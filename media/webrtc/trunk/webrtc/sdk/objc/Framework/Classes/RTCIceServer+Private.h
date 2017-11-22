/*
 *  Copyright 2015 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "WebRTC/RTCIceServer.h"

#include "webrtc/api/peerconnectioninterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTCIceServer ()

/**
 * IceServer struct representation of this RTCIceServer object's data.
 * This is needed to pass to the underlying C++ APIs.
 */
@property(nonatomic, readonly)
    webrtc::PeerConnectionInterface::IceServer nativeServer;

/** Initialize an RTCIceServer from a native IceServer. */
- (instancetype)initWithNativeServer:
    (webrtc::PeerConnectionInterface::IceServer)nativeServer;

@end

NS_ASSUME_NONNULL_END
