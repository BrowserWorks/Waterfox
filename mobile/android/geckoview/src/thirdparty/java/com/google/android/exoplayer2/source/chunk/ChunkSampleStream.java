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
package com.google.android.exoplayer2.source.chunk;

import com.google.android.exoplayer2.C;
import com.google.android.exoplayer2.Format;
import com.google.android.exoplayer2.FormatHolder;
import com.google.android.exoplayer2.decoder.DecoderInputBuffer;
import com.google.android.exoplayer2.extractor.DefaultTrackOutput;
import com.google.android.exoplayer2.source.AdaptiveMediaSourceEventListener.EventDispatcher;
import com.google.android.exoplayer2.source.SampleStream;
import com.google.android.exoplayer2.source.SequenceableLoader;
import com.google.android.exoplayer2.upstream.Allocator;
import com.google.android.exoplayer2.upstream.Loader;
import com.google.android.exoplayer2.util.Assertions;
import java.io.IOException;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

/**
 * A {@link SampleStream} that loads media in {@link Chunk}s, obtained from a {@link ChunkSource}.
 * May also be configured to expose additional embedded {@link SampleStream}s.
 */
public class ChunkSampleStream<T extends ChunkSource> implements SampleStream, SequenceableLoader,
    Loader.Callback<Chunk> {

  private final int primaryTrackType;
  private final int[] embeddedTrackTypes;
  private final boolean[] embeddedTracksSelected;
  private final T chunkSource;
  private final SequenceableLoader.Callback<ChunkSampleStream<T>> callback;
  private final EventDispatcher eventDispatcher;
  private final int minLoadableRetryCount;
  private final Loader loader;
  private final ChunkHolder nextChunkHolder;
  private final LinkedList<BaseMediaChunk> mediaChunks;
  private final List<BaseMediaChunk> readOnlyMediaChunks;
  private final DefaultTrackOutput primarySampleQueue;
  private final DefaultTrackOutput[] embeddedSampleQueues;
  private final BaseMediaChunkOutput mediaChunkOutput;

  private Format primaryDownstreamTrackFormat;
  private long pendingResetPositionUs;
  /* package */ long lastSeekPositionUs;
  /* package */ boolean loadingFinished;

  /**
   * @param primaryTrackType The type of the primary track. One of the {@link C}
   *     {@code TRACK_TYPE_*} constants.
   * @param embeddedTrackTypes The types of any embedded tracks, or null.
   * @param chunkSource A {@link ChunkSource} from which chunks to load are obtained.
   * @param callback An {@link Callback} for the stream.
   * @param allocator An {@link Allocator} from which allocations can be obtained.
   * @param positionUs The position from which to start loading media.
   * @param minLoadableRetryCount The minimum number of times that the source should retry a load
   *     before propagating an error.
   * @param eventDispatcher A dispatcher to notify of events.
   */
  public ChunkSampleStream(int primaryTrackType, int[] embeddedTrackTypes, T chunkSource,
      Callback<ChunkSampleStream<T>> callback, Allocator allocator, long positionUs,
      int minLoadableRetryCount, EventDispatcher eventDispatcher) {
    this.primaryTrackType = primaryTrackType;
    this.embeddedTrackTypes = embeddedTrackTypes;
    this.chunkSource = chunkSource;
    this.callback = callback;
    this.eventDispatcher = eventDispatcher;
    this.minLoadableRetryCount = minLoadableRetryCount;
    loader = new Loader("Loader:ChunkSampleStream");
    nextChunkHolder = new ChunkHolder();
    mediaChunks = new LinkedList<>();
    readOnlyMediaChunks = Collections.unmodifiableList(mediaChunks);

    int embeddedTrackCount = embeddedTrackTypes == null ? 0 : embeddedTrackTypes.length;
    embeddedSampleQueues = new DefaultTrackOutput[embeddedTrackCount];
    embeddedTracksSelected = new boolean[embeddedTrackCount];
    int[] trackTypes = new int[1 + embeddedTrackCount];
    DefaultTrackOutput[] sampleQueues = new DefaultTrackOutput[1 + embeddedTrackCount];

    primarySampleQueue = new DefaultTrackOutput(allocator);
    trackTypes[0] = primaryTrackType;
    sampleQueues[0] = primarySampleQueue;

    for (int i = 0; i < embeddedTrackCount; i++) {
      DefaultTrackOutput trackOutput = new DefaultTrackOutput(allocator);
      embeddedSampleQueues[i] = trackOutput;
      sampleQueues[i + 1] = trackOutput;
      trackTypes[i + 1] = embeddedTrackTypes[i];
    }

    mediaChunkOutput = new BaseMediaChunkOutput(trackTypes, sampleQueues);
    pendingResetPositionUs = positionUs;
    lastSeekPositionUs = positionUs;
  }

  /**
   * Discards buffered media for embedded tracks that are not currently selected, up to the
   * specified position.
   *
   * @param positionUs The position to discard up to, in microseconds.
   */
  public void discardUnselectedEmbeddedTracksTo(long positionUs) {
    for (int i = 0; i < embeddedSampleQueues.length; i++) {
      if (!embeddedTracksSelected[i]) {
        embeddedSampleQueues[i].skipToKeyframeBefore(positionUs, true);
      }
    }
  }

  /**
   * Selects the embedded track, returning a new {@link EmbeddedSampleStream} from which the track's
   * samples can be consumed. {@link EmbeddedSampleStream#release()} must be called on the returned
   * stream when the track is no longer required, and before calling this method again to obtain
   * another stream for the same track.
   *
   * @param positionUs The current playback position in microseconds.
   * @param trackType The type of the embedded track to enable.
   * @return The {@link EmbeddedSampleStream} for the embedded track.
   */
  public EmbeddedSampleStream selectEmbeddedTrack(long positionUs, int trackType) {
    for (int i = 0; i < embeddedSampleQueues.length; i++) {
      if (embeddedTrackTypes[i] == trackType) {
        Assertions.checkState(!embeddedTracksSelected[i]);
        embeddedTracksSelected[i] = true;
        embeddedSampleQueues[i].skipToKeyframeBefore(positionUs, true);
        return new EmbeddedSampleStream(this, embeddedSampleQueues[i], i);
      }
    }
    // Should never happen.
    throw new IllegalStateException();
  }

  /**
   * Returns the {@link ChunkSource} used by this stream.
   */
  public T getChunkSource() {
    return chunkSource;
  }

  /**
   * Returns an estimate of the position up to which data is buffered.
   *
   * @return An estimate of the absolute position in microseconds up to which data is buffered, or
   *     {@link C#TIME_END_OF_SOURCE} if the track is fully buffered.
   */
  public long getBufferedPositionUs() {
    if (loadingFinished) {
      return C.TIME_END_OF_SOURCE;
    } else if (isPendingReset()) {
      return pendingResetPositionUs;
    } else {
      long bufferedPositionUs = lastSeekPositionUs;
      BaseMediaChunk lastMediaChunk = mediaChunks.getLast();
      BaseMediaChunk lastCompletedMediaChunk = lastMediaChunk.isLoadCompleted() ? lastMediaChunk
          : mediaChunks.size() > 1 ? mediaChunks.get(mediaChunks.size() - 2) : null;
      if (lastCompletedMediaChunk != null) {
        bufferedPositionUs = Math.max(bufferedPositionUs, lastCompletedMediaChunk.endTimeUs);
      }
      return Math.max(bufferedPositionUs, primarySampleQueue.getLargestQueuedTimestampUs());
    }
  }

  /**
   * Seeks to the specified position in microseconds.
   *
   * @param positionUs The seek position in microseconds.
   */
  public void seekToUs(long positionUs) {
    lastSeekPositionUs = positionUs;
    // If we're not pending a reset, see if we can seek within the primary sample queue.
    boolean seekInsideBuffer = !isPendingReset() && primarySampleQueue.skipToKeyframeBefore(
        positionUs, positionUs < getNextLoadPositionUs());
    if (seekInsideBuffer) {
      // We succeeded. We need to discard any chunks that we've moved past and perform the seek for
      // any embedded streams as well.
      while (mediaChunks.size() > 1
          && mediaChunks.get(1).getFirstSampleIndex(0) <= primarySampleQueue.getReadIndex()) {
        mediaChunks.removeFirst();
      }
      // TODO: For this to work correctly, the embedded streams must not discard anything from their
      // sample queues beyond the current read position of the primary stream.
      for (DefaultTrackOutput embeddedSampleQueue : embeddedSampleQueues) {
        embeddedSampleQueue.skipToKeyframeBefore(positionUs, true);
      }
    } else {
      // We failed, and need to restart.
      pendingResetPositionUs = positionUs;
      loadingFinished = false;
      mediaChunks.clear();
      if (loader.isLoading()) {
        loader.cancelLoading();
      } else {
        primarySampleQueue.reset(true);
        for (DefaultTrackOutput embeddedSampleQueue : embeddedSampleQueues) {
          embeddedSampleQueue.reset(true);
        }
      }
    }
  }

  /**
   * Releases the stream.
   * <p>
   * This method should be called when the stream is no longer required.
   */
  public void release() {
    primarySampleQueue.disable();
    for (DefaultTrackOutput embeddedSampleQueue : embeddedSampleQueues) {
      embeddedSampleQueue.disable();
    }
    loader.release();
  }

  // SampleStream implementation.

  @Override
  public boolean isReady() {
    return loadingFinished || (!isPendingReset() && !primarySampleQueue.isEmpty());
  }

  @Override
  public void maybeThrowError() throws IOException {
    loader.maybeThrowError();
    if (!loader.isLoading()) {
      chunkSource.maybeThrowError();
    }
  }

  @Override
  public int readData(FormatHolder formatHolder, DecoderInputBuffer buffer,
      boolean formatRequired) {
    if (isPendingReset()) {
      return C.RESULT_NOTHING_READ;
    }
    discardDownstreamMediaChunks(primarySampleQueue.getReadIndex());
    return primarySampleQueue.readData(formatHolder, buffer, formatRequired, loadingFinished,
        lastSeekPositionUs);
  }

  @Override
  public void skipData(long positionUs) {
    if (loadingFinished && positionUs > primarySampleQueue.getLargestQueuedTimestampUs()) {
      primarySampleQueue.skipAll();
    } else {
      primarySampleQueue.skipToKeyframeBefore(positionUs, true);
    }
  }

  // Loader.Callback implementation.

  @Override
  public void onLoadCompleted(Chunk loadable, long elapsedRealtimeMs, long loadDurationMs) {
    chunkSource.onChunkLoadCompleted(loadable);
    eventDispatcher.loadCompleted(loadable.dataSpec, loadable.type, primaryTrackType,
        loadable.trackFormat, loadable.trackSelectionReason, loadable.trackSelectionData,
        loadable.startTimeUs, loadable.endTimeUs, elapsedRealtimeMs, loadDurationMs,
        loadable.bytesLoaded());
    callback.onContinueLoadingRequested(this);
  }

  @Override
  public void onLoadCanceled(Chunk loadable, long elapsedRealtimeMs, long loadDurationMs,
      boolean released) {
    eventDispatcher.loadCanceled(loadable.dataSpec, loadable.type, primaryTrackType,
        loadable.trackFormat, loadable.trackSelectionReason, loadable.trackSelectionData,
        loadable.startTimeUs, loadable.endTimeUs, elapsedRealtimeMs, loadDurationMs,
        loadable.bytesLoaded());
    if (!released) {
      primarySampleQueue.reset(true);
      for (DefaultTrackOutput embeddedSampleQueue : embeddedSampleQueues) {
        embeddedSampleQueue.reset(true);
      }
      callback.onContinueLoadingRequested(this);
    }
  }

  @Override
  public int onLoadError(Chunk loadable, long elapsedRealtimeMs, long loadDurationMs,
      IOException error) {
    long bytesLoaded = loadable.bytesLoaded();
    boolean isMediaChunk = isMediaChunk(loadable);
    boolean cancelable = !isMediaChunk || bytesLoaded == 0 || mediaChunks.size() > 1;
    boolean canceled = false;
    if (chunkSource.onChunkLoadError(loadable, cancelable, error)) {
      canceled = true;
      if (isMediaChunk) {
        BaseMediaChunk removed = mediaChunks.removeLast();
        Assertions.checkState(removed == loadable);
        primarySampleQueue.discardUpstreamSamples(removed.getFirstSampleIndex(0));
        for (int i = 0; i < embeddedSampleQueues.length; i++) {
          embeddedSampleQueues[i].discardUpstreamSamples(removed.getFirstSampleIndex(i + 1));
        }
        if (mediaChunks.isEmpty()) {
          pendingResetPositionUs = lastSeekPositionUs;
        }
      }
    }
    eventDispatcher.loadError(loadable.dataSpec, loadable.type, primaryTrackType,
        loadable.trackFormat, loadable.trackSelectionReason, loadable.trackSelectionData,
        loadable.startTimeUs, loadable.endTimeUs, elapsedRealtimeMs, loadDurationMs, bytesLoaded,
        error, canceled);
    if (canceled) {
      callback.onContinueLoadingRequested(this);
      return Loader.DONT_RETRY;
    } else {
      return Loader.RETRY;
    }
  }

  // SequenceableLoader implementation

  @Override
  public boolean continueLoading(long positionUs) {
    if (loadingFinished || loader.isLoading()) {
      return false;
    }

    chunkSource.getNextChunk(mediaChunks.isEmpty() ? null : mediaChunks.getLast(),
        pendingResetPositionUs != C.TIME_UNSET ? pendingResetPositionUs : positionUs,
        nextChunkHolder);
    boolean endOfStream = nextChunkHolder.endOfStream;
    Chunk loadable = nextChunkHolder.chunk;
    nextChunkHolder.clear();

    if (endOfStream) {
      loadingFinished = true;
      return true;
    }

    if (loadable == null) {
      return false;
    }

    if (isMediaChunk(loadable)) {
      pendingResetPositionUs = C.TIME_UNSET;
      BaseMediaChunk mediaChunk = (BaseMediaChunk) loadable;
      mediaChunk.init(mediaChunkOutput);
      mediaChunks.add(mediaChunk);
    }
    long elapsedRealtimeMs = loader.startLoading(loadable, this, minLoadableRetryCount);
    eventDispatcher.loadStarted(loadable.dataSpec, loadable.type, primaryTrackType,
        loadable.trackFormat, loadable.trackSelectionReason, loadable.trackSelectionData,
        loadable.startTimeUs, loadable.endTimeUs, elapsedRealtimeMs);
    return true;
  }

  @Override
  public long getNextLoadPositionUs() {
    if (isPendingReset()) {
      return pendingResetPositionUs;
    } else {
      return loadingFinished ? C.TIME_END_OF_SOURCE : mediaChunks.getLast().endTimeUs;
    }
  }

  // Internal methods

  // TODO[REFACTOR]: Call maybeDiscardUpstream for DASH and SmoothStreaming.
  /**
   * Discards media chunks from the back of the buffer if conditions have changed such that it's
   * preferable to re-buffer the media at a different quality.
   *
   * @param positionUs The current playback position in microseconds.
   */
  private void maybeDiscardUpstream(long positionUs) {
    int queueSize = chunkSource.getPreferredQueueSize(positionUs, readOnlyMediaChunks);
    discardUpstreamMediaChunks(Math.max(1, queueSize));
  }

  private boolean isMediaChunk(Chunk chunk) {
    return chunk instanceof BaseMediaChunk;
  }

  /* package */ boolean isPendingReset() {
    return pendingResetPositionUs != C.TIME_UNSET;
  }

  private void discardDownstreamMediaChunks(int primaryStreamReadIndex) {
    while (mediaChunks.size() > 1
        && mediaChunks.get(1).getFirstSampleIndex(0) <= primaryStreamReadIndex) {
      mediaChunks.removeFirst();
    }
    BaseMediaChunk currentChunk = mediaChunks.getFirst();
    Format trackFormat = currentChunk.trackFormat;
    if (!trackFormat.equals(primaryDownstreamTrackFormat)) {
      eventDispatcher.downstreamFormatChanged(primaryTrackType, trackFormat,
          currentChunk.trackSelectionReason, currentChunk.trackSelectionData,
          currentChunk.startTimeUs);
    }
    primaryDownstreamTrackFormat = trackFormat;
  }

  /**
   * Discard upstream media chunks until the queue length is equal to the length specified.
   *
   * @param queueLength The desired length of the queue.
   * @return Whether chunks were discarded.
   */
  private boolean discardUpstreamMediaChunks(int queueLength) {
    if (mediaChunks.size() <= queueLength) {
      return false;
    }
    long startTimeUs = 0;
    long endTimeUs = mediaChunks.getLast().endTimeUs;
    BaseMediaChunk removed = null;
    while (mediaChunks.size() > queueLength) {
      removed = mediaChunks.removeLast();
      startTimeUs = removed.startTimeUs;
      loadingFinished = false;
    }
    primarySampleQueue.discardUpstreamSamples(removed.getFirstSampleIndex(0));
    for (int i = 0; i < embeddedSampleQueues.length; i++) {
      embeddedSampleQueues[i].discardUpstreamSamples(removed.getFirstSampleIndex(i + 1));
    }
    eventDispatcher.upstreamDiscarded(primaryTrackType, startTimeUs, endTimeUs);
    return true;
  }

  /**
   * A {@link SampleStream} embedded in a {@link ChunkSampleStream}.
   */
  public final class EmbeddedSampleStream implements SampleStream {

    public final ChunkSampleStream<T> parent;

    private final DefaultTrackOutput sampleQueue;
    private final int index;

    public EmbeddedSampleStream(ChunkSampleStream<T> parent, DefaultTrackOutput sampleQueue,
        int index) {
      this.parent = parent;
      this.sampleQueue = sampleQueue;
      this.index = index;
    }

    @Override
    public boolean isReady() {
      return loadingFinished || (!isPendingReset() && !sampleQueue.isEmpty());
    }

    @Override
    public void skipData(long positionUs) {
      if (loadingFinished && positionUs > sampleQueue.getLargestQueuedTimestampUs()) {
        sampleQueue.skipAll();
      } else {
        sampleQueue.skipToKeyframeBefore(positionUs, true);
      }
    }

    @Override
    public void maybeThrowError() throws IOException {
      // Do nothing. Errors will be thrown from the primary stream.
    }

    @Override
    public int readData(FormatHolder formatHolder, DecoderInputBuffer buffer,
        boolean formatRequired) {
      if (isPendingReset()) {
        return C.RESULT_NOTHING_READ;
      }
      return sampleQueue.readData(formatHolder, buffer, formatRequired, loadingFinished,
          lastSeekPositionUs);
    }

    public void release() {
      Assertions.checkState(embeddedTracksSelected[index]);
      embeddedTracksSelected[index] = false;
    }

  }

}
