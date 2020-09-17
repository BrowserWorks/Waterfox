# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = ၀က်ဆိုက်များအား "နောက်ခံမလိုက်"  အချက်ပြပြီး သင့်အား နောက်လိုက် စုံစမ်း ခြင်း ရပ်တန့် ရန် ပြောပါ
do-not-track-learn-more = ဆက်လက် လေ့လာပါ
do-not-track-option-always =
    .label = အမြဲတမ်း
pref-page-title =
    { PLATFORM() ->
        [windows] ရွေးစရာများ
       *[other] နှစ်သက်ရာ အပြင်အဆင်များ
    }
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 15.4em
    .placeholder =
        { PLATFORM() ->
            [windows] ရွေးစရာများထဲမှ ရှာပါ
           *[other] နှစ်သက်ရာအပြင်အဆင်များထဲမှ ရှာပါ
        }
pane-general-title = အထွေထွေ
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = အဖွင့်စာမျက်နှာ
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = ရှာပါ
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = ကိုယ်ရေးကာကွယ်မှု နှင့် လုံခြုံရေး
category-privacy =
    .tooltiptext = { pane-privacy-title }
help-button-label = { -brand-short-name } အထောက်အပံ့
addons-button-label = တိုးချဲ့မှုနှင့် အပြင်အဆင်များ
focus-search =
    .key = f
close-button =
    .aria-label = ပိတ်ပါ

## Browser Restart Dialog

feature-enable-requires-restart = ယခု လုပ်ဆောင်ချက်ကို အသုံးပြုရန် { -brand-short-name } ကို ပြန်ဖွင့်ရမည်။
feature-disable-requires-restart = ယခု လုပ်ဆောင်ချက်ကို ပိတ်ရန် { -brand-short-name } ကို ပြန်ဖွင့်ရမည်။
should-restart-title = { -brand-short-name } ကို ပြန်ဖွင့်ပါ
should-restart-ok = ယခုပင် { -brand-short-name } ကို ပြန်လည်စတင်ပါ
cancel-no-restart-button = မလုပ်တော့
restart-later = နောက်မှ ပြန်ဖွင့်ပါ

## Extension Control Notifications
##
## These strings are used to inform the user
## about changes made by extensions to browser settings.
##
## <img data-l10n-name="icon"/> is going to be replaced by the extension icon.
##
## Variables:
##   $name (String): name of the extension

# This string is shown to notify the user that their home page
# is being controlled by an extension.
extension-controlled-homepage-override = ပေါင်းထည့်ဆော့ဖ်ဝဲ <img data-l10n-name="icon"/>{ $name } သည် အဖွင့်စာမျက်နှာကို ထိန်းချုပ်နေသည်။
# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = ပေါင်းထည့်ဆောဖ့်ဝဲ <img data-l10n-name="icon"/>{ $name } သည် တပ်ဗ်အသစ်တွင် ဖွင့်ထားသော စာမျက်နှာကို ထိန်းချုပ်နေသည်။
# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = ပေါင်းထည့်ဆော့ဖ်ဝဲ <img data-l10n-name="icon"/>{ $name } သည် မူသေရှာဖွေရေးယန္တရားကို သတ်မှတ်ထားသည်။
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = ပေါင်းထည့်ဆော့ဖ်ဝဲ <img data-l10n-name="icon"/>{ $name } သည် ကွန်တန်နာတပ်ဗ်ကို လိုအပ်သည်။
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = ပေါင်းထည့်ဆော့ဖ်ဝဲ <img data-l10n-name="icon"/>{ $name } သည် { -brand-short-name } ၏ အင်တာနက်ချိတ်ဆက်ပုံကို ထိန်းချုပ်နေသည်။
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = ပေါင်းထည့်ဆော့ဖ်ဝဲကို အသုံးပြုရန် <img data-l10n-name="menu-icon"/> ထဲမှ <img data-l10n-name="addons-icon"/> သို့ သွားပါ။

## Preferences UI Search Results

search-results-header = ရှာဖွေမှု ရလဒ်များ
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] ဝမ်းနည်းပါတယ်။ အပြင်အဆင်များထဲတွင် “<span data-l10n-name="query"></span>” အတွက် ရလဒ်များ မရှိပါ။
       *[other] ဝမ်းနည်းပါတယ်။ နှစ်သက်ရာအပြင်အဆင်များထဲတွင် “<span data-l10n-name="query"></span>” အတွက် ရလဒ်များ မရှိပါ။
    }
search-results-help-link = အကူအညီ လိုပါသလား။ <a data-l10n-name="url">{ -brand-short-name } အထောက်အပံ့</a> တွင် ကြည့်ရှုပါ

## General Section

startup-header = စတင်ခြင်း
# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = { -brand-short-name } နှင့် Firefox တို့ကို တစ်ချိန်တည်းတွင် လုပ်ငန်းဆောင်ရွက်ခွင့် ပြုပါ
use-firefox-sync = အရိပ်အမြွက်၊ မတူညီသည့် ပရိုဖိုင်းများကို အသုံးပြုပါသည်။ ထိုပရိုဖိုင်းများကြား အချက်အလက်မျှဝေရန် { -sync-brand-short-name } ကို အသုံးပြုပါ။
get-started-not-logged-in = { -sync-brand-short-name } သို့ ဝင်ပါ…
get-started-configured = { -sync-brand-short-name } ၏ အပြင်အဆင်များကို ဖွင့်ပါ
always-check-default =
    .label = { -brand-short-name } သည် ပုံသေဘရောင်ဇာ ဟုတ်/မဟုတ် အမြဲစစ်ဆေးပါ
    .accesskey = y
