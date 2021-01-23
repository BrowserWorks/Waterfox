/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
#include "mozilla/dom/PGamepadEventChannelParent.h"

#ifndef mozilla_dom_GamepadEventChannelParent_h_
#  define mozilla_dom_GamepadEventChannelParent_h_

namespace mozilla {
namespace dom {

class GamepadEventChannelParent final : public PGamepadEventChannelParent {
 public:
  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(GamepadEventChannelParent)
  GamepadEventChannelParent();
  virtual void ActorDestroy(ActorDestroyReason aWhy) override;
  mozilla::ipc::IPCResult RecvGamepadListenerAdded();
  mozilla::ipc::IPCResult RecvGamepadListenerRemoved();
  mozilla::ipc::IPCResult RecvVibrateHaptic(const uint32_t& aControllerIdx,
                                            const uint32_t& aHapticIndex,
                                            const double& aIntensity,
                                            const double& aDuration,
                                            const uint32_t& aPromiseID);
  mozilla::ipc::IPCResult RecvStopVibrateHaptic(const uint32_t& aControllerIdx);
  mozilla::ipc::IPCResult RecvLightIndicatorColor(
      const uint32_t& aControllerIdx, const uint32_t& aLightColorIndex,
      const uint8_t& aRed, const uint8_t& aGreen, const uint8_t& aBlue,
      const uint32_t& aPromiseID);
  void DispatchUpdateEvent(const GamepadChangeEvent& aEvent);
  bool HasGamepadListener() const { return mHasGamepadListener; }

 private:
  ~GamepadEventChannelParent() = default;
  bool mHasGamepadListener;
  nsCOMPtr<nsIEventTarget> mBackgroundEventTarget;
};

}  // namespace dom
}  // namespace mozilla

#endif
