/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/PGamepadTestChannelParent.h"

#ifndef mozilla_dom_GamepadTestChannelParent_h_
#  define mozilla_dom_GamepadTestChannelParent_h_

namespace mozilla {
namespace dom {

class GamepadTestChannelParent final : public PGamepadTestChannelParent {
 public:
  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(GamepadTestChannelParent)
  GamepadTestChannelParent() : mShuttingdown(false) {}
  virtual void ActorDestroy(ActorDestroyReason aWhy) override {}
  mozilla::ipc::IPCResult RecvGamepadTestEvent(
      const uint32_t& aID, const GamepadChangeEvent& aGamepadEvent);
  mozilla::ipc::IPCResult RecvShutdownChannel();

 private:
  ~GamepadTestChannelParent() = default;
  bool mShuttingdown;
};

}  // namespace dom
}  // namespace mozilla

#endif
