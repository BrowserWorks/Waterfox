/* -*- js-indent-level: 2; indent-tabs-mode: nil -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

/**
 * This module records detailed timing information about selected
 * GCs. The data is sent back in the telemetry session ping. To avoid
 * bloating the ping, only a few GCs are included. There are two
 * selection strategies. We always save the five GCs with the worst
 * max_pause time. Additionally, five collections are selected at
 * random. If a GC runs for C milliseconds and the total time for all
 * GCs since the session began is T milliseconds, then the GC has a
 * 5*C/T probablility of being selected (the factor of 5 is because we
 * save 5 of them).
 *
 * GCs from both the main process and all content processes are
 * recorded. The data is cleared for each new subsession.
 */

const Cu = Components.utils;

Cu.import("resource://gre/modules/Services.jsm", this);

this.EXPORTED_SYMBOLS = ["GCTelemetry"];

// Names of processes where we record GCs.
const PROCESS_NAMES = ["main", "content"];

// Should be the time we started up in milliseconds since the epoch.
const BASE_TIME = Date.now() - Services.telemetry.msSinceProcessStart();

// Records selected GCs. There is one instance per process type.
class GCData {
  constructor(kind) {
    let numRandom = {main: 0, content: 2};
    let numWorst = {main: 2, content: 2};

    this.totalGCTime = 0;
    this.randomlySelected = Array(numRandom[kind]).fill(null);
    this.worst = Array(numWorst[kind]).fill(null);
  }

  // Turn absolute timestamps (in microseconds since the epoch) into
  // milliseconds since startup.
  rebaseTimes(data) {
    function fixup(t) {
      return t / 1000.0 - BASE_TIME;
    }

    data.timestamp = fixup(data.timestamp);

    for (let i = 0; i < data.slices.length; i++) {
      let slice = data.slices[i];
      slice.start_timestamp = fixup(slice.start_timestamp);
      slice.end_timestamp = fixup(slice.end_timestamp);
    }
  }

  // Records a GC (represented by |data|) in the randomlySelected or
  // worst batches depending on the criteria above.
  record(data) {
    this.rebaseTimes(data);

    let time = data.total_time;
    this.totalGCTime += time;

    // Probability that we will replace any one of our
    // current randomlySelected GCs with |data|.
    let prob = time / this.totalGCTime;

    // Note that we may replace multiple GCs in
    // randomlySelected. It's easier to reason about the
    // probabilities this way, and it's unlikely to have any effect in
    // practice.
    for (let i = 0; i < this.randomlySelected.length; i++) {
      let r = Math.random();
      if (r <= prob) {
        this.randomlySelected[i] = data;
      }
    }

    // Save the 5 worst GCs based on max_pause. A GC may appear in
    // both worst and randomlySelected.
    for (let i = 0; i < this.worst.length; i++) {
      if (!this.worst[i]) {
        this.worst[i] = data;
        break;
      }

      if (this.worst[i].max_pause < data.max_pause) {
        this.worst.splice(i, 0, data);
        this.worst.length--;
        break;
      }
    }
  }

  entries() {
    return {
      random: this.randomlySelected.filter(e => e !== null),
      worst: this.worst.filter(e => e !== null),
    };
  }
}

// If you adjust any of the constants here (slice limit, number of keys, etc.)
// make sure to update the JSON schema at:
// https://github.com/mozilla-services/mozilla-pipeline-schemas/blob/master/telemetry/main.schema.json
// You should also adjust browser_TelemetryGC.js.
const MAX_GC_KEYS = 25;
const MAX_SLICES = 4;
const MAX_SLICE_KEYS = 15;
const MAX_PHASES = 65;

function limitProperties(obj, count) {
  // If there are too many properties, just delete them all. We don't
  // expect this ever to happen.
  if (Object.keys(obj).length > count) {
    for (let key of Object.keys(obj)) {
      delete obj[key];
    }
  }
}

function limitSize(data) {
  // Store the number of slices so we know if we lost any at the end.
  data.num_slices = data.slices.length;

  data.slices.sort((a, b) => b.pause - a.pause);

  if (data.slices.length > MAX_SLICES) {
    // Make sure we always keep the first slice since it has the
    // reason the GC was started.
    let firstSliceIndex = data.slices.findIndex(s => s.slice == 0);
    if (firstSliceIndex >= MAX_SLICES) {
      data.slices[MAX_SLICES - 1] = data.slices[firstSliceIndex];
    }

    data.slices.length = MAX_SLICES;
  }

  data.slices.sort((a, b) => a.slice - b.slice);

  limitProperties(data, MAX_GC_KEYS);

  for (let slice of data.slices) {
    limitProperties(slice, MAX_SLICE_KEYS);
    limitProperties(slice.times, MAX_PHASES);
  }

  limitProperties(data.totals, MAX_PHASES);
}

let processData = new Map();
for (let name of PROCESS_NAMES) {
  processData.set(name, new GCData(name));
}

var GCTelemetry = {
  initialized: false,

  init() {
    if (this.initialized) {
      return false;
    }

    this.initialized = true;
    Services.obs.addObserver(this, "garbage-collection-statistics", false);

    if (Services.appinfo.processType == Services.appinfo.PROCESS_TYPE_DEFAULT) {
      Services.ppmm.addMessageListener("Telemetry:GCStatistics", this);
    }

    return true;
  },

  shutdown() {
    if (!this.initialized) {
      return;
    }

    Services.obs.removeObserver(this, "garbage-collection-statistics");

    if (Services.appinfo.processType == Services.appinfo.PROCESS_TYPE_DEFAULT) {
      Services.ppmm.removeMessageListener("Telemetry:GCStatistics", this);
    }
    this.initialized = false;
  },

  observe(subject, topic, arg) {
    let data = JSON.parse(arg);

    limitSize(data);

    if (Services.appinfo.processType == Services.appinfo.PROCESS_TYPE_DEFAULT) {
      processData.get("main").record(data);
    } else {
      Services.cpmm.sendAsyncMessage("Telemetry:GCStatistics", data);
    }
  },

  receiveMessage(msg) {
    processData.get("content").record(msg.data);
  },

  entries(kind, clear) {
    let result = processData.get(kind).entries();
    if (clear) {
      processData.set(kind, new GCData(kind));
    }
    return result;
  },
};
