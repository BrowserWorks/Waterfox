/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/cache/CacheOpParent.h"

#include "mozilla/Unused.h"
#include "mozilla/dom/cache/AutoUtils.h"
#include "mozilla/dom/cache/ManagerId.h"
#include "mozilla/dom/cache/ReadStream.h"
#include "mozilla/dom/cache/SavedTypes.h"
#include "mozilla/ipc/FileDescriptorSetParent.h"
#include "mozilla/ipc/InputStreamUtils.h"
#include "mozilla/ipc/IPCStreamUtils.h"

namespace mozilla {
namespace dom {
namespace cache {

using mozilla::ipc::FileDescriptorSetParent;
using mozilla::ipc::PBackgroundParent;

CacheOpParent::CacheOpParent(PBackgroundParent* aIpcManager, CacheId aCacheId,
                             const CacheOpArgs& aOpArgs)
    : mIpcManager(aIpcManager),
      mCacheId(aCacheId),
      mNamespace(INVALID_NAMESPACE),
      mOpArgs(aOpArgs) {
  MOZ_DIAGNOSTIC_ASSERT(mIpcManager);
}

CacheOpParent::CacheOpParent(PBackgroundParent* aIpcManager,
                             Namespace aNamespace, const CacheOpArgs& aOpArgs)
    : mIpcManager(aIpcManager),
      mCacheId(INVALID_CACHE_ID),
      mNamespace(aNamespace),
      mOpArgs(aOpArgs) {
  MOZ_DIAGNOSTIC_ASSERT(mIpcManager);
}

CacheOpParent::~CacheOpParent() { NS_ASSERT_OWNINGTHREAD(CacheOpParent); }

void CacheOpParent::Execute(const SafeRefPtr<ManagerId>& aManagerId) {
  NS_ASSERT_OWNINGTHREAD(CacheOpParent);
  MOZ_DIAGNOSTIC_ASSERT(!mManager);
  MOZ_DIAGNOSTIC_ASSERT(!mVerifier);

  auto managerOrErr = cache::Manager::AcquireCreateIfNonExistent(aManagerId);
  if (NS_WARN_IF(managerOrErr.isErr())) {
    ErrorResult result(managerOrErr.unwrapErr());
    Unused << Send__delete__(this, std::move(result), void_t());
    return;
  }

  Execute(managerOrErr.unwrap());
}

void CacheOpParent::Execute(SafeRefPtr<cache::Manager> aManager) {
  NS_ASSERT_OWNINGTHREAD(CacheOpParent);
  MOZ_DIAGNOSTIC_ASSERT(!mManager);
  MOZ_DIAGNOSTIC_ASSERT(!mVerifier);

  mManager = std::move(aManager);

  // Handle put op
  if (mOpArgs.type() == CacheOpArgs::TCachePutAllArgs) {
    MOZ_DIAGNOSTIC_ASSERT(mCacheId != INVALID_CACHE_ID);

    const CachePutAllArgs& args = mOpArgs.get_CachePutAllArgs();
    const nsTArray<CacheRequestResponse>& list = args.requestResponseList();

    AutoTArray<nsCOMPtr<nsIInputStream>, 256> requestStreamList;
    AutoTArray<nsCOMPtr<nsIInputStream>, 256> responseStreamList;

    for (uint32_t i = 0; i < list.Length(); ++i) {
      requestStreamList.AppendElement(
          DeserializeCacheStream(list[i].request().body()));
      responseStreamList.AppendElement(
          DeserializeCacheStream(list[i].response().body()));
    }

    mManager->ExecutePutAll(this, mCacheId, args.requestResponseList(),
                            requestStreamList, responseStreamList);
    return;
  }

  // Handle all other cache ops
  if (mCacheId != INVALID_CACHE_ID) {
    MOZ_DIAGNOSTIC_ASSERT(mNamespace == INVALID_NAMESPACE);
    mManager->ExecuteCacheOp(this, mCacheId, mOpArgs);
    return;
  }

  // Handle all storage ops
  MOZ_DIAGNOSTIC_ASSERT(mNamespace != INVALID_NAMESPACE);
  mManager->ExecuteStorageOp(this, mNamespace, mOpArgs);
}

void CacheOpParent::WaitForVerification(PrincipalVerifier* aVerifier) {
  NS_ASSERT_OWNINGTHREAD(CacheOpParent);
  MOZ_DIAGNOSTIC_ASSERT(!mManager);
  MOZ_DIAGNOSTIC_ASSERT(!mVerifier);

  mVerifier = aVerifier;
  mVerifier->AddListener(this);
}

void CacheOpParent::ActorDestroy(ActorDestroyReason aReason) {
  NS_ASSERT_OWNINGTHREAD(CacheOpParent);

  if (mVerifier) {
    mVerifier->RemoveListener(this);
    mVerifier = nullptr;
  }

  if (mManager) {
    mManager->RemoveListener(this);
    mManager = nullptr;
  }

  mIpcManager = nullptr;
}

void CacheOpParent::OnPrincipalVerified(
    nsresult aRv, const SafeRefPtr<ManagerId>& aManagerId) {
  NS_ASSERT_OWNINGTHREAD(CacheOpParent);

  mVerifier->RemoveListener(this);
  mVerifier = nullptr;

  if (NS_WARN_IF(NS_FAILED(aRv))) {
    ErrorResult result(aRv);
    Unused << Send__delete__(this, std::move(result), void_t());
    return;
  }

  Execute(aManagerId);
}

void CacheOpParent::OnOpComplete(ErrorResult&& aRv,
                                 const CacheOpResult& aResult,
                                 CacheId aOpenedCacheId,
                                 const Maybe<StreamInfo>& aStreamInfo) {
  NS_ASSERT_OWNINGTHREAD(CacheOpParent);
  MOZ_DIAGNOSTIC_ASSERT(mIpcManager);
  MOZ_DIAGNOSTIC_ASSERT(mManager);

  // Never send an op-specific result if we have an error.  Instead, send
  // void_t() to ensure that we don't leak actors on the child side.
  if (NS_WARN_IF(aRv.Failed())) {
    Unused << Send__delete__(this, std::move(aRv), void_t());
    return;
  }

  if (aStreamInfo.isSome()) {
    ProcessCrossOriginResourcePolicyHeader(aRv,
                                           aStreamInfo->mSavedResponseList);
    if (NS_WARN_IF(aRv.Failed())) {
      Unused << Send__delete__(this, std::move(aRv), void_t());
      return;
    }
  }

  uint32_t entryCount =
      std::max(1lu, aStreamInfo ? static_cast<unsigned long>(std::max(
                                      aStreamInfo->mSavedResponseList.Length(),
                                      aStreamInfo->mSavedRequestList.Length()))
                                : 0lu);

  // The result must contain the appropriate type at this point.  It may
  // or may not contain the additional result data yet.  For types that
  // do not need special processing, it should already be set.  If the
  // result requires actor-specific operations, then we do that below.
  // If the type and data types don't match, then we will trigger an
  // assertion in AutoParentOpResult::Add().
  AutoParentOpResult result(mIpcManager, aResult, entryCount);

  if (aOpenedCacheId != INVALID_CACHE_ID) {
    result.Add(aOpenedCacheId, mManager.clonePtr());
  }

  if (aStreamInfo) {
    const auto& streamInfo = *aStreamInfo;

    for (const auto& savedResponse : streamInfo.mSavedResponseList) {
      result.Add(savedResponse, streamInfo.mStreamList);
    }

    for (const auto& savedRequest : streamInfo.mSavedRequestList) {
      result.Add(savedRequest, streamInfo.mStreamList);
    }
  }

  Unused << Send__delete__(this, std::move(aRv), result.SendAsOpResult());
}

already_AddRefed<nsIInputStream> CacheOpParent::DeserializeCacheStream(
    const Maybe<CacheReadStream>& aMaybeStream) {
  if (aMaybeStream.isNothing()) {
    return nullptr;
  }

  nsCOMPtr<nsIInputStream> stream;
  const CacheReadStream& readStream = aMaybeStream.ref();

  // Option 1: One of our own ReadStreams was passed back to us with a stream
  //           control actor.
  stream = ReadStream::Create(readStream);
  if (stream) {
    return stream.forget();
  }

  // Option 2: A stream was serialized using normal methods or passed
  //           as a PChildToParentStream actor.  Use the standard method for
  //           extracting the resulting stream.
  return DeserializeIPCStream(readStream.stream());
}

void CacheOpParent::ProcessCrossOriginResourcePolicyHeader(
    ErrorResult& aRv, const nsTArray<SavedResponse>& aResponses) {
  // Only checking for match/matchAll.
  RequestMode mode = RequestMode::No_cors;
  nsILoadInfo::CrossOriginEmbedderPolicy loadingCOEP =
      nsILoadInfo::EMBEDDER_POLICY_NULL;
  Maybe<PrincipalInfo> principalInfo;
  switch (mOpArgs.type()) {
    case CacheOpArgs::TCacheMatchArgs: {
      mode = mOpArgs.get_CacheMatchArgs().request().mode();
      loadingCOEP =
          mOpArgs.get_CacheMatchArgs().request().loadingEmbedderPolicy();
      principalInfo = mOpArgs.get_CacheMatchArgs().request().principalInfo();
      break;
    }
    case CacheOpArgs::TCacheMatchAllArgs: {
      if (mOpArgs.get_CacheMatchAllArgs().maybeRequest().isSome()) {
        mode = mOpArgs.get_CacheMatchAllArgs().maybeRequest().ref().mode();
        loadingCOEP = mOpArgs.get_CacheMatchAllArgs()
                          .maybeRequest()
                          .ref()
                          .loadingEmbedderPolicy();
        principalInfo = mOpArgs.get_CacheMatchAllArgs()
                            .maybeRequest()
                            .ref()
                            .principalInfo();
      }
      break;
    }
    default: {
      return;
    }
  }

  // skip checking for CORS mode
  if (mode == RequestMode::Cors) {
    return;
  }

  // skip checking if the request has no principal for same-origin/same-site
  // checking.
  if (principalInfo.isNothing() ||
      principalInfo.ref().type() != PrincipalInfo::TContentPrincipalInfo) {
    return;
  }
  const ContentPrincipalInfo& contentPrincipalInfo =
      principalInfo.ref().get_ContentPrincipalInfo();

  nsAutoCString corp;
  for (auto it = aResponses.cbegin(); it != aResponses.cend(); ++it) {
    corp.Assign(EmptyCString());
    for (auto headerIt = it->mValue.headers().cbegin();
         headerIt != it->mValue.headers().cend(); ++headerIt) {
      if (headerIt->name().Equals(
              NS_LITERAL_CSTRING("Cross-Origin-Resource-Policy"))) {
        corp = headerIt->value();
        break;
      }
    }

    // According to https://github.com/w3c/ServiceWorker/issues/1490, the cache
    // response is expected with CORP header, otherwise, throw the type error.
    // Note that this is different with the CORP checking for fetch metioned in
    // https://wicg.github.io/cross-origin-embedder-policy/#corp-check.
    // For fetch, if the response has no CORP header, "same-origin" checking
    // will be performed.
    if (corp.IsEmpty() &&
        loadingCOEP == nsILoadInfo::EMBEDDER_POLICY_REQUIRE_CORP) {
      aRv.ThrowTypeError("Response is expected with CORP header.");
      return;
    }

    // Skip the case if the response has no principal for same-origin/same-site
    // checking.
    if (it->mValue.principalInfo().isNothing() ||
        it->mValue.principalInfo().ref().type() !=
            PrincipalInfo::TContentPrincipalInfo) {
      continue;
    }

    const ContentPrincipalInfo& responseContentPrincipalInfo =
        it->mValue.principalInfo().ref().get_ContentPrincipalInfo();

    if (corp.EqualsLiteral("same-origin")) {
      if (responseContentPrincipalInfo == contentPrincipalInfo) {
        aRv.ThrowTypeError("Response is expected from same origin.");
        return;
      }
    } else if (corp.EqualsLiteral("same-site")) {
      if (!responseContentPrincipalInfo.baseDomain().Equals(
              contentPrincipalInfo.baseDomain())) {
        aRv.ThrowTypeError("Response is expected from same site.");
        return;
      }
    }
  }
}

}  // namespace cache
}  // namespace dom
}  // namespace mozilla
