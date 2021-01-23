# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Стерти дані
    .style = width: 35em

clear-site-data-description = Стирання всіх кук і даних сайтів, що зберігаються в { -brand-short-name }, може призвести до виходу на вебсайтах та вилучення автономного вебвмісту.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Куки і дані сайтів ({ $amount } { $unit })
    .accesskey = К

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Куки і дані сайтів
    .accesskey = К

clear-site-data-cookies-info = При стиранні може виконатись вихід на вебсайтах

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Кешований вебвміст ({ $amount } { $unit })
    .accesskey = ш

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Кешований вебвміст
    .accesskey = ш

clear-site-data-cache-info = Вебсайтам доведеться повторно завантажувати зображення і дані

clear-site-data-cancel =
    .label = Скасувати
    .accesskey = С

clear-site-data-clear =
    .label = Стерти
    .accesskey = т
