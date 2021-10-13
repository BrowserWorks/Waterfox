# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = الألوان
    .style =
        { PLATFORM() ->
            [macos] width: 41em !important
           *[other] width: 38em !important
        }

colors-dialog-legend = النص و الخلفية

text-color-label =
    .value = النص:
    .accesskey = ن

background-color-label =
    .value = الخلفية:
    .accesskey = خ

use-system-colors =
    .label = استخدم ألوان النظام
    .accesskey = س

colors-link-legend = ألوان الروابط

link-color-label =
    .value = الروابط غير المزارة:
    .accesskey = غ

visited-link-color-label =
    .value = الروابط المزارة:
    .accesskey = م

underline-link-checkbox =
    .label = سطّر الروابط
    .accesskey = و

override-color-label =
    .value = بدل الألوان التي يحددها المحتوى باختياراتي أعلاه:
    .accesskey = د

override-color-always =
    .label = دائمًا

override-color-auto =
    .label = مع السمات عالية التباين فقط

override-color-never =
    .label = أبدًا
