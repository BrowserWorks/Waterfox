# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - "Mozilla Firefox"
# private - "Mozilla Firefox (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } (مرور ناشناس)‏
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (مرور ناشناس)‏
# These are the default window titles on macOS. The first two are for use when
# there is no content title:
#
# "default" - "Mozilla Firefox"
# "private" - "Mozilla Firefox - (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Do not use the brand name in the last two attributes, as we do on non-macOS.
#
# Also note the other subtle difference here: we use a `-` to separate the
# brand name from `(Private Browsing)`, which does not happen on other OSes.
#
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-mac =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } - (مرور ناشناس)‏
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (مرور ناشناس)‏
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = نمایش اطلاعات سایت

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = باز کردن تابلو پیام‌های نصب
urlbar-web-notification-anchor =
    .tooltiptext = اینکه آیا می‌توانید از این سایت اعلان دریافت کنید یا خیر را تغییر دهید
urlbar-midi-notification-anchor =
    .tooltiptext = باز کردن تابلو MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = مدیریت استفاده از نرم‌افزار‌های DRM
urlbar-web-authn-anchor =
    .tooltiptext = باز کردن تابلوی تصدیق هویت وب
urlbar-canvas-notification-anchor =
    .tooltiptext = مدیریت مجوز بوم های استخراج شده
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = مدیریت به‌اشتراک‌گذاری میکروفن با این پایگاه
urlbar-default-notification-anchor =
    .tooltiptext = باز کردن تابلو پیام‌ها
urlbar-geolocation-notification-anchor =
    .tooltiptext = باز کردن تابلوی درخواستِ مکان
urlbar-xr-notification-anchor =
    .tooltiptext = باز کردن تابلوی مجوز واقعیت مجازی
urlbar-storage-access-anchor =
    .tooltiptext = باز کردن تابلوی مجوز فعالیت مرور
urlbar-translate-notification-anchor =
    .tooltiptext = ترجمه این صفحه
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = مدیریت به اشتراک‌گذاری پنجره یا صفحه خود با پایگاه
urlbar-indexed-db-notification-anchor =
    .tooltiptext = باز کردن تابلو ذخیرهٔ برون‌خط
urlbar-password-notification-anchor =
    .tooltiptext = باز کردن تابلو پیام‌های ذخیره گذواژه
urlbar-translated-notification-anchor =
    .tooltiptext = مدیریت صفحه ترجمه
urlbar-plugins-notification-anchor =
    .tooltiptext = مدیریت استفاده از افزونه
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = مدیریت اینکه آیا دوربین و/یا میکروفون خود را با این سایت به اشتراک می‌گذارید یا خیر
urlbar-autoplay-notification-anchor =
    .tooltiptext = بازکردن قطعه پخش خودکار
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = ذخیره اطلاعات به صورت ذخیره دائمی
urlbar-addons-notification-anchor =
    .tooltiptext = باز کردن تابلو پیام‌های نصب افزودنی‌ها
urlbar-tip-help-icon =
    .title = کمک بگیرید
urlbar-search-tips-confirm = باشه، فهمیدم
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = نکات:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = کمتر تایپ کنید، بیشتر پیدا کنید: تنها از طریق نوار آدرس با { $engineName } جست‌وجو کنید.
urlbar-search-tips-redirect-2 = جست‌وجوی خود را در نوار آدرس تایپ کنید تا پیشنهادهایی از { $engineName } و تاریخچهٔ مرور خود ببینید.

## Local search mode indicator labels in the urlbar


##

urlbar-geolocation-blocked =
    .tooltiptext = شما این پایگاه‌وب را برای دسترسی به اطلاعات مکانی مسدود کرده‌اید.
urlbar-xr-blocked =
    .tooltiptext = شما دسترسی این وب‌سایت را به دستگاه واقعیت مجازی مسدود کرده‌اید.
urlbar-web-notifications-blocked =
    .tooltiptext = شما این پایگاه‌وب را برای امکان ارسال اعلان مسدود کرده‌اید.
urlbar-camera-blocked =
    .tooltiptext = شما این پایگاه‌وب را برای دسترسی به دوربین مسدود کرده‌اید.
urlbar-microphone-blocked =
    .tooltiptext = شما این پایگاه‌وب را برای دسترسی به میکروفن مسدود کرده‌اید.
urlbar-screen-blocked =
    .tooltiptext = شما این پایگاه‌وب را برای اشتراک‌گذاری صفحهٔ خود مسدود کرده‌اید.
urlbar-persistent-storage-blocked =
    .tooltiptext = شما این پایگاه‌وب را برای ذخیره اطلاعات مسدود کرده‌اید.
urlbar-popup-blocked =
    .tooltiptext = شما پنجره باز شو مسدود شده برای این پایگاه اینترنتی دارید.
