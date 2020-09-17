# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = اطلاعات رفع اشکال
page-subtitle = این صفحه حاوی اطلاعات فنی است که امکان دارد هنگامی که به دنبال حل مشکلی هستید به شما کمک کند.  اگر به دنبال پاسخی برای پرسش‌های معمول دربارهٔ { -brand-short-name } هستید، از <a data-l10n-name="support-link">وب‌گاه پشتیبانی ما</a> بازدید نمایید.

crashes-title = گزارش‌های فروپاشی
crashes-id = شناسهٔ گزارش
crashes-send-date = ثبت شد
crashes-all-reports = تمام گزارش‌های فروپاشی
crashes-no-config = این برنامه برای نمایش گزارش‌های فروپاشی پیکربندی نشده است.
extensions-title = ضمیمه‌ها
extensions-name = نام
extensions-enabled = فعال
extensions-version = نسخه
extensions-id = شناسه
support-addons-name = نام
support-addons-version = نسخه
support-addons-id = شناسه
security-software-title = نرم‌افزار امنیتی
security-software-type = نوع
security-software-name = نام
security-software-antivirus = آنتی ویروس
security-software-antispyware = ضدجاسوسی
security-software-firewall = دیوارآتشین
features-title = امکانات { -brand-short-name }
features-name = نام
features-version = نسخه
features-id = شناسه
processes-title = پردازش‌های راه دور
processes-type = نوع
processes-count = تعداد
app-basics-title = اطلاعات اولیهٔ برنامه
app-basics-name = نام
app-basics-version = نسخه
app-basics-build-id = شناسه ساخت
app-basics-update-channel = کانال بروزرسانی
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] بروزرسانی شاخه
       *[other] بروزرسانی پوشه
    }
app-basics-update-history = تاریخچه بروزرسانی
app-basics-show-update-history = نمایش تاریخچه بروزرسانی
# Represents the path to the binary used to start the application.
app-basics-binary = فایل اجرایی برنامه
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] مسیر مجموعه تنظیمات
       *[other] پوشهٔ نمایه
    }
app-basics-enabled-plugins = متصل‌شونده‌های فعال
app-basics-build-config = تنظیمات هنگام ساخت
app-basics-user-agent = نام نمایندهٔ کاربر
app-basics-os = سیستم عامل
app-basics-memory-use = استفاده حافظه
app-basics-performance = کارایی
app-basics-service-workers = Service Workerهای ثبت شده
app-basics-profiles = نمایه
app-basics-multi-process-support = پنجره‌های چندپردازشی
app-basics-remote-processes-count = پردازش‌های راه دور
app-basics-enterprise-policies = خط و مش های سازمانی
app-basics-location-service-key-google = کلید سرویس مکان‌یابی گوگل
app-basics-safebrowsing-key-google = کلید مرور امن گوگل
app-basics-key-mozilla = کلید سرویس مکان‌یابی موزیلا
app-basics-safe-mode = حالت امن
show-dir-label =
    { PLATFORM() ->
        [macos] نمایش در Finder
        [windows] باز کردن پوشه
       *[other] باز کردن پوشه
    }
modified-key-prefs-title = ترجیحاتِ تغییر یافتهٔ مهم
modified-prefs-name = نام
modified-prefs-value = مقدار
user-js-title = ترجیحات user.js
user-js-description = پوشه نمایه‌ی شما شامل یک <a data-l10n-name="user-js-link">پرونده user.js</a> است، که شامل ترجیحاتی است که توسط { -brand-short-name } ساخته نشده است.
locked-key-prefs-title = ترجیحات مهم قفل شده
locked-prefs-name = نام
locked-prefs-value = مقدار
graphics-title = اطلاعات گرافیکی
graphics-features-title = ویژگی‌ها
graphics-diagnostics-title = تشخیص عیب
graphics-failure-log-title = گزارش خطاهای ثبت شده
graphics-gpu1-title = پردازنده گرافیکی #1
graphics-gpu2-title = پردازنده گرافیکی #2
graphics-decision-log-title = گزارش تصمیم‌ها
graphics-crash-guards-title = امکانات غیرفعال شده محافظ فروپاشی
graphics-workarounds-title = راه‌حل
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = پروتکل پنجره
place-database-title = پایگاه مکان‌ها
place-database-integrity = یکپارچگی
place-database-verify-integrity = بررسی یکپارچگی
a11y-title = دسترسی‌پذیری
a11y-activated = فعال‌ شده
a11y-force-disabled = دسترسی را متوقف کن
a11y-handler-used = یک دستیار قابل دسترسی استفاده شده است
a11y-instantiator = منطبق کنندهٔ دسترسی‌پذیری
library-version-title = نسخه‌های کتاب‌خانه
copy-text-to-clipboard-label = رونوشت متن به تخته‌گیره
copy-raw-data-to-clipboard-label = رونوشت برداشتن از داده‌های خام در تخته‌گیره
sandbox-title = فضا آزمایش
sandbox-sys-call-log-title = تماس‌های سیستمی رد شده
sandbox-sys-call-index = #
sandbox-sys-call-age = ثانیه قبل
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = نوع فرآیند
sandbox-sys-call-number = Syscall
sandbox-sys-call-args = آرگومان‌ها
safe-mode-title = آزمایش حالت امن
restart-in-safe-mode-label = راه‌اندازی مجدد، همراه با غیرفعال‌سازی افزونه‌ها…

