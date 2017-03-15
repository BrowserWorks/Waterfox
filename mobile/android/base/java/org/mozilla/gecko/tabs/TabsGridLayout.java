/* -*- Mode: Java; c-basic-offset: 4; tab-width: 20; indent-tabs-mode: nil; -*-
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.tabs;

import org.mozilla.gecko.AppConstants;
import org.mozilla.gecko.GeckoAppShell;
import org.mozilla.gecko.R;
import org.mozilla.gecko.Tab;
import org.mozilla.gecko.Tabs;
import org.mozilla.gecko.animation.PropertyAnimator;
import org.mozilla.gecko.tabs.TabsPanel.TabsLayout;
import org.mozilla.gecko.widget.themed.ThemedRelativeLayout;

import android.content.Context;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.graphics.PointF;
import android.graphics.Rect;
import android.os.Build;
import android.util.AttributeSet;
import android.util.SparseArray;
import android.view.MotionEvent;
import android.view.VelocityTracker;
import android.view.View;
import android.view.ViewConfiguration;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.view.animation.DecelerateInterpolator;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.GridView;
import android.animation.Animator;
import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.animation.PropertyValuesHolder;
import android.animation.ValueAnimator;

import java.util.ArrayList;
import java.util.List;

/**
 * A tabs layout implementation for the tablet redesign (bug 1014156) and later ported to mobile (bug 1193745).
 */

