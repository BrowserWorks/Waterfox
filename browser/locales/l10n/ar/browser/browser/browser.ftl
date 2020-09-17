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
    .data-title-private = { -brand-full-name } (التصفح الخاص)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (التصفح الخاص)
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
    .data-title-private = { -brand-full-name } - (التصفح الخاص)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (التصفح الخاص)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = اعرض معلومات الموقع

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = افتح لوحة رسائل التنصيب
urlbar-web-notification-anchor =
    .tooltiptext = غيّر ما إذا ما كنت تسمح باستلام تنبيهات من الموقع
urlbar-midi-notification-anchor =
    .tooltiptext = افتح لوحة MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = أدِر استخدام برمجيات إدارة الحقوق الرقمية
urlbar-web-authn-anchor =
    .tooltiptext = افتح لوحة استيثاق الوِب
urlbar-canvas-notification-anchor =
    .tooltiptext = أدِر تصاريح استخراج ألواح الرسم
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = أدر مشاركة ميكروفونك مع هذا الموقع
urlbar-default-notification-anchor =
    .tooltiptext = افتح لوحة الرسائل
urlbar-geolocation-notification-anchor =
    .tooltiptext = افتح لوحة طلب المكان
urlbar-xr-notification-anchor =
    .tooltiptext = افتح لوحة تصاريح الواقع الافتراضي
urlbar-storage-access-anchor =
    .tooltiptext = افتح لوحة تصاريح نشاط التصفّح
urlbar-translate-notification-anchor =
    .tooltiptext = ترجم هذه الصفحة
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = أدر مشاركة نوافذك أو شاشتك مع هذا الموقع
urlbar-indexed-db-notification-anchor =
    .tooltiptext = افتح لوحة رسائل مساحة التخزين دون اتصال
urlbar-password-notification-anchor =
    .tooltiptext = افتح لوحة رسائل حفظ كلمة السر
urlbar-translated-notification-anchor =
    .tooltiptext = أدِر ترجمة الصفحة
urlbar-plugins-notification-anchor =
    .tooltiptext = أدر الملحقات المستخدمة
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = أدر مشاركة كمرتك و ميكروفونك مع هذا الموقع
urlbar-autoplay-notification-anchor =
    .tooltiptext = افتح لوحة التشغيل التلقائي
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = حفظ البيانات في مساحة تخزين دائمة
urlbar-addons-notification-anchor =
    .tooltiptext = افتح لوحة رسائل تنصيب الإضافات
urlbar-tip-help-icon =
    .title = احصل على مُساعدة
urlbar-search-tips-confirm = حسنًا، فهمت
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = فائدة:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = اكتب بحروف أقل، و جِد نتائج أكثر: ابحث مستخدمًا { $engineName } مباشرة من شريط العنوان.
urlbar-search-tips-redirect-2 = ابدأ البحث من شريط العنوان لترى الاقتراحات من { $engineName } و من تأريخ التصفح.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = العلامات
urlbar-search-mode-tabs = الألسنة
urlbar-search-mode-history = التأريخ

##

urlbar-geolocation-blocked =
    .tooltiptext = لقد حجبت معلومات مكانك عن هذا الموقع.
urlbar-xr-blocked =
    .tooltiptext = لقد حجبت الوصول إلى جهاز الواقع الافتراضي عن هذا الموقع.
urlbar-web-notifications-blocked =
    .tooltiptext = لقد حجبت التنبيهات عن هذا الموقع.
urlbar-camera-blocked =
    .tooltiptext = لقد حجبت كمرتك عن هذا الموقع.
urlbar-microphone-blocked =
    .tooltiptext = لقد حجبت ميكروفونك عن هذا الموقع.
urlbar-screen-blocked =
    .tooltiptext = لقد حجبت هذا الموقع من مشاركة شاشتك.
urlbar-persistent-storage-blocked =
    .tooltiptext = لقد حجبت الحفظ الدائم للبيانات عن هذا الموقع.
urlbar-popup-blocked =
    .tooltiptext = لقد حجبت المنبثقات من هذا الموقع.
urlbar-autoplay-media-blocked =
    .tooltiptext = لقد حجبت تشغيل الوسائط التي تحتوي صوتا تلقائيا في هذا الموقع.
urlbar-canvas-blocked =
    .tooltiptext = لقد منعت استخراج بيانات رقعة الرسم في هذا الموقع.
urlbar-midi-blocked =
    .tooltiptext = لقد حجبنا عن هذا الموقع الوصول إلى MIDI.
