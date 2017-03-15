/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef InputData_h__
#define InputData_h__

#include "nsDebug.h"
#include "nsIDOMWheelEvent.h"
#include "nsIScrollableFrame.h"
#include "nsPoint.h"
#include "nsTArray.h"
#include "Units.h"
#include "mozilla/EventForwards.h"
#include "mozilla/TimeStamp.h"
#include "mozilla/gfx/MatrixFwd.h"

template<class E> struct already_AddRefed;
class nsIWidget;

namespace mozilla {

namespace layers {
class PAPZCTreeManagerParent;
class APZCTreeManagerChild;
}

namespace dom {
class Touch;
} // namespace dom

enum InputType
{
  // Warning, this enum is serialized and sent over IPC. If you reorder, add,
  // or remove a value, you need to update its ParamTraits<> in nsGUIEventIPC.h
  MULTITOUCH_INPUT,
  MOUSE_INPUT,
  PANGESTURE_INPUT,
  PINCHGESTURE_INPUT,
  TAPGESTURE_INPUT,
  SCROLLWHEEL_INPUT,

  // Used as an upper bound for ContiguousEnumSerializer
  SENTINEL_INPUT,
};

class MultiTouchInput;
class MouseInput;
class PanGestureInput;
class PinchGestureInput;
class TapGestureInput;
class ScrollWheelInput;

// This looks unnecessary now, but as we add more and more classes that derive
// from InputType (eventually probably almost as many as *Events.h has), it
// will be more and more clear what's going on with a macro that shortens the
// definition of the RTTI functions.
#define INPUTDATA_AS_CHILD_TYPE(type, enumID) \
  const type& As##type() const \
  { \
    MOZ_ASSERT(mInputType == enumID, "Invalid cast of InputData."); \
    return (const type&) *this; \
  } \
  type& As##type() \
  { \
    MOZ_ASSERT(mInputType == enumID, "Invalid cast of InputData."); \
    return (type&) *this; \
  }

/** Base input data class. Should never be instantiated. */
class InputData
{
public:
  // Warning, this class is serialized and sent over IPC. Any change to its
  // fields must be reflected in its ParamTraits<>, in nsGUIEventIPC.h
  InputType mInputType;
  // Time in milliseconds that this data is relevant to. This only really
  // matters when this data is used as an event. We use uint32_t instead of
  // TimeStamp because it is easier to convert from WidgetInputEvent. The time
  // is platform-specific but it in the case of B2G and Fennec it is since
  // startup.
  uint32_t mTime;
  // Set in parallel to mTime until we determine it is safe to drop
  // platform-specific event times (see bug 77992).
  TimeStamp mTimeStamp;

  Modifiers modifiers;

  INPUTDATA_AS_CHILD_TYPE(MultiTouchInput, MULTITOUCH_INPUT)
  INPUTDATA_AS_CHILD_TYPE(MouseInput, MOUSE_INPUT)
  INPUTDATA_AS_CHILD_TYPE(PanGestureInput, PANGESTURE_INPUT)
  INPUTDATA_AS_CHILD_TYPE(PinchGestureInput, PINCHGESTURE_INPUT)
  INPUTDATA_AS_CHILD_TYPE(TapGestureInput, TAPGESTURE_INPUT)
  INPUTDATA_AS_CHILD_TYPE(ScrollWheelInput, SCROLLWHEEL_INPUT)

