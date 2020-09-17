# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = တင်သွင်းခြင်းဆိုင်ရာ လုပ်ငန်းစဉ်
import-from =
    { PLATFORM() ->
        [windows] ရွေးစရာများ၊ မှတ်သားချက်များ၊ မှတ်တမ်း၊ စကားဝှက်များနဲ့ အ​ခြား အချက်အလက်ကြမ်း တင်သွင်းမဲ့ နေရာ၊
       *[other] Import Preferences, Bookmarks, History, Passwords and other data from:
    }
import-from-bookmarks = မှတ်သားချက်များ တင်သွင်းမဲ့ နေရာ၊
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-edge-legacy =
    .label = Microsoft Edge Legacy
    .accesskey = L
import-from-edge-beta =
    .label = Microsoft Edge Beta
    .accesskey = d
import-from-nothing =
    .label = မည်သည့်အရာကိုမျှ မတင်သွင်းပါနှင့်
    .accesskey = D
import-from-safari =
    .label = Safari
    .accesskey = S
import-from-canary =
    .label = Chrome Canary
    .accesskey = n
import-from-chrome =
    .label = Chrome
    .accesskey = C
import-from-chrome-beta =
    .label = Chrome Beta
    .accesskey = B
import-from-chrome-dev =
    .label = Chrome Dev
    .accesskey = D
import-from-chromium =
    .label = Chromium
    .accesskey = u
import-from-firefox =
    .label = မီးမြေခွေး
    .accesskey = x
import-from-360se =
    .label = 360 လုံခြုံသော ဘရောင်ဇာ
    .accesskey = 3
no-migration-sources = မှတ်သားချက်များ၊ မှတ်တမ်း သို့ စကားဝှက် အချက်အလက်ကြမ်း ပါ၀င်တဲ့ ဘယ် ပရိုဂရမ်များမှ မတွေ့ရဘူး။
import-source-page-title = အပြင်အဆင်များနဲ့ အချက်အလက်ကြမ်း တင်သွင်းပါ
import-items-page-title = တင်သွင်းရန် အချက်‌များ
import-items-description = တင်သွင်းရန် ဘယ်အချက်များကို ရွေးမလဲ၊
import-migrating-page-title = တင်သွင်းနေသည်…
import-migrating-description = အောက်ပါ အချက်များကို လောလောဆယ် တင်သွင်းနေတယ်...
import-select-profile-page-title = ရွေးပိုင်သုံးစွဲမှု ရွေးချယ်ပါ
import-select-profile-description = အောက်ပါ ကိုယ်ရေးမှတ်တမ်းများကို တင်သွင်းလို့ ရနိုင်တဲ့နေရာ၊
import-done-page-title = တင်သွင်းချက် ပြီးသွားပြီ
import-done-description = အောက်ပါ အချက်‌များကို အောင်မြင်စွာ တင်သွင်းခဲ့ပြီ၊
import-close-source-browser = ဆက်လက် မဆောင်ရွက်ခင် ကျေးဇူးပြု၍ ရွေးထားသည့် ဘရောင်ဇာသည် ပိတ်ထားခြင်း ရှိ/မရှိ စစ်ပါ။
# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = { $source } မှ
source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-safari = Safari
source-name-canary = Google Chrome Canary
source-name-chrome = Google Chrome
source-name-chrome-beta = Google Chrome Beta
source-name-chrome-dev = Google Chrome Dev
source-name-chromium = Chromium
source-name-firefox = Mozilla Firefox
source-name-360se = 360 Secure Browser
imported-safari-reading-list = ဖတ်ရှုစာရင်း (Safari မှ)
imported-edge-reading-list = ဖတ်နေဆဲ စာရင်း (Edge မှ)

## Browser data types
## All of these strings get a $browser variable passed in.
## You can use the browser variable to differentiate the name of items,
## which may have different labels in different browsers.
## The supported values for the $browser variable are:
## 360se
## chrome
## edge
## firefox
## ie
## safari
## The various beta and development versions of edge and chrome all get
## normalized to just "edge" and "chrome" for these strings.

browser-data-cookies-checkbox =
    .label = ကွတ်ကီးများ
browser-data-cookies-label =
    .value = ကွတ်ကီးများ
browser-data-formdata-checkbox =
    .label = သိမ်းထားသည့် ဖောင်ဖြည့်မှတ်တမ်း
browser-data-formdata-label =
    .value = သိမ်းထားသည့် ဖောင်ဖြည့်မှတ်တမ်း
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = သိမ်းဆည်းအကောင့်ဝင်ရောက်မှုနှင့်စကားဝှက်များ
browser-data-otherdata-checkbox =
    .label = အခြား အချက်အလက်
browser-data-otherdata-label =
    .label = အခြား အချက်အလက်
browser-data-session-checkbox =
    .label = ၀င်းဒိုးနှင့် တပ်ဗ်များ
browser-data-session-label =
    .value = ၀င်းဒိုးနှင့် တပ်ဗ်များ
