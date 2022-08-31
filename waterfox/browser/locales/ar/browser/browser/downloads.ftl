# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = التنزيلات
downloads-panel =
    .aria-label = التنزيلات

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-items =
    .style = width: 35em

downloads-cmd-pause =
    .label = ألبِث
    .accesskey = ث
downloads-cmd-resume =
    .label = استأنف
    .accesskey = س
downloads-cmd-cancel =
    .tooltiptext = ألغِ
downloads-cmd-cancel-panel =
    .aria-label = ألغِ

downloads-cmd-show-menuitem-2 =
    .label =
        { PLATFORM() ->
            [macos] اعرض في فايندر
           *[other] اعرض في المجلد
        }
    .accesskey = ف

## Displayed in the downloads context menu for files that can be opened.
## Variables:
##   $handler (String) - The name of the mime type's default file handler.
##   Example: "Notepad", "Acrobat Reader DC", "7-Zip File Manager"

downloads-cmd-use-system-default =
    .label = افتح في عارِض النظام
    .accesskey = ظ

# We can use the same accesskey as downloads-cmd-always-open-similar-files.
# Both should not be visible in the downloads context menu at the same time.
downloads-cmd-always-use-system-default =
    .label = افتح دائمًا في عارِض النظام
    .accesskey = ع

##

# We can use the same accesskey as downloads-cmd-always-use-system-default.
# Both should not be visible in the downloads context menu at the same time.
downloads-cmd-always-open-similar-files =
    .label = افتح الملفات المشابهة دائما
    .accesskey = ئ

downloads-cmd-show-button-2 =
    .tooltiptext =
        { PLATFORM() ->
            [macos] اعرض في فايندر
           *[other] اعرض في المجلد
        }

downloads-cmd-show-panel-2 =
    .aria-label =
        { PLATFORM() ->
            [macos] اعرض في فايندر
           *[other] اعرض في المجلد
        }
downloads-cmd-show-description-2 =
    .value =
        { PLATFORM() ->
            [macos] اعرض في فايندر
           *[other] اعرض في المجلد
        }

downloads-cmd-show-downloads =
    .label = اعرض مجلد التنزيلات
downloads-cmd-retry =
    .tooltiptext = أعد المحاولة
downloads-cmd-retry-panel =
    .aria-label = أعد المحاولة
downloads-cmd-go-to-download-page =
    .label = انتقل إلى صفحة التنزيل
    .accesskey = ت
downloads-cmd-copy-download-link =
    .label = انسخ رابط التنزيل
    .accesskey = ر
downloads-cmd-remove-from-history =
    .label = احذف من التأريخ
    .accesskey = ح
downloads-cmd-clear-list =
    .label = امسح لوحة المعاينة
    .accesskey = م
downloads-cmd-clear-downloads =
    .label = امسح التنزيلات
    .accesskey = س
downloads-cmd-delete-file =
    .label = احذف
    .accesskey = ح

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = اسمح بالتنزيل
    .accesskey = س

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = أزل الملف

downloads-cmd-remove-file-panel =
    .aria-label = أزل الملف

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = أزل الملف أو اسمح بالتنزيل

downloads-cmd-choose-unblock-panel =
    .aria-label = أزل الملف أو اسمح بالتنزيل

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = افتح أو احذف الملف

downloads-cmd-choose-open-panel =
    .aria-label = افتح أو احذف الملف

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = اعرض المزيد من المعلومات

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = افتح الملف

## Displayed when the user clicked on a download in process. Indicates that the
## downloading file will be opened after certain amount of time using an app
## available in the system.
## Variables:
##   $hours (number) - Amount of hours left till the file opens.
##   $seconds (number) - Amount of seconds left till the file opens.
##   $minutes (number) - Amount of minutes till the file opens.

downloading-file-opens-in-hours-and-minutes = سيُفتح في غضون { $hours }سا { $minutes }دق…
downloading-file-opens-in-minutes = سيُفتح في غضون { $minutes } دق…
downloading-file-opens-in-minutes-and-seconds = سيُفتح في غضون { $minutes } دق { $seconds } ثا…
downloading-file-opens-in-seconds = سيُفتح في غضون { $seconds } ثا…
downloading-file-opens-in-some-time = سيُفتح حين يكتمل…
downloading-file-click-to-open =
    .value = افتح عند الاكتمال

##

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = أعِد التنزيل

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = ألغِ التنزيل

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = أظهر كل التنزيلات
    .accesskey = ك

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = تفاصيل التنزيل

## Displayed when a site attempts to automatically download many files.
## Variables:
##   $num (number) - Number of blocked downloads.
##   $url (string) - The url of the suspicious site, stripped of http, https and www prefix.

downloads-files-not-downloaded =
    { $num ->
        [zero] لم يُنزّل الملف.
        [one] لم يُنزّل الملف.
        [two] لم يُنزّل الملفان.
        [few] لم تُنزّل { $num } ملفات.
        [many] لم يُنزّل { $num } ملفًا.
       *[other] لم يُنزّل { $num } ملف.
    }
downloads-blocked-from-url = حُظرت التنزيلات من { $url }.
downloads-blocked-download-detailed-info = حاول { $url } تنزيل ملفات عديدة تلقائيًا. قد يكون الموقع معطوبًا أو يحاول تخزين ملفات مزعجة على جهازك.

##

downloads-clear-downloads-button =
    .label = امسح التنزيلات
    .tooltiptext = امسح التنزيلات المكتملة و غير المكتملة و الملغاة

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = لا توجد أي تنزيلات.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = لا توجد تنزيلات لهذه الجلسة.

# This is displayed in an item at the bottom of the Downloads Panel when there
# are more downloads than can fit in the list in the panel.
#   $count (number) - number of files being downloaded that are not shown in the
#                     panel list.
downloads-more-downloading =
    { $count ->
        [zero] لا توجد ملفّات تُنزّل حاليًا
        [one] ملفّ واحد يُنزّل حاليًا
        [two] ملفّان يُنزّلان حاليًا
        [few] { $count } ملفّات تُنزّل حاليًا
        [many] { $count } ملفّا يُنزّل حاليًا
       *[other] { $count } ملف تُنزّل حاليًا
    }
