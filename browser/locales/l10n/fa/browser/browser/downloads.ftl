# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = بارگیری‌ها
downloads-panel =
    .aria-label = بارگیری‌ها

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = مکث
    .accesskey = P
downloads-cmd-resume =
    .label = ازسرگیری
    .accesskey = س
downloads-cmd-cancel =
    .tooltiptext = انصراف
downloads-cmd-cancel-panel =
    .aria-label = انصراف

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = باز کردن پوشهٔ محتوی پرونده
    .accesskey = پ

# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = نمایش در یابنده
    .accesskey = ی

downloads-cmd-use-system-default =
    .label = باز کردن در نمایشگر سامانه (V)
    .accesskey = V

downloads-cmd-always-use-system-default =
    .label = باز کردن همیشگی در نمایشگر سامانه (w)
    .accesskey = w

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] نمایش در یابنده
           *[other] باز کردن پوشهٔ محتوی پرونده
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] نمایش در یابنده
           *[other] باز کردن پوشهٔ محتوی پرونده
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] نمایش در یابنده
           *[other] باز کردن پوشهٔ محتوی پرونده
        }

downloads-cmd-show-downloads =
    .label = باز کردن پوشه بارگیری‌ها
downloads-cmd-retry =
    .tooltiptext = کوشش دوباره
downloads-cmd-retry-panel =
    .aria-label = کوشش دوباره
downloads-cmd-go-to-download-page =
    .label = رفتن به صفحه بارگیری
    .accesskey = ر
downloads-cmd-copy-download-link =
    .label = رونوشت برداشتن از پیوند بارگیری
    .accesskey = ش
downloads-cmd-remove-from-history =
    .label = حذف از تاریخچه
    .accesskey = ح
downloads-cmd-clear-list =
    .label = پاک کردن تابلو پیش‌نمایش
    .accesskey = پ
downloads-cmd-clear-downloads =
    .label = پاک کردن دانلودها
    .accesskey = د

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = َِاجازه بارگیری
    .accesskey = ا

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = حذف فایل

downloads-cmd-remove-file-panel =
    .aria-label = حذف فایل

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = حذف پرونده یا اجازه بارگیری

downloads-cmd-choose-unblock-panel =
    .aria-label = حذف پرونده یا اجازه بارگیری

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = بازکردن یا حذف پرونده

downloads-cmd-choose-open-panel =
    .aria-label = بازکردن یا حذف پرونده

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = نمایش اطلاعات بیشتر

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = بازکردن پرونده

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = بارگیری مجدد

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = لغو بارگیری

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = نمایش همهٔ دریافت‌ها
    .accesskey = S

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = دریافت جزئیات

downloads-clear-downloads-button =
    .label = پاک کردن دریافتی ها
    .tooltiptext = دانلودهای کامل شده و صرف نظر شده و شکست خورده را پاک میکند

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = هیچ دانلودی پیدا نشد.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = دریافت‌هایی برای این جلسه وجود ندارد.
