# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = لاگ ان اور پاس ورڈ

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = اپنے پاس ورڈ ہر جگہ لے  جاٴییں
login-app-promo-subtitle = { -lockwise-brand-name } ایپلیکیشن  مفت  حاصل  کریں
login-app-promo-android =
    .alt = Google Play سے حاصل کریں
login-app-promo-apple =
    .alt = App Store پر سے ڈائونلوڈ کریں

login-filter =
    .placeholder = لاگ ان تلاش کریں

create-login-button = نیا لاگ ان بنائیں

fxaccounts-sign-in-text = اپنے پاسورڈ  دوسرے آلات پر حاصل کریں
fxaccounts-sign-in-button = { -sync-brand-short-name } میں  سائن ان کریں
fxaccounts-avatar-button =
    .title = اکاؤنٹ کو  منظم کریں

## The ⋯ menu that is in the top corner of the page

menu =
    .title = مینیو کھولیں
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = دوسرے براؤزر سے درآمد کریں…
about-logins-menu-menuitem-import-from-a-file = فائل سے درآمد کریں...
about-logins-menu-menuitem-export-logins = لاگ انس برآمد کریں…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] اختیارات
       *[other] ترجیحات
    }
about-logins-menu-menuitem-help = مدد
menu-menuitem-android-app = { -lockwise-brand-short-name }  براٴے  Android
menu-menuitem-iphone-app = iPhone اور iPad کے لئے { -lockwise-brand-short-name }

## Login List

login-list =
    .aria-label = لاگ انزتلاش کرنےوالی کیوری
login-list-count =
    { $count ->
        [one] { $count }  لاگ  ان
       *[other] { $count }  لاگ  انز
    }
login-list-sort-label-text = کے مطابق چھانٹیں:
login-list-name-option = نام (A-Z)
login-list-name-reverse-option = نام  (Z-A)
about-logins-login-list-alerts-option = انتباہات
login-list-last-changed-option = آخری بار ترمیم کردہ
login-list-last-used-option = آخری استعمال
login-list-intro-title = کوئی لاگ ان نہیں ملا
login-list-intro-description = جب آپ { -brand-product-name } میں پاس ورڈ محفوظ کریں گے تو ، وہ یہاں دکھایا جائے گا.
about-logins-login-list-empty-search-title = کوئی لاگ ان نہیں ملا
about-logins-login-list-empty-search-description = آپ کی تلاش سے مماثل کوئی نتائج نہیں مل رہے ہیں۔
login-list-item-title-new-login = نیا لاگ ان
login-list-item-subtitle-new-login = لاگ ان کی سندیں درج کریں۔
login-list-item-subtitle-missing-username = (صارف نام کا نہیں)
about-logins-list-item-breach-icon =
    .title = بریچڈ ویب سائٹیں
about-logins-list-item-vulnerable-password-icon =
    .title = کمزور پاسورڈ

## Introduction screen

login-intro-heading = اپنے محفوظ شدہ لاگ ان ڈھونڈ رہے ہیں؟ { -sync-brand-short-name } مرتب کریں۔

about-logins-login-intro-heading-logged-out = اپنے محفوظ شدہ لاگ ان ڈھونڈ رہے ہیں؟ { -sync-brand-short-name } مرتب کریں یا انھیں درآمد کریں۔
about-logins-login-intro-heading-logged-in = کوئی سینکڈ لاگ ان نہیں ملا۔
login-intro-description = اگر آپ نے اپنے لاگ انز { -brand-product-name } کو کسی دوسرے آلے پر محفوظ کیاہوا ہے تو، انہیں یہاں حاصل کرنے کا طریقہ یوں ہے:
login-intro-instruction-fxa = وہ آلہ جہاں آپ کے لاگ انز محفوظ ہیں ان پر اپنا { -fxaccount-brand-name } بنائیں یا سائن ان کریں
login-intro-instruction-fxa-settings = یقینی بنائیں کہ آپ نے { -sync-brand-short-name } کے سیٹنگز میں لاگ انس کے چیک باکس کو منتخب کیا ہے
about-logins-intro-instruction-help = مزید مدد کے لئے <a data-l10n-name="help-link">{ -lockwise-brand-short-name } معاونت</a> پر جائیں
about-logins-intro-import = اگر آپ کے لاگ انز کسی دوسرے براؤزر میں محفوظ ہیں تو ، آپ <a data-l10n-name="import-link"> ان کو { -lockwise-brand-short-name }</a> میں درآمد کرسکتے ہیں

