# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


close-button =
    .aria-label = أغلق

preferences-title =
    .title =
        { PLATFORM() ->
            [windows] الخيارات
           *[other] التفضيلات
        }

pane-general-title = عام

pane-compose-title = التحرير
category-compose =
    .tooltiptext = التحرير

pane-privacy-title = الخصوصية و الأمان
category-privacy =
    .tooltiptext = الخصوصية و الأمان

pane-chat-title = الدردشة
category-chat =
    .tooltiptext = الدردشة

pane-calendar-title = التقويم
category-calendar =
    .tooltiptext = التقويم

general-language-and-appearance-header = اللغة والمظهر

general-incoming-mail-header = البريد الوارد

general-files-and-attachment-header = الملفات والمرفقات

general-tags-header = الوسوم

general-updates-header = التحديثات

general-network-and-diskspace-header = الشبكة ومساحة القرص

general-indexing-label = الفهرسة

composition-attachments-header = المرفقات

composition-spelling-title = الإملاء

composition-addressing-header = العنونة

privacy-main-header = الخصوصية

privacy-passwords-header = كلمات السر

privacy-security-header = الأمان

privacy-anti-virus-title = مضاد فيروسات

privacy-certificates-title = الشّهادات

chat-pane-header = الدردشة

chat-status-title = الحالة

chat-notifications-title = التنبيهات

chat-pane-styling-header = التصميم

choose-messenger-language-description = اختر اللغات المستخدمة لعرض القوائم والرسائل والتنبيهات من { -brand-short-name }.
confirm-messenger-language-change-description = أعِد تشغيل { -brand-short-name } لتطبيق هذه التغييرات
confirm-messenger-language-change-button = طبِّق وأعِد التشغيل

update-setting-write-failure-title = حدث عُطل أثناء تحديث التفضيلات

update-in-progress-title = يجري الآن التحديث

addons-button = الامتدادات والسمات

## OS Authentication dialog


## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = صفحة بداية { -brand-short-name }

start-page-label =
    .label = عند تشغيل { -brand-short-name }، اعرض صفحة البداية في منطقة الرسالة
    .accesskey = ص

location-label =
    .value = المكان:
    .accesskey = م
restore-default-label =
    .label = استعد المبدئيات
    .accesskey = س

default-search-engine = محرك البحث المبدئي

new-message-arrival = عند وصول رسالة جديدة:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] شغل ملف الصوت التالي:
           *[other] شغّل ملفًا صوتيًا
        }
    .accesskey =
        { PLATFORM() ->
            [macos] ش
           *[other] ت
        }
mail-play-button =
    .label = شغّل
    .accesskey = ش

change-dock-icon = غيّر تفضيلات أيقونة التطبيق
app-icon-options =
    .label = خيارات أيقونة التطبيق…
    .accesskey = خ

notification-settings = يمكن تعطيل التنبيهات و الصوت المبدئي من لوحة التنويهات في تفضيلات النظام.

animated-alert-label =
    .label = اعرض تنبيهًا
    .accesskey = ر
customize-alert-label =
    .label = خصّص…
    .accesskey = خ

tray-icon-label =
    .label = أظهر أيقونة في لوحة النظام
    .accesskey = ل

mail-custom-sound-label =
    .label = استخدم ملف الصوت التالي
    .accesskey = س
mail-browse-sound-button =
    .label = تصفّح…
    .accesskey = ص

enable-gloda-search-label =
    .label = فعّل البحث العمومي والفهرسة
    .accesskey = ف

datetime-formatting-legend = تنسيق التاريخ و الوقت
language-selector-legend = اللغة

allow-hw-accel =
    .label = استخدم تسريع العتاد إن كان متاحًا
    .accesskey = ع

store-type-label =
    .value = طريقة تخزين الرسائل للحسابات الجديدة:
    .accesskey = خ

mbox-store-label =
    .label = ملف لكل مجلد (mbox)
maildir-store-label =
    .label = ملف لكل رسالة (maildir)

scrolling-legend = اللف
autoscroll-label =
    .label = استخدم اللّف الآلي
    .accesskey = ف
smooth-scrolling-label =
    .label = استخدم اللّف السلس
    .accesskey = خ

system-integration-legend = تكامل النظام
always-check-default =
    .label = تحقق دائمًا عند البدء إن كان { -brand-short-name } هو عميل البريد الافتراضي
    .accesskey = ئ
check-default-button =
    .label = التمس الآن…
    .accesskey = ت

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Search
       *[other] { "" }
    }

