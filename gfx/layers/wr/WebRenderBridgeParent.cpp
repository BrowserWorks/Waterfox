/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set sw=4 ts=8 et tw=80 : */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/layers/WebRenderBridgeParent.h"

#include "apz/src/AsyncPanZoomController.h"
#include "CompositableHost.h"
#include "gfxEnv.h"
#include "gfxPrefs.h"
#include "gfxEnv.h"
#include "GeckoProfiler.h"
#include "GLContext.h"
#include "GLContextProvider.h"
#include "mozilla/Range.h"
#include "mozilla/layers/AnimationHelper.h"
#include "mozilla/layers/APZCTreeManager.h"
#include "mozilla/layers/Compositor.h"
#include "mozilla/layers/CompositorBridgeParent.h"
#include "mozilla/layers/CompositorThread.h"
#include "mozilla/layers/CompositorVsyncScheduler.h"
#include "mozilla/layers/ImageBridgeParent.h"
#include "mozilla/layers/ImageDataSerializer.h"
#include "mozilla/layers/TextureHost.h"
#include "mozilla/layers/AsyncImagePipelineManager.h"
#include "mozilla/layers/WebRenderImageHost.h"
#include "mozilla/layers/WebRenderTextureHost.h"
#include "mozilla/TimeStamp.h"
#include "mozilla/Unused.h"
#include "mozilla/webrender/RenderThread.h"
#include "mozilla/widget/CompositorWidget.h"

bool is_in_main_thread()
{
  return NS_IsMainThread();
}

bool is_in_compositor_thread()
{
  return mozilla::layers::CompositorThreadHolder::IsInCompositorThread();
}

bool is_in_render_thread()
{
  return mozilla::wr::RenderThread::IsInRenderThread();
}

bool is_glcontext_egl(void* glcontext_ptr)
{
  MOZ_ASSERT(glcontext_ptr);

  mozilla::gl::GLContext* glcontext = reinterpret_cast<mozilla::gl::GLContext*>(glcontext_ptr);
  if (!glcontext) {
    return false;
  }
  return glcontext->GetContextType() == mozilla::gl::GLContextType::EGL;
}

bool gfx_use_wrench()
{
  return gfxEnv::EnableWebRenderRecording();
}

void gfx_critical_note(const char* msg)
{
  gfxCriticalNote << msg;
}

void* get_proc_address_from_glcontext(void* glcontext_ptr, const char* procname)
{
  MOZ_ASSERT(glcontext_ptr);

  mozilla::gl::GLContext* glcontext = reinterpret_cast<mozilla::gl::GLContext*>(glcontext_ptr);
  if (!glcontext) {
    return nullptr;
  }
  PRFuncPtr p = glcontext->LookupSymbol(procname);
  return reinterpret_cast<void*>(p);
}

namespace mozilla {
namespace layers {

using namespace mozilla::gfx;

class MOZ_STACK_CLASS AutoWebRenderBridgeParentAsyncMessageSender
{
public:
  explicit AutoWebRenderBridgeParentAsyncMessageSender(WebRenderBridgeParent* aWebRenderBridgeParent,
                                                       InfallibleTArray<OpDestroy>* aDestroyActors = nullptr)
    : mWebRenderBridgeParent(aWebRenderBridgeParent)
    , mActorsToDestroy(aDestroyActors)
  {
    mWebRenderBridgeParent->SetAboutToSendAsyncMessages();
  }

