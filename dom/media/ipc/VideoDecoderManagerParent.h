/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=99: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
#ifndef include_dom_ipc_VideoDecoderManagerParent_h
#define include_dom_ipc_VideoDecoderManagerParent_h

#include "mozilla/dom/PVideoDecoderManagerParent.h"

namespace mozilla {
namespace dom {

class VideoDecoderManagerThreadHolder;

class VideoDecoderManagerParent final : public PVideoDecoderManagerParent
{
public:
  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(VideoDecoderManagerParent)

  static bool CreateForContent(Endpoint<PVideoDecoderManagerParent>&& aEndpoint);

  // Can be called from any thread
  SurfaceDescriptorGPUVideo StoreImage(layers::Image* aImage, layers::TextureClient* aTexture);

  static void StartupThreads();
  static void ShutdownThreads();

  static void ShutdownVideoBridge();

  bool OnManagerThread();

protected:
  PVideoDecoderParent* AllocPVideoDecoderParent(const VideoInfo& aVideoInfo, const layers::TextureFactoryIdentifier& aIdentifier, bool* aSuccess) override;
  bool DeallocPVideoDecoderParent(PVideoDecoderParent* actor) override;

  mozilla::ipc::IPCResult RecvReadback(const SurfaceDescriptorGPUVideo& aSD, SurfaceDescriptor* aResult) override;
  mozilla::ipc::IPCResult RecvDeallocateSurfaceDescriptorGPUVideo(const SurfaceDescriptorGPUVideo& aSD) override;

  void ActorDestroy(mozilla::ipc::IProtocol::ActorDestroyReason) override;

  void DeallocPVideoDecoderManagerParent() override;

private:
  explicit VideoDecoderManagerParent(VideoDecoderManagerThreadHolder* aThreadHolder);
  ~VideoDecoderManagerParent();

  void Open(Endpoint<PVideoDecoderManagerParent>&& aEndpoint);

  std::map<uint64_t, RefPtr<layers::Image>> mImageMap;
  std::map<uint64_t, RefPtr<layers::TextureClient>> mTextureMap;

  RefPtr<VideoDecoderManagerThreadHolder> mThreadHolder;
};

} // namespace dom
} // namespace mozilla

#endif // include_dom_ipc_VideoDecoderManagerParent_h
