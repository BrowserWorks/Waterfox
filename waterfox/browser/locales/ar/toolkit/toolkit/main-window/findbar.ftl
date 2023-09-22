# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = ابحث عن التّواجد التّالي للعبارة
findbar-previous =
    .tooltiptext = ابحث عن التّواجد السّابق للعبارة

findbar-find-button-close =
    .tooltiptext = أغلق شريط البحث

findbar-highlight-all2 =
    .label = أبرِز الكل
    .accesskey =
        { PLATFORM() ->
            [macos] ك
           *[other] ك
        }
    .tooltiptext = أبرِز كل تطابقات العبارة

findbar-case-sensitive =
    .label = طابق حالة الأحرف
    .accesskey = ط
    .tooltiptext = ابحث مع مطابقة حالة الأحرف

findbar-match-diacritics =
    .label = طابِق الحركات
    .accesskey = ط
    .tooltiptext = فرّق بين الأحرف مع الحركات وبدون حركات (بتفعيل الخيار لن تتطابق ”مُدرّسة“ مع ”مدرسة“)

findbar-entire-word =
    .label = كلمات كاملة
    .accesskey = ك
    .tooltiptext = ابحث عن الكلمات الكاملة فقط

findbar-not-found = لا وجود للعبارة

findbar-wrapped-to-top = تابعت من الأعلى بعدما وصلت إلى نهاية الصفحة
findbar-wrapped-to-bottom = تابعت من الأسفل بعدما وصلت إلى بداية الصفحة

findbar-normal-find =
    .placeholder = ابحث في الصفحة
findbar-fast-find =
    .placeholder = بحث سريع
findbar-fast-find-links =
    .placeholder = بحث سريع (روابط فقط)

findbar-case-sensitive-status =
    .value = (حساس لحالة الأحرف)
findbar-match-diacritics-status =
    .value = (مطابقة الحركات تعمل)
findbar-entire-word-status =
    .value = (الكلمات الكاملة فقط)

# Variables:
#   $current (Number): Index of the currently selected match
#   $total (Number): Total count of matches
findbar-found-matches =
    .value =
        { $total ->
            [zero] نتيجة { $current } من { $total }
            [one] نتيجة { $current } من { $total }
            [two] نتيجة { $current } من { $total }
            [few] نتيجة { $current } من { $total }
            [many] نتيجة { $current } من { $total }
           *[other] نتيجة { $current } من { $total }
        }

# Variables:
#   $limit (Number): Total count of matches allowed before counting stops
findbar-found-matches-count-limit =
    .value =
        { $limit ->
            [zero] أكثر من { $limit } نتيجة
            [one] أكثر من نتيجة
            [two] أكثر من نتيجتين
            [few] أكثر من { $limit } نتائج
            [many] أكثر من { $limit } نتيجة
           *[other] أكثر من { $limit } نتيجة
        }
