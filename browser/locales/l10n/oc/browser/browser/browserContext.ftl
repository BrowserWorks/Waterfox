# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Clicar en tot desplaçant la mirga cap aval per afichar l'istoric
           *[other] Far un clic drech o clicar en desplaçant la mirga cap aval per afichar l'istoric
        }

## Back

main-context-menu-back =
    .tooltiptext = Recuolar d'una pagina
    .aria-label = Pagina precedenta
    .accesskey = P

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Avançar d'una pagina
    .aria-label = Pagina seguenta
    .accesskey = s

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Actualizar
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Arrestar
    .accesskey = A

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Enregistrar jos…
    .accesskey = E

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Marcar aquesta pagina
    .accesskey = m
    .tooltiptext = Marcar aquesta pagina

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Marcar aquesta pagina
    .accesskey = m
    .tooltiptext = Marcar aquesta pagina ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Modificar aqueste marcapagina
    .accesskey = m
    .tooltiptext = Modificar aqueste marcapagina

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Modificar aqueste marcapagina
    .accesskey = m
    .tooltiptext = Modificar aqueste marcapagina ({ $shortcut })

main-context-menu-open-link =
    .label = Dobrir lo ligam
    .accesskey = o

main-context-menu-open-link-new-tab =
    .label = Dobrir lo ligam dins un onglet novèl
    .accesskey = o

main-context-menu-open-link-container-tab =
    .label = Dobrir lo ligam dins un novèl onglet contèxtual
    .accesskey = b

main-context-menu-open-link-new-window =
    .label = Dobrir lo ligam dins una fenèstra novèla
    .accesskey = o

main-context-menu-open-link-new-private-window =
    .label = Dobrir lo ligam dins una fenèstra privada
    .accesskey = n

main-context-menu-bookmark-this-link =
    .label = Marcapagina sus aqueste ligam
    .accesskey = M

main-context-menu-save-link =
    .label = Enregistrar la cibla del ligam jos…
    .accesskey = E

