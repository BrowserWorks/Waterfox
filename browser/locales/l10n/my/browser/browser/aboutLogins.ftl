# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = အကောင့်ဝင်ရောက်မှုနှင့် စကားဝှက်များ

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = နေရာတိုင်း မှာ သင်၏ စကားဝှက် ကို ယူလိုက်ပါ
login-app-promo-subtitle = { -lockwise-brand-name } အပလီကေးရှင်းကို အခမဲ့ ရယူလိုက်ပါ
login-app-promo-android =
    .alt = Google Play မှ ရယူရန်
login-app-promo-apple =
    .alt = App Store မှ ဆွဲယူရန်
login-filter =
    .placeholder = လော့ဂ်အင် များ ရှာရန်
create-login-button = လော့ဂ်အင် အသစ် ဖန်တီးရန်
fxaccounts-sign-in-text = သင် ၏ အခြား ကိရိယာ များမှ စကားဝှက်ကိုရယူပါ
fxaccounts-sign-in-button = { -sync-brand-short-name } သို့ လက်မှတ်ထိုးဝင်ပါ
fxaccounts-avatar-button =
    .title = အကောင့် စီမံရေးရာ

## The ⋯ menu that is in the top corner of the page

menu =
    .title = မီနူးကို ဖွင့်ရန်
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = အခြား ဘရောင်ဇာ မှ တင်သွင်းရန်...
about-logins-menu-menuitem-import-from-a-file = ဖိုင်မှ တင်သွင်းရန်...
about-logins-menu-menuitem-export-logins = ဝင်ရောက်မှုများ ထုတ်ပို့ရန်...
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] ရွေးချယ်စရာများ
       *[other] အပြင်အဆင်များ
    }
about-logins-menu-menuitem-help = အကူအညီ
menu-menuitem-android-app = Android အတွက် { -lockwise-brand-short-name }
menu-menuitem-iphone-app = iPhone နှင့် iPad တို့ အတွက် { -lockwise-brand-short-name }

## Login List

login-list =
    .aria-label = ရှာဖွေသော စကားလုံး နှင့် တူညီ သည့် လော့ဂ်အင်များ
login-list-count =
    { $count ->
       *[other] လော့ဂ်အင် { $count } ခု
    }
login-list-sort-label-text = ဖြင့် စဥ်ရန်:
login-list-name-option = အမည် (က - အ)
login-list-name-reverse-option = အမည်( အ-က)
about-logins-login-list-alerts-option = သတိပေးချက်
login-list-last-changed-option = နောက်ဆုံး ပြုပြင်ထားမှုများ
login-list-last-used-option = နောက်ဆုံး သုံးထား‌သော
login-list-intro-title = လော့အင် မတွေ့သည်များ
login-list-intro-description = { -brand-product-name } တွင် စကားဝှက်တစ်ခု သိမ်းလိုက်ပါက ဒီနေရာတွင် ဖော်ပြပါမည်။
about-logins-login-list-empty-search-title = လော့အင် မတွေ့သည်များ
about-logins-login-list-empty-search-description = သင် ရှာလိုသည် နှင့် ကိုက်ညီသော ရလဒ် မရှိပါ။
login-list-item-title-new-login = လော့အင် အသစ်
login-list-item-subtitle-new-login = သင် ၏ အထောက်အထား လော့အင် ကို ရိုက်သွင်းပါ
login-list-item-subtitle-missing-username = (အသုံးပြုသူအမည် မရှိ)
about-logins-list-item-breach-icon =
    .title = ချိုးဖောက်ခံရသောဝက်ဘ်ဆိုက်
about-logins-list-item-vulnerable-password-icon =
    .title = အားနည်းသော စကားဝှက်

## Introduction screen

