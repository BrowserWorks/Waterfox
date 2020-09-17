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
    .data-title-private = { -brand-full-name } (نجی براوزنگ)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (نجی براوزنگ)
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
    .data-title-private = { -brand-full-name } - (نجی براوزنگ)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (نجی براوزنگ)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = سائٹ کی معلومات کا نظارہ کریں

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = پیغام کے پینل کو کھولیں اور تنصیب کریں
urlbar-web-notification-anchor =
    .tooltiptext = تبدیل کریں کے آپ اس سائٹ سے اطلاع وصول کرنا چاہتے ہے یا نہیں
urlbar-midi-notification-anchor =
    .tooltiptext = MIDI پینل کھولیں
urlbar-eme-notification-anchor =
    .tooltiptext = DRM سافٹ ویئر کہ استعمال کو منظم کریں
urlbar-web-authn-anchor =
    .tooltiptext = ویب توثیق پینل کھولیں
urlbar-canvas-notification-anchor =
    .tooltiptext = کینوس نکالنے کی اجازت کا انتظام کریں
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = مائیکروفون کی سائٹ کہ ساتھ حصہ داری کو بندوبست کریں
urlbar-default-notification-anchor =
    .tooltiptext = پیغام پینل کھولیں
urlbar-geolocation-notification-anchor =
    .tooltiptext = محل وقوع درخواست پینل کھولیں
urlbar-xr-notification-anchor =
    .tooltiptext = مجازی حقیقت کا اجازتی پینل کھولیں
urlbar-storage-access-anchor =
    .tooltiptext = براؤزنگ سرگرمی کی اجازت والا پینل کھولیں
urlbar-translate-notification-anchor =
    .tooltiptext = اس صفحہ کا ترجمہ کریں
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = اپنے دریچوں یا اسکرین کو اس سائٹ کے ساتھ حصہ داری کے لئے بندوبست کریں
urlbar-indexed-db-notification-anchor =
    .tooltiptext = آف لائن ذخیرہ پیغام پینل کھولیں
urlbar-password-notification-anchor =
    .tooltiptext = مہفوظ شدہ پیغام پینل کھولیں
urlbar-translated-notification-anchor =
    .tooltiptext = صفحہ کہ ترجمہ کو بندوبست کریں
urlbar-plugins-notification-anchor =
    .tooltiptext = پلگ ان کو بندوبست کریں
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = کیمرہ اور مائیکروفون کی سائٹ کے ساتھ حصہ داری کو بندوبست کریں
urlbar-autoplay-notification-anchor =
    .tooltiptext = خودکار چلنے والی پینل کھولیں
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = مسلسل اسٹوریج میں کوائف اسٹور کرے
urlbar-addons-notification-anchor =
    .tooltiptext = ایڈاون کا تنصیب شدہ پیغام کا پینل کھولیں
urlbar-tip-help-icon =
    .title = مدد حاصل کریں
urlbar-search-tips-confirm = ٹھیک ہے، سمجھ آگیا
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = ٹوٹکا:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = کم ٹائپ کریں ، زیادہ ڈھونڈیں: اپنے ایڈریس بار  کے { $engineName } سے تلاش کریں۔
urlbar-search-tips-redirect-2 = { $engineName } سے تجاویز اور براؤزنگ سبقات دیکھنے کے لیے پتے کی بار میں اپنی تلاش کاآغاز کریں

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = بک مارک
urlbar-search-mode-tabs = ٹیبز
urlbar-search-mode-history = سابقات

##

urlbar-geolocation-blocked =
    .tooltiptext = آپ نے اس ویب سائٹ کے لیئے محل وقوع کی معلومات کو بلاک کیا ہوا ہے
urlbar-xr-blocked =
    .tooltiptext = رآپنے اس ویب سائٹ کے لئے ورچوئل رئیلٹی تک رسائی بلاک کر دی ہیں۔
urlbar-web-notifications-blocked =
    .tooltiptext = آپ نے اس ویب سائٹ کے لیئے اطلاع کو بلاک کیا ہوا ہے
urlbar-camera-blocked =
    .tooltiptext = آپ نے اس ویب سائٹ کے لیئے کیمرہ بلاک کیا ہوا ہے
urlbar-microphone-blocked =
    .tooltiptext = آپ نے اس ویب سائٹ کے لیئے مائیکروفون بلاک کیا ہوا ہے۔
urlbar-screen-blocked =
    .tooltiptext = آپ نے اس ویب سائٹ کو سکرین کا اشتراک کرنے سے بلاک کیا ہے
urlbar-persistent-storage-blocked =
    .tooltiptext = آپ نے اس ویب سائٹ کے لیئے مسلسل اسٹوریج کو بلاک کیا ہوا ہے۔
urlbar-popup-blocked =
    .tooltiptext = آپ نے اس ویب سائٹ کے لیئے پوپ اپ بلاک کیا ہوا ہے۔
urlbar-autoplay-media-blocked =
    .tooltiptext = آپنے اس ویب سائٹ کے لئے خودکار چلنیں والی میڈیا مع آواز بلاک کر دی ہیں۔