  ~AutoWebRenderBridgeParentAsyncMessageSender()
  {
    mWebRenderBridgeParent->SendPendingAsyncMessages();
    if (mActorsToDestroy) {
      // Destroy the actors after sending the async messages because the latter may contain
      // references to some actors.
      for (const auto& op : *mActorsToDestroy) {
        mWebRenderBridgeParent->DestroyActor(op);
      }
    }
  }
private:
  WebRenderBridgeParent* mWebRenderBridgeParent;
  InfallibleTArray<OpDestroy>* mActorsToDestroy;
};

/* static */ uint32_t WebRenderBridgeParent::sIdNameSpace = 0;

WebRenderBridgeParent::WebRenderBridgeParent(CompositorBridgeParentBase* aCompositorBridge,
                                             const wr::PipelineId& aPipelineId,
                                             widget::CompositorWidget* aWidget,
                                             CompositorVsyncScheduler* aScheduler,
                                             RefPtr<wr::WebRenderAPI>&& aApi,
                                             RefPtr<AsyncImagePipelineManager>&& aImageMgr,
                                             RefPtr<CompositorAnimationStorage>&& aAnimStorage)
  : mCompositorBridge(aCompositorBridge)
  , mPipelineId(aPipelineId)
  , mWidget(aWidget)
  , mApi(aApi)
  , mAsyncImageManager(aImageMgr)
  , mCompositorScheduler(aScheduler)
  , mAnimStorage(aAnimStorage)
  , mChildLayerObserverEpoch(0)
  , mParentLayerObserverEpoch(0)
  , mWrEpoch(0)
  , mIdNamespace(AllocIdNameSpace())
  , mPaused(false)
  , mDestroyed(false)
  , mForceRendering(false)
{
  MOZ_ASSERT(mAsyncImageManager);
  MOZ_ASSERT(mAnimStorage);
  mAsyncImageManager->AddPipeline(mPipelineId);
  if (mWidget) {
    MOZ_ASSERT(!mCompositorScheduler);
    mCompositorScheduler = new CompositorVsyncScheduler(this, mWidget);
  }
}

WebRenderBridgeParent::WebRenderBridgeParent()
  : mCompositorBridge(nullptr)
  , mChildLayerObserverEpoch(0)
  , mParentLayerObserverEpoch(0)
  , mWrEpoch(0)
  , mIdNamespace(AllocIdNameSpace())
  , mPaused(false)
  , mDestroyed(true)
  , mForceRendering(false)
{
}

/* static */ WebRenderBridgeParent*
WebRenderBridgeParent::CreateDestroyed()
{
  return new WebRenderBridgeParent();
}

WebRenderBridgeParent::~WebRenderBridgeParent()
{
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvCreate(const gfx::IntSize& aSize)
{
  if (mDestroyed) {
    return IPC_OK();
  }

  MOZ_ASSERT(mApi);

#ifdef MOZ_WIDGET_ANDROID
  // XXX temporary hack.
  // XXX Remove it when APZ is supported.
  // XXX Broken by Dynamic Toolbar v3. See: Bug 1335895
//  RefPtr<UiCompositorControllerParent> uiController = UiCompositorControllerParent::GetFromRootLayerTreeId(/* Root Layer Tree ID */);
//  if (uiController) {
//    uiController->ToolbarAnimatorMessageFromCompositor(/*FIRST_PAINT*/ 5);
//  }
#endif

  return IPC_OK();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvShutdown()
{
  return HandleShutdown();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvShutdownSync()
{
  return HandleShutdown();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::HandleShutdown()
{
  Destroy();
  IProtocol* mgr = Manager();
  if (!Send__delete__(this)) {
    return IPC_FAIL_NO_REASON(mgr);
  }
  return IPC_OK();
}

void
WebRenderBridgeParent::Destroy()
{
  if (mDestroyed) {
    return;
  }
  mDestroyed = true;
  ClearResources();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvAddImage(const wr::ImageKey& aImageKey,
                                    const gfx::IntSize& aSize,
                                    const uint32_t& aStride,
                                    const gfx::SurfaceFormat& aFormat,
                                    const ByteBuffer& aBuffer)
{
  if (mDestroyed) {
    return IPC_OK();
  }

  // Check if key is obsoleted.
  if (aImageKey.mNamespace != mIdNamespace) {
    return IPC_OK();
  }

  MOZ_ASSERT(mApi);
  MOZ_ASSERT(mActiveImageKeys.find(wr::AsUint64(aImageKey)) == mActiveImageKeys.end());

  wr::ImageDescriptor descriptor(aSize, aStride, aFormat);
  mActiveImageKeys.insert(wr::AsUint64(aImageKey));
  mApi->AddImage(aImageKey, descriptor,
                 aBuffer.AsSlice());

  return IPC_OK();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvAddBlobImage(const wr::ImageKey& aImageKey,
                                        const gfx::IntSize& aSize,
                                        const uint32_t& aStride,
                                        const gfx::SurfaceFormat& aFormat,
                                        const ByteBuffer& aBuffer)
{
  if (mDestroyed) {
    return IPC_OK();
  }

  // Check if key is obsoleted.
  if (aImageKey.mNamespace != mIdNamespace) {
    return IPC_OK();
  }

  MOZ_ASSERT(mApi);
  MOZ_ASSERT(mActiveImageKeys.find(wr::AsUint64(aImageKey)) == mActiveImageKeys.end());

  wr::ImageDescriptor descriptor(aSize, aStride, aFormat);
  mActiveImageKeys.insert(wr::AsUint64(aImageKey));
  mApi->AddBlobImage(aImageKey, descriptor,
                     aBuffer.AsSlice());

  return IPC_OK();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvAddRawFont(const wr::FontKey& aFontKey,
                                      const ByteBuffer& aBuffer,
                                      const uint32_t& aFontIndex)
{
  if (mDestroyed) {
    return IPC_OK();
  }

  // Check if key is obsoleted.
  if (aFontKey.mNamespace != mIdNamespace) {
    return IPC_OK();
  }

  MOZ_ASSERT(mApi);
  MOZ_ASSERT(mFontKeys.find(wr::AsUint64(aFontKey)) == mFontKeys.end());

  auto slice = aBuffer.AsSlice();
  mFontKeys.insert(wr::AsUint64(aFontKey));
  mApi->AddRawFont(aFontKey, slice, aFontIndex);

  return IPC_OK();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvDeleteFont(const wr::FontKey& aFontKey)
{
  if (mDestroyed) {
    return IPC_OK();
  }
  MOZ_ASSERT(mApi);

  // Check if key is obsoleted.
  if (aFontKey.mNamespace != mIdNamespace) {
    return IPC_OK();
  }

  if (mFontKeys.find(wr::AsUint64(aFontKey)) != mFontKeys.end()) {
    mFontKeys.erase(wr::AsUint64(aFontKey));
    mApi->DeleteFont(aFontKey);
  } else {
    MOZ_ASSERT_UNREACHABLE("invalid FontKey");
  }

  return IPC_OK();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvUpdateImage(const wr::ImageKey& aImageKey,
                                       const gfx::IntSize& aSize,
                                       const gfx::SurfaceFormat& aFormat,
                                       const ByteBuffer& aBuffer)
{
  if (mDestroyed) {
    return IPC_OK();
  }
  MOZ_ASSERT(mApi);

  // Check if key is obsoleted.
  if (aImageKey.mNamespace != mIdNamespace) {
    return IPC_OK();
  }

  wr::ImageDescriptor descriptor(aSize, aFormat);
  mApi->UpdateImageBuffer(aImageKey, descriptor, aBuffer.AsSlice());

  return IPC_OK();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvDeleteImage(const wr::ImageKey& aImageKey)
{
  if (mDestroyed) {
    return IPC_OK();
  }
  MOZ_ASSERT(mApi);

  // Check if key is obsoleted.
  if (aImageKey.mNamespace != mIdNamespace) {
    return IPC_OK();
  }

  if (mActiveImageKeys.find(wr::AsUint64(aImageKey)) != mActiveImageKeys.end()) {
    mActiveImageKeys.erase(wr::AsUint64(aImageKey));
    mKeysToDelete.push_back(aImageKey);
  } else {
    MOZ_ASSERT_UNREACHABLE("invalid ImageKey");
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvDeleteCompositorAnimations(InfallibleTArray<uint64_t>&& aIds)
{
  if (mDestroyed) {
    return IPC_OK();
  }

  for (uint32_t i = 0; i < aIds.Length(); i++) {
    if (mActiveAnimations.find(aIds[i]) != mActiveAnimations.end()) {
      mAnimStorage->ClearById(aIds[i]);
      mActiveAnimations.erase(aIds[i]);
    } else {
      NS_ERROR("Tried to delete invalid animation");
    }
  }

  return IPC_OK();
}


mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvDPBegin(const gfx::IntSize& aSize)
{
  if (mDestroyed) {
    return IPC_OK();
  }
  return IPC_OK();
}

void
WebRenderBridgeParent::HandleDPEnd(const gfx::IntSize& aSize,
                                 InfallibleTArray<WebRenderParentCommand>&& aCommands,
                                 InfallibleTArray<OpDestroy>&& aToDestroy,
                                 const uint64_t& aFwdTransactionId,
                                 const uint64_t& aTransactionId,
                                 const wr::LayoutSize& aContentSize,
                                 const wr::ByteBuffer& dl,
                                 const wr::BuiltDisplayListDescriptor& dlDesc,
                                 const WebRenderScrollData& aScrollData,
                                 const wr::IdNamespace& aIdNamespace,
                                 const TimeStamp& aFwdTime)
{
  AutoProfilerTracing tracing("Paint", "DPTransaction");
  UpdateFwdTransactionId(aFwdTransactionId);
  AutoClearReadLocks clearLocks(mReadLocks);

  if (mDestroyed) {
    for (const auto& op : aToDestroy) {
      DestroyActor(op);
    }
    return;
  }
  // This ensures that destroy operations are always processed. It is not safe
  // to early-return from RecvDPEnd without doing so.
  AutoWebRenderBridgeParentAsyncMessageSender autoAsyncMessageSender(this, &aToDestroy);

  uint32_t wrEpoch = GetNextWrEpoch();
  ProcessWebRenderCommands(aSize, aCommands, wr::NewEpoch(wrEpoch),
                           aContentSize, dl, dlDesc, aIdNamespace);
  HoldPendingTransactionId(wrEpoch, aTransactionId, aFwdTime);

  mScrollData = aScrollData;
  UpdateAPZ();

  if (mIdNamespace != aIdNamespace) {
    // Pretend we composited since someone is wating for this event,
    // though DisplayList was not pushed to webrender.
    TimeStamp now = TimeStamp::Now();
    mCompositorBridge->DidComposite(wr::AsUint64(mPipelineId), now, now);
  }
}

CompositorBridgeParent*
WebRenderBridgeParent::GetRootCompositorBridgeParent() const
{
  if (!mCompositorBridge) {
    return nullptr;
  }

  if (mWidget) {
    // This WebRenderBridgeParent is attached to the root
    // CompositorBridgeParent.
    return static_cast<CompositorBridgeParent*>(mCompositorBridge);
  }

  // Otherwise, this WebRenderBridgeParent is attached to a
  // CrossProcessCompositorBridgeParent so we have an extra level of
  // indirection to unravel.
  CompositorBridgeParent::LayerTreeState* lts =
      CompositorBridgeParent::GetIndirectShadowTree(GetLayersId());
  MOZ_ASSERT(lts);
  return lts->mParent;
}

void
WebRenderBridgeParent::UpdateAPZ()
{
  CompositorBridgeParent* cbp = GetRootCompositorBridgeParent();
  if (!cbp) {
    return;
  }
  uint64_t rootLayersId = cbp->RootLayerTreeId();
  RefPtr<WebRenderBridgeParent> rootWrbp = cbp->GetWebRenderBridgeParent();
  if (!rootWrbp) {
    return;
  }
  if (RefPtr<APZCTreeManager> apzc = cbp->GetAPZCTreeManager()) {
    apzc->UpdateFocusState(rootLayersId, GetLayersId(),
                           mScrollData.GetFocusTarget());
    apzc->UpdateHitTestingTree(rootLayersId, rootWrbp->GetScrollData(),
        mScrollData.IsFirstPaint(), GetLayersId(),
        mScrollData.GetPaintSequenceNumber());
  }
}

bool
WebRenderBridgeParent::PushAPZStateToWR(nsTArray<wr::WrTransformProperty>& aTransformArray)
{
  CompositorBridgeParent* cbp = GetRootCompositorBridgeParent();
  if (!cbp) {
    return false;
  }
  if (RefPtr<APZCTreeManager> apzc = cbp->GetAPZCTreeManager()) {
    TimeStamp animationTime = cbp->GetTestingTimeStamp().valueOr(
        mCompositorScheduler->GetLastComposeTime());
    TimeDuration frameInterval = cbp->GetVsyncInterval();
    // As with the non-webrender codepath in AsyncCompositionManager, we want to
    // use the timestamp for the next vsync when advancing animations.
    if (frameInterval != TimeDuration::Forever()) {
      animationTime += frameInterval;
    }
    return apzc->PushStateToWR(mApi, animationTime, aTransformArray);
  }
  return false;
}

const WebRenderScrollData&
WebRenderBridgeParent::GetScrollData() const
{
  MOZ_ASSERT(mozilla::layers::CompositorThreadHolder::IsInCompositorThread());
  return mScrollData;
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvDPEnd(const gfx::IntSize& aSize,
                                 InfallibleTArray<WebRenderParentCommand>&& aCommands,
                                 InfallibleTArray<OpDestroy>&& aToDestroy,
                                 const uint64_t& aFwdTransactionId,
                                 const uint64_t& aTransactionId,
                                 const wr::LayoutSize& aContentSize,
                                 const wr::ByteBuffer& dl,
                                 const wr::BuiltDisplayListDescriptor& dlDesc,
                                 const WebRenderScrollData& aScrollData,
                                 const wr::IdNamespace& aIdNamespace,
                                 const TimeStamp& aFwdTime)
{
  if (mDestroyed) {
    return IPC_OK();
  }
  HandleDPEnd(aSize, Move(aCommands), Move(aToDestroy), aFwdTransactionId, aTransactionId,
              aContentSize, dl, dlDesc, aScrollData, aIdNamespace, aFwdTime);
  return IPC_OK();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvDPSyncEnd(const gfx::IntSize &aSize,
                                     InfallibleTArray<WebRenderParentCommand>&& aCommands,
                                     InfallibleTArray<OpDestroy>&& aToDestroy,
                                     const uint64_t& aFwdTransactionId,
                                     const uint64_t& aTransactionId,
                                     const wr::LayoutSize& aContentSize,
                                     const wr::ByteBuffer& dl,
                                     const wr::BuiltDisplayListDescriptor& dlDesc,
                                     const WebRenderScrollData& aScrollData,
                                     const wr::IdNamespace& aIdNamespace,
                                     const TimeStamp& aFwdTime)
{
  if (mDestroyed) {
    return IPC_OK();
  }
  HandleDPEnd(aSize, Move(aCommands), Move(aToDestroy), aFwdTransactionId, aTransactionId,
              aContentSize, dl, dlDesc, aScrollData, aIdNamespace, aFwdTime);
  return IPC_OK();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvParentCommands(nsTArray<WebRenderParentCommand>&& aCommands)
{
  if (mDestroyed) {
    return IPC_OK();
  }
  ProcessWebRenderParentCommands(aCommands);
  return IPC_OK();
}

void
WebRenderBridgeParent::ProcessWebRenderParentCommands(InfallibleTArray<WebRenderParentCommand>& aCommands)
{
  for (InfallibleTArray<WebRenderParentCommand>::index_type i = 0; i < aCommands.Length(); ++i) {
    const WebRenderParentCommand& cmd = aCommands[i];
    switch (cmd.type()) {
      case WebRenderParentCommand::TOpAddExternalImage: {
        const OpAddExternalImage& op = cmd.get_OpAddExternalImage();
        Range<const wr::ImageKey> keys(&op.key(), 1);
        // Check if key is obsoleted.
        if (keys[0].mNamespace != mIdNamespace) {
          break;
        }
        MOZ_ASSERT(mExternalImageIds.Get(wr::AsUint64(op.externalImageId())).get());
        MOZ_ASSERT(mActiveImageKeys.find(wr::AsUint64(keys[0])) == mActiveImageKeys.end());
        mActiveImageKeys.insert(wr::AsUint64(keys[0]));

        RefPtr<WebRenderImageHost> host = mExternalImageIds.Get(wr::AsUint64(op.externalImageId()));
        if (!host) {
          NS_ERROR("CompositableHost does not exist");
          break;
        }
        if (!gfxEnv::EnableWebRenderRecording()) {
          TextureHost* texture = host->GetAsTextureHostForComposite();
          if (!texture) {
            NS_ERROR("TextureHost does not exist");
            break;
          }
          WebRenderTextureHost* wrTexture = texture->AsWebRenderTextureHost();
          if (wrTexture) {
            wrTexture->AddWRImage(mApi, keys, wrTexture->GetExternalImageKey());
            break;
          }
        }
        RefPtr<DataSourceSurface> dSurf = host->GetAsSurface();
        if (!dSurf) {
          NS_ERROR("TextureHost does not return DataSourceSurface");
          break;
        }

        DataSourceSurface::MappedSurface map;
        if (!dSurf->Map(gfx::DataSourceSurface::MapType::READ, &map)) {
          NS_ERROR("DataSourceSurface failed to map");
          break;
        }

        IntSize size = dSurf->GetSize();
        wr::ImageDescriptor descriptor(size, map.mStride, dSurf->GetFormat());
        auto slice = Range<uint8_t>(map.mData, size.height * map.mStride);
        mApi->AddImage(keys[0], descriptor, slice);

        dSurf->Unmap();
        break;
      }
      case WebRenderParentCommand::TOpUpdateAsyncImagePipeline: {
        const OpUpdateAsyncImagePipeline& op = cmd.get_OpUpdateAsyncImagePipeline();
        mAsyncImageManager->UpdateAsyncImagePipeline(op.pipelineId(),
                                                      op.scBounds(),
                                                      op.scTransform(),
                                                      op.scaleToSize(),
                                                      op.filter(),
                                                      op.mixBlendMode());
        break;
      }
      case WebRenderParentCommand::TCompositableOperation: {
        if (!ReceiveCompositableUpdate(cmd.get_CompositableOperation())) {
          NS_ERROR("ReceiveCompositableUpdate failed");
        }
        break;
      }
      case WebRenderParentCommand::TOpAddCompositorAnimations: {
        const OpAddCompositorAnimations& op = cmd.get_OpAddCompositorAnimations();
        CompositorAnimations data(Move(op.data()));
        if (data.animations().Length()) {
          mAnimStorage->SetAnimations(data.id(), data.animations());
          mActiveAnimations.insert(data.id());
          // Store the default opacity
          if (op.opacity().type() == OptionalOpacity::Tfloat) {
            mAnimStorage->SetAnimatedValue(data.id(), op.opacity().get_float());
          }
          // Store the default transform
          if (op.transform().type() == OptionalTransform::TMatrix4x4) {
            Matrix4x4 transform(Move(op.transform().get_Matrix4x4()));
            mAnimStorage->SetAnimatedValue(data.id(), Move(transform));
          }
        }
        break;
      }
      default: {
        // other commands are handle on the child
        break;
      }
    }
  }
}

void
WebRenderBridgeParent::ProcessWebRenderCommands(const gfx::IntSize &aSize,
                                                InfallibleTArray<WebRenderParentCommand>& aCommands, const wr::Epoch& aEpoch,
                                                const wr::LayoutSize& aContentSize, const wr::ByteBuffer& dl,
                                                const wr::BuiltDisplayListDescriptor& dlDesc,
                                                const wr::IdNamespace& aIdNamespace)
{
  mAsyncImageManager->SetCompositionTime(TimeStamp::Now());
  ProcessWebRenderParentCommands(aCommands);

  // The command is obsoleted.
  // Do not set the command to webrender since it causes crash in webrender.
  if (mIdNamespace != aIdNamespace) {
    return;
  }

  if (mWidget) {
    LayoutDeviceIntSize size = mWidget->GetClientSize();
    mApi->SetWindowParameters(size);
  }
  gfx::Color color = mWidget ? gfx::Color(0.3f, 0.f, 0.f, 1.f) : gfx::Color(0.f, 0.f, 0.f, 0.f);
  mApi->SetRootDisplayList(color, aEpoch, LayerSize(aSize.width, aSize.height),
                           mPipelineId, aContentSize,
                           dlDesc, dl.mData, dl.mLength);

  ScheduleComposition();
  DeleteOldImages();

  if (ShouldParentObserveEpoch()) {
    mCompositorBridge->ObserveLayerUpdate(GetLayersId(), GetChildLayerObserverEpoch(), true);
  }
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvDPGetSnapshot(PTextureParent* aTexture)
{
  if (mDestroyed) {
    return IPC_OK();
  }
  MOZ_ASSERT(!mPaused);

  RefPtr<TextureHost> texture = TextureHost::AsTextureHost(aTexture);
  if (!texture) {
    // We kill the content process rather than have it continue with an invalid
    // snapshot, that may be too harsh and we could decide to return some sort
    // of error to the child process and let it deal with it...
    return IPC_FAIL_NO_REASON(this);
  }

  // XXX Add other TextureHost supports.
  // Only BufferTextureHost is supported now.
  BufferTextureHost* bufferTexture = texture->AsBufferTextureHost();
  if (!bufferTexture) {
    // We kill the content process rather than have it continue with an invalid
    // snapshot, that may be too harsh and we could decide to return some sort
    // of error to the child process and let it deal with it...
    return IPC_FAIL_NO_REASON(this);
  }

  MOZ_ASSERT(bufferTexture->GetBufferDescriptor().type() == BufferDescriptor::TRGBDescriptor);
  DebugOnly<uint32_t> stride = ImageDataSerializer::GetRGBStride(bufferTexture->GetBufferDescriptor().get_RGBDescriptor());
  uint8_t* buffer = bufferTexture->GetBuffer();
  IntSize size = bufferTexture->GetSize();

  // We only support B8G8R8A8 for now.
  MOZ_ASSERT(buffer);
  MOZ_ASSERT(bufferTexture->GetFormat() == SurfaceFormat::B8G8R8A8);
  uint32_t buffer_size = size.width * size.height * 4;

  // Assert the stride of the buffer is what webrender expects
  MOZ_ASSERT((uint32_t)(size.width * 4) == stride);

  mForceRendering = true;

  if (mCompositorScheduler->NeedsComposite()) {
    mCompositorScheduler->CancelCurrentCompositeTask();
    mCompositorScheduler->ForceComposeToTarget(nullptr, nullptr);
  }

  mApi->Readback(size, buffer, buffer_size);

  mForceRendering = false;

  return IPC_OK();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvAddPipelineIdForAsyncCompositable(const wr::PipelineId& aPipelineId,
                                                             const CompositableHandle& aHandle)
{
  if (mDestroyed) {
    return IPC_OK();
  }

  MOZ_ASSERT(!mAsyncCompositables.Get(wr::AsUint64(aPipelineId)).get());

  RefPtr<ImageBridgeParent> imageBridge = ImageBridgeParent::GetInstance(OtherPid());
  if (!imageBridge) {
     return IPC_FAIL_NO_REASON(this);
  }
  RefPtr<CompositableHost> host = imageBridge->FindCompositable(aHandle);
  if (!host) {
    return IPC_FAIL_NO_REASON(this);
  }
  MOZ_ASSERT(host->AsWebRenderImageHost());
  WebRenderImageHost* wrHost = host->AsWebRenderImageHost();
  if (!wrHost) {
    return IPC_OK();
  }

  wrHost->SetWrBridge(this);
  mAsyncCompositables.Put(wr::AsUint64(aPipelineId), wrHost);
  mAsyncImageManager->AddAsyncImagePipeline(aPipelineId, wrHost);

  return IPC_OK();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvRemovePipelineIdForAsyncCompositable(const wr::PipelineId& aPipelineId)
{
  if (mDestroyed) {
    return IPC_OK();
  }

  WebRenderImageHost* wrHost = mAsyncCompositables.Get(wr::AsUint64(aPipelineId)).get();
  if (!wrHost) {
    return IPC_OK();
  }

  wrHost->ClearWrBridge();
  mAsyncImageManager->RemoveAsyncImagePipeline(mApi, aPipelineId);
  mAsyncCompositables.Remove(wr::AsUint64(aPipelineId));
  return IPC_OK();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvAddExternalImageIdForCompositable(const ExternalImageId& aImageId,
                                                             const CompositableHandle& aHandle)
{
  if (mDestroyed) {
    return IPC_OK();
  }
  MOZ_ASSERT(!mExternalImageIds.Get(wr::AsUint64(aImageId)).get());

  RefPtr<CompositableHost> host = FindCompositable(aHandle);
  MOZ_ASSERT(host->AsWebRenderImageHost());
  WebRenderImageHost* wrHost = host->AsWebRenderImageHost();
  if (!wrHost) {
    return IPC_OK();
  }

  wrHost->SetWrBridge(this);
  mExternalImageIds.Put(wr::AsUint64(aImageId), wrHost);

  return IPC_OK();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvRemoveExternalImageId(const ExternalImageId& aImageId)
{
  if (mDestroyed) {
    return IPC_OK();
  }
  WebRenderImageHost* wrHost = mExternalImageIds.Get(wr::AsUint64(aImageId)).get();
  if (!wrHost) {
    return IPC_OK();
  }

  wrHost->ClearWrBridge();
  mExternalImageIds.Remove(wr::AsUint64(aImageId));

  return IPC_OK();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvSetLayerObserverEpoch(const uint64_t& aLayerObserverEpoch)
{
  if (mDestroyed) {
    return IPC_OK();
  }
  mChildLayerObserverEpoch = aLayerObserverEpoch;
  return IPC_OK();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvClearCachedResources()
{
  if (mDestroyed) {
    return IPC_OK();
  }
  mCompositorBridge->ObserveLayerUpdate(GetLayersId(), GetChildLayerObserverEpoch(), false);

  // Clear resources
  mApi->ClearRootDisplayList(wr::NewEpoch(GetNextWrEpoch()), mPipelineId);
  // Schedule composition to clean up Pipeline
  mCompositorScheduler->ScheduleComposition();
  DeleteOldImages();
  // Remove animations.
  for (std::unordered_set<uint64_t>::iterator iter = mActiveAnimations.begin(); iter != mActiveAnimations.end(); iter++) {
    mAnimStorage->ClearById(*iter);
  }
  mActiveAnimations.clear();
  return IPC_OK();
}

void
WebRenderBridgeParent::UpdateWebRender(CompositorVsyncScheduler* aScheduler,
                                       wr::WebRenderAPI* aApi,
                                       AsyncImagePipelineManager* aImageMgr,
                                       CompositorAnimationStorage* aAnimStorage)
{
  MOZ_ASSERT(!mWidget);
  MOZ_ASSERT(aScheduler);
  MOZ_ASSERT(aApi);
  MOZ_ASSERT(aImageMgr);
  MOZ_ASSERT(aAnimStorage);

  if (mDestroyed) {
    return;
  }

  // Update id name space to identify obsoleted keys.
  // Since usage of invalid keys could cause crash in webrender.
  mIdNamespace = AllocIdNameSpace();
  // XXX Remove it when webrender supports sharing/moving Keys between different webrender instances.
  // XXX It requests client to update/reallocate webrender related resources,
  // but parent side does not wait end of the update.
  // The code could become simpler if we could serialise old keys deallocation and new keys allocation.
  // But we do not do it, it is because client side deallocate old layers/webrender keys
  // after new layers/webrender keys allocation.
  // Without client side's layout refactoring, we could not finish all old layers/webrender keys removals
  // before new layer/webrender keys allocation. In future, we could address the problem.
  Unused << SendWrUpdated(mIdNamespace);
  CompositorBridgeParentBase* cBridge = mCompositorBridge;
  // XXX Stop to clear resources if webreder supports resources sharing between different webrender instances.
  ClearResources();
  mCompositorBridge = cBridge;
  mCompositorScheduler = aScheduler;
  mApi = aApi;
  mAsyncImageManager = aImageMgr;
  mAnimStorage = aAnimStorage;

  Unused << GetNextWrEpoch(); // Update webrender epoch
  // Register pipeline to updated AsyncImageManager.
  mAsyncImageManager->AddPipeline(mPipelineId);
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvForceComposite()
{
  if (mDestroyed) {
    return IPC_OK();
  }
  ScheduleComposition();
  return IPC_OK();
}

already_AddRefed<AsyncPanZoomController>
WebRenderBridgeParent::GetTargetAPZC(const FrameMetrics::ViewID& aScrollId)
{
  RefPtr<AsyncPanZoomController> apzc;
  if (CompositorBridgeParent* cbp = GetRootCompositorBridgeParent()) {
    if (RefPtr<APZCTreeManager> apzctm = cbp->GetAPZCTreeManager()) {
      apzc = apzctm->GetTargetAPZC(GetLayersId(), aScrollId);
    }
  }
  return apzc.forget();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvSetConfirmedTargetAPZC(const uint64_t& aBlockId,
                                                  nsTArray<ScrollableLayerGuid>&& aTargets)
{
  if (mDestroyed) {
    return IPC_OK();
  }
  mCompositorBridge->SetConfirmedTargetAPZC(GetLayersId(), aBlockId, aTargets);
  return IPC_OK();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvSetTestSampleTime(const TimeStamp& aTime)
{
  if (!mCompositorBridge->SetTestSampleTime(GetLayersId(), aTime)) {
    return IPC_FAIL_NO_REASON(this);
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvLeaveTestMode()
{
  mCompositorBridge->LeaveTestMode(GetLayersId());
  return IPC_OK();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvGetAnimationOpacity(const uint64_t& aCompositorAnimationsId,
                                               float* aOpacity,
                                               bool* aHasAnimationOpacity)
{
  if (mDestroyed) {
    return IPC_FAIL_NO_REASON(this);
  }

  MOZ_ASSERT(mAnimStorage);
  AdvanceAnimations();

  Maybe<float> opacity = mAnimStorage->GetAnimationOpacity(aCompositorAnimationsId);
  if (opacity) {
    *aOpacity = *opacity;
    *aHasAnimationOpacity = true;
  } else {
    *aHasAnimationOpacity = false;
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvGetAnimationTransform(const uint64_t& aCompositorAnimationsId,
                                                 MaybeTransform* aTransform)
{
  if (mDestroyed) {
    return IPC_FAIL_NO_REASON(this);
  }

  MOZ_ASSERT(mAnimStorage);
  AdvanceAnimations();

  Maybe<Matrix4x4> transform = mAnimStorage->GetAnimationTransform(aCompositorAnimationsId);
  if (transform) {
    *aTransform = *transform;
  } else {
    *aTransform = mozilla::void_t();
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvSetAsyncScrollOffset(const FrameMetrics::ViewID& aScrollId,
                                                const float& aX,
                                                const float& aY)
{
  if (mDestroyed) {
    return IPC_OK();
  }
  RefPtr<AsyncPanZoomController> apzc = GetTargetAPZC(aScrollId);
  if (!apzc) {
    return IPC_FAIL_NO_REASON(this);
  }
  apzc->SetTestAsyncScrollOffset(CSSPoint(aX, aY));
  return IPC_OK();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvSetAsyncZoom(const FrameMetrics::ViewID& aScrollId,
                                        const float& aZoom)
{
  if (mDestroyed) {
    return IPC_OK();
  }
  RefPtr<AsyncPanZoomController> apzc = GetTargetAPZC(aScrollId);
  if (!apzc) {
    return IPC_FAIL_NO_REASON(this);
  }
  apzc->SetTestAsyncZoom(LayerToParentLayerScale(aZoom));
  return IPC_OK();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvFlushApzRepaints()
{
  if (mDestroyed) {
    return IPC_OK();
  }
  mCompositorBridge->FlushApzRepaints(GetLayersId());
  return IPC_OK();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvGetAPZTestData(APZTestData* aOutData)
{
  mCompositorBridge->GetAPZTestData(GetLayersId(), aOutData);
  return IPC_OK();
}

void
WebRenderBridgeParent::ActorDestroy(ActorDestroyReason aWhy)
{
  Destroy();
}

void
WebRenderBridgeParent::AdvanceAnimations()
{
  TimeStamp animTime = mCompositorScheduler->GetLastComposeTime();
  if (CompositorBridgeParent* cbp = GetRootCompositorBridgeParent()) {
    animTime = cbp->GetTestingTimeStamp().valueOr(animTime);
  }

  AnimationHelper::SampleAnimations(mAnimStorage,
                                    !mPreviousFrameTimeStamp.IsNull() ?
                                    mPreviousFrameTimeStamp : animTime);

  // Reset the previous time stamp if we don't already have any running
  // animations to avoid using the time which is far behind for newly
  // started animations.
  mPreviousFrameTimeStamp =
    mAnimStorage->AnimatedValueCount() ? animTime : TimeStamp();
}

void
WebRenderBridgeParent::SampleAnimations(nsTArray<wr::WrOpacityProperty>& aOpacityArray,
                                        nsTArray<wr::WrTransformProperty>& aTransformArray)
{
  AdvanceAnimations();

  // return the animated data if has
  if (mAnimStorage->AnimatedValueCount()) {
    for(auto iter = mAnimStorage->ConstAnimatedValueTableIter();
        !iter.Done(); iter.Next()) {
      AnimatedValue * value = iter.UserData();
      if (value->mType == AnimatedValue::TRANSFORM) {
        aTransformArray.AppendElement(
          wr::ToWrTransformProperty(iter.Key(), value->mTransform.mTransformInDevSpace));
      } else if (value->mType == AnimatedValue::OPACITY) {
        aOpacityArray.AppendElement(
          wr::ToWrOpacityProperty(iter.Key(), value->mOpacity));
      }
    }
  }
}

void
WebRenderBridgeParent::CompositeToTarget(gfx::DrawTarget* aTarget, const gfx::IntRect* aRect)
{
  AutoProfilerTracing tracing("Paint", "CompositeToTraget");
  if (mPaused) {
    return;
  }

  const uint32_t maxPendingFrameCount = 1;

  if (!mForceRendering &&
      wr::RenderThread::Get()->GetPendingFrameCount(mApi->GetId()) >= maxPendingFrameCount) {
    // Render thread is busy, try next time.
    ScheduleComposition();
    return;
  }

  bool scheduleComposite = false;
  nsTArray<wr::WrOpacityProperty> opacityArray;
  nsTArray<wr::WrTransformProperty> transformArray;

  mAsyncImageManager->SetCompositionTime(TimeStamp::Now());
  mAsyncImageManager->ApplyAsyncImages(mApi);

  SampleAnimations(opacityArray, transformArray);
  if (!transformArray.IsEmpty() || !opacityArray.IsEmpty()) {
    scheduleComposite = true;
  }

  if (PushAPZStateToWR(transformArray)) {
    scheduleComposite = true;
  }

  wr::RenderThread::Get()->IncPendingFrameCount(mApi->GetId());

#if defined(ENABLE_FRAME_LATENCY_LOG)
  auto startTime = TimeStamp::Now();
  mApi->SetFrameStartTime(startTime);
#endif

  if (!transformArray.IsEmpty() || !opacityArray.IsEmpty()) {
    mApi->GenerateFrame(opacityArray, transformArray);
  } else {
    mApi->GenerateFrame();
  }

  if (!mAsyncImageManager->GetCompositeUntilTime().IsNull()) {
    scheduleComposite = true;
  }

  if (scheduleComposite) {
    ScheduleComposition();
  }
}

void
WebRenderBridgeParent::HoldPendingTransactionId(uint32_t aWrEpoch, uint64_t aTransactionId, const TimeStamp& aFwdTime)
{
  // The transaction ID might get reset to 1 if the page gets reloaded, see
  // https://bugzilla.mozilla.org/show_bug.cgi?id=1145295#c41
  // Otherwise, it should be continually increasing.
  MOZ_ASSERT(aTransactionId == 1 || aTransactionId > LastPendingTransactionId());
  // Handle TransactionIdAllocator(RefreshDriver) change.
  if (aTransactionId == 1) {
    FlushPendingTransactionIds();
  }
  mPendingTransactionIds.push(PendingTransactionId(wr::NewEpoch(aWrEpoch), aTransactionId, aFwdTime));
}

uint64_t
WebRenderBridgeParent::LastPendingTransactionId()
{
  uint64_t id = 0;
  if (!mPendingTransactionIds.empty()) {
    id = mPendingTransactionIds.back().mId;
  }
  return id;
}

uint64_t
WebRenderBridgeParent::FlushPendingTransactionIds()
{
  uint64_t id = 0;
  while (!mPendingTransactionIds.empty()) {
    id = mPendingTransactionIds.front().mId;
    mPendingTransactionIds.pop();
  }
  return id;
}

uint64_t
WebRenderBridgeParent::FlushTransactionIdsForEpoch(const wr::Epoch& aEpoch, const TimeStamp& aEndTime)
{
  uint64_t id = 0;
  while (!mPendingTransactionIds.empty()) {
    int64_t diff =
      static_cast<int64_t>(aEpoch.mHandle) - static_cast<int64_t>(mPendingTransactionIds.front().mEpoch.mHandle);
    if (diff < 0) {
      break;
    }
#if defined(ENABLE_FRAME_LATENCY_LOG)
    if (mPendingTransactionIds.front().mFwdTime) {
      uint32_t latencyMs = round((aEndTime - mPendingTransactionIds.front().mFwdTime).ToMilliseconds());
      printf_stderr("From EndTransaction to end of generate frame latencyMs %d this %p\n", latencyMs, this);
    }
#endif

    id = mPendingTransactionIds.front().mId;
    mPendingTransactionIds.pop();
    if (diff == 0) {
      break;
    }
  }
  return id;
}

uint64_t
WebRenderBridgeParent::GetLayersId() const
{
  return wr::AsUint64(mPipelineId);
}

void
WebRenderBridgeParent::DeleteOldImages()
{
  for (wr::ImageKey key : mKeysToDelete) {
    mApi->DeleteImage(key);
  }
  mKeysToDelete.clear();
}

void
WebRenderBridgeParent::ScheduleComposition()
{
  if (mCompositorScheduler) {
    mCompositorScheduler->ScheduleComposition();
  }
}

void
WebRenderBridgeParent::FlushRendering(bool aIsSync)
{
  if (mDestroyed) {
    return;
  }

  if (!mCompositorScheduler->NeedsComposite()) {
    return;
  }

  mForceRendering = true;
  mCompositorScheduler->CancelCurrentCompositeTask();
  mCompositorScheduler->ForceComposeToTarget(nullptr, nullptr);
  if (aIsSync) {
    mApi->WaitFlushed();
  }
  mForceRendering = false;
}

void
WebRenderBridgeParent::Pause()
{
  MOZ_ASSERT(mWidget);
#ifdef MOZ_WIDGET_ANDROID
  if (!mWidget || mDestroyed) {
    return;
  }
  mApi->Pause();
#endif
  mPaused = true;
}

bool
WebRenderBridgeParent::Resume()
{
  MOZ_ASSERT(mWidget);
#ifdef MOZ_WIDGET_ANDROID
  if (!mWidget || mDestroyed) {
    return false;
  }

  if (!mApi->Resume()) {
    return false;
  }
#endif
  mPaused = false;
  return true;
}

void
WebRenderBridgeParent::ClearResources()
{
  if (!mApi) {
    return;
  }

  uint32_t wrEpoch = GetNextWrEpoch();
  mApi->ClearRootDisplayList(wr::NewEpoch(wrEpoch), mPipelineId);
  // Schedule composition to clean up Pipeline
  mCompositorScheduler->ScheduleComposition();
  // XXX webrender does not hava a way to delete a group of resources/keys,
  // then delete keys one by one.
  for (std::unordered_set<uint64_t>::iterator iter = mFontKeys.begin(); iter != mFontKeys.end(); iter++) {
    mApi->DeleteFont(wr::AsFontKey(*iter));
  }
  mFontKeys.clear();
  for (std::unordered_set<uint64_t>::iterator iter = mActiveImageKeys.begin(); iter != mActiveImageKeys.end(); iter++) {
    mKeysToDelete.push_back(wr::AsImageKey(*iter));
  }
  mActiveImageKeys.clear();
  DeleteOldImages();
  for (auto iter = mExternalImageIds.Iter(); !iter.Done(); iter.Next()) {
    iter.Data()->ClearWrBridge();
  }
  mExternalImageIds.Clear();
  for (auto iter = mAsyncCompositables.Iter(); !iter.Done(); iter.Next()) {
    wr::PipelineId pipelineId = wr::AsPipelineId(iter.Key());
    RefPtr<WebRenderImageHost> host = iter.Data();
    MOZ_ASSERT(host->GetAsyncRef());
    host->ClearWrBridge();
    mAsyncImageManager->RemoveAsyncImagePipeline(mApi, pipelineId);
  }
  mAsyncCompositables.Clear();

  mAsyncImageManager->RemovePipeline(mPipelineId, wr::NewEpoch(wrEpoch));

  for (std::unordered_set<uint64_t>::iterator iter = mActiveAnimations.begin(); iter != mActiveAnimations.end(); iter++) {
    mAnimStorage->ClearById(*iter);
  }
  mActiveAnimations.clear();

  if (mWidget) {
    mCompositorScheduler->Destroy();
  }
  mAnimStorage = nullptr;
  mCompositorScheduler = nullptr;
  mApi = nullptr;
  mCompositorBridge = nullptr;
}

bool
WebRenderBridgeParent::ShouldParentObserveEpoch()
{
  if (mParentLayerObserverEpoch == mChildLayerObserverEpoch) {
    return false;
  }

  mParentLayerObserverEpoch = mChildLayerObserverEpoch;
  return true;
}

void
WebRenderBridgeParent::SendAsyncMessage(const InfallibleTArray<AsyncParentMessageData>& aMessage)
{
  MOZ_ASSERT_UNREACHABLE("unexpected to be called");
}

void
WebRenderBridgeParent::SendPendingAsyncMessages()
{
  MOZ_ASSERT(mCompositorBridge);
  mCompositorBridge->SendPendingAsyncMessages();
}

void
WebRenderBridgeParent::SetAboutToSendAsyncMessages()
{
  MOZ_ASSERT(mCompositorBridge);
  mCompositorBridge->SetAboutToSendAsyncMessages();
}

void
WebRenderBridgeParent::NotifyNotUsed(PTextureParent* aTexture, uint64_t aTransactionId)
{
  MOZ_ASSERT_UNREACHABLE("unexpected to be called");
}

base::ProcessId
WebRenderBridgeParent::GetChildProcessId()
{
  return OtherPid();
}

bool
WebRenderBridgeParent::IsSameProcess() const
{
  return OtherPid() == base::GetCurrentProcId();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvNewCompositable(const CompositableHandle& aHandle,
                                           const TextureInfo& aInfo)
{
  if (mDestroyed) {
    return IPC_OK();
  }
  if (!AddCompositable(aHandle, aInfo)) {
    return IPC_FAIL_NO_REASON(this);
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvReleaseCompositable(const CompositableHandle& aHandle)
{
  if (mDestroyed) {
    return IPC_OK();
  }
  ReleaseCompositable(aHandle);
  return IPC_OK();
}

mozilla::ipc::IPCResult
WebRenderBridgeParent::RecvInitReadLocks(ReadLockArray&& aReadLocks)
{
  if (mDestroyed) {
    return IPC_OK();
  }
  if (!AddReadLocks(Move(aReadLocks))) {
    return IPC_FAIL_NO_REASON(this);
  }
  return IPC_OK();
}

void
WebRenderBridgeParent::SetWebRenderProfilerEnabled(bool aEnabled)
{
  if (mWidget) {
    // Only set the flag to "root" WebRenderBridgeParent.
    mApi->SetProfilerEnabled(aEnabled);
  }
}

TextureFactoryIdentifier
WebRenderBridgeParent::GetTextureFactoryIdentifier()
{
  MOZ_ASSERT(mApi);

  return TextureFactoryIdentifier(LayersBackend::LAYERS_WR,
                                  XRE_GetProcessType(),
                                  mApi->GetMaxTextureSize(),
                                  mApi->GetUseANGLE());
}

uint32_t
WebRenderBridgeParent::GetNextWrEpoch()
{
  MOZ_RELEASE_ASSERT(mWrEpoch != UINT32_MAX);
  return ++mWrEpoch;
}

void
WebRenderBridgeParent::ExtractImageCompositeNotifications(nsTArray<ImageCompositeNotificationInfo>* aNotifications)
{
  MOZ_ASSERT(mWidget);
  mAsyncImageManager->FlushImageNotifications(aNotifications);
}

} // namespace layers
} // namespace mozilla
