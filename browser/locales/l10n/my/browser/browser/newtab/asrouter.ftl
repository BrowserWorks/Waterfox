# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = အကြံပြုထားသော တိုးချဲ့ချက်
cfr-doorhanger-feature-heading = အကြံပြုထားသော လုပ်ဆောင်နိုင်မှုများ
cfr-doorhanger-pintab-heading = ဒါကိုစမ်းကြည့်ပါ: Tab ကို Pin လုပ်ပါ

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = ဘာကြောင့် မြင်ရပါသနည်း
cfr-doorhanger-extension-cancel-button = ယခု မဟုတ်သေးပါ
    .accesskey = N
cfr-doorhanger-extension-ok-button = ယခုပင်ထည့်ပါ
    .accesskey = A
cfr-doorhanger-pintab-ok-button = ဒီတပ်ဗ်ကို ချိတ်ထားပါ
    .accesskey = P
cfr-doorhanger-extension-manage-settings-button = အကြံပြုချက်နှင့်ဆိုင်သည့်အပြင်အဆင်များစီမံပါ
    .accesskey = M
cfr-doorhanger-extension-never-show-recommendation = ဒီအကြံပြုချက်ကိုမပြပါနှင့်
    .accesskey = S
cfr-doorhanger-extension-learn-more-link = ပိုမိုလေ့လာရန်
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = { $name } အားဖြင့်
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = အကြံပြုချက်
cfr-doorhanger-extension-notification2 = အကြံပြုချက်
    .tooltiptext = အပိုနောက်တွဲ အကြံပြုချက်
    .a11y-announcement = အပိုနောက်တွဲ အကြံပြုချက် ရပြီ
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = အကြံပြုချက်
    .tooltiptext = စွမ်းရည် အကြံပြုချက်
    .a11y-announcement = စွမ်းရည် အကြံပြုချက် ရပြီ

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
           *[other] ကြယ် { $total } ပွင့်
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
       *[other] သုံးစွဲသူ { $total } ယောက်
    }
cfr-doorhanger-pintab-description = သင်အသုံးပြုအများဆုံးဆိုက်ဒ်များကိုလွယ်ကူစွာဝင်ရောက်ပါ။ (သင်ဖွင့်ပြီးပြန်ပိတ်သည့်တိုင်အောင်) ဆိုက်ဒ်များကိုဖွင့်ထားပါ။

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = သင်ချိတ်ချင်တဲ့တက်ဗ်ပေါ်မှာ <b>ညာဘက်ခလုပ်နှိပ်လိုက်ပါ</b>။
cfr-doorhanger-pintab-step2 = စာရင်းမှ <b>ချိတ်ထားတဲ့တပ်ဗ်</b> ကိုရွေးချယ်ပါ။
cfr-doorhanger-pintab-step3 = ဆိုက်ဒ်ကပြောင်းလဲမှုရှိလျှင်သင်ချိတ်ထားတဲ့တပ်ဗ်တွင်အပြာရောင်အစက်ကလေးပေါ်လာလိမ့်မည်။
cfr-doorhanger-pintab-animation-pause = ရပ်တန့်ပါ
cfr-doorhanger-pintab-animation-resume = ဆက်လက်ဆောင်ရွက်ပါ

## Firefox Accounts Message


## Protections panel


## What's New toolbar button and panel

cfr-whatsnew-button =
    .label = ဘာထူးလဲ
    .tooltiptext = ဘာထူးလဲ
cfr-whatsnew-panel-header = ဘာထူးလဲ
cfr-whatsnew-release-notes-link-text = ထုတ်ပြန်ချက်မှတ်စုများကိုဖတ်ပါ
cfr-whatsnew-tracking-protect-title = ခြေရာခံများမှသင့်ကိုယ်သင်ကာကွယ်ပါ
cfr-whatsnew-tracking-blocked-link-text = အစီရင်ခံစာကြည့်ပါ
cfr-whatsnew-lockwise-backup-title = သင်၏စကားဝှက်များကိုသိမ်းဆည်းပါ
cfr-whatsnew-lockwise-backup-link-text = အရန်ကူးခြင်းများကိုဖွင့်ပါ
cfr-whatsnew-lockwise-take-title = သင့်စကားဝှက်ကိုသင့်နဲ့အတူ ခေါ်ဆောင်သွားပါ
cfr-whatsnew-lockwise-take-link-text = အက်ပ်ကို ရယူပါ

## Search Bar


## Picture-in-Picture

cfr-whatsnew-pip-cta = ပိုမိုလေ့လာရန်

## Permission Prompt

cfr-whatsnew-permission-prompt-cta = ပိုမိုလေ့လာရန်

## Fingerprinter Counter

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = လက်ဗွေများ

## Bookmark Sync


## Login Sync

cfr-doorhanger-sync-logins-header = စကားဝှက်ကိုဘယ်တော့မှမဆုံးရှုံးရ

## Send Tab

cfr-doorhanger-send-tab-header = ဒီကိုဖတ်ပါ
cfr-doorhanger-send-tab-ok-button = Send Tabဖွင့်ပါ
    .accesskey = T

## Firefox Send

cfr-doorhanger-firefox-send-ok-button = { -send-brand-name } စမ်းကြည့်ပါ
    .accesskey = T

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = ကာကွယ်မှုကိုကြည့်ပါ
    .accesskey = P
cfr-doorhanger-socialtracking-close-button = ပိတ်ပါ
    .accesskey = C

## Enhanced Tracking Protection Milestones

cfr-doorhanger-milestone-ok-button = အားလုံးကိုကြည့်ပါ
    .accesskey = s

## What’s New Panel Content for Firefox 76


## Lockwise message


## Vulnerable Passwords message


## Picture-in-Picture fullscreen message


## Protections Dashboard message


## Better PDF message


## DOH Message

cfr-doorhanger-doh-primary-button = ကောင်းပြီ၊ ရပါပြီ
    .accesskey = O
cfr-doorhanger-doh-secondary-button = ပိတ်ထားသည်
    .accesskey = D

## What's new: Cookies message