urlbar-canvas-blocked =
    .tooltiptext = آپنے اس ویب سائٹ کے لئے کینوس کوائف ماحصل بلاک کر دی ہیں۔
urlbar-midi-blocked =
    .tooltiptext = آپنے اس ویب سائٹ کے لئے MIDI تک رسائی بلاک کر دی ہیں۔
urlbar-install-blocked =
    .tooltiptext = آپ نے اس ویب سائٹ کیلئے ایڈ آنا کو انسٹالیشن کو بلاک کیا ہوا ہے۔
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = یہ بک مارک تدوین کریں ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = یہ صفحہ نشان زد کریں ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = ایڈریس بار میں شامل کرے
page-action-manage-extension =
    .label = ایکسٹینشن… منظم کریں
page-action-remove-from-urlbar =
    .label = ایڈریس بار سے ہٹائے
page-action-remove-extension =
    .label = ایکسٹینشن ہٹائیں

## Auto-hide Context Menu

full-screen-autohide =
    .label = ٹول بار چھپائیں
    .accesskey = H
full-screen-exit =
    .label = پوری اسکرین موڈ سے باہر نکلیں
    .accesskey = F

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = اس بار ، کے ساتھ تلاش کریں:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = تلاش سیٹنگز تبدیل کریں
search-one-offs-change-settings-compact-button =
    .tooltiptext = تلاش سیٹنگز تبدیل کریں
search-one-offs-context-open-new-tab =
    .label = نئے ٹیب میں تلاش کرے
    .accesskey = T
search-one-offs-context-set-as-default =
    .label = بطور طے شدہ تلاش انجن سیٹ کریں
    .accesskey = D
search-one-offs-context-set-as-default-private =
    .label = نجی ونڈوں کے لیئے طے شدہ تلاش انجن بنائیں
    .accesskey = P
# Search engine one-off buttons with an @alias shortcut/keyword.
# Variables:
#  $engineName (String): The name of the engine.
#  $alias (String): The @alias shortcut/keyword.
search-one-offs-engine-with-alias =
    .tooltiptext = { $engineName } ({ $alias })

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).

search-one-offs-bookmarks =
    .tooltiptext = بُک مارکس ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = تبز  ({ $restrict })
search-one-offs-history =
    .tooltiptext = سابقات ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = تدوین کار میں محفوظ کرتے وقت نمائش کریں
    .accesskey = S
bookmark-panel-done-button =
    .label = ہوگیا
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = ناقابل بھروسا کنکشن
identity-connection-secure = قابل بھروسا کنکشن
identity-connection-internal = یہ ایک قابل بھروسا { -brand-short-name } صفحہ ہے۔
identity-connection-file = یہ صفحہ آپکے کمپیوٹر پر سٹورڈ ہے۔
identity-extension-page = یہ صفہ ایکسٹینشن سے لوڈ کیا گیا ہے۔
identity-active-blocked = { -brand-short-name } نے اس صفحے کے وہ حصے بلاک کر دیے ہیں جو قابل بھروسا نہیں ہیں۔
identity-passive-loaded = اس صفحے کے حصے قابل بھروسا نہیں ہیں (جیسے کہ نقوش)۔
identity-active-loaded = آپ نے اس صفحے پر حفاظت نا اہل بنا دی ہے۔
identity-weak-encryption = یہ صفحہ کمزور خفیہ کاری استعمال کرتا ہے۔
identity-insecure-login-forms = اس صفحہ پر داخل کردہ لاگ ان اشتباہ کیا جا سکتا ہے۔
identity-permissions =
    .value = اجازتیں
identity-permissions-reload-hint = تبدیلی کو لگانے کے لیئے آپکو صفحہ کو دوبارہ لوڈ کرنے کی شاید ظرورت ہو۔
identity-permissions-empty = آپ نے اس سائٹ کو کوئی خاص اجازتیں نہیں دیں ہے۔
identity-clear-site-data =
    .label = کوکیز اور سائٹ کے کواِئف صاف کریں…
identity-connection-not-secure-security-view = آپ اس سائٹ کے ساتھ غیر محفوظ طریقے سے جڑے ہوئے ہیں۔
identity-connection-verified = آپ اس سائٹ کے ساتھ محفوظ طریقے سے جڑے ہوئے ہیں۔
identity-ev-owner-label = تصدیق نامہ جاری کیا گیا:
identity-remove-cert-exception =
    .label = استثنا ہٹائیں
    .accesskey = R
