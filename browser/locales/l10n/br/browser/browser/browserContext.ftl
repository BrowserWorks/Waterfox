# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Sachit etrezek an traoñ evit diskouez ar roll istor
           *[other] Grit ur c'hlik dehou pe sachit etrezek an traoñ evit diskouez ar roll istor
        }

## Back

main-context-menu-back =
    .tooltiptext = Mont d'ar bajennad kent
    .aria-label = Kent
    .accesskey = K
navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }
toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Mont d'ar bajennad war-lerc'h
    .aria-label = War-lerc'h
    .accesskey = W
navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }
toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Adkargañ
    .accesskey = A
toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Paouez
    .accesskey = P
toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Enrollañ ar bajenn evel…
    .accesskey = b
toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Lakaat ur sined war ar bajenn-mañ
    .accesskey = b
    .tooltiptext = Lakaat ur sined war ar bajenn-mañ
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Lakaat ur sined war ar bajenn-mañ
    .accesskey = b
    .tooltiptext = Lakaat ur sined war ar bajenn-mañ ({ $shortcut })
main-context-menu-bookmark-change =
    .aria-label = Embann ar sined-mañ
    .accesskey = b
    .tooltiptext = Embann ar sined-mañ
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Embann ar sined-mañ
    .accesskey = b
    .tooltiptext = Embann ar sined-mañ ({ $shortcut })
main-context-menu-open-link =
    .label = Digeriñ an ere
    .accesskey = g
main-context-menu-open-link-new-tab =
    .label = Digeriñ an ere e-barzh un ivinell nevez
    .accesskey = i
main-context-menu-open-link-container-tab =
    .label = Digeriñ an ere en un ivinell endalc'her nevez
    .accesskey = c
main-context-menu-open-link-new-window =
    .label = Digeriñ an ere e-barzh ur prenestr nevez
    .accesskey = b
main-context-menu-open-link-new-private-window =
    .label = Digeriñ an ere e-barzh ur prenestr merdeiñ prevez nevez
    .accesskey = m
main-context-menu-bookmark-this-link =
    .label = Lakaat ur sined war an ere
    .accesskey = L
main-context-menu-save-link =
    .label = Enrollañ an ere evel…
    .accesskey = n
