# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = أعِد تحميل اللسان
    .accesskey = ح
select-all-tabs =
    .label = اختر كل الألسنة
    .accesskey = خ
duplicate-tab =
    .label = كرّر اللسان
    .accesskey = ك
duplicate-tabs =
    .label = كرّر الألسنة
    .accesskey = ك
close-tabs-to-the-end =
    .label = أغلق الألسنة على اليسار
    .accesskey = س
close-other-tabs =
    .label = أغلق الألسنة الأخرى
    .accesskey = خ
reload-tabs =
    .label = أعِد تحميل الألسنة
    .accesskey = ع
pin-tab =
    .label = ثبّت اللسان
    .accesskey = ث
unpin-tab =
    .label = أفلِت اللسان
    .accesskey = ف
pin-selected-tabs =
    .label = ثبّت الألسنة
    .accesskey = ث
unpin-selected-tabs =
    .label = أفلِت الألسنة
    .accesskey = ف
bookmark-selected-tabs =
    .label = علّم الألسنة…
    .accesskey = ن
bookmark-tab =
    .label = علّم اللسان
    .accesskey = ع
reopen-in-container =
    .label = أعِد فتحها في الحاوية
    .accesskey = ع
move-to-start =
    .label = انقل إلى البداية
    .accesskey = د
move-to-end =
    .label = انقل إلى النهاية
    .accesskey = ه
move-to-new-window =
    .label = انقل إلى نافذة جديدة
    .accesskey = ذ
tab-context-close-multiple-tabs =
    .label = أغلِق أكثر من لسان
    .accesskey = ك

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] أعِد فتح اللسان
            [zero] أعِد فتح الألسنة
            [one] أعِد فتح اللسان
            [two] أعِد فتح اللسانين
            [few] أعِد فتح الألسنة
            [many] أعِد فتح الألسنة
           *[other] أعِد فتح الألسنة
        }
    .accesskey = ع
close-tab =
    .label = أغلِق اللسان
    .accesskey = غ
close-tabs =
    .label = أغلِق الألسنة
    .accesskey = غ
move-tabs =
    .label = انقل الألسنة
    .accesskey = ق
move-tab =
    .label = انقل اللسان
    .accesskey = ق
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] أغلِق اللسان
            [zero] أغلِق اللسان
            [one] أغلِق اللسان
            [two] أغلِق اللسانين
            [few] أغلِق الألسنة
            [many] أغلِق الألسنة
           *[other] أغلِق الألسنة
        }
    .accesskey = غ
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] انقل اللسان
            [zero] انقل اللسان
            [one] انقل اللسان
            [two] انقل اللسانين
            [few] انقل الألسنة
            [many] انقل الألسنة
           *[other] انقل الألسنة
        }
    .accesskey = ن
