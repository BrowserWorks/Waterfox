# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Thunderbird installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = ضبط السياسات التي يمكن لامتدادات الوِب WebExtensions الوصول إليها عبر chrome.storage.managed.

policy-AppUpdateURL = ضبط مسار التحديث المخصّص للتطبيق.

policy-Authentication = ضبط الاستيثاق المتكامل مع المواقع التي تدعمه.

policy-BlockAboutAddons = منع الوصول إلى مدير الإضافات (about:addons).

policy-BlockAboutConfig = منع الوصول إلى صفحة about:config.

policy-BlockAboutProfiles = منع الوصول إلى صفحة about:profiles.

policy-BlockAboutSupport = منع الوصول إلى صفحة about:support.

policy-CertificatesDescription = إضافة الشهادات أو استخدام الشهادات المضمّنة.

policy-Cookies = السماح للمواقع بضبط الكعكات أو الرفض.

policy-DefaultDownloadDirectory = ضبط دليل التنزيل المبدئي.

policy-DisableAppUpdate = منع { -brand-short-name } من التحديث.

policy-DisableDeveloperTools = منع الوصول إلى أدوات المطوّرين.

policy-DisableFeedbackCommands = تعطيل أوامر إرسال الانطباعات في قائمة المساعدة (”أرسِل تعليقًا“ و ”أبلغ عن موقع مخادع“).

policy-DisableForgetButton = منع الوصول إلى زر النسيان.

policy-DisableMasterPasswordCreation = إن كان ”صحيح“، فلا يمكن إنشاء كلمة سر رئيسية.

policy-DisableProfileImport = تعطيل أمر القائمة الخاص باستيراد البيانات من تطبيقات أخرى.

policy-DisableSafeMode = تعطيل ميزة إعادة التشغيل في الوضع الآمن. ملاحظة: لا يمكن تعطيل مفتاح Shift لدخول الوضع الآمن في وِندوز إلا باستخدام سياسة المجموعات.

policy-DisableSecurityBypass = منع المستخدم من تخطّي أنواع معيّنة من التحذيرات الأمنية.

policy-DisableTelemetry = تعطيل تيليمتري.

policy-DisplayMenuBar = عرض شريط القوائم مبدئيا.

policy-DNSOverHTTPS = ضبط DNS عبر HTTPS

policy-DownloadDirectory = ضبط وقفل دليل التنزيل.

# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = تفعيل أو تعطيل حجب المحتوى وقفل الخيار إن لزم.

# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = تثبيت أو إزالة أو قفل حالة الامتدادات. يأخذ خيار التثبيت مسارات محلية أو شبكية كمعطيات. يأخذ خياري الإزالة والقفل معرّفات الامتدادات.

policy-ExtensionSettings = إدارة كل ما يتعلّق بتثبيت الامتدادات.

policy-ExtensionUpdate = تفعيل/تعطيل تحديث الامتدادات تلقائيًا.

policy-HardwareAcceleration = إن كان ”خطأ“، عطِّل التسريع العتادي.

policy-InstallAddonsPermission = السماح لبعض المواقع بتثبيت الإضافات.

## Do not translate "SameSite", it's the name of a cookie attribute.

##

policy-LocalFileLinks = السماح لمواقع بعينها أن تصنع روابط إلى ملفات محلية.

policy-NetworkPrediction = تفعيل/تعطيل التوقّع الشبكي (الجلب المسبق لِ‍ DNS).

policy-OverrideFirstRunPage = الكتابة على صفحة ”أوّل تشغيل“. اضبط السياسة إلى فراغ إن أردت تعطيل الصفحة.

policy-Preferences = ضبط وقفل قيمة إحدى المجموعات الفرعية في التفضيلات.

policy-PromptForDownloadLocation = السؤال عن مكان حفظ الملفات عند تنزيلها.

policy-Proxy = ضبط إعدادات الوسيط.

policy-RequestedLocales = ضبط قائمة المحليّات المطلوبة للتطبيق بقائمة مرتّبة.

policy-SanitizeOnShutdown2 = مسح معلومات التنقّل عند الإطفاء.

policy-SearchEngines = ضبط إعدادات محرّك البحث. هذه السياسة متاحة في النسخة ممتدّة الدعم (ESR) لا غير.

# For more information, see https://developer.mozilla.org/en-US/docs/Waterfox/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = تثبيت وحدات PKCS #11.

policy-SSLVersionMax = ضبط إصدارة SSL العليا.

policy-SSLVersionMin = ضبط إصدارة SSL الدنيا.

# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = منع زيارة المواقع. طالع التوثيق لتفاصيل أكثر بخصوص النسق.