login-intro-heading = သိမ်းထားတဲ့ လော့အင်တွေ ရှာနေပါသလား? { -sync-brand-short-name } ကို စတင်လိုက်ပါ။
about-logins-login-intro-heading-logged-in = ထပ်တူပွားထားသည့် လော့အင်များ မတွေ့ပါ။
login-intro-description = အကယ်၍ သင် သည် အခြားစက်ကိရိယာ ၏ { -brand-product-name } တွင် လော့အင်များ သိမ်းထားလျှင် ၎င်း တို့ကို ဤနေရာသို့ မည်သို့ ရောက်အောင် ယူရမည်ကို ဤတွင် ရှု့း
login-intro-instruction-fxa = သင် လော့အင်များ သိမ်းထားသော ကိရိယာပေါ်က { -fxaccount-brand-name } တွင် သင့်အကောင့်ကို တည်ဆောက်  ခြင်း သို့မဟုတ် ဝင်ရောက်ပါ
login-intro-instruction-fxa-settings = { -sync-brand-short-name } ဆက်တင် ရှိ လော့အင်များ ကို အမှန်ချစ် ရွေ;ပြီးတာ သေခြာပါစေ
about-logins-intro-instruction-help = အကူအညီ ထပ်မံလိုအပ်ပါက <a data-l10n-name="help-link"> { -lockwise-brand-short-name } ပံ့ပိုးမှု </a> ကိုသွားကြည့်ပါ။

## Login

login-item-new-login-title = လော့အင် အသစ်ဖန်တီးပါ
login-item-edit-button = တည်းဖြတ်
about-logins-login-item-remove-button = ဖယ်ရှား
login-item-origin-label = ဝဘ်ဆိုက်လိပ်စာ
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = အသုံးပြုသူ အမည်
about-logins-login-item-username =
    .placeholder = (အသုံးပြုသူအမည် မရှိပါ)
login-item-copy-username-button-text = ကူးယူပါ
login-item-copied-username-button-text = ကူးပြီးပြီ
login-item-password-label = စကားဝှက်
login-item-password-reveal-checkbox =
    .aria-label = စကားဝှက် ပြ
login-item-copy-password-button-text = ကူးယူပါ
login-item-copied-password-button-text = ကူးပြီးပြီ
login-item-save-changes-button = ပြောင်းလဲမှုများကို သိမ်းပါ
login-item-save-new-button = သိမ်းရန်
login-item-cancel-button = ပယ်​ဖျက်ပါ
login-item-time-changed = နောက်ဆုံးပြုပြင်ခဲ့သည်မှာ : { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = ဖန်တီးခဲ့သည်မှာ :{ DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = သင်၏ ဝင်ရောက်မှတ်စု ကို ပြင်ဆင်ရန် သင် ၏ Windows ဝင်ရောက်မှု အထောက်အထား ကိုရိုက်ထည့်ပေးပါ။ ဒါက သင့် အကောင့် လုံခြုံရေး ဆိုင်ရာအကာအကွယ် အဖြစ် ကူညီပါလိမ့်မည်။
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = သိမ်းထားသော ဝင်ရောက်မှု ကိုပြင်ဆင်ရန်
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = သိမ်းဆည်းထားသောစကားဝှက်ကိုထုတ်ဖေါ်ပါ
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = သိမ်းဆည်းထားသောစကားဝှက်ကိုကူးယူပါ

## Master Password notification

master-password-notification-message = သိမ်းဆည်းထားသည့် လော့အင် နှင့် စကားဝှက်များ ကြည့်ရန် အဓိက စကားဝှက် ကိုရိုက်ထည့်ပါ
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = သိမ်းဆည်းထားသောဝင်ရောက်မှုများ နှင့် စကားဝှက်များကို ထုတ်ပို့ရန်

## Primary Password notification

master-password-reload-button =
    .label = လော့အင်
    .accesskey = လ

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] သင် { -brand-product-name } ကို နေရာစုံမှာ သုံးလိုသလား? သင့်{ -sync-brand-short-name } ရွေးချယ်စရာများ က လော့အင်များ ကို အမှန်ခြစ်ပါ။
       *[other] သင် { -brand-product-name } ကို နေရာစုံမှာ သုံးလိုသလား? သင့်{ -sync-brand-short-name } ရဲ့ အပြင်အဆင် က လော့အင်များ ကို အမှန်ခြစ်ပါ။
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] { -sync-brand-short-name } ၏ ရွေးချယ်စရာများ သို့သွား
           *[other] { -sync-brand-short-name } ၏ အပြင်အဆင်များ သို့ သွား
        }
    .accesskey = သ

