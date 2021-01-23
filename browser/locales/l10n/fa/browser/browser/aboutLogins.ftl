# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = ورودها و گذرواژه‌ها

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = گذرواژه‌هایتان را همه جا با خود داشته باشید
login-app-promo-subtitle = برنامهٔ آزاد و رایگان { -lockwise-brand-name } را نصب کنید
login-app-promo-android =
    .alt = از Google Play دریافت کنید
login-app-promo-apple =
    .alt = از App Store دریافت کنید

login-filter =
    .placeholder = جست‌وجو در اطلاعات ورودها

create-login-button = ایجاد کردن ورود جدید

fxaccounts-sign-in-text = گذرواژه‌هایتان را دستگاه‌های دیگر خود همراه داشته باشید
fxaccounts-sign-in-button = ورود به { -sync-brand-short-name }
fxaccounts-avatar-button =
    .title = مدیریت حساب

## The ⋯ menu that is in the top corner of the page

menu =
    .title = باز کردن منو
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = وارد کردن از یک مرورگر دیگر…
about-logins-menu-menuitem-import-from-a-file = افزودن از طریق یک پرونده…
about-logins-menu-menuitem-export-logins = برون‌ریزی ورودها…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] گزینه‌ها
       *[other] ترجیحات
    }
about-logins-menu-menuitem-help = راهنما
menu-menuitem-android-app = { -lockwise-brand-short-name } برای اندروید
menu-menuitem-iphone-app = { -lockwise-brand-short-name } برای آیفون و آیپد

## Login List

login-list =
    .aria-label = ورودهای مطابق با عبارت جست‌وجو شده
login-list-count =
    { $count ->
        [one] { $count } ورود
       *[other] { $count } ورود
    }
login-list-sort-label-text = مرتب کردن بر اساس:
login-list-name-option = نام (A-Z)
login-list-name-reverse-option = نام (A-Z)
about-logins-login-list-alerts-option = هشدارها
login-list-last-changed-option = آخرین تغییر
login-list-last-used-option = آخرین استفاده
login-list-intro-title = هیچ اطلاعات ورودی پیدا نشد
login-list-intro-description = وقتی گذرواژه‌ای را در { -brand-product-name } ذخیره می‌کنید، آنها را اینجا می‌بینید.
about-logins-login-list-empty-search-title = هیچ اطلاعات ورودی پیدا نشد
about-logins-login-list-empty-search-description = هیچ نتیجه‌ای مطابق با جستجوی شما یافت نشد.
login-list-item-title-new-login = ورود جدید
login-list-item-subtitle-new-login = اطلاعات ورود خود را وارد کنید
login-list-item-subtitle-missing-username = (بدون نام‌کاربری)
about-logins-list-item-breach-icon =
    .title = وب‌سایت هک شده
about-logins-list-item-vulnerable-password-icon =
    .title = رمز عبور آسیب پذیر

## Introduction screen

login-intro-heading = دنبال اطلاعات ورود خود می‌گردید؟ { -sync-brand-short-name } را تنظیم کنید.

about-logins-login-intro-heading-logged-out = به دنبال ورودهای ذخیره شدهٔ خود می‌گردید؟ { -sync-brand-short-name } را انجام دهید یا آنها را درون‌ریزی کنید.
about-logins-login-intro-heading-logged-in = هیچ ورود همگام شده‌ای پیدا نشد
login-intro-description = اگر شما ورودتون به{ -brand-product-name } را بر روی دستگاه دیگری ذخیره کرده‌اید،‌ به این شکل بدستشون بیارید:
login-intro-instruction-fxa = { -fxaccount-brand-name } خود را ایجاد کنید یا بر روی دستگاهی که ورود های خود راثبت کرده اید به این حساب وارد شوید.
login-intro-instruction-fxa-settings = مطمئن شوید که جعبه ورود در تنظیمات { -sync-brand-short-name } را انتخاب کرده اید.
about-logins-intro-instruction-help = برای دریافت کمک بیشتری یا پشتیبانی به  <a data-l10n-name="help-link">{ -lockwise-brand-short-name }پشتیبانی</a> مراجعه کنید
about-logins-intro-import = اگر اطلاعات ورود شما، در مرورگر دیگری ثبت شده است، می‌توانید از طریق <a data-l10n-name="import-link"> آن‌ها را به { -lockwise-brand-short-name }</a> منتقل کنید.

about-logins-intro-import2 = اگر ورودهای شما خارج از { -brand-product-name } ذخیره شده‌اند، می‌توانید <a data-l10n-name="import-browser-link">آنها را از مرورگری دیگر</a> یا <a data-l10n-name="import-file-link">از طریق یک پرونده</a> وارد کنید

## Login

login-item-new-login-title = ایجاد اطلاعات ورود جدید
login-item-edit-button = ویرایش
about-logins-login-item-remove-button = حذف
login-item-origin-label = آدرس پایگاه
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = نام کاربری
about-logins-login-item-username =
    .placeholder = (بدون نام‌کاربری)
login-item-copy-username-button-text = رونوشت
login-item-copied-username-button-text = رونوشت شد!
login-item-password-label = گذرواژه
login-item-password-reveal-checkbox =
    .aria-label = نمایش گذرواژه