## Media titles

audio-backend = پسانه صوتی
max-audio-channels = بیشترین میزان کانال‌ها
sample-rate = نرخ مثال ترجیح داده شده
media-title = رسانه
media-output-devices-title = دستگاه‌های خروجی
media-input-devices-title = دستگاه‌های ورودی
media-device-name = نام
media-device-group = گروه
media-device-vendor = فراهم‌کننده
media-device-state = وضعیت
media-device-preferred = ترجیح داده شده
media-device-format = قالب
media-device-channels = کانال‌ها
media-device-rate = ارزیابی
media-device-latency = تاخیر
media-capabilities-title = قابلیت‌های رسانه

##

intl-title = بین المللی سازی& محلی سازی
intl-app-title = تنظیمات برنامه
intl-locales-requested = مکان‌های درخواست شده
intl-locales-available = مکان‌های در دسترس
intl-locales-supported = برنامه های محلی
intl-locales-default = مکان‌های پیش فرض
intl-os-title = سیستم عامل
intl-os-prefs-system-locales = سیستم‌های محلی
intl-regional-prefs = ترجیحات منطقه‌ای

## Remote Debugging
##
## The Firefox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/


##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days =
    { $days ->
        [one] گزارش فروپاشی‌ها برای { $days } روز گذشته
       *[other] گزارش فروپاشی‌ها برای { $days } روز گذشته
    }

# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes =
    { $minutes ->
        [one] { $minutes } دقیقه قبل
       *[other] { $minutes } دقیقه قبل
    }

# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours =
    { $hours ->
        [one] { $hours } ساعت قبل
       *[other] { $hours } ساعت قبل
    }

# Variables
# $days (integer) - Number of days since crash
crashes-time-days =
    { $days ->
        [one] { $days } روز قبل
       *[other] { $days } روز قبل
    }

# Variables
# $reports (integer) - Number of pending reports
pending-reports =
    { $reports ->
        [one] تمامی گزارش‌های فروپاشی (شامل { $reports } فروپاشیِ معلق در بازهٔ زمانی داده شده)
       *[other] تمامی گزارش‌های فروپاشی (شامل { $reports } فروپاشی معلق در باز زمانی داده شده)
    }

raw-data-copied = رونوشت داده‌های خام به تخته‌گیره ارسال شد
text-copied = رونوشت متن به تخته‌گیره ارسال شد

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = به‌خاطر نسخه راه‌انداز گرافیکی شما متوقف شده است.
blocked-gfx-card = به خاطر مشکلات حل‌نشده در محرک گرافیکی شما، متوقف شده است.
blocked-os-version = به خاطر نسخهٔ سیستم عامل شما، متوقف شده است.
blocked-mismatched-version = مسدود شدن برای درایور نسخه گرافیکی به دلیل عدم هم‌خوانی بین ثبات و DLL
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = به خاطر نسخهٔ راه‌انداز گرافیکی شما متوقف شده است. سعی کنید راه‌انداز گرافیکی خود را به نسخهٔ { $driverVersion } یا جدیدتر ارتقا دهید.

# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = پارامترهای تایپ واضح

compositing = ترکیب
hardware-h264 = رمزگشایی سخت‌افزاری H264
main-thread-no-omtc = رشته اصلی، بدون OMTC
yes = بله
no = خیر
unknown = نامعلوم
virtual-monitor-disp = نمایش نمایشگر مجازی

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = پیدا شد
missing = ناپیدا