main-context-menu-save-link-to-pocket =
    .label = Enregistrar lo ligam dins { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Copiar l'adreça electronica
    .accesskey = e

main-context-menu-copy-link =
    .label = Copiar l'adreça del ligam
    .accesskey = C

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Legir
    .accesskey = L

main-context-menu-media-pause =
    .label = Pausa
    .accesskey = P

##

main-context-menu-media-mute =
    .label = Mut
    .accesskey = u

main-context-menu-media-unmute =
    .label = Ausible
    .accesskey = u

main-context-menu-media-play-speed =
    .label = Velocitat de lectura
    .accesskey = l

main-context-menu-media-play-speed-slow =
    .label = Lenta (×0.5)
    .accesskey = S

main-context-menu-media-play-speed-normal =
    .label = Normala
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = Rapida (×1.25)
    .accesskey = R

main-context-menu-media-play-speed-faster =
    .label = Fòrça rapida (×1.5)
    .accesskey = a

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Subrerapida (×2)
    .accesskey = L

main-context-menu-media-loop =
    .label = Tornar legir
    .accesskey = L

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Afichar los contraròtles
    .accesskey = c

main-context-menu-media-hide-controls =
    .label = Amagar los contraròtles
    .accesskey = c

##

main-context-menu-media-video-fullscreen =
    .label = Ecran complet
    .accesskey = c

main-context-menu-media-video-leave-fullscreen =
    .label = Sortir del mòde ecran complet
    .accesskey = c

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Vidèo incrustada
    .accesskey = i

main-context-menu-image-reload =
    .label = Actualizar l'imatge
    .accesskey = m

main-context-menu-image-view =
    .label = Afichar l'imatge
    .accesskey = A

main-context-menu-video-view =
    .label = Afichar la descripcion
    .accesskey = d

main-context-menu-image-copy =
    .label = Copiar l'imatge
    .accesskey = C

main-context-menu-image-copy-location =
    .label = Copiar l'adreça de l'imatge
    .accesskey = a

main-context-menu-video-copy-location =
    .label = Copiar l'URL de la vidèo
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = Copiar l'URL del fichièr àudio
    .accesskey = o

main-context-menu-image-save-as =
    .label = Enregistrar l'imatge jos…
    .accesskey = E

main-context-menu-image-email =
    .label = Enviar l'imatge per corrièl…
    .accesskey = c

main-context-menu-image-set-as-background =
    .label = Causir l'imatge coma fons d'ecran
    .accesskey = f

main-context-menu-image-info =
    .label = Informacions sus l'imatge
    .accesskey = I

main-context-menu-image-desc =
    .label = Afichar la descripcion
    .accesskey = d

main-context-menu-video-save-as =
    .label = Enregistrar la vidèo jos…
    .accesskey = E

main-context-menu-audio-save-as =
    .label = Enregistrar lo fichièr àudio jos…
    .accesskey = E

main-context-menu-video-image-save-as =
    .label = Enregistrar un instantanèu jos…
    .accesskey = E

main-context-menu-video-email =
    .label = Enviar la vidèo per corrièl…
    .accesskey = d

main-context-menu-audio-email =
    .label = Enviar lo fichièr àudio per corrièl…
    .accesskey = d

main-context-menu-plugin-play =
    .label = Activar aqueste plugin
    .accesskey = t

main-context-menu-plugin-hide =
    .label = Amagar aqueste plugin
    .accesskey = g

main-context-menu-save-to-pocket =
    .label = Enregistrar la pagina dins { -pocket-brand-name }
    .accesskey = n

main-context-menu-send-to-device =
    .label = Enviar la pagina al periferic
    .accesskey = v

main-context-menu-view-background-image =
    .label = Afichar l'imatge de fons
    .accesskey = h

main-context-menu-generate-new-password =
    .label = Utilizar un senhal generat…
    .accesskey = g

main-context-menu-keyword =
    .label = Apondre un mot clau per aquesta recèrca…
    .accesskey = c

main-context-menu-link-send-to-device =
    .label = Enviar lo ligam al periferic
    .accesskey = l

main-context-menu-frame =
    .label = Aqueste quadre
    .accesskey = d

main-context-menu-frame-show-this =
    .label = Dobrir lo quadre dins un onglet novèl
    .accesskey = o

main-context-menu-frame-open-tab =
    .label = Dobrir lo quadre dins un onglet novèl
    .accesskey = o

main-context-menu-frame-open-window =
    .label = Dobrir lo quadre dins una fenèstra novèla
    .accesskey = f

main-context-menu-frame-reload =
    .label = Actualizar lo quadre
    .accesskey = c

main-context-menu-frame-bookmark =
    .label = Marcapagina sus aqueste quadre
    .accesskey = M

main-context-menu-frame-save-as =
    .label = Enregistrar lo quadre jos…
    .accesskey = E

main-context-menu-frame-print =
    .label = Imprimir lo quadre…
    .accesskey = I

main-context-menu-frame-view-source =
    .label = Còde font del quadre
    .accesskey = d

main-context-menu-frame-view-info =
    .label = Informacions sul quadre
    .accesskey = n

main-context-menu-view-selection-source =
    .label = Còdi font de la seleccion
    .accesskey = e

main-context-menu-view-page-source =
    .label = Còdi font de la pagina
    .accesskey = f

main-context-menu-view-page-info =
    .label = Informacions sus la pagina
    .accesskey = o

main-context-menu-bidi-switch-text =
    .label = Cambiar lo sens del tèxte
    .accesskey = x

main-context-menu-bidi-switch-page =
    .label = Cambiar lo sens de la pagina
    .accesskey = g

main-context-menu-inspect-element =
    .label = Examinar l’element
    .accesskey = x

main-context-menu-inspect-a11y-properties =
    .label = Examinar las proprietats d’accessibilitat

main-context-menu-eme-learn-more =
    .label = Ne saber mai suls DRM…
    .accesskey = D

