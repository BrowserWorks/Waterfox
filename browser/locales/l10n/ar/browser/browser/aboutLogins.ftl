# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = جلسات الولوج وكلمات السر

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = خُذ معك كلمات السر أينما ذهبت
login-app-promo-subtitle = نزّل مجانًا تطبيق { -lockwise-brand-name }
login-app-promo-android =
    .alt = نزّله من متجر غوغل
login-app-promo-apple =
    .alt = نزّله من متجر آبل
login-filter =
    .placeholder = ابحث في جلسات الولوج
create-login-button = أنشئ جلسة ولوج جديدة
fxaccounts-sign-in-text = استعمل كلمات السر لحساباتك في أجهزتك الأخرى
fxaccounts-sign-in-button = لِج إلى { -sync-brand-short-name }
fxaccounts-avatar-button =
    .title = أدِر الحساب

## The ⋯ menu that is in the top corner of the page

menu =
    .title = افتح القائمة
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = استورِد من متصفح آخر…
about-logins-menu-menuitem-import-from-a-file = استورِد من ملف…
about-logins-menu-menuitem-export-logins = صدّر جلسات الولوج…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] الخيارات
       *[other] التفضيلات
    }
about-logins-menu-menuitem-help = مساعدة
menu-menuitem-android-app = { -lockwise-brand-short-name } على أندرويد
menu-menuitem-iphone-app = { -lockwise-brand-short-name } على آيفون وآيباد

## Login List

login-list =
    .aria-label = جلسات الولوج المطابقة لعبارة البحث
login-list-count =
    { $count ->
        [zero] لا جلسات ولوج
        [one] جلسة ولوج واحدة
        [two] جلستا ولوج اثنتان
        [few] { $count } جلسات ولوج
        [many] { $count } جلسة ولوج
       *[other] { $count } جلسة ولوج
    }
login-list-sort-label-text = افرز حسب:
login-list-name-option = الاسم (ا-ي)
login-list-name-reverse-option = الاسم (ي-ا)
about-logins-login-list-alerts-option = التنبيهات
login-list-last-changed-option = آخر تعديل
login-list-last-used-option = آخر استخدام
login-list-intro-title = لا جلسات ولوج
login-list-intro-description = متى ما حفظت كلمة سر في { -brand-product-name } ستظهر هنا.
about-logins-login-list-empty-search-title = لا جلسات ولوج
about-logins-login-list-empty-search-description = لا نتائج تطابق البحث.
login-list-item-title-new-login = جلسة ولوج جديدة
login-list-item-subtitle-new-login = أدخِل معلومات الولوج
login-list-item-subtitle-missing-username = (لا اسم مستخدم)
about-logins-list-item-breach-icon =
    .title = موقع مسرّب بياناته
about-logins-list-item-vulnerable-password-icon =
    .title = كلمة سر ضعيفة

## Introduction screen

login-intro-heading = أتبحث عن جلسات ولوجك المحفوظة؟ إذًا اضبط { -sync-brand-short-name }.
about-logins-login-intro-heading-logged-out = أتبحث عن جلسات ولوجك المحفوظة؟ إذًا اضبط { -sync-brand-short-name } أو استورِدها.
about-logins-login-intro-heading-logged-in = لم نجد أيّ جلسة ولوج متزامنة.
login-intro-description = إن حفظت جلسات ولوجك في { -brand-product-name } على جهاز آخر، فهكذا يمكنك أن تزامنها هنا:
login-intro-instruction-fxa = أنشِئ أو لِج إلى { -fxaccount-brand-name } على الأجهزة التي لديك عليها جلسات ولوج محفوظة
login-intro-instruction-fxa-settings = تحقّق من تحديد مربع ”جلسات الولوج“ في إعدادات { -sync-brand-short-name }
about-logins-intro-instruction-help = زُر <a data-l10n-name="help-link">دعم { -lockwise-brand-short-name }</a> لمزيد من المساعدة
about-logins-intro-import = لو كانت جلسات ولوجك محفوظة في متصفّح آخر فيمكنك <a data-l10n-name="import-link">استيرادها إلى { -lockwise-brand-short-name }</a>
about-logins-intro-import2 = إن حفظت جلسات الولوج خارج { -brand-product-name } فيمكنك <a data-l10n-name="import-browser-link">استيرادها من متصفّح آخر</a> أو <a data-l10n-name="import-file-link">من ملف</a>

## Login

login-item-new-login-title = أنشِئ جلسة ولوج جديدة
login-item-edit-button = حرِّر
about-logins-login-item-remove-button = أزِل
login-item-origin-label = عنوان الموقع
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = اسم المستخدم
about-logins-login-item-username =
    .placeholder = (لا اسم مستخدم)
login-item-copy-username-button-text = انسخ
login-item-copied-username-button-text = نُسخ.
login-item-password-label = كلمة السر
login-item-password-reveal-checkbox =
    .aria-label = أظهِر كلمة السر
