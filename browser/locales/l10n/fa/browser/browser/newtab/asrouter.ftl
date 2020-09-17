# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = افزونه‌های توصیه شده
cfr-doorhanger-feature-heading = ویژگی پیشنهادی
cfr-doorhanger-pintab-heading = امتحان کنید: سنجاق کردن زبانه

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = چرا این را می‌بینم

cfr-doorhanger-extension-cancel-button = اکنون نه
    .accesskey = N

cfr-doorhanger-extension-ok-button = اکنون اضافه کن
    .accesskey = A
cfr-doorhanger-pintab-ok-button = سنجاق کردن این زبانه
    .accesskey = س

cfr-doorhanger-extension-manage-settings-button = مدیریت تنظیمات پیشنهادی
    .accesskey = M

cfr-doorhanger-extension-never-show-recommendation = این پیشنهاد را به من نشان نده
    .accesskey = S

cfr-doorhanger-extension-learn-more-link = بیشتر بدانید

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = توسط { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = توصیه
cfr-doorhanger-extension-notification2 = توصیه
    .tooltiptext = افزونه‌های توصیه شده
    .a11y-announcement = افزونه‌های توصیه شده موجود

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = توصیه
    .tooltiptext = ویژگی‌های توصیه شده
    .a11y-announcement = ویژگی‌های توصیه شده موجود

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } ستاره
           *[other] { $total } ستاره
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } کاربر
       *[other] { $total } کاربر
    }

cfr-doorhanger-pintab-description = به آسانی به وب‌سایت‌های پرکاربرد خود دسترسی داشته باشید. وب‌سایت‌ها در یک زبانه باز نگه دارید(حتی با راه‌اندازی دوباره نرم‌افزار).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = بر زبانه‌ای که می‌خواهید آن را سنجاق کنید <b>راست-کلیک</b> کنید.
cfr-doorhanger-pintab-step2 = گزینه <b>سنجاق کردن زبانه</b> را از این منو انتخاب کنید.
cfr-doorhanger-pintab-step3 = اگر این وب‌سایت به روزرسانی داشته باشد، یک نقطه آبی در کنار زبانه سنجاق شده خواهید دید.

cfr-doorhanger-pintab-animation-pause = توقف
cfr-doorhanger-pintab-animation-resume = راه اندازی


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = نشانک‌های خود را در هر جایی همگام کنید.
cfr-doorhanger-bookmark-fxa-body = یک یافته فوق العاده! اکنون بدون این نشانک در دستگاه‌های تلفن همراه خود نماند. با یک { -fxaccount-brand-name } شروع کنید.
cfr-doorhanger-bookmark-fxa-link-text = نشانک‌ها را همگام کن...
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = دکمه بستن
    .title = بستن

## Protections panel

cfr-protections-panel-header = بدون دنبال شدن مرور کنید
cfr-protections-panel-body = داده‌های خود را نزد خود نگه دارید. { -brand-short-name } شما را از بسیاری از متداول‌ترین ردیاب‌هایی که شما را به صورت آنلاین دنبال می‌کنند محافظت می‌کند.
cfr-protections-panel-link-text = بیشتر بدانید

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = ویژگی‌های جدید:

cfr-whatsnew-button =
    .label = تازه‌ها
    .tooltiptext = تازه‌ها

cfr-whatsnew-panel-header = تازه‌ها

cfr-whatsnew-release-notes-link-text = یادداشت‌های انتشار را بخوانید

cfr-whatsnew-fx70-title = { -brand-short-name } برای حریم‌شخصی شما سخت‌تر می جنگد
cfr-whatsnew-fx70-body = آخرین به روزرسانی، ویژگی محافظت در برابر ردیابی را ارتقا داده است و ساختن گذرواژه امن برای هر وب‌سایتی را از همیشه ساده‌تر کرده است.

cfr-whatsnew-tracking-protect-title = خود را در مقابل ردیاب‌ها محافظت کنید
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } بسیاری از ردیاب‌های اجتماعی و بین وب‌سایتی را که
    فعالیت آنلاین شما را دنبال می‌کنند، مسدود می‌کند.
cfr-whatsnew-tracking-protect-link-text = گزارش خود را مشاهده کنید

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] ردیاب‌ مسدود شد
       *[other] ردیاب‌ها مسدود شدند
    }
