/* -*- Mode: Java; c-basic-offset: 4; tab-width: 20; indent-tabs-mode: nil; -*-
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.animation;

import java.util.ArrayList;
import java.util.List;

import org.mozilla.gecko.AppConstants.Versions;

import android.os.Handler;
import android.support.v4.view.ViewCompat;
import android.view.Choreographer;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.view.animation.AnimationUtils;
import android.view.animation.DecelerateInterpolator;
import android.view.animation.Interpolator;

public class PropertyAnimator implements Runnable {
    private static final String LOGTAG = "GeckoPropertyAnimator";

    public static enum Property {
        ALPHA,
        TRANSLATION_X,
        TRANSLATION_Y,
        SCROLL_X,
        SCROLL_Y,
        WIDTH,
        HEIGHT
    }

    private class ElementHolder {
        View view;
        Property property;
        float from;
        float to;
    }

    public static interface PropertyAnimationListener {
        public void onPropertyAnimationStart();
        public void onPropertyAnimationEnd();
    }

    private final Interpolator mInterpolator;
    private long mStartTime;
    private final long mDuration;
    private final float mDurationReciprocal;
    private final List<ElementHolder> mElementsList;
    private List<PropertyAnimationListener> mListeners;
    FramePoster mFramePoster;
    private boolean mUseHardwareLayer;

    public PropertyAnimator(long duration) {
        this(duration, new DecelerateInterpolator());
    }

    public PropertyAnimator(long duration, Interpolator interpolator) {
        mDuration = duration;
        mDurationReciprocal = 1.0f / mDuration;
        mInterpolator = interpolator;
        mElementsList = new ArrayList<ElementHolder>();
        mFramePoster = FramePoster.create(this);
        mUseHardwareLayer = true;
    }

    public void setUseHardwareLayer(boolean useHardwareLayer) {
        mUseHardwareLayer = useHardwareLayer;
    }

    public void attach(View view, Property property, float to) {
        ElementHolder element = new ElementHolder();

        element.view = view;
        element.property = property;
        element.to = to;

        mElementsList.add(element);
    }

    public void addPropertyAnimationListener(PropertyAnimationListener listener) {
        if (mListeners == null) {
            mListeners = new ArrayList<PropertyAnimationListener>();
        }

        mListeners.add(listener);
    }

    public long getDuration() {
        return mDuration;
    }

    public long getRemainingTime() {
        int timePassed = (int) (AnimationUtils.currentAnimationTimeMillis() - mStartTime);
        return mDuration - timePassed;
    }

    @Override
    public void run() {
        int timePassed = (int) (AnimationUtils.currentAnimationTimeMillis() - mStartTime);
        if (timePassed >= mDuration) {
            stop();
            return;
        }

        float interpolation = mInterpolator.getInterpolation(timePassed * mDurationReciprocal);

        for (ElementHolder element : mElementsList) {
            float delta = element.from + ((element.to - element.from) * interpolation);
            invalidate(element, delta);
        }

        mFramePoster.postNextAnimationFrame();
    }

    public void start() {
        if (mDuration == 0) {
            return;
        }

        mStartTime = AnimationUtils.currentAnimationTimeMillis();

        // Fix the from value based on current position and property
        for (ElementHolder element : mElementsList) {
            if (element.property == Property.ALPHA)
                element.from = ViewHelper.getAlpha(element.view);
            else if (element.property == Property.TRANSLATION_Y)
                element.from = ViewHelper.getTranslationY(element.view);
            else if (element.property == Property.TRANSLATION_X)
                element.from = ViewHelper.getTranslationX(element.view);
            else if (element.property == Property.SCROLL_Y)
                element.from = ViewHelper.getScrollY(element.view);
            else if (element.property == Property.SCROLL_X)
                element.from = ViewHelper.getScrollX(element.view);
            else if (element.property == Property.WIDTH)
                element.from = ViewHelper.getWidth(element.view);
            else if (element.property == Property.HEIGHT)
                element.from = ViewHelper.getHeight(element.view);

            ViewCompat.setHasTransientState(element.view, true);

            if (shouldEnableHardwareLayer(element))
                element.view.setLayerType(View.LAYER_TYPE_HARDWARE, null);
            else
                element.view.setDrawingCacheEnabled(true);
        }

        // Get ViewTreeObserver from any of the participant views
        // in the animation.
        final ViewTreeObserver treeObserver;
        if (mElementsList.size() > 0) {
            treeObserver = mElementsList.get(0).view.getViewTreeObserver();
        } else {
            treeObserver = null;
        }

        final ViewTreeObserver.OnPreDrawListener preDrawListener = new ViewTreeObserver.OnPreDrawListener() {
            @Override
            public boolean onPreDraw() {
                if (treeObserver.isAlive()) {
                    treeObserver.removeOnPreDrawListener(this);
                }

                mFramePoster.postFirstAnimationFrame();
                return true;
            }
        };

        // Try to start animation after any on-going layout round
        // in the current view tree. OnPreDrawListener seems broken
        // on pre-Honeycomb devices, start animation immediatelly
        // in this case.
        if (treeObserver != null && treeObserver.isAlive()) {
            treeObserver.addOnPreDrawListener(preDrawListener);
        } else {
            mFramePoster.postFirstAnimationFrame();
        }

        if (mListeners != null) {
            for (PropertyAnimationListener listener : mListeners) {
                listener.onPropertyAnimationStart();
            }
        }
    }

    /**
     * Stop the animation, optionally snapping to the end position.
     * onPropertyAnimationEnd is only called when snapping to the end position.
     */
    public void stop(boolean snapToEndPosition) {
        mFramePoster.cancelAnimationFrame();

        // Make sure to snap to the end position.
        for (ElementHolder element : mElementsList) {
            if (snapToEndPosition)
                invalidate(element, element.to);

            ViewCompat.setHasTransientState(element.view, false);

            if (shouldEnableHardwareLayer(element)) {
                element.view.setLayerType(View.LAYER_TYPE_NONE, null);
            } else {
                element.view.setDrawingCacheEnabled(false);
            }
        }

        mElementsList.clear();

        if (mListeners != null) {
            if (snapToEndPosition) {
                for (PropertyAnimationListener listener : mListeners) {
                    listener.onPropertyAnimationEnd();
                }
            }

            mListeners.clear();
            mListeners = null;
        }
    }

    public void stop() {
        stop(true);
    }

    private boolean shouldEnableHardwareLayer(ElementHolder element) {
        if (!mUseHardwareLayer) {
            return false;
        }

        if (!(element.view instanceof ViewGroup)) {
            return false;
        }

        if (element.property == Property.ALPHA ||
            element.property == Property.TRANSLATION_Y ||
            element.property == Property.TRANSLATION_X) {
            return true;
        }

        return false;
    }

    private void invalidate(final ElementHolder element, final float delta) {
        final View view = element.view;

        // check to see if the view was detached between the check above and this code
        // getting run on the UI thread.
        if (view.getHandler() == null)
            return;

        if (element.property == Property.ALPHA)
            ViewHelper.setAlpha(element.view, delta);
        else if (element.property == Property.TRANSLATION_Y)
            ViewHelper.setTranslationY(element.view, delta);
        else if (element.property == Property.TRANSLATION_X)
            ViewHelper.setTranslationX(element.view, delta);
        else if (element.property == Property.SCROLL_Y)
            ViewHelper.scrollTo(element.view, ViewHelper.getScrollX(element.view), (int) delta);
        else if (element.property == Property.SCROLL_X)
            ViewHelper.scrollTo(element.view, (int) delta, ViewHelper.getScrollY(element.view));
        else if (element.property == Property.WIDTH)
            ViewHelper.setWidth(element.view, (int) delta);
        else if (element.property == Property.HEIGHT)
            ViewHelper.setHeight(element.view, (int) delta);
    }

    private static abstract class FramePoster {
        public static FramePoster create(Runnable r) {
            if (Versions.feature16Plus) {
                return new FramePosterPostJB(r);
            }

            return new FramePosterPreJB(r);
        }

        public abstract void postFirstAnimationFrame();
        public abstract void postNextAnimationFrame();
        public abstract void cancelAnimationFrame();
    }

    private static class FramePosterPreJB extends FramePoster {
        // Default refresh rate in ms.
        private static final int INTERVAL = 10;

        private final Handler mHandler;
        private final Runnable mRunnable;

        public FramePosterPreJB(Runnable r) {
            mHandler = new Handler();
            mRunnable = r;
        }

        @Override
        public void postFirstAnimationFrame() {
            mHandler.post(mRunnable);
        }

        @Override
        public void postNextAnimationFrame() {
            mHandler.postDelayed(mRunnable, INTERVAL);
        }

        @Override
        public void cancelAnimationFrame() {
            mHandler.removeCallbacks(mRunnable);
        }
    }

    private static class FramePosterPostJB extends FramePoster {
        private final Choreographer mChoreographer;
        private final Choreographer.FrameCallback mCallback;

        public FramePosterPostJB(final Runnable r) {
            mChoreographer = Choreographer.getInstance();

            mCallback = new Choreographer.FrameCallback() {
                @Override
                public void doFrame(long frameTimeNanos) {
                    r.run();
                }
            };
        }

        @Override
        public void postFirstAnimationFrame() {
            postNextAnimationFrame();
        }

        @Override
        public void postNextAnimationFrame() {
            mChoreographer.postFrameCallback(mCallback);
        }

        @Override
        public void cancelAnimationFrame() {
            mChoreographer.removeFrameCallback(mCallback);
        }
    }
}
