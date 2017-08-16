// Copyright (c) 2012 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Time represents an absolute point in coordinated universal time (UTC),
// internally represented as microseconds (s/1,000,000) since the Windows epoch
// (1601-01-01 00:00:00 UTC). System-dependent clock interface routines are
// defined in time_PLATFORM.cc. Note that values for Time may skew and jump
// around as the operating system makes adjustments to synchronize (e.g., with
// NTP servers). Thus, client code that uses the Time class must account for
// this.
//
// TimeDelta represents a duration of time, internally represented in
// microseconds.
//
// TimeTicks and ThreadTicks represent an abstract time that is most of the time
// incrementing, for use in measuring time durations. Internally, they are
// represented in microseconds. They can not be converted to a human-readable
// time, but are guaranteed not to decrease (unlike the Time class). Note that
// TimeTicks may "stand still" (e.g., if the computer is suspended), and
// ThreadTicks will "stand still" whenever the thread has been de-scheduled by
// the operating system.
//
// All time classes are copyable, assignable, and occupy 64-bits per instance.
// As a result, prefer passing them by value:
//   void MyFunction(TimeDelta arg);
// If circumstances require, you may also pass by const reference:
//   void MyFunction(const TimeDelta& arg);  // Not preferred.
//
// Definitions of operator<< are provided to make these types work with
// DCHECK_EQ() and other log macros. For human-readable formatting, see
// "base/i18n/time_formatting.h".
//
// So many choices!  Which time class should you use?  Examples:
//
//   Time:        Interpreting the wall-clock time provided by a remote
//                system. Detecting whether cached resources have
//                expired. Providing the user with a display of the current date
//                and time. Determining the amount of time between events across
//                re-boots of the machine.
//
//   TimeTicks:   Tracking the amount of time a task runs. Executing delayed
//                tasks at the right time. Computing presentation timestamps.
//                Synchronizing audio and video using TimeTicks as a common
//                reference clock (lip-sync). Measuring network round-trip
//                latency.
//
//   ThreadTicks: Benchmarking how long the current thread has been doing actual
//                work.

#ifndef BASE_TIME_TIME_H_
#define BASE_TIME_TIME_H_

#include <stdint.h>
#include <time.h>

#include <iosfwd>
#include <limits>

#include "base/base_export.h"
#include "base/compiler_specific.h"
#include "base/numerics/safe_math.h"
#include "build/build_config.h"

#if defined(OS_MACOSX)
#include <CoreFoundation/CoreFoundation.h>
// Avoid Mac system header macro leak.
#undef TYPE_BOOL
#endif

#if defined(OS_POSIX)
#include <unistd.h>
#include <sys/time.h>
#endif

#if defined(OS_WIN)
// For FILETIME in FromFileTime, until it moves to a new converter class.
// See TODO(iyengar) below.
#include <windows.h>
#include "base/gtest_prod_util.h"
#endif

namespace base {

class PlatformThreadHandle;
class TimeDelta;

// The functions in the time_internal namespace are meant to be used only by the
// time classes and functions.  Please use the math operators defined in the
// time classes instead.
namespace time_internal {

// Add or subtract |value| from a TimeDelta. The int64_t argument and return
// value are in terms of a microsecond timebase.
BASE_EXPORT int64_t SaturatedAdd(TimeDelta delta, int64_t value);
BASE_EXPORT int64_t SaturatedSub(TimeDelta delta, int64_t value);

}  // namespace time_internal

// TimeDelta ------------------------------------------------------------------

class BASE_EXPORT TimeDelta {
 public:
  TimeDelta() : delta_(0) {
  }

  // Converts units of time to TimeDeltas.
  static constexpr TimeDelta FromDays(int days);
  static constexpr TimeDelta FromHours(int hours);
  static constexpr TimeDelta FromMinutes(int minutes);
  static constexpr TimeDelta FromSeconds(int64_t secs);
  static constexpr TimeDelta FromMilliseconds(int64_t ms);
  static constexpr TimeDelta FromSecondsD(double secs);
  static constexpr TimeDelta FromMillisecondsD(double ms);
  static constexpr TimeDelta FromMicroseconds(int64_t us);
#if defined(OS_POSIX)
  static TimeDelta FromTimeSpec(const timespec& ts);
#endif
#if defined(OS_WIN)
  static TimeDelta FromQPCValue(LONGLONG qpc_value);
#endif

