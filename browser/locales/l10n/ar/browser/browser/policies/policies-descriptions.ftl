# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Waterfox installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = ضبط السياسات التي يمكن لامتدادات الوِب WebExtensions الوصول إليها عبر chrome.storage.managed.

policy-AppAutoUpdate = تفعيل/تعطيل تحديث التطبيق تلقائيًا.

policy-AppUpdateURL = ضبط مسار التحديث المخصّص للتطبيق.

policy-Authentication = ضبط الاستيثاق المتكامل مع المواقع التي تدعمه.

policy-BackgroundAppUpdate2 = تفعيل/تعطيل أداة التحديث في الخلفية.

policy-BlockAboutAddons = منع الوصول إلى مدير الإضافات (about:addons).

policy-BlockAboutConfig = منع الوصول إلى صفحة about:config.

policy-BlockAboutProfiles = منع الوصول إلى صفحة about:profiles.

policy-BlockAboutSupport = منع الوصول إلى صفحة about:support.

policy-Bookmarks = إنشاء العلامات في شريط العلامات أو في قائمة العلامات أو في مجلد محدّد داخلها.

policy-CaptivePortal = تفعيل/تعطيل دعم بوّابات التقييد Captive Portal.

policy-CertificatesDescription = إضافة الشهادات أو استخدام الشهادات المضمّنة.

policy-Cookies = السماح للمواقع بضبط الكعكات أو الرفض.

policy-DefaultDownloadDirectory = ضبط دليل التنزيل المبدئي.

policy-DisableAppUpdate = منع المتصفح من التحديث.

policy-DisableBuiltinPDFViewer = تعطيل PDF.js، عارِض ملفات PDF المضمّن في { -brand-short-name }.

policy-DisableDefaultBrowserAgent = امنع وكيل المتصفّح المبدئي من اتخاذ أي إجراء. لا ينطبق هذا إلا على وِندوز إذ ليس لبقية المنصات وكلاء.

policy-DisableDeveloperTools = منع الوصول إلى أدوات المطوّرين.

policy-DisableFeedbackCommands = تعطيل أوامر إرسال الانطباعات في قائمة المساعدة (”أرسِل تعليقًا“ و ”أبلغ عن موقع مخادع“).

policy-DisableWaterfoxAccounts = تعطيل الخدمات التي تعتمد { -fxaccount-brand-name }، بما في ذلك المزامنة.

# Waterfox Screenshots is the name of the feature, and should not be translated.
policy-DisableWaterfoxScreenshots = تعطيل ميزة لقطات شاشة Waterfox.

policy-DisableWaterfoxStudies = منع { -brand-short-name } من تشغيل الدارسات.

policy-DisableForgetButton = منع الوصول إلى زر النسيان.

policy-DisableFormHistory = عدم تذكّر تأريخ الاستمارات والبحث.

policy-DisablePrimaryPasswordCreation = إن كان ”صحيح“، فلا يمكن إنشاء كلمة سر رئيسية.

policy-DisablePasswordReveal = لا تسمح بكشف كلمات السر في جلسات الولوج المحفوظة.

policy-DisablePocket = تعطيل ميزة حفظ الصفحات في Pocket.

policy-DisablePrivateBrowsing = تعطيل التصفح الخاص.

policy-DisableProfileImport = تعطيل أمر القائمة الخاص باستيراد البيانات من المتصفحات الأخرى.

policy-DisableProfileRefresh = تعطيل زر ”أنعِش { -brand-short-name }“ في صفحة about:support.

policy-DisableSafeMode = تعطيل ميزة إعادة التشغيل في الوضع الآمن. ملاحظة: لا يمكن تعطيل مفتاح Shift لدخول الوضع الآمن في وِندوز إلا باستخدام سياسة المجموعات.

policy-DisableSecurityBypass = منع المستخدم من تخطّي أنواع معيّنة من التحذيرات الأمنية.

policy-DisableSetAsDesktopBackground = تعطيل أمر القائمة الخاص بالضبط كخلفية سطح مكتب للصور.

policy-DisableSystemAddonUpdate = منع المتصفّح من تثبيت امتدادات النظام أو تحديثها.

policy-DisableTelemetry = تعطيل تيليمتري.

policy-DisplayBookmarksToolbar = عرض شريط أدوات العلامات مبدئيا.

policy-DisplayMenuBar = عرض شريط القوائم مبدئيا.

policy-DNSOverHTTPS = ضبط DNS عبر HTTPS

policy-DontCheckDefaultBrowser = تعطيل التحقق من كون المتصفح هو المبدئي عند بدئه.

policy-DownloadDirectory = ضبط وقفل دليل التنزيل.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = تفعيل أو تعطيل حجب المحتوى وقفل الخيار إن لزم.

# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = تفعيل أو تعطيل امتدادات الوسائط المعمّاة وقفل الخيار إن لزم.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = تثبيت أو إزالة أو قفل حالة الامتدادات. يأخذ خيار التثبيت مسارات محلية أو شبكية كمعطيات. يأخذ خياري الإزالة والقفل معرّفات الامتدادات.

policy-ExtensionSettings = إدارة كل ما يتعلّق بتثبيت الامتدادات.

policy-ExtensionUpdate = تفعيل/تعطيل تحديث الامتدادات تلقائيًا.

