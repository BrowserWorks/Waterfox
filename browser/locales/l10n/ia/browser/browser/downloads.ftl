# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Discargamentos
downloads-panel =
    .aria-label = Discargamentos

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = Pausar
    .accesskey = P
downloads-cmd-resume =
    .label = Reprender
    .accesskey = R
downloads-cmd-cancel =
    .tooltiptext = Cancellar
downloads-cmd-cancel-panel =
    .aria-label = Cancellar

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Aperir le dossier que lo contine
    .accesskey = d
  
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Monstrar in Finder
    .accesskey = F

downloads-cmd-use-system-default =
    .label = Aperir in le visor del systema
    .accesskey = v

downloads-cmd-always-use-system-default =
    .label = Aperir sempre in le visor del systema
    .accesskey = s

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Monstrar in Finder
           *[other] Aperir le dossier que lo contine
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Monstrar in Finder
           *[other] Aperir le dossier que lo contine
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Monstrar in Finder
           *[other] Aperir le dossier que lo contine
        }

downloads-cmd-show-downloads =
    .label = Monstrar le dossier de discargamentos
downloads-cmd-retry =
    .tooltiptext = Retentar
downloads-cmd-retry-panel =
    .aria-label = Retentar
downloads-cmd-go-to-download-page =
    .label = Ir al pagina de discargamento
    .accesskey = G
downloads-cmd-copy-download-link =
    .label = Copiar le ligamine de discargamento
    .accesskey = L
downloads-cmd-remove-from-history =
    .label = Remover del chronologia
    .accesskey = e
downloads-cmd-clear-list =
    .label = Vacuar le pannello de vista preliminar
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = Vacuar discargamentos
    .accesskey = D

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Permitter le discargamento
    .accesskey = P

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Remover le file

downloads-cmd-remove-file-panel =
    .aria-label = Remover le file

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Remover le file o permitter le discargamento

downloads-cmd-choose-unblock-panel =
    .aria-label = Remover le file o permitter le discargamento

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Aperir o remover le file

downloads-cmd-choose-open-panel =
    .aria-label = Aperir o remover le file

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Monstrar plus informationes

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Aperir le file

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Retentar le discargamento

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Cancellar le discargamento

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Monstrar tote le discargamentos
    .accesskey = S

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Detalios del discargamento

downloads-clear-downloads-button =
    .label = Vacuar discargamentos
    .tooltiptext = Vacua le lista de discargamentos complete, cancellate e fallite

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Il non ha discargamentos.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Nulle discargamentos pro iste session.
