# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } daaƴii{ $count } dewindotooɗo e yontere yawtunde ndee
       *[other] { -brand-short-name } daaƴii { $count } rewindotooɓe e yontere yawtunde ndee
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] { $count } dewindotooɗo daaƴaama gila { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] { $count }rewindotooɓe ndaaƴaama gila { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } ina jokki  daaƴde rewindotooɓe e kenorɗe cuuriiɗe, kono mooftataa ɓarakke ko daaƴaa koo.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Rewindotooɓe { -brand-short-name } ndaaƴaama ndee yontere

protection-report-manage-protections = Toppito Teelte

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Hannde

tracker-tab-title = Dewindagol Loowdi

protections-close-button2 =
    .aria-label = Uddu
    .title = Uddu
  
mobile-app-title = Daaƴ rewindotooɓe ɓaŋŋine e masiŋon keewkon

lockwise-title = Hoto majjin finnde maa kadi abadaa
lockwise-mobile-app-title = Nawor ceŋorɗe e pinle maa kala nokku.
lockwise-no-logins-card-content = Huutoro pinle danndaaɗe nder { -brand-short-name } e kaɓirgol baawngol won'de fof.
lockwise-app-links = { -lockwise-brand-name } ngam a data-l10n-name="lockwise-android-inline-link">Android</a> e  <a data-l10n-name="lockwise-ios-inline-link">iOS</a>

monitor-title = Yuurnito ciigol keɓe
monitor-link = Hol no gollortoo
monitor-header-content-no-account = Ƴeewto { -monitor-brand-name }ngam ƴeewde so tawii a jeyanooma e ciigol keɓe ganndangol, etee heɓ jeertine baɗte ciigol keɓe kesol.
monitor-header-content-signed-in = { -monitor-brand-name } ina reentin maa so kabaruuji maa peeñii e ciigol keɓe kesol ganndangol.
auto-scan = Niiwtaama ɗoon e ɗoon hannde

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

