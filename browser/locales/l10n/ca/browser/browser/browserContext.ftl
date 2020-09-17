# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Arrossegueu cap avall per veure l'historial
           *[other] Premeu amb el botó dret o arrossegueu cap avall per veure l'historial
        }

## Back

main-context-menu-back =
    .tooltiptext = Vés una pàgina enrere
    .aria-label = Enrere
    .accesskey = r

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Vés una pàgina endavant
    .aria-label = Endavant
    .accesskey = d

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Actualitza
    .accesskey = z

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Atura
    .accesskey = A

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Anomena i desa la pàgina…
    .accesskey = d

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Afegeix la pàgina a les adreces d'interès
    .accesskey = d
    .tooltiptext = Afegeix la pàgina a les adreces d'interès

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Afegeix la pàgina a les adreces d'interès
    .accesskey = d
    .tooltiptext = Afegeix la pàgina a les adreces d'interès ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Edita aquesta adreça d'interès
    .accesskey = d
    .tooltiptext = Edita l'adreça d'interès

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Edita aquesta adreça d'interès
    .accesskey = d
    .tooltiptext = Edita l'adreça d'interès ({ $shortcut })

main-context-menu-open-link =
    .label = Obre l'enllaç
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = Obre l'enllaç en una pestanya nova
    .accesskey = t

main-context-menu-open-link-container-tab =
    .label = Obre l'enllaç en una pestanya de contenidor nova
    .accesskey = b

main-context-menu-open-link-new-window =
    .label = Obre l'enllaç en una finestra nova
    .accesskey = f

main-context-menu-open-link-new-private-window =
    .label = Obre l'enllaç en una finestra privada nova
    .accesskey = p

main-context-menu-bookmark-this-link =
    .label = Afegeix l'enllaç a les adreces d'interès
    .accesskey = l

main-context-menu-save-link =
    .label = Anomena i desa el contingut de l'enllaç…
    .accesskey = s

main-context-menu-save-link-to-pocket =
    .label = Desa l'enllaç al { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Copia l'adreça electrònica
    .accesskey = e

main-context-menu-copy-link =
    .label = Copia l'enllaç
    .accesskey = C

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Reprodueix
    .accesskey = R

main-context-menu-media-pause =
    .label = Pausa
    .accesskey = P

##

main-context-menu-media-mute =
    .label = Silencia
    .accesskey = S

main-context-menu-media-unmute =
    .label = No silenciïs
    .accesskey = s

main-context-menu-media-play-speed =
    .label = Velocitat de reproducció
    .accesskey = l

main-context-menu-media-play-speed-slow =
    .label = Lent (0,5x)
    .accesskey = L

main-context-menu-media-play-speed-normal =
    .label = Normal
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = Ràpid (1,25x)
    .accesskey = R

main-context-menu-media-play-speed-faster =
    .label = Més ràpid (1,5x)
    .accesskey = s

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Màxima velocitat (×2)
    .accesskey = M

main-context-menu-media-loop =
    .label = Repetició
    .accesskey = R

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Mostra els controls
    .accesskey = c

main-context-menu-media-hide-controls =
    .label = Amaga els controls
    .accesskey = c

##

main-context-menu-media-video-fullscreen =
    .label = Pantalla completa
    .accesskey = P

main-context-menu-media-video-leave-fullscreen =
    .label = Surt de la pantalla completa
    .accesskey = p

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Imatge sobre imatge
    .accesskey = I

main-context-menu-image-reload =
    .label = Recarrega la imatge
    .accesskey = R

main-context-menu-image-view =
    .label = Visualitza la imatge
    .accesskey = i

main-context-menu-video-view =
    .label = Visualitza el vídeo
    .accesskey = i

main-context-menu-image-copy =
    .label = Copia la imatge
    .accesskey = m

main-context-menu-image-copy-location =
    .label = Copia la ubicació de la imatge
    .accesskey = o

main-context-menu-video-copy-location =
    .label = Copia la ubicació del vídeo
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = Copia la ubicació de l'àudio
    .accesskey = o

main-context-menu-image-save-as =
    .label = Anomena i desa la imatge…
    .accesskey = A

main-context-menu-image-email =
    .label = Envia la imatge per correu…
    .accesskey = a

main-context-menu-image-set-as-background =
    .label = Defineix com a fons d'escriptori…
    .accesskey = D

main-context-menu-image-info =
    .label = Visualitza la informació de la imatge
    .accesskey = f

main-context-menu-image-desc =
    .label = Visualitza la descripció
    .accesskey = d

main-context-menu-video-save-as =
    .label = Anomena i desa el vídeo…
    .accesskey = v

main-context-menu-audio-save-as =
    .label = Anomena i desa l'àudio…
    .accesskey = u

main-context-menu-video-image-save-as =
    .label = Anomena i desa una instantània…
    .accesskey = s

main-context-menu-video-email =
    .label = Envia el vídeo per correu…
    .accesskey = a

main-context-menu-audio-email =
    .label = Envia l'àudio per correu…
    .accesskey = a

main-context-menu-plugin-play =
    .label = Activa aquest connector
    .accesskey = c

main-context-menu-plugin-hide =
    .label = Amaga aquest connector
    .accesskey = m

main-context-menu-save-to-pocket =
    .label = Desa la pàgina al { -pocket-brand-name }
    .accesskey = k

main-context-menu-send-to-device =
    .label = Envia la pàgina al dispositiu
    .accesskey = d

main-context-menu-view-background-image =
    .label = Visualitza la imatge de fons
    .accesskey = n

main-context-menu-generate-new-password =
    .label = Utilitza una contrasenya generada…
    .accesskey = g

main-context-menu-keyword =
    .label = Afegeix una paraula clau per a aquesta cerca…
    .accesskey = p

main-context-menu-link-send-to-device =
    .label = Envia l'enllaç al dispositiu
    .accesskey = d

main-context-menu-frame =
    .label = Aquest marc
    .accesskey = t

main-context-menu-frame-show-this =
    .label = Mostra només aquest marc
    .accesskey = M

main-context-menu-frame-open-tab =
    .label = Obre el marc en una pestanya nova
    .accesskey = t

main-context-menu-frame-open-window =
    .label = Obre el marc en una finestra nova
    .accesskey = O

main-context-menu-frame-reload =
    .label = Actualitza el marc
    .accesskey = z

main-context-menu-frame-bookmark =
    .label = Afegeix el marc a les adreces d'interès
    .accesskey = m

main-context-menu-frame-save-as =
    .label = Anomena i desa el marc…
    .accesskey = m

main-context-menu-frame-print =
    .label = Imprimeix el marc…
    .accesskey = p

main-context-menu-frame-view-source =
    .label = Codi font del marc
    .accesskey = f

main-context-menu-frame-view-info =
    .label = Informació del marc
    .accesskey = I

main-context-menu-view-selection-source =
    .label = Codi font de la selecció
    .accesskey = e

main-context-menu-view-page-source =
    .label = Codi font de la pàgina
    .accesskey = f

main-context-menu-view-page-info =
    .label = Informació de la pàgina
    .accesskey = I

main-context-menu-bidi-switch-text =
    .label = Canvia la direcció del text
    .accesskey = v

main-context-menu-bidi-switch-page =
    .label = Canvia la direcció de la pàgina
    .accesskey = g

main-context-menu-inspect-element =
    .label = Inspecciona l'element
    .accesskey = I

main-context-menu-inspect-a11y-properties =
    .label = Inspecciona les propietats d'accessibilitat

main-context-menu-eme-learn-more =
    .label = Més informació sobre DRM…
    .accesskey = D
