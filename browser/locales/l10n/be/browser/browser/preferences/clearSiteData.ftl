# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Выдаліць дадзеныя
    .style = width: 35em

clear-site-data-description = Выдаленне ўсіх кукаў і дадзеных сайтаў, якія захоўваюцца ў { -brand-short-name }, можа прывесці да выхаду з вэб-сайтаў і выдалення аўтаномнага вэб-кантэнту. Ачыстка кэша дадзеных не паўплывае на вашы лагіны.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Кукі і дадзеныя сайтаў ({ $amount } { $unit })
    .accesskey = с

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Кукі і дадзеныя сайтаў
    .accesskey = с

clear-site-data-cookies-info = Пры выдаленні можа адбыцца выхад на вэб-сайтах

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Кэшаванае сеціўнае змесціва ({ $amount } { $unit })
    .accesskey = К

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Кэшаванае сеціўнае змесціва
    .accesskey = К

clear-site-data-cache-info = Вэб-сайтам давядзецца паўторна сцягваць выявы і дадзеныя

clear-site-data-cancel =
    .label = Адмяніць
    .accesskey = А

clear-site-data-clear =
    .label = Ачысціць
    .accesskey = ч
