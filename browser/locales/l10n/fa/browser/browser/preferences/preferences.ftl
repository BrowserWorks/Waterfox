# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = ارسال یک سیگنال “من را دنبال نکن ” برای پایگاه‌های اینترنتی که شما نمی‌خواهید توسط آن ها دنبال شوید
do-not-track-learn-more = اطلاعات بیشتر
do-not-track-option-default-content-blocking-known =
    .label = تنها وقتی که { -brand-short-name } برای مسدودسازی ردیاب‌های شناخته شده تنظیم شده است
do-not-track-option-always =
    .label = همیشه

pref-page-title =
    { PLATFORM() ->
        [windows] گزینه‌ها
       *[other] ترجیحات
    }

# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 15.4em
    .placeholder =
        { PLATFORM() ->
            [windows] پیدا‌کردن در گزینه‌ها
           *[other] پیدا‌کردن در ترجیحات
        }

managed-notice = مرورگر شما توسط سازمان شما مدیریت می شود.

pane-general-title = عمومی
category-general =
    .tooltiptext = { pane-general-title }

pane-home-title = خانه
category-home =
    .tooltiptext = { pane-home-title }

pane-search-title = جست‌وجو
category-search =
    .tooltiptext = { pane-search-title }

pane-privacy-title = حریم‌خصوصی و امنیت
category-privacy =
    .tooltiptext = { pane-privacy-title }

pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }

help-button-label = پشتیبانی { -brand-short-name }
addons-button-label = افزونه‌ها و پوسته‌ها

focus-search =
    .key = f

close-button =
    .aria-label = بستن

## Browser Restart Dialog

feature-enable-requires-restart = جهت فعال کردن این امکان، { -brand-short-name } باید مجددا راه‌اندازی شود.
feature-disable-requires-restart = شما باید برای غیرفعال کردن این امکان { -brand-short-name } را مجددا راه‌اندازی کنید.
should-restart-title = راه‌اندازی مجدد { -brand-short-name }
should-restart-ok = هم‌اکنون { -brand-short-name } راه‌اندازی مجدد شود
cancel-no-restart-button = لغو
restart-later = بعداْ راه‌اندازی مجدد شود

## Extension Control Notifications
##
## These strings are used to inform the user
## about changes made by extensions to browser settings.
##
## <img data-l10n-name="icon"/> is going to be replaced by the extension icon.
##
## Variables:
##   $name (String): name of the extension

# This string is shown to notify the user that their home page
# is being controlled by an extension.
extension-controlled-homepage-override = یک افزودنی، <img data-l10n-name="icon"/>{ $name }، در کنترل صفحهٔ خانگی شماست.

# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = یک افزودنی، <img data-l10n-name="icon"/>{ $name }، در کنترل صفحهٔ زبانه‌ٔ جدید شماست.

# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = یک افزونه، <img data-l10n-name="icon"/>{ $name }، این تنظیمات را کنترل می‌کند.

# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = یک افزایه،‌<img data-l10n-name="icon"/> { $name }،‌ بر روی موتور پیش فرض شما تنظیم شده است.

# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = یک افزونه، <img data-l10n-name="icon"/> { $name }،‌نیازمند نگه‌دارنده زبانه‌ها است.

# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = یک افزونه، <img data-l10n-name="icon"/>{ $name }، این تنظیم را کنترل می‌کند.

# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = یک افزودنی، <img data-l10n-name="icon"/>{ $name }، در حال کنترل نحوهٔ اتصال { -brand-short-name } به اینترنت است.

# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = برای فعال کردن این افزایه به افزونه <img data-l10n-name="addons-icon"/> در فهرست <img data-l10n-name="menu-icon"/> مراجعه کنید.

## Preferences UI Search Results

search-results-header = نتایج جستجو

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] متاسفیم! هیچ نتیجه‌ای در گزینه‌ها برای «<span data-l10n-name="query"></span>» وجود ندارد.
       *[other] متاسفیم! هیچ نتیجه‌ای در ترجیحات برای «<span data-l10n-name="query"></span>» وجود ندارد.
    }

search-results-help-link = نیاز به راهنمایی دارید؟ از <a data-l10n-name="url">پشتیبانی { -brand-short-name }</a> دیدن کنید

## General Section

startup-header = راه‌اندازی

# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = اجازه بده تا { -brand-short-name } و فایرفاکس همزمان اجرا شوند
use-firefox-sync = نکته: این از یک نمایه جدا استفاده میکند. از { -sync-brand-short-name } برای اشتراک‌گذاری اطلاعات بین آنها استفاده کنید.
get-started-not-logged-in = برای همگام‌سازی وارد { -sync-brand-short-name }…
get-started-configured = باز کردن ترجیحات { -sync-brand-short-name }

always-check-default =
    .label = همیشه بررسی شود که آیا { -brand-short-name } مرورگر پیش‌فرض شما است یا خیر
    .accesskey = ه

