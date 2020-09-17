# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Firefox installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = ایسی  پالیسیاں مرتب کریں جس سے   chrome.storage.managed.  کے  زریعے  WebExtensions  رسای  حاصل  کر  سکیں

policy-AppAutoUpdate = خودکار ایپلیکیشن کی تازہ کاری کو فعال یا غیر فعال کریں۔

policy-AppUpdateURL = مرضی کے مطابق ایپ اپڈیٹ URL سیٹ کریں۔

policy-Authentication = اس ویب سائٹ کے لئے مربوط تصدیق کو سیٹنگ دیں جو اس کی حمایت کرتی ہے۔

policy-BlockAboutAddons = ایڈ اون مینیجر(about:addons) تک رسائی کو روکیں۔

policy-BlockAboutConfig = about:config صفحے پر رسائی کو روکیں۔

policy-BlockAboutProfiles = about:profiles صفحے پر رسائی کو روکیں۔

policy-BlockAboutSupport = about:support صفحے پر رسائی کو روکیں۔

policy-Bookmarks = بکمارک ٹولبار، بکمارک مینو، یا انکے اندر کسی اختصاصی فولڈر  مے بکمارک بنائیں۔

policy-CaptivePortal = اسیر پورٹل سپورٹ کو فعال یا غیر فعال کریں۔

policy-CertificatesDescription = سرٹیفکیٹ شامل کریں یا پہلے سے بنے سرٹیفکیٹ استعمال کریں۔

policy-Cookies = کوکیز سیٹ کرنے کیلئے ویب سائٹس کو اجازت دیں یا انکار کریں۔

policy-DisabledCiphers = سائفرز کو غیر فعال بنائیں

policy-DefaultDownloadDirectory = پہلے سے طے شدہ ڈاؤن لوڈ ڈائریکٹری مرتب کریں۔

policy-DisableAppUpdate = براؤزر کو اپڈیٹ ہونے سے روکیں۔

policy-DisableBuiltinPDFViewer = PDF.js کو غیر فعال کریں، جو { -brand-short-name } مے پہلے سے بنا PDF ویور ہے۔

policy-DisableDeveloperTools = تخلیق کار ٹول تک رسائی کو روکیں۔

policy-DisableFeedbackCommands = مدد مینو سے رائے بھیجنے کے احکامات کو غیر فعال کریں (رائے جمع کریں اور فریبی سائٹ کو رپورٹ کریں)۔

policy-DisableFirefoxAccounts = سنک سمیت { -fxaccount-brand-name } پر مبنی خدمات کو غیر فعال بناٴیں۔

# Firefox Screenshots is the name of the feature, and should not be translated.
policy-DisableFirefoxScreenshots = Firefox کے اسکرین شاٹ خصوصیت کو غیر فعال کریں۔

policy-DisableFirefoxStudies = { -brand-short-name } کو مطالعے  چلانے والے سے کو روکیں۔

policy-DisableForgetButton = فارگیٹ بٹن تک رسائی کو روکیں۔

policy-DisableFormHistory = تلاش اور فارم کی سابقات یاد نا رکھیں۔

policy-DisableMasterPasswordCreation = اگر سچ ہے تو، ایک ماسٹر پاس ورڈ بنائی نہی جا سکتی۔

policy-DisablePrimaryPasswordCreation = اگر درست ہے تو ، بنیادی پاس ورڈ نہیں بنایا جاسکتا۔

policy-DisablePasswordReveal = پاس ورڈز کو محفوظ لاگ ان میں ظاہر ہونے کی اجازت نہ دیں۔

policy-DisablePocket = ویب صفحات کو Pocket مے محفوظ کرنے کی خصوصیات سے روکیں۔

policy-DisablePrivateBrowsing = نجی براؤزنگ غیر فعال کریں

policy-DisableProfileImport = دوسرے براؤزر سے ڈیٹا درآمد کرنے کیلئے مینو کمانڈ کو غیر فعال کریں۔

policy-DisableSecurityBypass = صارف کو سیکیورٹی کے بعض انتباہات کو نظرانداز کرنے سے روکیں۔

policy-DisableSystemAddonUpdate = برائوزر کو سسٹم ایڈاون کو انسٹال اور اپ ڈیٹ کرنے سے روکیں۔

policy-DisableTelemetry = ٹیلی میٹری بند کریں۔

policy-DisplayBookmarksToolbar = بک مارک ٹولبار طے شدہ طور پر ظاہر کریں۔

policy-DisplayMenuBar = مینوبار طے شدہ طور پر ظاہر کریں۔

policy-DNSOverHTTPS = HTTPS پرDNS سیٹنگ کریں۔

