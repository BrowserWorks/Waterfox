# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Telechargiadas
downloads-panel =
    .aria-label = Telechargiadas

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
    .label = Cuntinuar
    .accesskey = C
downloads-cmd-cancel =
    .tooltiptext = Interrumper
downloads-cmd-cancel-panel =
    .aria-label = Interrumper

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Mussar l'ordinatur che cuntegna la datoteca
    .accesskey = o

# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Mussar en il finder
    .accesskey = f

downloads-cmd-use-system-default =
    .label = Avrir cun il program da standard
    .accesskey = v

downloads-cmd-always-use-system-default =
    .label = Adina avrir cun il program da standard
    .accesskey = u

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Mussar en il finder
           *[other] Mussar l'ordinatur che cuntegna la datoteca
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Mussar en il finder
           *[other] Mussar l'ordinatur che cuntegna la datoteca
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Mussar en il finder
           *[other] Mussar l'ordinatur che cuntegna la datoteca
        }

downloads-cmd-show-downloads =
    .label = Mussar l'ordinatur da telechargiadas
downloads-cmd-retry =
    .tooltiptext = Empruvar anc ina giada
downloads-cmd-retry-panel =
    .aria-label = Empruvar anc ina giada
downloads-cmd-go-to-download-page =
    .label = Ir a la pagina da telechargiar
    .accesskey = t
downloads-cmd-copy-download-link =
    .label = Copiar la colliaziun a la telechargiada
    .accesskey = L
downloads-cmd-remove-from-history =
    .label = Allontanar da la cronologia
    .accesskey = g
downloads-cmd-clear-list =
    .label = Svidar la panela da prevista
    .accesskey = v
downloads-cmd-clear-downloads =
    .label = Svidar la glista da telechargiadas
    .accesskey = D

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Permetter da telechargiar
    .accesskey = i

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Allontanar la datoteca

downloads-cmd-remove-file-panel =
    .aria-label = Allontanar la datoteca

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Allontanar la datoteca u permetter da telechargiar

downloads-cmd-choose-unblock-panel =
    .aria-label = Allontanar la datoteca u permetter da telechargiar

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Avrir u allontanar la datoteca

downloads-cmd-choose-open-panel =
    .aria-label = Avrir u allontanar la datoteca

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Mussar ulteriuras infurmaziuns

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Avrir la datoteca

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Reempruvar da telechargiar

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Interrumper la telechargiada

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Mussar tut las telechargiadas
    .accesskey = S

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Detagls davart la telechargiada

downloads-clear-downloads-button =
    .label = Svidar la glista da telechargiadas
    .tooltiptext = Stizza tut las telechargiadas cumplettadas, interruttas u sbagliadas da la glista da telechargiadas

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = I na dat naginas telechargiadas.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Naginas telechargiadas per questa sesida.
