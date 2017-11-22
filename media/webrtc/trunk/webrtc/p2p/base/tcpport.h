/*
 *  Copyright 2004 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef WEBRTC_P2P_BASE_TCPPORT_H_
#define WEBRTC_P2P_BASE_TCPPORT_H_

#include <list>
#include <memory>
#include <string>

#include "webrtc/p2p/base/port.h"
#include "webrtc/base/asyncpacketsocket.h"

namespace cricket {

class TCPConnection;

// Communicates using a local TCP port.
//
// This class is designed to allow subclasses to take advantage of the
// connection management provided by this class.  A subclass should take of all
// packet sending and preparation, but when a packet is received, it should
// call this TCPPort::OnReadPacket (3 arg) to dispatch to a connection.
class TCPPort : public Port {
 public:
  static TCPPort* Create(rtc::Thread* thread,
                         rtc::PacketSocketFactory* factory,
                         rtc::Network* network,
                         const rtc::IPAddress& ip,
                         uint16_t min_port,
                         uint16_t max_port,
                         const std::string& username,
                         const std::string& password,
                         bool allow_listen) {
    TCPPort* port = new TCPPort(thread, factory, network, ip, min_port,
                                max_port, username, password, allow_listen);
    if (!port->Init()) {
      delete port;
      port = NULL;
    }
    return port;
  }
  ~TCPPort() override;

  Connection* CreateConnection(const Candidate& address,
                               CandidateOrigin origin) override;

  void PrepareAddress() override;

  int GetOption(rtc::Socket::Option opt, int* value) override;
  int SetOption(rtc::Socket::Option opt, int value) override;
  int GetError() override;
  bool SupportsProtocol(const std::string& protocol) const override {
    return protocol == TCP_PROTOCOL_NAME || protocol == SSLTCP_PROTOCOL_NAME;
  }

  ProtocolType GetProtocol() const override { return PROTO_TCP; }

 protected:
  TCPPort(rtc::Thread* thread,
          rtc::PacketSocketFactory* factory,
          rtc::Network* network,
          const rtc::IPAddress& ip,
          uint16_t min_port,
          uint16_t max_port,
          const std::string& username,
          const std::string& password,
          bool allow_listen);
  bool Init();

  // Handles sending using the local TCP socket.
  int SendTo(const void* data,
             size_t size,
             const rtc::SocketAddress& addr,
             const rtc::PacketOptions& options,
             bool payload) override;

  // Accepts incoming TCP connection.
  void OnNewConnection(rtc::AsyncPacketSocket* socket,
                       rtc::AsyncPacketSocket* new_socket);

 private:
  struct Incoming {
    rtc::SocketAddress addr;
    rtc::AsyncPacketSocket* socket;
  };

  rtc::AsyncPacketSocket* GetIncoming(
      const rtc::SocketAddress& addr, bool remove = false);

  // Receives packet signal from the local TCP Socket.
  void OnReadPacket(rtc::AsyncPacketSocket* socket,
                    const char* data, size_t size,
                    const rtc::SocketAddress& remote_addr,
                    const rtc::PacketTime& packet_time);

  void OnSentPacket(rtc::AsyncPacketSocket* socket,
                    const rtc::SentPacket& sent_packet) override;

  void OnReadyToSend(rtc::AsyncPacketSocket* socket);

  void OnAddressReady(rtc::AsyncPacketSocket* socket,
                      const rtc::SocketAddress& address);

  // TODO: Is this still needed?
  bool incoming_only_;
  bool allow_listen_;
  rtc::AsyncPacketSocket* socket_;
  int error_;
  std::list<Incoming> incoming_;

  friend class TCPConnection;
};

class TCPConnection : public Connection {
 public:
  // Connection is outgoing unless socket is specified
  TCPConnection(TCPPort* port, const Candidate& candidate,
                rtc::AsyncPacketSocket* socket = 0);
  ~TCPConnection() override;

  int Send(const void* data,
           size_t size,
           const rtc::PacketOptions& options) override;
  int GetError() override;

  rtc::AsyncPacketSocket* socket() { return socket_.get(); }

  void OnMessage(rtc::Message* pmsg) override;

  // Allow test cases to overwrite the default timeout period.
  int reconnection_timeout() const { return reconnection_timeout_; }
  void set_reconnection_timeout(int timeout_in_ms) {
    reconnection_timeout_ = timeout_in_ms;
  }

 protected:
  enum {
    MSG_TCPCONNECTION_DELAYED_ONCLOSE = Connection::MSG_FIRST_AVAILABLE,
  };

  // Set waiting_for_stun_binding_complete_ to false to allow data packets in
  // addition to what Port::OnConnectionRequestResponse does.
  void OnConnectionRequestResponse(ConnectionRequest* req,
                                   StunMessage* response) override;

 private:
  // Helper function to handle the case when Ping or Send fails with error
  // related to socket close.
  void MaybeReconnect();

  void CreateOutgoingTcpSocket();

  void ConnectSocketSignals(rtc::AsyncPacketSocket* socket);

  void OnConnect(rtc::AsyncPacketSocket* socket);
  void OnClose(rtc::AsyncPacketSocket* socket, int error);
  void OnReadPacket(rtc::AsyncPacketSocket* socket,
                    const char* data, size_t size,
                    const rtc::SocketAddress& remote_addr,
                    const rtc::PacketTime& packet_time);
  void OnReadyToSend(rtc::AsyncPacketSocket* socket);

  std::unique_ptr<rtc::AsyncPacketSocket> socket_;
  int error_;
  bool outgoing_;

  // Guard against multiple outgoing tcp connection during a reconnect.
  bool connection_pending_;

  // Guard against data packets sent when we reconnect a TCP connection. During
  // reconnecting, when a new tcp connection has being made, we can't send data
  // packets out until the STUN binding is completed (i.e. the write state is
  // set to WRITABLE again by Connection::OnConnectionRequestResponse). IPC
  // socket, when receiving data packets before that, will trigger OnError which
  // will terminate the newly created connection.
  bool pretending_to_be_writable_;

  // Allow test case to overwrite the default timeout period.
  int reconnection_timeout_;

  friend class TCPPort;
};

}  // namespace cricket

#endif  // WEBRTC_P2P_BASE_TCPPORT_H_
