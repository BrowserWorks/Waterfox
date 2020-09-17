# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = הגדרות למחיקת היסטוריה
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = מחיקת היסטוריה אחרונה
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = מחיקת כל ההיסטוריה
    .style = width: 34em

clear-data-settings-label = עם הסגירה, { -brand-short-name } אמור לפנות את כל אלה אוטומטית

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = טווח זמן למחיקה:{ " " }
    .accesskey = ז

clear-time-duration-value-last-hour =
    .label = שעה אחרונה

clear-time-duration-value-last-2-hours =
    .label = שעתיים אחרונות

clear-time-duration-value-last-4-hours =
    .label = 4 שעות אחרונות

clear-time-duration-value-today =
    .label = היום

clear-time-duration-value-everything =
    .label = הכול

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = היסטוריה

item-history-and-downloads =
    .label = היסטוריית גלישה והורדות
    .accesskey = ה

item-cookies =
    .label = עוגיות
    .accesskey = ע

item-active-logins =
    .label = כניסות פעילות
    .accesskey = כ

item-cache =
    .label = מטמון
    .accesskey = מ

item-form-search-history =
    .label = היסטוריית טפסים וחיפוש
    .accesskey = ט

data-section-label = נתונים

item-site-preferences =
    .label = העדפות אתר
    .accesskey = ה

item-offline-apps =
    .label = נתונים לא מקוונים של אתרים
    .accesskey = מ

sanitize-everything-undo-warning = לא ניתן לבטל פעולה זו.

window-close =
    .key = w

sanitize-button-ok =
    .label = מחיקה כעת

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = מחיקה

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = כל ההיסטוריה תימחק.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = כל הפריטים הנבחרים יימחקו.
