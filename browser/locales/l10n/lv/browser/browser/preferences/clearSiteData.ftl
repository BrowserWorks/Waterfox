# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Notīrīt datus
    .style = width: 35em

clear-site-data-description = { -brand-short-name } saglabāto sīkdatņu dzēšana var pārtraukt jūsu autorizācijas sesijas lapās un aizvākt bezsaistes datus. Kešatmiņas dzēšana autorizāciju lapās neietekmēs.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Sīkdatnes un lapas dati ({ $amount } { $unit })
    .accesskey = S

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Sīkdatnes un lapu dati
    .accesskey = S

clear-site-data-cookies-info = Ja notīrīsiet, jūsu autorizācijas sesijas lapās ar pazust

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Kešatmiņa ({ $amount } { $unit })
    .accesskey = T

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Saglabātais tīmekļa saturs
    .accesskey = T

clear-site-data-cache-info = Lapām būs vēlreiz jāielādē attēli un dati

clear-site-data-cancel =
    .label = Atcelt
    .accesskey = C

clear-site-data-clear =
    .label = Notīrīt
    .accesskey = t
