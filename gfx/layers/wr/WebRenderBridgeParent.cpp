/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/layers/WebRenderBridgeParent.h"

#include "CompositableHost.h"
#include "gfxEnv.h"
#include "gfxOTSUtils.h"
#include "GeckoProfiler.h"
#include "GLContext.h"
#include "GLContextProvider.h"
#include "nsExceptionHandler.h"
#include "mozilla/Range.h"
#include "mozilla/StaticPrefs_gfx.h"
#include "mozilla/UniquePtr.h"
#include "mozilla/gfx/gfxVars.h"
#include "mozilla/layers/AnimationHelper.h"
#include "mozilla/layers/APZSampler.h"
#include "mozilla/layers/APZUpdater.h"
#include "mozilla/layers/Compositor.h"
#include "mozilla/layers/CompositorBridgeParent.h"
#include "mozilla/layers/CompositorThread.h"
#include "mozilla/layers/CompositorVsyncScheduler.h"
#include "mozilla/layers/ImageBridgeParent.h"
#include "mozilla/layers/ImageDataSerializer.h"
#include "mozilla/layers/IpcResourceUpdateQueue.h"
#include "mozilla/layers/SharedSurfacesParent.h"
#include "mozilla/layers/TextureHost.h"
#include "mozilla/layers/AsyncImagePipelineManager.h"
#include "mozilla/layers/WebRenderImageHost.h"
#include "mozilla/layers/WebRenderTextureHost.h"
#include "mozilla/Telemetry.h"
#include "mozilla/TimeStamp.h"
#include "mozilla/Unused.h"
#include "mozilla/webrender/RenderThread.h"
#include "mozilla/widget/CompositorWidget.h"

#ifdef XP_WIN
#  include "mozilla/widget/WinCompositorWidget.h"
#endif

#ifdef MOZ_GECKO_PROFILER
#  include "ProfilerMarkerPayload.h"
#endif

bool is_in_main_thread() { return NS_IsMainThread(); }

bool is_in_compositor_thread() {
  return mozilla::layers::CompositorThreadHolder::IsInCompositorThread();
}

bool is_in_render_thread() {
  return mozilla::wr::RenderThread::IsInRenderThread();
}

void gecko_profiler_start_marker(const char* name) {
#ifdef MOZ_GECKO_PROFILER
  profiler_tracing_marker("WebRender", name,
                          JS::ProfilingCategoryPair::GRAPHICS,
                          TRACING_INTERVAL_START);
#endif
}

void gecko_profiler_end_marker(const char* name) {
#ifdef MOZ_GECKO_PROFILER
  profiler_tracing_marker("WebRender", name,
                          JS::ProfilingCategoryPair::GRAPHICS,
                          TRACING_INTERVAL_END);
#endif
}

void gecko_profiler_event_marker(const char* name) {
#ifdef MOZ_GECKO_PROFILER
  profiler_tracing_marker("WebRender", name,
                          JS::ProfilingCategoryPair::GRAPHICS, TRACING_EVENT);
#endif
}

void gecko_profiler_add_text_marker(const char* name, const char* text_bytes,
                                    size_t text_len, uint64_t microseconds) {
#ifdef MOZ_GECKO_PROFILER
  if (profiler_thread_is_being_profiled()) {
    auto now = mozilla::TimeStamp::NowUnfuzzed();
    auto start = now - mozilla::TimeDuration::FromMicroseconds(microseconds);
    profiler_add_text_marker(name, nsDependentCSubstring(text_bytes, text_len),
                             JS::ProfilingCategoryPair::GRAPHICS, start, now);
  }
#endif
}

bool gecko_profiler_thread_is_being_profiled() {
#ifdef MOZ_GECKO_PROFILER
  return profiler_thread_is_being_profiled();
#else
  return false;
#endif
}

bool is_glcontext_gles(void* const glcontext_ptr) {
  MOZ_RELEASE_ASSERT(glcontext_ptr);
  return reinterpret_cast<mozilla::gl::GLContext*>(glcontext_ptr)->IsGLES();
}

bool is_glcontext_angle(void* glcontext_ptr) {
  MOZ_ASSERT(glcontext_ptr);

  mozilla::gl::GLContext* glcontext =
      reinterpret_cast<mozilla::gl::GLContext*>(glcontext_ptr);
  if (!glcontext) {
    return false;
  }
  return glcontext->IsANGLE();
}

const char* gfx_wr_resource_path_override() {
  const char* resourcePath = PR_GetEnv("WR_RESOURCE_PATH");
  if (!resourcePath || resourcePath[0] == '\0') {
    return nullptr;
  }
  return resourcePath;
}

bool gfx_wr_use_optimized_shaders() {
  return mozilla::gfx::gfxVars::UseWebRenderOptimizedShaders();
}

void gfx_critical_note(const char* msg) { gfxCriticalNote << msg; }

void gfx_critical_error(const char* msg) { gfxCriticalError() << msg; }

void gecko_printf_stderr_output(const char* msg) { printf_stderr("%s\n", msg); }

void* get_proc_address_from_glcontext(void* glcontext_ptr,
                                      const char* procname) {
  mozilla::gl::GLContext* glcontext =
      reinterpret_cast<mozilla::gl::GLContext*>(glcontext_ptr);
  MOZ_ASSERT(glcontext);
  if (!glcontext) {
    return nullptr;
  }
  const auto& loader = glcontext->GetSymbolLoader();
  MOZ_ASSERT(loader);

  const auto ret = loader->GetProcAddress(procname);
  return reinterpret_cast<void*>(ret);
}

void gecko_profiler_register_thread(const char* name) {
  PROFILER_REGISTER_THREAD(name);
}

void gecko_profiler_unregister_thread() { PROFILER_UNREGISTER_THREAD(); }

void record_telemetry_time(mozilla::wr::TelemetryProbe aProbe,
                           uint64_t aTimeNs) {
  uint32_t time_ms = (uint32_t)(aTimeNs / 1000000);
  switch (aProbe) {
    case mozilla::wr::TelemetryProbe::SceneBuildTime:
      mozilla::Telemetry::Accumulate(mozilla::Telemetry::WR_SCENEBUILD_TIME,
                                     time_ms);
      break;
    case mozilla::wr::TelemetryProbe::SceneSwapTime:
      mozilla::Telemetry::Accumulate(mozilla::Telemetry::WR_SCENESWAP_TIME,
                                     time_ms);
      break;
    case mozilla::wr::TelemetryProbe::FrameBuildTime:
      mozilla::Telemetry::Accumulate(mozilla::Telemetry::WR_FRAMEBUILD_TIME,
                                     time_ms);
      break;
    default:
      MOZ_ASSERT(false);
      break;
  }
}

namespace mozilla {

namespace layers {

using namespace mozilla::gfx;

class ScheduleObserveLayersUpdate : public wr::NotificationHandler {
 public:
  ScheduleObserveLayersUpdate(RefPtr<CompositorBridgeParentBase> aBridge,
                              LayersId aLayersId, LayersObserverEpoch aEpoch,
                              bool aIsActive)
      : mBridge(aBridge),
        mLayersId(aLayersId),
        mObserverEpoch(aEpoch),
        mIsActive(aIsActive) {}

  void Notify(wr::Checkpoint) override {
    CompositorThread()->Dispatch(
        NewRunnableMethod<LayersId, LayersObserverEpoch, int>(
            "ObserveLayersUpdate", mBridge,
            &CompositorBridgeParentBase::ObserveLayersUpdate, mLayersId,
            mObserverEpoch, mIsActive));
  }

 protected:
  RefPtr<CompositorBridgeParentBase> mBridge;
  LayersId mLayersId;
  LayersObserverEpoch mObserverEpoch;
  bool mIsActive;
};

class SceneBuiltNotification : public wr::NotificationHandler {
 public:
  SceneBuiltNotification(WebRenderBridgeParent* aParent, wr::Epoch aEpoch,
                         TimeStamp aTxnStartTime)
      : mParent(aParent), mEpoch(aEpoch), mTxnStartTime(aTxnStartTime) {}

  void Notify(wr::Checkpoint) override {
    auto startTime = this->mTxnStartTime;
    RefPtr<WebRenderBridgeParent> parent = mParent;
    wr::Epoch epoch = mEpoch;
    CompositorThread()->Dispatch(NS_NewRunnableFunction(
        "SceneBuiltNotificationRunnable", [parent, epoch, startTime]() {
          auto endTime = TimeStamp::Now();
#ifdef MOZ_GECKO_PROFILER
          if (profiler_can_accept_markers()) {
            class ContentFullPaintPayload : public ProfilerMarkerPayload {
             public:
              ContentFullPaintPayload(const mozilla::TimeStamp& aStartTime,
                                      const mozilla::TimeStamp& aEndTime)
                  : ProfilerMarkerPayload(aStartTime, aEndTime) {}
              mozilla::ProfileBufferEntryWriter::Length
              TagAndSerializationBytes() const override {
                return CommonPropsTagAndSerializationBytes();
              }
              void SerializeTagAndPayload(mozilla::ProfileBufferEntryWriter&
                                              aEntryWriter) const override {
                static const DeserializerTag tag =
                    TagForDeserializer(Deserialize);
                SerializeTagAndCommonProps(tag, aEntryWriter);
              }
              void StreamPayload(SpliceableJSONWriter& aWriter,
                                 const TimeStamp& aProcessStartTime,
                                 UniqueStacks& aUniqueStacks) const override {
                StreamCommonProps("CONTENT_FULL_PAINT_TIME", aWriter,
                                  aProcessStartTime, aUniqueStacks);
              }

             private:
              explicit ContentFullPaintPayload(CommonProps&& aCommonProps)
                  : ProfilerMarkerPayload(std::move(aCommonProps)) {}
              static mozilla::UniquePtr<ProfilerMarkerPayload> Deserialize(
                  mozilla::ProfileBufferEntryReader& aEntryReader) {
                ProfilerMarkerPayload::CommonProps props =
                    DeserializeCommonProps(aEntryReader);
                return UniquePtr<ProfilerMarkerPayload>(
                    new ContentFullPaintPayload(std::move(props)));
              }
            };

            AUTO_PROFILER_STATS(add_marker_with_ContentFullPaintPayload);
            profiler_add_marker_for_thread(
                profiler_current_thread_id(),
                JS::ProfilingCategoryPair::GRAPHICS, "CONTENT_FULL_PAINT_TIME",
                ContentFullPaintPayload(startTime, endTime));
          }
#endif
          Telemetry::Accumulate(
              Telemetry::CONTENT_FULL_PAINT_TIME,
              static_cast<uint32_t>((endTime - startTime).ToMilliseconds()));
          parent->NotifySceneBuiltForEpoch(epoch, endTime);
        }));
  }

 protected:
  RefPtr<WebRenderBridgeParent> mParent;
  wr::Epoch mEpoch;
  TimeStamp mTxnStartTime;
};

class WebRenderBridgeParent::ScheduleSharedSurfaceRelease final
    : public wr::NotificationHandler {
 public:
  explicit ScheduleSharedSurfaceRelease(WebRenderBridgeParent* aWrBridge)
      : mWrBridge(aWrBridge), mSurfaces(20) {}

  void Add(const wr::ImageKey& aKey, const wr::ExternalImageId& aId) {
    mSurfaces.AppendElement(wr::ExternalImageKeyPair{aKey, aId});
  }

  void Notify(wr::Checkpoint) override {
    CompositorThread()->Dispatch(
        NewRunnableMethod<nsTArray<wr::ExternalImageKeyPair>>(
            "ObserveSharedSurfaceRelease", mWrBridge,
            &WebRenderBridgeParent::ObserveSharedSurfaceRelease,
            std::move(mSurfaces)));
  }

 private:
  RefPtr<WebRenderBridgeParent> mWrBridge;
  nsTArray<wr::ExternalImageKeyPair> mSurfaces;
};

class MOZ_STACK_CLASS AutoWebRenderBridgeParentAsyncMessageSender final {
 public:
  explicit AutoWebRenderBridgeParentAsyncMessageSender(
      WebRenderBridgeParent* aWebRenderBridgeParent,
      nsTArray<OpDestroy>* aDestroyActors = nullptr)
      : mWebRenderBridgeParent(aWebRenderBridgeParent),
        mActorsToDestroy(aDestroyActors) {
    mWebRenderBridgeParent->SetAboutToSendAsyncMessages();
  }

