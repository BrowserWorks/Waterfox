/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "NSSCertDBTrustDomain.h"

#include <stdint.h>

#include "ExtendedValidation.h"
#include "NSSErrorsService.h"
#include "OCSPRequestor.h"
#include "OCSPVerificationTrustDomain.h"
#include "PublicKeyPinningService.h"
#include "cert.h"
#include "certdb.h"
#include "mozilla/Assertions.h"
#include "mozilla/Casting.h"
#include "mozilla/PodOperations.h"
#include "mozilla/UniquePtr.h"
#include "mozilla/Unused.h"
#include "nsNSSCertificate.h"
#include "nsServiceManagerUtils.h"
#include "nss.h"
#include "pk11pub.h"
#include "pkix/Result.h"
#include "pkix/pkix.h"
#include "pkix/pkixnss.h"
#include "prerror.h"
#include "prmem.h"
#include "prprf.h"
#include "secerr.h"

#include "CNNICHashWhitelist.inc"
#include "StartComAndWoSignData.inc"

using namespace mozilla;
using namespace mozilla::pkix;

extern LazyLogModule gCertVerifierLog;

static const uint64_t ServerFailureDelaySeconds = 5 * 60;

namespace mozilla { namespace psm {

const char BUILTIN_ROOTS_MODULE_DEFAULT_NAME[] = "Builtin Roots Module";

NSSCertDBTrustDomain::NSSCertDBTrustDomain(SECTrustType certDBTrustType,
                                           OCSPFetching ocspFetching,
                                           OCSPCache& ocspCache,
             /*optional but shouldn't be*/ void* pinArg,
                                           CertVerifier::OcspGetConfig ocspGETConfig,
                                           uint32_t certShortLifetimeInDays,
                                           CertVerifier::PinningMode pinningMode,
                                           unsigned int minRSABits,
                                           ValidityCheckingMode validityCheckingMode,
                                           CertVerifier::SHA1Mode sha1Mode,
                                           NetscapeStepUpPolicy netscapeStepUpPolicy,
                                           const NeckoOriginAttributes& originAttributes,
                                           UniqueCERTCertList& builtChain,
                              /*optional*/ PinningTelemetryInfo* pinningTelemetryInfo,
                              /*optional*/ const char* hostname)
  : mCertDBTrustType(certDBTrustType)
  , mOCSPFetching(ocspFetching)
  , mOCSPCache(ocspCache)
  , mPinArg(pinArg)
  , mOCSPGetConfig(ocspGETConfig)
  , mCertShortLifetimeInDays(certShortLifetimeInDays)
  , mPinningMode(pinningMode)
  , mMinRSABits(minRSABits)
  , mValidityCheckingMode(validityCheckingMode)
  , mSHA1Mode(sha1Mode)
  , mNetscapeStepUpPolicy(netscapeStepUpPolicy)
  , mOriginAttributes(originAttributes)
  , mBuiltChain(builtChain)
  , mPinningTelemetryInfo(pinningTelemetryInfo)
  , mHostname(hostname)
  , mCertBlocklist(do_GetService(NS_CERTBLOCKLIST_CONTRACTID))
  , mOCSPStaplingStatus(CertVerifier::OCSP_STAPLING_NEVER_CHECKED)
  , mSCTListFromCertificate()
  , mSCTListFromOCSPStapling()
{
}

// If useRoots is true, we only use root certificates in the candidate list.
// If useRoots is false, we only use non-root certificates in the list.
static Result
FindIssuerInner(const UniqueCERTCertList& candidates, bool useRoots,
                Input encodedIssuerName, TrustDomain::IssuerChecker& checker,
                /*out*/ bool& keepGoing)
{
  keepGoing = true;
  for (CERTCertListNode* n = CERT_LIST_HEAD(candidates);
       !CERT_LIST_END(n, candidates); n = CERT_LIST_NEXT(n)) {
    bool candidateIsRoot = !!n->cert->isRoot;
    if (candidateIsRoot != useRoots) {
      continue;
    }
    Input certDER;
    Result rv = certDER.Init(n->cert->derCert.data, n->cert->derCert.len);
    if (rv != Success) {
      continue; // probably too big
    }

    const SECItem encodedIssuerNameItem = {
      siBuffer,
      const_cast<unsigned char*>(encodedIssuerName.UnsafeGetData()),
      encodedIssuerName.GetLength()
    };
    ScopedAutoSECItem nameConstraints;
    SECStatus srv = CERT_GetImposedNameConstraints(&encodedIssuerNameItem,
                                                   &nameConstraints);
    if (srv != SECSuccess) {
      if (PR_GetError() != SEC_ERROR_EXTENSION_NOT_FOUND) {
        return Result::FATAL_ERROR_LIBRARY_FAILURE;
      }

      // If no imposed name constraints were found, continue without them
      rv = checker.Check(certDER, nullptr, keepGoing);
    } else {
      // Otherwise apply the constraints
      Input nameConstraintsInput;
      if (nameConstraintsInput.Init(nameConstraints.data, nameConstraints.len)
            != Success) {
        return Result::FATAL_ERROR_LIBRARY_FAILURE;
      }
      rv = checker.Check(certDER, &nameConstraintsInput, keepGoing);
    }
    if (rv != Success) {
      return rv;
    }
    if (!keepGoing) {
      break;
    }
  }

  return Success;
}

Result
NSSCertDBTrustDomain::FindIssuer(Input encodedIssuerName,
                                 IssuerChecker& checker, Time)
{
  // TODO: NSS seems to be ambiguous between "no potential issuers found" and
  // "there was an error trying to retrieve the potential issuers."
  SECItem encodedIssuerNameItem = UnsafeMapInputToSECItem(encodedIssuerName);
  UniqueCERTCertList
    candidates(CERT_CreateSubjectCertList(nullptr, CERT_GetDefaultCertDB(),
                                          &encodedIssuerNameItem, 0,
                                          false));
  if (candidates) {
    // First, try all the root certs; then try all the non-root certs.
    bool keepGoing;
    Result rv = FindIssuerInner(candidates, true, encodedIssuerName, checker,
                                keepGoing);
    if (rv != Success) {
      return rv;
    }
    if (keepGoing) {
      rv = FindIssuerInner(candidates, false, encodedIssuerName, checker,
                           keepGoing);
      if (rv != Success) {
        return rv;
      }
    }
  }

  return Success;
}

Result
NSSCertDBTrustDomain::GetCertTrust(EndEntityOrCA endEntityOrCA,
                                   const CertPolicyId& policy,
                                   Input candidateCertDER,
                                   /*out*/ TrustLevel& trustLevel)
{
  // XXX: This would be cleaner and more efficient if we could get the trust
  // information without constructing a CERTCertificate here, but NSS doesn't
  // expose it in any other easy-to-use fashion. The use of
  // CERT_NewTempCertificate to get a CERTCertificate shouldn't be a
  // performance problem because NSS will just find the existing
  // CERTCertificate in its in-memory cache and return it.
  SECItem candidateCertDERSECItem = UnsafeMapInputToSECItem(candidateCertDER);
  UniqueCERTCertificate candidateCert(
    CERT_NewTempCertificate(CERT_GetDefaultCertDB(), &candidateCertDERSECItem,
                            nullptr, false, true));
  if (!candidateCert) {
    return MapPRErrorCodeToResult(PR_GetError());
  }

  // Check the certificate against the OneCRL cert blocklist
  if (!mCertBlocklist) {
    return Result::FATAL_ERROR_LIBRARY_FAILURE;
  }

  // The certificate blocklist currently only applies to TLS server
  // certificates.
  if (mCertDBTrustType == trustSSL) {
    bool isCertRevoked;
    nsresult nsrv = mCertBlocklist->IsCertRevoked(
                      candidateCert->derIssuer.data,
                      candidateCert->derIssuer.len,
                      candidateCert->serialNumber.data,
                      candidateCert->serialNumber.len,
                      candidateCert->derSubject.data,
                      candidateCert->derSubject.len,
                      candidateCert->derPublicKey.data,
                      candidateCert->derPublicKey.len,
                      &isCertRevoked);
    if (NS_FAILED(nsrv)) {
      return Result::FATAL_ERROR_LIBRARY_FAILURE;
    }

    if (isCertRevoked) {
      MOZ_LOG(gCertVerifierLog, LogLevel::Debug,
             ("NSSCertDBTrustDomain: certificate is in blocklist"));
      return Result::ERROR_REVOKED_CERTIFICATE;
    }
  }

  // XXX: CERT_GetCertTrust seems to be abusing SECStatus as a boolean, where
  // SECSuccess means that there is a trust record and SECFailure means there
  // is not a trust record. I looked at NSS's internal uses of
  // CERT_GetCertTrust, and all that code uses the result as a boolean meaning
  // "We have a trust record."
  CERTCertTrust trust;
  if (CERT_GetCertTrust(candidateCert.get(), &trust) == SECSuccess) {
    uint32_t flags = SEC_GET_TRUST_FLAGS(&trust, mCertDBTrustType);

    // For DISTRUST, we use the CERTDB_TRUSTED or CERTDB_TRUSTED_CA bit,
    // because we can have active distrust for either type of cert. Note that
    // CERTDB_TERMINAL_RECORD means "stop trying to inherit trust" so if the
    // relevant trust bit isn't set then that means the cert must be considered
    // distrusted.
    uint32_t relevantTrustBit =
      endEntityOrCA == EndEntityOrCA::MustBeCA ? CERTDB_TRUSTED_CA
                                               : CERTDB_TRUSTED;
    if (((flags & (relevantTrustBit|CERTDB_TERMINAL_RECORD)))
            == CERTDB_TERMINAL_RECORD) {
      trustLevel = TrustLevel::ActivelyDistrusted;
      return Success;
    }

    // For TRUST, we only use the CERTDB_TRUSTED_CA bit, because Gecko hasn't
    // needed to consider end-entity certs to be their own trust anchors since
    // Gecko implemented nsICertOverrideService.
    if (flags & CERTDB_TRUSTED_CA) {
      if (policy.IsAnyPolicy()) {
        trustLevel = TrustLevel::TrustAnchor;
        return Success;
      }
      if (CertIsAuthoritativeForEVPolicy(candidateCert, policy)) {
        trustLevel = TrustLevel::TrustAnchor;
        return Success;
      }
    }
  }

  trustLevel = TrustLevel::InheritsTrust;
  return Success;
}

Result
NSSCertDBTrustDomain::DigestBuf(Input item, DigestAlgorithm digestAlg,
                                /*out*/ uint8_t* digestBuf, size_t digestBufLen)
{
  return DigestBufNSS(item, digestAlg, digestBuf, digestBufLen);
}

static PRIntervalTime
OCSPFetchingTypeToTimeoutTime(NSSCertDBTrustDomain::OCSPFetching ocspFetching)
{
  switch (ocspFetching) {
    case NSSCertDBTrustDomain::FetchOCSPForDVSoftFail:
      return PR_SecondsToInterval(2);
    case NSSCertDBTrustDomain::FetchOCSPForEV:
    case NSSCertDBTrustDomain::FetchOCSPForDVHardFail:
      return PR_SecondsToInterval(10);
    // The rest of these are error cases. Assert in debug builds, but return
    // the default value corresponding to 2 seconds in release builds.
    case NSSCertDBTrustDomain::NeverFetchOCSP:
    case NSSCertDBTrustDomain::LocalOnlyOCSPForEV:
      PR_NOT_REACHED("we should never see this OCSPFetching type here");
      break;
  }

  PR_NOT_REACHED("we're not handling every OCSPFetching type");
  return PR_SecondsToInterval(2);
}

// Copied and modified from CERT_GetOCSPAuthorityInfoAccessLocation and
// CERT_GetGeneralNameByType. Returns a non-Result::Success result on error,
// Success with url == nullptr when an OCSP URI was not found, and Success with
// url != nullptr when an OCSP URI was found. The output url will be owned
// by the arena.
static Result
GetOCSPAuthorityInfoAccessLocation(const UniquePLArenaPool& arena,
                                   Input aiaExtension,
                                   /*out*/ char const*& url)
{
  MOZ_ASSERT(arena.get());
  if (!arena.get()) {
    return Result::FATAL_ERROR_INVALID_ARGS;
  }

  url = nullptr;
  SECItem aiaExtensionSECItem = UnsafeMapInputToSECItem(aiaExtension);
  CERTAuthInfoAccess** aia =
    CERT_DecodeAuthInfoAccessExtension(arena.get(), &aiaExtensionSECItem);
  if (!aia) {
    return Result::ERROR_CERT_BAD_ACCESS_LOCATION;
  }
  for (size_t i = 0; aia[i]; ++i) {
    if (SECOID_FindOIDTag(&aia[i]->method) == SEC_OID_PKIX_OCSP) {
      // NSS chooses the **last** OCSP URL; we choose the **first**
      CERTGeneralName* current = aia[i]->location;
      if (!current) {
        continue;
      }
      do {
        if (current->type == certURI) {
          const SECItem& location = current->name.other;
          // (location.len + 1) must be small enough to fit into a uint32_t,
          // but we limit it to a smaller bound to reduce OOM risk.
          if (location.len > 1024 || memchr(location.data, 0, location.len)) {
            // Reject embedded nulls. (NSS doesn't do this)
            return Result::ERROR_CERT_BAD_ACCESS_LOCATION;
          }
          // Copy the non-null-terminated SECItem into a null-terminated string.
          char* nullTerminatedURL(
            static_cast<char*>(PORT_ArenaAlloc(arena.get(), location.len + 1)));
          if (!nullTerminatedURL) {
            return Result::FATAL_ERROR_NO_MEMORY;
          }
          memcpy(nullTerminatedURL, location.data, location.len);
          nullTerminatedURL[location.len] = 0;
          url = nullTerminatedURL;
          return Success;
        }
        current = CERT_GetNextGeneralName(current);
      } while (current != aia[i]->location);
    }
  }

  return Success;
}

Result
NSSCertDBTrustDomain::CheckRevocation(EndEntityOrCA endEntityOrCA,
                                      const CertID& certID, Time time,
                                      Duration validityDuration,
                         /*optional*/ const Input* stapledOCSPResponse,
                         /*optional*/ const Input* aiaExtension)
{
  // Actively distrusted certificates will have already been blocked by
  // GetCertTrust.

  // TODO: need to verify that IsRevoked isn't called for trust anchors AND
  // that that fact is documented in mozillapkix.

  MOZ_LOG(gCertVerifierLog, LogLevel::Debug,
         ("NSSCertDBTrustDomain: Top of CheckRevocation\n"));

  // Bug 991815: The BR allow OCSP for intermediates to be up to one year old.
  // Since this affects EV there is no reason why DV should be more strict
  // so all intermediatates are allowed to have OCSP responses up to one year
  // old.
  uint16_t maxOCSPLifetimeInDays = 10;
  if (endEntityOrCA == EndEntityOrCA::MustBeCA) {
    maxOCSPLifetimeInDays = 365;
  }

  // If we have a stapled OCSP response then the verification of that response
  // determines the result unless the OCSP response is expired. We make an
  // exception for expired responses because some servers, nginx in particular,
  // are known to serve expired responses due to bugs.
  // We keep track of the result of verifying the stapled response but don't
  // immediately return failure if the response has expired.
  //
  // We only set the OCSP stapling status if we're validating the end-entity
  // certificate. Non-end-entity certificates would always be
  // OCSP_STAPLING_NONE unless/until we implement multi-stapling.
  Result stapledOCSPResponseResult = Success;
  if (stapledOCSPResponse) {
    PR_ASSERT(endEntityOrCA == EndEntityOrCA::MustBeEndEntity);
    bool expired;
    stapledOCSPResponseResult =
      VerifyAndMaybeCacheEncodedOCSPResponse(certID, time,
                                             maxOCSPLifetimeInDays,
                                             *stapledOCSPResponse,
                                             ResponseWasStapled, expired);
    if (stapledOCSPResponseResult == Success) {
      // stapled OCSP response present and good
      mOCSPStaplingStatus = CertVerifier::OCSP_STAPLING_GOOD;
      MOZ_LOG(gCertVerifierLog, LogLevel::Debug,
             ("NSSCertDBTrustDomain: stapled OCSP response: good"));
      return Success;
    }
    if (stapledOCSPResponseResult == Result::ERROR_OCSP_OLD_RESPONSE ||
        expired) {
      // stapled OCSP response present but expired
      mOCSPStaplingStatus = CertVerifier::OCSP_STAPLING_EXPIRED;
      MOZ_LOG(gCertVerifierLog, LogLevel::Debug,
             ("NSSCertDBTrustDomain: expired stapled OCSP response"));
    } else {
      // stapled OCSP response present but invalid for some reason
      mOCSPStaplingStatus = CertVerifier::OCSP_STAPLING_INVALID;
      MOZ_LOG(gCertVerifierLog, LogLevel::Debug,
             ("NSSCertDBTrustDomain: stapled OCSP response: failure"));
      return stapledOCSPResponseResult;
    }
  } else if (endEntityOrCA == EndEntityOrCA::MustBeEndEntity) {
    // no stapled OCSP response
    mOCSPStaplingStatus = CertVerifier::OCSP_STAPLING_NONE;
    MOZ_LOG(gCertVerifierLog, LogLevel::Debug,
           ("NSSCertDBTrustDomain: no stapled OCSP response"));
  }

  Result cachedResponseResult = Success;
  Time cachedResponseValidThrough(Time::uninitialized);
  bool cachedResponsePresent = mOCSPCache.Get(certID, mOriginAttributes,
                                              cachedResponseResult,
                                              cachedResponseValidThrough);
  if (cachedResponsePresent) {
    if (cachedResponseResult == Success && cachedResponseValidThrough >= time) {
      MOZ_LOG(gCertVerifierLog, LogLevel::Debug,
             ("NSSCertDBTrustDomain: cached OCSP response: good"));
      return Success;
    }
    // If we have a cached revoked response, use it.
    if (cachedResponseResult == Result::ERROR_REVOKED_CERTIFICATE) {
      MOZ_LOG(gCertVerifierLog, LogLevel::Debug,
             ("NSSCertDBTrustDomain: cached OCSP response: revoked"));
      return Result::ERROR_REVOKED_CERTIFICATE;
    }
    // The cached response may indicate an unknown certificate or it may be
    // expired. Don't return with either of these statuses yet - we may be
    // able to fetch a more recent one.
    MOZ_LOG(gCertVerifierLog, LogLevel::Debug,
           ("NSSCertDBTrustDomain: cached OCSP response: error %d",
           cachedResponseResult));
    // When a good cached response has expired, it is more convenient
    // to convert that to an error code and just deal with
    // cachedResponseResult from here on out.
    if (cachedResponseResult == Success && cachedResponseValidThrough < time) {
      cachedResponseResult = Result::ERROR_OCSP_OLD_RESPONSE;
    }
    // We may have a cached indication of server failure. Ignore it if
    // it has expired.
    if (cachedResponseResult != Success &&
        cachedResponseResult != Result::ERROR_OCSP_UNKNOWN_CERT &&
        cachedResponseResult != Result::ERROR_OCSP_OLD_RESPONSE &&
        cachedResponseValidThrough < time) {
      cachedResponseResult = Success;
      cachedResponsePresent = false;
    }
  } else {
    MOZ_LOG(gCertVerifierLog, LogLevel::Debug,
           ("NSSCertDBTrustDomain: no cached OCSP response"));
  }
  // At this point, if and only if cachedErrorResult is Success, there was no
  // cached response.
  PR_ASSERT((!cachedResponsePresent && cachedResponseResult == Success) ||
            (cachedResponsePresent && cachedResponseResult != Success));

  // If we have a fresh OneCRL Blocklist we can skip OCSP for CA certs
  bool blocklistIsFresh;
  nsresult nsrv = mCertBlocklist->IsBlocklistFresh(&blocklistIsFresh);
  if (NS_FAILED(nsrv)) {
    return Result::FATAL_ERROR_LIBRARY_FAILURE;
  }

  // TODO: We still need to handle the fallback for expired responses. But,
  // if/when we disable OCSP fetching by default, it would be ambiguous whether
  // security.OCSP.enable==0 means "I want the default" or "I really never want
  // you to ever fetch OCSP."

  Duration shortLifetime(mCertShortLifetimeInDays * Time::ONE_DAY_IN_SECONDS);

  if ((mOCSPFetching == NeverFetchOCSP) ||
      (validityDuration < shortLifetime) ||
      (endEntityOrCA == EndEntityOrCA::MustBeCA &&
       (mOCSPFetching == FetchOCSPForDVHardFail ||
        mOCSPFetching == FetchOCSPForDVSoftFail ||
        blocklistIsFresh))) {
    // We're not going to be doing any fetching, so if there was a cached
    // "unknown" response, say so.
    if (cachedResponseResult == Result::ERROR_OCSP_UNKNOWN_CERT) {
      return Result::ERROR_OCSP_UNKNOWN_CERT;
    }
    // If we're doing hard-fail, we want to know if we have a cached response
    // that has expired.
    if (mOCSPFetching == FetchOCSPForDVHardFail &&
        cachedResponseResult == Result::ERROR_OCSP_OLD_RESPONSE) {
      return Result::ERROR_OCSP_OLD_RESPONSE;
    }

    return Success;
  }

  if (mOCSPFetching == LocalOnlyOCSPForEV) {
    if (cachedResponseResult != Success) {
      return cachedResponseResult;
    }
    return Result::ERROR_OCSP_UNKNOWN_CERT;
  }

  UniquePLArenaPool arena(PORT_NewArena(DER_DEFAULT_CHUNKSIZE));
  if (!arena) {
    return Result::FATAL_ERROR_NO_MEMORY;
  }

  Result rv;
  const char* url = nullptr; // owned by the arena

  if (aiaExtension) {
    rv = GetOCSPAuthorityInfoAccessLocation(arena, *aiaExtension, url);
    if (rv != Success) {
      return rv;
    }
  }

  if (!url) {
    if (mOCSPFetching == FetchOCSPForEV ||
        cachedResponseResult == Result::ERROR_OCSP_UNKNOWN_CERT) {
      return Result::ERROR_OCSP_UNKNOWN_CERT;
    }
    if (cachedResponseResult == Result::ERROR_OCSP_OLD_RESPONSE) {
      return Result::ERROR_OCSP_OLD_RESPONSE;
    }
    if (stapledOCSPResponseResult != Success) {
      return stapledOCSPResponseResult;
    }

    // Nothing to do if we don't have an OCSP responder URI for the cert; just
    // assume it is good. Note that this is the confusing, but intended,
    // interpretation of "strict" revocation checking in the face of a
    // certificate that lacks an OCSP responder URI.
    return Success;
  }

  // Only request a response if we didn't have a cached indication of failure
  // (don't keep requesting responses from a failing server).
  Input response;
  bool attemptedRequest;
  if (cachedResponseResult == Success ||
      cachedResponseResult == Result::ERROR_OCSP_UNKNOWN_CERT ||
      cachedResponseResult == Result::ERROR_OCSP_OLD_RESPONSE) {
    uint8_t ocspRequest[OCSP_REQUEST_MAX_LENGTH];
    size_t ocspRequestLength;
    rv = CreateEncodedOCSPRequest(*this, certID, ocspRequest,
                                  ocspRequestLength);
    if (rv != Success) {
      return rv;
    }
    SECItem ocspRequestItem = {
      siBuffer,
      ocspRequest,
      static_cast<unsigned int>(ocspRequestLength)
    };
    // Owned by arena
    SECItem* responseSECItem = nullptr;
    Result tempRV =
      DoOCSPRequest(arena, url, mOriginAttributes, &ocspRequestItem,
                    OCSPFetchingTypeToTimeoutTime(mOCSPFetching),
                    mOCSPGetConfig == CertVerifier::ocspGetEnabled,
                    responseSECItem);
    MOZ_ASSERT((tempRV != Success) || responseSECItem);
    if (tempRV != Success) {
      rv = tempRV;
    } else if (response.Init(responseSECItem->data, responseSECItem->len)
                 != Success) {
      rv = Result::ERROR_OCSP_MALFORMED_RESPONSE; // too big
    }
    attemptedRequest = true;
  } else {
    rv = cachedResponseResult;
    attemptedRequest = false;
  }

  if (response.GetLength() == 0) {
    Result error = rv;
    if (attemptedRequest) {
      Time timeout(time);
      if (timeout.AddSeconds(ServerFailureDelaySeconds) != Success) {
        return Result::FATAL_ERROR_LIBRARY_FAILURE; // integer overflow
      }
      rv = mOCSPCache.Put(certID, mOriginAttributes, error, time, timeout);
      if (rv != Success) {
        return rv;
      }
    }
    if (mOCSPFetching != FetchOCSPForDVSoftFail) {
      MOZ_LOG(gCertVerifierLog, LogLevel::Debug,
             ("NSSCertDBTrustDomain: returning SECFailure after "
              "OCSP request failure"));
      return error;
    }
    if (cachedResponseResult == Result::ERROR_OCSP_UNKNOWN_CERT) {
      MOZ_LOG(gCertVerifierLog, LogLevel::Debug,
             ("NSSCertDBTrustDomain: returning SECFailure from cached "
              "response after OCSP request failure"));
      return cachedResponseResult;
    }
    if (stapledOCSPResponseResult != Success) {
      MOZ_LOG(gCertVerifierLog, LogLevel::Debug,
             ("NSSCertDBTrustDomain: returning SECFailure from expired "
              "stapled response after OCSP request failure"));
      return stapledOCSPResponseResult;
    }

    MOZ_LOG(gCertVerifierLog, LogLevel::Debug,
           ("NSSCertDBTrustDomain: returning SECSuccess after "
            "OCSP request failure"));
    return Success; // Soft fail -> success :(
  }

  // If the response from the network has expired but indicates a revoked
  // or unknown certificate, PR_GetError() will return the appropriate error.
  // We actually ignore expired here.
  bool expired;
  rv = VerifyAndMaybeCacheEncodedOCSPResponse(certID, time,
                                              maxOCSPLifetimeInDays,
                                              response, ResponseIsFromNetwork,
                                              expired);
  if (rv == Success || mOCSPFetching != FetchOCSPForDVSoftFail) {
    MOZ_LOG(gCertVerifierLog, LogLevel::Debug,
      ("NSSCertDBTrustDomain: returning after VerifyEncodedOCSPResponse"));
    return rv;
  }

  if (rv == Result::ERROR_OCSP_UNKNOWN_CERT ||
      rv == Result::ERROR_REVOKED_CERTIFICATE) {
    return rv;
  }
  if (stapledOCSPResponseResult != Success) {
    MOZ_LOG(gCertVerifierLog, LogLevel::Debug,
           ("NSSCertDBTrustDomain: returning SECFailure from expired stapled "
            "response after OCSP request verification failure"));
    return stapledOCSPResponseResult;
  }

  MOZ_LOG(gCertVerifierLog, LogLevel::Debug,
         ("NSSCertDBTrustDomain: end of CheckRevocation"));

  return Success; // Soft fail -> success :(
}

Result
NSSCertDBTrustDomain::VerifyAndMaybeCacheEncodedOCSPResponse(
  const CertID& certID, Time time, uint16_t maxLifetimeInDays,
  Input encodedResponse, EncodedResponseSource responseSource,
  /*out*/ bool& expired)
{
  Time thisUpdate(Time::uninitialized);
  Time validThrough(Time::uninitialized);

  // We use a try and fallback approach which first mandates good signature
  // digest algorithms, then falls back to SHA-1 if this fails. If a delegated
  // OCSP response signing certificate was issued with a SHA-1 signature,
  // verification initially fails. We cache the failure and then re-use that
  // result even when doing fallback (i.e. when weak signature digest algorithms
  // should succeed). To address this we use an OCSPVerificationTrustDomain
  // here, rather than using *this, to ensure verification succeeds for all
  // allowed signature digest algorithms.
  OCSPVerificationTrustDomain trustDomain(*this);
  Result rv = VerifyEncodedOCSPResponse(trustDomain, certID, time,
                                        maxLifetimeInDays, encodedResponse,
                                        expired, &thisUpdate, &validThrough);
  // If a response was stapled and expired, we don't want to cache it. Return
  // early to simplify the logic here.
  if (responseSource == ResponseWasStapled && expired) {
    PR_ASSERT(rv != Success);
    return rv;
  }
  // validThrough is only trustworthy if the response successfully verifies
  // or it indicates a revoked or unknown certificate.
  // If this isn't the case, store an indication of failure (to prevent
  // repeatedly requesting a response from a failing server).
  if (rv != Success && rv != Result::ERROR_REVOKED_CERTIFICATE &&
      rv != Result::ERROR_OCSP_UNKNOWN_CERT) {
    validThrough = time;
    if (validThrough.AddSeconds(ServerFailureDelaySeconds) != Success) {
      return Result::FATAL_ERROR_LIBRARY_FAILURE; // integer overflow
    }
  }
  if (responseSource == ResponseIsFromNetwork ||
      rv == Success ||
      rv == Result::ERROR_REVOKED_CERTIFICATE ||
      rv == Result::ERROR_OCSP_UNKNOWN_CERT) {
    MOZ_LOG(gCertVerifierLog, LogLevel::Debug,
           ("NSSCertDBTrustDomain: caching OCSP response"));
    Result putRV = mOCSPCache.Put(certID, mOriginAttributes, rv, thisUpdate,
                                  validThrough);
    if (putRV != Success) {
      return putRV;
    }
  }

  return rv;
}

static const uint8_t CNNIC_ROOT_CA_SUBJECT_DATA[] =
  "\x30\x32\x31\x0B\x30\x09\x06\x03\x55\x04\x06\x13\x02\x43\x4E\x31\x0E\x30"
  "\x0C\x06\x03\x55\x04\x0A\x13\x05\x43\x4E\x4E\x49\x43\x31\x13\x30\x11\x06"
  "\x03\x55\x04\x03\x13\x0A\x43\x4E\x4E\x49\x43\x20\x52\x4F\x4F\x54";

static const uint8_t CNNIC_EV_ROOT_CA_SUBJECT_DATA[] =
  "\x30\x81\x8A\x31\x0B\x30\x09\x06\x03\x55\x04\x06\x13\x02\x43\x4E\x31\x32"
  "\x30\x30\x06\x03\x55\x04\x0A\x0C\x29\x43\x68\x69\x6E\x61\x20\x49\x6E\x74"
  "\x65\x72\x6E\x65\x74\x20\x4E\x65\x74\x77\x6F\x72\x6B\x20\x49\x6E\x66\x6F"
  "\x72\x6D\x61\x74\x69\x6F\x6E\x20\x43\x65\x6E\x74\x65\x72\x31\x47\x30\x45"
  "\x06\x03\x55\x04\x03\x0C\x3E\x43\x68\x69\x6E\x61\x20\x49\x6E\x74\x65\x72"
  "\x6E\x65\x74\x20\x4E\x65\x74\x77\x6F\x72\x6B\x20\x49\x6E\x66\x6F\x72\x6D"
  "\x61\x74\x69\x6F\x6E\x20\x43\x65\x6E\x74\x65\x72\x20\x45\x56\x20\x43\x65"
  "\x72\x74\x69\x66\x69\x63\x61\x74\x65\x73\x20\x52\x6F\x6F\x74";

class WhitelistedCNNICHashBinarySearchComparator
{
public:
  explicit WhitelistedCNNICHashBinarySearchComparator(const uint8_t* aTarget,
                                                      size_t aTargetLength)
    : mTarget(aTarget)
  {
    MOZ_ASSERT(aTargetLength == CNNIC_WHITELIST_HASH_LEN,
               "Hashes should be of the same length.");
  }

