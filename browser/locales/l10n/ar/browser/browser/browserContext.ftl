# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] اسحب للأسفل لإظهار التأريخ
           *[other] انقر بالزر الأيمن أو اسحب للأسفل لإظهار التأريخ
        }

## Back

# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Back command.
main-context-menu-back-2 =
    .tooltiptext = عُد للخلف صفحة واحدة ({ $shortcut })
    .aria-label = السابق
    .accesskey = س
# This menuitem is only visible on macOS
main-context-menu-back-mac =
    .label = السابق
    .accesskey = س
navbar-tooltip-back-2 =
    .value = { main-context-menu-back-2.tooltiptext }
toolbar-button-back-2 =
    .label = { main-context-menu-back-2.aria-label }

## Forward

# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Forward command.
main-context-menu-forward-2 =
    .tooltiptext = انتقل للأمام صفحة واحدة ({ $shortcut })
    .aria-label = التالي
    .accesskey = ت
# This menuitem is only visible on macOS
main-context-menu-forward-mac =
    .label = التالي
    .accesskey = ت
navbar-tooltip-forward-2 =
    .value = { main-context-menu-forward-2.tooltiptext }
toolbar-button-forward-2 =
    .label = { main-context-menu-forward-2.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = أعد التحميل
    .accesskey = ع
# This menuitem is only visible on macOS
main-context-menu-reload-mac =
    .label = أعد التحميل
    .accesskey = ع
toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = أوقف
    .accesskey = ق
# This menuitem is only visible on macOS
main-context-menu-stop-mac =
    .label = أوقف
    .accesskey = ق
toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Waterfox Account Button

toolbar-button-fxaccount =
    .label = { -fxaccount-brand-name }
    .tooltiptext = { -fxaccount-brand-name }

## Save Page

main-context-menu-page-save =
    .label = احفظ الصفحة باسم…
    .accesskey = س

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = علّم هذه الصفحة
    .accesskey = ه
    .tooltiptext = علّم هذه الصفحة
# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-edit-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-add-mac =
    .label = علِّم الصفحة
    .accesskey = ع
# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-add-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-edit-mac =
    .label = حرّر العلامة
    .accesskey = ح
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
main-context-menu-bookmark-link =
    .label = علّم الرابط
    .accesskey = ع
main-context-menu-save-link =
    .label = احفظ الرابط باسم…
    .accesskey = ر
main-context-menu-save-link-to-pocket =
    .label = احفظ الرابط في { -pocket-brand-name }
    .accesskey = ط

## The access keys for "Copy Link" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = انسخ عنوان البريد الإلكتروني
    .accesskey = خ
main-context-menu-copy-link-simple =
    .label = انسخ الرابط
    .accesskey = ن

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
main-context-menu-media-play-speed-2 =
    .label = السرعة
    .accesskey = س
main-context-menu-media-play-speed-slow-2 =
    .label = 0.5×
main-context-menu-media-play-speed-normal-2 =
    .label = 1.0×
main-context-menu-media-play-speed-fast-2 =
    .label = 1.25×
main-context-menu-media-play-speed-faster-2 =
    .label = 1.5×
main-context-menu-media-play-speed-fastest-2 =
    .label = 2×
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
main-context-menu-media-watch-pip =
    .label = شاهِده بوضع الڤديو المعترِض
    .accesskey = ش
main-context-menu-image-reload =
    .label = أعِد تحميل الصورة
    .accesskey = ع
main-context-menu-image-view-new-tab =
    .label = افتح الصورة في لسان جديد
    .accesskey = ت
main-context-menu-video-view-new-tab =
    .label = افتح الڤديو في لسان جديد
    .accesskey = ت
main-context-menu-image-copy =
    .label = انسخ الصورة
    .accesskey = خ
main-context-menu-image-copy-link =
    .label = انسخ رابط الصورة
    .accesskey = س
main-context-menu-video-copy-link =
    .label = انسخ رابط الڤديو
    .accesskey = س
main-context-menu-audio-copy-link =
    .label = انسخ رابط الصوت
    .accesskey = س
main-context-menu-image-save-as =
    .label = احفظ الصورة باسم…
    .accesskey = ر
main-context-menu-image-email =
    .label = أرسل الصورة بالبريد…
    .accesskey = ص
main-context-menu-image-set-image-as-background =
    .label = اضبط الصورة لتكون خلفية سطح المكتب…
    .accesskey = ض
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
main-context-menu-video-take-snapshot =
    .label = خُذ لقطة…
    .accesskey = خ
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

## The access keys for "Use Saved Login" and "Use Saved Password"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-use-saved-login =
    .label = استعمل جلسة ولوج محفوظة
    .accesskey = ع
main-context-menu-use-saved-password =
    .label = استعمل كلمة سر محفوظة
    .accesskey = ع

##

main-context-menu-suggest-strong-password =
    .label = اقترِح كلمة سر قوية…
    .accesskey = ق
main-context-menu-manage-logins2 =
    .label = أدِر جلسات الولوج
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
main-context-menu-print-selection =
    .label = اطبع المحدّد
    .accesskey = ط
main-context-menu-view-selection-source =
    .label = اعرض مصدر التحديد
    .accesskey = ص
main-context-menu-take-screenshot =
    .label = خُذ لقطة شاشة
    .accesskey = خ
main-context-menu-view-page-source =
    .label = اعرض مصدر هذه الصفحة
    .accesskey = ص
main-context-menu-bidi-switch-text =
    .label = اعكس اتجاه النص
    .accesskey = ن
main-context-menu-bidi-switch-page =
    .label = اعكس اتجاه الصفحة
    .accesskey = ك
main-context-menu-inspect =
    .label = افحص
    .accesskey = ح
main-context-menu-inspect-a11y-properties =
    .label = افحص خصائص الإتاحة
main-context-menu-eme-learn-more =
    .label = اطلع أكثر عن إدارة الحقوق الرقمية…
    .accesskey = د
