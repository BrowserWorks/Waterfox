# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - "Mozilla Firefox"
# private - "Mozilla Firefox (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } (လုံခြုံစွာ ဝဘ်ဆိုက်ကြည့်ရှုခြင်း)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (လုံခြုံစွာ ဝဘ်ဆိုက်ကြည့်ရှုခြင်း)
# These are the default window titles on macOS. The first two are for use when
# there is no content title:
#
# "default" - "Mozilla Firefox"
# "private" - "Mozilla Firefox - (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Do not use the brand name in the last two attributes, as we do on non-macOS.
#
# Also note the other subtle difference here: we use a `-` to separate the
# brand name from `(Private Browsing)`, which does not happen on other OSes.
#
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-mac =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } - (လုံခြုံစွာ ဝဘ်ဆိုက်ကြည့်ရှုခြင်း)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (လုံခြုံစွာ ဝဘ်ဆိုက်ကြည့်ရှုခြင်း)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = ဝဘ်ဆိုက် ၏ အချက်အလက်ကို ကြည့်ရန်

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = တပ်ဆင်ခြင်းဆိုင်ရာ စာတိုပန်နယ်ကို ဖွင့်ပါ
urlbar-web-notification-anchor =
    .tooltiptext = ယခုဝဘ်ဆိုက်ထံမှ အသိပေးချက်များ ရယူနိုင်ရန်ဖြစ်စေ မရယူနိုင်ရန်ဖြစ်စေ ပြောင်းလဲသတ်မှတ်နိုင်သည်။
urlbar-midi-notification-anchor =
    .tooltiptext = MIDI ခလုတ်ခုံကို ဖွင့်ပါ
urlbar-eme-notification-anchor =
    .tooltiptext = DRM အပျော့ထည်များ အသုံးပြုခြင်းကို စီမံရန်
urlbar-canvas-notification-anchor =
    .tooltiptext = Canvas ထုတ်ယူခြင်းဆိုင်ရာ လုပ်ပိုင်ခွင့်ကို စီမံရန်
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = ယခုဝဘ်ဆိုက်နှင့်အတူ မိုက္ကရိုဖုန်း မျှဝေအသုံးပြုခြင်းကို စီမံရန်
urlbar-default-notification-anchor =
    .tooltiptext = စာတိုပန်နယ်ကို ဖွင့်ပါ
urlbar-geolocation-notification-anchor =
    .tooltiptext = တည်နေရာတောင်းဆိုမှု ပန်နယ်ကို ဖွင့်ပါ
urlbar-translate-notification-anchor =
    .tooltiptext = ဒီစာမျက်နှာကို ဘာသာပြန်ပါ
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = ယခုဝဘ်ဆိုက်နှင့်အတူ ဝင်းဒိုးများနှင့် မျက်နှာပြင်များ မျှဝေအသုံးပြုခြင်းကို စီမံရန်
urlbar-indexed-db-notification-anchor =
    .tooltiptext = ချိတ်ဆက်မဲ့ အချက်အလက်သိမ်းစနစ်ဆိုင်ရာ စာတိုပန်နယ်ကို ဖွင့်ပါ
urlbar-password-notification-anchor =
    .tooltiptext = စကားဝှက်သိမ်းခြင်းဆိုင်ရာ စာတိုပန်နယ်ကို ဖွင့်ပါ
urlbar-translated-notification-anchor =
    .tooltiptext = စာမျက်နှာဘာသာပြန်ခြင်းကို စီမံခန့်ခွဲရန်
urlbar-plugins-notification-anchor =
    .tooltiptext = အသုံးပြုနေသော ပလက်ဂ်အင်ကို စီမံရန်
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = ကင်မရာ နှင့်/သို့မဟုတ် မိုက္ကရိုဖုန်းကို ယခုဝဘ်ဆိုက်နှင့်အတူ မျှဝေအသုံးပြုခြင်းကို စီမံနိုင်သည်။
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = အမြဲသိမ်း သိုလှောင် နေရာတွင် သိမ်းမည်
urlbar-addons-notification-anchor =
    .tooltiptext = အတ်အွန်တပ်ဆင်ခြင်းဆိုင်ရာ စာတိုပန်နယ်ကို ဖွင့ပါ
urlbar-tip-help-icon =
    .title = အကူအညီ ယူမည်
urlbar-search-tips-confirm = ကောင်းပြီ၊ ရပါပြီ။
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = အကြံပြုချက်။

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".


## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = စာမှတ်များ
urlbar-search-mode-tabs = တပ်ဗ်များ
urlbar-search-mode-history = မှတ်တမ်း

##

urlbar-geolocation-blocked =
    .tooltiptext = ယခုဝဘ်ဆိုက်အတွက် တည်နေရာဆိုင်ရာ အချက်အလက်ကောက်ယူခြင်းကို တားဆီးထားသည်။
urlbar-web-notifications-blocked =
    .tooltiptext = ယခုဝဘ်ဆိုက်အတွက် အသိပေးချက်များပြသခြင်းကို တားဆီးထားသည်။
urlbar-camera-blocked =
    .tooltiptext = ယခုဝဘ်ဆိုက်အတွက် ကင်မရာအသုံးပြုခြင်းကို တားဆီးထားသည်။
urlbar-microphone-blocked =
    .tooltiptext = ယခုဝဘ်ဆိုက်အတွက် မိုက္ကရိုဖုန်းအသုံးပြုခြင်းကို တားဆီးထားသည်။
urlbar-screen-blocked =
    .tooltiptext = ယခုဝဘ်ဆိုက်ကို မျက်နှာပြင် မျှဝေအသုံးပြုခြင်းမှ တားဆီးထားသည်။
urlbar-persistent-storage-blocked =
    .tooltiptext = ယခုဝဘ်ဆိုက်အတွက် အချက်အလက်သိမ်းဆည်းခြင်းကို တားဆီးထားသည်။
urlbar-popup-blocked =
    .tooltiptext = ယခုဝဘ်ဆိုက်အတွက် ကင်မရာအသုံးပြုခြင်းကို တားဆီးထားသည်။
urlbar-canvas-blocked =
    .tooltiptext = ယခုဝဘ်ဆိုက်အတွက် canvas data extraction ကို တားဆီးထားသည်။
urlbar-midi-blocked =
    .tooltiptext = ယခုဝဘ်ဆိုက်အတွက် MIDI အသုံးပြုခြင်းကို တားဆီးထားသည်။
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = စာအမှတ်အားပြင်မည် ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = စာအမှတ်အားမှတ်သားထားမည် ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = လိပ်စာဘားတန်းသို့ ထည့်ပါ
page-action-manage-extension =
    .label = ပေါင်းထည့်ကိရိယာကို စီမံရန်…
page-action-remove-from-urlbar =
    .label = လိပ်စာဘားတန်းမှ ဖယ်ရှားပါ
page-action-remove-extension =
    .label = တိုးချဲ့မှု ပယ်ဖျက်ပါ

## Auto-hide Context Menu

full-screen-autohide =
    .label = ကိရိယာအတန်းများကို ဖျောက်ပါ
    .accesskey = H
full-screen-exit =
    .label = မျက်နှာပြင်အပြည့်ကြည့်ခြင်းမှ ထွက်ရန်
    .accesskey = F

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = ယခုအကြိမ် ရှာဖွေလိုက်သည်မှာ
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = ရှာဖွေရေး အပြင်အဆင်များကို ပြောင်းလဲရန်
search-one-offs-change-settings-compact-button =
    .tooltiptext = ရှာဖွေမှု အပြင်အဆင်များကို ပြောင်းလဲရန်
search-one-offs-context-open-new-tab =
    .label = တပ်ဗ်အသစ်တွင် ရှာရန်
    .accesskey = T
search-one-offs-context-set-as-default =
    .label = ပုံသေရှာဖွေရေးယန္တရားအဖြစ် သတ်မှတ်ပါ
    .accesskey = D
search-one-offs-context-set-as-default-private =
    .label = သီးသန့်ဝင်းဒိုးများ၏ ရှာဖွေရေးအင်ဂျင်အဖြစ် သတ်မှတ်ပါ
    .accesskey = P

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).

search-one-offs-bookmarks =
    .tooltiptext = စာမှတ်များ ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = တဗ်များ ({ $restrict })
search-one-offs-history =
    .tooltiptext = မှတ်တမ်းများ ({ $restrict })

## Bookmark Panel

