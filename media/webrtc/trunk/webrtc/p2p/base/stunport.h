/*
 *  Copyright 2004 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef WEBRTC_P2P_BASE_STUNPORT_H_
#define WEBRTC_P2P_BASE_STUNPORT_H_

#include <memory>
#include <string>

#include "webrtc/p2p/base/port.h"
#include "webrtc/p2p/base/stunrequest.h"
#include "webrtc/base/asyncpacketsocket.h"

// TODO(mallinath) - Rename stunport.cc|h to udpport.cc|h.
namespace rtc {
class AsyncResolver;
class SignalThread;
}

namespace cricket {

// Lifetime chosen for STUN ports on low-cost networks.
static const int INFINITE_LIFETIME = -1;
// Lifetime for STUN ports on high-cost networks: 2 minutes
static const int HIGH_COST_PORT_KEEPALIVE_LIFETIME = 2 * 60 * 1000;

// Communicates using the address on the outside of a NAT.
class UDPPort : public Port {
 public:
  static UDPPort* Create(rtc::Thread* thread,
                         rtc::PacketSocketFactory* factory,
                         rtc::Network* network,
                         rtc::AsyncPacketSocket* socket,
                         const std::string& username,
                         const std::string& password,
                         const std::string& origin,
                         bool emit_local_for_anyaddress) {
    UDPPort* port = new UDPPort(thread, factory, network, socket, username,
                                password, origin, emit_local_for_anyaddress);
    if (!port->Init()) {
      delete port;
      port = NULL;
    }
    return port;
  }

  static UDPPort* Create(rtc::Thread* thread,
                         rtc::PacketSocketFactory* factory,
                         rtc::Network* network,
                         const rtc::IPAddress& ip,
                         uint16_t min_port,
                         uint16_t max_port,
                         const std::string& username,
                         const std::string& password,
                         const std::string& origin,
                         bool emit_local_for_anyaddress) {
    UDPPort* port =
        new UDPPort(thread, factory, network, ip, min_port, max_port, username,
                    password, origin, emit_local_for_anyaddress);
    if (!port->Init()) {
      delete port;
      port = NULL;
    }
    return port;
  }

  virtual ~UDPPort();

  rtc::SocketAddress GetLocalAddress() const {
    return socket_->GetLocalAddress();
  }

  const ServerAddresses& server_addresses() const {
    return server_addresses_;
  }
  void set_server_addresses(const ServerAddresses& addresses) {
    server_addresses_ = addresses;
  }

  virtual void PrepareAddress();

  virtual Connection* CreateConnection(const Candidate& address,
                                       CandidateOrigin origin);
  virtual int SetOption(rtc::Socket::Option opt, int value);
  virtual int GetOption(rtc::Socket::Option opt, int* value);
  virtual int GetError();

  virtual bool HandleIncomingPacket(
      rtc::AsyncPacketSocket* socket, const char* data, size_t size,
      const rtc::SocketAddress& remote_addr,
      const rtc::PacketTime& packet_time) {
    // All packets given to UDP port will be consumed.
    OnReadPacket(socket, data, size, remote_addr, packet_time);
    return true;
  }
  virtual bool SupportsProtocol(const std::string& protocol) const {
    return protocol == UDP_PROTOCOL_NAME;
  }

  virtual ProtocolType GetProtocol() const { return PROTO_UDP; }

  void set_stun_keepalive_delay(int delay) {
    stun_keepalive_delay_ = delay;
  }
  int stun_keepalive_delay() const {
    return stun_keepalive_delay_;
  }

  // Visible for testing.
  int stun_keepalive_lifetime() const { return stun_keepalive_lifetime_; }
  void set_stun_keepalive_lifetime(int lifetime) {
    stun_keepalive_lifetime_ = lifetime;
  }
  // Returns true if there is a pending request with type |msg_type|.
  bool HasPendingRequest(int msg_type) {
    return requests_.HasRequest(msg_type);
  }

 protected:
  UDPPort(rtc::Thread* thread,
          rtc::PacketSocketFactory* factory,
          rtc::Network* network,
          const rtc::IPAddress& ip,
          uint16_t min_port,
          uint16_t max_port,
          const std::string& username,
          const std::string& password,
          const std::string& origin,
          bool emit_local_for_anyaddress);

  UDPPort(rtc::Thread* thread,
          rtc::PacketSocketFactory* factory,
          rtc::Network* network,
          rtc::AsyncPacketSocket* socket,
          const std::string& username,
          const std::string& password,
          const std::string& origin,
          bool emit_local_for_anyaddress);

  bool Init();

  virtual int SendTo(const void* data, size_t size,
                     const rtc::SocketAddress& addr,
                     const rtc::PacketOptions& options,
                     bool payload);

  virtual void UpdateNetworkCost();

  void OnLocalAddressReady(rtc::AsyncPacketSocket* socket,
                           const rtc::SocketAddress& address);
  void OnReadPacket(rtc::AsyncPacketSocket* socket,
                    const char* data, size_t size,
                    const rtc::SocketAddress& remote_addr,
                    const rtc::PacketTime& packet_time);

  void OnSentPacket(rtc::AsyncPacketSocket* socket,
                    const rtc::SentPacket& sent_packet);

  void OnReadyToSend(rtc::AsyncPacketSocket* socket);

  // This method will send STUN binding request if STUN server address is set.
  void MaybePrepareStunCandidate();

  void SendStunBindingRequests();

  // Helper function which will set |addr|'s IP to the default local address if
  // |addr| is the "any" address and |emit_local_for_anyaddress_| is true. When
  // returning false, it indicates that the operation has failed and the
  // address shouldn't be used by any candidate.
  bool MaybeSetDefaultLocalAddress(rtc::SocketAddress* addr) const;

 private:
  // A helper class which can be called repeatedly to resolve multiple
  // addresses, as opposed to rtc::AsyncResolverInterface, which can only
  // resolve one address per instance.
  class AddressResolver : public sigslot::has_slots<> {
   public:
    explicit AddressResolver(rtc::PacketSocketFactory* factory);
    ~AddressResolver();

    void Resolve(const rtc::SocketAddress& address);
    bool GetResolvedAddress(const rtc::SocketAddress& input,
                            int family,
                            rtc::SocketAddress* output) const;

    // The signal is sent when resolving the specified address is finished. The
    // first argument is the input address, the second argument is the error
    // or 0 if it succeeded.
    sigslot::signal2<const rtc::SocketAddress&, int> SignalDone;

   private:
    typedef std::map<rtc::SocketAddress,
                     rtc::AsyncResolverInterface*> ResolverMap;

    void OnResolveResult(rtc::AsyncResolverInterface* resolver);

    rtc::PacketSocketFactory* socket_factory_;
    ResolverMap resolvers_;
  };

  // DNS resolution of the STUN server.
  void ResolveStunAddress(const rtc::SocketAddress& stun_addr);
  void OnResolveResult(const rtc::SocketAddress& input, int error);

  void SendStunBindingRequest(const rtc::SocketAddress& stun_addr);

  // Below methods handles binding request responses.
  void OnStunBindingRequestSucceeded(
      const rtc::SocketAddress& stun_server_addr,
      const rtc::SocketAddress& stun_reflected_addr);
  void OnStunBindingOrResolveRequestFailed(
      const rtc::SocketAddress& stun_server_addr);

  // Sends STUN requests to the server.
  void OnSendPacket(const void* data, size_t size, StunRequest* req);

  // TODO(mallinaht) - Move this up to cricket::Port when SignalAddressReady is
  // changed to SignalPortReady.
  void MaybeSetPortCompleteOrError();

  bool HasCandidateWithAddress(const rtc::SocketAddress& addr) const;

  // If this is a low-cost network, it will keep on sending STUN binding
  // requests indefinitely to keep the NAT binding alive. Otherwise, stop
  // sending STUN binding requests after HIGH_COST_PORT_KEEPALIVE_LIFETIME.
  int GetStunKeepaliveLifetime() {
    return (network_cost() >= rtc::kNetworkCostHigh)
               ? HIGH_COST_PORT_KEEPALIVE_LIFETIME
               : INFINITE_LIFETIME;
  }

  ServerAddresses server_addresses_;
  ServerAddresses bind_request_succeeded_servers_;
  ServerAddresses bind_request_failed_servers_;
  StunRequestManager requests_;
  rtc::AsyncPacketSocket* socket_;
  int error_;
  std::unique_ptr<AddressResolver> resolver_;
  bool ready_;
  int stun_keepalive_delay_;
  int stun_keepalive_lifetime_ = INFINITE_LIFETIME;

  // This is true by default and false when
  // PORTALLOCATOR_DISABLE_DEFAULT_LOCAL_CANDIDATE is specified.
  bool emit_local_for_anyaddress_;

  friend class StunBindingRequest;
};

class StunPort : public UDPPort {
 public:
  static StunPort* Create(rtc::Thread* thread,
                          rtc::PacketSocketFactory* factory,
                          rtc::Network* network,
                          const rtc::IPAddress& ip,
                          uint16_t min_port,
                          uint16_t max_port,
                          const std::string& username,
                          const std::string& password,
                          const ServerAddresses& servers,
                          const std::string& origin) {
    StunPort* port = new StunPort(thread, factory, network,
                                  ip, min_port, max_port,
                                  username, password, servers,
                                  origin);
    if (!port->Init()) {
      delete port;
      port = NULL;
    }
    return port;
  }

  virtual ~StunPort() {}

  virtual void PrepareAddress() {
    SendStunBindingRequests();
  }

 protected:
  StunPort(rtc::Thread* thread,
           rtc::PacketSocketFactory* factory,
           rtc::Network* network,
           const rtc::IPAddress& ip,
           uint16_t min_port,
           uint16_t max_port,
           const std::string& username,
           const std::string& password,
           const ServerAddresses& servers,
           const std::string& origin)
      : UDPPort(thread,
                factory,
                network,
                ip,
                min_port,
                max_port,
                username,
                password,
                origin,
                false) {
    // UDPPort will set these to local udp, updating these to STUN.
    set_type(STUN_PORT_TYPE);
    set_server_addresses(servers);
  }
};

}  // namespace cricket

#endif  // WEBRTC_P2P_BASE_STUNPORT_H_
