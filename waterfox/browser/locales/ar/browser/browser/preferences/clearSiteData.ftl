# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = امسح البيانات
    .style = width: 35em

clear-site-data-description = مسحك كل الكعكات وبيانات المواقع التي خزّنها { -brand-short-name } قد يُخرجك من المواقع ويُزيل محتوى الوب بلا اتصال. لن يؤثر مسح بيانات الخبيئة على جلسات الولوج.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = الكعكات وبيانات المواقع ({ $amount } ‏{ $unit })
    .accesskey = ق

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = الكعكات وبيانات المواقع
    .accesskey = ق

clear-site-data-cookies-info = قد يتسبب المسح في خروجك من المواقع

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = محتوى الوب المخبّأ ({ $amount } ‏{ $unit })
    .accesskey = خ

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = محتوى الوب المخبّأ
    .accesskey = خ

clear-site-data-cache-info = سيتطلب أن تعيد المواقع تحميل الصور و البيانات

clear-site-data-dialog =
    .buttonlabelaccept = امسح
    .buttonaccesskeyaccept = س
