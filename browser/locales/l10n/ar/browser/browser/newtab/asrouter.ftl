# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = الامتدادات المقترحة
cfr-doorhanger-feature-heading = ميّزة موصى بها
cfr-doorhanger-pintab-heading = هيا جرّب: ثبّت اللسان

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = لماذا أرى هذا
cfr-doorhanger-extension-cancel-button = ليس الآن
    .accesskey = ل
cfr-doorhanger-extension-ok-button = أضِف الآن
    .accesskey = ض
cfr-doorhanger-pintab-ok-button = ثبّت هذا اللسان
    .accesskey = ث
cfr-doorhanger-extension-manage-settings-button = أدِر إعدادات التوصيات
    .accesskey = د
cfr-doorhanger-extension-never-show-recommendation = لا تعرض لي هذه التوصية
    .accesskey = ت
cfr-doorhanger-extension-learn-more-link = اطّلع على المزيد
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = من { $name }
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = توصية
cfr-doorhanger-extension-notification2 = توصية
    .tooltiptext = نُوصيك بامتداد
    .a11y-announcement = توصية بوجود امتداد
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = توصية
    .tooltiptext = نُوصيك بامتداد
    .a11y-announcement = توصية بوجود امتداد

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [zero] لا نجوم
            [one] نجمة واحدة
            [two] نجمتان
            [few] { $total } نجوم
            [many] { $total } نجمة
           *[other] { $total } نجمة
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [zero] لا مستخدمين
        [one] مستخدم واحد
        [two] مستخدمان
        [few] { $total } مستخدمين
        [many] { $total } مستخدما
       *[other] { $total } مستخدم
    }
cfr-doorhanger-pintab-description = انتقل إلى أكثر المواقع التي تزورها بسرعة. بهذا تبقى المواقع مفتوحة في ألسنة (حتى إن أعدت تشغيل المتصفح).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>انقر باليمين</b> على أي لسان تريد تثبيته.
cfr-doorhanger-pintab-step2 = اختر <b>ثبّت اللسان</b> من القائمة.
cfr-doorhanger-pintab-step3 = إن حصل شيء في الموقع وطرأ تحديث، سترى نقطة زرقاء في اللسان الذي ثبّته.
cfr-doorhanger-pintab-animation-pause = ألبِث
cfr-doorhanger-pintab-animation-resume = استأنف

## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = زامِن علاماتك في كل مكان.
cfr-doorhanger-bookmark-fxa-body = أحسنت باكتشاف هذا! حريّ بك أن تحفظ هذه العلامة على أجهزتك المحمولة، وإلا فما الداعي من الاكتشاف؟ ابدأ الآن وافتح { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = زامِن العلامات الآن…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = زر الإغلاق
    .title = أغلِق

## Protections panel

cfr-protections-panel-header = تصفّح ولا أحد ورائك
cfr-protections-panel-body = لتعبّر الكاف في ”بياناتك“ عنك أنت. يحميك { -brand-short-name } من عديد من المتعقّبات المعروفة والتي تريد معرفة ما تفعله في المواقع.
cfr-protections-panel-link-text = اطّلع على المزيد

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = ميزة جديدة:
cfr-whatsnew-button =
    .label = ما الجديد
    .tooltiptext = ما الجديد
cfr-whatsnew-panel-header = ما الجديد
cfr-whatsnew-release-notes-link-text = اقرأ ملاحظات الإصدار
cfr-whatsnew-fx70-title = الآن، يكافح { -brand-short-name } أكثر فأكثر لحماية خصوصيتك
cfr-whatsnew-fx70-body =
    يحسّن آخر تحديث ميزة الحماية من التعقّب ويبسّط
    عملية اختيار كلمات السر للمواقع كافة إلى حد غير مسبوق.
cfr-whatsnew-tracking-protect-title = احمِ نفسك من خطر المتعقّبات
cfr-whatsnew-tracking-protect-body =
    يحجب { -brand-short-name } عددًا من المتعقّبات الاجتماعية والمتعقّبات بين المواقع،
    متعقّبات هدفها معرفة ما تفعله في المواقع.
cfr-whatsnew-tracking-protect-link-text = اعرض تقرير الحماية
# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [zero] المتعقّبات المحجوبة
        [one] المتعقّبات المحجوبة
        [two] المتعقّبات المحجوبة
        [few] المتعقّبات المحجوبة
        [many] المتعقّبات المحجوبة
       *[other] المتعقّبات المحجوبة
    }