policy-WaterfoxHome = ضبط صفحة المنزل داخل Waterfox.

policy-FlashPlugin = السماح باستخدام ملحقة فلاش أو منع ذلك.

policy-Handlers = ضبط طرائق التعامل مع التطبيقات المبدئية.

policy-HardwareAcceleration = إن كان ”خطأ“، عطِّل التسريع العتادي.

# “lock” means that the user won’t be able to change this setting
policy-Homepage = ضبط صفحة البداية وقفل الخيار إن لزم.

policy-InstallAddonsPermission = السماح لبعض المواقع بتثبيت الإضافات.

policy-LegacyProfiles = تعطيل الميزة التي تُجبر بوجود ملف منفصل لكلّ نسخة مثبّتة.

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = تفعيل إعداد سلوك الكعكات SameSite المبدئي العتيق.

policy-LegacySameSiteCookieBehaviorEnabledForDomainList = العودة إلى سلوك الكعكات القديم لِ‍ SameSite على مواقع بذاتها.

##

policy-LocalFileLinks = السماح لمواقع بعينها أن تصنع روابط إلى ملفات محلية.

policy-ManagedBookmarks = ضبط قائمة من العلامات المُدارة من الإدارة بحيث لا يمكن للمستخدم تغييرها.

policy-ManualAppUpdateOnly = السماح بالتحديثات اليدوية فقط وعدم إعلام المستخدم بالتحديثات.

policy-PrimaryPassword = طلب استعمال كلمة سر رئيسية، أو منع ذلك.

policy-NetworkPrediction = تفعيل/تعطيل التوقّع الشبكي (الجلب المسبق لِ‍ DNS).

policy-NewTabPage = تفعيل/تعطيل صفحة ”لسان جديد“.

policy-NoDefaultBookmarks = تعطيل إنشاء العلامات المبدئية المشمولة في { -brand-short-name }، كما والعلامات الذكية (”الأكثر زيارة“، ”الوسوم الحديثة“). لاحظ: تعمل هذه السياسة إن استُخدمت قبل أول تشغيل لملف الإعدادات، وليس بعد ذلك.

policy-OfferToSaveLogins = إجبار الإعداد ليتيح بأن يقدّم { -brand-short-name } خيار تذكر جلسات الولوج وكلمات السر المحفوظة. تُقبل القيمتان ”صحيح“ و”خطأ“.

policy-OfferToSaveLoginsDefault = ضبط القيمة المبدئية فتسمح بأن يقدّم لك { -brand-short-name } خيار تذكر جلسات الولوج وكلمات السر المحفوظة. تُقبل القيمتان ”صحيح“ و”خطأ“.

policy-OverrideFirstRunPage = الكتابة على صفحة ”أوّل تشغيل“. اضبط السياسة إلى فراغ إن أردت تعطيل الصفحة.

policy-OverridePostUpdatePage = الكتابة على صفحة ”ما الجديد“ التي تأتي بعد التحديث. اضبط السياسة إلى فراغ إن أردت تعطيل صفحة ما بعد تثبيت التحديث.

policy-PasswordManagerEnabled = تفعيل حفظ كلمات السر في مدير كلمات السر.

# PDF.js and PDF should not be translated
policy-PDFjs = تعطيل أو ضبط PDF.js، عارِض ملفات PDF المضمّن في { -brand-short-name }.

policy-Permissions2 = ضبط تصاريح الكمرة والمِكرفون والمكان والتنبيهات والتشغيل التلقائي.

policy-PictureInPicture = تفعيل الڤديو المعترِض أو تعطيله.

policy-PopupBlocking = السماح لبعض المواقع بعرض المنبثقات مبدئيا.

policy-Preferences = ضبط وقفل قيمة إحدى المجموعات الفرعية في التفضيلات.

policy-PromptForDownloadLocation = السؤال عن مكان حفظ الملفات عند تنزيلها.

policy-Proxy = ضبط إعدادات الوسيط.

policy-RequestedLocales = ضبط قائمة المحليّات المطلوبة للتطبيق بقائمة مرتّبة.

policy-SanitizeOnShutdown2 = مسح معلومات التنقّل عند الإطفاء.

policy-SearchBar = ضبط المكان المبدئي لشريط البحث. يمكن للمستخدم تخصيصه.

policy-SearchEngines = ضبط إعدادات محرّك البحث. هذه السياسة متاحة في النسخة ممتدّة الدعم (ESR) لا غير.

policy-SearchSuggestEnabled = تفعيل/تعطيل اقتراحات البحث.

# For more information, see https://developer.mozilla.org/en-US/docs/Waterfox/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = تثبيت وحدات PKCS #11.

policy-ShowHomeButton = عرض زر الصفحة الرئيسية في شريط الأدوات.

policy-SSLVersionMax = ضبط إصدارة SSL العليا.

policy-SSLVersionMin = ضبط إصدارة SSL الدنيا.

policy-SupportMenu = إضافة عنصر ”الدعم“ (يمكن تخصيصه) في قائمة المساعدة.

policy-UserMessaging = عدم عرض بعض الرسائل بعينها للمستخدم.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = منع زيارة المواقع. طالع التوثيق لتفاصيل أكثر بخصوص النسق.