gpu-process-pid = شماره پردازه GPU
gpu-process = پردازه GPU
gpu-description = توضیحات
gpu-vendor-id = شناسهٔ تولیدکنندهٔ سخت‌افزار گرافیکی
gpu-device-id = شناسهٔ سخت‌افزار گرافیکی
gpu-subsys-id = شناسه Subsys
gpu-drivers = درایور‌ها
gpu-ram = رم
gpu-driver-version = نسخهٔ نرم‌افزار گرداننده
gpu-driver-date = تاریخ تولید نرم‌افزار گرداننده
gpu-active = فعال
webgl1-wsiinfo = اطلاعات راه‌انداز WebGL 1 WSI
webgl1-renderer = WebGL 1 Driver Renderer
webgl1-version = نسخه راه‌انداز WebGL 1
webgl1-driver-extensions = افزونه راه‌انداز WebGL 1
webgl1-extensions = افزونه‌های WebGL 1
webgl2-wsiinfo = اطلاعات WSI راه‌انداز WebGL 2
webgl2-renderer = WebGL 2 Driver Renderer
webgl2-version = نسخه راه‌انداز WebGL 2
webgl2-driver-extensions = افزونه راه‌انداز WebGL 2
webgl2-extensions = افزونه‌های WebGL 2
blocklisted-bug = مسدود شده به دلیل مسائل شناخته نشده

# Variables
# $bugNumber (string) - String of bug number from Bugzilla
bug-link = باگ{ $bugNumber }

# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = مسدود شده،‌ کد خطا { $failureCode }

d3d11layers-crash-guard = حروفچین D3D11
d3d11video-crash-guard = رمزگشا فیلم D3D11
d3d9video-crash-guard = رمزگشا فیلم D3D9
glcontext-crash-guard = OpenGL

reset-on-next-restart = تنظیم مجدد بعد از راه اندازی مجدد
gpu-process-kill-button = خاتمه پروسهٔ GPU
gpu-device-reset = بازنشانی دستگاه
gpu-device-reset-button = ماشه راه‌ اندازی مجدد دستگاه
uses-tiling = استفاده از Tiling
content-uses-tiling = استفاده از Tiling(محتوا)
off-main-thread-paint-enabled = Off Main Thread Painting فعال شد
target-frame-rate = نرخ فریم هدف

min-lib-versions = حداقل نسخهٔ لازم
loaded-lib-versions = نسخهٔ جاری

has-seccomp-bpf = Seccomp-BPF (پالایش فراخوانی‌های سیستم)
has-seccomp-tsync = به‌هنگام‌سازی تردهای Seccomp
has-user-namespaces = زیرمجموعه کاربر
has-privileged-user-namespaces = زیرمجموعه کاربر
can-sandbox-content = فضا آزمایشی پردازش محتوا
can-sandbox-media = فضا آزمایشی افزونه‌ی رسانه
content-sandbox-level = سطح آزمایش پردازش محتوا
effective-content-sandbox-level = سطح آزمایشیِ پردازشِ محتوای فعال
sandbox-proc-type-content = محتوا
sandbox-proc-type-file = محتوا پرونده
sandbox-proc-type-media-plugin = متصل‌شوندهٔ رسانه
sandbox-proc-type-data-decoder = رمز‌گشایِ داده

launcher-process-status-0 = فعال شد
launcher-process-status-1 = به دلیل عدم موفقیت غیرفعال شد
launcher-process-status-2 = در هر شرایطی غیرفعال شود
launcher-process-status-unknown = وضعیت نامشخص

# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-0 = فعال‌ ‌شده توسط کاربر
multi-process-status-1 = فعال شده توسط پیش فرض
multi-process-status-2 = غیرفعال
multi-process-status-4 = عیرفعال شده توسط ابزار دسترسی‌پذیری
multi-process-status-6 = غیرفعال توسط ورودی متن خارج از پشتیبانی
multi-process-status-7 = غیرفعال شده توسط افزونه
multi-process-status-8 = در هر شرایطی غیرفعال شود
multi-process-status-unknown = وضعیت نامشخص

async-pan-zoom = پان/بزرگنمایی ناهمگام
apz-none = هیچ‌کدام
wheel-enabled = ورودی چرخ فعال شد
touch-enabled = ورودی لمسی فعال شد
drag-enabled = کشیدن اسکرول‌بار فعال شد
keyboard-enabled = صفحه‌ کلید فعال شده است
autoscroll-enabled = اسکرول کردن خودکار فعال شده است

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = ورودی همگام چرخ به دلیل عدم پشتیبانی از ترجیحات غیرفعال شد: { $preferenceKey }
touch-warning = ورودی همگام لمسی به دلیل عدم پشتیبانی از ترجیحات غیرفعال شد: { $preferenceKey }

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = غیر فعال
policies-active = فعال
policies-error = خطا
