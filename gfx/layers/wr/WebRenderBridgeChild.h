/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_layers_WebRenderBridgeChild_h
#define mozilla_layers_WebRenderBridgeChild_h

#include "mozilla/layers/CompositableForwarder.h"
#include "mozilla/layers/PWebRenderBridgeChild.h"
#include "nsHashKeys.h"

namespace mozilla {

namespace widget {
class CompositorWidget;
}

namespace wr {
class DisplayListBuilder;
class ResourceUpdateQueue;
class IpcResourceUpdateQueue;
}  // namespace wr

namespace layers {

class CompositableClient;
class CompositorBridgeChild;
class StackingContextHelper;
class TextureForwarder;
class WebRenderLayerManager;

class WebRenderBridgeChild final : public PWebRenderBridgeChild,
                                   public CompositableForwarder {
  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(WebRenderBridgeChild, override)

  friend class PWebRenderBridgeChild;

 public:
  explicit WebRenderBridgeChild(const wr::PipelineId& aPipelineId);

  void AddWebRenderParentCommand(const WebRenderParentCommand& aCmd);
  /// Similar to AddWebRenderParentCommand, with the exception that ops are not
  /// picked up by off-screen transactions. Typically useful for operations that
  /// remove resources and should not be applied before we have un-referenced
  /// the resources from the main display list.
  void AddWebRenderParentDestroyCommand(const WebRenderParentCommand& aCmd);
  bool HasWebRenderParentCommands() {
    return !mParentCommands.IsEmpty() || !mParentDestroyCommands.IsEmpty();
  }

  void UpdateResources(wr::IpcResourceUpdateQueue& aResources);
  void BeginTransaction();
  bool EndTransaction(DisplayListData&& aDisplayListData,
                      TransactionId aTransactionId, bool aContainsSVGroup,
                      const mozilla::VsyncId& aVsyncId, bool aRenderOffscreen,
                      const mozilla::TimeStamp& aVsyncStartTime,
                      const mozilla::TimeStamp& aRefreshStartTime,
                      const mozilla::TimeStamp& aTxnStartTime,
                      const nsCString& aTxtURL);
  void EndEmptyTransaction(const FocusTarget& aFocusTarget,
                           Maybe<TransactionData>&& aTransactionData,
                           TransactionId aTransactionId,
                           const mozilla::VsyncId& aVsyncId,
                           const mozilla::TimeStamp& aVsyncStartTime,
                           const mozilla::TimeStamp& aRefreshStartTime,
                           const mozilla::TimeStamp& aTxnStartTime,
                           const nsCString& aTxtURL);
  void ProcessWebRenderParentCommands();

  CompositorBridgeChild* GetCompositorBridgeChild();

  wr::PipelineId GetPipeline() { return mPipelineId; }

  // KnowsCompositor
  RefPtr<TextureForwarder> GetTextureForwarder() override;
  LayersIPCActor* GetLayersIPCActor() override;
  void SyncWithCompositor(
      const Maybe<uint64_t>& aWindowID = Nothing()) override;

  void AddPipelineIdForCompositable(const wr::PipelineId& aPipelineId,
                                    const CompositableHandle& aHandle,
                                    CompositableHandleOwner aOwner);
  void RemovePipelineIdForCompositable(const wr::PipelineId& aPipelineId);

  /// Release TextureClient that is bounded to ImageKey.
  /// It is used for recycling TextureClient.
  void ReleaseTextureOfImage(const wr::ImageKey& aKey);

  /**
   * Clean this up, finishing with SendShutDown() which will cause __delete__
   * to be sent from the parent side.
   */
  void Destroy(bool aIsSync);
  bool IPCOpen() const { return CanSend() && !mDestroyed; }
  bool GetSentDisplayList() const { return mSentDisplayList; }
  bool IsDestroyed() const { return mDestroyed; }

  uint32_t GetNextResourceId() { return ++mResourceId; }
  wr::IdNamespace GetNamespace() { return mIdNamespace; }
  void SetNamespace(wr::IdNamespace aIdNamespace) {
    mIdNamespace = aIdNamespace;
  }

  bool MatchesNamespace(const wr::ImageKey& aImageKey) const {
    return aImageKey.mNamespace == mIdNamespace;
  }

  bool MatchesNamespace(const wr::BlobImageKey& aBlobKey) const {
    return MatchesNamespace(aBlobKey._0);
  }

  wr::FontKey GetNextFontKey() {
    return wr::FontKey{GetNamespace(), GetNextResourceId()};
  }

  wr::FontInstanceKey GetNextFontInstanceKey() {
    return wr::FontInstanceKey{GetNamespace(), GetNextResourceId()};
  }

  wr::WrImageKey GetNextImageKey() {
    return wr::WrImageKey{GetNamespace(), GetNextResourceId()};
  }

  void PushGlyphs(wr::DisplayListBuilder& aBuilder,
                  wr::IpcResourceUpdateQueue& aResources,
                  Range<const wr::GlyphInstance> aGlyphs,
                  gfx::ScaledFont* aFont, const wr::ColorF& aColor,
                  const StackingContextHelper& aSc,
                  const wr::LayoutRect& aBounds, const wr::LayoutRect& aClip,
                  bool aBackfaceVisible,
                  const wr::GlyphOptions* aGlyphOptions = nullptr);

  Maybe<wr::FontInstanceKey> GetFontKeyForScaledFont(
      gfx::ScaledFont* aScaledFont, wr::IpcResourceUpdateQueue& aResources);
  Maybe<wr::FontKey> GetFontKeyForUnscaledFont(
      gfx::UnscaledFont* aUnscaledFont, wr::IpcResourceUpdateQueue& aResources);
  void RemoveExpiredFontKeys(wr::IpcResourceUpdateQueue& aResources);

  void BeginClearCachedResources();
  void EndClearCachedResources();

  void SetWebRenderLayerManager(WebRenderLayerManager* aManager);

  mozilla::ipc::IShmemAllocator* GetShmemAllocator();

  bool IsThreadSafe() const override { return false; }

  RefPtr<KnowsCompositor> GetForMedia() override;

  /// Alloc a specific type of shmem that is intended for use in
  /// IpcResourceUpdateQueue only, and cache at most one of them,
  /// when called multiple times.
  ///
  /// Do not use this for anything else.
  bool AllocResourceShmem(size_t aSize, RefCountedShmem& aShm);
  /// Dealloc shared memory that was allocated with AllocResourceShmem.
  ///
  /// Do not use this for anything else.
  void DeallocResourceShmem(RefCountedShmem& aShm);

  void Capture();
  void StartCaptureSequence(uint32_t aFlags);
  void StopCaptureSequence();

  bool SendEnsureConnected(TextureFactoryIdentifier* textureFactoryIdentifier,
                           MaybeIdNamespace* maybeIdNamespace,
                           nsCString* error);

 private:
  friend class CompositorBridgeChild;

  ~WebRenderBridgeChild();

  void MergeWebRenderParentCommands();

  wr::ExternalImageId GetNextExternalImageId();

  // CompositableForwarder
  void Connect(CompositableClient* aCompositable,
               ImageContainer* aImageContainer = nullptr) override;
  void ReleaseCompositable(const CompositableHandle& aHandle) override;
  bool DestroyInTransaction(PTextureChild* aTexture) override;
  bool DestroyInTransaction(const CompositableHandle& aHandle);
  void RemoveTextureFromCompositable(CompositableClient* aCompositable,
                                     TextureClient* aTexture) override;
  void UseTextures(CompositableClient* aCompositable,
                   const nsTArray<TimedTextureClient>& aTextures) override;
  void UseRemoteTexture(CompositableClient* aCompositable,
                        const RemoteTextureId aTextureId,
                        const RemoteTextureOwnerId aOwnerId,
                        const gfx::IntSize aSize, const TextureFlags aFlags,
                        const RefPtr<FwdTransactionTracker>& aTracker) override;
  FwdTransactionCounter& GetFwdTransactionCounter() override;

  bool InForwarderThread() override;

  void ActorDestroy(ActorDestroyReason why) override;

  void DoDestroy();

  mozilla::ipc::IPCResult RecvWrUpdated(
      const wr::IdNamespace& aNewIdNamespace,
      const TextureFactoryIdentifier& textureFactoryIdentifier);
  mozilla::ipc::IPCResult RecvWrReleasedImages(
      nsTArray<wr::ExternalImageKeyPair>&& aPairs);

  bool AddOpDestroy(const OpDestroy& aOp);

  nsTArray<OpDestroy> mDestroyedActors;
  nsTArray<WebRenderParentCommand> mParentCommands;
  nsTArray<WebRenderParentCommand> mParentDestroyCommands;
  nsTHashMap<nsUint64HashKey, CompositableClient*> mCompositables;
  bool mIsInTransaction;
  bool mIsInClearCachedResources;
  wr::IdNamespace mIdNamespace;
  uint32_t mResourceId;
  wr::PipelineId mPipelineId;
  WebRenderLayerManager* mManager;

  bool mDestroyed;
  // True iff we have called SendSetDisplayList and haven't called
  // SendClearCachedResources since that call.
  bool mSentDisplayList;

  uint32_t mFontKeysDeleted;
  nsTHashMap<ThreadSafeWeakPtr<gfx::UnscaledFont>, wr::FontKey> mFontKeys;

  uint32_t mFontInstanceKeysDeleted;
  nsTHashMap<ThreadSafeWeakPtr<gfx::ScaledFont>, wr::FontInstanceKey>
      mFontInstanceKeys;

  RefCountedShmem mResourceShm;
};

}  // namespace layers
}  // namespace mozilla

#endif  // mozilla_layers_WebRenderBridgeChild_h
