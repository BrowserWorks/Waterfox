/* -*- Mode: Java; c-basic-offset: 4; tab-width: 20; indent-tabs-mode: nil; -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.gfx;

import java.nio.ByteBuffer;
import java.nio.IntBuffer;

import org.mozilla.gecko.AndroidGamepadManager;
import org.mozilla.gecko.annotation.RobocopTarget;
import org.mozilla.gecko.annotation.WrapForJNI;
import org.mozilla.gecko.AppConstants;
import org.mozilla.gecko.AppConstants.Versions;
import org.mozilla.gecko.EventDispatcher;
import org.mozilla.gecko.GeckoAccessibility;
import org.mozilla.gecko.GeckoAppShell;
import org.mozilla.gecko.GeckoThread;
import org.mozilla.gecko.mozglue.JNIObject;
import org.mozilla.gecko.util.ThreadUtils;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Point;
import android.graphics.PointF;
import android.graphics.Rect;
import android.graphics.SurfaceTexture;
import android.os.Parcelable;
import android.util.AttributeSet;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.TextureView;
import android.view.View;
import android.view.ViewGroup;
import android.view.InputDevice;
import android.widget.FrameLayout;

/**
 * A view rendered by the layer compositor.
 */
public class LayerView extends FrameLayout {
    private static final String LOGTAG = "GeckoLayerView";

    private GeckoLayerClient mLayerClient;
    private PanZoomController mPanZoomController;
    private DynamicToolbarAnimator mToolbarAnimator;
    private LayerRenderer mRenderer;
    /* Must be a PAINT_xxx constant */
    private int mPaintState;
    private FullScreenState mFullScreenState;

    private SurfaceView mSurfaceView;
    private TextureView mTextureView;

    private Listener mListener;

    /* This should only be modified on the Java UI thread. */
    private final Overscroll mOverscroll;

    private boolean mServerSurfaceValid;
    private int mWidth, mHeight;

    private boolean onAttachedToWindowCalled;

    /* This is written by the Gecko thread and the UI thread, and read by the UI thread. */
    @WrapForJNI(stubName = "CompositorCreated", calledFrom = "ui")
    /* package */ volatile boolean mCompositorCreated;

    private class Compositor extends JNIObject {
        public Compositor() {
        }

        @WrapForJNI(calledFrom = "ui", dispatchTo = "gecko")
        @Override protected native void disposeNative();

        // Gecko thread sets its Java instances; does not block UI thread.
        @WrapForJNI(calledFrom = "any", dispatchTo = "gecko")
        /* package */ native void attachToJava(GeckoLayerClient layerClient,
                                               NativePanZoomController npzc);

        @WrapForJNI(calledFrom = "any", dispatchTo = "gecko")
        /* package */ native void onSizeChanged(int windowWidth, int windowHeight,
                                                int screenWidth, int screenHeight);

        // Gecko thread creates compositor; blocks UI thread.
        @WrapForJNI(calledFrom = "ui", dispatchTo = "proxy")
        /* package */ native void createCompositor(int width, int height, Object surface);

        // Gecko thread pauses compositor; blocks UI thread.
        @WrapForJNI(calledFrom = "ui", dispatchTo = "current")
        /* package */ native void syncPauseCompositor();

        // UI thread resumes compositor and notifies Gecko thread; does not block UI thread.
        @WrapForJNI(calledFrom = "ui", dispatchTo = "current")
        /* package */ native void syncResumeResizeCompositor(int width, int height, Object surface);

        @WrapForJNI(calledFrom = "any", dispatchTo = "current")
        /* package */ native void syncInvalidateAndScheduleComposite();

        @WrapForJNI(calledFrom = "gecko")
        private void reattach() {
            mCompositorCreated = true;
        }

        @WrapForJNI(calledFrom = "gecko")
        private void destroy() {
            // The nsWindow has been closed. First mark our compositor as destroyed.
            LayerView.this.mCompositorCreated = false;

            LayerView.this.mLayerClient.setGeckoReady(false);

            // Then clear out any pending calls on the UI thread by disposing on the UI thread.
            ThreadUtils.postToUiThread(new Runnable() {
                @Override
                public void run() {
                    disposeNative();
                }
            });
        }
    }

    private final Compositor mCompositor = new Compositor();

    /* Flags used to determine when to show the painted surface. */
    public static final int PAINT_START = 0;
    public static final int PAINT_BEFORE_FIRST = 1;
    public static final int PAINT_AFTER_FIRST = 2;

