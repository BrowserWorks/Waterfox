/*
 *  Copyright 2015 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "WebRTC/RTCVideoSource.h"

#import "RTCMediaSource+Private.h"

#include "webrtc/api/mediastreaminterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTCVideoSource ()

/**
 * The VideoTrackSourceInterface object passed to this RTCVideoSource during
 * construction.
 */
@property(nonatomic, readonly)
    rtc::scoped_refptr<webrtc::VideoTrackSourceInterface>
        nativeVideoSource;

/** Initialize an RTCVideoSource from a native VideoTrackSourceInterface. */
- (instancetype)initWithNativeVideoSource:
    (rtc::scoped_refptr<webrtc::VideoTrackSourceInterface>)nativeVideoSource
    NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithNativeMediaSource:
    (rtc::scoped_refptr<webrtc::MediaSourceInterface>)nativeMediaSource
                                     type:(RTCMediaSourceType)type NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
