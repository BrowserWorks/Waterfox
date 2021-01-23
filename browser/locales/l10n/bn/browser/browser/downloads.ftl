# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = ডাউনলোড
downloads-panel =
    .aria-label = ডাউনলোড

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of 
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = বিরতি
    .accesskey = P
downloads-cmd-resume =
    .label = পুনরায় শুরু করা
    .accesskey = R
downloads-cmd-cancel =
    .tooltiptext = বাতিল
downloads-cmd-cancel-panel =
    .aria-label = বাতিল

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = ধারণকারী ফোল্ডার খুলুন
    .accesskey = F
  
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = ফাইন্ডারে প্রদর্শন F
    .accesskey = F

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] ফাইন্ডারে প্রদর্শন F
           *[other] ধারণকারী ফোল্ডার খুলুন
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] ফাইন্ডারে প্রদর্শন F
           *[other] ধারণকারী ফোল্ডার খুলুন
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] ফাইন্ডারে প্রদর্শন F
           *[other] ধারণকারী ফোল্ডার খুলুন
        }

downloads-cmd-show-downloads =
    .label = ডাউনলোড ফোল্ডার দেখাও
downloads-cmd-retry =
    .tooltiptext = পুনরায় চেষ্টা করুন
downloads-cmd-retry-panel =
    .aria-label = পুনরায় চেষ্টা করুন
downloads-cmd-go-to-download-page =
    .label = ডাউনলোড পাতা যাও
    .accesskey = G
downloads-cmd-copy-download-link =
    .label = ডাউনলোড লিঙ্ক অনুলিপি
    .accesskey = L
downloads-cmd-remove-from-history =
    .label = তালিকা থেকে অপসারণ e
    .accesskey = e
downloads-cmd-clear-list =
    .label = প্রাকপদর্শন প্যানেল পরিষ্কার করুন
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = ডাউনলোড অপসারণ
    .accesskey = D

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = ডাউনলোড অনুমোদন
    .accesskey = o

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = ফাইল সরিয়ে ফেলুন

downloads-cmd-remove-file-panel =
    .aria-label = ফাইল সরিয়ে ফেলুন

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = ফাইল মুছে ফেলুন বা ডাউনলোডের অনুমতি দিন

downloads-cmd-choose-unblock-panel =
    .aria-label = ফাইল মুছে ফেলুন বা ডাউনলোডের অনুমতি দিন

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = ফাইলটি খুলুন বা মুছে ফেলুন

downloads-cmd-choose-open-panel =
    .aria-label = ফাইলটি খুলুন বা মুছে ফেলুন

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = আরও তথ্য প্রদর্শন করো

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = ফাইল খুলুন

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = পুনরায় ডাউনলোড করুন

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = ডাউনলোড বাতিল করুন

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = সমস্ত ডাউনলোড প্রদর্শন করুন S
    .accesskey = S

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = বিস্তারিত ডাউনলোড করুন

downloads-clear-downloads-button =
    .label = ডাউনলোড অপসারণ
    .tooltiptext = সম্পন্ন,বাতিলকৃত এবং ব্যর্থ ডাউনলোডগুলো মুছুন

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = কোন ডাউনলোড নেই।

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = এই সেশনের জন্য কোন ডাউনলোড নেই।
