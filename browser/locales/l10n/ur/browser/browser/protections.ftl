# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] پچھلے ایک ہفتہ کے دوران { -brand-short-name } مسدود{ $count } ٹریکرز
       *[other] پچھلے ایک ہفتہ کے دوران { -brand-short-name } مسدود{ $count } ٹریکرز
    }

# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = اس ہفتے ٹریکرز{ -brand-short-name } مسدود ہیں

protection-report-settings-link = رازداری اور سیکورٹی کی ترتیبات کو بندرست کریں.

etp-card-title-always = بہتر ٹریکنگ پروٹیکشن: ہمیشہ  چالو
etp-card-title-custom-not-blocking = بہتر ٹریکنگ پروٹیکشن:  بند
protection-report-manage-protections = سیٹنگز بندرست کریں

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = آج

# This string is used to describe the graph for screenreader users.
graph-legend-description = اس ہفتے ہر طرح کے ٹریکر کی کل تعداد پر مشتمل گراف۔

social-tab-title = سوشل میڈیا ٹریکرز

cookie-tab-title = کراس-سائٹ ٹریکنگ کوکیز

tracker-tab-title = ٹریکنگ مواد

fingerprinter-tab-title = فنگر پرنٹرز

cryptominer-tab-title = کریپٹومینر

protections-close-button2 =
    .aria-label = بند کریں
    .title = بند کریں
  
mobile-app-title = مزید آلات میں اشتہار ٹریکروں کو مسدود کریں
mobile-app-card-content = اشتہار سے باخبر رہنے کے خلاف بلٹ ان تحفظ کے ساتھ موبائل براؤزر کا استعمال کریں۔

lockwise-title = دوبارہ کبھی پاس ورڈ مت بھولیے
lockwise-title-logged-in2 = پاس ورڈ مینجمنٹ
lockwise-header-content-logged-in = اپنے تمام آلات پر پاسورڈ محفوظ طریقے سے محفوظ اور سنک کریں۔
lockwise-mobile-app-title = اپنے پاس ورڈ ہر جگہ لے جاٴییں
lockwise-no-logins-card-content = کسی بھی ڈیوائس پر { -brand-short-name } میں محفوظ کردہ پاس ورڈ استعمال کریں۔

lockwise-how-it-works-link = یہ کیسے کام کرتا ہے

turn-on-sync = { -sync-brand-short-name } چالو کریں
    .title = سنک ترجیحات  پر جائے

monitor-title = ڈیٹا کی خلاف ورزیوں کو تلاش کریں
monitor-link = یہ کیسے کام کرتا ہے
monitor-sign-up-link = خلاف ورزی کے انتباہات کیلئے سائن اپ کریں
    .title = خلاف ورزی کے انتباہات کیلئے  { -monitor-brand-name } پر  سائن اپ کریں
auto-scan = آج خودکار طور پر اسکین ہوا

monitor-breaches-tooltip =
    .title = { -monitor-brand-short-name } پر معلوم ڈیٹا کی خلاف ورزیوں کو دیکھیں
monitor-passwords-tooltip =
    .title = { -monitor-brand-short-name } پر بے نقاب ہونے والے پاسورڈز دیکھیں

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] ای میل پتہ کی نگرانی کی جارہی ہے
       *[other] ای میل پتوں کی نگرانی کی جارہی ہے
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] معروف اعداد و شمار کی خلاف ورزی نے آپ کی معلومات کو بے نقاب کردیا ہے
       *[other] معروف اعداد و شمار کی خلاف ورزیوں نے آپ کی معلومات کو بے نقاب کردیا ہے
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] پاس ورڈ تمام خلاف ورزیوں کے بے نقاب
       *[other] پاس ورڈز تمام خلاف ورزیوں کے بے نقاب
    }

monitor-no-breaches-title = اچھی خبر!
monitor-breaches-unresolved-title = اپنی خلاف ورزیوں کو حل کریں
monitor-breaches-unresolved-description = خلاف ورزی کی تفصیلات کا جائزہ لینے اور اپنی معلومات کے تحفظ کے لئے اقدامات کرنے کے بعد ، آپ حل شدہ خلاف ورزیوں کو نشان زد کرسکتے ہیں۔
monitor-manage-breaches-link = خلاف ورزیاں  بندرست  کریں
    .title = { -monitor-brand-short-name }  پر  خلاف ورزیاں  بندرست  کریں
monitor-breaches-resolved-title = بہت  اچھے! آپ نے تمام معلوم شدہ  خلاف ورزیوں کو حل کر لیا ہے۔

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved }%  مکمل

monitor-partial-breaches-motivation-title-start = زبردست آغاز!
monitor-partial-breaches-motivation-title-middle = شاباش!
monitor-partial-breaches-motivation-title-end = تقریپا ہو گیا! شاباش۔

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = سوشل میڈیا ٹریکرز
    .aria-label =
        { $count ->
            [one] { $count }سوشل میڈیا ٹریکر{ $percentage }%
           *[other] { $count }سوشل میڈیا ٹریکرز{ $percentage }%
        }
bar-tooltip-tracker =
    .title = ٹریکنگ مواد
    .aria-label =
        { $count ->
            [one] { $count }ٹریکنگ مواد{ $percentage }%
           *[other] { $count }ٹریکنگ مواد{ $percentage }%
        }
bar-tooltip-fingerprinter =
    .title = فنگر پرنٹرز
    .aria-label =
        { $count ->
            [one] { $count }فنگر پرنٹرز{ $percentage }%
           *[other] { $count }فنگر پرنٹرز{ $percentage }%
        }
bar-tooltip-cryptominer =
    .title = کریپٹومینر
    .aria-label =
        { $count ->
            [one] { $count }کریپٹومینر{ $percentage }%
           *[other] { $count }کریپٹومینرز{ $percentage }%
        }