  // Converts an integer value representing TimeDelta to a class. This is used
  // when deserializing a |TimeDelta| structure, using a value known to be
  // compatible. It is not provided as a constructor because the integer type
  // may be unclear from the perspective of a caller.
  static TimeDelta FromInternalValue(int64_t delta) { return TimeDelta(delta); }

  // Returns the maximum time delta, which should be greater than any reasonable
  // time delta we might compare it to. Adding or subtracting the maximum time
  // delta to a time or another time delta has an undefined result.
  static TimeDelta Max();

  // Returns the internal numeric value of the TimeDelta object. Please don't
  // use this and do arithmetic on it, as it is more error prone than using the
  // provided operators.
  // For serializing, use FromInternalValue to reconstitute.
  int64_t ToInternalValue() const { return delta_; }

  // Returns the magnitude (absolute value) of this TimeDelta.
  TimeDelta magnitude() const {
    // Some toolchains provide an incomplete C++11 implementation and lack an
    // int64_t overload for std::abs().  The following is a simple branchless
    // implementation:
    const int64_t mask = delta_ >> (sizeof(delta_) * 8 - 1);
    return TimeDelta((delta_ + mask) ^ mask);
  }

  // Returns true if the time delta is zero.
  bool is_zero() const {
    return delta_ == 0;
  }

  // Returns true if the time delta is the maximum time delta.
  bool is_max() const { return delta_ == std::numeric_limits<int64_t>::max(); }

#if defined(OS_POSIX)
  struct timespec ToTimeSpec() const;
#endif

  // Returns the time delta in some unit. The F versions return a floating
  // point value, the "regular" versions return a rounded-down value.
  //
  // InMillisecondsRoundedUp() instead returns an integer that is rounded up
  // to the next full millisecond.
  int InDays() const;
  int InHours() const;
  int InMinutes() const;
  double InSecondsF() const;
  int64_t InSeconds() const;
  double InMillisecondsF() const;
  int64_t InMilliseconds() const;
  int64_t InMillisecondsRoundedUp() const;
  int64_t InMicroseconds() const;

  TimeDelta& operator=(TimeDelta other) {
    delta_ = other.delta_;
    return *this;
  }

  // Computations with other deltas.
  TimeDelta operator+(TimeDelta other) const {
    return TimeDelta(time_internal::SaturatedAdd(*this, other.delta_));
  }
  TimeDelta operator-(TimeDelta other) const {
    return TimeDelta(time_internal::SaturatedSub(*this, other.delta_));
  }

  TimeDelta& operator+=(TimeDelta other) {
    return *this = (*this + other);
  }
  TimeDelta& operator-=(TimeDelta other) {
    return *this = (*this - other);
  }
  TimeDelta operator-() const {
    return TimeDelta(-delta_);
  }

  // Computations with numeric types.
  template<typename T>
  TimeDelta operator*(T a) const {
    CheckedNumeric<int64_t> rv(delta_);
    rv *= a;
    if (rv.IsValid())
      return TimeDelta(rv.ValueOrDie());
    // Matched sign overflows. Mismatched sign underflows.
    if ((delta_ < 0) ^ (a < 0))
      return TimeDelta(-std::numeric_limits<int64_t>::max());
    return TimeDelta(std::numeric_limits<int64_t>::max());
  }
  template<typename T>
  TimeDelta operator/(T a) const {
    CheckedNumeric<int64_t> rv(delta_);
    rv /= a;
    if (rv.IsValid())
      return TimeDelta(rv.ValueOrDie());
    // Matched sign overflows. Mismatched sign underflows.
    // Special case to catch divide by zero.
    if ((delta_ < 0) ^ (a <= 0))
      return TimeDelta(-std::numeric_limits<int64_t>::max());
    return TimeDelta(std::numeric_limits<int64_t>::max());
  }
  template<typename T>
  TimeDelta& operator*=(T a) {
    return *this = (*this * a);
  }
  template<typename T>
  TimeDelta& operator/=(T a) {
    return *this = (*this / a);
  }

