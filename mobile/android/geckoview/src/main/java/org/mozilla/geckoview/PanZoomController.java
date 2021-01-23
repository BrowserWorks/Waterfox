/* -*- Mode: Java; c-basic-offset: 4; tab-width: 20; indent-tabs-mode: nil; -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.geckoview;

import org.mozilla.gecko.GeckoAppShell;
import org.mozilla.gecko.PrefsHelper;
import org.mozilla.gecko.annotation.WrapForJNI;
import org.mozilla.gecko.mozglue.JNIObject;
import org.mozilla.gecko.util.GeckoBundle;
import org.mozilla.gecko.util.ThreadUtils;

import android.app.UiModeManager;
import android.content.Context;
import android.content.res.Configuration;
import android.graphics.Rect;
import android.os.SystemClock;
import android.support.annotation.NonNull;
import android.support.annotation.UiThread;
import android.support.annotation.IntDef;
import android.util.Log;
import android.util.Pair;
import android.view.MotionEvent;
import android.view.InputDevice;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

import java.util.ArrayList;

@UiThread
public class PanZoomController {
    private static final String LOGTAG = "GeckoNPZC";
    private static final int EVENT_SOURCE_SCROLL = 0;
    private static final int EVENT_SOURCE_MOTION = 1;
    private static final int EVENT_SOURCE_MOUSE = 2;
    private static final String PREF_MOUSE_AS_TOUCH = "ui.android.mouse_as_touch";
    private static boolean sTreatMouseAsTouch = true;

    private final GeckoSession mSession;
    private final Rect mTempRect = new Rect();
    private boolean mAttached;
    private float mPointerScrollFactor = 64.0f;
    private long mLastDownTime;

    @Retention(RetentionPolicy.SOURCE)
    @IntDef({SCROLL_BEHAVIOR_SMOOTH, SCROLL_BEHAVIOR_AUTO})
    /* package */ @interface ScrollBehaviorType {}

    /**
     * Specifies smooth scrolling which animates content to the desired scroll position.
     */
    public static final int SCROLL_BEHAVIOR_SMOOTH = 0;
    /**
     * Specifies auto scrolling which jumps content to the desired scroll position.
     */
    public static final int SCROLL_BEHAVIOR_AUTO = 1;

    @Retention(RetentionPolicy.SOURCE)
    @IntDef({INPUT_RESULT_UNHANDLED, INPUT_RESULT_HANDLED, INPUT_RESULT_HANDLED_CONTENT})
    /* package */ @interface InputResult {}

    /**
     * Specifies that an input event was not handled by the PanZoomController for a panning
     * or zooming operation. The event may have been handled by Web content or
     * internally (e.g. text selection).
     */
    @WrapForJNI
    public static final int INPUT_RESULT_UNHANDLED = 0;

    /**
     * Specifies that an input event was handled by the PanZoomController for a
     * panning or zooming operation, but likely not by any touch event listeners in Web content.
     */
    @WrapForJNI
    public static final int INPUT_RESULT_HANDLED = 1;

    /**
     * Specifies that an input event was handled by the PanZoomController and passed on
     * to touch event listeners in Web content.
     */
    @WrapForJNI
    public static final int INPUT_RESULT_HANDLED_CONTENT = 2;

    private SynthesizedEventState mPointerState;

    private ArrayList<Pair<Integer, MotionEvent>> mQueuedEvents;

    private boolean mSynthesizedEvent = false;

    /* package */ final class NativeProvider extends JNIObject {
        @Override // JNIObject
        protected void disposeNative() {
            // Disposal happens in native code.
            throw new UnsupportedOperationException();
        }

        @WrapForJNI(calledFrom = "ui")
        private native @InputResult int handleMotionEvent(
               int action, int actionIndex, long time, int metaState,  float screenX, float screenY,
               int pointerId[], float x[], float y[], float orientation[], float pressure[],
               float toolMajor[], float toolMinor[]);

        @WrapForJNI(calledFrom = "ui")
        private native @InputResult int handleScrollEvent(
                long time, int metaState,
                float x, float y,
                float hScroll, float vScroll);

        @WrapForJNI(calledFrom = "ui")
        private native @InputResult int handleMouseEvent(
                int action, long time, int metaState,
                float x, float y, int buttons);

        @WrapForJNI(stubName = "SetIsLongpressEnabled") // Called from test thread.
        private native void nativeSetIsLongpressEnabled(boolean isLongpressEnabled);

        @WrapForJNI(calledFrom = "ui")
        private void synthesizeNativeTouchPoint(final int pointerId, final int eventType,
                                                final int clientX, final int clientY,
                                                final double pressure, final int orientation) {
            if (pointerId == PointerInfo.RESERVED_MOUSE_POINTER_ID) {
                throw new IllegalArgumentException("Pointer ID reserved for mouse");
            }
            synthesizeNativePointer(InputDevice.SOURCE_TOUCHSCREEN, pointerId,
                    eventType, clientX, clientY, pressure, orientation);
        }

        @WrapForJNI(calledFrom = "ui")
        private void synthesizeNativeMouseEvent(final int eventType, final int clientX,
                                                final int clientY) {
            synthesizeNativePointer(InputDevice.SOURCE_MOUSE,
                    PointerInfo.RESERVED_MOUSE_POINTER_ID,
                    eventType, clientX, clientY, 0, 0);
        }

        @WrapForJNI(calledFrom = "ui")
        private void setAttached(final boolean attached) {
            if (attached) {
                mAttached = true;
                flushEventQueue();
            } else if (mAttached) {
                mAttached = false;
                enableEventQueue();
            }
        }
    }

    /* package */ final NativeProvider mNative = new NativeProvider();

    private @InputResult int handleMotionEvent(final MotionEvent event) {
        if (!mAttached) {
            mQueuedEvents.add(new Pair<>(EVENT_SOURCE_MOTION, event));
            return INPUT_RESULT_HANDLED;
        }

        final int action = event.getActionMasked();
        final int count = event.getPointerCount();

        if (action == MotionEvent.ACTION_DOWN) {
            mLastDownTime = event.getDownTime();
        } else if (mLastDownTime != event.getDownTime()) {
            return INPUT_RESULT_UNHANDLED;
        }

        final int[] pointerId = new int[count];
        final float[] x = new float[count];
        final float[] y = new float[count];
        final float[] orientation = new float[count];
        final float[] pressure = new float[count];
        final float[] toolMajor = new float[count];
        final float[] toolMinor = new float[count];

        final MotionEvent.PointerCoords coords = new MotionEvent.PointerCoords();

        for (int i = 0; i < count; i++) {
            pointerId[i] = event.getPointerId(i);
            event.getPointerCoords(i, coords);

            x[i] = coords.x;
            y[i] = coords.y;

            orientation[i] = coords.orientation;
            pressure[i] = coords.pressure;

            // If we are converting to CSS pixels, we should adjust the radii as well.
            toolMajor[i] = coords.toolMajor;
            toolMinor[i] = coords.toolMinor;
        }

        final float screenX = event.getRawX() - event.getX();
        final float screenY = event.getRawY() - event.getY();

        // Take this opportunity to update screen origin of session. This gets
        // dispatched to the gecko thread, so we also pass the new screen x/y directly to apz.
        // If this is a synthesized touch, the screen offset is bogus so ignore it.
        if (!mSynthesizedEvent) {
            mSession.onScreenOriginChanged((int)screenX, (int)screenY);
        }

        return mNative.handleMotionEvent(action, event.getActionIndex(), event.getEventTime(),
                                         event.getMetaState(), screenX, screenY, pointerId, x, y,
                                         orientation, pressure, toolMajor, toolMinor);
    }

    private @InputResult int handleScrollEvent(final MotionEvent event) {
        if (!mAttached) {
            mQueuedEvents.add(new Pair<>(EVENT_SOURCE_SCROLL, event));
            return INPUT_RESULT_HANDLED;
        }

        final int count = event.getPointerCount();

        if (count <= 0) {
            return INPUT_RESULT_UNHANDLED;
        }

        final MotionEvent.PointerCoords coords = new MotionEvent.PointerCoords();
        event.getPointerCoords(0, coords);

        // Translate surface origin to client origin for scroll events.
        mSession.getSurfaceBounds(mTempRect);
        final float x = coords.x - mTempRect.left;
        final float y = coords.y - mTempRect.top;

        final float hScroll = event.getAxisValue(MotionEvent.AXIS_HSCROLL) *
                              mPointerScrollFactor;
        final float vScroll = event.getAxisValue(MotionEvent.AXIS_VSCROLL) *
                              mPointerScrollFactor;

        return mNative.handleScrollEvent(event.getEventTime(), event.getMetaState(), x, y,
                                         hScroll, vScroll);
    }

    private @InputResult int handleMouseEvent(final MotionEvent event) {
        if (!mAttached) {
            mQueuedEvents.add(new Pair<>(EVENT_SOURCE_MOUSE, event));
            return INPUT_RESULT_UNHANDLED;
        }

        final int count = event.getPointerCount();

        if (count <= 0) {
            return INPUT_RESULT_UNHANDLED;
        }

        final MotionEvent.PointerCoords coords = new MotionEvent.PointerCoords();
        event.getPointerCoords(0, coords);

        // Translate surface origin to client origin for mouse events.
        mSession.getSurfaceBounds(mTempRect);
        final float x = coords.x - mTempRect.left;
        final float y = coords.y - mTempRect.top;

        return mNative.handleMouseEvent(event.getActionMasked(), event.getEventTime(),
                                        event.getMetaState(), x, y, event.getButtonState());
    }

    protected PanZoomController(final GeckoSession session) {
        mSession = session;
        enableEventQueue();
        initMouseAsTouch();
    }

    private static void initMouseAsTouch() {
        PrefsHelper.PrefHandler prefHandler = new PrefsHelper.PrefHandlerBase() {
            @Override
            public void prefValue(final String pref, final int value) {
                if (!PREF_MOUSE_AS_TOUCH.equals(pref)) {
                    return;
                }
                if (value == 0) {
                    sTreatMouseAsTouch = false;
                } else if (value == 1) {
                    sTreatMouseAsTouch = true;
                } else if (value == 2) {
                    Context c = GeckoAppShell.getApplicationContext();
                    UiModeManager m = (UiModeManager)c.getSystemService(Context.UI_MODE_SERVICE);
                    // on TV devices, treat mouse as touch. everywhere else, don't
                    sTreatMouseAsTouch = (m.getCurrentModeType() == Configuration.UI_MODE_TYPE_TELEVISION);
                }
            }
        };
        PrefsHelper.addObserver(new String[] { PREF_MOUSE_AS_TOUCH }, prefHandler);
        PrefsHelper.getPref(PREF_MOUSE_AS_TOUCH, prefHandler);
    }

    /**
     * Set the current scroll factor. The scroll factor is the maximum scroll amount that
     * one scroll event may generate, in device pixels.
     *
     * @param factor Scroll factor.
     */
    public void setScrollFactor(final float factor) {
        ThreadUtils.assertOnUiThread();
        mPointerScrollFactor = factor;
    }

    /**
     * Get the current scroll factor.
     *
     * @return Scroll factor.
     */
    public float getScrollFactor() {
        ThreadUtils.assertOnUiThread();
        return mPointerScrollFactor;
    }

    /**
     * Process a touch event through the pan-zoom controller. Treat any mouse events as
     * "touch" rather than as "mouse". Pointer coordinates should be relative to the
     * display surface.
     *
     * @param event MotionEvent to process.
     * @return One of the {@link PanZoomController#INPUT_RESULT_UNHANDLED INPUT_RESULT_*}) constants indicating how the event was handled.
     */
    public @InputResult int onTouchEvent(final @NonNull MotionEvent event) {
        ThreadUtils.assertOnUiThread();

        if (!sTreatMouseAsTouch && event.getToolType(0) == MotionEvent.TOOL_TYPE_MOUSE) {
            return handleMouseEvent(event);
        }
        return handleMotionEvent(event);
    }

    /**
     * Process a touch event through the pan-zoom controller. Treat any mouse events as
     * "mouse" rather than as "touch". Pointer coordinates should be relative to the
     * display surface.
     *
     * @param event MotionEvent to process.
     * @return One of the {@link PanZoomController#INPUT_RESULT_UNHANDLED INPUT_RESULT_*}) constants indicating how the event was handled.
     */
    public @InputResult int onMouseEvent(final @NonNull MotionEvent event) {
        ThreadUtils.assertOnUiThread();

        if (event.getToolType(0) == MotionEvent.TOOL_TYPE_MOUSE) {
            return handleMouseEvent(event);
        }
        return handleMotionEvent(event);
    }

    @Override
    protected void finalize() throws Throwable {
        mNative.setAttached(false);
    }

    /**
     * Process a non-touch motion event through the pan-zoom controller. Currently, hover
     * and scroll events are supported. Pointer coordinates should be relative to the
     * display surface.
     *
     * @param event MotionEvent to process.
     * @return One of the {@link PanZoomController#INPUT_RESULT_UNHANDLED INPUT_RESULT_*}) indicating how the event was handled.
     */
    public @InputResult int onMotionEvent(final @NonNull MotionEvent event) {
        ThreadUtils.assertOnUiThread();

        final int action = event.getActionMasked();
        if (action == MotionEvent.ACTION_SCROLL) {
            if (event.getDownTime() >= mLastDownTime) {
                mLastDownTime = event.getDownTime();
            } else if ((InputDevice.getDevice(event.getDeviceId()) != null) &&
                       (InputDevice.getDevice(event.getDeviceId()).getSources() &
                        InputDevice.SOURCE_TOUCHPAD) == InputDevice.SOURCE_TOUCHPAD) {
                return INPUT_RESULT_UNHANDLED;
            }
            return handleScrollEvent(event);
        } else if ((action == MotionEvent.ACTION_HOVER_MOVE) ||
                   (action == MotionEvent.ACTION_HOVER_ENTER) ||
                   (action == MotionEvent.ACTION_HOVER_EXIT)) {
            return handleMouseEvent(event);
        } else {
            return INPUT_RESULT_UNHANDLED;
        }
    }

    private void enableEventQueue() {
        if (mQueuedEvents != null) {
            throw new IllegalStateException("Already have an event queue");
        }
        mQueuedEvents = new ArrayList<>();
    }

    private void flushEventQueue() {
        if (mQueuedEvents == null) {
            return;
        }

        ArrayList<Pair<Integer, MotionEvent>> events = mQueuedEvents;
        mQueuedEvents = null;
        for (Pair<Integer, MotionEvent> pair : events) {
            switch (pair.first) {
                case EVENT_SOURCE_MOTION:
                    handleMotionEvent(pair.second);
                    break;
                case EVENT_SOURCE_SCROLL:
                    handleScrollEvent(pair.second);
                    break;
                case EVENT_SOURCE_MOUSE:
                    handleMouseEvent(pair.second);
                    break;
            }
        }
    }

    /**
     * Set whether Gecko should generate long-press events.
     *
     * @param isLongpressEnabled True if Gecko should generate long-press events.
     */
    public void setIsLongpressEnabled(final boolean isLongpressEnabled) {
        ThreadUtils.assertOnUiThread();

        if (mAttached) {
            mNative.nativeSetIsLongpressEnabled(isLongpressEnabled);
        }
    }

    private static class PointerInfo {
        // We reserve one pointer ID for the mouse, so that tests don't have
        // to worry about tracking pointer IDs if they just want to test mouse
        // event synthesization. If somebody tries to use this ID for a
        // synthesized touch event we'll throw an exception.
        public static final int RESERVED_MOUSE_POINTER_ID = 100000;

        public int pointerId;
        public int source;
        public int surfaceX;
        public int surfaceY;
        public double pressure;
        public int orientation;

        public MotionEvent.PointerCoords getCoords() {
            MotionEvent.PointerCoords coords = new MotionEvent.PointerCoords();
            coords.orientation = orientation;
            coords.pressure = (float)pressure;
            coords.x = surfaceX;
            coords.y = surfaceY;
            return coords;
        }
    }

    private static class SynthesizedEventState {
        public final ArrayList<PointerInfo> pointers;
        public long downTime;

        SynthesizedEventState() {
            pointers = new ArrayList<PointerInfo>();
        }

        int getPointerIndex(final int pointerId) {
            for (int i = 0; i < pointers.size(); i++) {
                if (pointers.get(i).pointerId == pointerId) {
                    return i;
                }
            }
            return -1;
        }

        int addPointer(final int pointerId, final int source) {
            PointerInfo info = new PointerInfo();
            info.pointerId = pointerId;
            info.source = source;
            pointers.add(info);
            return pointers.size() - 1;
        }

        int getPointerCount(final int source) {
            int count = 0;
            for (int i = 0; i < pointers.size(); i++) {
                if (pointers.get(i).source == source) {
                    count++;
                }
            }
            return count;
        }

        MotionEvent.PointerProperties[] getPointerProperties(final int source) {
            MotionEvent.PointerProperties[] props =
                    new MotionEvent.PointerProperties[getPointerCount(source)];
            int index = 0;
            for (int i = 0; i < pointers.size(); i++) {
                if (pointers.get(i).source == source) {
                    MotionEvent.PointerProperties p = new MotionEvent.PointerProperties();
                    p.id = pointers.get(i).pointerId;
                    switch (source) {
                        case InputDevice.SOURCE_TOUCHSCREEN:
                            p.toolType = MotionEvent.TOOL_TYPE_FINGER;
                            break;
                        case InputDevice.SOURCE_MOUSE:
                            p.toolType = MotionEvent.TOOL_TYPE_MOUSE;
                            break;
                    }
                    props[index++] = p;
                }
            }
            return props;
        }

        MotionEvent.PointerCoords[] getPointerCoords(final int source) {
            MotionEvent.PointerCoords[] coords =
                    new MotionEvent.PointerCoords[getPointerCount(source)];
            int index = 0;
            for (int i = 0; i < pointers.size(); i++) {
                if (pointers.get(i).source == source) {
                    coords[index++] = pointers.get(i).getCoords();
                }
            }
            return coords;
        }
    }

    private void synthesizeNativePointer(final int source, final int pointerId,
                                         final int originalEventType,
                                         final int clientX, final int clientY,
                                         final double pressure, final int orientation) {
        if (mPointerState == null) {
            mPointerState = new SynthesizedEventState();
        }

        // Find the pointer if it already exists
        int pointerIndex = mPointerState.getPointerIndex(pointerId);

        // Event-specific handling
        int eventType = originalEventType;
        switch (originalEventType) {
            case MotionEvent.ACTION_POINTER_UP:
                if (pointerIndex < 0) {
                    Log.w(LOGTAG, "Pointer-up for invalid pointer");
                    return;
                }
                if (mPointerState.pointers.size() == 1) {
                    // Last pointer is going up
                    eventType = MotionEvent.ACTION_UP;
                }
                break;
            case MotionEvent.ACTION_CANCEL:
                if (pointerIndex < 0) {
                    Log.w(LOGTAG, "Pointer-cancel for invalid pointer");
                    return;
                }
                break;
            case MotionEvent.ACTION_POINTER_DOWN:
                if (pointerIndex < 0) {
                    // Adding a new pointer
                    pointerIndex = mPointerState.addPointer(pointerId, source);
                    if (pointerIndex == 0) {
                        // first pointer
                        eventType = MotionEvent.ACTION_DOWN;
                        mPointerState.downTime = SystemClock.uptimeMillis();
                    }
                } else {
                    // We're moving an existing pointer
                    eventType = MotionEvent.ACTION_MOVE;
                }
                break;
            case MotionEvent.ACTION_HOVER_MOVE:
                if (pointerIndex < 0) {
                    // Mouse-move a pointer without it going "down". However
                    // in order to send the right MotionEvent without a lot of
                    // duplicated code, we add the pointer to mPointerState,
                    // and then remove it at the bottom of this function.
                    pointerIndex = mPointerState.addPointer(pointerId, source);
                } else {
                    // We're moving an existing mouse pointer that went down.
                    eventType = MotionEvent.ACTION_MOVE;
                }
                break;
        }

        // Translate client origin to surface origin.
        mSession.getSurfaceBounds(mTempRect);
        final int surfaceX = clientX + mTempRect.left;
        final int surfaceY = clientY + mTempRect.top;

        // Update the pointer with the new info
        PointerInfo info = mPointerState.pointers.get(pointerIndex);
        info.surfaceX = surfaceX;
        info.surfaceY = surfaceY;
        info.pressure = pressure;
        info.orientation = orientation;

        // Dispatch the event
        int action = 0;
        if (eventType == MotionEvent.ACTION_POINTER_DOWN ||
            eventType == MotionEvent.ACTION_POINTER_UP) {
            // for pointer-down and pointer-up events we need to add the
            // index of the relevant pointer.
            action = (pointerIndex << MotionEvent.ACTION_POINTER_INDEX_SHIFT);
            action &= MotionEvent.ACTION_POINTER_INDEX_MASK;
        }
        action |= (eventType & MotionEvent.ACTION_MASK);
        boolean isButtonDown = (source == InputDevice.SOURCE_MOUSE) &&
                               (eventType == MotionEvent.ACTION_DOWN ||
                                eventType == MotionEvent.ACTION_MOVE);
        final MotionEvent event = MotionEvent.obtain(
            /*downTime*/ mPointerState.downTime,
            /*eventTime*/ SystemClock.uptimeMillis(),
            /*action*/ action,
            /*pointerCount*/ mPointerState.getPointerCount(source),
            /*pointerProperties*/ mPointerState.getPointerProperties(source),
            /*pointerCoords*/ mPointerState.getPointerCoords(source),
            /*metaState*/ 0,
            /*buttonState*/ (isButtonDown ? MotionEvent.BUTTON_PRIMARY : 0),
            /*xPrecision*/ 0,
            /*yPrecision*/ 0,
            /*deviceId*/ 0,
            /*edgeFlags*/ 0,
            /*source*/ source,
            /*flags*/ 0);

        mSynthesizedEvent = true;
        onTouchEvent(event);
        mSynthesizedEvent = false;

        // Forget about removed pointers
        if (eventType == MotionEvent.ACTION_POINTER_UP ||
            eventType == MotionEvent.ACTION_UP ||
            eventType == MotionEvent.ACTION_CANCEL ||
            eventType == MotionEvent.ACTION_HOVER_MOVE) {
            mPointerState.pointers.remove(pointerIndex);
        }
    }

    /**
     * Scroll the document body by an offset from the current scroll position.
     * Uses {@link #SCROLL_BEHAVIOR_SMOOTH}.
     *
     * @param width {@link ScreenLength} offset to scroll along X axis.
     * @param height {@link ScreenLength} offset to scroll along Y axis.
     */
    @UiThread
    public void scrollBy(final @NonNull ScreenLength width, final @NonNull ScreenLength height) {
        scrollBy(width, height, SCROLL_BEHAVIOR_SMOOTH);
    }

    /**
     * Scroll the document body by an offset from the current scroll position.
     *
     * @param width {@link ScreenLength} offset to scroll along X axis.
     * @param height {@link ScreenLength} offset to scroll along Y axis.
     * @param behavior ScrollBehaviorType One of {@link #SCROLL_BEHAVIOR_SMOOTH}, {@link #SCROLL_BEHAVIOR_AUTO},
     *                 that specifies how to scroll the content.
     */
    @UiThread
    public void scrollBy(final @NonNull ScreenLength width, final @NonNull ScreenLength height,
                         final @ScrollBehaviorType int behavior) {
        final GeckoBundle msg = buildScrollMessage(width, height, behavior);
        mSession.getEventDispatcher().dispatch("GeckoView:ScrollBy", msg);
    }

    /**
     * Scroll the document body to an absolute  position.
     * Uses {@link #SCROLL_BEHAVIOR_SMOOTH}.
     *
     * @param width {@link ScreenLength} position to scroll along X axis.
     * @param height {@link ScreenLength} position to scroll along Y axis.
     */
    @UiThread
    public void scrollTo(final @NonNull ScreenLength width, final @NonNull ScreenLength height) {
        scrollTo(width, height, SCROLL_BEHAVIOR_SMOOTH);
    }

    /**
     * Scroll the document body to an absolute position.
     *
     * @param width {@link ScreenLength} position to scroll along X axis.
     * @param height {@link ScreenLength} position to scroll along Y axis.
     * @param behavior ScrollBehaviorType One of {@link #SCROLL_BEHAVIOR_SMOOTH}, {@link #SCROLL_BEHAVIOR_AUTO},
     *                 that specifies how to scroll the content.
     */
    @UiThread
    public void scrollTo(final @NonNull ScreenLength width, final @NonNull ScreenLength height,
                         final @ScrollBehaviorType int behavior) {
        final GeckoBundle msg = buildScrollMessage(width, height, behavior);
        mSession.getEventDispatcher().dispatch("GeckoView:ScrollTo", msg);
    }

    /**
     * Scroll to the top left corner of the screen.
     * Uses {@link #SCROLL_BEHAVIOR_SMOOTH}.
     */
    @UiThread
    public void scrollToTop() {
        scrollTo(ScreenLength.zero(), ScreenLength.top(), SCROLL_BEHAVIOR_SMOOTH);
    }

    /**
     * Scroll to the bottom left corner of the screen.
     * Uses {@link #SCROLL_BEHAVIOR_SMOOTH}.
     */
    @UiThread
    public void scrollToBottom() {
        scrollTo(ScreenLength.zero(), ScreenLength.bottom(), SCROLL_BEHAVIOR_SMOOTH);
    }

    private GeckoBundle buildScrollMessage(final @NonNull ScreenLength width,
                                           final @NonNull ScreenLength height,
                                           final @ScrollBehaviorType int behavior) {
        final GeckoBundle msg = new GeckoBundle();
        msg.putDouble("widthValue", width.getValue());
        msg.putInt("widthType", width.getType());
        msg.putDouble("heightValue", height.getValue());
        msg.putInt("heightType", height.getType());
        msg.putInt("behavior", behavior);
        return msg;
    }
}
