# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = أرسل للمواقع إشارة ”لا تتعقبني“ بأنك لا تريد أن يتعقبوك
do-not-track-learn-more = اطّلع على المزيد
do-not-track-option-default-content-blocking-known =
    .label = فقط حين يُضبط { -brand-short-name } على حجب المتعقّبات المعروفة
do-not-track-option-always =
    .label = دائمًا

settings-page-title = الإعدادات

# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box2 =
    .style = width: 15.4em
    .placeholder = ابحث في الإعدادات

managed-notice = تُدير منظّمتك المتصفح الذي تستخدم الآن.

category-list =
    .aria-label = الفئات

pane-general-title = عام
category-general =
    .tooltiptext = { pane-general-title }

pane-home-title = المنزل
category-home =
    .tooltiptext = { pane-home-title }

pane-search-title = البحث
category-search =
    .tooltiptext = { pane-search-title }

pane-privacy-title = الخصوصية و الأمان
category-privacy =
    .tooltiptext = { pane-privacy-title }

pane-sync-title3 = المزامنة
category-sync3 =
    .tooltiptext = { pane-sync-title3 }

pane-experimental-title = تجارب { -brand-short-name }
category-experimental =
    .tooltiptext = تجارب { -brand-short-name }
pane-experimental-subtitle = واصِل وأنت حذر
pane-experimental-search-results-header = تجارب { -brand-short-name }: واصِل وأنت حذر
pane-experimental-description2 = يمكن أن يؤثّر التغيير على إعدادات الضبط المتقدمة أداء { -brand-short-name } وأمنه.

pane-experimental-reset =
    .label = استعد المبدئيات
    .accesskey = س

help-button-label = دعم { -brand-short-name }
addons-button-label = الامتدادات والسمات

focus-search =
    .key = f

close-button =
    .aria-label = أغلق

## Browser Restart Dialog

feature-enable-requires-restart = يجب إعادة تشغيل { -brand-short-name } لتفعيل هذه الخاصية.
feature-disable-requires-restart = يجب إعادة تشغيل { -brand-short-name } لتعطيل هذه الخاصية.
should-restart-title = أعِد تشغيل { -brand-short-name }
should-restart-ok = أعد تشغيل { -brand-short-name } الآن
cancel-no-restart-button = ألغِ
restart-later = أعِد التشغيل لاحقًا

## Extension Control Notifications
##
## These strings are used to inform the user
## about changes made by extensions to browser settings.
##
## <img data-l10n-name="icon"/> is going to be replaced by the extension icon.
##
## Variables:
##   $name (String): name of the extension

# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlled-password-saving = يتحكم أحد الامتدادات (<img data-l10n-name="icon"/> { $name }) في هذا الإعداد.

# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = يتحكّم الامتداد <img data-l10n-name="icon"/> { $name } بهذا الإعداد.

# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = يتطلب أحد الامتدادات (<img data-l10n-name="icon"/> { $name }) الألسنة الحاوية.

# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = يتحكم أحد الامتدادات (<img data-l10n-name="icon"/> { $name }) في هذا الإعداد.

# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = يتحكم أحد الامتدادات <img data-l10n-name="icon"/> { $name } في طريقة اتصال { -brand-short-name } بالإنترنت.

# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = لتفعيل الامتداد انتقل إلى <img data-l10n-name="addons-icon"/> الإضافات في <img data-l10n-name="menu-icon"/> القائمة.

## Preferences UI Search Results

search-results-header = نتائج البحث

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message2 = للأسف لا نتائج في الإعدادات عن ”<span data-l10n-name="query"></span>“.

search-results-help-link = أتحتاج للمساعدة؟ زُر <a data-l10n-name="url">دعم { -brand-short-name }</a>

## General Section

startup-header = البدء

always-check-default =
    .label = تحقق دائمًا من كون { -brand-short-name } متصفّحك المبدئي
    .accesskey = د

is-default = ‏{ -brand-short-name } هو المتصفح المبدئي حاليا
is-not-default = ‏{ -brand-short-name } ليس المتصفح المبدئي حاليا

set-as-my-default-browser =
    .label = اجعله المبدئي…
    .accesskey = م

startup-restore-previous-session =
    .label = استعد الجلسة السابقة
    .accesskey = س

startup-restore-warn-on-quit =
    .label = نبّهني عند إنهاء المتصفح

disable-extension =
    .label = عطّل الامتداد

tabs-group-header = الألسنة

ctrl-tab-recently-used-order =
    .label = ‏Ctrl+Tab يتنقّل عبر الألسنة حسب ترتيب آخر استخدام
    .accesskey = T

open-new-link-as-tabs =
    .label = افتح الروابط في ألسنة بدل فتح نوافذ جديدة
    .accesskey = ن

warn-on-close-multiple-tabs =
    .label = نبّهني عند محاولة إغلاق عدّة ألسنة
    .accesskey = ة

warn-on-open-many-tabs =
    .label = نبّهني عند فتح عدة ألسنة أن هذا قد يبطئ { -brand-short-name }
    .accesskey = ف

show-tabs-in-taskbar =
    .label = أظهِر معاينات للألسنة في شريط مهام ويندوز
    .accesskey = و

browser-containers-enabled =
    .label = فعل الألسنة الحاوية
    .accesskey = ف

browser-containers-learn-more = اطّلع على المزيد

browser-containers-settings =
    .label = الإعدادات…
    .accesskey = د