is-default = { -brand-short-name } သည် လက်ရှိတွင် ပုံသေဘရောက်ဇာ ဖြစ်ပါသည်
is-not-default = { -brand-short-name } သည် ပုံသေဘရောက်ဇာ ဖြစ်မနေပါ
set-as-my-default-browser =
    .label = စံသတ်မှတ်...
    .accesskey = D
startup-restore-previous-session =
    .label = ယခင်အသုံးပြုခဲ့သည်များကို ပြန်ဖွင့်ပါ
    .accesskey = s
startup-restore-warn-on-quit =
    .label = ဘရောက်ဇာပိတ်လျှင်အသိပေးပါ
disable-extension =
    .label = တိုးချဲ့မှု အားပိတ်ထားပါ
tabs-group-header = တပ်ဗ်များ
ctrl-tab-recently-used-order =
    .label = Ctrl+tab သည် အရင်သုံးခဲ့ဖူးသည့် တပ်ဗ်များကို အစဉ်လိုက် ပြောင်းပေးသွားမည်
    .accesskey = T
open-new-link-as-tabs =
    .label = လင့်ခ်များကို ဝင်းဒိုးများတွင်ဖွင့်မည့်အစား တပ်ဗ်ထဲတွင် ဖွင့်ပါ
    .accesskey = W
warn-on-close-multiple-tabs =
    .label = တပ်ဗ်အများကြီးကို ပိတ်ပါက သတိပေးပါ
    .accesskey = m
warn-on-open-many-tabs =
    .label = { -brand-short-name } အား နှေးသွားစေမည် တပ်ဗ်အများကြီးအား ဖွင့်ပါ ကသတိပေးပါ
    .accesskey = d
switch-links-to-new-tabs =
    .label = တပ်ဗ်တစ်ခုဖြင့် လင်ခ့်တစ်ခုအား ဖွင့်ပါ ၎င်းဆီသိုချက်ခြင်းပြောင်းပါ
    .accesskey = h
show-tabs-in-taskbar =
    .label = ဝင်းဒိုး တက်စ်ဘားတွင် တပ်ဗ်အကြိုမြင်ကွင်းကို ပြပါ
    .accesskey = k
browser-containers-enabled =
    .label = ကွန်တိန်နာတပ်ဗ်များအသုံးပြုခြင်းကို ဖွင့်ရန်
    .accesskey = n
browser-containers-learn-more = ပိုမိုလေ့လာရန်
browser-containers-settings =
    .label = အပြင်အဆင်များ…
    .accesskey = i
containers-disable-alert-title = ကွန်တိန်နာတပ်ဗ်အားလုံးကို ပိတ်ပါမည်လား။
containers-disable-alert-desc = ယခု ကွန်တိန်နာတပ်ဗ်များ အသုံးပြုခြင်းကို ပိတ်မည်ဆိုပါက ကွန်တိန်နာတပ်ဗ် { $tabCount } ခုသည် ပိတ်သွားပါလိမ့်မည်။ ထိုသို့ အသုံးပြုခြင်းကို ပိတ်မည်မှာ သေချာပါသလား။
containers-disable-alert-ok-button = ကွန်တိန်နာတပ်ဗ် { $tabCount } ခုကို ပိတ်ရန်
containers-disable-alert-cancel-button = ဆက်လက်ဖွင့်ထားသည်
containers-remove-alert-title = ယခုကွန်တိုင်နာအား ဖယ်ပါ
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg = ယခုကွန်တိန်နာကို ဖျက်မည်ဆိုပါက ဖွင့်ထားသော ကွန်တိန်နာတပ်ဗ် { $count } ခုသည် ပိတ်သွားပါမည်။ ၎င်းတို့ကို ဖျက်မည်မှာ သေချာပါသလား။
containers-remove-ok-button = ကွန်တိုင်အား ဖယ်ပါ
containers-remove-cancel-button = ကွန်တိုင်အား မဖယ်ပါနှင့်

## General Section - Language & Appearance

language-and-appearance-header = ဘာသာစကားနှင့် အသွင်အပြင်
fonts-and-colors-header = ဖောင့်များ & အရောင်များ
default-font = မူသေ ဖောင့်
    .accesskey = D
default-font-size = အရွယ်အ​စား
    .accesskey = S
advanced-fonts =
    .label = အဆင့်မြင့်…
    .accesskey = A
colors-settings =
    .label = အရောင်များ...
    .accesskey = C
language-header = ဘာသာစကား
choose-language-description = စာမျက်နှာများကို ပြသရန် နှစ်သက်ရာဘာသာစကားကို ရွေးပါ
choose-button =
    .label = ရွေးပါ...
    .accesskey = o
manage-browser-languages-button =
    .label = အခြားရွေးစရာ သတ်မှတ်ရန်
    .accesskey = I
confirm-browser-language-change-button = သတ်မှတ်ပြီး ပြန်ဖွင့်ပါ
translate-web-pages =
    .label = ဝဘ်စာမျက်နှာရှိ အကြောင်းအရာများကို ဘာသာပြန်ပါ
    .accesskey = T
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = ဘာသာပြန်ဆိုသူ <img data-l10n-name="logo"/>
translate-exceptions =
    .label = ခြွင်းချက်များ...
    .accesskey = x
