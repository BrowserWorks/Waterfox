# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Məlumatları təmizlə
    .style = width: 35em

clear-site-data-description = { -brand-short-name } tərəfindən saxlanılan bütün çərəz və sayt məlumatlarını təmizləmə saytlardan çıxma və oflayn web məzmunlarının silinməsi ilə nəticələnəcək. Keş məlumatlarını silmə sayt girişlərinizi dəyişdirməyəcək.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Çərəzlər və Sayt Məlumatları ({ $amount } { $unit })
    .accesskey = S

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Çərəzlər və Sayt Məlumatları
    .accesskey = S

clear-site-data-cookies-info = Əgər təmizlənsə saytlardan çıxış etmiş ola bilərsiz

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Keşdə Saxlanmış Web Məzmunlar ({ $amount } { $unit })
    .accesskey = W

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Keşdə Saxlanmış Web Məzmun
    .accesskey = W

clear-site-data-cache-info = Saytlarda şəkil və məlumatları təkrar yükləməyi tələb edəcək

clear-site-data-cancel =
    .label = Ləğv et
    .accesskey = L

clear-site-data-clear =
    .label = Təmizlə
    .accesskey = l