urlbar-autoplay-media-blocked =
    .tooltiptext = شما پخش خودکار رسانه صدا را برای این پایگاه اینترنتی مسدود کرده‌اید.
urlbar-canvas-blocked =
    .tooltiptext = شما بوم‌های استراخ شده‌ای از این وب سایت دادرید که مسدود شده‌‌اند.
urlbar-midi-blocked =
    .tooltiptext = شما دسترسی این وب‌سایت به MIDI را مسدود کرده‌اید.
urlbar-install-blocked =
    .tooltiptext = شما نصب افزونه‌ها از طریق این وب‌سایت را مسدود کرده‌اید.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = ویرایش این نشانک ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = نشانک‌گذاری این صفحه({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = اضافه کردن به نوار آدرس
page-action-manage-extension =
    .label = مدیریت افزونه…
page-action-remove-from-urlbar =
    .label = حذف از نوار آدرس
page-action-remove-extension =
    .label = حذف افزونه

## Auto-hide Context Menu

full-screen-autohide =
    .label = پنهان‌سازی نوارهای ابزار
    .accesskey = پ
full-screen-exit =
    .label = خروج از حالت مرور تمام‌صفحه
    .accesskey = ت

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = این بار، جست‌وجو با:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = تغییر تنظیمات جستجو
search-one-offs-change-settings-compact-button =
    .tooltiptext = تغییر تنظیمات جستجو
search-one-offs-context-open-new-tab =
    .label = جست‌وجو در زبانه جدید
    .accesskey = ز
search-one-offs-context-set-as-default =
    .label = تنظیم به عنوان موتور جست‌وجو پیش‌فرض
    .accesskey = پ
search-one-offs-context-set-as-default-private =
    .label = تنظیم به عنوان موتور جست‌وجو پیش‌فرض در پنجره‌های ناشناس
    .accesskey = P

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).


## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = نمایش ویرایش‌گر هنگام ذخیره‌سازی
    .accesskey = S
bookmark-panel-done-button =
    .label = انجام شد
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = اتصال امن نیست
identity-connection-secure = اتصال امن است
identity-connection-internal = این یک صفحهٔ امن { -brand-short-name } است.
identity-connection-file = این صفحه بر روی رایانه شما ذخیره شده است.
identity-extension-page = این صفحه توسط یک افزونه بارگیری شده است.
identity-active-blocked = { -brand-short-name } قسمت‌هایی از این صفحه را که ایمن نیستند، مسدود کرده است.
identity-custom-root = گواهیِ این اتصال، توسط صادرکننده‌ای ایجاد شده است که برای موزیلا قابل شناسایی نیست.
identity-passive-loaded = قسمت‌هایی از این صفحه امن نیست (مانند تصاویر).
identity-active-loaded = شما محافظت را در این صفحه غیرفعال کرده‌اید.
identity-weak-encryption = این صفحه از کدگذاری ضعیفی استفاده می‌کند.
identity-insecure-login-forms = اطلاعات ورودی که در این صفحه وارد می‌کنید می‌توانند فاش شوند.
identity-permissions =
    .value = مجوزها
identity-permissions-reload-hint = ممکن است لازم باشد که صفحه را برای اعمال تغییرات دوباره بارگیری کنید.
identity-permissions-empty = شما به این سایت هیچ دسترسی خاصی نداده‌اید.
identity-clear-site-data =
    .label = حذف کوکی‌ها و اطلاعات پایگاه‌ها…
identity-connection-not-secure-security-view = شما بطور امن به این سایت متصل نشده‌اید.
identity-connection-verified = شما بطور امن به این سایت متصل شده‌اید.
identity-ev-owner-label = گواهی صادر شده برای:
identity-description-custom-root = صادر کنندهٔ این گواهی برای موزیلا قابل شناسایی نیست. ممکن است از طریق سیستم‌عامل یا مدیرِ سیستم شما اضافه شده باشد. <label data-l10n-name="link">بیشتر بدانید</label>
identity-remove-cert-exception =
    .label = حذف استثنا
    .accesskey = ح
identity-description-insecure = اتصال شما با این سایت خصوصی نیست. اطلاعاتی که شما ثبت می‌کنید ممکن است توسط دیگران دیده شود (مانند گذرواژه‌ها، پیام‌ها، کارت‌های بانکی و غیره).
identity-description-insecure-login-forms = اطلاعات ورود شما که در این صفحه وارد می‌کنید امن نیستند و ممکن است در معرض خطر باشند.
identity-description-weak-cipher-intro = اتصال شما با این سایت از کدگذاری ضعیفی استفاده می‌کند و خصوصی نیست.
identity-description-weak-cipher-risk = افراد دیگر می‌توانند اطلاعات شما را ببینید یا رفتار سایت را تغییر دهند.
identity-description-active-blocked = { -brand-short-name } قسمت‌هایی از این صفحه را که ایمن نیستند، مسدود کرده است. <label data-l10n-name="link">بیشتر بدانید</label>
identity-description-passive-loaded = اتصال شما خصوصی نیست و اطلاعاتی که با سایت اشتراک می‌گذارید می‌تواند توسط دیگران دیده شود.
identity-description-passive-loaded-insecure = این سایت حاوی محتوایی است که ایمن نیستند (مانند تصاویر). <label data-l10n-name="link">بیشتر بدانید</label>
identity-description-passive-loaded-mixed = با اینکه { -brand-short-name } بعضی از محتوا را مسدود کرده است، هنوز محتوای در این سایت هستند که ایمن نیستند (مانند تصاویر). <label data-l10n-name="link">بیشتر بدانید</label>
identity-description-active-loaded = این سایت شامل محتوایی است که ایمن نیستند (مانند کدنوشته‌ها) و اتصال شما به آن خصوصی نیست.
identity-description-active-loaded-insecure = اطلاعاتی که با این سایت به‌اشتراک می‌گذارید ممکن است توسط دیگران دیده شوند (مانند گذرواژه‌ها، پیام‌ها، کارت‌های اعتباری و غیره).
identity-learn-more =
    .value = بیشتر بدانید
identity-disable-mixed-content-blocking =
    .label = فعلا محافظت غیرفعال شود.
    .accesskey = غ
identity-enable-mixed-content-blocking =
    .label = فعال‌سازی محافظت
    .accesskey = ف
identity-more-info-link-text =
    .label = اطلاعات بیشتر

## Window controls

browser-window-minimize-button =
    .tooltiptext = کمینه کردن
browser-window-maximize-button =
    .tooltiptext = بزرگ کردن
browser-window-close-button =
    .tooltiptext = بستن

## WebRTC Pop-up notifications

popup-select-camera =
    .value = دوربین جهت به‌اشتراک‌گذاری:
    .accesskey = د
popup-select-microphone =
    .value = میکروفون جهت به‌اشتراک‌گذاری:
    .accesskey = م
popup-all-windows-shared = همه‌ی پنجره‌هایی که مشاهده می‌کنید به اشتراک گذاشته می‌شود.
popup-screen-sharing-not-now =
    .label = اکنون نه (w)
    .accesskey = w
popup-screen-sharing-never =
    .label = هرگز اجازه نده (N)
    .accesskey = N
popup-silence-notifications-checkbox = از کار انداختن آگاهی‌ها از { -brand-short-name } هنگام هم‌رسانی
popup-silence-notifications-checkbox-warning = { -brand-short-name } هنگام هم‌رسانی، اعلان‌ها را نمایش نمی‌دهد.

## WebRTC window or screen share tab switch warning

sharing-warning-window = شما در حال هم‌رسانی { -brand-short-name } هستید. افراد دیگر می‌توانند هنگام تغییر زبانه‌ها آنها را ببینند.
sharing-warning-screen = شما در حال هم‌رسانی تمام صفحه‌نمایش خود هستید. افراد دیگر می‌توانند هنگام تغییر زبانه‌ها آنها را ببینند.
sharing-warning-proceed-to-tab =
    .label = رفتن به زبانه
sharing-warning-disable-for-session =
    .label = از کار انداختن محافظت هم‌رسانی برای این نشست

## DevTools F12 popup

enable-devtools-popup-description = برای استفاده از میانبر F12، ابتدا DevTools را از طریق منوی توسعه‌دهندگان باز کنید.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = متنی برای جست‌وجو یا یک آدرس وارد کنید
urlbar-placeholder =
    .placeholder = متنی برای جست‌وجو یا یک آدرس وارد کنید
urlbar-remote-control-notification-anchor =
    .tooltiptext = مرورگر تحت کنترل از راه دور است
urlbar-permissions-granted =
    .tooltiptext = به این پایگاه وب دسترسی‌های اضافی اعطا کرده‌اید.
urlbar-switch-to-tab =
    .value = پرش به زبانه:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = ضمیمه:
urlbar-go-button =
    .tooltiptext = رفتن به نشانی موجود در نوار مکان
urlbar-page-action-button =
    .tooltiptext = کنش‌های صفحه
urlbar-pocket-button =
    .tooltiptext = ذخیره‌سازی در { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> حالا در حالت تمام‌صفحه است
fullscreen-warning-no-domain = این سند حالا در حالت تمام‌صفحه است
fullscreen-exit-button = خروج از حالت تمام‌صفحه (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = خروج از حالت تمام‌صفحه (Esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> کنترل مکان‌نما شما را در دست دارد. برای پس گرفتن کنترل، Esc را فشار دهید.
pointerlock-warning-no-domain = این سند کنترل مکان‌نما شما را در دست گرفته است. برای پس گرفتن کنترل، Esc را فشار دهید.
