# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Descargas
downloads-panel =
    .aria-label = Descargas

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch
# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-items =
    .style = width: 35em
downloads-cmd-pause =
    .label = Pausar
    .accesskey = P
downloads-cmd-resume =
    .label = Continuar
    .accesskey = R
downloads-cmd-cancel =
    .tooltiptext = Cancelar
downloads-cmd-cancel-panel =
    .aria-label = Cancelar
# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Abrir la carpeta que lo contiene
    .accesskey = b
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Mostrar en Finder
    .accesskey = F
downloads-cmd-use-system-default =
    .label = Abrir en el visor del sistema
    .accesskey = V
downloads-cmd-always-use-system-default =
    .label = Abrir siempre en el visor del sistema
    .accesskey = w
downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Mostrar en Finder
           *[other] Abrir la carpeta que lo contiene
        }
downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Mostrar en Finder
           *[other] Abrir la carpeta que lo contiene
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Mostrar en Finder
           *[other] Abrir la carpeta que lo contiene
        }
downloads-cmd-show-downloads =
    .label = Mostrar carpeta de descargas
downloads-cmd-retry =
    .tooltiptext = Reintentar
downloads-cmd-retry-panel =
    .aria-label = Reintentar
downloads-cmd-go-to-download-page =
    .label = Ir a la página de la descarga
    .accesskey = G
downloads-cmd-copy-download-link =
    .label = Copiar enlace de la descarga
    .accesskey = L
downloads-cmd-remove-from-history =
    .label = Eliminar del historial
    .accesskey = e
downloads-cmd-clear-list =
    .label = Limpiar panel de vista previa
    .accesskey = A
downloads-cmd-clear-downloads =
    .label = Limpiar descargas
    .accesskey = D
# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Permitir descarga
    .accesskey = m
# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Eliminar archivo
downloads-cmd-remove-file-panel =
    .aria-label = Eliminar archivo
# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Eliminar archivo o permitir descarga
downloads-cmd-choose-unblock-panel =
    .aria-label = Eliminar archivo o permitir descarga
# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Abrir o eliminar archivo
downloads-cmd-choose-open-panel =
    .aria-label = Abrir o eliminar archivo
# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Mostrar más información
# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Abrir archivo

## Displayed when the user clicked on a download in process. Indicates that the
## downloading file will be opened after certain amount of time using an app
## available in the system.
## Variables:
##   $hours (number) - Amount of hours left till the file opens.
##   $seconds (number) - Amount of seconds left till the file opens.
##   $minutes (number) - Amount of minutes till the file opens.

downloading-file-opens-in-hours-and-minutes = Se abrirá en { $hours } h { $minutes } m…
downloading-file-opens-in-minutes = Se abrirá en { $minutes } m…
downloading-file-opens-in-minutes-and-seconds = Se abrirá en { $minutes } m { $seconds } s…
downloading-file-opens-in-seconds = Se abrirá en { $seconds } s…
downloading-file-opens-in-some-time = Se abrirá cuando finalice…

##

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Reintentar descarga
# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Cancelar descarga
# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Mostrar todas las descargas
    .accesskey = S
# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Detalles de la descarga
downloads-clear-downloads-button =
    .label = Limpiar descargas
    .tooltiptext = Limpia las descargas completas, canceladas y fallidas
# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = No hay descargas.
# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = No hay descargas en esta sesión.
