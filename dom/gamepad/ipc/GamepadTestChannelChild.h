/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/PGamepadTestChannelChild.h"
#include "mozilla/dom/Promise.h"

#ifndef mozilla_dom_GamepadTestChannelChild_h_
#  define mozilla_dom_GamepadTestChannelChild_h_

namespace mozilla {
namespace dom {

class GamepadTestChannelChild final : public PGamepadTestChannelChild {
  friend class PGamepadTestChannelChild;

 public:
  GamepadTestChannelChild() = default;
  ~GamepadTestChannelChild() = default;
  void AddPromise(const uint32_t& aID, Promise* aPromise);

 private:
  mozilla::ipc::IPCResult RecvReplyGamepadIndex(const uint32_t& aID,
                                                const uint32_t& aIndex);

  nsRefPtrHashtable<nsUint32HashKey, dom::Promise> mPromiseList;
};

}  // namespace dom
}  // namespace mozilla

#endif
