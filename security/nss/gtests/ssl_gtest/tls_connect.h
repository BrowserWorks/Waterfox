/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef tls_connect_h_
#define tls_connect_h_

#include <tuple>

#include "sslproto.h"
#include "sslt.h"

#include "tls_agent.h"
#include "tls_filter.h"

#define GTEST_HAS_RTTI 0
#include "gtest/gtest.h"

namespace nss_test {

extern std::string VersionString(uint16_t version);

// A generic TLS connection test base.
class TlsConnectTestBase : public ::testing::Test {
 public:
  static ::testing::internal::ParamGenerator<SSLProtocolVariant>
      kTlsVariantsStream;
  static ::testing::internal::ParamGenerator<SSLProtocolVariant>
      kTlsVariantsDatagram;
  static ::testing::internal::ParamGenerator<SSLProtocolVariant>
      kTlsVariantsAll;
  static ::testing::internal::ParamGenerator<uint16_t> kTlsV10;
  static ::testing::internal::ParamGenerator<uint16_t> kTlsV11;
  static ::testing::internal::ParamGenerator<uint16_t> kTlsV12;
  static ::testing::internal::ParamGenerator<uint16_t> kTlsV10V11;
  static ::testing::internal::ParamGenerator<uint16_t> kTlsV11V12;
  static ::testing::internal::ParamGenerator<uint16_t> kTlsV10ToV12;
  static ::testing::internal::ParamGenerator<uint16_t> kTlsV13;
  static ::testing::internal::ParamGenerator<uint16_t> kTlsV11Plus;
  static ::testing::internal::ParamGenerator<uint16_t> kTlsV12Plus;
  static ::testing::internal::ParamGenerator<uint16_t> kTlsVAll;

  TlsConnectTestBase(SSLProtocolVariant variant, uint16_t version);
  virtual ~TlsConnectTestBase();

  void SetUp();
  void TearDown();

  // Initialize client and server.
  void Init();
  // Clear the statistics.
  void ClearStats();
  // Clear the server session cache.
  void ClearServerCache();
  // Make sure TLS is configured for a connection.
  void EnsureTlsSetup();
  // Reset and keep the same certificate names
  void Reset();
  // Reset, and update the certificate names on both peers
  void Reset(const std::string& server_name,
             const std::string& client_name = "client");

  // Run the handshake.
  void Handshake();
  // Connect and check that it works.
  void Connect();
  // Check that the connection was successfully established.
  void CheckConnected();
  // Connect and expect it to fail.
  void ConnectExpectFail();
  void ExpectAlert(std::shared_ptr<TlsAgent>& sender, uint8_t alert);
  void ConnectExpectAlert(std::shared_ptr<TlsAgent>& sender, uint8_t alert);
  void ConnectExpectFailOneSide(TlsAgent::Role failingSide);
  void ConnectWithCipherSuite(uint16_t cipher_suite);
  // Check that the keys used in the handshake match expectations.
  void CheckKeys(SSLKEAType kea_type, SSLNamedGroup kea_group,
                 SSLAuthType auth_type, SSLSignatureScheme sig_scheme) const;
  // This version guesses some of the values.
  void CheckKeys(SSLKEAType kea_type, SSLAuthType auth_type) const;
  // This version assumes defaults.
  void CheckKeys() const;
  void CheckGroups(const DataBuffer& groups,
                   std::function<void(SSLNamedGroup)> check_group);
  void CheckShares(const DataBuffer& shares,
                   std::function<void(SSLNamedGroup)> check_group);

  void ConfigureVersion(uint16_t version);
  void SetExpectedVersion(uint16_t version);
  // Expect resumption of a particular type.
  void ExpectResumption(SessionResumptionMode expected);
  void DisableAllCiphers();
  void EnableOnlyStaticRsaCiphers();
  void EnableOnlyDheCiphers();
  void EnableSomeEcdhCiphers();
  void EnableExtendedMasterSecret();
  void ConfigureSessionCache(SessionResumptionMode client,
                             SessionResumptionMode server);
  void EnableAlpn();
  void EnableAlpn(const uint8_t* val, size_t len);
  void EnsureModelSockets();
  void CheckAlpn(const std::string& val);
  void EnableSrtp();
  void CheckSrtp() const;
  void SendReceive();
  void SetupForZeroRtt();
  void SetupForResume();
  void ZeroRttSendReceive(
      bool expect_writable, bool expect_readable,
      std::function<bool()> post_clienthello_check = nullptr);
  void Receive(size_t amount);
  void ExpectExtendedMasterSecret(bool expected);
  void ExpectEarlyDataAccepted(bool expected);
  void DisableECDHEServerKeyReuse();
  void SkipVersionChecks();

 protected:
  SSLProtocolVariant variant_;
  std::shared_ptr<TlsAgent> client_;
  std::shared_ptr<TlsAgent> server_;
  std::unique_ptr<TlsAgent> client_model_;
  std::unique_ptr<TlsAgent> server_model_;
  uint16_t version_;
  SessionResumptionMode expected_resumption_mode_;
  std::vector<std::vector<uint8_t>> session_ids_;

  // A simple value of "a", "b".  Note that the preferred value of "a" is placed
  // at the end, because the NSS API follows the now defunct NPN specification,
  // which places the preferred (and default) entry at the end of the list.
  // NSS will move this final entry to the front when used with ALPN.
  const uint8_t alpn_dummy_val_[4] = {0x01, 0x62, 0x01, 0x61};