urlbar-install-blocked =
    .tooltiptext = حجبت تثبيت الإضافات في هذا الموقع.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = حرّر هذه العلامة ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = علّم هذه الصفحة ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = أضف إلى شريط العناوين
page-action-manage-extension =
    .label = أدِر الامتدادات…
page-action-remove-from-urlbar =
    .label = أزل من شريط العناوين
page-action-remove-extension =
    .label = أزِل الامتداد

## Auto-hide Context Menu

full-screen-autohide =
    .label = اخفِ شريط الأدوات
    .accesskey = خ
full-screen-exit =
    .label = اخرج من وضع ملء الشاشة
    .accesskey = و

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = الآن فقط ابحث باستعمال:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = غيّر إعدادات البحث
search-one-offs-change-settings-compact-button =
    .tooltiptext = غيّر إعدادات البحث
search-one-offs-context-open-new-tab =
    .label = ابحث في لسان جديد
    .accesskey = س
search-one-offs-context-set-as-default =
    .label = اجعله محرك البحث الافتراضي
    .accesskey = ف
search-one-offs-context-set-as-default-private =
    .label = اضبطه ليكون محرّك البحث المبدئي في النوافذ الخاصة
    .accesskey = ن
# Search engine one-off buttons with an @alias shortcut/keyword.
# Variables:
#  $engineName (String): The name of the engine.
#  $alias (String): The @alias shortcut/keyword.
search-one-offs-engine-with-alias =
    .tooltiptext = ‏{ $engineName } ‏({ $alias })

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).

search-one-offs-bookmarks =
    .tooltiptext = العلامات ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = الألسنة ({ $restrict })
search-one-offs-history =
    .tooltiptext = التأريخ ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = اعرض المحرر عند الحفظ
    .accesskey = ظ
bookmark-panel-done-button =
    .label = تمّ
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = الاتصال غير آمن
identity-connection-secure = الاتصال آمن
identity-connection-internal = هذه صفحة { -brand-short-name } آمنة.
identity-connection-file = هذه الصفحة مخزنة على حاسوبك.
identity-extension-page = حمِّلت هذه الصفحة من امتداد.
identity-active-blocked = حجب { -brand-short-name } الأجزاء غير الآمنة في هذه الصفحة.
identity-custom-root = تثبّت من هذا الاتصال مُصْدِر شهادات لا تعرفه Mozilla.
identity-passive-loaded = بعض أجزاء هذه الصفحة غير آمنة (مثل الصور).
identity-active-loaded = لقد أوقفت الحماية على هذه الصفحة.
identity-weak-encryption = تستخدم هذه الصفحة تعمية ضعيفة.
identity-insecure-login-forms = معلومات الولوج التي تُدخلها في هذه الصفحة قد تكون مخترقة.
identity-permissions =
    .value = التصاريح
identity-permissions-reload-hint = قد تحتاج إعادة تحميل الصفحة لتطبيق التغييرات.
identity-permissions-empty = لم تمنح هذا الموقع أي صلاحيات خاصة.
identity-clear-site-data =
    .label = امسح الكعكات و بيانات المواقع…
identity-connection-not-secure-security-view = لست متصلا مع هذا الموقع بأمان.
identity-connection-verified = أنت متصل مع هذا الموقع بأمان.
identity-ev-owner-label = أُصدرت الشّهادة إلى:
identity-description-custom-root = لم تتعرّف Mozilla على مُصْدِر الشهادات هذا. لربّما أضافه نظام التشغيل أو أحد المدراء. <label data-l10n-name="link">اطّلع على المزيد</label>
identity-remove-cert-exception =
    .label = أزِل الاستثناء
    .accesskey = س
identity-description-insecure = اتصالك بهذا الموقع ليس خاصًّا. يمكن للآخرين مطالعة المعلومات التي ترسلها (مثل كلمات السر، و الرسائل، و بطاقات الائتمان و غيرها).
identity-description-insecure-login-forms = معلومات الولوج التي تُدخلها في هذه الصفحة ليست مُؤمّنة و قد تكون مخترقة.
identity-description-weak-cipher-intro = اتصالك بهذا الموقع يستخدم تعمية ضعيفة وليس خاصًّا أيضًا.
identity-description-weak-cipher-risk = يمكن للآخرين الاطلاع على معلوماتك أو تغيير سلوك الموقع.
identity-description-active-blocked = حجب { -brand-short-name } الأجزاء غير الآمنة في هذه الصفحة. <label data-l10n-name="link">اطّلع على المزيد</label>
identity-description-passive-loaded = اتصالك ليس خاصًا و يمكن للآخرين مطالعة المعلومات التي تشاركها مع الموقع.
identity-description-passive-loaded-insecure = يحوي هذا الموقع محتوى غير آمن (مثل الصور). <label data-l10n-name="link">اطّلع على المزيد</label>
identity-description-passive-loaded-mixed = مع أنّ { -brand-short-name } حجب بعض المحتويات، إلا أن هناك أخرى غير آمنة ما زالت في الصفحة (مثل الصور). <label data-l10n-name="link">اطّلع على المزيد</label>
identity-description-active-loaded = يحوي هذا الموقع محتوى غير آمن (مثل السكربتات) و اتصالك به ليس خاصا.
identity-description-active-loaded-insecure = يمكن للآخرين مطالعة المعلومات التي تشاركها مع الموقع (مثل كلمات السر، و الرسائل، و بطاقات الائتمان و غيرها).
identity-learn-more =
    .value = اطّلع على المزيد