is-default = { -brand-short-name } مرورگر همیشگی شماست
is-not-default = { -brand-short-name } مرورگر پیش‌فرض شما نیست

set-as-my-default-browser =
    .label = تنظیم به عنوان پیش‌فرض…
    .accesskey = پ

startup-restore-previous-session =
    .label = بازنشانی نشست قبلی
    .accesskey = s

startup-restore-warn-on-quit =
    .label = هنگام خروج اخطار می‌دهد

disable-extension =
    .label = غیرفعال سازی افزونه

tabs-group-header = زبانه‌ها

ctrl-tab-recently-used-order =
    .label = Ctrl+Tab به ترتیب زبانه‌های اخیرا استفاده شده بین آنها حرکت می‌کند
    .accesskey = T

open-new-link-as-tabs =
    .label = بازکردن پیوندها در زبانه به جای بازکردن در پنجره
    .accesskey = w

warn-on-close-multiple-tabs =
    .label = در هنگام بستن بیش از یک زبانه هشدار داده شود
    .accesskey = ب

warn-on-open-many-tabs =
    .label = در صورتی که باز کردن چند زبانه بتواند باعث کند کردن { -brand-short-name } بشود، به من هشدار بده
    .accesskey = ک

switch-links-to-new-tabs =
    .label = هنگامی که یک پیوند را در زبانه جدید باز میکنم، بلافاصله آن زبانه نمایش داده شود
    .accesskey = ه

show-tabs-in-taskbar =
    .label = پیش‌نمایش زبانه‌ها در نوار وضعیت ویندوز
    .accesskey = ز

browser-containers-enabled =
    .label = فعال‌سازی زبانه‌های حامل
    .accesskey = ع

browser-containers-learn-more = اطلاعات بیشتر

browser-containers-settings =
    .label = تنظیمات…
    .accesskey = ت

containers-disable-alert-title = بستن تمام زبانه‌های حامل؟
containers-disable-alert-desc =
    { $tabCount ->
        [one] اگر هم‌اکنون زبانه‌های حامل را غیرفعال کنید، { $tabCount } زبانه حامل بسته خواهد شد. آیا مطمئنید که می‌خواهید زبانه‌های حامل را غیرفعال کنید؟
       *[other] اگر هم‌اکنون زبانه‌های حامل را غیرفعال کنید، { $tabCount } زبانه حامل بسته خواهند شد. آیا مطمئنید که می‌خواهید زبانه‌های حامل را غیرفعال کنید؟
    }

containers-disable-alert-ok-button =
    { $tabCount ->
        [one] بستن { $tabCount } زبانه حامل
       *[other] بستن { $tabCount } زبانه حامل
    }
containers-disable-alert-cancel-button = فعال باقی بماند

containers-remove-alert-title = این حامل حذف شود؟

# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] اگر هم‌اکنون زبانه‌های حامل را غیرفعال کنید، { $count } زبانه حامل بسته خواهد شد. آیا مطمئنید که می‌خواهید زبانه‌های حامل را غیرفعال کنید؟
       *[other] اگر هم‌اکنون زبانه‌های حامل را غیرفعال کنید، { $count } زبانه حامل بسته خواهند شد. آیا مطمئنید که می‌خواهید زبانه‌های حامل را غیرفعال کنید؟
    }

containers-remove-ok-button = حذف حامل
containers-remove-cancel-button = این حامل حذف نشود


## General Section - Language & Appearance

language-and-appearance-header = زبان و ظاهر

fonts-and-colors-header = قلم‌ها و رنگ‌ها

default-font = قلم پیش‌فرض
    .accesskey = D
default-font-size = اندازه
    .accesskey = ا

advanced-fonts =
    .label = پیشرفته...
    .accesskey = پ

colors-settings =
    .label = رنگها‌...
    .accesskey = ر

# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = بزرگنمایی

preferences-default-zoom = بزرگنمایی پیش‌فرض
    .accesskey = z

preferences-default-zoom-value =
    .label = { $percentage }٪

preferences-zoom-text-only =
    .label = فقط بزرگنمایی متن
    .accesskey = t

language-header = زبان‌ها

choose-language-description = زبان مورد علاقهٔ خود را برای نمایش صفحات انتخاب کنید

choose-button =
    .label = انتخاب…
    .accesskey = ا

choose-browser-language-description = زبانی که برای نمایش منوها، پیام‌ها و اعلان‌ها در { -brand-short-name } استفاده می‌شود را انتخاب کنید
manage-browser-languages-button =
    .label = تنظیم جایگزین‌ها…
    .accesskey = l
confirm-browser-language-change-description = برای اعمال این تغییرات { -brand-short-name } را دوباره راه‌اندازی کن
confirm-browser-language-change-button = اعمال و راه‌اندازی دوباره

translate-web-pages =
    .label = ترجمه محتویات وب
    .accesskey = ت

# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = ترجمه با <img data-l10n-name="logo"/>

