/* -*- Mode: Java; c-basic-offset: 4; tab-width: 20; indent-tabs-mode: nil; -*-
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.widget;

import android.graphics.Color;
import org.mozilla.gecko.R;
import org.mozilla.gecko.icons.IconCallback;
import org.mozilla.gecko.icons.IconResponse;

import android.content.Context;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.RectF;
import android.support.v4.graphics.drawable.RoundedBitmapDrawable;
import android.support.v4.graphics.drawable.RoundedBitmapDrawableFactory;
import android.util.AttributeSet;
import android.util.DisplayMetrics;
import android.util.TypedValue;
import android.widget.ImageView;

import java.lang.ref.WeakReference;

/**
 * Special version of ImageView for favicons.
 * Displays solid colour background around Favicon to fill space not occupied by the icon. Colour
 * selected is the dominant colour of the provided Favicon.
 */
public class FaviconView extends ImageView {

    // Default x/y-radius of the oval used to round the corners of the background (dp)
    private static final int DEFAULT_CORNER_RADIUS_DP = 2;

    /**
     * True if we're capable of, and want to, display an image, false otherwise. This acts as a switch: if we
     * don't want to show an image, most other state will be ignored because we don't need it to draw.
     *
     * We use this flag, rather than zeroing all relevant state, because if update*Image is called before
     * onSizeChanged (during init), we would not be able to show an image and thus zero all state. When
     * onSizeChanged is called, the state has been zeroed and we would not be able to show the image properly
     * (bug 1341275).
     *
     * One notable exception is for ImageView's internal state via setImageBitmap/Drawable, which must be set to
     * null if we don't want to draw anything.
     *
     * By default, we can't show an image because we don't have a size yet (onSizeChanged) or an image (update*Image),
     * hence false.
     */
    private boolean mShouldShowImage = false;

    private Bitmap mIconBitmap;

    // Reference to the unscaled bitmap, if any, to prevent repeated assignments of the same bitmap
    // to the view from causing repeated rescalings (Some of the callers do this)
    private Bitmap mUnscaledBitmap;

    // Flag indicating if the most recently assigned image is considered likely to need scaling.
    private boolean mScalingExpected;

    // Dominant color of the favicon.
    private int mDominantColor;

    // Paint for drawing the background.
    private static final Paint sBackgroundPaint;

    // Size of the background rectangle.
    private final RectF mBackgroundRect;

    // The x/y-radius of the oval used to round the corners of the background (pixels)
    private final float mBackgroundCornerRadius;

    // Type of the border whose value is defined in attrs.xml .
    private final boolean isDominantBorderEnabled;

    // boolean switch for overriding scaletype, whose value is defined in attrs.xml .
    private final boolean isOverrideScaleTypeEnabled;

    // boolean switch for disabling rounded corners, value defined in attrs.xml .
    private final boolean areRoundCornersEnabled;

    private final Resources mResources;

    // Initializing the static paints.
    static {
        sBackgroundPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        sBackgroundPaint.setStyle(Paint.Style.FILL);
    }

    public FaviconView(Context context, AttributeSet attrs) {
        super(context, attrs);
        TypedArray a = context.getTheme().obtainStyledAttributes(attrs, R.styleable.FaviconView, 0, 0);

        try {
            isDominantBorderEnabled = a.getBoolean(R.styleable.FaviconView_dominantBorderEnabled, true);
            isOverrideScaleTypeEnabled = a.getBoolean(R.styleable.FaviconView_overrideScaleType, true);
            areRoundCornersEnabled = a.getBoolean(R.styleable.FaviconView_enableRoundCorners, true);

            final DisplayMetrics metrics = getResources().getDisplayMetrics();
            mBackgroundCornerRadius = a.getDimension(R.styleable.FaviconView_backgroundCornerRadius,
                                                     TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, DEFAULT_CORNER_RADIUS_DP, metrics));
        } finally {
            a.recycle();
        }

        if (isOverrideScaleTypeEnabled) {
            setScaleType(ImageView.ScaleType.CENTER);
        }

