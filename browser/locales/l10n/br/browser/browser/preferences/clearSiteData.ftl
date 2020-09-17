# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Skarzhañ ar roadennoù
    .style = width: 35em

clear-site-data-description = Skarzhañ an holl doupinoù ha roadennoù lec'hienn kadavet gant { -brand-short-name } a c'hall digennaskañ ac'hanoc'h eus lec'hiennoù ha dilemel endalc'hadoù web ezlinenn. Skarzhañ roadennoù ar c'hrubuilh na raio netra d'ho kennaskadennoù.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Toupinoù ha roadennoù lec'hienn ({ $amount } { $unit })
    .accesskey = T

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Toupinoù ha roadennoù lec'hienn
    .accesskey = T

clear-site-data-cookies-info = Gallout a rit bezañ digennasket eus lec'hiennoù m'int skarzhet

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Endalc'had web er c'hrubuilh ({ $amount } { $unit })
    .accesskey = E

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Endalc'had web er c'hrubuilh
    .accesskey = E

clear-site-data-cache-info = Lakaat a raio al lec'hiennoù da adkargañ o skeudennoù ha roadennoù

clear-site-data-cancel =
    .label = Nullañ
    .accesskey = N

clear-site-data-clear =
    .label = Skarzhañ
    .accesskey = S
