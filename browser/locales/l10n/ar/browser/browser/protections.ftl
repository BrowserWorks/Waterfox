# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [zero] لم يحجب { -brand-short-name } أي متعقّب خلال الأسبوع المنقضي
        [one] حجب { -brand-short-name } متعقبا واحدا خلال الأسبوع المنقضي
        [two] حجب { -brand-short-name } متعقبين اثنين خلال الأسبوع المنقضي
        [few] حجب { -brand-short-name } ‏{ $count } متعقبات خلال الأسبوع المنقضي
        [many] حجب { -brand-short-name } ‏{ $count } متعقبا خلال الأسبوع المنقضي
       *[other] حجب { -brand-short-name } ‏{ $count } متعقب خلال الأسبوع المنقضي
    }
# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [zero] لم يُحجب أي متعقب منذ { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
        [one] حُجب <b>متعقب واحد</b> منذ { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
        [two] حُجب <b>متعقبين اثنين</b> منذ { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
        [few] حُجب <b>{ $count }</b> متعقبات منذ { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
        [many] حُجب <b>{ $count }</b> متعقبا منذ { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] حُجب <b>{ $count }</b> متعقب منذ { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }
# Text displayed instead of the graph when in Private Mode
graph-private-window = يحجب { -brand-short-name } المتعقّبات في النوافذ الخاصّة أيضًا، ولكنّه لا يسجّل ما حجبه وكم حجب.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = المُتعقّبات التي حجبها { -brand-short-name } هذا الأسبوع
protection-report-webpage-title = لوحة معلومات الحماية
protection-report-page-content-title = لوحة معلومات الحماية
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = يمكنه { -brand-short-name } حماية خصوصيتك وأنت تتصفّح خفيةً. إليك ملخّصًا عن معلومات الحماية أُعدّ لك خصيصًا. يشمل الملخص ما يلزم لتتحكّم بأمنك على الشبكة.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = يحمي { -brand-short-name } خصوصيتك وأنت تتصفّح خفيةً. إليك ملخّصًا عن معلومات الحماية أُعدّ لك خصيصًا. يشمل الملخص ما يلزم لتتحكّم بأمنك على الشبكة.
protection-report-settings-link = أدِر إعدادات خصوصيتك وأمنك
etp-card-title-always = الحماية الموسّعة من التعقب: تعمل دومًا
etp-card-title-custom-not-blocking = الحماية الموسّعة من التعقب: معطّلة
etp-card-content-description = يُوقف { -brand-short-name } تلقائيًا الشركات من تعقّبك خفيةً في أرجاء الوِب.
protection-report-etp-card-content-custom-not-blocking = كلّ مزايا الحماية معطّلة. اختر أيّ متعقّبات تريد حجبها بإدارة إعدادات الحماية في { -brand-short-name }.
protection-report-manage-protections = أدِر الإعدادات
# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = اليوم
# This string is used to describe the graph for screenreader users.
graph-legend-description = رسم بياني فيه إجمالي عدد المتعقّبات ونوعها التي حُجبت هذا الأسبوع.
social-tab-title = متعقبات مواقع التواصل الاجتماعي
social-tab-contant = تضع شبكات التواصل المتعقّبات في مواقعها لتعرف ما تفعل وترى وتشاهد على الشبكة. يُتيح هذا لها بأن تعلم المزيد عنك وعمّا شاركته في صفحاتك الشخصية عليها. <a data-l10n-name="learn-more-link">اطّلع على المزيد</a>
cookie-tab-title = كعكات تتعقّبك بين المواقع
cookie-tab-content = تتعقّبك هذه الكعكات من موقع إلى آخر لتجمع بيانات عمّا تفعله على الشبكة، وقد ضبطتها أطراف ثالثة كشركات الإعلان والتحليل الرقمي. بحجب الكعكات التي تتعقّبك بين المواقع تكون قد قلّلت عدد الإعلانات التي تلاحقك عبر الشبكة. <a data-l10n-name="learn-more-link">اطّلع على المزيد</a>
tracker-tab-title = المحتوى الذي يتعقّبك
tracker-tab-description = يمكن أن تُحمّل المواقع الإعلانات والفديوهات وغيرها من محتوى خارجي يحتوي على كود تعقّب. بحجب المحتوى الذي يتعقّبك هذا فأنت تساهم في تحميل الصفحات أسرع، على حساب إمكانية عدم عمل بعض الأزرار والاستمارات وحقول الولوج. <a data-l10n-name="learn-more-link">اطّلع على المزيد</a>
fingerprinter-tab-title = مسجّلات البصمات
fingerprinter-tab-content = تجمع مُسجّلات البصمات الإعدادات من المتصفح والجهاز لتفتح عنك ملفا عمّن تكون. يمكنها باستعمال هذه البصمة الرقمية تعقّبك في أرجاء مختلف المواقع. <a data-l10n-name="learn-more-link">اطّلع على المزيد</a>
cryptominer-tab-title = المُعدّنات المعمّاة
cryptominer-tab-content = تستعمل المُعدّنات المعمّاة طاقة الحساب في جهازك لتُعدّن أموالا رقمية. يستنزف هذا التعدين المدخرة ويُبطئ الجهاز ويزيد من فاتورة الكهرباء.<a data-l10n-name="learn-more-link">اطّلع على المزيد</a>
protections-close-button2 =
    .aria-label = أغلِق
    .title = أغلِق
mobile-app-title = احجب الإعلانات المتعقّبة على أجهزتك الأخرى
mobile-app-card-content = استعمل متصفح المحمول ذا الحماية المدمجة ضد تعقّب الإعلانات.
mobile-app-links = متصفّح { -brand-product-name } لنظامي <a data-l10n-name="android-mobile-inline-link">أندرويد</a> و<a data-l10n-name="ios-mobile-inline-link">آي‌أوإس</a>
lockwise-title = بعد الآن، ”نسيت كلمة السر“ فعل ماض
lockwise-title-logged-in2 = إدارة كلمات السر
lockwise-header-content = يخزّن { -lockwise-brand-name } كلمات السرّ لديك في متصفّحك بأمان تام.
lockwise-header-content-logged-in = خزّن كلمات السر وزامنها على مختلف الأجهزة لديك.
protection-report-save-passwords-button = احفظ كلمات السر
    .title = احفظ كلمات السر في { -lockwise-brand-short-name }
protection-report-manage-passwords-button = أدِر كلمات السر
    .title = أدِر كلمات السر في { -lockwise-brand-short-name }
lockwise-mobile-app-title = خُذ معك كلمات السر أينما ذهبت
lockwise-no-logins-card-content = استعمل كلمات السر المحفوظة في { -brand-short-name } على أي جهاز.
lockwise-app-links = { -lockwise-brand-name } لنظامي <a data-l10n-name="lockwise-android-inline-link">أندرويد</a> و<a data-l10n-name="lockwise-ios-inline-link">آي‌أو‌إس</a>
# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [zero] لم تظهر أي كلمة سر في أي تسرّب بيانات.
        [one] ظهرت كلمة سر واحدة في تسرّب بيانات.
        [two] ظهرت كلمتا سر في تسرّب بيانات.
        [few] ظهرت { $count } كلمات سر في تسرّب بيانات.
        [many] ظهرت { $count } كلمة سر في تسرّب بيانات.
       *[other] ظهرت { $count } كلمة سر في تسرّب بيانات.
    }
# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [zero] لم تُخزّن أي كلمة سر بأمان.
        [one] خُزّنت كلمة سر واحدة بأمان.
        [two] خُزّنت كلمتا سر بأمان.
        [few] كلمات السر تُخزّن بأمان.
        [many] كلمات السر تُخزّن بأمان.
       *[other] كلمات السر تُخزّن بأمان.
    }
lockwise-how-it-works-link = كيف تعمل
turn-on-sync = فعّل { -sync-brand-short-name }…
    .title = انتقل إلى تفضيلات المزامنة
monitor-title = تنبّه وتيقّظ متى ما تسرّبت البيانات
monitor-link = آلية العمل
monitor-header-content-no-account = انقر { -monitor-brand-name } لتعرف لو كانت بياناتك جزءًا من تسرّب معروف للبيانات، ولتستلم التنبيهات عن التسريبات الجديدة.
monitor-header-content-signed-in = يُحذّرك { -monitor-brand-name } إن ظهرت معلوماتك في تسرّب معروف للبيانات.
monitor-sign-up-link = سجّل لتصلك التنبيهات عن التسريبات
    .title = سجّل لتصلك التنبيهات عن التسريبات على { -monitor-brand-name }
auto-scan = مجموع ما فُحص اليوم تلقائيًا
# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [zero] عناوين البريد التي نراقبها
        [one] عنوان البريد الذي نراقبه
        [two] عنوانا البريد الذي نراقبهما
        [few] عناوين البريد التي نراقبها
        [many] عناوين البريد التي نراقبها
       *[other] عناوين البريد التي نراقبها
    }