        mBackgroundRect = new RectF(0, 0, 0, 0);
        mResources = getResources();
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);

        mBackgroundRect.right = w;
        mBackgroundRect.bottom = h;

        formatImage();
    }

    @Override
    public void onDraw(Canvas canvas) {
        if (mShouldShowImage && isDominantBorderEnabled) {
            sBackgroundPaint.setColor(mDominantColor);

            if (areRoundCornersEnabled) {
                canvas.drawRoundRect(mBackgroundRect, mBackgroundCornerRadius, mBackgroundCornerRadius, sBackgroundPaint);
            } else {
                canvas.drawRect(mBackgroundRect, sBackgroundPaint);
            }
        }

        // If mShouldShowImage == false, setImageDrawable should be null & we are safe to call super.
        super.onDraw(canvas);
    }

    /**
     * Formats the image for display, if the prerequisite data are available. Upscales tiny Favicons to
     * normal sized ones, replaces null bitmaps with the default Favicon, and fills all remaining space
     * in this view with the coloured background.
     */
    private void formatImage() {
        // Both onSizeChanged and updateImage have to be called before an image can be shown.
        //
        // Note: getWidth/Height get their non-zero values during layout, at which point onSizeChanged will be called.
        // Since we block for onSizeChanged (getWidth/Height != 0) and we only call getWidth/Height from this method
        // and the ones it calls, we should have no problems with zero values for `getWidth/Height`.
        final boolean canImageBeShown = (mIconBitmap != null && getWidth() != 0 && getHeight() != 0);
        if (!canImageBeShown) {
            showNoImage();
            return;
        }

        mShouldShowImage = true;

        if (mScalingExpected && getWidth() != mIconBitmap.getWidth()) {
            scaleBitmap();
            // Don't scale the image every time something changes.
            mScalingExpected = false;
        }

        // In original, there is no round corners if FaviconView has bitmap icon. But the new design
        // needs round corners all the time, so we use RoundedBitmapDrawableFactory to create round corners.
        if (areRoundCornersEnabled) {
            // mIconBitmap's size must bew small or equal to getWidth(), or we cannot see the round corners.
            if (getWidth() < mIconBitmap.getWidth()) {
                scaleBitmap();
            }
            RoundedBitmapDrawable roundedBitmapDrawable = RoundedBitmapDrawableFactory.create(mResources, mIconBitmap);
            roundedBitmapDrawable.setCornerRadius(mBackgroundCornerRadius);
            roundedBitmapDrawable.setAntiAlias(true);
            setImageDrawable(roundedBitmapDrawable);
        } else {
            setImageBitmap(mIconBitmap);
        }

        // After scaling, determine if we have empty space around the scaled image which we need to
        // fill with the coloured background. If applicable, show it.
        // We assume Favicons are still squares and only bother with the background if more than 3px
        // of it would be displayed.
        if (Math.abs(mIconBitmap.getWidth() - getWidth()) < 3) {
            mDominantColor = Color.TRANSPARENT;
        }
    }

    private void scaleBitmap() {
        // If the Favicon can be resized to fill the view exactly without an enlargment of more than
        // a factor of two, do so.
        int doubledSize = mIconBitmap.getWidth() * 2;
        if (getWidth() > doubledSize) {
            // If the view is more than twice the size of the image, just double the image size
            // and do the rest with padding.
            mIconBitmap = Bitmap.createScaledBitmap(mIconBitmap, doubledSize, doubledSize, true);
        } else {
            // Otherwise, scale the image to fill the view.
            mIconBitmap = Bitmap.createScaledBitmap(mIconBitmap, getWidth(), getWidth(), true);
        }
    }

    /**
     * Sets the icon displayed in this Favicon view to the bitmap provided. If the size of the view
     * has been set, the display will be updated right away, otherwise the update will be deferred
     * until then. The key provided is used to cache the result of the calculation of the dominant
     * colour of the provided image - this value is used to draw the coloured background in this view
     * if the icon is not large enough to fill it.
     *
     * @param allowScaling If true, allows the provided bitmap to be scaled by this FaviconView.
     *                     Typically, you should prefer using Favicons obtained via the caching system
     *                     (Favicons class), so as to exploit caching.
     */
    private void updateImageInternal(IconResponse response, boolean allowScaling) {
        // Reassigning the same bitmap? Don't bother.
        if (mUnscaledBitmap == response.getBitmap()) {
            return;
        }
        mUnscaledBitmap = response.getBitmap();
        mIconBitmap = response.getBitmap();
        mDominantColor = response.getColor();
        mScalingExpected = allowScaling;

        // Possibly update the display.
        formatImage();
    }

    private void showNoImage() {
        mShouldShowImage = false;
        setImageDrawable(null);
    }

    /**
     * Clear image and background shown by this view.
     */
    public void clearImage() {
        showNoImage();
        mUnscaledBitmap = null;
        mIconBitmap = null;
        mDominantColor = Color.TRANSPARENT;
        mScalingExpected = false;
    }

    /**
     * Update the displayed image and apply the scaling logic.
     * The scaling logic will attempt to resize the image to fit correctly inside the view in a way
     * that avoids unreasonable levels of loss of quality.
     * Scaling is necessary only when the icon being provided is not drawn from the Favicon cache
     * introduced in Bug 914296.
     *
     * Due to Bug 913746, icons bundled for search engines are not available to the cache, so must
     * always have the scaling logic applied here. At the time of writing, this is the only case in
     * which the scaling logic here is applied.
     */
    public void updateAndScaleImage(IconResponse response) {
        updateImageInternal(response, true);
    }

    /**
     * Update the image displayed in the Favicon view without scaling. Images larger than the view
     * will be centrally cropped. Images smaller than the view will be placed centrally and the
     * extra space filled with the dominant colour of the provided image.
     */
    public void updateImage(IconResponse response) {
        updateImageInternal(response, false);
    }

    public Bitmap getBitmap() {
        return mIconBitmap;
    }

    /**
     * Create an IconCallback implementation that will update this view after an icon has been loaded.
     */
    public IconCallback createIconCallback() {
        return new Callback(this);
    }

    private static class Callback implements IconCallback {
        private final WeakReference<FaviconView> viewReference;

        private Callback(FaviconView view) {
            this.viewReference = new WeakReference<FaviconView>(view);
        }

        @Override
        public void onIconResponse(IconResponse response) {
            final FaviconView view = viewReference.get();
            if (view == null) {
                return;
            }

            view.updateImage(response);
        }
    }
}