main-context-menu-save-link-to-pocket =
    .label = Enrollañ an ere etrezek { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Eilañ ar chomlec'h postel
    .accesskey = p
main-context-menu-copy-link =
    .label = Eilañ lec'hiadur an ere
    .accesskey = l

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Lenn
    .accesskey = L
main-context-menu-media-pause =
    .label = Ehan
    .accesskey = E

##

main-context-menu-media-mute =
    .label = Mud
    .accesskey = M
main-context-menu-media-unmute =
    .label = Heglev
    .accesskey = H
main-context-menu-media-play-speed =
    .label = Tizh lenn
    .accesskey = l
main-context-menu-media-play-speed-slow =
    .label = Gorrek (0.5×)
    .accesskey = G
main-context-menu-media-play-speed-normal =
    .label = Reizh
    .accesskey = R
main-context-menu-media-play-speed-fast =
    .label = Herrek (1.25×)
    .accesskey = H
main-context-menu-media-play-speed-faster =
    .label = Herrekoc'h (1.5×)
    .accesskey = e
# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Tizh divuzul (2×)
    .accesskey = d
main-context-menu-media-loop =
    .label = Dol
    .accesskey = D

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Diskouez ar reolerezhioù
    .accesskey = D
main-context-menu-media-hide-controls =
    .label = Kuzhat ar reolerezhioù
    .accesskey = u

##

main-context-menu-media-video-fullscreen =
    .label = Skramm a-bezh
    .accesskey = S
main-context-menu-media-video-leave-fullscreen =
    .label = Kuitaat ar mod skramm a-bezh
    .accesskey = u
# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Skeudenn-ouzh-skeudenn
    .accesskey = S
main-context-menu-image-reload =
    .label = Adkargañ ar skeudenn
    .accesskey = r
main-context-menu-image-view =
    .label = Gwelout ar skeudenn
    .accesskey = s
main-context-menu-video-view =
    .label = Gwelout ar video
    .accesskey = i
main-context-menu-image-copy =
    .label = Eilañ ar skeudenn
    .accesskey = r
main-context-menu-image-copy-location =
    .label = Eilañ lec'hiadur ar skeudenn
    .accesskey = k
main-context-menu-video-copy-location =
    .label = Eilañ lec'hiadur ar video
    .accesskey = o
main-context-menu-audio-copy-location =
    .label = Eilañ lec'hiadur ar restr klevet
    .accesskey = E
main-context-menu-image-save-as =
    .label = Enrollañ ar skeudenn evel…
    .accesskey = v
main-context-menu-image-email =
    .label = Kas ar skeudenn dre bostel…
    .accesskey = K
main-context-menu-image-set-as-background =
    .label = Arventennañ evel Drekleur ar burev…
    .accesskey = l
main-context-menu-image-info =
    .label = Gwelout stlennoù ar skeudenn
    .accesskey = w
main-context-menu-image-desc =
    .label = Gwelout an deskrivadur
    .accesskey = d
main-context-menu-video-save-as =
    .label = Enrollañ ar video evel…
    .accesskey = v
main-context-menu-audio-save-as =
    .label = Enrollañ ar restr klevet evel…
    .accesskey = v
main-context-menu-video-image-save-as =
    .label = Enrollañ an dapadenn-skramm evel…
    .accesskey = n
main-context-menu-video-email =
    .label = Kas ar video dre bostel…
    .accesskey = K
main-context-menu-audio-email =
    .label = Kas ar restr klevet dre bostel…
    .accesskey = K
main-context-menu-plugin-play =
    .label = Gweredekaat an enlugellad-mañ
    .accesskey = w
main-context-menu-plugin-hide =
    .label = Kuzhat an enlugellad-mañ
    .accesskey = u
main-context-menu-save-to-pocket =
    .label = Enrollañ ar bajenn etrezek { -pocket-brand-name }
    .accesskey = k
main-context-menu-send-to-device =
    .label = Kas ar bajenn d'an trevnad
    .accesskey = t
main-context-menu-view-background-image =
    .label = Gwelout ar skeudenn drekleur
    .accesskey = d
main-context-menu-generate-new-password =
    .label = Arverañ ur ger-tremen azganet…
    .accesskey = A
main-context-menu-keyword =
    .label = Ouzhpennañ ur ger-alc'hwez evit ar c'hlask-mañ …
    .accesskey = k
main-context-menu-link-send-to-device =
    .label = Kas an ere d'an trevnad
    .accesskey = t
main-context-menu-frame =
    .label = Ar frammad-se
    .accesskey = f
main-context-menu-frame-show-this =
    .label = Gwelout ar frammad-mañ hepken
    .accesskey = f
main-context-menu-frame-open-tab =
    .label = Digeriñ ar frammad e-barzh un ivinell nevez
    .accesskey = i
main-context-menu-frame-open-window =
    .label = Digeriñ ar frammad e-barzh ur prenestr nevez
    .accesskey = p
main-context-menu-frame-reload =
    .label = Adkargañ ar frammad
    .accesskey = k
main-context-menu-frame-bookmark =
    .label = Merkañ ar frammad war ur sined
    .accesskey = M
main-context-menu-frame-save-as =
    .label = Enrollañ ar frammad evel…
    .accesskey = f
main-context-menu-frame-print =
    .label = Moullañ ar frammad…
    .accesskey = l
main-context-menu-frame-view-source =
    .label = Gwelout tarzh ar frammad
    .accesskey = t
main-context-menu-frame-view-info =
    .label = Gwelout stlennoù ar frammad
    .accesskey = t
main-context-menu-view-selection-source =
    .label = Gwelout tarzh an diuzad
    .accesskey = e
main-context-menu-view-page-source =
    .label = Gwelout tarzh ar bajennad
    .accesskey = t
main-context-menu-view-page-info =
    .label = Gwelout stlennoù ar bajennad
    .accesskey = t
main-context-menu-bidi-switch-text =
    .label = Kemmañ tuadur an destenn
    .accesskey = d
main-context-menu-bidi-switch-page =
    .label = Kemmañ tu ar bajenn
    .accesskey = b
main-context-menu-inspect-element =
    .label = Ensellout an elfenn
    .accesskey = E
main-context-menu-inspect-a11y-properties =
    .label = Ensellout ar perzhioù haezadusted
main-context-menu-eme-learn-more =
    .label = Gouzout hiroc'h diwar-benn an DRM...
    .accesskey = D
