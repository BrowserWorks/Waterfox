/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef libssl_internals_h_
#define libssl_internals_h_

#include <stdint.h>

#include "prio.h"
#include "seccomon.h"
#include "ssl.h"
#include "sslimpl.h"
#include "sslt.h"

SECStatus SSLInt_IncrementClientHandshakeVersion(PRFileDesc *fd);

SECStatus SSLInt_UpdateSSLv2ClientRandom(PRFileDesc *fd, uint8_t *rnd,
                                         size_t rnd_len, uint8_t *msg,
                                         size_t msg_len);

PRBool SSLInt_ExtensionNegotiated(PRFileDesc *fd, PRUint16 ext);
void SSLInt_ClearSelfEncryptKey();
void SSLInt_SetSelfEncryptMacKey(PK11SymKey *key);
PRInt32 SSLInt_CountTls13CipherSpecs(PRFileDesc *fd);
void SSLInt_PrintTls13CipherSpecs(PRFileDesc *fd);
void SSLInt_ForceTimerExpiry(PRFileDesc *fd);
SECStatus SSLInt_SetMTU(PRFileDesc *fd, PRUint16 mtu);
PRBool SSLInt_CheckSecretsDestroyed(PRFileDesc *fd);
PRBool SSLInt_DamageClientHsTrafficSecret(PRFileDesc *fd);
PRBool SSLInt_DamageServerHsTrafficSecret(PRFileDesc *fd);
PRBool SSLInt_DamageEarlyTrafficSecret(PRFileDesc *fd);
SECStatus SSLInt_Set0RttAlpn(PRFileDesc *fd, PRUint8 *data, unsigned int len);
PRBool SSLInt_HasCertWithAuthType(PRFileDesc *fd, SSLAuthType authType);
PRBool SSLInt_SendAlert(PRFileDesc *fd, uint8_t level, uint8_t type);
PRBool SSLInt_SendNewSessionTicket(PRFileDesc *fd);
SECStatus SSLInt_AdvanceWriteSeqNum(PRFileDesc *fd, PRUint64 to);
SECStatus SSLInt_AdvanceReadSeqNum(PRFileDesc *fd, PRUint64 to);
SECStatus SSLInt_AdvanceWriteSeqByAWindow(PRFileDesc *fd, PRInt32 extra);
SSLKEAType SSLInt_GetKEAType(SSLNamedGroup group);

SECStatus SSLInt_SetCipherSpecChangeFunc(PRFileDesc *fd,
                                         sslCipherSpecChangedFunc func,
                                         void *arg);
PK11SymKey *SSLInt_CipherSpecToKey(PRBool isServer, ssl3CipherSpec *spec);
SSLCipherAlgorithm SSLInt_CipherSpecToAlgorithm(PRBool isServer,
                                                ssl3CipherSpec *spec);
unsigned char *SSLInt_CipherSpecToIv(PRBool isServer, ssl3CipherSpec *spec);
SECStatus SSLInt_EnableShortHeaders(PRFileDesc *fd);
SECStatus SSLInt_UsingShortHeaders(PRFileDesc *fd, PRBool *result);
void SSLInt_SetTicketLifetime(uint32_t lifetime);
void SSLInt_SetMaxEarlyDataSize(uint32_t size);
SECStatus SSLInt_SetSocketMaxEarlyDataSize(PRFileDesc *fd, uint32_t size);

#endif  // ndef libssl_internals_h_