    public boolean shouldUseTextureView() {
        // Disable TextureView support for now as it causes panning/zooming
        // performance regressions (see bug 792259). Uncomment the code below
        // once this bug is fixed.
        return false;

        /*
        // we can only use TextureView on ICS or higher
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.ICE_CREAM_SANDWICH) {
            Log.i(LOGTAG, "Not using TextureView: not on ICS+");
            return false;
        }

        try {
            // and then we can only use it if we have a hardware accelerated window
            Method m = View.class.getMethod("isHardwareAccelerated", (Class[]) null);
            return (Boolean) m.invoke(this);
        } catch (Exception e) {
            Log.i(LOGTAG, "Not using TextureView: caught exception checking for hw accel: " + e.toString());
            return false;
        } */
    }

    public LayerView(Context context, AttributeSet attrs) {
        super(context, attrs);

        mPaintState = PAINT_START;
        mFullScreenState = FullScreenState.NONE;

        mOverscroll = new OverscrollEdgeEffect(this);
    }

    public LayerView(Context context) {
        this(context, null);
    }

    public void initializeView(EventDispatcher eventDispatcher) {
        mLayerClient = new GeckoLayerClient(getContext(), this, eventDispatcher);
        if (mOverscroll != null) {
            mLayerClient.setOverscrollHandler(mOverscroll);
        }

        mPanZoomController = mLayerClient.getPanZoomController();
        mToolbarAnimator = mLayerClient.getDynamicToolbarAnimator();

        mRenderer = new LayerRenderer(this);

        setFocusable(true);
        setFocusableInTouchMode(true);

        GeckoAccessibility.setDelegate(this);
    }

    /**
     * MotionEventHelper dragAsync() robocop tests can instruct
     * PanZoomController not to generate longpress events.
     */
    public void setIsLongpressEnabled(boolean isLongpressEnabled) {
        mPanZoomController.setIsLongpressEnabled(isLongpressEnabled);
    }

    private static Point getEventRadius(MotionEvent event) {
        return new Point((int)event.getToolMajor() / 2,
                         (int)event.getToolMinor() / 2);
    }

    public void showSurface() {
        // Fix this if TextureView support is turned back on above
        mSurfaceView.setVisibility(View.VISIBLE);
    }

    public void hideSurface() {
        // Fix this if TextureView support is turned back on above
        mSurfaceView.setVisibility(View.INVISIBLE);
    }

    public void destroy() {
        if (mLayerClient != null) {
            mLayerClient.destroy();
        }
        if (mRenderer != null) {
            mRenderer.destroy();
        }
    }

    @Override
    public void dispatchDraw(final Canvas canvas) {
        super.dispatchDraw(canvas);

        // We must have a layer client to get valid viewport metrics
        if (mLayerClient != null && mOverscroll != null) {
            mOverscroll.draw(canvas, getViewportMetrics());
        }
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        if (event.getActionMasked() == MotionEvent.ACTION_DOWN) {
            requestFocus();
        }

        if (mToolbarAnimator != null && mToolbarAnimator.onInterceptTouchEvent(event)) {
            if (mPanZoomController != null) {
                mPanZoomController.onMotionEventVelocity(event.getEventTime(), mToolbarAnimator.getVelocity());
            }
            return true;
        }
        if (!mLayerClient.isGeckoReady()) {
            // If gecko isn't loaded yet, don't try sending events to the
            // native code because it's just going to crash
            return true;
        }
        if (mPanZoomController != null && mPanZoomController.onTouchEvent(event)) {
            return true;
        }
        return false;
    }

    @Override
    public boolean onHoverEvent(MotionEvent event) {
        // If we get a touchscreen hover event, and accessibility is not enabled,
        // don't send it to gecko.
        if (event.getSource() == InputDevice.SOURCE_TOUCHSCREEN &&
            !GeckoAccessibility.isEnabled()) {
            return false;
        }

        if (!mLayerClient.isGeckoReady()) {
            // If gecko isn't loaded yet, don't try sending events to the
            // native code because it's just going to crash
            return true;
        } else if (mPanZoomController != null && mPanZoomController.onMotionEvent(event)) {
            return true;
        }

        return false;
    }

