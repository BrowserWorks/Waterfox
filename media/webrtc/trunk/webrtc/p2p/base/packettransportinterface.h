/*
 *  Copyright 2016 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef WEBRTC_P2P_BASE_PACKETTRANSPORTINTERFACE_H_
#define WEBRTC_P2P_BASE_PACKETTRANSPORTINTERFACE_H_

#include <string>
#include <vector>

#include "webrtc/base/sigslot.h"
#include "webrtc/base/socket.h"

namespace cricket {
class TransportChannel;
}

namespace rtc {
struct PacketOptions;
struct PacketTime;
struct SentPacket;

class PacketTransportInterface : public sigslot::has_slots<> {
 public:
  virtual ~PacketTransportInterface() {}

  // Identify the object for logging and debug purpose.
  virtual const std::string debug_name() const = 0;

  // The transport has been established.
  virtual bool writable() const = 0;

  // The transport has received a packet in the last X milliseconds, here X is
  // configured by each implementation.
  virtual bool receiving() const = 0;

  // Attempts to send the given packet.
  // The return value is < 0 on failure. The return value in failure case is not
  // descriptive. Depending on failure cause and implementation details
  // GetError() returns an descriptive errno.h error value.
  // This mimics posix socket send() or sendto() behavior.
  // TODO(johan): Reliable, meaningful, consistent error codes for all
  // implementations would be nice.
  // TODO(johan): Remove the default argument once channel code is updated.
  virtual int SendPacket(const char* data,
                         size_t len,
                         const rtc::PacketOptions& options,
                         int flags = 0) = 0;

  // Sets a socket option. Note that not all options are
  // supported by all transport types.
  virtual int SetOption(rtc::Socket::Option opt, int value) = 0;

  // TODO(pthatcher): Once Chrome's MockPacketTransportInterface implements
  // this, remove the default implementation.
  virtual bool GetOption(rtc::Socket::Option opt, int* value) { return false; }

  // Returns the most recent error that occurred on this channel.
  virtual int GetError() = 0;

  // Emitted when the writable state, represented by |writable()|, changes.
  sigslot::signal1<PacketTransportInterface*> SignalWritableState;

  //  Emitted when the PacketTransportInterface is ready to send packets. "Ready
  //  to send" is more sensitive than the writable state; a transport may be
  //  writable, but temporarily not able to send packets. For example, the
  //  underlying transport's socket buffer may be full, as indicated by
  //  SendPacket's return code and/or GetError.
  sigslot::signal1<PacketTransportInterface*> SignalReadyToSend;

  // Emitted when receiving state changes to true.
  sigslot::signal1<PacketTransportInterface*> SignalReceivingState;

  // Signalled each time a packet is received on this channel.
  sigslot::signal5<PacketTransportInterface*,
                   const char*,
                   size_t,
                   const rtc::PacketTime&,
                   int>
      SignalReadPacket;

  // Signalled each time a packet is sent on this channel.
  sigslot::signal2<PacketTransportInterface*, const rtc::SentPacket&>
      SignalSentPacket;
};

}  // namespace rtc

#endif  // WEBRTC_P2P_BASE_PACKETTRANSPORTINTERFACE_H_
