/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_layers_APZCCallbackHelper_h
#define mozilla_layers_APZCCallbackHelper_h

#include "FrameMetrics.h"
#include "InputData.h"
#include "mozilla/EventForwards.h"
#include "mozilla/Function.h"
#include "mozilla/layers/APZUtils.h"
#include "nsIDOMWindowUtils.h"

class nsIContent;
class nsIDocument;
class nsIPresShell;
class nsIScrollableFrame;
class nsIWidget;
template<class T> struct already_AddRefed;
template<class T> class nsCOMPtr;

namespace mozilla {
namespace layers {

typedef function<void(uint64_t, const nsTArray<TouchBehaviorFlags>&)>
        SetAllowedTouchBehaviorCallback;

/* This class contains some helper methods that facilitate implementing the
   GeckoContentController callback interface required by the AsyncPanZoomController.
   Since different platforms need to implement this interface in similar-but-
   not-quite-the-same ways, this utility class provides some helpful methods
   to hold code that can be shared across the different platform implementations.
 */
class APZCCallbackHelper
{
    typedef mozilla::layers::FrameMetrics FrameMetrics;
    typedef mozilla::layers::ScrollableLayerGuid ScrollableLayerGuid;

public:
    /* Applies the scroll and zoom parameters from the given FrameMetrics object
       to the root frame for the given metrics' scrollId. If tiled thebes layers
       are enabled, this will align the displayport to tile boundaries. Setting
       the scroll position can cause some small adjustments to be made to the
       actual scroll position. aMetrics' display port and scroll position will
       be updated with any modifications made. */
    static void UpdateRootFrame(FrameMetrics& aMetrics);

    /* Applies the scroll parameters from the given FrameMetrics object to the
       subframe corresponding to given metrics' scrollId. If tiled thebes
       layers are enabled, this will align the displayport to tile boundaries.
       Setting the scroll position can cause some small adjustments to be made
       to the actual scroll position. aMetrics' display port and scroll position
       will be updated with any modifications made. */
    static void UpdateSubFrame(FrameMetrics& aMetrics);

    /* Get the presShellId and view ID for the given content element.
     * If the view ID does not exist, one is created.
     * The pres shell ID should generally already exist; if it doesn't for some
     * reason, false is returned. */
    static bool GetOrCreateScrollIdentifiers(nsIContent* aContent,
                                             uint32_t* aPresShellIdOut,
                                             FrameMetrics::ViewID* aViewIdOut);

    /* Initialize a zero-margin displayport on the root document element of the
       given presShell. */
    static void InitializeRootDisplayport(nsIPresShell* aPresShell);

    /* Get the pres context associated with the document enclosing |aContent|. */
    static nsPresContext* GetPresContextForContent(nsIContent* aContent);

    /* Get the pres shell associated with the root content document enclosing |aContent|. */
    static nsIPresShell* GetRootContentDocumentPresShellForContent(nsIContent* aContent);

    /* Apply an "input transform" to the given |aInput| and return the transformed value.
       The input transform applied is the one for the content element corresponding to
       |aGuid|; this is populated in a previous call to UpdateCallbackTransform. See that
       method's documentations for details.
       This method additionally adjusts |aInput| by inversely scaling by the provided
       pres shell resolution, to cancel out a compositor-side transform (added in
       bug 1076241) that APZ doesn't unapply. */
    static CSSPoint ApplyCallbackTransform(const CSSPoint& aInput,
                                           const ScrollableLayerGuid& aGuid);

    /* Same as above, but operates on LayoutDeviceIntPoint.
       Requires an additonal |aScale| parameter to convert between CSS and
       LayoutDevice space. */
    static mozilla::LayoutDeviceIntPoint
    ApplyCallbackTransform(const LayoutDeviceIntPoint& aPoint,
                           const ScrollableLayerGuid& aGuid,
                           const CSSToLayoutDeviceScale& aScale);

    /* Convenience function for applying a callback transform to all refpoints
     * in the input event. */
    static void ApplyCallbackTransform(WidgetEvent& aEvent,
                                       const ScrollableLayerGuid& aGuid,
                                       const CSSToLayoutDeviceScale& aScale);

    /* Dispatch a widget event via the widget stored in the event, if any.
     * In a child process, allows the TabParent event-capture mechanism to
     * intercept the event. */
    static nsEventStatus DispatchWidgetEvent(WidgetGUIEvent& aEvent);

