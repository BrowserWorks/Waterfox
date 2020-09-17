# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Prema o rato mentres se move cara abaixo para amosar o historial
           *[other] Prema o botón dereito ou prema o rato mentres se move cara abaixo para amosar o historial
        }

## Back

main-context-menu-back =
    .tooltiptext = Retroceder unha páxina
    .aria-label = Atrás
    .accesskey = A
navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }
toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Avanzar unha páxina
    .aria-label = Adiante
    .accesskey = d
navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }
toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Recargar
    .accesskey = R
toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Deter
    .accesskey = D
toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Gardar páxina como…
    .accesskey = P
toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Marcar esta páxina
    .accesskey = m
    .tooltiptext = Marcar esta páxina
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Marcar esta páxina
    .accesskey = m
    .tooltiptext = Marcar esta páxina ({ $shortcut })
main-context-menu-bookmark-change =
    .aria-label = Editar este marcador
    .accesskey = m
    .tooltiptext = Editar este marcador
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Editar este marcador
    .accesskey = m
    .tooltiptext = Editar este marcador ({ $shortcut })
main-context-menu-open-link =
    .label = Abrir a ligazón
    .accesskey = A
main-context-menu-open-link-new-tab =
    .label = Abrir a ligazón nunha nova lapela
    .accesskey = h
main-context-menu-open-link-container-tab =
    .label = Abrir a ligazón nunha nova lapela contedor
    .accesskey = b
main-context-menu-open-link-new-window =
    .label = Abrir a ligazón nunha nova xanela
    .accesskey = x
main-context-menu-open-link-new-private-window =
    .label = Abrir a ligazón nunha nova xanela privada
    .accesskey = p
main-context-menu-bookmark-this-link =
    .label = Marcar esta ligazón
    .accesskey = l
main-context-menu-save-link =
    .label = Gardar ligazón como…
    .accesskey = m
main-context-menu-save-link-to-pocket =
    .label = Gardar ligazón en { -pocket-brand-name }
    .accesskey = G

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Copiar correo electrónico
    .accesskey = e
main-context-menu-copy-link =
    .label = Copiar a localización da ligazón
    .accesskey = z

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Reproducir
    .accesskey = R
main-context-menu-media-pause =
    .label = Pausa
    .accesskey = P

##

main-context-menu-media-mute =
    .label = Enmudecer
    .accesskey = m
main-context-menu-media-unmute =
    .label = Desenmudecer
    .accesskey = m
main-context-menu-media-play-speed =
    .label = Velocidade de reprodución
    .accesskey = d
main-context-menu-media-play-speed-slow =
    .label = Lenta (0.5×)
    .accesskey = L
main-context-menu-media-play-speed-normal =
    .label = Normal
    .accesskey = N
main-context-menu-media-play-speed-fast =
    .label = Rápida (1.25×)
    .accesskey = R
main-context-menu-media-play-speed-faster =
    .label = Máis rápida (1.5×)
    .accesskey = a
# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Máxima velocidade (2x)
    .accesskey = l
main-context-menu-media-loop =
    .label = Bucle
    .accesskey = B

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Amosar controis
    .accesskey = M
main-context-menu-media-hide-controls =
    .label = Agochar controis
    .accesskey = o

##

main-context-menu-media-video-fullscreen =
    .label = Pantalla completa
    .accesskey = P
main-context-menu-media-video-leave-fullscreen =
    .label = Saír de pantalla completa
    .accesskey = a
# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Imaxe en imaxe
    .accesskey = I
main-context-menu-image-reload =
    .label = Recargar imaxe
    .accesskey = R
main-context-menu-image-view =
    .label = Ver a imaxe
    .accesskey = V
main-context-menu-video-view =
    .label = Ver vídeo
    .accesskey = d
main-context-menu-image-copy =
    .label = Copiar a imaxe
    .accesskey = C
main-context-menu-image-copy-location =
    .label = Copiar a localización da imaxe
    .accesskey = o
main-context-menu-video-copy-location =
    .label = Copiar a localización do vídeo
    .accesskey = o
main-context-menu-audio-copy-location =
    .label = Copiar a localización do audio
    .accesskey = o
main-context-menu-image-save-as =
    .label = Gardar imaxe como…
    .accesskey = G
main-context-menu-image-email =
    .label = Enviar a imaxe por correo…
    .accesskey = a
main-context-menu-image-set-as-background =
    .label = Estabelecer como fondo do escritorio…
    .accesskey = E
main-context-menu-image-info =
    .label = Ver a información da imaxe
    .accesskey = f
main-context-menu-image-desc =
    .label = Ver descrición
    .accesskey = d
main-context-menu-video-save-as =
    .label = Gardar vídeo como…
    .accesskey = v
main-context-menu-audio-save-as =
    .label = Gardar son como…
    .accesskey = a
main-context-menu-video-image-save-as =
    .label = Gardar a captura como…
    .accesskey = G
main-context-menu-video-email =
    .label = Enviar o vídeo por correo…
    .accesskey = a
main-context-menu-audio-email =
    .label = Enviar o ficheiro de son por correo…
    .accesskey = a
main-context-menu-plugin-play =
    .label = Activar este engadido
    .accesskey = c
main-context-menu-plugin-hide =
    .label = Agochar este engadido
    .accesskey = h
main-context-menu-save-to-pocket =
    .label = Gardar páxina en { -pocket-brand-name }
    .accesskey = k
main-context-menu-send-to-device =
    .label = Enviar a páxina ao dispositivo
    .accesskey = n
main-context-menu-view-background-image =
    .label = Ver a imaxe de fondo
    .accesskey = r
main-context-menu-generate-new-password =
    .label = Usar contrasinal xerado...
    .accesskey = U
main-context-menu-keyword =
    .label = Engadir unha palabra clave para esta busca…
    .accesskey = b
main-context-menu-link-send-to-device =
    .label = Enviar a ligazón ao dispositivo
    .accesskey = n
main-context-menu-frame =
    .label = Este marco
    .accesskey = m
main-context-menu-frame-show-this =
    .label = Amosar só este marco
    .accesskey = M
main-context-menu-frame-open-tab =
    .label = Abrir o marco nunha nova lapela
    .accesskey = h
main-context-menu-frame-open-window =
    .label = Abrir o marco nunha nova xanela
    .accesskey = x
main-context-menu-frame-reload =
    .label = Recargar o marco
    .accesskey = R
main-context-menu-frame-bookmark =
    .label = Marcar este marco
    .accesskey = m
main-context-menu-frame-save-as =
    .label = Gardar marco como…
    .accesskey = d
main-context-menu-frame-print =
    .label = Imprimir marco…
    .accesskey = I
main-context-menu-frame-view-source =
    .label = Ver o código do marco
    .accesskey = V
main-context-menu-frame-view-info =
    .label = Ver a información do marco
    .accesskey = m
main-context-menu-view-selection-source =
    .label = Ver o código da selección
    .accesskey = e
main-context-menu-view-page-source =
    .label = Ver o código da páxina
    .accesskey = V
main-context-menu-view-page-info =
    .label = Ver a información da páxina
    .accesskey = f
main-context-menu-bidi-switch-text =
    .label = Cambiar a orientación do texto
    .accesskey = b
main-context-menu-bidi-switch-page =
    .label = Cambiar a orientación da páxina
    .accesskey = x
main-context-menu-inspect-element =
    .label = Inspeccionar elemento
    .accesskey = I
main-context-menu-inspect-a11y-properties =
    .label = Inspeccionar as propiedades de accesibilidade
main-context-menu-eme-learn-more =
    .label = Obteña máis información sobre DRM…
    .accesskey = D