search-integration-label =
    .label = اسمح ل‍ { search-engine-name } بالبحث في الرسائل
    .accesskey = ث

config-editor-button =
    .label = محرر الإعدادات…
    .accesskey = ت

return-receipts-description = حدد كيف يتعامل { -brand-short-name } مع إعلامات الوصول
return-receipts-button =
    .label = إعلامات الوصول…
    .accesskey = ع

update-app-legend = تحديثات { -brand-short-name }

# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = الإصدارة { $version }

automatic-updates-label =
    .label = نصّب التحديثات آليًا (مستحسن: يزيد الأمان)
    .accesskey = ل
check-updates-label =
    .label = التمس التحديثات، و لكن اترك لي خيار تنصيبها من عدمه
    .accesskey = ت

update-history-button =
    .label = أظهر تأريخ التحديث
    .accesskey = ظ

use-service =
    .label = استخدم خدمة تعمل في الخلفية لتنصيب التحديثات
    .accesskey = خ

networking-legend = الاتصال
proxy-config-description = اضبط كيفية اتصال { -brand-short-name } بالإنترنت

network-settings-button =
    .label = إعدادات…
    .accesskey = د

offline-legend = غير متّصل
offline-settings = اضبط إعدادات طور اللا اتصال

offline-settings-button =
    .label = غير متصل…
    .accesskey = ص

diskspace-legend = مساحة القرص
offline-compact-folder =
    .label = ادمج كل المجلدات إذا كانت ستوفِّر أكثر من
    .accesskey = و

compact-folder-size =
    .value = م.بايت

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = استخدم حتى
    .accesskey = ى

use-cache-after = م.بايت من المساحة للذاكرة المخبأة

##

smart-cache-label =
    .label = تخطَّ الإدارة الآلية للذاكرة الخبيئة
    .accesskey = ذ

clear-cache-button =
    .label = امسح الآن
    .accesskey = ح

fonts-legend = الخطوط و الألوان

default-font-label =
    .value = الخط المبدئي:
    .accesskey = م

default-size-label =
    .value = الحجم:
    .accesskey = ح

font-options-button =
    .label = الخطوط…
    .accesskey = خ

color-options-button =
    .label = الألوان…
    .accesskey = ن

display-width-legend = رسائل النص الصرف

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = اعرض أيقونات الانفعالات كرسوم
    .accesskey = ع

display-text-label = عند عرض رسائل النص الصرف مقتبسة:

style-label =
    .value = الأسلوب:
    .accesskey = س

regular-style-item =
    .label = عادي
bold-style-item =
    .label = سميك
italic-style-item =
    .label = مائل
bold-italic-style-item =
    .label = سميك مائل

size-label =
    .value = الحجم:
    .accesskey = ح

regular-size-item =
    .label = عادي
bigger-size-item =
    .label = أكبر
smaller-size-item =
    .label = أصغر

quoted-text-color =
    .label = اللون:
    .accesskey = ل

search-input =
    .placeholder = ابحث

type-column-label =
    .label = نوع المحتوى
    .accesskey = ح

action-column-label =
    .label = الإجراء
    .accesskey = ر

save-to-label =
    .label = احفظ الملفات في
    .accesskey = ف

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] اختر…
           *[other] استعرض…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] خ
           *[other] ع
        }

always-ask-label =
    .label = اسألني دائمًا أين أريد حفظ الملفات
    .accesskey = د


display-tags-text = يمكن استخدام الوسوم لتصنيف وتفضيل رسائلك.

new-tag-button =
    .label = جديد…
    .accesskey = د

edit-tag-button =
    .label = حرّر…
    .accesskey = ح

delete-tag-button =
    .label = احذف
    .accesskey = ح

auto-mark-as-read =
    .label = أشّر على الرسائل تلقائيًا بانها مقروءة
    .accesskey = ت

mark-read-no-delay =
    .label = فورًا عند العرض
    .accesskey = ف

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = بعد العرض لمدة
    .accesskey = ض

seconds-label = ثانية

##

open-msg-label =
    .value = افتح الرسائل في:

open-msg-tab =
    .label = لسان جديد
    .accesskey = ن

open-msg-window =
    .label = نافذة رسالة جديدة
    .accesskey = ن

open-msg-ex-window =
    .label = نافذة رسالة موجودة
    .accesskey = م

close-move-delete =
    .label = أغلِق نافذة/لسان الرسالة عند النقل أو الحذف
    .accesskey = ن

