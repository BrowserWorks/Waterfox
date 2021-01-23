# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = با هوشیاری پیش بروید
about-config-intro-warning-text = تغییر پیکربندی‌های پیشرفتهٔ ترجیحات می‌تواند بر عملکرد یا امنیت { -brand-short-name } تأثیر بگذارد.
about-config-intro-warning-checkbox = وقتی سعی می‌کنم به این ترجیحات دسترسی پیدا کنم به من هشدار دهید
about-config-intro-warning-button = پذیرش خطر و ادامه



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = تغییر این ترجیحات می‌تواند بر عملکرد یا امنیت { -brand-short-name } تأثیر بگذارد.

about-config-page-title = ترجیحات پیشرفته

about-config-search-input1 =
    .placeholder = جست‌وجوی نام ترجیحات
about-config-show-all = نمایش همه

about-config-pref-add-button =
    .title = افزودن
about-config-pref-toggle-button =
    .title = تغییر وضعیت
about-config-pref-edit-button =
    .title = ویرایش
about-config-pref-save-button =
    .title = ذخیره
about-config-pref-reset-button =
    .title = مقدار اولیه
about-config-pref-delete-button =
    .title = حذف

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = بولی
about-config-pref-add-type-number = عدد
about-config-pref-add-type-string = رشته

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (پیش‌فرض)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (سفارشی)
