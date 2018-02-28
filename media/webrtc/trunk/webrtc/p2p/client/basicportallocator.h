/*
 *  Copyright 2004 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef WEBRTC_P2P_CLIENT_BASICPORTALLOCATOR_H_
#define WEBRTC_P2P_CLIENT_BASICPORTALLOCATOR_H_

#include <memory>
#include <string>
#include <vector>

#include "webrtc/p2p/base/portallocator.h"
#include "webrtc/base/checks.h"
#include "webrtc/base/messagequeue.h"
#include "webrtc/base/network.h"
#include "webrtc/base/thread.h"

namespace cricket {

class BasicPortAllocator : public PortAllocator {
 public:
  BasicPortAllocator(rtc::NetworkManager* network_manager,
                     rtc::PacketSocketFactory* socket_factory);
  explicit BasicPortAllocator(rtc::NetworkManager* network_manager);
  BasicPortAllocator(rtc::NetworkManager* network_manager,
                     rtc::PacketSocketFactory* socket_factory,
                     const ServerAddresses& stun_servers);
  BasicPortAllocator(rtc::NetworkManager* network_manager,
                     const ServerAddresses& stun_servers,
                     const rtc::SocketAddress& relay_server_udp,
                     const rtc::SocketAddress& relay_server_tcp,
                     const rtc::SocketAddress& relay_server_ssl);
  virtual ~BasicPortAllocator();

  // Set to kDefaultNetworkIgnoreMask by default.
  void SetNetworkIgnoreMask(int network_ignore_mask) override {
    // TODO(phoglund): implement support for other types than loopback.
    // See https://code.google.com/p/webrtc/issues/detail?id=4288.
    // Then remove set_network_ignore_list from NetworkManager.
    network_ignore_mask_ = network_ignore_mask;
  }

  int network_ignore_mask() const { return network_ignore_mask_; }

  rtc::NetworkManager* network_manager() const { return network_manager_; }

  // If socket_factory() is set to NULL each PortAllocatorSession
  // creates its own socket factory.
  rtc::PacketSocketFactory* socket_factory() { return socket_factory_; }

  PortAllocatorSession* CreateSessionInternal(
      const std::string& content_name,
      int component,
      const std::string& ice_ufrag,
      const std::string& ice_pwd) override;

  // Convenience method that adds a TURN server to the configuration.
  void AddTurnServer(const RelayServerConfig& turn_server);

 private:
  void Construct();

  void OnIceRegathering(PortAllocatorSession* session,
                        IceRegatheringReason reason);

  rtc::NetworkManager* network_manager_;
  rtc::PacketSocketFactory* socket_factory_;
  bool allow_tcp_listen_;
  int network_ignore_mask_ = rtc::kDefaultNetworkIgnoreMask;
};

struct PortConfiguration;
class AllocationSequence;

enum class SessionState {
  GATHERING,  // Actively allocating ports and gathering candidates.
  CLEARED,    // Current allocation process has been stopped but may start
              // new ones.
  STOPPED     // This session has completely stopped, no new allocation
              // process will be started.
};

class BasicPortAllocatorSession : public PortAllocatorSession,
                                  public rtc::MessageHandler {
 public:
  BasicPortAllocatorSession(BasicPortAllocator* allocator,
                            const std::string& content_name,
                            int component,
                            const std::string& ice_ufrag,
                            const std::string& ice_pwd);
  ~BasicPortAllocatorSession();

  virtual BasicPortAllocator* allocator() { return allocator_; }
  rtc::Thread* network_thread() { return network_thread_; }
  rtc::PacketSocketFactory* socket_factory() { return socket_factory_; }

  void SetCandidateFilter(uint32_t filter) override;
  void StartGettingPorts() override;
  void StopGettingPorts() override;
  void ClearGettingPorts() override;
  bool IsGettingPorts() override { return state_ == SessionState::GATHERING; }
  bool IsCleared() const override { return state_ == SessionState::CLEARED; }
  bool IsStopped() const override { return state_ == SessionState::STOPPED; }
  // These will all be cricket::Ports.
  std::vector<PortInterface*> ReadyPorts() const override;
  std::vector<Candidate> ReadyCandidates() const override;
  bool CandidatesAllocationDone() const override;
  void RegatherOnFailedNetworks() override;
  void PruneAllPorts() override;

 protected:
  void UpdateIceParametersInternal() override;

  // Starts the process of getting the port configurations.
  virtual void GetPortConfigurations();

  // Adds a port configuration that is now ready.  Once we have one for each
  // network (or a timeout occurs), we will start allocating ports.
  virtual void ConfigReady(PortConfiguration* config);

  // MessageHandler.  Can be overriden if message IDs do not conflict.
  void OnMessage(rtc::Message* message) override;

 private:
  class PortData {
   public:
    PortData() {}
    PortData(Port* port, AllocationSequence* seq)
        : port_(port), sequence_(seq) {}

    Port* port() const { return port_; }
    AllocationSequence* sequence() const { return sequence_; }
    bool has_pairable_candidate() const { return has_pairable_candidate_; }
    bool complete() const { return state_ == STATE_COMPLETE; }
    bool error() const { return state_ == STATE_ERROR; }
    bool pruned() const { return state_ == STATE_PRUNED; }
    bool inprogress() const { return state_ == STATE_INPROGRESS; }
    // Returns true if this port is ready to be used.
    bool ready() const {
      return has_pairable_candidate_ && state_ != STATE_ERROR &&
             state_ != STATE_PRUNED;
    }
    // Sets the state to "PRUNED" and prunes the Port.
    void Prune() {
      state_ = STATE_PRUNED;
      if (port()) {
        port()->Prune();
      }
    }
    void set_has_pairable_candidate(bool has_pairable_candidate) {
      if (has_pairable_candidate) {
        RTC_DCHECK(state_ == STATE_INPROGRESS);
      }
      has_pairable_candidate_ = has_pairable_candidate;
    }
    void set_complete() {
      state_ = STATE_COMPLETE;
    }
    void set_error() {
      RTC_DCHECK(state_ == STATE_INPROGRESS);
      state_ = STATE_ERROR;
    }

   private:
    enum State {
      STATE_INPROGRESS,  // Still gathering candidates.
      STATE_COMPLETE,    // All candidates allocated and ready for process.
      STATE_ERROR,       // Error in gathering candidates.
      STATE_PRUNED       // Pruned by higher priority ports on the same network
                         // interface. Only TURN ports may be pruned.
    };
    Port* port_ = nullptr;
    AllocationSequence* sequence_ = nullptr;
    bool has_pairable_candidate_ = false;
    State state_ = STATE_INPROGRESS;
  };

  void OnConfigReady(PortConfiguration* config);
  void OnConfigStop();
  void AllocatePorts();
  void OnAllocate();
  void DoAllocate();
  void OnNetworksChanged();
  void OnAllocationSequenceObjectsCreated();
  void DisableEquivalentPhases(rtc::Network* network,
                               PortConfiguration* config,
                               uint32_t* flags);
  void AddAllocatedPort(Port* port, AllocationSequence* seq,
                        bool prepare_address);
  void OnCandidateReady(Port* port, const Candidate& c);
  void OnPortComplete(Port* port);
  void OnPortError(Port* port);
  void OnProtocolEnabled(AllocationSequence* seq, ProtocolType proto);
  void OnPortDestroyed(PortInterface* port);
  void MaybeSignalCandidatesAllocationDone();
  void OnPortAllocationComplete(AllocationSequence* seq);
  PortData* FindPort(Port* port);
  std::vector<rtc::Network*> GetNetworks();
  std::vector<rtc::Network*> GetFailedNetworks();

  bool CheckCandidateFilter(const Candidate& c) const;
  bool CandidatePairable(const Candidate& c, const Port* port) const;
  // Clear the related address according to the flags and candidate filter
  // in order to avoid leaking any information.
  Candidate SanitizeRelatedAddress(const Candidate& c) const;

  std::vector<PortData*> GetUnprunedPorts(
      const std::vector<rtc::Network*>& networks);
  // Prunes ports and signal the remote side to remove the candidates that
  // were previously signaled from these ports.
  void PrunePortsAndRemoveCandidates(
      const std::vector<PortData*>& port_data_list);
  // Gets filtered and sanitized candidates generated from a port and
  // append to |candidates|.
  void GetCandidatesFromPort(const PortData& data,
                             std::vector<Candidate>* candidates) const;
  Port* GetBestTurnPortForNetwork(const std::string& network_name) const;
  // Returns true if at least one TURN port is pruned.
  bool PruneTurnPorts(Port* newly_pairable_turn_port);

  BasicPortAllocator* allocator_;
  rtc::Thread* network_thread_;
  std::unique_ptr<rtc::PacketSocketFactory> owned_socket_factory_;
  rtc::PacketSocketFactory* socket_factory_;
  bool allocation_started_;
  bool network_manager_started_;
  bool allocation_sequences_created_;
  std::vector<PortConfiguration*> configs_;
  std::vector<AllocationSequence*> sequences_;
  std::vector<PortData> ports_;
  uint32_t candidate_filter_ = CF_ALL;
  // Whether to prune low-priority ports, taken from the port allocator.
  bool prune_turn_ports_;
  SessionState state_ = SessionState::CLEARED;

  friend class AllocationSequence;
};

// Records configuration information useful in creating ports.
// TODO(deadbeef): Rename "relay" to "turn_server" in this struct.
struct PortConfiguration : public rtc::MessageData {
  // TODO(jiayl): remove |stun_address| when Chrome is updated.
  rtc::SocketAddress stun_address;
  ServerAddresses stun_servers;
  std::string username;
  std::string password;

  typedef std::vector<RelayServerConfig> RelayList;
  RelayList relays;

  // TODO(jiayl): remove this ctor when Chrome is updated.
  PortConfiguration(const rtc::SocketAddress& stun_address,
                    const std::string& username,
                    const std::string& password);

  PortConfiguration(const ServerAddresses& stun_servers,
                    const std::string& username,
                    const std::string& password);

  // Returns addresses of both the explicitly configured STUN servers,
  // and TURN servers that should be used as STUN servers.
  ServerAddresses StunServers();

  // Adds another relay server, with the given ports and modifier, to the list.
  void AddRelay(const RelayServerConfig& config);

  // Determines whether the given relay server supports the given protocol.
  bool SupportsProtocol(const RelayServerConfig& relay,
                        ProtocolType type) const;
  bool SupportsProtocol(RelayType turn_type, ProtocolType type) const;
  // Helper method returns the server addresses for the matching RelayType and
  // Protocol type.
  ServerAddresses GetRelayServerAddresses(
      RelayType turn_type, ProtocolType type) const;
};

class UDPPort;
class TurnPort;

// Performs the allocation of ports, in a sequenced (timed) manner, for a given
// network and IP address.
class AllocationSequence : public rtc::MessageHandler,
                           public sigslot::has_slots<> {
 public:
  enum State {
    kInit,       // Initial state.
    kRunning,    // Started allocating ports.
    kStopped,    // Stopped from running.
    kCompleted,  // All ports are allocated.

    // kInit --> kRunning --> {kCompleted|kStopped}
  };
  AllocationSequence(BasicPortAllocatorSession* session,
                     rtc::Network* network,
                     PortConfiguration* config,
                     uint32_t flags);
  ~AllocationSequence();
  void Init();
  void Clear();
  void OnNetworkFailed();

  State state() const { return state_; }
  rtc::Network* network() const { return network_; }

  bool network_failed() const { return network_failed_; }
  void set_network_failed() { network_failed_ = true; }

  // Disables the phases for a new sequence that this one already covers for an
  // equivalent network setup.
  void DisableEquivalentPhases(rtc::Network* network,
                               PortConfiguration* config,
                               uint32_t* flags);

  // Starts and stops the sequence.  When started, it will continue allocating
  // new ports on its own timed schedule.
  void Start();
  void Stop();

  // MessageHandler
  void OnMessage(rtc::Message* msg);

  void EnableProtocol(ProtocolType proto);
  bool ProtocolEnabled(ProtocolType proto) const;

  // Signal from AllocationSequence, when it's done with allocating ports.
  // This signal is useful, when port allocation fails which doesn't result
  // in any candidates. Using this signal BasicPortAllocatorSession can send
  // its candidate discovery conclusion signal. Without this signal,
  // BasicPortAllocatorSession doesn't have any event to trigger signal. This
  // can also be achieved by starting timer in BPAS.
  sigslot::signal1<AllocationSequence*> SignalPortAllocationComplete;

 protected:
  // For testing.
  void CreateTurnPort(const RelayServerConfig& config);

 private:
  typedef std::vector<ProtocolType> ProtocolList;

  bool IsFlagSet(uint32_t flag) { return ((flags_ & flag) != 0); }
  void CreateUDPPorts();
  void CreateTCPPorts();
  void CreateStunPorts();
  void CreateRelayPorts();
  void CreateGturnPort(const RelayServerConfig& config);

  void OnReadPacket(rtc::AsyncPacketSocket* socket,
                    const char* data,
                    size_t size,
                    const rtc::SocketAddress& remote_addr,
                    const rtc::PacketTime& packet_time);

  void OnPortDestroyed(PortInterface* port);

  BasicPortAllocatorSession* session_;
  bool network_failed_ = false;
  rtc::Network* network_;
  rtc::IPAddress ip_;
  PortConfiguration* config_;
  State state_;
  uint32_t flags_;
  ProtocolList protocols_;
  std::unique_ptr<rtc::AsyncPacketSocket> udp_socket_;
  // There will be only one udp port per AllocationSequence.
  UDPPort* udp_port_;
  std::vector<TurnPort*> turn_ports_;
  int phase_;
};

}  // namespace cricket

#endif  // WEBRTC_P2P_CLIENT_BASICPORTALLOCATOR_H_
