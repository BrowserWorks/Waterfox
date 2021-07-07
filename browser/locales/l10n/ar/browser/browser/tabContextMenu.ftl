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
# The following string is displayed on a menuitem that will close the tabs from the start of the tabstrip to the currently targeted tab (excluding the currently targeted and any other selected tabs).
# In left-to-right languages this should use "Left" and in right-to-left languages this should use "Right".
close-tabs-to-the-start =
    .label = أغلِق الألسنة على اليمين
    .accesskey = م
# The following string is displayed on a menuitem that will close the tabs from the end of the tabstrip to the currently targeted tab (excluding the currently targeted and any other selected tabs).
# In left-to-right languages this should use "Right" and in right-to-left languages this should use "Left".
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
    .label = أعِد فتحه في الحاوية
    .accesskey = ع
tab-context-open-in-new-container-tab =
    .label = افتح في لسانٍ حاوٍ جديد
    .accesskey = س
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
tab-context-share-url =
    .label = شارِك
    .accesskey = ش
tab-context-share-more =
    .label = أكثر

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
tab-context-reopen-closed-tabs =
    .label =
        { $tabCount ->
            [1] أعِد فتح اللسان المغلق
            [zero] أعِد فتح اللسان المغلق
            [one] أعِد فتح اللسان المغلق
            [two] أعِد فتح اللسانين المغلقين
            [few] أعِد فتح الألسنة المغلقة
            [many] أعِد فتح الألسنة المغلقة
           *[other] أعِد فتح الألسنة المغلقة
        }
    .accesskey = ع
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
