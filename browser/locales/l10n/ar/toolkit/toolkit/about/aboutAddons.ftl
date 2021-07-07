# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-page-title = مدير الإضافات

search-header =
    .placeholder = ابحث في addons.mozilla.org
    .searchbuttonlabel = ابحث

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = ليس لديك أي إضافات منصّبة من هذا النوع

list-empty-available-updates =
    .value = لا تحديثات متوفرة

list-empty-recent-updates =
    .value = لم تحدّث أي إضافات مؤخرًا

list-empty-find-updates =
    .label = التمس التحديثات

list-empty-button =
    .label = اعرف المزيد عن الإضافات

help-button = دعم الإضافات
sidebar-help-button-title =
    .title = دعم الإضافات

show-unsigned-extensions-button =
    .label = تعذّر التحقق من بعض الامتدادات

show-all-extensions-button =
    .label = اعرض كل الامتدادات

detail-version =
    .label = النسخة

detail-last-updated =
    .label = آخر تحديث

detail-contributions-description = يطلب منك مطوّر هذه الإضافة مساعدته بدعم استمرار تطوير هذا العمل من خلال تبرع صغير منك.

detail-contributions-button = ساهِم
    .title = ساهِم بتطويل هذه الإضافة
    .accesskey = س

detail-update-type =
    .value = التحديثات التلقائية

detail-update-default =
    .label = مبدئي
    .tooltiptext = نصّب التحديثات تلقائيًا إذا كان ذلك هو المبدئي فقط

detail-update-automatic =
    .label = مشغلة
    .tooltiptext = نصّب التحديثات تلقائيًا

detail-update-manual =
    .label = مطفأة
    .tooltiptext = لا نصّب التحديثات تلقائيًا

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = تشغيله في النوافذ الخاصة

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = ليس مسموحًا بأن تعمل في النوافذ الخاصة
detail-private-disallowed-description2 = لا يعمل هذا الامتداد وأنت تتصفح تصفحا خاصا. <a data-l10n-name="learn-more">اطّلع على المزيد</a>

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = تطلب الوصول إلى النوافذ الخاصة
detail-private-required-description2 = يملك هذا الامتداد تصريح الوصول إلى نشاطك على الإنترنت وأنت تتصفح تصفحا خاصا. <a data-l10n-name="learn-more">اطّلع على المزيد</a>

detail-private-browsing-on =
    .label = مسموح
    .tooltiptext = فعّل تشغيله عند التصفح تصفحا خاصا

detail-private-browsing-off =
    .label = غير مسموح
    .tooltiptext = عطّل تشغيله عند التصفح تصفحا خاصا

detail-home =
    .label = صفحة البداية

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = ملف الإضافة الشخصي

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = التمس التحديثات
    .accesskey = س
    .tooltiptext = التمس التحديثات لهذه الإضافة

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] خيارات
           *[other] تفضيلات
        }
    .accesskey =
        { PLATFORM() ->
            [windows] خ
           *[other] ض
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] غيّر خيارات هذه الإضافة
           *[other] غيّر تفضيلات هذه الإضافة
        }

detail-rating =
    .value = التقييم

addon-restart-now =
    .label = أعد التشغيل الآن

disabled-unsigned-heading =
    .value = عُطّلت بعض الإضافات

disabled-unsigned-description = لم يُتحقق من الإضافات التالية لاستخدامها مع { -brand-short-name }. يمكنك <label data-l10n-name="find-addons">البحث عن بدائل</label> أو أن تطلب من المطوّر أن يجعل موزيلا تتحقق منهم.

disabled-unsigned-learn-more = اطلع أكثر على مجهوداتنا في إبقائك آمنا على الإنترنت.

disabled-unsigned-devinfo = المطورين المهتمين بأن تتحقق موزيلا من إضافاتهم، يمكنهم قراءة <label data-l10n-name="learn-more">دليلنا</label>.

plugin-deprecation-description = أهناك ما تفتقده؟ لم يعد { -brand-short-name } يدعم بعض الملحقات. <label data-l10n-name="learn-more">اطّلع على المزيد.</label>

legacy-warning-show-legacy = اعرض الامتدادات العتيقة

legacy-extensions =
    .value = امتدادات عتيقة

legacy-extensions-description = لا تحقق هذه الامتدادات معايير { -brand-short-name } الحالية، لذا عُطّلت. <label data-l10n-name="legacy-learn-more">تعرّف على التغييرات على الإضافات</label>