check-user-spelling =
    .label = စာရိုက်နေစဉ် စာလုံးပေါင်းများကို စစ်ဆေးပါ
    .accesskey = t

## General Section - Files and Applications

files-and-applications-title = ဖိုင်များနှင့် အက်ပလီကေးရှင်းများ
download-header = ဆွဲယူထားသည့် ဖိုင်များ
download-save-to =
    .label = ဖိုင်များကို ထိုနေရာတွင် သိမ်းရန်
    .accesskey = v
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] ရွေးပါ…
           *[other] ရှာဖွေရန်…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] e
           *[other] o
        }
download-always-ask-where =
    .label = မည်သည့်နေရာတွင် ဖိုင်သိမ်းရမည်ကိုမေးပါ
    .accesskey = A
applications-header = အက်ပလီကေးရှင်းများ
applications-description = ဝဘ်အသုံးပြုနေစဉ် ဝဘ် သို့မဟုတ် အက်ပလီကေးရှင်းများထံမှ ဆွဲယူထားသော ဖိုင်များကို { -brand-short-name } က မည်သို့ကိုင်တွယ်ရမည်ကို ရွေးပါ။
applications-filter =
    .placeholder = ဖိုင်အမျိုးအစားများ သို့မဟုတ် အက်ပလီကေးရှင်းများကို ရှာပါ
applications-type-column =
    .label = အကြောင်းအရာ အမျိုးအစား
    .accesskey = T
applications-action-column =
    .label = ဆောင်ရွက်ချက်
    .accesskey = A
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = { $extension } ဖိုင်
applications-action-save =
    .label = ဖိုင်ကို သိမ်းဆည်းပါ
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = { $app-name } ကို အသုံးပြုပါ
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = { $app-name } ကို အသုံးပြုပါ (မူလသတ်မှတ်ချက်)
applications-use-other =
    .label = အခြားအက်ပ်ကို အသုံးပြုရန်…
applications-select-helper = အကူအညီပေး အက်ပလီကေးရှင်းအားရွေးပါ
applications-manage-app =
    .label = အက်ပလီကေ:ရှင်းအသေးစိတ်...
applications-always-ask =
    .label = အမြဲမေးပါ
applications-type-pdf = သယ်ယူရလွယ်ကူသော စာတမ်းပုံစံ (PDF)
# Variables:
#   $type (String) - the MIME type (e.g application/binary)
applications-type-pdf-with-type = { applications-type-pdf } ({ $type })
# Variables:
#   $type-description (String) - Description of the type (e.g "Portable Document Format")
#   $type (String) - the MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })
# Variables:
#   $plugin-name (String) - Name of a plugin (e.g Adobe Flash)
applications-use-plugin-in =
    .label = ({ $plugin-name } တွင်) { -brand-short-name } ကို အသုံးပြုပါ

## The strings in this group are used to populate
## selected label element based on the string from
## the selected menu item.

applications-use-plugin-in-label =
    .value = { applications-use-plugin-in.label }
applications-action-save-label =
    .value = { applications-action-save.label }
applications-use-app-label =
    .value = { applications-use-app.label }
applications-always-ask-label =
    .value = { applications-always-ask.label }
applications-use-app-default-label =
    .value = { applications-use-app-default.label }
applications-use-other-label =
    .value = { applications-use-other.label }

##

drm-content-header = Digital Rights Management (DRM) အကြောင်းအရာ
play-drm-content =
    .label = DRMဖြင့်ထိန်းထားသော အကြောင်းအရာကို ဖွင့်ပါ
    .accesskey = p
play-drm-content-learn-more = ပိုမိုလေ့လာရန်
update-application-title = { -brand-short-name } မွမ်းမံမှုများ
update-application-description = အကောင်းဆုံးစွမ်းရည်၊ တည်ငြိမ်မှုနှင့် လုံခြုံရေး ရရှိစေရန် { -brand-short-name } ကို နောက်ဆုံးပေါ် ဖြစ်စေပါ။
update-application-version = ဗားရှင်း { $version } <a data-l10n-name="learn-more">ဘာအသစ်တွေပါသလဲ</a>
update-history =
    .label = မြှင့်တင်မှုမှတ်တမ်းကို ပြပါ…
    .accesskey = p
update-application-allow-description = { -brand-short-name } ကို ဆောင်ရွက်ခွင့်ပြုရန်
update-application-auto =
    .label = အဆင့်မြှင့်တင်မှုကို အလိုလျောက် ဆောင်ရွက်ပါ (အကြံပြုထားသည်)
    .accesskey = a
update-application-check-choose =
    .label = အဆင့်မြှင့်တင်မှုများ ရှိ/မရှိ စစ်ဆေးပါ၊ သို့သော် ၎င်းတို့ကို တပ်ဆင်မည်ဆိုပါက ရွေးချယ်ခွင့်ပေးပါ။
    .accesskey = C
update-application-manual =
    .label = အဆင့်မြှင့်တင်မှုများကို ဘယ်သောအခါမှ မစစ်ဆေးပါနှင့် (အကြံမပြုလိုပါ)
    .accesskey = N
update-application-use-service =
    .label = နောက်ဆုံးပေါ် ပြုပြင်မှုများကို တပ်ဆင်ပါက နောက်ကွယ်လုပ်ငန်းစဉ်ကို အသုံးပြုပါ
    .accesskey = b

## General Section - Performance

