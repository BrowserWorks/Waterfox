# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } က မမှန်ကန်တဲ့ လုံခြုံရေး လက်မှတ်တခုကို သုံးစွဲနေတယ်။
cert-error-mitm-intro = လက်မှတ်ထုတ်ပေးသောသူများ ဆီ မှ လက်မှတ်များဖြင့် ဝတ်ဆိုဒ်များသည် ၎င်းတို့ ၏ အိုင်ဒီကို သက်သေပြကြသည်
cert-error-mitm-mozilla = { -brand-short-name } သည် Mozilla ဆိုသည့်  လွတ်လပ်သော  လက်မှတ်စီမံသောစတိုး တစ်ခုအားခန့်ခွဲနေသည့် အကျိုးအမြတ်မယူသော အဖွဲ့အစည်းတစ်ခုမှ ထောက်ပံ့ပေးထားပါသည်.။ CA လက်မှတ်စတိုး သည် လက်မှတ်ထုတ်သူများအား သုံးဆွဲသူတွေအတွက် အကောင်းဆုံးသော လုံခြုံမှုကို ပေးစေရန် လုပ်ဆောင်ပေးပါသည်။
cert-error-mitm-connection = { -brand-short-name } သည် အသုံးပြုသူ ၏ စန်လည်ပတ်မှု့ မှ ထောက်ပံ့သော လုံခြုံရေး လက်မှတ်များ ထက် ဆက်သွယ်မှုတစ်ခု လုံခြုံမှု ရှိမရှိ စစ်ဆေးရန် Mozilla CA စတိုးကိုအသုံးပြုသည်။ ထို့ကြောင့်၊ ဗိုင်းရပ်စ်နှိမ်နင်းရေးပရိုဂရမ်တစ်ခုသို့မဟုတ်ကွန်ယက်တစ်ခုသည် Mozilla CA စတိုးတွင်မပါရှိသော CA မှ ထုတ်ပေးသော လုံခြုံရေး လက်မှတ်နှင့် ဆက်သွယ်မှုကို ကြားဖြတ် နေလျှင် ၎င်း ဆက်သွယ်မှုသည် လုံခြုံမှုမရှိနိုင်ပါ။
cert-error-trust-unknown-issuer-intro = တစ်စုံတစ်ဦး မှ ဆိုက်ကိုအယောင်ဆောင်ဖို့ကြိုးစားနေနိုင်ပြီးသင်ဆက်မလုပ်သင့်ပါ။
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = ဝက်ဘ်ဆိုက်များ မှ ၎င်းတို့ စစ်မှန်ကြောင်း ကို လုံခြုံရေး လက်မှတ်များဖြင့် သက်သေခံကြသည်။ { -brand-short-name } သည် { $hostname } ကိုမယုံကြည်ပေ၊ အကြောင်းက သူ၏ လက်မှတ် ထုတ်ပေးသူကို မသိပါ၊ သက်သေခံ လက်မှတ် သည် ကိုယ်တိုင်ပြုလုပ်ထားခြင်း သို့မဟုတ် ဆာဗာ မှ မှန်ကန်သော ကြားခံ သက်သေခံလက်မှတ် မပို့ပါ
cert-error-trust-cert-invalid = လက်မှတ်ကို မမှန်ကန်တဲ့ CA လက်မှတ် တခုက ထုတ်ပြန်ထားတဲ့ အတွက် စိတ်မချရဘူး။
cert-error-trust-untrusted-issuer = လက်မှတ်ကို လက်မှတ် ထုတ်ပြန်သူကို စိတ်မချတဲ့ အတွက် စိတ်မချရဘူး။
cert-error-trust-signature-algorithm-disabled = The certificate is not trusted because it was signed using a signature algorithm that was disabled because that algorithm is not secure.
cert-error-trust-expired-issuer = လက်မှတ်ကို လက်မှတ် ထုတ်ပြန်သူကို စိတ်မချတဲ့ အတွက် စိတ်မချရဘူး။
cert-error-trust-self-signed = လက်မှတ်ကို ကိုယ်တိုင် ရေးထိုးထားတဲ့ အတွက် စိတ်မချရဘူး။
cert-error-trust-symantec = GeoTrust၊ RapidSSL, Symantec, Thawte နှင့် VeriSign တို့မှထုတ်ပေးထားသောလက်မှတ်များသည်လုံခြုံမှုမရှိတော့ပါ။ အကြောင်းမှာ ထိုအာဏာပိုင်များသည်ယခင်ကလုံခြုံရေးအလေ့အထများကိုမလိုက်နာသောကြောင့်ဖြစ်သည်။
cert-error-untrusted-default = လက်မှတ်ဟာ စိတ်ချရတဲ့ ရင်းမြစ်က မဟုတ်ပါ။
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = ဝက်ဘ်ဆိုက်များ မှ ၎င်းတို့ စစ်မှန်ကြောင်း ကို လုံခြုံရေး လက်မှတ်များဖြင့် သက်သေခံကြသည်။ { -brand-short-name } သည် ဤဆိုက် ကို မယုံကြ‌ည်ပါ၊ အကြောင်းက { $hostname } အတွက်မှန်ကန်တဲ့ လက်မှတ် မဟုတ်သောကြောင့် ဖြစ်သည်။
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = ဝက်ဘ်ဆိုက်များ မှ ၎င်းတို့ စစ်မှန်ကြောင်း ကို လုံခြုံရေး လက်မှတ်များဖြင့် သက်သေခံကြသည်။ { -brand-short-name } သည် ဒီဆိုက်ကို မယုံကြည်ပါ၊ အကြောင်းက ဒီ လက်မှတ်သည် { $hostname } အတွက် တရားဝင်ပါ၊ { $alt-name } အတွက်သာ တရားဝင်ပါသည်။
# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = ဝက်ဘ်ဆိုက်များ မှ ၎င်းတို့ စစ်မှန်ကြောင်း ကို လုံခြုံရေး လက်မှတ်များဖြင့် သက်သေခံကြသည်။ { -brand-short-name } သည် ဒီဆိုက်ကို မယုံကြည်ပါ၊ အကြောင်းက ဒီ လက်မှတ်သည် { $hostname } အတွက် တရားဝင်ပါ။ ဒီ လက်မှတ် သည် ဖော်ပြပါ နာမည် များ:{ $subject-alt-names } တို့ အတွက်သာ တရားဝင်သည်။
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = ဝက်ဘ်ဆိုက်များ မှ ၎င်းတို့ စစ်မှန်ကြောင်း ကို လုံခြုံရေး လက်မှတ်များဖြင့် သက်သေခံကြသည်။ ထို လက်မှတ်များသည် အချိန်ကာလ တစ်ခုအထိသာ တရားဝင်သည်။ { $hostname } အတွက် လက်မှတ်သည် { $not-after-local-time } တွင် သက်တမ်း ကုန်သည်။
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = ဝက်ဘ်ဆိုက်များ မှ ၎င်းတို့ စစ်မှန်ကြောင်း ကို လုံခြုံရေး လက်မှတ်များဖြင့် သက်သေခံကြသည်။ ထို လက်မှတ်များသည် အချိန်ကာလ တစ်ခုအထိသာ တရားဝင်သည်။ { $hostname } အတွက် လက်မှတ်သည် { $not-before-local-time } မတိုင်ခင် ထိတရားမဝင်ပါ။
# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = အမှား ကုဒ် : <a data-l10n-name="error-code-link">{ $error }</a>
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = ၀က်ဘ်ဆိုက်များ မှာ ၎င်းတို့ ၏ သက်သေခံ လက်မှတ်ကို လက်မှတ် ထုတ်ပိုင်ခွင့် အာဏာရှိသူမှ ထုတ်ပေး ကာ သက်သေခံ ကြသည်။ Browser အများစုသည် GeoTrust, RapidSSL, Symantec, Thawte နှင့် VeriSign မှထုတ်ပေးသော လက်မှတ်များ ကို မယုံကြည် တော့ပါ။ { $hostname } သည်ဤအာဏာပိုင်များအနက်မှ လက်မှတ်တစ်ခု ကိုအသုံးပြု သောကြောင့် ဝက်ဘ်ဆိုက်၏ စစ်မှန်မှု့ ကိုအတည်မပြုနိုင်ပါ။
cert-error-symantec-distrust-admin = ဝက်ဘ်ဆိုက် အုပ်ချုပ်သူများ ကို အဆိုပါ ပြဿနာ အကြောင်း ကို သတင်းပို့ပါ။
# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }
# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }
cert-error-details-cert-chain-label = Certificate chain:
open-in-new-window-for-csp-or-xfo-error = ဆိုက်ကို ဝင်းဒိုးအသစ်တွင် ဖွင့်ပါ
# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = သင်၏လုံခြုံရေးကိုကာကွယ်ရန် { -brand-short-name } သည် အခြားဆိုဒ် တစ်ခု ပေါင်းစပ် နေသော { $hostname } ၏ စာမျက်နှာအားဖော်ပြခွင့်မပြုပါ။ ဤစာမျက်နှာကို ကြည့်လိုပါက သင် ၎င်းကို ဝင်းဒိုး အသစ် တွင် ဖွင့်ရန်လိုသည်။

