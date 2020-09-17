# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

aboutDialog-title =
    .title = { -brand-full-name } အကြောင်း

releaseNotes-link = ဘာအသစ်တွေ ပါဝင်ပါသလဲ။

update-checkForUpdatesButton =
    .label = မွမ်းမံချက်များရှိ/မရှိ စစ်ဆေးမည်
    .accesskey = C

update-updateButton =
    .label = { -brand-shorter-name } ကို အဆင့်မြှင့်ရန် ပြန်ဖွင့်ပါ
    .accesskey = R

update-checkingForUpdates = မွမ်းမံချက် အသစ်ရှိမရှိ စစ်နေသည်...
update-downloading = <img data-l10n-name="icon"/>နောက်ဆုံးပေါ်ပြုပြင်ချက်ကို ရယူနေသည် — <label data-l10n-name="download-status"/>
update-applying = အဆင့်မြှင့်တင်မှု ဆောင်ရွက်နေသည်…

update-failed = အဆင့်မြှင့်တင်ခြင်း မပြုလုပ်နိုင်ပါ။ <label data-l10n-name="failed-link">နောက်ဆုံးထွက်ဗားရှင်းကို ရယူမည်</label>
update-failed-main = အဆင့်မြှင့်တင်ခြင်း မပြုလုပ်နိုင်ပါ။ <a data-l10n-name="failed-link-main">နောက်ဆုံးထွက်ဗားရှင်းကို ရယူမည်</a>

update-adminDisabled = အဆင့်မြှင့်တင်ခြင်းကို သင်၏ကွန်ပျူတာစနစ် ထိန်းချုပ်သူက ခွင့်မပြုပါ။
update-noUpdatesFound = { -brand-short-name } သည် နောက်ဆုံးပေါ်အသစ် ဖြစ်သွားပြီဖြစ်သည်။
update-otherInstanceHandlingUpdates = { -brand-short-name } ကို အခြားတစ်ဖက်မှာ အဆင့်မြှင့်ပေးနေပါသည်။

update-manual = နောက်ဆုံးပေါ်ရနိုင်သောနေရာသည် <label data-l10n-name="manual-link"/>

update-unsupported = ဒီကွန်ပျူတာစနစ်တွင် နောင်လာမည့် အဆင့်မြှင့်တင်မှုများကို လုပ်ဆောင်နိုင်တော့မည် မဟုတ်ပါ။ <label data-l10n-name="unsupported-link">ပိုမို လေ့လာပါ</label>

update-restarting = ပြန်ဖွင့်နေသည်…

channel-description = ယခု ရှိနေသောနေရာသည် <label data-l10n-name="current-channel"></label> နောက်ဆုံးပေါ်ရနိုင်သည့် လမ်းကြောင်း ဖြစ်သည်။ 

warningDesc-version = { -brand-short-name } သည် စမ်းသပ်နေဆဲအရာဖြစ်ပြီး မတည်ငြိမ်မှု ဖြစ်ကောင်းဖြစ်နိုင်သည်။

community-exp = <label data-l10n-name="community-exp-mozillaLink">{ -vendor-short-name }</label> သည် <label data-l10n-name="community-exp-creditsLink">ကမ္ဘာလုံးဆိုင်ရာ ကွန်မြူနတီ ဖြစ်ပါသည်</label> ဝဘ်ကို အများပိုင်ဖြစ်ရန် ၊ ပွင့်လင်းမြင်သာရန် ၊ အသုံးပြုနိုင်ရန် လုပ်ဆောင်လျက်

community-2 = { -brand-short-name } ကို ဒီဇိုင်းထုတ်သူမှာ <label data-l10n-name="community-mozillaLink">{ -vendor-short-name }</label>, a<label data-l10n-name="community-creditsLink">ကမ္ဘာလုံးဆိုင်ရာ ကွန်မြူနတီ</label> ဝဘ်ကို အများပိုင်ဖြစ်ရန် ၊ ပွင့်လင်းမြင်သာရန် ၊ အသုံးပြုနိုင်ရန် လုပ်ဆောင်လျက်

helpus = အကူအညီပေးချင်ပါသလား။ <label data-l10n-name="helpus-donateLink">လှူဒါန်းပါ</label> သို့မဟုတ် <label data-l10n-name="helpus-getInvolvedLink">ပါဝင်ဆောင်ရွက်ပါ။</label>

bottomLinks-license = လိုင်စင်အကြောင်းသိကောင်းစရာ
bottomLinks-rights = သုံးစွဲသူ၏ အခွင့်အရေးများ
bottomLinks-privacy = ကိုယ်ရေးအချက်အလက်ကာကွယ်မှုမူဝါဒ

# Example of resulting string: 66.0.1 (64-bit)
# Variables:
#   $version (String): version of Firefox, e.g. 66.0.1
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version = { $version }({ $bits } -bit)

# Example of resulting string: 66.0a1 (2019-01-16) (64-bit)
# Variables:
#   $version (String): version of Firefox for Nightly builds, e.g. 66.0a1
#   $isodate (String): date in ISO format, e.g. 2019-01-16
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version-nightly = { $version }{ $isodate } ({ $bits }-bit)