  int64_t operator/(TimeDelta a) const { return delta_ / a.delta_; }
  TimeDelta operator%(TimeDelta a) const {
    return TimeDelta(delta_ % a.delta_);
  }

  // Comparison operators.
  constexpr bool operator==(TimeDelta other) const {
    return delta_ == other.delta_;
  }
  constexpr bool operator!=(TimeDelta other) const {
    return delta_ != other.delta_;
  }
  constexpr bool operator<(TimeDelta other) const {
    return delta_ < other.delta_;
  }
  constexpr bool operator<=(TimeDelta other) const {
    return delta_ <= other.delta_;
  }
  constexpr bool operator>(TimeDelta other) const {
    return delta_ > other.delta_;
  }
  constexpr bool operator>=(TimeDelta other) const {
    return delta_ >= other.delta_;
  }

#if defined(OS_WIN)
  // This works around crbug.com/635974
  constexpr TimeDelta(const TimeDelta& other) : delta_(other.delta_) {}
#endif

 private:
  friend int64_t time_internal::SaturatedAdd(TimeDelta delta, int64_t value);
  friend int64_t time_internal::SaturatedSub(TimeDelta delta, int64_t value);

  // Constructs a delta given the duration in microseconds. This is private
  // to avoid confusion by callers with an integer constructor. Use
  // FromSeconds, FromMilliseconds, etc. instead.
  constexpr explicit TimeDelta(int64_t delta_us) : delta_(delta_us) {}

  // Private method to build a delta from a double.
  static constexpr TimeDelta FromDouble(double value);

  // Private method to build a delta from the product of a user-provided value
  // and a known-positive value.
  static constexpr TimeDelta FromProduct(int64_t value, int64_t positive_value);

  // Delta in microseconds.
  int64_t delta_;
};

template<typename T>
inline TimeDelta operator*(T a, TimeDelta td) {
  return td * a;
}

// For logging use only.
BASE_EXPORT std::ostream& operator<<(std::ostream& os, TimeDelta time_delta);

// Do not reference the time_internal::TimeBase template class directly.  Please
// use one of the time subclasses instead, and only reference the public
// TimeBase members via those classes.
namespace time_internal {

// TimeBase--------------------------------------------------------------------

// Provides value storage and comparison/math operations common to all time
// classes. Each subclass provides for strong type-checking to ensure
// semantically meaningful comparison/math of time values from the same clock
// source or timeline.
template<class TimeClass>
class TimeBase {
 public:
  static const int64_t kHoursPerDay = 24;
  static const int64_t kMillisecondsPerSecond = 1000;
  static const int64_t kMillisecondsPerDay =
      kMillisecondsPerSecond * 60 * 60 * kHoursPerDay;
  static const int64_t kMicrosecondsPerMillisecond = 1000;
  static const int64_t kMicrosecondsPerSecond =
      kMicrosecondsPerMillisecond * kMillisecondsPerSecond;
  static const int64_t kMicrosecondsPerMinute = kMicrosecondsPerSecond * 60;
  static const int64_t kMicrosecondsPerHour = kMicrosecondsPerMinute * 60;
  static const int64_t kMicrosecondsPerDay =
      kMicrosecondsPerHour * kHoursPerDay;
  static const int64_t kMicrosecondsPerWeek = kMicrosecondsPerDay * 7;
  static const int64_t kNanosecondsPerMicrosecond = 1000;
  static const int64_t kNanosecondsPerSecond =
      kNanosecondsPerMicrosecond * kMicrosecondsPerSecond;

  // Returns true if this object has not been initialized.
  //
  // Warning: Be careful when writing code that performs math on time values,
  // since it's possible to produce a valid "zero" result that should not be
  // interpreted as a "null" value.
  bool is_null() const {
    return us_ == 0;
  }

