# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Fjern data
    .style = width: 35em

clear-site-data-description = Om du fjernar alle infokapslar og nettstad-data som er lagra av { -brand-short-name } vil kunne logge deg ut av nettstadar og fjerne fråkopla nettinnhald. Fjerning av snøgglager- (cache-) data vil ikkje påverke innloggingane dine.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Infokapslar og nettsidedata ({ $amount } { $unit })
    .accesskey = I

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Infokapslar og nettsidedata
    .accesskey = I

clear-site-data-cookies-info = Du kan bli logga ut av nettsider du har fjerna data frå

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Søgglagra (cacha) nettinnhald ({ $amount } { $unit })
    .accesskey = S

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Snøgglagra (cacha) nettinnhald
    .accesskey = S

clear-site-data-cache-info = Krev at nettsider lastar bilde og data på nytt

clear-site-data-dialog =
    .buttonlabelaccept = Fjern
    .buttonaccesskeyaccept = F
