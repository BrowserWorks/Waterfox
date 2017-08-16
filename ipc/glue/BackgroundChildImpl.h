/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_ipc_backgroundchildimpl_h__
#define mozilla_ipc_backgroundchildimpl_h__

#include "mozilla/Attributes.h"
#include "mozilla/ipc/PBackgroundChild.h"
#include "nsAutoPtr.h"

namespace mozilla {
namespace dom {

class IDBFileHandle;

namespace indexedDB {

class ThreadLocal;

} // namespace indexedDB
} // namespace dom

namespace ipc {

// Instances of this class should never be created directly. This class is meant
// to be inherited in BackgroundImpl.
class BackgroundChildImpl : public PBackgroundChild
{
public:
  class ThreadLocal;

  // Get the ThreadLocal for the current thread if
  // BackgroundChild::GetOrCreateForCurrentThread() has been called and true was
  // returned (e.g. a valid PBackgroundChild actor has been created or is in the
  // process of being created). Otherwise this function returns null.
  // This functions is implemented in BackgroundImpl.cpp.
  static ThreadLocal*
  GetThreadLocalForCurrentThread();

protected:
  BackgroundChildImpl();
  virtual ~BackgroundChildImpl();

  virtual void
  ProcessingError(Result aCode, const char* aReason) override;

  virtual void
  ActorDestroy(ActorDestroyReason aWhy) override;

  virtual PBackgroundTestChild*
  AllocPBackgroundTestChild(const nsCString& aTestArg) override;

  virtual bool
  DeallocPBackgroundTestChild(PBackgroundTestChild* aActor) override;

  virtual PBackgroundIDBFactoryChild*
  AllocPBackgroundIDBFactoryChild(const LoggingInfo& aLoggingInfo) override;

  virtual bool
  DeallocPBackgroundIDBFactoryChild(PBackgroundIDBFactoryChild* aActor)
                                    override;

  virtual PBackgroundIndexedDBUtilsChild*
  AllocPBackgroundIndexedDBUtilsChild() override;

  virtual bool
  DeallocPBackgroundIndexedDBUtilsChild(PBackgroundIndexedDBUtilsChild* aActor)
                                        override;

  virtual PPendingIPCBlobChild*
  AllocPPendingIPCBlobChild(const IPCBlob& aBlob) override;

  virtual bool
  DeallocPPendingIPCBlobChild(PPendingIPCBlobChild* aActor) override;

  virtual PIPCBlobInputStreamChild*
  AllocPIPCBlobInputStreamChild(const nsID& aID,
                                const uint64_t& aSize) override;

  virtual bool
  DeallocPIPCBlobInputStreamChild(PIPCBlobInputStreamChild* aActor) override;

  virtual PFileDescriptorSetChild*
  AllocPFileDescriptorSetChild(const FileDescriptor& aFileDescriptor)
                               override;

  virtual bool
  DeallocPFileDescriptorSetChild(PFileDescriptorSetChild* aActor) override;

  virtual PCamerasChild*
  AllocPCamerasChild() override;

  virtual bool
  DeallocPCamerasChild(PCamerasChild* aActor) override;

  virtual PVsyncChild*
  AllocPVsyncChild() override;

  virtual bool
  DeallocPVsyncChild(PVsyncChild* aActor) override;

  virtual PUDPSocketChild*
  AllocPUDPSocketChild(const OptionalPrincipalInfo& aPrincipalInfo,
                       const nsCString& aFilter) override;
  virtual bool
  DeallocPUDPSocketChild(PUDPSocketChild* aActor) override;

  virtual PBroadcastChannelChild*
  AllocPBroadcastChannelChild(const PrincipalInfo& aPrincipalInfo,
                              const nsCString& aOrigin,
                              const nsString& aChannel) override;

  virtual bool
  DeallocPBroadcastChannelChild(PBroadcastChannelChild* aActor) override;

  virtual PServiceWorkerManagerChild*
  AllocPServiceWorkerManagerChild() override;