cfr-whatsnew-tracking-blocked-subtitle = از { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = نمایش گزارش

cfr-whatsnew-lockwise-backup-title = از گذرواژه‌های خود نسخه پشتیبان تهیه کنید
cfr-whatsnew-lockwise-backup-body = حالا گذرواژه‌های امنی ایجاد کنید، که با ورود به حساب خود می‌توانید از هرجایی به آن‌ها دسترسی داشته باشید.
cfr-whatsnew-lockwise-backup-link-text = فعال‌سازی پشتیبان گیری

cfr-whatsnew-lockwise-take-title = گذرواژه‌های خود را با خود داشته باشید
cfr-whatsnew-lockwise-take-body = برنامهٔ تلفن همراه { -lockwise-brand-short-name } به شما اجازه دسترسی امن را از هرجایی به گذرواژه‌های پشتیبانی گرفته شده می‌دهد.
cfr-whatsnew-lockwise-take-link-text = دریافت اپ

## Search Bar

cfr-whatsnew-searchbar-title = با نوار آدرس، کمتر تایپ کنید، اطلاعات بیشتری پیدا کنید
cfr-whatsnew-searchbar-icon-alt-text = نشانکِ ذره‌بین

## Picture-in-Picture

cfr-whatsnew-pip-header = هنگام مرور اینترنت ویدئو ببینید
cfr-whatsnew-pip-cta = بیشتر بدانید

## Permission Prompt

cfr-whatsnew-permission-prompt-header = پنجره‌های بازشو مزاحم کمتر
cfr-whatsnew-permission-prompt-cta = بیشتر بدانید

## Fingerprinter Counter


## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = این نشانک را بر روی تلفن خود دریافت کنید
cfr-doorhanger-sync-bookmarks-body = می‌توانید نشانک‌ها، گذرواژه‌ها و تاریخچه مرور خود را با خود به هر جایی که وارد حساب کاربریتان در { -brand-product-name } شده باشید، ببرید.
cfr-doorhanger-sync-bookmarks-ok-button = روشن کردنِ { -sync-brand-short-name }
    .accesskey = T

## Login Sync

cfr-doorhanger-sync-logins-header = هرگز گذرواژه خود را از گم نکنید
cfr-doorhanger-sync-logins-body = به شکل امن گذرواژه‌های خود را در تمام دستگاه‌های خود ذخیره و همگام‌سازی کنید.
cfr-doorhanger-sync-logins-ok-button = روشن کردن { -sync-brand-short-name }
    .accesskey = T

## Send Tab

cfr-doorhanger-send-tab-header = این را در حال حرکت بخوانید
cfr-doorhanger-send-tab-recipe-header = این دستورالعمل را به آشپزخانه ببرید
cfr-doorhanger-send-tab-ok-button = ارسال زبانه را امتحان کنید
    .accesskey = T

## Firefox Send

cfr-doorhanger-firefox-send-header = این PDF را به شکل امن به اشتراک بگذارید
cfr-doorhanger-firefox-send-ok-button = { -send-brand-name } را امتحان کنید
    .accesskey = T

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = دیدن محافطت‌ها
    .accesskey = P
cfr-doorhanger-socialtracking-close-button = بستن
    .accesskey = C
cfr-doorhanger-socialtracking-dont-show-again = پیام‌هایی مانند این را دوباره به من نشان نده
    .accesskey = D
cfr-doorhanger-socialtracking-heading = { -brand-short-name } یک شبکه اجتماعی را در هنگام ردیابی شما متوقف کرد
cfr-doorhanger-socialtracking-description = حریم‌خصوصی شما اهمیت دارد. { -brand-short-name } ردیاب‌های متداولِ رسانه‌های اجتماعی را مسدود، و میزان داده‌هایی که می‌توانند در مورد آنچه که برخط انجام می‌دهید جمع‌آوری کنند را محدود می‌کند.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name }  یک برداشت کننده‌ی اثر انگشت را در این صفحه مسدود کرد.
cfr-doorhanger-fingerprinters-description = حریم‌خصوصی شما اهمیت دارد. { -brand-short-name } اکنون برداشت کنندگان اثر انگشت را که برای ردیابی شما اطلاعات منحصر به فرد قابل شناسایی شما را جمع می‌کنند، مسدود می‌کند.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } یک استخراج کنندهٔ رمزارزها را در این صفحه مسدود کرد
cfr-doorhanger-cryptominers-description = حریم‌خصوصی شما اهمیت دارد. { -brand-short-name } استخراج کننده‌های رمز‌ارزها را که از قدرت پردازش سیستم شما برای استخراج پول دیجیتالی استفاده می‌کنند، مسدود می‌کند.

## Enhanced Tracking Protection Milestones

cfr-doorhanger-milestone-ok-button = نمایش همه
    .accesskey = ن

## What’s New Panel Content for Firefox 76


## Lockwise message


## Vulnerable Passwords message


## Picture-in-Picture fullscreen message


## Protections Dashboard message


## Better PDF message

cfr-whatsnew-better-pdf-header = تجربهٔ PDF بهتر
cfr-whatsnew-better-pdf-body = اکنون سندهای PDF مستقیماً در { -brand-short-name } گشوده می‌شوند که روند کاریتان را ساده می کند.

## DOH Message


## What's new: Cookies message