    @Override
    public boolean onGenericMotionEvent(MotionEvent event) {
        if (AndroidGamepadManager.handleMotionEvent(event)) {
            return true;
        }
        if (!mLayerClient.isGeckoReady()) {
            // If gecko isn't loaded yet, don't try sending events to the
            // native code because it's just going to crash
            return true;
        }
        if (mPanZoomController != null && mPanZoomController.onMotionEvent(event)) {
            return true;
        }
        return false;
    }

    @Override
    protected void onRestoreInstanceState(final Parcelable state) {
        if (onAttachedToWindowCalled) {
            attachCompositor();
        }
        super.onRestoreInstanceState(state);
    }

    @Override
    protected void onAttachedToWindow() {
        super.onAttachedToWindow();

        // We are adding descendants to this LayerView, but we don't want the
        // descendants to affect the way LayerView retains its focus.
        setDescendantFocusability(FOCUS_BLOCK_DESCENDANTS);

        // This check should not be done before the view is attached to a window
        // as hardware acceleration will not be enabled at that point.
        // We must create and add the SurfaceView instance before the view tree
        // is fully created to avoid flickering (see bug 801477).
        if (shouldUseTextureView()) {
            mTextureView = new TextureView(getContext());
            mTextureView.setSurfaceTextureListener(new SurfaceTextureListener());

            // The background is set to this color when the LayerView is
            // created, and it will be shown immediately at startup. Shortly
            // after, the tab's background color will be used before any content
            // is shown.
            mTextureView.setBackgroundColor(Color.WHITE);
            addView(mTextureView, ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
        } else {
            // This will stop PropertyAnimator from creating a drawing cache (i.e. a bitmap)
            // from a SurfaceView, which is just not possible (the bitmap will be transparent).
            setWillNotCacheDrawing(false);

            mSurfaceView = new LayerSurfaceView(getContext(), this);
            mSurfaceView.setBackgroundColor(Color.WHITE);
            addView(mSurfaceView, new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));

            SurfaceHolder holder = mSurfaceView.getHolder();
            holder.addCallback(new SurfaceListener());
        }

        attachCompositor();

        onAttachedToWindowCalled = true;
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();

        onAttachedToWindowCalled = false;
    }

    // Don't expose GeckoLayerClient to things outside this package; only expose it as an Object
    GeckoLayerClient getLayerClient() { return mLayerClient; }

    public PanZoomController getPanZoomController() { return mPanZoomController; }
    public DynamicToolbarAnimator getDynamicToolbarAnimator() { return mToolbarAnimator; }

    public ImmutableViewportMetrics getViewportMetrics() {
        return mLayerClient.getViewportMetrics();
    }

    public Matrix getMatrixForLayerRectToViewRect() {
        return mLayerClient.getMatrixForLayerRectToViewRect();
    }

    public void setSurfaceBackgroundColor(int newColor) {
        if (mSurfaceView != null) {
            mSurfaceView.setBackgroundColor(newColor);
        }
    }

    public void requestRender() {
        if (mCompositorCreated) {
            mCompositor.syncInvalidateAndScheduleComposite();
        }
    }

    public void postRenderTask(RenderTask task) {
        mRenderer.postRenderTask(task);
    }

    public void removeRenderTask(RenderTask task) {
        mRenderer.removeRenderTask(task);
    }

    public int getMaxTextureSize() {
        return mRenderer.getMaxTextureSize();
    }

    /** Used by robocop for testing purposes. Not for production use! */
    @RobocopTarget
    public IntBuffer getPixels() {
        return mRenderer.getPixels();
    }

    /* paintState must be a PAINT_xxx constant. */
    public void setPaintState(int paintState) {
        mPaintState = paintState;
    }

    public int getPaintState() {
        return mPaintState;
    }

    public LayerRenderer getRenderer() {
        return mRenderer;
    }

    public void setListener(Listener listener) {
        mListener = listener;
    }

    Listener getListener() {
        return mListener;
    }

    private void attachCompositor() {
        final NativePanZoomController npzc = (NativePanZoomController) mPanZoomController;

        if (GeckoThread.isStateAtLeast(GeckoThread.State.PROFILE_READY)) {
            mCompositor.attachToJava(mLayerClient, npzc);
        } else {
            GeckoThread.queueNativeCallUntil(GeckoThread.State.PROFILE_READY,
                    mCompositor, "attachToJava",
                    GeckoLayerClient.class, mLayerClient,
                    NativePanZoomController.class, npzc);
        }
    }

    @WrapForJNI(calledFrom = "ui")
    protected Object getCompositor() {
        return mCompositor;
    }

