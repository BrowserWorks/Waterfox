# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = ဆွဲယူထားသည့်ဖိုင်များ
downloads-panel =
    .aria-label = ဆွဲယူထားသည့်ဖိုင်များ

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch
downloads-cmd-pause =
    .label = ခေတ္တရပ်တန့်ပါ
    .accesskey = P
downloads-cmd-resume =
    .label = ဆက်လက်ဆောင်ရွက်ပါ
    .accesskey = R
downloads-cmd-cancel =
    .tooltiptext = မလုပ်ဆောင်တော့ပါ
downloads-cmd-cancel-panel =
    .aria-label = မလုပ်ဆောင်တော့ပါ
# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = ဖိုင်ရှိသည့်နေရာကို ဖွင့်ရန်
    .accesskey = F
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = ရှာဖွေကိရိယာတွင် ဖေါ်ပြပါ
    .accesskey = F
downloads-cmd-use-system-default =
    .label = System Viewer ကိုဖွင့်ပါ
    .accesskey = V
downloads-cmd-always-use-system-default =
    .label = အမြဲတမ်း System Viewer ကိုဖွင့်ပါ
    .accesskey = w
downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] ရှာဖွေကိရိယာတွင် ဖေါ်ပြပါ
           *[other] ဖိုင်ရှိသည့်နေရာကို ဖွင့်ရန်
        }
downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] ရှာဖွေကိရိယာတွင် ဖေါ်ပြပါ
           *[other] ဖိုင်ရှိသည့်နေရာကို ဖွင့်ရန်
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] ရှာဖွေကိရိယာတွင် ဖေါ်ပြပါ
           *[other] ဖိုင်ရှိသည့်နေရာကို ဖွင့်ရန်
        }
downloads-cmd-show-downloads =
    .label = ဆွဲချချက်များ ထားသိုရာဖိုင်တွဲကို ပြပါ
downloads-cmd-retry =
    .tooltiptext = ထပ်မံဆောင်ရွက်ကြည့်ပါ
downloads-cmd-retry-panel =
    .aria-label = ထပ်မံဆောင်ရွက်ကြည့်ပါ
downloads-cmd-go-to-download-page =
    .label = ဆွဲယူရမည့် စာမျက်နှာသို့ သွားပါ
    .accesskey = G
downloads-cmd-copy-download-link =
    .label = ဆွဲယူရမည့်လင့်ခ်ကို ကူးယူပါ
    .accesskey = L
downloads-cmd-remove-from-history =
    .label = မှတ်တမ်းမှ ဖယ်ရှားပါ
    .accesskey = e
downloads-cmd-clear-list =
    .label = အစမ်းကြည့်ပန်နယ်ကို ရှင်းလင်းပါ
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = ဆွဲယူထားသည့်ဖိုင်များကို ရှင်းလင်းပါ
    .accesskey = D
# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = ဆွဲချယူခွင့်ပြုပါ
    .accesskey = o
# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = ဖိုင်ကို ဖျက်ရန်
downloads-cmd-remove-file-panel =
    .aria-label = ဖိုင်ကို ဖျက်ရန်
# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = ဖိုင်ကို ဖယ်ရှားပါ သို့မဟုတ် ဆွဲချယူခွင့်ပြုပါ
downloads-cmd-choose-unblock-panel =
    .aria-label = ဖိုင်ကို ဖယ်ရှားပါ သို့မဟုတ် ဆွဲချယူခွင့်ပြုပါ
# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = ဖိုင်ကို ဖွင့်ပါ သို့မဟုတ် ဖယ်ရှားပါ
downloads-cmd-choose-open-panel =
    .aria-label = ဖိုင်ကို ဖွင့်ပါ သို့မဟုတ် ဖယ်ရှားပါ
# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = နောက်ထပ် ထပ်ပြပါ
# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = ဖိုင်ကို ဖွင့်ရန်
# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = ဆွဲယူမှုကို ပြန်လည်စတင်ဆောင်ရွက်ရန်
# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = ဆွဲယူမှုကို ဖျက်သိမ်းပါ
# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = ဆွဲယူထားသည့်ဖိုင်အားလုံးကို ပြပါ
    .accesskey = S
# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = ဆွဲယူထားသည့်ဖိုင်အသေးစိတ်
downloads-clear-downloads-button =
    .label = ဆွဲယူထားသည့်ဖိုင်များကို ရှင်းလင်းပါ
    .tooltiptext = ဆွဲယူပြီးသောဖိုင်များ၊ မဆွဲယူတော့သောဖိုင်များနှင့် ဆွဲယူမှုမအောင်မြင်သောဖိုင်များကို ရှင်းလင်းပါ
# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = ဆွဲယူထားသည့်ဖိုင်များ မရှိပါ။
# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = လောလောဆယ် ဒေါင်းထားသော ဖိုင်များ မရှိ
