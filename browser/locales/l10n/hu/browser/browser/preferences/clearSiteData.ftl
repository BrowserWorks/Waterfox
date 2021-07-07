# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Adatok törlése
    .style = width: 35em
clear-site-data-description = A { -brand-short-name } által tárolt összes süti és oldaladat törlése kijelentkeztetheti a webhelyekről és eltávolíthatja az offline webes tartalmat. A gyorsítótár törlése nem befolyásolja a bejelentkezéseit.
clear-site-data-close-key =
    .key = w
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Sütik és oldaladatok ({ $amount } { $unit })
    .accesskey = o
# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Sütik és oldaladatok
    .accesskey = o
clear-site-data-cookies-info = Ha kiüríti, akkor lehet hogy ki lesz jelentkeztetve egyes webhelyekről
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Gyorsítótárazott webes tartalom ({ $amount } { $unit })
    .accesskey = w
# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Gyorsítótárazott webtartalom
    .accesskey = w
clear-site-data-cache-info = A weboldalaknak újra kell majd tölteniük a képeket és az adatokat
clear-site-data-cancel =
    .label = Mégse
    .accesskey = M
clear-site-data-clear =
    .label = Törlés
    .accesskey = T
clear-site-data-dialog =
    .buttonlabelaccept = Törlés
    .buttonaccesskeyaccept = T