    void serverSurfaceChanged(int newWidth, int newHeight) {
        ThreadUtils.assertOnUiThread();

        mWidth = newWidth;
        mHeight = newHeight;
        mServerSurfaceValid = true;

        updateCompositor();
    }

    void updateCompositor() {
        ThreadUtils.assertOnUiThread();

        if (mCompositorCreated) {
            // If the compositor has already been created, just resume it instead. We don't need
            // to block here because if the surface is destroyed before the compositor grabs it,
            // we can handle that gracefully (i.e. the compositor will remain paused).
            if (!mServerSurfaceValid) {
                return;
            }
            // Asking Gecko to resume the compositor takes too long (see
            // https://bugzilla.mozilla.org/show_bug.cgi?id=735230#c23), so we
            // resume the compositor directly. We still need to inform Gecko about
            // the compositor resuming, so that Gecko knows that it can now draw.
            // It is important to not notify Gecko until after the compositor has
            // been resumed, otherwise Gecko may send updates that get dropped.
            mCompositor.syncResumeResizeCompositor(mWidth, mHeight, getSurface());
            return;
        }

        // Only try to create the compositor if we have a valid surface and gecko is up. When these
        // two conditions are satisfied, we can be relatively sure that the compositor creation will
        // happen without needing to block anywhere.
        if (mServerSurfaceValid && getLayerClient().isGeckoReady()) {
            mCompositorCreated = true;
            mCompositor.createCompositor(mWidth, mHeight, getSurface());
        }
    }

    /* When using a SurfaceView (mSurfaceView != null), resizing happens in two
     * phases. First, the LayerView changes size, then, often some frames later,
     * the SurfaceView changes size. Because of this, we need to split the
     * resize into two phases to avoid jittering.
     *
     * The first phase is the LayerView size change. mListener is notified so
     * that a synchronous draw can be performed (otherwise a blank frame will
     * appear).
     *
     * The second phase is the SurfaceView size change. At this point, the
     * backing GL surface is resized and another synchronous draw is performed.
     * Gecko is also sent the new window size, and this will likely cause an
     * extra draw a few frames later, after it's re-rendered and caught up.
     *
     * In the case that there is no valid GL surface (for example, when
     * resuming, or when coming back from the awesomescreen), or we're using a
     * TextureView instead of a SurfaceView, the first phase is skipped.
     */
    private void onSizeChanged(int width, int height) {
        if (!mServerSurfaceValid || mSurfaceView == null) {
            surfaceChanged(width, height);
            return;
        }

        if (mCompositorCreated) {
            mCompositor.syncResumeResizeCompositor(width, height, getSurface());
        }

        if (mOverscroll != null) {
            mOverscroll.setSize(width, height);
        }
    }

    private void surfaceChanged(int width, int height) {
        serverSurfaceChanged(width, height);

        if (mListener != null) {
            mListener.surfaceChanged(width, height);
        }

        if (mOverscroll != null) {
            mOverscroll.setSize(width, height);
        }
    }

    void notifySizeChanged(int windowWidth, int windowHeight, int screenWidth, int screenHeight) {
        mCompositor.onSizeChanged(windowWidth, windowHeight, screenWidth, screenHeight);
    }

    void serverSurfaceDestroyed() {
        ThreadUtils.assertOnUiThread();

        // We need to coordinate with Gecko when pausing composition, to ensure
        // that Gecko never executes a draw event while the compositor is paused.
        // This is sent synchronously to make sure that we don't attempt to use
        // any outstanding Surfaces after we call this (such as from a
        // serverSurfaceDestroyed notification), and to make sure that any in-flight
        // Gecko draw events have been processed.  When this returns, composition is
        // definitely paused -- it'll synchronize with the Gecko event loop, which
        // in turn will synchronize with the compositor thread.
        if (mCompositorCreated) {
            mCompositor.syncPauseCompositor();
        }

        mServerSurfaceValid = false;
    }

    private void onDestroyed() {
        serverSurfaceDestroyed();
    }

    public Object getNativeWindow() {
        if (mSurfaceView != null)
            return mSurfaceView.getHolder();

        return mTextureView.getSurfaceTexture();
    }

    public Object getSurface() {
      if (mSurfaceView != null) {
        return mSurfaceView.getHolder().getSurface();
      }
      return null;
    }

