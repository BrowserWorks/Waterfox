/*
 *  Copyright 2015 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "RTCPeerConnection+Private.h"

#import "NSString+StdString.h"
#import "RTCMediaStreamTrack+Private.h"
#import "RTCLegacyStatsReport+Private.h"

#include "webrtc/base/checks.h"

namespace webrtc {

class StatsObserverAdapter : public StatsObserver {
 public:
  StatsObserverAdapter(void (^completionHandler)
      (NSArray<RTCLegacyStatsReport *> *stats)) {
    completion_handler_ = completionHandler;
  }

  ~StatsObserverAdapter() {
    completion_handler_ = nil;
  }

  void OnCompleteReports(std::unique_ptr<StatsReports> reports) override {
    RTC_DCHECK(completion_handler_);
    NSMutableArray *stats = [NSMutableArray arrayWithCapacity:reports->size()];
    for (const auto* report : *reports) {
      RTCLegacyStatsReport *statsReport =
          [[RTCLegacyStatsReport alloc] initWithNativeReport:*report];
      [stats addObject:statsReport];
    }
    completion_handler_(stats);
    completion_handler_ = nil;
  }

 private:
  void (^completion_handler_)(NSArray<RTCLegacyStatsReport *> *stats);
};
}  // namespace webrtc

@implementation RTCPeerConnection (Stats)

- (void)statsForTrack:(RTCMediaStreamTrack *)mediaStreamTrack
     statsOutputLevel:(RTCStatsOutputLevel)statsOutputLevel
    completionHandler:
    (void (^)(NSArray<RTCLegacyStatsReport *> *stats))completionHandler {
  rtc::scoped_refptr<webrtc::StatsObserverAdapter> observer(
      new rtc::RefCountedObject<webrtc::StatsObserverAdapter>
          (completionHandler));
  webrtc::PeerConnectionInterface::StatsOutputLevel nativeOutputLevel =
      [[self class] nativeStatsOutputLevelForLevel:statsOutputLevel];
  self.nativePeerConnection->GetStats(
      observer, mediaStreamTrack.nativeTrack, nativeOutputLevel);
}

@end