cfr-whatsnew-tracking-blocked-subtitle = منذ { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = اعرض التقرير
cfr-whatsnew-lockwise-backup-title = انسخ كلمات السر احتياطيًا
cfr-whatsnew-lockwise-backup-body = بات بإمكانك الآن توليد كلمات سر آمنة تدخلها أينما تريد متى ما ولجت.
cfr-whatsnew-lockwise-backup-link-text = فعّل النسخ الاحتياطي
cfr-whatsnew-lockwise-take-title = خُذ معك كلمات السر أينما ذهبت
cfr-whatsnew-lockwise-take-body =
    يتيح لك تطبيق { -lockwise-brand-short-name } للمحمول الوصول بأمان إلى
    كلمات السر التي نسختها احتياطيًا أينما كنت.
cfr-whatsnew-lockwise-take-link-text = نزّل التطبيق

## Search Bar

cfr-whatsnew-searchbar-title = مع شريط العنوان، قلّل الكتابة وخُذ نتائج أكثر
cfr-whatsnew-searchbar-body-topsites = ما عليك الآن إلا نقر شريط العنوان وسترى مربّعا فيه روابط تنقلك إلى أكثر المواقع زيارة.

## Search bar

cfr-whatsnew-searchbar-icon-alt-text = أيقونة المكبّرة

## Picture-in-Picture

cfr-whatsnew-pip-header = شاهِد الڤِديوهات بينما تتصفّح
cfr-whatsnew-pip-body = في وضع الڤديوهات المعترِضة (Picture-in-picture)، يصير الڤديو داخل نافذة تكون أعلى كلّ شيء لتُطالعه وأنت تؤدّي أشغالك في الألسنة الأخرى.
cfr-whatsnew-pip-cta = اطّلع على المزيد

## Permission Prompt

cfr-whatsnew-permission-prompt-header = قلّلنا عدد المُنبثقات المزعجة
cfr-whatsnew-permission-prompt-body = بات { -brand-shorter-name } يحجب طلبات المواقع بإرسال الرسائل المنبثقة تلقائيًا.
cfr-whatsnew-permission-prompt-cta = اطّلع على المزيد

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [zero] مسجّلات البصمات المحجوبة
        [one] مسجّلات البصمات المحجوبة
        [two] مسجّلات البصمات المحجوبة
        [few] مسجّلات البصمات المحجوبة
        [many] مسجّلات البصمات المحجوبة
       *[other] مسجّلات البصمات المحجوبة
    }
