# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = سفارش شدا ایکسٹنشن
cfr-doorhanger-feature-heading = تجویز کردہ خصوصیت
cfr-doorhanger-pintab-heading = یہ آزمائیں: پن ٹیب

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = میں یہ کیوں دیکھ رہا ہوں

cfr-doorhanger-extension-cancel-button = ابھی نہیں
    .accesskey = N

cfr-doorhanger-extension-ok-button = اب شامل کریں
    .accesskey = A
cfr-doorhanger-pintab-ok-button = اس ٹیب کو پن کریں
    .accesskey = P

cfr-doorhanger-extension-manage-settings-button = سفارش کی سیٹنگز منظم کریں
    .accesskey = M

cfr-doorhanger-extension-never-show-recommendation = مجھے اس کی سفارش نا دکھائیں
    .accesskey = S

cfr-doorhanger-extension-learn-more-link = مزید سیکھیں

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = { $name } کے ساتھ

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = سفارش
cfr-doorhanger-extension-notification2 = سفارش
    .tooltiptext = ایکسٹینشن کی سفارش
    .a11y-announcement = ایکسٹینشن کی  دتستیاب سفارش

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = سفارشات
    .tooltiptext = خصوصیات سفارشات
    .a11y-announcement = دستیاب خصوصیات سفارشات

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } اسٹار
           *[other] { $total } اسٹارس
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } صارف
       *[other] { $total } صارفین
    }

cfr-doorhanger-pintab-description = اپنی سب سے زیادہ استعمال شدہ سائٹس تک آسانی سے رسائی حاصل کریں۔ سائٹس کو ٹیب میں کھلا رکھیں (یہاں تک کہ جب آپ دوبارہ شروع کریں)۔

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = آپ ٹیب پر <b> دائیں کلک کریں </ b> جس پر آپ پن کرنا چاہتے ہیں۔
cfr-doorhanger-pintab-step2 = مینو سے <b> پن ٹیب </ b> منتخب کریں۔
cfr-doorhanger-pintab-step3 = اگر سائٹ میں تازہ کاری ہوئی تو آپ کو اپنے پن شدہ ٹیب پر ایک نیلا نقطہ نظر آئے گا۔

cfr-doorhanger-pintab-animation-pause = توقف کریں
cfr-doorhanger-pintab-animation-resume = پھر جاری کریں


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = ہر جگہ اپنے بک مارکس کی ہمہ وقت سازی کریں
cfr-doorhanger-bookmark-fxa-body = بہت اچھا! اب آپ کو اپنے موبائل آلات پر اس نشانی کے بغیر نہیں چھوڑے گا۔ ایک { -fxaccount-brand-name } کے ساتھ شروع کریں۔
cfr-doorhanger-bookmark-fxa-link-text = ابھی بک مارک کی ہہمہ وقت سازی کریں…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = بٹن بند کریں
    .title = بند کریں

## Protections panel

cfr-protections-panel-header = بغیر پیروی کیے براؤز کریں
cfr-protections-panel-body = اپنا ڈیٹا اپنے پاس رکھیں۔{ -brand-short-name } آپ کو بہت سے عام ٹریکرس سے بچاتا ہے جواسکی پیروی کر تےھیں کے آپ آن لائن کیا کرتے ہیں ۔
cfr-protections-panel-link-text = مزید سیکھیں

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = نئی خصوصیات

cfr-whatsnew-button =
    .label = نیا کیا ہے
    .tooltiptext = نیا کیا ہے

cfr-whatsnew-panel-header = نیا کیا ہے

cfr-whatsnew-release-notes-link-text = اجرائی نوٹس پڑھیں

cfr-whatsnew-fx70-title = { -brand-short-name } اب آپ کی رازداری کے لئے اب سخت مقابلہ کررہا ہے
cfr-whatsnew-fx70-body = تازہ ترین اپ ڈیٹ ٹریکنگ، پروٹیکشن کی خصوصیت میں اضافہ کرتی ہے اور اسےہر سائٹ کے لئے محفوظ پاس ورڈ بنانے میں  پہلے سے کہیں زیادہ آسان بناتی ہے۔

cfr-whatsnew-tracking-protect-title = اپنے آپ کو  سراغ  کاری سے بچائیں
cfr-whatsnew-tracking-protect-body = { -brand-short-name } بہت سے عام سماجی اور کراس سائٹ ٹریکروں کو روکتا ہے جواسکی پیروی کر تےھیں کے آپ آن لائن کیا کرتے ہیں
cfr-whatsnew-tracking-protect-link-text = اپنی رپورٹ دیکھیں

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] بلاک کردہ ٹریکر
       *[other] بلاک کردہ ٹریکرز
    }
