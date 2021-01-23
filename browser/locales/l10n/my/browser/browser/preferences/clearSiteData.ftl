# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = အချက်အလက်ကို ရှင်းပါ
    .style = width: 35em

clear-site-data-description = { -brand-short-name } တွင် ယာယီသိမ်းထားသည့် ကွတ်ကီးများနှင့် ဆိုက်အချက်အလက်များကို ရှင်းလင်းခြင်းသည် သင့်ကို ဝဘ်ဆိုက်တွင် ဝင်ရောက်ထားခြင်းမှ ထွက်စေနိုင်သည့်အပြင် အင်တာနက်မဲ့ဝဘ်အချက်အလက်ကိုလည်း ဖယ်ရှားသည်။ ယာယီအချက်အလက် cache ကို ရှင်းလင်းခြင်းသည် ဝဘ်ဆိုက်တွင် ဝင်ရောက်ထားခြင်းကို ထိခိုက်မှု မရှိစေပါ။

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = ကွတ်ကီးနှင့်ဆိုက်ဒေတာများ{ $amount }{ $unit }
    .accesskey = S

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = ကွတ်ကီးနှင့်ဆိုက်ဒေတာ
    .accesskey = S

clear-site-data-cookies-info = ရှင်းလင်းလိုက်ပါက ဆိုက်များမှထွက်သွားလိမ့်မည်

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = ဝဘ်ဆိုက်ယာယီဖိုင်{ $amount }{ $unit }
    .accesskey = W

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = ဝဘ်ဆိုက်ယာယီဖိုင်
    .accesskey = W

clear-site-data-cache-info = ပုံနှင့် စာများကို ပြရန် ဝဘ်ဆိုက်များကို ပြန်ဖွင့်ရန် လိုအပ်သည်

clear-site-data-cancel =
    .label = ပယ်​ဖျက်ပါ
    .accesskey = C

clear-site-data-clear =
    .label = ရှင်းလင်းပါ
    .accesskey = l