  // Returns true if this object represents the maximum time.
  bool is_max() const { return us_ == std::numeric_limits<int64_t>::max(); }

  // Returns the maximum time, which should be greater than any reasonable time
  // with which we might compare it.
  static TimeClass Max() {
    return TimeClass(std::numeric_limits<int64_t>::max());
  }

  // For serializing only. Use FromInternalValue() to reconstitute. Please don't
  // use this and do arithmetic on it, as it is more error prone than using the
  // provided operators.
  int64_t ToInternalValue() const { return us_; }

  TimeClass& operator=(TimeClass other) {
    us_ = other.us_;
    return *(static_cast<TimeClass*>(this));
  }

  // Compute the difference between two times.
  TimeDelta operator-(TimeClass other) const {
    return TimeDelta::FromMicroseconds(us_ - other.us_);
  }

  // Return a new time modified by some delta.
  TimeClass operator+(TimeDelta delta) const {
    return TimeClass(time_internal::SaturatedAdd(delta, us_));
  }
  TimeClass operator-(TimeDelta delta) const {
    return TimeClass(-time_internal::SaturatedSub(delta, us_));
  }

  // Modify by some time delta.
  TimeClass& operator+=(TimeDelta delta) {
    return static_cast<TimeClass&>(*this = (*this + delta));
  }
  TimeClass& operator-=(TimeDelta delta) {
    return static_cast<TimeClass&>(*this = (*this - delta));
  }

  // Comparison operators
  bool operator==(TimeClass other) const {
    return us_ == other.us_;
  }
  bool operator!=(TimeClass other) const {
    return us_ != other.us_;
  }
  bool operator<(TimeClass other) const {
    return us_ < other.us_;
  }
  bool operator<=(TimeClass other) const {
    return us_ <= other.us_;
  }
  bool operator>(TimeClass other) const {
    return us_ > other.us_;
  }
  bool operator>=(TimeClass other) const {
    return us_ >= other.us_;
  }

  // Converts an integer value representing TimeClass to a class. This is used
  // when deserializing a |TimeClass| structure, using a value known to be
  // compatible. It is not provided as a constructor because the integer type
  // may be unclear from the perspective of a caller.
  static TimeClass FromInternalValue(int64_t us) { return TimeClass(us); }

 protected:
  explicit TimeBase(int64_t us) : us_(us) {}

  // Time value in a microsecond timebase.
  int64_t us_;
};

}  // namespace time_internal

template<class TimeClass>
inline TimeClass operator+(TimeDelta delta, TimeClass t) {
  return t + delta;
}

// Time -----------------------------------------------------------------------

// Represents a wall clock time in UTC. Values are not guaranteed to be
// monotonically non-decreasing and are subject to large amounts of skew.
class BASE_EXPORT Time : public time_internal::TimeBase<Time> {
 public:
  // The representation of Jan 1, 1970 UTC in microseconds since the
  // platform-dependent epoch.
  static const int64_t kTimeTToMicrosecondsOffset;

#if !defined(OS_WIN)
  // On Mac & Linux, this value is the delta from the Windows epoch of 1601 to
  // the Posix delta of 1970. This is used for migrating between the old
  // 1970-based epochs to the new 1601-based ones. It should be removed from
  // this global header and put in the platform-specific ones when we remove the
  // migration code.
  static const int64_t kWindowsEpochDeltaMicroseconds;
#else
  // To avoid overflow in QPC to Microseconds calculations, since we multiply
  // by kMicrosecondsPerSecond, then the QPC value should not exceed
  // (2^63 - 1) / 1E6. If it exceeds that threshold, we divide then multiply.
  enum : int64_t{kQPCOverflowThreshold = 0x8637BD05AF7};
#endif