containers-disable-alert-title = أأغلق كل الألسنة الحاوية؟
containers-disable-alert-desc =
    { $tabCount ->
        [one] إذا عطلت الألسنة الحاوية الآن فسيغلق لسان حاو. أمتأكد أنك تريد تعطيل الألسنة الحاوية؟
        [two] إذا عطلت الألسنة الحاوية الآن فسيغلق لسانين حاويين. أمتأكد أنك تريد تعطيل الألسنة الحاوية؟
        [few] إذا عطلت الألسنة الحاوية الآن فستغلق { $tabCount } ألسنة حاوية. أمتأكد أنك تريد تعطيل الألسنة الحاوية؟
        [many] إذا عطلت الألسنة الحاوية الآن فسيغلق { $tabCount } لسانًا حاويًا. أمتأكد أنك تريد تعطيل الألسنة الحاوية؟
       *[other] إذا عطلت الألسنة الحاوية الآن فسيغلق { $tabCount } لسان حاو. أمتأكد أنك تريد تعطيل الألسنة الحاوية؟
    }

containers-disable-alert-ok-button =
    { $tabCount ->
        [one] أغلق اللسان الحاوي
        [two] أغلق اللسانين الحاويين
        [few] أغلق { $tabCount } ألسنة حاوية
        [many] أغلق { $tabCount } لسانًا حاويًا
       *[other] أغلق { $tabCount } لسان حاو
    }
containers-disable-alert-cancel-button = أبقها مفعلّة

containers-remove-alert-title = أتريد إزالة هذه الحاوية؟

# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] إذا أزلت هذه الحاوية الآن فسيغلق لسان حاو. أمتأكد أنك تريد إزالة هذه الحاوية؟
        [two] إذا أزلت هذه الحاوية الآن فسيغلق لسانين حاويين. أمتأكد أنك تريد إزالة هذه الحاوية؟
        [few] إذا أزلت هذه الحاوية الآن فستغلق { $count } ألسنة حاوية. أمتأكد أنك تريد إزالة هذه الحاوية؟
        [many] إذا أزلت هذه الحاوية الآن فسيغلق { $count } لسانًا حاويًا. أمتأكد أنك تريد إزالة هذه الحاوية؟
       *[other] إذا أزلت هذه الحاوية الآن فسيغلق { $count } لسان حاو. أمتأكد أنك تريد إزالة هذه الحاوية؟
    }

containers-remove-ok-button = أزل الحاوية
containers-remove-cancel-button = لا تزِل هذه الحاوية


## General Section - Language & Appearance

language-and-appearance-header = اللغة و المظهر

fonts-and-colors-header = الخطوط و الألوان

default-font = الخط المبدئي
    .accesskey = ط
default-font-size = الحجم
    .accesskey = ح

advanced-fonts =
    .label = متقدم…
    .accesskey = د

colors-settings =
    .label = الألوان…
    .accesskey = ل

# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = التقريب

preferences-default-zoom = التقريب المبدئي
    .accesskey = ق

preferences-default-zoom-value =
    .label = { $percentage }٪

preferences-zoom-text-only =
    .label = قرّب النص فقط
    .accesskey = ن

language-header = اللّغات

choose-language-description = اختر لغتك المفضلة لعرض الصفحات

choose-button =
    .label = اختر…
    .accesskey = خ

choose-browser-language-description = اختر اللغات التي ستُستخدم لعرض القوائم والرسائل والتنبيهات من { -brand-short-name }.
manage-browser-languages-button =
    .label = اضبط البديلة
    .accesskey = د
confirm-browser-language-change-description = أعِد تشغيل { -brand-short-name } لتطبيق التغييرات
confirm-browser-language-change-button = طبِّق وأعِد التشغيل

translate-web-pages =
    .label = ترجم محتوى الوب
    .accesskey = ت

# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = ترجمات <img data-l10n-name="logo"/>

translate-exceptions =
    .label = الاستثناءات…
    .accesskey = ث

# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = استعمل إعدادات نظام التشغيل لتنسيق التواريخ والأوقات والأرقام والمقاييس في ”{ $localeName }“.

check-user-spelling =
    .label = دقق الإملاء أثناء الكتابة
    .accesskey = ك

## General Section - Files and Applications

files-and-applications-title = الملفات و التطبيقات

download-header = التّنزيلات

download-save-to =
    .label = احفظ الملفّات في
    .accesskey = ظ

download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] اختر…
           *[other] تصفّح…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] ت
           *[other] ص
        }

download-always-ask-where =
    .label = اسألني دائمًا عن مكان حفظ الملفّات
    .accesskey = ن

applications-header = التطبيقات

applications-description = اختر كيف يتعامل { -brand-short-name } مع الملفات التي تنزلها من الوب أو التطبيقات التي تستخدمها أثناء التصفح.

applications-filter =
    .placeholder = ابحث عن أنواع الملفات أو التطبيقات

applications-type-column =
    .label = نوع المحتوى
    .accesskey = ن

applications-action-column =
    .label = الإجراء
    .accesskey = ج

# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = ملف { $extension }
applications-action-save =
    .label = احفظ الملف

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = استخدم { $app-name }

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = استخدم { $app-name } (المبدئي)

applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] استعمل التطبيق المبدئي لنظام ماك‎أوإس
            [windows] استعمل التطبيق المبدئي لنظام وِندوز
           *[other] استعمل التطبيق المبدئي للنظام
        }

