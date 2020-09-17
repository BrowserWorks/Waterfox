# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = تنظیمات پاک‌سازی تاریخچه
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = پاک‌سازی تاریخچهٔ اخیر
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = پاک‌سازی تمام تاریخچه
    .style = width: 34em

clear-data-settings-label = هنگام بسته شدن، { -brand-short-name } باید همه را به طور خودکار پاک کند

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = بازهٔ زمانی برای پاک‌سازی:{ " " }
    .accesskey = ب

clear-time-duration-value-last-hour =
    .label = ساعت گذشته

clear-time-duration-value-last-2-hours =
    .label = دو ساعت گذشته

clear-time-duration-value-last-4-hours =
    .label = چهار ساعت گذشته

clear-time-duration-value-today =
    .label = امروز

clear-time-duration-value-everything =
    .label = تمام تاریخچه

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = تاریخچه

item-history-and-downloads =
    .label = &مرور تاریخچه دانلود
    .accesskey = ت

item-cookies =
    .label = کوکی‌ها
    .accesskey = ک

item-active-logins =
    .label = نشست‌های فعال
    .accesskey = ن

item-cache =
    .label = حافظهٔ نهان
    .accesskey = ح

item-form-search-history =
    .label = فرم و تاریخچه جست‌و‌جو
    .accesskey = ف

data-section-label = اطلاعات

item-site-preferences =
    .label = ترجیحات سایت
    .accesskey = س

item-offline-apps =
    .label = اطلاعات برون‌خط پایگاه‌های وب
    .accesskey = ا

sanitize-everything-undo-warning = این عمل قابل واگرد نیست.

window-close =
    .key = w

sanitize-button-ok =
    .label = پاک‌سازی

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = پاک‌سازی

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = تمام تاریخچه پاک خواهد شد.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = همه‌ی موارد انتخاب‌شده پاک خواهند شد.
