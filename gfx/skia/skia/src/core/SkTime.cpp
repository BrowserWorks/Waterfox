/*
 * Copyright 2015 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "SkLeanWindows.h"
#include "SkString.h"
#include "SkTime.h"
#include "SkTypes.h"

void SkTime::DateTime::toISO8601(SkString* dst) const {
    if (dst) {
        int timeZoneMinutes = SkToInt(fTimeZoneMinutes);
        char timezoneSign = timeZoneMinutes >= 0 ? '+' : '-';
        int timeZoneHours = SkTAbs(timeZoneMinutes) / 60;
        timeZoneMinutes = SkTAbs(timeZoneMinutes) % 60;
        dst->printf("%04u-%02u-%02uT%02u:%02u:%02u%c%02d:%02d",
                    static_cast<unsigned>(fYear), static_cast<unsigned>(fMonth),
                    static_cast<unsigned>(fDay), static_cast<unsigned>(fHour),
                    static_cast<unsigned>(fMinute),
                    static_cast<unsigned>(fSecond), timezoneSign, timeZoneHours,
                    timeZoneMinutes);
    }
}

#ifdef SK_BUILD_FOR_WIN32

void SkTime::GetDateTime(DateTime* dt) {
    if (dt) {
        SYSTEMTIME st;
        GetSystemTime(&st);
        dt->fTimeZoneMinutes = 0;
        dt->fYear       = st.wYear;
        dt->fMonth      = SkToU8(st.wMonth);
        dt->fDayOfWeek  = SkToU8(st.wDayOfWeek);
        dt->fDay        = SkToU8(st.wDay);
        dt->fHour       = SkToU8(st.wHour);
        dt->fMinute     = SkToU8(st.wMinute);
        dt->fSecond     = SkToU8(st.wSecond);
    }
}

#else // SK_BUILD_FOR_WIN32

#include <time.h>
void SkTime::GetDateTime(DateTime* dt) {
    if (dt) {
        time_t m_time;
        time(&m_time);
        struct tm tstruct;
        gmtime_r(&m_time, &tstruct);
        dt->fTimeZoneMinutes = 0;
        dt->fYear       = tstruct.tm_year + 1900;
        dt->fMonth      = SkToU8(tstruct.tm_mon + 1);
        dt->fDayOfWeek  = SkToU8(tstruct.tm_wday);
        dt->fDay        = SkToU8(tstruct.tm_mday);
        dt->fHour       = SkToU8(tstruct.tm_hour);
        dt->fMinute     = SkToU8(tstruct.tm_min);
        dt->fSecond     = SkToU8(tstruct.tm_sec);
    }
}
#endif // SK_BUILD_FOR_WIN32

#if defined(SK_BUILD_FOR_UNIX) || defined(SK_BUILD_FOR_ANDROID)
#include <time.h>
double SkTime::GetNSecs() {
    struct timespec ts;
    if (clock_gettime(CLOCK_MONOTONIC, &ts) != 0) {
      return 0.0;
    }
    return ts.tv_sec * 1e9 + ts.tv_nsec;
}
#else
#include <chrono>
double SkTime::GetNSecs() {
    auto now = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::nano> ns = now.time_since_epoch();
    return ns.count();
}
#endif
