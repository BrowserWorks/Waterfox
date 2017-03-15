/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsNSSCertHelper_h
#define nsNSSCertHelper_h

#ifndef INET6_ADDRSTRLEN
#define INET6_ADDRSTRLEN 46
#endif

#include "certt.h"
#include "nsString.h"

uint32_t
getCertType(CERTCertificate *cert);

nsresult
GetCertFingerprintByOidTag(CERTCertificate* nsscert,
                           SECOidTag aOidTag, 
                           nsCString &fp);

#endif // nsNSSCertHelper_h
