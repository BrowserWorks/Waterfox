# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Spastroji të Dhënat
    .style = width: 35em

clear-site-data-description = Spastrimi i krejt cookie-eve dhe të dhënave të sajtit të depozituara nga { -brand-short-name }-i mund të sjellë daljen tuaj nga llogaritë në sajte dhe heqje të lëndës për përdorim pa qenë i lidhur në internet. Spastrimi i të dhënave të fshehtinës nuk do të prekë kredencialet tuaja për hyrje.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Cookie dhe të Dhëna Sajtesh ({ $amount } { $unit })
    .accesskey = C

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Cookies dhe të Dhëna Sajtesh
    .accesskey = C

clear-site-data-cookies-info = Në u spastroftë, mund të sjellë daljen tuaj nga llogaritë në sajte

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Lëndë Web e Ruajtur Në Fshehtinë ({ $amount } { $unit })
    .accesskey = L

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Lëndë Web Në Fshehtinë
    .accesskey = L

clear-site-data-cache-info = Do të kërkojë që sajtet të ringarkojnë figura dhe të dhëna

clear-site-data-cancel =
    .label = Anuloje
    .accesskey = A

clear-site-data-clear =
    .label = Spastroje
    .accesskey = S
