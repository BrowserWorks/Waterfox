/*
 *  Copyright (c) 2016 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef WEBRTC_MODULES_AUDIO_CODING_AUDIO_NETWORK_ADAPTOR_DTX_CONTROLLER_H_
#define WEBRTC_MODULES_AUDIO_CODING_AUDIO_NETWORK_ADAPTOR_DTX_CONTROLLER_H_

#include "webrtc/base/constructormagic.h"
#include "webrtc/modules/audio_coding/audio_network_adaptor/controller.h"

namespace webrtc {

class DtxController final : public Controller {
 public:
  struct Config {
    Config(bool initial_dtx_enabled,
           int dtx_enabling_bandwidth_bps,
           int dtx_disabling_bandwidth_bps);
    bool initial_dtx_enabled;
    // Uplink bandwidth below which DTX should be switched on.
    int dtx_enabling_bandwidth_bps;
    // Uplink bandwidth above which DTX should be switched off.
    int dtx_disabling_bandwidth_bps;
  };

  explicit DtxController(const Config& config);

  void MakeDecision(const NetworkMetrics& metrics,
                    AudioNetworkAdaptor::EncoderRuntimeConfig* config) override;

 private:
  const Config config_;
  bool dtx_enabled_;
  RTC_DISALLOW_COPY_AND_ASSIGN(DtxController);
};

}  // namespace webrtc

#endif  // WEBRTC_MODULES_AUDIO_CODING_AUDIO_NETWORK_ADAPTOR_DTX_CONTROLLER_H_
