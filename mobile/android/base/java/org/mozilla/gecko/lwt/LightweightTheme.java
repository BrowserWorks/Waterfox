/* -*- Mode: Java; c-basic-offset: 4; tab-width: 20; indent-tabs-mode: nil; -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.lwt;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONObject;
import org.mozilla.gecko.AppConstants.Versions;
import org.mozilla.gecko.EventDispatcher;
import org.mozilla.gecko.GeckoSharedPrefs;
import org.mozilla.gecko.gfx.BitmapUtils;
import org.mozilla.gecko.util.GeckoEventListener;
import org.mozilla.gecko.util.WindowUtils;
import org.mozilla.gecko.util.ThreadUtils;
import org.mozilla.gecko.util.ThreadUtils.AssertBehavior;

import android.app.Application;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.Shader;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.text.TextUtils;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewParent;

public class LightweightTheme implements GeckoEventListener {
    private static final String LOGTAG = "GeckoLightweightTheme";

    private static final String PREFS_URL = "lightweightTheme.headerURL";
    private static final String PREFS_COLOR = "lightweightTheme.color";

    private static final String ASSETS_PREFIX = "resource://android/assets/";

    private final Application mApplication;

    private Bitmap mBitmap;
    private int mColor;
    private boolean mIsLight;

    public static interface OnChangeListener {
        // The View should change its background/text color.
        public void onLightweightThemeChanged();

        // The View should reset to its default background/text color.
        public void onLightweightThemeReset();
    }

    private final List<OnChangeListener> mListeners;

    class LightweightThemeRunnable implements Runnable {
        private String mHeaderURL;
        private String mColor;

        private String mSavedURL;
        private String mSavedColor;

        LightweightThemeRunnable() {
        }

        LightweightThemeRunnable(final String headerURL, final String color) {
            mHeaderURL = headerURL;
            mColor = color;
        }

        private void loadFromPrefs() {
            SharedPreferences prefs = GeckoSharedPrefs.forProfile(mApplication);
            mSavedURL = prefs.getString(PREFS_URL, null);
            mSavedColor = prefs.getString(PREFS_COLOR, null);
        }

        private void saveToPrefs() {
            GeckoSharedPrefs.forProfile(mApplication)
                            .edit()
                            .putString(PREFS_URL, mHeaderURL)
                            .putString(PREFS_COLOR, mColor)
                            .apply();

            // Let's keep the saved data in sync.
            mSavedURL = mHeaderURL;
            mSavedColor = mColor;
        }

        @Override
        public void run() {
            // Load the data from preferences, if it exists.
            loadFromPrefs();

            if (TextUtils.isEmpty(mHeaderURL)) {
                // mHeaderURL is null is this is the early startup path. Use
                // the saved values, if we have any.
                mHeaderURL = mSavedURL;
                mColor = mSavedColor;
                if (TextUtils.isEmpty(mHeaderURL)) {
                    // We don't have any saved values, so we probably don't have
                    // any lightweight theme set yet.
                    return;
                }
            } else if (TextUtils.equals(mHeaderURL, mSavedURL)) {
                // If we are already using the given header, just return
                // without doing any work.
                return;
            } else {
                // mHeaderURL and mColor probably need to be saved if we get here.
                saveToPrefs();
            }

            String croppedURL = mHeaderURL;
            int mark = croppedURL.indexOf('?');
            if (mark != -1) {
                croppedURL = croppedURL.substring(0, mark);
            }

            if (croppedURL.startsWith(ASSETS_PREFIX)) {
                onBitmapLoaded(loadFromAssets(croppedURL));
            } else {
                onBitmapLoaded(BitmapUtils.decodeUrl(croppedURL));
            }
        }

        private Bitmap loadFromAssets(String url) {
            InputStream stream = null;

            try {
                stream = mApplication.getAssets().open(url.substring(ASSETS_PREFIX.length()));
                return BitmapFactory.decodeStream(stream);
            } catch (IOException e) {
                return null;
            } finally {
                if (stream != null) {
                    try {
                        stream.close();
                    } catch (IOException e) { }
                }
            }
        }

        private void onBitmapLoaded(final Bitmap bitmap) {
            ThreadUtils.postToUiThread(new Runnable() {
                @Override
                public void run() {
                    setLightweightTheme(bitmap, mColor);
                }
            });
        }
    }

    public LightweightTheme(Application application) {
        mApplication = application;
        mListeners = new ArrayList<OnChangeListener>();

        // unregister isn't needed as the lifetime is same as the application.
        EventDispatcher.getInstance().registerGeckoThreadListener(this,
            "LightweightTheme:Update",
            "LightweightTheme:Disable");

        ThreadUtils.postToBackgroundThread(new LightweightThemeRunnable());
    }

    public void addListener(final OnChangeListener listener) {
        // Don't inform the listeners that attached late.
        // Their onLayout() will take care of them before their onDraw();
        mListeners.add(listener);
    }

    public void removeListener(OnChangeListener listener) {
        mListeners.remove(listener);
    }

    @Override
    public void handleMessage(String event, JSONObject message) {
        try {
            if (event.equals("LightweightTheme:Update")) {
                JSONObject lightweightTheme = message.getJSONObject("data");
                final String headerURL = lightweightTheme.getString("headerURL");
                final String color = lightweightTheme.optString("accentcolor");

                ThreadUtils.postToBackgroundThread(new LightweightThemeRunnable(headerURL, color));
            } else if (event.equals("LightweightTheme:Disable")) {
                // Clear the saved data when a theme is disabled.
                // Called on the Gecko thread, but should be very lightweight.
                clearPrefs();

                ThreadUtils.postToUiThread(new Runnable() {
                    @Override
                    public void run() {
                        resetLightweightTheme();
                    }
                });
            }
        } catch (Exception e) {
            Log.e(LOGTAG, "Exception handling message \"" + event + "\":", e);
        }
    }

    /**
     * Clear the data stored in preferences for fast path loading during startup
     */
    private void clearPrefs() {
        GeckoSharedPrefs.forProfile(mApplication)
                        .edit()
                        .remove(PREFS_URL)
                        .remove(PREFS_COLOR)
                        .apply();
    }

    /**
     * Set a new lightweight theme with the given bitmap.
     * Note: This should be called on the UI thread to restrict accessing the
     * bitmap to a single thread.
     *
     * @param bitmap The bitmap used for the lightweight theme.
     * @param color  The background/accent color used for the lightweight theme.
     */
    private void setLightweightTheme(Bitmap bitmap, String color) {
        if (bitmap == null || bitmap.getWidth() == 0 || bitmap.getHeight() == 0) {
            mBitmap = null;
            return;
        }

        // Get the max display dimension so we can crop or expand the theme.
        final int maxWidth = WindowUtils.getLargestDimension(mApplication);

        // The lightweight theme image's width and height.
        final int bitmapWidth = bitmap.getWidth();
        final int bitmapHeight = bitmap.getHeight();

        try {
            mColor = Color.parseColor(color);
        } catch (Exception e) {
            // Malformed or missing color.
            // Default to TRANSPARENT.
            mColor = Color.TRANSPARENT;
        }

        // Calculate the luminance to determine if it's a light or a dark theme.
        double luminance = (0.2125 * ((mColor & 0x00FF0000) >> 16)) +
                           (0.7154 * ((mColor & 0x0000FF00) >> 8)) +
                           (0.0721 * (mColor & 0x000000FF));
        mIsLight = luminance > 110;

        // The bitmap image might be smaller than the device's width.
        // If it's smaller, fill the extra space on the left with the dominant color.
        if (bitmapWidth >= maxWidth) {
            mBitmap = Bitmap.createBitmap(bitmap, bitmapWidth - maxWidth, 0, maxWidth, bitmapHeight);
        } else {
            Paint paint = new Paint();
            paint.setAntiAlias(true);

            // Create a bigger image that can fill the device width.
            // By creating a canvas for the bitmap, anything drawn on the canvas
            // will be drawn on the bitmap.
            mBitmap = Bitmap.createBitmap(maxWidth, bitmapHeight, Bitmap.Config.ARGB_8888);
            Canvas canvas = new Canvas(mBitmap);

            // Fill the canvas with dominant color.
            canvas.drawColor(mColor);

            // The image should be top-right aligned.
            Rect rect = new Rect();
            Gravity.apply(Gravity.TOP | Gravity.RIGHT,
                          bitmapWidth,
                          bitmapHeight,
                          new Rect(0, 0, maxWidth, bitmapHeight),
                          rect);

            // Draw the bitmap.
            canvas.drawBitmap(bitmap, null, rect, paint);
        }

        for (OnChangeListener listener : mListeners) {
            listener.onLightweightThemeChanged();
        }
    }

    /**
     * Reset the lightweight theme.
     * Note: This should be called on the UI thread to restrict accessing the
     * bitmap to a single thread.
     */
    private void resetLightweightTheme() {
        ThreadUtils.assertOnUiThread(AssertBehavior.NONE);
        if (mBitmap == null) {
            return;
        }

        // Reset the bitmap.
        mBitmap = null;

        for (OnChangeListener listener : mListeners) {
            listener.onLightweightThemeReset();
        }
    }

    /**
     * A lightweight theme is enabled only if there is an active bitmap.
     *
     * @return True if the theme is enabled.
     */
    public boolean isEnabled() {
        return (mBitmap != null);
    }

    /**
     * Based on the luminance of the domanint color, a theme is classified as light or dark.
     *
     * @return True if the theme is light.
     */
    public boolean isLightTheme() {
        return mIsLight;
    }

    /**
     * Crop the image based on the position of the view on the window.
     * Either the View or one of its ancestors might have scrolled or translated.
     * This value should be taken into account while mapping the View to the Bitmap.
     *
     * @param view The view requesting a cropped bitmap.
     */
    private Bitmap getCroppedBitmap(View view) {
        if (mBitmap == null || view == null) {
            return null;
        }

        // Get the global position of the view on the entire screen.
        Rect rect = new Rect();
        view.getGlobalVisibleRect(rect);

        // Get the activity's window position. This does an IPC call, may be expensive.
        Rect window = new Rect();
        view.getWindowVisibleDisplayFrame(window);

        // Calculate the coordinates for the cropped bitmap.
        int screenWidth = view.getContext().getResources().getDisplayMetrics().widthPixels;
        int left = mBitmap.getWidth() - screenWidth + rect.left;
        int right = mBitmap.getWidth() - screenWidth + rect.right;
        int top = rect.top - window.top;
        int bottom = rect.bottom - window.top;

        int offsetX = 0;
        int offsetY = 0;

        // Find if this view or any of its ancestors has been translated or scrolled.
        ViewParent parent;
        View curView = view;
        do {
            offsetX += (int) curView.getTranslationX() - curView.getScrollX();
            offsetY += (int) curView.getTranslationY() - curView.getScrollY();

            parent = curView.getParent();

            if (parent instanceof View) {
                curView = (View) parent;
            }

        } while (parent instanceof View);

        // Adjust the coordinates for the offset.
        left -= offsetX;
        right -= offsetX;
        top -= offsetY;
        bottom -= offsetY;

        // The either the required height may be less than the available image height or more than it.
        // If the height required is more, crop only the available portion on the image.
        int width = right - left;
        int height = (bottom > mBitmap.getHeight() ? mBitmap.getHeight() - top : bottom - top);

        // There is a chance that the view is not visible or doesn't fall within the phone's size.
        // In this case, 'rect' will have all values as '0'. Hence 'top' and 'bottom' may be negative,
        // and createBitmap() will fail.
        // The view will get a background in its next layout pass.
        try {
            return Bitmap.createBitmap(mBitmap, left, top, width, height);
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Converts the cropped bitmap to a BitmapDrawable and returns the same.
     *
     * @param view The view for which a background drawable is required.
     * @return Either the cropped bitmap as a Drawable or null.
     */
    public Drawable getDrawable(View view) {
        Bitmap bitmap = getCroppedBitmap(view);
        if (bitmap == null) {
            return null;
        }

        BitmapDrawable drawable = new BitmapDrawable(view.getContext().getResources(), bitmap);
        drawable.setGravity(Gravity.TOP | Gravity.RIGHT);
        drawable.setTileModeXY(Shader.TileMode.CLAMP, Shader.TileMode.CLAMP);
        return drawable;
    }

    /**
     * Converts the cropped bitmap to a LightweightThemeDrawable, placing it over the dominant color.
     *
     * @param view The view for which a background drawable is required.
     * @return Either the cropped bitmap as a Drawable or null.
     */
     public LightweightThemeDrawable getColorDrawable(View view) {
         return getColorDrawable(view, mColor, false);
     }

    /**
     * Converts the cropped bitmap to a LightweightThemeDrawable, placing it over the required color.
     *
     * @param view The view for which a background drawable is required.
     * @param color The color over which the drawable should be drawn.
     * @return Either the cropped bitmap as a Drawable or null.
     */
    public LightweightThemeDrawable getColorDrawable(View view, int color) {
        return getColorDrawable(view, color, false);
    }

    /**
     * Converts the cropped bitmap to a LightweightThemeDrawable, placing it over the required color.
     *
     * @param view The view for which a background drawable is required.
     * @param color The color over which the drawable should be drawn.
     * @param needsDominantColor A layer of dominant color is needed or not.
     * @return Either the cropped bitmap as a Drawable or null.
     */
    public LightweightThemeDrawable getColorDrawable(View view, int color, boolean needsDominantColor) {
        Bitmap bitmap = getCroppedBitmap(view);
        if (bitmap == null) {
            return null;
        }

        LightweightThemeDrawable drawable = new LightweightThemeDrawable(view.getContext().getResources(), bitmap);
        if (needsDominantColor) {
            drawable.setColorWithFilter(color, (mColor & 0x22FFFFFF));
        } else {
            drawable.setColor(color);
        }

        return drawable;
    }
}