performance-title = စွမ်းဆောင်ရည်
performance-use-recommended-settings-checkbox =
    .label = အကြံပြုထားသော စွမ်းဆောင်ရည်ဆိုင်ရာ အပြင်အဆင်ကို အသုံးပြုပါ
    .accesskey = u
performance-use-recommended-settings-desc = ယခုအပြင်အဆင်များကို ကွန်ပျူတာ၏အမာထည်နှင့် လည်ပတ်စနစ်အရ သတ်မှတ်ထားခြင်း ဖြစ်သည်။
performance-settings-learn-more = ပိုမိုလေ့လာရန်
performance-allow-hw-accel =
    .label = ဖြစ်နိုင်လျှင် စက်ကိရိယာဖြင့် အရှိန်မြှင့်တင်ခြင်းကို အသုံးပြုပါ
    .accesskey = r
performance-limit-content-process-option = အကြောင်းအရာပရောဆက်အကန့်အသတ်
    .accesskey = I
performance-limit-content-process-enabled-desc = ထပ်ပေါင်း အကြောင်းအရာပရောဆက်များသည် တပ်ဗ်များကို အသုံးပြုသောအခါ စွမ်းဆောင်ရည်ကို တိုးတက်စေသော်လည်း မှတ်ဉာဏ်ကို ပိုမိုအသုံးပြုသည်။
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (မူလ သတ်မှတ်ချက်)

## General Section - Browsing

browsing-title = ကြည့်ရှုခြင်း
browsing-use-autoscroll =
    .label = အလိုအလျောက် အပေါ်အောက်ရွှေ့သည့်စနစ်ကို အသုံးပြုပါ
    .accesskey = a
browsing-use-smooth-scrolling =
    .label = ချောမောလွယ်ကူသော အပေါ်အောက်ရွှေ့သည့်စနစ်ကို အသုံးပြုပါ
    .accesskey = m
browsing-use-onscreen-keyboard =
    .label = လိုအပ်လျှင် တို့ထိကီးဘုတ်ကို ပြပါ
    .accesskey = k
browsing-use-cursor-navigation =
    .label = စာမျက်နှာအတွင်း ကူးသန်းရွှေ့ပြောင်းရန် ကာဆာခလုတ်ကို အမြဲ အသုံးပြုပါ
    .accesskey = c
browsing-search-on-start-typing =
    .label = စာစရိုက်သည်နှင့် စရှာပါ
    .accesskey = x
browsing-cfr-recommendations =
    .label = သင့်ရှာဖွေမှုတွင် တိုးချဲ့မှုများကို အကြံပေးပါ
    .accesskey = R
browsing-cfr-recommendations-learn-more = ပိုမိုလေ့လာရန်

## General Section - Proxy

network-settings-title = ကွန်ယက် အပြင်အဆင်များ
network-proxy-connection-description = အင်တာနက်နှင့် { -brand-short-name } ချိတ်ဆက်ပုံကို ပြုပြင်ပါ
network-proxy-connection-learn-more = ပိုမိုလေ့လာရန်
network-proxy-connection-settings =
    .label = အပြင်အဆင်များ...
    .accesskey = e

## Home Section

home-new-windows-tabs-header = ဝင်းဒိုးအသစ်နှင့် တပ်ဗ်အသစ်များ

## Home Section - Home Page Customization

home-homepage-mode-label = အဖွင့်စာမျက်နှာနှင့် ဝင်းဒိုးအသစ်များ
home-newtabs-mode-label = တပ်ဗ်အသစ်များ
home-restore-defaults =
    .label = မူလအတိုင်း ပြန်ထားပါ
    .accesskey = R
# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Firefox အဖွင့်စာမျက်နှာ (မူသေ)
home-mode-choice-custom =
    .label = စိတ်ကြိုက် URL များ...
home-mode-choice-blank =
    .label = စာမျက်နှာအလွတ်
home-homepage-custom-url =
    .placeholder = URL ကို ပွားယူပါ...
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] လက်ရှိစာမျက်နှာကို အသုံးပြုပါ
           *[other] လက်ရှိဖွင့်ထားသည့် စာမျက်နှာများကို အသုံးပြုပါ
        }
    .accesskey = C
choose-bookmark =
    .label = စာမှတ်ကို အသုံးပြုပါ…
    .accesskey = B

## Home Section - Firefox Home Content Customization

home-prefs-topsites-header =
    .label = ထိပ်တန်းဝဘ်ဆိုက်များ

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = { $provider } က အကြံပြုထားသည်

##

home-prefs-recommended-by-learn-more = ဘယ်လိုအလုပ်လုပ်လဲ
home-prefs-highlights-header =
    .label = ဦးစားပေးအကြောင်းအရာများ
home-prefs-highlights-option-visited-pages =
    .label = လည်ပတ်ခဲ့သည့်စာမျက်နှာများ
home-prefs-highlights-options-bookmarks =
    .label = စာမှတ်များ
home-prefs-highlights-option-most-recent-download =
    .label = လတ်တလောဆွဲချမှုများ
home-prefs-highlights-option-saved-to-pocket =
    .label = { -pocket-brand-name } တွင် သိမ်းထားသည့် စာမျက်နှာများ
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = မှတ်စုတိုများ
home-prefs-snippets-description = { -vendor-short-name } နှင့် { -brand-product-name } မှ အပ်ဒိတ်များ
home-prefs-sections-rows-option =
    .label =
        { $num ->
           *[other] { $num } တန်း
        }

## Search Section

