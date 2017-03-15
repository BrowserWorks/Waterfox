/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_GamepadServiceTest_h_
#define mozilla_dom_GamepadServiceTest_h_

#include "nsIIPCBackgroundChildCreateCallback.h"
#include "mozilla/DOMEventTargetHelper.h"
#include "mozilla/dom/GamepadBinding.h"

namespace mozilla {
namespace dom {

class GamepadChangeEvent;
class GamepadManager;
class GamepadTestChannelChild;
class Promise;

// Service for testing purposes
class GamepadServiceTest final : public DOMEventTargetHelper,
                                 public nsIIPCBackgroundChildCreateCallback
{
public:
  NS_DECL_NSIIPCBACKGROUNDCHILDCREATECALLBACK
  NS_DECL_ISUPPORTS_INHERITED
  NS_DECL_CYCLE_COLLECTION_CLASS_INHERITED(GamepadServiceTest,
                                           DOMEventTargetHelper)

  uint32_t NoMapping() const { return 0; }
  uint32_t StandardMapping() const { return 1; }

  already_AddRefed<Promise> AddGamepad(const nsAString& aID,
                                       uint32_t aMapping,
                                       uint32_t aNumButtons,
                                       uint32_t aNumAxes,
                                       ErrorResult& aRv);
  void RemoveGamepad(uint32_t aIndex);
  void NewButtonEvent(uint32_t aIndex, uint32_t aButton, bool aPressed);
  void NewButtonValueEvent(uint32_t aIndex, uint32_t aButton, bool aPressed, double aValue);
  void NewAxisMoveEvent(uint32_t aIndex, uint32_t aAxis, double aValue);
  void Shutdown();

  static already_AddRefed<GamepadServiceTest> CreateTestService(nsPIDOMWindowInner* aWindow);
  nsPIDOMWindowInner* GetParentObject() const { return mWindow; }
  JSObject* WrapObject(JSContext* aCx, JS::HandleObject aGivenProto) override;

private:

  // We need to asynchronously create IPDL channel, it is possible that
  // we send commands before the channel is created, so we have to buffer
  // them until the channel is created in that case.
  struct PendingOperation {
    explicit PendingOperation(const uint32_t& aID,
                              const GamepadChangeEvent& aEvent,
                              Promise* aPromise = nullptr)
               : mID(aID), mEvent(aEvent), mPromise(aPromise) {}
    uint32_t mID;
    const GamepadChangeEvent& mEvent;
    RefPtr<Promise> mPromise;
  };

  // Hold a reference to the gamepad service so we don't have to worry about
  // execution order in tests.
  RefPtr<GamepadManager> mService;
  nsCOMPtr<nsPIDOMWindowInner> mWindow;
  nsTArray<PendingOperation> mPendingOperations;
  uint32_t mEventNumber;
  bool mShuttingDown;

  // IPDL Channel for us to send test events to GamepadPlatformService, it
  // will only be used in this singleton class and deleted during the IPDL
  // shutdown chain
  GamepadTestChannelChild* MOZ_NON_OWNING_REF mChild;

  explicit GamepadServiceTest(nsPIDOMWindowInner* aWindow);
  ~GamepadServiceTest();
  void InitPBackgroundActor();
  void DestroyPBackgroundActor();
  void FlushPendingOperations();

};

} // namespace dom
} // namespace mozilla

#endif
