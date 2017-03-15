/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef TransportSecurityInfo_h
#define TransportSecurityInfo_h

#include "ScopedNSSTypes.h"
#include "certt.h"
#include "mozilla/BasePrincipal.h"
#include "mozilla/Mutex.h"
#include "mozilla/RefPtr.h"
#include "nsDataHashtable.h"
#include "nsIAssociatedContentSecurity.h"
#include "nsIInterfaceRequestor.h"
#include "nsISSLStatusProvider.h"
#include "nsITransportSecurityInfo.h"
#include "nsNSSShutDown.h"
#include "nsSSLStatus.h"
#include "pkix/pkixtypes.h"

namespace mozilla { namespace psm {

enum SSLErrorMessageType {
  OverridableCertErrorMessage  = 1, // for *overridable* certificate errors
  PlainErrorMessage = 2             // all other errors (or "no error")
};

class TransportSecurityInfo : public nsITransportSecurityInfo,
                              public nsIInterfaceRequestor,
                              public nsISSLStatusProvider,
                              public nsIAssociatedContentSecurity,
                              public nsISerializable,
                              public nsIClassInfo,
                              public nsNSSShutDownObject,
                              public nsOnPK11LogoutCancelObject
{
protected:
  virtual ~TransportSecurityInfo();
public:
  TransportSecurityInfo();
  
  NS_DECL_THREADSAFE_ISUPPORTS
  NS_DECL_NSITRANSPORTSECURITYINFO
  NS_DECL_NSIINTERFACEREQUESTOR
  NS_DECL_NSISSLSTATUSPROVIDER
  NS_DECL_NSIASSOCIATEDCONTENTSECURITY
  NS_DECL_NSISERIALIZABLE
  NS_DECL_NSICLASSINFO

  nsresult SetSecurityState(uint32_t aState);
  nsresult SetShortSecurityDescription(const char16_t *aText);

  const nsACString & GetHostName() const { return mHostName; }
  const char * GetHostNameRaw() const { return mHostName.get(); }

  nsresult GetHostName(char **aHostName);
  nsresult SetHostName(const char *aHostName);

  int32_t GetPort() const { return mPort; }
  nsresult GetPort(int32_t *aPort);
  nsresult SetPort(int32_t aPort);

  const NeckoOriginAttributes& GetOriginAttributes() const {
    return mOriginAttributes;
  }
  nsresult SetOriginAttributes(const NeckoOriginAttributes& aOriginAttributes);

  PRErrorCode GetErrorCode() const;
  
  void GetErrorLogMessage(PRErrorCode errorCode,
                          ::mozilla::psm::SSLErrorMessageType errorMessageType,
                          nsString &result);
  
  void SetCanceled(PRErrorCode errorCode,
                   ::mozilla::psm::SSLErrorMessageType errorMessageType);

  /* Set SSL Status values */
  nsresult SetSSLStatus(nsSSLStatus *aSSLStatus);
  nsSSLStatus* SSLStatus() { return mSSLStatus; }
  void SetStatusErrorBits(nsNSSCertificate* cert, uint32_t collected_errors);

  nsresult SetFailedCertChain(UniqueCERTCertList certList);

private:
  mutable ::mozilla::Mutex mMutex;

protected:
  nsCOMPtr<nsIInterfaceRequestor> mCallbacks;

private:
  uint32_t mSecurityState;
  int32_t mSubRequestsBrokenSecurity;
  int32_t mSubRequestsNoSecurity;

  PRErrorCode mErrorCode;
  ::mozilla::psm::SSLErrorMessageType mErrorMessageType;
  nsString mErrorMessageCached;
  nsresult formatErrorMessage(::mozilla::MutexAutoLock const & proofOfLock, 
                              PRErrorCode errorCode,
                              ::mozilla::psm::SSLErrorMessageType errorMessageType,
                              bool wantsHtml, bool suppressPort443, 
                              nsString &result);

  int32_t mPort;
  nsXPIDLCString mHostName;
  NeckoOriginAttributes mOriginAttributes;

  /* SSL Status */
  RefPtr<nsSSLStatus> mSSLStatus;

  /* Peer cert chain for failed connections (for error reporting) */
  nsCOMPtr<nsIX509CertList> mFailedCertChain;

  virtual void virtualDestroyNSSReference() override;
  void destructorSafeDestroyNSSReference();
};

class RememberCertErrorsTable
{
private:
  RememberCertErrorsTable();

  struct CertStateBits
  {
    bool mIsDomainMismatch;
    bool mIsNotValidAtThisTime;
    bool mIsUntrusted;
  };
  nsDataHashtable<nsCStringHashKey, CertStateBits> mErrorHosts;

public:
  void RememberCertHasError(TransportSecurityInfo * infoobject,
                            nsSSLStatus * status,
                            SECStatus certVerificationResult);
  void LookupCertErrorBits(TransportSecurityInfo * infoObject,
                           nsSSLStatus* status);

  static nsresult Init()
  {
    sInstance = new RememberCertErrorsTable();
    return NS_OK;
  }

  static RememberCertErrorsTable & GetInstance()
  {
    MOZ_ASSERT(sInstance);
    return *sInstance;
  }

  static void Cleanup()
  {
    delete sInstance;
    sInstance = nullptr;
  }
private:
  Mutex mMutex;

  static RememberCertErrorsTable * sInstance;
};

} } // namespace mozilla::psm

// 16786594-0296-4471-8096-8f84497ca428
#define TRANSPORTSECURITYINFO_CID \
{ 0x16786594, 0x0296, 0x4471, \
    { 0x80, 0x96, 0x8f, 0x84, 0x49, 0x7c, 0xa4, 0x28 } }

#endif // TransportSecurityInfo_h