policy-DontCheckDefaultBrowser = ابتدائی طور پر طے شدہ براؤزر کے لئے چیک کرنے کو غیر فعال کریں۔

policy-DownloadDirectory = ڈاؤن لوڈ ڈائریکٹری کو سیٹ اور لاک کریں۔

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = مواد روکنے کو فعال یا غیر فعال کر اور اس کے بعد اختیاری طور پر اس کو بند کردیں۔

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = ایکسٹنشن کو انسٹال، ان انسٹال یا لاک کریں۔ انسٹال اختیارات URL یا پاتھ کو بطور پیرامیٹر لیتا ہے۔ ان انسٹال یا لاک کے اختیار ایکسٹنش آئی ڈی کے تحت کام کرتے ہیں۔

policy-ExtensionSettings = ایکسٹینشن کی تنصیب کے تمام پہلوؤں کو بندرست کریں کریں۔

policy-ExtensionUpdate = خودکار ایکسٹینشن کی تازہ کاریوں کو فعال یا غیر فعال کریں۔

policy-FirefoxHome = Firefox کی ابتدا کو تشکیل دیں۔

policy-FlashPlugin = Flash پلگ ان کے استعمال کا اجازت دینے یا انکار کریں۔

policy-HardwareAcceleration = غلط ہونے کی صورت میں ہارڈویئر تیز رفتاری کو بند کریں۔

# “lock” means that the user won’t be able to change this setting
policy-Homepage = ابتدائی صفحہ سیٹ کریں اور اختیاری طور پر تالا بندی کرِں۔

policy-InstallAddonsPermission = چند ویب سائٹص کو اظافہ جات کی تنسیب کاری کی اجازت دیں۔

policy-LegacyProfiles = ہر انسٹالیشن کے لئے ایک علیحدہ پروفائل نافذ کرنے والی خصوصیت کو غیر فعال کریں۔

## Do not translate "SameSite", it's the name of a cookie attribute.


##

policy-LocalFileLinks = مخصوص ویب سائٹوں کو مقامی فائلوں سے لنک کرنے کی اجازت دیں۔

policy-NetworkPrediction = نیٹ ورک کی پیش گوئی کو فعال یا غیر فعال کریں (DNS پہلے لانا)

policy-NewTabPage = نیا ٹیب صفحہ فعال یا غیر فعال بانیے ۔

policy-NoDefaultBookmarks = { -brand-short-name } کے ساتھ آئے ہوئے طے شدہ بکمارک، اور سمارٹ بکمارک (سب سے زیادہ ملاحظہ کردہ، حالیہ ٹیگز)، کی تخلیق کو غیر فعال کرے۔ نوٹ: یہ پالسی تبھی مؤثر ہوگی جب پروفائل کے پہلی بار چلانے میں استعمال کی ہوئ ہوگی۔

policy-OverrideFirstRunPage = پہلےچلنے والے صفحے کو اوور رائڈ کریں۔ اگر آپ پہلے چلنے والے صفحے کو غیر فعال کرنا چاہتے ہیں تو اس پالیسی کو خالی پر مقرر کریں۔

policy-PasswordManagerEnabled = پاس ورڈ مینیجر میں پاس ورڈز محفوظ کرنے کو فعال بنائیں۔

policy-PopupBlocking = کچھ ویب سائٹوں کو بطور ڈیفالٹ پاپ اپ ظاہر کرنے کی اجازت دیں۔

policy-Preferences = ترجیحات کے سب سیٹ کی قدر کو سیٹ اور لاک کریں۔

policy-PromptForDownloadLocation = فائلیں ڈاؤن لوڈ کرتے وقت کہاں محفوظ کریں ؟ کا پوچھیں

policy-Proxy = پراکسی سیٹنگز سیٹنگ کریں۔

policy-RequestedLocales = درخواست کے لئے درخواست کردہ زبانوں  کی فہرست کو ترجیح کے مطابق سیٹنگ دیں۔

policy-SanitizeOnShutdown2 = بند کرنے پر تمام نیویگیشن ڈیٹا صاف کریں۔

policy-SearchSuggestEnabled = تلاش تجاویز کو فعال یا غیر فعال کریں۔

# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = PKCS #11 ماڈیول انسٹال کریں۔

policy-SSLVersionMax = زیادہ سے زیادہ SSL ورژن مرتب کریں۔

policy-SSLVersionMin = کم از کم SSL ورژن مرتب کریں۔

policy-SupportMenu = مدد والے مینو میں کسٹم سپورٹ مینو آئٹم شامل کریں۔

policy-UserMessaging = صارف کو کچھ پیغامات نہ دکھائیں۔

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = ویب سائٹوں کا دورہ کرنے سے روکیں۔ فارمیٹ پر مزید تفصیلات کے لئے دستاویزات دیکھیں۔
