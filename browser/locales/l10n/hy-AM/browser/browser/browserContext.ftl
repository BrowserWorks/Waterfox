# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Պտտեք ներքև՝ պատմությունը դիտելու համար
           *[other] Աջ սեղմում կամ պտտում ներքև՝ պատմությունը դիտելու
        }

## Back

main-context-menu-back =
    .tooltiptext = Գնալ Նախորդ Էջ
    .aria-label = Նախորդը
    .accesskey = B

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Գնալ Հաջորդ Էջ
    .aria-label = Հաջորդը
    .accesskey = F

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Կրկին բեռնել
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Ընդհատել
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Պահպանել Էջը որպես…
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Էջանշել այս Էջը
    .accesskey = m
    .tooltiptext = Էջանշել այս էջը

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Էջանշել այս Էջը
    .accesskey = m
    .tooltiptext = Էջանշել այս էջը ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Խմբագրել այս էջանիշը
    .accesskey = m
    .tooltiptext = Խմբագրել այս էջանիշը

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Խմբագրել այս էջանիշը
    .accesskey = m
    .tooltiptext = Խմբագրել այս էջանիշը ({ $shortcut })

main-context-menu-open-link =
    .label = Բացել Հղումը
    .accesskey = Բ

main-context-menu-open-link-new-tab =
    .label = Հղումը Բացել Նոր Ներդիրում
    .accesskey = Բ

main-context-menu-open-link-container-tab =
    .label = Բացել հղումը Նոր Պարունակ Ներդիրում
    .accesskey = դ

main-context-menu-open-link-new-window =
    .label = Հղումը Բացել Նոր Պատուհանում
    .accesskey = Բ

main-context-menu-open-link-new-private-window =
    .label = Բացել հղումը Գաղտնի Դիտարկմամբ
    .accesskey = Դ

main-context-menu-bookmark-this-link =
    .label = էջանշել Այս Հղումը
    .accesskey = Հ

main-context-menu-save-link =
    .label = Պահպանել Հղումը Որպես…
    .accesskey = ո

main-context-menu-save-link-to-pocket =
    .label = Պահպանել հղումը { -pocket-brand-name }-ում
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Պատճենել Էլ. փոստի հասցեն
    .accesskey = Է

main-context-menu-copy-link =
    .label = Պատճենել Հղման Հասցեն
    .accesskey = ց

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Նվագարկել
    .accesskey = Ն

main-context-menu-media-pause =
    .label = Ընդմիջել
    .accesskey = Ը

##

main-context-menu-media-mute =
    .label = Անձայն
    .accesskey = Ա

main-context-menu-media-unmute =
    .label = Ձայնով
    .accesskey = ա

main-context-menu-media-play-speed =
    .label = Նվագարկելու արագություն
    .accesskey = ն

main-context-menu-media-play-speed-slow =
    .label = Դանդաղ (0.5×)
    .accesskey = Դ

main-context-menu-media-play-speed-normal =
    .label = Նորմալ
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = Արագ (1.25×)
    .accesskey = Ա

main-context-menu-media-play-speed-faster =
    .label = Ավելի արագ (1,5×)
    .accesskey = ա

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Անհավանական (2x)
    .accesskey = Ա

main-context-menu-media-loop =
    .label = Օղակում
    .accesskey = Օ

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Ցուցադրել ղեկավարիչներին
    .accesskey = Ց

main-context-menu-media-hide-controls =
    .label = Թաքցնել ղեկավարիչները
    .accesskey = Թ

##

main-context-menu-media-video-fullscreen =
    .label = Բացել Լիաէկրան
    .accesskey = Բ

main-context-menu-media-video-leave-fullscreen =
    .label = Դուրս գալ Լիաէկրան վիճակից
    .accesskey = Լ

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Նկար նկարում
    .accesskey = u

main-context-menu-image-reload =
    .label = Կրկին բեռնել Նկարը
    .accesskey = Կ

main-context-menu-image-view =
    .label = Նայել Նկարը
    .accesskey = Ն

main-context-menu-video-view =
    .label = Դիտել Հոլովակը
    .accesskey = Դ

main-context-menu-image-copy =
    .label = Կրկնօրինակել Նկարը
    .accesskey = ր

main-context-menu-image-copy-location =
    .label = Պատճենել Նկարի Հասցեն
    .accesskey = ա

main-context-menu-video-copy-location =
    .label = Պատճենել Հոլովակի Հասցեն
    .accesskey = ա

