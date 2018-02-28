/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <functional>
#include <memory>
#include "secerr.h"
#include "ssl.h"
#include "sslerr.h"
#include "sslproto.h"

extern "C" {
// This is not something that should make you happy.
#include "libssl_internals.h"
}

#include "gtest_utils.h"
#include "scoped_ptrs.h"
#include "tls_connect.h"
#include "tls_filter.h"
#include "tls_parser.h"

namespace nss_test {

TEST_P(TlsConnectGeneric, SetupOnly) {}

TEST_P(TlsConnectGeneric, Connect) {
  SetExpectedVersion(std::get<1>(GetParam()));
  Connect();
  CheckKeys();
}

TEST_P(TlsConnectGeneric, ConnectEcdsa) {
  SetExpectedVersion(std::get<1>(GetParam()));
  Reset(TlsAgent::kServerEcdsa256);
  Connect();
  CheckKeys(ssl_kea_ecdh, ssl_auth_ecdsa);
}

TEST_P(TlsConnectGeneric, CipherSuiteMismatch) {
  EnsureTlsSetup();
  if (version_ >= SSL_LIBRARY_VERSION_TLS_1_3) {
    client_->EnableSingleCipher(TLS_AES_128_GCM_SHA256);
    server_->EnableSingleCipher(TLS_AES_256_GCM_SHA384);
  } else {
    client_->EnableSingleCipher(TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA);
    server_->EnableSingleCipher(TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA);
  }
  ConnectExpectAlert(server_, kTlsAlertHandshakeFailure);
  client_->CheckErrorCode(SSL_ERROR_NO_CYPHER_OVERLAP);
  server_->CheckErrorCode(SSL_ERROR_NO_CYPHER_OVERLAP);
}

class TlsAlertRecorder : public TlsRecordFilter {
 public:
  TlsAlertRecorder() : level_(255), description_(255) {}

  PacketFilter::Action FilterRecord(const TlsRecordHeader& header,
                                    const DataBuffer& input,
                                    DataBuffer* output) override {
    if (level_ != 255) {  // Already captured.
      return KEEP;
    }
    if (header.content_type() != kTlsAlertType) {
      return KEEP;
    }

    std::cerr << "Alert: " << input << std::endl;

    TlsParser parser(input);
    EXPECT_TRUE(parser.Read(&level_));
    EXPECT_TRUE(parser.Read(&description_));
    return KEEP;
  }

  uint8_t level() const { return level_; }
  uint8_t description() const { return description_; }