    /* Synthesize a mouse event with the given parameters, and dispatch it
     * via the given widget. */
    static nsEventStatus DispatchSynthesizedMouseEvent(EventMessage aMsg,
                                                       uint64_t aTime,
                                                       const LayoutDevicePoint& aRefPoint,
                                                       Modifiers aModifiers,
                                                       int32_t aClickCount,
                                                       nsIWidget* aWidget);

    /* Dispatch a mouse event with the given parameters.
     * Return whether or not any listeners have called preventDefault on the event. */
    static bool DispatchMouseEvent(const nsCOMPtr<nsIPresShell>& aPresShell,
                                   const nsString& aType,
                                   const CSSPoint& aPoint,
                                   int32_t aButton,
                                   int32_t aClickCount,
                                   int32_t aModifiers,
                                   bool aIgnoreRootScrollFrame,
                                   unsigned short aInputSourceArg);

    /* Fire a single-tap event at the given point. The event is dispatched
     * via the given widget. */
    static void FireSingleTapEvent(const LayoutDevicePoint& aPoint,
                                   Modifiers aModifiers,
                                   int32_t aClickCount,
                                   nsIWidget* aWidget);

    /* Perform hit-testing on the touch points of |aEvent| to determine
     * which scrollable frames they target. If any of these frames don't have
     * a displayport, set one.
     *
     * If any displayports need to be set, the actual notification to APZ is
     * sent to the compositor, which will then post a message back to APZ's
     * controller thread. Otherwise, the provided widget's SetConfirmedTargetAPZC
     * method is invoked immediately.
     */
    static void SendSetTargetAPZCNotification(nsIWidget* aWidget,
                                              nsIDocument* aDocument,
                                              const WidgetGUIEvent& aEvent,
                                              const ScrollableLayerGuid& aGuid,
                                              uint64_t aInputBlockId);

    /* Figure out the allowed touch behaviors of each touch point in |aEvent|
     * and send that information to the provided callback. */
    static void SendSetAllowedTouchBehaviorNotification(nsIWidget* aWidget,
                                                        nsIDocument* aDocument,
                                                        const WidgetTouchEvent& aEvent,
                                                        uint64_t aInputBlockId,
                                                        const SetAllowedTouchBehaviorCallback& aCallback);

    /* Notify content of a mouse scroll testing event. */
    static void NotifyMozMouseScrollEvent(const FrameMetrics::ViewID& aScrollId, const nsString& aEvent);

    /* Notify content that the repaint flush is complete. */
    static void NotifyFlushComplete(nsIPresShell* aShell);

    /* Temporarily ignore the Displayport for better paint performance. If at
     * all possible, pass in a presShell if you have one at the call site, we
     * use it to trigger a repaint once suppression is disabled. Without that
     * the displayport may get left at the suppressed size for an extended
     * period of time and result in unnecessary checkerboarding (see bug
     * 1255054). */
    static void SuppressDisplayport(const bool& aEnabled,
                                    const nsCOMPtr<nsIPresShell>& aShell);

    /* Whether or not displayport suppression should be turned on. Note that
     * this only affects the return value of |IsDisplayportSuppressed()|, and
     * doesn't change the value of the internal counter. As with
     * SuppressDisplayport, this function should be passed a presShell to trigger
     * a repaint if suppression is being turned off.
     */
    static void RespectDisplayPortSuppression(bool aEnabled,
                                              const nsCOMPtr<nsIPresShell>& aShell);

    /* Whether or not the displayport is currently suppressed. */
    static bool IsDisplayportSuppressed();

    static void
    AdjustDisplayPortForScrollDelta(mozilla::layers::FrameMetrics& aFrameMetrics,
                                    const CSSPoint& aActualScrollOffset);

    /*
     * Check if the scrollable frame is currently in the middle of an async
     * or smooth scroll. We want to discard certain scroll input if this is
     * true to prevent clobbering higher priority origins.
     */
    static bool
    IsScrollInProgress(nsIScrollableFrame* aFrame);

    /* Notify content of the progress of a pinch gesture that APZ won't do
     * zooming for (because the apz.allow_zooming pref is false). This function
     * will dispatch appropriate WidgetSimpleGestureEvent events to gecko.
     */
    static void NotifyPinchGesture(PinchGestureInput::PinchGestureType aType,
                                   LayoutDeviceCoord aSpanChange,
                                   Modifiers aModifiers,
                                   nsIWidget* aWidget);
private:
  static uint64_t sLastTargetAPZCNotificationInputBlock;
};

} // namespace layers
} // namespace mozilla

#endif /* mozilla_layers_APZCCallbackHelper_h */
