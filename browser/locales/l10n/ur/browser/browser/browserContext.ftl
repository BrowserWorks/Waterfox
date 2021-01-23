# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] سابقات دکھانے کے لیے نیچے کھینچیں
           *[other] سابقات دکھانے کے لیے دایاں کلک کریں یا نیچے کھینچیں
        }

## Back

main-context-menu-back =
    .tooltiptext = ایک صفحہ واپس جائیں
    .aria-label = واپس
    .accesskey = B

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = ایک صفحہ آگے جائیں
    .aria-label = آگے
    .accesskey = F

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = پھر لوڈ کریں
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = رکیں
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = صفحہ محفوظ کریں بطور…
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = یہ صفحہ نشان زد کریں
    .accesskey = m
    .tooltiptext = یہ صفحہ نشان زد کریں

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = یہ صفحہ نشان زد کریں
    .accesskey = m
    .tooltiptext = یہ صفحہ نشان زد کریں ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = اس بک مارک کی تدوین کریں
    .accesskey = m
    .tooltiptext = یہ بک مارک تدوین کریں

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = اس بک مارک کی تدوین کریں
    .accesskey = m
    .tooltiptext = یہ بک مارک تدوین کریں ({ $shortcut })

main-context-menu-open-link =
    .label = ربط کھولیں
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = ربط نئی ٹیب میں کھولیں
    .accesskey = T

main-context-menu-open-link-container-tab =
    .label = ربط کو نئے حامل ٹیب میں کھولیں
    .accesskey = b

main-context-menu-open-link-new-window =
    .label = ربط نئے دریچے میں کھولیں
    .accesskey = W

main-context-menu-open-link-new-private-window =
    .label = ربط نئے نجی دریچے میں کھولیں
    .accesskey = P

main-context-menu-bookmark-this-link =
    .label = یہ ربط نشان زد کریں
    .accesskey = L

main-context-menu-save-link =
    .label = ربط محفوظ کریں بطور ...
    .accesskey = k

main-context-menu-save-link-to-pocket =
    .label = { -pocket-brand-name } میں ربط محفوظ کریں
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = ای میل پتہ نقل کریں
    .accesskey = A

main-context-menu-copy-link =
    .label = ربط محل وقوع نقل کریں
    .accesskey = a

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = چلائیں
    .accesskey = P

main-context-menu-media-pause =
    .label = توقف کریں
    .accesskey = P

##

main-context-menu-media-mute =
    .label = خاموش
    .accesskey = M

main-context-menu-media-unmute =
    .label = انمیوٹ
    .accesskey = m

main-context-menu-media-play-speed =
    .label = چلنے کی رفتار
    .accesskey = d

main-context-menu-media-play-speed-slow =
    .label = (0.5×) گنا اہستہ
    .accesskey = S

main-context-menu-media-play-speed-normal =
    .label = عام
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = (1.25×) گنا تیز
    .accesskey = F

main-context-menu-media-play-speed-faster =
    .label = تیز تر (1.5×)
    .accesskey = a

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Ludicrous (2×)
    .accesskey = L

main-context-menu-media-loop =
    .label = دہراؤ
    .accesskey = L

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = کنٹرول دکھائیں
    .accesskey = C

main-context-menu-media-hide-controls =
    .label = کنٹرول چھبائیں
    .accesskey = C

##

main-context-menu-media-video-fullscreen =
    .label = پوری سکرین
    .accesskey = F

main-context-menu-media-video-leave-fullscreen =
    .label = پوری سکرین سے باہر نکلیں
    .accesskey = u

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = تصویر-میں-تصویر
    .accesskey = u

main-context-menu-image-reload =
    .label = نقش پھر لوڈ کریں
    .accesskey = R

main-context-menu-image-view =
    .label = نقش نظارہ کریں
    .accesskey = I

main-context-menu-video-view =
    .label = وڈیو دیکھیں
    .accesskey = I

main-context-menu-image-copy =
    .label = نقش نقل کریں
    .accesskey = y

main-context-menu-image-copy-location =
    .label = نقش محل وقوع نقل کریں
    .accesskey = o

main-context-menu-video-copy-location =
    .label = وڈیو محل وقوع نقل کریں
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = سمعی محل وقوع نقل کریں
    .accesskey = o

