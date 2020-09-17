# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Scancella dæti
    .style = width: 35em

clear-site-data-description = Scancelâ tutti i cookie e dæti di sciti sarvæ da{ -brand-short-name } o peu fate sciortî da-i sciti e scancelâ i contegnui feua linia. Scancelâ a chache no aviâ efetto in sci teu login.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Cookie e Dæti di Sciti ({ $amount } { $unit })
    .accesskey = S

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Cookie e dæti di sciti
    .accesskey = S

clear-site-data-cookies-info = Ti poriesci sciortî da-o scito se ti scancelli questi

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Contegnuo Web inta cache ({ $amount } { $unit })
    .accesskey = W

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Contegnuo Web inta cache
    .accesskey = W

clear-site-data-cache-info = Te saiâ domandou de recaregâ inmagini e dæti

clear-site-data-cancel =
    .label = Anulla
    .accesskey = A

clear-site-data-clear =
    .label = Scancella
    .accesskey = l
