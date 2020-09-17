# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Մաքրել տվյալները
    .style = width: 35em

clear-site-data-description = Բոլոր cookie-երի և { -brand-short-name }-ի կողմից պահված տվյալների մաքրումը կարող է ձեզ դուրս գրել կայքերից և հեռացնել անցանց վեբ բովանդակությունը: Դա չի վերաբերի ձեր մուտքագրումներին:

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Cookie-ներ և կայքի տվյալներ ({ $amount } { $unit })
    .accesskey = S

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Cookie-ներ և կայքի տվյալներ
    .accesskey = S

clear-site-data-cookies-info = Մաքրելու դեպքում կարող եք դուրս գրվել կայքերից

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Շտեմված վեբ բովանդակություն ({ $amount } { $unit })
    .accesskey = W

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Շտեմված վեբ բովանդակություն
    .accesskey = W

clear-site-data-cache-info = Կպահանջի կայքերից կրկին բեռնել պատկերները և տվյալները

clear-site-data-cancel =
    .label = Չեղարկել
    .accesskey = C

clear-site-data-clear =
    .label = Մաքրել
    .accesskey = l
