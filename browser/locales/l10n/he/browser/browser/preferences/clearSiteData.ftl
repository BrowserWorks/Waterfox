# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = ניקוי נתונים
    .style = width: 35em

clear-site-data-description = ניקוי כל העוגיות ונתוני האתר שמאוחסנים על־ידי { -brand-short-name } עשוי לנתק את המשתמש שלך מאתרים ויסיר תוכן אינטרנט בלתי מקוון. ניקוי נתוני המטמון לא ישפיע על פרטי הכניסה שלך.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = עוגיות ונתוני אתרים ({ $amount } { $unit })
    .accesskey = נ

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = עוגיות ונתוני אתרים
    .accesskey = נ

clear-site-data-cookies-info = יתכן שהמשתמש שלך יצא מאתרים במקרה של ניקוי

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = תוכן אינטרנט במטמון ({ $amount } { $unit })
    .accesskey = א

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = תוכן אינטרנט במטמון
    .accesskey = א

clear-site-data-cache-info = יאלץ אתרים לטעון מחדש תמונות ונתונים

clear-site-data-cancel =
    .label = ביטול
    .accesskey = ב

clear-site-data-clear =
    .label = ניקוי
    .accesskey = נ