 private:
  uint8_t level_;
  uint8_t description_;
};

class HelloTruncator : public TlsHandshakeFilter {
  PacketFilter::Action FilterHandshake(const HandshakeHeader& header,
                                       const DataBuffer& input,
                                       DataBuffer* output) override {
    if (header.handshake_type() != kTlsHandshakeClientHello &&
        header.handshake_type() != kTlsHandshakeServerHello) {
      return KEEP;
    }
    output->Assign(input.data(), input.len() - 1);
    return CHANGE;
  }
};

// Verify that when NSS reports that an alert is sent, it is actually sent.
TEST_P(TlsConnectGeneric, CaptureAlertServer) {
  client_->SetPacketFilter(std::make_shared<HelloTruncator>());
  auto alert_recorder = std::make_shared<TlsAlertRecorder>();
  server_->SetPacketFilter(alert_recorder);

  ConnectExpectAlert(server_, kTlsAlertIllegalParameter);
  EXPECT_EQ(kTlsAlertFatal, alert_recorder->level());
  EXPECT_EQ(kTlsAlertIllegalParameter, alert_recorder->description());
}

TEST_P(TlsConnectGenericPre13, CaptureAlertClient) {
  server_->SetPacketFilter(std::make_shared<HelloTruncator>());
  auto alert_recorder = std::make_shared<TlsAlertRecorder>();
  client_->SetPacketFilter(alert_recorder);

  ConnectExpectAlert(client_, kTlsAlertDecodeError);
  EXPECT_EQ(kTlsAlertFatal, alert_recorder->level());
  EXPECT_EQ(kTlsAlertDecodeError, alert_recorder->description());
}

// In TLS 1.3, the server can't read the client alert.
TEST_P(TlsConnectTls13, CaptureAlertClient) {
  server_->SetPacketFilter(std::make_shared<HelloTruncator>());
  auto alert_recorder = std::make_shared<TlsAlertRecorder>();
  client_->SetPacketFilter(alert_recorder);

  server_->StartConnect();
  client_->StartConnect();

  client_->Handshake();
  client_->ExpectSendAlert(kTlsAlertDecodeError);
  server_->Handshake();
  client_->Handshake();
  if (variant_ == ssl_variant_stream) {
    // DTLS just drops the alert it can't decrypt.
    server_->ExpectSendAlert(kTlsAlertBadRecordMac);
  }
  server_->Handshake();
  EXPECT_EQ(kTlsAlertFatal, alert_recorder->level());
  EXPECT_EQ(kTlsAlertDecodeError, alert_recorder->description());
}

TEST_P(TlsConnectGenericPre13, ConnectFalseStart) {
  client_->EnableFalseStart();
  Connect();
  SendReceive();
}

TEST_P(TlsConnectGeneric, ConnectAlpn) {
  EnableAlpn();
  Connect();
  CheckAlpn("a");
}

TEST_P(TlsConnectGeneric, ConnectAlpnClone) {
  EnsureModelSockets();
  client_model_->EnableAlpn(alpn_dummy_val_, sizeof(alpn_dummy_val_));
  server_model_->EnableAlpn(alpn_dummy_val_, sizeof(alpn_dummy_val_));
  Connect();
  CheckAlpn("a");
}

TEST_P(TlsConnectDatagram, ConnectSrtp) {
  EnableSrtp();
  Connect();
  CheckSrtp();
  SendReceive();
}

// 1.3 is disabled in the next few tests because we don't
// presently support resumption in 1.3.
TEST_P(TlsConnectStreamPre13, ConnectAndClientRenegotiate) {
  Connect();
  server_->PrepareForRenegotiate();
  client_->StartRenegotiate();
  Handshake();
  CheckConnected();
}

TEST_P(TlsConnectStreamPre13, ConnectAndServerRenegotiate) {
  Connect();
  client_->PrepareForRenegotiate();
  server_->StartRenegotiate();
  Handshake();
  CheckConnected();
}

TEST_P(TlsConnectGeneric, ConnectSendReceive) {
  Connect();
  SendReceive();
}

// The next two tests takes advantage of the fact that we
// automatically read the first 1024 bytes, so if
// we provide 1200 bytes, they overrun the read buffer
// provided by the calling test.

// DTLS should return an error.
TEST_P(TlsConnectDatagram, ShortRead) {
  Connect();
  client_->ExpectReadWriteError();
  server_->SendData(50, 50);
  client_->ReadBytes(20);
  EXPECT_EQ(0U, client_->received_bytes());
  EXPECT_EQ(SSL_ERROR_RX_SHORT_DTLS_READ, PORT_GetError());

  // Now send and receive another packet.
  server_->ResetSentBytes();  // Reset the counter.
  SendReceive();
}

// TLS should get the write in two chunks.
TEST_P(TlsConnectStream, ShortRead) {
  // This test behaves oddly with TLS 1.0 because of 1/n+1 splitting,
  // so skip in that case.
  if (version_ < SSL_LIBRARY_VERSION_TLS_1_1) return;

  Connect();
  server_->SendData(50, 50);
  // Read the first tranche.
  client_->ReadBytes(20);
  ASSERT_EQ(20U, client_->received_bytes());
  // The second tranche should now immediately be available.
  client_->ReadBytes();
  ASSERT_EQ(50U, client_->received_bytes());
}

TEST_P(TlsConnectGeneric, ConnectWithCompressionMaybe) {
  EnsureTlsSetup();
  client_->EnableCompression();
  server_->EnableCompression();
  Connect();
  EXPECT_EQ(client_->version() < SSL_LIBRARY_VERSION_TLS_1_3 &&
                variant_ != ssl_variant_datagram,
            client_->is_compressed());
  SendReceive();
}

TEST_P(TlsConnectDatagram, TestDtlsHolddownExpiry) {
  Connect();
  std::cerr << "Expiring holddown timer\n";
  SSLInt_ForceTimerExpiry(client_->ssl_fd());
  SSLInt_ForceTimerExpiry(server_->ssl_fd());
  SendReceive();
  if (version_ >= SSL_LIBRARY_VERSION_TLS_1_3) {
    // One for send, one for receive.
    EXPECT_EQ(2, SSLInt_CountTls13CipherSpecs(client_->ssl_fd()));
  }
}

class TlsPreCCSHeaderInjector : public TlsRecordFilter {
 public:
  TlsPreCCSHeaderInjector() {}
  virtual PacketFilter::Action FilterRecord(
      const TlsRecordHeader& record_header, const DataBuffer& input,
      size_t* offset, DataBuffer* output) override {
    if (record_header.content_type() != kTlsChangeCipherSpecType) return KEEP;

    std::cerr << "Injecting Finished header before CCS\n";
    const uint8_t hhdr[] = {kTlsHandshakeFinished, 0x00, 0x00, 0x0c};
    DataBuffer hhdr_buf(hhdr, sizeof(hhdr));
    TlsRecordHeader nhdr(record_header.version(), kTlsHandshakeType, 0);
    *offset = nhdr.Write(output, *offset, hhdr_buf);
    *offset = record_header.Write(output, *offset, input);
    return CHANGE;
  }
};

TEST_P(TlsConnectStreamPre13, ClientFinishedHeaderBeforeCCS) {
  client_->SetPacketFilter(std::make_shared<TlsPreCCSHeaderInjector>());
  ConnectExpectAlert(server_, kTlsAlertUnexpectedMessage);
  client_->CheckErrorCode(SSL_ERROR_HANDSHAKE_UNEXPECTED_ALERT);
  server_->CheckErrorCode(SSL_ERROR_RX_UNEXPECTED_CHANGE_CIPHER);
}

TEST_P(TlsConnectStreamPre13, ServerFinishedHeaderBeforeCCS) {
  server_->SetPacketFilter(std::make_shared<TlsPreCCSHeaderInjector>());
  client_->StartConnect();
  server_->StartConnect();
  ExpectAlert(client_, kTlsAlertUnexpectedMessage);
  Handshake();
  EXPECT_EQ(TlsAgent::STATE_ERROR, client_->state());
  client_->CheckErrorCode(SSL_ERROR_RX_UNEXPECTED_CHANGE_CIPHER);
  EXPECT_EQ(TlsAgent::STATE_CONNECTED, server_->state());
  server_->Handshake();  // Make sure alert is consumed.
}

TEST_P(TlsConnectTls13, UnknownAlert) {
  Connect();
  server_->ExpectSendAlert(0xff, kTlsAlertWarning);
  client_->ExpectReceiveAlert(0xff, kTlsAlertWarning);
  SSLInt_SendAlert(server_->ssl_fd(), kTlsAlertWarning,
                   0xff);  // Unknown value.
  client_->ExpectReadWriteError();
  client_->WaitForErrorCode(SSL_ERROR_RX_UNKNOWN_ALERT, 2000);
}

TEST_P(TlsConnectTls13, AlertWrongLevel) {
  Connect();
  server_->ExpectSendAlert(kTlsAlertUnexpectedMessage, kTlsAlertWarning);
  client_->ExpectReceiveAlert(kTlsAlertUnexpectedMessage, kTlsAlertWarning);
  SSLInt_SendAlert(server_->ssl_fd(), kTlsAlertWarning,
                   kTlsAlertUnexpectedMessage);
  client_->ExpectReadWriteError();
  client_->WaitForErrorCode(SSL_ERROR_HANDSHAKE_UNEXPECTED_ALERT, 2000);
}

TEST_F(TlsConnectStreamTls13, Tls13FailedWriteSecondFlight) {
  EnsureTlsSetup();
  client_->StartConnect();
  server_->StartConnect();
  client_->Handshake();
  server_->Handshake();  // Send first flight.
  client_->adapter()->CloseWrites();
  client_->Handshake();  // This will get an error, but shouldn't crash.
  client_->CheckErrorCode(SSL_ERROR_SOCKET_WRITE_FAILURE);
}

TEST_F(TlsConnectStreamTls13, NegotiateShortHeaders) {
  client_->SetShortHeadersEnabled();
  server_->SetShortHeadersEnabled();
  client_->ExpectShortHeaders();
  server_->ExpectShortHeaders();
  Connect();
}

INSTANTIATE_TEST_CASE_P(
    GenericStream, TlsConnectGeneric,
    ::testing::Combine(TlsConnectTestBase::kTlsVariantsStream,
                       TlsConnectTestBase::kTlsVAll));
INSTANTIATE_TEST_CASE_P(
    GenericDatagram, TlsConnectGeneric,
    ::testing::Combine(TlsConnectTestBase::kTlsVariantsDatagram,
                       TlsConnectTestBase::kTlsV11Plus));

INSTANTIATE_TEST_CASE_P(StreamOnly, TlsConnectStream,
                        TlsConnectTestBase::kTlsVAll);
INSTANTIATE_TEST_CASE_P(DatagramOnly, TlsConnectDatagram,
                        TlsConnectTestBase::kTlsV11Plus);

INSTANTIATE_TEST_CASE_P(
    Pre12Stream, TlsConnectPre12,
    ::testing::Combine(TlsConnectTestBase::kTlsVariantsStream,
                       TlsConnectTestBase::kTlsV10V11));
INSTANTIATE_TEST_CASE_P(
    Pre12Datagram, TlsConnectPre12,
    ::testing::Combine(TlsConnectTestBase::kTlsVariantsDatagram,
                       TlsConnectTestBase::kTlsV11));

INSTANTIATE_TEST_CASE_P(Version12Only, TlsConnectTls12,
                        TlsConnectTestBase::kTlsVariantsAll);
#ifndef NSS_DISABLE_TLS_1_3
INSTANTIATE_TEST_CASE_P(Version13Only, TlsConnectTls13,
                        TlsConnectTestBase::kTlsVariantsAll);
#endif

INSTANTIATE_TEST_CASE_P(
    Pre13Stream, TlsConnectGenericPre13,
    ::testing::Combine(TlsConnectTestBase::kTlsVariantsStream,
                       TlsConnectTestBase::kTlsV10ToV12));
INSTANTIATE_TEST_CASE_P(
    Pre13Datagram, TlsConnectGenericPre13,
    ::testing::Combine(TlsConnectTestBase::kTlsVariantsDatagram,
                       TlsConnectTestBase::kTlsV11V12));
INSTANTIATE_TEST_CASE_P(Pre13StreamOnly, TlsConnectStreamPre13,
                        TlsConnectTestBase::kTlsV10ToV12);

INSTANTIATE_TEST_CASE_P(Version12Plus, TlsConnectTls12Plus,
                        ::testing::Combine(TlsConnectTestBase::kTlsVariantsAll,
                                           TlsConnectTestBase::kTlsV12Plus));

}  // namespace nspr_test
