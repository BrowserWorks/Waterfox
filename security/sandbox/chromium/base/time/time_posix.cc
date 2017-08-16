// Copyright (c) 2012 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "base/time/time.h"

#include <stdint.h>
#include <sys/time.h>
#include <time.h>
#if defined(OS_ANDROID) && !defined(__LP64__)
#include <time64.h>
#endif
#include <unistd.h>

#include <limits>
#include <ostream>

#include "base/logging.h"
#include "build/build_config.h"

#if defined(OS_ANDROID)
#include "base/os_compat_android.h"
#elif defined(OS_NACL)
#include "base/os_compat_nacl.h"
#endif

#if !defined(OS_MACOSX)
#include "base/lazy_instance.h"
#include "base/synchronization/lock.h"
#endif

namespace {

#if !defined(OS_MACOSX)
// This prevents a crash on traversing the environment global and looking up
// the 'TZ' variable in libc. See: crbug.com/390567.
base::LazyInstance<base::Lock>::Leaky
    g_sys_time_to_time_struct_lock = LAZY_INSTANCE_INITIALIZER;

// Define a system-specific SysTime that wraps either to a time_t or
// a time64_t depending on the host system, and associated convertion.
// See crbug.com/162007
#if defined(OS_ANDROID) && !defined(__LP64__)
typedef time64_t SysTime;

SysTime SysTimeFromTimeStruct(struct tm* timestruct, bool is_local) {
  base::AutoLock locked(g_sys_time_to_time_struct_lock.Get());
  if (is_local)
    return mktime64(timestruct);
  else
    return timegm64(timestruct);
}

void SysTimeToTimeStruct(SysTime t, struct tm* timestruct, bool is_local) {
  base::AutoLock locked(g_sys_time_to_time_struct_lock.Get());
  if (is_local)
    localtime64_r(&t, timestruct);
  else
    gmtime64_r(&t, timestruct);
}

#else  // OS_ANDROID && !__LP64__
typedef time_t SysTime;

SysTime SysTimeFromTimeStruct(struct tm* timestruct, bool is_local) {
  base::AutoLock locked(g_sys_time_to_time_struct_lock.Get());
  if (is_local)
    return mktime(timestruct);
  else
    return timegm(timestruct);
}

void SysTimeToTimeStruct(SysTime t, struct tm* timestruct, bool is_local) {
  base::AutoLock locked(g_sys_time_to_time_struct_lock.Get());
  if (is_local)
    localtime_r(&t, timestruct);
  else
    gmtime_r(&t, timestruct);
}
#endif  // OS_ANDROID

int64_t ConvertTimespecToMicros(const struct timespec& ts) {
  // On 32-bit systems, the calculation cannot overflow int64_t.
  // 2**32 * 1000000 + 2**64 / 1000 < 2**63
  if (sizeof(ts.tv_sec) <= 4 && sizeof(ts.tv_nsec) <= 8) {
    int64_t result = ts.tv_sec;
    result *= base::Time::kMicrosecondsPerSecond;
    result += (ts.tv_nsec / base::Time::kNanosecondsPerMicrosecond);
    return result;
  } else {
    base::CheckedNumeric<int64_t> result(ts.tv_sec);
    result *= base::Time::kMicrosecondsPerSecond;
    result += (ts.tv_nsec / base::Time::kNanosecondsPerMicrosecond);
    return result.ValueOrDie();
  }
}

// Helper function to get results from clock_gettime() and convert to a
// microsecond timebase. Minimum requirement is MONOTONIC_CLOCK to be supported
// on the system. FreeBSD 6 has CLOCK_MONOTONIC but defines
// _POSIX_MONOTONIC_CLOCK to -1.
#if (defined(OS_POSIX) &&                                               \
     defined(_POSIX_MONOTONIC_CLOCK) && _POSIX_MONOTONIC_CLOCK >= 0) || \
    defined(OS_BSD) || defined(OS_ANDROID)
int64_t ClockNow(clockid_t clk_id) {
  struct timespec ts;
  if (clock_gettime(clk_id, &ts) != 0) {
    NOTREACHED() << "clock_gettime(" << clk_id << ") failed.";
    return 0;
  }
  return ConvertTimespecToMicros(ts);
}
#else  // _POSIX_MONOTONIC_CLOCK
#error No usable tick clock function on this platform.
#endif  // _POSIX_MONOTONIC_CLOCK
#endif  // !defined(OS_MACOSX)

}  // namespace