private-browsing-description2 = بدأ { -brand-short-name } بتغيير كيفية عمل الامتدادات في التصفح الخاص. مبدئيًا، لن تعمل أي امتدادات جديدة تُضيفها إلى { -brand-short-name } في النوافذ الخاصة. إن لم تغيّر ذلك وتسمح به في الإعدادات فلن يعمل الامتداد وأنت في التصفح الخاص، ولن يملك حق الوصول إلى نشاطك على الوِب فيها. أجرينا هذا التغيير ليكون التصفح الخاص خاصًا بحق. <label data-l10n-name="private-browsing-learn-more">اطّلع على طريقة إدارة إعدادات الامتدادات</label>

addon-category-discover = مُقترحة عليك
addon-category-discover-title =
    .title = مُقترحة عليك
addon-category-extension = الامتدادات
addon-category-extension-title =
    .title = الامتدادات
addon-category-theme = السِمات
addon-category-theme-title =
    .title = السِمات
addon-category-plugin = الملحقات
addon-category-plugin-title =
    .title = الملحقات
addon-category-dictionary = القواميس
addon-category-dictionary-title =
    .title = القواميس
addon-category-locale = اللغات
addon-category-locale-title =
    .title = اللغات
addon-category-available-updates = التحديثات المتاحة
addon-category-available-updates-title =
    .title = التحديثات المتاحة
addon-category-recent-updates = التحديثات الأخيرة
addon-category-recent-updates-title =
    .title = التحديثات الأخيرة

## These are global warnings

extensions-warning-safe-mode = النمط الآمن عطّل جميع الإضافات.
extensions-warning-check-compatibility = التحقق من توافقية الإضافات قد عُطّل. قد يكون لديك إضافات غير متوافقة.
extensions-warning-check-compatibility-button = فعّل
    .title = فعّل التحقق من توافقية الإضافات
extensions-warning-update-security = التحقق من أمن التحديثات قد عُطّل. قد تشكل التهديدات عليك خطرًا.
extensions-warning-update-security-button = فعّل
    .title = فعّل التحقق من أمن تحديثات الإضافات


## Strings connected to add-on updates

addon-updates-check-for-updates = التمس التحديثات
    .accesskey = ت
addon-updates-view-updates = اعرض التحديثات الأخيرة
    .accesskey = ض

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = حدّث الإضافات تلقائيًا
    .accesskey = ق

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = اجعل تحديث كل الإضافات تلقائيًا
    .accesskey = ف
addon-updates-reset-updates-to-manual = اجعل تحديث كل الإضافات يدويًا
    .accesskey = ف

## Status messages displayed when updating add-ons

addon-updates-updating = يحدّث الإضافات
addon-updates-installed = حُدّثت إضافاتك.
addon-updates-none-found = لا يوجد تحديثات
addon-updates-manual-updates-found = اعرض التحديثات المتاحة

## Add-on install/debug strings for page options menu

addon-install-from-file = نصّب إضافة من ملف…
    .accesskey = ن
addon-install-from-file-dialog-title = اختر إضافة لتنصيبها
addon-install-from-file-filter-name = الإضافات
addon-open-about-debugging = نقّح الإضافات
    .accesskey = ن

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = أدِر اختصارات الامتدادات
    .accesskey = د

shortcuts-no-addons = ليس لديك أيّ امتدادات مفعّلة.
shortcuts-no-commands = لا اختصارات للامتدادات الآتية:
shortcuts-input =
    .placeholder = اكتب اختصارًا

shortcuts-browserAction2 = تفعيل زر شريط الأدوات
shortcuts-pageAction = تفعيل إجراء على الصفحة
shortcuts-sidebarAction = عرض/إخفاء الشريط الجانبي

shortcuts-modifier-mac = يحتوي على Ctrl أو Alt أو ⌘
shortcuts-modifier-other = يحتوي على Ctrl أو Alt
shortcuts-invalid = تشكيلة غير صالحة
shortcuts-letter = اكتب حرفا
shortcuts-system = لا يمكنك إلغاء اختصار من اختصارات { -brand-short-name }

# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = اختصار متكرر

# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = يُستعمل { $shortcut } كاختصار في أكثر من إجراء واحد. قد تؤدي الاختصارات المتكررة إلى سلوك لا تتوقعه.

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = تستخدمه { $addon } بالفعل

shortcuts-card-expand-button =
    { $numberToShow ->
        [zero] لا تعرض المزيد
        [one] اعرض واحدًا أكثر
        [two] اعرض اثنين أكثر
        [few] اعرض { $numberToShow } أكثر
        [many] اعرض { $numberToShow } أكثر
       *[other] اعرض { $numberToShow } أكثر
    }

shortcuts-card-collapse-button = اعرض أقل

header-back-button =
    .title = عُد للسابق

## Recommended add-ons page

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations = بعض هذه المُقترحات مخصّصة لك، إذ تعتمد على الامتدادات التي ثبّتها وتفضيلات الملف الشخصي وإحصاءات الاستخدام.
discopane-notice-learn-more = اطّلع على المزيد

