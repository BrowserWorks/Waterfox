# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = { $addon-name }  کے  لیے رپورٹ

abuse-report-title-extension = اس توسیع کی اطلاع{ -vendor-short-name } کو دیں
abuse-report-title-theme = اس تھیم کو { -vendor-short-name } رپورٹ کریں
abuse-report-subtitle = کیا مسئلہ ہے؟

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = <a data-l10n-name="author-name">{ $author-name }</a>  کی جانب سے

abuse-report-submit-description = مسئلہ کی وضاحت (اختیاری)
abuse-report-textarea =
    .placeholder = اگر ہمارے پاس کوئی مخصوص وضاحت ہو تو ہمارے لئے کسی مسئلے کو حل کرنا آسان ہے۔ براہ کرم اپنا تجربہ بیان کریں کہ آپ کس چیز کا سامنا کر رہے ہیں۔ ویب کو صحت مند رکھنے میں ہماری مدد کرنے کے لئے آپ کا شکریہ۔
abuse-report-submit-note =
    نوٹ: ذاتی معلومات (جیسے نام ، ای میل ایڈریس ، فون نمبر ، جسمانی پتہ) شامل نہ کریں۔
    { -vendor-short-name } ان رپورٹس کا مستقل ریکارڈ رکھتا ہے۔

## Panel buttons.

abuse-report-cancel-button = منسوخ کریں
abuse-report-next-button = آگے
abuse-report-goback-button = پیچھے جائیں
abuse-report-submit-button = ‏‏جمع کریں

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = <span data-l10n-name = "addon-name"> { $addon-name } </span> کی رپورٹ منسوخ کردی گئی۔
abuse-report-messagebar-submitting = <span data-l10n-name = "addon-name"> { $addon-name } </span> کیلئے رپورٹ بھیجنا۔
abuse-report-messagebar-submitted = رپورٹ چمع کرانے کا  شکریہ۔ کیا آپ  <span data-l10n-name="addon-name">{ $addon-name } کو ہٹانا  چاہتے ہیں؟
abuse-report-messagebar-submitted-noremove = رپورٹ جمع کرنے کا شکریہ۔
abuse-report-messagebar-removed-extension = رپورٹ جمع کرنے کا شکریہ۔ آپنے ایکسٹینشن { $addon-name }</span><span data-l10n-name="addon-name"> کو ہٹا دیا ہے۔
abuse-report-messagebar-removed-theme = رپورٹ جمع کرنے کا شکریہ۔ آپنے تھیم{ $addon-name }</span><span data-l10n-name="addon-name"> کو ہٹا دیا ہے۔
abuse-report-messagebar-error-recent-submit = <span data-l10n-name ="addon-name"> { $addon-name }</span> کے لئے رپورٹ نہیں بھیجی گئی تھی کیونکہ حال ہی میں ایک اور رپورٹ پیش کی گئی تھی۔

## Message bars actions.

abuse-report-messagebar-action-remove-extension = ہاں ، اسے ہٹا دیں
abuse-report-messagebar-action-keep-extension = نہیں ، میں اسے رکھوں گا
abuse-report-messagebar-action-remove-theme = ہاں ، اسے ہٹا دیں
abuse-report-messagebar-action-keep-theme = نہیں ، میں اسے رکھوں گا
abuse-report-messagebar-action-retry = ‏‏دوبارہ کوشش کریں
abuse-report-messagebar-action-cancel = منسوخ کریں

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = اس نے میرے کمپیوٹر کو نقصان پہنچایا یا میرے ڈیٹا سے سمجھوتہ کیا
abuse-report-damage-example = مثال: انجکشن شدہ مالویئر یا ڈیٹا چوری کرنا

abuse-report-spam-reason-v2 = اس میں اسپام ہے یا ناپسندیدہ اشتہار داخل ہوتا ہے
abuse-report-spam-example = مثال: ویب صفحات پر اشتہارات داخل کریں

abuse-report-settings-reason-v2 = مجھ کو بتائے یا پوچھے بغیر میرے سرچ انجن ، ابتداٴی صفحہ ، یا نئے ٹیب کو تبدیل کردیا گیا
abuse-report-settings-suggestions = توسیع کی اطلاع دینے سے پہلے ، آپ اپنی سیٹنگز کو تبدیل کرنے کی کوشش کر سکتے ہیں۔
abuse-report-settings-suggestions-search = اپنی ڈیفالٹ تلاش کی سیٹنگز کو تبدیل کریں
abuse-report-settings-suggestions-homepage = اپنا ہوم پیج اور نیا ٹیب تبدیل کریں

abuse-report-deceptive-reason-v2 = یہ دعوی کرتا ہے کہ ایسی چیز ہے جو نہیں ہے
abuse-report-deceptive-example = مثال: گمراہ کن تفصیل یا منظر کشی

abuse-report-broken-reason-extension-v2 = یہ کام نہیں کرتا ، ویب سائٹوں کو توڑتا ہے ، یا { -brand-product-name } سست کرتا ہے۔
abuse-report-broken-reason-theme-v2 = یہ کام نہیں کرتا ہے یا براؤزر کے ڈسپلے کو توڑتا ہے
abuse-report-broken-example = مثال: خصوصیات آہستہ ہیں ، استعمال میں سخت ہیں ، یا کام نہیں کرتی ہیں۔ ویب سائٹ کے کچھ حصے لوڈ یا غیر معمولی نظر نہیں آئیں گے

abuse-report-policy-reason-v2 = اس میں نفرت انگیز ، پرتشدد ، یا غیر قانونی مواد شامل ہے
abuse-report-policy-suggestions =
    نوٹ: کاپی رائٹ اور ٹریڈ مارک کے معاملات کی اطلاع علیحدہ عمل میں دینی چاہئے۔
    <a data-l10n-name="report-infringement-link"> ان ہدایات کا استعمال کریں </a>
    مسئلہ کی اطلاع دیں۔

abuse-report-unwanted-reason-v2 = میں یہ کبھی نہیں چاہتا تھا اور نہ جانتا ہوں کہ اس سے کیسے چھٹکارا حاصل کروں
abuse-report-unwanted-example = مثال: کسی ایپلیکیشن نے اسے میری اجازت کے بغیر انسٹال کیا  ہے

abuse-report-other-reason = اس کے علاوہ کچھ اور

