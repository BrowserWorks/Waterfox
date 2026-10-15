/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_layers_IAPZCTreeManager_h
#define mozilla_layers_IAPZCTreeManager_h

#include <stdint.h>  // for uint64_t, uint32_t

#include "mozilla/RefPtr.h"  // for RefPtr

#include "mozilla/layers/LayersTypes.h"          // for TouchBehaviorFlags
#include "mozilla/layers/ScrollableLayerGuid.h"  // for ScrollableLayerGuid, etc
#include "mozilla/layers/ZoomConstraints.h"      // for ZoomConstraints
#include "nsTArrayForwardDeclare.h"  // for nsTArray, nsTArray_Impl, etc
#include "nsISupportsImpl.h"         // for MOZ_COUNT_CTOR, etc
#include "Units.h"                   // for CSSRect, etc

namespace mozilla {
namespace layers {

class APZInputBridge;
struct ZoomTarget;

enum AllowedTouchBehavior {
  NONE = 0,
  VERTICAL_PAN = 1 << 0,
  HORIZONTAL_PAN = 1 << 1,
  PINCH_ZOOM = 1 << 2,
  ANIMATING_ZOOM = 1 << 3,
  UNKNOWN = 1 << 4
};

enum ZoomToRectBehavior : uint32_t {
  DEFAULT_BEHAVIOR = 0,
  DISABLE_ZOOM_OUT = 1 << 0,
  PAN_INTO_VIEW_ONLY = 1 << 1,
  ONLY_ZOOM_TO_DEFAULT_SCALE = 1 << 2,
  ZOOM_TO_FOCUSED_INPUT = 1 << 3,
  ZOOM_TO_FOCUSED_INPUT_ON_RESIZES_VISUAL = 1 << 4,
};

class AsyncDragMetrics;
struct APZHandledResult;

class IAPZCTreeManager {
  NS_INLINE_DECL_PURE_VIRTUAL_REFCOUNTING

 public:
  /**
   * Kicks an animation to zoom to a rect. This may be either a zoom out or zoom
   * in. The actual animation is done on the sampler thread after being set
   * up. |aRect| must be given in CSS pixels, relative to the document.
   * |aFlags| is a combination of the ZoomToRectBehavior enum values.
   */
  virtual void ZoomToRect(const ScrollableLayerGuid& aGuid,
                          const ZoomTarget& aZoomTarget,
                          const uint32_t aFlags = DEFAULT_BEHAVIOR) = 0;

  /**
   * If we have touch listeners, this should always be called when we know
   * definitively whether or not content has preventDefaulted any touch events
   * that have come in. If |aPreventDefault| is true, any touch events in the
   * queue will be discarded. This function must be called on the controller
   * thread.
   */
  virtual void ContentReceivedInputBlock(uint64_t aInputBlockId,
                                         bool aPreventDefault) = 0;

  /**
   * When the event regions code is enabled, this function should be invoked to
   * to confirm the target of the input block. This is only needed in cases
   * where the initial input event of the block hit a dispatch-to-content region
   * but is safe to call for all input blocks. This function should always be
   * invoked on the controller thread.
   * The different elements in the array of targets correspond to the targets
   * for the different touch points. In the case where the touch point has no
   * target, or the target is not a scrollable frame, the target's |mScrollId|
   * should be set to ScrollableLayerGuid::NULL_SCROLL_ID.
   */
  virtual void SetTargetAPZC(uint64_t aInputBlockId,
                             const nsTArray<ScrollableLayerGuid>& aTargets) = 0;

  /**
   * Updates any zoom constraints contained in the <meta name="viewport"> tag.
   * If the |aConstraints| is Nothing() then previously-provided constraints for
   * the given |aGuid| are cleared.
   */
  virtual void UpdateZoomConstraints(
      const ScrollableLayerGuid& aGuid,
      const Maybe<ZoomConstraints>& aConstraints) = 0;

  /**
   * Sets allowed touch behavior values for current touch-session for specific
   * input block (determined by aInputBlock).
   * Should be invoked by the widget. Each value of the aValues arrays
   * corresponds to the different touch point that is currently active.
   * Must be called after receiving the TOUCH_START event that starts the
   * touch-session.
   * This must be called on the controller thread.
   */
  virtual void SetAllowedTouchBehavior(
      uint64_t aInputBlockId, const nsTArray<TouchBehaviorFlags>& aValues) = 0;

  virtual void StartScrollbarDrag(const ScrollableLayerGuid& aGuid,
                                  const AsyncDragMetrics& aDragMetrics) = 0;

  /**
   * Notify APZ that the content process has just registered a non-passive
   * APZ-aware event listener (touchstart/touchmove/touchend/wheel/...).
   * |aGuid| identifies the nearest scroll container ancestor of the
   * listener target (root scroll container for document/window listeners).
   * APZ uses this signal to flag subsequent hit-test results whose target
   * matches |aGuid| or any of its APZC-tree descendants with
   * eApzAwareListeners, without waiting for a full paint and WebRender
   * transaction.
   */
  virtual void NotifyApzAwareListenerAdded(
      const ScrollableLayerGuid& aGuid) = 0;

  /**
   * Returns an APZInputBridge interface that can be used to send input
   * events to APZ in a synchronous manner. The returned strong reference keeps
   * the bridge alive if its owner is destroyed during a synchronous call.
   * It is only valid to call this function in the UI process.
   */
  virtual RefPtr<APZInputBridge> InputBridge() = 0;

 protected:
  // Discourage destruction outside of decref

  virtual ~IAPZCTreeManager() = default;
};

}  // namespace layers
}  // namespace mozilla

#endif  // mozilla_layers_IAPZCTreeManager_h
