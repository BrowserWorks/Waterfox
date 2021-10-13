# This Source Code Form is subject to the terms of the Waterfox Public
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

## These messages are steps on how to use the feature and are shown together.


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

## Search Bar

## Search bar

## Picture-in-Picture

## Permission Prompt

## Fingerprinter Counter

## Bookmark Sync

## Login Sync

## Send Tab

## Waterfox Send

## Social Tracking Protection

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

## What’s New Panel Content for Waterfox 76


## Lockwise message

## Vulnerable Passwords message

## Picture-in-Picture fullscreen message

## Protections Dashboard message

## Better PDF message

cfr-doorhanger-milestone-close-button = أغلِق
    .accesskey = غ

## What’s New Panel Content for Waterfox 76
## Protections Dashboard message

## DOH Message

cfr-doorhanger-doh-body = خصوصيّتك فوق كل شيء. بات { -brand-short-name } يوجّه كل طلبات DNS التي تُجريها (متى كان ممكنًا) إلى خدمة شريكة، ذلك لحمايتك وأنت تتصفّح.
cfr-doorhanger-doh-header = عمليات بحث DNS أكثر أمانًا وتعميةً
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

## What's new: Media controls message

## What's new: Search shortcuts

## What's new: Cookies protection

## What's new: Better bookmarking

## What's new: Cross-site cookie tracking

## Full Video Support CFR message

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the Waterfox VPN page and a link to dismiss the dialog.

