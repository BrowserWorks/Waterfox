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
    .label = Retomar
    .accesskey = R
downloads-cmd-cancel =
    .tooltiptext = Cancelar
downloads-cmd-cancel-panel =
    .aria-label = Cancelar
# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Abrir o cartafol contedor
    .accesskey = f
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Amosar no Finder
    .accesskey = F
downloads-cmd-use-system-default =
    .label = Abrir no visor do sistema
    .accesskey = A
downloads-cmd-always-use-system-default =
    .label = Abrir sempre no visor do sistema
    .accesskey = s
downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Amosar no Finder
           *[other] Abrir o cartafol contedor
        }
downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Amosar no Finder
           *[other] Abrir o cartafol contedor
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Amosar no Finder
           *[other] Abrir o cartafol contedor
        }
downloads-cmd-show-downloads =
    .label = Amosar o cartafol de descargas
downloads-cmd-retry =
    .tooltiptext = Tentar de novo
downloads-cmd-retry-panel =
    .aria-label = Tentar de novo
downloads-cmd-go-to-download-page =
    .label = Ir á páxina de descargas
    .accesskey = g
downloads-cmd-copy-download-link =
    .label = Copiar ligazón de descarga
    .accesskey = l
downloads-cmd-remove-from-history =
    .label = Retirar do historial
    .accesskey = e
downloads-cmd-clear-list =
    .label = Limpa o panel de previsualización
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = Borrar as descargas
    .accesskey = d
# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Permitir a descarga
    .accesskey = e
# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Retirar ficheiro
downloads-cmd-remove-file-panel =
    .aria-label = Retirar ficheiro
# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Retira o ficheiro ou permite a descarga
downloads-cmd-choose-unblock-panel =
    .aria-label = Retira o ficheiro ou permite a descarga
# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Abre ou elimina o ficheiro
downloads-cmd-choose-open-panel =
    .aria-label = Abre ou elimina o ficheiro
# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Amosar máis información
# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Abrir ficheiro
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
    .label = Amosar todas as descargas
    .accesskey = s
# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Detalles da descarga
downloads-clear-downloads-button =
    .label = Borrar as descargas
    .tooltiptext = Borra as descargas rematadas, canceladas ou que fallaron
# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Non hai descargas.
# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Sen descargas nesta sesión.
