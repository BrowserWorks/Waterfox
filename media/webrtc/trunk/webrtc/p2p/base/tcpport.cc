/*
 *  Copyright 2004 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

/*
 *  This is a diagram of how TCP reconnect works for the active side. The
 *  passive side just waits for an incoming connection.
 *
 *  - Connected: Indicate whether the TCP socket is connected.
 *
 *  - Writable: Whether the stun binding is completed. Sending a data packet
 *    before stun binding completed will trigger IPC socket layer to shutdown
 *    the connection.
 *
 *  - PendingTCP: |connection_pending_| indicates whether there is an
 *    outstanding TCP connection in progress.
 *
 *  - PretendWri: Tracked by |pretending_to_be_writable_|. Marking connection as
 *    WRITE_TIMEOUT will cause the connection be deleted. Instead, we're
 *    "pretending" we're still writable for a period of time such that reconnect
 *    could work.
 *
 *  Data could only be sent in state 3. Sening data during state 2 & 6 will get
 *  EWOULDBLOCK, 4 & 5 EPIPE.
 *
 *         OS Timeout         7 -------------+
 *   +----------------------->|Connected: N  |
 *   |                        |Writable:  N  |     Timeout
 *   |       Timeout          |Connection is |<----------------+
 *   |   +------------------->|Dead          |                 |
 *   |   |                    +--------------+                 |
 *   |   |                               ^                     |
 *   |   |            OnClose            |                     |
 *   |   |    +-----------------------+  |                     |
 *   |   |    |                       |  |Timeout              |
 *   |   |    v                       |  |                     |
 *   | 4 +----------+          5 -----+--+--+           6 -----+-----+
 *   | |Connected: N|Send() or |Connected: N|           |Connected: Y|
 *   | |Writable:  Y|Ping()    |Writable:  Y|OnConnect  |Writable:  Y|
 *   | |PendingTCP:N+--------> |PendingTCP:Y+---------> |PendingTCP:N|
 *   | |PretendWri:Y|          |PretendWri:Y|           |PretendWri:Y|
 *   | +-----+------+          +------------+           +---+--+-----+
 *   |   ^   ^                                              |  |
 *   |   |   |                     OnClose                  |  |
 *   |   |   +----------------------------------------------+  |
 *   |   |                                                     |
 *   |   |                              Stun Binding Completed |
 *   |   |                                                     |
 *   |   |                    OnClose                          |
 *   |   +------------------------------------------------+    |
 *   |                                                    |    v
 *  1 -----------+           2 -----------+Stun      3 -----------+
 *  |Connected: N|           |Connected: Y|Binding   |Connected: Y|
 *  |Writable:  N|OnConnect  |Writable:  N|Completed |Writable:  Y|
 *  |PendingTCP:Y+---------> |PendingTCP:N+--------> |PendingTCP:N|
 *  |PretendWri:N|           |PretendWri:N|          |PretendWri:N|
 *  +------------+           +------------+          +------------+
 *
 */

#include "webrtc/p2p/base/tcpport.h"

#include "webrtc/p2p/base/common.h"
#include "webrtc/base/checks.h"
#include "webrtc/base/common.h"
#include "webrtc/base/logging.h"

