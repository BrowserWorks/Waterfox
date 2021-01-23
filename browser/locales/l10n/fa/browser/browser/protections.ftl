# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } { $count } ردیاب را در طی هفته گذشته مسدود کرد
       *[other] { -brand-short-name } { $count } ردیاب را در طی هفته گذشته مسدود کرد
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> ردیاب از { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") } مسدود شده است
       *[other] <b>{ $count }</b> ردیاب از { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") } مسدود شده‌اند.
    }

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = امروز

social-tab-title = ردیاب‌های شبکه‌های اجتماعی

tracker-tab-title = محتوای ردیابی کننده

cryptominer-tab-title = استخراج کننده‌های رمزارزها
  
lockwise-title = هرگز گذرواژه را فراموش نکن
lockwise-header-content = { -lockwise-brand-name } گذرواژه‌های شما را به صورت امن در مرورگر ذخیره می‌کند.
lockwise-header-content-logged-in = ذخیره امن گذرواژه‌ها و همگام‌سازی با تمام دستگاه های شما.

turn-on-sync = روشن کردن { -sync-brand-short-name }…
    .title = به تنظیمات همگام‌سازی برو

monitor-title = مواضب نشت اطلاعات باشید
monitor-link = چگونه کار می‌کند

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

