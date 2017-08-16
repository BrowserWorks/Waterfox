/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef GFX_VR_DISPLAY_CLIENT_H
#define GFX_VR_DISPLAY_CLIENT_H

#include "nsIScreen.h"
#include "nsCOMPtr.h"
#include "mozilla/RefPtr.h"
#include "mozilla/dom/VRDisplayBinding.h"

#include "gfxVR.h"

namespace mozilla {
namespace gfx {
class VRDisplayPresentation;
class VRManagerChild;

class VRDisplayClient
{
public:
  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(VRDisplayClient)

  explicit VRDisplayClient(const VRDisplayInfo& aDisplayInfo);

  void UpdateDisplayInfo(const VRDisplayInfo& aDisplayInfo);
  void UpdateSubmitFrameResult(const VRSubmitFrameResultInfo& aResult);

  const VRDisplayInfo& GetDisplayInfo() const { return mDisplayInfo; }
  virtual VRHMDSensorState GetSensorState();
  void GetSubmitFrameResult(VRSubmitFrameResultInfo& aResult);

  virtual void ZeroSensor();

  already_AddRefed<VRDisplayPresentation> BeginPresentation(const nsTArray<dom::VRLayer>& aLayers,
                                                            uint32_t aGroup);
  void PresentationDestroyed();

  bool GetIsConnected() const;

  void NotifyDisconnected();
  void SetGroupMask(uint32_t aGroupMask);

protected:
  virtual ~VRDisplayClient();

  void FireEvents();

  VRDisplayInfo mDisplayInfo;

  bool bLastEventWasMounted;
  bool bLastEventWasPresenting;

  int mPresentationCount;
  uint32_t mLastEventFrameId;
private:
  VRSubmitFrameResultInfo mSubmitFrameResult;
};

} // namespace gfx
} // namespace mozilla

#endif /* GFX_VR_DISPLAY_CLIENT_H */