 private:
  void CheckResumption(SessionResumptionMode expected);
  void CheckExtendedMasterSecret();
  void CheckEarlyDataAccepted();

  bool expect_extended_master_secret_;
  bool expect_early_data_accepted_;
  bool skip_version_checks_;

  // Track groups and make sure that there are no duplicates.
  class DuplicateGroupChecker {
   public:
    void AddAndCheckGroup(SSLNamedGroup group) {
      EXPECT_EQ(groups_.end(), groups_.find(group))
          << "Group " << group << " should not be duplicated";
      groups_.insert(group);
    }

   private:
    std::set<SSLNamedGroup> groups_;
  };
};

// A non-parametrized TLS test base.
class TlsConnectTest : public TlsConnectTestBase {
 public:
  TlsConnectTest() : TlsConnectTestBase(ssl_variant_stream, 0) {}
};

// A non-parametrized DTLS-only test base.
class DtlsConnectTest : public TlsConnectTestBase {
 public:
  DtlsConnectTest() : TlsConnectTestBase(ssl_variant_datagram, 0) {}
};

// A TLS-only test base.
class TlsConnectStream : public TlsConnectTestBase,
                         public ::testing::WithParamInterface<uint16_t> {
 public:
  TlsConnectStream() : TlsConnectTestBase(ssl_variant_stream, GetParam()) {}
};

// A TLS-only test base for tests before 1.3
class TlsConnectStreamPre13 : public TlsConnectStream {};

// A DTLS-only test base.
class TlsConnectDatagram : public TlsConnectTestBase,
                           public ::testing::WithParamInterface<uint16_t> {
 public:
  TlsConnectDatagram() : TlsConnectTestBase(ssl_variant_datagram, GetParam()) {}
};

// A generic test class that can be either stream or datagram and a single
// version of TLS.  This is configured in ssl_loopback_unittest.cc.
class TlsConnectGeneric : public TlsConnectTestBase,
                          public ::testing::WithParamInterface<
                              std::tuple<SSLProtocolVariant, uint16_t>> {
 public:
  TlsConnectGeneric();
};

// A Pre TLS 1.2 generic test.
class TlsConnectPre12 : public TlsConnectTestBase,
                        public ::testing::WithParamInterface<
                            std::tuple<SSLProtocolVariant, uint16_t>> {
 public:
  TlsConnectPre12();
};

// A TLS 1.2 only generic test.
class TlsConnectTls12
    : public TlsConnectTestBase,
      public ::testing::WithParamInterface<SSLProtocolVariant> {
 public:
  TlsConnectTls12();
};

// A TLS 1.2 only stream test.
class TlsConnectStreamTls12 : public TlsConnectTestBase {
 public:
  TlsConnectStreamTls12()
      : TlsConnectTestBase(ssl_variant_stream, SSL_LIBRARY_VERSION_TLS_1_2) {}
};

// A TLS 1.2+ generic test.
class TlsConnectTls12Plus : public TlsConnectTestBase,
                            public ::testing::WithParamInterface<
                                std::tuple<SSLProtocolVariant, uint16_t>> {
 public:
  TlsConnectTls12Plus();
};

// A TLS 1.3 only generic test.
class TlsConnectTls13
    : public TlsConnectTestBase,
      public ::testing::WithParamInterface<SSLProtocolVariant> {
 public:
  TlsConnectTls13();
};

// A TLS 1.3 only stream test.
class TlsConnectStreamTls13 : public TlsConnectTestBase {
 public:
  TlsConnectStreamTls13()
      : TlsConnectTestBase(ssl_variant_stream, SSL_LIBRARY_VERSION_TLS_1_3) {}
};

class TlsConnectDatagram13 : public TlsConnectTestBase {
 public:
  TlsConnectDatagram13()
      : TlsConnectTestBase(ssl_variant_datagram, SSL_LIBRARY_VERSION_TLS_1_3) {}
};

// A variant that is used only with Pre13.
class TlsConnectGenericPre13 : public TlsConnectGeneric {};

class TlsKeyExchangeTest : public TlsConnectGeneric {
 protected:
  std::shared_ptr<TlsExtensionCapture> groups_capture_;
  std::shared_ptr<TlsExtensionCapture> shares_capture_;
  std::shared_ptr<TlsExtensionCapture> shares_capture2_;
  std::shared_ptr<TlsInspectorRecordHandshakeMessage> capture_hrr_;

  void EnsureKeyShareSetup();
  void ConfigNamedGroups(const std::vector<SSLNamedGroup>& groups);
  std::vector<SSLNamedGroup> GetGroupDetails(const DataBuffer& ext);
  std::vector<SSLNamedGroup> GetShareDetails(const DataBuffer& ext);
  void CheckKEXDetails(const std::vector<SSLNamedGroup>& expectedGroups,
                       const std::vector<SSLNamedGroup>& expectedShares);
  void CheckKEXDetails(const std::vector<SSLNamedGroup>& expectedGroups,
                       const std::vector<SSLNamedGroup>& expectedShares,
                       SSLNamedGroup expectedShare2);

 private:
  void CheckKEXDetails(const std::vector<SSLNamedGroup>& expectedGroups,
                       const std::vector<SSLNamedGroup>& expectedShares,
                       bool expect_hrr);
};

class TlsKeyExchangeTest13 : public TlsKeyExchangeTest {};
class TlsKeyExchangeTestPre13 : public TlsKeyExchangeTest {};

}  // namespace nss_test

#endif