identity-disable-mixed-content-blocking =
    .label = عطّل الحماية في الوقت الحالي
    .accesskey = ع
identity-enable-mixed-content-blocking =
    .label = فعّل الحماية
    .accesskey = ف
identity-more-info-link-text =
    .label = المزيد من المعلومات

## Window controls

browser-window-minimize-button =
    .tooltiptext = صغّر
browser-window-maximize-button =
    .tooltiptext = كبِّر
browser-window-restore-down-button =
    .tooltiptext = أنزِله
browser-window-close-button =
    .tooltiptext = أغلق

## WebRTC Pop-up notifications

popup-select-camera =
    .value = الكمرة التي ستُشارك:
    .accesskey = م
popup-select-microphone =
    .value = الميكروفون الذي سيُشارك:
    .accesskey = ك
popup-all-windows-shared = ستُشارك كل النوافذ الظاهرة على شاشتك.
popup-screen-sharing-not-now =
    .label = ليس الآن
    .accesskey = ل
popup-screen-sharing-never =
    .label = لا تسمح أبدًا
    .accesskey = س
popup-silence-notifications-checkbox = عطّل التنبيهات { -brand-short-name } أثناء المشاركة
popup-silence-notifications-checkbox-warning = لن يعرض { -brand-short-name } التنبيهات أثناء المشاركة.

## WebRTC window or screen share tab switch warning

sharing-warning-window = أنت تُشارك { -brand-short-name }. يقدر الآخرين على رؤيتك حين تنتقل إلى لسان جديد.
sharing-warning-screen = أنت تُشارك شاشتك كلها. يقدر الآخرين على رؤيتك حين تنتقل إلى لسان جديد.
sharing-warning-proceed-to-tab =
    .label = واصِل إلى اللسان
sharing-warning-disable-for-session =
    .label = أوقِف حماية المشاركة لهذه الجلسة

## DevTools F12 popup

enable-devtools-popup-description = افتح أولا أدوات المطورين من قائمة مطوّري الوِب لاستعمال الاختصار F12.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = ابحث أو أدخل عنوانا
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = ابحث أو أدخل عنوانا
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = ابحث في الوِب
    .aria-label = ابحث مستعملًا { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = أدخِل نص البحث
    .aria-label = ابحث عن { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = أدخِل نص البحث
    .aria-label = ابحث في العلامات
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = أدخِل نص البحث
    .aria-label = ابحث في التأريخ
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = أدخِل نص البحث
    .aria-label = ابحث في الألسنة
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = ‫ابحث مستعملًا { $name } أو أدخِل عنوانا
urlbar-remote-control-notification-anchor =
    .tooltiptext = يخضع المتصفح للتحكم عن بعد
urlbar-permissions-granted =
    .tooltiptext = منحت هذا الموقع صلاحيات أخرى.
urlbar-switch-to-tab =
    .value = انتقل إلى اللسان:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = الامتداد:
urlbar-go-button =
    .tooltiptext = انتقل للعنوان في شريط الموقع
urlbar-page-action-button =
    .tooltiptext = إجراءات الصفحة
urlbar-pocket-button =
    .tooltiptext = احفظ في { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> يملأ الشاشة الآن
fullscreen-warning-no-domain = يملأ هذا المستند الشاشة الآن
fullscreen-exit-button = غادر ملء الشاشة (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = غادر ملء الشاشة (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = يتحكم <span data-l10n-name="domain">{ $domain }</span> في مؤشرك. اضغط Esc لتستعيد التحكم.
pointerlock-warning-no-domain = يتحكم هذا المستند في مؤشرك. اضغط Esc لتستعيد التحكم.