main-context-menu-image-save-as =
    .label = نقش محفوظ کریں بطور ...
    .accesskey = v

main-context-menu-image-email =
    .label = نقش ای میل کریں…
    .accesskey = g

main-context-menu-image-set-as-background =
    .label = ڈیسک ٹاپ پس منظر کے طور پر سیٹ کریں ...
    .accesskey = S

main-context-menu-image-info =
    .label = صفحہ معلومات نظارہ کریں
    .accesskey = f

main-context-menu-image-desc =
    .label = تصریح دیکھیں
    .accesskey = D

main-context-menu-video-save-as =
    .label = وڈیو محفوظ کریں بطور…
    .accesskey = v

main-context-menu-audio-save-as =
    .label = آڈیو محفوظ کریں بطور…
    .accesskey = v

main-context-menu-video-image-save-as =
    .label = سنیپ شاٹ محفوظ کریں بطور…
    .accesskey = S

main-context-menu-video-email =
    .label = وڈیو ای میل کریں…
    .accesskey = a

main-context-menu-audio-email =
    .label = آڈیو ای میل کریں…
    .accesskey = a

main-context-menu-plugin-play =
    .label = اس پلگ ان کو متحرک کریں
    .accesskey = c

main-context-menu-plugin-hide =
    .label = اس پلگ ان کو چھپائیں
    .accesskey = H

main-context-menu-save-to-pocket =
    .label = { -pocket-brand-name } میں صفحہ محفوظ کریں
    .accesskey = k

main-context-menu-send-to-device =
    .label = صفحہ کو آلہ پر ارسال کریں
    .accesskey = n

main-context-menu-view-background-image =
    .label = پس منظر نقش نظارہ کریں
    .accesskey = w

main-context-menu-generate-new-password =
    .label = تیار کردہ پاس ورڈ کا استعمال کریں…
    .accesskey = G

main-context-menu-keyword =
    .label = اس تلاش کے لیے کلیدی لفظ ڈالیں…
    .accesskey = K

main-context-menu-link-send-to-device =
    .label = ربط کو آلہ پر ارسال کریں
    .accesskey = n

main-context-menu-frame =
    .label = یہ فریم
    .accesskey = h

main-context-menu-frame-show-this =
    .label = صرف یہ فریم دکھائیں
    .accesskey = S

main-context-menu-frame-open-tab =
    .label = فریم نئی ٹیب میں کھولیں
    .accesskey = T

main-context-menu-frame-open-window =
    .label = فریم نئے دریچے میں کھولیں
    .accesskey = W

main-context-menu-frame-reload =
    .label = فریم پھر لوڈ کریں
    .accesskey = R

main-context-menu-frame-bookmark =
    .label = یہ فریم نشان زد کریں
    .accesskey = m

main-context-menu-frame-save-as =
    .label = فریم محفوظ کریں بطو ر...
    .accesskey = F

main-context-menu-frame-print =
    .label = فریم چھاپیں ...
    .accesskey = P

main-context-menu-frame-view-source =
    .label = فریم ماخذ نظارہ کریں
    .accesskey = V

main-context-menu-frame-view-info =
    .label = فریم معلومات نظارہ کریں
    .accesskey = I

main-context-menu-view-selection-source =
    .label = انتخاب ماخذ نظارہ کریں
    .accesskey = e

main-context-menu-view-page-source =
    .label = صفحہ ماخذ نظارہ کریں
    .accesskey = V

main-context-menu-view-page-info =
    .label = صفحہ معلومات نظارہ کریں
    .accesskey = I

main-context-menu-bidi-switch-text =
    .label = متن کی سمت بدلیں کریں
    .accesskey = w

main-context-menu-bidi-switch-page =
    .label = صفحے کی سمت تبدیل کریں
    .accesskey = D

main-context-menu-inspect-element =
    .label = عناصر چیک کریں
    .accesskey = Q

main-context-menu-inspect-a11y-properties =
    .label = رسائی کی خصوصیات کا معائنہ کریں

main-context-menu-eme-learn-more =
    .label = DRM کے بارے میں مزید سیکھیں
    .accesskey = D