translate-exceptions =
    .label = استثناها…
    .accesskey = س

check-user-spelling =
    .label = بررسی املا همزمان با نوشتن
    .accesskey = ن

## General Section - Files and Applications

files-and-applications-title = پرونده‌ها و برنامه‌ها

download-header = بارگیری‌ها

download-save-to =
    .label = ذخیره پرونده در
    .accesskey = ذ

download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] انتخاب…
           *[other] مرور…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] ا
           *[other] م
        }

download-always-ask-where =
    .label = همیشه در مورد محل ذخیره سازی سوال شود
    .accesskey = ه

applications-header = برنامه‌ها

applications-description = اینکه چگونه { -brand-short-name } پرونده‌های دریافت شده از وب یا برنامه‌هایی که هنگام مرور در وب از آنها استفاده می‌کنید را مدیریت کند، را انتخاب کنید.

applications-filter =
    .placeholder = جست‌وجو نوعِ پرونده‌ها یا برنامه‌ها

applications-type-column =
    .label = نوع محتوا
    .accesskey = T

applications-action-column =
    .label = عمل
    .accesskey = A

# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = { $extension } پرونده
applications-action-save =
    .label = ذخیرهٔ پرونده

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = استفاده از { $app-name }

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = استفاده از { $app-name } (پیش‌فرض)

applications-use-other =
    .label = استفاده از برنامه‌ای دیگر…
applications-select-helper = انتخاب برنامهٔ راهنما

applications-manage-app =
    .label = جزئیات برنامه…
applications-always-ask =
    .label = هر بار پرسیده شود
applications-type-pdf = قالب پروندهٔ همراه (PDF)

# Variables:
#   $type (String) - the MIME type (e.g application/binary)
applications-type-pdf-with-type = { applications-type-pdf } ({ $type })

# Variables:
#   $type-description (String) - Description of the type (e.g "Portable Document Format")
#   $type (String) - the MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })

# Variables:
#   $extension (String) - file extension (e.g .TXT)
#   $type (String) - the MIME type (e.g application/binary)
applications-file-ending-with-type = { applications-file-ending } ({ $type })

# Variables:
#   $plugin-name (String) - Name of a plugin (e.g Adobe Flash)
applications-use-plugin-in =
    .label = استفاده از { $plugin-name } (در { -brand-short-name })

## The strings in this group are used to populate
## selected label element based on the string from
## the selected menu item.

applications-use-plugin-in-label =
    .value = { applications-use-plugin-in.label }

applications-action-save-label =
    .value = { applications-action-save.label }

applications-use-app-label =
    .value = { applications-use-app.label }

applications-always-ask-label =
    .value = { applications-always-ask.label }

applications-use-app-default-label =
    .value = { applications-use-app-default.label }

applications-use-other-label =
    .value = { applications-use-other.label }

##

drm-content-header = محتوا مدیریت حقوق دیجیتال(DRM)

play-drm-content =
    .label = پخش محتوا کنترل شده-DRM
    .accesskey = پ

play-drm-content-learn-more = بیشتر بدانید

update-application-title = بروزرسانی‌های { -brand-short-name }:

update-application-description = برای تجربهٔ بهترین کارایی، پایداری و امنیت { -brand-short-name } را به روز نگاه دارید.

update-application-version = نسخه{ $version } <a data-l10n-name="learn-more">امکانات جدید</a>

update-history =
    .label = نمایش تاریخچهٔ بروزرسانی…
    .accesskey = ت

update-application-allow-description = اجازه داده به { -brand-short-name } برای

update-application-auto =
    .label = به صورت خودکار بروزرسانی نصب شود (پیشنهاد می‌شود)
    .accesskey = A

update-application-check-choose =
    .label = وجود بروزرسانی‌ها را بررسی کن، اما به شما اجازه انتخاب برای نصب داده شود
    .accesskey = و

update-application-manual =
    .label = هرگز برای بروزرسانی‌ها بررسی نکن (توصیه نمی‌شود)
    .accesskey = ه

update-application-use-service =
    .label = از سرویس پس‌زمینه برای نصب بروزرسانی ها استفاده شود
    .accesskey = پ

update-setting-write-failure-title = خطا در ذخیره کردن ترجیحات بروزرسانی

update-in-progress-title = در حال بروزرسانی

update-in-progress-message = آیا می‌خواهید { -brand-short-name } به این بروزرسانی ادامه بدهد؟

update-in-progress-ok-button = &نادیده گرفتن
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &ادامه

## General Section - Performance

performance-title = کارایی

performance-use-recommended-settings-checkbox =
    .label = استفاده از تنظیماتِ کارایی توصیه شده
    .accesskey = س

performance-use-recommended-settings-desc = این تنظیمات بر اساس سخت‌افزار و سیستم‌عامل رایانهٔ شما تنظیم می‌شود.

performance-settings-learn-more = بیشتر بدانید