condensed-addresses-label =
    .label = اعرض فقط اسم العرض للأشخاص الذين في دفتر عناويني
    .accesskey = ع

## Compose Tab

forward-label =
    .value = مرّر الرسائل:
    .accesskey = م

inline-label =
    .label = ضمن السّياق

as-attachment-label =
    .label = كمرفقة

extension-label =
    .label = أضِف الامتداد إلى اسم الملف
    .accesskey = ف

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = احفظ تلقائيًّا كل
    .accesskey = ح

auto-save-end = دقائق

##

warn-on-send-accel-key =
    .label = اسأل التأكيد عند استخدام اختصارات لوحة المفاتيح لإرسال الرسالة
    .accesskey = س

spellcheck-label =
    .label = دقِّق الإملاء قبل الإرسال
    .accesskey = د

spellcheck-inline-label =
    .label = فعّل تدقيق الإملاء بينما أكتب
    .accesskey = ق

language-popup-label =
    .value = اللغة:
    .accesskey = ل

download-dictionaries-link = نزِّل المزيد من المعاجم

font-label =
    .value = الخط:
    .accesskey = خ

font-color-label =
    .value = لون النص:
    .accesskey = ن

bg-color-label =
    .value = لون الخلفية:
    .accesskey = ف

restore-html-label =
    .label = استعد المبدئيات
    .accesskey = م

default-format-label =
    .label = استخدم تنسيق الفقرات بدلا من متن النص مبدئيًا
    .accesskey = ف

format-description = اضبط سلوك تنسيق النص

send-options-label =
    .label = خيارات الإرسال…
    .accesskey = س

autocomplete-description = عند عنونة الرسائل، ابحث عن المدخلات المطابقة في:

ab-label =
    .label = دفتر العناوين المحلي
    .accesskey = ع

directories-label =
    .label = خادوم الدليل:
    .accesskey = د

directories-none-label =
    .none = لا شيء

edit-directories-label =
    .label = حرّر المجلدات…
    .accesskey = ح

email-picker-label =
    .label = أضِف آليًّا عنوان البريد الصادر إلى:
    .accesskey = ع

default-directory-label =
    .value = مجلد بدأ التشغيل المبدئي في نافذة دفتر العناوين:
    .accesskey = د

default-last-label =
    .none = آخر دليل مستخدم

attachment-label =
    .label = تحقق من المرفقات الناقصة
    .accesskey = ن

attachment-options-label =
    .label = الكلمات المفتاحية…
    .accesskey = ك

enable-cloud-share =
    .label = اقترح مشاركة الملفات الأكبر من
cloud-share-size =
    .value = م.ب

add-cloud-account =
    .label = أضف…
    .accesskey = ض
    .defaultlabel = أضف…

remove-cloud-account =
    .label = أزِل
    .accesskey = ل

cloud-account-description = أضِف خدمة تخزين ملفات على الإنترنت جديدة


## Privacy Tab

mail-content = محتوى البريد

remote-content-label =
    .label = اسمح بالمحتوى البعيد في الرسائل
    .accesskey = س

exceptions-button =
    .label = الاستثناءات…
    .accesskey = ث

remote-content-info =
    .value = اطلع على المزيد حول مسائل الخصوصية مع المحتوى البعيد

web-content = محتوى الوب

history-label =
    .label = تذكر المواقع و الروابط التي زُرتُها
    .accesskey = ت

cookies-label =
    .label = اقبل الكعكات من المواقع
    .accesskey = ك

third-party-label =
    .value = اقبل الكعكات من أطراف أخرى:
    .accesskey = ب

third-party-always =
    .label = دائمًا
third-party-never =
    .label = أبدًا
third-party-visited =
    .label = من المواقع المُزارة

keep-label =
    .value = احتفظ بها حتى:
    .accesskey = ف

keep-expire =
    .label = تنتهي صلاحيتها
keep-close =
    .label = أُغلق { -brand-short-name }
keep-ask =
    .label = اسألني كل مرة

cookies-button =
    .label = أظهِر الكعكات…
    .accesskey = ظ

learn-button =
    .label = اطّلع على المزيد

passwords-description = يستطيع { -brand-short-name } تذكر معلومات كلمة السر لكل حساباتك لذا لن تحتاج إلى إعادة إدخال بيانات الولوج.

passwords-button =
    .label = كلمات السر المحفوظة…
    .accesskey = س