  ~AutoWebRenderBridgeParentAsyncMessageSender() {
    mWebRenderBridgeParent->SendPendingAsyncMessages();
    if (mActorsToDestroy) {
      // Destroy the actors after sending the async messages because the latter
      // may contain references to some actors.
      for (const auto& op : *mActorsToDestroy) {
        mWebRenderBridgeParent->DestroyActor(op);
      }
    }
  }

 private:
  WebRenderBridgeParent* mWebRenderBridgeParent;
  nsTArray<OpDestroy>* mActorsToDestroy;
};

WebRenderBridgeParent::WebRenderBridgeParent(
    CompositorBridgeParentBase* aCompositorBridge,
    const wr::PipelineId& aPipelineId, widget::CompositorWidget* aWidget,
    CompositorVsyncScheduler* aScheduler, RefPtr<wr::WebRenderAPI>&& aApi,
    RefPtr<AsyncImagePipelineManager>&& aImageMgr,
    RefPtr<CompositorAnimationStorage>&& aAnimStorage, TimeDuration aVsyncRate)
    : mCompositorBridge(aCompositorBridge),
      mPipelineId(aPipelineId),
      mWidget(aWidget),
      mApi(aApi),
      mAsyncImageManager(aImageMgr),
      mCompositorScheduler(aScheduler),
      mAnimStorage(aAnimStorage),
      mVsyncRate(aVsyncRate),
      mChildLayersObserverEpoch{0},
      mParentLayersObserverEpoch{0},
      mWrEpoch{0},
      mIdNamespace(aApi->GetNamespace()),
#if defined(MOZ_WIDGET_ANDROID)
      mScreenPixelsTarget(nullptr),
#endif
      mPaused(false),
      mDestroyed(false),
      mReceivedDisplayList(false),
      mIsFirstPaint(true),
      mSkippedComposite(false),
      mDisablingNativeCompositor(false),
      mPendingScrollPayloads("WebRenderBridgeParent::mPendingScrollPayloads") {
  MOZ_ASSERT(mAsyncImageManager);
  MOZ_ASSERT(mAnimStorage);
  mAsyncImageManager->AddPipeline(mPipelineId, this);
  if (IsRootWebRenderBridgeParent()) {
    MOZ_ASSERT(!mCompositorScheduler);
    mCompositorScheduler = new CompositorVsyncScheduler(this, mWidget);
  }

  UpdateDebugFlags();
  UpdateQualitySettings();
}

WebRenderBridgeParent::WebRenderBridgeParent(const wr::PipelineId& aPipelineId)
    : mCompositorBridge(nullptr),
      mPipelineId(aPipelineId),
      mChildLayersObserverEpoch{0},
      mParentLayersObserverEpoch{0},
      mWrEpoch{0},
      mIdNamespace{0},
      mPaused(false),
      mDestroyed(true),
      mReceivedDisplayList(false),
      mIsFirstPaint(false),
      mSkippedComposite(false),
      mDisablingNativeCompositor(false),
      mPendingScrollPayloads("WebRenderBridgeParent::mPendingScrollPayloads") {}

WebRenderBridgeParent::~WebRenderBridgeParent() {}

/* static */
WebRenderBridgeParent* WebRenderBridgeParent::CreateDestroyed(
    const wr::PipelineId& aPipelineId) {
  return new WebRenderBridgeParent(aPipelineId);
}

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvEnsureConnected(
    TextureFactoryIdentifier* aTextureFactoryIdentifier,
    MaybeIdNamespace* aMaybeIdNamespace) {
  if (mDestroyed) {
    *aTextureFactoryIdentifier =
        TextureFactoryIdentifier(LayersBackend::LAYERS_NONE);
    *aMaybeIdNamespace = Nothing();
    return IPC_OK();
  }

  MOZ_ASSERT(mIdNamespace.mHandle != 0);
  *aTextureFactoryIdentifier = GetTextureFactoryIdentifier();
  *aMaybeIdNamespace = Some(mIdNamespace);

  return IPC_OK();
}

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvShutdown() {
  return HandleShutdown();
}

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvShutdownSync() {
  return HandleShutdown();
}

mozilla::ipc::IPCResult WebRenderBridgeParent::HandleShutdown() {
  Destroy();
  IProtocol* mgr = Manager();
  if (!Send__delete__(this)) {
    return IPC_FAIL_NO_REASON(mgr);
  }
  return IPC_OK();
}

void WebRenderBridgeParent::Destroy() {
  if (mDestroyed) {
    return;
  }
  mDestroyed = true;
  ClearResources();
}

struct WROTSAlloc {
  wr::Vec<uint8_t> mVec;

