/*
 *  Copyright 2009 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include <algorithm>
#include <memory>

#include "webrtc/p2p/base/basicpacketsocketfactory.h"
#include "webrtc/p2p/base/p2pconstants.h"
#include "webrtc/p2p/base/p2ptransportchannel.h"
#include "webrtc/p2p/base/testrelayserver.h"
#include "webrtc/p2p/base/teststunserver.h"
#include "webrtc/p2p/base/testturnserver.h"
#include "webrtc/p2p/client/basicportallocator.h"
#include "webrtc/base/fakenetwork.h"
#include "webrtc/base/firewallsocketserver.h"
#include "webrtc/base/gunit.h"
#include "webrtc/base/helpers.h"
#include "webrtc/base/ipaddress.h"
#include "webrtc/base/logging.h"
#include "webrtc/base/natserver.h"
#include "webrtc/base/natsocketfactory.h"
#include "webrtc/base/network.h"
#include "webrtc/base/physicalsocketserver.h"
#include "webrtc/base/socketaddress.h"
#include "webrtc/base/ssladapter.h"
#include "webrtc/base/thread.h"
#include "webrtc/base/virtualsocketserver.h"

using rtc::IPAddress;
using rtc::SocketAddress;
using rtc::Thread;

static const SocketAddress kAnyAddr("0.0.0.0", 0);
static const SocketAddress kClientAddr("11.11.11.11", 0);
static const SocketAddress kClientAddr2("22.22.22.22", 0);
static const SocketAddress kLoopbackAddr("127.0.0.1", 0);
static const SocketAddress kPrivateAddr("192.168.1.11", 0);
static const SocketAddress kPrivateAddr2("192.168.1.12", 0);
static const SocketAddress kClientIPv6Addr("2401:fa00:4:1000:be30:5bff:fee5:c3",
                                           0);
static const SocketAddress kClientIPv6Addr2(
    "2401:fa00:4:2000:be30:5bff:fee5:c3",
    0);
static const SocketAddress kNatUdpAddr("77.77.77.77", rtc::NAT_SERVER_UDP_PORT);
static const SocketAddress kNatTcpAddr("77.77.77.77", rtc::NAT_SERVER_TCP_PORT);
static const SocketAddress kRemoteClientAddr("22.22.22.22", 0);
static const SocketAddress kStunAddr("99.99.99.1", cricket::STUN_SERVER_PORT);
static const SocketAddress kRelayUdpIntAddr("99.99.99.2", 5000);
static const SocketAddress kRelayUdpExtAddr("99.99.99.3", 5001);
static const SocketAddress kRelayTcpIntAddr("99.99.99.2", 5002);
static const SocketAddress kRelayTcpExtAddr("99.99.99.3", 5003);
static const SocketAddress kRelaySslTcpIntAddr("99.99.99.2", 5004);
static const SocketAddress kRelaySslTcpExtAddr("99.99.99.3", 5005);
static const SocketAddress kTurnUdpIntAddr("99.99.99.4", 3478);
static const SocketAddress kTurnUdpIntIPv6Addr(
    "2402:fb00:4:1000:be30:5bff:fee5:c3",
    3479);
static const SocketAddress kTurnTcpIntAddr("99.99.99.5", 3478);
static const SocketAddress kTurnTcpIntIPv6Addr(
    "2402:fb00:4:2000:be30:5bff:fee5:c3",
    3479);
static const SocketAddress kTurnUdpExtAddr("99.99.99.6", 0);

// Minimum and maximum port for port range tests.
static const int kMinPort = 10000;
static const int kMaxPort = 10099;

// Based on ICE_UFRAG_LENGTH
static const char kIceUfrag0[] = "UF00";
// Based on ICE_PWD_LENGTH
static const char kIcePwd0[] = "TESTICEPWD00000000000000";

static const char kContentName[] = "test content";

static const int kDefaultAllocationTimeout = 3000;
static const char kTurnUsername[] = "test";
static const char kTurnPassword[] = "test";

// STUN timeout (with all retries) is 9500ms.
// Add some margin of error for slow bots.
// TODO(deadbeef): Use simulated clock instead of just increasing timeouts to
// fix flaky tests.
static const int kStunTimeoutMs = 15000;

namespace cricket {

// Helper for dumping candidates
std::ostream& operator<<(std::ostream& os,
                         const std::vector<Candidate>& candidates) {
  os << '[';
  bool first = true;
  for (const Candidate& c : candidates) {
    if (!first) {
      os << ", ";
    }
    os << c.ToString();
    first = false;
  };
  os << ']';
  return os;
}

class BasicPortAllocatorTest : public testing::Test,
                               public sigslot::has_slots<> {
 public:
  BasicPortAllocatorTest()
      : pss_(new rtc::PhysicalSocketServer),
        vss_(new rtc::VirtualSocketServer(pss_.get())),
        fss_(new rtc::FirewallSocketServer(vss_.get())),
        ss_scope_(fss_.get()),
        // Note that the NAT is not used by default. ResetWithStunServerAndNat
        // must be called.
        nat_factory_(vss_.get(), kNatUdpAddr, kNatTcpAddr),
        nat_socket_factory_(new rtc::BasicPacketSocketFactory(&nat_factory_)),
        stun_server_(TestStunServer::Create(Thread::Current(), kStunAddr)),
        relay_server_(Thread::Current(),
                      kRelayUdpIntAddr,
                      kRelayUdpExtAddr,
                      kRelayTcpIntAddr,
                      kRelayTcpExtAddr,
                      kRelaySslTcpIntAddr,
                      kRelaySslTcpExtAddr),
        turn_server_(Thread::Current(), kTurnUdpIntAddr, kTurnUdpExtAddr),
        candidate_allocation_done_(false) {
    ServerAddresses stun_servers;
    stun_servers.insert(kStunAddr);
    // Passing the addresses of GTURN servers will enable GTURN in
    // Basicportallocator.
    // TODO(deadbeef): Stop using GTURN by default in this test... Either the
    // configuration should be blank by default (preferred), or it should use
    // TURN instead.
    allocator_.reset(new BasicPortAllocator(&network_manager_, stun_servers,
                                            kRelayUdpIntAddr, kRelayTcpIntAddr,
                                            kRelaySslTcpIntAddr));
    allocator_->set_step_delay(kMinimumStepDelay);
  }

  void AddInterface(const SocketAddress& addr) {
    network_manager_.AddInterface(addr);
  }
  void AddInterface(const SocketAddress& addr, const std::string& if_name) {
    network_manager_.AddInterface(addr, if_name);
  }
  void AddInterface(const SocketAddress& addr,
                    const std::string& if_name,
                    rtc::AdapterType type) {
    network_manager_.AddInterface(addr, if_name, type);
  }
  // The default route is the public address that STUN server will observe when
  // the endpoint is sitting on the public internet and the local port is bound
  // to the "any" address. This may be different from the default local address
  // which the endpoint observes. This can occur if the route to the public
  // endpoint like 8.8.8.8 (specified as the default local address) is
  // different from the route to the STUN server (the default route).
  void AddInterfaceAsDefaultRoute(const SocketAddress& addr) {
    AddInterface(addr);
    // When a binding comes from the any address, the |addr| will be used as the
    // srflx address.
    vss_->SetDefaultRoute(addr.ipaddr());
  }
  void RemoveInterface(const SocketAddress& addr) {
    network_manager_.RemoveInterface(addr);
  }
  bool SetPortRange(int min_port, int max_port) {
    return allocator_->SetPortRange(min_port, max_port);
  }
  // Endpoint is on the public network. No STUN or TURN.
  void ResetWithNoServersOrNat() {
    allocator_.reset(new BasicPortAllocator(&network_manager_));
    allocator_->set_step_delay(kMinimumStepDelay);
  }
  // Endpoint is behind a NAT, with STUN specified.
  void ResetWithStunServerAndNat(const rtc::SocketAddress& stun_server) {
    ResetWithStunServer(stun_server, true);
  }
  // Endpoint is on the public network, with STUN specified.
  void ResetWithStunServerNoNat(const rtc::SocketAddress& stun_server) {
    ResetWithStunServer(stun_server, false);
  }
  // Endpoint is on the public network, with TURN specified.
  void ResetWithTurnServersNoNat(const rtc::SocketAddress& udp_turn,
                                 const rtc::SocketAddress& tcp_turn) {
    ResetWithNoServersOrNat();
    AddTurnServers(udp_turn, tcp_turn);
  }

  void AddTurnServers(const rtc::SocketAddress& udp_turn,
                      const rtc::SocketAddress& tcp_turn) {
    RelayServerConfig turn_server(RELAY_TURN);
    RelayCredentials credentials(kTurnUsername, kTurnPassword);
    turn_server.credentials = credentials;

    if (!udp_turn.IsNil()) {
      turn_server.ports.push_back(ProtocolAddress(udp_turn, PROTO_UDP));
    }
    if (!tcp_turn.IsNil()) {
      turn_server.ports.push_back(ProtocolAddress(tcp_turn, PROTO_TCP));
    }
    allocator_->AddTurnServer(turn_server);
  }

  bool CreateSession(int component) {
    session_ = CreateSession("session", component);
    if (!session_) {
      return false;
    }
    return true;
  }

  bool CreateSession(int component, const std::string& content_name) {
    session_ = CreateSession("session", content_name, component);
    if (!session_) {
      return false;
    }
    return true;
  }

  std::unique_ptr<PortAllocatorSession> CreateSession(const std::string& sid,
                                                      int component) {
    return CreateSession(sid, kContentName, component);
  }

  std::unique_ptr<PortAllocatorSession> CreateSession(
      const std::string& sid,
      const std::string& content_name,
      int component) {
    return CreateSession(sid, content_name, component, kIceUfrag0, kIcePwd0);
  }

  std::unique_ptr<PortAllocatorSession> CreateSession(
      const std::string& sid,
      const std::string& content_name,
      int component,
      const std::string& ice_ufrag,
      const std::string& ice_pwd) {
    std::unique_ptr<PortAllocatorSession> session =
        allocator_->CreateSession(content_name, component, ice_ufrag, ice_pwd);
    session->SignalPortReady.connect(this,
                                     &BasicPortAllocatorTest::OnPortReady);
    session->SignalPortsPruned.connect(this,
                                       &BasicPortAllocatorTest::OnPortsPruned);
    session->SignalCandidatesReady.connect(
        this, &BasicPortAllocatorTest::OnCandidatesReady);
    session->SignalCandidatesRemoved.connect(
        this, &BasicPortAllocatorTest::OnCandidatesRemoved);
    session->SignalCandidatesAllocationDone.connect(
        this, &BasicPortAllocatorTest::OnCandidatesAllocationDone);
    return session;
  }

  // Return true if the addresses are the same, or the port is 0 in |pattern|
  // (acting as a wildcard) and the IPs are the same.
  // Even with a wildcard port, the port of the address should be nonzero if
  // the IP is nonzero.
  static bool AddressMatch(const SocketAddress& address,
                           const SocketAddress& pattern) {
    return address.ipaddr() == pattern.ipaddr() &&
           ((pattern.port() == 0 &&
             (address.port() != 0 || IPIsAny(address.ipaddr()))) ||
            (pattern.port() != 0 && address.port() == pattern.port()));
  }

  // Returns the number of ports that have matching type, protocol and
  // address.
  static int CountPorts(const std::vector<PortInterface*>& ports,
                        const std::string& type,
                        ProtocolType protocol,
                        const SocketAddress& client_addr) {
    return std::count_if(
        ports.begin(), ports.end(),
        [type, protocol, client_addr](PortInterface* port) {
          return port->Type() == type && port->GetProtocol() == protocol &&
                 port->Network()->GetBestIP() == client_addr.ipaddr();
        });
  }

  static int CountCandidates(const std::vector<Candidate>& candidates,
                             const std::string& type,
                             const std::string& proto,
                             const SocketAddress& addr) {
    return std::count_if(candidates.begin(), candidates.end(),
                         [type, proto, addr](const Candidate& c) {
                           return c.type() == type && c.protocol() == proto &&
                                  AddressMatch(c.address(), addr);
                         });
  }

  // Find a candidate and return it.
  static bool FindCandidate(const std::vector<Candidate>& candidates,
                            const std::string& type,
                            const std::string& proto,
                            const SocketAddress& addr,
                            Candidate* found) {
    auto it = std::find_if(candidates.begin(), candidates.end(),
                           [type, proto, addr](const Candidate& c) {
                             return c.type() == type && c.protocol() == proto &&
                                    AddressMatch(c.address(), addr);
                           });
    if (it != candidates.end() && found) {
      *found = *it;
    }
    return it != candidates.end();
  }

  // Convenience method to call FindCandidate with no return.
  static bool HasCandidate(const std::vector<Candidate>& candidates,
                           const std::string& type,
                           const std::string& proto,
                           const SocketAddress& addr) {
    return FindCandidate(candidates, type, proto, addr, nullptr);
  }

  // Version of HasCandidate that also takes a related address.
  static bool HasCandidateWithRelatedAddr(
      const std::vector<Candidate>& candidates,
      const std::string& type,
      const std::string& proto,
      const SocketAddress& addr,
      const SocketAddress& related_addr) {
    auto it =
        std::find_if(candidates.begin(), candidates.end(),
                     [type, proto, addr, related_addr](const Candidate& c) {
                       return c.type() == type && c.protocol() == proto &&
                              AddressMatch(c.address(), addr) &&
                              AddressMatch(c.related_address(), related_addr);
                     });
    return it != candidates.end();
  }

  static bool CheckPort(const rtc::SocketAddress& addr,
                        int min_port,
                        int max_port) {
    return (addr.port() >= min_port && addr.port() <= max_port);
  }

  void OnCandidatesAllocationDone(PortAllocatorSession* session) {
    // We should only get this callback once, except in the mux test where
    // we have multiple port allocation sessions.
    if (session == session_.get()) {
      ASSERT_FALSE(candidate_allocation_done_);
      candidate_allocation_done_ = true;
    }
    EXPECT_TRUE(session->CandidatesAllocationDone());
  }

  // Check if all ports allocated have send-buffer size |expected|. If
  // |expected| == -1, check if GetOptions returns SOCKET_ERROR.
  void CheckSendBufferSizesOfAllPorts(int expected) {
    std::vector<PortInterface*>::iterator it;
    for (it = ports_.begin(); it < ports_.end(); ++it) {
      int send_buffer_size;
      if (expected == -1) {
        EXPECT_EQ(SOCKET_ERROR,
                  (*it)->GetOption(rtc::Socket::OPT_SNDBUF, &send_buffer_size));
      } else {
        EXPECT_EQ(0,
                  (*it)->GetOption(rtc::Socket::OPT_SNDBUF, &send_buffer_size));
        ASSERT_EQ(expected, send_buffer_size);
      }
    }
  }

  // This function starts the port/address gathering and check the existence of
  // candidates as specified. When |expect_stun_candidate| is true,
  // |stun_candidate_addr| carries the expected reflective address, which is
  // also the related address for TURN candidate if it is expected. Otherwise,
  // it should be ignore.
  void CheckDisableAdapterEnumeration(
      uint32_t total_ports,
      const rtc::IPAddress& host_candidate_addr,
      const rtc::IPAddress& stun_candidate_addr,
      const rtc::IPAddress& relay_candidate_udp_transport_addr,
      const rtc::IPAddress& relay_candidate_tcp_transport_addr) {
    network_manager_.set_default_local_addresses(kPrivateAddr.ipaddr(),
                                                 rtc::IPAddress());
    if (!session_) {
      EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
    }
    session_->set_flags(session_->flags() |
                        PORTALLOCATOR_DISABLE_ADAPTER_ENUMERATION |
                        PORTALLOCATOR_ENABLE_SHARED_SOCKET);
    allocator().set_allow_tcp_listen(false);
    session_->StartGettingPorts();
    EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);

    uint32_t total_candidates = 0;
    if (!host_candidate_addr.IsNil()) {
      EXPECT_PRED4(HasCandidate, candidates_, "local", "udp",
                   rtc::SocketAddress(kPrivateAddr.ipaddr(), 0));
      ++total_candidates;
    }
    if (!stun_candidate_addr.IsNil()) {
      rtc::SocketAddress related_address(host_candidate_addr, 0);
      if (host_candidate_addr.IsNil()) {
        related_address.SetIP(rtc::GetAnyIP(stun_candidate_addr.family()));
      }
      EXPECT_PRED5(HasCandidateWithRelatedAddr, candidates_, "stun", "udp",
                   rtc::SocketAddress(stun_candidate_addr, 0), related_address);
      ++total_candidates;
    }
    if (!relay_candidate_udp_transport_addr.IsNil()) {
      EXPECT_PRED5(HasCandidateWithRelatedAddr, candidates_, "relay", "udp",
                   rtc::SocketAddress(relay_candidate_udp_transport_addr, 0),
                   rtc::SocketAddress(stun_candidate_addr, 0));
      ++total_candidates;
    }
    if (!relay_candidate_tcp_transport_addr.IsNil()) {
      EXPECT_PRED5(HasCandidateWithRelatedAddr, candidates_, "relay", "udp",
                   rtc::SocketAddress(relay_candidate_tcp_transport_addr, 0),
                   rtc::SocketAddress(stun_candidate_addr, 0));
      ++total_candidates;
    }

    EXPECT_EQ(total_candidates, candidates_.size());
    EXPECT_EQ(total_ports, ports_.size());
  }

  rtc::VirtualSocketServer* virtual_socket_server() { return vss_.get(); }

 protected:
  BasicPortAllocator& allocator() { return *allocator_; }

  void OnPortReady(PortAllocatorSession* ses, PortInterface* port) {
    LOG(LS_INFO) << "OnPortReady: " << port->ToString();
    ports_.push_back(port);
    // Make sure the new port is added to ReadyPorts.
    auto ready_ports = ses->ReadyPorts();
    EXPECT_NE(ready_ports.end(),
              std::find(ready_ports.begin(), ready_ports.end(), port));
  }
  void OnPortsPruned(PortAllocatorSession* ses,
                     const std::vector<PortInterface*>& pruned_ports) {
    LOG(LS_INFO) << "Number of ports pruned: " << pruned_ports.size();
    auto ready_ports = ses->ReadyPorts();
    auto new_end = ports_.end();
    for (PortInterface* port : pruned_ports) {
      new_end = std::remove(ports_.begin(), new_end, port);
      // Make sure the pruned port is not in ReadyPorts.
      EXPECT_EQ(ready_ports.end(),
                std::find(ready_ports.begin(), ready_ports.end(), port));
    }
    ports_.erase(new_end, ports_.end());
  }

  void OnCandidatesReady(PortAllocatorSession* ses,
                         const std::vector<Candidate>& candidates) {
    for (const Candidate& candidate : candidates) {
      LOG(LS_INFO) << "OnCandidatesReady: " << candidate.ToString();
      // Sanity check that the ICE component is set.
      EXPECT_EQ(ICE_CANDIDATE_COMPONENT_RTP, candidate.component());
      candidates_.push_back(candidate);
    }
    // Make sure the new candidates are added to Candidates.
    auto ses_candidates = ses->ReadyCandidates();
    for (const Candidate& candidate : candidates) {
      EXPECT_NE(
          ses_candidates.end(),
          std::find(ses_candidates.begin(), ses_candidates.end(), candidate));
    }
  }

  void OnCandidatesRemoved(PortAllocatorSession* session,
                           const std::vector<Candidate>& removed_candidates) {
    auto new_end = std::remove_if(
        candidates_.begin(), candidates_.end(),
        [removed_candidates](Candidate& candidate) {
          for (const Candidate& removed_candidate : removed_candidates) {
            if (candidate.MatchesForRemoval(removed_candidate)) {
              return true;
            }
          }
          return false;
        });
    candidates_.erase(new_end, candidates_.end());
  }

  bool HasRelayAddress(const ProtocolAddress& proto_addr) {
    for (size_t i = 0; i < allocator_->turn_servers().size(); ++i) {
      RelayServerConfig server_config = allocator_->turn_servers()[i];
      PortList::const_iterator relay_port;
      for (relay_port = server_config.ports.begin();
           relay_port != server_config.ports.end(); ++relay_port) {
        if (proto_addr.address == relay_port->address &&
            proto_addr.proto == relay_port->proto)
          return true;
      }
    }
    return false;
  }

  void ResetWithStunServer(const rtc::SocketAddress& stun_server,
                           bool with_nat) {
    if (with_nat) {
      nat_server_.reset(new rtc::NATServer(
          rtc::NAT_OPEN_CONE, vss_.get(), kNatUdpAddr, kNatTcpAddr, vss_.get(),
          rtc::SocketAddress(kNatUdpAddr.ipaddr(), 0)));
    } else {
      nat_socket_factory_.reset(new rtc::BasicPacketSocketFactory());
    }

    ServerAddresses stun_servers;
    if (!stun_server.IsNil()) {
      stun_servers.insert(stun_server);
    }
    allocator_.reset(new BasicPortAllocator(
        &network_manager_, nat_socket_factory_.get(), stun_servers));
    allocator().set_step_delay(kMinimumStepDelay);
  }

  void TestUdpTurnPortPrunesTcpTurnPort() {
    turn_server_.AddInternalSocket(kTurnTcpIntAddr, PROTO_TCP);
    AddInterface(kClientAddr);
    allocator_.reset(new BasicPortAllocator(&network_manager_));
    allocator_->SetConfiguration(allocator_->stun_servers(),
                                 allocator_->turn_servers(), 0, true);
    AddTurnServers(kTurnUdpIntAddr, kTurnTcpIntAddr);
    allocator_->set_step_delay(kMinimumStepDelay);
    allocator_->set_flags(allocator().flags() |
                          PORTALLOCATOR_ENABLE_SHARED_SOCKET |
                          PORTALLOCATOR_DISABLE_TCP);

    EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
    session_->StartGettingPorts();
    EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);
    // Only 2 ports (one STUN and one TURN) are actually being used.
    EXPECT_EQ(2U, session_->ReadyPorts().size());
    // We have verified that each port, when it is added to |ports_|, it is
    // found in |ready_ports|, and when it is pruned, it is not found in
    // |ready_ports|, so we only need to verify the content in one of them.
    EXPECT_EQ(2U, ports_.size());
    EXPECT_EQ(1, CountPorts(ports_, "local", PROTO_UDP, kClientAddr));
    EXPECT_EQ(1, CountPorts(ports_, "relay", PROTO_UDP, kClientAddr));
    EXPECT_EQ(0, CountPorts(ports_, "relay", PROTO_TCP, kClientAddr));

    // Now that we remove candidates when a TURN port is pruned, |candidates_|
    // should only contains two candidates regardless whether the TCP TURN port
    // is created before or after the UDP turn port.
    EXPECT_EQ(2U, candidates_.size());
    // There will only be 2 candidates in |ready_candidates| because it only
    // includes the candidates in the ready ports.
    const std::vector<Candidate>& ready_candidates =
        session_->ReadyCandidates();
    EXPECT_EQ(2U, ready_candidates.size());
    EXPECT_PRED4(HasCandidate, ready_candidates, "local", "udp", kClientAddr);
    EXPECT_PRED4(HasCandidate, ready_candidates, "relay", "udp",
                 rtc::SocketAddress(kTurnUdpExtAddr.ipaddr(), 0));
  }

  void TestIPv6TurnPortPrunesIPv4TurnPort() {
    turn_server_.AddInternalSocket(kTurnUdpIntIPv6Addr, PROTO_UDP);
    // Add two IP addresses on the same interface.
    AddInterface(kClientAddr, "net1");
    AddInterface(kClientIPv6Addr, "net1");
    allocator_.reset(new BasicPortAllocator(&network_manager_));
    allocator_->SetConfiguration(allocator_->stun_servers(),
                                 allocator_->turn_servers(), 0, true);
    AddTurnServers(kTurnUdpIntIPv6Addr, rtc::SocketAddress());
    AddTurnServers(kTurnUdpIntAddr, rtc::SocketAddress());

    allocator_->set_step_delay(kMinimumStepDelay);
    allocator_->set_flags(
        allocator().flags() | PORTALLOCATOR_ENABLE_SHARED_SOCKET |
        PORTALLOCATOR_ENABLE_IPV6 | PORTALLOCATOR_DISABLE_TCP);

    EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
    session_->StartGettingPorts();
    EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);
    // Three ports (one IPv4 STUN, one IPv6 STUN and one TURN) will be ready.
    EXPECT_EQ(3U, session_->ReadyPorts().size());
    EXPECT_EQ(3U, ports_.size());
    EXPECT_EQ(1, CountPorts(ports_, "local", PROTO_UDP, kClientAddr));
    EXPECT_EQ(1, CountPorts(ports_, "local", PROTO_UDP, kClientIPv6Addr));
    EXPECT_EQ(1, CountPorts(ports_, "relay", PROTO_UDP, kClientIPv6Addr));
    EXPECT_EQ(0, CountPorts(ports_, "relay", PROTO_UDP, kClientAddr));

    // Now that we remove candidates when a TURN port is pruned, there will be
    // exactly 3 candidates in both |candidates_| and |ready_candidates|.
    EXPECT_EQ(3U, candidates_.size());
    const std::vector<Candidate>& ready_candidates =
        session_->ReadyCandidates();
    EXPECT_EQ(3U, ready_candidates.size());
    EXPECT_PRED4(HasCandidate, ready_candidates, "local", "udp", kClientAddr);
    EXPECT_PRED4(HasCandidate, ready_candidates, "relay", "udp",
                 rtc::SocketAddress(kTurnUdpExtAddr.ipaddr(), 0));
  }

  void TestEachInterfaceHasItsOwnTurnPorts() {
    turn_server_.AddInternalSocket(kTurnTcpIntAddr, PROTO_TCP);
    turn_server_.AddInternalSocket(kTurnUdpIntIPv6Addr, PROTO_UDP);
    turn_server_.AddInternalSocket(kTurnTcpIntIPv6Addr, PROTO_TCP);
    // Add two interfaces both having IPv4 and IPv6 addresses.
    AddInterface(kClientAddr, "net1", rtc::ADAPTER_TYPE_WIFI);
    AddInterface(kClientIPv6Addr, "net1", rtc::ADAPTER_TYPE_WIFI);
    AddInterface(kClientAddr2, "net2", rtc::ADAPTER_TYPE_CELLULAR);
    AddInterface(kClientIPv6Addr2, "net2", rtc::ADAPTER_TYPE_CELLULAR);
    allocator_.reset(new BasicPortAllocator(&network_manager_));
    allocator_->SetConfiguration(allocator_->stun_servers(),
                                 allocator_->turn_servers(), 0, true);
    // Have both UDP/TCP and IPv4/IPv6 TURN ports.
    AddTurnServers(kTurnUdpIntAddr, kTurnTcpIntAddr);
    AddTurnServers(kTurnUdpIntIPv6Addr, kTurnTcpIntIPv6Addr);

    allocator_->set_step_delay(kMinimumStepDelay);
    allocator_->set_flags(allocator().flags() |
                          PORTALLOCATOR_ENABLE_SHARED_SOCKET |
                          PORTALLOCATOR_ENABLE_IPV6);
    EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
    session_->StartGettingPorts();
    EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);
    // 10 ports (4 STUN and 1 TURN ports on each interface) will be ready to
    // use.
    EXPECT_EQ(10U, session_->ReadyPorts().size());
    EXPECT_EQ(10U, ports_.size());
    EXPECT_EQ(1, CountPorts(ports_, "local", PROTO_UDP, kClientAddr));
    EXPECT_EQ(1, CountPorts(ports_, "local", PROTO_UDP, kClientAddr2));
    EXPECT_EQ(1, CountPorts(ports_, "local", PROTO_UDP, kClientIPv6Addr));
    EXPECT_EQ(1, CountPorts(ports_, "local", PROTO_UDP, kClientIPv6Addr2));
    EXPECT_EQ(1, CountPorts(ports_, "local", PROTO_TCP, kClientAddr));
    EXPECT_EQ(1, CountPorts(ports_, "local", PROTO_TCP, kClientAddr2));
    EXPECT_EQ(1, CountPorts(ports_, "local", PROTO_TCP, kClientIPv6Addr));
    EXPECT_EQ(1, CountPorts(ports_, "local", PROTO_TCP, kClientIPv6Addr2));
    EXPECT_EQ(1, CountPorts(ports_, "relay", PROTO_UDP, kClientIPv6Addr));
    EXPECT_EQ(1, CountPorts(ports_, "relay", PROTO_UDP, kClientIPv6Addr2));

    // Now that we remove candidates when TURN ports are pruned, there will be
    // exactly 10 candidates in |candidates_|.
    EXPECT_EQ(10U, candidates_.size());
    const std::vector<Candidate>& ready_candidates =
        session_->ReadyCandidates();
    EXPECT_EQ(10U, ready_candidates.size());
    EXPECT_PRED4(HasCandidate, ready_candidates, "local", "udp", kClientAddr);
    EXPECT_PRED4(HasCandidate, ready_candidates, "local", "udp", kClientAddr2);
    EXPECT_PRED4(HasCandidate, ready_candidates, "local", "udp",
                 kClientIPv6Addr);
    EXPECT_PRED4(HasCandidate, ready_candidates, "local", "udp",
                 kClientIPv6Addr2);
    EXPECT_PRED4(HasCandidate, ready_candidates, "local", "tcp", kClientAddr);
    EXPECT_PRED4(HasCandidate, ready_candidates, "local", "tcp", kClientAddr2);
    EXPECT_PRED4(HasCandidate, ready_candidates, "local", "tcp",
                 kClientIPv6Addr);
    EXPECT_PRED4(HasCandidate, ready_candidates, "local", "tcp",
                 kClientIPv6Addr2);
    EXPECT_PRED4(HasCandidate, ready_candidates, "relay", "udp",
                 rtc::SocketAddress(kTurnUdpExtAddr.ipaddr(), 0));
  }

  std::unique_ptr<rtc::PhysicalSocketServer> pss_;
  std::unique_ptr<rtc::VirtualSocketServer> vss_;
  std::unique_ptr<rtc::FirewallSocketServer> fss_;
  rtc::SocketServerScope ss_scope_;
  std::unique_ptr<rtc::NATServer> nat_server_;
  rtc::NATSocketFactory nat_factory_;
  std::unique_ptr<rtc::BasicPacketSocketFactory> nat_socket_factory_;
  std::unique_ptr<TestStunServer> stun_server_;
  TestRelayServer relay_server_;
  TestTurnServer turn_server_;
  rtc::FakeNetworkManager network_manager_;
  std::unique_ptr<BasicPortAllocator> allocator_;
  std::unique_ptr<PortAllocatorSession> session_;
  std::vector<PortInterface*> ports_;
  std::vector<Candidate> candidates_;
  bool candidate_allocation_done_;
};

// Tests that we can init the port allocator and create a session.
TEST_F(BasicPortAllocatorTest, TestBasic) {
  EXPECT_EQ(&network_manager_, allocator().network_manager());
  EXPECT_EQ(kStunAddr, *allocator().stun_servers().begin());
  ASSERT_EQ(1u, allocator().turn_servers().size());
  EXPECT_EQ(RELAY_GTURN, allocator().turn_servers()[0].type);
  // Empty relay credentials are used for GTURN.
  EXPECT_TRUE(allocator().turn_servers()[0].credentials.username.empty());
  EXPECT_TRUE(allocator().turn_servers()[0].credentials.password.empty());
  EXPECT_TRUE(HasRelayAddress(ProtocolAddress(kRelayUdpIntAddr, PROTO_UDP)));
  EXPECT_TRUE(HasRelayAddress(ProtocolAddress(kRelayTcpIntAddr, PROTO_TCP)));
  EXPECT_TRUE(
      HasRelayAddress(ProtocolAddress(kRelaySslTcpIntAddr, PROTO_SSLTCP)));
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  EXPECT_FALSE(session_->CandidatesAllocationDone());
}

// Tests that our network filtering works properly.
TEST_F(BasicPortAllocatorTest, TestIgnoreOnlyLoopbackNetworkByDefault) {
  AddInterface(SocketAddress(IPAddress(0x12345600U), 0), "test_eth0",
               rtc::ADAPTER_TYPE_ETHERNET);
  AddInterface(SocketAddress(IPAddress(0x12345601U), 0), "test_wlan0",
               rtc::ADAPTER_TYPE_WIFI);
  AddInterface(SocketAddress(IPAddress(0x12345602U), 0), "test_cell0",
               rtc::ADAPTER_TYPE_CELLULAR);
  AddInterface(SocketAddress(IPAddress(0x12345603U), 0), "test_vpn0",
               rtc::ADAPTER_TYPE_VPN);
  AddInterface(SocketAddress(IPAddress(0x12345604U), 0), "test_lo",
               rtc::ADAPTER_TYPE_LOOPBACK);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->set_flags(PORTALLOCATOR_DISABLE_STUN | PORTALLOCATOR_DISABLE_RELAY |
                      PORTALLOCATOR_DISABLE_TCP);
  session_->StartGettingPorts();
  EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);
  EXPECT_EQ(4U, candidates_.size());
  for (Candidate candidate : candidates_) {
    EXPECT_LT(candidate.address().ip(), 0x12345604U);
  }
}

TEST_F(BasicPortAllocatorTest, TestIgnoreNetworksAccordingToIgnoreMask) {
  AddInterface(SocketAddress(IPAddress(0x12345600U), 0), "test_eth0",
               rtc::ADAPTER_TYPE_ETHERNET);
  AddInterface(SocketAddress(IPAddress(0x12345601U), 0), "test_wlan0",
               rtc::ADAPTER_TYPE_WIFI);
  AddInterface(SocketAddress(IPAddress(0x12345602U), 0), "test_cell0",
               rtc::ADAPTER_TYPE_CELLULAR);
  allocator_->SetNetworkIgnoreMask(rtc::ADAPTER_TYPE_ETHERNET |
                                   rtc::ADAPTER_TYPE_LOOPBACK |
                                   rtc::ADAPTER_TYPE_WIFI);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->set_flags(PORTALLOCATOR_DISABLE_STUN | PORTALLOCATOR_DISABLE_RELAY |
                      PORTALLOCATOR_DISABLE_TCP);
  session_->StartGettingPorts();
  EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);
  EXPECT_EQ(1U, candidates_.size());
  EXPECT_EQ(0x12345602U, candidates_[0].address().ip());
}

// Test that high cost networks are filtered if the flag
// PORTALLOCATOR_DISABLE_COSTLY_NETWORKS is set.
TEST_F(BasicPortAllocatorTest, TestGatherLowCostNetworkOnly) {
  SocketAddress addr_wifi(IPAddress(0x12345600U), 0);
  SocketAddress addr_cellular(IPAddress(0x12345601U), 0);
  SocketAddress addr_unknown1(IPAddress(0x12345602U), 0);
  SocketAddress addr_unknown2(IPAddress(0x12345603U), 0);
  // If both Wi-Fi and cellular interfaces are present, only gather on the Wi-Fi
  // interface.
  AddInterface(addr_wifi, "test_wlan0", rtc::ADAPTER_TYPE_WIFI);
  AddInterface(addr_cellular, "test_cell0", rtc::ADAPTER_TYPE_CELLULAR);
  allocator().set_flags(cricket::PORTALLOCATOR_DISABLE_STUN |
                        cricket::PORTALLOCATOR_DISABLE_RELAY |
                        cricket::PORTALLOCATOR_DISABLE_TCP |
                        cricket::PORTALLOCATOR_DISABLE_COSTLY_NETWORKS);
  EXPECT_TRUE(CreateSession(cricket::ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();
  EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);
  EXPECT_EQ(1U, candidates_.size());
  EXPECT_TRUE(addr_wifi.EqualIPs(candidates_[0].address()));

  // If both cellular and unknown interfaces are present, only gather on the
  // unknown interfaces.
  candidates_.clear();
  candidate_allocation_done_ = false;
  RemoveInterface(addr_wifi);
  AddInterface(addr_unknown1, "test_unknown0", rtc::ADAPTER_TYPE_UNKNOWN);
  AddInterface(addr_unknown2, "test_unknown1", rtc::ADAPTER_TYPE_UNKNOWN);
  session_->StartGettingPorts();
  EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);
  EXPECT_EQ(2U, candidates_.size());
  EXPECT_TRUE((addr_unknown1.EqualIPs(candidates_[0].address()) &&
               addr_unknown2.EqualIPs(candidates_[1].address())) ||
              (addr_unknown1.EqualIPs(candidates_[1].address()) &&
               addr_unknown2.EqualIPs(candidates_[0].address())));

  // If Wi-Fi, cellular, unknown interfaces are all present, only gather on the
  // Wi-Fi interface.
  candidates_.clear();
  candidate_allocation_done_ = false;
  AddInterface(addr_wifi, "test_wlan0", rtc::ADAPTER_TYPE_WIFI);
  session_->StartGettingPorts();
  EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);
  EXPECT_EQ(1U, candidates_.size());
  EXPECT_TRUE(addr_wifi.EqualIPs(candidates_[0].address()));
}

// Test that we could use loopback interface as host candidate.
TEST_F(BasicPortAllocatorTest, TestLoopbackNetworkInterface) {
  AddInterface(kLoopbackAddr, "test_loopback", rtc::ADAPTER_TYPE_LOOPBACK);
  allocator_->SetNetworkIgnoreMask(0);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->set_flags(PORTALLOCATOR_DISABLE_STUN | PORTALLOCATOR_DISABLE_RELAY |
                      PORTALLOCATOR_DISABLE_TCP);
  session_->StartGettingPorts();
  EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);
  EXPECT_EQ(1U, candidates_.size());
}

// Tests that we can get all the desired addresses successfully.
TEST_F(BasicPortAllocatorTest, TestGetAllPortsWithMinimumStepDelay) {
  AddInterface(kClientAddr);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();
  ASSERT_EQ_WAIT(7U, candidates_.size(), kDefaultAllocationTimeout);
  EXPECT_EQ(4U, ports_.size());
  EXPECT_PRED4(HasCandidate, candidates_, "local", "udp", kClientAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "stun", "udp", kClientAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "relay", "udp", kRelayUdpIntAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "relay", "udp", kRelayUdpExtAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "relay", "tcp", kRelayTcpIntAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "local", "tcp", kClientAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "relay", "ssltcp",
               kRelaySslTcpIntAddr);
  EXPECT_TRUE(candidate_allocation_done_);
}

// Test that when the same network interface is brought down and up, the
// port allocator session will restart a new allocation sequence if
// it is not stopped.
TEST_F(BasicPortAllocatorTest, TestSameNetworkDownAndUpWhenSessionNotStopped) {
  std::string if_name("test_net0");
  AddInterface(kClientAddr, if_name);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();
  ASSERT_EQ_WAIT(7U, candidates_.size(), kDefaultAllocationTimeout);
  EXPECT_EQ(4U, ports_.size());
  EXPECT_TRUE(candidate_allocation_done_);
  candidate_allocation_done_ = false;
  candidates_.clear();
  ports_.clear();

  RemoveInterface(kClientAddr);
  ASSERT_EQ_WAIT(0U, candidates_.size(), kDefaultAllocationTimeout);
  EXPECT_EQ(0U, ports_.size());
  EXPECT_FALSE(candidate_allocation_done_);

  // When the same interfaces are added again, new candidates/ports should be
  // generated.
  AddInterface(kClientAddr, if_name);
  ASSERT_EQ_WAIT(7U, candidates_.size(), kDefaultAllocationTimeout);
  EXPECT_EQ(4U, ports_.size());
  EXPECT_TRUE(candidate_allocation_done_);
}

// Test that when the same network interface is brought down and up, the
// port allocator session will not restart a new allocation sequence if
// it is stopped.
TEST_F(BasicPortAllocatorTest, TestSameNetworkDownAndUpWhenSessionStopped) {
  std::string if_name("test_net0");
  AddInterface(kClientAddr, if_name);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();
  ASSERT_EQ_WAIT(7U, candidates_.size(), kDefaultAllocationTimeout);
  EXPECT_EQ(4U, ports_.size());
  EXPECT_TRUE(candidate_allocation_done_);
  session_->StopGettingPorts();
  candidates_.clear();
  ports_.clear();

  RemoveInterface(kClientAddr);
  ASSERT_EQ_WAIT(0U, candidates_.size(), kDefaultAllocationTimeout);
  EXPECT_EQ(0U, ports_.size());

  // When the same interfaces are added again, new candidates/ports should not
  // be generated because the session has stopped.
  AddInterface(kClientAddr, if_name);
  ASSERT_EQ_WAIT(0U, candidates_.size(), kDefaultAllocationTimeout);
  EXPECT_EQ(0U, ports_.size());
  EXPECT_TRUE(candidate_allocation_done_);
}

// Verify candidates with default step delay of 1sec.
TEST_F(BasicPortAllocatorTest, TestGetAllPortsWithOneSecondStepDelay) {
  AddInterface(kClientAddr);
  allocator_->set_step_delay(kDefaultStepDelay);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();
  ASSERT_EQ_WAIT(2U, candidates_.size(), 1000);
  EXPECT_EQ(2U, ports_.size());
  ASSERT_EQ_WAIT(4U, candidates_.size(), 2000);
  EXPECT_EQ(3U, ports_.size());
  EXPECT_PRED4(HasCandidate, candidates_, "relay", "udp", kRelayUdpIntAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "relay", "udp", kRelayUdpExtAddr);
  ASSERT_EQ_WAIT(6U, candidates_.size(), 1500);
  EXPECT_PRED4(HasCandidate, candidates_, "relay", "tcp", kRelayTcpIntAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "local", "tcp", kClientAddr);
  EXPECT_EQ(4U, ports_.size());
  ASSERT_EQ_WAIT(7U, candidates_.size(), 2000);
  EXPECT_PRED4(HasCandidate, candidates_, "relay", "ssltcp",
               kRelaySslTcpIntAddr);
  EXPECT_EQ(4U, ports_.size());
  EXPECT_TRUE(candidate_allocation_done_);
  // If we Stop gathering now, we shouldn't get a second "done" callback.
  session_->StopGettingPorts();
}

TEST_F(BasicPortAllocatorTest, TestSetupVideoRtpPortsWithNormalSendBuffers) {
  AddInterface(kClientAddr);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP, CN_VIDEO));
  session_->StartGettingPorts();
  ASSERT_EQ_WAIT(7U, candidates_.size(), kDefaultAllocationTimeout);
  EXPECT_TRUE(candidate_allocation_done_);
  // If we Stop gathering now, we shouldn't get a second "done" callback.
  session_->StopGettingPorts();

  // All ports should have unset send-buffer sizes.
  CheckSendBufferSizesOfAllPorts(-1);
}

// Tests that we can get callback after StopGetAllPorts.
TEST_F(BasicPortAllocatorTest, TestStopGetAllPorts) {
  AddInterface(kClientAddr);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();
  ASSERT_EQ_WAIT(2U, candidates_.size(), kDefaultAllocationTimeout);
  EXPECT_EQ(2U, ports_.size());
  session_->StopGettingPorts();
  EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);
}

// Test that we restrict client ports appropriately when a port range is set.
// We check the candidates for udp/stun/tcp ports, and the from address
// for relay ports.
TEST_F(BasicPortAllocatorTest, TestGetAllPortsPortRange) {
  AddInterface(kClientAddr);
  // Check that an invalid port range fails.
  EXPECT_FALSE(SetPortRange(kMaxPort, kMinPort));
  // Check that a null port range succeeds.
  EXPECT_TRUE(SetPortRange(0, 0));
  // Check that a valid port range succeeds.
  EXPECT_TRUE(SetPortRange(kMinPort, kMaxPort));
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();
  ASSERT_EQ_WAIT(7U, candidates_.size(), kDefaultAllocationTimeout);
  EXPECT_EQ(4U, ports_.size());

  int num_nonrelay_candidates = 0;
  for (const Candidate& candidate : candidates_) {
    // Check the port number for the UDP/STUN/TCP port objects.
    if (candidate.type() != RELAY_PORT_TYPE) {
      EXPECT_PRED3(CheckPort, candidate.address(), kMinPort, kMaxPort);
      ++num_nonrelay_candidates;
    }
  }
  EXPECT_EQ(3, num_nonrelay_candidates);
  // Check the port number used to connect to the relay server.
  EXPECT_PRED3(CheckPort, relay_server_.GetConnection(0).source(), kMinPort,
               kMaxPort);
  EXPECT_TRUE(candidate_allocation_done_);
}

// Test that if we have no network adapters, we bind to the ANY address and
// still get non-host candidates.
TEST_F(BasicPortAllocatorTest, TestGetAllPortsNoAdapters) {
  // Default config uses GTURN and no NAT, so replace that with the
  // desired setup (NAT, STUN server, TURN server, UDP/TCP).
  ResetWithStunServerAndNat(kStunAddr);
  turn_server_.AddInternalSocket(kTurnTcpIntAddr, PROTO_TCP);
  AddTurnServers(kTurnUdpIntAddr, kTurnTcpIntAddr);
  AddTurnServers(kTurnUdpIntIPv6Addr, kTurnTcpIntIPv6Addr);
  // Disable IPv6, because our test infrastructure doesn't support having IPv4
  // behind a NAT but IPv6 not, or having an IPv6 NAT.
  // TODO(deadbeef): Fix this.
  network_manager_.set_ipv6_enabled(false);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();
  EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);
  EXPECT_EQ(4U, ports_.size());
  EXPECT_EQ(1, CountPorts(ports_, "stun", PROTO_UDP, kAnyAddr));
  EXPECT_EQ(1, CountPorts(ports_, "local", PROTO_TCP, kAnyAddr));
  // Two TURN ports, using UDP/TCP for the first hop to the TURN server.
  EXPECT_EQ(1, CountPorts(ports_, "relay", PROTO_UDP, kAnyAddr));
  EXPECT_EQ(1, CountPorts(ports_, "relay", PROTO_TCP, kAnyAddr));
  // The "any" address port should be in the signaled ready ports, but the host
  // candidate for it is useless and shouldn't be signaled. So we only have
  // STUN/TURN candidates.
  EXPECT_EQ(3U, candidates_.size());
  EXPECT_PRED4(HasCandidate, candidates_, "stun", "udp",
               rtc::SocketAddress(kNatUdpAddr.ipaddr(), 0));
  // Again, two TURN candidates, using UDP/TCP for the first hop to the TURN
  // server.
  EXPECT_EQ(2,
            CountCandidates(candidates_, "relay", "udp",
                            rtc::SocketAddress(kTurnUdpExtAddr.ipaddr(), 0)));
}

// Test that when enumeration is disabled, we should not have any ports when
// candidate_filter() is set to CF_RELAY and no relay is specified.
TEST_F(BasicPortAllocatorTest,
       TestDisableAdapterEnumerationWithoutNatRelayTransportOnly) {
  ResetWithStunServerNoNat(kStunAddr);
  allocator().set_candidate_filter(CF_RELAY);
  // Expect to see no ports and no candidates.
  CheckDisableAdapterEnumeration(0U, rtc::IPAddress(), rtc::IPAddress(),
                                 rtc::IPAddress(), rtc::IPAddress());
}

// Test that even with multiple interfaces, the result should still be a single
// default private, one STUN and one TURN candidate since we bind to any address
// (i.e. all 0s).
TEST_F(BasicPortAllocatorTest,
       TestDisableAdapterEnumerationBehindNatMultipleInterfaces) {
  AddInterface(kPrivateAddr);
  AddInterface(kPrivateAddr2);
  ResetWithStunServerAndNat(kStunAddr);
  AddTurnServers(kTurnUdpIntAddr, rtc::SocketAddress());

  // Enable IPv6 here. Since the network_manager doesn't have IPv6 default
  // address set and we have no IPv6 STUN server, there should be no IPv6
  // candidates.
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->set_flags(PORTALLOCATOR_ENABLE_IPV6);

  // Expect to see 3 ports for IPv4: HOST/STUN, TURN/UDP and TCP ports, 2 ports
  // for IPv6: HOST, and TCP. Only IPv4 candidates: a default private, STUN and
  // TURN/UDP candidates.
  CheckDisableAdapterEnumeration(5U, kPrivateAddr.ipaddr(),
                                 kNatUdpAddr.ipaddr(), kTurnUdpExtAddr.ipaddr(),
                                 rtc::IPAddress());
}

// Test that we should get a default private, STUN, TURN/UDP and TURN/TCP
// candidates when both TURN/UDP and TURN/TCP servers are specified.
TEST_F(BasicPortAllocatorTest, TestDisableAdapterEnumerationBehindNatWithTcp) {
  turn_server_.AddInternalSocket(kTurnTcpIntAddr, PROTO_TCP);
  AddInterface(kPrivateAddr);
  ResetWithStunServerAndNat(kStunAddr);
  AddTurnServers(kTurnUdpIntAddr, kTurnTcpIntAddr);
  // Expect to see 4 ports - STUN, TURN/UDP, TURN/TCP and TCP port. A default
  // private, STUN, TURN/UDP, and TURN/TCP candidates.
  CheckDisableAdapterEnumeration(4U, kPrivateAddr.ipaddr(),
                                 kNatUdpAddr.ipaddr(), kTurnUdpExtAddr.ipaddr(),
                                 kTurnUdpExtAddr.ipaddr());
}

// Test that when adapter enumeration is disabled, for endpoints without
// STUN/TURN specified, a default private candidate is still generated.
TEST_F(BasicPortAllocatorTest,
       TestDisableAdapterEnumerationWithoutNatOrServers) {
  ResetWithNoServersOrNat();
  // Expect to see 2 ports: STUN and TCP ports, one default private candidate.
  CheckDisableAdapterEnumeration(2U, kPrivateAddr.ipaddr(), rtc::IPAddress(),
                                 rtc::IPAddress(), rtc::IPAddress());
}

// Test that when adapter enumeration is disabled, with
// PORTALLOCATOR_DISABLE_LOCALHOST_CANDIDATE specified, for endpoints not behind
// a NAT, there is no local candidate.
TEST_F(BasicPortAllocatorTest,
       TestDisableAdapterEnumerationWithoutNatLocalhostCandidateDisabled) {
  ResetWithStunServerNoNat(kStunAddr);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->set_flags(PORTALLOCATOR_DISABLE_DEFAULT_LOCAL_CANDIDATE);
  // Expect to see 2 ports: STUN and TCP ports, localhost candidate and STUN
  // candidate.
  CheckDisableAdapterEnumeration(2U, rtc::IPAddress(), rtc::IPAddress(),
                                 rtc::IPAddress(), rtc::IPAddress());
}

// Test that when adapter enumeration is disabled, with
// PORTALLOCATOR_DISABLE_LOCALHOST_CANDIDATE specified, for endpoints not behind
// a NAT, there is no local candidate. However, this specified default route
// (kClientAddr) which was discovered when sending STUN requests, will become
// the srflx addresses.
TEST_F(
    BasicPortAllocatorTest,
    TestDisableAdapterEnumerationWithoutNatLocalhostCandidateDisabledWithDifferentDefaultRoute) {
  ResetWithStunServerNoNat(kStunAddr);
  AddInterfaceAsDefaultRoute(kClientAddr);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->set_flags(PORTALLOCATOR_DISABLE_DEFAULT_LOCAL_CANDIDATE);
  // Expect to see 2 ports: STUN and TCP ports, localhost candidate and STUN
  // candidate.
  CheckDisableAdapterEnumeration(2U, rtc::IPAddress(), kClientAddr.ipaddr(),
                                 rtc::IPAddress(), rtc::IPAddress());
}

// Test that when adapter enumeration is disabled, with
// PORTALLOCATOR_DISABLE_LOCALHOST_CANDIDATE specified, for endpoints behind a
// NAT, there is only one STUN candidate.
TEST_F(BasicPortAllocatorTest,
       TestDisableAdapterEnumerationWithNatLocalhostCandidateDisabled) {
  ResetWithStunServerAndNat(kStunAddr);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->set_flags(PORTALLOCATOR_DISABLE_DEFAULT_LOCAL_CANDIDATE);
  // Expect to see 2 ports: STUN and TCP ports, and single STUN candidate.
  CheckDisableAdapterEnumeration(2U, rtc::IPAddress(), kNatUdpAddr.ipaddr(),
                                 rtc::IPAddress(), rtc::IPAddress());
}

// Test that we disable relay over UDP, and only TCP is used when connecting to
// the relay server.
TEST_F(BasicPortAllocatorTest, TestDisableUdpTurn) {
  turn_server_.AddInternalSocket(kTurnTcpIntAddr, PROTO_TCP);
  AddInterface(kClientAddr);
  ResetWithStunServerAndNat(kStunAddr);
  AddTurnServers(kTurnUdpIntAddr, kTurnTcpIntAddr);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->set_flags(PORTALLOCATOR_DISABLE_UDP_RELAY |
                      PORTALLOCATOR_DISABLE_UDP | PORTALLOCATOR_DISABLE_STUN |
                      PORTALLOCATOR_ENABLE_SHARED_SOCKET);

  session_->StartGettingPorts();
  EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);

  // Expect to see 2 ports and 2 candidates - TURN/TCP and TCP ports, TCP and
  // TURN/TCP candidates.
  EXPECT_EQ(2U, ports_.size());
  EXPECT_EQ(2U, candidates_.size());
  Candidate turn_candidate;
  EXPECT_PRED5(FindCandidate, candidates_, "relay", "udp", kTurnUdpExtAddr,
               &turn_candidate);
  // The TURN candidate should use TCP to contact the TURN server.
  EXPECT_EQ(TCP_PROTOCOL_NAME, turn_candidate.relay_protocol());
  EXPECT_PRED4(HasCandidate, candidates_, "local", "tcp", kClientAddr);
}

// Disable for asan, see
// https://code.google.com/p/webrtc/issues/detail?id=4743 for details.
#if !defined(ADDRESS_SANITIZER)

// Test that we can get OnCandidatesAllocationDone callback when all the ports
// are disabled.
TEST_F(BasicPortAllocatorTest, TestDisableAllPorts) {
  AddInterface(kClientAddr);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->set_flags(PORTALLOCATOR_DISABLE_UDP | PORTALLOCATOR_DISABLE_STUN |
                      PORTALLOCATOR_DISABLE_RELAY | PORTALLOCATOR_DISABLE_TCP);
  session_->StartGettingPorts();
  rtc::Thread::Current()->ProcessMessages(100);
  EXPECT_EQ(0U, candidates_.size());
  EXPECT_TRUE(candidate_allocation_done_);
}

// Test that we don't crash or malfunction if we can't create UDP sockets.
TEST_F(BasicPortAllocatorTest, TestGetAllPortsNoUdpSockets) {
  AddInterface(kClientAddr);
  fss_->set_udp_sockets_enabled(false);
  EXPECT_TRUE(CreateSession(1));
  session_->StartGettingPorts();
  ASSERT_EQ_WAIT(5U, candidates_.size(), kDefaultAllocationTimeout);
  EXPECT_EQ(2U, ports_.size());
  EXPECT_PRED4(HasCandidate, candidates_, "relay", "udp", kRelayUdpIntAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "relay", "udp", kRelayUdpExtAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "relay", "tcp", kRelayTcpIntAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "local", "tcp", kClientAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "relay", "ssltcp",
               kRelaySslTcpIntAddr);
  EXPECT_TRUE(candidate_allocation_done_);
}

#endif  // if !defined(ADDRESS_SANITIZER)

// Test that we don't crash or malfunction if we can't create UDP sockets or
// listen on TCP sockets. We still give out a local TCP address, since
// apparently this is needed for the remote side to accept our connection.
TEST_F(BasicPortAllocatorTest, TestGetAllPortsNoUdpSocketsNoTcpListen) {
  AddInterface(kClientAddr);
  fss_->set_udp_sockets_enabled(false);
  fss_->set_tcp_listen_enabled(false);
  EXPECT_TRUE(CreateSession(1));
  session_->StartGettingPorts();
  ASSERT_EQ_WAIT(5U, candidates_.size(), kDefaultAllocationTimeout);
  EXPECT_EQ(2U, ports_.size());
  EXPECT_PRED4(HasCandidate, candidates_, "relay", "udp", kRelayUdpIntAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "relay", "udp", kRelayUdpExtAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "relay", "tcp", kRelayTcpIntAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "local", "tcp", kClientAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "relay", "ssltcp",
               kRelaySslTcpIntAddr);
  EXPECT_TRUE(candidate_allocation_done_);
}

// Test that we don't crash or malfunction if we can't create any sockets.
// TODO(deadbeef): Find a way to exit early here.
TEST_F(BasicPortAllocatorTest, TestGetAllPortsNoSockets) {
  AddInterface(kClientAddr);
  fss_->set_tcp_sockets_enabled(false);
  fss_->set_udp_sockets_enabled(false);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();
  WAIT(candidates_.size() > 0, 2000);
  // TODO(deadbeef): Check candidate_allocation_done signal.
  // In case of Relay, ports creation will succeed but sockets will fail.
  // There is no error reporting from RelayEntry to handle this failure.
}

// Testing STUN timeout.
TEST_F(BasicPortAllocatorTest, TestGetAllPortsNoUdpAllowed) {
  fss_->AddRule(false, rtc::FP_UDP, rtc::FD_ANY, kClientAddr);
  AddInterface(kClientAddr);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();
  EXPECT_EQ_WAIT(2U, candidates_.size(), kDefaultAllocationTimeout);
  EXPECT_EQ(2U, ports_.size());
  EXPECT_PRED4(HasCandidate, candidates_, "local", "udp", kClientAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "local", "tcp", kClientAddr);
  // RelayPort connection timeout is 3sec. TCP connection with RelayServer
  // will be tried after 3 seconds.
  // TODO(deadbeef): Use simulated clock here, waiting for exactly 3 seconds.
  EXPECT_EQ_WAIT(6U, candidates_.size(), kStunTimeoutMs);
  EXPECT_EQ(3U, ports_.size());
  EXPECT_PRED4(HasCandidate, candidates_, "relay", "udp", kRelayUdpIntAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "relay", "tcp", kRelayTcpIntAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "relay", "ssltcp",
               kRelaySslTcpIntAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "relay", "udp", kRelayUdpExtAddr);
  // Stun Timeout is 9.5sec.
  // TODO(deadbeef): Use simulated clock here, waiting exactly 6.5 seconds.
  EXPECT_TRUE_WAIT(candidate_allocation_done_, kStunTimeoutMs);
}

TEST_F(BasicPortAllocatorTest, TestCandidatePriorityOfMultipleInterfaces) {
  AddInterface(kClientAddr);
  AddInterface(kClientAddr2);
  // Allocating only host UDP ports. This is done purely for testing
  // convenience.
  allocator().set_flags(PORTALLOCATOR_DISABLE_TCP | PORTALLOCATOR_DISABLE_STUN |
                        PORTALLOCATOR_DISABLE_RELAY);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();
  EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);
  ASSERT_EQ(2U, candidates_.size());
  EXPECT_EQ(2U, ports_.size());
  // Candidates priorities should be different.
  EXPECT_NE(candidates_[0].priority(), candidates_[1].priority());
}

// Test to verify ICE restart process.
TEST_F(BasicPortAllocatorTest, TestGetAllPortsRestarts) {
  AddInterface(kClientAddr);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();
  EXPECT_EQ_WAIT(7U, candidates_.size(), kDefaultAllocationTimeout);
  EXPECT_EQ(4U, ports_.size());
  EXPECT_TRUE(candidate_allocation_done_);
  // TODO(deadbeef): Extend this to verify ICE restart.
}

// Test that the allocator session uses the candidate filter it's created with,
// rather than the filter of its parent allocator.
// The filter of the allocator should only affect the next gathering phase,
// according to JSEP, which means the *next* allocator session returned.
TEST_F(BasicPortAllocatorTest, TestSessionUsesOwnCandidateFilter) {
  AddInterface(kClientAddr);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  // Set candidate filter *after* creating the session. Should have no effect.
  allocator().set_candidate_filter(CF_RELAY);
  session_->StartGettingPorts();
  // 7 candidates and 4 ports is what we would normally get (see the
  // TestGetAllPorts* tests).
  EXPECT_EQ_WAIT(7U, candidates_.size(), kDefaultAllocationTimeout);
  EXPECT_EQ(4U, ports_.size());
  EXPECT_TRUE(candidate_allocation_done_);
}

// Test ICE candidate filter mechanism with options Relay/Host/Reflexive.
// This test also verifies that when the allocator is only allowed to use
// relay (i.e. IceTransportsType is relay), the raddr is an empty
// address with the correct family. This is to prevent any local
// reflective address leakage in the sdp line.
TEST_F(BasicPortAllocatorTest, TestCandidateFilterWithRelayOnly) {
  AddInterface(kClientAddr);
  // GTURN is not configured here.
  ResetWithTurnServersNoNat(kTurnUdpIntAddr, rtc::SocketAddress());
  allocator().set_candidate_filter(CF_RELAY);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();
  EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);
  EXPECT_PRED4(HasCandidate, candidates_, "relay", "udp",
               rtc::SocketAddress(kTurnUdpExtAddr.ipaddr(), 0));

  EXPECT_EQ(1U, candidates_.size());
  EXPECT_EQ(1U, ports_.size());  // Only Relay port will be in ready state.
  EXPECT_EQ(std::string(RELAY_PORT_TYPE), candidates_[0].type());
  EXPECT_EQ(
      candidates_[0].related_address(),
      rtc::EmptySocketAddressWithFamily(candidates_[0].address().family()));
}

TEST_F(BasicPortAllocatorTest, TestCandidateFilterWithHostOnly) {
  AddInterface(kClientAddr);
  allocator().set_flags(PORTALLOCATOR_ENABLE_SHARED_SOCKET);
  allocator().set_candidate_filter(CF_HOST);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();
  EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);
  EXPECT_EQ(2U, candidates_.size());  // Host UDP/TCP candidates only.
  EXPECT_EQ(2U, ports_.size());       // UDP/TCP ports only.
  for (const Candidate& candidate : candidates_) {
    EXPECT_EQ(std::string(LOCAL_PORT_TYPE), candidate.type());
  }
}

// Host is behind the NAT.
TEST_F(BasicPortAllocatorTest, TestCandidateFilterWithReflexiveOnly) {
  AddInterface(kPrivateAddr);
  ResetWithStunServerAndNat(kStunAddr);

  allocator().set_flags(PORTALLOCATOR_ENABLE_SHARED_SOCKET);
  allocator().set_candidate_filter(CF_REFLEXIVE);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();
  EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);
  // Host is behind NAT, no private address will be exposed. Hence only UDP
  // port with STUN candidate will be sent outside.
  EXPECT_EQ(1U, candidates_.size());  // Only STUN candidate.
  EXPECT_EQ(1U, ports_.size());       // Only UDP port will be in ready state.
  EXPECT_EQ(std::string(STUN_PORT_TYPE), candidates_[0].type());
  EXPECT_EQ(
      candidates_[0].related_address(),
      rtc::EmptySocketAddressWithFamily(candidates_[0].address().family()));
}

// Host is not behind the NAT.
TEST_F(BasicPortAllocatorTest, TestCandidateFilterWithReflexiveOnlyAndNoNAT) {
  AddInterface(kClientAddr);
  allocator().set_flags(PORTALLOCATOR_ENABLE_SHARED_SOCKET);
  allocator().set_candidate_filter(CF_REFLEXIVE);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();
  EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);
  // Host has a public address, both UDP and TCP candidates will be exposed.
  EXPECT_EQ(2U, candidates_.size());  // Local UDP + TCP candidate.
  EXPECT_EQ(2U, ports_.size());  //  UDP and TCP ports will be in ready state.
  for (const Candidate& candidate : candidates_) {
    EXPECT_EQ(std::string(LOCAL_PORT_TYPE), candidate.type());
  }
}

// Test that we get the same ufrag and pwd for all candidates.
TEST_F(BasicPortAllocatorTest, TestEnableSharedUfrag) {
  AddInterface(kClientAddr);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();
  ASSERT_EQ_WAIT(7U, candidates_.size(), kDefaultAllocationTimeout);
  EXPECT_PRED4(HasCandidate, candidates_, "local", "udp", kClientAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "stun", "udp", kClientAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "local", "tcp", kClientAddr);
  EXPECT_EQ(4U, ports_.size());
  for (const Candidate& candidate : candidates_) {
    EXPECT_EQ(kIceUfrag0, candidate.username());
    EXPECT_EQ(kIcePwd0, candidate.password());
  }
  EXPECT_TRUE(candidate_allocation_done_);
}

// Test that when PORTALLOCATOR_ENABLE_SHARED_SOCKET is enabled only one port
// is allocated for udp and stun. Also verify there is only one candidate
// (local) if stun candidate is same as local candidate, which will be the case
// in a public network like the below test.
TEST_F(BasicPortAllocatorTest, TestSharedSocketWithoutNat) {
  AddInterface(kClientAddr);
  allocator_->set_flags(allocator().flags() |
                        PORTALLOCATOR_ENABLE_SHARED_SOCKET);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();
  ASSERT_EQ_WAIT(6U, candidates_.size(), kDefaultAllocationTimeout);
  EXPECT_EQ(3U, ports_.size());
  EXPECT_PRED4(HasCandidate, candidates_, "local", "udp", kClientAddr);
  EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);
}

// Test that when PORTALLOCATOR_ENABLE_SHARED_SOCKET is enabled only one port
// is allocated for udp and stun. In this test we should expect both stun and
// local candidates as client behind a nat.
TEST_F(BasicPortAllocatorTest, TestSharedSocketWithNat) {
  AddInterface(kClientAddr);
  ResetWithStunServerAndNat(kStunAddr);

  allocator_->set_flags(allocator().flags() |
                        PORTALLOCATOR_ENABLE_SHARED_SOCKET);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();
  ASSERT_EQ_WAIT(3U, candidates_.size(), kDefaultAllocationTimeout);
  ASSERT_EQ(2U, ports_.size());
  EXPECT_PRED4(HasCandidate, candidates_, "local", "udp", kClientAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "stun", "udp",
               rtc::SocketAddress(kNatUdpAddr.ipaddr(), 0));
  EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);
  EXPECT_EQ(3U, candidates_.size());
}

// Test TURN port in shared socket mode with UDP and TCP TURN server addresses.
TEST_F(BasicPortAllocatorTest, TestSharedSocketWithoutNatUsingTurn) {
  turn_server_.AddInternalSocket(kTurnTcpIntAddr, PROTO_TCP);
  AddInterface(kClientAddr);
  allocator_.reset(new BasicPortAllocator(&network_manager_));

  AddTurnServers(kTurnUdpIntAddr, kTurnTcpIntAddr);

  allocator_->set_step_delay(kMinimumStepDelay);
  allocator_->set_flags(allocator().flags() |
                        PORTALLOCATOR_ENABLE_SHARED_SOCKET |
                        PORTALLOCATOR_DISABLE_TCP);

  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();

  ASSERT_EQ_WAIT(3U, candidates_.size(), kDefaultAllocationTimeout);
  ASSERT_EQ(3U, ports_.size());
  EXPECT_PRED4(HasCandidate, candidates_, "local", "udp", kClientAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "relay", "udp",
               rtc::SocketAddress(kTurnUdpExtAddr.ipaddr(), 0));
  EXPECT_PRED4(HasCandidate, candidates_, "relay", "udp",
               rtc::SocketAddress(kTurnUdpExtAddr.ipaddr(), 0));
  EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);
  EXPECT_EQ(3U, candidates_.size());
}

// Test that if prune_turn_ports is set, TCP TURN port will not be used
// if UDP TurnPort is used, given that TCP TURN port becomes ready first.
TEST_F(BasicPortAllocatorTest,
       TestUdpTurnPortPrunesTcpTurnPortWithTcpPortReadyFirst) {
  // UDP has longer delay than TCP so that TCP TURN port becomes ready first.
  virtual_socket_server()->SetDelayOnAddress(kTurnUdpIntAddr, 200);
  virtual_socket_server()->SetDelayOnAddress(kTurnTcpIntAddr, 100);

  TestUdpTurnPortPrunesTcpTurnPort();
}

// Test that if prune_turn_ports is set, TCP TURN port will not be used
// if UDP TurnPort is used, given that UDP TURN port becomes ready first.
TEST_F(BasicPortAllocatorTest,
       TestUdpTurnPortPrunesTcpTurnPortsWithUdpPortReadyFirst) {
  // UDP has shorter delay than TCP so that UDP TURN port becomes ready first.
  virtual_socket_server()->SetDelayOnAddress(kTurnUdpIntAddr, 100);
  virtual_socket_server()->SetDelayOnAddress(kTurnTcpIntAddr, 200);

  TestUdpTurnPortPrunesTcpTurnPort();
}

// Tests that if prune_turn_ports is set, IPv4 TurnPort will not be used
// if IPv6 TurnPort is used, given that IPv4 TURN port becomes ready first.
TEST_F(BasicPortAllocatorTest,
       TestIPv6TurnPortPrunesIPv4TurnPortWithIPv4PortReadyFirst) {
  // IPv6 has longer delay than IPv4, so that IPv4 TURN port becomes ready
  // first.
  virtual_socket_server()->SetDelayOnAddress(kTurnUdpIntAddr, 100);
  virtual_socket_server()->SetDelayOnAddress(kTurnUdpIntIPv6Addr, 200);

  TestIPv6TurnPortPrunesIPv4TurnPort();
}

// Tests that if prune_turn_ports is set, IPv4 TurnPort will not be used
// if IPv6 TurnPort is used, given that IPv6 TURN port becomes ready first.
TEST_F(BasicPortAllocatorTest,
       TestIPv6TurnPortPrunesIPv4TurnPortWithIPv6PortReadyFirst) {
  // IPv6 has longer delay than IPv4, so that IPv6 TURN port becomes ready
  // first.
  virtual_socket_server()->SetDelayOnAddress(kTurnUdpIntAddr, 200);
  virtual_socket_server()->SetDelayOnAddress(kTurnUdpIntIPv6Addr, 100);

  TestIPv6TurnPortPrunesIPv4TurnPort();
}

// Tests that if prune_turn_ports is set, each network interface
// will has its own set of TurnPorts based on their priorities, in the default
// case where no transit delay is set.
TEST_F(BasicPortAllocatorTest, TestEachInterfaceHasItsOwnTurnPortsNoDelay) {
  TestEachInterfaceHasItsOwnTurnPorts();
}

// Tests that if prune_turn_ports is set, each network interface
// will has its own set of TurnPorts based on their priorities, given that
// IPv4/TCP TURN port becomes ready first.
TEST_F(BasicPortAllocatorTest,
       TestEachInterfaceHasItsOwnTurnPortsWithTcpIPv4ReadyFirst) {
  // IPv6/UDP have longer delay than IPv4/TCP, so that IPv4/TCP TURN port
  // becomes ready last.
  virtual_socket_server()->SetDelayOnAddress(kTurnTcpIntAddr, 10);
  virtual_socket_server()->SetDelayOnAddress(kTurnUdpIntAddr, 100);
  virtual_socket_server()->SetDelayOnAddress(kTurnTcpIntIPv6Addr, 20);
  virtual_socket_server()->SetDelayOnAddress(kTurnUdpIntIPv6Addr, 300);

  TestEachInterfaceHasItsOwnTurnPorts();
}

// Testing DNS resolve for the TURN server, this will test AllocationSequence
// handling the unresolved address signal from TurnPort.
TEST_F(BasicPortAllocatorTest, TestSharedSocketWithServerAddressResolve) {
  turn_server_.AddInternalSocket(rtc::SocketAddress("127.0.0.1", 3478),
                                 PROTO_UDP);
  AddInterface(kClientAddr);
  allocator_.reset(new BasicPortAllocator(&network_manager_));
  RelayServerConfig turn_server(RELAY_TURN);
  RelayCredentials credentials(kTurnUsername, kTurnPassword);
  turn_server.credentials = credentials;
  turn_server.ports.push_back(
      ProtocolAddress(rtc::SocketAddress("localhost", 3478), PROTO_UDP));
  allocator_->AddTurnServer(turn_server);

  allocator_->set_step_delay(kMinimumStepDelay);
  allocator_->set_flags(allocator().flags() |
                        PORTALLOCATOR_ENABLE_SHARED_SOCKET |
                        PORTALLOCATOR_DISABLE_TCP);

  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();

  EXPECT_EQ_WAIT(2U, ports_.size(), kDefaultAllocationTimeout);
}

// Test that when PORTALLOCATOR_ENABLE_SHARED_SOCKET is enabled only one port
// is allocated for udp/stun/turn. In this test we should expect all local,
// stun and turn candidates.
TEST_F(BasicPortAllocatorTest, TestSharedSocketWithNatUsingTurn) {
  AddInterface(kClientAddr);
  ResetWithStunServerAndNat(kStunAddr);

  AddTurnServers(kTurnUdpIntAddr, rtc::SocketAddress());

  allocator_->set_flags(allocator().flags() |
                        PORTALLOCATOR_ENABLE_SHARED_SOCKET |
                        PORTALLOCATOR_DISABLE_TCP);

  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();

  ASSERT_EQ_WAIT(3U, candidates_.size(), kDefaultAllocationTimeout);
  ASSERT_EQ(2U, ports_.size());
  EXPECT_PRED4(HasCandidate, candidates_, "local", "udp", kClientAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "stun", "udp",
               rtc::SocketAddress(kNatUdpAddr.ipaddr(), 0));
  EXPECT_PRED4(HasCandidate, candidates_, "relay", "udp",
               rtc::SocketAddress(kTurnUdpExtAddr.ipaddr(), 0));
  EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);
  EXPECT_EQ(3U, candidates_.size());
  // Local port will be created first and then TURN port.
  EXPECT_EQ(2U, ports_[0]->Candidates().size());
  EXPECT_EQ(1U, ports_[1]->Candidates().size());
}

// Test that when PORTALLOCATOR_ENABLE_SHARED_SOCKET is enabled and the TURN
// server is also used as the STUN server, we should get 'local', 'stun', and
// 'relay' candidates.
TEST_F(BasicPortAllocatorTest, TestSharedSocketWithNatUsingTurnAsStun) {
  AddInterface(kClientAddr);
  // Use an empty SocketAddress to add a NAT without STUN server.
  ResetWithStunServerAndNat(SocketAddress());
  AddTurnServers(kTurnUdpIntAddr, rtc::SocketAddress());

  // Must set the step delay to 0 to make sure the relay allocation phase is
  // started before the STUN candidates are obtained, so that the STUN binding
  // response is processed when both StunPort and TurnPort exist to reproduce
  // webrtc issue 3537.
  allocator_->set_step_delay(0);
  allocator_->set_flags(allocator().flags() |
                        PORTALLOCATOR_ENABLE_SHARED_SOCKET |
                        PORTALLOCATOR_DISABLE_TCP);

  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();

  ASSERT_EQ_WAIT(3U, candidates_.size(), kDefaultAllocationTimeout);
  EXPECT_PRED4(HasCandidate, candidates_, "local", "udp", kClientAddr);
  Candidate stun_candidate;
  EXPECT_PRED5(FindCandidate, candidates_, "stun", "udp",
               rtc::SocketAddress(kNatUdpAddr.ipaddr(), 0), &stun_candidate);
  EXPECT_PRED5(HasCandidateWithRelatedAddr, candidates_, "relay", "udp",
               rtc::SocketAddress(kTurnUdpExtAddr.ipaddr(), 0),
               stun_candidate.address());

  EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);
  EXPECT_EQ(3U, candidates_.size());
  // Local port will be created first and then TURN port.
  EXPECT_EQ(2U, ports_[0]->Candidates().size());
  EXPECT_EQ(1U, ports_[1]->Candidates().size());
}

// Test that when only a TCP TURN server is available, we do NOT use it as
// a UDP STUN server, as this could leak our IP address. Thus we should only
// expect two ports, a UDPPort and TurnPort.
TEST_F(BasicPortAllocatorTest, TestSharedSocketWithNatUsingTurnTcpOnly) {
  turn_server_.AddInternalSocket(kTurnTcpIntAddr, PROTO_TCP);
  AddInterface(kClientAddr);
  ResetWithStunServerAndNat(rtc::SocketAddress());
  AddTurnServers(rtc::SocketAddress(), kTurnTcpIntAddr);

  allocator_->set_flags(allocator().flags() |
                        PORTALLOCATOR_ENABLE_SHARED_SOCKET |
                        PORTALLOCATOR_DISABLE_TCP);

  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();

  ASSERT_EQ_WAIT(2U, candidates_.size(), kDefaultAllocationTimeout);
  ASSERT_EQ(2U, ports_.size());
  EXPECT_PRED4(HasCandidate, candidates_, "local", "udp", kClientAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "relay", "udp",
               rtc::SocketAddress(kTurnUdpExtAddr.ipaddr(), 0));
  EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);
  EXPECT_EQ(2U, candidates_.size());
  EXPECT_EQ(1U, ports_[0]->Candidates().size());
  EXPECT_EQ(1U, ports_[1]->Candidates().size());
}

// Test that even when PORTALLOCATOR_ENABLE_SHARED_SOCKET is NOT enabled, the
// TURN server is used as the STUN server and we get 'local', 'stun', and
// 'relay' candidates.
// TODO(deadbeef): Remove this test when support for non-shared socket mode
// is removed.
TEST_F(BasicPortAllocatorTest, TestNonSharedSocketWithNatUsingTurnAsStun) {
  AddInterface(kClientAddr);
  // Use an empty SocketAddress to add a NAT without STUN server.
  ResetWithStunServerAndNat(SocketAddress());
  AddTurnServers(kTurnUdpIntAddr, rtc::SocketAddress());

  allocator_->set_flags(allocator().flags() | PORTALLOCATOR_DISABLE_TCP);

  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();

  ASSERT_EQ_WAIT(3U, candidates_.size(), kDefaultAllocationTimeout);
  ASSERT_EQ(3U, ports_.size());
  EXPECT_PRED4(HasCandidate, candidates_, "local", "udp", kClientAddr);
  Candidate stun_candidate;
  EXPECT_PRED5(FindCandidate, candidates_, "stun", "udp",
               rtc::SocketAddress(kNatUdpAddr.ipaddr(), 0), &stun_candidate);
  Candidate turn_candidate;
  EXPECT_PRED5(FindCandidate, candidates_, "relay", "udp",
               rtc::SocketAddress(kTurnUdpExtAddr.ipaddr(), 0),
               &turn_candidate);
  // Not using shared socket, so the STUN request's server reflexive address
  // should be different than the TURN request's server reflexive address.
  EXPECT_NE(turn_candidate.related_address(), stun_candidate.address());

  EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);
  EXPECT_EQ(3U, candidates_.size());
  EXPECT_EQ(1U, ports_[0]->Candidates().size());
  EXPECT_EQ(1U, ports_[1]->Candidates().size());
  EXPECT_EQ(1U, ports_[2]->Candidates().size());
}

// Test that even when both a STUN and TURN server are configured, the TURN
// server is used as a STUN server and we get a 'stun' candidate.
TEST_F(BasicPortAllocatorTest, TestSharedSocketWithNatUsingTurnAndStun) {
  AddInterface(kClientAddr);
  // Configure with STUN server but destroy it, so we can ensure that it's
  // the TURN server actually being used as a STUN server.
  ResetWithStunServerAndNat(kStunAddr);
  stun_server_.reset();
  AddTurnServers(kTurnUdpIntAddr, rtc::SocketAddress());

  allocator_->set_flags(allocator().flags() |
                        PORTALLOCATOR_ENABLE_SHARED_SOCKET |
                        PORTALLOCATOR_DISABLE_TCP);

  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();

  ASSERT_EQ_WAIT(3U, candidates_.size(), kDefaultAllocationTimeout);
  EXPECT_PRED4(HasCandidate, candidates_, "local", "udp", kClientAddr);
  Candidate stun_candidate;
  EXPECT_PRED5(FindCandidate, candidates_, "stun", "udp",
               rtc::SocketAddress(kNatUdpAddr.ipaddr(), 0), &stun_candidate);
  EXPECT_PRED5(HasCandidateWithRelatedAddr, candidates_, "relay", "udp",
               rtc::SocketAddress(kTurnUdpExtAddr.ipaddr(), 0),
               stun_candidate.address());

  // Don't bother waiting for STUN timeout, since we already verified
  // that we got a STUN candidate from the TURN server.
}

// This test verifies when PORTALLOCATOR_ENABLE_SHARED_SOCKET flag is enabled
// and fail to generate STUN candidate, local UDP candidate is generated
// properly.
TEST_F(BasicPortAllocatorTest, TestSharedSocketNoUdpAllowed) {
  allocator().set_flags(allocator().flags() | PORTALLOCATOR_DISABLE_RELAY |
                        PORTALLOCATOR_DISABLE_TCP |
                        PORTALLOCATOR_ENABLE_SHARED_SOCKET);
  fss_->AddRule(false, rtc::FP_UDP, rtc::FD_ANY, kClientAddr);
  AddInterface(kClientAddr);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();
  ASSERT_EQ_WAIT(1U, ports_.size(), kDefaultAllocationTimeout);
  EXPECT_EQ(1U, candidates_.size());
  EXPECT_PRED4(HasCandidate, candidates_, "local", "udp", kClientAddr);
  // STUN timeout is 9.5sec. We need to wait to get candidate done signal.
  EXPECT_TRUE_WAIT(candidate_allocation_done_, kStunTimeoutMs);
  EXPECT_EQ(1U, candidates_.size());
}

// Test that when the NetworkManager doesn't have permission to enumerate
// adapters, the PORTALLOCATOR_DISABLE_ADAPTER_ENUMERATION is specified
// automatically.
TEST_F(BasicPortAllocatorTest, TestNetworkPermissionBlocked) {
  network_manager_.set_default_local_addresses(kPrivateAddr.ipaddr(),
                                               rtc::IPAddress());
  network_manager_.set_enumeration_permission(
      rtc::NetworkManager::ENUMERATION_BLOCKED);
  allocator().set_flags(allocator().flags() | PORTALLOCATOR_DISABLE_RELAY |
                        PORTALLOCATOR_DISABLE_TCP |
                        PORTALLOCATOR_ENABLE_SHARED_SOCKET);
  EXPECT_EQ(0U,
            allocator_->flags() & PORTALLOCATOR_DISABLE_ADAPTER_ENUMERATION);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  EXPECT_EQ(0U, session_->flags() & PORTALLOCATOR_DISABLE_ADAPTER_ENUMERATION);
  session_->StartGettingPorts();
  EXPECT_EQ_WAIT(1U, ports_.size(), kDefaultAllocationTimeout);
  EXPECT_EQ(1U, candidates_.size());
  EXPECT_PRED4(HasCandidate, candidates_, "local", "udp", kPrivateAddr);
  EXPECT_NE(0U, session_->flags() & PORTALLOCATOR_DISABLE_ADAPTER_ENUMERATION);
}

// This test verifies allocator can use IPv6 addresses along with IPv4.
TEST_F(BasicPortAllocatorTest, TestEnableIPv6Addresses) {
  allocator().set_flags(allocator().flags() | PORTALLOCATOR_DISABLE_RELAY |
                        PORTALLOCATOR_ENABLE_IPV6 |
                        PORTALLOCATOR_ENABLE_SHARED_SOCKET);
  AddInterface(kClientIPv6Addr);
  AddInterface(kClientAddr);
  allocator_->set_step_delay(kMinimumStepDelay);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();
  ASSERT_EQ_WAIT(4U, ports_.size(), kDefaultAllocationTimeout);
  EXPECT_EQ(4U, candidates_.size());
  EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);
  EXPECT_PRED4(HasCandidate, candidates_, "local", "udp", kClientIPv6Addr);
  EXPECT_PRED4(HasCandidate, candidates_, "local", "udp", kClientAddr);
  EXPECT_PRED4(HasCandidate, candidates_, "local", "tcp", kClientIPv6Addr);
  EXPECT_PRED4(HasCandidate, candidates_, "local", "tcp", kClientAddr);
  EXPECT_EQ(4U, candidates_.size());
}

TEST_F(BasicPortAllocatorTest, TestStopGettingPorts) {
  AddInterface(kClientAddr);
  allocator_->set_step_delay(kDefaultStepDelay);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();
  ASSERT_EQ_WAIT(2U, candidates_.size(), 1000);
  EXPECT_EQ(2U, ports_.size());
  session_->StopGettingPorts();
  EXPECT_TRUE_WAIT(candidate_allocation_done_, 1000);

  // After stopping getting ports, adding a new interface will not start
  // getting ports again.
  allocator_->set_step_delay(kMinimumStepDelay);
  candidates_.clear();
  ports_.clear();
  candidate_allocation_done_ = false;
  network_manager_.AddInterface(kClientAddr2);
  rtc::Thread::Current()->ProcessMessages(1000);
  EXPECT_EQ(0U, candidates_.size());
  EXPECT_EQ(0U, ports_.size());
}

TEST_F(BasicPortAllocatorTest, TestClearGettingPorts) {
  AddInterface(kClientAddr);
  allocator_->set_step_delay(kDefaultStepDelay);
  EXPECT_TRUE(CreateSession(ICE_CANDIDATE_COMPONENT_RTP));
  session_->StartGettingPorts();
  ASSERT_EQ_WAIT(2U, candidates_.size(), 1000);
  EXPECT_EQ(2U, ports_.size());
  session_->ClearGettingPorts();
  EXPECT_TRUE_WAIT(candidate_allocation_done_, 1000);

  // After clearing getting ports, adding a new interface will start getting
  // ports again.
  allocator_->set_step_delay(kMinimumStepDelay);
  candidates_.clear();
  ports_.clear();
  candidate_allocation_done_ = false;
  network_manager_.AddInterface(kClientAddr2);
  ASSERT_EQ_WAIT(2U, candidates_.size(), 1000);
  EXPECT_EQ(2U, ports_.size());
  EXPECT_TRUE_WAIT(candidate_allocation_done_, kDefaultAllocationTimeout);
}

// Test that the ports and candidates are updated with new ufrag/pwd/etc. when
// a pooled session is taken out of the pool.
TEST_F(BasicPortAllocatorTest, TestTransportInformationUpdated) {
  AddInterface(kClientAddr);
  int pool_size = 1;
  allocator_->SetConfiguration(allocator_->stun_servers(),
                               allocator_->turn_servers(), pool_size, false);
  const PortAllocatorSession* peeked_session = allocator_->GetPooledSession();
  ASSERT_NE(nullptr, peeked_session);
  EXPECT_EQ_WAIT(true, peeked_session->CandidatesAllocationDone(),
                 kDefaultAllocationTimeout);
  // Expect that when TakePooledSession is called,
  // UpdateTransportInformationInternal will be called and the
  // BasicPortAllocatorSession will update the ufrag/pwd of ports and
  // candidates.
  session_ =
      allocator_->TakePooledSession(kContentName, 1, kIceUfrag0, kIcePwd0);
  ASSERT_NE(nullptr, session_.get());
  auto ready_ports = session_->ReadyPorts();
  auto candidates = session_->ReadyCandidates();
  EXPECT_FALSE(ready_ports.empty());
  EXPECT_FALSE(candidates.empty());
  for (const PortInterface* port_interface : ready_ports) {
    const Port* port = static_cast<const Port*>(port_interface);
    EXPECT_EQ(kContentName, port->content_name());
    EXPECT_EQ(1, port->component());
    EXPECT_EQ(kIceUfrag0, port->username_fragment());
    EXPECT_EQ(kIcePwd0, port->password());
  }
  for (const Candidate& candidate : candidates) {
    EXPECT_EQ(1, candidate.component());
    EXPECT_EQ(kIceUfrag0, candidate.username());
    EXPECT_EQ(kIcePwd0, candidate.password());
  }
}

// Test that a new candidate filter takes effect even on already-gathered
// candidates.
TEST_F(BasicPortAllocatorTest, TestSetCandidateFilterAfterCandidatesGathered) {
  AddInterface(kClientAddr);
  int pool_size = 1;
  allocator_->SetConfiguration(allocator_->stun_servers(),
                               allocator_->turn_servers(), pool_size, false);
  const PortAllocatorSession* peeked_session = allocator_->GetPooledSession();
  ASSERT_NE(nullptr, peeked_session);
  EXPECT_EQ_WAIT(true, peeked_session->CandidatesAllocationDone(),
                 kDefaultAllocationTimeout);
  size_t initial_candidates_size = peeked_session->ReadyCandidates().size();
  size_t initial_ports_size = peeked_session->ReadyPorts().size();
  allocator_->set_candidate_filter(CF_RELAY);
  // Assume that when TakePooledSession is called, the candidate filter will be
  // applied to the pooled session. This is tested by PortAllocatorTest.
  session_ =
      allocator_->TakePooledSession(kContentName, 1, kIceUfrag0, kIcePwd0);
  ASSERT_NE(nullptr, session_.get());
  auto candidates = session_->ReadyCandidates();
  auto ports = session_->ReadyPorts();
  // Sanity check that the number of candidates and ports decreased.
  EXPECT_GT(initial_candidates_size, candidates.size());
  EXPECT_GT(initial_ports_size, ports.size());
  for (const PortInterface* port : ports) {
    // Expect only relay ports.
    EXPECT_EQ(RELAY_PORT_TYPE, port->Type());
  }
  for (const Candidate& candidate : candidates) {
    // Expect only relay candidates now that the filter is applied.
    EXPECT_EQ(std::string(RELAY_PORT_TYPE), candidate.type());
    // Expect that the raddr is emptied due to the CF_RELAY filter.
    EXPECT_EQ(candidate.related_address(),
              rtc::EmptySocketAddressWithFamily(candidate.address().family()));
  }
}

}  // namespace cricket
