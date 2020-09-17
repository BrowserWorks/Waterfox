# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

blocklist-window =
    .title = فهرست‌ مسدود‌ی‌ها
    .style = width: 55em

blocklist-description = فهرستی که { -brand-short-name } از آن برای مسدودسازی ردیاب‌ها استفاده می‌کند را انتخاب کنید. فهرست توسط <a data-l10n-name="disconnect-link" title="Disconnect">Disconnect</a> فراهم شده است.
blocklist-close-key =
    .key = w

blocklist-treehead-list =
    .label = فهرست

blocklist-button-cancel =
    .label = انصراف
    .accesskey = ا

blocklist-button-ok =
    .label = ذخیره تغییرات
    .accesskey = ذ

# This template constructs the name of the block list in the block lists dialog.
# It combines the list name and description.
# e.g. "Standard (Recommended). This list does a pretty good job."
#
# Variables:
#   $listName {string, "Standard (Recommended)."} - List name.
#   $description {string, "This list does a pretty good job."} - Description of the list.
blocklist-item-list-template = { $listName } { $description }

blocklist-item-moz-std-listName = فهرست مسدودسازی سطح ۱ (توصیه شده)
blocklist-item-moz-std-description = به تعدادی از ردیاب‌ها اجازه فعالیت بده تا تعداد کمتری وب‌سایت از کار بیافتند.
blocklist-item-moz-full-listName = فهرست مسدودسازی سطح ۲.
blocklist-item-moz-full-description = تمام ردیاب‌های پیدا شده را بلاک کن. تعدادی از وب‌سایت‌ها یا اطلاعات ممکن از به طور کامل لود نشوند.
