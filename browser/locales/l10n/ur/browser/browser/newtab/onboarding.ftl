# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = مزید سیکھیں
onboarding-button-label-get-started = شروع کریں

## Welcome modal dialog strings

onboarding-welcome-header = { -brand-short-name } میں خوش آمدید
onboarding-welcome-body = آپ کو براؤزر مل گیا ہے۔ <br/> باقی { -brand-product-name } سے ملیں۔
onboarding-welcome-learn-more = فوائد کے بارے میں مزید سیکھیں۔
onboarding-welcome-modal-get-body = آپ کو براؤزر مل گیا ہے۔ <br/> اس { -brand-product-name } سب کچھ حاصل کریں۔
onboarding-welcome-modal-supercharge-body = اپنی رازداری کے تحفظ کو سپرچارج کریں۔
onboarding-welcome-modal-privacy-body = آپ کو براؤزر مل گیا ہے۔ آئیے مزید رازداری تحفظات شامل کریں۔
onboarding-welcome-modal-family-learn-more = مصنوعات کے { -brand-product-name } کے کنبہ کے بارے میں جانیں۔
onboarding-welcome-form-header = یہاں سے شروع کرو

onboarding-join-form-body = شروع کرنے کے لئے اپنا ای میل ایڈریس درج کریں۔
onboarding-join-form-email =
    .placeholder = ای میل درز کریں
onboarding-join-form-email-error = جائز ای میل کی ظرورت ہے
onboarding-join-form-continue = جاری رکھیں

# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = کیا پہلے سے ہی ایک اکاؤنٹ ہے؟
# Text for link to submit the sign in form
onboarding-join-form-signin = سائن ان کریں

onboarding-start-browsing-button-label = براؤزنگ شروع کریں
onboarding-cards-dismiss =
    .title = برخاست کریں
    .aria-label = برخاست کریں

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = <span data-l10n-name="zap">{ -brand-short-name }</span> میں خوشامدید
onboarding-multistage-welcome-subtitle = تیز ، محفوظ ، اور نجی براؤزر جس کو غیر منافع بخش کی حمایت حاصل ہے۔
onboarding-multistage-welcome-primary-button-label = سیٹ اپ شروع کریں
onboarding-multistage-welcome-secondary-button-label = سائن ان کریں
onboarding-multistage-welcome-secondary-button-text = کیا آپ کا اکاؤنٹ ہے؟

onboarding-multistage-import-subtitle = کسی دوسرے براؤزر سے آرہے ہیں؟ سب چیزوں کو { -brand-short-name } پر لانا آسان ہے۔
onboarding-multistage-import-primary-button-label = درآمد شروع کریں
onboarding-multistage-import-secondary-button-label = ابھی نہیں

onboarding-multistage-theme-primary-button-label = تھیم کو محفوظ کریں
onboarding-multistage-theme-secondary-button-label = ابھی نہیں

# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = خودکار

# System refers to the operating system
onboarding-multistage-theme-description-automatic = سسٹم تھیم استعمال کریں

onboarding-multistage-theme-label-light = ہلکا
onboarding-multistage-theme-label-dark = گہرا
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox الپینگلو

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.


## Welcome full page string

onboarding-fullpage-welcome-subheader = آئیے آپ جو کچھ بھی کر سکتے ہیں اس کی دریافت شروع کریں۔
onboarding-fullpage-form-email =
    .placeholder = آپکا ای میل ایڈرس…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = { -brand-product-name }کو  اپنے ساتھ جائے
onboarding-sync-welcome-content = اپنے تمام آلات پر اپنی نشانیاں ، سابقات ، پاس ورڈ اور دیگر سیٹنگز حاصل کریں۔
onboarding-sync-welcome-learn-more-link = Firefox اکاؤنٹس کے بارے میں مزید سیکھیں

onboarding-sync-form-input =
    .placeholder = ای میل

onboarding-sync-form-continue-button = جاری رکھیں
onboarding-sync-form-skip-login-button = اس مرحلے کو چھوڑیں

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = اپنی ای میل داخل کریں
onboarding-sync-form-sub-header = { -sync-brand-name } کو جاری رکھنے کے  لیے


## These are individual benefit messages shown with an image, title and
## description.

# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = ہم جو بھی کام کرتے ہیں وہ ہمارے ذاتی ڈیٹا کے وعدے کی قدر کرتا ہے: کم لیں۔ اسے محفوظ رکھیں۔ کوئی راز نہیں۔

onboarding-benefit-sync-title = { -sync-brand-short-name }

onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = جب آپ کی ذاتی معلومات معروف ڈیٹا کی خلاف ورزی میں ہے تو مطلع ھوں۔

onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = پاس ورڈ کا نظم کریں جو محفوظ اور پورٹیبل ہیں۔


## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = سراغ کاری سے تحفظ
onboarding-tracking-protection-button2 = یہ کیسے کام کرتا ہے

onboarding-data-sync-title = اپنی سیٹنگز اپنے ساتھ رکھیں
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = جہاں بھی آپ { -brand-product-name } استعمال کرتے ہیں ہر جگہ اپنے بُک مارکس ، پاس ورڈز اور  مزید چیزوں کو سنک کریں ۔
onboarding-data-sync-button2 = { -sync-brand-short-name } میں  سائن ان کریں

onboarding-firefox-monitor-title = ڈیٹا کی خلاف ورزیوں پر الرٹ رہیں
onboarding-firefox-monitor-button = الرٹس کے لئے سائن اپ کریں

onboarding-browse-privately-title = رازداری سے براؤز کریں
onboarding-browse-privately-text = نجی براؤزنگ آپ کے کمپیوٹر کو استعمال کرنے والے ہر شخص سے خفیہ رکھنے کے لیے آپ کی تلاش اور براؤزنگ کی سابقات کو صاف کردیتی ہے۔
onboarding-browse-privately-button = نجی ونڈو میں کھولیں؟

onboarding-firefox-send-title = اپنی مشترکہ امسال نجی رکھیں
onboarding-firefox-send-button = { -send-brand-name }آزمائیں

onboarding-mobile-phone-title = { -brand-product-name }  اپنے فون پر حاصل کریں
onboarding-mobile-phone-text = iOS یا Android  کے لئے { -brand-product-name } ڈونلوڈ کریں اور تمام آلات پر ڈیٹا سنک کریں.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = موبائل براؤزر ڈاؤن لوڈ کریں

onboarding-send-tabs-title = فوری طور پر خود کو ٹیبس ارسال کریں
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = لنکس کاپی کیے بغیر یا براؤزر کو چھوڑے بغیر اپنے آلات کے درمیان آسانی سے صفحات کا اشتراک کریں۔
onboarding-send-tabs-button = Send Tabs کا  استعمال شروع کریں

onboarding-pocket-anywhere-title = کہیں بھی پڑھیں اور سنیں
onboarding-pocket-anywhere-text2 = اپنے پسندیدہ مواد کو آف لائن{ -pocket-brand-name }ایپ کے ساتھ محفوظ کریں اور جب بھی آپ کے لئے مناسب ہو پڑھیں ، سنیں اور دیکھیں۔
onboarding-pocket-anywhere-button = { -pocket-brand-name } آزمائیں

onboarding-lockwise-strong-passwords-title = مضبوط پاس ورڈز بنائیں اور محفوظ کریں
onboarding-lockwise-strong-passwords-button = اپنے  لاگ ان بندوبست کریں

onboarding-facebook-container-title = Facebook کے ساتھ حدود طے کریں
onboarding-facebook-container-button = ایکسٹینشن شامل کریں

onboarding-import-browser-settings-title = اپنے بُک مارکس ، پاس ورڈز اور بہت کچھ درآمد کریں
onboarding-import-browser-settings-text = سیدھے ڈوبکی  لگائیں — آسانی سے اپنے ساتھ اپنی Chrome سائٹس اور سیٹنگیں اپنے ساتھ لائیں۔
onboarding-import-browser-settings-button = chrome ڈیٹا درآمد کریں

onboarding-personal-data-promise-title = ڈیزائن کے طور پر نجی ہے
onboarding-personal-data-promise-button = ہمارا وعدہ پڑھیں

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = بہت اچھا ، آپ کو { -brand-short-name } مل گیا ہے

# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = چلیں آئیے آپ کو <icon></icon><b>{ $addon-name }.</b>
return-to-amo-extension-button = اس توسیع شامل کریں
return-to-amo-get-started-button = { -brand-short-name } کے ساتھ شروع کریں
