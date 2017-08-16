/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "GMPContentParent.h"
#include "GMPDecryptorParent.h"
#include "GMPParent.h"
#include "GMPServiceChild.h"
#include "GMPVideoDecoderParent.h"
#include "GMPVideoEncoderParent.h"
#include "ChromiumCDMParent.h"
#include "mozIGeckoMediaPluginService.h"
#include "mozilla/Logging.h"
#include "mozilla/Unused.h"
#include "base/task.h"

namespace mozilla {

#ifdef LOG
#undef LOG
#endif

extern LogModule* GetGMPLog();

#define LOGD(msg) MOZ_LOG(GetGMPLog(), mozilla::LogLevel::Debug, msg)
#define LOG(level, msg) MOZ_LOG(GetGMPLog(), (level), msg)

#ifdef __CLASS__
#undef __CLASS__
#endif
#define __CLASS__ "GMPContentParent"

namespace gmp {

GMPContentParent::GMPContentParent(GMPParent* aParent)
  : mParent(aParent)
{
  if (mParent) {
    SetDisplayName(mParent->GetDisplayName());
    SetPluginId(mParent->GetPluginId());
  }
}

GMPContentParent::~GMPContentParent()
{
}

class ReleaseGMPContentParent : public Runnable
{
public:
  explicit ReleaseGMPContentParent(GMPContentParent* aToRelease)
    : mToRelease(aToRelease)
  {
  }

