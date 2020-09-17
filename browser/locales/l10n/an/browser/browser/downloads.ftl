# This Source Code Form is subject to the terms of the Mozilla Public
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

downloads-cmd-pause =
    .label = Pausa
    .accesskey = P
downloads-cmd-resume =
    .label = Continar
    .accesskey = r
downloads-cmd-cancel =
    .tooltiptext = Cancelar
downloads-cmd-cancel-panel =
    .aria-label = Cancelar

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Ubrir a carpeta a on se troba
    .accesskey = b

# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Amostrar en o Finder
    .accesskey = F

downloads-cmd-use-system-default =
    .label = Ubrir en o visualizador d'o sistema
    .accesskey = v

downloads-cmd-always-use-system-default =
    .label = Ubrir siempre en o visualizador d'o sistema
    .accesskey = s

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Amostrar en o Finder
           *[other] Ubrir a carpeta a on se troba
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Amostrar en o Finder
           *[other] Ubrir a carpeta a on se troba
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Amostrar en o Finder
           *[other] Ubrir a carpeta a on se troba
        }

downloads-cmd-show-downloads =
    .label = Amostrar la carpeta de descargas
downloads-cmd-retry =
    .tooltiptext = Tornar a prebar
downloads-cmd-retry-panel =
    .aria-label = Tornar a prebar
downloads-cmd-go-to-download-page =
    .label = Ir ta la pachina de descargas
    .accesskey = I
downloads-cmd-copy-download-link =
    .label = Copiar o vinclo d'a descarga
    .accesskey = l
downloads-cmd-remove-from-history =
    .label = Eliminar de l'historial
    .accesskey = E
downloads-cmd-clear-list =
    .label = Escoscar panel de previsualización
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = Limpiar as descargas
    .accesskey = d

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Permitir descargas
    .accesskey = d

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Eliminar Fichero

downloads-cmd-remove-file-panel =
    .aria-label = Eliminar Fichero

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Eliminar fichero u permitir descarga

downloads-cmd-choose-unblock-panel =
    .aria-label = Eliminar fichero u permitir descarga

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Ubrir y eliminar fichero

downloads-cmd-choose-open-panel =
    .aria-label = Ubrir y eliminar fichero

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Amostrar mas información

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Ubrir lo fichero

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Reintentar la descarga

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Cancelar la descarga

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Amostrar todas as descargas
    .accesskey = A

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Detalles d'as descargas

downloads-clear-downloads-button =
    .label = Limpiar as descargas
    .tooltiptext = Limpia as descargas completas, canceladas y erronias

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = No s'ha trobau descargas.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Garra descarga en esta sesión.