  virtual ~InputData();
  explicit InputData(InputType aInputType);

protected:
  InputData(InputType aInputType, uint32_t aTime, TimeStamp aTimeStamp,
            Modifiers aModifiers);
};

/**
 * Data container for a single touch input. Similar to dom::Touch, but used in
 * off-main-thread situations. This is more for just storing touch data, whereas
 * dom::Touch is more useful for dispatching through the DOM (which can only
 * happen on the main thread). dom::Touch also bears the problem of storing
 * pointers to nsIWidget instances which can only be used on the main thread,
 * so if instead we used dom::Touch and ever set these pointers
 * off-main-thread, Bad Things Can Happen(tm).
 *
 * Note that this doesn't inherit from InputData because this itself is not an
 * event. It is only a container/struct that should have any number of instances
 * within a MultiTouchInput.
 *
 * fixme/bug 775746: Make dom::Touch inherit from this class.
 */
class SingleTouchData
{
public:
  // Construct a SingleTouchData from a Screen point.
  // mLocalScreenPoint remains (0,0) unless it's set later.
  SingleTouchData(int32_t aIdentifier,
                  ScreenIntPoint aScreenPoint,
                  ScreenSize aRadius,
                  float aRotationAngle,
                  float aForce);

  // Construct a SingleTouchData from a ParentLayer point.
  // mScreenPoint remains (0,0) unless it's set later.
  // Note: if APZ starts using the radius for anything, we should add a local
  // version of that too, and have this constructor take it as a ParentLayerSize.
  SingleTouchData(int32_t aIdentifier,
                  ParentLayerPoint aLocalScreenPoint,
                  ScreenSize aRadius,
                  float aRotationAngle,
                  float aForce);

  SingleTouchData();

  already_AddRefed<dom::Touch> ToNewDOMTouch() const;

  // Warning, this class is serialized and sent over IPC. Any change to its
  // fields must be reflected in its ParamTraits<>, in nsGUIEventIPC.h

  // A unique number assigned to each SingleTouchData within a MultiTouchInput so
  // that they can be easily distinguished when handling a touch start/move/end.
  int32_t mIdentifier;

  // Point on the screen that the touch hit, in device pixels. They are
  // coordinates on the screen.
  ScreenIntPoint mScreenPoint;

  // |mScreenPoint| transformed to the local coordinates of the APZC targeted
  // by the hit. This is set and used by APZ.
  ParentLayerPoint mLocalScreenPoint;

  // Radius that the touch covers, i.e. if you're using your thumb it will
  // probably be larger than using your pinky, even with the same force.
  // Radius can be different along x and y. For example, if you press down with
  // your entire finger vertically, the y radius will be much larger than the x
  // radius.
  ScreenSize mRadius;

  float mRotationAngle;

  // How hard the screen is being pressed.
  float mForce;
};

/**
 * Similar to WidgetTouchEvent, but for use off-main-thread. Also only stores a
 * screen touch point instead of the many different coordinate spaces
 * WidgetTouchEvent stores its touch point in. This includes a way to initialize
 * itself from a WidgetTouchEvent by copying all relevant data over. Note that
 * this copying from WidgetTouchEvent functionality can only be used on the main
 * thread.
 *
 * Stores an array of SingleTouchData.
 */
class MultiTouchInput : public InputData
{
public:
  enum MultiTouchType
  {
    // Warning, this enum is serialized and sent over IPC. If you reorder, add,
    // or remove a value, you need to update its ParamTraits<> in nsGUIEventIPC.h
    MULTITOUCH_START,
    MULTITOUCH_MOVE,
    MULTITOUCH_END,
    MULTITOUCH_CANCEL,

    // Used as an upper bound for ContiguousEnumSerializer
    MULTITOUCH_SENTINEL,
  };

  MultiTouchInput(MultiTouchType aType, uint32_t aTime, TimeStamp aTimeStamp,
                  Modifiers aModifiers);
  MultiTouchInput();
  MultiTouchInput(const MultiTouchInput& aOther);
  explicit MultiTouchInput(const WidgetTouchEvent& aTouchEvent);
  // This conversion from WidgetMouseEvent to MultiTouchInput is needed because
  // on the B2G emulator we can only receive mouse events, but we need to be
  // able to pan correctly. To do this, we convert the events into a format that
  // the panning code can handle. This code is very limited and only supports
  // SingleTouchData. It also sends garbage for the identifier, radius, force
  // and rotation angle.
  explicit MultiTouchInput(const WidgetMouseEvent& aMouseEvent);

