/*
 * Copyright (C) 2007 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.mozilla.gecko.widget;

import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Locale;

import org.mozilla.gecko.AppConstants;
import org.mozilla.gecko.AppConstants.Versions;
import org.mozilla.gecko.R;

import android.content.Context;
import android.text.format.DateFormat;
import android.text.format.DateUtils;
import android.util.DisplayMetrics;
import android.util.Log;
import android.util.TypedValue;
import android.view.Display;
import android.view.LayoutInflater;
import android.view.WindowManager;
import android.view.accessibility.AccessibilityEvent;
import android.view.inputmethod.InputMethodManager;
import android.widget.CalendarView;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.NumberPicker;

public class DateTimePicker extends FrameLayout {
    private static final boolean DEBUG = true;
    private static final String LOGTAG = "GeckoDateTimePicker";
    private static final int DEFAULT_START_YEAR = 1;
    private static final int DEFAULT_END_YEAR = 9999;
    private static final char DATE_FORMAT_DAY = 'd';
    private static final char DATE_FORMAT_MONTH = 'M';
    private static final char DATE_FORMAT_YEAR = 'y';

    boolean mYearEnabled = true;
    boolean mMonthEnabled = true;
    boolean mWeekEnabled;
    boolean mDayEnabled = true;
    boolean mHourEnabled = true;
    boolean mMinuteEnabled = true;
    boolean mIs12HourMode;
    private boolean mCalendarEnabled;

    // Size of the screen in inches;
    private final int mScreenWidth;
    private final int mScreenHeight;
    private final OnValueChangeListener mOnChangeListener;
    private final LinearLayout mPickers;
    private final LinearLayout mDateSpinners;
    private final LinearLayout mTimeSpinners;

    final NumberPicker mDaySpinner;
    final NumberPicker mMonthSpinner;
    final NumberPicker mWeekSpinner;
    final NumberPicker mYearSpinner;
    final NumberPicker mHourSpinner;
    final NumberPicker mMinuteSpinner;
    final NumberPicker mAMPMSpinner;
    private final CalendarView mCalendar;
    private final EditText mDaySpinnerInput;
    private final EditText mMonthSpinnerInput;
    private final EditText mWeekSpinnerInput;
    private final EditText mYearSpinnerInput;
    private final EditText mHourSpinnerInput;
    private final EditText mMinuteSpinnerInput;
    private final EditText mAMPMSpinnerInput;
    private Locale mCurrentLocale;
    private String[] mShortMonths;
    private String[] mShortAMPMs;
    private int mNumberOfMonths;

    Calendar mTempDate;
    Calendar mCurrentDate;
    private Calendar mMinDate;
    private Calendar mMaxDate;
    private final PickersState mState;

    public static enum PickersState { DATE, MONTH, WEEK, TIME, DATETIME };

    public class OnValueChangeListener implements NumberPicker.OnValueChangeListener {
        @Override
        public void onValueChange(NumberPicker picker, int oldVal, int newVal) {
            updateInputState();
            mTempDate.setTimeInMillis(mCurrentDate.getTimeInMillis());
            if (DEBUG) {
                Log.d(LOGTAG, "SDK version > 10, using new behavior");
            }

            // The native date picker widget on these SDKs increments
            // the next field when one field reaches the maximum.
            if (picker == mDaySpinner && mDayEnabled) {
                int maxDayOfMonth = mTempDate.getActualMaximum(Calendar.DAY_OF_MONTH);
                int old = mTempDate.get(Calendar.DAY_OF_MONTH);
                setTempDate(Calendar.DAY_OF_MONTH, old, newVal, 1, maxDayOfMonth);
            } else if (picker == mMonthSpinner && mMonthEnabled) {
                int old = mTempDate.get(Calendar.MONTH);
                setTempDate(Calendar.MONTH, old, newVal, Calendar.JANUARY, Calendar.DECEMBER);
            } else if (picker == mWeekSpinner) {
                int old = mTempDate.get(Calendar.WEEK_OF_YEAR);
                int maxWeekOfYear = mTempDate.getActualMaximum(Calendar.WEEK_OF_YEAR);
                setTempDate(Calendar.WEEK_OF_YEAR, old, newVal, 0, maxWeekOfYear);
            } else if (picker == mYearSpinner && mYearEnabled) {
                int month = mTempDate.get(Calendar.MONTH);
                mTempDate.set(Calendar.YEAR, newVal);
                // Changing the year shouldn't change the month. (in case of non-leap year a Feb 29)
                // change the day instead;
                if (month != mTempDate.get(Calendar.MONTH)) {
                    mTempDate.set(Calendar.MONTH, month);
                    mTempDate.set(Calendar.DAY_OF_MONTH,
                    mTempDate.getActualMaximum(Calendar.DAY_OF_MONTH));
                }
            } else if (picker == mHourSpinner && mHourEnabled) {
                if (mIs12HourMode) {
                    setTempDate(Calendar.HOUR, oldVal, newVal, 1, 12);
                } else {
                    setTempDate(Calendar.HOUR_OF_DAY, oldVal, newVal, 0, 23);
                }
            } else if (picker == mMinuteSpinner && mMinuteEnabled) {
                setTempDate(Calendar.MINUTE, oldVal, newVal, 0, 59);
            } else if (picker == mAMPMSpinner && mHourEnabled) {
                mTempDate.set(Calendar.AM_PM, newVal);
            } else {
                throw new IllegalArgumentException();
            }
            setDate(mTempDate);
            if (mDayEnabled) {
                mDaySpinner.setMaxValue(mCurrentDate.getActualMaximum(Calendar.DAY_OF_MONTH));
            }
            if (mWeekEnabled) {
                mWeekSpinner.setMaxValue(mCurrentDate.getActualMaximum(Calendar.WEEK_OF_YEAR));
            }
            updateCalendar();
            updateSpinners();
            notifyDateChanged();
        }

        private void setTempDate(int field, int oldVal, int newVal, int min, int max) {
            if (oldVal == max && newVal == min) {
                mTempDate.add(field, 1);
            } else if (oldVal == min && newVal == max) {
                mTempDate.add(field, -1);
            } else {
                mTempDate.add(field, newVal - oldVal);
            }
        }
    }

    private static final NumberPicker.Formatter TWO_DIGIT_FORMATTER = new NumberPicker.Formatter() {
        final StringBuilder mBuilder = new StringBuilder();

        final java.util.Formatter mFmt = new java.util.Formatter(mBuilder, java.util.Locale.US);

        final Object[] mArgs = new Object[1];

        @Override
        public String format(int value) {
            mArgs[0] = value;
            mBuilder.delete(0, mBuilder.length());
            mFmt.format("%02d", mArgs);
            return mFmt.toString();
        }
    };

    private void displayPickers() {
        setWeekShown(false);
        set12HourShown(mIs12HourMode);
        if (mState == PickersState.DATETIME) {
            return;
        }

        setHourShown(false);
        setMinuteShown(false);
        if (mState == PickersState.WEEK) {
            setDayShown(false);
            setMonthShown(false);
            setWeekShown(true);
        } else if (mState == PickersState.MONTH) {
            setDayShown(false);
        }
    }

    public DateTimePicker(Context context) {
        this(context, "", "", PickersState.DATE, null, null);
    }

    public DateTimePicker(Context context, String dateFormat, String dateTimeValue, PickersState state, String minDateValue, String maxDateValue) {
        super(context);

        setCurrentLocale(Locale.getDefault());

        mState = state;
        LayoutInflater inflater = LayoutInflater.from(context);
        inflater.inflate(R.layout.datetime_picker, this, true);

        mOnChangeListener = new OnValueChangeListener();

        mDateSpinners = (LinearLayout)findViewById(R.id.date_spinners);
        mTimeSpinners = (LinearLayout)findViewById(R.id.time_spinners);
        mPickers = (LinearLayout)findViewById(R.id.datetime_picker);

        // We will display differently according to the screen size width.
        WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        Display display = wm.getDefaultDisplay();
        DisplayMetrics dm = new DisplayMetrics();
        display.getMetrics(dm);
        mScreenWidth = display.getWidth() / dm.densityDpi;
        mScreenHeight = display.getHeight() / dm.densityDpi;

        if (DEBUG) {
            Log.d(LOGTAG, "screen width: " + mScreenWidth + " screen height: " + mScreenHeight);
        }

        // Set the min / max attribute.
        try {
            if (minDateValue != null && !minDateValue.equals("")) {
                mMinDate.setTime(new SimpleDateFormat(dateFormat).parse(minDateValue));
            } else {
                mMinDate.set(DEFAULT_START_YEAR, Calendar.JANUARY, 1);
            }
        } catch (Exception ex) {
            Log.e(LOGTAG, "Error parsing format sting: " + ex);
            mMinDate.set(DEFAULT_START_YEAR, Calendar.JANUARY, 1);
        }

        try {
            if (maxDateValue != null && !maxDateValue.equals("")) {
                mMaxDate.setTime(new SimpleDateFormat(dateFormat).parse(maxDateValue));
            } else {
                mMaxDate.set(DEFAULT_END_YEAR, Calendar.DECEMBER, 31);
            }
        } catch (Exception ex) {
            Log.e(LOGTAG, "Error parsing format string: " + ex);
            mMaxDate.set(DEFAULT_END_YEAR, Calendar.DECEMBER, 31);
        }

        // Find the initial date from the constructor arguments.
        try {
            if (!dateTimeValue.equals("")) {
                mTempDate.setTime(new SimpleDateFormat(dateFormat).parse(dateTimeValue));
            } else {
                mTempDate.setTimeInMillis(System.currentTimeMillis());
            }
        } catch (Exception ex) {
            Log.e(LOGTAG, "Error parsing format string: " + ex);
            mTempDate.setTimeInMillis(System.currentTimeMillis());
        }

        if (mMaxDate.before(mMinDate)) {
            // If the input date range is illogical/garbage, we should not restrict the input range (i.e. allow the
            // user to select any date). If we try to make any assumptions based on the illogical min/max date we could
            // potentially prevent the user from selecting dates that are in the developers intended range, so it's best
            // to allow anything.
            mMinDate.set(DEFAULT_START_YEAR, Calendar.JANUARY, 1);
            mMaxDate.set(DEFAULT_END_YEAR, Calendar.DECEMBER, 31);
        }

        // mTempDate will either be a site-supplied value, or today's date otherwise. CalendarView implementations can
        // crash if they're supplied an invalid date (i.e. a date not in the specified range), hence we need to set
        // a sensible default date here.
        if (mTempDate.before(mMinDate) || mTempDate.after(mMaxDate)) {
            mTempDate.setTimeInMillis(mMinDate.getTimeInMillis());
        }

        // If we're displaying a date, the screen is wide enough
        // (and if we're using an SDK where the calendar view exists)
        // then display a calendar.
        if (mState == PickersState.DATE || mState == PickersState.DATETIME) {
            mCalendar = new CalendarView(context);
            mCalendar.setVisibility(GONE);

            mCalendar.setFocusable(true);
            mCalendar.setFocusableInTouchMode(true);
            mCalendar.setMaxDate(mMaxDate.getTimeInMillis());
            mCalendar.setMinDate(mMinDate.getTimeInMillis());
            mCalendar.setDate(mTempDate.getTimeInMillis(), false, false);

            mCalendar.setOnDateChangeListener(new CalendarView.OnDateChangeListener() {
                @Override
                public void onSelectedDayChange(
                    CalendarView view, int year, int month, int monthDay) {
                    mTempDate.set(year, month, monthDay);
                    setDate(mTempDate);
                    notifyDateChanged();
                }
            });

            final int height;
            if (Versions.preLollipop) {
                // The 4.X version of CalendarView doesn't request any height, resulting in
                // the whole dialog not appearing unless we manually request height.
                height =  (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 200, getResources().getDisplayMetrics());;
            } else {
                height = LayoutParams.WRAP_CONTENT;
            }

            mPickers.addView(mCalendar, LayoutParams.MATCH_PARENT, height);

        } else {
            // If the screen is more wide than high, we are displaying day and
            // time spinners, and if there is no calendar displayed, we should
            // display the fields in one row.
            if (mScreenWidth > mScreenHeight && mState == PickersState.DATETIME) {
                mPickers.setOrientation(LinearLayout.HORIZONTAL);
            }
            mCalendar = null;
        }

        // Initialize all spinners.
        mDaySpinner = setupSpinner(R.id.day, 1,
                                   mTempDate.get(Calendar.DAY_OF_MONTH));
        mDaySpinner.setFormatter(TWO_DIGIT_FORMATTER);
        mDaySpinnerInput = (EditText) mDaySpinner.getChildAt(1);

        mMonthSpinner = setupSpinner(R.id.month, 1,
                                     mTempDate.get(Calendar.MONTH) + 1); // Month is 0-based
        mMonthSpinner.setFormatter(TWO_DIGIT_FORMATTER);
        mMonthSpinner.setDisplayedValues(mShortMonths);
        mMonthSpinnerInput = (EditText) mMonthSpinner.getChildAt(1);

        mWeekSpinner = setupSpinner(R.id.week, 1,
                                    mTempDate.get(Calendar.WEEK_OF_YEAR));
        mWeekSpinner.setFormatter(TWO_DIGIT_FORMATTER);
        mWeekSpinnerInput = (EditText) mWeekSpinner.getChildAt(1);

        mYearSpinner = setupSpinner(R.id.year, DEFAULT_START_YEAR,
                                    DEFAULT_END_YEAR);
        mYearSpinnerInput = (EditText) mYearSpinner.getChildAt(1);

        mAMPMSpinner = setupSpinner(R.id.ampm, 0, 1);
        mAMPMSpinner.setFormatter(TWO_DIGIT_FORMATTER);

        if (mIs12HourMode) {
            mHourSpinner = setupSpinner(R.id.hour, 1, 12);
            mAMPMSpinnerInput = (EditText) mAMPMSpinner.getChildAt(1);
            mAMPMSpinner.setDisplayedValues(mShortAMPMs);
        } else {
            mHourSpinner = setupSpinner(R.id.hour, 0, 23);
            mAMPMSpinnerInput = null;
        }

        mHourSpinner.setFormatter(TWO_DIGIT_FORMATTER);
        mHourSpinnerInput = (EditText) mHourSpinner.getChildAt(1);

        mMinuteSpinner = setupSpinner(R.id.minute, 0, 59);
        mMinuteSpinner.setFormatter(TWO_DIGIT_FORMATTER);
        mMinuteSpinnerInput = (EditText) mMinuteSpinner.getChildAt(1);

        // The order in which the spinners are displayed are locale-dependent
        reorderDateSpinners();

        // Set the date to the initial date. Since this date can come from the user,
        // it can fire an exception (out-of-bound date)
        try {
          updateDate(mTempDate);
        } catch (Exception ex) {
        }

        // Display only the pickers needed for the current state.
        displayPickers();
    }

    public NumberPicker setupSpinner(int id, int min, int max) {
        NumberPicker mSpinner = (NumberPicker) findViewById(id);
        mSpinner.setMinValue(min);
        mSpinner.setMaxValue(max);
        mSpinner.setOnValueChangedListener(mOnChangeListener);
        mSpinner.setOnLongPressUpdateInterval(100);
        return mSpinner;
    }

    public long getTimeInMillis() {
        return mCurrentDate.getTimeInMillis();
    }

    private void reorderDateSpinners() {
        mDateSpinners.removeAllViews();
        char[] order = DateFormat.getDateFormatOrder(getContext());
        final int spinnerCount = order.length;

        for (int i = 0; i < spinnerCount; i++) {
            switch (order[i]) {
                case DATE_FORMAT_DAY:
                    mDateSpinners.addView(mDaySpinner);
                    break;
                case DATE_FORMAT_MONTH:
                    mDateSpinners.addView(mMonthSpinner);
                    break;
                case DATE_FORMAT_YEAR:
                    mDateSpinners.addView(mYearSpinner);
                    break;
                default:
                    throw new IllegalArgumentException();
            }
        }

        mDateSpinners.addView(mWeekSpinner);
    }

    void setDate(Calendar calendar) {
        mCurrentDate = mTempDate;
        if (mCurrentDate.before(mMinDate)) {
            mCurrentDate.setTimeInMillis(mMinDate.getTimeInMillis());
        } else if (mCurrentDate.after(mMaxDate)) {
            mCurrentDate.setTimeInMillis(mMaxDate.getTimeInMillis());
        }
    }

    void updateInputState() {
        InputMethodManager inputMethodManager = (InputMethodManager)
          getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
        if (mYearEnabled && inputMethodManager.isActive(mYearSpinnerInput)) {
            mYearSpinnerInput.clearFocus();
            inputMethodManager.hideSoftInputFromWindow(getWindowToken(), 0);
        } else if (mMonthEnabled && inputMethodManager.isActive(mMonthSpinnerInput)) {
            mMonthSpinnerInput.clearFocus();
            inputMethodManager.hideSoftInputFromWindow(getWindowToken(), 0);
        } else if (mDayEnabled && inputMethodManager.isActive(mDaySpinnerInput)) {
            mDaySpinnerInput.clearFocus();
            inputMethodManager.hideSoftInputFromWindow(getWindowToken(), 0);
        } else if (mHourEnabled && inputMethodManager.isActive(mHourSpinnerInput)) {
            mHourSpinnerInput.clearFocus();
            inputMethodManager.hideSoftInputFromWindow(getWindowToken(), 0);
        } else if (mMinuteEnabled && inputMethodManager.isActive(mMinuteSpinnerInput)) {
            mMinuteSpinnerInput.clearFocus();
            inputMethodManager.hideSoftInputFromWindow(getWindowToken(), 0);
        }
    }

    void updateSpinners() {
        if (mDayEnabled) {
            if (mCurrentDate.equals(mMinDate)) {
                mDaySpinner.setMinValue(mCurrentDate.get(Calendar.DAY_OF_MONTH));
                mDaySpinner.setMaxValue(mCurrentDate.getActualMaximum(Calendar.DAY_OF_MONTH));
            } else if (mCurrentDate.equals(mMaxDate)) {
                mDaySpinner.setMinValue(mCurrentDate.getActualMinimum(Calendar.DAY_OF_MONTH));
                mDaySpinner.setMaxValue(mCurrentDate.get(Calendar.DAY_OF_MONTH));
            } else {
                mDaySpinner.setMinValue(1);
                mDaySpinner.setMaxValue(mCurrentDate.getActualMaximum(Calendar.DAY_OF_MONTH));
            }
            mDaySpinner.setValue(mCurrentDate.get(Calendar.DAY_OF_MONTH));
        }

        if (mWeekEnabled) {
            mWeekSpinner.setMinValue(1);
            mWeekSpinner.setMaxValue(mCurrentDate.getActualMaximum(Calendar.WEEK_OF_YEAR));
            mWeekSpinner.setValue(mCurrentDate.get(Calendar.WEEK_OF_YEAR));
        }

        if (mMonthEnabled) {
            mMonthSpinner.setDisplayedValues(null);
            if (mCurrentDate.equals(mMinDate)) {
                mMonthSpinner.setMinValue(mCurrentDate.get(Calendar.MONTH));
                mMonthSpinner.setMaxValue(mCurrentDate.getActualMaximum(Calendar.MONTH));
            } else if (mCurrentDate.equals(mMaxDate)) {
                mMonthSpinner.setMinValue(mCurrentDate.getActualMinimum(Calendar.MONTH));
                mMonthSpinner.setMaxValue(mCurrentDate.get(Calendar.MONTH));
            } else {
                mMonthSpinner.setMinValue(Calendar.JANUARY);
                mMonthSpinner.setMaxValue(Calendar.DECEMBER);
            }

            String[] displayedValues = Arrays.copyOfRange(mShortMonths,
                    mMonthSpinner.getMinValue(), mMonthSpinner.getMaxValue() + 1);
            mMonthSpinner.setDisplayedValues(displayedValues);
            mMonthSpinner.setValue(mCurrentDate.get(Calendar.MONTH));
        }

        if (mYearEnabled) {
            mYearSpinner.setMinValue(mMinDate.get(Calendar.YEAR));
            mYearSpinner.setMaxValue(mMaxDate.get(Calendar.YEAR));
            mYearSpinner.setValue(mCurrentDate.get(Calendar.YEAR));
        }

        if (mHourEnabled) {
            if (mIs12HourMode) {
                mHourSpinner.setValue(mCurrentDate.get(Calendar.HOUR));
                mAMPMSpinner.setValue(mCurrentDate.get(Calendar.AM_PM));
                mAMPMSpinner.setDisplayedValues(mShortAMPMs);
            } else {
                mHourSpinner.setValue(mCurrentDate.get(Calendar.HOUR_OF_DAY));
            }
        }
        if (mMinuteEnabled) {
            mMinuteSpinner.setValue(mCurrentDate.get(Calendar.MINUTE));
        }
    }

    void updateCalendar() {
        if (mCalendarEnabled) {
            mCalendar.setDate(mCurrentDate.getTimeInMillis(), false, false);
        }
    }

    void notifyDateChanged() {
        sendAccessibilityEvent(AccessibilityEvent.TYPE_VIEW_SELECTED);
    }

    public void toggleCalendar(boolean shown) {
        if ((mState != PickersState.DATE && mState != PickersState.DATETIME)) {
            return;
        }

        if (shown) {
            mCalendarEnabled = true;
            mCalendar.setVisibility(VISIBLE);
            setYearShown(false);
            setWeekShown(false);
            setMonthShown(false);
            setDayShown(false);
        } else {
            mCalendar.setVisibility(GONE);
            setYearShown(true);
            setMonthShown(true);
            setDayShown(true);
            mPickers.setOrientation(LinearLayout.HORIZONTAL);
            mCalendarEnabled = false;
        }
    }

    private void setYearShown(boolean shown) {
        if (shown) {
            toggleCalendar(false);
            mYearSpinner.setVisibility(VISIBLE);
            mYearEnabled = true;
        } else {
            mYearSpinner.setVisibility(GONE);
            mYearEnabled = false;
        }
    }

    private void setWeekShown(boolean shown) {
        if (shown) {
            toggleCalendar(false);
            mWeekSpinner.setVisibility(VISIBLE);
            mWeekEnabled = true;
        } else {
            mWeekSpinner.setVisibility(GONE);
            mWeekEnabled = false;
        }
    }

    private void setMonthShown(boolean shown) {
        if (shown) {
            toggleCalendar(false);
            mMonthSpinner.setVisibility(VISIBLE);
            mMonthEnabled = true;
        } else {
            mMonthSpinner.setVisibility(GONE);
            mMonthEnabled = false;
        }
    }

    private void setDayShown(boolean shown) {
        if (shown) {
            toggleCalendar(false);
            mDaySpinner.setVisibility(VISIBLE);
            mDayEnabled = true;
        } else {
            mDaySpinner.setVisibility(GONE);
            mDayEnabled = false;
        }
    }

    private void set12HourShown(boolean shown) {
        if (shown) {
            mAMPMSpinner.setVisibility(VISIBLE);
        } else {
            mAMPMSpinner.setVisibility(GONE);
        }
    }

    private void setHourShown(boolean shown) {
        if (shown) {
            mHourSpinner.setVisibility(VISIBLE);
            mHourEnabled = true;
        } else {
            mHourSpinner.setVisibility(GONE);
            mAMPMSpinner.setVisibility(GONE);
            mTimeSpinners.setVisibility(GONE);
            mHourEnabled = false;
        }
    }

    private void setMinuteShown(boolean shown) {
        if (shown) {
            mMinuteSpinner.setVisibility(VISIBLE);
            mTimeSpinners.findViewById(R.id.mincolon).setVisibility(VISIBLE);
            mMinuteEnabled = true;
        } else {
            mMinuteSpinner.setVisibility(GONE);
            mTimeSpinners.findViewById(R.id.mincolon).setVisibility(GONE);
            mMinuteEnabled = false;
        }
    }

    private void setCurrentLocale(Locale locale) {
        if (locale.equals(mCurrentLocale)) {
            return;
        }

        mCurrentLocale = locale;
        mIs12HourMode = !DateFormat.is24HourFormat(getContext());
        mTempDate = getCalendarForLocale(mTempDate, locale);
        mMinDate = getCalendarForLocale(mMinDate, locale);
        mMaxDate = getCalendarForLocale(mMaxDate, locale);
        mCurrentDate = getCalendarForLocale(mCurrentDate, locale);

        mNumberOfMonths = mTempDate.getActualMaximum(Calendar.MONTH) + 1;

        mShortAMPMs = new String[2];
        mShortAMPMs[0] = DateUtils.getAMPMString(Calendar.AM);
        mShortAMPMs[1] = DateUtils.getAMPMString(Calendar.PM);

        mShortMonths = new String[mNumberOfMonths];
        for (int i = 0; i < mNumberOfMonths; i++) {
            mShortMonths[i] = DateUtils.getMonthString(Calendar.JANUARY + i,
                    DateUtils.LENGTH_MEDIUM);
        }
    }

    private Calendar getCalendarForLocale(Calendar oldCalendar, Locale locale) {
        if (oldCalendar == null) {
            return Calendar.getInstance(locale);
        }

        final long currentTimeMillis = oldCalendar.getTimeInMillis();
        Calendar newCalendar = Calendar.getInstance(locale);
        newCalendar.setTimeInMillis(currentTimeMillis);
        return newCalendar;
    }

    public void updateDate(Calendar calendar) {
        if (mCurrentDate.equals(calendar)) {
            return;
        }
        mCurrentDate.setTimeInMillis(calendar.getTimeInMillis());
        if (mCurrentDate.before(mMinDate)) {
            mCurrentDate.setTimeInMillis(mMinDate.getTimeInMillis());
        } else if (mCurrentDate.after(mMaxDate)) {
            mCurrentDate.setTimeInMillis(mMaxDate.getTimeInMillis());
        }
        updateSpinners();
        notifyDateChanged();
    }
}
