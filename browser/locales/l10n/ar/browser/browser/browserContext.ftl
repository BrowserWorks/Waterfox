# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] اسحب للأسفل لإظهار التأريخ
           *[other] انقر بالزر الأيمن أو اسحب للأسفل لإظهار التأريخ
        }

## Back

main-context-menu-back =
    .tooltiptext = عُد للخلف صفحة واحدة
    .aria-label = السابق
    .accesskey = س
navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }
toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = انتقل للأمام صفحة واحدة
    .aria-label = التالي
    .accesskey = ت
navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }
toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = أعد التحميل
    .accesskey = ع
toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = أوقف
    .accesskey = ق
toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = احفظ الصفحة باسم…
    .accesskey = س
toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = علّم هذه الصفحة
    .accesskey = ه
    .tooltiptext = علّم هذه الصفحة
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = علّم هذه الصفحة
    .accesskey = ه
    .tooltiptext = علّم هذه الصفحة ({ $shortcut })
main-context-menu-bookmark-change =
    .aria-label = حرّر هذه العلامة
    .accesskey = ه
    .tooltiptext = حرّر هذه العلامة
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = حرّر هذه العلامة
    .accesskey = ه
    .tooltiptext = حرّر هذه العلامة ({ $shortcut })
main-context-menu-open-link =
    .label = افتح الرابط
    .accesskey = ر
main-context-menu-open-link-new-tab =
    .label = افتح الرابط في لسان جديد
    .accesskey = ل
main-context-menu-open-link-container-tab =
    .label = افتح الرابط في لسان حاوِ جديد
    .accesskey = ح
main-context-menu-open-link-new-window =
    .label = افتح الرابط في نافذة جديدة
    .accesskey = ج
main-context-menu-open-link-new-private-window =
    .label = افتح الرابط في نافذة خاصة جديدة
    .accesskey = خ
main-context-menu-bookmark-this-link =
    .label = علِّم هذا الرابط
    .accesskey = ر
main-context-menu-save-link =
    .label = احفظ الرابط باسم…
    .accesskey = ر
main-context-menu-save-link-to-pocket =
    .label = احفظ الرابط في { -pocket-brand-name }
    .accesskey = ط

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = انسخ عنوان البريد الإلكتروني
    .accesskey = خ
main-context-menu-copy-link =
    .label = انسخ مكان الرابط
    .accesskey = م

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = شغّل
    .accesskey = ش
main-context-menu-media-pause =
    .label = ألبِث
    .accesskey = ث

##

main-context-menu-media-mute =
    .label = اكتم الصوت
    .accesskey = ك
main-context-menu-media-unmute =
    .label = أطلِق الصوت
    .accesskey = ط
main-context-menu-media-play-speed =
    .label = سرعة التشغيل
    .accesskey = ت
main-context-menu-media-play-speed-slow =
    .label = بطيئة (نصف السرعة)
    .accesskey = ط
main-context-menu-media-play-speed-normal =
    .label = عادية
    .accesskey = ع
main-context-menu-media-play-speed-fast =
    .label = سريعة (١٫٢٥ ضعف)
    .accesskey = س
main-context-menu-media-play-speed-faster =
    .label = أسرع (١٫٥ ضعف)
    .accesskey = ع
# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = سريعة جدًا (ضعفي السرعة)
    .accesskey = د
main-context-menu-media-loop =
    .label = تكرار
    .accesskey = ر

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = أظهر أزرار التحكم
    .accesskey = ز
main-context-menu-media-hide-controls =
    .label = أخفِ أزرار التحكم
    .accesskey = ك

##

main-context-menu-media-video-fullscreen =
    .label = ملء الشاشة
    .accesskey = ش
main-context-menu-media-video-leave-fullscreen =
    .label = غادر ملء الشاشة
    .accesskey = م
# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = ڤديو معترِض
    .accesskey = ع
main-context-menu-image-reload =
    .label = أعِد تحميل الصورة
    .accesskey = ع
main-context-menu-image-view =
    .label = اعرض الصورة
    .accesskey = ص
main-context-menu-video-view =
    .label = اعرض الفديو
    .accesskey = ف
main-context-menu-image-copy =
    .label = انسخ الصورة
    .accesskey = خ