performance-allow-hw-accel =
    .label = استفاده از شتاب‌دهنده‌های سخت‌افزاری در صورت وجود
    .accesskey = ش

performance-limit-content-process-option = محدودیت پروسهٔ محتوا
    .accesskey = م

performance-limit-content-process-enabled-desc = پروسه‌هایِ محتوایِ بیشتر می‌تواند کارایی را هنگام استفاده از چندین زبانه افزایش دهد، اما حافظه بیشتری هم مصرف خواهد کرد.
performance-limit-content-process-blocked-desc = تغییر دادن تعداد پردازدش‌های محتوا تنها با چند‌پردازشی { -brand-short-name } امکان پذیر است. <a data-l10n-name="learn-more">بدانید چگونه بررسی کنید چندپرادزشی فعال است</a>

# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (پیش‌فرض)

## General Section - Browsing

browsing-title = مرور

browsing-use-autoscroll =
    .label = استفاده از لغزش خودکار
    .accesskey = ل

browsing-use-smooth-scrolling =
    .label = استفاده از لغزش هموار
    .accesskey = غ

browsing-use-onscreen-keyboard =
    .label = نمایش یک صفحه‌کلید لمسی در صورت لزوم
    .accesskey = ص

browsing-use-cursor-navigation =
    .label = در مرور صفحات همیشه از مکان‌نما استفاده شود
    .accesskey = ص

browsing-search-on-start-typing =
    .label = هنگامی که شروع به وارد کردن حروف می‌کنم، به دنبال متن جست‌وجو شود
    .accesskey = ج

browsing-picture-in-picture-toggle-enabled =
    .label = کنترل‌های ویدیویی تصویر در تصویر را فعال کنید
    .accesskey = E

browsing-picture-in-picture-learn-more = بیشتر بدانید

browsing-cfr-recommendations =
    .label = پیشنهاد دادن افزونه‌ها همزمان با مرور
    .accesskey = R
browsing-cfr-features =
    .label = پیشنهاد دادن ویژگی‌ها همزمان با مرور وب
    .accesskey = f

browsing-cfr-recommendations-learn-more = بیشتر بدانید

## General Section - Proxy

network-settings-title = تنظیمات شبکه

network-proxy-connection-description = نحوهٔ اتصال { -brand-short-name } به اینترنت را پیکربندی کنید.

network-proxy-connection-learn-more = اطلاعات بیشتر

network-proxy-connection-settings =
    .label = تنظیمات…
    .accesskey = ت

## Home Section

home-new-windows-tabs-header = پنجره‌ها و زبانه‌های جدید

home-new-windows-tabs-description2 = انتخاب کنید چه چیزی در زمان باز کردن صفحهٔ خانگی، پنجره‌ها جدید و زبانه‌های جدید می‌بینید.

## Home Section - Home Page Customization

home-homepage-mode-label = صفحهٔ خانگی و پنجره‌های جدید

home-newtabs-mode-label = زبانه‌های جدید

home-restore-defaults =
    .label = بازنشانی پیش‌فرض‌ها
    .accesskey = R

# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = خانهٔ فایرفاکس (پیش‌فرض)

home-mode-choice-custom =
    .label = آدرس‌های سفارشی…

home-mode-choice-blank =
    .label = صفحهٔ خالی

home-homepage-custom-url =
    .placeholder = جای‌گذاری یک آدرس…

# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] استفاده از صفحهٔ فعلی
           *[other] استفاده از صفحهٔ فعلی
        }
    .accesskey = ف

choose-bookmark =
    .label = استفاده از نشانک…
    .accesskey = ن

## Home Section - Firefox Home Content Customization

home-prefs-content-header = محتوای صفحه خانگی فایرفاکس
home-prefs-content-description = انتخاب کنید که چه محتوایی می‌خواهید در صفحه خانگیِ فایرفاکس خود ببینید.

home-prefs-search-header =
    .label = جست‌وجو وب
home-prefs-topsites-header =
    .label = سایت‌های برتر
home-prefs-topsites-description = سایت‌هایی که بیشتر بازدید می‌کنید

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

# Variables:
#  $provider (String): Name of the corresponding content provider, e.g "Pocket".
home-prefs-recommended-by-header =
    .label = پیشنهاد شده توسط { $provider }
##

home-prefs-recommended-by-learn-more = این چجوری کار میکنه
home-prefs-recommended-by-option-sponsored-stories =
    .label = محتوایی از حامیان مالی

home-prefs-highlights-header =
    .label = برجسته‌ها
home-prefs-highlights-description = گزیده‌ای از سایت‌هایی که بازدید یا ذخیره کرده‌اید
home-prefs-highlights-option-visited-pages =
    .label = صفحات بازدید شده
home-prefs-highlights-options-bookmarks =
    .label = نشانک‌ها
home-prefs-highlights-option-most-recent-download =
    .label = آخرین دریافت
