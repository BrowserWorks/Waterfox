# This Source Code Form is subject to the terms of the Mozilla Public
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
downloads-panel-list =
    .style = width: 70ch
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
# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = افتح المجلد المحتوي
    .accesskey = م
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = اعرض في فايندر
    .accesskey = ف
downloads-cmd-use-system-default =
    .label = افتح في عارِض النظام
    .accesskey = ظ
downloads-cmd-always-use-system-default =
    .label = افتح دائمًا في عارِض النظام
    .accesskey = ع
downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] اعرض في فايندر
           *[other] افتح المجلد المحتوي
        }
downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] اعرض في فايندر
           *[other] افتح المجلد المحتوي
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] اعرض في فايندر
           *[other] افتح المجلد المحتوي
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