  void* Grow(void* aPtr, size_t aLength) {
    if (aLength > mVec.Capacity()) {
      mVec.Reserve(aLength - mVec.Capacity());
    }
    return mVec.inner.data;
  }
  wr::Vec<uint8_t> ShrinkToFit(void* aPtr, size_t aLength) {
    wr::Vec<uint8_t> result(std::move(mVec));
    result.inner.length = aLength;
    return result;
  }
  void Free(void* aPtr) {}
};

static bool ReadRawFont(const OpAddRawFont& aOp, wr::ShmSegmentsReader& aReader,
                        wr::TransactionBuilder& aUpdates) {
#ifdef NIGHTLY_BUILD
  wr::Vec<uint8_t> sourceBytes;
  Maybe<Range<uint8_t>> ptr =
      aReader.GetReadPointerOrCopy(aOp.bytes(), sourceBytes);
  if (ptr.isNothing()) {
    return false;
  }
  Range<uint8_t>& source = ptr.ref();
  // Attempt to sanitize the font before passing it along for updating.
  // Ensure that we're not strict here about font types, since any font that
  // failed generating a descriptor might end up here as raw font data.
  size_t lengthHint = gfxOTSContext::GuessSanitizedFontSize(
      source.begin().get(), source.length(), false);
  if (!lengthHint) {
    gfxCriticalNote << "Could not determine font type for sanitizing font "
                    << aOp.key().mHandle;
    return false;
  }
  gfxOTSExpandingMemoryStream<WROTSAlloc> output(lengthHint);
  gfxOTSContext otsContext;
  if (!otsContext.Process(&output, source.begin().get(), source.length())) {
    gfxCriticalNote << "Failed sanitizing font " << aOp.key().mHandle;
    return false;
  }
  wr::Vec<uint8_t> bytes = output.forget();
#else
  wr::Vec<uint8_t> bytes;
  if (!aReader.Read(aOp.bytes(), bytes)) {
    return false;
  }
#endif

  aUpdates.AddRawFont(aOp.key(), bytes, aOp.fontIndex());
  return true;
}

bool WebRenderBridgeParent::UpdateResources(
    const nsTArray<OpUpdateResource>& aResourceUpdates,
    const nsTArray<RefCountedShmem>& aSmallShmems,
    const nsTArray<ipc::Shmem>& aLargeShmems,
    wr::TransactionBuilder& aUpdates) {
  wr::ShmSegmentsReader reader(aSmallShmems, aLargeShmems);
  UniquePtr<ScheduleSharedSurfaceRelease> scheduleRelease;

  for (const auto& cmd : aResourceUpdates) {
    switch (cmd.type()) {
      case OpUpdateResource::TOpAddImage: {
        const auto& op = cmd.get_OpAddImage();
        wr::Vec<uint8_t> bytes;
        if (!reader.Read(op.bytes(), bytes)) {
          return false;
        }
        aUpdates.AddImage(op.key(), op.descriptor(), bytes);
        break;
      }
      case OpUpdateResource::TOpUpdateImage: {
        const auto& op = cmd.get_OpUpdateImage();
        wr::Vec<uint8_t> bytes;
        if (!reader.Read(op.bytes(), bytes)) {
          return false;
        }
        aUpdates.UpdateImageBuffer(op.key(), op.descriptor(), bytes);
        break;
      }
      case OpUpdateResource::TOpAddBlobImage: {
        const auto& op = cmd.get_OpAddBlobImage();
        wr::Vec<uint8_t> bytes;
        if (!reader.Read(op.bytes(), bytes)) {
          return false;
        }
        aUpdates.AddBlobImage(op.key(), op.descriptor(), bytes,
                              wr::ToDeviceIntRect(op.visibleRect()));
        break;
      }
      case OpUpdateResource::TOpUpdateBlobImage: {
        const auto& op = cmd.get_OpUpdateBlobImage();
        wr::Vec<uint8_t> bytes;
        if (!reader.Read(op.bytes(), bytes)) {
          return false;
        }
        aUpdates.UpdateBlobImage(op.key(), op.descriptor(), bytes,
                                 wr::ToDeviceIntRect(op.visibleRect()),
                                 wr::ToLayoutIntRect(op.dirtyRect()));
        break;
      }
      case OpUpdateResource::TOpSetBlobImageVisibleArea: {
        const auto& op = cmd.get_OpSetBlobImageVisibleArea();
        aUpdates.SetBlobImageVisibleArea(op.key(),
                                         wr::ToDeviceIntRect(op.area()));
        break;
      }
      case OpUpdateResource::TOpAddPrivateExternalImage: {
        const auto& op = cmd.get_OpAddPrivateExternalImage();
        if (!AddPrivateExternalImage(op.externalImageId(), op.key(),
                                     op.descriptor(), aUpdates)) {
          return false;
        }
        break;
      }
      case OpUpdateResource::TOpAddSharedExternalImage: {
        const auto& op = cmd.get_OpAddSharedExternalImage();
        if (!AddSharedExternalImage(op.externalImageId(), op.key(), aUpdates)) {
          return false;
        }
        break;
      }
      case OpUpdateResource::TOpPushExternalImageForTexture: {
        const auto& op = cmd.get_OpPushExternalImageForTexture();
        CompositableTextureHostRef texture;
        texture = TextureHost::AsTextureHost(op.textureParent());
        if (!PushExternalImageForTexture(op.externalImageId(), op.key(),
                                         texture, op.isUpdate(), aUpdates)) {
          return false;
        }
        break;
      }
      case OpUpdateResource::TOpUpdatePrivateExternalImage: {
        const auto& op = cmd.get_OpUpdatePrivateExternalImage();
        if (!UpdatePrivateExternalImage(op.externalImageId(), op.key(),
                                        op.descriptor(), op.dirtyRect(),
                                        aUpdates)) {
          return false;
        }
        break;
      }
      case OpUpdateResource::TOpUpdateSharedExternalImage: {
        const auto& op = cmd.get_OpUpdateSharedExternalImage();
        if (!UpdateSharedExternalImage(op.externalImageId(), op.key(),
                                       op.dirtyRect(), aUpdates,
                                       scheduleRelease)) {
          return false;
        }
        break;
      }
      case OpUpdateResource::TOpAddRawFont: {
        if (!ReadRawFont(cmd.get_OpAddRawFont(), reader, aUpdates)) {
          return false;
        }
        break;
      }
      case OpUpdateResource::TOpAddFontDescriptor: {
        const auto& op = cmd.get_OpAddFontDescriptor();
        wr::Vec<uint8_t> bytes;
        if (!reader.Read(op.bytes(), bytes)) {
          return false;
        }
        aUpdates.AddFontDescriptor(op.key(), bytes, op.fontIndex());
        break;
      }
      case OpUpdateResource::TOpAddFontInstance: {
        const auto& op = cmd.get_OpAddFontInstance();
        wr::Vec<uint8_t> variations;
        if (!reader.Read(op.variations(), variations)) {
          return false;
        }
        aUpdates.AddFontInstance(op.instanceKey(), op.fontKey(), op.glyphSize(),
                                 op.options().ptrOr(nullptr),
                                 op.platformOptions().ptrOr(nullptr),
                                 variations);
        break;
      }
      case OpUpdateResource::TOpDeleteImage: {
        const auto& op = cmd.get_OpDeleteImage();
        DeleteImage(op.key(), aUpdates);
        break;
      }
      case OpUpdateResource::TOpDeleteBlobImage: {
        const auto& op = cmd.get_OpDeleteBlobImage();
        aUpdates.DeleteBlobImage(op.key());
        break;
      }
      case OpUpdateResource::TOpDeleteFont: {
        const auto& op = cmd.get_OpDeleteFont();
        aUpdates.DeleteFont(op.key());
        break;
      }
      case OpUpdateResource::TOpDeleteFontInstance: {
        const auto& op = cmd.get_OpDeleteFontInstance();
        aUpdates.DeleteFontInstance(op.key());
        break;
      }
      case OpUpdateResource::T__None:
        break;
    }
  }

  if (scheduleRelease) {
    aUpdates.Notify(wr::Checkpoint::FrameTexturesUpdated,
                    std::move(scheduleRelease));
  }
  return true;
}

bool WebRenderBridgeParent::AddPrivateExternalImage(
    wr::ExternalImageId aExtId, wr::ImageKey aKey, wr::ImageDescriptor aDesc,
    wr::TransactionBuilder& aResources) {
  Range<wr::ImageKey> keys(&aKey, 1);
  // Check if key is obsoleted.
  if (keys[0].mNamespace != mIdNamespace) {
    return true;
  }

  aResources.AddExternalImage(aKey, aDesc, aExtId,
                              wr::ExternalImageType::Buffer(), 0);

  return true;
}

bool WebRenderBridgeParent::UpdatePrivateExternalImage(
    wr::ExternalImageId aExtId, wr::ImageKey aKey,
    const wr::ImageDescriptor& aDesc, const ImageIntRect& aDirtyRect,
    wr::TransactionBuilder& aResources) {
  Range<wr::ImageKey> keys(&aKey, 1);
  // Check if key is obsoleted.
  if (keys[0].mNamespace != mIdNamespace) {
    return true;
  }

  aResources.UpdateExternalImageWithDirtyRect(
      aKey, aDesc, aExtId, wr::ExternalImageType::Buffer(),
      wr::ToDeviceIntRect(aDirtyRect), 0);

  return true;
}

bool WebRenderBridgeParent::AddSharedExternalImage(
    wr::ExternalImageId aExtId, wr::ImageKey aKey,
    wr::TransactionBuilder& aResources) {
  Range<wr::ImageKey> keys(&aKey, 1);
  // Check if key is obsoleted.
  if (keys[0].mNamespace != mIdNamespace) {
    return true;
  }

  auto key = wr::AsUint64(aKey);
  auto it = mSharedSurfaceIds.find(key);
  if (it != mSharedSurfaceIds.end()) {
    gfxCriticalNote << "Readding known shared surface: " << key;
    return false;
  }

  RefPtr<DataSourceSurface> dSurf = SharedSurfacesParent::Acquire(aExtId);
  if (!dSurf) {
    gfxCriticalNote
        << "DataSourceSurface of SharedSurfaces does not exist for extId:"
        << wr::AsUint64(aExtId);
    return false;
  }

  mSharedSurfaceIds.insert(std::make_pair(key, aExtId));

  wr::ImageDescriptor descriptor(dSurf->GetSize(), dSurf->Stride(),
                                 dSurf->GetFormat());
  aResources.AddExternalImage(aKey, descriptor, aExtId,
                              wr::ExternalImageType::Buffer(), 0);
  return true;
}

bool WebRenderBridgeParent::PushExternalImageForTexture(
    wr::ExternalImageId aExtId, wr::ImageKey aKey, TextureHost* aTexture,
    bool aIsUpdate, wr::TransactionBuilder& aResources) {
  auto op = aIsUpdate ? TextureHost::UPDATE_IMAGE : TextureHost::ADD_IMAGE;
  Range<wr::ImageKey> keys(&aKey, 1);
  // Check if key is obsoleted.
  if (keys[0].mNamespace != mIdNamespace) {
    return true;
  }

  if (!aTexture) {
    gfxCriticalNote << "TextureHost does not exist for extId:"
                    << wr::AsUint64(aExtId);
    return false;
  }

  WebRenderTextureHost* wrTexture = aTexture->AsWebRenderTextureHost();
  if (wrTexture) {
    wrTexture->PushResourceUpdates(aResources, op, keys,
                                   wrTexture->GetExternalImageKey());
    auto it = mTextureHosts.find(wr::AsUint64(aKey));
    MOZ_ASSERT((it == mTextureHosts.end() && !aIsUpdate) ||
               (it != mTextureHosts.end() && aIsUpdate));
    if (it != mTextureHosts.end()) {
      // Release Texture if it exists.
      ReleaseTextureOfImage(aKey);
    }
    mTextureHosts.emplace(wr::AsUint64(aKey),
                          CompositableTextureHostRef(aTexture));
    return true;
  }

  RefPtr<DataSourceSurface> dSurf = aTexture->GetAsSurface();
  if (!dSurf) {
    gfxCriticalNote
        << "TextureHost does not return DataSourceSurface for extId:"
        << wr::AsUint64(aExtId);
    return false;
  }

  DataSourceSurface::MappedSurface map;
  if (!dSurf->Map(gfx::DataSourceSurface::MapType::READ, &map)) {
    gfxCriticalNote << "DataSourceSurface failed to map for Image for extId:"
                    << wr::AsUint64(aExtId);
    return false;
  }

  IntSize size = dSurf->GetSize();
  wr::ImageDescriptor descriptor(size, map.mStride, dSurf->GetFormat());
  wr::Vec<uint8_t> data;
  data.PushBytes(Range<uint8_t>(map.mData, size.height * map.mStride));

  if (op == TextureHost::UPDATE_IMAGE) {
    aResources.UpdateImageBuffer(keys[0], descriptor, data);
  } else {
    aResources.AddImage(keys[0], descriptor, data);
  }

  dSurf->Unmap();

  return true;
}

bool WebRenderBridgeParent::UpdateSharedExternalImage(
    wr::ExternalImageId aExtId, wr::ImageKey aKey,
    const ImageIntRect& aDirtyRect, wr::TransactionBuilder& aResources,
    UniquePtr<ScheduleSharedSurfaceRelease>& aScheduleRelease) {
  Range<wr::ImageKey> keys(&aKey, 1);
  // Check if key is obsoleted.
  if (keys[0].mNamespace != mIdNamespace) {
    return true;
  }

  auto key = wr::AsUint64(aKey);
  auto it = mSharedSurfaceIds.find(key);
  if (it == mSharedSurfaceIds.end()) {
    gfxCriticalNote << "Updating unknown shared surface: " << key;
    return false;
  }

  RefPtr<DataSourceSurface> dSurf;
  if (it->second == aExtId) {
    dSurf = SharedSurfacesParent::Get(aExtId);
  } else {
    dSurf = SharedSurfacesParent::Acquire(aExtId);
  }

  if (!dSurf) {
    gfxCriticalNote << "Shared surface does not exist for extId:"
                    << wr::AsUint64(aExtId);
    return false;
  }

  if (!(it->second == aExtId)) {
    // We already have a mapping for this image key, so ensure we release the
    // previous external image ID. This can happen when an image is animated,
    // and it is changing the external image that the animation points to.
    if (!aScheduleRelease) {
      aScheduleRelease = MakeUnique<ScheduleSharedSurfaceRelease>(this);
    }
    aScheduleRelease->Add(aKey, it->second);
    it->second = aExtId;
  }

  wr::ImageDescriptor descriptor(dSurf->GetSize(), dSurf->Stride(),
                                 dSurf->GetFormat());
  aResources.UpdateExternalImageWithDirtyRect(
      aKey, descriptor, aExtId, wr::ExternalImageType::Buffer(),
      wr::ToDeviceIntRect(aDirtyRect), 0);

  return true;
}

void WebRenderBridgeParent::ObserveSharedSurfaceRelease(
    const nsTArray<wr::ExternalImageKeyPair>& aPairs) {
  if (!mDestroyed) {
    Unused << SendWrReleasedImages(aPairs);
  }
  for (const auto& pair : aPairs) {
    SharedSurfacesParent::Release(pair.id);
  }
}

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvUpdateResources(
    nsTArray<OpUpdateResource>&& aResourceUpdates,
    nsTArray<RefCountedShmem>&& aSmallShmems,
    nsTArray<ipc::Shmem>&& aLargeShmems) {
  if (mDestroyed) {
    wr::IpcResourceUpdateQueue::ReleaseShmems(this, aSmallShmems);
    wr::IpcResourceUpdateQueue::ReleaseShmems(this, aLargeShmems);
    return IPC_OK();
  }

  wr::TransactionBuilder txn;
  txn.SetLowPriority(!IsRootWebRenderBridgeParent());

  bool success =
      UpdateResources(aResourceUpdates, aSmallShmems, aLargeShmems, txn);
  wr::IpcResourceUpdateQueue::ReleaseShmems(this, aSmallShmems);
  wr::IpcResourceUpdateQueue::ReleaseShmems(this, aLargeShmems);

  if (!success) {
    return IPC_FAIL(this, "Invalid WebRender resource data shmem or address.");
  }

  mApi->SendTransaction(txn);

  return IPC_OK();
}

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvDeleteCompositorAnimations(
    nsTArray<uint64_t>&& aIds) {
  if (mDestroyed) {
    return IPC_OK();
  }

  // Once mWrEpoch has been rendered, we can delete these compositor animations
  mCompositorAnimationsToDelete.push(
      CompositorAnimationIdsForEpoch(mWrEpoch, std::move(aIds)));
  return IPC_OK();
}

void WebRenderBridgeParent::RemoveEpochDataPriorTo(
    const wr::Epoch& aRenderedEpoch) {
  while (!mCompositorAnimationsToDelete.empty()) {
    if (aRenderedEpoch < mCompositorAnimationsToDelete.front().mEpoch) {
      break;
    }
    for (uint64_t id : mCompositorAnimationsToDelete.front().mIds) {
      const auto activeAnim = mActiveAnimations.find(id);
      if (activeAnim == mActiveAnimations.end()) {
        NS_ERROR("Tried to delete invalid animation");
        continue;
      }
      // Check if animation delete request is still valid.
      if (activeAnim->second <= mCompositorAnimationsToDelete.front().mEpoch) {
        mAnimStorage->ClearById(id);
        mActiveAnimations.erase(activeAnim);
      }
    }
    mCompositorAnimationsToDelete.pop();
  }
}

bool WebRenderBridgeParent::IsRootWebRenderBridgeParent() const {
  return !!mWidget;
}

void WebRenderBridgeParent::SetCompositionRecorder(
    UniquePtr<layers::WebRenderCompositionRecorder> aRecorder) {
  mApi->SetCompositionRecorder(std::move(aRecorder));
}

RefPtr<wr::WebRenderAPI::WriteCollectedFramesPromise>
WebRenderBridgeParent::WriteCollectedFrames() {
  return mApi->WriteCollectedFrames();
}

RefPtr<wr::WebRenderAPI::GetCollectedFramesPromise>
WebRenderBridgeParent::GetCollectedFrames() {
  return mApi->GetCollectedFrames();
}

void WebRenderBridgeParent::AddPendingScrollPayload(
    CompositionPayload& aPayload,
    const std::pair<wr::PipelineId, wr::Epoch>& aKey) {
  auto pendingScrollPayloads = mPendingScrollPayloads.Lock();
  nsTArray<CompositionPayload>* payloads =
      pendingScrollPayloads->LookupOrAdd(aKey);

  payloads->AppendElement(aPayload);
}

nsTArray<CompositionPayload> WebRenderBridgeParent::TakePendingScrollPayload(
    const std::pair<wr::PipelineId, wr::Epoch>& aKey) {
  auto pendingScrollPayloads = mPendingScrollPayloads.Lock();
  nsTArray<CompositionPayload> payload;
  if (nsTArray<CompositionPayload>* storedPayload =
          pendingScrollPayloads->Get(aKey)) {
    payload.AppendElements(std::move(*storedPayload));
    pendingScrollPayloads->Remove(aKey);
  }
  return payload;
}

CompositorBridgeParent* WebRenderBridgeParent::GetRootCompositorBridgeParent()
    const {
  if (!mCompositorBridge) {
    return nullptr;
  }

  if (IsRootWebRenderBridgeParent()) {
    // This WebRenderBridgeParent is attached to the root
    // CompositorBridgeParent.
    return static_cast<CompositorBridgeParent*>(mCompositorBridge);
  }

  // Otherwise, this WebRenderBridgeParent is attached to a
  // ContentCompositorBridgeParent so we have an extra level of
  // indirection to unravel.
  CompositorBridgeParent::LayerTreeState* lts =
      CompositorBridgeParent::GetIndirectShadowTree(GetLayersId());
  if (!lts) {
    return nullptr;
  }
  return lts->mParent;
}

RefPtr<WebRenderBridgeParent>
WebRenderBridgeParent::GetRootWebRenderBridgeParent() const {
  CompositorBridgeParent* cbp = GetRootCompositorBridgeParent();
  if (!cbp) {
    return nullptr;
  }

  return cbp->GetWebRenderBridgeParent();
}

void WebRenderBridgeParent::UpdateAPZFocusState(const FocusTarget& aFocus) {
  CompositorBridgeParent* cbp = GetRootCompositorBridgeParent();
  if (!cbp) {
    return;
  }
  LayersId rootLayersId = cbp->RootLayerTreeId();
  if (RefPtr<APZUpdater> apz = cbp->GetAPZUpdater()) {
    apz->UpdateFocusState(rootLayersId, GetLayersId(), aFocus);
  }
}

void WebRenderBridgeParent::UpdateAPZScrollData(const wr::Epoch& aEpoch,
                                                WebRenderScrollData&& aData) {
  CompositorBridgeParent* cbp = GetRootCompositorBridgeParent();
  if (!cbp) {
    return;
  }
  LayersId rootLayersId = cbp->RootLayerTreeId();
  if (RefPtr<APZUpdater> apz = cbp->GetAPZUpdater()) {
    apz->UpdateScrollDataAndTreeState(rootLayersId, GetLayersId(), aEpoch,
                                      std::move(aData));
  }
}

void WebRenderBridgeParent::UpdateAPZScrollOffsets(
    ScrollUpdatesMap&& aUpdates, uint32_t aPaintSequenceNumber) {
  CompositorBridgeParent* cbp = GetRootCompositorBridgeParent();
  if (!cbp) {
    return;
  }
  LayersId rootLayersId = cbp->RootLayerTreeId();
  if (RefPtr<APZUpdater> apz = cbp->GetAPZUpdater()) {
    apz->UpdateScrollOffsets(rootLayersId, GetLayersId(), std::move(aUpdates),
                             aPaintSequenceNumber);
  }
}

void WebRenderBridgeParent::SetAPZSampleTime() {
  CompositorBridgeParent* cbp = GetRootCompositorBridgeParent();
  if (!cbp) {
    return;
  }
  if (RefPtr<APZSampler> apz = cbp->GetAPZSampler()) {
    TimeStamp animationTime = cbp->GetTestingTimeStamp().valueOr(
        mCompositorScheduler->GetLastComposeTime());
    TimeDuration frameInterval = cbp->GetVsyncInterval();
    // As with the non-webrender codepath in AsyncCompositionManager, we want to
    // use the timestamp for the next vsync when advancing animations.
    if (frameInterval != TimeDuration::Forever()) {
      animationTime += frameInterval;
    }
    apz->SetSampleTime(animationTime);
  }
}

bool WebRenderBridgeParent::SetDisplayList(
    const LayoutDeviceRect& aRect, const wr::LayoutSize& aContentSize,
    ipc::ByteBuf&& aDL, const wr::BuiltDisplayListDescriptor& aDLDesc,
    const nsTArray<OpUpdateResource>& aResourceUpdates,
    const nsTArray<RefCountedShmem>& aSmallShmems,
    const nsTArray<ipc::Shmem>& aLargeShmems, const TimeStamp& aTxnStartTime,
    wr::TransactionBuilder& aTxn, wr::Epoch aWrEpoch, bool aValidTransaction,
    bool aObserveLayersUpdate) {
  if (NS_WARN_IF(!UpdateResources(aResourceUpdates, aSmallShmems, aLargeShmems,
                                  aTxn))) {
    return false;
  }

  wr::Vec<uint8_t> dlData(std::move(aDL));

  if (aValidTransaction) {
    if (IsRootWebRenderBridgeParent()) {
      LayoutDeviceIntSize widgetSize = mWidget->GetClientSize();
      LayoutDeviceIntRect rect =
          LayoutDeviceIntRect(LayoutDeviceIntPoint(), widgetSize);
      aTxn.SetDocumentView(rect);
    }
    gfx::DeviceColor clearColor(0.f, 0.f, 0.f, 0.f);
    aTxn.SetDisplayList(clearColor, aWrEpoch,
                        wr::ToLayoutSize(RoundedToInt(aRect).Size()),
                        mPipelineId, aContentSize, aDLDesc, dlData);

    if (aObserveLayersUpdate) {
      aTxn.Notify(wr::Checkpoint::SceneBuilt,
                  MakeUnique<ScheduleObserveLayersUpdate>(
                      mCompositorBridge, GetLayersId(),
                      mChildLayersObserverEpoch, true));
    }

    if (!IsRootWebRenderBridgeParent()) {
      aTxn.Notify(
          wr::Checkpoint::SceneBuilt,
          MakeUnique<SceneBuiltNotification>(this, aWrEpoch, aTxnStartTime));
    }

    mApi->SendTransaction(aTxn);

    // We will schedule generating a frame after the scene
    // build is done, so we don't need to do it here.
  }

  return true;
}

bool WebRenderBridgeParent::ProcessDisplayListData(
    DisplayListData& aDisplayList, wr::Epoch aWrEpoch,
    const TimeStamp& aTxnStartTime, bool aValidTransaction,
    bool aObserveLayersUpdate) {
  wr::TransactionBuilder txn;
  Maybe<wr::AutoTransactionSender> sender;

  // Note that this needs to happen before the display list transaction is
  // sent to WebRender, so that the UpdateHitTestingTree call is guaranteed to
  // be in the updater queue at the time that the scene swap completes.
  if (aDisplayList.mScrollData) {
    UpdateAPZScrollData(aWrEpoch, std::move(aDisplayList.mScrollData.ref()));
  }

  txn.SetLowPriority(!IsRootWebRenderBridgeParent());
  if (aValidTransaction) {
    MOZ_ASSERT(aDisplayList.mIdNamespace == mIdNamespace);
    sender.emplace(mApi, &txn);
  }

  if (NS_WARN_IF(
          !ProcessWebRenderParentCommands(aDisplayList.mCommands, txn))) {
    return false;
  }

  if (aDisplayList.mDL &&
      !SetDisplayList(aDisplayList.mRect, aDisplayList.mContentSize,
                      std::move(aDisplayList.mDL.ref()), aDisplayList.mDLDesc,
                      aDisplayList.mResourceUpdates, aDisplayList.mSmallShmems,
                      aDisplayList.mLargeShmems, aTxnStartTime, txn, aWrEpoch,
                      aValidTransaction, aObserveLayersUpdate)) {
    return false;
  }
  return true;
}

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvSetDisplayList(
    DisplayListData&& aDisplayList, nsTArray<OpDestroy>&& aToDestroy,
    const uint64_t& aFwdTransactionId, const TransactionId& aTransactionId,
    const bool& aContainsSVGGroup, const VsyncId& aVsyncId,
    const TimeStamp& aVsyncStartTime, const TimeStamp& aRefreshStartTime,
    const TimeStamp& aTxnStartTime, const nsCString& aTxnURL,
    const TimeStamp& aFwdTime, nsTArray<CompositionPayload>&& aPayloads) {
  if (mDestroyed) {
    for (const auto& op : aToDestroy) {
      DestroyActor(op);
    }
    return IPC_OK();
  }

  if (!IsRootWebRenderBridgeParent()) {
    CrashReporter::AnnotateCrashReport(CrashReporter::Annotation::URL, aTxnURL);
  }

  AUTO_PROFILER_TRACING_MARKER("Paint", "SetDisplayList", GRAPHICS);
  UpdateFwdTransactionId(aFwdTransactionId);

  // This ensures that destroy operations are always processed. It is not safe
  // to early-return from RecvDPEnd without doing so.
  AutoWebRenderBridgeParentAsyncMessageSender autoAsyncMessageSender(
      this, &aToDestroy);

  wr::Epoch wrEpoch = GetNextWrEpoch();

  mAsyncImageManager->SetCompositionTime(TimeStamp::Now());

  mReceivedDisplayList = true;

  if (aDisplayList.mScrollData && aDisplayList.mScrollData->IsFirstPaint()) {
    mIsFirstPaint = true;
  }

  bool validTransaction = aDisplayList.mIdNamespace == mIdNamespace;
  bool observeLayersUpdate = ShouldParentObserveEpoch();

  if (!ProcessDisplayListData(aDisplayList, wrEpoch, aTxnStartTime,
                              validTransaction, observeLayersUpdate)) {
    return IPC_FAIL(this, "Failed to process DisplayListData.");
  }

  if (!validTransaction && observeLayersUpdate) {
    mCompositorBridge->ObserveLayersUpdate(GetLayersId(),
                                           mChildLayersObserverEpoch, true);
  }

  if (!IsRootWebRenderBridgeParent()) {
    aPayloads.AppendElement(
        CompositionPayload{CompositionPayloadType::eContentPaint, aFwdTime});
  }

  HoldPendingTransactionId(wrEpoch, aTransactionId, aContainsSVGGroup, aVsyncId,
                           aVsyncStartTime, aRefreshStartTime, aTxnStartTime,
                           aTxnURL, aFwdTime, mIsFirstPaint,
                           std::move(aPayloads));
  mIsFirstPaint = false;

  if (!validTransaction) {
    // Pretend we composited since someone is wating for this event,
    // though DisplayList was not pushed to webrender.
    if (CompositorBridgeParent* cbp = GetRootCompositorBridgeParent()) {
      TimeStamp now = TimeStamp::Now();
      cbp->NotifyPipelineRendered(mPipelineId, wrEpoch, VsyncId(), now, now,
                                  now);
    }
  }

  wr::IpcResourceUpdateQueue::ReleaseShmems(this, aDisplayList.mSmallShmems);
  wr::IpcResourceUpdateQueue::ReleaseShmems(this, aDisplayList.mLargeShmems);

  return IPC_OK();
}

bool WebRenderBridgeParent::ProcessEmptyTransactionUpdates(
    TransactionData& aData, bool* aScheduleComposite) {
  *aScheduleComposite = false;
  wr::TransactionBuilder txn;
  txn.SetLowPriority(!IsRootWebRenderBridgeParent());

  if (!aData.mScrollUpdates.IsEmpty()) {
    UpdateAPZScrollOffsets(std::move(aData.mScrollUpdates),
                           aData.mPaintSequenceNumber);
  }

  // Update WrEpoch for UpdateResources() and ProcessWebRenderParentCommands().
  // WrEpoch is used to manage ExternalImages lifetimes in
  // AsyncImagePipelineManager.
  Unused << GetNextWrEpoch();

  if (!UpdateResources(aData.mResourceUpdates, aData.mSmallShmems,
                       aData.mLargeShmems, txn)) {
    return false;
  }

  if (!aData.mCommands.IsEmpty()) {
    mAsyncImageManager->SetCompositionTime(TimeStamp::Now());
    if (!ProcessWebRenderParentCommands(aData.mCommands, txn)) {
      return false;
    }
  }

  if (ShouldParentObserveEpoch()) {
    txn.Notify(
        wr::Checkpoint::SceneBuilt,
        MakeUnique<ScheduleObserveLayersUpdate>(
            mCompositorBridge, GetLayersId(), mChildLayersObserverEpoch, true));
  }

  // Even when txn.IsResourceUpdatesEmpty() is true, there could be resource
  // updates. It is handled by WebRenderTextureHostWrapper. In this case
  // txn.IsRenderedFrameInvalidated() becomes true.
  if (!txn.IsResourceUpdatesEmpty() || txn.IsRenderedFrameInvalidated()) {
    // There are resource updates, then we update Epoch of transaction.
    txn.UpdateEpoch(mPipelineId, mWrEpoch);
    *aScheduleComposite = true;
  } else {
    // If TransactionBuilder does not have resource updates nor display list,
    // ScheduleGenerateFrame is not triggered via SceneBuilder and there is no
    // need to update WrEpoch.
    // Then we want to rollback WrEpoch. See Bug 1490117.
    RollbackWrEpoch();
  }

  if (!txn.IsEmpty()) {
    mApi->SendTransaction(txn);
  }

  if (*aScheduleComposite) {
    mAsyncImageManager->SetWillGenerateFrame();
  }

  return true;
}

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvEmptyTransaction(
    const FocusTarget& aFocusTarget, Maybe<TransactionData>&& aTransactionData,
    nsTArray<OpDestroy>&& aToDestroy, const uint64_t& aFwdTransactionId,
    const TransactionId& aTransactionId, const VsyncId& aVsyncId,
    const TimeStamp& aVsyncStartTime, const TimeStamp& aRefreshStartTime,
    const TimeStamp& aTxnStartTime, const nsCString& aTxnURL,
    const TimeStamp& aFwdTime, nsTArray<CompositionPayload>&& aPayloads) {
  if (mDestroyed) {
    for (const auto& op : aToDestroy) {
      DestroyActor(op);
    }
    return IPC_OK();
  }

  if (!IsRootWebRenderBridgeParent()) {
    CrashReporter::AnnotateCrashReport(CrashReporter::Annotation::URL, aTxnURL);
  }

  AUTO_PROFILER_TRACING_MARKER("Paint", "EmptyTransaction", GRAPHICS);
  UpdateFwdTransactionId(aFwdTransactionId);

  // This ensures that destroy operations are always processed. It is not safe
  // to early-return without doing so.
  AutoWebRenderBridgeParentAsyncMessageSender autoAsyncMessageSender(
      this, &aToDestroy);

  UpdateAPZFocusState(aFocusTarget);

  bool scheduleAnyComposite = false;

  if (aTransactionData) {
    bool scheduleComposite = false;
    if (!ProcessEmptyTransactionUpdates(*aTransactionData,
                                        &scheduleComposite)) {
      return IPC_FAIL(this, "Failed to process empty transaction update.");
    }
    scheduleAnyComposite = scheduleAnyComposite || scheduleComposite;
  }

  // If we are going to kick off a new composite as a result of this
  // transaction, or if there are already composite-triggering pending
  // transactions inflight, then set sendDidComposite to false because we will
  // send the DidComposite message after the composite occurs.
  // If there are no pending transactions and we're not going to do a
  // composite, then we leave sendDidComposite as true so we just send
  // the DidComposite notification now.
  bool sendDidComposite =
      !scheduleAnyComposite && mPendingTransactionIds.empty();

  // Only register a value for CONTENT_FRAME_TIME telemetry if we actually drew
  // something. It is for consistency with disabling WebRender.
  HoldPendingTransactionId(mWrEpoch, aTransactionId, false, aVsyncId,
                           aVsyncStartTime, aRefreshStartTime, aTxnStartTime,
                           aTxnURL, aFwdTime,
                           /* aIsFirstPaint */ false, std::move(aPayloads),
                           /* aUseForTelemetry */ scheduleAnyComposite);

  if (scheduleAnyComposite) {
    ScheduleGenerateFrame();
  } else if (sendDidComposite) {
    // The only thing in the pending transaction id queue should be the entry
    // we just added, and now we're going to pretend we rendered it
    MOZ_ASSERT(mPendingTransactionIds.size() == 1);
    if (CompositorBridgeParent* cbp = GetRootCompositorBridgeParent()) {
      TimeStamp now = TimeStamp::Now();
      cbp->NotifyPipelineRendered(mPipelineId, mWrEpoch, VsyncId(), now, now,
                                  now);
    }
  }

  if (aTransactionData) {
    wr::IpcResourceUpdateQueue::ReleaseShmems(this,
                                              aTransactionData->mSmallShmems);
    wr::IpcResourceUpdateQueue::ReleaseShmems(this,
                                              aTransactionData->mLargeShmems);
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvSetFocusTarget(
    const FocusTarget& aFocusTarget) {
  UpdateAPZFocusState(aFocusTarget);
  return IPC_OK();
}

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvParentCommands(
    nsTArray<WebRenderParentCommand>&& aCommands) {
  if (mDestroyed) {
    return IPC_OK();
  }

  wr::TransactionBuilder txn;
  txn.SetLowPriority(!IsRootWebRenderBridgeParent());
  if (!ProcessWebRenderParentCommands(aCommands, txn)) {
    return IPC_FAIL(this, "Invalid parent command found");
  }

  mApi->SendTransaction(txn);
  return IPC_OK();
}

bool WebRenderBridgeParent::ProcessWebRenderParentCommands(
    const nsTArray<WebRenderParentCommand>& aCommands,
    wr::TransactionBuilder& aTxn) {
  // Transaction for async image pipeline that uses ImageBridge always need to
  // be non low priority.
  wr::TransactionBuilder txnForImageBridge;
  wr::AutoTransactionSender sender(mApi, &txnForImageBridge);

  for (nsTArray<WebRenderParentCommand>::index_type i = 0;
       i < aCommands.Length(); ++i) {
    const WebRenderParentCommand& cmd = aCommands[i];
    switch (cmd.type()) {
      case WebRenderParentCommand::TOpAddPipelineIdForCompositable: {
        const OpAddPipelineIdForCompositable& op =
            cmd.get_OpAddPipelineIdForCompositable();
        AddPipelineIdForCompositable(op.pipelineId(), op.handle(), op.isAsync(),
                                     aTxn, txnForImageBridge);
        break;
      }
      case WebRenderParentCommand::TOpRemovePipelineIdForCompositable: {
        const OpRemovePipelineIdForCompositable& op =
            cmd.get_OpRemovePipelineIdForCompositable();
        RemovePipelineIdForCompositable(op.pipelineId(), aTxn);
        break;
      }
      case WebRenderParentCommand::TOpReleaseTextureOfImage: {
        const OpReleaseTextureOfImage& op = cmd.get_OpReleaseTextureOfImage();
        ReleaseTextureOfImage(op.key());
        break;
      }
      case WebRenderParentCommand::TOpUpdateAsyncImagePipeline: {
        const OpUpdateAsyncImagePipeline& op =
            cmd.get_OpUpdateAsyncImagePipeline();
        mAsyncImageManager->UpdateAsyncImagePipeline(
            op.pipelineId(), op.scBounds(), op.scTransform(), op.scaleToSize(),
            op.filter(), op.mixBlendMode());
        mAsyncImageManager->ApplyAsyncImageForPipeline(op.pipelineId(), aTxn,
                                                       txnForImageBridge);
        break;
      }
      case WebRenderParentCommand::TOpUpdatedAsyncImagePipeline: {
        const OpUpdatedAsyncImagePipeline& op =
            cmd.get_OpUpdatedAsyncImagePipeline();
        aTxn.InvalidateRenderedFrame();
        mAsyncImageManager->ApplyAsyncImageForPipeline(op.pipelineId(), aTxn,
                                                       txnForImageBridge);
        break;
      }
      case WebRenderParentCommand::TCompositableOperation: {
        if (!ReceiveCompositableUpdate(cmd.get_CompositableOperation())) {
          NS_ERROR("ReceiveCompositableUpdate failed");
        }
        break;
      }
      case WebRenderParentCommand::TOpAddCompositorAnimations: {
        const OpAddCompositorAnimations& op =
            cmd.get_OpAddCompositorAnimations();
        CompositorAnimations data(std::move(op.data()));
        // AnimationHelper::GetNextCompositorAnimationsId() encodes the child
        // process PID in the upper 32 bits of the id, verify that this is as
        // expected.
        if ((data.id() >> 32) != (uint64_t)OtherPid()) {
          return false;
        }
        if (data.animations().Length()) {
          mAnimStorage->SetAnimations(data.id(), data.animations());
          const auto activeAnim = mActiveAnimations.find(data.id());
          if (activeAnim == mActiveAnimations.end()) {
            mActiveAnimations.emplace(data.id(), mWrEpoch);
          } else {
            // Update wr::Epoch if the animation already exists.
            activeAnim->second = mWrEpoch;
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
  return true;
}

void WebRenderBridgeParent::FlushSceneBuilds() {
  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread());

  // Since we are sending transactions through the scene builder thread, we need
  // to block until all the inflight transactions have been processed. This
  // flush message blocks until all previously sent scenes have been built
  // and received by the render backend thread.
  mApi->FlushSceneBuilder();
  // The post-swap hook for async-scene-building calls the
  // ScheduleRenderOnCompositorThread function from the scene builder thread,
  // which then triggers a call to ScheduleGenerateFrame() on the compositor
  // thread. But since *this* function is running on the compositor thread,
  // that scheduling will not happen until this call stack unwinds (or we
  // could spin a nested event loop, but that's more messy). Instead, we
  // simulate it ourselves by calling ScheduleGenerateFrame() directly.
  // Note also that the post-swap hook will run and do another
  // ScheduleGenerateFrame() after we unwind here, so we will end up with an
  // extra render/composite that is probably avoidable, but in practice we
  // shouldn't be calling this function all that much in production so this
  // is probably fine. If it becomes an issue we can add more state tracking
  // machinery to optimize it away.
  ScheduleGenerateFrame();
}

void WebRenderBridgeParent::FlushFrameGeneration() {
  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread());
  MOZ_ASSERT(IsRootWebRenderBridgeParent());  // This function is only useful on
                                              // the root WRBP

  // This forces a new GenerateFrame transaction to be sent to the render
  // backend thread, if one is pending. This doesn't block on any other threads.
  if (mCompositorScheduler->NeedsComposite()) {
    mCompositorScheduler->CancelCurrentCompositeTask();
    // Update timestamp of scheduler for APZ and animation.
    mCompositorScheduler->UpdateLastComposeTime();
    MaybeGenerateFrame(VsyncId(), /* aForceGenerateFrame */ true);
  }
}

void WebRenderBridgeParent::FlushFramePresentation() {
  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread());

  // This sends a message to the render backend thread to send a message
  // to the renderer thread, and waits for that message to be processed. So
  // this effectively blocks on the render backend and renderer threads,
  // following the same codepath that WebRender takes to render and composite
  // a frame.
  mApi->WaitFlushed();
}

void WebRenderBridgeParent::DisableNativeCompositor() {
  // Make sure that SceneBuilder thread does not have a task.
  mApi->FlushSceneBuilder();
  // Disable WebRender's native compositor usage
  mApi->EnableNativeCompositor(false);
  // Ensure we generate and render a frame immediately.
  ScheduleForcedGenerateFrame();

  mDisablingNativeCompositor = true;
}

void WebRenderBridgeParent::UpdateQualitySettings() {
  wr::TransactionBuilder txn;
  txn.UpdateQualitySettings(gfxVars::ForceSubpixelAAWherePossible());
  mApi->SendTransaction(txn);
}

void WebRenderBridgeParent::UpdateDebugFlags() {
  mApi->UpdateDebugFlags(gfxVars::WebRenderDebugFlags());
}

void WebRenderBridgeParent::UpdateMultithreading() {
  mApi->EnableMultithreading(gfxVars::UseWebRenderMultithreading());
}

void WebRenderBridgeParent::UpdateBatchingParameters() {
  uint32_t count = gfxVars::WebRenderBatchingLookback();
  mApi->SetBatchingLookback(count);
}

#if defined(MOZ_WIDGET_ANDROID)
void WebRenderBridgeParent::RequestScreenPixels(
    UiCompositorControllerParent* aController) {
  mScreenPixelsTarget = aController;
}

void WebRenderBridgeParent::MaybeCaptureScreenPixels() {
  if (!mScreenPixelsTarget) {
    return;
  }

  if (mDestroyed) {
    return;
  }
  MOZ_ASSERT(!mPaused);

  // This function should only get called in the root WRBP.
  MOZ_ASSERT(IsRootWebRenderBridgeParent());

  SurfaceFormat format = SurfaceFormat::R8G8B8A8;  // On android we use RGBA8
  auto client_size = mWidget->GetClientSize();
  size_t buffer_size =
      client_size.width * client_size.height * BytesPerPixel(format);

  ipc::Shmem mem;
  if (!mScreenPixelsTarget->AllocPixelBuffer(buffer_size, &mem)) {
    // Failed to alloc shmem, Just bail out.
    return;
  }

  IntSize size(client_size.width, client_size.height);

  mApi->Readback(TimeStamp::Now(), size, format,
                 Range<uint8_t>(mem.get<uint8_t>(), buffer_size));

  Unused << mScreenPixelsTarget->SendScreenPixels(
      std::move(mem), ScreenIntSize(client_size.width, client_size.height));

  mScreenPixelsTarget = nullptr;
}
#endif

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvGetSnapshot(
    PTextureParent* aTexture) {
  if (mDestroyed) {
    return IPC_OK();
  }
  MOZ_ASSERT(!mPaused);

  // This function should only get called in the root WRBP. If this function
  // gets called in a non-root WRBP, we will set mForceRendering in this WRBP
  // but it will have no effect because CompositeToTarget (which reads the
  // flag) only gets invoked in the root WRBP. So we assert that this is the
  // root WRBP (i.e. has a non-null mWidget) to catch violations of this rule.
  MOZ_ASSERT(IsRootWebRenderBridgeParent());

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

  TimeStamp start = TimeStamp::Now();
  MOZ_ASSERT(bufferTexture->GetBufferDescriptor().type() ==
             BufferDescriptor::TRGBDescriptor);
  DebugOnly<uint32_t> stride = ImageDataSerializer::GetRGBStride(
      bufferTexture->GetBufferDescriptor().get_RGBDescriptor());
  uint8_t* buffer = bufferTexture->GetBuffer();
  IntSize size = bufferTexture->GetSize();

  MOZ_ASSERT(buffer);
  // For now the only formats we get here are RGBA and BGRA, and code below is
  // assuming a bpp of 4. If we allow other formats, the code needs adjusting
  // accordingly.
  MOZ_ASSERT(BytesPerPixel(bufferTexture->GetFormat()) == 4);
  uint32_t buffer_size = size.width * size.height * 4;

  // Assert the stride of the buffer is what webrender expects
  MOZ_ASSERT((uint32_t)(size.width * 4) == stride);

  FlushSceneBuilds();
  FlushFrameGeneration();
  mApi->Readback(start, size, bufferTexture->GetFormat(),
                 Range<uint8_t>(buffer, buffer_size));

  return IPC_OK();
}

void WebRenderBridgeParent::AddPipelineIdForCompositable(
    const wr::PipelineId& aPipelineId, const CompositableHandle& aHandle,
    const bool& aAsync, wr::TransactionBuilder& aTxn,
    wr::TransactionBuilder& aTxnForImageBridge) {
  if (mDestroyed) {
    return;
  }

  MOZ_ASSERT(mAsyncCompositables.find(wr::AsUint64(aPipelineId)) ==
             mAsyncCompositables.end());

  RefPtr<CompositableHost> host;
  if (aAsync) {
    RefPtr<ImageBridgeParent> imageBridge =
        ImageBridgeParent::GetInstance(OtherPid());
    if (!imageBridge) {
      return;
    }
    host = imageBridge->FindCompositable(aHandle);
  } else {
    host = FindCompositable(aHandle);
  }
  if (!host) {
    return;
  }

  WebRenderImageHost* wrHost = host->AsWebRenderImageHost();
  MOZ_ASSERT(wrHost);
  if (!wrHost) {
    gfxCriticalNote
        << "Incompatible CompositableHost at WebRenderBridgeParent.";
  }

  if (!wrHost) {
    return;
  }

  wrHost->SetWrBridge(aPipelineId, this);
  mAsyncCompositables.emplace(wr::AsUint64(aPipelineId), wrHost);
  mAsyncImageManager->AddAsyncImagePipeline(aPipelineId, wrHost);

  // If this is being called from WebRenderBridgeParent::RecvSetDisplayList,
  // then aTxn might contain a display list that references pipelines that
  // we just added to the async image manager.
  // If we send the display list alone then WR will not yet have the content for
  // the pipelines and so it will emit errors; the SetEmptyDisplayList call
  // below ensure that we provide its content to WR as part of the same
  // transaction.
  mAsyncImageManager->SetEmptyDisplayList(aPipelineId, aTxn,
                                          aTxnForImageBridge);
}

void WebRenderBridgeParent::RemovePipelineIdForCompositable(
    const wr::PipelineId& aPipelineId, wr::TransactionBuilder& aTxn) {
  if (mDestroyed) {
    return;
  }

  auto it = mAsyncCompositables.find(wr::AsUint64(aPipelineId));
  if (it == mAsyncCompositables.end()) {
    return;
  }
  RefPtr<WebRenderImageHost>& wrHost = it->second;

  wrHost->ClearWrBridge(aPipelineId, this);
  mAsyncImageManager->RemoveAsyncImagePipeline(aPipelineId, aTxn);
  aTxn.RemovePipeline(aPipelineId);
  mAsyncCompositables.erase(wr::AsUint64(aPipelineId));
}

void WebRenderBridgeParent::DeleteImage(const ImageKey& aKey,
                                        wr::TransactionBuilder& aUpdates) {
  if (mDestroyed) {
    return;
  }

  auto it = mSharedSurfaceIds.find(wr::AsUint64(aKey));
  if (it != mSharedSurfaceIds.end()) {
    mAsyncImageManager->HoldExternalImage(mPipelineId, mWrEpoch, it->second);
    mSharedSurfaceIds.erase(it);
  }

  aUpdates.DeleteImage(aKey);
}

void WebRenderBridgeParent::ReleaseTextureOfImage(const wr::ImageKey& aKey) {
  if (mDestroyed) {
    return;
  }

  uint64_t id = wr::AsUint64(aKey);
  CompositableTextureHostRef texture;
  WebRenderTextureHost* wrTexture = nullptr;

  auto it = mTextureHosts.find(id);
  if (it != mTextureHosts.end()) {
    wrTexture = (*it).second->AsWebRenderTextureHost();
  }
  if (wrTexture) {
    mAsyncImageManager->HoldExternalImage(mPipelineId, mWrEpoch, wrTexture);
  }
  mTextureHosts.erase(id);
}

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvSetLayersObserverEpoch(
    const LayersObserverEpoch& aChildEpoch) {
  if (mDestroyed) {
    return IPC_OK();
  }
  mChildLayersObserverEpoch = aChildEpoch;
  return IPC_OK();
}

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvClearCachedResources() {
  if (mDestroyed) {
    return IPC_OK();
  }

  // Clear resources
  wr::TransactionBuilder txn;
  txn.SetLowPriority(true);
  txn.ClearDisplayList(GetNextWrEpoch(), mPipelineId);
  txn.Notify(
      wr::Checkpoint::SceneBuilt,
      MakeUnique<ScheduleObserveLayersUpdate>(
          mCompositorBridge, GetLayersId(), mChildLayersObserverEpoch, false));
  mApi->SendTransaction(txn);

  // Schedule generate frame to clean up Pipeline
  ScheduleGenerateFrame();

  // Remove animations.
  for (const auto& id : mActiveAnimations) {
    mAnimStorage->ClearById(id.first);
  }
  mActiveAnimations.clear();
  std::queue<CompositorAnimationIdsForEpoch>().swap(
      mCompositorAnimationsToDelete);  // clear queue
  return IPC_OK();
}

wr::Epoch WebRenderBridgeParent::UpdateWebRender(
    CompositorVsyncScheduler* aScheduler, RefPtr<wr::WebRenderAPI>&& aApi,
    AsyncImagePipelineManager* aImageMgr,
    CompositorAnimationStorage* aAnimStorage,
    const TextureFactoryIdentifier& aTextureFactoryIdentifier) {
  MOZ_ASSERT(!IsRootWebRenderBridgeParent());
  MOZ_ASSERT(aScheduler);
  MOZ_ASSERT(aApi);
  MOZ_ASSERT(aImageMgr);
  MOZ_ASSERT(aAnimStorage);

  if (mDestroyed) {
    return mWrEpoch;
  }

  // Update id name space to identify obsoleted keys.
  // Since usage of invalid keys could cause crash in webrender.
  mIdNamespace = aApi->GetNamespace();
  // XXX Remove it when webrender supports sharing/moving Keys between different
  // webrender instances.
  // XXX It requests client to update/reallocate webrender related resources,
  // but parent side does not wait end of the update.
  // The code could become simpler if we could serialise old keys deallocation
  // and new keys allocation. But we do not do it, it is because client side
  // deallocate old layers/webrender keys after new layers/webrender keys
  // allocation. Without client side's layout refactoring, we could not finish
  // all old layers/webrender keys removals before new layer/webrender keys
  // allocation. In future, we could address the problem.
  Unused << SendWrUpdated(mIdNamespace, aTextureFactoryIdentifier);
  CompositorBridgeParentBase* cBridge = mCompositorBridge;
  // XXX Stop to clear resources if webreder supports resources sharing between
  // different webrender instances.
  ClearResources();
  mCompositorBridge = cBridge;
  mCompositorScheduler = aScheduler;
  mApi = aApi;
  mAsyncImageManager = aImageMgr;
  mAnimStorage = aAnimStorage;

  // Register pipeline to updated AsyncImageManager.
  mAsyncImageManager->AddPipeline(mPipelineId, this);

  return GetNextWrEpoch();  // Update webrender epoch
}

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvInvalidateRenderedFrame() {
  // This function should only get called in the root WRBP
  MOZ_ASSERT(IsRootWebRenderBridgeParent());

  InvalidateRenderedFrame();
  return IPC_OK();
}

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvScheduleComposite() {
  // Caller of LayerManager::ScheduleComposite() expects that it trigger
  // composite. Then we do not want to skip generate frame.
  ScheduleForcedGenerateFrame();
  return IPC_OK();
}

void WebRenderBridgeParent::InvalidateRenderedFrame() {
  if (mDestroyed) {
    return;
  }

  wr::TransactionBuilder fastTxn(/* aUseSceneBuilderThread */ false);
  fastTxn.InvalidateRenderedFrame();
  mApi->SendTransaction(fastTxn);
}

void WebRenderBridgeParent::ScheduleForcedGenerateFrame() {
  if (mDestroyed) {
    return;
  }

  InvalidateRenderedFrame();
  ScheduleGenerateFrame();
}

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvCapture() {
  if (!mDestroyed) {
    mApi->Capture();
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvToggleCaptureSequence() {
  if (!mDestroyed) {
    mApi->ToggleCaptureSequence();
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvSyncWithCompositor() {
  FlushSceneBuilds();
  if (RefPtr<WebRenderBridgeParent> root = GetRootWebRenderBridgeParent()) {
    root->FlushFrameGeneration();
  }
  FlushFramePresentation();
  // Finally, we force the AsyncImagePipelineManager to handle all the
  // pipeline updates produced in the last step, so that it frees any
  // unneeded textures. Then we can return from this sync IPC call knowing
  // that we've done everything we can to flush stuff on the compositor.
  mAsyncImageManager->ProcessPipelineUpdates();

  return IPC_OK();
}

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvSetConfirmedTargetAPZC(
    const uint64_t& aBlockId, nsTArray<ScrollableLayerGuid>&& aTargets) {
  for (size_t i = 0; i < aTargets.Length(); i++) {
    // Guard against bad data from hijacked child processes
    if (aTargets[i].mLayersId != GetLayersId()) {
      NS_ERROR(
          "Unexpected layers id in RecvSetConfirmedTargetAPZC; dropping "
          "message...");
      return IPC_FAIL(this, "Bad layers id");
    }
  }

  if (mDestroyed) {
    return IPC_OK();
  }
  mCompositorBridge->SetConfirmedTargetAPZC(GetLayersId(), aBlockId, aTargets);
  return IPC_OK();
}

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvSetTestSampleTime(
    const TimeStamp& aTime) {
  if (!mCompositorBridge->SetTestSampleTime(GetLayersId(), aTime)) {
    return IPC_FAIL_NO_REASON(this);
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvLeaveTestMode() {
  if (mDestroyed) {
    return IPC_FAIL_NO_REASON(this);
  }

  mCompositorBridge->LeaveTestMode(GetLayersId());
  return IPC_OK();
}

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvGetAnimationValue(
    const uint64_t& aCompositorAnimationsId, OMTAValue* aValue) {
  if (mDestroyed) {
    return IPC_FAIL_NO_REASON(this);
  }

  MOZ_ASSERT(mAnimStorage);
  if (RefPtr<WebRenderBridgeParent> root = GetRootWebRenderBridgeParent()) {
    root->AdvanceAnimations();
  } else {
    AdvanceAnimations();
  }

  *aValue = mAnimStorage->GetOMTAValue(aCompositorAnimationsId);
  return IPC_OK();
}

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvSetAsyncScrollOffset(
    const ScrollableLayerGuid::ViewID& aScrollId, const float& aX,
    const float& aY) {
  if (mDestroyed) {
    return IPC_OK();
  }
  mCompositorBridge->SetTestAsyncScrollOffset(GetLayersId(), aScrollId,
                                              CSSPoint(aX, aY));
  return IPC_OK();
}

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvSetAsyncZoom(
    const ScrollableLayerGuid::ViewID& aScrollId, const float& aZoom) {
  if (mDestroyed) {
    return IPC_OK();
  }
  mCompositorBridge->SetTestAsyncZoom(GetLayersId(), aScrollId,
                                      LayerToParentLayerScale(aZoom));
  return IPC_OK();
}

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvFlushApzRepaints() {
  if (mDestroyed) {
    return IPC_OK();
  }
  mCompositorBridge->FlushApzRepaints(GetLayersId());
  return IPC_OK();
}

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvGetAPZTestData(
    APZTestData* aOutData) {
  mCompositorBridge->GetAPZTestData(GetLayersId(), aOutData);
  return IPC_OK();
}

void WebRenderBridgeParent::ActorDestroy(ActorDestroyReason aWhy) { Destroy(); }

bool WebRenderBridgeParent::AdvanceAnimations() {
  if (CompositorBridgeParent* cbp = GetRootCompositorBridgeParent()) {
    Maybe<TimeStamp> testingTimeStamp = cbp->GetTestingTimeStamp();
    if (testingTimeStamp) {
      // If we are on testing refresh mode, use the testing time stamp.  And
      // also we don't update mPreviousFrameTimeStamp since unlike normal
      // refresh mode, on the testing mode animations on the compositor are
      // synchronously composed, so we don't need to worry about the time gap
      // between the main thread and compositor thread.
      return AnimationHelper::SampleAnimations(mAnimStorage, *testingTimeStamp,
                                               *testingTimeStamp);
    }
  }

  TimeStamp lastComposeTime = mCompositorScheduler->GetLastComposeTime();
  const bool isAnimating = AnimationHelper::SampleAnimations(
      mAnimStorage, mPreviousFrameTimeStamp, lastComposeTime);

  // Reset the previous time stamp if we don't already have any running
  // animations to avoid using the time which is far behind for newly
  // started animations.
  mPreviousFrameTimeStamp = isAnimating ? lastComposeTime : TimeStamp();

  return isAnimating;
}

bool WebRenderBridgeParent::SampleAnimations(WrAnimations& aAnimations) {
  const bool isAnimating = AdvanceAnimations();

  // return the animated data if has
  if (mAnimStorage->AnimatedValueCount()) {
    for (auto iter = mAnimStorage->ConstAnimatedValueTableIter(); !iter.Done();
         iter.Next()) {
      AnimatedValue* value = iter.UserData();
      value->Value().match(
          [&](const AnimationTransform& aTransform) {
            aAnimations.mTransformArrays.AppendElement(
                wr::ToWrTransformProperty(iter.Key(),
                                          aTransform.mTransformInDevSpace));
          },
          [&](const float& aOpacity) {
            aAnimations.mOpacityArrays.AppendElement(
                wr::ToWrOpacityProperty(iter.Key(), aOpacity));
          },
          [&](const nscolor& aColor) {
            aAnimations.mColorArrays.AppendElement(wr::ToWrColorProperty(
                iter.Key(), ToDeviceColor(gfx::sRGBColor::FromABGR(aColor))));
          });
    }
  }

  return isAnimating;
}

void WebRenderBridgeParent::CompositeIfNeeded() {
  if (mSkippedComposite) {
    mSkippedComposite = false;
    CompositeToTarget(mSkippedCompositeId, nullptr, nullptr);
  }
}

void WebRenderBridgeParent::CompositeToTarget(VsyncId aId,
                                              gfx::DrawTarget* aTarget,
                                              const gfx::IntRect* aRect) {
  // This function should only get called in the root WRBP
  MOZ_ASSERT(IsRootWebRenderBridgeParent());

  // The two arguments are part of the CompositorVsyncSchedulerOwner API but in
  // this implementation they should never be non-null.
  MOZ_ASSERT(aTarget == nullptr);
  MOZ_ASSERT(aRect == nullptr);

  AUTO_PROFILER_TRACING_MARKER("Paint", "CompositeToTarget", GRAPHICS);
  if (mPaused || !mReceivedDisplayList) {
    mPreviousFrameTimeStamp = TimeStamp();
    return;
  }

  if (mSkippedComposite ||
      wr::RenderThread::Get()->TooManyPendingFrames(mApi->GetId())) {
    // Render thread is busy, try next time.
    mSkippedComposite = true;
    mSkippedCompositeId = aId;
    mPreviousFrameTimeStamp = TimeStamp();

    // Record that we skipped presenting a frame for
    // all pending transactions that have finished scene building.
    for (auto& id : mPendingTransactionIds) {
      if (id.mSceneBuiltTime) {
        id.mSkippedComposites++;
      }
    }
    return;
  }
  MaybeGenerateFrame(aId, /* aForceGenerateFrame */ false);
}

TimeDuration WebRenderBridgeParent::GetVsyncInterval() const {
  // This function should only get called in the root WRBP
  MOZ_ASSERT(IsRootWebRenderBridgeParent());
  if (CompositorBridgeParent* cbp = GetRootCompositorBridgeParent()) {
    return cbp->GetVsyncInterval();
  }
  return TimeDuration();
}

void WebRenderBridgeParent::MaybeGenerateFrame(VsyncId aId,
                                               bool aForceGenerateFrame) {
  // This function should only get called in the root WRBP
  MOZ_ASSERT(IsRootWebRenderBridgeParent());

  if (CompositorBridgeParent* cbp = GetRootCompositorBridgeParent()) {
    // Skip WR render during paused state.
    if (cbp->IsPaused()) {
      TimeStamp now = TimeStamp::Now();
      cbp->NotifyPipelineRendered(mPipelineId, mWrEpoch, VsyncId(), now, now,
                                  now);
      return;
    }
  }

  TimeStamp start = TimeStamp::Now();
  mAsyncImageManager->SetCompositionTime(start);

  // Ensure GenerateFrame is handled on the render backend thread rather
  // than going through the scene builder thread. That way we continue
  // generating frames with the old scene even during slow scene builds.
  wr::TransactionBuilder fastTxn(false /* useSceneBuilderThread */);
  // Handle transaction that is related to DisplayList.
  wr::TransactionBuilder sceneBuilderTxn;
  wr::AutoTransactionSender sender(mApi, &sceneBuilderTxn);

  // Adding and updating wr::ImageKeys of ImageHosts that uses ImageBridge are
  // done without using transaction of scene builder thread. With it, updating
  // of video frame becomes faster.
  mAsyncImageManager->ApplyAsyncImagesOfImageBridge(sceneBuilderTxn, fastTxn);

  if (!mAsyncImageManager->GetCompositeUntilTime().IsNull()) {
    // Trigger another CompositeToTarget() call because there might be another
    // frame that we want to generate after this one.
    // It will check if we actually want to generate the frame or not.
    mCompositorScheduler->ScheduleComposition();
  }

  bool generateFrame = mAsyncImageManager->GetAndResetWillGenerateFrame() ||
                       !fastTxn.IsEmpty() || aForceGenerateFrame;

  if (!generateFrame) {
    // Could skip generating frame now.
    mPreviousFrameTimeStamp = TimeStamp();
    return;
  }

  WrAnimations animations;
  if (SampleAnimations(animations)) {
    ScheduleGenerateFrame();
  }
  // We do this even if the arrays are empty, because it will clear out any
  // previous properties store on the WR side, which is desirable.
  fastTxn.UpdateDynamicProperties(animations.mOpacityArrays,
                                  animations.mTransformArrays,
                                  animations.mColorArrays);

  SetAPZSampleTime();

  wr::RenderThread::Get()->IncPendingFrameCount(mApi->GetId(), aId, start);

#if defined(ENABLE_FRAME_LATENCY_LOG)
  auto startTime = TimeStamp::Now();
  mApi->SetFrameStartTime(startTime);
#endif

  MOZ_ASSERT(generateFrame);
  fastTxn.GenerateFrame();
  mApi->SendTransaction(fastTxn);

#if defined(MOZ_WIDGET_ANDROID)
  MaybeCaptureScreenPixels();
#endif

  mMostRecentComposite = TimeStamp::Now();

  // During disabling native compositor, webrender needs to render twice.
  // Otherwise, browser flashes black.
  // XXX better fix?
  if (mDisablingNativeCompositor) {
    mDisablingNativeCompositor = false;

    // Ensure we generate and render a frame immediately.
    ScheduleForcedGenerateFrame();
  }
}

void WebRenderBridgeParent::HoldPendingTransactionId(
    const wr::Epoch& aWrEpoch, TransactionId aTransactionId,
    bool aContainsSVGGroup, const VsyncId& aVsyncId,
    const TimeStamp& aVsyncStartTime, const TimeStamp& aRefreshStartTime,
    const TimeStamp& aTxnStartTime, const nsCString& aTxnURL,
    const TimeStamp& aFwdTime, const bool aIsFirstPaint,
    nsTArray<CompositionPayload>&& aPayloads, const bool aUseForTelemetry) {
  MOZ_ASSERT(aTransactionId > LastPendingTransactionId());
  mPendingTransactionIds.push_back(PendingTransactionId(
      aWrEpoch, aTransactionId, aContainsSVGGroup, aVsyncId, aVsyncStartTime,
      aRefreshStartTime, aTxnStartTime, aTxnURL, aFwdTime, aIsFirstPaint,
      aUseForTelemetry, std::move(aPayloads)));
}

TransactionId WebRenderBridgeParent::LastPendingTransactionId() {
  TransactionId id{0};
  if (!mPendingTransactionIds.empty()) {
    id = mPendingTransactionIds.back().mId;
  }
  return id;
}

void WebRenderBridgeParent::NotifySceneBuiltForEpoch(
    const wr::Epoch& aEpoch, const TimeStamp& aEndTime) {
  for (auto& id : mPendingTransactionIds) {
    if (id.mEpoch.mHandle == aEpoch.mHandle) {
      id.mSceneBuiltTime = aEndTime;
      break;
    }
  }
}

void WebRenderBridgeParent::NotifyDidSceneBuild(
    RefPtr<const wr::WebRenderPipelineInfo> aInfo) {
  MOZ_ASSERT(IsRootWebRenderBridgeParent());
  if (!mCompositorScheduler) {
    return;
  }

  mAsyncImageManager->SetWillGenerateFrame();

  // If the scheduler has a composite more recent than our last composite (which
  // we missed), and we're within the threshold ms of the last vsync, then
  // kick of a late composite.
  TimeStamp lastVsync = mCompositorScheduler->GetLastVsyncTime();
  VsyncId lastVsyncId = mCompositorScheduler->GetLastVsyncId();
  if (lastVsyncId == VsyncId() || !mMostRecentComposite ||
      mMostRecentComposite >= lastVsync ||
      ((TimeStamp::Now() - lastVsync).ToMilliseconds() >
       StaticPrefs::gfx_webrender_late_scenebuild_threshold())) {
    mCompositorScheduler->ScheduleComposition();
    return;
  }

  // Look through all the pipelines contained within the built scene
  // and check which vsync they initiated from.
  const auto& info = aInfo->Raw();
  for (const auto& epoch : info.epochs) {
    WebRenderBridgeParent* wrBridge = this;
    if (!(epoch.pipeline_id == PipelineId())) {
      wrBridge = mAsyncImageManager->GetWrBridge(epoch.pipeline_id);
    }

    if (wrBridge) {
      VsyncId startId = wrBridge->GetVsyncIdForEpoch(epoch.epoch);
      // If any of the pipelines started building on the current vsync (i.e
      // we did all of display list building and scene building within the
      // threshold), then don't do an early composite.
      if (startId == lastVsyncId) {
        mCompositorScheduler->ScheduleComposition();
        return;
      }
    }
  }

  CompositeToTarget(mCompositorScheduler->GetLastVsyncId(), nullptr, nullptr);
}

TransactionId WebRenderBridgeParent::FlushTransactionIdsForEpoch(
    const wr::Epoch& aEpoch, const VsyncId& aCompositeStartId,
    const TimeStamp& aCompositeStartTime, const TimeStamp& aRenderStartTime,
    const TimeStamp& aEndTime, UiCompositorControllerParent* aUiController,
    wr::RendererStats* aStats, nsTArray<FrameStats>* aOutputStats) {
  TransactionId id{0};
  while (!mPendingTransactionIds.empty()) {
    const auto& transactionId = mPendingTransactionIds.front();

    if (aEpoch.mHandle < transactionId.mEpoch.mHandle) {
      break;
    }

    if (!IsRootWebRenderBridgeParent() && !mVsyncRate.IsZero() &&
        transactionId.mUseForTelemetry) {
      auto fullPaintTime =
          transactionId.mSceneBuiltTime
              ? transactionId.mSceneBuiltTime - transactionId.mTxnStartTime
              : TimeDuration::FromMilliseconds(0);

      int32_t contentFrameTime = RecordContentFrameTime(
          transactionId.mVsyncId, transactionId.mVsyncStartTime,
          transactionId.mTxnStartTime, aCompositeStartId, aEndTime,
          fullPaintTime, mVsyncRate, transactionId.mContainsSVGGroup, true,
          aStats);
      if (contentFrameTime > 200) {
        aOutputStats->AppendElement(FrameStats(
            transactionId.mId, aCompositeStartTime, aRenderStartTime, aEndTime,
            contentFrameTime,
            aStats ? (double(aStats->resource_upload_time) / 1000000.0) : 0.0,
            aStats ? (double(aStats->gpu_cache_upload_time) / 1000000.0) : 0.0,
            transactionId.mTxnStartTime, transactionId.mRefreshStartTime,
            transactionId.mFwdTime, transactionId.mSceneBuiltTime,
            transactionId.mSkippedComposites, transactionId.mTxnURL));
      }
    }

#if defined(ENABLE_FRAME_LATENCY_LOG)
    if (transactionId.mRefreshStartTime) {
      int32_t latencyMs =
          lround((aEndTime - transactionId.mRefreshStartTime).ToMilliseconds());
      printf_stderr(
          "From transaction start to end of generate frame latencyMs %d this "
          "%p\n",
          latencyMs, this);
    }
    if (transactionId.mFwdTime) {
      int32_t latencyMs =
          lround((aEndTime - transactionId.mFwdTime).ToMilliseconds());
      printf_stderr(
          "From forwarding transaction to end of generate frame latencyMs %d "
          "this %p\n",
          latencyMs, this);
    }
#endif

    if (aUiController && transactionId.mIsFirstPaint) {
      aUiController->NotifyFirstPaint();
    }

    RecordCompositionPayloadsPresented(transactionId.mPayloads);

    id = transactionId.mId;
    mPendingTransactionIds.pop_front();
  }
  return id;
}

LayersId WebRenderBridgeParent::GetLayersId() const {
  return wr::AsLayersId(mPipelineId);
}

void WebRenderBridgeParent::ScheduleGenerateFrame() {
  if (mCompositorScheduler) {
    mAsyncImageManager->SetWillGenerateFrame();
    mCompositorScheduler->ScheduleComposition();
  }
}

void WebRenderBridgeParent::FlushRendering(bool aWaitForPresent) {
  if (mDestroyed) {
    return;
  }

  // This gets called during e.g. window resizes, so we need to flush the
  // scene (which has the display list at the new window size).
  FlushSceneBuilds();
  FlushFrameGeneration();
  if (aWaitForPresent) {
    FlushFramePresentation();
  }
}

void WebRenderBridgeParent::Pause() {
  MOZ_ASSERT(IsRootWebRenderBridgeParent());

  if (!IsRootWebRenderBridgeParent() || mDestroyed) {
    return;
  }

  mApi->Pause();
  mPaused = true;
}

bool WebRenderBridgeParent::Resume() {
  MOZ_ASSERT(IsRootWebRenderBridgeParent());

  if (!IsRootWebRenderBridgeParent() || mDestroyed) {
    return false;
  }

  if (!mApi->Resume()) {
    return false;
  }

  // Ensure we generate and render a frame immediately.
  ScheduleForcedGenerateFrame();

  mPaused = false;
  return true;
}

void WebRenderBridgeParent::ClearResources() {
  if (!mApi) {
    return;
  }

  wr::Epoch wrEpoch = GetNextWrEpoch();
  mReceivedDisplayList = false;
  // Schedule generate frame to clean up Pipeline
  ScheduleGenerateFrame();

  // WrFontKeys and WrImageKeys are deleted during WebRenderAPI destruction.
  for (const auto& entry : mTextureHosts) {
    WebRenderTextureHost* wrTexture = entry.second->AsWebRenderTextureHost();
    MOZ_ASSERT(wrTexture);
    if (wrTexture) {
      mAsyncImageManager->HoldExternalImage(mPipelineId, wrEpoch, wrTexture);
    }
  }
  mTextureHosts.clear();

  for (const auto& entry : mSharedSurfaceIds) {
    mAsyncImageManager->HoldExternalImage(mPipelineId, mWrEpoch, entry.second);
  }
  mSharedSurfaceIds.clear();

  mAsyncImageManager->RemovePipeline(mPipelineId, wrEpoch);

  wr::TransactionBuilder txn;
  txn.SetLowPriority(true);
  txn.ClearDisplayList(wrEpoch, mPipelineId);

  for (const auto& entry : mAsyncCompositables) {
    wr::PipelineId pipelineId = wr::AsPipelineId(entry.first);
    RefPtr<WebRenderImageHost> host = entry.second;
    host->ClearWrBridge(pipelineId, this);
    mAsyncImageManager->RemoveAsyncImagePipeline(pipelineId, txn);
    txn.RemovePipeline(pipelineId);
  }
  mAsyncCompositables.clear();
  txn.RemovePipeline(mPipelineId);
  mApi->SendTransaction(txn);

  for (const auto& id : mActiveAnimations) {
    mAnimStorage->ClearById(id.first);
  }
  mActiveAnimations.clear();
  std::queue<CompositorAnimationIdsForEpoch>().swap(
      mCompositorAnimationsToDelete);  // clear queue

  if (IsRootWebRenderBridgeParent()) {
    mCompositorScheduler->Destroy();
  }

  mAnimStorage = nullptr;
  mCompositorScheduler = nullptr;
  mAsyncImageManager = nullptr;
  mApi = nullptr;
  mCompositorBridge = nullptr;
}

bool WebRenderBridgeParent::ShouldParentObserveEpoch() {
  if (mParentLayersObserverEpoch == mChildLayersObserverEpoch) {
    return false;
  }

  mParentLayersObserverEpoch = mChildLayersObserverEpoch;
  return true;
}

void WebRenderBridgeParent::SendAsyncMessage(
    const nsTArray<AsyncParentMessageData>& aMessage) {
  MOZ_ASSERT_UNREACHABLE("unexpected to be called");
}

void WebRenderBridgeParent::SendPendingAsyncMessages() {
  MOZ_ASSERT(mCompositorBridge);
  mCompositorBridge->SendPendingAsyncMessages();
}

void WebRenderBridgeParent::SetAboutToSendAsyncMessages() {
  MOZ_ASSERT(mCompositorBridge);
  mCompositorBridge->SetAboutToSendAsyncMessages();
}

void WebRenderBridgeParent::NotifyNotUsed(PTextureParent* aTexture,
                                          uint64_t aTransactionId) {
  MOZ_ASSERT_UNREACHABLE("unexpected to be called");
}

base::ProcessId WebRenderBridgeParent::GetChildProcessId() {
  return OtherPid();
}

bool WebRenderBridgeParent::IsSameProcess() const {
  return OtherPid() == base::GetCurrentProcId();
}

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvNewCompositable(
    const CompositableHandle& aHandle, const TextureInfo& aInfo) {
  if (mDestroyed) {
    return IPC_OK();
  }
  if (!AddCompositable(aHandle, aInfo, /* aUseWebRender */ true)) {
    return IPC_FAIL_NO_REASON(this);
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult WebRenderBridgeParent::RecvReleaseCompositable(
    const CompositableHandle& aHandle) {
  if (mDestroyed) {
    return IPC_OK();
  }
  ReleaseCompositable(aHandle);
  return IPC_OK();
}

TextureFactoryIdentifier WebRenderBridgeParent::GetTextureFactoryIdentifier() {
  MOZ_ASSERT(mApi);

  return TextureFactoryIdentifier(
      LayersBackend::LAYERS_WR, XRE_GetProcessType(), mApi->GetMaxTextureSize(),
      false, mApi->GetUseANGLE(), mApi->GetUseDComp(),
      mAsyncImageManager->UseCompositorWnd(), false, false, false,
      mApi->GetSyncHandle());
}

wr::Epoch WebRenderBridgeParent::GetNextWrEpoch() {
  MOZ_RELEASE_ASSERT(mWrEpoch.mHandle != UINT32_MAX);
  mWrEpoch.mHandle++;
  return mWrEpoch;
}

void WebRenderBridgeParent::RollbackWrEpoch() {
  MOZ_RELEASE_ASSERT(mWrEpoch.mHandle != 0);
  mWrEpoch.mHandle--;
}

void WebRenderBridgeParent::ExtractImageCompositeNotifications(
    nsTArray<ImageCompositeNotificationInfo>* aNotifications) {
  MOZ_ASSERT(IsRootWebRenderBridgeParent());
  if (mDestroyed) {
    return;
  }
  mAsyncImageManager->FlushImageNotifications(aNotifications);
}

}  // namespace layers
}  // namespace mozilla