namespace base {

// static
TimeDelta TimeDelta::FromTimeSpec(const timespec& ts) {
  return TimeDelta(ts.tv_sec * Time::kMicrosecondsPerSecond +
                   ts.tv_nsec / Time::kNanosecondsPerMicrosecond);
}

struct timespec TimeDelta::ToTimeSpec() const {
  int64_t microseconds = InMicroseconds();
  time_t seconds = 0;
  if (microseconds >= Time::kMicrosecondsPerSecond) {
    seconds = InSeconds();
    microseconds -= seconds * Time::kMicrosecondsPerSecond;
  }
  struct timespec result =
      {seconds,
       static_cast<long>(microseconds * Time::kNanosecondsPerMicrosecond)};
  return result;
}

#if !defined(OS_MACOSX)
// The Time routines in this file use standard POSIX routines, or almost-
// standard routines in the case of timegm.  We need to use a Mach-specific
// function for TimeTicks::Now() on Mac OS X.

// Time -----------------------------------------------------------------------

// Windows uses a Gregorian epoch of 1601.  We need to match this internally
// so that our time representations match across all platforms.  See bug 14734.
//   irb(main):010:0> Time.at(0).getutc()
//   => Thu Jan 01 00:00:00 UTC 1970
//   irb(main):011:0> Time.at(-11644473600).getutc()
//   => Mon Jan 01 00:00:00 UTC 1601
static const int64_t kWindowsEpochDeltaSeconds = INT64_C(11644473600);

// static
const int64_t Time::kWindowsEpochDeltaMicroseconds =
    kWindowsEpochDeltaSeconds * Time::kMicrosecondsPerSecond;

// Some functions in time.cc use time_t directly, so we provide an offset
// to convert from time_t (Unix epoch) and internal (Windows epoch).
// static
const int64_t Time::kTimeTToMicrosecondsOffset = kWindowsEpochDeltaMicroseconds;

// static
Time Time::Now() {
  struct timeval tv;
  struct timezone tz = { 0, 0 };  // UTC
  if (gettimeofday(&tv, &tz) != 0) {
    DCHECK(0) << "Could not determine time of day";
    PLOG(ERROR) << "Call to gettimeofday failed.";
    // Return null instead of uninitialized |tv| value, which contains random
    // garbage data. This may result in the crash seen in crbug.com/147570.
    return Time();
  }
  // Combine seconds and microseconds in a 64-bit field containing microseconds
  // since the epoch.  That's enough for nearly 600 centuries.  Adjust from
  // Unix (1970) to Windows (1601) epoch.
  return Time((tv.tv_sec * kMicrosecondsPerSecond + tv.tv_usec) +
      kWindowsEpochDeltaMicroseconds);
}

// static
Time Time::NowFromSystemTime() {
  // Just use Now() because Now() returns the system time.
  return Now();
}

void Time::Explode(bool is_local, Exploded* exploded) const {
  // Time stores times with microsecond resolution, but Exploded only carries
  // millisecond resolution, so begin by being lossy.  Adjust from Windows
  // epoch (1601) to Unix epoch (1970);
  int64_t microseconds = us_ - kWindowsEpochDeltaMicroseconds;
  // The following values are all rounded towards -infinity.
  int64_t milliseconds;  // Milliseconds since epoch.
  SysTime seconds;  // Seconds since epoch.
  int millisecond;  // Exploded millisecond value (0-999).
  if (microseconds >= 0) {
    // Rounding towards -infinity <=> rounding towards 0, in this case.
    milliseconds = microseconds / kMicrosecondsPerMillisecond;
    seconds = milliseconds / kMillisecondsPerSecond;
    millisecond = milliseconds % kMillisecondsPerSecond;
  } else {
    // Round these *down* (towards -infinity).
    milliseconds = (microseconds - kMicrosecondsPerMillisecond + 1) /
                   kMicrosecondsPerMillisecond;
    seconds = (milliseconds - kMillisecondsPerSecond + 1) /
              kMillisecondsPerSecond;
    // Make this nonnegative (and between 0 and 999 inclusive).
    millisecond = milliseconds % kMillisecondsPerSecond;
    if (millisecond < 0)
      millisecond += kMillisecondsPerSecond;
  }

  struct tm timestruct;
  SysTimeToTimeStruct(seconds, &timestruct, is_local);

  exploded->year         = timestruct.tm_year + 1900;
  exploded->month        = timestruct.tm_mon + 1;
  exploded->day_of_week  = timestruct.tm_wday;
  exploded->day_of_month = timestruct.tm_mday;
  exploded->hour         = timestruct.tm_hour;
  exploded->minute       = timestruct.tm_min;
  exploded->second       = timestruct.tm_sec;
  exploded->millisecond  = millisecond;
}

// static
bool Time::FromExploded(bool is_local, const Exploded& exploded, Time* time) {
  struct tm timestruct;
  timestruct.tm_sec    = exploded.second;
  timestruct.tm_min    = exploded.minute;
  timestruct.tm_hour   = exploded.hour;
  timestruct.tm_mday   = exploded.day_of_month;
  timestruct.tm_mon    = exploded.month - 1;
  timestruct.tm_year   = exploded.year - 1900;
  timestruct.tm_wday   = exploded.day_of_week;  // mktime/timegm ignore this
  timestruct.tm_yday   = 0;     // mktime/timegm ignore this
  timestruct.tm_isdst  = -1;    // attempt to figure it out
#if !defined(OS_NACL) && !defined(OS_SOLARIS)
  timestruct.tm_gmtoff = 0;     // not a POSIX field, so mktime/timegm ignore
  timestruct.tm_zone   = NULL;  // not a POSIX field, so mktime/timegm ignore
#endif

  SysTime seconds;

  // Certain exploded dates do not really exist due to daylight saving times,
  // and this causes mktime() to return implementation-defined values when
  // tm_isdst is set to -1. On Android, the function will return -1, while the
  // C libraries of other platforms typically return a liberally-chosen value.
  // Handling this requires the special code below.

  // SysTimeFromTimeStruct() modifies the input structure, save current value.
  struct tm timestruct0 = timestruct;

  seconds = SysTimeFromTimeStruct(&timestruct, is_local);
  if (seconds == -1) {
    // Get the time values with tm_isdst == 0 and 1, then select the closest one
    // to UTC 00:00:00 that isn't -1.
    timestruct = timestruct0;
    timestruct.tm_isdst = 0;
    int64_t seconds_isdst0 = SysTimeFromTimeStruct(&timestruct, is_local);

    timestruct = timestruct0;
    timestruct.tm_isdst = 1;
    int64_t seconds_isdst1 = SysTimeFromTimeStruct(&timestruct, is_local);

    // seconds_isdst0 or seconds_isdst1 can be -1 for some timezones.
    // E.g. "CLST" (Chile Summer Time) returns -1 for 'tm_isdt == 1'.
    if (seconds_isdst0 < 0)
      seconds = seconds_isdst1;
    else if (seconds_isdst1 < 0)
      seconds = seconds_isdst0;
    else
      seconds = std::min(seconds_isdst0, seconds_isdst1);
  }

  // Handle overflow.  Clamping the range to what mktime and timegm might
  // return is the best that can be done here.  It's not ideal, but it's better
  // than failing here or ignoring the overflow case and treating each time
  // overflow as one second prior to the epoch.
  int64_t milliseconds = 0;
  if (seconds == -1 &&
      (exploded.year < 1969 || exploded.year > 1970)) {
    // If exploded.year is 1969 or 1970, take -1 as correct, with the
    // time indicating 1 second prior to the epoch.  (1970 is allowed to handle
    // time zone and DST offsets.)  Otherwise, return the most future or past
    // time representable.  Assumes the time_t epoch is 1970-01-01 00:00:00 UTC.
    //
    // The minimum and maximum representible times that mktime and timegm could
    // return are used here instead of values outside that range to allow for
    // proper round-tripping between exploded and counter-type time
    // representations in the presence of possible truncation to time_t by
    // division and use with other functions that accept time_t.
    //
    // When representing the most distant time in the future, add in an extra
    // 999ms to avoid the time being less than any other possible value that
    // this function can return.

    // On Android, SysTime is int64_t, special care must be taken to avoid
    // overflows.
    const int64_t min_seconds = (sizeof(SysTime) < sizeof(int64_t))
                                    ? std::numeric_limits<SysTime>::min()
                                    : std::numeric_limits<int32_t>::min();
    const int64_t max_seconds = (sizeof(SysTime) < sizeof(int64_t))
                                    ? std::numeric_limits<SysTime>::max()
                                    : std::numeric_limits<int32_t>::max();
    if (exploded.year < 1969) {
      milliseconds = min_seconds * kMillisecondsPerSecond;
    } else {
      milliseconds = max_seconds * kMillisecondsPerSecond;
      milliseconds += (kMillisecondsPerSecond - 1);
    }
  } else {
    base::CheckedNumeric<int64_t> checked_millis = seconds;
    checked_millis *= kMillisecondsPerSecond;
    checked_millis += exploded.millisecond;
    if (!checked_millis.IsValid()) {
      *time = base::Time(0);
      return false;
    }
    milliseconds = checked_millis.ValueOrDie();
  }

  // Adjust from Unix (1970) to Windows (1601) epoch avoiding overflows.
  base::CheckedNumeric<int64_t> checked_microseconds_win_epoch = milliseconds;
  checked_microseconds_win_epoch *= kMicrosecondsPerMillisecond;
  checked_microseconds_win_epoch += kWindowsEpochDeltaMicroseconds;
  if (!checked_microseconds_win_epoch.IsValid()) {
    *time = base::Time(0);
    return false;
  }
  base::Time converted_time(checked_microseconds_win_epoch.ValueOrDie());

  // If |exploded.day_of_month| is set to 31 on a 28-30 day month, it will
  // return the first day of the next month. Thus round-trip the time and
  // compare the initial |exploded| with |utc_to_exploded| time.
  base::Time::Exploded to_exploded;
  if (!is_local)
    converted_time.UTCExplode(&to_exploded);
  else
    converted_time.LocalExplode(&to_exploded);

  if (ExplodedMostlyEquals(to_exploded, exploded)) {
    *time = converted_time;
    return true;
  }

  *time = Time(0);
  return false;
}

// TimeTicks ------------------------------------------------------------------
// static
TimeTicks TimeTicks::Now() {
  return TimeTicks(ClockNow(CLOCK_MONOTONIC));
}

// static
TimeTicks::Clock TimeTicks::GetClock() {
  return Clock::LINUX_CLOCK_MONOTONIC;
}

// static
bool TimeTicks::IsHighResolution() {
  return true;
}

// static
bool TimeTicks::IsConsistentAcrossProcesses() {
  return true;
}

// static
ThreadTicks ThreadTicks::Now() {
#if (defined(_POSIX_THREAD_CPUTIME) && (_POSIX_THREAD_CPUTIME >= 0)) || \
    defined(OS_ANDROID)
  return ThreadTicks(ClockNow(CLOCK_THREAD_CPUTIME_ID));
#else
  NOTREACHED();
  return ThreadTicks();
#endif
}

#endif  // !OS_MACOSX

// static
Time Time::FromTimeVal(struct timeval t) {
  DCHECK_LT(t.tv_usec, static_cast<int>(Time::kMicrosecondsPerSecond));
  DCHECK_GE(t.tv_usec, 0);
  if (t.tv_usec == 0 && t.tv_sec == 0)
    return Time();
  if (t.tv_usec == static_cast<suseconds_t>(Time::kMicrosecondsPerSecond) - 1 &&
      t.tv_sec == std::numeric_limits<time_t>::max())
    return Max();
  return Time((static_cast<int64_t>(t.tv_sec) * Time::kMicrosecondsPerSecond) +
              t.tv_usec + kTimeTToMicrosecondsOffset);
}

struct timeval Time::ToTimeVal() const {
  struct timeval result;
  if (is_null()) {
    result.tv_sec = 0;
    result.tv_usec = 0;
    return result;
  }
  if (is_max()) {
    result.tv_sec = std::numeric_limits<time_t>::max();
    result.tv_usec = static_cast<suseconds_t>(Time::kMicrosecondsPerSecond) - 1;
    return result;
  }
  int64_t us = us_ - kTimeTToMicrosecondsOffset;
  result.tv_sec = us / Time::kMicrosecondsPerSecond;
  result.tv_usec = us % Time::kMicrosecondsPerSecond;
  return result;
}

}  // namespace base
