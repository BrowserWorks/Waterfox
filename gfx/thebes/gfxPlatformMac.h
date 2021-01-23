/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef GFX_PLATFORM_MAC_H
#define GFX_PLATFORM_MAC_H

#include "nsTArrayForwardDeclare.h"
#include "gfxPlatform.h"
#include "mozilla/LookAndFeel.h"

namespace mozilla {
namespace gfx {
class DrawTarget;
class VsyncSource;
}  // namespace gfx
}  // namespace mozilla

class gfxPlatformMac : public gfxPlatform {
 public:
  gfxPlatformMac();
  virtual ~gfxPlatformMac();

  static gfxPlatformMac* GetPlatform() {
    return (gfxPlatformMac*)gfxPlatform::GetPlatform();
  }

  bool UsesTiling() const override;
  bool ContentUsesTiling() const override;

  already_AddRefed<gfxASurface> CreateOffscreenSurface(
      const IntSize& aSize, gfxImageFormat aFormat) override;

  gfxPlatformFontList* CreatePlatformFontList() override;

  void ReadSystemFontList(
      nsTArray<mozilla::dom::SystemFontListEntry>* aFontList) override;

  bool IsFontFormatSupported(uint32_t aFormatFlags) override;

  void GetCommonFallbackFonts(uint32_t aCh, uint32_t aNextCh, Script aRunScript,
                              nsTArray<const char*>& aFontList) override;

  // lookup the system font for a particular system font type and set
  // the name and style characteristics
  static void LookupSystemFont(mozilla::LookAndFeel::FontID aSystemFontID,
                               nsACString& aSystemFontName,
                               gfxFontStyle& aFontStyle);

  bool SupportsApzWheelInput() const override { return true; }

  bool RespectsFontStyleSmoothing() const override {
    // gfxMacFont respects the font smoothing hint.
    return true;
  }

  bool RequiresAcceleratedGLContextForCompositorOGL() const override {
    // On OS X in a VM, unaccelerated CompositorOGL shows black flashes, so we
    // require accelerated GL for CompositorOGL but allow unaccelerated GL for
    // BasicCompositor.
    return true;
  }

  already_AddRefed<mozilla::gfx::VsyncSource> CreateHardwareVsyncSource()
      override;

  // lower threshold on font anti-aliasing
  uint32_t GetAntiAliasingThreshold() { return mFontAntiAliasingThreshold; }

 protected:
  bool AccelerateLayersByDefault() override;

  BackendPrefsData GetBackendPrefs() const override;

  bool CheckVariationFontSupport() override;

  void InitPlatformGPUProcessPrefs() override;

 private:
  nsTArray<uint8_t> GetPlatformCMSOutputProfileData() override;

  // read in the pref value for the lower threshold on font anti-aliasing
  static uint32_t ReadAntiAliasingThreshold();

  uint32_t mFontAntiAliasingThreshold;
};

#endif /* GFX_PLATFORM_MAC_H */
