/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

/* This file contains functions for frobbing the internals of libssl */
#include "libssl_internals.h"

#include "nss.h"
#include "pk11pub.h"
#include "seccomon.h"

SECStatus SSLInt_IncrementClientHandshakeVersion(PRFileDesc *fd) {
  sslSocket *ss = ssl_FindSocket(fd);
  if (!ss) {
    return SECFailure;
  }

  ++ss->clientHelloVersion;

  return SECSuccess;
}

/* Use this function to update the ClientRandom of a client's handshake state
 * after replacing its ClientHello message. We for example need to do this
 * when replacing an SSLv3 ClientHello with its SSLv2 equivalent. */
SECStatus SSLInt_UpdateSSLv2ClientRandom(PRFileDesc *fd, uint8_t *rnd,
                                         size_t rnd_len, uint8_t *msg,
                                         size_t msg_len) {
  sslSocket *ss = ssl_FindSocket(fd);
  if (!ss) {
    return SECFailure;
  }

  ssl3_InitState(ss);
  ssl3_RestartHandshakeHashes(ss);

  // Ensure we don't overrun hs.client_random.
  rnd_len = PR_MIN(SSL3_RANDOM_LENGTH, rnd_len);

  // Zero the client_random struct.
  PORT_Memset(&ss->ssl3.hs.client_random, 0, SSL3_RANDOM_LENGTH);

  // Copy over the challenge bytes.
  size_t offset = SSL3_RANDOM_LENGTH - rnd_len;
  PORT_Memcpy(&ss->ssl3.hs.client_random.rand[offset], rnd, rnd_len);

  // Rehash the SSLv2 client hello message.
  return ssl3_UpdateHandshakeHashes(ss, msg, msg_len);
}

PRBool SSLInt_ExtensionNegotiated(PRFileDesc *fd, PRUint16 ext) {
  sslSocket *ss = ssl_FindSocket(fd);
  return (PRBool)(ss && ssl3_ExtensionNegotiated(ss, ext));
}

void SSLInt_ClearSessionTicketKey() { ssl_ResetSessionTicketKeys(); }

SECStatus SSLInt_SetMTU(PRFileDesc *fd, PRUint16 mtu) {
  sslSocket *ss = ssl_FindSocket(fd);
  if (!ss) {
    return SECFailure;
  }
  ss->ssl3.mtu = mtu;
  return SECSuccess;
}

PRInt32 SSLInt_CountTls13CipherSpecs(PRFileDesc *fd) {
  PRCList *cur_p;
  PRInt32 ct = 0;

  sslSocket *ss = ssl_FindSocket(fd);
  if (!ss) {
    return -1;
  }

  for (cur_p = PR_NEXT_LINK(&ss->ssl3.hs.cipherSpecs);
       cur_p != &ss->ssl3.hs.cipherSpecs; cur_p = PR_NEXT_LINK(cur_p)) {
    ++ct;
  }
  return ct;
}

void SSLInt_PrintTls13CipherSpecs(PRFileDesc *fd) {
  PRCList *cur_p;

  sslSocket *ss = ssl_FindSocket(fd);
  if (!ss) {
    return;
  }

  fprintf(stderr, "Cipher specs\n");
  for (cur_p = PR_NEXT_LINK(&ss->ssl3.hs.cipherSpecs);
       cur_p != &ss->ssl3.hs.cipherSpecs; cur_p = PR_NEXT_LINK(cur_p)) {
    ssl3CipherSpec *spec = (ssl3CipherSpec *)cur_p;
    fprintf(stderr, "  %s\n", spec->phase);
  }
}

/* Force a timer expiry by backdating when the timer was started.
 * We could set the remaining time to 0 but then backoff would not
 * work properly if we decide to test it. */
void SSLInt_ForceTimerExpiry(PRFileDesc *fd) {
  sslSocket *ss = ssl_FindSocket(fd);
  if (!ss) {
    return;
  }

  if (!ss->ssl3.hs.rtTimerCb) return;

  ss->ssl3.hs.rtTimerStarted =
      PR_IntervalNow() - PR_MillisecondsToInterval(ss->ssl3.hs.rtTimeoutMs + 1);
}

