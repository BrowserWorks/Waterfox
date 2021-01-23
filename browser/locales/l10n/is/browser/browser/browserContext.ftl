# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Flettu niður til að sýna feril
           *[other] Hægri smelltu eða flettu niður til að sýna feril
        }

## Back

main-context-menu-back =
    .tooltiptext = Til baka um eina síðu
    .aria-label = Til baka
    .accesskey = B

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Áfram um eina síðu
    .aria-label = Áfram
    .accesskey = F

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Endurnýja
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Stöðva
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Vista síðu sem…
    .accesskey = V

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Setja síðu í bókamerki
    .accesskey = m
    .tooltiptext = Setja síðu í bókamerki

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Setja síðu í bókamerki
    .accesskey = m
    .tooltiptext = Setja síðu í bókamerki ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Breyta bókamerki
    .accesskey = m
    .tooltiptext = Breyta bókamerki

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Breyta bókamerki
    .accesskey = m
    .tooltiptext = Breyta bókamerki ({ $shortcut })

main-context-menu-open-link =
    .label = Opna tengil
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = Opna tengil í nýjum flipa
    .accesskey = f

main-context-menu-open-link-container-tab =
    .label = Opna tengil í nýjum hópaflipa
    .accesskey = d

main-context-menu-open-link-new-window =
    .label = Opna tengil í nýjum glugga
    .accesskey = g

main-context-menu-open-link-new-private-window =
    .label = Opna tengil í nýjum huliðsglugga
    .accesskey = p

main-context-menu-bookmark-this-link =
    .label = Setja tengil í bókamerki
    .accesskey = l

main-context-menu-save-link =
    .label = Vista tengil sem…
    .accesskey = V

main-context-menu-save-link-to-pocket =
    .label = Vista tengil í { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Afrita póstfang
    .accesskey = p

main-context-menu-copy-link =
    .label = Afrita tengil
    .accesskey = r

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Spila
    .accesskey = S

main-context-menu-media-pause =
    .label = Í bið
    .accesskey = b

##

main-context-menu-media-mute =
    .label = Hljóðlaus
    .accesskey = H

main-context-menu-media-unmute =
    .label = Virkja hljóð
    .accesskey = h

main-context-menu-media-play-speed =
    .label = Spilunarhraði
    .accesskey = l

main-context-menu-media-play-speed-slow =
    .label = Hægt (0.5×)
    .accesskey = H

main-context-menu-media-play-speed-normal =
    .label = Venjulegt
    .accesskey = n

main-context-menu-media-play-speed-fast =
    .label = Hratt(1.25×)
    .accesskey = r

main-context-menu-media-play-speed-faster =
    .label = Hraðara (1.5×)
    .accesskey = a

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Fáránlega hratt (2×)
    .accesskey = l

main-context-menu-media-loop =
    .label = Endurtaka
    .accesskey = E

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Sýna stjórntæki
    .accesskey = n

main-context-menu-media-hide-controls =
    .label = Fela stjórntæki
    .accesskey = F

##

main-context-menu-media-video-fullscreen =
    .label = Fylla skjá
    .accesskey = F

main-context-menu-media-video-leave-fullscreen =
    .label = Hætta í fullum skjá
    .accesskey = u

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Mynd-í-mynd
    .accesskey = u

main-context-menu-image-reload =
    .label = Endurlesa mynd
    .accesskey = r

main-context-menu-image-view =
    .label = Sjá mynd
    .accesskey = m

main-context-menu-video-view =
    .label = Skoða myndband
    .accesskey = k

main-context-menu-image-copy =
    .label = Afrita mynd
    .accesskey = y

main-context-menu-image-copy-location =
    .label = Afrita staðsetningu myndar
    .accesskey = s

main-context-menu-video-copy-location =
    .label = Afrita myndbandatengil
    .accesskey = m

main-context-menu-audio-copy-location =
    .label = Afrita hljóðtengil
    .accesskey = h

main-context-menu-image-save-as =
    .label = Vista mynd sem…
    .accesskey = V

main-context-menu-image-email =
    .label = Senda mynd…
    .accesskey = a

main-context-menu-image-set-as-background =
    .label = Setja sem bakgrunnsmynd…
    .accesskey = S

main-context-menu-image-info =
    .label = Skoða upplýsingar um mynd
    .accesskey = u

main-context-menu-image-desc =
    .label = Lýsing á yfirliti
    .accesskey = y

main-context-menu-video-save-as =
    .label = Vista myndband sem…
    .accesskey = V

main-context-menu-audio-save-as =
    .label = Vista hljóð sem…
    .accesskey = V

main-context-menu-video-image-save-as =
    .label = Vista skjámynd sem…
    .accesskey = s

main-context-menu-video-email =
    .label = Senda myndband…
    .accesskey = a

main-context-menu-audio-email =
    .label = Senda hljóðskrá…
    .accesskey = a

main-context-menu-plugin-play =
    .label = Gera þessa viðbót virka
    .accesskey = G

main-context-menu-plugin-hide =
    .label = Fela þetta tengiforrit
    .accesskey = F

main-context-menu-save-to-pocket =
    .label = Vista síðu í { -pocket-brand-name }
    .accesskey = k

main-context-menu-send-to-device =
    .label = Senda síðu á tæki
    .accesskey = æ

main-context-menu-view-background-image =
    .label = Sjá bakgrunnsmynd
    .accesskey = g

main-context-menu-keyword =
    .label = Bæta við orði í leit…
    .accesskey = o

main-context-menu-link-send-to-device =
    .label = Senda tengil á tæki
    .accesskey = æ

main-context-menu-frame =
    .label = Þessi rammi
    .accesskey = Þ

main-context-menu-frame-show-this =
    .label = Sýna einungis þennan ramma
    .accesskey = S

main-context-menu-frame-open-tab =
    .label = Opna ramma í nýjum flipa
    .accesskey = f

main-context-menu-frame-open-window =
    .label = Opna ramma í nýjum glugga
    .accesskey = g

main-context-menu-frame-reload =
    .label = Endurnýja ramma
    .accesskey = r

main-context-menu-frame-bookmark =
    .label = Setja ramma í bókamerki
    .accesskey = m

main-context-menu-frame-save-as =
    .label = Vista ramma sem…
    .accesskey = a

main-context-menu-frame-print =
    .label = Prenta ramma…
    .accesskey = P

main-context-menu-frame-view-source =
    .label = Sýna frumkóða ramma
    .accesskey = k

main-context-menu-frame-view-info =
    .label = Skoða upplýsingar ramma
    .accesskey = i

main-context-menu-view-selection-source =
    .label = Sýna frumkóða vals
    .accesskey = n

main-context-menu-view-page-source =
    .label = Sýna frumkóða síðu
    .accesskey = k

main-context-menu-view-page-info =
    .label = Skoða upplýsingar síðu
    .accesskey = i

main-context-menu-bidi-switch-text =
    .label = Skipta um texta átt
    .accesskey = t

main-context-menu-bidi-switch-page =
    .label = Skipta um síðu átt
    .accesskey = s

main-context-menu-inspect-element =
    .label = Skoða einindi
    .accesskey = e

main-context-menu-inspect-a11y-properties =
    .label = Skoða aðgengiseiginleika

main-context-menu-eme-learn-more =
    .label = Vita meira um DRM…
    .accesskey = D

