# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Удаление данных
    .style = width: 35em

clear-site-data-description = Удаление всех кук и данных сайтов, хранимых в { -brand-short-name }, может привести к разрегистрации вас на веб-сайтах и удалению данных автономных веб-сайтов. Очистка кэша не затронет ваши логины.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Куки и данные сайтов ({ $amount } { $unit })
    .accesskey = а

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Куки и данные сайтов
    .accesskey = а

clear-site-data-cookies-info = Удаление может привести к разрегистрации вас на веб-сайтах

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Кэш веб-содержимого ({ $amount } { $unit })
    .accesskey = ш

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Кэш веб-содержимого
    .accesskey = ш

clear-site-data-cache-info = Веб-сайтам потребуется перезагрузить изображения и данные

clear-site-data-dialog =
    .buttonlabelaccept = Удалить
    .buttonaccesskeyaccept = и
