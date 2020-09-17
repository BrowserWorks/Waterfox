# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Ekarri behera historia erakusteko
           *[other] Egin eskuin-klika edo ekarri behera historia erakusteko
        }

## Back

main-context-menu-back =
    .tooltiptext = Joan orri bat atzera
    .aria-label = Atzera
    .accesskey = z

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Joan orri bat aurrera
    .aria-label = Aurrera
    .accesskey = A

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Berritu
    .accesskey = r

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Gelditu
    .accesskey = G

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Gorde orria honela…
    .accesskey = G

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Egin orri honen laster-marka
    .accesskey = E
    .tooltiptext = Egin orri honen laster-marka

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Egin orri honen laster-marka
    .accesskey = E
    .tooltiptext = Egin orri honen laster-marka ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Editatu laster-marka
    .accesskey = E
    .tooltiptext = Editatu laster-marka

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Editatu laster-marka
    .accesskey = E
    .tooltiptext = Editatu laster-marka ({ $shortcut })

main-context-menu-open-link =
    .label = Ireki lotura
    .accesskey = I

main-context-menu-open-link-new-tab =
    .label = Ireki fitxa berrian
    .accesskey = t

main-context-menu-open-link-container-tab =
    .label = Ireki lotura edukiontzi-fitxa berrian
    .accesskey = b

main-context-menu-open-link-new-window =
    .label = Ireki leiho berrian
    .accesskey = l

main-context-menu-open-link-new-private-window =
    .label = Ireki lotura leiho pribatu berrian
    .accesskey = p

main-context-menu-bookmark-this-link =
    .label = Egin lotura honen laster-marka
    .accesskey = l

main-context-menu-save-link =
    .label = Gorde lotura honela…
    .accesskey = G

main-context-menu-save-link-to-pocket =
    .label = Gorde lotura { -pocket-brand-name }-en
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Kopiatu helbide elektronikoa
    .accesskey = e

main-context-menu-copy-link =
    .label = Kopiatu loturaren helbidea
    .accesskey = K

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Erreproduzitu
    .accesskey = p

main-context-menu-media-pause =
    .label = Pausatu
    .accesskey = P

##

main-context-menu-media-mute =
    .label = Mututu
    .accesskey = M

main-context-menu-media-unmute =
    .label = Ez mututu
    .accesskey = m

main-context-menu-media-play-speed =
    .label = Erreprodukzio-abiadura
    .accesskey = b

main-context-menu-media-play-speed-slow =
    .label = Motela (0,5×)
    .accesskey = M

main-context-menu-media-play-speed-normal =
    .label = Arrunta
    .accesskey = A

main-context-menu-media-play-speed-fast =
    .label = Azkarra (1,25×)
    .accesskey = z

main-context-menu-media-play-speed-faster =
    .label = Azkarragoa (1,5×)
    .accesskey = r

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Abiadura bizia (2×)
    .accesskey = b

main-context-menu-media-loop =
    .label = Begizta
    .accesskey = B

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Erakutsi kontrolak
    .accesskey = k

main-context-menu-media-hide-controls =
    .label = Ezkutatu kontrolak
    .accesskey = k

##

main-context-menu-media-video-fullscreen =
    .label = Pantaila osoa
    .accesskey = P

main-context-menu-media-video-leave-fullscreen =
    .label = Irten pantaila osotik
    .accesskey = s

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Bideoa beste leiho batean
    .accesskey = b

main-context-menu-image-reload =
    .label = Berritu irudia
    .accesskey = r

main-context-menu-image-view =
    .label = Ikusi irudia
    .accesskey = I

main-context-menu-video-view =
    .label = Ikusi bideoa
    .accesskey = k

main-context-menu-image-copy =
    .label = Kopiatu irudia
    .accesskey = K

main-context-menu-image-copy-location =
    .label = Kopiatu irudiaren helbidea
    .accesskey = o

