/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "tls_agent.h"
#include "databuffer.h"
#include "keyhi.h"
#include "pk11func.h"
#include "ssl.h"
#include "sslerr.h"
#include "sslproto.h"
#include "tls_parser.h"

extern "C" {
// This is not something that should make you happy.
#include "libssl_internals.h"
}

#define GTEST_HAS_RTTI 0
#include "gtest/gtest.h"
#include "gtest_utils.h"
#include "scoped_ptrs.h"

extern std::string g_working_dir_path;

namespace nss_test {

const char* TlsAgent::states[] = {"INIT", "CONNECTING", "CONNECTED", "ERROR"};

const std::string TlsAgent::kClient = "client";    // both sign and encrypt
const std::string TlsAgent::kRsa2048 = "rsa2048";  // bigger
const std::string TlsAgent::kServerRsa = "rsa";    // both sign and encrypt
const std::string TlsAgent::kServerRsaSign = "rsa_sign";
const std::string TlsAgent::kServerRsaPss = "rsa_pss";
const std::string TlsAgent::kServerRsaDecrypt = "rsa_decrypt";
const std::string TlsAgent::kServerRsaChain = "rsa_chain";
const std::string TlsAgent::kServerEcdsa256 = "ecdsa256";
const std::string TlsAgent::kServerEcdsa384 = "ecdsa384";
const std::string TlsAgent::kServerEcdsa521 = "ecdsa521";
const std::string TlsAgent::kServerEcdhRsa = "ecdh_rsa";
const std::string TlsAgent::kServerEcdhEcdsa = "ecdh_ecdsa";
const std::string TlsAgent::kServerDsa = "dsa";

TlsAgent::TlsAgent(const std::string& name, Role role,
                   SSLProtocolVariant variant)
    : name_(name),
      variant_(variant),
      role_(role),
      server_key_bits_(0),
      adapter_(new DummyPrSocket(role_str(), variant)),
      ssl_fd_(nullptr),
      state_(STATE_INIT),
      timer_handle_(nullptr),
      falsestart_enabled_(false),
      expected_version_(0),
      expected_cipher_suite_(0),
      expect_resumption_(false),
      expect_client_auth_(false),
      can_falsestart_hook_called_(false),
      sni_hook_called_(false),
      auth_certificate_hook_called_(false),
      expected_received_alert_(kTlsAlertCloseNotify),
      expected_received_alert_level_(kTlsAlertWarning),
      expected_sent_alert_(kTlsAlertCloseNotify),
      expected_sent_alert_level_(kTlsAlertWarning),
      handshake_callback_called_(false),
      error_code_(0),
      send_ctr_(0),
      recv_ctr_(0),
      expect_readwrite_error_(false),
      handshake_callback_(),
      auth_certificate_callback_(),
      sni_callback_(),
      expect_short_headers_(false),
      skip_version_checks_(false) {
  memset(&info_, 0, sizeof(info_));
  memset(&csinfo_, 0, sizeof(csinfo_));
  SECStatus rv = SSL_VersionRangeGetDefault(variant_, &vrange_);
  EXPECT_EQ(SECSuccess, rv);
}

TlsAgent::~TlsAgent() {
  if (timer_handle_) {
    timer_handle_->Cancel();
  }

  if (adapter_) {
    Poller::Instance()->Cancel(READABLE_EVENT, adapter_);
  }

  // Add failures manually, if any, so we don't throw in a destructor.
  if (expected_received_alert_ != kTlsAlertCloseNotify ||
      expected_received_alert_level_ != kTlsAlertWarning) {
    ADD_FAILURE() << "Wrong expected_received_alert status";
  }
  if (expected_sent_alert_ != kTlsAlertCloseNotify ||
      expected_sent_alert_level_ != kTlsAlertWarning) {
    ADD_FAILURE() << "Wrong expected_sent_alert status";
  }
}

void TlsAgent::SetState(State state) {
  if (state_ == state) return;

  LOG("Changing state from " << state_ << " to " << state);
  state_ = state;
}

/*static*/ bool TlsAgent::LoadCertificate(const std::string& name,
                                          ScopedCERTCertificate* cert,
                                          ScopedSECKEYPrivateKey* priv) {
  cert->reset(PK11_FindCertFromNickname(name.c_str(), nullptr));
  EXPECT_NE(nullptr, cert->get());
  if (!cert->get()) return false;

  priv->reset(PK11_FindKeyByAnyCert(cert->get(), nullptr));
  EXPECT_NE(nullptr, priv->get());
  if (!priv->get()) return false;

  return true;
}

bool TlsAgent::ConfigServerCert(const std::string& name, bool updateKeyBits,
                                const SSLExtraServerCertData* serverCertData) {
  ScopedCERTCertificate cert;
  ScopedSECKEYPrivateKey priv;
  if (!TlsAgent::LoadCertificate(name, &cert, &priv)) {
    return false;
  }

  if (updateKeyBits) {
    ScopedSECKEYPublicKey pub(CERT_ExtractPublicKey(cert.get()));
    EXPECT_NE(nullptr, pub.get());
    if (!pub.get()) return false;
    server_key_bits_ = SECKEY_PublicKeyStrengthInBits(pub.get());
  }

  SECStatus rv =
      SSL_ConfigSecureServer(ssl_fd(), nullptr, nullptr, ssl_kea_null);
  EXPECT_EQ(SECFailure, rv);
  rv = SSL_ConfigServerCert(ssl_fd(), cert.get(), priv.get(), serverCertData,
                            serverCertData ? sizeof(*serverCertData) : 0);
  return rv == SECSuccess;
}

bool TlsAgent::EnsureTlsSetup(PRFileDesc* modelSocket) {
  // Don't set up twice
  if (ssl_fd_) return true;

  ScopedPRFileDesc dummy_fd(adapter_->CreateFD());
  EXPECT_NE(nullptr, dummy_fd);
  if (!dummy_fd) {
    return false;
  }
  if (adapter_->variant() == ssl_variant_stream) {
    ssl_fd_.reset(SSL_ImportFD(modelSocket, dummy_fd.get()));
  } else {
    ssl_fd_.reset(DTLS_ImportFD(modelSocket, dummy_fd.get()));
  }

  EXPECT_NE(nullptr, ssl_fd_);
  if (!ssl_fd_) {
    return false;
  }
  dummy_fd.release();  // Now subsumed by ssl_fd_.

  SECStatus rv;
  if (!skip_version_checks_) {
    rv = SSL_VersionRangeSet(ssl_fd(), &vrange_);
    EXPECT_EQ(SECSuccess, rv);
    if (rv != SECSuccess) return false;
  }

  if (role_ == SERVER) {
    EXPECT_TRUE(ConfigServerCert(name_, true));

    rv = SSL_SNISocketConfigHook(ssl_fd(), SniHook, this);
    EXPECT_EQ(SECSuccess, rv);
    if (rv != SECSuccess) return false;

    ScopedCERTCertList anchors(CERT_NewCertList());
    rv = SSL_SetTrustAnchors(ssl_fd(), anchors.get());
    if (rv != SECSuccess) return false;
  } else {
    rv = SSL_SetURL(ssl_fd(), "server");
    EXPECT_EQ(SECSuccess, rv);
    if (rv != SECSuccess) return false;
  }

  rv = SSL_AuthCertificateHook(ssl_fd(), AuthCertificateHook, this);
  EXPECT_EQ(SECSuccess, rv);
  if (rv != SECSuccess) return false;

  rv = SSL_AlertReceivedCallback(ssl_fd(), AlertReceivedCallback, this);
  EXPECT_EQ(SECSuccess, rv);
  if (rv != SECSuccess) return false;

  rv = SSL_AlertSentCallback(ssl_fd(), AlertSentCallback, this);
  EXPECT_EQ(SECSuccess, rv);
  if (rv != SECSuccess) return false;

  rv = SSL_HandshakeCallback(ssl_fd(), HandshakeCallback, this);
  EXPECT_EQ(SECSuccess, rv);
  if (rv != SECSuccess) return false;

  return true;
}

void TlsAgent::SetupClientAuth() {
  EXPECT_TRUE(EnsureTlsSetup());
  ASSERT_EQ(CLIENT, role_);

  EXPECT_EQ(SECSuccess,
            SSL_GetClientAuthDataHook(ssl_fd(), GetClientAuthDataHook,
                                      reinterpret_cast<void*>(this)));
}

SECStatus TlsAgent::GetClientAuthDataHook(void* self, PRFileDesc* fd,
                                          CERTDistNames* caNames,
                                          CERTCertificate** clientCert,
                                          SECKEYPrivateKey** clientKey) {
  TlsAgent* agent = reinterpret_cast<TlsAgent*>(self);
  ScopedCERTCertificate peerCert(SSL_PeerCertificate(agent->ssl_fd()));
  EXPECT_TRUE(peerCert) << "Client should be able to see the server cert";

  ScopedCERTCertificate cert;
  ScopedSECKEYPrivateKey priv;
  if (!TlsAgent::LoadCertificate(agent->name(), &cert, &priv)) {
    return SECFailure;
  }

  *clientCert = cert.release();
  *clientKey = priv.release();
  return SECSuccess;
}

bool TlsAgent::GetPeerChainLength(size_t* count) {
  CERTCertList* chain = SSL_PeerCertificateChain(ssl_fd());
  if (!chain) return false;
  *count = 0;

  for (PRCList* cursor = PR_NEXT_LINK(&chain->list); cursor != &chain->list;
       cursor = PR_NEXT_LINK(cursor)) {
    CERTCertListNode* node = (CERTCertListNode*)cursor;
    std::cerr << node->cert->subjectName << std::endl;
    ++(*count);
  }

  CERT_DestroyCertList(chain);

  return true;
}

void TlsAgent::CheckCipherSuite(uint16_t cipher_suite) {
  EXPECT_EQ(csinfo_.cipherSuite, cipher_suite);
}

void TlsAgent::RequestClientAuth(bool requireAuth) {
  EXPECT_TRUE(EnsureTlsSetup());
  ASSERT_EQ(SERVER, role_);

  EXPECT_EQ(SECSuccess,
            SSL_OptionSet(ssl_fd(), SSL_REQUEST_CERTIFICATE, PR_TRUE));
  EXPECT_EQ(SECSuccess, SSL_OptionSet(ssl_fd(), SSL_REQUIRE_CERTIFICATE,
                                      requireAuth ? PR_TRUE : PR_FALSE));

  EXPECT_EQ(SECSuccess, SSL_AuthCertificateHook(
                            ssl_fd(), &TlsAgent::ClientAuthenticated, this));
  expect_client_auth_ = true;
}

void TlsAgent::StartConnect(PRFileDesc* model) {
  EXPECT_TRUE(EnsureTlsSetup(model));

  SECStatus rv;
  rv = SSL_ResetHandshake(ssl_fd(), role_ == SERVER ? PR_TRUE : PR_FALSE);
  EXPECT_EQ(SECSuccess, rv);
  SetState(STATE_CONNECTING);
}

void TlsAgent::DisableAllCiphers() {
  for (size_t i = 0; i < SSL_NumImplementedCiphers; ++i) {
    SECStatus rv =
        SSL_CipherPrefSet(ssl_fd(), SSL_ImplementedCiphers[i], PR_FALSE);
    EXPECT_EQ(SECSuccess, rv);
  }
}

// Not actually all groups, just the onece that we are actually willing
// to use.
const std::vector<SSLNamedGroup> kAllDHEGroups = {
    ssl_grp_ec_curve25519, ssl_grp_ec_secp256r1, ssl_grp_ec_secp384r1,
    ssl_grp_ec_secp521r1,  ssl_grp_ffdhe_2048,   ssl_grp_ffdhe_3072,
    ssl_grp_ffdhe_4096,    ssl_grp_ffdhe_6144,   ssl_grp_ffdhe_8192};

const std::vector<SSLNamedGroup> kECDHEGroups = {
    ssl_grp_ec_curve25519, ssl_grp_ec_secp256r1, ssl_grp_ec_secp384r1,
    ssl_grp_ec_secp521r1};

const std::vector<SSLNamedGroup> kFFDHEGroups = {
    ssl_grp_ffdhe_2048, ssl_grp_ffdhe_3072, ssl_grp_ffdhe_4096,
    ssl_grp_ffdhe_6144, ssl_grp_ffdhe_8192};

// Defined because the big DHE groups are ridiculously slow.
const std::vector<SSLNamedGroup> kFasterDHEGroups = {
    ssl_grp_ec_curve25519, ssl_grp_ec_secp256r1, ssl_grp_ec_secp384r1,
    ssl_grp_ffdhe_2048, ssl_grp_ffdhe_3072};

void TlsAgent::EnableCiphersByKeyExchange(SSLKEAType kea) {
  EXPECT_TRUE(EnsureTlsSetup());

  for (size_t i = 0; i < SSL_NumImplementedCiphers; ++i) {
    SSLCipherSuiteInfo csinfo;

    SECStatus rv = SSL_GetCipherSuiteInfo(SSL_ImplementedCiphers[i], &csinfo,
                                          sizeof(csinfo));
    ASSERT_EQ(SECSuccess, rv);
    EXPECT_EQ(sizeof(csinfo), csinfo.length);

    if ((csinfo.keaType == kea) || (csinfo.keaType == ssl_kea_tls13_any)) {
      rv = SSL_CipherPrefSet(ssl_fd(), SSL_ImplementedCiphers[i], PR_TRUE);
      EXPECT_EQ(SECSuccess, rv);
    }
  }
}

void TlsAgent::EnableGroupsByKeyExchange(SSLKEAType kea) {
  switch (kea) {
    case ssl_kea_dh:
      ConfigNamedGroups(kFFDHEGroups);
      break;
    case ssl_kea_ecdh:
      ConfigNamedGroups(kECDHEGroups);
      break;
    default:
      break;
  }
}

void TlsAgent::EnableGroupsByAuthType(SSLAuthType authType) {
  if (authType == ssl_auth_ecdh_rsa || authType == ssl_auth_ecdh_ecdsa ||
      authType == ssl_auth_ecdsa || authType == ssl_auth_tls13_any) {
    ConfigNamedGroups(kECDHEGroups);
  }
}

void TlsAgent::EnableCiphersByAuthType(SSLAuthType authType) {
  EXPECT_TRUE(EnsureTlsSetup());

  for (size_t i = 0; i < SSL_NumImplementedCiphers; ++i) {
    SSLCipherSuiteInfo csinfo;

    SECStatus rv = SSL_GetCipherSuiteInfo(SSL_ImplementedCiphers[i], &csinfo,
                                          sizeof(csinfo));
    ASSERT_EQ(SECSuccess, rv);

    if ((csinfo.authType == authType) ||
        (csinfo.keaType == ssl_kea_tls13_any)) {
      rv = SSL_CipherPrefSet(ssl_fd(), SSL_ImplementedCiphers[i], PR_TRUE);
      EXPECT_EQ(SECSuccess, rv);
    }
  }
}

void TlsAgent::EnableSingleCipher(uint16_t cipher) {
  DisableAllCiphers();
  SECStatus rv = SSL_CipherPrefSet(ssl_fd(), cipher, PR_TRUE);
  EXPECT_EQ(SECSuccess, rv);
}

void TlsAgent::ConfigNamedGroups(const std::vector<SSLNamedGroup>& groups) {
  EXPECT_TRUE(EnsureTlsSetup());
  SECStatus rv = SSL_NamedGroupConfig(ssl_fd(), &groups[0], groups.size());
  EXPECT_EQ(SECSuccess, rv);
}

void TlsAgent::SetSessionTicketsEnabled(bool en) {
  EXPECT_TRUE(EnsureTlsSetup());

  SECStatus rv = SSL_OptionSet(ssl_fd(), SSL_ENABLE_SESSION_TICKETS,
                               en ? PR_TRUE : PR_FALSE);
  EXPECT_EQ(SECSuccess, rv);
}

void TlsAgent::SetSessionCacheEnabled(bool en) {
  EXPECT_TRUE(EnsureTlsSetup());

  SECStatus rv = SSL_OptionSet(ssl_fd(), SSL_NO_CACHE, en ? PR_FALSE : PR_TRUE);
  EXPECT_EQ(SECSuccess, rv);
}

void TlsAgent::Set0RttEnabled(bool en) {
  EXPECT_TRUE(EnsureTlsSetup());

  SECStatus rv =
      SSL_OptionSet(ssl_fd(), SSL_ENABLE_0RTT_DATA, en ? PR_TRUE : PR_FALSE);
  EXPECT_EQ(SECSuccess, rv);
}

void TlsAgent::SetFallbackSCSVEnabled(bool en) {
  EXPECT_TRUE(role_ == CLIENT && EnsureTlsSetup());

  SECStatus rv = SSL_OptionSet(ssl_fd(), SSL_ENABLE_FALLBACK_SCSV,
                               en ? PR_TRUE : PR_FALSE);
  EXPECT_EQ(SECSuccess, rv);
}

void TlsAgent::SetShortHeadersEnabled() {
  EXPECT_TRUE(EnsureTlsSetup());

  SECStatus rv = SSLInt_EnableShortHeaders(ssl_fd());
  EXPECT_EQ(SECSuccess, rv);
}

void TlsAgent::SetVersionRange(uint16_t minver, uint16_t maxver) {
  vrange_.min = minver;
  vrange_.max = maxver;

  if (ssl_fd()) {
    SECStatus rv = SSL_VersionRangeSet(ssl_fd(), &vrange_);
    EXPECT_EQ(SECSuccess, rv);
  }
}

void TlsAgent::GetVersionRange(uint16_t* minver, uint16_t* maxver) {
  *minver = vrange_.min;
  *maxver = vrange_.max;
}

void TlsAgent::SetExpectedVersion(uint16_t version) {
  expected_version_ = version;
}

void TlsAgent::SetServerKeyBits(uint16_t bits) { server_key_bits_ = bits; }

void TlsAgent::ExpectReadWriteError() { expect_readwrite_error_ = true; }

void TlsAgent::ExpectShortHeaders() { expect_short_headers_ = true; }

void TlsAgent::SkipVersionChecks() { skip_version_checks_ = true; }

void TlsAgent::SetSignatureSchemes(const SSLSignatureScheme* schemes,
                                   size_t count) {
  EXPECT_TRUE(EnsureTlsSetup());
  EXPECT_LE(count, SSL_SignatureMaxCount());
  EXPECT_EQ(SECSuccess,
            SSL_SignatureSchemePrefSet(ssl_fd(), schemes,
                                       static_cast<unsigned int>(count)));
  EXPECT_EQ(SECFailure, SSL_SignatureSchemePrefSet(ssl_fd(), schemes, 0))
      << "setting no schemes should fail and do nothing";

  std::vector<SSLSignatureScheme> configuredSchemes(count);
  unsigned int configuredCount;
  EXPECT_EQ(SECFailure,
            SSL_SignatureSchemePrefGet(ssl_fd(), nullptr, &configuredCount, 1))
      << "get schemes, schemes is nullptr";
  EXPECT_EQ(SECFailure,
            SSL_SignatureSchemePrefGet(ssl_fd(), &configuredSchemes[0],
                                       &configuredCount, 0))
      << "get schemes, too little space";
  EXPECT_EQ(SECFailure,
            SSL_SignatureSchemePrefGet(ssl_fd(), &configuredSchemes[0], nullptr,
                                       configuredSchemes.size()))
      << "get schemes, countOut is nullptr";

  EXPECT_EQ(SECSuccess, SSL_SignatureSchemePrefGet(
                            ssl_fd(), &configuredSchemes[0], &configuredCount,
                            configuredSchemes.size()));
  // SignatureSchemePrefSet drops unsupported algorithms silently, so the
  // number that are configured might be fewer.
  EXPECT_LE(configuredCount, count);
  unsigned int i = 0;
  for (unsigned int j = 0; j < count && i < configuredCount; ++j) {
    if (i < configuredCount && schemes[j] == configuredSchemes[i]) {
      ++i;
    }
  }
  EXPECT_EQ(i, configuredCount) << "schemes in use were all set";
}

void TlsAgent::CheckKEA(SSLKEAType kea_type, SSLNamedGroup kea_group,
                        size_t kea_size) const {
  EXPECT_EQ(STATE_CONNECTED, state_);
  EXPECT_EQ(kea_type, info_.keaType);
  if (kea_size == 0) {
    switch (kea_group) {
      case ssl_grp_ec_curve25519:
        kea_size = 255;
        break;
      case ssl_grp_ec_secp256r1:
        kea_size = 256;
        break;
      case ssl_grp_ec_secp384r1:
        kea_size = 384;
        break;
      case ssl_grp_ffdhe_2048:
        kea_size = 2048;
        break;
      case ssl_grp_ffdhe_3072:
        kea_size = 3072;
        break;
      case ssl_grp_ffdhe_custom:
        break;
      default:
        if (kea_type == ssl_kea_rsa) {
          kea_size = server_key_bits_;
        } else {
          EXPECT_TRUE(false) << "need to update group sizes";
        }
    }
  }
  if (kea_group != ssl_grp_ffdhe_custom) {
    EXPECT_EQ(kea_size, info_.keaKeyBits);
    EXPECT_EQ(kea_group, info_.keaGroup);
  }
}

void TlsAgent::CheckAuthType(SSLAuthType auth_type,
                             SSLSignatureScheme sig_scheme) const {
  EXPECT_EQ(STATE_CONNECTED, state_);
  EXPECT_EQ(auth_type, info_.authType);
  EXPECT_EQ(server_key_bits_, info_.authKeyBits);
  if (expected_version_ < SSL_LIBRARY_VERSION_TLS_1_2) {
    switch (auth_type) {
      case ssl_auth_rsa_sign:
        sig_scheme = ssl_sig_rsa_pkcs1_sha1md5;
        break;
      case ssl_auth_ecdsa:
        sig_scheme = ssl_sig_ecdsa_sha1;
        break;
      default:
        break;
    }
  }
  EXPECT_EQ(sig_scheme, info_.signatureScheme);

  if (info_.protocolVersion >= SSL_LIBRARY_VERSION_TLS_1_3) {
    return;
  }

  // Check authAlgorithm, which is the old value for authType.  This is a second
  // switch
  // statement because default label is different.
  switch (auth_type) {
    case ssl_auth_rsa_sign:
      EXPECT_EQ(ssl_auth_rsa_decrypt, csinfo_.authAlgorithm)
          << "authAlgorithm for RSA is always decrypt";
      break;
    case ssl_auth_ecdh_rsa:
      EXPECT_EQ(ssl_auth_rsa_decrypt, csinfo_.authAlgorithm)
          << "authAlgorithm for ECDH_RSA is RSA decrypt (i.e., wrong)";
      break;
    case ssl_auth_ecdh_ecdsa:
      EXPECT_EQ(ssl_auth_ecdsa, csinfo_.authAlgorithm)
          << "authAlgorithm for ECDH_ECDSA is ECDSA (i.e., wrong)";
      break;
    default:
      EXPECT_EQ(auth_type, csinfo_.authAlgorithm)
          << "authAlgorithm is (usually) the same as authType";
      break;
  }
}

void TlsAgent::EnableFalseStart() {
  EXPECT_TRUE(EnsureTlsSetup());

  falsestart_enabled_ = true;
  EXPECT_EQ(SECSuccess, SSL_SetCanFalseStartCallback(
                            ssl_fd(), CanFalseStartCallback, this));
  EXPECT_EQ(SECSuccess,
            SSL_OptionSet(ssl_fd(), SSL_ENABLE_FALSE_START, PR_TRUE));
}

void TlsAgent::ExpectResumption() { expect_resumption_ = true; }

void TlsAgent::EnableAlpn(const uint8_t* val, size_t len) {
  EXPECT_TRUE(EnsureTlsSetup());

  EXPECT_EQ(SECSuccess, SSL_OptionSet(ssl_fd(), SSL_ENABLE_ALPN, PR_TRUE));
  EXPECT_EQ(SECSuccess, SSL_SetNextProtoNego(ssl_fd(), val, len));
}

void TlsAgent::CheckAlpn(SSLNextProtoState expected_state,
                         const std::string& expected) const {
  SSLNextProtoState state;
  char chosen[10];
  unsigned int chosen_len;
  SECStatus rv = SSL_GetNextProto(ssl_fd(), &state,
                                  reinterpret_cast<unsigned char*>(chosen),
                                  &chosen_len, sizeof(chosen));
  EXPECT_EQ(SECSuccess, rv);
  EXPECT_EQ(expected_state, state);
  if (state == SSL_NEXT_PROTO_NO_SUPPORT) {
    EXPECT_EQ("", expected);
  } else {
    EXPECT_NE("", expected);
    EXPECT_EQ(expected, std::string(chosen, chosen_len));
  }
}

void TlsAgent::EnableSrtp() {
  EXPECT_TRUE(EnsureTlsSetup());
  const uint16_t ciphers[] = {SRTP_AES128_CM_HMAC_SHA1_80,
                              SRTP_AES128_CM_HMAC_SHA1_32};
  EXPECT_EQ(SECSuccess,
            SSL_SetSRTPCiphers(ssl_fd(), ciphers, PR_ARRAY_SIZE(ciphers)));
}

void TlsAgent::CheckSrtp() const {
  uint16_t actual;
  EXPECT_EQ(SECSuccess, SSL_GetSRTPCipher(ssl_fd(), &actual));
  EXPECT_EQ(SRTP_AES128_CM_HMAC_SHA1_80, actual);
}

void TlsAgent::CheckErrorCode(int32_t expected) const {
  EXPECT_EQ(STATE_ERROR, state_);
  EXPECT_EQ(expected, error_code_)
      << "Got error code " << PORT_ErrorToName(error_code_) << " expecting "
      << PORT_ErrorToName(expected) << std::endl;
}

static uint8_t GetExpectedAlertLevel(uint8_t alert) {
  switch (alert) {
    case kTlsAlertCloseNotify:
    case kTlsAlertEndOfEarlyData:
      return kTlsAlertWarning;
    default:
      break;
  }
  return kTlsAlertFatal;
}

void TlsAgent::ExpectReceiveAlert(uint8_t alert, uint8_t level) {
  expected_received_alert_ = alert;
  if (level == 0) {
    expected_received_alert_level_ = GetExpectedAlertLevel(alert);
  } else {
    expected_received_alert_level_ = level;
  }
}

void TlsAgent::ExpectSendAlert(uint8_t alert, uint8_t level) {
  expected_sent_alert_ = alert;
  if (level == 0) {
    expected_sent_alert_level_ = GetExpectedAlertLevel(alert);
  } else {
    expected_sent_alert_level_ = level;
  }
}

void TlsAgent::CheckAlert(bool sent, const SSLAlert* alert) {
  LOG(((alert->level == kTlsAlertWarning) ? "Warning" : "Fatal")
      << " alert " << (sent ? "sent" : "received") << ": "
      << static_cast<int>(alert->description));

  auto& expected = sent ? expected_sent_alert_ : expected_received_alert_;
  auto& expected_level =
      sent ? expected_sent_alert_level_ : expected_received_alert_level_;
  /* Silently pass close_notify in case the test has already ended. */
  if (expected == kTlsAlertCloseNotify && expected_level == kTlsAlertWarning &&
      alert->description == expected && alert->level == expected_level) {
    return;
  }

  EXPECT_EQ(expected, alert->description);
  EXPECT_EQ(expected_level, alert->level);
  expected = kTlsAlertCloseNotify;
  expected_level = kTlsAlertWarning;
}

void TlsAgent::WaitForErrorCode(int32_t expected, uint32_t delay) const {
  ASSERT_EQ(0, error_code_);
  WAIT_(error_code_ != 0, delay);
  EXPECT_EQ(expected, error_code_)
      << "Got error code " << PORT_ErrorToName(error_code_) << " expecting "
      << PORT_ErrorToName(expected) << std::endl;
}

void TlsAgent::CheckPreliminaryInfo() {
  SSLPreliminaryChannelInfo info;
  EXPECT_EQ(SECSuccess,
            SSL_GetPreliminaryChannelInfo(ssl_fd(), &info, sizeof(info)));
  EXPECT_EQ(sizeof(info), info.length);
  EXPECT_TRUE(info.valuesSet & ssl_preinfo_version);
  EXPECT_TRUE(info.valuesSet & ssl_preinfo_cipher_suite);

  // A version of 0 is invalid and indicates no expectation.  This value is
  // initialized to 0 so that tests that don't explicitly set an expected
  // version can negotiate a version.
  if (!expected_version_) {
    expected_version_ = info.protocolVersion;
  }
  EXPECT_EQ(expected_version_, info.protocolVersion);

  // As with the version; 0 is the null cipher suite (and also invalid).
  if (!expected_cipher_suite_) {
    expected_cipher_suite_ = info.cipherSuite;
  }
  EXPECT_EQ(expected_cipher_suite_, info.cipherSuite);
}

// Check that all the expected callbacks have been called.
void TlsAgent::CheckCallbacks() const {
  // If false start happens, the handshake is reported as being complete at the
  // point that false start happens.
  if (expect_resumption_ || !falsestart_enabled_) {
    EXPECT_TRUE(handshake_callback_called_);
  }

  // These callbacks shouldn't fire if we are resuming, except on TLS 1.3.
  if (role_ == SERVER) {
    PRBool have_sni = SSLInt_ExtensionNegotiated(ssl_fd(), ssl_server_name_xtn);
    EXPECT_EQ(((!expect_resumption_ && have_sni) ||
               expected_version_ >= SSL_LIBRARY_VERSION_TLS_1_3),
              sni_hook_called_);
  } else {
    EXPECT_EQ(!expect_resumption_, auth_certificate_hook_called_);
    // Note that this isn't unconditionally called, even with false start on.
    // But the callback is only skipped if a cipher that is ridiculously weak
    // (80 bits) is chosen.  Don't test that: plan to remove bad ciphers.
    EXPECT_EQ(falsestart_enabled_ && !expect_resumption_,
              can_falsestart_hook_called_);
  }
}

void TlsAgent::ResetPreliminaryInfo() {
  expected_version_ = 0;
  expected_cipher_suite_ = 0;
}

void TlsAgent::Connected() {
  if (state_ == STATE_CONNECTED) {
    return;
  }

  LOG("Handshake success");
  CheckPreliminaryInfo();
  CheckCallbacks();

  SECStatus rv = SSL_GetChannelInfo(ssl_fd(), &info_, sizeof(info_));
  EXPECT_EQ(SECSuccess, rv);
  EXPECT_EQ(sizeof(info_), info_.length);

  // Preliminary values are exposed through callbacks during the handshake.
  // If either expected values were set or the callbacks were called, check
  // that the final values are correct.
  EXPECT_EQ(expected_version_, info_.protocolVersion);
  EXPECT_EQ(expected_cipher_suite_, info_.cipherSuite);

  rv = SSL_GetCipherSuiteInfo(info_.cipherSuite, &csinfo_, sizeof(csinfo_));
  EXPECT_EQ(SECSuccess, rv);
  EXPECT_EQ(sizeof(csinfo_), csinfo_.length);

  if (expected_version_ >= SSL_LIBRARY_VERSION_TLS_1_3) {
    PRInt32 cipherSuites = SSLInt_CountTls13CipherSpecs(ssl_fd());
    // We use one ciphersuite in each direction, plus one that's kept around
    // by DTLS for retransmission.
    PRInt32 expected =
        ((variant_ == ssl_variant_datagram) && (role_ == CLIENT)) ? 3 : 2;
    EXPECT_EQ(expected, cipherSuites);
    if (expected != cipherSuites) {
      SSLInt_PrintTls13CipherSpecs(ssl_fd());
    }
  }

  PRBool short_headers;
  rv = SSLInt_UsingShortHeaders(ssl_fd(), &short_headers);
  EXPECT_EQ(SECSuccess, rv);
  EXPECT_EQ((PRBool)expect_short_headers_, short_headers);
  SetState(STATE_CONNECTED);
}

void TlsAgent::EnableExtendedMasterSecret() {
  ASSERT_TRUE(EnsureTlsSetup());

  SECStatus rv =
      SSL_OptionSet(ssl_fd(), SSL_ENABLE_EXTENDED_MASTER_SECRET, PR_TRUE);

  ASSERT_EQ(SECSuccess, rv);
}

void TlsAgent::CheckExtendedMasterSecret(bool expected) {
  if (version() >= SSL_LIBRARY_VERSION_TLS_1_3) {
    expected = PR_TRUE;
  }
  ASSERT_EQ(expected, info_.extendedMasterSecretUsed != PR_FALSE)
      << "unexpected extended master secret state for " << name_;
}

void TlsAgent::CheckEarlyDataAccepted(bool expected) {
  if (version() < SSL_LIBRARY_VERSION_TLS_1_3) {
    expected = false;
  }
  ASSERT_EQ(expected, info_.earlyDataAccepted != PR_FALSE)
      << "unexpected early data state for " << name_;
}

void TlsAgent::CheckSecretsDestroyed() {
  ASSERT_EQ(PR_TRUE, SSLInt_CheckSecretsDestroyed(ssl_fd()));
}

void TlsAgent::DisableRollbackDetection() {
  ASSERT_TRUE(EnsureTlsSetup());

  SECStatus rv = SSL_OptionSet(ssl_fd(), SSL_ROLLBACK_DETECTION, PR_FALSE);

  ASSERT_EQ(SECSuccess, rv);
}

void TlsAgent::EnableCompression() {
  ASSERT_TRUE(EnsureTlsSetup());

  SECStatus rv = SSL_OptionSet(ssl_fd(), SSL_ENABLE_DEFLATE, PR_TRUE);
  ASSERT_EQ(SECSuccess, rv);
}

void TlsAgent::SetDowngradeCheckVersion(uint16_t version) {
  ASSERT_TRUE(EnsureTlsSetup());

  SECStatus rv = SSL_SetDowngradeCheckVersion(ssl_fd(), version);
  ASSERT_EQ(SECSuccess, rv);
}

void TlsAgent::Handshake() {
  LOGV("Handshake");
  SECStatus rv = SSL_ForceHandshake(ssl_fd());
  if (rv == SECSuccess) {
    Connected();
    Poller::Instance()->Wait(READABLE_EVENT, adapter_, this,
                             &TlsAgent::ReadableCallback);
    return;
  }

  int32_t err = PR_GetError();
  if (err == PR_WOULD_BLOCK_ERROR) {
    LOGV("Would have blocked");
    if (variant_ == ssl_variant_datagram) {
      if (timer_handle_) {
        timer_handle_->Cancel();
        timer_handle_ = nullptr;
      }

      PRIntervalTime timeout;
      rv = DTLS_GetHandshakeTimeout(ssl_fd(), &timeout);
      if (rv == SECSuccess) {
        Poller::Instance()->SetTimer(
            timeout + 1, this, &TlsAgent::ReadableCallback, &timer_handle_);
      }
    }
    Poller::Instance()->Wait(READABLE_EVENT, adapter_, this,
                             &TlsAgent::ReadableCallback);
    return;
  }

  LOG("Handshake failed with error " << PORT_ErrorToName(err) << ": "
                                     << PORT_ErrorToString(err));
  error_code_ = err;
  SetState(STATE_ERROR);
}

void TlsAgent::PrepareForRenegotiate() {
  EXPECT_EQ(STATE_CONNECTED, state_);

  SetState(STATE_CONNECTING);
}

void TlsAgent::StartRenegotiate() {
  PrepareForRenegotiate();

  SECStatus rv = SSL_ReHandshake(ssl_fd(), PR_TRUE);
  EXPECT_EQ(SECSuccess, rv);
}

void TlsAgent::SendDirect(const DataBuffer& buf) {
  LOG("Send Direct " << buf);
  auto peer = adapter_->peer().lock();
  if (peer) {
    peer->PacketReceived(buf);
  } else {
    LOG("Send Direct peer absent");
  }
}

static bool ErrorIsNonFatal(PRErrorCode code) {
  return code == PR_WOULD_BLOCK_ERROR || code == SSL_ERROR_RX_SHORT_DTLS_READ;
}

void TlsAgent::SendData(size_t bytes, size_t blocksize) {
  uint8_t block[4096];

  ASSERT_LT(blocksize, sizeof(block));

  while (bytes) {
    size_t tosend = std::min(blocksize, bytes);

    for (size_t i = 0; i < tosend; ++i) {
      block[i] = 0xff & send_ctr_;
      ++send_ctr_;
    }

    SendBuffer(DataBuffer(block, tosend));
    bytes -= tosend;
  }
}

void TlsAgent::SendBuffer(const DataBuffer& buf) {
  LOGV("Writing " << buf.len() << " bytes");
  int32_t rv = PR_Write(ssl_fd(), buf.data(), buf.len());
  if (expect_readwrite_error_) {
    EXPECT_GT(0, rv);
    EXPECT_NE(PR_WOULD_BLOCK_ERROR, error_code_);
    error_code_ = PR_GetError();
    expect_readwrite_error_ = false;
  } else {
    ASSERT_EQ(buf.len(), static_cast<size_t>(rv));
  }
}

void TlsAgent::ReadBytes(size_t amount) {
  uint8_t block[16384];

  int32_t rv = PR_Read(ssl_fd(), block, (std::min)(amount, sizeof(block)));
  LOGV("ReadBytes " << rv);
  int32_t err;

  if (rv >= 0) {
    size_t count = static_cast<size_t>(rv);
    for (size_t i = 0; i < count; ++i) {
      ASSERT_EQ(recv_ctr_ & 0xff, block[i]);
      recv_ctr_++;
    }
  } else {
    err = PR_GetError();
    LOG("Read error " << PORT_ErrorToName(err) << ": "
                      << PORT_ErrorToString(err));
    if (err != PR_WOULD_BLOCK_ERROR && expect_readwrite_error_) {
      error_code_ = err;
      expect_readwrite_error_ = false;
    }
  }

  // If closed, then don't bother waiting around.
  if (rv > 0 || (rv < 0 && ErrorIsNonFatal(err))) {
    LOGV("Re-arming");
    Poller::Instance()->Wait(READABLE_EVENT, adapter_, this,
                             &TlsAgent::ReadableCallback);
  }
}

void TlsAgent::ResetSentBytes() { send_ctr_ = 0; }

void TlsAgent::ConfigureSessionCache(SessionResumptionMode mode) {
  EXPECT_TRUE(EnsureTlsSetup());

  SECStatus rv = SSL_OptionSet(ssl_fd(), SSL_NO_CACHE,
                               mode & RESUME_SESSIONID ? PR_FALSE : PR_TRUE);
  EXPECT_EQ(SECSuccess, rv);

  rv = SSL_OptionSet(ssl_fd(), SSL_ENABLE_SESSION_TICKETS,
                     mode & RESUME_TICKET ? PR_TRUE : PR_FALSE);
  EXPECT_EQ(SECSuccess, rv);
}

void TlsAgent::DisableECDHEServerKeyReuse() {
  ASSERT_TRUE(EnsureTlsSetup());
  ASSERT_EQ(TlsAgent::SERVER, role_);
  SECStatus rv = SSL_OptionSet(ssl_fd(), SSL_REUSE_SERVER_ECDHE_KEY, PR_FALSE);
  EXPECT_EQ(SECSuccess, rv);
}

static const std::string kTlsRolesAllArr[] = {"CLIENT", "SERVER"};
::testing::internal::ParamGenerator<std::string>
    TlsAgentTestBase::kTlsRolesAll = ::testing::ValuesIn(kTlsRolesAllArr);

void TlsAgentTestBase::SetUp() {
  SSL_ConfigServerSessionIDCache(1024, 0, 0, g_working_dir_path.c_str());
}

void TlsAgentTestBase::TearDown() {
  agent_ = nullptr;
  SSL_ClearSessionCache();
  SSL_ShutdownServerSessionIDCache();
}

void TlsAgentTestBase::Reset(const std::string& server_name) {
  agent_.reset(
      new TlsAgent(role_ == TlsAgent::CLIENT ? TlsAgent::kClient : server_name,
                   role_, variant_));
  if (version_) {
    agent_->SetVersionRange(version_, version_);
  }
  agent_->adapter()->SetPeer(sink_adapter_);
  agent_->StartConnect();
}

void TlsAgentTestBase::EnsureInit() {
  if (!agent_) {
    Reset();
  }
  const std::vector<SSLNamedGroup> groups = {
      ssl_grp_ec_curve25519, ssl_grp_ec_secp256r1, ssl_grp_ec_secp384r1,
      ssl_grp_ffdhe_2048};
  agent_->ConfigNamedGroups(groups);
}

void TlsAgentTestBase::ExpectAlert(uint8_t alert) {
  EnsureInit();
  agent_->ExpectSendAlert(alert);
}

void TlsAgentTestBase::ProcessMessage(const DataBuffer& buffer,
                                      TlsAgent::State expected_state,
                                      int32_t error_code) {
  std::cerr << "Process message: " << buffer << std::endl;
  EnsureInit();
  agent_->adapter()->PacketReceived(buffer);
  agent_->Handshake();

  ASSERT_EQ(expected_state, agent_->state());

  if (expected_state == TlsAgent::STATE_ERROR) {
    ASSERT_EQ(error_code, agent_->error_code());
  }
}

void TlsAgentTestBase::MakeRecord(SSLProtocolVariant variant, uint8_t type,
                                  uint16_t version, const uint8_t* buf,
                                  size_t len, DataBuffer* out,
                                  uint64_t seq_num) {
  size_t index = 0;
  index = out->Write(index, type, 1);
  if (variant == ssl_variant_stream) {
    index = out->Write(index, version, 2);
  } else {
    index = out->Write(index, TlsVersionToDtlsVersion(version), 2);
    index = out->Write(index, seq_num >> 32, 4);
    index = out->Write(index, seq_num & PR_UINT32_MAX, 4);
  }
  index = out->Write(index, len, 2);
  out->Write(index, buf, len);
}

void TlsAgentTestBase::MakeRecord(uint8_t type, uint16_t version,
                                  const uint8_t* buf, size_t len,
                                  DataBuffer* out, uint64_t seq_num) const {
  MakeRecord(variant_, type, version, buf, len, out, seq_num);
}

void TlsAgentTestBase::MakeHandshakeMessage(uint8_t hs_type,
                                            const uint8_t* data, size_t hs_len,
                                            DataBuffer* out,
                                            uint64_t seq_num) const {
  return MakeHandshakeMessageFragment(hs_type, data, hs_len, out, seq_num, 0,
                                      0);
}

void TlsAgentTestBase::MakeHandshakeMessageFragment(
    uint8_t hs_type, const uint8_t* data, size_t hs_len, DataBuffer* out,
    uint64_t seq_num, uint32_t fragment_offset,
    uint32_t fragment_length) const {
  size_t index = 0;
  if (!fragment_length) fragment_length = hs_len;
  index = out->Write(index, hs_type, 1);  // Handshake record type.
  index = out->Write(index, hs_len, 3);   // Handshake length
  if (variant_ == ssl_variant_datagram) {
    index = out->Write(index, seq_num, 2);
    index = out->Write(index, fragment_offset, 3);
    index = out->Write(index, fragment_length, 3);
  }
  if (data) {
    index = out->Write(index, data, fragment_length);
  } else {
    for (size_t i = 0; i < fragment_length; ++i) {
      index = out->Write(index, 1, 1);
    }
  }
}

void TlsAgentTestBase::MakeTrivialHandshakeRecord(uint8_t hs_type,
                                                  size_t hs_len,
                                                  DataBuffer* out) {
  size_t index = 0;
  index = out->Write(index, kTlsHandshakeType, 1);  // Content Type
  index = out->Write(index, 3, 1);                  // Version high
  index = out->Write(index, 1, 1);                  // Version low
  index = out->Write(index, 4 + hs_len, 2);         // Length

  index = out->Write(index, hs_type, 1);  // Handshake record type.
  index = out->Write(index, hs_len, 3);   // Handshake length
  for (size_t i = 0; i < hs_len; ++i) {
    index = out->Write(index, 1, 1);
  }
}

}  // namespace nss_test