privacy-policy = سياسة الخصوصية

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = طوّرها <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = المستخدمين: { $dailyUsers }
install-extension-button = أضِفه إلى { -brand-product-name }
install-theme-button = ثبّت السمة
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = أدِر
find-more-addons = ابحث عن إضافات أكثر

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = خيارات أكثر

## Add-on actions

report-addon-button = أبلِغ
remove-addon-button = أزِل
# The link will always be shown after the other text.
remove-addon-disabled-button = لا يمكنك إزالته <a data-l10n-name="link">لماذا؟</a>
disable-addon-button = عطّل
enable-addon-button = فعّل
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = فعّل
preferences-addon-button =
    { PLATFORM() ->
        [windows] الخيارات
       *[other] التفضيلات
    }
details-addon-button = التفاصيل
release-notes-addon-button = ملاحظات الإصدار
permissions-addon-button = الصلاحيات

extension-enabled-heading = مفعّل
extension-disabled-heading = معطّل

theme-enabled-heading = مفعّلة
theme-disabled-heading = معطّلة

plugin-enabled-heading = مفعّلة
plugin-disabled-heading = معطّلة

dictionary-enabled-heading = مفعّل
dictionary-disabled-heading = معطّل

locale-enabled-heading = مفعّلة
locale-disabled-heading = معطّلة

always-activate-button = فعّل دائمًا
never-activate-button = لا تُفعّل أبدًا

addon-detail-author-label = المؤلف
addon-detail-version-label = الإصدارة
addon-detail-last-updated-label = آخر تحديث
addon-detail-homepage-label = صفحة البداية
addon-detail-rating-label = التقييم

# Message for add-ons with a staged pending update.
install-postponed-message = سيُحدّث هذا الامتداد متى أُعيد تشغيل { -brand-short-name }.
install-postponed-button = حدّث الآن

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = تقييمها { NUMBER($rating, maximumFractionDigits: 1) } من أصل 5

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = ‏{ $name } (معطّلة)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [zero] ما من مراجعات
        [one] مراجعة واحدة
        [two] مراجعتان
        [few] { $numberOfReviews } مراجعات
        [many] { $numberOfReviews } مراجعة
       *[other] { $numberOfReviews } مراجعة
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = أُزيلت <span data-l10n-name="addon-name">{ $addon }</span>.
pending-uninstall-undo-button = تراجَع

addon-detail-updates-label = اسمح بالتحديثات التلقائية
addon-detail-updates-radio-default = المبدئي
addon-detail-updates-radio-on = مفعّل
addon-detail-updates-radio-off = معطّل
addon-detail-update-check-label = التمس التحديثات
install-update-button = حدّث

# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = مسموح بها في النوافذ الخاصة
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = إن سمحت به فسيملك هذا الامتداد تصريح الوصول إلى نشاطك على الإنترنت وأنت تتصفح تصفحا خاصا. <a data-l10n-name="learn-more">اطّلع على المزيد</label>
addon-detail-private-browsing-allow = مسموح
addon-detail-private-browsing-disallow = غير مسموح

## This is the tooltip text for the recommended badges for an extension in about:addons. The
## badge is a small icon displayed next to an extension when it is recommended on AMO.

addon-badge-recommended2 =
    .title = يوصي { -brand-product-name } ويقترح فقط الامتدادات التي تلبي معاييرنا للأمان والأداء.
    .aria-label = { addon-badge-recommended2.title }

##

available-updates-heading = التحديثات المتاحة
recent-updates-heading = التحديثات الأخيرة

release-notes-loading = يحمّل…
release-notes-error = المعذرة، ولكن حصل خطأ أثناء تحميل ملاحظات الإصدار.

addon-permissions-empty = لا يطلب هذا الامتداد أيّ صلاحيات

recommended-extensions-heading = الامتدادات المقترحة
recommended-themes-heading = السمات المقترحة

# A recommendation for the Waterfox Color theme shown at the bottom of the theme
# list view. The "Waterfox Color" name itself should not be translated.
recommended-theme-1 = ترى فيك الإبداع؟ <a data-l10n-name="link">اصنع سمتك الخاصة باستعمال Waterfox Color.</a>

## Page headings

extension-heading = أدِر الامتدادات لديك
theme-heading = أدِر السمات لديك
plugin-heading = أدِر الملحقات لديك
dictionary-heading = أدِر القواميس لديك
locale-heading = أدِر اللغات لديك
updates-heading = أدِر التحديثات لديك
discover-heading = خصّص { -brand-short-name } ليكون لك
shortcuts-heading = أدِر اختصارات الامتدادات

default-heading-search-label = ابحث عن إضافات أكثر
addons-heading-search-input =
    .placeholder = ابحث في addons.mozilla.org

addon-page-options-button =
    .title = أدوات لجميع الإضافات