  // Represents an exploded time that can be formatted nicely. This is kind of
  // like the Win32 SYSTEMTIME structure or the Unix "struct tm" with a few
  // additions and changes to prevent errors.
  struct BASE_EXPORT Exploded {
    int year;          // Four digit year "2007"
    int month;         // 1-based month (values 1 = January, etc.)
    int day_of_week;   // 0-based day of week (0 = Sunday, etc.)
    int day_of_month;  // 1-based day of month (1-31)
    int hour;          // Hour within the current day (0-23)
    int minute;        // Minute within the current hour (0-59)
    int second;        // Second within the current minute (0-59 plus leap
                       //   seconds which may take it up to 60).
    int millisecond;   // Milliseconds within the current second (0-999)

    // A cursory test for whether the data members are within their
    // respective ranges. A 'true' return value does not guarantee the
    // Exploded value can be successfully converted to a Time value.
    bool HasValidValues() const;
  };

  // Contains the NULL time. Use Time::Now() to get the current time.
  Time() : TimeBase(0) {
  }

  // Returns the time for epoch in Unix-like system (Jan 1, 1970).
  static Time UnixEpoch();

  // Returns the current time. Watch out, the system might adjust its clock
  // in which case time will actually go backwards. We don't guarantee that
  // times are increasing, or that two calls to Now() won't be the same.
  static Time Now();

  // Returns the current time. Same as Now() except that this function always
  // uses system time so that there are no discrepancies between the returned
  // time and system time even on virtual environments including our test bot.
  // For timing sensitive unittests, this function should be used.
  static Time NowFromSystemTime();

  // Converts to/from time_t in UTC and a Time class.
  static Time FromTimeT(time_t tt);
  time_t ToTimeT() const;

  // Converts time to/from a double which is the number of seconds since epoch
  // (Jan 1, 1970).  Webkit uses this format to represent time.
  // Because WebKit initializes double time value to 0 to indicate "not
  // initialized", we map it to empty Time object that also means "not
  // initialized".
  static Time FromDoubleT(double dt);
  double ToDoubleT() const;

#if defined(OS_POSIX)
  // Converts the timespec structure to time. MacOS X 10.8.3 (and tentatively,
  // earlier versions) will have the |ts|'s tv_nsec component zeroed out,
  // having a 1 second resolution, which agrees with
  // https://developer.apple.com/legacy/library/#technotes/tn/tn1150.html#HFSPlusDates.
  static Time FromTimeSpec(const timespec& ts);
#endif

  // Converts to/from the Javascript convention for times, a number of
  // milliseconds since the epoch:
  // https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Date/getTime.
  static Time FromJsTime(double ms_since_epoch);
  double ToJsTime() const;

  // Converts to Java convention for times, a number of
  // milliseconds since the epoch.
  int64_t ToJavaTime() const;

#if defined(OS_POSIX)
  static Time FromTimeVal(struct timeval t);
  struct timeval ToTimeVal() const;
#endif

#if defined(OS_MACOSX)
  static Time FromCFAbsoluteTime(CFAbsoluteTime t);
  CFAbsoluteTime ToCFAbsoluteTime() const;
#endif

#if defined(OS_WIN)
  static Time FromFileTime(FILETIME ft);
  FILETIME ToFileTime() const;

  // The minimum time of a low resolution timer.  This is basically a windows
  // constant of ~15.6ms.  While it does vary on some older OS versions, we'll
  // treat it as static across all windows versions.
  static const int kMinLowResolutionThresholdMs = 16;

  // Enable or disable Windows high resolution timer.
  static void EnableHighResolutionTimer(bool enable);

  // Activates or deactivates the high resolution timer based on the |activate|
  // flag.  If the HighResolutionTimer is not Enabled (see
  // EnableHighResolutionTimer), this function will return false.  Otherwise
  // returns true.  Each successful activate call must be paired with a
  // subsequent deactivate call.
  // All callers to activate the high resolution timer must eventually call
  // this function to deactivate the high resolution timer.
  static bool ActivateHighResolutionTimer(bool activate);

  // Returns true if the high resolution timer is both enabled and activated.
  // This is provided for testing only, and is not tracked in a thread-safe
  // way.
  static bool IsHighResolutionTimerInUse();
#endif

