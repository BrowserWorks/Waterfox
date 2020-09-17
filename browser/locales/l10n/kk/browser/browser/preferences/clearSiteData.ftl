# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Мәліметті өшіру
    .style = width: 45em

clear-site-data-description = { -brand-short-name } сақтаған барлық cookies және сайт деректері өшіру нәтижесінде веб сайттардан шығып, желіден тыс веб құрамасы өшірілуі мүмкін. Кэштелген деректерді өшіру логиндерге әсер етпейді.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Cookies файлдары және сайт деректері ({ $amount } { $unit })
    .accesskey = с

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Cookies файлдары және сайт деректері
    .accesskey = с

clear-site-data-cookies-info = Тазартылса, сіз сайттардан шығатын боласыз

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Кэштелген веб құрамасы ({ $amount } { $unit })
    .accesskey = в

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Кэштелген веб құрамасы
    .accesskey = в

clear-site-data-cache-info = Веб-сайттарға суреттер мен деректерді қайта жүктеуге мәжбүр етеді

clear-site-data-cancel =
    .label = Бас тарту
    .accesskey = с

clear-site-data-clear =
    .label = Тазарту
    .accesskey = з