applications-use-other =
    .label = استخدم تطبيقًا آخر…
applications-select-helper = اختر التّطبيق المساعد

applications-manage-app =
    .label = تفاصيل التطبيق…
applications-always-ask =
    .label = اسأل دائمًا

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
    .label = استخدم { $plugin-name } (في { -brand-short-name })
applications-open-inapp =
    .label = افتح في { -brand-short-name }

## The strings in this group are used to populate
## selected label element based on the string from
## the selected menu item.

applications-use-plugin-in-label =
    .value = { applications-use-plugin-in.label }

applications-action-save-label =
    .value = { applications-action-save.label }

applications-use-app-label =
    .value = { applications-use-app.label }

applications-open-inapp-label =
    .value = { applications-open-inapp.label }

applications-always-ask-label =
    .value = { applications-always-ask.label }

applications-use-app-default-label =
    .value = { applications-use-app-default.label }

applications-use-other-label =
    .value = { applications-use-other.label }

applications-use-os-default-label =
    .value = { applications-use-os-default.label }

##

drm-content-header = محتوى إدارة الحقوق الرقمية (DRM)

play-drm-content =
    .label = شغّل المحتوى الخاضع لإدارة الحقوق الرقمية
    .accesskey = ش

play-drm-content-learn-more = اطّلع على المزيد

update-application-title = تحديثات { -brand-short-name }

update-application-description = أبقِ { -brand-short-name } محدّثا للحصول على أحسن أداء و ثبات و أمان.

update-application-version = الإصدارة { $version } <a data-l10n-name="learn-more">ما الجديد</a>

update-history =
    .label = أظهر تأريخ التحديث…
    .accesskey = ظ

update-application-allow-description = اسمح لِ‍ { -brand-short-name } أن

update-application-auto =
    .label = ينزّل التحديثات تلقائيا (مستحسن)
    .accesskey = ن

update-application-check-choose =
    .label = يلتمس التحديثات، و لكن يترك لك خيار تنصيبها من عدمه
    .accesskey = ت

update-application-manual =
    .label = لا يلتمس التحديثات أبدًا (غير مستحسن)
    .accesskey = د

update-application-background-enabled =
    .label = حين لا يعمل { -brand-short-name }
    .accesskey = ح

update-application-warning-cross-user-setting = سيُطبّق هذا الإعداد على كل حسابات وِندوز وملفات { -brand-short-name } الشخصية التي تستخدم هذه النسخة من { -brand-short-name }.

update-application-use-service =
    .label = استخدم خدمة تعمل في الخلفية لتنصيب التحديثات
    .accesskey = خ

update-setting-write-failure-title2 = حدث عُطل أثناء تحديث الإعدادات

# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message2 =
    واجه { -brand-short-name } عُطلًا ولم يحفظ هذا التغيير. كي تغيّر إعداد التحديث هذا سيكون عليك تقديم تصريحك للكتابة في الملف أدناه. يمكنك أنت أو يمكن لمدير النظام أن يحلّ هذا العُطل بمنح مجموعة ”المستخدمين/Users“ التصريح الكامل للتحكّم بهذا الملف.
    
    تعذّرت الكتابة في الملف: { $path }

update-in-progress-title = يجري الآن التحديث

update-in-progress-message = أتريد من { -brand-short-name } مواصلة العمل على هذا التحديث؟

update-in-progress-ok-button = أ&همِل
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = وا&صِل

## General Section - Performance

performance-title = الأداء

performance-use-recommended-settings-checkbox =
    .label = استعمل إعدادات الأداء المستحسنة
    .accesskey = س

performance-use-recommended-settings-desc = طُوِّعت هذه الإعدادات لتناسب عتاد حاسوبك و نظام تشغيله.

performance-settings-learn-more = اطّلع على المزيد

performance-allow-hw-accel =
    .label = استخدم تسريع العتاد إن كان متاحًا
    .accesskey = ع

performance-limit-content-process-option = حد سيرورة المحتوى
    .accesskey = ح

performance-limit-content-process-enabled-desc = يمكن أن تساهم زيادة سيرورات المحتوى في تحسين الأداء عند استعمال عدة ألسنة، و لكن ذلك يستهلك ذاكرة أكثر.
performance-limit-content-process-blocked-desc = لا يمكن تعديل عدد سيرورات المحتوى إلا في { -brand-short-name } متعدد السيرورات. <a data-l10n-name="learn-more">اطلع على كيفية التحقق من تفعيل تعدد السيرورات</a>

# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = ‏{ $num } (المبدئي)

## General Section - Browsing

browsing-title = التّصفّح

browsing-use-autoscroll =
    .label = استخدم اللّف الآلي
    .accesskey = ف

browsing-use-smooth-scrolling =
    .label = استخدم اللّف السلس
    .accesskey = خ

browsing-use-onscreen-keyboard =
    .label = اعرض لوحة مفاتيح باللمس عند الضرورة
    .accesskey = م

browsing-use-cursor-navigation =
    .label = استعمل دائمًا مفاتيح الأسهم للتنقل داخل الصفحات
    .accesskey = س

browsing-search-on-start-typing =
    .label = ابحث عن النص مع بداية الكتابة
    .accesskey = ح

browsing-picture-in-picture-toggle-enabled =
    .label = فعّل عناصر التحكّم بالڤديوهات المعترِضة
    .accesskey = ك