  virtual bool
  DeallocPServiceWorkerManagerChild(PServiceWorkerManagerChild* aActor) override;

  virtual dom::cache::PCacheStorageChild*
  AllocPCacheStorageChild(const dom::cache::Namespace& aNamespace,
                          const PrincipalInfo& aPrincipalInfo) override;

  virtual bool
  DeallocPCacheStorageChild(dom::cache::PCacheStorageChild* aActor) override;

  virtual dom::cache::PCacheChild* AllocPCacheChild() override;

  virtual bool
  DeallocPCacheChild(dom::cache::PCacheChild* aActor) override;

  virtual dom::cache::PCacheStreamControlChild*
  AllocPCacheStreamControlChild() override;

  virtual bool
  DeallocPCacheStreamControlChild(dom::cache::PCacheStreamControlChild* aActor) override;

  virtual PMessagePortChild*
  AllocPMessagePortChild(const nsID& aUUID, const nsID& aDestinationUUID,
                         const uint32_t& aSequenceID) override;

  virtual bool
  DeallocPMessagePortChild(PMessagePortChild* aActor) override;

  virtual PChildToParentStreamChild*
  AllocPChildToParentStreamChild() override;

  virtual bool
  DeallocPChildToParentStreamChild(PChildToParentStreamChild* aActor) override;

  virtual PParentToChildStreamChild*
  AllocPParentToChildStreamChild() override;

  virtual bool
  DeallocPParentToChildStreamChild(PParentToChildStreamChild* aActor) override;

  virtual PAsmJSCacheEntryChild*
  AllocPAsmJSCacheEntryChild(const dom::asmjscache::OpenMode& aOpenMode,
                             const dom::asmjscache::WriteParams& aWriteParams,
                             const PrincipalInfo& aPrincipalInfo) override;

  virtual bool
  DeallocPAsmJSCacheEntryChild(PAsmJSCacheEntryChild* aActor) override;

  virtual PQuotaChild*
  AllocPQuotaChild() override;

  virtual bool
  DeallocPQuotaChild(PQuotaChild* aActor) override;

  virtual PFileSystemRequestChild*
  AllocPFileSystemRequestChild(const FileSystemParams&) override;

  virtual bool
  DeallocPFileSystemRequestChild(PFileSystemRequestChild*) override;

  // Gamepad API Background IPC
  virtual PGamepadEventChannelChild*
  AllocPGamepadEventChannelChild() override;

  virtual bool
  DeallocPGamepadEventChannelChild(PGamepadEventChannelChild* aActor) override;

  virtual PGamepadTestChannelChild*
  AllocPGamepadTestChannelChild() override;

  virtual bool
  DeallocPGamepadTestChannelChild(PGamepadTestChannelChild* aActor) override;

#ifdef EARLY_BETA_OR_EARLIER
  virtual void
  OnChannelReceivedMessage(const Message& aMsg) override;
#endif

  virtual PWebAuthnTransactionChild*
  AllocPWebAuthnTransactionChild() override;

  virtual bool
  DeallocPWebAuthnTransactionChild(PWebAuthnTransactionChild* aActor) override;

  virtual PHttpBackgroundChannelChild*
  AllocPHttpBackgroundChannelChild(const uint64_t& aChannelId) override;

  virtual bool
  DeallocPHttpBackgroundChannelChild(PHttpBackgroundChannelChild* aActor) override;
};

class BackgroundChildImpl::ThreadLocal final
{
  friend class nsAutoPtr<ThreadLocal>;

public:
  nsAutoPtr<mozilla::dom::indexedDB::ThreadLocal> mIndexedDBThreadLocal;
  mozilla::dom::IDBFileHandle* mCurrentFileHandle;

public:
  ThreadLocal();

private:
  // Only destroyed by nsAutoPtr<ThreadLocal>.
  ~ThreadLocal();
};

} // namespace ipc
} // namespace mozilla

#endif // mozilla_ipc_backgroundchildimpl_h__
