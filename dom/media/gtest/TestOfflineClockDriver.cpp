/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "MockGraphInterface.h"
#include "gtest/gtest.h"
#include "mozilla/gtest/WaitFor.h"

using namespace mozilla;
using testing::InSequence;
using testing::Return;

TEST(TestOfflineClockDriver, TimeAdvance)
MOZ_CAN_RUN_SCRIPT_BOUNDARY {
  TrackRate rate =
      CubebUtils::PreferredSampleRate(/* aShouldResistFingerprinting */ false);
  RefPtr graph = new MockGraphInterface(rate);
  RefPtr driver = new OfflineClockDriver(graph, rate);
  MozPromiseHolder<GenericPromise> doneHolder;
  RefPtr<GenericPromise> done = doneHolder.Ensure(__func__);
  {
    GraphTime length = WEBAUDIO_BLOCK_SIZE / 4;  // < WEBAUDIO_BLOCK_SIZE
    auto EnsureNextIteration = [&](GraphTime aTime) {
      driver->EnsureNextIteration();
    };
    InSequence s;
    EXPECT_CALL(*graph, MockIteration(0))
        // Time should not advance on the first iteration to process control
        // messages
        .WillOnce(EnsureNextIteration)
        // ... nor on subsequent.
        .WillOnce([&driver, length](GraphTime aTime) {
          driver->SetTickCountToRender(length);
          driver->EnsureNextIteration();
        });
    EXPECT_CALL(*graph, MockIteration(WEBAUDIO_BLOCK_SIZE))
        // Rendering iteration
        .WillOnce(EnsureNextIteration)
        // Time should not advance after rendering.
        .WillOnce([&](GraphTime aTime) {
          // Tell the driver to exit its event loop.
          graph->StopIterating();
          RefPtr(doneHolder.Steal())->Resolve(true, __func__);
        });
  }

  graph->SetCurrentDriver(driver);
  driver->EnsureNextIteration();
  driver->Start();
  WaitForResolve(done);
  // Clean up.
  driver->Shutdown();
}
