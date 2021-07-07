# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Valyti duomenis
    .style = width: 35em
clear-site-data-description = Išvalius visus slapukus bei svetainių duomenis, saugomus „{ -brand-short-name }“, jūs galite būti atjungti iš svetainių bei netekti darbui neprisijungus skirto turinio. Podėlio duomenų išvalymas neturės įtakos jūsų prisijungimams.
clear-site-data-close-key =
    .key = w
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Slapukai ir svetainių duomenys ({ $amount } { $unit })
    .accesskey = s
# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Slapukai ir svetainių duomenys
    .accesskey = s
clear-site-data-cookies-info = Išvalius jūs galite būti atjungti iš svetainių
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Saityno podėlis ({ $amount } { $unit })
    .accesskey = S
# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Saityno podėlis
    .accesskey = S
clear-site-data-cache-info = Svetainėms reikės iš naujo įkelti paveikslus ir duomenis
clear-site-data-cancel =
    .label = Atsisakyti
    .accesskey = A
clear-site-data-clear =
    .label = Išvalyti
    .accesskey = v
clear-site-data-dialog =
    .buttonlabelaccept = Išvalyti
    .buttonaccesskeyaccept = v
