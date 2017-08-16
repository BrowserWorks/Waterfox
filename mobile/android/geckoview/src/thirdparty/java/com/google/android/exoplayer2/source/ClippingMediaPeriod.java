/*
 * Copyright (C) 2016 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.google.android.exoplayer2.source;

import com.google.android.exoplayer2.C;
import com.google.android.exoplayer2.FormatHolder;
import com.google.android.exoplayer2.decoder.DecoderInputBuffer;
import com.google.android.exoplayer2.trackselection.TrackSelection;
import com.google.android.exoplayer2.util.Assertions;
import java.io.IOException;

/**
 * Wraps a {@link MediaPeriod} and clips its {@link SampleStream}s to provide a subsequence of their
 * samples.
 */
public final class ClippingMediaPeriod implements MediaPeriod, MediaPeriod.Callback {

  /**
   * The {@link MediaPeriod} wrapped by this clipping media period.
   */
  public final MediaPeriod mediaPeriod;

  private MediaPeriod.Callback callback;
  private long startUs;
  private long endUs;
  private ClippingSampleStream[] sampleStreams;
  private boolean pendingInitialDiscontinuity;

  /**
   * Creates a new clipping media period that provides a clipped view of the specified
   * {@link MediaPeriod}'s sample streams.
   * <p>
   * The clipping start/end positions must be specified by calling {@link #setClipping(long, long)}
   * on the playback thread before preparation completes.
   *
   * @param mediaPeriod The media period to clip.
   */
  public ClippingMediaPeriod(MediaPeriod mediaPeriod) {
    this.mediaPeriod = mediaPeriod;
    startUs = C.TIME_UNSET;
    endUs = C.TIME_UNSET;
    sampleStreams = new ClippingSampleStream[0];
  }

  /**
   * Sets the clipping start/end times for this period, in microseconds.
   *
   * @param startUs The clipping start time, in microseconds.
   * @param endUs The clipping end time, in microseconds, or {@link C#TIME_END_OF_SOURCE} to
   *     indicate the end of the period.
   */
  public void setClipping(long startUs, long endUs) {
    this.startUs = startUs;
    this.endUs = endUs;
  }

  @Override
  public void prepare(MediaPeriod.Callback callback) {
    this.callback = callback;
    mediaPeriod.prepare(this);
  }

  @Override
  public void maybeThrowPrepareError() throws IOException {
    mediaPeriod.maybeThrowPrepareError();
  }

  @Override
  public TrackGroupArray getTrackGroups() {
    return mediaPeriod.getTrackGroups();
  }

  @Override
  public long selectTracks(TrackSelection[] selections, boolean[] mayRetainStreamFlags,
      SampleStream[] streams, boolean[] streamResetFlags, long positionUs) {
    sampleStreams = new ClippingSampleStream[streams.length];
    SampleStream[] internalStreams = new SampleStream[streams.length];
    for (int i = 0; i < streams.length; i++) {
      sampleStreams[i] = (ClippingSampleStream) streams[i];
      internalStreams[i] = sampleStreams[i] != null ? sampleStreams[i].stream : null;
    }
    long enablePositionUs = mediaPeriod.selectTracks(selections, mayRetainStreamFlags,
        internalStreams, streamResetFlags, positionUs + startUs);
    Assertions.checkState(enablePositionUs == positionUs + startUs
        || (enablePositionUs >= startUs
        && (endUs == C.TIME_END_OF_SOURCE || enablePositionUs <= endUs)));
    for (int i = 0; i < streams.length; i++) {
      if (internalStreams[i] == null) {
        sampleStreams[i] = null;
      } else if (streams[i] == null || sampleStreams[i].stream != internalStreams[i]) {
        sampleStreams[i] = new ClippingSampleStream(this, internalStreams[i], startUs, endUs,
            pendingInitialDiscontinuity);
      }
      streams[i] = sampleStreams[i];
    }
    return enablePositionUs - startUs;
  }

  @Override
  public void discardBuffer(long positionUs) {
    mediaPeriod.discardBuffer(positionUs + startUs);
  }

  @Override
  public long readDiscontinuity() {
    if (pendingInitialDiscontinuity) {
      for (ClippingSampleStream sampleStream : sampleStreams) {
        if (sampleStream != null) {
          sampleStream.clearPendingDiscontinuity();
        }
      }
      pendingInitialDiscontinuity = false;
      // Always read an initial discontinuity, using mediaPeriod's discontinuity if set.
      long discontinuityUs = readDiscontinuity();
      return discontinuityUs != C.TIME_UNSET ? discontinuityUs : 0;
    }
    long discontinuityUs = mediaPeriod.readDiscontinuity();
    if (discontinuityUs == C.TIME_UNSET) {
      return C.TIME_UNSET;
    }
    Assertions.checkState(discontinuityUs >= startUs);
    Assertions.checkState(endUs == C.TIME_END_OF_SOURCE || discontinuityUs <= endUs);
    return discontinuityUs - startUs;
  }

