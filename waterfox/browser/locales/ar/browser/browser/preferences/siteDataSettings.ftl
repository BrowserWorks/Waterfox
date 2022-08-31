# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Settings

site-data-settings-window =
    .title = أدِر الكعكات و بيانات المواقع

site-data-settings-description = تخزّن المواقع التالية الكعكات و بيانات الموقع على حاسوبك. يبقي { -brand-short-name } البيانات من المواقع التي تستخدم تخزينًا دائمًا حتى تحذفها، و يحذف البيانات من المواقع التي لا تستخدم التخزين الدائم عندما يحتاج إلى مساحة التخزين.

site-data-search-textbox =
    .placeholder = ابحث في المواقع
    .accesskey = ح

site-data-column-host =
    .label = الموقع
site-data-column-cookies =
    .label = الكعكات
site-data-column-storage =
    .label = التخزين
site-data-column-last-used =
    .label = آخر استخدام

# This label is used in the "Host" column for local files, which have no host.
site-data-local-file-host = (ملف محلي)

site-data-remove-selected =
    .label = أزل المحدد
    .accesskey = م

site-data-settings-dialog =
    .buttonlabelaccept = احفظ التغييرات
    .buttonaccesskeyaccept = ظ

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
site-storage-usage =
    .value = { $value } { $unit }
site-storage-persistent =
    .value = { site-storage-usage.value } (دائم)

site-data-remove-all =
    .label = أزِل الكل
    .accesskey = ل

site-data-remove-shown =
    .label = أزِل كل المعروض
    .accesskey = ض

## Removing

site-data-removing-dialog =
    .title = { site-data-removing-header }
    .buttonlabelaccept = أزِل

site-data-removing-header = إزالة الكعكات و بيانات المواقع

site-data-removing-desc = بإزالة الكعكات و بيانات المواقع قد تخرج من مواقع الوِب. أمتأكد من إجراء هذه التغييرات؟

site-data-removing-table = ستُزال الكعكات و بيانات المواقع للمواقع الآتية