search-bar-header = ရှာဖွေရေးဘားတန်း
search-bar-hidden =
    .label = ရှာဖွေရန်နှင့် သွားရောက်ရန် လိပ်စာဘားတန်းကို အသုံးပြုပါ
search-bar-shown =
    .label = ရှာဖွေရေးဘားတန်းကို ကိရိယာဘားတန်းသို့ ထည့်ပါ
search-engine-default-header = မူသေ ရှာဖွေရေး ယန္တရား
search-suggestions-option =
    .label = ရှာဖွေရေး အကြံပြုချက်များကို ပြပါ
    .accesskey = s
search-show-suggestions-url-bar-option =
    .label = ရှာဖွေရေးအကြံပြုချက်များကို လိပ်စာဘားတန်းရလဒ်ထဲတွင် ပြသပါ
    .accesskey = i
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = ရှာဖွေခဲ့သောစာရင်းများထဲမှ အကြံပြုချက်များကို လိပ်စာဘားတန်းရလဒ်ထဲတွင် ပြသပါ
search-suggestions-cant-show = ရှာဖွေရေးဘားတွင် ရှာဖွေမှု အကြံပြုချက်များကို ပြသမည်မဟုတ်ပါ။ မှတ်တမ်းများ မှတ်မထားရန် { -brand-short-name } ကို သတ်မှတ်ထားသောကြောင့် ဖြစ်သည်။
search-one-click-header = ကလစ် တစ်ချက်နှိပ် ရှာဖွေရေးယန္တရားများ
search-one-click-desc = ပြောင်းလဲအသုံးပြုလိုသော ရှာဖွေရေးယန္တရားကို ရွေးချယ်ပါ။ ရှာဖွေလိုသောစာလုံးကို ရိုက်နှိပ်သောအခါ ၎င်းသည် လိပ်စာဘားတန်းနှင့် ရှာဖွေရေးဘားတန်းတို့ အောက်တွင် ပေါ်လာမည်။
search-choose-engine-column =
    .label = ရှာဖွေရေးယန္တရား
search-choose-keyword-column =
    .label = သော့ချက် စာလုံး
search-restore-default =
    .label = ရှာဖွေရေးယန္တရားများကို မူလအတိုင်း ပြန်ထားပါ
    .accesskey = d
search-remove-engine =
    .label = ဖယ်ရှားပါ
    .accesskey = r
search-find-more-link = နောက်ထပ်ရှာဖွေရေးယန္တရားများကို ရှာပါ
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = သော့ချက် စာလုံး ပုံတူပွားပါ
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = လောလောဆယ် "{ $name }" သုံးစွဲနေတဲ့ သော့ချက်တခုကို သင် ရွေးထားပြီးပြီ။ အခြားကို ရွေးပါ။
search-keyword-warning-bookmark = လောလောဆယ် မှတ်သားချက်တခုက သုံးစွဲနေတဲ့ သော့ချက် တခုကို သင်​ ရွေးထားတယ်။ အခြားကို ရွေးပါ။

## Containers Section

containers-header = ကွန်တိန်နာတပ်ဗ်များ
containers-add-button =
    .label = ကွန်တိန်နာအသစ်ထပ်ထည့်ပါ
    .accesskey = A
containers-preferences-button =
    .label = အပြင်အဆင်များ
containers-remove-button =
    .label = ဖယ်ရှားပါ

## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = ဝဘ်ကို သင့်နဲ့အတူ ခေါ်ဆောင်သွားပါ
sync-signedout-description = သင့်ကိရိယာအားလုံးရှိ စာမှတ်များ၊ မှတ်တမ်း၊ စာမျက်နှာများ၊ စကားဝှက်များ၊ အတ်အွန်များနှင့် အပြင်အဆင်များကို တစ်ပြေးညီဖြစ်စေပါ။
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = ထိုစနစ်အတွက် မီးမြေခွေးကို ဆွဲယူကူးပါ၊ <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> သို့မဟုတ် <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> သင့်မိုဘိုင်းလ်ကိရိယာများကို တစ်ပြေးညီဖြစ်စေရန်

## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = ပရိုဖိုင်းရုပ်ပုံကို ပြောင်းလဲရန်
sync-manage-account = အကောင့်ကို စီမံရန်
    .accesskey = o
sync-signedin-unverified = { $email } ​ကို အတည်မပြုရသေးပါ။
sync-signedin-login-failure = ပြန်လည်ချိတ်ဆက်ရန် အကောင့်ဖြင့် ဝင်ရောက်ပါ { $email }
sync-resend-verification =
    .label = အတည်ပြုချက်ကို ပြန်လည်ပေးပို့ပါ
    .accesskey = d
sync-remove-account =
    .label = အကောင့်ကို ဖယ်ရှားပါ
    .accesskey = R
sync-sign-in =
    .label = ဝင်ပါ
    .accesskey = g

## Sync section - enabling or disabling sync.


## The list of things currently syncing.

sync-currently-syncing-bookmarks = စာမှတ်များ
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] ရွေးချယ်စရာများ
       *[other] အပြင်အဆင်များ
    }
sync-change-options =
    .label = ပြောင်းလဲရန်
    .accesskey = C

## The "Choose what to sync" dialog.

sync-engine-bookmarks =
    .label = စာမှတ်များ
    .accesskey = m
sync-engine-history =
    .label = မှတ်တမ်း
    .accesskey = r
sync-engine-tabs =
    .label = ဖွင့်ထားသောတပ်ဗ်များ
    .tooltiptext = ကိရိယာအားလုံးတွင် ဖွင့်ထားသော တပ်ဗ်စာရင်း
    .accesskey = t
