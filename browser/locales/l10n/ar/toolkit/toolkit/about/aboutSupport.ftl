# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = معلومات مواجهة الأعطال
page-subtitle = تحتوي هذه الصفحة معلومات تقنية قد تكون مفيدة عندما تحاول حل مشكلة ما. إن كنت تبحث عن إجابات لأسئلة شائعة تخص { -brand-short-name }، تحقق من <a data-l10n-name="support-link">موقع الدعم</a>.

crashes-title = بلاغات الانهيار
crashes-id = معرّف البلاغ
crashes-send-date = أُرسلَ
crashes-all-reports = كل بلاغات الانهيار
crashes-no-config = لم يُضبط التطبيق لعرض بلاغات الانهيار.
support-addons-title = الإضافات
support-addons-name = الاسم
support-addons-type = النوع
support-addons-enabled = مفعّلة
support-addons-version = النسخة
support-addons-id = المعرّف
security-software-title = برمجيات الحماية
security-software-type = النوع
security-software-name = الاسم
security-software-antivirus = مضاد فيروسات
security-software-antispyware = مضاد برمجيات تجسس
security-software-firewall = جدار حماية
features-title = مميزات { -brand-short-name }
features-name = الاسم
features-version = النسخة
features-id = المعرّف
processes-title = العمليات البعيدة
processes-type = النوع
processes-count = العدد
app-basics-title = أساسيات التطبيق
app-basics-name = الاسم
app-basics-version = النسخة
app-basics-build-id = معرف البناء
app-basics-distribution-id = معرّف التوزيعة
app-basics-update-channel = قناة التحديث
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] دليل التحديثات
       *[other] مجلد التحديثات
    }
app-basics-update-history = تأريخ التحديث
app-basics-show-update-history = أظهر تأريخ التحديث
# Represents the path to the binary used to start the application.
app-basics-binary = ملف التطبيق الثنائي
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] مجلد الملف الشخصي
       *[other] مجلد الملف الشخصي
    }
app-basics-enabled-plugins = الملحقات المفعّلة
app-basics-build-config = إعدادات البناء
app-basics-user-agent = عميل المستخدم
app-basics-os = نظام التشغيل
app-basics-memory-use = استخدام الذاكرة
app-basics-performance = الأداء
app-basics-service-workers = عمّال الخدمة المسجلين
app-basics-profiles = ملفات الإعدادات
app-basics-multi-process-support = نوافذ متعددة السيرورات
app-basics-fission-support = النوافذ المنشطرة
app-basics-remote-processes-count = العمليات البعيدة
app-basics-enterprise-policies = سياسات المؤسسات
app-basics-location-service-key-google = مفتاح خدمة التموضع من جوجل
app-basics-safebrowsing-key-google = مفتاح التصفّح الآمن من جوجل
app-basics-key-mozilla = مفتاح خدمة التموضع من Waterfox
app-basics-safe-mode = الوضع الآمن
show-dir-label =
    { PLATFORM() ->
        [macos] أظهِر في فايندر
        [windows] افتح المجلد
       *[other] افتح المجلد
    }
environment-variables-title = متغيرات البيئة
environment-variables-name = الاسم
environment-variables-value = القيمة
experimental-features-title = المزايات التجريبية
experimental-features-name = الاسم
experimental-features-value = القيمة
modified-key-prefs-title = التفضيلات المهمّة المُعدّلة
modified-prefs-name = الاسم
modified-prefs-value = قيمة
user-js-title = تفضيلات user.js
user-js-description = يحتوي مجلد إعداداتك على <a data-l10n-name="user-js-link">ملف user.js</a> به تفضيلات لم يُنشئها { -brand-short-name }.
locked-key-prefs-title = التفضيلات المهمّة المُوصدة
locked-prefs-name = الاسم
locked-prefs-value = القيمة
graphics-title = الرسوميات
graphics-features-title = الميزات
graphics-diagnostics-title = التشخيص
graphics-failure-log-title = سجل الأعطال
graphics-gpu1-title = معالج الرسوميات #1
graphics-gpu2-title = معالج الرسوميات #2
graphics-decision-log-title = سجل القرارات
graphics-crash-guards-title = خصائص حامي التحطم المعطَّلة
graphics-workarounds-title = الحلول الالتفافية
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = ميفاق النوافذ
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = بيئة سطح المكتب
place-database-title = قاعدة بيانات الأماكن
place-database-integrity = التكامل
place-database-verify-integrity = تحقّق من التكامل
a11y-title = الإتاحة
a11y-activated = مفعّلة
a11y-force-disabled = امنع الإتاحة
a11y-handler-used = مُعالج الإتاحة المستخدم
a11y-instantiator = بادئ الإتاحة
library-version-title = إصدارات المكتبات
copy-text-to-clipboard-label = انسخ النص إلى الحافظة
copy-raw-data-to-clipboard-label = انسخ البيانات الخام إلى الحافظة
sandbox-title = العزل
sandbox-sys-call-log-title = نداءات النظام المرفوضة
sandbox-sys-call-index = #
sandbox-sys-call-age = ثوان مضت
sandbox-sys-call-pid = معرف السيرورة
sandbox-sys-call-tid = معرف الخيط
sandbox-sys-call-proc-type = نوع السيرورة
sandbox-sys-call-number = نداء النظام
sandbox-sys-call-args = المعطيات

