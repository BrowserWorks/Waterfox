# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = ڈاؤن لوڈ
downloads-panel =
    .aria-label = ڈاؤن لوڈ

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of 
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = توقف کریں
    .accesskey = ت
downloads-cmd-resume =
    .label = پھر جاری کریں
    .accesskey = پ
downloads-cmd-cancel =
    .tooltiptext = منسوخ کریں
downloads-cmd-cancel-panel =
    .aria-label = منسوخ کریں

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = حامل پوشہ کھولیں
    .accesskey = پ
  
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = ڈھونڈ کار میں دکھائیں
    .accesskey = ڈ

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] ڈھونڈ کار میں دکھائیں
           *[other] حامل پوشہ کھولیں
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] ڈھونڈ کار میں دکھائیں
           *[other] حامل پوشہ کھولیں
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] ڈھونڈ کار میں دکھائیں
           *[other] حامل پوشہ کھولیں
        }

downloads-cmd-show-downloads =
    .label = ڈاؤن لوڈ پوشہ دکھائیں
downloads-cmd-retry =
    .tooltiptext = پھر کوشش کریں
downloads-cmd-retry-panel =
    .aria-label = پھر کوشش کریں
downloads-cmd-go-to-download-page =
    .label = ڈاؤن لوڈ صفحہ پر جائیں
    .accesskey = ج
downloads-cmd-copy-download-link =
    .label = ڈاؤن لوڈ ربط نقل کریں
    .accesskey = ر
downloads-cmd-remove-from-history =
    .label = سابقات سے ہٹائیں
    .accesskey = ہ
downloads-cmd-clear-list =
    .label = صاف پیش نظارہ پینل
    .accesskey = ف
downloads-cmd-clear-downloads =
    .label = ڈاؤن لوڈ خالی کریں
    .accesskey = ڈ

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = اجازت دیں ڈاؤن لوڈ کرنے کی
    .accesskey = ز

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = فائل ہٹائیں

downloads-cmd-remove-file-panel =
    .aria-label = فائل ہٹائیں

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = فائل ہٹائیں یا ڈاؤن لوڈ اجازت دیں

downloads-cmd-choose-unblock-panel =
    .aria-label = فائل ہٹائیں یا ڈاؤن لوڈ اجازت دیں

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = کھولیں یا فائل ہٹائیں

downloads-cmd-choose-open-panel =
    .aria-label = کھولیں یا مسل ہٹائیں

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = مزید معلومات دکھائیں

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = فائل کھولیں

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = ڈاؤن لوڈ کی پھر کوشش کریں

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = ڈاؤن لوڈ منسوخ کریں

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = تمام ڈاؤن لوڈ دکھائیں
    .accesskey = ت

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = تفصیلات ڈاؤن لوڈ کریں

downloads-clear-downloads-button =
    .label = ڈاؤن لوڈ خالی کریں
    .tooltiptext = مکمل، منسوخ شدہ اور ناکام ڈاؤن لوڈ کریں ہٹاتا ہے

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = کوئی ڈاؤن لوڈ نہیں ہیں۔

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = اس سیشن کے لیئے کوئی ڈاؤن لوڈ نہیں۔