sync-engine-addresses =
    .label = လိပ်စာများ
    .tooltiptext = မှတ်သားထားသော စာပို့လိပ်စာများ (ဒက်စတော့အတွက်သာ)
    .accesskey = e
sync-engine-creditcards =
    .label = အကြွေးကဒ်များ
    .tooltiptext = နာမည်၊ နံပါတ်နှင့် ကုန်ဆုံးရက်များ (ဒက်စတော့အတွက်သာ)
    .accesskey = C
sync-engine-addons =
    .label = အတ်အွန်များ
    .tooltiptext = Firefox ဒက်စတော့အတွက် ပေါင်းထည့်ဆော့ဖ်ဝဲများနှင့် အခင်းအကျင်းများ
    .accesskey = A
sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] ရွေးချယ်မှုများ
           *[other] နှစ်သက်ရာ အပြင်အဆင်များ
        }
    .tooltiptext = ပြောင်းလဲထားသော အထွေထွေ၊ကိုယ်ရေးကိုယ်တာနှင့် လုံခြုံမှုအပြင်အဆင်များ
    .accesskey = s

## The device name controls.

sync-device-name-header = ကိရိယာအမည်
sync-device-name-change =
    .label = ကိရိယာအမည်ကို ပြောင်းလဲရန်…
    .accesskey = h
sync-device-name-cancel =
    .label = မဆောင်ရွက်တော့ပါ
    .accesskey = n
sync-device-name-save =
    .label = သိမ်းဆည်းပါ
    .accesskey = v
sync-connect-another-device = အခြားကိရိယာကို ချိတ်ပါ။

## Privacy Section

privacy-header = ဘရောင်ဇာ ကိုယ်ရေးကာကွယ်မှု

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = အကောင့်ဝင်ရောက်မှုနှင့်စကားဝှက်များ
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = ဆိုက်များအတွက် ဝင်ရောက်မှုများနှင့် စကားဝှက်များကို မှတ်ရန် မေးပါ
    .accesskey = r
forms-exceptions =
    .label = ခြွင်းချက်များ...
    .accesskey = x
forms-saved-logins =
    .label = သိမ်းထားသည့် ဝင်ရောက်မှု အချက်အလက်များ…
    .accesskey = L
forms-master-pw-use =
    .label = အဓိကစကားဝှက်တစ်ခု အသုံးပြုပါ
    .accesskey = U
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = အဓိကစကားဝှက်ကို ပြောင်းလဲရန်…
    .accesskey = M
forms-master-pw-fips-title = လတ်တလော FIPS အသွင်အတွင်း ရှိသည်။ FIPSသည် ‌ဗလာမဖြစ်သော ပင်မစကားဝှက်တစ်ခု လိုအပ်နေသည်။
forms-master-pw-fips-desc = စကားဝှက်ပြောင်းလဲမှု မအောင်မြင်ပါ

## OS Authentication dialog


## Privacy Section - History

history-header = မှတ်တမ်း
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Firefox", moving the verb into each option.
#     This will result in "Firefox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = { -brand-short-name } သည်
    .accesskey = w
history-remember-option-all =
    .label = မှတ်တမ်းကို မှတ်ထားမည်
history-remember-option-never =
    .label = မှတ်တမ်းကို ဘယ်တော့မှ မမှတ်ထားပါ
history-remember-option-custom =
    .label = မှတ်တမ်းအတွက် စိတ်ကြိုက်အပြင်အဆင်ကို အသုံးပြုမည်
history-remember-description = { -brand-short-name }သည် သင့်၏ရှာဖွေမှု၊ဆွဲယူမှု၊ရှာဖွေမှတ်တမ်းများကို မှတ်သားမည်။
history-dontremember-description = { -brand-short-name } က တူညီတဲ့ အပြင်အဆင်များကို သီးသန့် လှော်လှန်မှုအဖြစ် သုံးစွဲမှာ ဖြစ်ပြီး၊ ကွန်ရက်ကို သင်လှော်လှန်နေစဉ် ဘယ် မှတ်တမ်းကိုမှ မှတ်သားထားမှာ မဟုတ်ဘူး။
history-private-browsing-permanent =
    .label = သီးသန့်ကြည့်ရှုခြင်းကို အမြဲ အသုံးပြုမည်
    .accesskey = p
history-remember-browser-option =
    .label = ကြည့်ရှုနှင့် ဆွဲယူမှုမှတ်တမ်းကို မှတ်ထားပါ
    .accesskey = b
history-remember-search-option =
    .label = ရှာဖွေမှတ်တမ်းနှင့် ဖောင်ဖြည့်မှတ်တမ်းကို မှတ်ထားပါ
    .accesskey = f
history-clear-on-close-option =
    .label = { -brand-short-name } ကို ပိတ်သောအခါတွင် မှတ်တမ်းကို ရှင်းလင်းပါ
    .accesskey = r
history-clear-on-close-settings =
    .label = အပြင်အဆင်များ...
    .accesskey = t
history-clear-button =
    .label = မှတ်တမ်းကို ရှင်းလင်းပါ...
    .accesskey = s

## Privacy Section - Site Data

