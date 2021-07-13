# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = اطّلع على المزيد
onboarding-button-label-get-started = فلنبدأ

## Welcome modal dialog strings


### UI strings for the simplified onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = مرحبًا بك في { -brand-short-name }
onboarding-welcome-body = وصلك الآن المتصفّح.<br/>اطّلع على بقيّة منتجات { -brand-product-name }.
onboarding-welcome-learn-more = اعرف المزيد حول فوائد ذلك.
onboarding-welcome-modal-get-body = وصلك الآن المتصفّح.<br/>بقيت أمامك روائع { -brand-product-name } كلّها.
onboarding-welcome-modal-supercharge-body = عزّز حمايات الخصوصية.
onboarding-welcome-modal-privacy-body = صار المتصفّح عندك. الآن لنزيد من حمايات الخصوصيّة.
onboarding-welcome-modal-family-learn-more = خُذ نظرة على طقم منتجات { -brand-product-name }.
onboarding-welcome-form-header = ابدأ هنا
onboarding-join-form-body = أدخِل عنوان البريد الإلكتروني لتبدأ.
onboarding-join-form-email =
    .placeholder = أدخِل البريد الإلكتروني
onboarding-join-form-email-error = مطلوب بريد إلكتروني صالح
onboarding-join-form-legal = تعني المواصلة أنّك توافق على <a data-l10n-name="terms">شروط الخدمة</a> و<a data-l10n-name="privacy">تنويه الخصوصية</a>.
onboarding-join-form-continue = واصِل
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = ألديك حساب؟
# Text for link to submit the sign in form
onboarding-join-form-signin = لِج
onboarding-start-browsing-button-label = ابدأ التصفح
onboarding-cards-dismiss =
    .title = ألغِ
    .aria-label = ألغِ

## Welcome full page string

onboarding-fullpage-welcome-subheader = لنبدأ رحلة البحث عمّا يمكنك فعله.
onboarding-fullpage-form-email =
    .placeholder = عنوان بريدك الإلكتروني…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = خذ معك { -brand-product-name } أينما ذهبت
onboarding-sync-welcome-content = تشارك العلامات، وتأريخ التصفح، وكلمات السر وباقي الإعدادات على جميع أجهزتك.
onboarding-sync-welcome-learn-more-link = اطّلع على المزيد عن حسابات Firefox
onboarding-sync-form-input =
    .placeholder = البريد الإلكتروني
