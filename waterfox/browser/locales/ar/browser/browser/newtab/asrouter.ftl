# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = الامتدادات المقترحة
cfr-doorhanger-feature-heading = ميّزة موصى بها

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = لماذا أرى هذا

cfr-doorhanger-extension-cancel-button = ليس الآن
    .accesskey = ل

cfr-doorhanger-extension-ok-button = أضِف الآن
    .accesskey = ض

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

## Waterfox Accounts Message

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

cfr-whatsnew-release-notes-link-text = اقرأ ملاحظات الإصدار

## Enhanced Tracking Protection Milestones

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
cfr-doorhanger-milestone-close-button = أغلِق
    .accesskey = غ

## DOH Message

cfr-doorhanger-doh-body = خصوصيّتك فوق كل شيء. بات { -brand-short-name } يوجّه كل طلبات DNS التي تُجريها (متى كان ممكنًا) إلى خدمة شريكة، ذلك لحمايتك وأنت تتصفّح.
cfr-doorhanger-doh-header = عمليات بحث DNS أكثر أمانًا وتعميةً
cfr-doorhanger-doh-primary-button-2 = حسنا
    .accesskey = ح
cfr-doorhanger-doh-secondary-button = عطّل
    .accesskey = ط

## Fission Experiment Message

## Full Video Support CFR message

cfr-doorhanger-video-support-body = قد لا تعمل الڤِديوهات في هذا الموقع كما ينبغي في إصدارة { -brand-short-name } هذه. من فضلك حدّث { -brand-short-name } الآن لتحصل على الدعم الكامل للڤِديوهات.
cfr-doorhanger-video-support-header = حدّث { -brand-short-name } لتشغيل الڤِديو
cfr-doorhanger-video-support-primary-button = حدّث الآن
    .accesskey = ح

## Spotlight modal shared strings

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the BrowserWorks VPN page and a link to dismiss the dialog.

# This header text can be explicitly wrapped.
spotlight-public-wifi-vpn-header = يبدو أنك تستخدم شبكة Wi-Fi عامة
spotlight-public-wifi-vpn-body = ننصحك باستعمال شبكة افتراضية خاصة VPN لإخفاء مكانك وتأريخ التصفح. سيساعد هذا في إبقاء تصفّحك في الأماكن العامة كالمطارات والمقاهي محميًا.
spotlight-public-wifi-vpn-primary-button = احفظ خصوصيتك دومًا عبر { -mozilla-vpn-brand-name }
    .accesskey = ح
spotlight-public-wifi-vpn-link = ليس الآن
    .accesskey = ل

## Total Cookie Protection Rollout

## Emotive Continuous Onboarding

## MR2022 Background Update Windows native toast notification strings.
##
## These strings will be displayed by the Windows operating system in
## a native toast, like:
##
## <b>multi-line title</b>
## multi-line text
## <img>
## [ primary button ] [ secondary button ]
##
## The button labels are fitted into narrow fixed-width buttons by
## Windows and therefore must be as narrow as possible.

## Waterfox View CFR

## Waterfox View Spotlight

## Colorways expiry reminder CFR

## Cookie Banner Handling CFR

## These strings are used in the Fox doodle Pin/set default spotlights

## These strings are used in the Set Waterfox as Default PDF Handler for Existing Users experiment

## FxA sync CFR

## Device Migration FxA Spotlight

