# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Andmete kustutamine
    .style = width: 35em

clear-site-data-description = Kustutades kõik { -brand-short-name }i poolt salvestatud küpsised ja saitide andmed, võib tulemuseks olla see, et sind logitakse saitidest välja ja võrguta režiimis kasutamiseks mõeldud andmed eemaldatakse. Vahemälus olevate andmete kustutamine ei mõjuta sinu kasutajakontosid.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Küpsised ja saidi andmed ({ $amount } { $unit })
    .accesskey = K

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Küpsised ja saidi andmed
    .accesskey = K

clear-site-data-cookies-info = Kustutamine võib põhjustada saitidest väljalogimist

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Veebisisu vahemälu ({ $amount } { $unit })
    .accesskey = V

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Veebisisu vahemälu
    .accesskey = V

clear-site-data-cache-info = Kustutamisel tuleb veebilehtede pildid ja andmed uuesti laadida

clear-site-data-cancel =
    .label = Loobu
    .accesskey = L

clear-site-data-clear =
    .label = Kustuta
    .accesskey = u
