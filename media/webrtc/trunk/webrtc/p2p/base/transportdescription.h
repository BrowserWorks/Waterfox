/*
 *  Copyright 2012 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef WEBRTC_P2P_BASE_TRANSPORTDESCRIPTION_H_
#define WEBRTC_P2P_BASE_TRANSPORTDESCRIPTION_H_

#include <algorithm>
#include <memory>
#include <string>
#include <vector>

#include "webrtc/p2p/base/p2pconstants.h"
#include "webrtc/base/sslfingerprint.h"

namespace cricket {

// SEC_ENABLED and SEC_REQUIRED should only be used if the session
// was negotiated over TLS, to protect the inline crypto material
// exchange.
// SEC_DISABLED: No crypto in outgoing offer, ignore any supplied crypto.
// SEC_ENABLED:  Crypto in outgoing offer and answer (if supplied in offer).
// SEC_REQUIRED: Crypto in outgoing offer and answer. Fail any offer with absent
//               or unsupported crypto.
// TODO(deadbeef): Remove this or rename it to something more appropriate, like
// SdesPolicy.
enum SecurePolicy {
  SEC_DISABLED,
  SEC_ENABLED,
  SEC_REQUIRED
};

// Whether our side of the call is driving the negotiation, or the other side.
enum IceRole {
  ICEROLE_CONTROLLING = 0,
  ICEROLE_CONTROLLED,
  ICEROLE_UNKNOWN
};

// ICE RFC 5245 implementation type.
enum IceMode {
  ICEMODE_FULL,  // As defined in http://tools.ietf.org/html/rfc5245#section-4.1
  ICEMODE_LITE   // As defined in http://tools.ietf.org/html/rfc5245#section-4.2
};

// RFC 4145 - http://tools.ietf.org/html/rfc4145#section-4
// 'active':  The endpoint will initiate an outgoing connection.
// 'passive': The endpoint will accept an incoming connection.
// 'actpass': The endpoint is willing to accept an incoming
//            connection or to initiate an outgoing connection.
enum ConnectionRole {
  CONNECTIONROLE_NONE = 0,
  CONNECTIONROLE_ACTIVE,
  CONNECTIONROLE_PASSIVE,
  CONNECTIONROLE_ACTPASS,
  CONNECTIONROLE_HOLDCONN,
};

struct IceParameters {
  // TODO(honghaiz): Include ICE mode in this structure to match the ORTC
  // struct:
  // http://ortc.org/wp-content/uploads/2016/03/ortc.html#idl-def-RTCIceParameters
  std::string ufrag;
  std::string pwd;
  bool renomination = false;
  IceParameters() = default;
  IceParameters(const std::string& ice_ufrag,
                const std::string& ice_pwd,
                bool ice_renomination)
      : ufrag(ice_ufrag), pwd(ice_pwd), renomination(ice_renomination) {}

  bool operator==(const IceParameters& other) {
    return ufrag == other.ufrag && pwd == other.pwd &&
           renomination == other.renomination;
  }
  bool operator!=(const IceParameters& other) { return !(*this == other); }
};

extern const char CONNECTIONROLE_ACTIVE_STR[];
extern const char CONNECTIONROLE_PASSIVE_STR[];
extern const char CONNECTIONROLE_ACTPASS_STR[];
extern const char CONNECTIONROLE_HOLDCONN_STR[];

constexpr auto ICE_RENOMINATION_STR = "renomination";

bool StringToConnectionRole(const std::string& role_str, ConnectionRole* role);
bool ConnectionRoleToString(const ConnectionRole& role, std::string* role_str);

struct TransportDescription {
  TransportDescription()
      : ice_mode(ICEMODE_FULL),
        connection_role(CONNECTIONROLE_NONE) {}

  TransportDescription(const std::vector<std::string>& transport_options,
                       const std::string& ice_ufrag,
                       const std::string& ice_pwd,
                       IceMode ice_mode,
                       ConnectionRole role,
                       const rtc::SSLFingerprint* identity_fingerprint)
      : transport_options(transport_options),
        ice_ufrag(ice_ufrag),
        ice_pwd(ice_pwd),
        ice_mode(ice_mode),
        connection_role(role),
        identity_fingerprint(CopyFingerprint(identity_fingerprint)) {}
  TransportDescription(const std::string& ice_ufrag,
                       const std::string& ice_pwd)
      : ice_ufrag(ice_ufrag),
        ice_pwd(ice_pwd),
        ice_mode(ICEMODE_FULL),
        connection_role(CONNECTIONROLE_NONE) {}
  TransportDescription(const TransportDescription& from)
      : transport_options(from.transport_options),
        ice_ufrag(from.ice_ufrag),
        ice_pwd(from.ice_pwd),
        ice_mode(from.ice_mode),
        connection_role(from.connection_role),
        identity_fingerprint(CopyFingerprint(from.identity_fingerprint.get())) {
  }

  TransportDescription& operator=(const TransportDescription& from) {
    // Self-assignment
    if (this == &from)
      return *this;

    transport_options = from.transport_options;
    ice_ufrag = from.ice_ufrag;
    ice_pwd = from.ice_pwd;
    ice_mode = from.ice_mode;
    connection_role = from.connection_role;

    identity_fingerprint.reset(CopyFingerprint(
        from.identity_fingerprint.get()));
    return *this;
  }

  bool HasOption(const std::string& option) const {
    return (std::find(transport_options.begin(), transport_options.end(),
                      option) != transport_options.end());
  }
  void AddOption(const std::string& option) {
    transport_options.push_back(option);
  }
  bool secure() const { return identity_fingerprint != NULL; }

  IceParameters GetIceParameters() {
    return IceParameters(ice_ufrag, ice_pwd, HasOption(ICE_RENOMINATION_STR));
  }

  static rtc::SSLFingerprint* CopyFingerprint(
      const rtc::SSLFingerprint* from) {
    if (!from)
      return NULL;

    return new rtc::SSLFingerprint(*from);
  }

  std::vector<std::string> transport_options;
  std::string ice_ufrag;
  std::string ice_pwd;
  IceMode ice_mode;
  ConnectionRole connection_role;

  std::unique_ptr<rtc::SSLFingerprint> identity_fingerprint;
};

}  // namespace cricket

#endif  // WEBRTC_P2P_BASE_TRANSPORTDESCRIPTION_H_
