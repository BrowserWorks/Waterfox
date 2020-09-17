# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = پاک کردن داده‌ها
    .style = width: 35em

clear-site-data-description = پاک کردن تمام کوکی‌ها و داده‌های سایت‌ها توسط { -brand-short-name } ممکن از شما را از برخی سایت‌ها خارج و داده‌های برون‌خط شما را حذف کند. حذف داده‌های نهان، تاثیری بر ورودهای شما در سایت‌های مختلف ندارد.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = کوکی‌ها و داده‌های سایت ({ $amount } { $unit })
    .accesskey = S

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = کوکی‌ها و داده‌های سایت
    .accesskey = S

clear-site-data-cookies-info = اگر پاک کنید، ممکن است از بعضی سایت‌ها خارج شوید

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = محتوای ذخیره شدهٔ وب ({ $amount } { $unit })
    .accesskey = W

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = محتوای ذخیره شدهٔ وب
    .accesskey = W

clear-site-data-cache-info = لازم از وب‌سایت‌ها داده‌ها و تصاویر را مجددا بارگیری کنند

clear-site-data-cancel =
    .label = لغو
    .accesskey = C

clear-site-data-clear =
    .label = پاک کردن
    .accesskey = I