home-prefs-highlights-option-saved-to-pocket =
    .label = صفحات در { -pocket-brand-name } ذخیره شد

# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = قطعه‌ها
home-prefs-snippets-description = بروزرسانی از { -vendor-short-name } و { -brand-product-name }
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } ردیف
           *[other] { $num } ردیف
        }

## Search Section

search-bar-header = نوار جست وجو
search-bar-hidden =
    .label = استفاده از نوادر آدرس برای پیمایش و جست وجو
search-bar-shown =
    .label = اضافه کردن نوار جست‌وجو به نوار ابزار

search-engine-default-header = موتور جست‌وجو پیش‌فرض

search-separate-default-engine =
    .label = از این موتور جستجو در پنجره‌های ناشناس استفاده کنید
    .accesskey = U

search-suggestions-header = پیشنهادهای جستجو
search-suggestions-desc = نحوه ارائه پیشنهادات از موتورهای جستجو را انتخاب کنید.

search-suggestions-option =
    .label = عرضه پیشنهادهای جست‌وجو
    .accesskey = ج

search-show-suggestions-url-bar-option =
    .label = نمایش پیشنهادهای جست‌و‌جو در نوار آدرس
    .accesskey = آ

# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = نمایش پیشنهادات جست‌وجو در بالا ی تاریخچه مرورگر در نوار آدرس

search-suggestions-cant-show = پیشنهادهای جست‌وجو در نوار مکان نمایش داده نخواهد شده زیرا شما { -brand-short-name } را به گونه‌ای تنظیم کرده‌اید که هیچ تاریخچه‌ای را نگه ندارد.

search-one-click-header = موتورهای جست‌وجوی تک-کلیکی

search-one-click-desc = در هنگام وارد کردن کلید واژه‌ها جهت جست‌وجو، موتورهای جست‌وجو جایگزین را از قسمت پایینی نوار آدرس یا نوار جست‌وجو انتخاب کنید.

search-choose-engine-column =
    .label = موتور جست‌وجو
search-choose-keyword-column =
    .label = کلیدواژه

search-restore-default =
    .label = برگرداندن موتور جست‌وجوی پیش‌فرض
    .accesskey = پ

search-remove-engine =
    .label = حذف
    .accesskey = ح

search-find-more-link = پیدا کردن موتورهای جست‌وجو بیشتر

# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = کلیدواژهٔ تکراری
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = شما کلیدواژه‌ای انتخاب نموده‌اید که در حال حاضر توسط «{ $name }» در حال استفاده است. لطفا کلیدواژه دیگری انتخاب کنید.
search-keyword-warning-bookmark = شما کلیدواژه‌ای انتخاب نموده‌اید که در حال حاضر توسط یک نشانک در حال استفاده است.  لطفاً کلیدواژهٔ دیگری انتخاب کنید.

## Containers Section

containers-header = زبانه‌های حامل
containers-add-button =
    .label = افزودن حامل جدید
    .accesskey = ا

containers-preferences-button =
    .label = ترجیحات
containers-remove-button =
    .label = حذف

## Sync Section - Signed out


## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = وب را با خودتان همراه کنید
sync-signedout-description = نشانک‌ها، تاریخچه، زبانه‌ها، گذرواژه‌ها، افزونه‌ها و ترجیحات خود را در تمام دستگاه‌هایتان همگام کنید.

# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = بارگیری فایرفاکس برای <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">اندروید</a> یا <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> جهت همگام‌سازی با دستگاه همراه شما.

## Sync Section - Signed in


## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = تغییرتصویر نمایه

sync-sign-out =
    .label = خروج...
    .accesskey = g

sync-manage-account = مدیریت حساب
    .accesskey = ح

sync-signedin-unverified = { $email } تایید نشده است.
sync-signedin-login-failure = لطفا جهت ارتباط مجدد وارد شوید. { $email }

sync-resend-verification =
    .label = ارسال مجدد تاییدیه
    .accesskey = d

sync-remove-account =
    .label = حذف حساب
    .accesskey = R

sync-sign-in =
    .label = ورود
    .accesskey = و

## Sync section - enabling or disabling sync.

prefs-syncing-on = همگام‌سازی: روشن

prefs-syncing-off = همگام‌سازی: خاموش

prefs-sync-setup =
    .label = راه اندازی { -sync-brand-short-name }...
    .accesskey = S

prefs-sync-offer-setup-label = نشانک‌ها، تاریخچه، زبانه‌ها، گذرواژه‌ها، افزونه‌ها و ترجیحات خود را در تمام دستگاه‌هایتان همگام کنید.

prefs-sync-now =
    .labelnotsyncing = هم‌اکنون همگام‌سازی کنید
    .accesskeynotsyncing = N
    .labelsyncing = درحال همگام‌سازی...

## The list of things currently syncing.

sync-currently-syncing-heading = شما در حال همگام‌سازی این موارد هستید:

sync-currently-syncing-bookmarks = نشانک‌ها
sync-currently-syncing-history = تاریخچه
sync-currently-syncing-tabs = زبانه‌های باز
sync-currently-syncing-logins-passwords = ورودها و گذرواژه‌ها
sync-currently-syncing-addresses = نشانی‌ها
sync-currently-syncing-creditcards = کارت‌های اعتباری
sync-currently-syncing-addons = افزونه‌ها
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] گزینه‌ها
       *[other] ترجیحات
    }

sync-change-options =
    .label = تغییر…
    .accesskey = c

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = چه چیزی را می‌خواهید همگام کنید
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = ذخیره تغییرات
    .buttonaccesskeyaccept = S
    .buttonlabelextra2 = قطع ارتباط
    .buttonaccesskeyextra2 = D

sync-engine-bookmarks =
    .label = نشانک‌ها
    .accesskey = ن

sync-engine-history =
    .label = تاریخچه
    .accesskey = ت

sync-engine-tabs =
    .label = باز کردن زبانه‌ها
    .tooltiptext = فهرستی از تمام دستگاه‌های همگام سازی شده باز
    .accesskey = T

sync-engine-logins-passwords =
    .label = ورودها و گذرواژه‌ها
    .tooltiptext = نام‌های کاربری و گذرواژه‌هایی که ذخیره کرده‌اید
    .accesskey = L

sync-engine-addresses =
    .label = آدرس‌ها
    .tooltiptext = آدرس پستی که شما ذخیره کرده‌ اید(تنها رومیزی)
    .accesskey = آ

sync-engine-creditcards =
    .label = کارت اعتباری
    .tooltiptext = نام، اعداد و تاریخ انتقضا‌( رو میزی تنها)
    .accesskey = ک

sync-engine-addons =
    .label = افزودنی‌ها
    .tooltiptext = افزونه‌ها و زمینه‌ها برای فایرفاکس رومیزی
    .accesskey = ا

sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] گزینه‌ها
           *[other] ترجیحات
        }
    .tooltiptext = عمومی،‌ حریم شخصی، و تنظیمات امنیتی که شما تغییر داده اید
    .accesskey = ت

## The device name controls.

sync-device-name-header = نام دستگاه

sync-device-name-change =
    .label = تغییر نام دستگاه…
    .accesskey = ت

sync-device-name-cancel =
    .label = انصراف
    .accesskey = ا

sync-device-name-save =
    .label = ذخیره
    .accesskey = ذ

sync-connect-another-device = اتصال یک دستگاه دیگر

## Privacy Section

privacy-header = حریم خصوصی مرورگر

## Privacy Section - Forms


## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = ورودها و گذرواژه‌ها
    .searchkeywords = { -lockwise-brand-short-name }

# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = در مورد ذخیره کردن نام‌کاربری و گذرواژه‌ها برای پایگاه‌ها سوال کن
    .accesskey = r
forms-exceptions =
    .label = استثناها…
    .accesskey = ث
forms-generate-passwords =
    .label = پیشنهاد و تولید گذرواژه‌های قوی
    .accesskey = u
forms-breach-alerts =
    .label = هشدارهای مربوط به گذرواژه‌ها در خصوص سایت‌های هک شده را نمایش بده
    .accesskey = b
forms-breach-alerts-learn-more-link = بیشتر بدانید

forms-saved-logins =
    .label = ورودهای ذخیره شده
    .accesskey = و
forms-master-pw-use =
    .label = استفاده از گذرواژهٔ اصلی
    .accesskey = ا
forms-master-pw-change =
    .label = تنظیم گذرواژهٔ اصلی…
    .accesskey = ص

forms-master-pw-fips-title = شما هم‌اکنون در حالت FIPS هستید. در این حالت لازم است گذرواژهٔ اصلی خالی نباشد.

forms-master-pw-fips-desc = تغییر گذرواژه شکست خورد

## OS Authentication dialog


## Privacy Section - History

history-header = تاریخچه

# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Firefox", moving the verb into each option.
#     This will result in "Firefox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = { -brand-short-name } will
    .accesskey = w

history-remember-option-all =
    .label = تاریخچه را به خاطر خواهد داشت
history-remember-option-never =
    .label = هرگز تاریخچه را به خاطر نمی‌سپارد
history-remember-option-custom =
    .label = تنظیمات خاصی را برای تاریخچه استفاده می‌کند

history-remember-description = { -brand-short-name } سابقهٔ مرور، دریافت‌ها، اطلاعات فرم‌ها و تاریخچهٔ جست‌وجوهای شما را به خاطر خواهد آورد.
history-dontremember-description = { -brand-short-name } تنظیمات حالت مرور ناشناس را استفاده خواهد کرد، و هیچ تاریخچه‌ای از مرور شما در وب نگه نخواهد داشت.

history-private-browsing-permanent =
    .label = همیشه از حالت  مرور خصوصی استفاده کن
    .accesskey = م

