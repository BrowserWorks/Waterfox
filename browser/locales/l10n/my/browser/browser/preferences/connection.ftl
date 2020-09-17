# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

connection-window =
    .title = ချိတ်ဆက်မှု အပြင်အဆင်များ
    .style =
        { PLATFORM() ->
            [macos] width: 44em
           *[other] width: 49em
        }
connection-close-key =
    .key = w
connection-disable-extension =
    .label = ပေါင်းထည့်တိုးချဲ့မှု ပိတ်ရန်
connection-proxy-configure = အင်တာနက်အသုံးပြုရန် ကြားခံအပြင်အဆင်ကို ပြုပြင်ပါ
connection-proxy-option-no =
    .label = ကြားခံဆာဗာ မသုံးပါ
    .accesskey = y
connection-proxy-option-system =
    .label = စနစ်တွင် သတ်မှတ်ထားသော ကြားခံဆာဗာ အပြင်အဆင်များကို အသုံးပြုပါ
    .accesskey = u
connection-proxy-option-auto =
    .label = ယခုကွန်ယက်အတွက် ကြားခံဆာဗာ အပြင်အဆင်များကို အလိုအလျောက် ရှာပြီး ချိတ်ဆက်ပါ
    .accesskey = w
connection-proxy-option-manual =
    .label = ကြားခံဆာဗာ အပြင်အဆင်ကို ကိုယ်တိုင်ပြင်ဆင်သတ်မှတ်ရန်
    .accesskey = M
connection-proxy-http = HTTP ကြားခံဆာဗာ
    .accesskey = x
connection-proxy-http-port = Port
    .accesskey = P
connection-proxy-ssl-port = Port
    .accesskey = o
connection-proxy-ftp = FTP ကြားခံဆာဗာ
    .accesskey = F
connection-proxy-ftp-port = Port
    .accesskey = r
connection-proxy-socks = SOCKS Host
    .accesskey = C
connection-proxy-socks-port = Port
    .accesskey = t
connection-proxy-socks4 =
    .label = SOCKS v4
    .accesskey = K
connection-proxy-socks5 =
    .label = SOCKS v5
    .accesskey = v
connection-proxy-noproxy = ယခုအတွက် ကြားခံဆာဗာ မသုံးပါနှင့်
    .accesskey = N
connection-proxy-noproxy-desc = ဥပမာ။ .mozilla.org, .net.nz, 192.168.1.0/24
connection-proxy-autotype =
    .label = အလိုအလျောက် ကြားခံဆာဗာကို ပြုပြင်ပေးသော URL
    .accesskey = A
connection-proxy-reload =
    .label = ပြန်ဖွင့်ပါ
    .accesskey = e
connection-proxy-autologin =
    .label = စကားဝှက် သိမ်းပြီးသားရှိပါက အတည်ပြုခြင်းအတွက် ထပ်မမေးပါနှင့်
    .accesskey = i
    .tooltip = ကြားခံဆာဗာများအတွက် အတည်ပြုအချက်အလက်များကို သိမ်းထားပါက ယခုအပြင်အဆင်သည် ကြားခံဆာဗာများနှင့် အတည်ပြုရာတွင် တိတ်ဆိတ်စွာ ဆောင်ရွက်ပေးသည်။ အကယ်၍ အတည်ပြုခြင်း မအောင်မြင်ပါက အတည်ပြုအချက်အလက်ကို တောင်းခံပါမည်။
connection-proxy-socks-remote-dns =
    .label = SOCKS v5 ကို အသုံးပြုသည့်အခါ DNS ကို ကြားခံအနေဖြင့် အသုံးပြုပါ
    .accesskey = d
connection-dns-over-https =
    .label = HTTPS ဖြင့် DNS ကို သုံးပါ
    .accesskey = b
# Variables:
#   $name (String) - Display name or URL for the DNS over HTTPS provider
connection-dns-over-https-url-item-default =
    .label = { $name } (မူလသတ်မှတ်ချက်)
    .tooltiptext = HTTPS ပေါ်မှ DNS ရယူချင်း အတွက် URL ကို မူလသတ်မှတ်ချက်အတိုင်း သုံးမည်
connection-dns-over-https-url-custom =
    .label = စိတ်ကြိုက်
    .accesskey = C
    .tooltiptext = Enter your preferred URL for resolving DNS over HTTPS
