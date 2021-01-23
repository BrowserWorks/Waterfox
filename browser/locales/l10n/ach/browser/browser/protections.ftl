# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> lalub kor ma ki gengo nicake { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] <b>{ $count }</b> lulub kor ma ki gengo nicake { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Lulub kor ma { -brand-short-name } ogengo i cabit man

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Tin
  
lockwise-title = Pe wii wil mung me donyo doki matwal
lockwise-header-content = { -lockwise-brand-name } gwoko maber mung me donyo ni i layeny mamegi.
lockwise-header-content-logged-in = Gwok ka i rib maber mung me donyo mamegi i nyonyo ni weng.

monitor-link = Kit ma tiyo kwede

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

