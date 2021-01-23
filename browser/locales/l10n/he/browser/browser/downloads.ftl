# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = הורדות
downloads-panel =
    .aria-label = הורדות

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = השהייה
    .accesskey = ש
downloads-cmd-resume =
    .label = המשך
    .accesskey = מ
downloads-cmd-cancel =
    .tooltiptext = ביטול
downloads-cmd-cancel-panel =
    .aria-label = ביטול

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = פתיחת תיקייה מכילה
    .accesskey = ת
  
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = הצגה ב־Finder
    .accesskey = צ

downloads-cmd-use-system-default =
    .label = פתיחה באמצעות מציג המערכת
    .accesskey = פ

downloads-cmd-always-use-system-default =
    .label = תמיד לפתוח באמצעות מציג המערכת
    .accesskey = ת

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] הצגה ב־Finder
           *[other] פתיחת תיקייה מכילה
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] הצגה ב־Finder
           *[other] פתיחת תיקייה מכילה
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] הצגה ב־Finder
           *[other] פתיחת תיקייה מכילה
        }

downloads-cmd-show-downloads =
    .label = הצגת תיקיית ההורדות
downloads-cmd-retry =
    .tooltiptext = לנסות שנית
downloads-cmd-retry-panel =
    .aria-label = לנסות שנית
downloads-cmd-go-to-download-page =
    .label = מעבר לדף הורדה
    .accesskey = ד
downloads-cmd-copy-download-link =
    .label = העתקת קישור ההורדה
    .accesskey = ע
downloads-cmd-remove-from-history =
    .label = הסרה מההיסטוריה
    .accesskey = ט
downloads-cmd-clear-list =
    .label = ניקוי חלונית תצוגה מקדימה
    .accesskey = ח
downloads-cmd-clear-downloads =
    .label = ניקוי רשימת ההורדות
    .accesskey = ה

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = אפשר הורדה
    .accesskey = א

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = הסרת קובץ

downloads-cmd-remove-file-panel =
    .aria-label = הסרת קובץ

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = הסרת קובץ או אפשור ההורדה

downloads-cmd-choose-unblock-panel =
    .aria-label = הסרת קובץ או אפשור ההורדה

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = פתיחה או הסרת קובץ

downloads-cmd-choose-open-panel =
    .aria-label = פתיחה או הסרת קובץ

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = הצגת מידע נוסף

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = פתיחת קובץ

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = הורדה מחדש

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = ביטול הורדה

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = הצגת כל ההורדות
    .accesskey = ה

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = פרטי הורדה

downloads-clear-downloads-button =
    .label = ניקוי הורדות
    .tooltiptext = ניקוי ההורדות שהושלמו, בוטלו ונכשלו

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = אין הורדות

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = אין הורדות בהפעלה זו.
