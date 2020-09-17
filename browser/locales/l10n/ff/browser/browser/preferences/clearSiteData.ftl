# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Momtu keɓe
    .style = width: 35em

clear-site-data-description = Momtude kuukiije ɗee fof kañum e keɓe ɗe { -brand-short-name } moofti e lowre ina waawi seŋtudema e lowre geese tee momta loowdi geese ɗe ceŋaaki. Momtude keɓe mogginiiɗe battinoytaa ceŋi maa.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Kuukiije kam e Keɓe Lowre ({ $amount } { $unit })
    .accesskey = S

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Kuukiije e Keɓe Lowre
    .accesskey = S

clear-site-data-cookies-info = Aɗa waawi seŋteede e lowe geese so momtaama

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Loowdi Geese Mogginaandi ({ $amount } { $unit })
    .accesskey = W

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Loowdi Geese Mogginaandi
    .accesskey = W

clear-site-data-cache-info = Maa naamnoyo lowe geese ngam loowtude nate e keɓe

clear-site-data-cancel =
    .label = Haaytu
    .accesskey = C

clear-site-data-clear =
    .label = Momtu
    .accesskey = l