browsing-picture-in-picture-learn-more = اطّلع على المزيد

browsing-media-control =
    .label = تحكّم بالوسائط عبر لوحة المفاتيح أو سماعة الرأس أو الواجهة الافتراضية
    .accesskey = ك

browsing-media-control-learn-more = اطّلع على المزيد

browsing-cfr-recommendations =
    .label = امتدادات موصى بها وأنت تتصفّح
    .accesskey = ص
browsing-cfr-features =
    .label = مزايا مستحسنة وأنت تتصفّح أرجاء الوِب
    .accesskey = س

browsing-cfr-recommendations-learn-more = اطّلع على المزيد

## General Section - Proxy

network-settings-title = إعدادات الشبكة

network-proxy-connection-description = اضبط طريقة اتصال { -brand-short-name } بالإنترنت.

network-proxy-connection-learn-more = اطّلع على المزيد

network-proxy-connection-settings =
    .label = الإعدادات…
    .accesskey = ع

## Home Section

home-new-windows-tabs-header = النوافذ و الألسنة الجديدة

home-new-windows-tabs-description2 = اختر ما تراه عندما تفتح صفحة البداية و النوافذ و الألسنة الجديدة.

## Home Section - Home Page Customization

home-homepage-mode-label = صفحة البداية و النوافذ الجديدة

home-newtabs-mode-label = الألسنة الجديدة

home-restore-defaults =
    .label = استعد المبدئيات
    .accesskey = س

# "Waterfox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = صفحة بداية Waterfox (المبدئية)

home-mode-choice-custom =
    .label = عناوين مخصصة…

home-mode-choice-blank =
    .label = صفحة فارغة

home-homepage-custom-url =
    .placeholder = ألصِق عنوانا…

# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] استخدم الصفحة الحالية
           *[other] استخدم الصفحات الحالية
        }
    .accesskey = ح

choose-bookmark =
    .label = استخدم علامة…
    .accesskey = ع

## Home Section - Waterfox Home Content Customization

home-prefs-content-header = محتوى Waterfox الرئيسي
home-prefs-content-description = اختر المحتوى الذي تريد عرضه في شاشة بداية Waterfox.

home-prefs-search-header =
    .label = ابحث في الوِب
home-prefs-topsites-header =
    .label = المواقع الأكثر زيارة
home-prefs-topsites-description = أكثر المواقع المزارة

home-prefs-topsites-by-option-sponsored =
    .label = أهم المواقع المموّلة
home-prefs-shortcuts-header =
    .label = الاختصارات
home-prefs-shortcuts-description = المواقع التي حفظتها أو زُرتها
home-prefs-shortcuts-by-option-sponsored =
    .label = الاختصارات المموّلة

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = ينصح به { $provider }
home-prefs-recommended-by-description-update = محتوى مميّز من أرجاء الوِب جمعه لك { $provider }
home-prefs-recommended-by-description-new = محتوى مميّز جمعه لك { $provider }، وهو جزء من عائلة { -brand-product-name }

##

home-prefs-recommended-by-learn-more = آلية العمل
home-prefs-recommended-by-option-sponsored-stories =
    .label = الأخبار الممولة

home-prefs-highlights-header =
    .label = أهم الأحداث
home-prefs-highlights-description = مجموعة المواقع التي حفظتها أو زرتها
home-prefs-highlights-option-visited-pages =
    .label = الصفحات المزارة
home-prefs-highlights-options-bookmarks =
    .label = العلامات
home-prefs-highlights-option-most-recent-download =
    .label = آخر ما نُزّل
home-prefs-highlights-option-saved-to-pocket =
    .label = الصفحات المحفوظة في { -pocket-brand-name }

home-prefs-recent-activity-header =
    .label = أحدث الأنشطة
home-prefs-recent-activity-description = مختارات من المواقع والمحتويات الحديثة

# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = المقتطفات
home-prefs-snippets-description = التحديثات من { -vendor-short-name } و{ -brand-product-name }

home-prefs-snippets-description-new = فوائد وأخبار من { -vendor-short-name } و{ -brand-product-name }

home-prefs-sections-rows-option =
    .label =
        { $num ->
            [zero] لا صفوف
            [one] صف واحد
            [two] صفان
            [few] { $num } صفوف
            [many] { $num } صفا
           *[other] { $num } صف
        }

## Search Section

search-bar-header = شريط البحث
search-bar-hidden =
    .label = استخدم شريط العنوان للبحث و التنقل
search-bar-shown =
    .label = أضف شريط البحث إلى شريط الأدوات

search-engine-default-header = محرك البحث المبدئي
search-engine-default-desc-2 = هذا هو محرّك البحث المبدئي في شريطي العنوان والبحث. يمكنك تغييره متى شئت.
search-engine-default-private-desc-2 = اختر محرّك بحث مبدئي آخر ليُستعمل في النوافذ الخاصة فقط
search-separate-default-engine =
    .label = استعمل محرك البحث هذا في النوافذ الخاصة
    .accesskey = س

search-suggestions-header = اقتراحات البحث
search-suggestions-desc = اختر طريقة عرض اقتراحات محركات البحث.

search-suggestions-option =
    .label = اعرض اقتراحات البحث
    .accesskey = ع

search-show-suggestions-url-bar-option =
    .label = أظهر اقتراحات البحث في نتائج شريط العناوين
    .accesskey = ت

# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = فضّل اقتراحات البحث على تأريخ التصفح في نتائج شريط العنوان

search-show-suggestions-private-windows =
    .label = اعرض اقتراحات البحث في النوافذ الخاصة

suggestions-addressbar-settings-generic2 = غيّر إعدادات اقتراحات شريط العنوان

search-suggestions-cant-show = لن تظهر اقتراحات البحث في نتائج شريط الموقع لأنّك أعددت { -brand-short-name } على ألّا يتذكر التأريخ.

search-one-click-header2 = اختصارات البحث

search-one-click-desc = اختر محركات البحث البديلة التي تظهر تحت شريطي العناوين و البحث عندما تكتب كلمة بحث.

search-choose-engine-column =
    .label = محرك البحث
search-choose-keyword-column =
    .label = كلمة مفتاحية

search-restore-default =
    .label = استعد محركات البحث المبدئية
    .accesskey = د

search-remove-engine =
    .label = احذف
    .accesskey = ح

search-add-engine =
    .label = أضِف
    .accesskey = ض

search-find-more-link = اعثر على المزيد من محركات البحث

# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = كرر الكلمة المفتاحية
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = لقد اخترت كلمة مفتاحية يستخدمها ”{ $name }“ حاليا. من فضلك اختر واحدة أخرى.
search-keyword-warning-bookmark = لقد اخترت كلمة مفتاحية تستخدمها علامة حاليا. من فضلك اختر واحدة أخرى.

## Containers Section

containers-back-button2 =
    .aria-label = عُد إلى الإعدادات
containers-header = الألسنة الحاوية
containers-add-button =
    .label = أضف حاوية جديدة
    .accesskey = ح

containers-new-tab-check =
    .label = اختر حاويًا لكلّ لسان جديد
    .accesskey = خ

containers-settings-button =
    .label = الإعدادات
containers-remove-button =
    .label = أزِل

## Waterfox Account - Signed out. Note that "Sync" and "Waterfox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = خُذ الوِب معك

sync-signedout-description2 = زامن علاماتك، و تأريخك، و ألسنتك، و كلمات سرك، و إضافاتك و الإعدادات بين كل أجهزتك.

sync-signedout-account-signin3 =
    .label = لِج كي تبدأ المزامنة…
    .accesskey = ل

# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = نزّل Waterfox لنظامي <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">أندرويد</a> أو <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">آي أو إس</a> للمزامنة مع هاتفك المحمول.

## Waterfox Account - Signed in

sync-profile-picture =
    .tooltiptext = غيّر صورة الحساب

sync-sign-out =
    .label = اخرج…
    .accesskey = خ

sync-manage-account = أدِر الحساب
    .accesskey = س

sync-signedin-unverified = { $email } ليس مؤكّدًا.
sync-signedin-login-failure = من فضلك لج لإعادة التوصيل { $email }

sync-resend-verification =
    .label = أعِد إرسال التأكيد
    .accesskey = س

sync-remove-account =
    .label = أزِل الحساب
    .accesskey = ز

sync-sign-in =
    .label = لِج
    .accesskey = ل

## Sync section - enabling or disabling sync.

prefs-syncing-on = المزامنة: مفعلة

prefs-syncing-off = المزامنة: معطلة

prefs-sync-turn-on-syncing =
    .label = فعّل المزامنة…
    .accesskey = ف

prefs-sync-offer-setup-label2 = زامن علاماتك، و تأريخك، و ألسنتك، و كلمات سرك، و إضافاتك و الإعدادات بين كل أجهزتك.

prefs-sync-now =
    .labelnotsyncing = زامِن الآن
    .accesskeynotsyncing = م
    .labelsyncing = يُزامن…

## The list of things currently syncing.

sync-currently-syncing-heading = تُزامن الآن هذه المعلومات:

sync-currently-syncing-bookmarks = العلامات
sync-currently-syncing-history = التأريخ
sync-currently-syncing-tabs = الألسنة المفتوحة
sync-currently-syncing-logins-passwords = جلسات الولوج وكلمات السر
sync-currently-syncing-addresses = العناوين
sync-currently-syncing-creditcards = بطاقات الائتمان
sync-currently-syncing-addons = الإضافات

sync-currently-syncing-settings = الإعدادات

sync-change-options =
    .label = غيّرها…
    .accesskey = غ

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = اختر ما تريد مزامنته
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = احفظ التغييرات
    .buttonaccesskeyaccept = ح
    .buttonlabelextra2 = اقطع الاتصال…
    .buttonaccesskeyextra2 = ق

sync-engine-bookmarks =
    .label = علاماتي
    .accesskey = م

sync-engine-history =
    .label = تأريخي
    .accesskey = خ

sync-engine-tabs =
    .label = الألسنة المفتوحة
    .tooltiptext = قائمة بالألسنة المفتوحة على كل الأجهزة
    .accesskey = س

sync-engine-logins-passwords =
    .label = جلسات الولوج وكلمات السر
    .tooltiptext = أسماء المستخدمين وكلمات السر التي حفظتها
    .accesskey = س

sync-engine-addresses =
    .label = العناوين
    .tooltiptext = العناوين البريدية التي حفظتها (لسطح المكتب فقط)
    .accesskey = ع

sync-engine-creditcards =
    .label = بطاقات الائتمان
    .tooltiptext = الأسماء والأرقام وتواريخ الانتهاء (لسطح المكتب فقط)
    .accesskey = ق