cfr-whatsnew-fingerprinter-counter-body = يحجب { -brand-shorter-name } العديد من مسجّلات البصمات التي تجمع معلومات جهازك وأفعالك لتفتح عنك ملفًا شخصيًا تستعمله للإعلانات.
# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = مسجّلات البصمات
cfr-whatsnew-fingerprinter-counter-body-alt = يمكن أن يحجب { -brand-shorter-name } العديد من مسجّلات البصمات التي تجمع معلومات جهازك وأفعالك لتفتح عنك ملفًا شخصيًا تستعمله للإعلانات.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = زامِن هذه العلامة مع هاتفك
cfr-doorhanger-sync-bookmarks-body = خُذ معك علاماتك وكلمات السر والتأريخ وغيرها الكثير في أيّ مكان تلج فيه إلى { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = فعّل { -sync-brand-short-name }
    .accesskey = ف

## Login Sync

cfr-doorhanger-sync-logins-header = بعد الآن، ”نسيت كلمة السر“ فعل ماض
cfr-doorhanger-sync-logins-body = خزّن كلمات السر وزامنها على مختلف الأجهزة لديك.
cfr-doorhanger-sync-logins-ok-button = فعّل { -sync-brand-short-name }
    .accesskey = ف

## Send Tab

cfr-doorhanger-send-tab-header = اقرأ هذا المحتوى حتى وأنت بعيد
cfr-doorhanger-send-tab-recipe-header = دوّن هذه الوصفة وحضّرها في المطبخ
cfr-doorhanger-send-tab-body = تتيح لك ميزة إرسال الألسنة مشاركة هذا الرابط مع الهاتف لديك وأي مكان تلج فيه إلى { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = جرّب ميزة إرسال الألسنة
    .accesskey = ج

## Firefox Send

cfr-doorhanger-firefox-send-header = شارِك بأمان ملف PDF هذا
cfr-doorhanger-firefox-send-body = أخفِ مستنداتك الخاصة من أعين المتربصين مستغلًا الحماية من الطرفين التي تقدّم رابطًا يختفي حين تنتهي منه.
cfr-doorhanger-firefox-send-ok-button = جرّب { -send-brand-name }
    .accesskey = ج

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = طالِع الحمايات
    .accesskey = ط
cfr-doorhanger-socialtracking-close-button = أغلِق
    .accesskey = غ
cfr-doorhanger-socialtracking-dont-show-again = لا تعرض هذه الرسائل ثانيةً
    .accesskey = ع
cfr-doorhanger-socialtracking-heading = منع { -brand-short-name } إحدى الشبكات الاجتماعية من تعقّبك إلى هنا
cfr-doorhanger-socialtracking-description = خصوصيتك فوق كل شيء. بات { -brand-short-name } يحجب أكثر متعقّبات الشبكات الاجتماعية شيوعًا فيحدّ من بياناتك التي تجمعها وأنت تتصفّح الإنترنت.
cfr-doorhanger-fingerprinters-heading = حجب { -brand-short-name } مسجّل بصمات في هذه الصفحة
cfr-doorhanger-fingerprinters-description = خصوصيتك فوق كل شيء. بات { -brand-short-name } يحجب مسجّلات البصمات التي تجمع المعلومات الفريدة التي تحدّد جهازك عن غيرك، كلّه لتتعقّبك.
cfr-doorhanger-cryptominers-heading = حجب { -brand-short-name } مُعدّنًا معمّى في هذه الصفحة
cfr-doorhanger-cryptominers-description = خصوصيتك فوق كل شيء. بات { -brand-short-name } يحجب المُعدّنات المعمّاة التي تستعمل قوّة الحساب لنظامك لتُعدّن النقود الرقمية.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [zero] لم يحجب { -brand-short-name } أيّ متعقّب منذ { $date }!
        [one] حجب { -brand-short-name } ما يزيد على <b>متعقّب واحد</b> منذ { $date }!
        [two] حجب { -brand-short-name } ما يزيد على <b>متعقّبين اثنين</b> منذ { $date }!
        [few] حجب { -brand-short-name } ما يزيد على <b>{ $blockedCount }</b> متعقّبات منذ { $date }!
        [many] حجب { -brand-short-name } ما يزيد على <b>{ $blockedCount }</b> متعقّبًا منذ { $date }!
       *[other] حجب { -brand-short-name } ما يزيد على <b>{ $blockedCount }</b> متعقّب منذ { $date }!
    }
# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
        [zero] لم يحجب { -brand-short-name } أيّ متعقّب منذ { DATETIME($date, month: "long", year: "numeric") }!
        [one] حجب { -brand-short-name } ما يزيد على <b>متعقّب واحد</b> منذ { DATETIME($date, month: "long", year: "numeric") }!
        [two] حجب { -brand-short-name } ما يزيد على <b>متعقّبين اثنين</b> منذ { DATETIME($date, month: "long", year: "numeric") }!
        [few] حجب { -brand-short-name } ما يزيد على <b>{ $blockedCount }</b> متعقّبات منذ { DATETIME($date, month: "long", year: "numeric") }!
        [many] حجب { -brand-short-name } ما يزيد على <b>{ $blockedCount }</b> متعقّبًا منذ { DATETIME($date, month: "long", year: "numeric") }!
       *[other] حجب { -brand-short-name } ما يزيد على <b>{ $blockedCount }</b> متعقّب منذ { DATETIME($date, month: "long", year: "numeric") }!
    }
