/*
 *  Copyright 2004 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef WEBRTC_P2P_BASE_PORTALLOCATOR_H_
#define WEBRTC_P2P_BASE_PORTALLOCATOR_H_

#include <deque>
#include <memory>
#include <string>
#include <vector>

#include "webrtc/p2p/base/port.h"
#include "webrtc/p2p/base/portinterface.h"
#include "webrtc/base/helpers.h"
#include "webrtc/base/proxyinfo.h"
#include "webrtc/base/sigslot.h"
#include "webrtc/base/thread.h"

namespace webrtc {
class MetricsObserverInterface;
}

namespace cricket {

// PortAllocator is responsible for allocating Port types for a given
// P2PSocket. It also handles port freeing.
//
// Clients can override this class to control port allocation, including
// what kinds of ports are allocated.

enum {
  // Disable local UDP ports. This doesn't impact how we connect to relay
  // servers.
  PORTALLOCATOR_DISABLE_UDP = 0x01,
  PORTALLOCATOR_DISABLE_STUN = 0x02,
  PORTALLOCATOR_DISABLE_RELAY = 0x04,
  // Disable local TCP ports. This doesn't impact how we connect to relay
  // servers.
  PORTALLOCATOR_DISABLE_TCP = 0x08,
  PORTALLOCATOR_ENABLE_IPV6 = 0x40,
  // TODO(pthatcher): Remove this once it's no longer used in:
  // remoting/client/plugin/pepper_port_allocator.cc
  // remoting/protocol/chromium_port_allocator.cc
  // remoting/test/fake_port_allocator.cc
  // It's a no-op and is no longer needed.
  PORTALLOCATOR_ENABLE_SHARED_UFRAG = 0x80,
  PORTALLOCATOR_ENABLE_SHARED_SOCKET = 0x100,
  PORTALLOCATOR_ENABLE_STUN_RETRANSMIT_ATTRIBUTE = 0x200,
  // When specified, we'll only allocate the STUN candidate for the public
  // interface as seen by regular http traffic and the HOST candidate associated
  // with the default local interface.
  PORTALLOCATOR_DISABLE_ADAPTER_ENUMERATION = 0x400,
  // When specified along with PORTALLOCATOR_DISABLE_ADAPTER_ENUMERATION, the
  // default local candidate mentioned above will not be allocated. Only the
  // STUN candidate will be.
  PORTALLOCATOR_DISABLE_DEFAULT_LOCAL_CANDIDATE = 0x800,
  // Disallow use of UDP when connecting to a relay server. Since proxy servers
  // usually don't handle UDP, using UDP will leak the IP address.
  PORTALLOCATOR_DISABLE_UDP_RELAY = 0x1000,

  // When multiple networks exist, do not gather candidates on the ones with
  // high cost. So if both Wi-Fi and cellular networks exist, gather only on the
  // Wi-Fi network. If a network type is "unknown", it has a cost lower than
  // cellular but higher than Wi-Fi/Ethernet. So if an unknown network exists,
  // cellular networks will not be used to gather candidates and if a Wi-Fi
  // network is present, "unknown" networks will not be usd to gather
  // candidates. Doing so ensures that even if a cellular network type was not
  // detected initially, it would not be used if a Wi-Fi network is present.
  PORTALLOCATOR_DISABLE_COSTLY_NETWORKS = 0x2000,
};

// Defines various reasons that have caused ICE regathering.
enum class IceRegatheringReason { NETWORK_CHANGE, NETWORK_FAILURE, MAX_VALUE };

const uint32_t kDefaultPortAllocatorFlags = 0;

const uint32_t kDefaultStepDelay = 1000;  // 1 sec step delay.
// As per RFC 5245 Appendix B.1, STUN transactions need to be paced at certain
// internal. Less than 20ms is not acceptable. We choose 50ms as our default.
const uint32_t kMinimumStepDelay = 50;

// CF = CANDIDATE FILTER
enum {
  CF_NONE = 0x0,
  CF_HOST = 0x1,
  CF_REFLEXIVE = 0x2,
  CF_RELAY = 0x4,
  CF_ALL = 0x7,
};

// TLS certificate policy.
enum class TlsCertPolicy {
  // For TLS based protocols, ensure the connection is secure by not
  // circumventing certificate validation.
  TLS_CERT_POLICY_SECURE,
  // For TLS based protocols, disregard security completely by skipping
  // certificate validation. This is insecure and should never be used unless
  // security is irrelevant in that particular context.
  TLS_CERT_POLICY_INSECURE_NO_CHECK,
};

// TODO(deadbeef): Rename to TurnCredentials (and username to ufrag).
struct RelayCredentials {
  RelayCredentials() {}
  RelayCredentials(const std::string& username, const std::string& password)
      : username(username), password(password) {}

  bool operator==(const RelayCredentials& o) const {
    return username == o.username && password == o.password;
  }
  bool operator!=(const RelayCredentials& o) const { return !(*this == o); }

  std::string username;
  std::string password;
};

typedef std::vector<ProtocolAddress> PortList;
// TODO(deadbeef): Rename to TurnServerConfig.
struct RelayServerConfig {
  RelayServerConfig(RelayType type) : type(type) {}

  RelayServerConfig(const std::string& address,
                    int port,
                    const std::string& username,
                    const std::string& password,
                    ProtocolType proto)
      : type(RELAY_TURN), credentials(username, password) {
    ports.push_back(ProtocolAddress(rtc::SocketAddress(address, port), proto));
  }

  // Legacy constructor where "secure" and PROTO_TCP implies PROTO_TLS.
  RelayServerConfig(const std::string& address,
                    int port,
                    const std::string& username,
                    const std::string& password,
                    ProtocolType proto,
                    bool secure)
      : RelayServerConfig(address,
                          port,
                          username,
                          password,
                          (proto == PROTO_TCP && secure ? PROTO_TLS : proto)) {}

  bool operator==(const RelayServerConfig& o) const {
    return type == o.type && ports == o.ports && credentials == o.credentials &&
           priority == o.priority;
  }
  bool operator!=(const RelayServerConfig& o) const { return !(*this == o); }

  RelayType type;
  PortList ports;
  RelayCredentials credentials;
  int priority = 0;
  TlsCertPolicy tls_cert_policy = TlsCertPolicy::TLS_CERT_POLICY_SECURE;
};

class PortAllocatorSession : public sigslot::has_slots<> {
 public:
  // Content name passed in mostly for logging and debugging.
  PortAllocatorSession(const std::string& content_name,
                       int component,
                       const std::string& ice_ufrag,
                       const std::string& ice_pwd,
                       uint32_t flags);

  // Subclasses should clean up any ports created.
  virtual ~PortAllocatorSession() {}

  uint32_t flags() const { return flags_; }
  void set_flags(uint32_t flags) { flags_ = flags; }
  std::string content_name() const { return content_name_; }
  int component() const { return component_; }
  const std::string& ice_ufrag() const { return ice_ufrag_; }
  const std::string& ice_pwd() const { return ice_pwd_; }
  bool pooled() const { return ice_ufrag_.empty(); }

  // Setting this filter should affect not only candidates gathered in the
  // future, but candidates already gathered and ports already "ready",
  // which would be returned by ReadyCandidates() and ReadyPorts().
  //
  // Default filter should be CF_ALL.
  virtual void SetCandidateFilter(uint32_t filter) = 0;

  // Starts gathering ports and ICE candidates.
  virtual void StartGettingPorts() = 0;
  // Completely stops gathering. Will not gather again unless StartGettingPorts
  // is called again.
  virtual void StopGettingPorts() = 0;
  // Whether the session is actively getting ports.
  virtual bool IsGettingPorts() = 0;

  //
  // NOTE: The group of methods below is only used for continual gathering.
  //

  // ClearGettingPorts should have the same immediate effect as
  // StopGettingPorts, but if the implementation supports continual gathering,
  // ClearGettingPorts allows additional ports/candidates to be gathered if the
  // network conditions change.
  virtual void ClearGettingPorts() = 0;
  // Whether it is in the state where the existing gathering process is stopped,
  // but new ones may be started (basically after calling ClearGettingPorts).
  virtual bool IsCleared() const { return false; }
  // Whether the session has completely stopped.
  virtual bool IsStopped() const { return false; }
  // Re-gathers candidates on networks that do not have any connections. More
  // precisely, a network interface may have more than one IP addresses (e.g.,
  // IPv4 and IPv6 addresses). Each address subnet will be used to create a
  // network. Only if all networks of an interface have no connection, the
  // implementation should start re-gathering on all networks of that interface.
  virtual void RegatherOnFailedNetworks() {}
  // Re-gathers candidates on all networks.
  // TODO(honghaiz): Implement this in BasicPortAllocator.
  virtual void RegatherOnAllNetworks() {}

  // Another way of getting the information provided by the signals below.
  //
  // Ports and candidates are not guaranteed to be in the same order as the
  // signals were emitted in.
  virtual std::vector<PortInterface*> ReadyPorts() const = 0;
  virtual std::vector<Candidate> ReadyCandidates() const = 0;
  virtual bool CandidatesAllocationDone() const = 0;
  // Marks all ports in the current session as "pruned" so that they may be
  // destroyed if no connection is using them.
  virtual void PruneAllPorts() {}

  sigslot::signal2<PortAllocatorSession*, PortInterface*> SignalPortReady;
  // Fires this signal when the network of the ports failed (either because the
  // interface is down, or because there is no connection on the interface),
  // or when TURN ports are pruned because a higher-priority TURN port becomes
  // ready(pairable).
  sigslot::signal2<PortAllocatorSession*, const std::vector<PortInterface*>&>
      SignalPortsPruned;
  sigslot::signal2<PortAllocatorSession*,
                   const std::vector<Candidate>&> SignalCandidatesReady;
  // Candidates should be signaled to be removed when the port that generated
  // the candidates is removed.
  sigslot::signal2<PortAllocatorSession*, const std::vector<Candidate>&>
      SignalCandidatesRemoved;
  sigslot::signal1<PortAllocatorSession*> SignalCandidatesAllocationDone;

  sigslot::signal2<PortAllocatorSession*, IceRegatheringReason>
      SignalIceRegathering;

  virtual uint32_t generation() { return generation_; }
  virtual void set_generation(uint32_t generation) { generation_ = generation; }
  sigslot::signal1<PortAllocatorSession*> SignalDestroyed;

 protected:
  // This method is called when a pooled session (which doesn't have these
  // properties initially) is returned by PortAllocator::TakePooledSession,
  // and the content name, component, and ICE ufrag/pwd are updated.
  //
  // A subclass may need to override this method to perform additional actions,
  // such as applying the updated information to ports and candidates.
  virtual void UpdateIceParametersInternal() {}

  // TODO(deadbeef): Get rid of these when everyone switches to ice_ufrag and
  // ice_pwd.
  const std::string& username() const { return ice_ufrag_; }
  const std::string& password() const { return ice_pwd_; }

 private:
  void SetIceParameters(const std::string& content_name,
                        int component,
                        const std::string& ice_ufrag,
                        const std::string& ice_pwd) {
    content_name_ = content_name;
    component_ = component;
    ice_ufrag_ = ice_ufrag;
    ice_pwd_ = ice_pwd;
    UpdateIceParametersInternal();
  }

  uint32_t flags_;
  uint32_t generation_;
  std::string content_name_;
  int component_;
  std::string ice_ufrag_;
  std::string ice_pwd_;

  // SetIceParameters is an implementation detail which only PortAllocator
  // should be able to call.
  friend class PortAllocator;
};

// Every method of PortAllocator (including the destructor) must be called on
// the same thread, except for the constructor which may be called on any
// thread.
//
// This allows constructing a PortAllocator subclass on one thread and
// passing it into an object that uses it on a different thread.
class PortAllocator : public sigslot::has_slots<> {
 public:
  PortAllocator() :
      flags_(kDefaultPortAllocatorFlags),
      min_port_(0),
      max_port_(0),
      step_delay_(kDefaultStepDelay),
      allow_tcp_listen_(true),
      candidate_filter_(CF_ALL) {
  }
  virtual ~PortAllocator() {}

  // This should be called on the PortAllocator's thread before the
  // PortAllocator is used. Subclasses may override this if necessary.
  virtual void Initialize() {}

  // Set STUN and TURN servers to be used in future sessions, and set
  // candidate pool size, as described in JSEP.
  //
  // If the servers are changing and the candidate pool size is nonzero,
  // existing pooled sessions will be destroyed and new ones created.
  //
  // If the servers are not changing but the candidate pool size is,
  // pooled sessions will be either created or destroyed as necessary.
  //
  // Returns true if the configuration could successfully be changed.
  bool SetConfiguration(const ServerAddresses& stun_servers,
                        const std::vector<RelayServerConfig>& turn_servers,
                        int candidate_pool_size,
                        bool prune_turn_ports);

  const ServerAddresses& stun_servers() const { return stun_servers_; }

  const std::vector<RelayServerConfig>& turn_servers() const {
    return turn_servers_;
  }

  int candidate_pool_size() const { return candidate_pool_size_; }

  // Sets the network types to ignore.
  // Values are defined by the AdapterType enum.
  // For instance, calling this with
  // ADAPTER_TYPE_ETHERNET | ADAPTER_TYPE_LOOPBACK will ignore Ethernet and
  // loopback interfaces.
  virtual void SetNetworkIgnoreMask(int network_ignore_mask) = 0;

  std::unique_ptr<PortAllocatorSession> CreateSession(
      const std::string& content_name,
      int component,
      const std::string& ice_ufrag,
      const std::string& ice_pwd);

  // Get an available pooled session and set the transport information on it.
  //
  // Caller takes ownership of the returned session.
  //
  // If no pooled sessions are available, returns null.
  std::unique_ptr<PortAllocatorSession> TakePooledSession(
      const std::string& content_name,
      int component,
      const std::string& ice_ufrag,
      const std::string& ice_pwd);

  // Returns the next session that would be returned by TakePooledSession.
  const PortAllocatorSession* GetPooledSession() const;

  uint32_t flags() const { return flags_; }
  void set_flags(uint32_t flags) { flags_ = flags; }

  const std::string& user_agent() const { return agent_; }
  const rtc::ProxyInfo& proxy() const { return proxy_; }
  void set_proxy(const std::string& agent, const rtc::ProxyInfo& proxy) {
    agent_ = agent;
    proxy_ = proxy;
  }

  // Gets/Sets the port range to use when choosing client ports.
  int min_port() const { return min_port_; }
  int max_port() const { return max_port_; }
  bool SetPortRange(int min_port, int max_port) {
    if (min_port > max_port) {
      return false;
    }

    min_port_ = min_port;
    max_port_ = max_port;
    return true;
  }

  uint32_t step_delay() const { return step_delay_; }
  void set_step_delay(uint32_t delay) { step_delay_ = delay; }

  bool allow_tcp_listen() const { return allow_tcp_listen_; }
  void set_allow_tcp_listen(bool allow_tcp_listen) {
    allow_tcp_listen_ = allow_tcp_listen;
  }

  uint32_t candidate_filter() { return candidate_filter_; }
  void set_candidate_filter(uint32_t filter) {
    candidate_filter_ = filter;
  }

  bool prune_turn_ports() const { return prune_turn_ports_; }

  // Gets/Sets the Origin value used for WebRTC STUN requests.
  const std::string& origin() const { return origin_; }
  void set_origin(const std::string& origin) { origin_ = origin; }

  void SetMetricsObserver(webrtc::MetricsObserverInterface* observer) {
    metrics_observer_ = observer;
  }

 protected:
  virtual PortAllocatorSession* CreateSessionInternal(
      const std::string& content_name,
      int component,
      const std::string& ice_ufrag,
      const std::string& ice_pwd) = 0;

  webrtc::MetricsObserverInterface* metrics_observer() {
    return metrics_observer_;
  }

  const std::deque<std::unique_ptr<PortAllocatorSession>>& pooled_sessions() {
    return pooled_sessions_;
  }

  uint32_t flags_;
  std::string agent_;
  rtc::ProxyInfo proxy_;
  int min_port_;
  int max_port_;
  uint32_t step_delay_;
  bool allow_tcp_listen_;
  uint32_t candidate_filter_;
  std::string origin_;

 private:
  ServerAddresses stun_servers_;
  std::vector<RelayServerConfig> turn_servers_;
  int candidate_pool_size_ = 0;  // Last value passed into SetConfiguration.
  std::deque<std::unique_ptr<PortAllocatorSession>> pooled_sessions_;
  bool prune_turn_ports_ = false;

  webrtc::MetricsObserverInterface* metrics_observer_ = nullptr;
};

}  // namespace cricket

#endif  // WEBRTC_P2P_BASE_PORTALLOCATOR_H_