bookmark-panel-done-button =
    .label = ပြီးပြီ
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = ချိတ်ဆက်မှုသည် မလုံခြုံပါ
identity-connection-internal = ဒီ စာမျက်နှာ { -brand-short-name } သည် လုံခြုံစိတ်ချရသည်။
identity-connection-file = ဒီစာမျက်နှာကို သင့်ကွန်ပျူတာတွင် သိမ်းထားသည်။
identity-extension-page = ယခုစာမျက်နှာကို တိုးချဲ့ဆော့ဖ်ဝဲထံမှ ဖွင့်ထားသည်။
identity-active-blocked = { -brand-short-name } ၏ အစိတ်အပိုင်းတချို့သည် မလုံခြုံသောကြောင့် ၄င်းကို တားဆီးထားသည်။
identity-passive-loaded = ဒီစာမျက်နှာ၏ အစိတ်အပိုင်းတချို့သည် မလုံခြုံပါ (ရုပ်ပုံများ စသည်)။
identity-active-loaded = ဒီစာမျက်နှာတွင် သင်သည် ကာကွယ်မှုကို ပိတ်ထားသည်။
identity-weak-encryption = ဒီစာမျက်နှာသည် အားနည်းသည့် ဝှက်စာစနစ်ကို သုံးထားသည်။
identity-insecure-login-forms = ဒီစာမျက်နှာကို ဝင်ရောက်ရာတွင် အသုံးပြုသည့် အချက်အလက်များသည် တိုက်ခိုက်ခိုးယူခံရနိုင်သည်။
identity-permissions =
    .value = ခွင့်ပြုချက်များ
identity-permissions-reload-hint = ပြောင်းလဲထားသည့် အပြင်အဆင်များ သက်ရောက်မှုရှိစေရန်အတွက် ယခုစာမျက်နှာကို ပြန်လည်ခေါ်ယူရန် လိုအပ်ကောင်း လိုအပ်နိုင်ပါသည်။
identity-permissions-empty = ယခုဆိုက်တွင် သင့်အတွက် မည်သည့် အထူးခွင့်ပြုချက်များ သက်မှတ်ပေးထားခြင်းမရှိပါ။
identity-clear-site-data =
    .label = ကွတ်ကီးများနှင့် ဝဘ်ဆိုက် အချက်အလက်အားလုံးကို ရှင်းလင်းပါ…
identity-ev-owner-label = ထုတ်ပေးသောလက်မှတ် -
identity-remove-cert-exception =
    .label = ခြွင်းချက်သတ်မှတ်ထားခြင်းမှ ဖယ်ရှားရန်
    .accesskey = R
identity-description-insecure = ဒီဆိုက်သို့ သင့်ချိတ်ဆက်မှုသည် သီးသန့်ဖြစ်မနေပါ။ သင်ပို့လိုက်သည့် အချက်အလက်များကို အခြားသူများက ကြည့်ရှုနိုင်ပါလိမ့်မည် (စကားဝှက်များ၊ စာတိုများ၊ အကြွေးကတ်များ စသည်)။
identity-description-insecure-login-forms = ဒီစာမျက်နှာရှိ သင့်ဝင်ရောက်မှု အချက်အလက်များကို ထည့်သွင်းခြင်းသည် လုံခြုံမှု မရှိနိုင်သလို ခိုးယူခံရနိုင်ပါသည်။
identity-description-weak-cipher-intro = ဒီဆိုက်သို့ သင့်ချိတ်ဆက်မှုသည် အားနည်းသည့် ဝှက်စာစနစ်ကို သုံးထားပြီး သီးသန့် ဖြစ်မနေပါ။
identity-description-weak-cipher-risk = အခြားသူများသည် သင့်အချက်အလက်များကို ကြည့်ရှုနိုင် (သို့) ဝဘ်ဆိုက်၏ ဆောင်ရွက်မှုကို ပြင်ဆင်နိုင်သည်။
identity-description-active-blocked = { -brand-short-name } ၏ အစိတ်အပိုင်းတချို့သည် မလုံခြုံသောကြောင့် ၄င်းကို တားဆီးထားသည်။ <label data-l10n-name="link">ပိုမို လေ့လာပါ</label>
identity-description-passive-loaded = သင့်ချိတ်ဆက်မှုသည် သီးသန့် ဖြစ်မနေပါ။ ပြီးတော့ ဒီဆိုက်နှင့် သင်မျှဝေထားသည့် အချက်အလက်များကို အခြားသူများ ကြည့်ရှုနိုင်သည်။
identity-description-passive-loaded-insecure = ဒီဝဘ်ဆိုက်သည် မလုံခြုံသော အကြောင်းအရာများ(ရုပ်ပုံများ ကဲ့သို့) ပါဝင်သည်။ <label data-l10n-name="link">ပိုမို လေ့လာပါ</label>
identity-description-passive-loaded-mixed = { -brand-short-name } က အကြောင်းအရာတစ်ချို့ကို တားဆီးထားသော်လည်း ဒီစာမျက်နှာတွင် မလုံခြုံသော အကြောင်းအရာများ(ရုပ်ပုံများ ကဲ့သို့) ရှိနေသေးသည်။ <label data-l10n-name="link">ပိုမို လေ့လာပါ</label>
identity-description-active-loaded = ဒီဝဘ်ဆိုဒ်သည် စိတ်မချရသော အကြောင်းအရာများ(ကုဒ်များ ကဲ့သို့) ပါဝင်သည်။ ပြီးတော့ ထိုဝဘ်ဆိုက်သို့ သင့်ချိတ်ဆက်မှုသည် သီးသန့် ဖြစ်မနေပါ။
identity-description-active-loaded-insecure = ဒီဆိုက်နှင့် သင်မျှဝေထားသည့် အချက်အလက်များ (စကားဝှက်များ၊ စာတိုများ၊ အကြွေးကတ်များ စသည်) ကို အခြားသူများက မြင်နိုင်ပါသည်။
identity-learn-more =
    .value = ပိုမို လေ့လာပါ