sync-engine-addons =
    .label = الإضافات
    .tooltiptext = امتدادات و سمات لنسخة سطح المكتب من فَيَرفُكس
    .accesskey = ت

sync-engine-settings =
    .label = الإعدادات
    .tooltiptext = الإعدادات العامة وإعدادات الخصوصية والأمن التي غيّرتها
    .accesskey = ع

## The device name controls.

sync-device-name-header = اسم الجهاز

sync-device-name-change =
    .label = غيّر اسم الجهاز…
    .accesskey = ه

sync-device-name-cancel =
    .label = ألغِ
    .accesskey = ل

sync-device-name-save =
    .label = احفظ
    .accesskey = ح

sync-connect-another-device = صِلْ جهازا آخر

## Privacy Section

privacy-header = خصوصية المتصفح

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = جلسات الولوج وكلمات السر
    .searchkeywords = { -lockwise-brand-short-name }

# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = اطلب مني حفظ كلمات سر و بيانات ولوج مواقع الوِب
    .accesskey = ط
forms-exceptions =
    .label = الاستثناءات…
    .accesskey = س
forms-generate-passwords =
    .label = ولّد كلمات سر قوية واقترحها عليّ
    .accesskey = ك
forms-breach-alerts =
    .label = اعرض تنبيهات بكلمات السر المتسرّبة من المواقع
    .accesskey = ت
forms-breach-alerts-learn-more-link = اطّلع على المزيد

# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = املأ جلسات الولوج وكلمات السر تلقائيا
    .accesskey = م
forms-saved-logins =
    .label = جلسات الولوج المحفوظة…
    .accesskey = ح
forms-primary-pw-use =
    .label = استعمل كلمة سر رئيسيّة
    .accesskey = س
forms-primary-pw-learn-more-link = اطّلع على المزيد
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = غيّر كلمة السر الرئيسيّة…
    .accesskey = ر

forms-primary-pw-change =
    .label = غيّر كلمة السر الرئيسيّة…
    .accesskey = غ
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = { "" }

forms-primary-pw-fips-title = أنت حاليًّا في وضع FIPS. يتطلّب FIPS كلمة سر رئيسية غير فارغة.
forms-master-pw-fips-desc = فشل تغيير كلمة السر

## OS Authentication dialog

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = أدخِل معلومات ولوج وِندوز لتصنع كلمة سر رئيسية. يساعد هذا الأمر على حماية أمن حساباتك.

# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Waterfox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = أنشِئ كلمة سر رئيسية
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = التأريخ

# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Waterfox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Waterfox", moving the verb into each option.
#     This will result in "Waterfox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Waterfox history settings:".
history-remember-label = اجعل { -brand-short-name }
    .accesskey = ع

history-remember-option-all =
    .label = يتذكر التأريخ
history-remember-option-never =
    .label = لا يتذكر التأريخ أبدًا
history-remember-option-custom =
    .label = يستخدم إعدادات مخصصة للتأريخ

history-remember-description = سيتذكر { -brand-short-name } تأريخ التصفح، و التنزيلات، و الاستمارات، و البحث.
history-dontremember-description = سيستخدم { -brand-short-name } نفس إعدادات التصفح الخاص، بحيث لن يحتفظ بأيّ تأريخ لتصفحك للوب.

history-private-browsing-permanent =
    .label = استخدم نمط التصفح الخاص دائمًا
    .accesskey = د

history-remember-browser-option =
    .label = تذكر تأريخ التصفح و التنزيل
    .accesskey = ت

history-remember-search-option =
    .label = تذكّر تأريخ النماذج والبحث
    .accesskey = ث

history-clear-on-close-option =
    .label = امسح التأريخ عند إغلاق { -brand-short-name }
    .accesskey = غ

history-clear-on-close-settings =
    .label = إعدادات…
    .accesskey = د

history-clear-button =
    .label = امسح التأريخ…
    .accesskey = ت

## Privacy Section - Site Data

sitedata-header = الكعكات و بيانات المواقع

sitedata-total-size-calculating = يحسب حجم بيانات الموقع و الخبيئة…

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = تستخدم الكعكات، و بيانات الموقع، و الخبيئة المحفوظة حاليًا { $value }‏ { $unit } من مساحة القرص.

sitedata-learn-more = اطّلع على المزيد

sitedata-delete-on-close =
    .label = احذف الكعكات وبيانات المواقع عندما ينغلق { -brand-short-name }
    .accesskey = ذ

sitedata-delete-on-close-private-browsing = في وضع التصفح الخاص الدائم، تُمسح الكعكات وبيانات المواقع متى ما أُغلق { -brand-short-name }.

sitedata-allow-cookies-option =
    .label = اقبل الكعكات و بيانات المواقع
    .accesskey = ق

sitedata-disallow-cookies-option =
    .label = امنع الكعكات و بيانات المواقع
    .accesskey = م

# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = النوع المحجوب
    .accesskey = ن

sitedata-option-block-cross-site-trackers =
    .label = المتعقّبات بين المواقع
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = المتعقّبات الاجتماعية ومتعقّبات بين المواقع
sitedata-option-block-cross-site-tracking-cookies-including-social-media =
    .label = المتعقّبات التي تعبر المواقع، تشمل متعقّبات المواقع الاجتماعية
