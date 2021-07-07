# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = إعدادات مسح التأريخ
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = امسح التأريخ الحالي
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = امسح كل التأريخ
    .style = width: 34em

clear-data-settings-label = على { -brand-short-name } مسح كل شيء تلقائيا عندما إغلاقه

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = المدى الزمني الذي سيُمسح:{ " " }
    .accesskey = م

clear-time-duration-value-last-hour =
    .label = آخر ساعة

clear-time-duration-value-last-2-hours =
    .label = آخر ساعتين

clear-time-duration-value-last-4-hours =
    .label = آخر أربع ساعات

clear-time-duration-value-today =
    .label = التأريخ لهذا اليوم

clear-time-duration-value-everything =
    .label = التأريخ كله

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = التأريخ

item-history-and-downloads =
    .label = تأريخ التصفح و التنزيلات
    .accesskey = ص

item-cookies =
    .label = الكعكات
    .accesskey = ت

item-active-logins =
    .label = جلسات الدخول النشِطة
    .accesskey = ش

item-cache =
    .label = ذاكرة مخبّأة
    .accesskey = ة

item-form-search-history =
    .label = تأريخ البحث و النماذج
    .accesskey = ث

data-section-label = البيانات

item-site-preferences =
    .label = تفضيلات الموقع
    .accesskey = ض

item-offline-apps =
    .label = بيانات المواقع للعمل دون اتصال
    .accesskey = ب

sanitize-everything-undo-warning = لا يمكن التراجع عن هذا الإجراء.

window-close =
    .key = w

sanitize-button-ok =
    .label = امسح الآن

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = يُنظّف

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = سوف يُمسح كل التأريخ.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = سوف تُحذف كل العناصر المحدّدة.
