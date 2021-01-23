# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Izbriši podatke
    .style = width: 35em
clear-site-data-description = Brisanje svih kolačića i podataka stranice koje je { -brand-short-name } spremio, može prouzročiti odjavljivanje s web stranica i brisanje izvanmrežnog web sadržaja. Brisanje sadržaja iz priručne memorije neće utjecati na tvoje prijave.
clear-site-data-close-key =
    .key = w
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Kolačići i podaci web stranice ({ $amount } { $unit })
    .accesskey = K
# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Kolačići i podaci web stranice
    .accesskey = K
clear-site-data-cookies-info = Moguće je da ćeš se odjaviti s web stranica, ako izbrišeš
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Web sadržaj u priručnoj memoriji ({ $amount } { $unit })
    .accesskey = W
# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Web sadržaj u priručnoj memoriji
    .accesskey = W
clear-site-data-cache-info = Web stranice će morati ponovo učitati slike i podatke
clear-site-data-cancel =
    .label = Otkaži
    .accesskey = O
clear-site-data-clear =
    .label = Izbriši
    .accesskey = I
