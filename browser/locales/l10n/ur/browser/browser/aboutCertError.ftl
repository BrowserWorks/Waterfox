# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = یہ { $hostname } ایک ناجائز سلامتی تصدیق نامہ استعمال کرتا ہے۔

cert-error-mitm-intro = ویب سائٹس اپنی شناخت سرٹیفکیٹس کے ذریعہ ثابت کرتی ہیں، جو سرٹیفکیٹ حکام کے ذریعہ جاری ہوتے ہیں۔

cert-error-mitm-mozilla = { -brand-short-name }کی حمایت غیر منافع بخش Mozilla کرتا ہے، جو مکمل طور پر کھلا سرٹیفکیٹ اتھارٹی (CA) اسٹور کا انتظام کرتی ہے۔ CA اسٹور اس بات کو یقینی بنانے میں مدد کرتا ہے کہ سرٹیفکیٹ حکام صارف سیکورٹی کے لئے بہترین طریقوں پر عمل کریں۔

cert-error-mitm-connection = اس بات کی تصدیق کرنے کے لئے کہ کنکشن محفوظ ہے { -brand-short-name } Mozilla کے CA اسٹور کا استعمال کرتاہے، صارف کی آپریٹنگ سسٹم کی طرف سے فراہم کردہ سرٹیفکیٹ کے بجائے۔ لہذا، اگر ایک اینٹی وایرس پروگرام یا نیٹ ورک CA کی طرف سے جاری سیکیورٹی سرٹیفکیٹ کے ساتھ کنکشن کو روک رہا ہے جو  Mozilla CA سٹور میں نہیں ہے، تو کنکشن کو محفوظ نہیں سمجھا جاتا ہے۔

cert-error-trust-unknown-issuer-intro = کوئی سائٹ کی نقالی کرنے کی کوشش کرسکتا ہے اور آپ کو جاری نہیں رکھنا چاہئے۔

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = ویب سائٹس تصیق نامہ کے ذریعے اپنی شناخت ثابت کرتی ہیں۔{ -brand-short-name }پر { $hostname } پر بھروسہ نہیں ہے کیونکہ اس کا تصیق نامہ جاری کرنے والا نامعلوم ہے ، تصیق نامہ از خود دستخط شدہ ہے ، یا پیش کار  صحیح دریمیانی تصیق نامہ نہیں بھیج رہا ہے۔

cert-error-trust-cert-invalid = یہ تصدیق نامہ قابل اعتماد نہیں ہے کیوں کہ اسے ایک ناجائز CA تصدیق نامے نے جاری کیا ہے۔

cert-error-trust-untrusted-issuer = یہ تصدیق نامہ قابل اعتماد نہیں ہے کیوں کہ جاری کنندہ کا تصدیق نامہ نامعلوم نہیں ہے۔

cert-error-trust-signature-algorithm-disabled = تصدیق نامہ ناقابل بھروسا ہے کیونکہ اس کو دستخط کیا گپا دستخط شدہ الگورزم کو استعمال کرتے ہوئے جس کو نااہل بنا دیا گیا تھا کیونکہ وہ الگورزم قابل بھروسا نہیں تھا۔

cert-error-trust-expired-issuer = یہ تصدیق نامہ قابل اعتماد نہیں ہے کیوں کہ جاری کنندہ کا تصدیق نامہ زائدالمدت ہے۔

cert-error-trust-self-signed = یہ تصدیق نامہ قابل اعتماد نہیں ہے کیوں کہ اس نے خود پر دستخط کیا ہوا ہے۔

cert-error-trust-symantec = GeoTrust ، RapidSSL ، Symantec، Thawteاور VeriSign کے ذریعہ جاری کردہ تصدہق نامہ کو اب محفوظ  شدہ نہیں سمجھا جاتا ہے کیونکہ یہ تصدہق نامہ  حکام ماضی میں سلامتی کے طریقوں پر عمل کرنے میں ناکام رہے تھے۔

