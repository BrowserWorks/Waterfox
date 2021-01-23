# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = မှတ်တမ်း ရှင်းလင်းရန် အပြင်အဆင်များ
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = လတ်တလောမှတ်တမ်းကို ရှင်းလင်းရန်
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = မှတ်တမ်းအားလုံးကို ရှင်းပါမည်
    .style = width: 34em

clear-data-settings-label = ပိတ်သည့်အခါ { -brand-short-name } နှင့်ဆိုင်သည့်အချက်အလက်များကို အလိုအလျောက် ရှင်းလင်းသင့်တယ်

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = ရှင်းလင်းရန် အချိန်အတိုင်းအတာ၊
    .accesskey = အ

clear-time-duration-value-last-hour =
    .label = နောက်ဆုံးအချိန်

clear-time-duration-value-last-2-hours =
    .label = နောက်ဆုံး နှစ်နာရီ အချိန်

clear-time-duration-value-last-4-hours =
    .label = နောက်ဆုံး လေးနာရီ အချိန်

clear-time-duration-value-today =
    .label = ဒီနေ့

clear-time-duration-value-everything =
    .label = အကုန်လုံး

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = မှတ်တမ်း

item-history-and-downloads =
    .label = B​ အင်တာနက်ရှာဖွေသုံးဆွဲခြင်း နှင့် ဒေါင်းလုဒ်ရယူခြင်းမှတ်တမ်း
    .accesskey = B

item-cookies =
    .label = Cကွတ်ကီးများ
    .accesskey = C

item-active-logins =
    .label = လက်ရှိ အသုံးပြုနေသော ဝင်ရောက်မှုအချက်အလက်များ
    .accesskey = L

item-cache =
    .label = ယာယီသိမ်းဆည်းခန်း
    .accesskey = A

item-form-search-history =
    .label = (F)ဖြည့်စွတ်ပုံစံ & ရှာဖွေရေး မှတ်တမ်း
    .accesskey = F

data-section-label = အချက်အလက်ကြမ်း

item-site-preferences =
    .label = ကွန်ရက် ဦးစားပေးအချက်များ
    .accesskey = က

item-offline-apps =
    .label = ချိတ်ဆက်မဲ့သုံးအချက်အလက်
    .accesskey = O

sanitize-everything-undo-warning = ဒီလုပ်ဆောင်ချက်ကို ပြန်ဖြေလို့ မရနိုင်ဘူး။

window-close =
    .key = w

sanitize-button-ok =
    .label = ယခု ရှင်းလင်းပါ

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = ရှင်းလင်းနေသည်

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = မှတ်တမ်းအားလုံးကို ရှင်းလင်းပါမည်။

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = ရွေးထားသည့်မှတ်တမ်းများကို ရှင်းလင်းပါမည်။
