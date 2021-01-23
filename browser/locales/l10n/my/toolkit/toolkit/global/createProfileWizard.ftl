# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = ပရိုဖိုင်းလ် ဖန်တီးခြင်း နည်းလမ်း
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] နိဒါန်း
       *[other] { create-profile-window.title } မှ ကြိုဆိုပါသည်
    }

profile-creation-explanation-1 = { -brand-short-name } သည် သင်၏ ကိုယ်ပိုင်ပရိုဖိုင်းလ်ရှိ အပြင်ဆင်များနှင့် နှစ်သက်ရာ ရွေးချယ်ချက်များကို သိုလှောင်သိမ်းဆည်းပါသည်။

profile-creation-explanation-2 = သင်သည် { -brand-short-name } ကို အခြားသူများနှင့် မျှဝေအသုံးပြုနေပါက အသုံးပြုသူ တစ်ဦးချင်းစီ၏ အချက်အလက်များကို သီးခြားစီ ဖြစ်နေစေရန် ပရိုဖိုင်းလ်ကို အသုံးပြုနိုင်ပါသည်။ ထိုသို့ သီးခြားစီ ဖြစ်နေစေရန် အသုံးပြုသူ တစ်ဦးချင်းစီသည် ၎င်းတို့၏ ပရိုဖိုင်းလ်ကို ဖန်တီးထားသင့်သည်။

profile-creation-explanation-3 = { -brand-short-name } အားသင်တစ်ယောက်တည်း သုံးဆွဲသည်ဆိုသော်လည်း ပရိုဖိုင်တစ်ခု အနည်းဆုံးထားရှိရမည်ဖြစ်သည် ။ သင်စိတ်ရှိပါကလဲ တစ်ခုထက်ပိုသော ပရိုဖိုင်များအား ဆောက်ထားနိုင်ပြီ အပြင်အဆင်အမျိုးမျိုးဖြင့် သုံးဆွဲနိုင်မည်ဖြစ်ပါသည် ။ ဥပမာအားဖြင့်ဆိုရသော လုပ်ငန်းသုံး ပါဆင်နယ်တစ်ကိုယ်ရည် သုံး ခွဲထားခြင်း။

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] သင့်၏ profile ကို စတင်တည်ဆောက်ရန် Continue ကိုနှိပ်ပါ
       *[other] သင့်၏ profile ကို စတင်တည်ဆောက်ရန် Next ကိုနှိပ်ပါ
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] နိဂုံး
       *[other] { create-profile-window.title } ကို ပြီးဆုံးသည်အထိ ဆောင်ရွက်နေသည်
    }

profile-creation-intro = သင့်တွင် ပရိုင်ဖိုင်များ စွာရှိပါက ယခုသည်သင် နာမည်များအား မတူအောင်ပေးထားနိုင်ပါသည်။ သို့မဟုတ် ဤတွင်ပေးထားသော နာမည်အားသုံးလိုကသုံး မသုံးလိုက သင်ကိုယ်တိုင်ပေးပြီးသုံး။

profile-prompt = Eပရိုဖိုင်နာမည် အသစ်တစ်ခုရိုက်ထည့်ပါ:
    .accesskey = E

profile-default-name =
    .value = အမြဲအသုံးပြုသောသူ

profile-directory-explanation = သင်၏ အသုံးပြုသူ settings, preferences နှင့် အခြားသော အသုံးပြုနှင့် သက်ဆိုင်ရာ အချက်အလက်များကို သိမ်းဆည်းထားပါသည်။

create-profile-choose-folder =
    .label = ဖိုင်တွဲရွေးပါ
    .accesskey = ဖ

create-profile-use-default =
    .label = U စံဖိုဒါအဖြစ်သုံး
    .accesskey = U