  // Converts an exploded structure representing either the local time or UTC
  // into a Time class.
  // TODO(maksims): Get rid of these in favor of the methods below when
  // all the callers stop using these ones.
  static Time FromUTCExploded(const Exploded& exploded) {
    base::Time time;
    ignore_result(FromUTCExploded(exploded, &time));
    return time;
  }
  static Time FromLocalExploded(const Exploded& exploded) {
    base::Time time;
    ignore_result(FromLocalExploded(exploded, &time));
    return time;
  }

  // Converts an exploded structure representing either the local time or UTC
  // into a Time class. Returns false on a failure when, for example, a day of
  // month is set to 31 on a 28-30 day month. Returns Time(0) on overflow.
  static bool FromUTCExploded(const Exploded& exploded,
                              Time* time) WARN_UNUSED_RESULT {
    return FromExploded(false, exploded, time);
  }
  static bool FromLocalExploded(const Exploded& exploded,
                                Time* time) WARN_UNUSED_RESULT {
    return FromExploded(true, exploded, time);
  }

  // Converts a string representation of time to a Time object.
  // An example of a time string which is converted is as below:-
  // "Tue, 15 Nov 1994 12:45:26 GMT". If the timezone is not specified
  // in the input string, FromString assumes local time and FromUTCString
  // assumes UTC. A timezone that cannot be parsed (e.g. "UTC" which is not
  // specified in RFC822) is treated as if the timezone is not specified.
  // TODO(iyengar) Move the FromString/FromTimeT/ToTimeT/FromFileTime to
  // a new time converter class.
  static bool FromString(const char* time_string, Time* parsed_time) {
    return FromStringInternal(time_string, true, parsed_time);
  }
  static bool FromUTCString(const char* time_string, Time* parsed_time) {
    return FromStringInternal(time_string, false, parsed_time);
  }

  // Fills the given exploded structure with either the local time or UTC from
  // this time structure (containing UTC).
  void UTCExplode(Exploded* exploded) const {
    return Explode(false, exploded);
  }
  void LocalExplode(Exploded* exploded) const {
    return Explode(true, exploded);
  }

  // Rounds this time down to the nearest day in local time. It will represent
  // midnight on that day.
  Time LocalMidnight() const;

 private:
  friend class time_internal::TimeBase<Time>;

  explicit Time(int64_t us) : TimeBase(us) {}

  // Explodes the given time to either local time |is_local = true| or UTC
  // |is_local = false|.
  void Explode(bool is_local, Exploded* exploded) const;

  // Unexplodes a given time assuming the source is either local time
  // |is_local = true| or UTC |is_local = false|. Function returns false on
  // failure and sets |time| to Time(0). Otherwise returns true and sets |time|
  // to non-exploded time.
  static bool FromExploded(bool is_local,
                           const Exploded& exploded,
                           Time* time) WARN_UNUSED_RESULT;

  // Converts a string representation of time to a Time object.
  // An example of a time string which is converted is as below:-
  // "Tue, 15 Nov 1994 12:45:26 GMT". If the timezone is not specified
  // in the input string, local time |is_local = true| or
  // UTC |is_local = false| is assumed. A timezone that cannot be parsed
  // (e.g. "UTC" which is not specified in RFC822) is treated as if the
  // timezone is not specified.
  static bool FromStringInternal(const char* time_string,
                                 bool is_local,
                                 Time* parsed_time);