    // This method is called on the Gecko main thread.
    @WrapForJNI(calledFrom = "gecko")
    private static void updateZoomedView(ByteBuffer data) {
        LayerView layerView = GeckoAppShell.getLayerView();
        if (layerView != null) {
            LayerRenderer layerRenderer = layerView.getRenderer();
            if (layerRenderer != null) {
                layerRenderer.updateZoomedView(data);
            }
        }
    }

    public interface Listener {
        void surfaceChanged(int width, int height);
    }

    private class SurfaceListener implements SurfaceHolder.Callback {
        @Override
        public void surfaceChanged(SurfaceHolder holder, int format, int width,
                                                int height) {
            onSizeChanged(width, height);
        }

        @Override
        public void surfaceCreated(SurfaceHolder holder) {
        }

        @Override
        public void surfaceDestroyed(SurfaceHolder holder) {
            onDestroyed();
        }
    }

    /* A subclass of SurfaceView to listen to layout changes, as
     * View.OnLayoutChangeListener requires API level 11.
     */
    private class LayerSurfaceView extends SurfaceView {
        private LayerView mParent;

        public LayerSurfaceView(Context aContext, LayerView aParent) {
            super(aContext);
            mParent = aParent;
        }

        @Override
        protected void onLayout(boolean changed, int left, int top, int right, int bottom) {
            super.onLayout(changed, left, top, right, bottom);
            if (changed && mParent.mServerSurfaceValid) {
                mParent.surfaceChanged(right - left, bottom - top);
            }
        }
    }

    private class SurfaceTextureListener implements TextureView.SurfaceTextureListener {
        @Override
        public void onSurfaceTextureAvailable(SurfaceTexture surface, int width, int height) {
            // We don't do this for surfaceCreated above because it is always followed by a surfaceChanged,
            // but that is not the case here.
            onSizeChanged(width, height);
        }

        @Override
        public boolean onSurfaceTextureDestroyed(SurfaceTexture surface) {
            onDestroyed();
            return true; // allow Android to call release() on the SurfaceTexture, we are done drawing to it
        }

        @Override
        public void onSurfaceTextureSizeChanged(SurfaceTexture surface, int width, int height) {
            onSizeChanged(width, height);
        }

        @Override
        public void onSurfaceTextureUpdated(SurfaceTexture surface) {

        }
    }

    @RobocopTarget
    public void addDrawListener(DrawListener listener) {
        mLayerClient.addDrawListener(listener);
    }

    @RobocopTarget
    public void removeDrawListener(DrawListener listener) {
        mLayerClient.removeDrawListener(listener);
    }

    @RobocopTarget
    public static interface DrawListener {
        public void drawFinished();
    }

    @Override
    public void setOverScrollMode(int overscrollMode) {
        super.setOverScrollMode(overscrollMode);
    }

    @Override
    public int getOverScrollMode() {
        return super.getOverScrollMode();
    }

    public float getZoomFactor() {
        return getLayerClient().getViewportMetrics().zoomFactor;
    }

    @Override
    public void onFocusChanged (boolean gainFocus, int direction, Rect previouslyFocusedRect) {
        super.onFocusChanged(gainFocus, direction, previouslyFocusedRect);
        GeckoAccessibility.onLayerViewFocusChanged(gainFocus);
    }

    public void setFullScreenState(FullScreenState state) {
        mFullScreenState = state;
    }

    public boolean isFullScreen() {
        return mFullScreenState != FullScreenState.NONE;
    }

    public void setMaxTranslation(float aMaxTranslation) {
        mToolbarAnimator.setMaxTranslation(aMaxTranslation);
    }

    public void setSurfaceTranslation(float translation) {
        setTranslationY(translation);
    }

    public float getSurfaceTranslation() {
        return getTranslationY();
    }

    // Public hooks for dynamic toolbar translation

    public interface DynamicToolbarListener {
        public void onTranslationChanged(float aToolbarTranslation, float aLayerViewTranslation);
        public void onPanZoomStopped();
        public void onMetricsChanged(ImmutableViewportMetrics viewport);
    }

    // Public hooks for zoomed view

    public interface ZoomedViewListener {
        public void requestZoomedViewRender();
        public void updateView(ByteBuffer data);
    }

    public void addZoomedViewListener(ZoomedViewListener listener) {
        mRenderer.addZoomedViewListener(listener);
    }

    public void removeZoomedViewListener(ZoomedViewListener listener) {
        mRenderer.removeZoomedViewListener(listener);
    }

    public void setClearColor(int color) {
        if (mLayerClient != null) {
            mLayerClient.setClearColor(color);
        }
    }
}
