# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = مدير الإضافات

addons-page-title = مدير الإضافات

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

show-unsigned-extensions-button =
    .label = تعذّر التحقق من بعض الامتدادات

show-all-extensions-button =
    .label = اعرض كل الامتدادات

cmd-show-details =
    .label = أظهر المزيد من المعلومات
    .accesskey = ظ

cmd-find-updates =
    .label = ابحث عن التحديثات
    .accesskey = ح

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] خيارات
           *[other] تفضيلات
        }
    .accesskey =
        { PLATFORM() ->
            [windows] خ
           *[other] ف
        }

cmd-enable-theme =
    .label = طبّق السمة
    .accesskey = س

cmd-disable-theme =
    .label = انزع السمة
    .accesskey = س

cmd-install-addon =
    .label = نصّب
    .accesskey = ن

cmd-contribute =
    .label = ساهِم
    .accesskey = س
    .tooltiptext = ساهِم في تطوير هذه الإضافة

detail-version =
    .label = النسخة

detail-last-updated =
    .label = آخر تحديث

detail-contributions-description = يطلب منك مطوّر هذه الإضافة مساعدته بدعم استمرار تطوير هذا العمل من خلال تبرع صغير منك.

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

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = تطلب الوصول إلى النوافذ الخاصة

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

## Recommended add-ons page


## Add-on actions


## Pending uninstall message bar

addon-detail-private-browsing-help = إن سمحت به فسيملك هذا الامتداد تصريح الوصول إلى نشاطك على الإنترنت وأنت تتصفح تصفحا خاصا. <a data-l10n-name="learn-more">اطّلع على المزيد</label>
addon-detail-private-browsing-allow = مسموح
addon-detail-private-browsing-disallow = غير مسموح

## Page headings

extension-heading = أدِر الامتدادات لديك
theme-heading = أدِر السمات لديك
plugin-heading = أدِر الملحقات لديك
dictionary-heading = أدِر القواميس لديك
locale-heading = أدِر اللغات لديك
shortcuts-heading = أدِر اختصارات الامتدادات

addon-page-options-button =
    .title = أدوات لجميع الإضافات