identity-description-insecure = اس سائٹ سے آپ کی کنکشن رازدار نہیں ہے۔ جو معلومات آپ بھیجتے ہیں (جیسے کے پاس ورڈ، پیغامات، کریڈٹ کارڈ وغیرہ) اسے اور لوگ دیکھ سکیں گے۔
identity-description-insecure-login-forms = جو لاگ ان معلومات آپ اس صفحے پر داخل کرتے ہیں وہ محفوظ نہیں ہے اور اشتباہ ہو سکتی ہے۔
identity-description-weak-cipher-intro = اس ویب سائٹ پر آپ کے کنکشن کمزور خفیہ کندھ استعمال کرتا ہے اور نجی نہیں ہے۔
identity-description-weak-cipher-risk = دیگر لوگ آپ کی معلومات دیکھ سکتے ہیں یا ویب سائٹ کا رویہ بدل سکتے ہیں۔
identity-description-active-blocked = { -brand-short-name }  نے اس صفحے کے وہ حصے بلاک کر دیے ہیں جو قابل بھروسا نہیں ہیں۔ <label data-l10n-name="link">مزید سیکھیں</label>
identity-description-passive-loaded = آپ کی کنکشن رازدار نہیں ہے اور وہ معلومات جو آپ سائٹ سے شیئر کریں گے دیگر لوگ دیکھ سکیں گے۔
identity-description-passive-loaded-insecure = اس ویب سائٹ میں مواد شامل ہے جو کہ قابل بھروسا نہیں ہے (جیسے کے نقوش)۔ <label data-l10n-name="link">مزید سیکھیں</label>
identity-description-passive-loaded-mixed = { -brand-short-name } نے کچھ مواد بلاک کیا ہے، لیکن پھر بھی صفحے پر بواد ہے جو کہ قابل بھروسا نہیں (جیسے کے نقوش)۔ <label data-l10n-name="link">مزید سیکھیں</label>
identity-description-active-loaded = اس ویب سائٹ میں مواد شامل ہے جو کے قابل بھروسا نہیں ہے (جیسے کے نوشتے) اور اس کے ساتھ آپ کی کنکشن قابل بھروسا نہیں ہے۔
identity-description-active-loaded-insecure = وہ معلومات جو آپ اس سائٹ کے ساتھ شیئر کرتے ہیں وہ دیگر لوگ دیکھ سکیں گے (جیسے کے پاس ورڈ، پیغامات، کریڈٹ کارڈ وغیرہ)۔
identity-learn-more =
    .value = مزید سیکھیں
identity-disable-mixed-content-blocking =
    .label = ابھی کے لئے حفاظت کو نا اہل بنائیں
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = تحفظ فعال کریں
    .accesskey = E
identity-more-info-link-text =
    .label = مزید معلومات

## Window controls

browser-window-minimize-button =
    .tooltiptext = چھوٹا کریں
browser-window-maximize-button =
    .tooltiptext = بڑا کریں
browser-window-restore-down-button =
    .tooltiptext = نیچے بحال کریں
browser-window-close-button =
    .tooltiptext = بند کریں

## WebRTC Pop-up notifications

popup-select-camera =
    .value = شیئر کرنے کےلیے کیمرہ:
    .accesskey = C
popup-select-microphone =
    .value = شیئر کرنے کےلیے مائیکروفون:
    .accesskey = M
popup-all-windows-shared = آپ کی سکرین پر نظر آنے والے تمام دریچے شیئر کیے جائیں گے۔
popup-screen-sharing-not-now =
    .label = ابھی نہیں
    .accesskey = w
popup-screen-sharing-never =
    .label = کبھی اجازت نہیں دیں
    .accesskey = N
popup-silence-notifications-checkbox = اشتراک کے دوران { -brand-short-name } سے اطلاعات کو غیر فعال کریں
popup-silence-notifications-checkbox-warning = شیئرنگ کے عمل کے دوران { -brand-short-name } اطلاعات نہیں دکھایے گا.

## WebRTC window or screen share tab switch warning

sharing-warning-proceed-to-tab =
    .label = ٹیب پر آگے بڑھیں

## DevTools F12 popup


## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = تلاش کریں یا پتہ داخل کریں
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = تلاش کریں یا پتہ داخل کریں
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = ویب پر تلاش کریں
    .aria-label = { $name } کے ساتھ تلاش کریں
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = { $name } کے ساتھ تلاش کریں یا پتہ درج کریں
urlbar-remote-control-notification-anchor =
    .tooltiptext = براؤزر ریموٹ کنٹرول کے تحت ہے
urlbar-permissions-granted =
    .tooltiptext = آپ نے اس ویب سائٹ کو اضافی اجازتیں دے دی ہیں۔
urlbar-switch-to-tab =
    .value = ٹیب پر سوئچ کریں:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = ایکسٹینشن:
urlbar-go-button =
    .tooltiptext = محل وقوع بار میں دیے گئے پتے پر جائیں
urlbar-page-action-button =
    .tooltiptext = صفحہ اعمال
urlbar-pocket-button =
    .tooltiptext = { -pocket-brand-name } میں محفوظ کریں

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> اب پوری اسکرین پر ہے
fullscreen-warning-no-domain = یہ دستاویز اب پوری اسکرین پر ہے
fullscreen-exit-button = پوری سکرین سے باہر نکلیں (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = پوری سکرین سے باہر نکلیں (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> آپ کے نشان کار کا کنٹرول ہے۔ Esc دبا کر کنٹرول واپس لیں
pointerlock-warning-no-domain = اس دستاویز کہ پاس آپ کہ نشان کار کا کنٹرول ہے ۔ کنٹرول واپس حاصل کرنے کے لیے Esc دبائیں ۔