onboarding-sync-form-continue-button = تابِع
onboarding-sync-form-skip-login-button = تجاوز هذه الخطوة

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = أدخِل بريدك الإلكتروني
onboarding-sync-form-sub-header = لمواصلة استخدام { -sync-brand-name }

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = أنجِز أمورك مستخدما طقما من الأدوات يحترم خصوصيتك على مختلف الأجهزة لديك.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = كل ما نفعله يحترم ميثاق ”عهدة البيانات الشخصية“: استلم أدنى قدر، أبقِها آمنة ولا أسرار مخفية.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = خُذ معك علاماتك وكلمات السر والتأريخ وغيرها الكثير أينما تستعمل { -brand-product-name }.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = استلم إشعارًا متى ما ظهرت معلوماتك الشخصية في تسريبٍ للبيانات.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = أدِر كلمات السر لديك المحمية والمحمولة.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = الحماية من التعقّب
onboarding-tracking-protection-text2 = يساعدك { -brand-short-name } بمنع المواقع من تعقّبك في الوِب، ما يصعّب الأمر على الإعلانات بمعرفة ما تفعل وأين تذهب.
onboarding-tracking-protection-button2 = كيف تعمل
onboarding-data-sync-title = خُذ إعداداتك أينما ذهبت
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = زامِن علاماتك وكلمات السر وغيرها الكثير في أيّ مكان تستخدم فيه { -brand-product-name }.
onboarding-data-sync-button2 = لِج إلى { -sync-brand-short-name }
onboarding-firefox-monitor-title = اعلم متى يحدث تسرّب بيانات
onboarding-firefox-monitor-text2 = يراقب { -monitor-brand-name } وينبّهك لو ظهر بريدك الإلكتروني في أيّ تسريبٍ جديد للبيانات.
onboarding-firefox-monitor-button = سجّل لتصلك التنبيهات
onboarding-browse-privately-title = تصفَّح بخصوصية
onboarding-browse-privately-text = يمسح التصفح الخاص تأريخ البحث والتصفح ليُبقيه سرًا على أي شخص يستخدم هذا الحاسوب.
onboarding-browse-privately-button = افتح نافذة خاصة
onboarding-firefox-send-title = أبقِ ملفاتك التي شاركتها خاصّة
onboarding-firefox-send-text2 = ارفع ملفاتك إلى { -send-brand-name } وشاركها عبر تعميتها من الطرفين كما وفي رابط ينقضي أجله تلقائيا.
onboarding-firefox-send-button = جرّب { -send-brand-name }
onboarding-mobile-phone-title = نزّل { -brand-product-name } على المحمول
onboarding-mobile-phone-text = نزّل { -brand-product-name } على آي‌أوإس وأندرويد لتُزامن بياناتك عبر مختلف الأجهزة.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = نزّل متصفّح المحمول
onboarding-send-tabs-title = أرسِل الألسنة إلى ذاتك الأخرى مباشرةً
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = شارِك الصفحات بين أجهزتك بسهولة تامة دون نسخ الروابط يدويًا أو ترك المتصفّح.
onboarding-send-tabs-button = ابدأ استعمال ميزة «إرسال الألسنة»
onboarding-pocket-anywhere-title = اقرأ واستمع إلى ما ترغب أينما كنت
onboarding-pocket-anywhere-text2 = احفظ ما تحبّ من محتوى وتصفّحه دون اتصال عبر تطبيق { -pocket-brand-name }. بهذا تقرأه وتسمعه وتطالعه متى ما أردت وحينما تشاء.
onboarding-pocket-anywhere-button = جرّب { -pocket-brand-name }
onboarding-lockwise-strong-passwords-title = أنشِئ كلمات سر قوية وخزّنها
onboarding-lockwise-strong-passwords-text = يصنع { -lockwise-brand-name } كلمات سرّ قوية مباشرةً ويحفظها كلها في مكان واحد.
onboarding-lockwise-strong-passwords-button = أدِر جلسات الولوج
onboarding-facebook-container-title = اضبط حدود فيسبوك
onboarding-facebook-container-text2 = يفصل { -facebook-container-brand-name } ملفك الشخصي عن المعلومات الأخرى، وهكذا تكون مهمة فيسبوك في إيصال الإعلانات إليك أصعب وأصعب.
onboarding-facebook-container-button = أضِف الامتداد
onboarding-import-browser-settings-title = استورِد العلامات وكلمات السر وغيرها
onboarding-import-browser-settings-text = ادخُل صلب الموضوع بأخذ مواقعك وإعداداتك على كروم معك.
onboarding-import-browser-settings-button = استورِد بيانات كروم
onboarding-personal-data-promise-title = صمّمناه ليكون خاصًا
onboarding-personal-data-promise-text = تتعامل { -brand-product-name } مع بياناتك باحترام شديد ذلك باستلام أقلّ قدر منها، وحمايتها وتوضيح كيفية استعمالها لها بأقصى شفافية ممكنة.

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = هذا رائع، لديك الآن { -brand-short-name }
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = هيا نثبّت لك <icon></icon>‏<b>{ $addon-name }.</b>
return-to-amo-extension-button = أضِف الامتداد
return-to-amo-get-started-button = ابدأ العمل مع { -brand-short-name }
onboarding-not-now-button-label = ليس الآن

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = هذا رائع، لديك الآن { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = هيا نثبّت لك <img data-l10n-name="icon"/> <b>{ $addon-name }</b>.
return-to-amo-add-extension-label = أضِف الامتداد

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = مرحبًا في <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = المتصفّح السريع والآمن والخاص وتدعمه مؤسسة غير ربحية.
onboarding-multistage-welcome-primary-button-label = ابدأ الإعداد
onboarding-multistage-welcome-secondary-button-label = لِج
onboarding-multistage-welcome-secondary-button-text = ألديك حسابًا؟
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "default" should stay inside the span.
onboarding-multistage-set-default-header = اضبط { -brand-short-name } ليكون <span data-l10n-name="zap">المبدئي</span>
onboarding-multistage-set-default-subtitle = السرعة والأمان والخصوصية في كل مرة تتصفح فيها.
onboarding-multistage-set-default-primary-button-label = اجعله المبدئي
onboarding-multistage-set-default-secondary-button-label = ليس الآن
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-pin-default-header = ابدأ أولًا بتسهيل الوصول إلى <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-pin-default-subtitle = تصفّح سريع وآمن وخاص كلّما استعملت الوِب.
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-waiting-subtitle = اختر { -brand-short-name } من ”مستعرض الويب“ حين تظهر الإعدادات
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-help-text = هذا سيُثبّت { -brand-short-name } في شريط المهام ويفتح الإعدادات
onboarding-multistage-pin-default-primary-button-label = اضبط { -brand-short-name } ليكون متصفّحي الأساسي
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = استورِد كلمات السر <br/>والعلامات و<span data-l10n-name="zap">غيرها</span>
onboarding-multistage-import-subtitle = انتقلت إلى { -brand-short-name } من متصفّح آخر؟ نقل أمورك إلى هنا أسهل مما تتخيل.
onboarding-multistage-import-primary-button-label = ابدأ الاستيراد
onboarding-multistage-import-secondary-button-label = ليس الآن
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = وجدنا المواقع أسفله في هذا الجهاز. لا يحفظ { -brand-short-name } البيانات ولا يُزامنها من متصفّحاتك الأخرى إلّا بموافقتك على استيرادها.
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = البداية: شاشة { $current } من أصل { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = اختر <span data-l10n-name="zap">مظهرًا</span>
onboarding-multistage-theme-subtitle = خصّص { -brand-short-name } باستعمال سمة.
onboarding-multistage-theme-primary-button-label2 = تمّ
onboarding-multistage-theme-secondary-button-label = ليس الآن
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = تلقائي
onboarding-multistage-theme-label-light = فاتحة
onboarding-multistage-theme-label-dark = داكنة
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Waterfox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title =
        استعمل مظهر نظام التشغيل
        لعرض الأزرار والقوائم والنوافذ.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        استعمل مظهر نظام التشغيل
        لعرض الأزرار والقوائم والنوافذ.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        استعمل مظهرًا فاتحًا لعرض
        الأزرار والقوائم والنوافذ.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        استعمل مظهرًا فاتحًا لعرض
        الأزرار والقوائم والنوافذ.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        استعمل مظهرًا داكنًا لعرض
        الأزرار والقوائم والنوافذ.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        استعمل مظهرًا داكنًا لعرض
        الأزرار والقوائم والنوافذ.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        استعمل مظهرًا ملونًا لعرض
        الأزرار والقوائم والنوافذ.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        استعمل مظهرًا ملونًا لعرض
        الأزرار والقوائم والنوافذ.

## Multistage MR1 onboarding strings (MR1 about:welcome pages)

# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Firefox, how they use
# Firefox to pursue those passions, as well as the boldness in their
# choice to use Firefox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
mr1-welcome-screen-hero-text = من هنا تبدأ الرحلة
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = عطّل الرسوم المتحركة
mr1-onboarding-welcome-header = مرحبًا بك في { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = اضبط { -brand-short-name } ليكون متصفّحي الأساسي
    .title = يتيح لك الخيار ضبط { -brand-short-name } ليكون المتصفّح المبدئي ويثبّته في شريط المهام
mr1-onboarding-set-default-only-primary-button-label = اضبط { -brand-short-name } ليكون متصفّحي المبدئي
mr1-onboarding-set-default-secondary-button-label = ليس الآن
mr1-onboarding-sign-in-button-label = لِج
mr1-onboarding-import-header = خُذ كل شي معك
mr1-onboarding-import-subtitle = استورِد كلمات السر<br/>والعلامات وغيرها المزيد.
# The primary import button label will depend on whether we can detect which browser was used to download Firefox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = استورِد من { $previous }
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = استورِدها من المتصفّح السابق
mr1-onboarding-import-secondary-button-label = ليس الآن
mr1-onboarding-theme-header = طوّعه كما ترغب
mr1-onboarding-theme-subtitle = خصّص { -brand-short-name } باستعمال سمة.
mr1-onboarding-theme-primary-button-label = احفظ السمة
mr1-onboarding-theme-secondary-button-label = ليس الآن
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = سمة النظام
mr1-onboarding-theme-label-light = فاتحة
mr1-onboarding-theme-label-dark = داكنة
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = شفق ألبي (Alpenglow)

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title =
        اتبع سمة نظام التشغيل لعرض
        الأزرار والقوائم والنوافذ.
# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        اتبع سمة نظام التشغيل لعرض
        الأزرار والقوائم والنوافذ.
# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title =
        استعمل سمة فاتحة لعرض
        الأزرار والقوائم والنوافذ.
# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description =
        استعمل سمة فاتحة لعرض
        الأزرار والقوائم والنوافذ.
# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title =
        استعمل سمة داكنة لعرض
        الأزرار والقوائم والنوافذ.
# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description =
        استعمل سمة داكنة لعرض
        الأزرار والقوائم والنوافذ.
# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title =
        استعمل سمة مفعمة بالألوان
        لعرض الأزرار والقوائم والنوافذ.
# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description =
        استعمل سمة مفعمة بالألوان
        لعرض الأزرار والقوائم والنوافذ.
