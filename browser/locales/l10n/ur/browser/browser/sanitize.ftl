# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = سابقات صاف کرنے کی سیٹنگز
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = حالیہ سابقات خالی کریں
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = تمام سابقات خالی کریں
    .style = width: 34em

clear-data-settings-label = جب میں { -brand-short-name } بندکروں تو اسے خود بخود تمام صاف کریں

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = خالی کرنے کے لیے وقت کی رینج:{ " " }
    .accesskey = و

clear-time-duration-value-last-hour =
    .label = پچھلا گھنٹہ

clear-time-duration-value-last-2-hours =
    .label = پچھلے دو گھنٹے

clear-time-duration-value-last-4-hours =
    .label = پچھلے چار گھنٹے

clear-time-duration-value-today =
    .label = آج

clear-time-duration-value-everything =
    .label = سب کچھ

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = سابقات

item-history-and-downloads =
    .label = براؤزنگ اور ڈاؤن لوڈ سابقات
    .accesskey = ب

item-cookies =
    .label = کوکیز
    .accesskey = ک

item-active-logins =
    .label = متحرک لاگ ان
    .accesskey = ل

item-cache =
    .label = کیسہ
    .accesskey = ک

item-form-search-history =
    .label = فارم اور تلاش سابقات
    .accesskey = ف

data-section-label = کوائف

item-site-preferences =
    .label = سائٹ ترجیحات
    .accesskey = س

item-offline-apps =
    .label = آف لائن ویب سائٹ کوائف
    .accesskey = ل

sanitize-everything-undo-warning = یہ عمل کلعدم نہیں ہو سکتا۔

window-close =
    .key = w

sanitize-button-ok =
    .label = ابھی خالی کریں

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = صاف کر رہا ہے

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = تمام سابقات خالی کر دی جائے گی

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = تمام منتخب اشیاہ خالی کر دیے جائیں گے۔
