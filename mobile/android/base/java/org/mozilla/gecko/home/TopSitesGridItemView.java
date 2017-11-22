/* -*- Mode: Java; c-basic-offset: 4; tab-width: 20; indent-tabs-mode: nil; -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.home;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
import android.support.annotation.DrawableRes;
import android.support.v4.content.ContextCompat;
import android.support.v4.widget.TextViewCompat;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.widget.ImageView.ScaleType;
import android.widget.RelativeLayout;
import android.widget.TextView;

import org.mozilla.gecko.R;
import org.mozilla.gecko.db.BrowserContract.TopSites;
import org.mozilla.gecko.icons.IconCallback;
import org.mozilla.gecko.icons.IconResponse;
import org.mozilla.gecko.icons.Icons;
import org.mozilla.gecko.util.DrawableUtil;

import java.util.concurrent.Future;

/**
 * A view that displays the thumbnail and the title/url for a top/pinned site.
 * If the title/url is longer than the width of the view, they are faded out.
 * If there is no valid url, a default string is shown at 50% opacity.
 * This is denoted by the empty state.
 */
public class TopSitesGridItemView extends RelativeLayout implements IconCallback {
    private static final String LOGTAG = "GeckoTopSitesGridItemView";

    // Empty state, to denote there is no valid url.
    private static final int[] STATE_EMPTY = { android.R.attr.state_empty };

    private static final ScaleType SCALE_TYPE_FAVICON   = ScaleType.CENTER;
    private static final ScaleType SCALE_TYPE_RESOURCE  = ScaleType.CENTER;
    private static final ScaleType SCALE_TYPE_THUMBNAIL = ScaleType.CENTER_CROP;
    private static final ScaleType SCALE_TYPE_URL       = ScaleType.CENTER_INSIDE;

    // Child views.
    private final TextView mTitleView;
    private final TopSitesThumbnailView mThumbnailView;

    // Data backing this view.
    private String mTitle;
    private String mUrl;

    private boolean mThumbnailSet;

    // Matches BrowserContract.TopSites row types
    private int mType = -1;

    // Dirty state.
    private boolean mIsDirty;

    private Future<IconResponse> mOngoingIconRequest;

    public TopSitesGridItemView(Context context) {
        this(context, null);
    }

    public TopSitesGridItemView(Context context, AttributeSet attrs) {
        this(context, attrs, R.attr.topSitesGridItemViewStyle);
    }