#define CHECK_SECRET(secret)                  \
  if (ss->ssl3.hs.secret) {                   \
    fprintf(stderr, "%s != NULL\n", #secret); \
    return PR_FALSE;                          \
  }

PRBool SSLInt_CheckSecretsDestroyed(PRFileDesc *fd) {
  sslSocket *ss = ssl_FindSocket(fd);
  if (!ss) {
    return PR_FALSE;
  }

  CHECK_SECRET(currentSecret);
  CHECK_SECRET(resumptionMasterSecret);
  CHECK_SECRET(dheSecret);
  CHECK_SECRET(clientEarlyTrafficSecret);
  CHECK_SECRET(clientHsTrafficSecret);
  CHECK_SECRET(serverHsTrafficSecret);

  return PR_TRUE;
}

PRBool sslint_DamageTrafficSecret(PRFileDesc *fd, size_t offset) {
  unsigned char data[32] = {0};
  PK11SymKey **keyPtr;
  PK11SlotInfo *slot = PK11_GetInternalSlot();
  SECItem key_item = {siBuffer, data, sizeof(data)};
  sslSocket *ss = ssl_FindSocket(fd);
  if (!ss) {
    return PR_FALSE;
  }
  if (!slot) {
    return PR_FALSE;
  }
  keyPtr = (PK11SymKey **)((char *)&ss->ssl3.hs + offset);
  if (!*keyPtr) {
    return PR_FALSE;
  }
  PK11_FreeSymKey(*keyPtr);
  *keyPtr = PK11_ImportSymKey(slot, CKM_NSS_HKDF_SHA256, PK11_OriginUnwrap,
                              CKA_DERIVE, &key_item, NULL);
  PK11_FreeSlot(slot);
  if (!*keyPtr) {
    return PR_FALSE;
  }

  return PR_TRUE;
}

PRBool SSLInt_DamageClientHsTrafficSecret(PRFileDesc *fd) {
  return sslint_DamageTrafficSecret(
      fd, offsetof(SSL3HandshakeState, clientHsTrafficSecret));
}

PRBool SSLInt_DamageServerHsTrafficSecret(PRFileDesc *fd) {
  return sslint_DamageTrafficSecret(
      fd, offsetof(SSL3HandshakeState, serverHsTrafficSecret));
}

PRBool SSLInt_DamageEarlyTrafficSecret(PRFileDesc *fd) {
  return sslint_DamageTrafficSecret(
      fd, offsetof(SSL3HandshakeState, clientEarlyTrafficSecret));
}

SECStatus SSLInt_Set0RttAlpn(PRFileDesc *fd, PRUint8 *data, unsigned int len) {
  sslSocket *ss = ssl_FindSocket(fd);
  if (!ss) {
    return SECFailure;
  }

  ss->xtnData.nextProtoState = SSL_NEXT_PROTO_EARLY_VALUE;
  if (ss->xtnData.nextProto.data) {
    SECITEM_FreeItem(&ss->xtnData.nextProto, PR_FALSE);
  }
  if (!SECITEM_AllocItem(NULL, &ss->xtnData.nextProto, len)) {
    return SECFailure;
  }
  PORT_Memcpy(ss->xtnData.nextProto.data, data, len);

  return SECSuccess;
}

PRBool SSLInt_HasCertWithAuthType(PRFileDesc *fd, SSLAuthType authType) {
  sslSocket *ss = ssl_FindSocket(fd);
  if (!ss) {
    return PR_FALSE;
  }

  return (PRBool)(!!ssl_FindServerCert(ss, authType, NULL));
}

PRBool SSLInt_SendAlert(PRFileDesc *fd, uint8_t level, uint8_t type) {
  sslSocket *ss = ssl_FindSocket(fd);
  if (!ss) {
    return PR_FALSE;
  }

  SECStatus rv = SSL3_SendAlert(ss, level, type);
  if (rv != SECSuccess) return PR_FALSE;

  return PR_TRUE;
}

PRBool SSLInt_SendNewSessionTicket(PRFileDesc *fd) {
  sslSocket *ss = ssl_FindSocket(fd);
  if (!ss) {
    return PR_FALSE;
  }

  ssl_GetSSL3HandshakeLock(ss);
  ssl_GetXmitBufLock(ss);

  SECStatus rv = tls13_SendNewSessionTicket(ss);
  if (rv == SECSuccess) {
    rv = ssl3_FlushHandshake(ss, 0);
  }

  ssl_ReleaseXmitBufLock(ss);
  ssl_ReleaseSSL3HandshakeLock(ss);

  return rv == SECSuccess;
}

SECStatus SSLInt_AdvanceReadSeqNum(PRFileDesc *fd, PRUint64 to) {
  PRUint64 epoch;
  sslSocket *ss;
  ssl3CipherSpec *spec;

  ss = ssl_FindSocket(fd);
  if (!ss) {
    return SECFailure;
  }
  if (to >= (1ULL << 48)) {
    PORT_SetError(SEC_ERROR_INVALID_ARGS);
    return SECFailure;
  }
  ssl_GetSpecWriteLock(ss);
  spec = ss->ssl3.crSpec;
  epoch = spec->read_seq_num >> 48;
  spec->read_seq_num = (epoch << 48) | to;

  /* For DTLS, we need to fix the record sequence number.  For this, we can just
   * scrub the entire structure on the assumption that the new sequence number
   * is far enough past the last received sequence number. */
  if (to <= spec->recvdRecords.right + DTLS_RECVD_RECORDS_WINDOW) {
    PORT_SetError(SEC_ERROR_INVALID_ARGS);
    return SECFailure;
  }
  dtls_RecordSetRecvd(&spec->recvdRecords, to);

  ssl_ReleaseSpecWriteLock(ss);
  return SECSuccess;
}

SECStatus SSLInt_AdvanceWriteSeqNum(PRFileDesc *fd, PRUint64 to) {
  PRUint64 epoch;
  sslSocket *ss;

  ss = ssl_FindSocket(fd);
  if (!ss) {
    return SECFailure;
  }
  if (to >= (1ULL << 48)) {
    PORT_SetError(SEC_ERROR_INVALID_ARGS);
    return SECFailure;
  }
  ssl_GetSpecWriteLock(ss);
  epoch = ss->ssl3.cwSpec->write_seq_num >> 48;
  ss->ssl3.cwSpec->write_seq_num = (epoch << 48) | to;
  ssl_ReleaseSpecWriteLock(ss);
  return SECSuccess;
}

SECStatus SSLInt_AdvanceWriteSeqByAWindow(PRFileDesc *fd, PRInt32 extra) {
  sslSocket *ss;
  sslSequenceNumber to;

  ss = ssl_FindSocket(fd);
  if (!ss) {
    return SECFailure;
  }
  ssl_GetSpecReadLock(ss);
  to = ss->ssl3.cwSpec->write_seq_num + DTLS_RECVD_RECORDS_WINDOW + extra;
  ssl_ReleaseSpecReadLock(ss);
  return SSLInt_AdvanceWriteSeqNum(fd, to & RECORD_SEQ_MAX);
}

SSLKEAType SSLInt_GetKEAType(SSLNamedGroup group) {
  const sslNamedGroupDef *groupDef = ssl_LookupNamedGroup(group);
  if (!groupDef) return ssl_kea_null;

  return groupDef->keaType;
}

SECStatus SSLInt_SetCipherSpecChangeFunc(PRFileDesc *fd,
                                         sslCipherSpecChangedFunc func,
                                         void *arg) {
  sslSocket *ss;

  ss = ssl_FindSocket(fd);
  if (!ss) {
    return SECFailure;
  }

  ss->ssl3.changedCipherSpecFunc = func;
  ss->ssl3.changedCipherSpecArg = arg;

  return SECSuccess;
}

static ssl3KeyMaterial *GetKeyingMaterial(PRBool isServer,
                                          ssl3CipherSpec *spec) {
  return isServer ? &spec->server : &spec->client;
}

PK11SymKey *SSLInt_CipherSpecToKey(PRBool isServer, ssl3CipherSpec *spec) {
  return GetKeyingMaterial(isServer, spec)->write_key;
}

SSLCipherAlgorithm SSLInt_CipherSpecToAlgorithm(PRBool isServer,
                                                ssl3CipherSpec *spec) {
  return spec->cipher_def->calg;
}

unsigned char *SSLInt_CipherSpecToIv(PRBool isServer, ssl3CipherSpec *spec) {
  return GetKeyingMaterial(isServer, spec)->write_iv;
}

SECStatus SSLInt_EnableShortHeaders(PRFileDesc *fd) {
  sslSocket *ss;

  ss = ssl_FindSocket(fd);
  if (!ss) {
    return SECFailure;
  }

  ss->opt.enableShortHeaders = PR_TRUE;
  return SECSuccess;
}

SECStatus SSLInt_UsingShortHeaders(PRFileDesc *fd, PRBool *result) {
  sslSocket *ss;

  ss = ssl_FindSocket(fd);
  if (!ss) {
    return SECFailure;
  }

  *result = ss->ssl3.hs.shortHeaders;
  return SECSuccess;
}

void SSLInt_SetTicketLifetime(uint32_t lifetime) {
  ssl_ticket_lifetime = lifetime;
}

void SSLInt_SetMaxEarlyDataSize(uint32_t size) {
  ssl_max_early_data_size = size;
}

SECStatus SSLInt_SetSocketMaxEarlyDataSize(PRFileDesc *fd, uint32_t size) {
  sslSocket *ss;

  ss = ssl_FindSocket(fd);
  if (!ss) {
    return SECFailure;
  }

  /* This only works when resuming. */
  if (!ss->statelessResume) {
    PORT_SetError(SEC_INTERNAL_ONLY);
    return SECFailure;
  }

  /* Modifying both specs allows this to be used on either peer. */
  ssl_GetSpecWriteLock(ss);
  ss->ssl3.crSpec->earlyDataRemaining = size;
  ss->ssl3.cwSpec->earlyDataRemaining = size;
  ssl_ReleaseSpecWriteLock(ss);

  return SECSuccess;
}
