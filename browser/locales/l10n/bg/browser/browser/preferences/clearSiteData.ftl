# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Изчистване на данни
    .style = width: 35em

clear-site-data-description = Изчиствайки всички бисквитки и данни на страници запазени от { -brand-short-name } може да бъдете отписани от някои сайтове, както и ще бъде премахнато съдържанието за работа извън мрежа. Изчистването на буфера няма да повлияе на вписванията ви.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Бисквитки и данни на страници ({ $amount } { $unit })
    .accesskey = д

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Бисквитки и данни на страници
    .accesskey = д

clear-site-data-cookies-info = При изчистване може да бъдете отписани от някои страници

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Буферирано съдържание от мрежата ({ $amount } { $unit })
    .accesskey = б

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Буферирано съдържание от интернет
    .accesskey = б

clear-site-data-cache-info = Ще принуди страниците да презаредят своите изображения и данни

clear-site-data-cancel =
    .label = Отказ
    .accesskey = о

clear-site-data-clear =
    .label = Изчистване
    .accesskey = и