sitedata-option-block-cross-site-cookies-including-social-media =
    .label = الكعكات التي تعبر المواقع، تشمل متعقّبات المواقع الاجتماعية
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = المتعقّبات الاجتماعية وتلك التي تعبر المواقع، واعزل بقية الكعكات
sitedata-option-block-unvisited =
    .label = الكعكات من المواقع غير المُزارة
sitedata-option-block-all-third-party =
    .label = كل كعكات الأطراف الثالثة (يمكن أن تعطب المواقع هكذا)
sitedata-option-block-all =
    .label = كل الكعكات (يمكن أن تعطب المواقع هكذا)

sitedata-clear =
    .label = امسح البيانات…
    .accesskey = س

sitedata-settings =
    .label = أدِر البيانات…
    .accesskey = د

sitedata-cookies-exceptions =
    .label = أدِر الاستثناءات…
    .accesskey = ت

## Privacy Section - Address Bar

addressbar-header = شريط العناوين

addressbar-suggest = عند استخدام شريط العناوين، اقترح

addressbar-locbar-history-option =
    .label = تأريخ التصفح
    .accesskey = ص
addressbar-locbar-bookmarks-option =
    .label = العلامات
    .accesskey = ع
addressbar-locbar-openpage-option =
    .label = الألسنة المفتوحة
    .accesskey = ف
# Shortcuts refers to the shortcut tiles on the new tab page, previously known as top sites. Translation should be consistent.
addressbar-locbar-shortcuts-option =
    .label = اختصارات
    .accesskey = خ
addressbar-locbar-topsites-option =
    .label = المواقع الأكثر زيارة
    .accesskey = ك

addressbar-locbar-engines-option =
    .label = محركات البحث
    .accesskey = ح

addressbar-suggestions-settings = غيّر تفضيلات اقتراحات محرّك البحث

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = الحماية الموسّعة من التعقب

content-blocking-section-top-level-description = تحاول المتعقّبات معرفة ما تفعل على الشبكة دومًا وجمع المعلومات التي تخصّ عاداتك في التصفّح كما واهتماماتك. يحجب { -brand-short-name } أكثر هذه المتعقّبات وغيرها من سكربتات ضارة.

content-blocking-learn-more = اطّلع على المزيد

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = قياسي
    .accesskey = ق
enhanced-tracking-protection-setting-strict =
    .label = صارم
    .accesskey = ص
enhanced-tracking-protection-setting-custom =
    .label = مخصّص
    .accesskey = خ

##

content-blocking-etp-standard-desc = يوازن بين الحماية والأداء. ستتحمّل الصفحات كالعادة.
content-blocking-etp-strict-desc = حماية أقوى وأعتى، لكنها قد تعطب محتويات بعض المواقع أو المواقع نفسها.
content-blocking-etp-custom-desc = اختر المتعقّبات والسكربتات التي تريد حجبها.

content-blocking-private-windows = المحتوى الذي يتعقّبك في النوافذ الخاصة
content-blocking-cross-site-tracking-cookies = كعكات تتعقّبك بين المواقع
content-blocking-cross-site-tracking-cookies-plus-isolate = المتعقّبات التي تعبر المواقع، واعزل بقية الكعكات
content-blocking-social-media-trackers = متعقبات مواقع التواصل الاجتماعي
content-blocking-all-cookies = كل الكعكات
content-blocking-unvisited-cookies = الكعكات من المواقع غير المُزارة
content-blocking-all-windows-tracking-content = المحتوى الذي يتعقّبك في كل النوافذ
content-blocking-all-third-party-cookies = كل الكعكات من الأطراف الثالثة
content-blocking-cryptominers = المُعدّنات المعمّاة
content-blocking-fingerprinters = مسجّلات البصمات

content-blocking-warning-title = انتبه!
content-blocking-and-isolating-etp-warning-description = يمكن أن يضرّ حجب المتعقّبات وعزل الكعكات بمزايا بعض المواقع. أعِد تحميل الصفحات التي فيها متعقّبات لتحميل كلّ محتواها.
content-blocking-and-isolating-etp-warning-description-2 = قد يتسبّب هذا الإعداد بألّا تعرض بعض المواقع أي محتوى أو ألا تعمل كما ينبغي. إن رأيت الموقع معطوبًا، فيمكنك تعطيل الحماية من التعقّب لهذا الموقع لتحميل محتواه.
content-blocking-warning-learn-how = اطّلع على المزيد

content-blocking-reload-description = عليك إعادة تحميل الألسنة لتأخذ هذه التغييرات مفعولها.
content-blocking-reload-tabs-button =
    .label = أعِد تحميل كل الألسنة
    .accesskey = ع

content-blocking-tracking-content-label =
    .label = المحتوى الذي يتعقّبك
    .accesskey = ح
content-blocking-tracking-protection-option-all-windows =
    .label = في كل النوافذ
    .accesskey = ك
content-blocking-option-private =
    .label = في النوافذ الخاصة فقط
    .accesskey = خ
content-blocking-tracking-protection-change-block-list = غيّر قائمة الحجب

content-blocking-cookies-label =
    .label = الكعكات
    .accesskey = ك

content-blocking-expand-section =
    .tooltiptext = معلومات أكثر

# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = المُعدّنات المعمّاة
    .accesskey = ن

# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = مسجّلات البصمات
    .accesskey = ص

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = أدِر الاستثناءات…
    .accesskey = ث

## Privacy Section - Permissions

permissions-header = الصلاحيات