cfr-whatsnew-tracking-blocked-subtitle = چونکہ { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = رپورٹ ملاحظہ کریں

cfr-whatsnew-lockwise-backup-title = اپنے پاس ورڈ کا بیک اپ بنائیں
cfr-whatsnew-lockwise-backup-body = اب محفوظ پاس ورڈ بنائیں جسکو آپ کہیں بھی جہاں آپ سائن ان کرتے ہیں وہاں حاصل کر سکتے ہیں ۔
cfr-whatsnew-lockwise-backup-link-text = بیک اپ کو چالو کریں

cfr-whatsnew-lockwise-take-title = اپنے پاس ورڈ اپنے ساتھ رکھیں
cfr-whatsnew-lockwise-take-body =
     { -lockwise-brand-short-name } موبائل ایپ کی مدد سے آپ کو اپنے پاس محفوظ طریقے سے رسائی حاصل کرنے کی سہولت ملتی ہے
    کہیں سے بھی پاس ورڈز کا بیک اپ لیں۔
cfr-whatsnew-lockwise-take-link-text = اپلیکیشن حاصل کریں

## Search Bar

cfr-whatsnew-searchbar-title = ایڈریس بار کے ساتھ کم ٹائپ کریں ،  مزید ڈھونڈیں
cfr-whatsnew-searchbar-body-topsites = اب ، صرف پتے والی بار منتخب کریں ، اور ایک خانہ آپ کی سرفہرست سائٹوں کے ربط کے ساتھ پھیل جائے گا۔
cfr-whatsnew-searchbar-icon-alt-text = میگنفائنگ گلاس آئکن

## Picture-in-Picture

cfr-whatsnew-pip-header = براؤز کرتے وقت ویڈیوز دیکھیں
cfr-whatsnew-pip-body = تصویر میں تصویر ویڈیو کو تیرتی ونڈو میں ٹمٹماتی ہے تاکہ آپ دوسرے ٹیبز میں کام کرتے ہوئے دیکھ سکیں۔
cfr-whatsnew-pip-cta = مزید سیکھیں

## Permission Prompt

cfr-whatsnew-permission-prompt-header = کم پریشان کن سائٹ پاپ اپز
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } اب سائٹوں کو خود بخود آپ کو پاپ اپ پیغامات بھیجنے کا پوچھنے سے روکتا ہے۔
cfr-whatsnew-permission-prompt-cta = مزید سیکھیں

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] فنگر پرنٹر مسدود ہیں
       *[other] فنگر پرنٹرز مسدود ہیں
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } بہت سے فنگر پرنٹوں کو روکتا ہے جو آپ کی اشتہاری پروفائل بنانے کے لیے چپکے سے آپ کے آلے اور اعمال کے بارے میں معلومات اکٹھا کرتے ہیں۔

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = فنگر پرنٹرز
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } بہت سے فنگر پرنٹوں کو روکتا ہے جو آپ کی اشتہاری پروفائل بنانے کے لیے چپکے سے آپ کے آلے اور اعمال کے بارے میں معلومات اکٹھا کرتے ہیں۔

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = یہ بُک مارک اپنے فون پر حاصل کریں
cfr-doorhanger-sync-bookmarks-ok-button = { -sync-brand-short-name } چالو  کریں
    .accesskey = ت

## Login Sync

cfr-doorhanger-sync-logins-header = دوبارہ کبھی پاس ورڈ مت کھوءیں
cfr-doorhanger-sync-logins-body = اپنے تمام آلات پر پاسورڈ محفوظ طریقے سے محفوظ اور سنک کریں۔
cfr-doorhanger-sync-logins-ok-button = { -sync-brand-short-name } چالو  کریں
    .accesskey = ت

## Send Tab

cfr-doorhanger-send-tab-header = چلتے پھرتے پڑھیں
cfr-doorhanger-send-tab-recipe-header = اس ترکیب کو کچن تک لے جائیں
cfr-doorhanger-send-tab-ok-button = ٹیب بھیجنے کی کوشش کریں
    .accesskey = ت

## Firefox Send

cfr-doorhanger-firefox-send-header = اس PDF کو محفوظ طریقے سے شیئر کریں
cfr-doorhanger-firefox-send-ok-button = { -send-brand-name }آزمائیں
    .accesskey = ت

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = حفظات دیکھیں
    .accesskey = P
cfr-doorhanger-socialtracking-close-button = بند کریں
    .accesskey = چ
cfr-doorhanger-socialtracking-dont-show-again = مجھے دوبارہ اس طرح کے پیغامات نہ دکھائیں
    .accesskey = د
cfr-doorhanger-socialtracking-heading = { -brand-short-name } نے ایک سماجی نیٹ ورک کو یہاں آپ کی سراغ کاری کرنے سے روک دیا ہے
cfr-doorhanger-fingerprinters-heading = { -brand-short-name }  نے اس صفحے پر ایک فنگرپرنٹر کو مسدود کردیا
cfr-doorhanger-cryptominers-heading = { -brand-short-name } نے اس صفحے پر ایک کرپٹوماٴینر کو مسدود کردیا

## Enhanced Tracking Protection Milestones

cfr-doorhanger-milestone-ok-button = تمام دیکھیں
    .accesskey = س

cfr-doorhanger-milestone-close-button = بند کریں
    .accesskey = C

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = آسانی سے محفوظ پاس ورڈ بنائیں
cfr-whatsnew-lockwise-icon-alt = { -lockwise-brand-short-name }  آئیکن

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = کمزور پاس ورڈ کے بارے میں انتباہات حاصل کریں
cfr-whatsnew-passwords-icon-alt = کمزور پاس ورڈ کی کلیدی آئکن

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-icon-alt = پکچر-ان-پکچر آئیکن

## Protections Dashboard message

cfr-whatsnew-protections-header = ایک نظر میں حفاظت
cfr-whatsnew-protections-cta-link = حفاظتی ڈیش بورڈ دیکھیں
cfr-whatsnew-protections-icon-alt = شیلڈ آئیکن

## Better PDF message

cfr-whatsnew-better-pdf-header = بہتر پی ڈی ایف کا تجربہ
cfr-whatsnew-better-pdf-body = پی ڈی ایف دستاویزات اب آپ کے کام کے بہاؤ کی آسان رسائ برقرار رکھتے ہوئے ، براہ راست { -brand-short-name }. میں کھلتی ہیں۔

## DOH Message

cfr-doorhanger-doh-primary-button = ٹھیک ہے مجھے سمجھ آگئی ہے
    .accesskey = O
cfr-doorhanger-doh-secondary-button = غیر فعال بنایے
    .accesskey = D

## What's new: Cookies message

