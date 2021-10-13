# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

config-window =
    .title = about:config

## Strings used to display a warning in about:config

# This text should be attention grabbing and playful
config-about-warning-title =
    .value = قد يلغي هذا ضمانك!
config-about-warning-text = تغيير القيم المبدئية لهذه الإعدادات المتقدمة قد يضر بثبات وأمان وأداء التطبيق. يجب أن تواصِل فقط إذا كنت واثقا مما تفعل.
config-about-warning-button =
    .label = أقبل المخاطرة!
config-about-warning-checkbox =
    .label = أظهر هذا التحذير في المرّة القادمة

config-search-prefs =
    .value = ابحث:
    .accesskey = ح

config-focus-search =
    .key = r

config-focus-search-2 =
    .key = f

## These strings are used for column headers

config-pref-column =
    .label = اسم التّفضيل
config-lock-column =
    .label = الحالة
config-type-column =
    .label = النوع
config-value-column =
    .label = القيمة

## These strings are used for tooltips

config-pref-column-header =
    .tooltip = انقر للتّرتيب
config-column-chooser =
    .tooltip = انقر لاختيار الأعمدة التي ستعرض

## These strings are used for the context menu

config-copy-pref =
    .key = C
    .label = انسخ
    .accesskey = ن

config-copy-name =
    .label = انسخ الاسم
    .accesskey = س

config-copy-value =
    .label = انسخ القيمة
    .accesskey = ق

config-modify =
    .label = عدِّل
    .accesskey = ع

config-toggle =
    .label = بدّل
    .accesskey = ب

config-reset =
    .label = صفّر
    .accesskey = ص

config-new =
    .label = جديد
    .accesskey = ي

config-string =
    .label = نصّ
    .accesskey = ن

config-integer =
    .label = عدد صحيح
    .accesskey = ص

config-boolean =
    .label = عدد منطقي
    .accesskey = م

config-default = المبدئي
config-modified = معدّل
config-locked = مُوصد

config-property-string = نص
config-property-int = عدد صحيح
config-property-bool = عدد منطقي

config-new-prompt = أدخل اسم التّفضيل

config-nan-title = قيمة غير صالحة
config-nan-text = النص الذي أدخلته ليس رقمًا.

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-new-title = قيمة { $type } جديدة

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-modify-title = أدخل قيمة { $type }