    public TopSitesGridItemView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);

        LayoutInflater.from(context).inflate(R.layout.top_sites_grid_item_view, this);

        mTitleView = (TextView) findViewById(R.id.title);
        mThumbnailView = (TopSitesThumbnailView) findViewById(R.id.thumbnail);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public int[] onCreateDrawableState(int extraSpace) {
        final int[] drawableState = super.onCreateDrawableState(extraSpace + 1);

        if (mType == TopSites.TYPE_BLANK) {
            mergeDrawableStates(drawableState, STATE_EMPTY);
        }

        return drawableState;
    }

    /**
     * @return The title shown by this view.
     */
    public String getTitle() {
        return (!TextUtils.isEmpty(mTitle) ? mTitle : mUrl);
    }

    /**
     * @return The url shown by this view.
     */
    public String getUrl() {
        return mUrl;
    }

    /**
     * @return The site type associated with this view.
     */
    public int getType() {
        return mType;
    }

    /**
     * @param title The title for this view.
     */
    public void setTitle(String title) {
        if (mTitle != null && mTitle.equals(title)) {
            return;
        }

        mTitle = title;
        updateTitleView();
    }

    /**
     * @param url The url for this view.
     */
    public void setUrl(String url) {
        if (mUrl != null && mUrl.equals(url)) {
            return;
        }

        mUrl = url;
        updateTitleView();
    }

    public void blankOut() {
        mUrl = "";
        mTitle = "";
        updateType(TopSites.TYPE_BLANK);
        updateTitleView();
        cancelIconLoading();
        ImageLoader.with(getContext()).cancelRequest(mThumbnailView);
        displayThumbnail(R.drawable.top_site_add, ContextCompat.getColor(getContext(), R.color.about_page_header_grey));
    }

    public void markAsDirty() {
        mIsDirty = true;
    }

    /**
     * Updates the title, URL, and pinned state of this view.
     *
     * Also resets our loadId to NOT_LOADING.
     *
     * Returns true if any fields changed.
     */
    public boolean updateState(final String title, final String url, final int type, final TopSitesPanel.ThumbnailInfo thumbnail) {
        boolean changed = false;
        if (mUrl == null || !mUrl.equals(url)) {
            mUrl = url;
            changed = true;
        }

        if (mTitle == null || !mTitle.equals(title)) {
            mTitle = title;
            changed = true;
        }

        if (thumbnail != null) {
            if (thumbnail.imageUrl != null) {
                displayThumbnail(thumbnail.imageUrl, thumbnail.bgColor);
            } else if (thumbnail.bitmap != null) {
                displayThumbnail(thumbnail.bitmap);
            }
        } else if (changed) {
            // Because we'll have a new favicon or thumbnail arriving shortly, and
            // we need to not reject it because we already had a thumbnail.
            mThumbnailSet = false;
        }

        if (changed) {
            updateTitleView();
            cancelIconLoading();
            ImageLoader.with(getContext()).cancelRequest(mThumbnailView);
        }

        if (updateType(type)) {
            changed = true;
        }

        // The dirty state forces the state update to return true
        // so that the adapter loads favicons once the thumbnails
        // are loaded in TopSitesPanel/TopSitesGridAdapter.
        changed = (changed || mIsDirty);
        mIsDirty = false;

        return changed;
    }

    /**
     * Try to load an icon for the given page URL.
     */
    public void loadFavicon(String pageUrl) {
        mOngoingIconRequest = Icons.with(getContext())
                .pageUrl(pageUrl)
                .skipNetwork()
                .build()
                .execute(this);
    }

    private void cancelIconLoading() {
        if (mOngoingIconRequest != null) {
            mOngoingIconRequest.cancel(true);
        }
    }

    /**
     * Display the thumbnail from a resource.
     *
     * @param resId Resource ID of the drawable to show.
     * @param bgColor background color
     */
    public void displayThumbnail(@DrawableRes int resId, int bgColor) {
        mThumbnailView.setScaleType(SCALE_TYPE_RESOURCE);
        mThumbnailView.setImageResource(resId);
        mThumbnailView.setBackgroundColor(bgColor);
        mThumbnailView.setDrawDefaultBorder(true);
        mThumbnailSet = false;
    }

    /**
     * Display the thumbnail from a bitmap.
     *
     * @param thumbnail The bitmap to show as thumbnail.
     */
    public void displayThumbnail(Bitmap thumbnail) {
        if (thumbnail == null) {
            return;
        }

        mThumbnailSet = true;

        cancelIconLoading();
        ImageLoader.with(getContext()).cancelRequest(mThumbnailView);

        mThumbnailView.setScaleType(SCALE_TYPE_THUMBNAIL);
        mThumbnailView.setImageBitmap(thumbnail, true);
        mThumbnailView.setBackgroundDrawable(null);
        mThumbnailView.setDrawDefaultBorder(true);
    }

    /**
     * Display the thumbnail from a URL.
     *
     * @param imageUrl URL of the image to show.
     * @param bgColor background color to use in the view.
     */
    public void displayThumbnail(final String imageUrl, final int bgColor) {
        mThumbnailView.setScaleType(SCALE_TYPE_URL);
        mThumbnailView.setBackgroundColor(bgColor);
        mThumbnailView.setDrawDefaultBorder(false);
        mThumbnailSet = true;

        ImageLoader.with(getContext())
                   .load(imageUrl)
                   .noFade()
                   .into(mThumbnailView);
    }

    /**
     * Update the item type associated with this view. Returns true if
     * the type has changed, false otherwise.
     */
    private boolean updateType(int type) {
        if (mType == type) {
            return false;
        }

        mType = type;
        refreshDrawableState();

        final Drawable pinDrawable;
        if (type == TopSites.TYPE_PINNED) {
            pinDrawable = DrawableUtil.tintDrawable(getContext(), R.drawable.as_pin, getResources().getColor(R.color.placeholder_grey));
        } else {
            pinDrawable = null;
        }
        TextViewCompat.setCompoundDrawablesRelativeWithIntrinsicBounds(mTitleView, pinDrawable, null, null, null);

        return true;
    }

    /**
     * Update the title shown by this view. If both title and url
     * are empty, mark the state as STATE_EMPTY and show a default text.
     */
    private void updateTitleView() {
        String title = getTitle();
        if (!TextUtils.isEmpty(title)) {
            mTitleView.setText(title);
        } else {
            mTitleView.setText(R.string.home_top_sites_add);
        }
    }

    /**
     * Display the loaded icon (if no thumbnail is set).
     */
    @Override
    public void onIconResponse(IconResponse response) {
        if (mThumbnailSet) {
            // Already showing a thumbnail; do nothing.
            return;
        }

        mThumbnailView.setScaleType(SCALE_TYPE_FAVICON);
        mThumbnailView.setImageBitmap(response.getBitmap(), false);
        mThumbnailView.setBackgroundColorWithOpacityFilter(response.getColor());
    }
}
