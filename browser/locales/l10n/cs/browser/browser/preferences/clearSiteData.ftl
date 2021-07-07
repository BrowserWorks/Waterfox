# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Vymazat data
    .style = width: 35em

clear-site-data-description =
    Po vymazání všech cookies a dat stránek uložených { -brand-short-name.gender ->
        [masculine] ve { -brand-short-name(case: "loc") }
        [feminine] v { -brand-short-name(case: "loc") }
        [neuter] v { -brand-short-name(case: "loc") }
       *[other] v aplikaci { -brand-short-name }
    } může dojít k vašemu odhlášení z webových stránek a odstranění offline uloženého webového obsahu. Vymazání mezipaměti vaše přihlášení neovlivní.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Cookies a data stránek ({ $amount } { $unit })
    .accesskey = s

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Cookies a data stránek
    .accesskey = s

clear-site-data-cookies-info = Po vymazání může dojít k vašemu odhlášení z webových stránek

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Mezipaměť webových stránek ({ $amount } { $unit })
    .accesskey = w

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Mezipaměť webových stránek
    .accesskey = w

clear-site-data-cache-info = Po vymazání bude potřeba znovu načíst obrázky a data z webových stránek

clear-site-data-dialog =
    .buttonlabelaccept = Vymazat
    .buttonaccesskeyaccept = V