  int operator()(const WhitelistedCNNICHash val) const {
    return memcmp(mTarget, val.hash, CNNIC_WHITELIST_HASH_LEN);
  }

private:
  const uint8_t* mTarget;
};

static bool
CertIsStartComOrWoSign(const CERTCertificate* cert)
{
  for (const DataAndLength& dn : StartComAndWoSignDNs) {
    if (cert->derSubject.len == dn.len &&
        PodEqual(cert->derSubject.data, dn.data, dn.len)) {
      return true;
    }
  }
  return false;
}

// If a certificate in the given chain appears to have been issued by one of
// seven roots operated by StartCom and WoSign that are not trusted to issue new
// certificates, verify that the end-entity has a notBefore date before 21
// October 2016. If the value of notBefore is after this time, the chain is not
// valid.
// (NB: While there are seven distinct roots being checked for, two of them
// share distinguished names, resulting in six distinct distinguished names to
// actually look for.)
static Result
CheckForStartComOrWoSign(const UniqueCERTCertList& certChain)
{
  if (CERT_LIST_EMPTY(certChain)) {
    return Result::FATAL_ERROR_LIBRARY_FAILURE;
  }
  const CERTCertListNode* endEntityNode = CERT_LIST_HEAD(certChain);
  if (!endEntityNode || !endEntityNode->cert) {
    return Result::FATAL_ERROR_LIBRARY_FAILURE;
  }
  PRTime notBefore;
  PRTime notAfter;
  if (CERT_GetCertTimes(endEntityNode->cert, &notBefore, &notAfter)
        != SECSuccess) {
    return Result::FATAL_ERROR_LIBRARY_FAILURE;
  }
  // PRTime is microseconds since the epoch, whereas JS time is milliseconds.
  // (new Date("2016-10-21T00:00:00Z")).getTime() * 1000
  static const PRTime OCTOBER_21_2016 = 1477008000000000;
  if (notBefore <= OCTOBER_21_2016) {
    return Success;
  }

  for (const CERTCertListNode* node = CERT_LIST_HEAD(certChain);
       !CERT_LIST_END(node, certChain); node = CERT_LIST_NEXT(node)) {
    if (!node || !node->cert) {
      return Result::FATAL_ERROR_LIBRARY_FAILURE;
    }
    if (CertIsStartComOrWoSign(node->cert)) {
      return Result::ERROR_REVOKED_CERTIFICATE;
    }
  }
  return Success;
}

Result
NSSCertDBTrustDomain::IsChainValid(const DERArray& certArray, Time time)
{
  MOZ_LOG(gCertVerifierLog, LogLevel::Debug,
         ("NSSCertDBTrustDomain: IsChainValid"));

  UniqueCERTCertList certList;
  SECStatus srv = ConstructCERTCertListFromReversedDERArray(certArray,
                                                            certList);
  if (srv != SECSuccess) {
    return MapPRErrorCodeToResult(PR_GetError());
  }
  if (CERT_LIST_EMPTY(certList)) {
    return Result::FATAL_ERROR_LIBRARY_FAILURE;
  }

  Result rv = CheckForStartComOrWoSign(certList);
  if (rv != Success) {
    return rv;
  }

  // If the certificate appears to have been issued by a CNNIC root, only allow
  // it if it is on the whitelist.
  CERTCertListNode* rootNode = CERT_LIST_TAIL(certList);
  if (!rootNode) {
    return Result::FATAL_ERROR_LIBRARY_FAILURE;
  }
  CERTCertificate* root = rootNode->cert;
  if (!root) {
    return Result::FATAL_ERROR_LIBRARY_FAILURE;
  }
  if ((root->derSubject.len == sizeof(CNNIC_ROOT_CA_SUBJECT_DATA) - 1 &&
       memcmp(root->derSubject.data, CNNIC_ROOT_CA_SUBJECT_DATA,
              root->derSubject.len) == 0) ||
      (root->derSubject.len == sizeof(CNNIC_EV_ROOT_CA_SUBJECT_DATA) - 1 &&
       memcmp(root->derSubject.data, CNNIC_EV_ROOT_CA_SUBJECT_DATA,
              root->derSubject.len) == 0)) {
    CERTCertListNode* certNode = CERT_LIST_HEAD(certList);
    if (!certNode) {
      return Result::FATAL_ERROR_LIBRARY_FAILURE;
    }
    CERTCertificate* cert = certNode->cert;
    if (!cert) {
      return Result::FATAL_ERROR_LIBRARY_FAILURE;
    }
    Digest digest;
    nsresult nsrv = digest.DigestBuf(SEC_OID_SHA256, cert->derCert.data,
                                     cert->derCert.len);
    if (NS_FAILED(nsrv)) {
      return Result::FATAL_ERROR_LIBRARY_FAILURE;
    }
    const uint8_t* certHash(
      BitwiseCast<uint8_t*, unsigned char*>(digest.get().data));
    size_t certHashLen = digest.get().len;
    size_t unused;
    if (!mozilla::BinarySearchIf(WhitelistedCNNICHashes, 0,
                                 ArrayLength(WhitelistedCNNICHashes),
                                 WhitelistedCNNICHashBinarySearchComparator(
                                   certHash, certHashLen),
                                 &unused)) {
      return Result::ERROR_REVOKED_CERTIFICATE;
    }
  }

  bool isBuiltInRoot = false;
  rv = IsCertBuiltInRoot(root, isBuiltInRoot);
  if (rv != Success) {
    return rv;
  }
  bool skipPinningChecksBecauseOfMITMMode =
    (!isBuiltInRoot && mPinningMode == CertVerifier::pinningAllowUserCAMITM);
  // If mHostname isn't set, we're not verifying in the context of a TLS
  // handshake, so don't verify HPKP in those cases.
  if (mHostname && (mPinningMode != CertVerifier::pinningDisabled) &&
      !skipPinningChecksBecauseOfMITMMode) {
    bool enforceTestMode =
      (mPinningMode == CertVerifier::pinningEnforceTestMode);
    bool chainHasValidPins;
    nsresult nsrv = PublicKeyPinningService::ChainHasValidPins(
      certList, mHostname, time, enforceTestMode, chainHasValidPins,
      mPinningTelemetryInfo);
    if (NS_FAILED(nsrv)) {
      return Result::FATAL_ERROR_LIBRARY_FAILURE;
    }
    if (!chainHasValidPins) {
      return Result::ERROR_KEY_PINNING_FAILURE;
    }
  }

  mBuiltChain = Move(certList);

  return Success;
}

Result
NSSCertDBTrustDomain::CheckSignatureDigestAlgorithm(DigestAlgorithm aAlg,
                                                    EndEntityOrCA endEntityOrCA,
                                                    Time notBefore)
{
  // (new Date("2016-01-01T00:00:00Z")).getTime() / 1000
  static const Time JANUARY_FIRST_2016 = TimeFromEpochInSeconds(1451606400);

  MOZ_LOG(gCertVerifierLog, LogLevel::Debug,
          ("NSSCertDBTrustDomain: CheckSignatureDigestAlgorithm"));
  if (aAlg == DigestAlgorithm::sha1) {
    switch (mSHA1Mode) {
      case CertVerifier::SHA1Mode::Forbidden:
        MOZ_LOG(gCertVerifierLog, LogLevel::Debug, ("SHA-1 certificate rejected"));
        return Result::ERROR_CERT_SIGNATURE_ALGORITHM_DISABLED;
      case CertVerifier::SHA1Mode::ImportedRootOrBefore2016:
        if (JANUARY_FIRST_2016 <= notBefore) {
          MOZ_LOG(gCertVerifierLog, LogLevel::Debug, ("Post-2015 SHA-1 certificate rejected"));
          return Result::ERROR_CERT_SIGNATURE_ALGORITHM_DISABLED;
        }
        break;
      case CertVerifier::SHA1Mode::Allowed:
      // Enforcing that the resulting chain uses an imported root is only
      // possible at a higher level. This is done in CertVerifier::VerifyCert.
      case CertVerifier::SHA1Mode::ImportedRoot:
      default:
        break;
      // MSVC warns unless we explicitly handle this now-unused option.
      case CertVerifier::SHA1Mode::UsedToBeBefore2016ButNowIsForbidden:
        MOZ_ASSERT_UNREACHABLE("unexpected SHA1Mode type");
        return Result::FATAL_ERROR_LIBRARY_FAILURE;
    }
  }

  return Success;
}

Result
NSSCertDBTrustDomain::CheckRSAPublicKeyModulusSizeInBits(
  EndEntityOrCA /*endEntityOrCA*/, unsigned int modulusSizeInBits)
{
  if (modulusSizeInBits < mMinRSABits) {
    return Result::ERROR_INADEQUATE_KEY_SIZE;
  }
  return Success;
}

Result
NSSCertDBTrustDomain::VerifyRSAPKCS1SignedDigest(
  const SignedDigest& signedDigest,
  Input subjectPublicKeyInfo)
{
  return VerifyRSAPKCS1SignedDigestNSS(signedDigest, subjectPublicKeyInfo,
                                       mPinArg);
}

Result
NSSCertDBTrustDomain::CheckECDSACurveIsAcceptable(
  EndEntityOrCA /*endEntityOrCA*/, NamedCurve curve)
{
  switch (curve) {
    case NamedCurve::secp256r1: // fall through
    case NamedCurve::secp384r1: // fall through
    case NamedCurve::secp521r1:
      return Success;
  }

  return Result::ERROR_UNSUPPORTED_ELLIPTIC_CURVE;
}

Result
NSSCertDBTrustDomain::VerifyECDSASignedDigest(const SignedDigest& signedDigest,
                                              Input subjectPublicKeyInfo)
{
  return VerifyECDSASignedDigestNSS(signedDigest, subjectPublicKeyInfo,
                                    mPinArg);
}

Result
NSSCertDBTrustDomain::CheckValidityIsAcceptable(Time notBefore, Time notAfter,
                                                EndEntityOrCA endEntityOrCA,
                                                KeyPurposeId keyPurpose)
{
  if (endEntityOrCA != EndEntityOrCA::MustBeEndEntity) {
    return Success;
  }
  if (keyPurpose == KeyPurposeId::id_kp_OCSPSigning) {
    return Success;
  }

  Duration DURATION_27_MONTHS_PLUS_SLOP((2 * 365 + 3 * 31 + 7) *
                                        Time::ONE_DAY_IN_SECONDS);
  Duration maxValidityDuration(UINT64_MAX);
  Duration validityDuration(notBefore, notAfter);

  switch (mValidityCheckingMode) {
    case ValidityCheckingMode::CheckingOff:
      return Success;
    case ValidityCheckingMode::CheckForEV:
      // The EV Guidelines say the maximum is 27 months, but we use a slightly
      // higher limit here to (hopefully) minimize compatibility breakage.
      maxValidityDuration = DURATION_27_MONTHS_PLUS_SLOP;
      break;
    default:
      PR_NOT_REACHED("We're not handling every ValidityCheckingMode type");
  }

  if (validityDuration > maxValidityDuration) {
    return Result::ERROR_VALIDITY_TOO_LONG;
  }

  return Success;
}

Result
NSSCertDBTrustDomain::NetscapeStepUpMatchesServerAuth(Time notBefore,
                                                      /*out*/ bool& matches)
{
  // (new Date("2015-08-23T00:00:00Z")).getTime() / 1000
  static const Time AUGUST_23_2015 = TimeFromEpochInSeconds(1440288000);
  // (new Date("2016-08-23T00:00:00Z")).getTime() / 1000
  static const Time AUGUST_23_2016 = TimeFromEpochInSeconds(1471910400);

  switch (mNetscapeStepUpPolicy) {
    case NetscapeStepUpPolicy::AlwaysMatch:
      matches = true;
      return Success;
    case NetscapeStepUpPolicy::MatchBefore23August2016:
      matches = notBefore < AUGUST_23_2016;
      return Success;
    case NetscapeStepUpPolicy::MatchBefore23August2015:
      matches = notBefore < AUGUST_23_2015;
      return Success;
    case NetscapeStepUpPolicy::NeverMatch:
      matches = false;
      return Success;
    default:
      MOZ_ASSERT_UNREACHABLE("unhandled NetscapeStepUpPolicy type");
  }
  return Result::FATAL_ERROR_LIBRARY_FAILURE;
}

void
NSSCertDBTrustDomain::ResetAccumulatedState()
{
  mOCSPStaplingStatus = CertVerifier::OCSP_STAPLING_NEVER_CHECKED;
  mSCTListFromOCSPStapling = nullptr;
  mSCTListFromCertificate = nullptr;
}

static Input
SECItemToInput(const UniqueSECItem& item)
{
  Input result;
  if (item) {
    MOZ_ASSERT(item->type == siBuffer);
    Result rv = result.Init(item->data, item->len);
    // As used here, |item| originally comes from an Input,
    // so there should be no issues converting it back.
    MOZ_ASSERT(rv == Success);
    Unused << rv; // suppresses warnings in release builds
  }
  return result;
}

Input
NSSCertDBTrustDomain::GetSCTListFromCertificate() const
{
  return SECItemToInput(mSCTListFromCertificate);
}

Input
NSSCertDBTrustDomain::GetSCTListFromOCSPStapling() const
{
  return SECItemToInput(mSCTListFromOCSPStapling);
}

void
NSSCertDBTrustDomain::NoteAuxiliaryExtension(AuxiliaryExtension extension,
                                             Input extensionData)
{
  UniqueSECItem* out = nullptr;
  switch (extension) {
    case AuxiliaryExtension::EmbeddedSCTList:
      out = &mSCTListFromCertificate;
      break;
    case AuxiliaryExtension::SCTListFromOCSPResponse:
      out = &mSCTListFromOCSPStapling;
      break;
    default:
      MOZ_ASSERT_UNREACHABLE("unhandled AuxiliaryExtension");
  }
  if (out) {
    SECItem extensionDataItem = UnsafeMapInputToSECItem(extensionData);
    out->reset(SECITEM_DupItem(&extensionDataItem));
  }
}

SECStatus
InitializeNSS(const char* dir, bool readOnly, bool loadPKCS11Modules)
{
  // The NSS_INIT_NOROOTINIT flag turns off the loading of the root certs
  // module by NSS_Initialize because we will load it in InstallLoadableRoots
  // later.  It also allows us to work around a bug in the system NSS in
  // Ubuntu 8.04, which loads any nonexistent "<configdir>/libnssckbi.so" as
  // "/usr/lib/nss/libnssckbi.so".
  uint32_t flags = NSS_INIT_NOROOTINIT | NSS_INIT_OPTIMIZESPACE;
  if (readOnly) {
    flags |= NSS_INIT_READONLY;
  }
  if (!loadPKCS11Modules) {
    flags |= NSS_INIT_NOMODDB;
  }
  return ::NSS_Initialize(dir, "", "", SECMOD_DB, flags);
}

void
DisableMD5()
{
  NSS_SetAlgorithmPolicy(SEC_OID_MD5,
    0, NSS_USE_ALG_IN_CERT_SIGNATURE | NSS_USE_ALG_IN_CMS_SIGNATURE);
  NSS_SetAlgorithmPolicy(SEC_OID_PKCS1_MD5_WITH_RSA_ENCRYPTION,
    0, NSS_USE_ALG_IN_CERT_SIGNATURE | NSS_USE_ALG_IN_CMS_SIGNATURE);
  NSS_SetAlgorithmPolicy(SEC_OID_PKCS5_PBE_WITH_MD5_AND_DES_CBC,
    0, NSS_USE_ALG_IN_CERT_SIGNATURE | NSS_USE_ALG_IN_CMS_SIGNATURE);
}

SECStatus
LoadLoadableRoots(/*optional*/ const char* dir, const char* modNameUTF8)
{
  PR_ASSERT(modNameUTF8);

  if (!modNameUTF8) {
    PR_SetError(SEC_ERROR_INVALID_ARGS, 0);
    return SECFailure;
  }

  UniquePtr<char, void(&)(char*)>
    fullLibraryPath(PR_GetLibraryName(dir, "nssckbi"), PR_FreeLibraryName);
  if (!fullLibraryPath) {
    return SECFailure;
  }

  // Escape the \ and " characters.
  nsAutoCString escapedFullLibraryPath(fullLibraryPath.get());
  escapedFullLibraryPath.ReplaceSubstring("\\", "\\\\");
  escapedFullLibraryPath.ReplaceSubstring("\"", "\\\"");
  if (escapedFullLibraryPath.IsEmpty()) {
    return SECFailure;
  }

  // If a module exists with the same name, delete it.
  int modType;
  SECMOD_DeleteModule(modNameUTF8, &modType);

  nsAutoCString pkcs11ModuleSpec;
  pkcs11ModuleSpec.AppendPrintf("name=\"%s\" library=\"%s\"", modNameUTF8,
                                escapedFullLibraryPath.get());
  if (pkcs11ModuleSpec.IsEmpty()) {
    return SECFailure;
  }

  UniqueSECMODModule rootsModule(
    SECMOD_LoadUserModule(const_cast<char*>(pkcs11ModuleSpec.get()), nullptr,
                          false));
  if (!rootsModule) {
    return SECFailure;
  }

  if (!rootsModule->loaded) {
    PR_SetError(PR_INVALID_STATE_ERROR, 0);
    return SECFailure;
  }

  return SECSuccess;
}

void
UnloadLoadableRoots(const char* modNameUTF8)
{
  PR_ASSERT(modNameUTF8);
  UniqueSECMODModule rootsModule(SECMOD_FindModule(modNameUTF8));

  if (rootsModule) {
    SECMOD_UnloadUserModule(rootsModule.get());
  }
}

nsresult
DefaultServerNicknameForCert(const CERTCertificate* cert,
                     /*out*/ nsCString& nickname)
{
  MOZ_ASSERT(cert);
  NS_ENSURE_ARG_POINTER(cert);

  UniquePORTString baseName(CERT_GetCommonName(&cert->subject));
  if (!baseName) {
    baseName = UniquePORTString(CERT_GetOrgUnitName(&cert->subject));
  }
  if (!baseName) {
    baseName = UniquePORTString(CERT_GetOrgName(&cert->subject));
  }
  if (!baseName) {
    baseName = UniquePORTString(CERT_GetLocalityName(&cert->subject));
  }
  if (!baseName) {
    baseName = UniquePORTString(CERT_GetStateName(&cert->subject));
  }
  if (!baseName) {
    baseName = UniquePORTString(CERT_GetCountryName(&cert->subject));
  }
  if (!baseName) {
    return NS_ERROR_FAILURE;
  }

  // This function is only used in contexts where a failure to find a suitable
  // nickname does not block the overall task from succeeding.
  // As such, we use an arbitrary limit to prevent this nickname searching
  // process from taking forever.
  static const uint32_t ARBITRARY_LIMIT = 500;
  for (uint32_t count = 1; count < ARBITRARY_LIMIT; count++) {
    nickname = baseName.get();
    if (count != 1) {
      nickname.AppendPrintf(" #%u", count);
    }
    if (nickname.IsEmpty()) {
      return NS_ERROR_FAILURE;
    }

    bool conflict = SEC_CertNicknameConflict(nickname.get(), &cert->derSubject,
                                             cert->dbhandle);
    if (!conflict) {
      return NS_OK;
    }
  }

  return NS_ERROR_FAILURE;
}

/**
 * Given a list of certificates representing a verified certificate path from an
 * end-entity certificate to a trust anchor, imports the intermediate
 * certificates into the permanent certificate database. This is an attempt to
 * cope with misconfigured servers that don't include the appropriate
 * intermediate certificates in the TLS handshake.
 *
 * @param certList the verified certificate list
 */
void
SaveIntermediateCerts(const UniqueCERTCertList& certList)
{
  if (!certList) {
    return;
  }

  UniquePK11SlotInfo slot(PK11_GetInternalKeySlot());
  if (!slot) {
    return;
  }

  bool isEndEntity = true;
  for (CERTCertListNode* node = CERT_LIST_HEAD(certList);
        !CERT_LIST_END(node, certList);
        node = CERT_LIST_NEXT(node)) {
    if (isEndEntity) {
      // Skip the end-entity; we only want to store intermediates
      isEndEntity = false;
      continue;
    }

    if (node->cert->slot) {
      // This cert was found on a token; no need to remember it in the permanent
      // database.
      continue;
    }

    if (node->cert->isperm) {
      // We don't need to remember certs already stored in perm db.
      continue;
    }

    // No need to save the trust anchor - it's either already a permanent
    // certificate or it's the Microsoft Family Safety root or an enterprise
    // root temporarily imported via the child mode or enterprise root features.
    // We don't want to import these because they're intended to be temporary
    // (and because importing them happens to reset their trust settings, which
    // breaks these features).
    if (node == CERT_LIST_TAIL(certList)) {
      continue;
    }

    nsAutoCString nickname;
    nsresult rv = DefaultServerNicknameForCert(node->cert, nickname);
    if (NS_FAILED(rv)) {
      continue;
    }

    // As mentioned in the documentation of this function, we're importing only
    // to cope with misconfigured servers. As such, we ignore the return value
    // below, since it doesn't really matter if the import fails.
    Unused << PK11_ImportCert(slot.get(), node->cert, CK_INVALID_HANDLE,
                              nickname.get(), false);
  }
}

} } // namespace mozilla::psm
