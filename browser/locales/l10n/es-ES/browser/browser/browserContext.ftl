# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Arrastre hacia abajo para ver el historial
           *[other] Pinche con el botón derecho o arrastre hacia abajo para ver el historial
        }

## Back

# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Back command.
main-context-menu-back-2 =
    .tooltiptext = Ir a la página anterior ({ $shortcut })
    .aria-label = Anterior
    .accesskey = A

# This menuitem is only visible on macOS
main-context-menu-back-mac =
    .label = Anterior
    .accesskey = A

navbar-tooltip-back-2 =
    .value = { main-context-menu-back-2.tooltiptext }

toolbar-button-back-2 =
    .label = { main-context-menu-back-2.aria-label }

## Forward

# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Forward command.
main-context-menu-forward-2 =
    .tooltiptext = Ir a la página siguiente ({ $shortcut })
    .aria-label = Siguiente
    .accesskey = S

# This menuitem is only visible on macOS
main-context-menu-forward-mac =
    .label = Siguiente
    .accesskey = S

navbar-tooltip-forward-2 =
    .value = { main-context-menu-forward-2.tooltiptext }

toolbar-button-forward-2 =
    .label = { main-context-menu-forward-2.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Recargar
    .accesskey = R

# This menuitem is only visible on macOS
main-context-menu-reload-mac =
    .label = Recargar
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Detener
    .accesskey = D

# This menuitem is only visible on macOS
main-context-menu-stop-mac =
    .label = Detener
    .accesskey = D

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
    .label = Guardar como…
    .accesskey = d

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Añadir esta página a marcadores
    .accesskey = m
    .tooltiptext = Añadir esta página a marcadores

# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-edit-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-add-mac =
    .label = Añadir página a marcadores
    .accesskey = m

# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-add-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-edit-mac =
    .label = Editar marcador
    .accesskey = m

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Añadir esta página a marcadores
    .accesskey = m
    .tooltiptext = Añadir esta página a marcadores ({ $shortcut })

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
    .label = Abrir enlace
    .accesskey = l

main-context-menu-open-link-new-tab =
    .label = Abrir enlace en una pestaña nueva
    .accesskey = T

main-context-menu-open-link-container-tab =
    .label = Abrir enlace en pestaña de contenedor nueva
    .accesskey = A

main-context-menu-open-link-new-window =
    .label = Abrir enlace en una ventana nueva
    .accesskey = v

main-context-menu-open-link-new-private-window =
    .label = Abrir enlace en una nueva ventana privada
    .accesskey = P

main-context-menu-bookmark-link =
    .label = Añadir enlace a marcadores
    .accesskey = A

main-context-menu-save-link =
    .label = Guardar enlace como…
    .accesskey = n

main-context-menu-save-link-to-pocket =
    .label = Guardar enlace en { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.


## The access keys for "Copy Link" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Copiar dirección de correo electrónico
    .accesskey = E

main-context-menu-copy-link-simple =
    .label = Copiar enlace
    .accesskey = l

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Reproducir
    .accesskey = P

main-context-menu-media-pause =
    .label = Pausar
    .accesskey = P

##

main-context-menu-media-mute =
    .label = Silenciar
    .accesskey = S

main-context-menu-media-unmute =
    .label = Restaurar sonido
    .accesskey = s

main-context-menu-media-play-speed-2 =
    .label = Velocidad
    .accesskey = V

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
    .label = Repetir
    .accesskey = R

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Mostrar controles
    .accesskey = C

main-context-menu-media-hide-controls =
    .label = Ocultar controles
    .accesskey = C

##

main-context-menu-media-video-fullscreen =
    .label = Pantalla completa
    .accesskey = c

main-context-menu-media-video-leave-fullscreen =
    .label = Salir de la pantalla completa
    .accesskey = p

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-watch-pip =
    .label = Ver en Picture-in-Picture
    .accesskey = i

main-context-menu-image-reload =
    .label = Recargar imagen
    .accesskey = R

main-context-menu-image-view-new-tab =
    .label = Abrir imagen en una pestaña nueva
    .accesskey = i

main-context-menu-video-view-new-tab =
    .label = Abrir vídeo en una pestaña nueva
    .accesskey = A

main-context-menu-image-copy =
    .label = Copiar imagen
    .accesskey = C

main-context-menu-image-copy-link =
    .label = Copiar el enlace de la imagen
    .accesskey = o

main-context-menu-video-copy-link =
    .label = Copiar el enlace del vídeo
    .accesskey = o

main-context-menu-audio-copy-link =
    .label = Copiar el enlace del audio
    .accesskey = o

main-context-menu-image-save-as =
    .label = Guardar imagen como…
    .accesskey = u

main-context-menu-image-email =
    .label = Enviar imagen…
    .accesskey = a

main-context-menu-image-set-image-as-background =
    .label = Establecer imagen como fondo de escritorio…
    .accesskey = s

main-context-menu-image-info =
    .label = Ver información de la imagen
    .accesskey = f

main-context-menu-image-desc =
    .label = Ver descripción
    .accesskey = D

main-context-menu-video-save-as =
    .label = Guardar vídeo como…
    .accesskey = v

main-context-menu-audio-save-as =
    .label = Guardar audio como…
    .accesskey = a

main-context-menu-video-take-snapshot =
    .label = Tomar instantánea
    .accesskey = i

main-context-menu-video-email =
    .label = Enviar vídeo…
    .accesskey = a

main-context-menu-audio-email =
    .label = Enviar audio…
    .accesskey = a

main-context-menu-plugin-play =
    .label = Activar este plugin
    .accesskey = c

main-context-menu-plugin-hide =
    .label = Ocultar este plugin
    .accesskey = t

main-context-menu-save-to-pocket =
    .label = Guardar página en { -pocket-brand-name }
    .accesskey = k

main-context-menu-send-to-device =
    .label = Enviar página al dispositivo
    .accesskey = E

## The access keys for "Use Saved Login" and "Use Saved Password"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-use-saved-login =
    .label = Usar inicio de sesión guardado
    .accesskey = g

main-context-menu-use-saved-password =
    .label = Usar contraseña guardada
    .accesskey = g

##

main-context-menu-suggest-strong-password =
    .label = Sugerir contraseña segura...
    .accesskey = S

main-context-menu-manage-logins2 =
    .label = Administrar inicios de sesión
    .accesskey = m

main-context-menu-keyword =
    .label = Añadir una palabra clave para esta búsqueda…
    .accesskey = v

main-context-menu-link-send-to-device =
    .label = Enviar enlace al dispositivo
    .accesskey = v

main-context-menu-frame =
    .label = Este marco
    .accesskey = m

main-context-menu-frame-show-this =
    .label = Mostrar sólo este marco
    .accesskey = o

main-context-menu-frame-open-tab =
    .label = Abrir el marco en una pestaña nueva
    .accesskey = T

main-context-menu-frame-open-window =
    .label = Abrir el marco en una ventana nueva
    .accesskey = e

main-context-menu-frame-reload =
    .label = Recargar marco
    .accesskey = R

main-context-menu-frame-bookmark =
    .label = Añadir este cuadro a marcadores
    .accesskey = m

main-context-menu-frame-save-as =
    .label = Guardar marco como…
    .accesskey = G

main-context-menu-frame-print =
    .label = Imprimir marco…
    .accesskey = P

main-context-menu-frame-view-source =
    .label = Ver código fuente del marco
    .accesskey = V

main-context-menu-frame-view-info =
    .label = Ver información del marco
    .accesskey = I

main-context-menu-print-selection =
    .label = Imprimir selección
    .accesskey = r

main-context-menu-view-selection-source =
    .label = Ver código fuente seleccionado
    .accesskey = e

main-context-menu-take-screenshot =
    .label = Hacer captura de pantalla
    .accesskey = c

main-context-menu-take-frame-screenshot =
    .label = Hacer captura de pantalla
    .accesskey = u

main-context-menu-view-page-source =
    .label = Ver código fuente de la página
    .accesskey = V

main-context-menu-bidi-switch-text =
    .label = Cambiar dirección del texto
    .accesskey = d

main-context-menu-bidi-switch-page =
    .label = Cambiar dirección de la página
    .accesskey = D

main-context-menu-inspect =
    .label = Inspeccionar
    .accesskey = I

main-context-menu-inspect-a11y-properties =
    .label = Inspeccionar propiedades de accesibilidad

main-context-menu-eme-learn-more =
    .label = Más información sobre DRM…
    .accesskey = D

# Variables
#   $containerName (String): The name of the current container
main-context-menu-open-link-in-container-tab =
    .label = Abrir enlace en una nueva pestaña { $containerName }
    .accesskey = t