namespace cricket {

TCPPort::TCPPort(rtc::Thread* thread,
                 rtc::PacketSocketFactory* factory,
                 rtc::Network* network,
                 const rtc::IPAddress& ip,
                 uint16_t min_port,
                 uint16_t max_port,
                 const std::string& username,
                 const std::string& password,
                 bool allow_listen)
    : Port(thread,
           LOCAL_PORT_TYPE,
           factory,
           network,
           ip,
           min_port,
           max_port,
           username,
           password),
      incoming_only_(false),
      allow_listen_(allow_listen),
      socket_(NULL),
      error_(0) {
  // TODO(mallinath) - Set preference value as per RFC 6544.
  // http://b/issue?id=7141794
}

bool TCPPort::Init() {
  if (allow_listen_) {
    // Treat failure to create or bind a TCP socket as fatal.  This
    // should never happen.
    socket_ = socket_factory()->CreateServerTcpSocket(
        rtc::SocketAddress(ip(), 0), min_port(), max_port(),
        false /* ssl */);
    if (!socket_) {
      LOG_J(LS_ERROR, this) << "TCP socket creation failed.";
      return false;
    }
    socket_->SignalNewConnection.connect(this, &TCPPort::OnNewConnection);
    socket_->SignalAddressReady.connect(this, &TCPPort::OnAddressReady);
  }
  return true;
}

TCPPort::~TCPPort() {
  delete socket_;
  std::list<Incoming>::iterator it;
  for (it = incoming_.begin(); it != incoming_.end(); ++it)
    delete it->socket;
  incoming_.clear();
}

Connection* TCPPort::CreateConnection(const Candidate& address,
                                      CandidateOrigin origin) {
  if (!SupportsProtocol(address.protocol())) {
    return NULL;
  }

  if (address.tcptype() == TCPTYPE_ACTIVE_STR ||
      (address.tcptype().empty() && address.address().port() == 0)) {
    // It's active only candidate, we should not try to create connections
    // for these candidates.
    return NULL;
  }

  // We can't accept TCP connections incoming on other ports
  if (origin == ORIGIN_OTHER_PORT)
    return NULL;

  // Check if we are allowed to make outgoing TCP connections
  if (incoming_only_ && (origin == ORIGIN_MESSAGE))
    return NULL;

  // We don't know how to act as an ssl server yet
  if ((address.protocol() == SSLTCP_PROTOCOL_NAME) &&
      (origin == ORIGIN_THIS_PORT)) {
    return NULL;
  }

  if (!IsCompatibleAddress(address.address())) {
    return NULL;
  }

  TCPConnection* conn = NULL;
  if (rtc::AsyncPacketSocket* socket =
      GetIncoming(address.address(), true)) {
    socket->SignalReadPacket.disconnect(this);
    conn = new TCPConnection(this, address, socket);
  } else {
    conn = new TCPConnection(this, address);
  }
  AddOrReplaceConnection(conn);
  return conn;
}

void TCPPort::PrepareAddress() {
  if (socket_) {
    // If socket isn't bound yet the address will be added in
    // OnAddressReady(). Socket may be in the CLOSED state if Listen()
    // failed, we still want to add the socket address.
    LOG(LS_VERBOSE) << "Preparing TCP address, current state: "
                    << socket_->GetState();
    if (socket_->GetState() == rtc::AsyncPacketSocket::STATE_BOUND ||
        socket_->GetState() == rtc::AsyncPacketSocket::STATE_CLOSED)
      AddAddress(socket_->GetLocalAddress(), socket_->GetLocalAddress(),
                 rtc::SocketAddress(), TCP_PROTOCOL_NAME, "",
                 TCPTYPE_PASSIVE_STR, LOCAL_PORT_TYPE,
                 ICE_TYPE_PREFERENCE_HOST_TCP, 0, true);
  } else {
    LOG_J(LS_INFO, this) << "Not listening due to firewall restrictions.";
    // Note: We still add the address, since otherwise the remote side won't
    // recognize our incoming TCP connections. According to
    // https://tools.ietf.org/html/rfc6544#section-4.5, for active candidate,
    // the port must be set to the discard port, i.e. 9.
    AddAddress(rtc::SocketAddress(ip(), DISCARD_PORT),
               rtc::SocketAddress(ip(), 0), rtc::SocketAddress(),
               TCP_PROTOCOL_NAME, "", TCPTYPE_ACTIVE_STR, LOCAL_PORT_TYPE,
               ICE_TYPE_PREFERENCE_HOST_TCP, 0, true);
  }
}

int TCPPort::SendTo(const void* data, size_t size,
                    const rtc::SocketAddress& addr,
                    const rtc::PacketOptions& options,
                    bool payload) {
  rtc::AsyncPacketSocket * socket = NULL;
  TCPConnection* conn = static_cast<TCPConnection*>(GetConnection(addr));

  // For Connection, this is the code path used by Ping() to establish
  // WRITABLE. It has to send through the socket directly as TCPConnection::Send
  // checks writability.
  if (conn) {
    if (!conn->connected()) {
      conn->MaybeReconnect();
      return SOCKET_ERROR;
    }
    socket = conn->socket();
  } else {
    socket = GetIncoming(addr);
  }
  if (!socket) {
    LOG_J(LS_ERROR, this) << "Attempted to send to an unknown destination, "
                          << addr.ToSensitiveString();
    return SOCKET_ERROR;  // TODO(tbd): Set error_
  }

  int sent = socket->Send(data, size, options);
  if (sent < 0) {
    error_ = socket->GetError();
    // Error from this code path for a Connection (instead of from a bare
    // socket) will not trigger reconnecting. In theory, this shouldn't matter
    // as OnClose should always be called and set connected to false.
    LOG_J(LS_ERROR, this) << "TCP send of " << size
                          << " bytes failed with error " << error_;
  }
  return sent;
}

int TCPPort::GetOption(rtc::Socket::Option opt, int* value) {
  if (socket_) {
    return socket_->GetOption(opt, value);
  } else {
    return SOCKET_ERROR;
  }
}

int TCPPort::SetOption(rtc::Socket::Option opt, int value) {
  if (socket_) {
    return socket_->SetOption(opt, value);
  } else {
    return SOCKET_ERROR;
  }
}

int TCPPort::GetError() {
  return error_;
}

void TCPPort::OnNewConnection(rtc::AsyncPacketSocket* socket,
                              rtc::AsyncPacketSocket* new_socket) {
  RTC_DCHECK(socket == socket_);

  Incoming incoming;
  incoming.addr = new_socket->GetRemoteAddress();
  incoming.socket = new_socket;
  incoming.socket->SignalReadPacket.connect(this, &TCPPort::OnReadPacket);
  incoming.socket->SignalReadyToSend.connect(this, &TCPPort::OnReadyToSend);
  incoming.socket->SignalSentPacket.connect(this, &TCPPort::OnSentPacket);

  LOG_J(LS_VERBOSE, this) << "Accepted connection from "
                          << incoming.addr.ToSensitiveString();
  incoming_.push_back(incoming);
}

rtc::AsyncPacketSocket* TCPPort::GetIncoming(
    const rtc::SocketAddress& addr, bool remove) {
  rtc::AsyncPacketSocket* socket = NULL;
  for (std::list<Incoming>::iterator it = incoming_.begin();
       it != incoming_.end(); ++it) {
    if (it->addr == addr) {
      socket = it->socket;
      if (remove)
        incoming_.erase(it);
      break;
    }
  }
  return socket;
}

void TCPPort::OnReadPacket(rtc::AsyncPacketSocket* socket,
                           const char* data, size_t size,
                           const rtc::SocketAddress& remote_addr,
                           const rtc::PacketTime& packet_time) {
  Port::OnReadPacket(data, size, remote_addr, PROTO_TCP);
}

void TCPPort::OnSentPacket(rtc::AsyncPacketSocket* socket,
                           const rtc::SentPacket& sent_packet) {
  PortInterface::SignalSentPacket(sent_packet);
}

void TCPPort::OnReadyToSend(rtc::AsyncPacketSocket* socket) {
  Port::OnReadyToSend();
}

void TCPPort::OnAddressReady(rtc::AsyncPacketSocket* socket,
                             const rtc::SocketAddress& address) {
  AddAddress(address, address, rtc::SocketAddress(), TCP_PROTOCOL_NAME, "",
             TCPTYPE_PASSIVE_STR, LOCAL_PORT_TYPE, ICE_TYPE_PREFERENCE_HOST_TCP,
             0, true);
}

TCPConnection::TCPConnection(TCPPort* port,
                             const Candidate& candidate,
                             rtc::AsyncPacketSocket* socket)
    : Connection(port, 0, candidate),
      socket_(socket),
      error_(0),
      outgoing_(socket == NULL),
      connection_pending_(false),
      pretending_to_be_writable_(false),
      reconnection_timeout_(cricket::CONNECTION_WRITE_CONNECT_TIMEOUT) {
  if (outgoing_) {
    CreateOutgoingTcpSocket();
  } else {
    // Incoming connections should match the network address.
    LOG_J(LS_VERBOSE, this)
        << "socket ipaddr: " << socket_->GetLocalAddress().ToString()
        << ",port() ip:" << port->ip().ToString();
    RTC_DCHECK(socket_->GetLocalAddress().ipaddr() == port->ip());
    ConnectSocketSignals(socket);
  }
}

TCPConnection::~TCPConnection() {
}

int TCPConnection::Send(const void* data, size_t size,
                        const rtc::PacketOptions& options) {
  if (!socket_) {
    error_ = ENOTCONN;
    return SOCKET_ERROR;
  }

  // Sending after OnClose on active side will trigger a reconnect for a
  // outgoing connection. Note that the write state is still WRITABLE as we want
  // to spend a few seconds attempting a reconnect before saying we're
  // unwritable.
  if (!connected()) {
    MaybeReconnect();
    return SOCKET_ERROR;
  }

  // Note that this is important to put this after the previous check to give
  // the connection a chance to reconnect.
  if (pretending_to_be_writable_ || write_state() != STATE_WRITABLE) {
    // TODO: Should STATE_WRITE_TIMEOUT return a non-blocking error?
    error_ = ENOTCONN;
    return SOCKET_ERROR;
  }
  stats_.sent_total_packets++;
  int sent = socket_->Send(data, size, options);
  if (sent < 0) {
    stats_.sent_discarded_packets++;
    error_ = socket_->GetError();
  } else {
    send_rate_tracker_.AddSamples(sent);
  }
  return sent;
}

int TCPConnection::GetError() {
  return error_;
}

void TCPConnection::OnConnectionRequestResponse(ConnectionRequest* req,
                                                StunMessage* response) {
  // Process the STUN response before we inform upper layer ready to send.
  Connection::OnConnectionRequestResponse(req, response);

  // If we're in the state of pretending to be writeable, we should inform the
  // upper layer it's ready to send again as previous EWOULDLBLOCK from socket
  // would have stopped the outgoing stream.
  if (pretending_to_be_writable_) {
    Connection::OnReadyToSend();
  }
  pretending_to_be_writable_ = false;
  RTC_DCHECK(write_state() == STATE_WRITABLE);
}

void TCPConnection::OnConnect(rtc::AsyncPacketSocket* socket) {
  RTC_DCHECK(socket == socket_.get());
  // Do not use this connection if the socket bound to a different address than
  // the one we asked for. This is seen in Chrome, where TCP sockets cannot be
  // given a binding address, and the platform is expected to pick the
  // correct local address.
  const rtc::SocketAddress& socket_addr = socket->GetLocalAddress();
  if (socket_addr.ipaddr() == port()->ip()) {
    LOG_J(LS_VERBOSE, this) << "Connection established to "
                            << socket->GetRemoteAddress().ToSensitiveString();
  } else if (IPIsAny(port()->ip())) {
    LOG(LS_WARNING) << "Socket is bound to a different address:"
                    << socket_addr.ipaddr().ToString()
                    << ", rather then the local port:"
                    << port()->ip().ToString()
                    << ". Still allowing it since it's any address"
                    << ", possibly caused by multi-routes being disabled.";
  } else if (socket_addr.IsLoopbackIP()) {
    LOG(LS_WARNING) << "Socket is bound to a different address:"
                    << socket_addr.ipaddr().ToString()
                    << ", rather then the local port:"
                    << port()->ip().ToString()
                    << ". Still allowing it since it's localhost.";
  } else {
    LOG_J(LS_WARNING, this) << "Dropping connection as TCP socket bound to IP "
                            << socket_addr.ipaddr().ToSensitiveString()
                            << ", different from the local candidate IP "
                            << port()->ip().ToSensitiveString();
    OnClose(socket, 0);
    return;
  }

  // Connection is established successfully.
  set_connected(true);
  connection_pending_ = false;
}

void TCPConnection::OnClose(rtc::AsyncPacketSocket* socket, int error) {
  RTC_DCHECK(socket == socket_.get());
  LOG_J(LS_INFO, this) << "Connection closed with error " << error;

  // Guard against the condition where IPC socket will call OnClose for every
  // packet it can't send.
  if (connected()) {
    set_connected(false);

    // Prevent the connection from being destroyed by redundant SignalClose
    // events.
    pretending_to_be_writable_ = true;

    // We don't attempt reconnect right here. This is to avoid a case where the
    // shutdown is intentional and reconnect is not necessary. We only reconnect
    // when the connection is used to Send() or Ping().
    port()->thread()->PostDelayed(RTC_FROM_HERE, reconnection_timeout(), this,
                                  MSG_TCPCONNECTION_DELAYED_ONCLOSE);
  } else if (!pretending_to_be_writable_) {
    // OnClose could be called when the underneath socket times out during the
    // initial connect() (i.e. |pretending_to_be_writable_| is false) . We have
    // to manually destroy here as this connection, as never connected, will not
    // be scheduled for ping to trigger destroy.
    Destroy();
  }
}

void TCPConnection::OnMessage(rtc::Message* pmsg) {
  switch (pmsg->message_id) {
    case MSG_TCPCONNECTION_DELAYED_ONCLOSE:
      // If this connection can't become connected and writable again in 5
      // seconds, it's time to tear this down. This is the case for the original
      // TCP connection on passive side during a reconnect.
      if (pretending_to_be_writable_) {
        Destroy();
      }
      break;
    default:
      Connection::OnMessage(pmsg);
  }
}

void TCPConnection::MaybeReconnect() {
  // Only reconnect for an outgoing TCPConnection when OnClose was signaled and
  // no outstanding reconnect is pending.
  if (connected() || connection_pending_ || !outgoing_) {
    return;
  }

  LOG_J(LS_INFO, this) << "TCP Connection with remote is closed, "
                       << "trying to reconnect";

  CreateOutgoingTcpSocket();
  error_ = EPIPE;
}

void TCPConnection::OnReadPacket(
  rtc::AsyncPacketSocket* socket, const char* data, size_t size,
  const rtc::SocketAddress& remote_addr,
  const rtc::PacketTime& packet_time) {
  RTC_DCHECK(socket == socket_.get());
  Connection::OnReadPacket(data, size, packet_time);
}

void TCPConnection::OnReadyToSend(rtc::AsyncPacketSocket* socket) {
  RTC_DCHECK(socket == socket_.get());
  Connection::OnReadyToSend();
}

void TCPConnection::CreateOutgoingTcpSocket() {
  RTC_DCHECK(outgoing_);
  // TODO(guoweis): Handle failures here (unlikely since TCP).
  int opts = (remote_candidate().protocol() == SSLTCP_PROTOCOL_NAME)
                 ? rtc::PacketSocketFactory::OPT_TLS_FAKE
                 : 0;
  socket_.reset(port()->socket_factory()->CreateClientTcpSocket(
      rtc::SocketAddress(port()->ip(), 0), remote_candidate().address(),
      port()->proxy(), port()->user_agent(), opts));
  if (socket_) {
    LOG_J(LS_VERBOSE, this)
        << "Connecting from " << socket_->GetLocalAddress().ToSensitiveString()
        << " to " << remote_candidate().address().ToSensitiveString();
    set_connected(false);
    connection_pending_ = true;
    ConnectSocketSignals(socket_.get());
  } else {
    LOG_J(LS_WARNING, this) << "Failed to create connection to "
                            << remote_candidate().address().ToSensitiveString();
  }
}

void TCPConnection::ConnectSocketSignals(rtc::AsyncPacketSocket* socket) {
  if (outgoing_) {
    socket->SignalConnect.connect(this, &TCPConnection::OnConnect);
  }
  socket->SignalReadPacket.connect(this, &TCPConnection::OnReadPacket);
  socket->SignalReadyToSend.connect(this, &TCPConnection::OnReadyToSend);
  socket->SignalClose.connect(this, &TCPConnection::OnClose);
}

}  // namespace cricket
