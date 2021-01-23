# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Descolgar para mostrar historial
           *[other] Botón derecho o descolgar para mostrar historial
        }

## Back

main-context-menu-back =
    .tooltiptext = Retroceder una página
    .aria-label = Atrás
    .accesskey = t

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Avanzar una página
    .aria-label = Adelante
    .accesskey = A

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
    .aria-label = Detener
    .accesskey = D

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = Guardar página como…
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Marcar esta página
    .accesskey = M
    .tooltiptext = Marcar esta página

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Marcar esta página
    .accesskey = M
    .tooltiptext = Marcar esta página ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = Editar este marcador
    .accesskey = M
    .tooltiptext = Editar este marcador

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Editar este marcador
    .accesskey = M
    .tooltiptext = Editar este marcador ({ $shortcut })

main-context-menu-open-link =
    .label = Abrir enlace
    .accesskey = e

main-context-menu-open-link-new-tab =
    .label = Abrir enlace en nueva pestaña
    .accesskey = t

main-context-menu-open-link-container-tab =
    .label = Abrir enlace en nueva pestaña contenedora
    .accesskey = c

main-context-menu-open-link-new-window =
    .label = Abrir enlace en nueva ventana
    .accesskey = v

main-context-menu-open-link-new-private-window =
    .label = Abrir enlace en nueva ventana privada
    .accesskey = P

main-context-menu-bookmark-this-link =
    .label = Marcar este enlace
    .accesskey = l

main-context-menu-save-link =
    .label = Guardar enlace como…
    .accesskey = l

main-context-menu-save-link-to-pocket =
    .label = Guardar enlace en { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Copiar dirección de correo electrónico
    .accesskey = e

main-context-menu-copy-link =
    .label = Copiar dirección del enlace
    .accesskey = C

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Reproducir
    .accesskey = p

main-context-menu-media-pause =
    .label = Pausa
    .accesskey = P

##

main-context-menu-media-mute =
    .label = Mudo
    .accesskey = M

main-context-menu-media-unmute =
    .label = Activar el sonido
    .accesskey = s

main-context-menu-media-play-speed =
    .label = Velocidad de reproducción
    .accesskey = d

main-context-menu-media-play-speed-slow =
    .label = Lenta (0.5×)
    .accesskey = L

main-context-menu-media-play-speed-normal =
    .label = Normal
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = Rápida (1.25 ×)
    .accesskey = R

main-context-menu-media-play-speed-faster =
    .label = Más rápida (1.5 ×)
    .accesskey = a

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Ridícula (2 ×)
    .accesskey = d

main-context-menu-media-loop =
    .label = Repetir
    .accesskey = e

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Mostrar controles
    .accesskey = c

main-context-menu-media-hide-controls =
    .label = Ocultar controles
    .accesskey = c

##

main-context-menu-media-video-fullscreen =
    .label = Pantalla completa
    .accesskey = n

main-context-menu-media-video-leave-fullscreen =
    .label = Salir de pantalla completa
    .accesskey = e

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Picture-in-Picture
    .accesskey = u

main-context-menu-image-reload =
    .label = Recargar imagen
    .accesskey = R

main-context-menu-image-view =
    .label = Ver imagen
    .accesskey = i

main-context-menu-video-view =
    .label = Ver video
    .accesskey = i

main-context-menu-image-copy =
    .label = Copiar imagen
    .accesskey = i

main-context-menu-image-copy-location =
    .label = Copiar dirección de la imagen
    .accesskey = o

main-context-menu-video-copy-location =
    .label = Copiar dirección del video
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = Copiar dirección del audio
    .accesskey = o

main-context-menu-image-save-as =
    .label = Guardar imagen como…
    .accesskey = u

main-context-menu-image-email =
    .label = Imagen por email…
    .accesskey = a

main-context-menu-image-set-as-background =
    .label = Poner como fondo del escritorio…
    .accesskey = s

main-context-menu-image-info =
    .label = Ver información de la imagen
    .accesskey = f

main-context-menu-image-desc =
    .label = Ver descripción
    .accesskey = d

main-context-menu-video-save-as =
    .label = Guardar video como…
    .accesskey = u

main-context-menu-audio-save-as =
    .label = Guardar audio como…
    .accesskey = u

main-context-menu-video-image-save-as =
    .label = Guardar captura como…
    .accesskey = G

main-context-menu-video-email =
    .label = Video por email…
    .accesskey = a

main-context-menu-audio-email =
    .label = Audio por email…
    .accesskey = A

main-context-menu-plugin-play =
    .label = Activar este plugin
    .accesskey = c

main-context-menu-plugin-hide =
    .label = Ocultar este plugin
    .accesskey = o

main-context-menu-save-to-pocket =
    .label = Guardar página en { -pocket-brand-name }
    .accesskey = k

main-context-menu-send-to-device =
    .label = Enviar página a dispositivo
    .accesskey = d

main-context-menu-view-background-image =
    .label = Ver imagen de fondo
    .accesskey = f

main-context-menu-generate-new-password =
    .label = Usar contraseña generada…
    .accesskey = g

main-context-menu-keyword =
    .label = Agregar una palabra clave a esta búsqueda…
    .accesskey = g

main-context-menu-link-send-to-device =
    .label = Enviar enlace a dispositivo
    .accesskey = d

main-context-menu-frame =
    .label = Este marco
    .accesskey = c

main-context-menu-frame-show-this =
    .label = Mostrar solamente este marco
    .accesskey = o

main-context-menu-frame-open-tab =
    .label = Abrir marco en nueva pestaña
    .accesskey = t

main-context-menu-frame-open-window =
    .label = Abrir marco en nueva ventana
    .accesskey = v

main-context-menu-frame-reload =
    .label = Recargar marco
    .accesskey = R

main-context-menu-frame-bookmark =
    .label = Marcar este marco…
    .accesskey = r

main-context-menu-frame-save-as =
    .label = Guardar marco como…
    .accesskey = m

main-context-menu-frame-print =
    .label = Imprimir marco…
    .accesskey = I

main-context-menu-frame-view-source =
    .label = Ver fuente del marco
    .accesskey = V

main-context-menu-frame-view-info =
    .label = Ver información del marco
    .accesskey = i

main-context-menu-view-selection-source =
    .label = Ver fuente de la selección
    .accesskey = e

main-context-menu-view-page-source =
    .label = Ver código fuente
    .accesskey = V

main-context-menu-view-page-info =
    .label = Ver información de la página
    .accesskey = i

main-context-menu-bidi-switch-text =
    .label = Cambiar dirección del texto
    .accesskey = x

main-context-menu-bidi-switch-page =
    .label = Cambiar dirección de la página
    .accesskey = g

main-context-menu-inspect-element =
    .label = Inspeccionar elemento
    .accesskey = o

main-context-menu-inspect-a11y-properties =
    .label = Inspeccionar las propiedades de Accesibilidad

main-context-menu-eme-learn-more =
    .label = Conocer más sobre DRM…
    .accesskey = D

