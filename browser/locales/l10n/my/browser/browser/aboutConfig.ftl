# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = သတိနှင့် ဆက်လုပ်ပါ
about-config-intro-warning-text = အဆင့်မြင့် ပြင်ဆင်ချမှတ်မှုများ ကိုပြောင်းလဲ လိုခြင်းသည် { -brand-short-name } ၏ စွမ်းဆောင်ရည် နှင့် လုံခြုံရေး ကို ထိခိုက် စေပါသည်။
about-config-intro-warning-checkbox = ဤ အပြင်အဆင် ကို ရယူရန်ကြိုးစာတိုင်း ကျွန်ုပ် ကို သတိပေးပါ
about-config-intro-warning-button = အန္တရာယ် ကို လက်ခံပြီး ဆက်လုပ်ပါမည်

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = ဤ အပြင်အဆင်ကို ပြောင်းလဲခြင်းကြောင့် { -brand-short-name } ၏ စွမ်းဆောင်ရည် နှင့် လုံခြုံရေး ကို ထိခိုက် စေပါသည်။
about-config-page-title = အဆင့်မြင့် အပြင်အဆင်များ
about-config-search-input1 =
    .placeholder = အပြင်အဆင်၏ အမည် ဖြင့်ရှာပါ
about-config-show-all = အားလုံးကို ပြပါ
about-config-pref-add-button =
    .title = ထည့်ရန်
about-config-pref-toggle-button =
    .title = အထိန်းခလုပ်
about-config-pref-edit-button =
    .title = တည်းဖြတ်ပါ
about-config-pref-save-button =
    .title = သိမ်းဆည်းပါ
about-config-pref-reset-button =
    .title = မူလအတိုင်း ပြန်သတ်မှတ်ရန်
about-config-pref-delete-button =
    .title = ဖျက်ရန်

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = ယုတ္တိကိန်းတန်ဖိုး
about-config-pref-add-type-number = ဂဏန်း
about-config-pref-add-type-string = စာကြောင်း

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (ပုံသေ)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (စိတ်ကြိုက်)