  // Comparison does not consider |day_of_week| when doing the operation.
  static bool ExplodedMostlyEquals(const Exploded& lhs, const Exploded& rhs);
};

// static
constexpr TimeDelta TimeDelta::FromDays(int days) {
  return days == std::numeric_limits<int>::max()
             ? Max()
             : TimeDelta(days * Time::kMicrosecondsPerDay);
}

// static
constexpr TimeDelta TimeDelta::FromHours(int hours) {
  return hours == std::numeric_limits<int>::max()
             ? Max()
             : TimeDelta(hours * Time::kMicrosecondsPerHour);
}

// static
constexpr TimeDelta TimeDelta::FromMinutes(int minutes) {
  return minutes == std::numeric_limits<int>::max()
             ? Max()
             : TimeDelta(minutes * Time::kMicrosecondsPerMinute);
}

// static
constexpr TimeDelta TimeDelta::FromSeconds(int64_t secs) {
  return FromProduct(secs, Time::kMicrosecondsPerSecond);
}

// static
constexpr TimeDelta TimeDelta::FromMilliseconds(int64_t ms) {
  return FromProduct(ms, Time::kMicrosecondsPerMillisecond);
}

// static
constexpr TimeDelta TimeDelta::FromSecondsD(double secs) {
  return FromDouble(secs * Time::kMicrosecondsPerSecond);
}

// static
constexpr TimeDelta TimeDelta::FromMillisecondsD(double ms) {
  return FromDouble(ms * Time::kMicrosecondsPerMillisecond);
}

// static
constexpr TimeDelta TimeDelta::FromMicroseconds(int64_t us) {
  return TimeDelta(us);
}

// static
constexpr TimeDelta TimeDelta::FromDouble(double value) {
  // TODO(crbug.com/612601): Use saturated_cast<int64_t>(value) once we sort out
  // the Min() behavior.
  return value > std::numeric_limits<int64_t>::max()
             ? Max()
             : value < -std::numeric_limits<int64_t>::max()
                   ? -Max()
                   : TimeDelta(static_cast<int64_t>(value));
}

// static
constexpr TimeDelta TimeDelta::FromProduct(int64_t value,
                                           int64_t positive_value) {
  return (
#if !defined(_PREFAST_) || !defined(OS_WIN)
          // Avoid internal compiler errors in /analyze builds with VS 2015
          // update 3.
          // https://connect.microsoft.com/VisualStudio/feedback/details/2870865
          static_cast<void>(DCHECK(positive_value > 0)),
#endif
          value > std::numeric_limits<int64_t>::max() / positive_value
              ? Max()
              : value < -std::numeric_limits<int64_t>::max() / positive_value
                    ? -Max()
                    : TimeDelta(value * positive_value));
}

// For logging use only.
BASE_EXPORT std::ostream& operator<<(std::ostream& os, Time time);

// TimeTicks ------------------------------------------------------------------

// Represents monotonically non-decreasing clock time.
class BASE_EXPORT TimeTicks : public time_internal::TimeBase<TimeTicks> {
 public:
  // The underlying clock used to generate new TimeTicks.
  enum class Clock {
    LINUX_CLOCK_MONOTONIC,
    IOS_CF_ABSOLUTE_TIME_MINUS_KERN_BOOTTIME,
    MAC_MACH_ABSOLUTE_TIME,
    WIN_QPC,
    WIN_ROLLOVER_PROTECTED_TIME_GET_TIME
  };

  TimeTicks() : TimeBase(0) {
  }

  // Platform-dependent tick count representing "right now." When
  // IsHighResolution() returns false, the resolution of the clock could be
  // as coarse as ~15.6ms. Otherwise, the resolution should be no worse than one
  // microsecond.
  static TimeTicks Now();

  // Returns true if the high resolution clock is working on this system and
  // Now() will return high resolution values. Note that, on systems where the
  // high resolution clock works but is deemed inefficient, the low resolution
  // clock will be used instead.
  static bool IsHighResolution();

  // Returns true if TimeTicks is consistent across processes, meaning that
  // timestamps taken on different processes can be safely compared with one
  // another. (Note that, even on platforms where this returns true, time values
  // from different threads that are within one tick of each other must be
  // considered to have an ambiguous ordering.)
  static bool IsConsistentAcrossProcesses();

#if defined(OS_WIN)
  // Translates an absolute QPC timestamp into a TimeTicks value. The returned
  // value has the same origin as Now(). Do NOT attempt to use this if
  // IsHighResolution() returns false.
  static TimeTicks FromQPCValue(LONGLONG qpc_value);
#endif

#if defined(OS_MACOSX) && !defined(OS_IOS)
  static TimeTicks FromMachAbsoluteTime(uint64_t mach_absolute_time);
#endif  // defined(OS_MACOSX) && !defined(OS_IOS)

