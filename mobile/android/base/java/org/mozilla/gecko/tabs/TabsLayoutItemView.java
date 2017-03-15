/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.tabs;

import org.mozilla.gecko.R;
import org.mozilla.gecko.Tab;
import org.mozilla.gecko.Tabs;
import org.mozilla.gecko.widget.TabThumbnailWrapper;
import org.mozilla.gecko.widget.TouchDelegateWithReset;
import org.mozilla.gecko.widget.themed.ThemedRelativeLayout;

import android.content.Context;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.Checkable;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

public class TabsLayoutItemView extends LinearLayout
                                implements Checkable {
    private static final String LOGTAG = "Gecko" + TabsLayoutItemView.class.getSimpleName();
    private static final int[] STATE_CHECKED = { android.R.attr.state_checked };
    private boolean mChecked;

    private int mTabId;
    private TextView mTitle;
    private TabsPanelThumbnailView mThumbnail;
    private ImageView mCloseButton;
    private TabThumbnailWrapper mThumbnailWrapper;

    public TabsLayoutItemView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    @Override
    public int[] onCreateDrawableState(int extraSpace) {
        final int[] drawableState = super.onCreateDrawableState(extraSpace + 1);

        if (mChecked) {
            mergeDrawableStates(drawableState, STATE_CHECKED);
        }

        return drawableState;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }

    @Override
    public boolean isChecked() {
        return mChecked;
    }

    @Override
    public void setChecked(boolean checked) {
        if (mChecked == checked) {
            return;
        }

        mChecked = checked;
        refreshDrawableState();

        int count = getChildCount();
        for (int i = 0; i < count; i++) {
            final View child = getChildAt(i);
            if (child instanceof Checkable) {
                ((Checkable) child).setChecked(checked);
            }
        }
    }

    @Override
    public void toggle() {
        mChecked = !mChecked;
    }

    public void setCloseOnClickListener(OnClickListener mOnClickListener) {
        mCloseButton.setOnClickListener(mOnClickListener);
    }

    @Override
    protected void onFinishInflate() {
        super.onFinishInflate();
        mTitle = (TextView) findViewById(R.id.title);
        mThumbnail = (TabsPanelThumbnailView) findViewById(R.id.thumbnail);
        mCloseButton = (ImageView) findViewById(R.id.close);
        mThumbnailWrapper = (TabThumbnailWrapper) findViewById(R.id.wrapper);

        growCloseButtonHitArea();
    }

    private void growCloseButtonHitArea() {
        getViewTreeObserver().addOnPreDrawListener(new ViewTreeObserver.OnPreDrawListener() {
            @Override
            public boolean onPreDraw() {
                getViewTreeObserver().removeOnPreDrawListener(this);

                // Ideally we want the close button hit area to be 40x40dp but we are constrained by the height of the parent, so
                // we make it as tall as the parent view and 40dp across.
                final int targetHitArea = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 40, getResources().getDisplayMetrics());;

                final Rect hitRect = new Rect();
                hitRect.top = 0;
                hitRect.right = getWidth();
                hitRect.left = getWidth() - targetHitArea;
                hitRect.bottom = targetHitArea;

                setTouchDelegate(new TouchDelegateWithReset(hitRect, mCloseButton));

                return true;
            }
        });
    }

    protected void assignValues(Tab tab)  {
        if (tab == null) {
            return;
        }

        mTabId = tab.getId();

        setChecked(Tabs.getInstance().isSelectedTab(tab));

        Drawable thumbnailImage = tab.getThumbnail();
        mThumbnail.setImageDrawable(thumbnailImage);

        mThumbnail.setPrivateMode(tab.isPrivate());

        if (mThumbnailWrapper != null) {
            mThumbnailWrapper.setRecording(tab.isRecording());
        }

        final String tabTitle = tab.getDisplayTitle();
        mTitle.setText(tabTitle);
        mCloseButton.setTag(this);

        if (tab.isAudioPlaying()) {
            mTitle.setCompoundDrawablesWithIntrinsicBounds(R.drawable.tab_audio_playing, 0, 0, 0);
            final String tabTitleWithAudio =
                    getResources().getString(R.string.tab_title_prefix_is_playing_audio, tabTitle);
            mTitle.setContentDescription(tabTitleWithAudio);
        } else {
            mTitle.setCompoundDrawables(null, null, null, null);
            mTitle.setContentDescription(tabTitle);
        }
    }

    public int getTabId() {
        return mTabId;
    }

    public void setThumbnail(Drawable thumbnail) {
        mThumbnail.setImageDrawable(thumbnail);
    }

    public void setCloseVisible(boolean visible) {
        mCloseButton.setVisibility(visible ? View.VISIBLE : View.INVISIBLE);
    }

    public void setPrivateMode(boolean isPrivate) {
        ((ThemedRelativeLayout) findViewById(R.id.wrapper)).setPrivateMode(isPrivate);
    }
}