  NS_IMETHOD Run() override
  {
    return NS_OK;
  }

private:
  RefPtr<GMPContentParent> mToRelease;
};

void
GMPContentParent::ActorDestroy(ActorDestroyReason aWhy)
{
  MOZ_ASSERT(mDecryptors.IsEmpty() && mVideoDecoders.IsEmpty() &&
             mVideoEncoders.IsEmpty() && mChromiumCDMs.IsEmpty());
  NS_DispatchToCurrentThread(new ReleaseGMPContentParent(this));
}

void
GMPContentParent::CheckThread()
{
  MOZ_ASSERT(mGMPThread == NS_GetCurrentThread());
}

void
GMPContentParent::ChromiumCDMDestroyed(ChromiumCDMParent* aDecoder)
{
  MOZ_ASSERT(GMPThread() == NS_GetCurrentThread());

  MOZ_ALWAYS_TRUE(mChromiumCDMs.RemoveElement(aDecoder));
  CloseIfUnused();
}

void
GMPContentParent::VideoDecoderDestroyed(GMPVideoDecoderParent* aDecoder)
{
  MOZ_ASSERT(GMPThread() == NS_GetCurrentThread());

  // If the constructor fails, we'll get called before it's added
  Unused << NS_WARN_IF(!mVideoDecoders.RemoveElement(aDecoder));
  CloseIfUnused();
}

void
GMPContentParent::VideoEncoderDestroyed(GMPVideoEncoderParent* aEncoder)
{
  MOZ_ASSERT(GMPThread() == NS_GetCurrentThread());

  // If the constructor fails, we'll get called before it's added
  Unused << NS_WARN_IF(!mVideoEncoders.RemoveElement(aEncoder));
  CloseIfUnused();
}

void
GMPContentParent::DecryptorDestroyed(GMPDecryptorParent* aSession)
{
  MOZ_ASSERT(GMPThread() == NS_GetCurrentThread());

  MOZ_ALWAYS_TRUE(mDecryptors.RemoveElement(aSession));
  CloseIfUnused();
}

void
GMPContentParent::AddCloseBlocker()
{
  MOZ_ASSERT(GMPThread() == NS_GetCurrentThread());
  ++mCloseBlockerCount;
}

void
GMPContentParent::RemoveCloseBlocker()
{
  MOZ_ASSERT(GMPThread() == NS_GetCurrentThread());
  --mCloseBlockerCount;
  CloseIfUnused();
}

void
GMPContentParent::CloseIfUnused()
{
  if (mDecryptors.IsEmpty() && mVideoDecoders.IsEmpty() &&
      mVideoEncoders.IsEmpty() && mChromiumCDMs.IsEmpty() &&
      mCloseBlockerCount == 0) {
    RefPtr<GMPContentParent> toClose;
    if (mParent) {
      toClose = mParent->ForgetGMPContentParent();
    } else {
      toClose = this;
      RefPtr<GeckoMediaPluginServiceChild> gmp(
        GeckoMediaPluginServiceChild::GetSingleton());
      gmp->RemoveGMPContentParent(toClose);
    }
    NS_DispatchToCurrentThread(NewRunnableMethod(toClose,
                                                 &GMPContentParent::Close));
  }
}

nsresult
GMPContentParent::GetGMPDecryptor(GMPDecryptorParent** aGMPDP)
{
  PGMPDecryptorParent* pdp = SendPGMPDecryptorConstructor();
  if (!pdp) {
    return NS_ERROR_FAILURE;
  }
  GMPDecryptorParent* dp = static_cast<GMPDecryptorParent*>(pdp);
  // This addref corresponds to the Proxy pointer the consumer is returned.
  // It's dropped by calling Close() on the interface.
  NS_ADDREF(dp);
  mDecryptors.AppendElement(dp);
  *aGMPDP = dp;

  return NS_OK;
}

nsCOMPtr<nsIThread>
GMPContentParent::GMPThread()
{
  if (!mGMPThread) {
    nsCOMPtr<mozIGeckoMediaPluginService> mps = do_GetService("@mozilla.org/gecko-media-plugin-service;1");
    MOZ_ASSERT(mps);
    if (!mps) {
      return nullptr;
    }
    // Not really safe if we just grab to the mGMPThread, as we don't know
    // what thread we're running on and other threads may be trying to
    // access this without locks!  However, debug only, and primary failure
    // mode outside of compiler-helped TSAN is a leak.  But better would be
    // to use swap() under a lock.
    mps->GetThread(getter_AddRefs(mGMPThread));
    MOZ_ASSERT(mGMPThread);
  }

  return mGMPThread;
}

already_AddRefed<ChromiumCDMParent>
GMPContentParent::GetChromiumCDM()
{
  PChromiumCDMParent* actor = SendPChromiumCDMConstructor();
  if (!actor) {
    return nullptr;
  }
  RefPtr<ChromiumCDMParent> parent = static_cast<ChromiumCDMParent*>(actor);

  // TODO: Remove parent from mChromiumCDMs in ChromiumCDMParent::Destroy().
  mChromiumCDMs.AppendElement(parent);

  return parent.forget();
}

nsresult
GMPContentParent::GetGMPVideoDecoder(GMPVideoDecoderParent** aGMPVD,
                                     uint32_t aDecryptorId)
{
  // returned with one anonymous AddRef that locks it until Destroy
  PGMPVideoDecoderParent* pvdp = SendPGMPVideoDecoderConstructor(aDecryptorId);
  if (!pvdp) {
    return NS_ERROR_FAILURE;
  }
  GMPVideoDecoderParent *vdp = static_cast<GMPVideoDecoderParent*>(pvdp);
  // This addref corresponds to the Proxy pointer the consumer is returned.
  // It's dropped by calling Close() on the interface.
  NS_ADDREF(vdp);
  *aGMPVD = vdp;
  mVideoDecoders.AppendElement(vdp);

  return NS_OK;
}

nsresult
GMPContentParent::GetGMPVideoEncoder(GMPVideoEncoderParent** aGMPVE)
{
  // returned with one anonymous AddRef that locks it until Destroy
  PGMPVideoEncoderParent* pvep = SendPGMPVideoEncoderConstructor();
  if (!pvep) {
    return NS_ERROR_FAILURE;
  }
  GMPVideoEncoderParent *vep = static_cast<GMPVideoEncoderParent*>(pvep);
  // This addref corresponds to the Proxy pointer the consumer is returned.
  // It's dropped by calling Close() on the interface.
  NS_ADDREF(vep);
  *aGMPVE = vep;
  mVideoEncoders.AppendElement(vep);

  return NS_OK;
}

PChromiumCDMParent*
GMPContentParent::AllocPChromiumCDMParent()
{
  ChromiumCDMParent* parent = new ChromiumCDMParent(this, GetPluginId());
  NS_ADDREF(parent);
  return parent;
}

PGMPVideoDecoderParent*
GMPContentParent::AllocPGMPVideoDecoderParent(const uint32_t& aDecryptorId)
{
  GMPVideoDecoderParent* vdp = new GMPVideoDecoderParent(this);
  NS_ADDREF(vdp);
  return vdp;
}

bool
GMPContentParent::DeallocPChromiumCDMParent(PChromiumCDMParent* aActor)
{
  ChromiumCDMParent* parent = static_cast<ChromiumCDMParent*>(aActor);
  NS_RELEASE(parent);
  return true;
}

bool
GMPContentParent::DeallocPGMPVideoDecoderParent(PGMPVideoDecoderParent* aActor)
{
  GMPVideoDecoderParent* vdp = static_cast<GMPVideoDecoderParent*>(aActor);
  NS_RELEASE(vdp);
  return true;
}

PGMPVideoEncoderParent*
GMPContentParent::AllocPGMPVideoEncoderParent()
{
  GMPVideoEncoderParent* vep = new GMPVideoEncoderParent(this);
  NS_ADDREF(vep);
  return vep;
}

bool
GMPContentParent::DeallocPGMPVideoEncoderParent(PGMPVideoEncoderParent* aActor)
{
  GMPVideoEncoderParent* vep = static_cast<GMPVideoEncoderParent*>(aActor);
  NS_RELEASE(vep);
  return true;
}

PGMPDecryptorParent*
GMPContentParent::AllocPGMPDecryptorParent()
{
  GMPDecryptorParent* ksp = new GMPDecryptorParent(this);
  NS_ADDREF(ksp);
  return ksp;
}

bool
GMPContentParent::DeallocPGMPDecryptorParent(PGMPDecryptorParent* aActor)
{
  GMPDecryptorParent* ksp = static_cast<GMPDecryptorParent*>(aActor);
  NS_RELEASE(ksp);
  return true;
}

} // namespace gmp
} // namespace mozilla