cert-error-untrusted-default = یہ تصدیق نامہ قابل اعتماد ماخذ سے نہیں ہے۔

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = ویب سائٹس تصدیق نامے کے ذریعے اپنی شناخت ثابت کرتی ہیں۔{ -brand-short-name } کو اس سائٹ پر اعتماد نہیں ہے کیونکہ وہ ایسے  تصدیق نامے کا استعمال کر رہی ہے{ $hostname } کے لئے درست نہیں ہے۔

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = ویب سائٹس اپنی شناخت سرٹیفکیٹ کے ذریعے ثابت کرتی ہیں۔ { -brand-short-name } کو اس سائٹ پر اعتماد نہیں ہے کیونکہ { $hostname } کے لئے جو سرٹیفکیٹ استعمال ہو رہا ہے وہ درست نہیں ہے۔ یہ سرٹیفکیٹ صرف <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a> کے لئے درست ہے۔

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = ویب سائٹس اپنی شناخت سرٹیفکیٹ کے ذریعے ثابت کرتی ہیں۔ { -brand-short-name } کو اس سائٹ پر اعتماد نہیں ہے کیونکہ { $hostname } کے لئے جو سرٹیفکیٹ استعمال ہو رہا ہے وہ درست نہیں ہے۔ یہ سرٹیفکیٹ صرف { $alt-name } کے لئے درست ہے۔

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = ویب سائٹس اپنی شناخت سرٹیفکیٹ کے ذریعے ثابت کرتی ہیں۔ { -brand-short-name } کو اس سائٹ پر اعتماد نہیں ہے کیونکہ { $hostname } کے لئے جو سرٹیفکیٹ استعمال ہو رہا ہے وہ درست نہیں ہے۔ یہ سرٹیفکیٹ صرف { $subject-alt-names } کے لئے درست ہے۔

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = ویب سائٹس اپنی شناخت سرٹیفکیٹ کے ذریعے ثابت کرتی ہیں، جو کی مقررہ مدت کے لئے درست ہوتا ہے۔ { $hostname } کے سرٹیفکیٹ کی میعاد { $not-after-local-time } کو ختم ہو گئی۔

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = ویب سائٹس اپنی شناخت سرٹیفکیٹ کے ذریعے ثابت کرتی ہیں، جو کی مقررہ مدت کے لئے درست ہوتا ہے۔ { $hostname } کا سرٹیفکیٹ { $not-before-local-time } سے پہلے درست نہیں ہوگا۔

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = نقص: کا کوڈ:<a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = ویب سائٹس اپنی شناخت سرٹیفکیٹ کے ذریعے ثابت کرتی ہیں، جو سرٹیفکیٹ اتھارٹی کے زریعہ جاری ہوتے ہے۔ زیادہ تر براؤزر GeoTrust، RapidSSL، Symantec، Thawte، اور VeriSign کے زریعہ جاری کئے گئے سرٹیفکیٹ پر اعتماد نہیں کرتے۔ { $hostname } ان میں سے کسی ایک کا فراہم سرٹیفکیٹ استعمال کرتا ہے اور اسی لئے ویب سائٹ کی شناخت سابت نہیں ہو پا رہی ہے۔

cert-error-symantec-distrust-admin = آپ اس مسئلے کے بارے میں ویب سائٹ کے منتظم کو مطلع کرسکتے ہیں۔

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP سخت ٹرانسپورٹ سلامتی: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP عوامی کلید پننگ: { $hasHPKP }

cert-error-details-cert-chain-label = تصدیق نامہ سلسلہ:

open-in-new-window-for-csp-or-xfo-error = نئی ونڈو میں سائٹ کھولیں

## Messages used for certificate error titles

connectionFailure-title = جڑنے میں ناکامیاب
deniedPortAccess-title = یہ پتہ رسٹرکٹڈ ہے
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = ہمم۔ ہمیں وہ سائٹ ڈھونڈنے میں دشواری ہو رہی ہے۔
fileNotFound-title = فائل نہیں ملا
fileAccessDenied-title = فائل تک رسائی مسترد کردی گئی ہے
generic-title = اف
captivePortal-title = نیٹ ورک میں لاگ ان کریں
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = ہمم۔ یہ پتہ صحیح نہیں لگ رہا
netInterrupt-title = کنکشن خراب ہو گیا
notCached-title = دستاویز زائدالمدت
netOffline-title = آف لائن موڈ
contentEncodingError-title = مواد انکوڈنگ نقص
unsafeContentType-title = غیر محفوظ فائل قسم
netReset-title = کنکشن ریسٹ ہو گیا
netTimeout-title = کنکشن ٹائم آوٹ ہو گیا ہے
unknownProtocolFound-title = پتہ سمجھ نہیں آیا
proxyConnectFailure-title = پراکسی پیش کار کنکشن واپس کر رہا ہے
proxyResolveFailure-title = پراکسی پیش کار ڈھونڈیں میں ناکام
redirectLoop-title = صفحہ ٹھیک طرح ری ڈائریکٹ نہیں ہو رہا
unknownSocketType-title = سرور کی طرف سے غیر متوقع جواب
nssFailure2-title = قابل بھروسا کنکشن ناکام ہو گیا ہے
csp-xfo-error-title = { -brand-short-name } اس صفہ کو نہیں کھول سکتا
corruptedContentError-title = خراب مواد نقص
remoteXUL-title = بعید XUL
sslv3Used-title = حفاظتی طور پر جڑنے میں ناکام
inadequateSecurityError-title = آپکا کنکشن ناقابل بھروسا ہے
blockedByPolicy-title = بلاک شدہ صفحہ
clockSkewError-title = آپ کے کمپیوٹر کی گھڑی غلط ہے
networkProtocolError-title = نیٹ ورک پروٹوکول ایرر
nssBadCert-title = انتباہ: اآگے ممکنہ سیکیورٹی کا خطرہ ہو سکتا ہے
nssBadCert-sts-title = رابطہ قائم نہیں ھوا: امکانی حفاظتی مسئلہ
certerror-mitm-title = سافٹ ویئر { -brand-short-name } کو سائٹ  سے منسلک ہونے سے محفوظ طریقے سے روک رہا ہے