monitor-no-breaches-title = أخبار سارة!
monitor-no-breaches-description = ما من تسريبات بيانات معروفة فيها بياناتك. سنُعلمك طبعًا في حال تغيّر الحال.
monitor-view-report-link = اعرض التقرير
    .title = حُلّ التسريبات على { -monitor-brand-short-name }
monitor-breaches-unresolved-title = حُلّ تسريبات معلوماتك
monitor-breaches-unresolved-description = بعدما تراجع تفاصيل التسريب وتأخذ الخطوات اللازمة لحماية معلوماتك، يمكنك وضع علامة ”حُلّ“ على التسريب.
monitor-manage-breaches-link = أدِر التسريبات
    .title = أدِر التسريبات من { -monitor-brand-short-name }
monitor-breaches-resolved-title = جميل! حللت كل تسريبات البيانات المعروفة.
monitor-breaches-resolved-description = سنُعلمك حال ظهور عنوان بريدك الإلكتروني في أي تسريب جديد للبيانات.
# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = تمت { $percentageResolved }%
monitor-partial-breaches-motivation-title-start = بداية طيبة!
monitor-partial-breaches-motivation-title-middle = واصل على هذا النحو!
monitor-partial-breaches-motivation-title-end = أوشكنا! واصل على هذا النحو.
monitor-partial-breaches-motivation-description = حُلّ بقية التسريبات على { -monitor-brand-short-name }.

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = متعقبات مواقع التواصل الاجتماعي
    .aria-label =
        { $count ->
            [zero] لا متعقبات مواقع تواصل اجتماعي ({ $percentage }٪)
            [one] متعقب واحد لمواقع التواصل الاجتماعي ({ $percentage }٪)
            [two] متعقبان اثنان لمواقع التواصل الاجتماعي ({ $percentage }٪)
            [few] { $count } متعقبات لمواقع التواصل الاجتماعي ({ $percentage }٪)
            [many] { $count } متعقبا لمواقع التواصل الاجتماعي ({ $percentage }٪)
           *[other] { $count } متعقب لمواقع التواصل الاجتماعي ({ $percentage }٪)
        }
bar-tooltip-cookie =
    .title = الكعكات التي تتعقّبك بين المواقع
    .aria-label =
        { $count ->
            [zero] ما من كعكات تتعقّبك بين المواقع ({ $percentage }%)
            [one] كعكة واحدة من الكعكات التي تتعقّبك بين المواقع ({ $percentage }%)
            [two] كعكتان من الكعكات التي تتعقّبك بين المواقع ({ $percentage }%)
            [few] { $count } كعكات من الكعكات التي تتعقّبك بين المواقع ({ $percentage }%)
            [many] { $count } كعكة من الكعكات التي تتعقّبك بين المواقع ({ $percentage }%)
           *[other] { $count } كعكة من الكعكات التي تتعقّبك بين المواقع ({ $percentage }%)
        }