cfr-doorhanger-milestone-ok-button = اعرض الكل
    .accesskey = ع

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = اصنع كلمات سر آمنة بسهولة
cfr-whatsnew-lockwise-body = من الصعب بمكان التفكير بكلمة سر آمنة وفريدة لكلّ حساب من حساباتك. في المرة القادمة حين تختار كلمة سر، انقر حقل كلمة السر لاستعمال كلمة سر آمنة ولّدها { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = أيقونة { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = استلم تنبيهات بخصوص كلمات السر الضعيفة
cfr-whatsnew-passwords-body = يعرف المخترقون أن الناس تُعيد استعمال كلمات السر نفسها. فإن استعملت نفس كلمة السر في أكثر من موقع، وتسرّبت بيانات إحداها، فسترى في { -lockwise-brand-short-name } تنبيهًا لتغيير كلمة السر في تلك المواقع التي تستعمل نفس الكلمة.
cfr-whatsnew-passwords-icon-alt = أيقونة مفتاح ”كلمة السر ضعيفة“

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = حوّل الڤديو المعترِض ليملأ الشاشة
cfr-whatsnew-pip-fullscreen-body = صار بإمكانك الآن (حين تنزع الڤديو ليصير في نافذة مستقلة) نقر النافذة مرتين لتملأ الشاشة.
cfr-whatsnew-pip-fullscreen-icon-alt = أيقونة الڤديو المعترِض

## Protections Dashboard message

cfr-doorhanger-milestone-close-button = أغلِق
    .accesskey = غ

## What’s New Panel Content for Firefox 76
## Protections Dashboard message

cfr-whatsnew-protections-header = كل أمور الحماية، في لمحة سريعة
cfr-whatsnew-protections-body = تشمل لوحة معلومات الحماية تقارير تلخّص تسرّب البيانات وإدارة كلمات السر. يمكنك الآن مراقبة التسريبات التي استجبت إليها، وإن ظهرت إحدى كلمات السر المحفوظة التي تستعمل في إحدى تسريبات البيانات.
cfr-whatsnew-protections-cta-link = اعرض لوحة معلومات الحماية
cfr-whatsnew-protections-icon-alt = أيقونة الدرع

## Better PDF message

cfr-whatsnew-better-pdf-header = تجربة محسّنة لملفات PDF
cfr-whatsnew-better-pdf-body = تفتح مستندات PDF الآن مباشرة في { -brand-short-name } مما يسهل أسلوب عملك.

## DOH Message

cfr-doorhanger-doh-body = خصوصيّتك فوق كل شيء. بات { -brand-short-name } يوجّه كل طلبات DNS التي تُجريها (متى كان ممكنًا) إلى خدمة شريكة، ذلك لحمايتك وأنت تتصفّح.
cfr-doorhanger-doh-header = عمليات بحث DNS أكثر أمانًا وتعميةً
cfr-doorhanger-doh-primary-button = حسنًا، فهمت
    .accesskey = ح
cfr-doorhanger-doh-primary-button-2 = حسنا
    .accesskey = ح
cfr-doorhanger-doh-secondary-button = عطّل
    .accesskey = ط

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = خصوصيتك فوق كل شيء. بات { -brand-short-name } يعزل (أو بالإنجليزية، sandbox) المواقع عن بعضها بعض، ما يصعّب على المخترقين سرقة كلمات السر أو أرقام البطاقات الائتمانية أو غيرها من معلومات حساسة.
cfr-doorhanger-fission-header = عزل المواقع
cfr-doorhanger-fission-primary-button = حسنًا، فهمت
    .accesskey = ح
cfr-doorhanger-fission-secondary-button = اطّلع على المزيد
    .accesskey = ط

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = الحماية التلقائية ضد أساليب التعقّب المتخفّية
cfr-whatsnew-clear-cookies-body = تُوجّهك بعض المتعقّبات إلى مواقع أخرى تضبط الكعكات دون أن تعلم. يمسح { -brand-short-name } الآن تلقائيًا تلك الكعكات بذلك يستحيل تعقّبك.
cfr-whatsnew-clear-cookies-image-alt = رسمٌ يوضّح ”حجب الكعكات“

## What's new: Media controls message

cfr-whatsnew-media-keys-header = تحكّمات أخرى بالوسائط
cfr-whatsnew-media-keys-body = سهّلنا التحكم بالوسائط من الألسنة والبرامج الأخرى، وحتى حين يكون الحاسوب مُقفلًا بميزة تشغيل الصوت والڤديو أو إلباثه مباشرة من لوحة المفاتيح أو سماعة الرأس. كما يمكنك التنقّل بين المقطوعات باستعمال مفاتيح التالي والسابق.
cfr-whatsnew-media-keys-button = اطّلع على المزيد

## What's new: Search shortcuts

cfr-whatsnew-search-shortcuts-header = اختصارات البحث في شريط العنوان
cfr-whatsnew-search-shortcuts-body = سيظهر الآن (متى كتبت اسم محرّك بحث أو موقع معيّن في شريط العنوان) اختصارًا أزرقًا في مربع اقتراحات البحث أسفل الشريط. اختر الاختصار لتُواصل البحث مباشرةً من شريط العنوان دون مغادرته.

## What's new: Cookies protection

cfr-whatsnew-supercookies-header = الحماية من الكعكات الخارقة الضارّة
cfr-whatsnew-supercookies-body = تستطيع المواقع إضافة ”كعكة خارقة/Supercookie“ إلى متصفّحك دون علمك كي تتعقّبك عبر الوِب حتّى إن مسحت كلّ الكعكات. يقدّم { -brand-short-name } الآن حماية أعتى ضدّ الكعكات الخارقة لألّا تُستعمل لتعقّب أنشطتك عبر الإنترنت وأنت تتنقّل بين المواقع.

## What's new: Better bookmarking

cfr-whatsnew-bookmarking-header = علامات أفضل

## What's new: Cross-site cookie tracking