class TabsGridLayout extends GridView
                     implements TabsLayout,
                                Tabs.OnTabsChangedListener {

    private static final String LOGTAG = "Gecko" + TabsGridLayout.class.getSimpleName();

    public static final int ANIM_DELAY_MULTIPLE_MS = 20;
    private static final int ANIM_TIME_MS = 200;
    private static final DecelerateInterpolator ANIM_INTERPOLATOR = new DecelerateInterpolator();

    private final SparseArray<PointF> tabLocations = new SparseArray<PointF>();
    private final boolean isPrivate;
    private final TabsLayoutAdapter tabsAdapter;
    private final int columnWidth;
    private TabsPanel tabsPanel;
    private int lastSelectedTabId;

    public TabsGridLayout(final Context context, final AttributeSet attrs) {
        super(context, attrs, R.attr.tabGridLayoutViewStyle);

        TypedArray a = context.obtainStyledAttributes(attrs, R.styleable.TabsLayout);
        isPrivate = (a.getInt(R.styleable.TabsLayout_tabs, 0x0) == 1);
        a.recycle();

        tabsAdapter = new TabsGridLayoutAdapter(context);
        setAdapter(tabsAdapter);

        setRecyclerListener(new RecyclerListener() {
            @Override
            public void onMovedToScrapHeap(View view) {
                TabsLayoutItemView item = (TabsLayoutItemView) view;
                item.setThumbnail(null);
            }
        });

        // The clipToPadding setting in the styles.xml doesn't seem to be working (bug 1101784)
        // so lets set it manually in code for the moment as it's needed for the padding animation
        setClipToPadding(false);

        setVerticalFadingEdgeEnabled(false);

        final Resources resources = getResources();
        columnWidth = resources.getDimensionPixelSize(R.dimen.tab_panel_column_width);

        final int padding = resources.getDimensionPixelSize(R.dimen.tab_panel_grid_padding);
        final int paddingTop = resources.getDimensionPixelSize(R.dimen.tab_panel_grid_padding_top);

        // Lets set double the top padding on the bottom so that the last row shows up properly!
        // Your demise, GridView, cannot come fast enough.
        final int paddingBottom = paddingTop * 2;

        setPadding(padding, paddingTop, padding, paddingBottom);

        setOnItemClickListener(new OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                final TabsLayoutItemView tabView = (TabsLayoutItemView) view;
                final int tabId = tabView.getTabId();
                final Tab tab = Tabs.getInstance().selectTab(tabId);
                if (tab == null) {
                    return;
                }
                autoHidePanel();
                Tabs.getInstance().notifyListeners(tab, Tabs.TabEvents.OPENED_FROM_TABS_TRAY);
            }
        });

        TabSwipeGestureListener mSwipeListener = new TabSwipeGestureListener();
        setOnTouchListener(mSwipeListener);
        setOnScrollListener(mSwipeListener.makeScrollListener());
    }

    private void populateTabLocations(final Tab removedTab) {
        tabLocations.clear();

        final int firstPosition = getFirstVisiblePosition();
        final int lastPosition = getLastVisiblePosition();
        final int numberOfColumns = getNumColumns();
        final int childCount = getChildCount();
        final int removedPosition = tabsAdapter.getPositionForTab(removedTab);

        for (int x = 1, i = (removedPosition - firstPosition) + 1; i < childCount; i++, x++) {
            final View child = getChildAt(i);
            if (child != null) {
                // Reset the transformations here in case the user is swiping tabs away fast and they swipe a tab
                // before the last animation has finished (bug 1179195).
                resetTransforms(child);

                tabLocations.append(x, new PointF(child.getX(), child.getY()));
            }
        }

        final boolean firstChildOffScreen = ((firstPosition > 0) || getChildAt(0).getY() < 0);
        final boolean lastChildVisible = (lastPosition - childCount == firstPosition - 1);
        final boolean oneItemOnLastRow = (lastPosition % numberOfColumns == 0);
        if (firstChildOffScreen && lastChildVisible && oneItemOnLastRow) {
            // We need to set the view's bottom padding to prevent a sudden jump as the
            // last item in the row is being removed. We then need to remove the padding
            // via a sweet animation

            final int removedHeight = getChildAt(0).getMeasuredHeight();
            final int verticalSpacing =
                    getResources().getDimensionPixelOffset(R.dimen.tab_panel_grid_vspacing);

            ValueAnimator paddingAnimator = ValueAnimator.ofInt(getPaddingBottom() + removedHeight + verticalSpacing, getPaddingBottom());
            paddingAnimator.setDuration(ANIM_TIME_MS * 2);

            paddingAnimator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {

                @Override
                public void onAnimationUpdate(ValueAnimator animation) {
                    setPadding(getPaddingLeft(), getPaddingTop(), getPaddingRight(), (Integer) animation.getAnimatedValue());
                }
            });
            paddingAnimator.start();
        }
    }

    @Override
    public void setTabsPanel(TabsPanel panel) {
        tabsPanel = panel;
    }

    @Override
    public void show() {
        setVisibility(View.VISIBLE);
        Tabs.getInstance().refreshThumbnails();
        Tabs.registerOnTabsChangedListener(this);
        refreshTabsData();

        final Tab currentlySelectedTab = Tabs.getInstance().getSelectedTab();
        final int position =  currentlySelectedTab != null ? tabsAdapter.getPositionForTab(currentlySelectedTab) : -1;
        if (position != -1) {
            final boolean selectionChanged = lastSelectedTabId != currentlySelectedTab.getId();
            final boolean positionIsVisible = position >= getFirstVisiblePosition() && position <= getLastVisiblePosition();

            if (selectionChanged || !positionIsVisible) {
                smoothScrollToPosition(position);
            }
        }
    }

    @Override
    public void hide() {
        lastSelectedTabId = Tabs.getInstance().getSelectedTab().getId();
        setVisibility(View.GONE);
        Tabs.unregisterOnTabsChangedListener(this);
        GeckoAppShell.notifyObservers("Tab:Screenshot:Cancel", "");
        tabsAdapter.clear();
    }

    @Override
    public boolean shouldExpand() {
        return true;
    }

    private void autoHidePanel() {
        tabsPanel.autoHidePanel();
    }

    @Override
    public void onTabChanged(Tab tab, Tabs.TabEvents msg, String data) {
        switch (msg) {
            case ADDED:
                // Refresh only if panel is shown. show() will call refreshTabsData() later again.
                if (tabsPanel.isShown()) {
                    // Refresh the list to make sure the new tab is added in the right position.
                    refreshTabsData();
                }
                break;

            case CLOSED:

                // This is limited to >= ICS as animations on GB devices are generally pants
                if (Build.VERSION.SDK_INT >= 11 && tabsAdapter.getCount() > 0) {
                    animateRemoveTab(tab);
                }

                final Tabs tabsInstance = Tabs.getInstance();

                if (tabsAdapter.removeTab(tab)) {
                    if (tab.isPrivate() == isPrivate && tabsAdapter.getCount() > 0) {
                        int selected = tabsAdapter.getPositionForTab(tabsInstance.getSelectedTab());
                        updateSelectedStyle(selected);
                    }
                    if (!tab.isPrivate()) {
                        // Make sure we always have at least one normal tab
                        final Iterable<Tab> tabs = tabsInstance.getTabsInOrder();
                        boolean removedTabIsLastNormalTab = true;
                        for (Tab singleTab : tabs) {
                            if (!singleTab.isPrivate()) {
                                removedTabIsLastNormalTab = false;
                                break;
                            }
                        }
                        if (removedTabIsLastNormalTab) {
                            tabsInstance.addTab();
                        }
                    }
                }
                break;

            case SELECTED:
                // Update the selected position, then fall through...
                updateSelectedPosition();
            case UNSELECTED:
                // We just need to update the style for the unselected tab...
            case THUMBNAIL:
            case TITLE:
            case RECORDING_CHANGE:
            case AUDIO_PLAYING_CHANGE:
                View view = getChildAt(tabsAdapter.getPositionForTab(tab) - getFirstVisiblePosition());
                if (view == null)
                    return;

                ((TabsLayoutItemView) view).assignValues(tab);
                break;
        }
    }

    // Updates the selected position in the list so that it will be scrolled to the right place.
    private void updateSelectedPosition() {
        int selected = tabsAdapter.getPositionForTab(Tabs.getInstance().getSelectedTab());
        updateSelectedStyle(selected);

        if (selected != -1) {
            setSelection(selected);
        }
    }

    /**
     * Updates the selected/unselected style for the tabs.
     *
     * @param selected position of the selected tab
     */
    private void updateSelectedStyle(final int selected) {
        post(new Runnable() {
            @Override
            public void run() {
                final int displayCount = tabsAdapter.getCount();

                for (int i = 0; i < displayCount; i++) {
                    final Tab tab = tabsAdapter.getItem(i);
                    final boolean checked = displayCount == 1 || i == selected;
                    final View tabView = getViewForTab(tab);
                    if (tabView != null) {
                        ((TabsLayoutItemView) tabView).setChecked(checked);
                    }
                    // setItemChecked doesn't exist until API 11, despite what the API docs say!
                    setItemChecked(i, checked);
                }
            }
        });
    }

    private void refreshTabsData() {
        // Store a different copy of the tabs, so that we don't have to worry about
        // accidentally updating it on the wrong thread.
        ArrayList<Tab> tabData = new ArrayList<>();

        Iterable<Tab> allTabs = Tabs.getInstance().getTabsInOrder();
        for (Tab tab : allTabs) {
            if (tab.isPrivate() == isPrivate)
                tabData.add(tab);
        }

        tabsAdapter.setTabs(tabData);
        updateSelectedPosition();
    }

    private void resetTransforms(View view) {
        view.setAlpha(1);
        view.setTranslationX(0);
        view.setTranslationY(0);

        ((TabsLayoutItemView) view).setCloseVisible(true);
    }

    @Override
    public void closeAll() {

        autoHidePanel();

        if (getChildCount() == 0) {
            return;
        }

        final Iterable<Tab> tabs = Tabs.getInstance().getTabsInOrder();
        for (Tab tab : tabs) {
            // In the normal panel we want to close all tabs (both private and normal),
            // but in the private panel we only want to close private tabs.
            if (!isPrivate || tab.isPrivate()) {
                Tabs.getInstance().closeTab(tab, false);
            }
        }
    }

    private View getViewForTab(Tab tab) {
        final int position = tabsAdapter.getPositionForTab(tab);
        return getChildAt(position - getFirstVisiblePosition());
    }

    void closeTab(View v) {
        if (tabsAdapter.getCount() == 1) {
            autoHidePanel();
        }

        TabsLayoutItemView itemView = (TabsLayoutItemView) v.getTag();
        Tab tab = Tabs.getInstance().getTab(itemView.getTabId());

        Tabs.getInstance().closeTab(tab, true);
    }

    private void animateRemoveTab(final Tab removedTab) {
        final int removedPosition = tabsAdapter.getPositionForTab(removedTab);

        final View removedView = getViewForTab(removedTab);

        // The removed position might not have a matching child view
        // when it's not within the visible range of positions in the strip.
        if (removedView == null) {
            return;
        }
        final int removedHeight = removedView.getMeasuredHeight();

        populateTabLocations(removedTab);

        getViewTreeObserver().addOnPreDrawListener(new ViewTreeObserver.OnPreDrawListener() {
            @Override
            public boolean onPreDraw() {
                getViewTreeObserver().removeOnPreDrawListener(this);
                // We don't animate the removed child view (it just disappears)
                // but we still need its size to animate all affected children
                // within the visible viewport.
                final int childCount = getChildCount();
                final int firstPosition = getFirstVisiblePosition();
                final int numberOfColumns = getNumColumns();

                final List<Animator> childAnimators = new ArrayList<>();

                PropertyValuesHolder translateX, translateY;
                for (int x = 0, i = removedPosition - firstPosition; i < childCount; i++, x++) {
                    final View child = getChildAt(i);
                    ObjectAnimator animator;

                    if (i % numberOfColumns == numberOfColumns - 1) {
                        // Animate X & Y
                        translateX = PropertyValuesHolder.ofFloat("translationX", -(columnWidth * numberOfColumns), 0);
                        translateY = PropertyValuesHolder.ofFloat("translationY", removedHeight, 0);
                        animator = ObjectAnimator.ofPropertyValuesHolder(child, translateX, translateY);
                    } else {
                        // Just animate X
                        translateX = PropertyValuesHolder.ofFloat("translationX", columnWidth, 0);
                        animator = ObjectAnimator.ofPropertyValuesHolder(child, translateX);
                    }
                    animator.setStartDelay(x * ANIM_DELAY_MULTIPLE_MS);
                    childAnimators.add(animator);
                }

                final AnimatorSet animatorSet = new AnimatorSet();
                animatorSet.playTogether(childAnimators);
                animatorSet.setDuration(ANIM_TIME_MS);
                animatorSet.setInterpolator(ANIM_INTERPOLATOR);
                animatorSet.start();

                // Set the starting position of the child views - because we are delaying the start
                // of the animation, we need to prevent the items being drawn in their final position
                // prior to the animation starting
                for (int x = 1, i = (removedPosition - firstPosition) + 1; i < childCount; i++, x++) {
                    final View child = getChildAt(i);

                    final PointF targetLocation = tabLocations.get(x + 1);
                    if (targetLocation == null) {
                        continue;
                    }

                    child.setX(targetLocation.x);
                    child.setY(targetLocation.y);
                }

                return true;
            }
        });
    }


    private void animateCancel(final View view) {
        PropertyAnimator animator = new PropertyAnimator(ANIM_TIME_MS);
        animator.attach(view, PropertyAnimator.Property.ALPHA, 1);
        animator.attach(view, PropertyAnimator.Property.TRANSLATION_X, 0);

        animator.addPropertyAnimationListener(new PropertyAnimator.PropertyAnimationListener() {
            @Override
            public void onPropertyAnimationStart() {
            }

            @Override
            public void onPropertyAnimationEnd() {
                TabsLayoutItemView tab = (TabsLayoutItemView) view;
                tab.setCloseVisible(true);
            }
        });

        animator.start();
    }

    private class TabsGridLayoutAdapter extends TabsLayoutAdapter {

        final private Button.OnClickListener mCloseClickListener;

        public TabsGridLayoutAdapter(Context context) {
            super(context, R.layout.tabs_layout_item_view);

            mCloseClickListener = new Button.OnClickListener() {
                @Override
                public void onClick(View v) {
                    closeTab(v);
                }
            };
        }

        @Override
        TabsLayoutItemView newView(int position, ViewGroup parent) {
            final TabsLayoutItemView item = super.newView(position, parent);

            item.setCloseOnClickListener(mCloseClickListener);
            ((ThemedRelativeLayout) item.findViewById(R.id.wrapper)).setPrivateMode(isPrivate);

            return item;
        }

        @Override
        public void bindView(TabsLayoutItemView view, Tab tab) {
            super.bindView(view, tab);

            // If we're recycling this view, there's a chance it was transformed during
            // the close animation. Remove any of those properties.
            resetTransforms(view);
        }
    }

    private class TabSwipeGestureListener implements View.OnTouchListener {
        // same value the stock browser uses for after drag animation velocity in pixels/sec
        // http://androidxref.com/4.0.4/xref/packages/apps/Browser/src/com/android/browser/NavTabScroller.java#61
        private static final float MIN_VELOCITY = 750;

        private final int mSwipeThreshold;
        private final int mMinFlingVelocity;

        private final int mMaxFlingVelocity;
        private VelocityTracker mVelocityTracker;

        private int mTabWidth = 1;

        private View mSwipeView;
        private Runnable mPendingCheckForTap;

        private float mSwipeStartX;
        private boolean mSwiping;
        private boolean mEnabled;

        public TabSwipeGestureListener() {
            mEnabled = true;

            ViewConfiguration vc = ViewConfiguration.get(TabsGridLayout.this.getContext());
            mSwipeThreshold = vc.getScaledTouchSlop();
            mMinFlingVelocity = (int) (TabsGridLayout.this.getContext().getResources().getDisplayMetrics().density * MIN_VELOCITY);
            mMaxFlingVelocity = vc.getScaledMaximumFlingVelocity();
        }

        public void setEnabled(boolean enabled) {
            mEnabled = enabled;
        }

        public OnScrollListener makeScrollListener() {
            return new OnScrollListener() {
                @Override
                public void onScrollStateChanged(AbsListView view, int scrollState) {
                    setEnabled(scrollState != GridView.OnScrollListener.SCROLL_STATE_TOUCH_SCROLL);
                }

                @Override
                public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {

                }
            };
        }

        @Override
        public boolean onTouch(View view, MotionEvent e) {
            if (!mEnabled) {
                return false;
            }

            switch (e.getActionMasked()) {
                case MotionEvent.ACTION_DOWN: {
                    // Check if we should set pressed state on the
                    // touched view after a standard delay.
                    triggerCheckForTap();

                    final float x = e.getRawX();
                    final float y = e.getRawY();

                    // Find out which view is being touched
                    mSwipeView = findViewAt(x, y);

                    if (mSwipeView != null) {
                        if (mTabWidth < 2) {
                            mTabWidth = mSwipeView.getWidth();
                        }

                        mSwipeStartX = e.getRawX();

                        mVelocityTracker = VelocityTracker.obtain();
                        mVelocityTracker.addMovement(e);
                    }

                    view.onTouchEvent(e);
                    return true;
                }

                case MotionEvent.ACTION_UP: {
                    if (mSwipeView == null) {
                        break;
                    }

                    cancelCheckForTap();
                    mSwipeView.setPressed(false);

                    if (!mSwiping) {
                        final TabsLayoutItemView item = (TabsLayoutItemView) mSwipeView;
                        final int tabId = item.getTabId();
                        final Tab tab = Tabs.getInstance().selectTab(tabId);
                        if (tab != null) {
                            autoHidePanel();
                            Tabs.getInstance().notifyListeners(tab, Tabs.TabEvents.OPENED_FROM_TABS_TRAY);
                        }

                        mVelocityTracker.recycle();
                        mVelocityTracker = null;
                        break;
                    }

                    mVelocityTracker.addMovement(e);
                    mVelocityTracker.computeCurrentVelocity(1000, mMaxFlingVelocity);

                    float velocityX = Math.abs(mVelocityTracker.getXVelocity());

                    boolean dismiss = false;

                    float deltaX = mSwipeView.getTranslationX();

                    if (Math.abs(deltaX) > mTabWidth / 2) {
                        dismiss = true;
                    } else if (mMinFlingVelocity <= velocityX && velocityX <= mMaxFlingVelocity) {
                        dismiss = mSwiping && (deltaX * mVelocityTracker.getYVelocity() > 0);
                    }
                    if (dismiss) {
                        closeTab(mSwipeView.findViewById(R.id.close));
                    } else {
                        animateCancel(mSwipeView);
                    }
                    mVelocityTracker.recycle();
                    mVelocityTracker = null;
                    mSwipeView = null;

                    mSwipeStartX = 0;
                    mSwiping = false;
                }

                case MotionEvent.ACTION_MOVE: {
                    if (mSwipeView == null || mVelocityTracker == null) {
                        break;
                    }

                    mVelocityTracker.addMovement(e);

                    float delta = e.getRawX() - mSwipeStartX;

                    boolean isScrollingX = Math.abs(delta) > mSwipeThreshold;
                    boolean isSwipingToClose = isScrollingX;

                    // If we're actually swiping, make sure we don't
                    // set pressed state on the swiped view.
                    if (isScrollingX) {
                        cancelCheckForTap();
                    }

                    if (isSwipingToClose) {
                        mSwiping = true;
                        TabsGridLayout.this.requestDisallowInterceptTouchEvent(true);

                        ((TabsLayoutItemView) mSwipeView).setCloseVisible(false);

                        // Stops listview from highlighting the touched item
                        // in the list when swiping.
                        MotionEvent cancelEvent = MotionEvent.obtain(e);
                        cancelEvent.setAction(MotionEvent.ACTION_CANCEL |
                                (e.getActionIndex() << MotionEvent.ACTION_POINTER_INDEX_SHIFT));
                        TabsGridLayout.this.onTouchEvent(cancelEvent);
                        cancelEvent.recycle();
                    }

                    if (mSwiping) {
                        mSwipeView.setTranslationX(delta);

                        mSwipeView.setAlpha(Math.min(1f, 1f - 2f * Math.abs(delta) / mTabWidth));

                        return true;
                    }

                    break;
                }
            }
            return false;
        }

        private View findViewAt(float rawX, float rawY) {
            Rect rect = new Rect();

            int[] listViewCoords = new int[2];
            TabsGridLayout.this.getLocationOnScreen(listViewCoords);

            int x = (int) rawX - listViewCoords[0];
            int y = (int) rawY - listViewCoords[1];

            for (int i = 0; i < TabsGridLayout.this.getChildCount(); i++) {
                View child = TabsGridLayout.this.getChildAt(i);
                child.getHitRect(rect);

                if (rect.contains(x, y)) {
                    return child;
                }
            }

            return null;
        }

        private void triggerCheckForTap() {
            if (mPendingCheckForTap == null) {
                mPendingCheckForTap = new CheckForTap();
            }

            TabsGridLayout.this.postDelayed(mPendingCheckForTap, ViewConfiguration.getTapTimeout());
        }

        private void cancelCheckForTap() {
            if (mPendingCheckForTap == null) {
                return;
            }

            TabsGridLayout.this.removeCallbacks(mPendingCheckForTap);
        }

        private class CheckForTap implements Runnable {
            @Override
            public void run() {
                if (!mSwiping && mSwipeView != null && mEnabled) {
                    mSwipeView.setPressed(true);
                }
            }
        }
    }
}