login-item-copy-password-button-text = رونوشت
login-item-copied-password-button-text = رونوشت شد!
login-item-save-changes-button = ذخیره تغییرات
login-item-save-new-button = ذخیره
login-item-cancel-button = انصراف
login-item-time-changed = آخرین تغییر: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = تاریخ ایجاد: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = آخرین استفاده: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = برای ویرایش ورودتان، گواهی ورود ویندوز خود را وارد کنید. این کار به محافظت از امنیت حسابتان کمک می‌کند.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = ویرایش ورودهای ذخیره شده

# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = برای دیدن گذرواژه خود، گذواژهٔ ویندوز خود را وارد کنید. این به امنیت حساب شما کمک می‌کند.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = نمایش گذرواژهٔ ذخیره شده

# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = برای رونوشت از گذرواژه خود، گذواژهٔ ویندوز خود را وارد کنید. این به امنیت حساب شما کمک می‌کند.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = کپی رمز عبور ذخیره شده

## Master Password notification

master-password-notification-message = برای دیدن نام‌های کاربری و گذرواژه‌ها، گذرواژهٔ اصلی خود را وارد کنید

# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = برای برون‌ریزی گذرواژه‌های خود، گذواژهٔ ویندوز خود را وارد کنید. این به امنیت حساب شما کمک می‌کند.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = برون‌ریزی ورودها و گذرواژه‌های ذخیره‌شده

## Primary Password notification

about-logins-primary-password-notification-message = برای دیدن ورودها و گذرواژه‌های ذخیره شدهٔ خود، گذاوژهٔ اصلی را وارد کنید
master-password-reload-button =
    .label = ورود
    .accesskey = و

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] آیا می‌خواهید اطلاعات ورود خود را هر جایی که از { -brand-product-name } استفاده می‌کنید با خود داشته باشید؟ به گزینه‌های { -sync-brand-short-name } بروید و کادر ورود را انتخاب کنید.
       *[other] آیا می‌خواهید اطلاعات ورود خود را هر جایی که از { -brand-product-name } استفاده می‌کنید با خود داشته باشید؟ به ترجیحات { -sync-brand-short-name } بروید و کادرهای ورود را انتخاب کنید.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] گزینه‌های { -sync-brand-short-name } را ببینید
           *[other] ترجیحات { -sync-brand-short-name } را ببینید
        }
    .accesskey = گ
about-logins-enable-password-sync-dont-ask-again-button =
    .label = دوباره از من نپرس
    .accesskey = د

## Dialogs

confirmation-dialog-cancel-button = انصراف
confirmation-dialog-dismiss-button =
    .title = انصراف

about-logins-confirm-remove-dialog-title = حذف این ورود؟
confirm-delete-dialog-message = این عمل قابل برگشت نیست.
about-logins-confirm-remove-dialog-confirm-button = حذف

about-logins-confirm-export-dialog-title = برون‌ریزی ورودها و گذرواژه‌ها
about-logins-confirm-export-dialog-message = گذرواژه‌های شما به عنوان متن قابل خواندن ذخیره خواهد شد (مثلاً BadP@ssw0rd) بنابراین هر کسی که بتواند پرونده صادر شده را باز کند، می‌تواند آنها را ببیند.
about-logins-confirm-export-dialog-confirm-button = برون‌ریزی…

confirm-discard-changes-dialog-title = تغییرات ذخیره نشده نادیده گرفته شود؟
confirm-discard-changes-dialog-message = تمام تغییرات ذخیره نشده از بین می‌روند.
confirm-discard-changes-dialog-confirm-button = نادیده گرفتن

## Breach Alert notification

about-logins-breach-alert-title = رخنه در وب‌سایت
breach-alert-text = از آخرین باری که اطلاعات ورود خود را تغییر داده‌اید، گذرواژه‌های مربوط به این وب‌سایت سرقت یا به بیرون درز کرده است. گذرواژه خود را تغییر دهید تا در خطر نباشید.
about-logins-breach-alert-date = این رخنه در تاریخ { DATETIME($date, day: "numeric", month: "long", year: "numeric") } اتفاق افتاده
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = برو به { $hostname }
about-logins-breach-alert-learn-more-link = بیشتر بدانید

## Vulnerable Password notification

about-logins-vulnerable-alert-title = رمز عبور آسیب پذیر
about-logins-vulnerable-alert-text2 = این گذرواژه در یک حساب دیگر که احتمالاً هک شده است استفاده شده. استفاده مجدد از گذرواژه، تمام حسابهای شما را در معرض خطر قرار می‌دهد. این گذرواژه را تغییر دهید.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = برو به { $hostname }
about-logins-vulnerable-alert-learn-more-link = بیشتر یاد بگیرید

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = یک ورودی برای { $loginTitle } با آن نام‌کاربری از قبل وجود دارد. <a data-l10n-name="duplicate-link">به ورودی فعلی برو؟</a>

# This is a generic error message.
about-logins-error-message-default = خطای هنگام ذخیره این گذرواژه رخ داد.


## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = برون‌ریزی پروندهٔ ورودها
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = ورودها.csv
about-logins-export-file-picker-export-button = برون‌ریزی
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] سند CSV
       *[other] پروندهٔ CSV
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = وارد کردن پروندهٔ ورودها
about-logins-import-file-picker-import-button = درون‌ریزی
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] سند CSV
       *[other] پرونده CSV
    }