clear-startup-cache-title = جرّب مسح خبيئة البدء
clear-startup-cache-label = امسح خبيئة البدء…
restart-button-label = أعِد التشغيل

## Media titles

audio-backend = سند الصوت
max-audio-channels = أقصى عدد للقنوات
sample-rate = معدل العينات المفضل
media-title = الوسائط
media-output-devices-title = أجهزة الخَرْج
media-input-devices-title = أجهزة الدَخْل
media-device-name = الاسم
media-device-group = المجموعة
media-device-vendor = المُنتِج
media-device-state = الحالة
media-device-preferred = مفضّل
media-device-format = التنسيق
media-device-channels = القنوات
media-device-rate = المعدل
media-device-latency = الكمون

##

intl-title = التدويل و التوطين
intl-app-title = إعدادات التطبيق
intl-locales-requested = المحليات المطلوبة
intl-locales-available = المحليات المتاحة
intl-locales-supported = محليات التطبيق
intl-locales-default = المحلية المبدئية
intl-os-title = نظام التشغيل
intl-os-prefs-system-locales = محليات النظام
intl-regional-prefs = التفضيلات الإقليمية

## Remote Debugging
##
## The Waterfox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = التنقيح عن بُعد (بروتوكول كروميوم)

##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [zero] بلاغات انهيار اليوم
        [one] بلاغات انهيار آخر يوم
        [two] بلاغات انهيار آخر يومين
        [few] بلاغات انهيار آخر { $days } أيام
        [many] بلاغات انهيار آخر { $days } يومًا
       *[other] بلاغات انهيار آخر { $days } يوم
    }

# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [zero] الآن
        [one] منذ دقيقة
        [two] منذ دقيقتين
        [few] منذ { $minutes } دقائق
        [many] منذ { $minutes } دقيقة
       *[other] منذ { $minutes } دقيقة
    }

# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [zero] منذ أقل من ساعة
        [one] منذ ساعة
        [two] منذ ساعتين
        [few] منذ { $hours } ساعات
        [many] منذ { $hours } ساعة
       *[other] منذ { $hours } ساعة
    }

# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [zero] منذ أقل من يوم
        [one] منذ يوم
        [two] منذ يومين
        [few] منذ { $days } أيام
        [many] منذ { $days } يومًا
       *[other] منذ { $days } يوم
    }

# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [zero] كل بلاغات الانهيار (لا تشمل أي بلاغات انهيار معلّقة في الفترة الزمنية المحددة)
        [one] كل بلاغات الانهيار (تشمل بلاغ انهيار معلّق في الفترة الزمنية المحددة)
        [two] كل بلاغات الانهيار (تشمل بلاغي انهيار معلّقين في الفترة الزمنية المحددة)
        [few] كل بلاغات الانهيار (تشمل { $reports } بلاغات انهيار معلّقة في الفترة الزمنية المحددة)
        [many] كل بلاغات الانهيار (تشمل { $reports } بلاغ انهيار معلّق في الفترة الزمنية المحددة)
       *[other] كل بلاغات الانهيار (تشمل { $reports } بلاغ انهيار معلّق في الفترة الزمنية المحددة)
    }

raw-data-copied = نُسخت البيانات الخام إلى الحافظة
text-copied = نُسخ النص إلى الحافظة

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = معطّلة بسبب إصدارة مشغل البطاقة الرسومية.
blocked-gfx-card = معطّلة في بطاقتك الرسومية بسبب مشاكل في المشغل غير محلولة بعد.
blocked-os-version = معطّلة بسبب إصدارة نظام التشغيل.
blocked-mismatched-version = معطلة بسبب عدم تطابق إصدارة مشغل الرسوميات في السجل وDLL.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = معطّلة بسبب إصدارة مشغل البطاقة الرسومية. جرّب تحديث مشغل البطاقة الرسومية لديك إلى النسخة { $driverVersion } أو أحدث.

# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = معاملات ClearType

compositing = التراكب
hardware-h264 = فك ترميز H264 باستخدام العتاد
main-thread-no-omtc = الخيط الأساسي، لا OMTC
yes = نعم
no = لا

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = موجود
missing = مفقود

gpu-description = الوصف
gpu-vendor-id = معرّف المنتِج
gpu-device-id = معرّف الجهاز
gpu-subsys-id = معرّف النظام الفرعي
gpu-drivers = المشغلات
gpu-ram = الذاكرة
gpu-driver-version = نسخة المشغل
gpu-driver-date = تاريخ المشغل
gpu-active = نشط
webgl1-wsiinfo = معلومات WSI لمشغّل WebGL 1
webgl1-renderer = مصيّر مشغّل WebGL 1
webgl1-version = إصدارة مشغّل WebGL 1
webgl1-driver-extensions = امتدادات مشغّل WebGL 1
webgl1-extensions = امتدادات WebGL 1
webgl2-wsiinfo = معلومات WSI لمشغّل WebGL 2
webgl2-renderer = مصيّر مشغّل WebGL 2
webgl2-version = إصدارة مشغّل WebGL 2
webgl2-driver-extensions = امتدادات مشغّل WebGL 2
webgl2-extensions = امتدادات WebGL 2

# Variables
#   $bugNumber (string) - Bug number on Bugzilla
support-blocklisted-bug = على قائمة الحجب بسبب المشاكل المعروفة: <a data-l10n-name="bug-link">علة { $bugNumber }</a>

# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = على قائمة الحجب؛ رمز العطل { $failureCode }

d3d11layers-crash-guard = مركّب D3D11
glcontext-crash-guard = أوپن‌جي‌إل

reset-on-next-restart = صفّر عند التشغيل التالي
gpu-process-kill-button = أنهِ سيرورة وحدة معالجة الرسوميات
gpu-device-reset-button = أطلِق عملية إعادة الجهاز إلى حالته المبدئية
uses-tiling = يستخدم البلاطات
content-uses-tiling = يستخدم البلاطات (المحتوى)
off-main-thread-paint-enabled = الرسم خارج الخيط الرئيسي مفعل
off-main-thread-paint-worker-count = عدد عمال الرسم خارج الخيط الرئيسي
target-frame-rate = معدّل الإطارات الهدف

min-lib-versions = أقل إصدارة مقبولة
loaded-lib-versions = الإصدارة المستخدمة

has-seccomp-bpf = ‏Seccomp-BPF (ترشيح استدعاءات النظام)
has-seccomp-tsync = مزامنة Seccomp للخيوط
has-user-namespaces = نطاقات أسماء المستخدمين
has-privileged-user-namespaces = نطاقات أسماء المستخدمين للسيرورات ذات الامتياز
can-sandbox-content = عزل سيرورة المحتوى
can-sandbox-media = عزل ملحقات الوسائط
content-sandbox-level = مستوى عزل سيرورة المحتوى
effective-content-sandbox-level = مستوى عزل سيرورة المحتوى الفعلي
sandbox-proc-type-content = محتوى
sandbox-proc-type-file = محتوى الملف
sandbox-proc-type-media-plugin = ملحقة وسائط

# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }

# Variables
# $fissionWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
fission-windows = { $fissionWindows }/‏{ $totalWindows }
fission-status-experiment-treatment = فعّلتها ميزة تجريبية
fission-status-enabled-by-env = فعّلتها البيئة
fission-status-enabled-by-default = مفعّلة مبدئيًا
fission-status-enabled-by-user-pref = فعّلها المستخدم

async-pan-zoom = التقريب غير المتزامن
apz-none = لا شيء
wheel-enabled = إدخال البكرة مُفعّل
touch-enabled = إدخال اللمس مُفعّل
drag-enabled = سحب شريط التمرير مفعّل
keyboard-enabled = لوحة المفاتيح مفعّلة
autoscroll-enabled = التمرير التلقائي مفعّل

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = إدخال البكرة غير المتزامن مُعطّل بسبب خيار غير مدعوم: { $preferenceKey }
touch-warning = إدخال اللمس غير المتزامن مُعطّل بسبب خيار غير مدعوم: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = غير نشط
policies-active = نشط
policies-error = خطأ

## Printing section


## Normandy sections