permissions-location = المكان
permissions-location-settings =
    .label = الإعدادات…
    .accesskey = ع

permissions-xr = الواقع الافتراضي
permissions-xr-settings =
    .label = الإعدادات…
    .accesskey = ع

permissions-camera = الكمرة
permissions-camera-settings =
    .label = الإعدادات…
    .accesskey = ع

permissions-microphone = الميكروفون
permissions-microphone-settings =
    .label = الإعدادات…
    .accesskey = ع

permissions-notification = التنبيهات
permissions-notification-settings =
    .label = الإعدادات…
    .accesskey = ت
permissions-notification-link = اطّلع على المزيد

permissions-notification-pause =
    .label = ألبِث التنبيهات حتى يُعاد تشغيل { -brand-short-name }
    .accesskey = ث

permissions-autoplay = التشغيل التلقائي

permissions-autoplay-settings =
    .label = الإعدادات…
    .accesskey = ع

permissions-block-popups =
    .label = احجب النوافذ المنبثقة
    .accesskey = ذ

permissions-block-popups-exceptions =
    .label = الاستثناءات…
    .accesskey = ت

permissions-addon-install-warning =
    .label = حذّرني عندما يحاول موقع وِب تنصيب إضافات
    .accesskey = ح

permissions-addon-exceptions =
    .label = الاستثناءات…
    .accesskey = ث

## Privacy Section - Data Collection

collection-header = جمع { -brand-short-name } للبيانات و استخدامها

collection-description = نبذل جهدنا لإعطائك الخيار و جمع ما نحتاجه فقط لتحسين { -brand-short-name }. نطلب الإذن دائمًا قبل استقبال أي معلومات شخصية.
collection-privacy-notice = تنويه الخصوصية

collection-health-report-telemetry-disabled = لم تعد تسمح بأن يلتقط { -vendor-short-name } البيانات التقنية والتفاعلية. ستُحذف البيانات القديمة كلها خلال 30 يومًا.
collection-health-report-telemetry-disabled-link = اطّلع على المزيد

collection-health-report =
    .label = اسمح أن يُرسل { -brand-short-name } بيانات تقنية و بيانات التفاعل إلى { -vendor-short-name }
    .accesskey = ح
collection-health-report-link = اطّلع على المزيد

collection-studies =
    .label = اسمح أن ينصّب { -brand-short-name } ويشغل الدراسات
collection-studies-link = اعرض دراسات { -brand-short-name }

addon-recommendations =
    .label = اسمح بأن يقترح { -brand-short-name } الامتدادات المخصّصة لك
addon-recommendations-link = اطّلع على المزيد

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = الإبلاغ عن البيانات معطّل في إعدادات البناء

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = الأمان

security-browsing-protection = الحماية من المحتوى المخادع و البرمجيات الخبيثة

security-enable-safe-browsing =
    .label = احجب المحتوى الخطير و المخادع
    .accesskey = ح
security-enable-safe-browsing-link = اطّلع على المزيد

security-block-downloads =
    .label = احجب التنزيلات الخطيرة
    .accesskey = ت

security-block-uncommon-software =
    .label = حذرني من البرمجيات غير المرغوب فيها و غير الشائعة
    .accesskey = غ

## Privacy Section - Certificates

certs-header = الشّهادات

certs-enable-ocsp =
    .label = استعلم من خواديم مستجيبي OCSP عن الصلاحية الحالية للشهادات
    .accesskey = س

certs-view =
    .label = اعرض الشهادات…
    .accesskey = ش

certs-devices =
    .label = أجهزة الأمن…
    .accesskey = ج

space-alert-over-5gb-settings-button =
    .label = افتح الإعدادات
    .accesskey = ف

space-alert-over-5gb-message2 = <strong>مساحة القرص قاربت على النفاذ من { -brand-short-name }</strong>. قد لا يُعرض محتوى المواقع كما ينبغي. يمكنك مسح البيانات المحفوظة من ”الإعدادات ← الخصوصية والأمان ← الكعكات وبيانات المواقع“.

space-alert-under-5gb-message2 = <strong>مساحة القرص قاربت على النفاذ من { -brand-short-name }</strong>. قد لا يُعرض محتوى المواقع كما ينبغي. انتقل إلى ”اطّلع على المزيد“ لتحسين استخدام القرص لتصفح أحسن.

## Privacy Section - HTTPS-Only

httpsonly-header = وضع HTTPS فقط

httpsonly-description = يقدّم بروتوكول HTTPS اتصالًا آمنًا ومعمًى بين { -brand-short-name } والمواقع التي تزورها. تدعم أغلب المواقع HTTPS، ولو فعّلت وضع ”HTTPS فقط“ فسيُرقّي { -brand-short-name } كل الاتصالات لتكون ببروتوكول HTTPS.

httpsonly-learn-more = اطّلع على المزيد

httpsonly-radio-enabled =
    .label = فعّل وضع HTTPS فقط في كل النوافذ

httpsonly-radio-enabled-pbm =
    .label = فعّل وضع HTTPS فقط في النوافذ الخاصة فقط

httpsonly-radio-disabled =
    .label = لا تفعّل وضع HTTPS فقط

## The following strings are used in the Download section of settings

desktop-folder-name = سطح المكتب
downloads-folder-name = التّنزيلات
choose-download-folder-title = اختر مجلّد التّنزيلات:

# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = احفظ الملفات في { $service-name }