main-context-menu-audio-copy-location =
    .label = Պատճենել Ձայնագրության Հասցեն
    .accesskey = ա

main-context-menu-image-save-as =
    .label = Պահպանել Նկարը Որպես…
    .accesskey = պ

main-context-menu-image-email =
    .label = Նկարը ուղարկել էլ. փոստով...
    .accesskey = ա

main-context-menu-image-set-as-background =
    .label = Տեղադրել Աշխատասեղանին…
    .accesskey = Տ

main-context-menu-image-info =
    .label = Տեղեկություն Նկարի Մասին
    .accesskey = Տ

main-context-menu-image-desc =
    .label = Դիտել նկարագրությունը
    .accesskey = ն

main-context-menu-video-save-as =
    .label = Պահպանել Տեսանյութը Որպես...
    .accesskey = լ

main-context-menu-audio-save-as =
    .label = Պահպանել ձայնանյութը որպես...
    .accesskey = պ

main-context-menu-video-image-save-as =
    .label = Պահպանել էկրանի պատկերը որպես...
    .accesskey = Պ

main-context-menu-video-email =
    .label = Տեսանյութը ուղարկել էլ. փոստով...
    .accesskey = ս

main-context-menu-audio-email =
    .label = Ուղարկել էլ. փոստով...
    .accesskey = ր

main-context-menu-plugin-play =
    .label = Ակտիվացնել բաղադրիչը
    .accesskey = կ

main-context-menu-plugin-hide =
    .label = Թաքցնել այս բաղադրիչը
    .accesskey = Թ

main-context-menu-save-to-pocket =
    .label = Պահպանել էջը { -pocket-brand-name }-ում
    .accesskey = k

main-context-menu-send-to-device =
    .label = Ուղարկել էջը սարքին
    .accesskey = ս

main-context-menu-view-background-image =
    .label = Նայել Խորապատկերի Նկարը
    .accesskey = յ

main-context-menu-generate-new-password =
    .label = Օգտագործել ստեղծված գաղտնաբառը…
    .accesskey = G

main-context-menu-keyword =
    .label = Ավելացնել Բանալի այս Որոնմանը…
    .accesskey = Բ

main-context-menu-link-send-to-device =
    .label = Ուղարկել հղումը սարքին
    .accesskey = ս

main-context-menu-frame =
    .label = Այս շրջանակում
    .accesskey = Ա

main-context-menu-frame-show-this =
    .label = Ցուցադրել միայն այս շրջանակը
    .accesskey = Ց

main-context-menu-frame-open-tab =
    .label = Շրջանակը բացել նոր ներդիրում
    .accesskey = Շ

main-context-menu-frame-open-window =
    .label = Շրջանակը բացել նոր պատուհանում
    .accesskey = Շ

main-context-menu-frame-reload =
    .label = Կրկին բեռնել շրջանակը
    .accesskey = Կ

main-context-menu-frame-bookmark =
    .label = Էջանշել Այս շրջանակը
    .accesskey = շ

main-context-menu-frame-save-as =
    .label = Պահպանել շրջանակը որպես…
    .accesskey = Պ

main-context-menu-frame-print =
    .label = Տպել շրջանակը…
    .accesskey = Տ

main-context-menu-frame-view-source =
    .label = Դիտել շրջանակը
    .accesskey = Դ

main-context-menu-frame-view-info =
    .label = Տեղեկություն շրջանակի մասին
    .accesskey = Տ

main-context-menu-view-selection-source =
    .label = Դիտել Նշված Մասի Կոդը
    .accesskey = e

main-context-menu-view-page-source =
    .label = Դիտել Էջի Կոդը
    .accesskey = Դ

main-context-menu-view-page-info =
    .label = Էջի Մասին Տվյալներ
    .accesskey = Տ

main-context-menu-bidi-switch-text =
    .label = Փոխել Տեքստի Ուղղությունը
    .accesskey = ո

main-context-menu-bidi-switch-page =
    .label = Փոխել Էջի Ուղղությունը
    .accesskey = Ո

main-context-menu-inspect-element =
    .label = Զննել տարրը
    .accesskey = Q

main-context-menu-inspect-a11y-properties =
    .label = Ստուգել մատչելիության հատկությունները

main-context-menu-eme-learn-more =
    .label = Իմանալ ավելին DRM-ի մասին...
    .accesskey = D

