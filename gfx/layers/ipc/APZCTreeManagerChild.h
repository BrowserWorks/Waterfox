/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_layers_APZCTreeManagerChild_h
#define mozilla_layers_APZCTreeManagerChild_h

#include "mozilla/layers/APZInputBridge.h"
#include "mozilla/layers/IAPZCTreeManager.h"
#include "mozilla/layers/PAPZCTreeManagerChild.h"

namespace mozilla {
namespace layers {

class APZInputBridgeChild;
class RemoteCompositorSession;

class APZCTreeManagerChild final : public IAPZCTreeManager,
                                   public PAPZCTreeManagerChild {
  friend class PAPZCTreeManagerChild;
  using TapType = GeckoContentController_TapType;

 public:
  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(APZCTreeManagerChild, final);

  APZCTreeManagerChild();

  void SetCompositorSession(RemoteCompositorSession* aSession);
  void SetInputBridge(RefPtr<APZInputBridgeChild>&& aInputBridge);
  void Destroy();

  void ZoomToRect(const ScrollableLayerGuid& aGuid,
                  const ZoomTarget& aZoomTarget,
                  const uint32_t aFlags = DEFAULT_BEHAVIOR) override;

  void ContentReceivedInputBlock(uint64_t aInputBlockId,
                                 bool aPreventDefault) override;

  void SetTargetAPZC(uint64_t aInputBlockId,
                     const nsTArray<ScrollableLayerGuid>& aTargets) override;

  void UpdateZoomConstraints(
      const ScrollableLayerGuid& aGuid,
      const Maybe<ZoomConstraints>& aConstraints) override;

  void SetAllowedTouchBehavior(
      uint64_t aInputBlockId,
      const nsTArray<TouchBehaviorFlags>& aValues) override;

  void StartScrollbarDrag(const ScrollableLayerGuid& aGuid,
                          const AsyncDragMetrics& aDragMetrics) override;

  void NotifyApzAwareListenerAdded(const ScrollableLayerGuid& aGuid) override;

  RefPtr<APZInputBridge> InputBridge() override;

 protected:
  virtual ~APZCTreeManagerChild();

 private:
  MOZ_NON_OWNING_REF RemoteCompositorSession* mCompositorSession;
  RefPtr<APZInputBridgeChild> mInputBridge;
};

}  // namespace layers
}  // namespace mozilla

#endif  // mozilla_layers_APZCTreeManagerChild_h