  @Override
  public long getBufferedPositionUs() {
    long bufferedPositionUs = mediaPeriod.getBufferedPositionUs();
    if (bufferedPositionUs == C.TIME_END_OF_SOURCE
        || (endUs != C.TIME_END_OF_SOURCE && bufferedPositionUs >= endUs)) {
      return C.TIME_END_OF_SOURCE;
    }
    return Math.max(0, bufferedPositionUs - startUs);
  }

  @Override
  public long seekToUs(long positionUs) {
    for (ClippingSampleStream sampleStream : sampleStreams) {
      if (sampleStream != null) {
        sampleStream.clearSentEos();
      }
    }
    long seekUs = mediaPeriod.seekToUs(positionUs + startUs);
    Assertions.checkState(seekUs == positionUs + startUs
        || (seekUs >= startUs && (endUs == C.TIME_END_OF_SOURCE || seekUs <= endUs)));
    return seekUs - startUs;
  }

  @Override
  public long getNextLoadPositionUs() {
    long nextLoadPositionUs = mediaPeriod.getNextLoadPositionUs();
    if (nextLoadPositionUs == C.TIME_END_OF_SOURCE
        || (endUs != C.TIME_END_OF_SOURCE && nextLoadPositionUs >= endUs)) {
      return C.TIME_END_OF_SOURCE;
    }
    return nextLoadPositionUs - startUs;
  }

  @Override
  public boolean continueLoading(long positionUs) {
    return mediaPeriod.continueLoading(positionUs + startUs);
  }

  // MediaPeriod.Callback implementation.

  @Override
  public void onPrepared(MediaPeriod mediaPeriod) {
    Assertions.checkState(startUs != C.TIME_UNSET && endUs != C.TIME_UNSET);
    // If the clipping start position is non-zero, the clipping sample streams will adjust
    // timestamps on buffers they read from the unclipped sample streams. These adjusted buffer
    // timestamps can be negative, because sample streams provide buffers starting at a key-frame,
    // which may be before the clipping start point. When the renderer reads a buffer with a
    // negative timestamp, its offset timestamp can jump backwards compared to the last timestamp
    // read in the previous period. Renderer implementations may not allow this, so we signal a
    // discontinuity which resets the renderers before they read the clipping sample stream.
    pendingInitialDiscontinuity = startUs != 0;
    callback.onPrepared(this);
  }

  @Override
  public void onContinueLoadingRequested(MediaPeriod source) {
    callback.onContinueLoadingRequested(this);
  }

  /**
   * Wraps a {@link SampleStream} and clips its samples.
   */
  private static final class ClippingSampleStream implements SampleStream {

    private final MediaPeriod mediaPeriod;
    private final SampleStream stream;
    private final long startUs;
    private final long endUs;

    private boolean pendingDiscontinuity;
    private boolean sentEos;

    public ClippingSampleStream(MediaPeriod mediaPeriod, SampleStream stream, long startUs,
        long endUs, boolean pendingDiscontinuity) {
      this.mediaPeriod = mediaPeriod;
      this.stream = stream;
      this.startUs = startUs;
      this.endUs = endUs;
      this.pendingDiscontinuity = pendingDiscontinuity;
    }

    public void clearPendingDiscontinuity() {
      pendingDiscontinuity = false;
    }

    public void clearSentEos() {
      sentEos = false;
    }

    @Override
    public boolean isReady() {
      return stream.isReady();
    }

    @Override
    public void maybeThrowError() throws IOException {
      stream.maybeThrowError();
    }

    @Override
    public int readData(FormatHolder formatHolder, DecoderInputBuffer buffer,
        boolean requireFormat) {
      if (pendingDiscontinuity) {
        return C.RESULT_NOTHING_READ;
      }
      if (sentEos) {
        buffer.setFlags(C.BUFFER_FLAG_END_OF_STREAM);
        return C.RESULT_BUFFER_READ;
      }
      int result = stream.readData(formatHolder, buffer, requireFormat);
      // TODO: Clear gapless playback metadata if a format was read (if applicable).
      if (endUs != C.TIME_END_OF_SOURCE && ((result == C.RESULT_BUFFER_READ
          && buffer.timeUs >= endUs) || (result == C.RESULT_NOTHING_READ
          && mediaPeriod.getBufferedPositionUs() == C.TIME_END_OF_SOURCE))) {
        buffer.clear();
        buffer.setFlags(C.BUFFER_FLAG_END_OF_STREAM);
        sentEos = true;
        return C.RESULT_BUFFER_READ;
      }
      if (result == C.RESULT_BUFFER_READ && !buffer.isEndOfStream()) {
        buffer.timeUs -= startUs;
      }
      return result;
    }

    @Override
    public void skipData(long positionUs) {
      stream.skipData(startUs + positionUs);
    }

  }

}
