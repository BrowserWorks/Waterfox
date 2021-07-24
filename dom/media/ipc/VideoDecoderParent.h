/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=99: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
#ifndef include_dom_ipc_VideoDecoderParent_h
#define include_dom_ipc_VideoDecoderParent_h

#include "ImageContainer.h"
#include "MediaData.h"
#include "PlatformDecoderModule.h"
#include "VideoDecoderManagerParent.h"
#include "mozilla/MozPromise.h"
#include "mozilla/dom/PVideoDecoderParent.h"
#include "mozilla/layers/TextureForwarder.h"

namespace mozilla {
namespace dom {

class KnowsCompositorVideo;

class VideoDecoderParent final : public PVideoDecoderParent
{
public:
  // We refcount this class since the task queue can have runnables
  // that reference us.
  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(VideoDecoderParent)

  VideoDecoderParent(VideoDecoderManagerParent* aParent,
                     const VideoInfo& aVideoInfo,
                     float aFramerate,
                     const layers::TextureFactoryIdentifier& aIdentifier,
                     TaskQueue* aManagerTaskQueue,
                     TaskQueue* aDecodeTaskQueue,
                     bool* aSuccess,
                     nsCString* aErrorDescription);

  void Destroy();

  // PVideoDecoderParent
  mozilla::ipc::IPCResult RecvInit() override;
  mozilla::ipc::IPCResult RecvInput(const MediaRawDataIPDL& aData) override;
  mozilla::ipc::IPCResult RecvFlush() override;
  mozilla::ipc::IPCResult RecvDrain() override;
  mozilla::ipc::IPCResult RecvShutdown() override;
  mozilla::ipc::IPCResult RecvSetSeekThreshold(const int64_t& aTime) override;

  void ActorDestroy(ActorDestroyReason aWhy) override;

private:
  bool OnManagerThread();
  void Error(const MediaResult& aError);

  ~VideoDecoderParent();
  void ProcessDecodedData(const MediaDataDecoder::DecodedData& aData);

  RefPtr<VideoDecoderManagerParent> mParent;
  RefPtr<VideoDecoderParent> mIPDLSelfRef;
  RefPtr<TaskQueue> mManagerTaskQueue;
  RefPtr<TaskQueue> mDecodeTaskQueue;
  RefPtr<MediaDataDecoder> mDecoder;
  RefPtr<KnowsCompositorVideo> mKnowsCompositor;

  // Can only be accessed from the manager thread
  bool mDestroyed;
};

} // namespace dom
} // namespace mozilla

#endif // include_dom_ipc_VideoDecoderParent_h