master-password-description = عند تحديدها، ستحمي كلمة السر الرئيسيّة كل كلمات السر لكن يجب إدخالها مرة لكل جلسة.

master-password-label =
    .label = استخدم كلمة سر رئيسيّة
    .accesskey = م

master-password-button =
    .label = غيّر كلمة السر الرئيسيّة…
    .accesskey = غ


junk-description = اضبط إعدادات السخام الافتراضيَّة. يمكن ضبط إعدادات السخام الخاصة بالحساب في إعدادات الحساب.

junk-label =
    .label = عند تأشير الرسائل كسخام:
    .accesskey = ئ

junk-move-label =
    .label = انقلها إلى مجلد ”السخام“
    .accesskey = ن

junk-delete-label =
    .label = احذفهم
    .accesskey = ذ

junk-read-label =
    .label = أشِّر الرسائل السخام كمقروءة
    .accesskey = ء

junk-log-label =
    .label = فعل تسجيل مرشّح السّخام التكيّفي
    .accesskey = ف

junk-log-button =
    .label = اعرض السجل
    .accesskey = ع

reset-junk-button =
    .label = صفّر بيانات التدريب
    .accesskey = ب

phishing-description = يستطيع { -brand-short-name } تحليل الرسائل واكتشاف بريد الاحتيال المحتمل بالبحث عن وسائل الاحتيال الشهيرة.

phishing-label =
    .label = أخبرني إذا كانت الرسالة التي أقرأ بريد احتيال محتمل
    .accesskey = خ

antivirus-description = يستطيع { -brand-short-name } تسهيل مهمة مضاد الفيروسات في تحليل رسائل البريد الواردة بحثا عن فيروسات قبل حفظها محليّا.

antivirus-label =
    .label = اسمح لمضادات الفيروسات بحجر الرسائل الواردة عن بعض
    .accesskey = س

certificate-description = عندما يطلب خادوم شهادتي الشخصية:

certificate-auto =
    .label = اختر واحدة تلقائيًا
    .accesskey = خ

certificate-ask =
    .label = اسألني كل مرة
    .accesskey = ك

ocsp-label =
    .label = استعلم من خواديم مستجيبي OCSP عن الصلاحية الحالية للشهادات
    .accesskey = س

## Chat Tab

startup-label =
    .value = عند بدء { -brand-short-name }:
    .accesskey = ب

offline-label =
    .label = اترك حسابات الدردشة غير متصلة

auto-connect-label =
    .label = اتصل بحسابات الدردشة تلقائيا

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = أعلِم جهات اتصالي بخمولي بعد
    .accesskey = ع

idle-time-label = دقائق من عدم النشاط

##

away-message-label =
    .label = واجعل حالتي غائب مع هذه الرسالة:
    .accesskey = غ

send-typing-label =
    .label = أرسل تنويهات الكتابة في المحادثات
    .accesskey = ك

notification-label = عندما تصل الرسائل الموجهة إليك:

show-notification-label =
    .label = أظهر تنبيهًا:
    .accesskey = ت

notification-all =
    .label = باسم المرسل و معاينة للرسالة
notification-name =
    .label = باسم المرسل فقط
notification-empty =
    .label = بدون أي بيانات

notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] حرك أيقونة اللوحة
           *[other] ألمع عنصر شريط المهام
        }
    .accesskey =
        { PLATFORM() ->
            [macos] و
           *[other] م
        }

chat-play-sound-label =
    .label = اعزف صوتًا
    .accesskey = ع

chat-play-button =
    .label = شغّل
    .accesskey = ش

chat-system-sound-label =
    .label = صوت النظام المبدئي للبريد الجديد
    .accesskey = ت

chat-custom-sound-label =
    .label = استخدم ملف الصوت التالي
    .accesskey = س

chat-browse-sound-button =
    .label = تصفّح…
    .accesskey = ف

theme-label =
    .value = السمة:
    .accesskey = س

style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = فقاعات
style-dark =
    .label = داكن
style-paper =
    .label = صفحات ورقية
style-simple =
    .label = بسيط

preview-label = المعاينة:
no-preview-label = لا معاينة متوفرة
no-preview-description = ليست هذه السمة صحيحة أو ربما غير متاحة حاليًا (إضافة معطلة، صنعتها بنفسك، …).

chat-variant-label =
    .value = التنويعة:
    .accesskey = ع

chat-header-label =
    .label = اعرض الترويسة
    .accesskey = ت

## Preferences UI Search Results