## Messages used for certificate error titles

connectionFailure-title = မချိတ်ဆက်နိုင်ပါ
deniedPortAccess-title = ယခုလိပ်စာကို တားမြစ်ထားသည်
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = အို့။ ထိုဝဘ်ဆိုက်ကို ရှာမတွေ့ပါ။
fileNotFound-title = ဖိုင် မတွေ့ရပါ
fileAccessDenied-title = ဖိုင်အသုံးပြုခြင်းကို တားမြစ်ထားသည်
generic-title = မဆောင်ရွက်နိုင်ခဲ့ပါ
captivePortal-title = ကွန်ယက်သို့ ဝင်ရောက်ပါ
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = ဟမ်။ ဒီလိပ်စာက မှန်ကန်မယ်မထင်ဘူး။
netInterrupt-title = ချိတ်ဆက်မှု ပြတ်တောက်သွားခဲ့သည်
notCached-title = စာတမ်းသည် ဆွဲယူရန် သတ်မှတ်ချိန် ကျော်လွန်သွားသည်
netOffline-title = ချိတ်ဆက်မဲ့ စနစ်
contentEncodingError-title = အကြောင်းအရာ အန်ကုဒ်ဒင်း အမှား
unsafeContentType-title = အန္တရာယ်မကင်းသော ဖိုင်အမျိုးအစား
netReset-title = ချိတ်ဆက်မှုပြတ်တောက်ပြီး ပြန်ချိတ်ခဲ့သည်
netTimeout-title = ချိတ်ဆက်မှုသည် သတ်မှတ်ချိန် ကျော်လွန်ခဲ့သည်
unknownProtocolFound-title = လိပ်စာကို နားမလည်ပါ
proxyConnectFailure-title = ကြားခံဆာဗာသည် ချိန်ဆက်မှုများကို လက်မခံပါ
proxyResolveFailure-title = ကြားခံဆာဗာကို ရှာမတွေ့ပါ
redirectLoop-title = ယခုစာမျက်နှာသည် ကောင်းမွန်စွာ လမ်းညွှန်မပေးနိုင်ပါ
unknownSocketType-title = ဆာဗာထံမှ မမျှော်မှန်းထားသော တုံ့ပြန်ချက်
nssFailure2-title = လုံခြုံသောချိတ်ဆက်မှု မအောင်မြင်ပါ
csp-xfo-error-title = { -brand-short-name } သည် ဤ စာမျက်နှာ ကို မဖွင့်နိုင်ပါ
corruptedContentError-title = အကြောင်းအရာ မစုံလင်သော အမှား
remoteXUL-title = Remote XUL
sslv3Used-title = လုံခြုံစိတ်ချစွာ မချိတ်ဆက်နိုင်ပါ
inadequateSecurityError-title = ချိတ်ဆက်မှုသည် မလုံခြုံပါ
blockedByPolicy-title = ပိတ်ပင်ထားသော စာမျက်နှာ
clockSkewError-title = သင့် ကွန်ပျူတာ၏နာရီ မှားနေသည်
networkProtocolError-title = ကွန်ယက် လုပ်ထုံး (ပရိုတိုကော) အမှား
nssBadCert-title = သတိပေးချက်: လုံခြုံရေးအန္တရာယ်
nssBadCert-sts-title = လုံခြုံရေးပြဿနာကြောင့် မချိတ်ဆက်ခဲ့ပါ။
certerror-mitm-title = ဆော့ဝဲ သည် { -brand-short-name } မှ ဤ ဆိုက်ကို လုံခြုံစွာ ချိတ်ဆက်ရန် ကာကွယ်နေသည်