## Dialogs

confirmation-dialog-cancel-button = ပယ်ဖျက်
confirmation-dialog-dismiss-button =
    .title = ပယ်ဖျက်
about-logins-confirm-remove-dialog-title = ဤ ဝင်ရောက်မှု ကို ဖယ်ရှားမှာလား။
about-logins-confirm-remove-dialog-confirm-button = ဖယ်ရှားပါ
about-logins-confirm-export-dialog-title = ဝင်ရောက်မှုများ နှင့် စကားဝှက်များကို ထုတ်ပို့ရန်
about-logins-confirm-export-dialog-confirm-button = ထုတ်ပို့...
confirm-discard-changes-dialog-title = မသိမ်းရသောသော ပြောင်းလဲမှုများကို ပယ်ဖျက်မှာလား?
confirm-discard-changes-dialog-message = မသိမ်းဆည်းရသေးသော အပြောင်းအလဲများအားလုံး ပျောက်ဆုံးပါလိမ့်မည်။
confirm-discard-changes-dialog-confirm-button = ပယ်ဖျက်

## Breach Alert notification

about-logins-breach-alert-title = ကျိုးပေါက် ဝဘ်ဆိုက်
breach-alert-text = ဤ ဝက်ဘ်ဆိုက် တွင် သင်နောက်ဆုံး လော့အင် အသေစိတ် ကို ပြင်ဆင်ပြီးပြီးနောက်ပိုင်း မှ စကားဝှက်များ ပေါက်ကြားခြင်း သို့မဟုတ် အခိုးခံရခြင်း ဖြစ်ပေါ်ခဲ့သည်။ သင့် စကားဝှက် ကို ပြောင်းပြီး သင့် အကောင့်ကို ကာကွယ်ပါ။
about-logins-breach-alert-date = ဤ ကျိုးပေါက်မှု သည် { DATETIME($date, day: "numeric", month: "long", year: "numeric") } တွင်ဖြစ်ပွားခဲ့သည်
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = { $hostname } သို့ သွားရန်
about-logins-breach-alert-learn-more-link = ပိုမို လေ့လာရန်

## Vulnerable Password notification

about-logins-vulnerable-alert-title = အားနည်းသော စကားဝှက်
about-logins-vulnerable-alert-text2 = ဤ စကားဝှက် ကို အချက်အလက်ချိုးဖောက် မှု ခံရနိူင် သည့် အခြားအကောင့် အသုံးပြုထားသည်။ အချက်အလက် များ ကို ပြန်လည်အသုံးပြုခြင်းသည် သင်၏အကောင့်များ အားလုံးအတွက်ပါ အန္တရာယ်ရှိသည်။ ဒီ စကားဝှက်ကို ပြောင်းပါ။
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = { $hostname } သို့ သွားရန်
about-logins-vulnerable-alert-learn-more-link = ပိုမို လေ့လာရန်

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = { $loginTitle } အတွက် ဖြည့်သွင်းမှု့ မှာ အသုံးပြုသူအမည် သည် ရှိပြီးသာဖြစ်သည်။ <a data-l10n-name="duplicate-link">ရှိပြီးသား ဖြည့်သွင်းမှု့ ဆီ သွားမလား?</a>
# This is a generic error message.
about-logins-error-message-default = ဤ စကားဝှက်ကို သိမ်းရန် ကြိုးစားစဉ်အမှား ဖြစ်ခဲ့သည်။

## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = ဝင်ရောက်မှု ဖိုင်များ ထုတ်ပို့ရန်
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = ဝင်ရောက်မှုဖိုင်.csv
about-logins-export-file-picker-export-button = ထုတ်ပို့ရန်
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV မှတ်တမ်းစာရွက်
       *[other] CSV ဖိုင်
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = ဝင်ရောက်မှု ဖိုင် တင်သွင်းရန်
about-logins-import-file-picker-import-button = တင်သွင်း
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV မှတ်တမ်းစာရွက်
       *[other] CSV ဖိုင်
    }
