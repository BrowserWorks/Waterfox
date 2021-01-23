# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Vymazanie údajov
    .style = width: 35em

clear-site-data-description = Vymazanie všetkých cookies a údajov stránok, ktoré má aplikácia { -brand-short-name } uložené, vás môže odhlásiť z webových stránok a odstrániť offline webový obsah. Vymazanie údajov vo vyrovnávacej pamäti vaše prihlásenia neovplyvní.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Cookies a údaje stránok ({ $amount } { $unit })
    .accesskey = s

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Cookies a údaje stránok
    .accesskey = s

clear-site-data-cookies-info = Po vymazaní môže dôjsť k odhláseniu z webových stránok

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Webový obsah vo vyrovnávacej pamäti ({ $amount } { $unit })
    .accesskey = W

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Webový obsah vo vyrovnávacej pamäti
    .accesskey = W

clear-site-data-cache-info = Po vymazaní bude nutné znova načítať obrázky a údaje z webových stránok

clear-site-data-cancel =
    .label = Zrušiť
    .accesskey = Z

clear-site-data-clear =
    .label = Vymazať
    .accesskey = V