  // Get an estimate of the TimeTick value at the time of the UnixEpoch. Because
  // Time and TimeTicks respond differently to user-set time and NTP
  // adjustments, this number is only an estimate. Nevertheless, this can be
  // useful when you need to relate the value of TimeTicks to a real time and
  // date. Note: Upon first invocation, this function takes a snapshot of the
  // realtime clock to establish a reference point.  This function will return
  // the same value for the duration of the application, but will be different
  // in future application runs.
  static TimeTicks UnixEpoch();

  // Returns |this| snapped to the next tick, given a |tick_phase| and
  // repeating |tick_interval| in both directions. |this| may be before,
  // after, or equal to the |tick_phase|.
  TimeTicks SnappedToNextTick(TimeTicks tick_phase,
                              TimeDelta tick_interval) const;

  // Returns an enum indicating the underlying clock being used to generate
  // TimeTicks timestamps. This function should only be used for debugging and
  // logging purposes.
  static Clock GetClock();

#if defined(OS_WIN)
 protected:
  typedef DWORD (*TickFunctionType)(void);
  static TickFunctionType SetMockTickFunction(TickFunctionType ticker);
#endif

 private:
  friend class time_internal::TimeBase<TimeTicks>;

  // Please use Now() to create a new object. This is for internal use
  // and testing.
  explicit TimeTicks(int64_t us) : TimeBase(us) {}
};

// For logging use only.
BASE_EXPORT std::ostream& operator<<(std::ostream& os, TimeTicks time_ticks);

// ThreadTicks ----------------------------------------------------------------

// Represents a clock, specific to a particular thread, than runs only while the
// thread is running.
class BASE_EXPORT ThreadTicks : public time_internal::TimeBase<ThreadTicks> {
 public:
  ThreadTicks() : TimeBase(0) {
  }

  // Returns true if ThreadTicks::Now() is supported on this system.
  static bool IsSupported() {
#if (defined(_POSIX_THREAD_CPUTIME) && (_POSIX_THREAD_CPUTIME >= 0)) || \
    (defined(OS_MACOSX) && !defined(OS_IOS)) || defined(OS_ANDROID)
    return true;
#elif defined(OS_WIN)
    return IsSupportedWin();
#else
    return false;
#endif
  }

  // Waits until the initialization is completed. Needs to be guarded with a
  // call to IsSupported().
  static void WaitUntilInitialized() {
#if defined(OS_WIN)
    WaitUntilInitializedWin();
#endif
  }

  // Returns thread-specific CPU-time on systems that support this feature.
  // Needs to be guarded with a call to IsSupported(). Use this timer
  // to (approximately) measure how much time the calling thread spent doing
  // actual work vs. being de-scheduled. May return bogus results if the thread
  // migrates to another CPU between two calls. Returns an empty ThreadTicks
  // object until the initialization is completed. If a clock reading is
  // absolutely needed, call WaitUntilInitialized() before this method.
  static ThreadTicks Now();

#if defined(OS_WIN)
  // Similar to Now() above except this returns thread-specific CPU time for an
  // arbitrary thread. All comments for Now() method above apply apply to this
  // method as well.
  static ThreadTicks GetForThread(const PlatformThreadHandle& thread_handle);
#endif

 private:
  friend class time_internal::TimeBase<ThreadTicks>;

  // Please use Now() or GetForThread() to create a new object. This is for
  // internal use and testing.
  explicit ThreadTicks(int64_t us) : TimeBase(us) {}

#if defined(OS_WIN)
  FRIEND_TEST_ALL_PREFIXES(TimeTicks, TSCTicksPerSecond);

  // Returns the frequency of the TSC in ticks per second, or 0 if it hasn't
  // been measured yet. Needs to be guarded with a call to IsSupported().
  // This method is declared here rather than in the anonymous namespace to
  // allow testing.
  static double TSCTicksPerSecond();

  static bool IsSupportedWin();
  static void WaitUntilInitializedWin();
#endif
};

// For logging use only.
BASE_EXPORT std::ostream& operator<<(std::ostream& os, ThreadTicks time_ticks);

}  // namespace base

#endif  // BASE_TIME_TIME_H_