  WidgetTouchEvent ToWidgetTouchEvent(nsIWidget* aWidget) const;
  WidgetMouseEvent ToWidgetMouseEvent(nsIWidget* aWidget) const;

  // Return the index into mTouches of the SingleTouchData with the given
  // identifier, or -1 if there is no such SingleTouchData.
  int32_t IndexOfTouch(int32_t aTouchIdentifier);

  bool TransformToLocal(const ScreenToParentLayerMatrix4x4& aTransform);

  // Warning, this class is serialized and sent over IPC. Any change to its
  // fields must be reflected in its ParamTraits<>, in nsGUIEventIPC.h
  MultiTouchType mType;
  nsTArray<SingleTouchData> mTouches;
  bool mHandledByAPZ;
};

class MouseInput : public InputData
{
protected:
  friend mozilla::layers::PAPZCTreeManagerParent;
  friend mozilla::layers::APZCTreeManagerChild;

  MouseInput();

public:
  enum MouseType
  {
    // Warning, this enum is serialized and sent over IPC. If you reorder, add,
    // or remove a value, you need to update its ParamTraits<> in nsGUIEventIPC.h
    MOUSE_NONE,
    MOUSE_MOVE,
    MOUSE_DOWN,
    MOUSE_UP,
    MOUSE_DRAG_START,
    MOUSE_DRAG_END,
    MOUSE_WIDGET_ENTER,
    MOUSE_WIDGET_EXIT,

    // Used as an upper bound for ContiguousEnumSerializer
    MOUSE_SENTINEL,
  };

  enum ButtonType
  {
    // Warning, this enum is serialized and sent over IPC. If you reorder, add,
    // or remove a value, you need to update its ParamTraits<> in nsGUIEventIPC.h
    LEFT_BUTTON,
    MIDDLE_BUTTON,
    RIGHT_BUTTON,
    NONE,

    // Used as an upper bound for ContiguousEnumSerializer
    BUTTON_SENTINEL,
  };

  MouseInput(MouseType aType, ButtonType aButtonType, uint16_t aInputSource,
             int16_t aButtons, const ScreenPoint& aPoint, uint32_t aTime,
             TimeStamp aTimeStamp, Modifiers aModifiers);
  explicit MouseInput(const WidgetMouseEventBase& aMouseEvent);

  bool IsLeftButton() const;

  bool TransformToLocal(const ScreenToParentLayerMatrix4x4& aTransform);
  WidgetMouseEvent ToWidgetMouseEvent(nsIWidget* aWidget) const;

  // Warning, this class is serialized and sent over IPC. Any change to its
  // fields must be reflected in its ParamTraits<>, in nsGUIEventIPC.h
  MouseType mType;
  ButtonType mButtonType;
  uint16_t mInputSource;
  int16_t mButtons;
  ScreenPoint mOrigin;
  ParentLayerPoint mLocalOrigin;
  bool mHandledByAPZ;
};

/**
 * Encapsulation class for pan events, can be used off-main-thread.
 * These events are currently only used for scrolling on desktop.
 */
class PanGestureInput : public InputData
{
protected:
  friend mozilla::layers::PAPZCTreeManagerParent;
  friend mozilla::layers::APZCTreeManagerChild;

  PanGestureInput();

public:
  enum PanGestureType
  {
    // Warning, this enum is serialized and sent over IPC. If you reorder, add,
    // or remove a value, you need to update its ParamTraits<> in nsGUIEventIPC.h

    // MayStart: Dispatched before any actual panning has occurred but when a
    // pan gesture is probably about to start, for example when the user
    // starts touching the touchpad. Should interrupt any ongoing APZ
    // animation and can be used to trigger scrollability indicators (e.g.
    // flashing overlay scrollbars).
    PANGESTURE_MAYSTART,

    // Cancelled: Dispatched after MayStart when no pan gesture is going to
    // happen after all, for example when the user lifts their fingers from a
    // touchpad without having done any scrolling.
    PANGESTURE_CANCELLED,

