# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = ပရိုဖိုင်များ အကြောင်း
profiles-subtitle = ဒီစာမျက်နှာသည် သင့်ပရိုဖိုင်များကို စီမံရန် ဖြစ်ပါသည်။ ပရိုဖိုင်းတစ်ခုချင်းစီသည် သီးသန့်မှတ်ထားသည့် မှတ်တမ်း၊ စာမှတ်များ၊ အပြင်အဆင်များနှင့် ပေါင်းစပ်အက်ပ်များပါဝင်သည့် သီးခြားနေရာတစ်ခုဖြစ်ပါသည်။
profiles-create = ပရိုဖိုင်အသစ်တစ်ခု ဖန်တီးရန်
profiles-restart-title = ပြန်စပါ
profiles-restart-in-safe-mode = ထပ်ပေါင်းဆော့ဖ်ဝဲများ ပိတ်ပြီး ပြန်စမည်...
profiles-restart-normal = ပုံမှန် ပြန်စမည်…

# Variables:
#   $name (String) - Name of the profile
profiles-name = ပရိုဖိုင်လ်: { $name }
profiles-is-default = မူလပရိုဖိုင်လ်
profiles-rootdir = ရင်းမြစ်ဖိုင်လမ်းကြောင်း

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = မူလသတ်မှတ်ထားသည့် ဖိုင်လမ်းကြောင်း
profiles-current-profile = ဒီပရိုဖိုင်လ်ကို အသုံးပြုနေဆဲ ဖြစ်သည့်အတွက် ၎င်းကို မဖျက်နိုင်ပါ။

profiles-rename = အမည်ပြောင်းပါ
profiles-remove = ဖယ်ရှားပါ
profiles-set-as-default = မူလပရိုဖိုင်လ်အနေနှင့် သတ်မှတ်ရန်
profiles-launch-profile = ဘရောင်ဇာအသစ်တွင် ပရိုဖိုင်လ်ကို ဖွင့်ပါ

profiles-yes = ဟုတ်ကဲ့
profiles-no = မဟုတ်ပါ

profiles-rename-profile-title = ပရိုဖိုင်လ်ကို အမည်ပြောင်းရန်
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = ပရိုဖိုင်လ် { $name } ကို အမည်ပြောင်းရန်

profiles-invalid-profile-name-title = မှားယွင်းနေသည့် ပရိုဖိုင်လ်အမည်
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = ပရိုဖိုင်လ်အမည် “{ $name }” ကို အသုံးပြုခွင့်မရှိပါ။

profiles-delete-profile-title = ပရိုဖိုင်လ်ကို ဖျက်ရန်
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    ပရိုဖိုင်လ်ကို ဖျက်ပါက ဘရောင်ဇာတွင် ရှိနေသော ပရိုဖိုင်လ်စာရင်းထဲမှပါ ဖယ်ရှားခံရပါလိမ့်မည်။ ထို့ပြင် ၎င်းပရိုဖိုင်လ်ကို ပြန်ယူ၍ မရနိုင်ပါ။
    အပြင်အဆင်များ၊ အထောက်အထားများနှင့် အခြားဆက်စပ်အချက်အလက်များအပါအဝင် ပရိုဖိုင်လ်အချက်အလက်ဖိုင်များကို ဖျက်ရန် ရွေးချယ်နိုင်ပါသည်။ ဒီရွေးချယ်မှုသည် ဖိုင်တွဲ “{ $dir }” ကို ဖျက်မည်ဖြစ်ပြီး ၎င်းကို ပြန်ယူ၍ မရနိုင်ပါ။
    သင်သည် ပရိုဖိုင်လ်အချက်အလက်ဖိုင်များကို ဖျက်ချင်ပါသလား။
profiles-delete-files = ဖိုင်များကို ဖျက်ရန်
profiles-dont-delete-files = ဖိုင်များကို မဖျက်ပါနှင့်


profiles-opendir =
    { PLATFORM() ->
        [macos] ရှာဖွေကိရိယာမှာ ပြပါ
        [windows] ဖိုဒါအား ဖွင့်ပါ
       *[other] ဖွင့်ထားသော ဖိုင်လမ်းကြောင်း
    }
