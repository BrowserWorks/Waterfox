/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
"use strict";

const { Front, FrontClassWithSpec } = require("devtools/shared/protocol");
const { performanceRecordingSpec } = require("devtools/shared/specs/performance-recording");

loader.lazyRequireGetter(this, "PerformanceIO",
  "devtools/client/performance/modules/io");
loader.lazyRequireGetter(this, "PerformanceRecordingCommon",
  "devtools/shared/performance/recording-common", true);
loader.lazyRequireGetter(this, "RecordingUtils",
  "devtools/shared/performance/recording-utils");

/**
 * This can be used on older Profiler implementations, but the methods cannot
 * be changed -- you must introduce a new method, and detect the server.
 */
const PerformanceRecordingFront = FrontClassWithSpec(performanceRecordingSpec,
Object.assign({
  form: function (form, detail) {
    if (detail === "actorid") {
      this.actorID = form;
      return;
    }
    this.actorID = form.actor;
    this._form = form;
    this._configuration = form.configuration;
    this._startingBufferStatus = form.startingBufferStatus;
    this._console = form.console;
    this._label = form.label;
    this._startTime = form.startTime;
    this._localStartTime = form.localStartTime;
    this._recording = form.recording;
    this._completed = form.completed;
    this._duration = form.duration;

    if (form.finalizedData) {
      this._profile = form.profile;
      this._systemHost = form.systemHost;
      this._systemClient = form.systemClient;
    }

    // Sort again on the client side if we're using realtime markers and the recording
    // just finished. This is because GC/Compositing markers can come into the array out
    // of order with the other markers, leading to strange collapsing in waterfall view.
    if (this._completed && !this._markersSorted) {
      this._markers = this._markers.sort((a, b) => (a.start > b.start));
      this._markersSorted = true;
    }
  },

  initialize: function (client, form, config) {
    Front.prototype.initialize.call(this, client, form);
    this._markers = [];
    this._frames = [];
    this._memory = [];
    this._ticks = [];
    this._allocations = { sites: [], timestamps: [], frames: [], sizes: [] };
  },

  destroy: function () {
    Front.prototype.destroy.call(this);
  },

  /**
   * Saves the current recording to a file.
   *
   * @param nsILocalFile file
   *        The file to stream the data into.
   */
  exportRecording: function (file) {
    let recordingData = this.getAllData();
    return PerformanceIO.saveRecordingToFile(recordingData, file);
  },

  /**
   * Fired whenever the PerformanceFront emits markers, memory or ticks.
   */
  _addTimelineData: function (eventName, data) {
    let config = this.getConfiguration();

    switch (eventName) {
      // Accumulate timeline markers into an array. Furthermore, the timestamps
      // do not have a zero epoch, so offset all of them by the start time.
      case "markers": {
        if (!config.withMarkers) {
          break;
        }
        let { markers } = data;
        RecordingUtils.offsetMarkerTimes(markers, this._startTime);
        RecordingUtils.pushAll(this._markers, markers);
        break;
      }
      // Accumulate stack frames into an array.
      case "frames": {
        if (!config.withMarkers) {
          break;
        }
        let { frames } = data;
        RecordingUtils.pushAll(this._frames, frames);
        break;
      }
      // Accumulate memory measurements into an array. Furthermore, the timestamp
      // does not have a zero epoch, so offset it by the actor's start time.
      case "memory": {
        if (!config.withMemory) {
          break;
        }
        let { delta, measurement } = data;
        this._memory.push({
          delta: delta - this._startTime,
          value: measurement.total / 1024 / 1024
        });
        break;
      }
      // Save the accumulated refresh driver ticks.
      case "ticks": {
        if (!config.withTicks) {
          break;
        }
        let { timestamps } = data;
        this._ticks = timestamps;
        break;
      }
      // Accumulate allocation sites into an array.
      case "allocations": {
        if (!config.withAllocations) {
          break;
        }
        let {
          allocations: sites,
          allocationsTimestamps: timestamps,
          allocationSizes: sizes,
          frames,
        } = data;

        RecordingUtils.offsetAndScaleTimestamps(timestamps, this._startTime);
        RecordingUtils.pushAll(this._allocations.sites, sites);
        RecordingUtils.pushAll(this._allocations.timestamps, timestamps);
        RecordingUtils.pushAll(this._allocations.frames, frames);
        RecordingUtils.pushAll(this._allocations.sizes, sizes);
        break;
      }
    }
  },

  toString: () => "[object PerformanceRecordingFront]"
}, PerformanceRecordingCommon));

exports.PerformanceRecordingFront = PerformanceRecordingFront;