    // Start: A pan gesture is starting.
    // For devices that do not support the MayStart event type, this event can
    // be used to interrupt ongoing APZ animations.
    PANGESTURE_START,

    // Pan: The actual pan motion by mPanDisplacement.
    PANGESTURE_PAN,

    // End: The pan gesture has ended, for example because the user has lifted
    // their fingers from a touchpad after scrolling.
    // Any potential momentum events fire after this event.
    PANGESTURE_END,

    // The following momentum event types are used in order to control the pan
    // momentum animation. Using these instead of our own animation ensures
    // that the animation curve is OS native and that the animation stops
    // reliably if it is cancelled by the user.

    // MomentumStart: Dispatched between the End event of the actual
    // user-controlled pan, and the first MomentumPan event of the momentum
    // animation.
    PANGESTURE_MOMENTUMSTART,

    // MomentumPan: The actual momentum motion by mPanDisplacement.
    PANGESTURE_MOMENTUMPAN,

    // MomentumEnd: The momentum animation has ended, for example because the
    // momentum velocity has gone below the stopping threshold, or because the
    // user has stopped the animation by putting their fingers on a touchpad.
    PANGESTURE_MOMENTUMEND,

    // Used as an upper bound for ContiguousEnumSerializer
    PANGESTURE_SENTINEL,
  };

  PanGestureInput(PanGestureType aType,
                  uint32_t aTime,
                  TimeStamp aTimeStamp,
                  const ScreenPoint& aPanStartPoint,
                  const ScreenPoint& aPanDisplacement,
                  Modifiers aModifiers);

  bool IsMomentum() const;

  WidgetWheelEvent ToWidgetWheelEvent(nsIWidget* aWidget) const;

  bool TransformToLocal(const ScreenToParentLayerMatrix4x4& aTransform);

  ScreenPoint UserMultipliedPanDisplacement() const;
  ParentLayerPoint UserMultipliedLocalPanDisplacement() const;

  // Warning, this class is serialized and sent over IPC. Any change to its
  // fields must be reflected in its ParamTraits<>, in nsGUIEventIPC.h
  PanGestureType mType;
  ScreenPoint mPanStartPoint;

  // The delta. This can be non-zero on any type of event.
  ScreenPoint mPanDisplacement;

  // Versions of |mPanStartPoint| and |mPanDisplacement| in the local
  // coordinates of the APZC receiving the pan. These are set and used by APZ.
  ParentLayerPoint mLocalPanStartPoint;
  ParentLayerPoint mLocalPanDisplacement;

  // See lineOrPageDeltaX/Y on WidgetWheelEvent.
  int32_t mLineOrPageDeltaX;
  int32_t mLineOrPageDeltaY;

  // User-set delta multipliers.
  double mUserDeltaMultiplierX;
  double mUserDeltaMultiplierY;

  bool mHandledByAPZ;

  // true if this is a PANGESTURE_END event that will be followed by a
  // PANGESTURE_MOMENTUMSTART event.
  bool mFollowedByMomentum;

  // If this is true, and this event started a new input block that couldn't
  // find a scrollable target which is scrollable in the horizontal component
  // of the scroll start direction, then this input block needs to be put on
  // hold until a content response has arrived, even if the block has a
  // confirmed target.
  // This is used by events that can result in a swipe instead of a scroll.
  bool mRequiresContentResponseIfCannotScrollHorizontallyInStartDirection;
};

/**
 * Encapsulation class for pinch events. In general, these will be generated by
 * a gesture listener by looking at SingleTouchData/MultiTouchInput instances and
 * determining whether or not the user was trying to do a gesture.
 */
class PinchGestureInput : public InputData
{
protected:
  friend mozilla::layers::PAPZCTreeManagerParent;
  friend mozilla::layers::APZCTreeManagerChild;

  PinchGestureInput();

public:
  enum PinchGestureType
  {
    // Warning, this enum is serialized and sent over IPC. If you reorder, add,
    // or remove a value, you need to update its ParamTraits<> in nsGUIEventIPC.h
    PINCHGESTURE_START,
    PINCHGESTURE_SCALE,
    PINCHGESTURE_END,