history-remember-browser-option =
    .label = ذخیرهٔ تاریخچهٔ دریافت‌ها و مرور
    .accesskey = b

history-remember-search-option =
    .label = اطلاعاتی که در فرم‌های صفحات وب و نوار جست‌وجو وارد می‌شوند به خاطر سپرده شود
    .accesskey = ط

history-clear-on-close-option =
    .label = تاریخچه همیشه هنگام بستن { -brand-short-name } پاک شود
    .accesskey = ه

history-clear-on-close-settings =
    .label = تنظیمات
    .accesskey = ت

history-clear-button =
    .label = پاک کردن تاریخچه…
    .accesskey = s

## Privacy Section - Site Data

sitedata-header = کوکی‌ها و اطلاعات وب سایت

sitedata-total-size-calculating = در حال محاسبهٔ اطلاعات پایگاه‌ها و اندازهٔ حافظهٔ نهان…

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = کوکی‌ها، اطلاعات پایگاه‌ها و حافظهٔ نهانِ ذخیره شده در حال حاضر { $value } { $unit } از فضای دیسک شما استفاده می‌کنند.

sitedata-learn-more = بیشتر بدانید

sitedata-delete-on-close =
    .label = پاک کردن کوکی‌ها و داده‌های سایت هنگام بستن { -brand-short-name }.
    .accesskey = c

sitedata-allow-cookies-option =
    .label = پذیرفتن کوکی‌ها و داده‌های سایت
    .accesskey = A

sitedata-disallow-cookies-option =
    .label = مسدودسازی کوکی‌ها و داده‌های سایت
    .accesskey = B

sitedata-option-block-unvisited =
    .label = کوکی‌ها از وب‌سایت‌های مشاهده نشده
sitedata-option-block-all-third-party =
    .label = تمام کوکی‌های متفرقه (ممکن است باعث از کار افتادن سایت‌ها شود)
sitedata-option-block-all =
    .label = تمام کوکی‌ها (باعث از کار افتادن وب‌سایت‌ها می‌شود)

sitedata-clear =
    .label = پاک کردن اطلاعات…
    .accesskey = I

sitedata-settings =
    .label = مدیریت اطلاعات…
    .accesskey = M

sitedata-cookies-permissions =
    .label = مدیریت مجوزها...
    .accesskey = P

## Privacy Section - Address Bar

addressbar-header = نوار نشانی

addressbar-suggest = هنگام استفاده از نوار مکان، پیشنهاد بده

addressbar-locbar-history-option =
    .label = تاریخچه‌ی مرورگر
    .accesskey = م
addressbar-locbar-bookmarks-option =
    .label = نشانک‌ها
    .accesskey = ن
addressbar-locbar-openpage-option =
    .label = زبانه‌های باز
    .accesskey = ز

addressbar-suggestions-settings = تغییر ترجیحات مربوط به پیشنهادهای موتورهای جست‌وجو

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = محفاظت پیشرفته در برابر ردیابی

content-blocking-learn-more = بیشتر بدانید

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = استاندارد
    .accesskey = d
enhanced-tracking-protection-setting-strict =
    .label = شدید
    .accesskey = r
enhanced-tracking-protection-setting-custom =
    .label = سفارشی
    .accesskey = C

##

content-blocking-all-cookies = همه کوکی‌ها
content-blocking-all-third-party-cookies = تمام کوکی‌های متفرقه
content-blocking-cryptominers = استخراج کننده‌های رمزارزها
content-blocking-fingerprinters = برداشت کنندگان اثر انگشت

content-blocking-warning-title = هوشیار باشید!

content-blocking-warning-learn-how = بیشتر بدانید

content-blocking-reload-tabs-button =
    .label = بارگذاری مجدد تمام زبانه‌ها
    .accesskey = R

content-blocking-tracking-content-label =
    .label = محتوای ردیابی
    .accesskey = T
content-blocking-tracking-protection-option-all-windows =
    .label = در همه پنجره‌ها
    .accesskey = A
content-blocking-option-private =
    .label = تنها در پنجره‌های ناشناس
    .accesskey = p
content-blocking-tracking-protection-change-block-list = تغییر لیست مسدودی‌ها

content-blocking-cookies-label =
    .label = کوکی‌ها
    .accesskey = C

content-blocking-expand-section =
    .tooltiptext = اطلاعات بیشتر

# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = استخراج کننده‌های رمزارزها
    .accesskey = y

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = مدیریت استثناها…
    .accesskey = x

## Privacy Section - Permissions

permissions-header = مجوزها

permissions-location = مکان
permissions-location-settings =
    .label = تنظیمات…
    .accesskey = l

permissions-camera = دوربین
permissions-camera-settings =
    .label = تنظیمات…
    .accesskey = c

permissions-microphone = میکروفن
permissions-microphone-settings =
    .label = تنظیمات…
    .accesskey = m

permissions-notification = اعلان‌ها
permissions-notification-settings =
    .label = تنظیمات…
    .accesskey = n