## Login

login-item-new-login-title = نیا لاگ ان بنائیں
login-item-edit-button = تدوین کریں
about-logins-login-item-remove-button = ہٹائیں
login-item-origin-label = ویب سائٹ ایڈریس
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = صارف کا نام
about-logins-login-item-username =
    .placeholder = (صارف نام کا نہیں)
login-item-copy-username-button-text = نقل کریں
login-item-copied-username-button-text = نقل شدہ!
login-item-password-label = پاس ورڈ
login-item-password-reveal-checkbox =
    .aria-label = پاس ورڈ دکھائیں
login-item-copy-password-button-text = نقل کریں
login-item-copied-password-button-text = نقل شدہ!
login-item-save-changes-button = تبدیلیاں محفوظ کریں
login-item-save-new-button = محفوظ کریں
login-item-cancel-button = منسوخ کریں
login-item-time-changed = { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") } :آخری بار ترمیم کردہ
login-item-time-created = { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") } :تشکیل دیا گیا
login-item-time-used = آخری استعمال شدہ:{ DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = محفوظ کردہ لاگ ان میں تدوین کریں

# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = محفوظ شدہ پاس ورڈ کو ظاہر کریں

# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = محفوظ شدہ پاس ورڈ کو نقل کریں

## Master Password notification

master-password-notification-message = براہ کرم محفوظ لاگ ان اور پاس ورڈز کو دیکھنے کے لئے اپنا ماسٹر پاس ورڈ درج کریں

# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = محفوظ شدہ لاگ ان اور پاس ورڈ برآمد کریں

## Primary Password notification

master-password-reload-button =
    .label = لاگ ان
    .accesskey = L

## Password Sync notification

enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] دورہ کریں  { -sync-brand-short-name } اختیارات
           *[other] دورہ کریں{ -sync-brand-short-name }ترجیحات
        }
    .accesskey = V
about-logins-enable-password-sync-dont-ask-again-button =
    .label = مجھے دوبارہ مت پوچھیں
    .accesskey = د

## Dialogs

confirmation-dialog-cancel-button = منسوخ کریں
confirmation-dialog-dismiss-button =
    .title = منسوخ کریں

about-logins-confirm-remove-dialog-title = اس لاگ ان کو ہٹائیں؟
confirm-delete-dialog-message = یہ عمل کلعدم نہیں ہو سکتا۔
about-logins-confirm-remove-dialog-confirm-button = ہٹائیں

about-logins-confirm-export-dialog-title = لاگ ان اور پاس ورڈ برآمد کریں
about-logins-confirm-export-dialog-confirm-button = برآمد کریں…

confirm-discard-changes-dialog-title = غیر محفوظ شدہ تبدیلیاں ہٹاییں؟
confirm-discard-changes-dialog-message = سبھی غیر محفوظ شدہ تبدیلیاں ختم ہوجائیں گی۔
confirm-discard-changes-dialog-confirm-button = رد کريں

## Breach Alert notification

about-logins-breach-alert-title = ویب سائٹ بریچ
breach-alert-text = اس ویب سائٹ سے پاس ورڈز لیک یا چوری ہوگئے تھے جب سے آپ نے لاگ ان کی تفصیلات کو آخری بار اپ ڈیٹ کیا تھا۔ اپنے اکاؤنٹ کی حفاظت کے لئے اپنا پاس ورڈ تبدیل کریں۔
about-logins-breach-alert-date = یہخلافورزی { DATETIME($date, day: "numeric", month: "long", year: "numeric") } ہوئی ہے
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = { $hostname } پر جائیں
about-logins-breach-alert-learn-more-link = مزید سیکھیں

## Vulnerable Password notification

about-logins-vulnerable-alert-title = کمزور پاسورڈ
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = { $hostname } پر جائیں
about-logins-vulnerable-alert-learn-more-link = مزید سیکھیں

## Error Messages

# This is a generic error message.
about-logins-error-message-default = اس پاس ورڈ کو محفوظ کرنے کی کوشش کرتے وقت ایک نقص پیش آگیا۔


## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = لاگ ان فائل برآمد کریں
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = برآمد کریں
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV دستاویز
       *[other] CSV فائل
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = لاگ ان فائل درآمد کریں
about-logins-import-file-picker-import-button = درآمد کریں
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV دستاویز
       *[other] CSV فائل
    }
