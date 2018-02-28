/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef GMPCDMProxy_h_
#define GMPCDMProxy_h_

#include "mozilla/CDMProxy.h"
#include "GMPCDMCallbackProxy.h"
#include "GMPDecryptorProxy.h"

namespace mozilla {

class MediaRawData;
class DecryptJob;

// Implementation of CDMProxy which is based on GMP architecture.
class GMPCDMProxy : public CDMProxy {
public:

  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(GMPCDMProxy, override)

  GMPCDMProxy(dom::MediaKeys* aKeys,
              const nsAString& aKeySystem,
              GMPCrashHelper* aCrashHelper,
              bool aDistinctiveIdentifierRequired,
              bool aPersistentStateRequired,
              nsIEventTarget* aMainThread);

  void Init(PromiseId aPromiseId,
            const nsAString& aOrigin,
            const nsAString& aTopLevelOrigin,
            const nsAString& aGMPName) override;

  void OnSetDecryptorId(uint32_t aId) override;

  void CreateSession(uint32_t aCreateSessionToken,
                     dom::MediaKeySessionType aSessionType,
                     PromiseId aPromiseId,
                     const nsAString& aInitDataType,
                     nsTArray<uint8_t>& aInitData) override;

  void LoadSession(PromiseId aPromiseId,
                   dom::MediaKeySessionType aSessionType,
                   const nsAString& aSessionId) override;

  void SetServerCertificate(PromiseId aPromiseId,
                            nsTArray<uint8_t>& aCert) override;

  void UpdateSession(const nsAString& aSessionId,
                     PromiseId aPromiseId,
                     nsTArray<uint8_t>& aResponse) override;

  void CloseSession(const nsAString& aSessionId,
                    PromiseId aPromiseId) override;

  void RemoveSession(const nsAString& aSessionId,
                     PromiseId aPromiseId) override;

  void Shutdown() override;

  void Terminated() override;

  const nsCString& GetNodeId() const override;

  void OnSetSessionId(uint32_t aCreateSessionToken,
                      const nsAString& aSessionId) override;

  void OnResolveLoadSessionPromise(uint32_t aPromiseId, bool aSuccess) override;

  void OnSessionMessage(const nsAString& aSessionId,
                        dom::MediaKeyMessageType aMessageType,
                        nsTArray<uint8_t>& aMessage) override;

  void OnExpirationChange(const nsAString& aSessionId,
                          GMPTimestamp aExpiryTime) override;

  void OnSessionClosed(const nsAString& aSessionId) override;

  void OnSessionError(const nsAString& aSessionId,
                      nsresult aException,
                      uint32_t aSystemCode,
                      const nsAString& aMsg) override;

  void OnRejectPromise(uint32_t aPromiseId,
                       nsresult aDOMException,
                       const nsCString& aMsg) override;

  RefPtr<DecryptPromise> Decrypt(MediaRawData* aSample) override;

  void OnDecrypted(uint32_t aId,
                   DecryptStatus aResult,
                   const nsTArray<uint8_t>& aDecryptedData) override;

  void RejectPromise(PromiseId aId, nsresult aExceptionCode,
                     const nsCString& aReason) override;

  void ResolvePromise(PromiseId aId) override;

  const nsString& KeySystem() const override;

  CDMCaps& Capabilites() override;

  void OnKeyStatusesChange(const nsAString& aSessionId) override;

  void GetSessionIdsForKeyId(const nsTArray<uint8_t>& aKeyId,
                             nsTArray<nsCString>& aSessionIds) override;

#ifdef DEBUG
  bool IsOnOwnerThread() override;
#endif

  uint32_t GetDecryptorId() override;

private:
  friend class gmp_InitDoneCallback;
  friend class gmp_InitGetGMPDecryptorCallback;

  struct InitData {
    uint32_t mPromiseId;
    nsString mOrigin;
    nsString mTopLevelOrigin;
    nsString mGMPName;
    RefPtr<GMPCrashHelper> mCrashHelper;
  };

  // GMP thread only.
  void gmp_Init(UniquePtr<InitData>&& aData);
  void gmp_InitDone(GMPDecryptorProxy* aCDM, UniquePtr<InitData>&& aData);
  void gmp_InitGetGMPDecryptor(nsresult aResult,
                               const nsACString& aNodeId,
                               UniquePtr<InitData>&& aData);

  // GMP thread only.
  void gmp_Shutdown();

  // Main thread only.
  void OnCDMCreated(uint32_t aPromiseId);

  struct CreateSessionData {
    dom::MediaKeySessionType mSessionType;
    uint32_t mCreateSessionToken;
    PromiseId mPromiseId;
    nsCString mInitDataType;
    nsTArray<uint8_t> mInitData;
  };
  // GMP thread only.
  void gmp_CreateSession(UniquePtr<CreateSessionData>&& aData);

  struct SessionOpData {
    PromiseId mPromiseId;
    nsCString mSessionId;
  };
  // GMP thread only.
  void gmp_LoadSession(UniquePtr<SessionOpData>&& aData);

  struct SetServerCertificateData {
    PromiseId mPromiseId;
    nsTArray<uint8_t> mCert;
  };
  // GMP thread only.
  void gmp_SetServerCertificate(UniquePtr<SetServerCertificateData>&& aData);

  struct UpdateSessionData {
    PromiseId mPromiseId;
    nsCString mSessionId;
    nsTArray<uint8_t> mResponse;
  };
  // GMP thread only.
  void gmp_UpdateSession(UniquePtr<UpdateSessionData>&& aData);

  // GMP thread only.
  void gmp_CloseSession(UniquePtr<SessionOpData>&& aData);

  // GMP thread only.
  void gmp_RemoveSession(UniquePtr<SessionOpData>&& aData);

  // GMP thread only.
  void gmp_Decrypt(RefPtr<DecryptJob> aJob);

  // GMP thread only.
  void gmp_Decrypted(uint32_t aId,
                     DecryptStatus aResult,
                     const nsTArray<uint8_t>& aDecryptedData);

  class RejectPromiseTask : public Runnable {
  public:
    RejectPromiseTask(GMPCDMProxy* aProxy,
                      PromiseId aId,
                      nsresult aCode,
                      const nsCString& aReason)
      : Runnable("GMPCDMProxy::RejectPromiseTask")
      , mProxy(aProxy)
      , mId(aId)
      , mCode(aCode)
      , mReason(aReason)
    {
    }
    NS_IMETHOD Run() override {
      mProxy->RejectPromise(mId, mCode, mReason);
      return NS_OK;
    }
  private:
    RefPtr<GMPCDMProxy> mProxy;
    PromiseId mId;
    nsresult mCode;
    nsCString mReason;
  };

  ~GMPCDMProxy();

  GMPCrashHelper* mCrashHelper;

  GMPDecryptorProxy* mCDM;

  UniquePtr<GMPCDMCallbackProxy> mCallback;

  // Decryption jobs sent to CDM, awaiting result.
  // GMP thread only.
  nsTArray<RefPtr<DecryptJob>> mDecryptionJobs;

  // True if GMPCDMProxy::gmp_Shutdown was called.
  // GMP thread only.
  bool mShutdownCalled;

  uint32_t mDecryptorId;

  PromiseId mCreatePromiseId;
};


} // namespace mozilla

#endif // GMPCDMProxy_h_
