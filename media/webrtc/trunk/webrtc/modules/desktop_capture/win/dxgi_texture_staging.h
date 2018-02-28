/*
 *  Copyright (c) 2016 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef WEBRTC_MODULES_DESKTOP_CAPTURE_WIN_DXGI_TEXTURE_STAGING_H_
#define WEBRTC_MODULES_DESKTOP_CAPTURE_WIN_DXGI_TEXTURE_STAGING_H_

#include <wrl/client.h>
#include <D3D11.h>
#include <DXGI1_2.h>

#include "webrtc/modules/desktop_capture/desktop_geometry.h"
#include "webrtc/modules/desktop_capture/desktop_region.h"
#include "webrtc/modules/desktop_capture/win/d3d_device.h"
#include "webrtc/modules/desktop_capture/win/dxgi_texture.h"

namespace webrtc {

// A pair of an ID3D11Texture2D and an IDXGISurface. We need an ID3D11Texture2D
// instance to copy GPU texture to RAM, but an IDXGISurface instance to map the
// texture into a bitmap buffer. These two instances are pointing to a same
// object.
//
// An ID3D11Texture2D is created by an ID3D11Device, so a DxgiTexture cannot be
// shared between two DxgiAdapterDuplicators.
class DxgiTextureStaging : public DxgiTexture {
 public:
  // Creates a DxgiTextureStaging instance. Caller must maintain the lifetime
  // of input device to make sure it outlives this instance.
  DxgiTextureStaging(const DesktopSize& desktop_size, const D3dDevice& device);

  ~DxgiTextureStaging() override;

  // Copies selected regions of a frame represented by frame_info and resource.
  // Returns false if anything wrong.
  bool CopyFrom(const DXGI_OUTDUPL_FRAME_INFO& frame_info,
                IDXGIResource* resource) override;

  bool DoRelease() override;

 private:
  // Initializes stage_ from a CPU inaccessible IDXGIResource. Returns false if
  // it failed to execute Windows APIs, or the size of the texture is not
  // consistent with desktop_rect.
  bool InitializeStage(ID3D11Texture2D* texture);

  // Makes sure stage_ and surface_ are always pointing to a same object.
  // We need an ID3D11Texture2D instance for
  // ID3D11DeviceContext::CopySubresourceRegion, but an IDXGISurface for
  // IDXGISurface::Map.
  void AssertStageAndSurfaceAreSameObject();

  const DesktopRect desktop_rect_;
  const D3dDevice device_;
  Microsoft::WRL::ComPtr<ID3D11Texture2D> stage_;
  Microsoft::WRL::ComPtr<IDXGISurface> surface_;
};

}  // namespace webrtc

#endif  // WEBRTC_MODULES_DESKTOP_CAPTURE_WIN_DXGI_TEXTURE_STAGING_H_
