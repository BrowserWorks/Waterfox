# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Sfeḍ isefka
    .style = width: 35em

clear-site-data-description = Asfaḍn  inagan n tuqna meṛṛa akked isefka isekles { -brand-short-name } izmer ad ak-id-isuffeγ seg ismal web, ad ak-ikkes aqbur n war tuqna. Asfaḍ n isefka n tkatut tuffirt ur igellu ara s inekcam-inek.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Inagan n tuqna akked isefka n usmel ({ $amount } { $unit })
    .accesskey = S

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Inagan n tuqna akked isefka n usmel
    .accesskey = S

clear-site-data-cookies-info = Izmer ad tefγeḍ seg ismal web ma tsefḍeḍ

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Agbur web uffir ({ $amount } { $unit })
    .accesskey = W

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Agbur web uffir
    .accesskey = W

clear-site-data-cache-info = Ad yisru ismal web akken ad id-isali tugniwin akked isefka

clear-site-data-cancel =
    .label = Sefsex
    .accesskey = C

clear-site-data-clear =
    .label = Sfeḍ
    .accesskey = l