main-context-menu-video-copy-location =
    .label = Kopiatu bideoaren helbidea
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = Kopiatu audioaren helbidea
    .accesskey = o

main-context-menu-image-save-as =
    .label = Gorde irudia honela…
    .accesskey = G

main-context-menu-image-email =
    .label = Bidali irudia postaz…
    .accesskey = a

main-context-menu-image-set-as-background =
    .label = Jarri idazmahaiaren atzeko planoan…
    .accesskey = J

main-context-menu-image-info =
    .label = Ikusi irudiaren informazioa
    .accesskey = f

main-context-menu-image-desc =
    .label = Ikusi deskribapena
    .accesskey = d

main-context-menu-video-save-as =
    .label = Gorde bideoa honela…
    .accesskey = b

main-context-menu-audio-save-as =
    .label = Gorde audioa honela…
    .accesskey = r

main-context-menu-video-image-save-as =
    .label = Gorde argazkia honela…
    .accesskey = G

main-context-menu-video-email =
    .label = Bidali bideoa postaz…
    .accesskey = a

main-context-menu-audio-email =
    .label = Bidali audioa postaz…
    .accesskey = a

main-context-menu-plugin-play =
    .label = Aktibatu plugin hau
    .accesskey = k

main-context-menu-plugin-hide =
    .label = Ezkutatu plugin hau
    .accesskey = E

main-context-menu-save-to-pocket =
    .label = Gorde orria { -pocket-brand-name }-en
    .accesskey = k

main-context-menu-send-to-device =
    .label = Bidali orria gailura
    .accesskey = g

main-context-menu-view-background-image =
    .label = Ikusi atzeko planoko irudia
    .accesskey = a

main-context-menu-generate-new-password =
    .label = Erabili sortutako pasahitza…
    .accesskey = s

main-context-menu-keyword =
    .label = Gehitu bilaketa honentzat gako-hitza…
    .accesskey = k

main-context-menu-link-send-to-device =
    .label = Bidali lotura gailura
    .accesskey = g

main-context-menu-frame =
    .label = Marko hau
    .accesskey = h

main-context-menu-frame-show-this =
    .label = Erakutsi marko hau bakarrik
    .accesskey = b

main-context-menu-frame-open-tab =
    .label = Ireki markoa fitxa berrian
    .accesskey = t

main-context-menu-frame-open-window =
    .label = Ireki markoa leiho berrian
    .accesskey = m

main-context-menu-frame-reload =
    .label = Berritu markoa
    .accesskey = r

main-context-menu-frame-bookmark =
    .label = Egin marko honen laster-marka
    .accesskey = m

main-context-menu-frame-save-as =
    .label = Gorde markoa honela…
    .accesskey = m

main-context-menu-frame-print =
    .label = Inprimatu markoa…
    .accesskey = p

main-context-menu-frame-view-source =
    .label = Ikusi markoaren iturburua
    .accesskey = m

main-context-menu-frame-view-info =
    .label = Ikusi markoaren informazioa
    .accesskey = u

main-context-menu-view-selection-source =
    .label = Ikusi aukeraren iturburua
    .accesskey = u

main-context-menu-view-page-source =
    .label = Ikusi orriaren iturburua
    .accesskey = o

main-context-menu-view-page-info =
    .label = Ikusi orriaren informazioa
    .accesskey = I

main-context-menu-bidi-switch-text =
    .label = Aldatu testuaren norabidea
    .accesskey = t

main-context-menu-bidi-switch-page =
    .label = Aldatu orriaren norabidea
    .accesskey = n

main-context-menu-inspect-element =
    .label = Ikuskatu elementua
    .accesskey = s

main-context-menu-inspect-a11y-properties =
    .label = Ikuskatu erabilgarritasun-propietateak

main-context-menu-eme-learn-more =
    .label = DRMri buruzko argibide gehiago…
    .accesskey = D