main-context-menu-image-copy-location =
    .label = انسخ مكان الصورة
    .accesskey = س
main-context-menu-video-copy-location =
    .label = انسخ مكان الفديو
    .accesskey = ف
main-context-menu-audio-copy-location =
    .label = انسخ مكان الصوت
    .accesskey = و
main-context-menu-image-save-as =
    .label = احفظ الصورة باسم…
    .accesskey = ر
main-context-menu-image-email =
    .label = أرسل الصورة بالبريد…
    .accesskey = ص
main-context-menu-image-set-as-background =
    .label = اجعلها خلفية سطح المكتب…
    .accesskey = ج
main-context-menu-image-info =
    .label = اعرض معلومات الصورة
    .accesskey = ة
main-context-menu-image-desc =
    .label = اعرض الوصف
    .accesskey = ص
main-context-menu-video-save-as =
    .label = احفظ الڤديو باسم…
    .accesskey = و
main-context-menu-audio-save-as =
    .label = احفظ الصوت باسم…
    .accesskey = ت
main-context-menu-video-image-save-as =
    .label = احفظ لقطة شاشة باسم…
    .accesskey = ط
main-context-menu-video-email =
    .label = أرسل الڤديو بالبريد…
    .accesskey = ڤ
main-context-menu-audio-email =
    .label = أرسل الصوت بالبريد…
    .accesskey = ت
main-context-menu-plugin-play =
    .label = فعّل هذه المُلحقة
    .accesskey = ف
main-context-menu-plugin-hide =
    .label = أخفِ هذه المُلحقة
    .accesskey = خ
main-context-menu-save-to-pocket =
    .label = احفظ الصفحة في { -pocket-brand-name }
    .accesskey = ح
main-context-menu-send-to-device =
    .label = أرسِل الصفحة إلى جهاز
    .accesskey = ه
main-context-menu-view-background-image =
    .label = اعرض صورة الخلفية
    .accesskey = خ
main-context-menu-generate-new-password =
    .label = استعمل كلمة سرّ مولّدة…
    .accesskey = د
main-context-menu-keyword =
    .label = أضِف كلمة رئيسية لهذا البحث…
    .accesskey = ك
main-context-menu-link-send-to-device =
    .label = أرسل الرابط إلى جهاز
    .accesskey = ه
main-context-menu-frame =
    .label = هذا الإطار
    .accesskey = ه
main-context-menu-frame-show-this =
    .label = أظهر هذا الإطار فقط
    .accesskey = ظ
main-context-menu-frame-open-tab =
    .label = افتح الإطار في لسان جديد
    .accesskey = ل
main-context-menu-frame-open-window =
    .label = افتح الإطار في نافذةٍ جديدة
    .accesskey = ف
main-context-menu-frame-reload =
    .label = أعِد تحميل الإطار
    .accesskey = ت
main-context-menu-frame-bookmark =
    .label = علِّم هذا الإطار
    .accesskey = ط
main-context-menu-frame-save-as =
    .label = احفظ الإطار باسم…
    .accesskey = ط
main-context-menu-frame-print =
    .label = اطبع الإطار…
    .accesskey = ط
main-context-menu-frame-view-source =
    .label = اعرض مصدر الإطار
    .accesskey = ط
main-context-menu-frame-view-info =
    .label = اعرض معلومات الإطار
    .accesskey = ط
main-context-menu-view-selection-source =
    .label = اعرض مصدر التحديد
    .accesskey = ص
main-context-menu-view-page-source =
    .label = اعرض مصدر هذه الصفحة
    .accesskey = ص
main-context-menu-view-page-info =
    .label = اعرض معلومات الصفحة
    .accesskey = ص
main-context-menu-bidi-switch-text =
    .label = اعكس اتجاه النص
    .accesskey = ن
main-context-menu-bidi-switch-page =
    .label = اعكس اتجاه الصفحة
    .accesskey = ك
main-context-menu-inspect-element =
    .label = افحص العنصر
    .accesskey = ح
main-context-menu-inspect-a11y-properties =
    .label = افحص خصائص الإتاحة
main-context-menu-eme-learn-more =
    .label = اطلع أكثر عن إدارة الحقوق الرقمية…
    .accesskey = د
