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
import com.google.android.exoplayer2.trackselection.TrackSelection;
import com.google.android.exoplayer2.util.Assertions;
import java.io.IOException;
import java.util.ArrayList;
import java.util.IdentityHashMap;

/**
 * Merges multiple {@link MediaPeriod}s.
 */
/* package */ final class MergingMediaPeriod implements MediaPeriod, MediaPeriod.Callback {

  public final MediaPeriod[] periods;

  private final IdentityHashMap<SampleStream, Integer> streamPeriodIndices;

  private Callback callback;
  private int pendingChildPrepareCount;
  private TrackGroupArray trackGroups;

  private MediaPeriod[] enabledPeriods;
  private SequenceableLoader sequenceableLoader;

  public MergingMediaPeriod(MediaPeriod... periods) {
    this.periods = periods;
    streamPeriodIndices = new IdentityHashMap<>();
  }

  @Override
  public void prepare(Callback callback) {
    this.callback = callback;
    pendingChildPrepareCount = periods.length;
    for (MediaPeriod period : periods) {
      period.prepare(this);
    }
  }

  @Override
  public void maybeThrowPrepareError() throws IOException {
    for (MediaPeriod period : periods) {
      period.maybeThrowPrepareError();
    }
  }

  @Override
  public TrackGroupArray getTrackGroups() {
    return trackGroups;
  }

  @Override
  public long selectTracks(TrackSelection[] selections, boolean[] mayRetainStreamFlags,
      SampleStream[] streams, boolean[] streamResetFlags, long positionUs) {
    // Map each selection and stream onto a child period index.
    int[] streamChildIndices = new int[selections.length];
    int[] selectionChildIndices = new int[selections.length];
    for (int i = 0; i < selections.length; i++) {
      streamChildIndices[i] = streams[i] == null ? C.INDEX_UNSET
          : streamPeriodIndices.get(streams[i]);
      selectionChildIndices[i] = C.INDEX_UNSET;
      if (selections[i] != null) {
        TrackGroup trackGroup = selections[i].getTrackGroup();
        for (int j = 0; j < periods.length; j++) {
          if (periods[j].getTrackGroups().indexOf(trackGroup) != C.INDEX_UNSET) {
            selectionChildIndices[i] = j;
            break;
          }
        }
      }
    }
    streamPeriodIndices.clear();
    // Select tracks for each child, copying the resulting streams back into a new streams array.
    SampleStream[] newStreams = new SampleStream[selections.length];
    SampleStream[] childStreams = new SampleStream[selections.length];
    TrackSelection[] childSelections = new TrackSelection[selections.length];
    ArrayList<MediaPeriod> enabledPeriodsList = new ArrayList<>(periods.length);
    for (int i = 0; i < periods.length; i++) {
      for (int j = 0; j < selections.length; j++) {
        childStreams[j] = streamChildIndices[j] == i ? streams[j] : null;
        childSelections[j] = selectionChildIndices[j] == i ? selections[j] : null;
      }
      long selectPositionUs = periods[i].selectTracks(childSelections, mayRetainStreamFlags,
          childStreams, streamResetFlags, positionUs);
      if (i == 0) {
        positionUs = selectPositionUs;
      } else if (selectPositionUs != positionUs) {
        throw new IllegalStateException("Children enabled at different positions");
      }
      boolean periodEnabled = false;
      for (int j = 0; j < selections.length; j++) {
        if (selectionChildIndices[j] == i) {
          // Assert that the child provided a stream for the selection.
          Assertions.checkState(childStreams[j] != null);
          newStreams[j] = childStreams[j];
          periodEnabled = true;
          streamPeriodIndices.put(childStreams[j], i);
        } else if (streamChildIndices[j] == i) {
          // Assert that the child cleared any previous stream.
          Assertions.checkState(childStreams[j] == null);
        }
      }
      if (periodEnabled) {
        enabledPeriodsList.add(periods[i]);
      }
    }
    // Copy the new streams back into the streams array.
    System.arraycopy(newStreams, 0, streams, 0, newStreams.length);
    // Update the local state.
    enabledPeriods = new MediaPeriod[enabledPeriodsList.size()];
    enabledPeriodsList.toArray(enabledPeriods);
    sequenceableLoader = new CompositeSequenceableLoader(enabledPeriods);
    return positionUs;
  }

  @Override
  public void discardBuffer(long positionUs) {
    for (MediaPeriod period : enabledPeriods) {
      period.discardBuffer(positionUs);
    }
  }

  @Override
  public boolean continueLoading(long positionUs) {
    return sequenceableLoader.continueLoading(positionUs);
  }

  @Override
  public long getNextLoadPositionUs() {
    return sequenceableLoader.getNextLoadPositionUs();
  }

  @Override
  public long readDiscontinuity() {
    long positionUs = periods[0].readDiscontinuity();
    // Periods other than the first one are not allowed to report discontinuities.
    for (int i = 1; i < periods.length; i++) {
      if (periods[i].readDiscontinuity() != C.TIME_UNSET) {
        throw new IllegalStateException("Child reported discontinuity");
      }
    }
    // It must be possible to seek enabled periods to the new position, if there is one.
    if (positionUs != C.TIME_UNSET) {
      for (MediaPeriod enabledPeriod : enabledPeriods) {
        if (enabledPeriod != periods[0]
            && enabledPeriod.seekToUs(positionUs) != positionUs) {
          throw new IllegalStateException("Children seeked to different positions");
        }
      }
    }
    return positionUs;
  }

  @Override
  public long getBufferedPositionUs() {
    long bufferedPositionUs = Long.MAX_VALUE;
    for (MediaPeriod period : enabledPeriods) {
      long rendererBufferedPositionUs = period.getBufferedPositionUs();
      if (rendererBufferedPositionUs != C.TIME_END_OF_SOURCE) {
        bufferedPositionUs = Math.min(bufferedPositionUs, rendererBufferedPositionUs);
      }
    }
    return bufferedPositionUs == Long.MAX_VALUE ? C.TIME_END_OF_SOURCE : bufferedPositionUs;
  }

  @Override
  public long seekToUs(long positionUs) {
    positionUs = enabledPeriods[0].seekToUs(positionUs);
    // Additional periods must seek to the same position.
    for (int i = 1; i < enabledPeriods.length; i++) {
      if (enabledPeriods[i].seekToUs(positionUs) != positionUs) {
        throw new IllegalStateException("Children seeked to different positions");
      }
    }
    return positionUs;
  }

  // MediaPeriod.Callback implementation

  @Override
  public void onPrepared(MediaPeriod ignored) {
    if (--pendingChildPrepareCount > 0) {
      return;
    }
    int totalTrackGroupCount = 0;
    for (MediaPeriod period : periods) {
      totalTrackGroupCount += period.getTrackGroups().length;
    }
    TrackGroup[] trackGroupArray = new TrackGroup[totalTrackGroupCount];
    int trackGroupIndex = 0;
    for (MediaPeriod period : periods) {
      TrackGroupArray periodTrackGroups = period.getTrackGroups();
      int periodTrackGroupCount = periodTrackGroups.length;
      for (int j = 0; j < periodTrackGroupCount; j++) {
        trackGroupArray[trackGroupIndex++] = periodTrackGroups.get(j);
      }
    }
    trackGroups = new TrackGroupArray(trackGroupArray);
    callback.onPrepared(this);
  }

  @Override
  public void onContinueLoadingRequested(MediaPeriod ignored) {
    if (trackGroups == null) {
      // Still preparing.
      return;
    }
    callback.onContinueLoadingRequested(this);
  }

}