    // Used as an upper bound for ContiguousEnumSerializer
    PINCHGESTURE_SENTINEL,
  };

  // Construct a pinch gesture from a ParentLayer point.
  // mFocusPoint remains (0,0) unless it's set later.
  PinchGestureInput(PinchGestureType aType, uint32_t aTime, TimeStamp aTimeStamp,
                    const ParentLayerPoint& aLocalFocusPoint,
                    ParentLayerCoord aCurrentSpan,
                    ParentLayerCoord aPreviousSpan, Modifiers aModifiers);

  bool TransformToLocal(const ScreenToParentLayerMatrix4x4& aTransform);

  // Warning, this class is serialized and sent over IPC. Any change to its
  // fields must be reflected in its ParamTraits<>, in nsGUIEventIPC.h
  PinchGestureType mType;

  // Center point of the pinch gesture. That is, if there are two fingers on the
  // screen, it is their midpoint. In the case of more than two fingers, the
  // point is implementation-specific, but can for example be the midpoint
  // between the very first and very last touch. This is in device pixels and
  // are the coordinates on the screen of this midpoint.
  // For PINCHGESTURE_END events, this instead will hold the coordinates of
  // the remaining finger, if there is one. If there isn't one then it will
  // store -1, -1.
  ScreenPoint mFocusPoint;

  // |mFocusPoint| transformed to the local coordinates of the APZC targeted
  // by the hit. This is set and used by APZ.
  ParentLayerPoint mLocalFocusPoint;

  // The distance between the touches responsible for the pinch gesture.
  ParentLayerCoord mCurrentSpan;

  // The previous |mCurrentSpan| in the PinchGestureInput preceding this one.
  // This is only really relevant during a PINCHGESTURE_SCALE because when it is
  // of this type then there must have been a history of spans.
  ParentLayerCoord mPreviousSpan;
};

/**
 * Encapsulation class for tap events. In general, these will be generated by
 * a gesture listener by looking at SingleTouchData/MultiTouchInput instances and
 * determining whether or not the user was trying to do a gesture.
 */
class TapGestureInput : public InputData
{
protected:
  friend mozilla::layers::PAPZCTreeManagerParent;
  friend mozilla::layers::APZCTreeManagerChild;

  TapGestureInput();

public:
  enum TapGestureType
  {
    // Warning, this enum is serialized and sent over IPC. If you reorder, add,
    // or remove a value, you need to update its ParamTraits<> in nsGUIEventIPC.h
    TAPGESTURE_LONG,
    TAPGESTURE_LONG_UP,
    TAPGESTURE_UP,
    TAPGESTURE_CONFIRMED,
    TAPGESTURE_DOUBLE,
    TAPGESTURE_SECOND, // See GeckoContentController::TapType::eSecondTap
    TAPGESTURE_CANCEL,

    // Used as an upper bound for ContiguousEnumSerializer
    TAPGESTURE_SENTINEL,
  };

  // Construct a tap gesture from a Screen point.
  // mLocalPoint remains (0,0) unless it's set later.
  TapGestureInput(TapGestureType aType, uint32_t aTime, TimeStamp aTimeStamp,
                  const ScreenIntPoint& aPoint, Modifiers aModifiers);

  // Construct a tap gesture from a ParentLayer point.
  // mPoint remains (0,0) unless it's set later.
  TapGestureInput(TapGestureType aType, uint32_t aTime, TimeStamp aTimeStamp,
                  const ParentLayerPoint& aLocalPoint, Modifiers aModifiers);

  bool TransformToLocal(const ScreenToParentLayerMatrix4x4& aTransform);

  // Warning, this class is serialized and sent over IPC. Any change to its
  // fields must be reflected in its ParamTraits<>, in nsGUIEventIPC.h
  TapGestureType mType;

  // The location of the tap in screen pixels.
  ScreenIntPoint mPoint;