login-item-copy-password-button-text = انسخ
login-item-copied-password-button-text = نُسخ.
login-item-save-changes-button = احفظ التغييرات
login-item-save-new-button = احفظ
login-item-cancel-button = ألغِ
login-item-time-changed = آخر تعديل: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = تاريخ الإنشاء: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = آخر استخدام: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = أدخِل معلومات ولوج وِندوز لتعدّل جلسة الولوج. يساعد هذا الأمر على حماية أمن حساباتك.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = تحرير جلسة الولوج المحفوظة
# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = أدخِل معلومات ولوج وِندوز لتعرض كلمة السر. يساعد هذا الأمر على حماية أمن حساباتك.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = عرض كلمة السر المحفوظة
# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = أدخِل معلومات ولوج وِندوز لتنسخ كلمة السر. يساعد هذا الأمر على حماية أمن حساباتك.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = نسخ كلمة السر المحفوظة

## Master Password notification

master-password-notification-message = من فضلك أدخِل كلمة السر الرئيسية لعرض جلسات الولوج وكلمات السر المحفوظة
# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = أدخِل معلومات ولوج وِندوز لتُصدّر جلسات الولوجج. يساعد هذا الأمر على حماية أمن حساباتك.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = صدّر جلسات الولوج وكلمات السر المحفوظة

## Primary Password notification

about-logins-primary-password-notification-message = من فضلك أدخِل كلمة السر الرئيسية لعرض جلسات الولوج وكلمات السر المحفوظة
master-password-reload-button =
    .label = لِج
    .accesskey = ل

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] أتودّ أن تكون جلسات الولوج التي بدأتها أينما استخدمت { -brand-product-name }؟ افتح خيارات { -sync-brand-short-name } وحدّد مربع ”جلسات الولوج“.
       *[other] أتودّ أن تكون جلسات الولوج التي بدأتها أينما استخدمت { -brand-product-name }؟ افتح تفضيلات { -sync-brand-short-name } وحدّد مربع ”جلسات الولوج“.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] افتح خيارات { -sync-brand-short-name }
           *[other] افتح تفضيلات { -sync-brand-short-name }
        }
    .accesskey = ف
about-logins-enable-password-sync-dont-ask-again-button =
    .label = لا تسألني ثانيةً
    .accesskey = ت

## Dialogs

confirmation-dialog-cancel-button = ألغِ
confirmation-dialog-dismiss-button =
    .title = ألغِ
about-logins-confirm-remove-dialog-title = أنُزيل هذا الولوج؟
confirm-delete-dialog-message = هذا إجراء لا عودة فيه.
about-logins-confirm-remove-dialog-confirm-button = أزِل
about-logins-confirm-export-dialog-title = صدّر جلسات الولوج وكلمات السر
about-logins-confirm-export-dialog-message = ستُحفظ جلسات الولوج على هيئة نص مقروء (مثلا 12345 أو BadP@ssw0rd) وبهذا يستطيع أيّ شخص معاينتها لو فتح الملف المصدّر.
about-logins-confirm-export-dialog-confirm-button = صدّر…
confirm-discard-changes-dialog-title = أتريد إهمال التغييرات غير المحفوظة؟
confirm-discard-changes-dialog-message = ستفقد كل تغيير لم تحفظه.
confirm-discard-changes-dialog-confirm-button = أهمِل

## Breach Alert notification

about-logins-breach-alert-title = تسرّبت بيانات موقع
breach-alert-text = تسرّبت كلمات السر (أو سُرقت) من هذا الموقع مذ حدّثت بيانات ولوجك فيه. غيّر كلمة السر لتحمي حسابك من الاختراق.
about-logins-breach-alert-date = حدث هذا التسرّب بتاريخ { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = انتقل إلى { $hostname }
about-logins-breach-alert-learn-more-link = اطّلع على المزيد

## Vulnerable Password notification

about-logins-vulnerable-alert-title = كلمة سر ضعيفة
about-logins-vulnerable-alert-text2 = استعملت كلمة السر هذه في حساب آخر قد يكون تسرّب مع تسرّب بيانات أحد المواقع. بإعادة استعمال هذه المعلومات للولوج أنت تضع حساباتك كلها في خطر. غيّر كلمة السر.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = انتقل إلى { $hostname }
about-logins-vulnerable-alert-learn-more-link = اطّلع على المزيد

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = جلسة الولوج باسم المستخدم { $loginTitle } موجودة. <a data-l10n-name="duplicate-link">أتريد أن تراها؟</a>
# This is a generic error message.
about-logins-error-message-default = حدث خطأ أثناء محاولة حفظ كلمة السر هذه.

## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = صدّر ملف جلسات الولوج
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = جلسات_الولوج.csv
about-logins-export-file-picker-export-button = صدّر
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] مستند CSV
       *[other] ملف CSV
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = استورِد ملف جلسات الولوج
about-logins-import-file-picker-import-button = استورِد
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] مستند CSV
       *[other] ملف CSV
    }