sitedata-header = ကွတ်ကီးနှင့် ဆိုက်အချက်အလက်များ
sitedata-total-size-calculating = ဆိုက်အချက်အလက်နှင့် ယာယီအချက်အလက် cache သုံးစွဲမှုပမာဏကို တွက်ချက်နေသည်...
sitedata-learn-more = ပိုမိုလေ့လာရန်
sitedata-allow-cookies-option =
    .label = ကွတ်ကီးများနှင့် ဆိုက်အချက်အလက်ကို လက်ခံရန်
    .accesskey = A
sitedata-disallow-cookies-option =
    .label = ကွတ်ကီးများနှင့် ဆိုက်အချက်အလက်ကို မသိမ်းရန်
    .accesskey = B
sitedata-clear =
    .label = အချက်အလက်ကို ရှင်းပါ...
    .accesskey = l
sitedata-settings =
    .label = အချက်အလက်ကို စီမံပါ...
    .accesskey = M

## Privacy Section - Address Bar

addressbar-header = လိပ်စာဘား
addressbar-suggest = လိပ်စာဘားတန်းတွင်ရှာဖွေပါက အကြံပေးပါ
addressbar-locbar-history-option =
    .label = ရှာဖွေကြည့်ရှုမှု မှတ်တမ်း
    .accesskey = h
addressbar-locbar-bookmarks-option =
    .label = စာမှတ်များ
    .accesskey = k
addressbar-locbar-openpage-option =
    .label = ဖွင့်ထားသည့် စာမျက်နှာများ
    .accesskey = O
addressbar-suggestions-settings = ရှာဖွေရေးယန္တရား၏ အကြံပေးချက်များအတွက် အပြင်အဆင်ကို ပြောင်းလဲရန်

## Privacy Section - Content Blocking

content-blocking-learn-more = ပိုမိုလေ့လာရန်

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

enhanced-tracking-protection-setting-strict =
    .label = တားမြစ်ရန်
    .accesskey = r
enhanced-tracking-protection-setting-custom =
    .label = စိတ်ကြိုက်
    .accesskey = C

##

content-blocking-all-cookies = ကွတ်ကီးအားလုံး
content-blocking-unvisited-cookies = မလည်ပတ်သောဆိုက်များမှ ကွတ်ကီးများ
content-blocking-all-third-party-cookies = သက်ဗ်ပါတီ ကွတ်ကီးများအားလုံး
content-blocking-cryptominers = Cryptominers
content-blocking-fingerprinters = လက်ဗွေများ
content-blocking-warning-title = ကြိုတင်အသိပေးသည်!
content-blocking-reload-tabs-button =
    .label = တပ်ဗ်အားလုံးကို ပြန်ဖွင့်ရန်
    .accesskey = R
content-blocking-tracking-protection-option-all-windows =
    .label = ဝင်းဒိုးအားလုံးတွင်
    .accesskey = A
content-blocking-option-private =
    .label = ကိုယ်ပိုင်ဝင်းဒိုးတွင်သာလျှင်
    .accesskey = p
content-blocking-tracking-protection-change-block-list = ပိတ်ထားသည့်စာရင်းကို ပြောင်းရန်
content-blocking-cookies-label =
    .label = ကွတ်ကီးများ
    .accesskey = C
content-blocking-expand-section =
    .tooltiptext = ပိုမို အချက်အလက်
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = လက်ဗွေရာများ
    .accesskey = F

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = ချွင်းချက်များကို စီမံပါ
    .accesskey = x

## Privacy Section - Permissions

permissions-header = ခွင့်ပြုချက်များ
permissions-location = တည်နေရာ
permissions-location-settings =
    .label = အပြင်အဆင်များ...
    .accesskey = t
permissions-camera = ကင်မရာ
permissions-camera-settings =
    .label = အပြင်အဆင်များ...
    .accesskey = t
permissions-microphone = မိုက်ကရိုဖုန်း
permissions-microphone-settings =
    .label = အပြင်အဆင်များ...
    .accesskey = t
permissions-notification = အသိပေးချက်များ
permissions-notification-settings =
    .label = အပြင်အဆင်များ...
    .accesskey = t
permissions-notification-link = ပိုမိုလေ့လာရန်
permissions-notification-pause =
    .label = အသိပေးချက်ကို { -brand-short-name } ပြန်လည်စတင်မှု မတိုင်ခင်ထိ ရပ်တန့်ထားပါ
    .accesskey = n
permissions-block-popups =
    .label = ပေါ့အပ်ဝင်းဒိုးများကို မဖွင့်ပါနှင့်
    .accesskey = B
permissions-block-popups-exceptions =
    .label = ခြွင်းချက်များ...
    .accesskey = E
permissions-addon-install-warning =
    .label = ဝဘ်ဆိုက်များက အတ်အွန်များ တပ်ဆင်လိုသည့်အခါ အသိပေးပါ
    .accesskey = W
permissions-addon-exceptions =
    .label = ခြွင်းချက်များ...
    .accesskey = E
permissions-a11y-privacy-link = ပိုမိုလေ့လာရန်

## Privacy Section - Data Collection

collection-header = { -brand-short-name } ချက်လက်စုစည်းမှုနှင့်အသုံးပြုမှု
collection-privacy-notice = ကိုယ်ရေးကာကွယ်မှု အသိပေးချက်
collection-health-report =
    .label = { -vendor-short-name } သို့နည်းပညာဆိုင်ရာချက်လက်များပို့ရန်{ -brand-short-name } ကို ခွင့်ပြုပါ
    .accesskey = r
collection-health-report-link = ပိုမိုလေ့လာရန်
collection-studies =
    .label = { -brand-short-name } ကို ထည့်သွင်းခြင်းနှင့် လေ့လာမှုလုပ်ရန် ခွင့်ပြုပါ
