/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "gtest/gtest.h"
#include "mozilla/MouseEvents.h"
#include "mozilla/layers/APZInputBridgeChild.h"
#include "mozilla/layers/APZCTreeManagerChild.h"
#include "mozilla/layers/APZThreadUtils.h"
#include "nsThreadUtils.h"

using namespace mozilla;
using namespace mozilla::layers;

namespace {

class DestroyingAPZInputBridgeChild final : public APZInputBridgeChild {
 public:
  DestroyingAPZInputBridgeChild(APZCTreeManagerChild& aManager,
                                bool& aIsDestroyed)
      : APZInputBridgeChild(0),
        mManager(aManager),
        mIsDestroyed(aIsDestroyed) {}

  APZEventResult ReceiveInputEvent(InputData& aEvent,
                                   InputBlockCallback&& aCallback) override {
    bool& isDestroyed = mIsDestroyed;
    mManager.Destroy();
    EXPECT_FALSE(isDestroyed);
    return APZEventResult();
  }

 private:
  ~DestroyingAPZInputBridgeChild() override { mIsDestroyed = true; }

  APZCTreeManagerChild& mManager;
  bool& mIsDestroyed;
};

}  // namespace

class APZInputBridgeTester : public ::testing::Test {
 protected:
  void SetUp() override {
    APZThreadUtils::SetControllerThread(NS_GetCurrentThread());
  }

  void TearDown() override { APZThreadUtils::SetControllerThread(nullptr); }
};

TEST_F(APZInputBridgeTester, DestroyOwnerDuringMouseInput) {
  bool isDestroyed = false;
  auto manager = MakeRefPtr<APZCTreeManagerChild>();
  manager->SetInputBridge(
      MakeRefPtr<DestroyingAPZInputBridgeChild>(*manager, isDestroyed));

  WidgetMouseEvent event(true, eMouseMove, nullptr, WidgetMouseEvent::eReal);
  EXPECT_EQ(manager->InputBridge()->ReceiveInputEvent(event).GetStatus(),
            nsEventStatus_eIgnore);
  EXPECT_TRUE(isDestroyed);
}