permissions-notification-link = بیشتر بدانید

permissions-notification-pause =
    .label = توقف هوشدار تا زمانی که { -brand-short-name } مجدد راه اندازی شود
    .accesskey = n

permissions-autoplay = پخش خودکار

permissions-autoplay-settings =
    .label = تنظیمات...
    .accesskey = t

permissions-block-popups =
    .label = مسدود کردن پنجره‌های بازشو
    .accesskey = م

permissions-block-popups-exceptions =
    .label = استثناها…
    .accesskey = ا

permissions-addon-install-warning =
    .label = درهنگام تلاش پایگاه اینترنتی برای نصب افزودنی، به من هشدار داده شود
    .accesskey = د

permissions-addon-exceptions =
    .label = استثناها…
    .accesskey = ت

permissions-a11y-privacy-checkbox =
    .label = جلوگیری از دسترسی به سرویس‌ها از طریق مرورگر شما
    .accesskey = a

permissions-a11y-privacy-link = بیشتر بدانید

## Privacy Section - Data Collection

collection-header = ذخیره اطلاعات و استفاده { -brand-short-name }

collection-description = ما تمام تلاش خود را می‌کنیم که به شما حق انتخاب بدهیم و تنها اطلاعاتی را جمع‌آوری کنیم که برای بهبود { -brand-short-name } برای همه، کمک کند. ما همیشه قبل از دریافت اطلاعات شخصی از شما اجازه خواهیم گرفت.
collection-privacy-notice = نکات حفظ حریم خصوصی

collection-health-report =
    .label = اجازه دادن به { -brand-short-name } برای ارسال اطلاعاتِ فنی و رفتاری به { -vendor-short-name }
    .accesskey = r
collection-health-report-link = بیشتر بدانید

collection-studies =
    .label = اجازه دادن به { -brand-short-name } برای نصب و اجرای studyها
collection-studies-link = نمایش studyهای { -brand-short-name }

addon-recommendations =
    .label = اجازه دادن به { -brand-short-name } برای ساخت پیشنهادهای سفارشی شدهٔ مربوط به افزونه‌ها
addon-recommendations-link = بیشتر بدانید

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = گزارش کردن داده‌ها برای این پیکربندی ساخته شده غیرفعال شده است

collection-backlogged-crash-reports =
    .label = به { -brand-short-name } اجازه بده تا گزارش های پس زمینه خرابی را از طرف شما ارسال کند
    .accesskey = c
collection-backlogged-crash-reports-link = بیشتر بدانید

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = امنیت

security-browsing-protection = محافظت در مقابل نرم‌افزارهای خطرناک و محتوا فریبنده

security-enable-safe-browsing =
    .label = مسدود سازی محتوا‌های خطرناک و فریبنده
    .accesskey = م
security-enable-safe-browsing-link = بیشتر بدانید

security-block-downloads =
    .label = مسدود سازی دریافت های خطرناک
    .accesskey = خ

security-block-uncommon-software =
    .label = به من در مورد نرم‌افزارهای نامطلوب و غیرمعمول اخطار بده
    .accesskey = ن

## Privacy Section - Certificates

certs-header = گواهینامه‌ها

certs-personal-label = هنگامی که کارگزاری گواهی شخصی شما را درخواست می‌کند

certs-select-auto-option =
    .label = انتخاب‌ یکی به صورت خودکار
    .accesskey = S

certs-select-ask-option =
    .label = هر بار پرسیده شود
    .accesskey = A

certs-enable-ocsp =
    .label = پرس‌وجو از کارگزار پاسخگوی OCSP جهت تصدیق اعتبار فعلی گواهینامه
    .accesskey = پ

certs-view =
    .label = نمایش‌ گواهینامه‌ها…
    .accesskey = گ

certs-devices =
    .label = امنیت دستگاه‌ها…
    .accesskey = د

space-alert-learn-more-button =
    .label = بیشتر بدانید
    .accesskey = ب

space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] بازکردن گزینه‌ها
           *[other] بازکردن ترجیحات
        }
    .accesskey =
        { PLATFORM() ->
            [windows] ب
           *[other] ب
        }

space-alert-under-5gb-ok-button =
    .label = باشه،‌ متوجه شدم
    .accesskey = ب

space-alert-under-5gb-message = فضای ذخیره سازی { -brand-short-name } تمام شده است. ممکن است محتواهای سایت‌ها خوب نمایش داده نشود.“اطلاعات بیشتر” رابرای بهبود سازی فضای ذخیره سازی خود در جهت کسب تجربه بهتری از مرورگر مشاهده کنید.

## Privacy Section - HTTPS-Only

## The following strings are used in the Download section of settings

desktop-folder-name = رومیزی
downloads-folder-name = بارگیری‌ها
choose-download-folder-title = انتخاب پوشهٔ بارگیری:‏

# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = ذخیره فایل‌ها در { $service-name }
