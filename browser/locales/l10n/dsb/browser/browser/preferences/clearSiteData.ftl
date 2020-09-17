# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Daty lašowaś
    .style = width: 35em

clear-site-data-description = Pśez lašowanje wšych cookiejow a datow sedła pśez { -brand-short-name } móžo k wótzjawjanjeju z websedłow a wótwńoźowanjeju webwopśimjesa offline dojś. Lašowanje datow z cacha waše pśizjewjanja njewobwliwujo.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Cookieje a daty sedła ({ $amount } { $unit })
    .accesskey = C

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Cookieje a sedłowe daty
    .accesskey = C

clear-site-data-cookies-info = Pśez lašowanje móžo k wašomu wótzjawjanjeju z websedłow dójś

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Webwopśimjeśe w cachu ({ $amount } { $unit })
    .accesskey = W

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Webwopśimjeśe w cachu
    .accesskey = W

clear-site-data-cache-info = Pomina se, až websedła wobraze a daty znowego zacytaju

clear-site-data-cancel =
    .label = Pśetergnuś
    .accesskey = P

clear-site-data-clear =
    .label = Wuprozniś
    .accesskey = u
