# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 500px;

copy =
    .key = C
menu-copy =
    .label = העתקה
    .accesskey = ה

select-all =
    .key = A
menu-select-all =
    .label = בחירת הכל
    .accesskey = ב

close-dialog =
    .key = w

general-tab =
    .label = כללי
    .accesskey = כ
general-title =
    .value = כותרת:
general-url =
    .value = כתובת:
general-type =
    .value = סוג:
general-mode =
    .value = מצב ציור:
general-size =
    .value = גודל:
general-referrer =
    .value = כתובת קודמת:
general-modified =
    .value = שינוי אחרון:
general-encoding =
    .value = קידוד טקסט:
general-meta-name =
    .label = שם
general-meta-content =
    .label = תוכן

media-tab =
    .label = מדיה
    .accesskey = מ
media-location =
    .value = מיקום:
media-text =
    .value = מלל משויך:
media-alt-header =
    .label = מלל חלופי
media-address =
    .label = כתובת
media-type =
    .label = סוג
media-size =
    .label = גודל
media-count =
    .label = כמות
media-dimension =
    .value = ממדים:
media-long-desc =
    .value = תיאור:
media-save-as =
    .label = שמירה בשם…
    .accesskey = ש
media-save-image-as =
    .label = שמירה בשם…
    .accesskey = ב

perm-tab =
    .label = הרשאות
    .accesskey = ר
permissions-for =
    .value = הרשאות עבור:

security-tab =
    .label = אבטחה
    .accesskey = א
security-view =
    .label = הצגת אישור
    .accesskey = ה
security-view-unknown = לא ידוע
    .value = לא ידוע
security-view-identity =
    .value = זהות האתר
security-view-identity-owner =
    .value = בעלים:
security-view-identity-domain =
    .value = אתר:
security-view-identity-verifier =
    .value = גורם מאמת:
security-view-identity-validity =
    .value = מועד תפוגה:
security-view-privacy =
    .value = פרטיות והיסטוריה

security-view-privacy-history-value = האם ביקרתי באתר זה בעבר?
security-view-privacy-sitedata-value = האם אתר זה מאחסן מידע על המחשב שלי?

security-view-privacy-clearsitedata =
    .label = ניקוי עוגיות ונתוני אתרים
    .accesskey = נ

security-view-privacy-passwords-value = האם שמרתי ססמאות עבור אתר זה?

security-view-privacy-viewpasswords =
    .label = הצגת ססמאות שמורות
    .accesskey = ס
security-view-technical =
    .value = פרטים טכניים

help-button =
    .label = עזרה

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = כן, עוגיות ו־‎{ $value } { $unit } של נתוני אתרים
security-site-data-only = כן, ‎{ $value } { $unit } של נתוני אתרים

security-site-data-cookies-only = כן, עוגיות
security-site-data-no = לא

image-size-unknown = לא ידוע
page-info-not-specified =
    .value = לא צוין
not-set-alternative-text = לא צוין
not-set-date = לא צוין
media-img = תמונה
media-bg-img = רקע
media-border-img = מסגרת
media-list-img = תבליט
media-cursor = סמן
media-object = עצם
media-embed = מוטבע
media-link = צלמית
media-input = קלט
media-video = וידאו
media-audio = אודיו
saved-passwords-yes = כן
saved-passwords-no = לא

no-page-title =
    .value = דף ללא כותרת:
general-quirks-mode =
    .value = מצב לא תקני
general-strict-mode =
    .value = מצב ציות לתקן
page-info-security-no-owner =
    .value = אתר זה לא מספק מידע על הבעלים.
media-select-folder = בחירת תיקייה לשמירת התמונות
media-unknown-not-cached =
    .value = לא ידוע (לא במטמון)
permissions-use-default =
    .label = שימוש בברירת מחדל
security-no-visits = לא

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
            [one] ‏Meta (תגית אחת)
           *[other] ‏Meta (‏{ $tags } תגיות)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] לא
        [one] כן, פעם אחת
        [two] כן, פעמיים
       *[other] כן, { $visits } פעמים
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
            [one] { $kb } ק״ב (בית אחד)
           *[other] { $kb } ק״ב ({ $bytes } בתים)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
            [one] תמונה מסוג { $type } (מונפשת, שקופית אחת)
           *[other] תמונה מסוג { $type } (מונפשת, { $frames } שקופית)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = תמונה מסוג { $type }

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx } פיקסלים × { $dimy } פיקסלים (מוקטן ל־{ $scaledx } פיקסלים × { $scaledy } פיקסלים)

# This string is used to display the size of an image in pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
media-dimensions =
    .value = { $dimx } פיקסלים × { $dimy } פיקסלים

# This string is used to display the size of a media
# file in kilobytes
# Variables:
#   $size (number) - The size of the media file in kilobytes
media-file-size = { $size } ק״ב

# This string is used to display the website name next to the
# "Block Images" checkbox in the media tab
# Variables:
#   $website (string) - The website name
media-block-image =
    .label = חסימת תמונות מ־{ $website }
    .accesskey = ח

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = מידע דף - { $website }‎
page-info-frame =
    .title = מידע מסגרת - { $website }
