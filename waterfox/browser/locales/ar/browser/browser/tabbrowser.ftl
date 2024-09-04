# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tabbrowser-empty-tab-title = لسان جديد

tabbrowser-menuitem-close-tab =
    .label = أغلق اللّسان
tabbrowser-menuitem-close =
    .label = أغلق

# Displayed as a tooltip on container tabs
# Variables:
#   $title (String): the title of the current tab.
#   $containerName (String): the name of the current container.
tabbrowser-container-tab-title = ‏{ $title } ‏- ‏{ $containerName }

# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-close-tabs-tooltip =
    .label =
        { $tabCount ->
            [one] أغلِق اللسان
            [two] أغلِق اللسانين
            [few] أغلِق { $tabCount } ألسنة
            [many] أغلِق { $tabCount } لسانا
           *[other] أغلِق { $tabCount } لسان
        }

## Tooltips for tab audio control
## Variables:
##   $tabCount (Number): The number of tabs that will be affected.

# Variables:
#   $shortcut (String): The keyboard shortcut for "Mute tab".
tabbrowser-mute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] اكتم اللسان ({ $shortcut })
            [two] اكتم اللسانين ({ $shortcut })
            [few] اكتم { $tabCount } ألسنة ({ $shortcut })
            [many] اكتم { $tabCount } لسانا ({ $shortcut })
           *[other] اكتم { $tabCount } لسان ({ $shortcut })
        }
# Variables:
#   $shortcut (String): The keyboard shortcut for "Unmute tab".
tabbrowser-unmute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] أطلِق صوت اللسان ({ $shortcut })
            [two] أطلِق صوت اللسانين ({ $shortcut })
            [few] أطلِق صوت { $tabCount } ألسنة ({ $shortcut })
            [many] أطلِق صوت { $tabCount } لسانا ({ $shortcut })
           *[other] أطلِق صوت { $tabCount } لسان ({ $shortcut })
        }
tabbrowser-mute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] اكتم اللسان
            [two] اكتم اللسانين
            [few] اكتم { $tabCount } ألسنة
            [many] اكتم { $tabCount } لسانا
           *[other] اكتم { $tabCount } لسان
        }
tabbrowser-unmute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] أطلِق صوت اللسان
            [two] أطلِق صوت اللسانين
            [few] أطلِق صوت { $tabCount } ألسنة
            [many] أطلِق صوت { $tabCount } لسانا
           *[other] أطلِق صوت { $tabCount } لسان
        }
tabbrowser-unblock-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] شغِّل اللسان
            [two] شغِّل اللسانين
            [few] شغِّل { $tabCount } ألسنة
            [many] شغِّل { $tabCount } لسانا
           *[other] شغِّل { $tabCount } لسان
        }

## Confirmation dialog when closing a window with more than one tab open,
## or when quitting when only one window is open.

# The singular form is not considered since this string is used only for multiple tabs.
# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-confirm-close-tabs-title =
    { $tabCount ->
        [one] أتريد إغلاق اللسان؟
        [two] أتريد إغلاق اللسانين؟
        [few] أتريد إغلاق { $tabCount } ألسنة؟
        [many] أتريد إغلاق { $tabCount } لسانًا؟
       *[other] أتريد إغلاق { $tabCount } لسان؟
    }
tabbrowser-confirm-close-tabs-button = أغلق الألسنة
tabbrowser-confirm-close-tabs-checkbox = أكّد علي عند محاولة إغلاق عدّة ألسنة

## Confirmation dialog when quitting using the menu and multiple windows are open.

# The forms for 0 or 1 items are not considered since this string is used only for
# multiple windows.
# Variables:
#   $windowCount (Number): The number of windows that will be closed.
tabbrowser-confirm-close-windows-title =
    { $windowCount ->
        [one] أتريد إغلاق النافذة؟
        [two] أتريد إغلاق النافذتين؟
        [few] أتريد إغلاق { $windowCount } نوافذ؟
        [many] أتريد إغلاق { $windowCount } نافذة؟
       *[other] أتريد إغلاق { $windowCount } نافذة؟
    }
tabbrowser-confirm-close-windows-button =
    { PLATFORM() ->
        [windows] أغلِق وغادِر
       *[other] أغلِق وغادِر
    }

## Confirmation dialog when quitting using the keyboard shortcut (Ctrl/Cmd+Q)
## Windows does not show a prompt on quit when using the keyboard shortcut by default.

tabbrowser-confirm-close-tabs-with-key-title = أتريد إغلاق النافذة ومغادرة { -brand-short-name }؟
tabbrowser-confirm-close-tabs-with-key-button = غادِر { -brand-short-name }

## Confirmation dialog when opening multiple tabs simultaneously

tabbrowser-confirm-open-multiple-tabs-title = أكّد الفتح
# Variables:
#   $tabCount (Number): The number of tabs that will be opened.
tabbrowser-confirm-open-multiple-tabs-message =
    { $tabCount ->
       *[other] أنت على وشك فتح { $tabCount } ألسنة. قد يبطئ هذا { -brand-short-name } بينما يتمّ تحميل الصفحات. أمتأكّد أنّك تريد المتابعة؟
    }
tabbrowser-confirm-open-multiple-tabs-button = فتح ألسنة
tabbrowser-confirm-open-multiple-tabs-checkbox = نبّهني أنّ فتح عدّة ألسنة قد يبطئ { -brand-short-name }

## Confirmation dialog for enabling caret browsing

tabbrowser-confirm-caretbrowsing-title = التصفّح بالمؤشّر
tabbrowser-confirm-caretbrowsing-message = ضغط F7 يعطّل التصفّح بالمؤشّر. تضع هذه الميزة مؤشّرًا متحرّكًا في صفحات الوِب، ما يسمح لك بتحديد النص بلوحة المفاتيح. أتريد تفعيل التصفّح بالمؤشّر؟
tabbrowser-confirm-caretbrowsing-checkbox = لا تعرض هذا الحوار مرّة أخرى.

##

tabbrowser-customizemode-tab-title = خصّص { -brand-short-name }

## Context menu buttons, of which only one will be visible at a time

tabbrowser-context-mute-tab =
    .label = اكتم اللسان
    .accesskey = ك
tabbrowser-context-unmute-tab =
    .label = أطلِق صوت اللسان
    .accesskey = ط
# The accesskey should match the accesskey for tabbrowser-context-mute-tab
tabbrowser-context-mute-selected-tabs =
    .label = اكتم الألسنة
    .accesskey = ك
# The accesskey should match the accesskey for tabbrowser-context-unmute-tab
tabbrowser-context-unmute-selected-tabs =
    .label = أطلِق صوت الألسنة
    .accesskey = ط

## Ctrl-Tab dialog

# Variables:
#   $tabCount (Number): The number of tabs in the current browser window. It will always be 2 at least.
tabbrowser-ctrl-tab-list-all-tabs =
    .label =
        { $tabCount ->
            [two] اعرض لسانين
            [few] اعرض { $tabCount } ألسنة
            [many] اعرض { $tabCount } لسانًا
           *[other] اعرض { $tabCount } لسان
        }

## Tab manager menu buttons

