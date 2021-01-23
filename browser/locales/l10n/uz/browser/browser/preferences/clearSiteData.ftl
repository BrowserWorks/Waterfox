# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Maʼlumotlarni tozalash
    .style = width: 40em

clear-site-data-description = { -brand-short-name } joylagan sayt ma’lumot va kukilarini tozalasangiz, isobingizdan vaqtincha chiqarilishingiz hamda oflayn ma’lumotlar tozalab tashlanishi mumkin. Keshni tozalash login ma’lumotlariga ta’sir qilmaydi.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Cookie fayllari va sayt maʼlumotlari ({ $amount } { $unit })
    .accesskey = C

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Kuki va sayt ma’lumotlari
    .accesskey = S

clear-site-data-cookies-info = Tozalansa, saytlardagi hisobingizdan chiqib ketishingiz mumkin

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Keshlangan kontent ({ $amount } { $unit })
    .accesskey = K

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Sayt tarkibi kechga joylayndi
    .accesskey = W

clear-site-data-cache-info = Saytlardan rasm va ma’lumotlarni qayta yuklash so‘raladi

clear-site-data-cancel =
    .label = Bekor qilish
    .accesskey = B

clear-site-data-clear =
    .label = Tozalash
    .accesskey = T