identity-disable-mixed-content-blocking =
    .label = လောလောဆယ် ကာကွယ်မှုကို ပိတ်ထားပါ
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = ကာကွယ်မှုကို ဖွင့်ရန်
    .accesskey = E
identity-more-info-link-text =
    .label = နောက်ထပ်အချက်အလက်များ

## Window controls

browser-window-minimize-button =
    .tooltiptext = ချုံ့ပါ
browser-window-maximize-button =
    .tooltiptext = ချဲ့ပါ
browser-window-restore-down-button =
    .tooltiptext = ပြန်ယူပါ
browser-window-close-button =
    .tooltiptext = ပိတ်ပါ

## WebRTC Pop-up notifications

popup-select-camera =
    .value = ကင်မရာကို မျှဝေအသုံးပြုမည်
    .accesskey = C
popup-select-microphone =
    .value = မိုက္ကရိုဖုန်းကို မျှဝေအသုံးပြုမည်
    .accesskey = M
popup-all-windows-shared = သင့်စကရင်ပေါ်ရှိ မြင်ရသော ဝင်းဒိုးအားလုံး မျှဝေပေးမည်။

## WebRTC window or screen share tab switch warning

sharing-warning-proceed-to-tab =
    .label = Tab ကိုဆက်လက်ဆောင်ရွက်ပါ

## DevTools F12 popup


## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = ရှာဖွေပါ (သို့) လိပ်စာရိုက်ပါ
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = ရှာဖွေပါ (သို့) လိပ်စာရိုက်ပါ
urlbar-remote-control-notification-anchor =
    .tooltiptext = ဘရောင်ဇာသည် အဝေးရောက်ထိန်းချုပ်မှုအောက်တွင် ရှိနေသည်
urlbar-switch-to-tab =
    .value = ထိုတပ်ဗ်သို့ ပြောင်းကြည့်မည်
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = ထပ်ပေါင်းဆော့ဖ်ဝဲလ်။
urlbar-go-button =
    .tooltiptext = လမ်းကြောင်းအတန်းထဲရှိ လိပ်စာသို့ သွားပါ
urlbar-page-action-button =
    .tooltiptext = စာမျက်နှာရှိ ဆောင်ရွက်နိုင်သည်များ
urlbar-pocket-button =
    .tooltiptext = { -pocket-brand-name } တွင်သိမ်းပါ

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> ယခု မြင်ကွင်းအပြည့် ဖြစ်သွားပါပြီ
fullscreen-warning-no-domain = ဒီစာတမ်းသည် မြင်ကွင်းအပြည့် ဖြစ်သွားပါပြီ
fullscreen-exit-button = မြင်ကွင်းအပြည့် ကြည့်ရှုခြင်းမှ ထွက်ရန် (ESC) ခလုတ် ကိုနိုပ်ပါ။
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = မြင်ကွင်းအပြည့် ကြည့်ရှုခြင်းမှ ထွက်ရန် (ESC) ခလုတ် ကိုနိုပ်ပါ။
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> သင့်ပွိုင်တာကို ထိန်းချုပ်ထားသည်။ ပြန်လည်ရယူရန် Esc ကို နှိပ်ပါ။
pointerlock-warning-no-domain = ဒီစာတမ်းသည် သင့်ပွိုင်တာကို ထိန်းချုပ်ထားသည်။ ပြန်လည်ရယူရန် Esc ကို နှိပ်ပါ။