  // The location of the tap in the local coordinates of the APZC receiving it.
  // This is set and used by APZ.
  ParentLayerPoint mLocalPoint;
};

// Encapsulation class for scroll-wheel events. These are generated by mice
// with physical scroll wheels, and on Windows by most touchpads when using
// scroll gestures.
class ScrollWheelInput : public InputData
{
protected:
  friend mozilla::layers::PAPZCTreeManagerParent;
  friend mozilla::layers::APZCTreeManagerChild;

  ScrollWheelInput();

public:
  enum ScrollDeltaType
  {
    // Warning, this enum is serialized and sent over IPC. If you reorder, add,
    // or remove a value, you need to update its ParamTraits<> in nsGUIEventIPC.h

    // There are three kinds of scroll delta modes in Gecko: "page", "line" and
    // "pixel".
    SCROLLDELTA_LINE,
    SCROLLDELTA_PAGE,
    SCROLLDELTA_PIXEL,

    // Used as an upper bound for ContiguousEnumSerializer
    SCROLLDELTA_SENTINEL,
  };

  enum ScrollMode
  {
    // Warning, this enum is serialized and sent over IPC. If you reorder, add,
    // or remove a value, you need to update its ParamTraits<> in nsGUIEventIPC.h

    SCROLLMODE_INSTANT,
    SCROLLMODE_SMOOTH,

    // Used as an upper bound for ContiguousEnumSerializer
    SCROLLMODE_SENTINEL,
  };

  ScrollWheelInput(uint32_t aTime, TimeStamp aTimeStamp, Modifiers aModifiers,
                   ScrollMode aScrollMode, ScrollDeltaType aDeltaType,
                   const ScreenPoint& aOrigin, double aDeltaX, double aDeltaY,
                   bool aAllowToOverrideSystemScrollSpeed);
  explicit ScrollWheelInput(const WidgetWheelEvent& aEvent);

  static ScrollDeltaType DeltaTypeForDeltaMode(uint32_t aDeltaMode);
  static uint32_t DeltaModeForDeltaType(ScrollDeltaType aDeltaType);
  static nsIScrollableFrame::ScrollUnit ScrollUnitForDeltaType(ScrollDeltaType aDeltaType);

  WidgetWheelEvent ToWidgetWheelEvent(nsIWidget* aWidget) const;
  bool TransformToLocal(const ScreenToParentLayerMatrix4x4& aTransform);

  bool IsCustomizedByUserPrefs() const;

  // Warning, this class is serialized and sent over IPC. Any change to its
  // fields must be reflected in its ParamTraits<>, in nsGUIEventIPC.h
  ScrollDeltaType mDeltaType;
  ScrollMode mScrollMode;
  ScreenPoint mOrigin;

  bool mHandledByAPZ;

  // Deltas are in units corresponding to the delta type. For line deltas, they
  // are the number of line units to scroll. The number of device pixels for a
  // horizontal and vertical line unit are in FrameMetrics::mLineScrollAmount.
  // For pixel deltas, these values are in ScreenCoords.
  //
  // The horizontal (X) delta is > 0 for scrolling right and < 0 for scrolling
  // left. The vertical (Y) delta is < 0 for scrolling up and > 0 for
  // scrolling down.
  double mDeltaX;
  double mDeltaY;

  // The location of the scroll in local coordinates. This is set and used by
  // APZ.
  ParentLayerPoint mLocalOrigin;

  // See lineOrPageDeltaX/Y on WidgetWheelEvent.
  int32_t mLineOrPageDeltaX;
  int32_t mLineOrPageDeltaY;

  // Indicates the order in which this event was added to a transaction. The
  // first event is 1; if not a member of a transaction, this is 0.
  uint32_t mScrollSeriesNumber;

  // User-set delta multipliers.
  double mUserDeltaMultiplierX;
  double mUserDeltaMultiplierY;

  bool mMayHaveMomentum;
  bool mIsMomentum;
  bool mAllowToOverrideSystemScrollSpeed;
};

} // namespace mozilla

#endif // InputData_h__