collection-studies-link = { -brand-short-name }လေ့လာမှု ကြည့်ရန်
addon-recommendations-link = ပိုမိုလေ့လာရန်
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = တည်ဆောက်မှုဆိုင်ရာ ယခုအပြင်အဆင်အတွက် အချက်အလက်အစီရင်ခံခြင်းကို ပိတ်ထားသည်
collection-backlogged-crash-reports =
    .label = မတင်ပို့ရသေးသော ပျက်စီးမှုအစီရင်ခံစာများကို ကိုယ်စားပေးပို့ရန် { -brand-short-name } ကို ခွင့်ပေးပါ။
    .accesskey = c
collection-backlogged-crash-reports-link = ပိုမိုလေ့လာရန်

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = လုံခြုံရေး
security-browsing-protection = အချက်အလက်အတုနှင့် အန္တရာယ်ရှိသော ဆော့ဖ်ဝဲ ကာကွယ်မှု
security-enable-safe-browsing =
    .label = အန္တရာယ်ရှိသည့် အကြောင်းအရာတုများကို တားဆီးပါ
    .accesskey = B
security-enable-safe-browsing-link = ပိုမိုလေ့လာရန်
security-block-downloads =
    .label = အန္တရာယ်ရှိသည့် ဆွဲယူထားသည့်ဖိုင်များကို တားဆီးပါ
    .accesskey = d
security-block-uncommon-software =
    .label = မလိုအပ်သော၊ ပုံမှန်မဟုတ်သော ဆော့ဖ်ဝဲလ်များ တွေ့ရှိပါက သတိပေးပါ
    .accesskey = C

## Privacy Section - Certificates

certs-header = အသိအမှတ်ပြုလက်မှတ်များ
certs-personal-label = ဆာဗာမှ သင့်ကိုယ်ရေးထောက်ခံချက် တောင်းဆိုလာပါက
certs-select-auto-option =
    .label = တစ်ခုကို အလိုအလျောက် ရွေးပါ
    .accesskey = S
certs-select-ask-option =
    .label = အကြိမ်တိုင်း မေးပါ
    .accesskey = A
certs-enable-ocsp =
    .label = လက်ရှိအထောက်အထားများ၏ ခိုင်လုံမှုကို အတည်ပြုရန် OSCP responder servers များကို ဆွဲထုတ်ပါ Q
    .accesskey = Q
certs-view =
    .label = အထောက်အထားများကို ကြည့်ရန်...
    .accesskey = C
certs-devices =
    .label = လုံခြုံရေး ကိရိယာများ...
    .accesskey = D
space-alert-learn-more-button =
    .label = ပိုမိုလေ့လာရန်
    .accesskey = L
space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] အပြင်အဆင်များကို ဖွင့်ပါ
           *[other] နှစ်သက်ရာအပြင်အဆင်များကို ဖွင့်ပါ
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] O
        }
space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] { -brand-short-name } ကို အသုံးပြုရန် နေရာလွတ်မရှိတော့ပါ။ ဝဘ်ဆိုက်ရှိ အကြောင်းအရာများကို ကောင်းမွန်စွာ ပြသနိုင်မည် မဟုတ်ပါ။ သိမ်းဆည်းထားသည့် ဝဘ်ဆိုက်အချက်အလက်များကို အပြင်အဆင်များ > ကိုယ်ရေးကာကွယ်မှုနှင့် လုံခြုံမှု > ဝဘ်ဆိုက်ဒေတာ တွင် ရှင်းလင်းနိုင်သည်။
       *[other] { -brand-short-name } ကို အသုံးပြုရန် နေရာလွတ်မရှိတော့ပါ။ ဝဘ်ဆိုက်ရှိ အကြောင်းအရာများကို ကောင်းမွန်စွာ ပြသနိုင်မည် မဟုတ်ပါ။ သိမ်းဆည်းထားသည့် ဝဘ်ဆိုက်အချက်အလက်များကို အပြင်အဆင်များ > ကိုယ်ရေးကာကွယ်မှုနှင့် လုံခြုံမှု > ဝဘ်ဆိုက်ဒေတာ တွင် ရှင်းလင်းနိုင်သည်။
    }
space-alert-under-5gb-ok-button =
    .label = ကောင်းပြီ၊ ရပါပြီ
    .accesskey = K
space-alert-under-5gb-message = { -brand-short-name } ကို အသုံးပြုရန် နေရာလွတ်မရှိတော့ပါ။ ဝဘ်ဆိုက်ရှိအကြောင်းအရာများကို ကောင်းမွန်စွာ ပြသနိုင်မည် မဟုတ်ပါ။ ပိုမိုကောင်းမွန်သော အင်တာနက်ကြည့်ရှုမှု ရရှိရန်အတွက် နေရာလွတ်အသုံးပြုမှုကို ပိုမိုကျစ်လစ်ကောင်းမွန်စေရန် “ပိုမိုလေ့လာရန်” သို့ သွားရောက်ကြည့်ရှုပါ။

## Privacy Section - HTTPS-Only


## The following strings are used in the Download section of settings

desktop-folder-name = ဒက်စ်တော့
downloads-folder-name = ဆွဲယူထားသော ဖိုင်များ
choose-download-folder-title = ဆွဲယူထားသည့် ဖိုင်များထားရာနေရာကို ရွေးပါ
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = { $service-name } သို့ ဖိုင်မှတ်သားပါ
