/*
 *  Copyright 2012 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "webrtc/p2p/base/turnport.h"

#include <functional>

#include "webrtc/p2p/base/common.h"
#include "webrtc/p2p/base/stun.h"
#include "webrtc/base/asyncpacketsocket.h"
#include "webrtc/base/byteorder.h"
#include "webrtc/base/checks.h"
#include "webrtc/base/common.h"
#include "webrtc/base/logging.h"
#include "webrtc/base/nethelpers.h"
#include "webrtc/base/socketaddress.h"
#include "webrtc/base/stringencode.h"

namespace cricket {

// TODO(juberti): Move to stun.h when relay messages have been renamed.
static const int TURN_ALLOCATE_REQUEST = STUN_ALLOCATE_REQUEST;

// TODO(juberti): Extract to turnmessage.h
static const int TURN_DEFAULT_PORT = 3478;
static const int TURN_CHANNEL_NUMBER_START = 0x4000;
static const int TURN_PERMISSION_TIMEOUT = 5 * 60 * 1000;  // 5 minutes

static const size_t TURN_CHANNEL_HEADER_SIZE = 4U;

// Retry at most twice (i.e. three different ALLOCATE requests) on
// STUN_ERROR_ALLOCATION_MISMATCH error per rfc5766.
static const size_t MAX_ALLOCATE_MISMATCH_RETRIES = 2;

static const int TURN_SUCCESS_RESULT_CODE = 0;

inline bool IsTurnChannelData(uint16_t msg_type) {
  return ((msg_type & 0xC000) == 0x4000);  // MSB are 0b01
}

static int GetRelayPreference(cricket::ProtocolType proto) {
  switch (proto) {
    case cricket::PROTO_TCP:
      return ICE_TYPE_PREFERENCE_RELAY_TCP;
    case cricket::PROTO_TLS:
      return ICE_TYPE_PREFERENCE_RELAY_TLS;
    default:
      RTC_DCHECK(proto == PROTO_UDP);
      return ICE_TYPE_PREFERENCE_RELAY_UDP;
  }
}

class TurnAllocateRequest : public StunRequest {
 public:
  explicit TurnAllocateRequest(TurnPort* port);
  void Prepare(StunMessage* request) override;
  void OnSent() override;
  void OnResponse(StunMessage* response) override;
  void OnErrorResponse(StunMessage* response) override;
  void OnTimeout() override;

 private:
  // Handles authentication challenge from the server.
  void OnAuthChallenge(StunMessage* response, int code);
  void OnTryAlternate(StunMessage* response, int code);
  void OnUnknownAttribute(StunMessage* response);

  TurnPort* port_;
};

class TurnRefreshRequest : public StunRequest {
 public:
  explicit TurnRefreshRequest(TurnPort* port);
  void Prepare(StunMessage* request) override;
  void OnSent() override;
  void OnResponse(StunMessage* response) override;
  void OnErrorResponse(StunMessage* response) override;
  void OnTimeout() override;
  void set_lifetime(int lifetime) { lifetime_ = lifetime; }

 private:
  TurnPort* port_;
  int lifetime_;
};

class TurnCreatePermissionRequest : public StunRequest,
                                    public sigslot::has_slots<> {
 public:
  TurnCreatePermissionRequest(TurnPort* port, TurnEntry* entry,
                              const rtc::SocketAddress& ext_addr);
  void Prepare(StunMessage* request) override;
  void OnSent() override;
  void OnResponse(StunMessage* response) override;
  void OnErrorResponse(StunMessage* response) override;
  void OnTimeout() override;

 private:
  void OnEntryDestroyed(TurnEntry* entry);

  TurnPort* port_;
  TurnEntry* entry_;
  rtc::SocketAddress ext_addr_;
};

class TurnChannelBindRequest : public StunRequest,
                               public sigslot::has_slots<> {
 public:
  TurnChannelBindRequest(TurnPort* port, TurnEntry* entry, int channel_id,
                         const rtc::SocketAddress& ext_addr);
  void Prepare(StunMessage* request) override;
  void OnSent() override;
  void OnResponse(StunMessage* response) override;
  void OnErrorResponse(StunMessage* response) override;
  void OnTimeout() override;

 private:
  void OnEntryDestroyed(TurnEntry* entry);

  TurnPort* port_;
  TurnEntry* entry_;
  int channel_id_;
  rtc::SocketAddress ext_addr_;
};

// Manages a "connection" to a remote destination. We will attempt to bring up
// a channel for this remote destination to reduce the overhead of sending data.
class TurnEntry : public sigslot::has_slots<> {
 public:
  enum BindState { STATE_UNBOUND, STATE_BINDING, STATE_BOUND };
  TurnEntry(TurnPort* port, int channel_id,
            const rtc::SocketAddress& ext_addr);

  TurnPort* port() { return port_; }

  int channel_id() const { return channel_id_; }
  // For testing only.
  void set_channel_id(int channel_id) { channel_id_ = channel_id; }

  const rtc::SocketAddress& address() const { return ext_addr_; }
  BindState state() const { return state_; }

  int64_t destruction_timestamp() { return destruction_timestamp_; }
  void set_destruction_timestamp(int64_t destruction_timestamp) {
    destruction_timestamp_ = destruction_timestamp;
  }

  // Helper methods to send permission and channel bind requests.
  void SendCreatePermissionRequest(int delay);
  void SendChannelBindRequest(int delay);
  // Sends a packet to the given destination address.
  // This will wrap the packet in STUN if necessary.
  int Send(const void* data, size_t size, bool payload,
           const rtc::PacketOptions& options);

  void OnCreatePermissionSuccess();
  void OnCreatePermissionError(StunMessage* response, int code);
  void OnCreatePermissionTimeout();
  void OnChannelBindSuccess();
  void OnChannelBindError(StunMessage* response, int code);
  void OnChannelBindTimeout();
  // Signal sent when TurnEntry is destroyed.
  sigslot::signal1<TurnEntry*> SignalDestroyed;

 private:
  TurnPort* port_;
  int channel_id_;
  rtc::SocketAddress ext_addr_;
  BindState state_;
  // A non-zero value indicates that this entry is scheduled to be destroyed.
  // It is also used as an ID of the event scheduling. When the destruction
  // event actually fires, the TurnEntry will be destroyed only if the
  // timestamp here matches the one in the firing event.
  int64_t destruction_timestamp_ = 0;
};

TurnPort::TurnPort(rtc::Thread* thread,
                   rtc::PacketSocketFactory* factory,
                   rtc::Network* network,
                   rtc::AsyncPacketSocket* socket,
                   const std::string& username,
                   const std::string& password,
                   const ProtocolAddress& server_address,
                   const RelayCredentials& credentials,
                   int server_priority,
                   const std::string& origin)
    : Port(thread,
           RELAY_PORT_TYPE,
           factory,
           network,
           socket->GetLocalAddress().ipaddr(),
           username,
           password),
      server_address_(server_address),
      credentials_(credentials),
      socket_(socket),
      resolver_(NULL),
      error_(0),
      request_manager_(thread),
      next_channel_number_(TURN_CHANNEL_NUMBER_START),
      state_(STATE_CONNECTING),
      server_priority_(server_priority),
      allocate_mismatch_retries_(0) {
  request_manager_.SignalSendPacket.connect(this, &TurnPort::OnSendStunPacket);
  request_manager_.set_origin(origin);
}

TurnPort::TurnPort(rtc::Thread* thread,
                   rtc::PacketSocketFactory* factory,
                   rtc::Network* network,
                   const rtc::IPAddress& ip,
                   uint16_t min_port,
                   uint16_t max_port,
                   const std::string& username,
                   const std::string& password,
                   const ProtocolAddress& server_address,
                   const RelayCredentials& credentials,
                   int server_priority,
                   const std::string& origin)
    : Port(thread,
           RELAY_PORT_TYPE,
           factory,
           network,
           ip,
           min_port,
           max_port,
           username,
           password),
      server_address_(server_address),
      credentials_(credentials),
      socket_(NULL),
      resolver_(NULL),
      error_(0),
      request_manager_(thread),
      next_channel_number_(TURN_CHANNEL_NUMBER_START),
      state_(STATE_CONNECTING),
      server_priority_(server_priority),
      allocate_mismatch_retries_(0) {
  request_manager_.SignalSendPacket.connect(this, &TurnPort::OnSendStunPacket);
  request_manager_.set_origin(origin);
}

TurnPort::~TurnPort() {
  // TODO(juberti): Should this even be necessary?

  // release the allocation by sending a refresh with
  // lifetime 0.
  if (ready()) {
    TurnRefreshRequest bye(this);
    bye.set_lifetime(0);
    SendRequest(&bye, 0);
  }

  while (!entries_.empty()) {
    DestroyEntry(entries_.front());
  }
  if (resolver_) {
    resolver_->Destroy(false);
  }
  if (!SharedSocket()) {
    delete socket_;
  }
}

rtc::SocketAddress TurnPort::GetLocalAddress() const {
  return socket_ ? socket_->GetLocalAddress() : rtc::SocketAddress();
}

void TurnPort::PrepareAddress() {
  if (credentials_.username.empty() ||
      credentials_.password.empty()) {
    LOG(LS_ERROR) << "Allocation can't be started without setting the"
                  << " TURN server credentials for the user.";
    OnAllocateError();
    return;
  }

  if (!server_address_.address.port()) {
    // We will set default TURN port, if no port is set in the address.
    server_address_.address.SetPort(TURN_DEFAULT_PORT);
  }

  if (server_address_.address.IsUnresolvedIP()) {
    ResolveTurnAddress(server_address_.address);
  } else {
    // If protocol family of server address doesn't match with local, return.
    if (!IsCompatibleAddress(server_address_.address)) {
      LOG(LS_ERROR) << "IP address family does not match: "
                    << "server: " << server_address_.address.family()
                    << " local: " << ip().family();
      OnAllocateError();
      return;
    }

    // Insert the current address to prevent redirection pingpong.
    attempted_server_addresses_.insert(server_address_.address);

    LOG_J(LS_INFO, this) << "Trying to connect to TURN server via "
                         << ProtoToString(server_address_.proto) << " @ "
                         << server_address_.address.ToSensitiveString();
    if (!CreateTurnClientSocket()) {
      LOG(LS_ERROR) << "Failed to create TURN client socket";
      OnAllocateError();
      return;
    }
    if (server_address_.proto == PROTO_UDP) {
      // If its UDP, send AllocateRequest now.
      // For TCP and TLS AllcateRequest will be sent by OnSocketConnect.
      SendRequest(new TurnAllocateRequest(this), 0);
    }
  }
}

bool TurnPort::CreateTurnClientSocket() {
  RTC_DCHECK(!socket_ || SharedSocket());

  if (server_address_.proto == PROTO_UDP && !SharedSocket()) {
    socket_ = socket_factory()->CreateUdpSocket(
        rtc::SocketAddress(ip(), 0), min_port(), max_port());
  } else if (server_address_.proto == PROTO_TCP ||
             server_address_.proto == PROTO_TLS) {
    RTC_DCHECK(!SharedSocket());
    int opts = rtc::PacketSocketFactory::OPT_STUN;

    // Apply server address TLS and insecure bits to options.
    if (server_address_.proto == PROTO_TLS) {
      if (tls_cert_policy_ ==
          TlsCertPolicy::TLS_CERT_POLICY_INSECURE_NO_CHECK) {
        opts |= rtc::PacketSocketFactory::OPT_TLS_INSECURE;
      } else {
        opts |= rtc::PacketSocketFactory::OPT_TLS;
      }
    }

    socket_ = socket_factory()->CreateClientTcpSocket(
        rtc::SocketAddress(ip(), 0), server_address_.address,
        proxy(), user_agent(), opts);
  }

  if (!socket_) {
    error_ = SOCKET_ERROR;
    return false;
  }

  // Apply options if any.
  for (SocketOptionsMap::iterator iter = socket_options_.begin();
       iter != socket_options_.end(); ++iter) {
    socket_->SetOption(iter->first, iter->second);
  }

  if (!SharedSocket()) {
    // If socket is shared, AllocationSequence will receive the packet.
    socket_->SignalReadPacket.connect(this, &TurnPort::OnReadPacket);
  }

  socket_->SignalReadyToSend.connect(this, &TurnPort::OnReadyToSend);

  socket_->SignalSentPacket.connect(this, &TurnPort::OnSentPacket);

  // TCP port is ready to send stun requests after the socket is connected,
  // while UDP port is ready to do so once the socket is created.
  if (server_address_.proto == PROTO_TCP ||
      server_address_.proto == PROTO_TLS) {
    socket_->SignalConnect.connect(this, &TurnPort::OnSocketConnect);
    socket_->SignalClose.connect(this, &TurnPort::OnSocketClose);
  } else {
    state_ = STATE_CONNECTED;
  }
  return true;
}

void TurnPort::OnSocketConnect(rtc::AsyncPacketSocket* socket) {
  RTC_DCHECK(server_address_.proto == PROTO_TCP);
  // Do not use this port if the socket bound to a different address than
  // the one we asked for. This is seen in Chrome, where TCP sockets cannot be
  // given a binding address, and the platform is expected to pick the
  // correct local address.

  // However, there are two situations in which we allow the bound address to
  // differ from the requested address: 1. The bound address is the loopback
  // address.  This happens when a proxy forces TCP to bind to only the
  // localhost address (see issue 3927). 2. The bound address is the "any
  // address".  This happens when multiple_routes is disabled (see issue 4780).
  if (socket->GetLocalAddress().ipaddr() != ip()) {
    if (socket->GetLocalAddress().IsLoopbackIP()) {
      LOG(LS_WARNING) << "Socket is bound to a different address:"
                      << socket->GetLocalAddress().ipaddr().ToString()
                      << ", rather then the local port:" << ip().ToString()
                      << ". Still allowing it since it's localhost.";
    } else if (IPIsAny(ip())) {
      LOG(LS_WARNING) << "Socket is bound to a different address:"
                      << socket->GetLocalAddress().ipaddr().ToString()
                      << ", rather then the local port:" << ip().ToString()
                      << ". Still allowing it since it's any address"
                      << ", possibly caused by multiple_routes being disabled.";
    } else {
      LOG(LS_WARNING) << "Socket is bound to a different address:"
                      << socket->GetLocalAddress().ipaddr().ToString()
                      << ", rather then the local port:" << ip().ToString()
                      << ". Discarding TURN port.";
      OnAllocateError();
      return;
    }
  }

  state_ = STATE_CONNECTED;  // It is ready to send stun requests.
  if (server_address_.address.IsUnresolvedIP()) {
    server_address_.address = socket_->GetRemoteAddress();
  }

  LOG(LS_INFO) << "TurnPort connected to " << socket->GetRemoteAddress()
               << " using tcp.";
  SendRequest(new TurnAllocateRequest(this), 0);
}

void TurnPort::OnSocketClose(rtc::AsyncPacketSocket* socket, int error) {
  LOG_J(LS_WARNING, this) << "Connection with server failed, error=" << error;
  RTC_DCHECK(socket == socket_);
  Close();
}

void TurnPort::OnAllocateMismatch() {
  if (allocate_mismatch_retries_ >= MAX_ALLOCATE_MISMATCH_RETRIES) {
    LOG_J(LS_WARNING, this) << "Giving up on the port after "
                            << allocate_mismatch_retries_
                            << " retries for STUN_ERROR_ALLOCATION_MISMATCH";
    OnAllocateError();
    return;
  }

  LOG_J(LS_INFO, this) << "Allocating a new socket after "
                       << "STUN_ERROR_ALLOCATION_MISMATCH, retry = "
                       << allocate_mismatch_retries_ + 1;
  if (SharedSocket()) {
    ResetSharedSocket();
  } else {
    delete socket_;
  }
  socket_ = NULL;

  ResetNonce();
  PrepareAddress();
  ++allocate_mismatch_retries_;
}

Connection* TurnPort::CreateConnection(const Candidate& remote_candidate,
                                       CandidateOrigin origin) {
  // TURN-UDP can only connect to UDP candidates.
  if (!SupportsProtocol(remote_candidate.protocol())) {
    return NULL;
  }

  if (state_ == STATE_DISCONNECTED || state_ == STATE_RECEIVEONLY) {
    return NULL;
  }

  // A TURN port will have two candiates, STUN and TURN. STUN may not
  // present in all cases. If present stun candidate will be added first
  // and TURN candidate later.
  for (size_t index = 0; index < Candidates().size(); ++index) {
    const Candidate& local_candidate = Candidates()[index];
    if (local_candidate.type() == RELAY_PORT_TYPE &&
        local_candidate.address().family() ==
            remote_candidate.address().family()) {
      // Create an entry, if needed, so we can get our permissions set up
      // correctly.
      CreateOrRefreshEntry(remote_candidate.address());
      ProxyConnection* conn =
          new ProxyConnection(this, index, remote_candidate);
      AddOrReplaceConnection(conn);
      return conn;
    }
  }
  return NULL;
}

bool TurnPort::FailAndPruneConnection(const rtc::SocketAddress& address) {
  Connection* conn = GetConnection(address);
  if (conn != nullptr) {
    conn->FailAndPrune();
    return true;
  }
  return false;
}

int TurnPort::SetOption(rtc::Socket::Option opt, int value) {
  if (!socket_) {
    // If socket is not created yet, these options will be applied during socket
    // creation.
    socket_options_[opt] = value;
    return 0;
  }
  return socket_->SetOption(opt, value);
}

int TurnPort::GetOption(rtc::Socket::Option opt, int* value) {
  if (!socket_) {
    SocketOptionsMap::const_iterator it = socket_options_.find(opt);
    if (it == socket_options_.end()) {
      return -1;
    }
    *value = it->second;
    return 0;
  }

  return socket_->GetOption(opt, value);
}

int TurnPort::GetError() {
  return error_;
}

int TurnPort::SendTo(const void* data, size_t size,
                     const rtc::SocketAddress& addr,
                     const rtc::PacketOptions& options,
                     bool payload) {
  // Try to find an entry for this specific address; we should have one.
  TurnEntry* entry = FindEntry(addr);
  if (!entry) {
    LOG(LS_ERROR) << "Did not find the TurnEntry for address " << addr;
    return 0;
  }

  if (!ready()) {
    error_ = ENOTCONN;
    return SOCKET_ERROR;
  }

  // Send the actual contents to the server using the usual mechanism.
  int sent = entry->Send(data, size, payload, options);
  if (sent <= 0) {
    return SOCKET_ERROR;
  }

  // The caller of the function is expecting the number of user data bytes,
  // rather than the size of the packet.
  return static_cast<int>(size);
}

bool TurnPort::HandleIncomingPacket(rtc::AsyncPacketSocket* socket,
                                    const char* data, size_t size,
                                    const rtc::SocketAddress& remote_addr,
                                    const rtc::PacketTime& packet_time) {
  if (socket != socket_) {
    // The packet was received on a shared socket after we've allocated a new
    // socket for this TURN port.
    return false;
  }

  // This is to guard against a STUN response from previous server after
  // alternative server redirection. TODO(guoweis): add a unit test for this
  // race condition.
  if (remote_addr != server_address_.address) {
    LOG_J(LS_WARNING, this) << "Discarding TURN message from unknown address:"
                            << remote_addr.ToString()
                            << ", server_address_:"
                            << server_address_.address.ToString();
    return false;
  }

  // The message must be at least the size of a channel header.
  if (size < TURN_CHANNEL_HEADER_SIZE) {
    LOG_J(LS_WARNING, this) << "Received TURN message that was too short";
    return false;
  }

  if (state_ == STATE_DISCONNECTED) {
    LOG_J(LS_WARNING, this)
        << "Received TURN message while the TURN port is disconnected";
    return false;
  }

  // Check the message type, to see if is a Channel Data message.
  // The message will either be channel data, a TURN data indication, or
  // a response to a previous request.
  uint16_t msg_type = rtc::GetBE16(data);
  if (IsTurnChannelData(msg_type)) {
    HandleChannelData(msg_type, data, size, packet_time);
    return true;

  }

  if (msg_type == TURN_DATA_INDICATION) {
    HandleDataIndication(data, size, packet_time);
    return true;
  }

  if (SharedSocket() && (msg_type == STUN_BINDING_RESPONSE ||
                         msg_type == STUN_BINDING_ERROR_RESPONSE)) {
    LOG_J(LS_VERBOSE, this) <<
        "Ignoring STUN binding response message on shared socket.";
    return false;
  }

  // This must be a response for one of our requests.
  // Check success responses, but not errors, for MESSAGE-INTEGRITY.
  if (IsStunSuccessResponseType(msg_type) &&
      !StunMessage::ValidateMessageIntegrity(data, size, hash())) {
    LOG_J(LS_WARNING, this) << "Received TURN message with invalid "
                            << "message integrity, msg_type=" << msg_type;
    return true;
  }
  request_manager_.CheckResponse(data, size);

  return true;
}

void TurnPort::OnReadPacket(rtc::AsyncPacketSocket* socket,
                            const char* data,
                            size_t size,
                            const rtc::SocketAddress& remote_addr,
                            const rtc::PacketTime& packet_time) {
  HandleIncomingPacket(socket, data, size, remote_addr, packet_time);
}

void TurnPort::OnSentPacket(rtc::AsyncPacketSocket* socket,
                            const rtc::SentPacket& sent_packet) {
  PortInterface::SignalSentPacket(sent_packet);
}

void TurnPort::OnReadyToSend(rtc::AsyncPacketSocket* socket) {
  if (ready()) {
    Port::OnReadyToSend();
  }
}


// Update current server address port with the alternate server address port.
bool TurnPort::SetAlternateServer(const rtc::SocketAddress& address) {
  // Check if we have seen this address before and reject if we did.
  AttemptedServerSet::iterator iter = attempted_server_addresses_.find(address);
  if (iter != attempted_server_addresses_.end()) {
    LOG_J(LS_WARNING, this) << "Redirection to ["
                            << address.ToSensitiveString()
                            << "] ignored, allocation failed.";
    return false;
  }

  // If protocol family of server address doesn't match with local, return.
  if (!IsCompatibleAddress(address)) {
    LOG(LS_WARNING) << "Server IP address family does not match with "
                    << "local host address family type";
    return false;
  }

  // Block redirects to a loopback address.
  // See: https://bugs.chromium.org/p/chromium/issues/detail?id=649118
  if (address.IsLoopbackIP()) {
    LOG_J(LS_WARNING, this)
        << "Blocking attempted redirect to loopback address.";
    return false;
  }

  LOG_J(LS_INFO, this) << "Redirecting from TURN server ["
                       << server_address_.address.ToSensitiveString()
                       << "] to TURN server ["
                       << address.ToSensitiveString()
                       << "]";
  server_address_ = ProtocolAddress(address, server_address_.proto);

  // Insert the current address to prevent redirection pingpong.
  attempted_server_addresses_.insert(server_address_.address);
  return true;
}

void TurnPort::ResolveTurnAddress(const rtc::SocketAddress& address) {
  if (resolver_)
    return;

  LOG_J(LS_INFO, this) << "Starting TURN host lookup for "
                       << address.ToSensitiveString();
  resolver_ = socket_factory()->CreateAsyncResolver();
  resolver_->SignalDone.connect(this, &TurnPort::OnResolveResult);
  resolver_->Start(address);
}

void TurnPort::OnResolveResult(rtc::AsyncResolverInterface* resolver) {
  RTC_DCHECK(resolver == resolver_);
  // If DNS resolve is failed when trying to connect to the server using TCP,
  // one of the reason could be due to DNS queries blocked by firewall.
  // In such cases we will try to connect to the server with hostname, assuming
  // socket layer will resolve the hostname through a HTTP proxy (if any).
  if (resolver_->GetError() != 0 && server_address_.proto == PROTO_TCP) {
    if (!CreateTurnClientSocket()) {
      OnAllocateError();
    }
    return;
  }

  // Copy the original server address in |resolved_address|. For TLS based
  // sockets we need hostname along with resolved address.
  rtc::SocketAddress resolved_address = server_address_.address;
  if (resolver_->GetError() != 0 ||
      !resolver_->GetResolvedAddress(ip().family(), &resolved_address)) {
    LOG_J(LS_WARNING, this) << "TURN host lookup received error "
                            << resolver_->GetError();
    error_ = resolver_->GetError();
    OnAllocateError();
    return;
  }
  // Signal needs both resolved and unresolved address. After signal is sent
  // we can copy resolved address back into |server_address_|.
  SignalResolvedServerAddress(this, server_address_.address,
                              resolved_address);
  server_address_.address = resolved_address;
  PrepareAddress();
}

void TurnPort::OnSendStunPacket(const void* data, size_t size,
                                StunRequest* request) {
  RTC_DCHECK(connected());
  rtc::PacketOptions options(DefaultDscpValue());
  if (Send(data, size, options) < 0) {
    LOG_J(LS_ERROR, this) << "Failed to send TURN message, err="
                          << socket_->GetError();
  }
}

void TurnPort::OnStunAddress(const rtc::SocketAddress& address) {
  // STUN Port will discover STUN candidate, as it's supplied with first TURN
  // server address.
  // Why not using this address? - P2PTransportChannel will start creating
  // connections after first candidate, which means it could start creating the
  // connections before TURN candidate added. For that to handle, we need to
  // supply STUN candidate from this port to UDPPort, and TurnPort should have
  // handle to UDPPort to pass back the address.
}

void TurnPort::OnAllocateSuccess(const rtc::SocketAddress& address,
                                 const rtc::SocketAddress& stun_address) {
  state_ = STATE_READY;

  rtc::SocketAddress related_address = stun_address;

  // For relayed candidate, Base is the candidate itself.
  AddAddress(address,          // Candidate address.
             address,          // Base address.
             related_address,  // Related address.
             UDP_PROTOCOL_NAME,
             ProtoToString(server_address_.proto),  // The first hop protocol.
             "",  // TCP canddiate type, empty for turn candidates.
             RELAY_PORT_TYPE, GetRelayPreference(server_address_.proto),
             server_priority_, true);
}

void TurnPort::OnAllocateError() {
  // We will send SignalPortError asynchronously as this can be sent during
  // port initialization. This way it will not be blocking other port
  // creation.
  thread()->Post(RTC_FROM_HERE, this, MSG_ALLOCATE_ERROR);
}

void TurnPort::OnRefreshError() {
  // Need to clear the requests asynchronously because otherwise, the refresh
  // request may be deleted twice: once at the end of the message processing
  // and the other in HandleRefreshError().
  thread()->Post(RTC_FROM_HERE, this, MSG_REFRESH_ERROR);
}

void TurnPort::HandleRefreshError() {
  request_manager_.Clear();
  state_ = STATE_RECEIVEONLY;
  // Fail and prune all connections; stop sending data.
  for (auto kv : connections()) {
    kv.second->FailAndPrune();
  }
}

void TurnPort::Close() {
  if (!ready()) {
    OnAllocateError();
  }
  request_manager_.Clear();
  // Stop the port from creating new connections.
  state_ = STATE_DISCONNECTED;
  // Delete all existing connections; stop sending data.
  for (auto kv : connections()) {
    kv.second->Destroy();
  }
}

void TurnPort::OnMessage(rtc::Message* message) {
  switch (message->message_id) {
    case MSG_ALLOCATE_ERROR:
      SignalPortError(this);
      break;
    case MSG_ALLOCATE_MISMATCH:
      OnAllocateMismatch();
      break;
    case MSG_REFRESH_ERROR:
      HandleRefreshError();
      break;
    case MSG_TRY_ALTERNATE_SERVER:
      if (server_address().proto == PROTO_UDP) {
        // Send another allocate request to alternate server, with the received
        // realm and nonce values.
        SendRequest(new TurnAllocateRequest(this), 0);
      } else {
        // Since it's TCP, we have to delete the connected socket and reconnect
        // with the alternate server. PrepareAddress will send stun binding once
        // the new socket is connected.
        RTC_DCHECK(server_address().proto == PROTO_TCP);
        RTC_DCHECK(!SharedSocket());
        delete socket_;
        socket_ = NULL;
        PrepareAddress();
      }
      break;
    default:
      Port::OnMessage(message);
  }
}

void TurnPort::OnAllocateRequestTimeout() {
  OnAllocateError();
}

void TurnPort::HandleDataIndication(const char* data, size_t size,
                                    const rtc::PacketTime& packet_time) {
  // Read in the message, and process according to RFC5766, Section 10.4.
  rtc::ByteBufferReader buf(data, size);
  TurnMessage msg;
  if (!msg.Read(&buf)) {
    LOG_J(LS_WARNING, this) << "Received invalid TURN data indication";
    return;
  }

  // Check mandatory attributes.
  const StunAddressAttribute* addr_attr =
      msg.GetAddress(STUN_ATTR_XOR_PEER_ADDRESS);
  if (!addr_attr) {
    LOG_J(LS_WARNING, this) << "Missing STUN_ATTR_XOR_PEER_ADDRESS attribute "
                            << "in data indication.";
    return;
  }

  const StunByteStringAttribute* data_attr =
      msg.GetByteString(STUN_ATTR_DATA);
  if (!data_attr) {
    LOG_J(LS_WARNING, this) << "Missing STUN_ATTR_DATA attribute in "
                            << "data indication.";
    return;
  }

  // Log a warning if the data didn't come from an address that we think we have
  // a permission for.
  rtc::SocketAddress ext_addr(addr_attr->GetAddress());
  if (!HasPermission(ext_addr.ipaddr())) {
    LOG_J(LS_WARNING, this)
        << "Received TURN data indication with unknown "
        << "peer address, addr=" << ext_addr.ToSensitiveString();
  }

  DispatchPacket(data_attr->bytes(), data_attr->length(), ext_addr,
                 PROTO_UDP, packet_time);
}

void TurnPort::HandleChannelData(int channel_id, const char* data,
                                 size_t size,
                                 const rtc::PacketTime& packet_time) {
  // Read the message, and process according to RFC5766, Section 11.6.
  //    0                   1                   2                   3
  //    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
  //   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  //   |         Channel Number        |            Length             |
  //   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  //   |                                                               |
  //   /                       Application Data                        /
  //   /                                                               /
  //   |                                                               |
  //   |                               +-------------------------------+
  //   |                               |
  //   +-------------------------------+

  // Extract header fields from the message.
  uint16_t len = rtc::GetBE16(data + 2);
  if (len > size - TURN_CHANNEL_HEADER_SIZE) {
    LOG_J(LS_WARNING, this) << "Received TURN channel data message with "
                            << "incorrect length, len=" << len;
    return;
  }
  // Allowing messages larger than |len|, as ChannelData can be padded.

  TurnEntry* entry = FindEntry(channel_id);
  if (!entry) {
    LOG_J(LS_WARNING, this) << "Received TURN channel data message for invalid "
                            << "channel, channel_id=" << channel_id;
    return;
  }

  DispatchPacket(data + TURN_CHANNEL_HEADER_SIZE, len, entry->address(),
                 PROTO_UDP, packet_time);
}

void TurnPort::DispatchPacket(const char* data, size_t size,
    const rtc::SocketAddress& remote_addr,
    ProtocolType proto, const rtc::PacketTime& packet_time) {
  if (Connection* conn = GetConnection(remote_addr)) {
    conn->OnReadPacket(data, size, packet_time);
  } else {
    Port::OnReadPacket(data, size, remote_addr, proto);
  }
}

bool TurnPort::ScheduleRefresh(int lifetime) {
  // Lifetime is in seconds; we schedule a refresh for one minute less.
  if (lifetime < 2 * 60) {
    LOG_J(LS_WARNING, this) << "Received response with lifetime that was "
                            << "too short, lifetime=" << lifetime;
    return false;
  }

  int delay = (lifetime - 60) * 1000;
  SendRequest(new TurnRefreshRequest(this), delay);
  LOG_J(LS_INFO, this) << "Scheduled refresh in " << delay << "ms.";
  return true;
}

void TurnPort::SendRequest(StunRequest* req, int delay) {
  request_manager_.SendDelayed(req, delay);
}

void TurnPort::AddRequestAuthInfo(StunMessage* msg) {
  // If we've gotten the necessary data from the server, add it to our request.
  VERIFY(!hash_.empty());
  VERIFY(msg->AddAttribute(new StunByteStringAttribute(
      STUN_ATTR_USERNAME, credentials_.username)));
  VERIFY(msg->AddAttribute(new StunByteStringAttribute(
      STUN_ATTR_REALM, realm_)));
  VERIFY(msg->AddAttribute(new StunByteStringAttribute(
      STUN_ATTR_NONCE, nonce_)));
  VERIFY(msg->AddMessageIntegrity(hash()));
}

int TurnPort::Send(const void* data, size_t len,
                   const rtc::PacketOptions& options) {
  return socket_->SendTo(data, len, server_address_.address, options);
}

void TurnPort::UpdateHash() {
  VERIFY(ComputeStunCredentialHash(credentials_.username, realm_,
                                   credentials_.password, &hash_));
}

bool TurnPort::UpdateNonce(StunMessage* response) {
  // When stale nonce error received, we should update
  // hash and store realm and nonce.
  // Check the mandatory attributes.
  const StunByteStringAttribute* realm_attr =
      response->GetByteString(STUN_ATTR_REALM);
  if (!realm_attr) {
    LOG(LS_ERROR) << "Missing STUN_ATTR_REALM attribute in "
                  << "stale nonce error response.";
    return false;
  }
  set_realm(realm_attr->GetString());

  const StunByteStringAttribute* nonce_attr =
      response->GetByteString(STUN_ATTR_NONCE);
  if (!nonce_attr) {
    LOG(LS_ERROR) << "Missing STUN_ATTR_NONCE attribute in "
                  << "stale nonce error response.";
    return false;
  }
  set_nonce(nonce_attr->GetString());
  return true;
}

void TurnPort::ResetNonce() {
  hash_.clear();
  nonce_.clear();
  realm_.clear();
}

static bool MatchesIP(TurnEntry* e, rtc::IPAddress ipaddr) {
  return e->address().ipaddr() == ipaddr;
}
bool TurnPort::HasPermission(const rtc::IPAddress& ipaddr) const {
  return (std::find_if(entries_.begin(), entries_.end(),
      std::bind2nd(std::ptr_fun(MatchesIP), ipaddr)) != entries_.end());
}

static bool MatchesAddress(TurnEntry* e, rtc::SocketAddress addr) {
  return e->address() == addr;
}
TurnEntry* TurnPort::FindEntry(const rtc::SocketAddress& addr) const {
  EntryList::const_iterator it = std::find_if(entries_.begin(), entries_.end(),
      std::bind2nd(std::ptr_fun(MatchesAddress), addr));
  return (it != entries_.end()) ? *it : NULL;
}

static bool MatchesChannelId(TurnEntry* e, int id) {
  return e->channel_id() == id;
}
TurnEntry* TurnPort::FindEntry(int channel_id) const {
  EntryList::const_iterator it = std::find_if(entries_.begin(), entries_.end(),
      std::bind2nd(std::ptr_fun(MatchesChannelId), channel_id));
  return (it != entries_.end()) ? *it : NULL;
}

bool TurnPort::EntryExists(TurnEntry* e) {
  auto it = std::find(entries_.begin(), entries_.end(), e);
  return it != entries_.end();
}

void TurnPort::CreateOrRefreshEntry(const rtc::SocketAddress& addr) {
  TurnEntry* entry = FindEntry(addr);
  if (entry == nullptr) {
    entry = new TurnEntry(this, next_channel_number_++, addr);
    entries_.push_back(entry);
  } else {
    // The channel binding request for the entry will be refreshed automatically
    // until the entry is destroyed.
    CancelEntryDestruction(entry);
  }
}

void TurnPort::DestroyEntry(TurnEntry* entry) {
  RTC_DCHECK(entry != NULL);
  entry->SignalDestroyed(entry);
  entries_.remove(entry);
  delete entry;
}

void TurnPort::DestroyEntryIfNotCancelled(TurnEntry* entry, int64_t timestamp) {
  if (!EntryExists(entry)) {
    return;
  }
  bool cancelled = timestamp != entry->destruction_timestamp();
  if (!cancelled) {
    DestroyEntry(entry);
  }
}

void TurnPort::HandleConnectionDestroyed(Connection* conn) {
  // Schedule an event to destroy TurnEntry for the connection, which is
  // already destroyed.
  const rtc::SocketAddress& remote_address = conn->remote_candidate().address();
  TurnEntry* entry = FindEntry(remote_address);
  RTC_DCHECK(entry != NULL);
  ScheduleEntryDestruction(entry);
}

void TurnPort::ScheduleEntryDestruction(TurnEntry* entry) {
  RTC_DCHECK(entry->destruction_timestamp() == 0);
  int64_t timestamp = rtc::TimeMillis();
  entry->set_destruction_timestamp(timestamp);
  invoker_.AsyncInvokeDelayed<void>(
      RTC_FROM_HERE, thread(),
      rtc::Bind(&TurnPort::DestroyEntryIfNotCancelled, this, entry, timestamp),
      TURN_PERMISSION_TIMEOUT);
}

void TurnPort::CancelEntryDestruction(TurnEntry* entry) {
  RTC_DCHECK(entry->destruction_timestamp() != 0);
  entry->set_destruction_timestamp(0);
}

bool TurnPort::SetEntryChannelId(const rtc::SocketAddress& address,
                                 int channel_id) {
  TurnEntry* entry = FindEntry(address);
  if (!entry) {
    return false;
  }
  entry->set_channel_id(channel_id);
  return true;
}

TurnAllocateRequest::TurnAllocateRequest(TurnPort* port)
    : StunRequest(new TurnMessage()),
      port_(port) {
}

void TurnAllocateRequest::Prepare(StunMessage* request) {
  // Create the request as indicated in RFC 5766, Section 6.1.
  request->SetType(TURN_ALLOCATE_REQUEST);
  StunUInt32Attribute* transport_attr = StunAttribute::CreateUInt32(
      STUN_ATTR_REQUESTED_TRANSPORT);
  transport_attr->SetValue(IPPROTO_UDP << 24);
  VERIFY(request->AddAttribute(transport_attr));
  if (!port_->hash().empty()) {
    port_->AddRequestAuthInfo(request);
  }
}

void TurnAllocateRequest::OnSent() {
  LOG_J(LS_INFO, port_) << "TURN allocate request sent"
                        << ", id=" << rtc::hex_encode(id());
  StunRequest::OnSent();
}

void TurnAllocateRequest::OnResponse(StunMessage* response) {
  LOG_J(LS_INFO, port_) << "TURN allocate requested successfully"
                        << ", id=" << rtc::hex_encode(id())
                        << ", code=0"  // Makes logging easier to parse.
                        << ", rtt=" << Elapsed();

  // Check mandatory attributes as indicated in RFC5766, Section 6.3.
  const StunAddressAttribute* mapped_attr =
      response->GetAddress(STUN_ATTR_XOR_MAPPED_ADDRESS);
  if (!mapped_attr) {
    LOG_J(LS_WARNING, port_) << "Missing STUN_ATTR_XOR_MAPPED_ADDRESS "
                             << "attribute in allocate success response";
    return;
  }
  // Using XOR-Mapped-Address for stun.
  port_->OnStunAddress(mapped_attr->GetAddress());

  const StunAddressAttribute* relayed_attr =
      response->GetAddress(STUN_ATTR_XOR_RELAYED_ADDRESS);
  if (!relayed_attr) {
    LOG_J(LS_WARNING, port_) << "Missing STUN_ATTR_XOR_RELAYED_ADDRESS "
                             << "attribute in allocate success response";
    return;
  }

  const StunUInt32Attribute* lifetime_attr =
      response->GetUInt32(STUN_ATTR_TURN_LIFETIME);
  if (!lifetime_attr) {
    LOG_J(LS_WARNING, port_) << "Missing STUN_ATTR_TURN_LIFETIME attribute in "
                             << "allocate success response";
    return;
  }
  // Notify the port the allocate succeeded, and schedule a refresh request.
  port_->OnAllocateSuccess(relayed_attr->GetAddress(),
                           mapped_attr->GetAddress());
  port_->ScheduleRefresh(lifetime_attr->value());
}

void TurnAllocateRequest::OnErrorResponse(StunMessage* response) {
  // Process error response according to RFC5766, Section 6.4.
  const StunErrorCodeAttribute* error_code = response->GetErrorCode();

  LOG_J(LS_INFO, port_) << "Received TURN allocate error response"
                        << ", id=" << rtc::hex_encode(id())
                        << ", code=" << error_code->code()
                        << ", rtt=" << Elapsed();

  switch (error_code->code()) {
    case STUN_ERROR_UNAUTHORIZED:       // Unauthrorized.
      OnAuthChallenge(response, error_code->code());
      break;
    case STUN_ERROR_TRY_ALTERNATE:
      OnTryAlternate(response, error_code->code());
      break;
    case STUN_ERROR_ALLOCATION_MISMATCH:
      // We must handle this error async because trying to delete the socket in
      // OnErrorResponse will cause a deadlock on the socket.
      port_->thread()->Post(RTC_FROM_HERE, port_,
                            TurnPort::MSG_ALLOCATE_MISMATCH);
      break;
    default:
      LOG_J(LS_WARNING, port_) << "Received TURN allocate error response"
                               << ", id=" << rtc::hex_encode(id())
                               << ", code=" << error_code->code()
                               << ", rtt=" << Elapsed();
      port_->OnAllocateError();
  }
}

void TurnAllocateRequest::OnTimeout() {
  LOG_J(LS_WARNING, port_) << "TURN allocate request "
                           << rtc::hex_encode(id()) << " timout";
  port_->OnAllocateRequestTimeout();
}

void TurnAllocateRequest::OnAuthChallenge(StunMessage* response, int code) {
  // If we failed to authenticate even after we sent our credentials, fail hard.
  if (code == STUN_ERROR_UNAUTHORIZED && !port_->hash().empty()) {
    LOG_J(LS_WARNING, port_) << "Failed to authenticate with the server "
                             << "after challenge.";
    port_->OnAllocateError();
    return;
  }

  // Check the mandatory attributes.
  const StunByteStringAttribute* realm_attr =
      response->GetByteString(STUN_ATTR_REALM);
  if (!realm_attr) {
    LOG_J(LS_WARNING, port_) << "Missing STUN_ATTR_REALM attribute in "
                             << "allocate unauthorized response.";
    return;
  }
  port_->set_realm(realm_attr->GetString());

  const StunByteStringAttribute* nonce_attr =
      response->GetByteString(STUN_ATTR_NONCE);
  if (!nonce_attr) {
    LOG_J(LS_WARNING, port_) << "Missing STUN_ATTR_NONCE attribute in "
                             << "allocate unauthorized response.";
    return;
  }
  port_->set_nonce(nonce_attr->GetString());

  // Send another allocate request, with the received realm and nonce values.
  port_->SendRequest(new TurnAllocateRequest(port_), 0);
}

void TurnAllocateRequest::OnTryAlternate(StunMessage* response, int code) {

  // According to RFC 5389 section 11, there are use cases where
  // authentication of response is not possible, we're not validating
  // message integrity.

  // Get the alternate server address attribute value.
  const StunAddressAttribute* alternate_server_attr =
      response->GetAddress(STUN_ATTR_ALTERNATE_SERVER);
  if (!alternate_server_attr) {
    LOG_J(LS_WARNING, port_) << "Missing STUN_ATTR_ALTERNATE_SERVER "
                             << "attribute in try alternate error response";
    port_->OnAllocateError();
    return;
  }
  if (!port_->SetAlternateServer(alternate_server_attr->GetAddress())) {
    port_->OnAllocateError();
    return;
  }

  // Check the attributes.
  const StunByteStringAttribute* realm_attr =
      response->GetByteString(STUN_ATTR_REALM);
  if (realm_attr) {
    LOG_J(LS_INFO, port_) << "Applying STUN_ATTR_REALM attribute in "
                          << "try alternate error response.";
    port_->set_realm(realm_attr->GetString());
  }

  const StunByteStringAttribute* nonce_attr =
      response->GetByteString(STUN_ATTR_NONCE);
  if (nonce_attr) {
    LOG_J(LS_INFO, port_) << "Applying STUN_ATTR_NONCE attribute in "
                          << "try alternate error response.";
    port_->set_nonce(nonce_attr->GetString());
  }

  // For TCP, we can't close the original Tcp socket during handling a 300 as
  // we're still inside that socket's event handler. Doing so will cause
  // deadlock.
  port_->thread()->Post(RTC_FROM_HERE, port_,
                        TurnPort::MSG_TRY_ALTERNATE_SERVER);
}

TurnRefreshRequest::TurnRefreshRequest(TurnPort* port)
    : StunRequest(new TurnMessage()),
      port_(port),
      lifetime_(-1) {
}

void TurnRefreshRequest::Prepare(StunMessage* request) {
  // Create the request as indicated in RFC 5766, Section 7.1.
  // No attributes need to be included.
  request->SetType(TURN_REFRESH_REQUEST);
  if (lifetime_ > -1) {
    VERIFY(request->AddAttribute(new StunUInt32Attribute(
        STUN_ATTR_LIFETIME, lifetime_)));
  }

  port_->AddRequestAuthInfo(request);
}

void TurnRefreshRequest::OnSent() {
  LOG_J(LS_INFO, port_) << "TURN refresh request sent"
                        << ", id=" << rtc::hex_encode(id());
  StunRequest::OnSent();
}

void TurnRefreshRequest::OnResponse(StunMessage* response) {
  LOG_J(LS_INFO, port_) << "TURN refresh requested successfully"
                        << ", id=" << rtc::hex_encode(id())
                        << ", code=0"  // Makes logging easier to parse.
                        << ", rtt=" << Elapsed();

  // Check mandatory attributes as indicated in RFC5766, Section 7.3.
  const StunUInt32Attribute* lifetime_attr =
      response->GetUInt32(STUN_ATTR_TURN_LIFETIME);
  if (!lifetime_attr) {
    LOG_J(LS_WARNING, port_) << "Missing STUN_ATTR_TURN_LIFETIME attribute in "
                             << "refresh success response.";
    return;
  }

  // Schedule a refresh based on the returned lifetime value.
  port_->ScheduleRefresh(lifetime_attr->value());
  port_->SignalTurnRefreshResult(port_, TURN_SUCCESS_RESULT_CODE);
}

void TurnRefreshRequest::OnErrorResponse(StunMessage* response) {
  const StunErrorCodeAttribute* error_code = response->GetErrorCode();

  if (error_code->code() == STUN_ERROR_STALE_NONCE) {
    if (port_->UpdateNonce(response)) {
      // Send RefreshRequest immediately.
      port_->SendRequest(new TurnRefreshRequest(port_), 0);
    }
  } else {
    LOG_J(LS_WARNING, port_) << "Received TURN refresh error response"
                             << ", id=" << rtc::hex_encode(id())
                             << ", code=" << error_code->code()
                             << ", rtt=" << Elapsed();
    port_->OnRefreshError();
    port_->SignalTurnRefreshResult(port_, error_code->code());
  }
}

void TurnRefreshRequest::OnTimeout() {
  LOG_J(LS_WARNING, port_) << "TURN refresh timeout " << rtc::hex_encode(id());
  port_->OnRefreshError();
}

TurnCreatePermissionRequest::TurnCreatePermissionRequest(
    TurnPort* port, TurnEntry* entry,
    const rtc::SocketAddress& ext_addr)
    : StunRequest(new TurnMessage()),
      port_(port),
      entry_(entry),
      ext_addr_(ext_addr) {
  entry_->SignalDestroyed.connect(
      this, &TurnCreatePermissionRequest::OnEntryDestroyed);
}

void TurnCreatePermissionRequest::Prepare(StunMessage* request) {
  // Create the request as indicated in RFC5766, Section 9.1.
  request->SetType(TURN_CREATE_PERMISSION_REQUEST);
  VERIFY(request->AddAttribute(new StunXorAddressAttribute(
      STUN_ATTR_XOR_PEER_ADDRESS, ext_addr_)));
  port_->AddRequestAuthInfo(request);
}

void TurnCreatePermissionRequest::OnSent() {
  LOG_J(LS_INFO, port_) << "TURN create permission request sent"
                        << ", id=" << rtc::hex_encode(id());
  StunRequest::OnSent();
}

void TurnCreatePermissionRequest::OnResponse(StunMessage* response) {
  LOG_J(LS_INFO, port_) << "TURN permission requested successfully"
                        << ", id=" << rtc::hex_encode(id())
                        << ", code=0"  // Makes logging easier to parse.
                        << ", rtt=" << Elapsed();

  if (entry_) {
    entry_->OnCreatePermissionSuccess();
  }
}

void TurnCreatePermissionRequest::OnErrorResponse(StunMessage* response) {
  const StunErrorCodeAttribute* error_code = response->GetErrorCode();
  LOG_J(LS_WARNING, port_) << "Received TURN create permission error response"
                           << ", id=" << rtc::hex_encode(id())
                           << ", code=" << error_code->code()
                           << ", rtt=" << Elapsed();
  if (entry_) {
    entry_->OnCreatePermissionError(response, error_code->code());
  }
}

void TurnCreatePermissionRequest::OnTimeout() {
  LOG_J(LS_WARNING, port_) << "TURN create permission timeout "
                           << rtc::hex_encode(id());
  if (entry_) {
    entry_->OnCreatePermissionTimeout();
  }
}

void TurnCreatePermissionRequest::OnEntryDestroyed(TurnEntry* entry) {
  RTC_DCHECK(entry_ == entry);
  entry_ = NULL;
}

TurnChannelBindRequest::TurnChannelBindRequest(
    TurnPort* port, TurnEntry* entry,
    int channel_id, const rtc::SocketAddress& ext_addr)
    : StunRequest(new TurnMessage()),
      port_(port),
      entry_(entry),
      channel_id_(channel_id),
      ext_addr_(ext_addr) {
  entry_->SignalDestroyed.connect(
      this, &TurnChannelBindRequest::OnEntryDestroyed);
}

void TurnChannelBindRequest::Prepare(StunMessage* request) {
  // Create the request as indicated in RFC5766, Section 11.1.
  request->SetType(TURN_CHANNEL_BIND_REQUEST);
  VERIFY(request->AddAttribute(new StunUInt32Attribute(
      STUN_ATTR_CHANNEL_NUMBER, channel_id_ << 16)));
  VERIFY(request->AddAttribute(new StunXorAddressAttribute(
      STUN_ATTR_XOR_PEER_ADDRESS, ext_addr_)));
  port_->AddRequestAuthInfo(request);
}

void TurnChannelBindRequest::OnSent() {
  LOG_J(LS_INFO, port_) << "TURN channel bind request sent"
                        << ", id=" << rtc::hex_encode(id());
  StunRequest::OnSent();
}

void TurnChannelBindRequest::OnResponse(StunMessage* response) {
  LOG_J(LS_INFO, port_) << "TURN channel bind requested successfully"
                        << ", id=" << rtc::hex_encode(id())
                        << ", code=0"  // Makes logging easier to parse.
                        << ", rtt=" << Elapsed();

  if (entry_) {
    entry_->OnChannelBindSuccess();
    // Refresh the channel binding just under the permission timeout
    // threshold. The channel binding has a longer lifetime, but
    // this is the easiest way to keep both the channel and the
    // permission from expiring.
    int delay = TURN_PERMISSION_TIMEOUT - 60000;
    entry_->SendChannelBindRequest(delay);
    LOG_J(LS_INFO, port_) << "Scheduled channel bind in " << delay << "ms.";
  }
}

void TurnChannelBindRequest::OnErrorResponse(StunMessage* response) {
  const StunErrorCodeAttribute* error_code = response->GetErrorCode();
  LOG_J(LS_WARNING, port_) << "Received TURN channel bind error response"
                           << ", id=" << rtc::hex_encode(id())
                           << ", code=" << error_code->code()
                           << ", rtt=" << Elapsed();
  if (entry_) {
    entry_->OnChannelBindError(response, error_code->code());
  }
}

void TurnChannelBindRequest::OnTimeout() {
  LOG_J(LS_WARNING, port_) << "TURN channel bind timeout "
                           << rtc::hex_encode(id());
  if (entry_) {
    entry_->OnChannelBindTimeout();
  }
}

void TurnChannelBindRequest::OnEntryDestroyed(TurnEntry* entry) {
  RTC_DCHECK(entry_ == entry);
  entry_ = NULL;
}

TurnEntry::TurnEntry(TurnPort* port, int channel_id,
                     const rtc::SocketAddress& ext_addr)
    : port_(port),
      channel_id_(channel_id),
      ext_addr_(ext_addr),
      state_(STATE_UNBOUND) {
  // Creating permission for |ext_addr_|.
  SendCreatePermissionRequest(0);
}

void TurnEntry::SendCreatePermissionRequest(int delay) {
  port_->SendRequest(new TurnCreatePermissionRequest(port_, this, ext_addr_),
                     delay);
}

void TurnEntry::SendChannelBindRequest(int delay) {
  port_->SendRequest(new TurnChannelBindRequest(
      port_, this, channel_id_, ext_addr_), delay);
}

int TurnEntry::Send(const void* data, size_t size, bool payload,
                    const rtc::PacketOptions& options) {
  rtc::ByteBufferWriter buf;
  if (state_ != STATE_BOUND) {
    // If we haven't bound the channel yet, we have to use a Send Indication.
    TurnMessage msg;
    msg.SetType(TURN_SEND_INDICATION);
    msg.SetTransactionID(
        rtc::CreateRandomString(kStunTransactionIdLength));
    VERIFY(msg.AddAttribute(new StunXorAddressAttribute(
        STUN_ATTR_XOR_PEER_ADDRESS, ext_addr_)));
    VERIFY(msg.AddAttribute(new StunByteStringAttribute(
        STUN_ATTR_DATA, data, size)));
    VERIFY(msg.Write(&buf));

    // If we're sending real data, request a channel bind that we can use later.
    if (state_ == STATE_UNBOUND && payload) {
      SendChannelBindRequest(0);
      state_ = STATE_BINDING;
    }
  } else {
    // If the channel is bound, we can send the data as a Channel Message.
    buf.WriteUInt16(channel_id_);
    buf.WriteUInt16(static_cast<uint16_t>(size));
    buf.WriteBytes(reinterpret_cast<const char*>(data), size);
  }
  return port_->Send(buf.Data(), buf.Length(), options);
}

void TurnEntry::OnCreatePermissionSuccess() {
  LOG_J(LS_INFO, port_) << "Create permission for "
                        << ext_addr_.ToSensitiveString()
                        << " succeeded";
  port_->SignalCreatePermissionResult(port_, ext_addr_,
                                      TURN_SUCCESS_RESULT_CODE);

  // If |state_| is STATE_BOUND, the permission will be refreshed
  // by ChannelBindRequest.
  if (state_ != STATE_BOUND) {
    // Refresh the permission request about 1 minute before the permission
    // times out.
    int delay = TURN_PERMISSION_TIMEOUT - 60000;
    SendCreatePermissionRequest(delay);
    LOG_J(LS_INFO, port_) << "Scheduled create-permission-request in "
                          << delay << "ms.";
  }
}

void TurnEntry::OnCreatePermissionError(StunMessage* response, int code) {
  if (code == STUN_ERROR_STALE_NONCE) {
    if (port_->UpdateNonce(response)) {
      SendCreatePermissionRequest(0);
    }
  } else {
    bool found = port_->FailAndPruneConnection(ext_addr_);
    if (found) {
      LOG(LS_ERROR) << "Received TURN CreatePermission error response, "
                    << "code=" << code << "; pruned connection.";
    }
    // Send signal with error code.
    port_->SignalCreatePermissionResult(port_, ext_addr_, code);
  }
}

void TurnEntry::OnCreatePermissionTimeout() {
  port_->FailAndPruneConnection(ext_addr_);
}

void TurnEntry::OnChannelBindSuccess() {
  LOG_J(LS_INFO, port_) << "Channel bind for " << ext_addr_.ToSensitiveString()
                        << " succeeded";
  RTC_DCHECK(state_ == STATE_BINDING || state_ == STATE_BOUND);
  state_ = STATE_BOUND;
}

void TurnEntry::OnChannelBindError(StunMessage* response, int code) {
  // If the channel bind fails due to errors other than STATE_NONCE,
  // we will fail and prune the connection and rely on ICE restart to
  // re-establish a new connection if needed.
  if (code == STUN_ERROR_STALE_NONCE) {
    if (port_->UpdateNonce(response)) {
      // Send channel bind request with fresh nonce.
      SendChannelBindRequest(0);
    }
  } else {
    state_ = STATE_UNBOUND;
    port_->FailAndPruneConnection(ext_addr_);
  }
}
void TurnEntry::OnChannelBindTimeout() {
  state_ = STATE_UNBOUND;
  port_->FailAndPruneConnection(ext_addr_);
}
}  // namespace cricket
