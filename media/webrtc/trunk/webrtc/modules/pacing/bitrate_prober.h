/*
 *  Copyright (c) 2014 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef WEBRTC_MODULES_PACING_BITRATE_PROBER_H_
#define WEBRTC_MODULES_PACING_BITRATE_PROBER_H_

#include <queue>

#include "webrtc/base/basictypes.h"
#include "webrtc/typedefs.h"

namespace webrtc {

// Note that this class isn't thread-safe by itself and therefore relies
// on being protected by the caller.
class BitrateProber {
 public:
  BitrateProber();

  void SetEnabled(bool enable);

  // Returns true if the prober is in a probing session, i.e., it currently
  // wants packets to be sent out according to the time returned by
  // TimeUntilNextProbe().
  bool IsProbing() const;

  // Initializes a new probing session if the prober is allowed to probe. Does
  // not initialize the prober unless the packet size is large enough to probe
  // with.
  void OnIncomingPacket(size_t packet_size);

  // Create a cluster used to probe for |bitrate_bps| with |num_probes| number
  // of probes.
  void CreateProbeCluster(int bitrate_bps);

  // Returns the number of milliseconds until the next probe should be sent to
  // get accurate probing.
  int TimeUntilNextProbe(int64_t now_ms);

  // Which cluster that is currently being used for probing.
  int CurrentClusterId() const;

  // Returns the minimum number of bytes that the prober recommends for
  // the next probe.
  size_t RecommendedMinProbeSize() const;

  // Called to report to the prober that a probe has been sent. In case of
  // multiple packets per probe, this call would be made at the end of sending
  // the last packet in probe. |probe_size| is the total size of all packets
  // in probe.
  void ProbeSent(int64_t now_ms, size_t probe_size);

 private:
  enum class ProbingState {
    // Probing will not be triggered in this state at all times.
    kDisabled,
    // Probing is enabled and ready to trigger on the first packet arrival.
    kInactive,
    // Probe cluster is filled with the set of data rates to be probed and
    // probes are being sent.
    kActive,
    // Probing is enabled, but currently suspended until an explicit trigger
    // to start probing again.
    kSuspended,
  };

  // A probe cluster consists of a set of probes. Each probe in turn can be
  // divided into a number of packets to accomodate the MTU on the network.
  struct ProbeCluster {
    int min_probes = 0;
    int sent_probes = 0;
    int min_bytes = 0;
    int sent_bytes = 0;
    int bitrate_bps = 0;
    int id = -1;
  };

  // Resets the state of the prober and clears any cluster/timing data tracked.
  void ResetState();

  ProbingState probing_state_;
  // Probe bitrate per packet. These are used to compute the delta relative to
  // the previous probe packet based on the size and time when that packet was
  // sent.
  std::queue<ProbeCluster> clusters_;
  // A probe can include one or more packets.
  size_t probe_size_last_sent_;
  // The last time a probe was sent.
  int64_t time_last_probe_sent_ms_;
  int next_cluster_id_;
};
}  // namespace webrtc
#endif  // WEBRTC_MODULES_PACING_BITRATE_PROBER_H_
