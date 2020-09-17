# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Baixades
downloads-panel =
    .aria-label = Baixades

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
    .label = Reprèn
    .accesskey = R
downloads-cmd-cancel =
    .tooltiptext = Cancel·la
downloads-cmd-cancel-panel =
    .aria-label = Cancel·la

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Obre la carpeta on es troba
    .accesskey = b

# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Mostra-ho en el Finder
    .accesskey = F

downloads-cmd-use-system-default =
    .label = Obre amb el visualitzador del sistema
    .accesskey = v

downloads-cmd-always-use-system-default =
    .label = Obre sempre amb el visualitzador del sistema
    .accesskey = z

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Mostra-ho en el Finder
           *[other] Obre la carpeta on es troba
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Mostra-ho en el Finder
           *[other] Obre la carpeta on es troba
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Mostra-ho en el Finder
           *[other] Obre la carpeta on es troba
        }

downloads-cmd-show-downloads =
    .label = Mostra la carpeta de baixades
downloads-cmd-retry =
    .tooltiptext = Reintenta
downloads-cmd-retry-panel =
    .aria-label = Reintenta
downloads-cmd-go-to-download-page =
    .label = Vés a la pàgina de la baixada
    .accesskey = V
downloads-cmd-copy-download-link =
    .label = Copia l'enllaç de la baixada
    .accesskey = l
downloads-cmd-remove-from-history =
    .label = Elimina de l'historial
    .accesskey = e
downloads-cmd-clear-list =
    .label = Buida la subfinestra de previsualització
    .accesskey = B
downloads-cmd-clear-downloads =
    .label = Buida la llista de baixades
    .accesskey = B

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Permet la baixada
    .accesskey = P

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Elimina el fitxer

downloads-cmd-remove-file-panel =
    .aria-label = Elimina el fitxer

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Elimina el fitxer o permet la baixada

downloads-cmd-choose-unblock-panel =
    .aria-label = Elimina el fitxer o permet la baixada

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Obre o elimina el fitxer

downloads-cmd-choose-open-panel =
    .aria-label = Obre o elimina el fitxer

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Mostra més informació

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Obre el fitxer

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Reintenta la baixada

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Cancel·la la baixada

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Mostra totes les baixades
    .accesskey = s

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Detalls de la baixada

downloads-clear-downloads-button =
    .label = Buida la llista de baixades
    .tooltiptext = Elimina de la llista les baixades acabades, cancel·lades o que han fallat

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = No hi ha cap baixada.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = No heu baixat res durant aquesta sessió.
