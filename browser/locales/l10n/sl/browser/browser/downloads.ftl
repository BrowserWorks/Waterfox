# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Prenosi
downloads-panel =
    .aria-label = Prenosi

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 80ch

downloads-cmd-pause =
    .label = Premor
    .accesskey = o
downloads-cmd-resume =
    .label = Nadaljuj
    .accesskey = N
downloads-cmd-cancel =
    .tooltiptext = Prekliči
downloads-cmd-cancel-panel =
    .aria-label = Prekliči

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Odpri vsebujočo mapo
    .accesskey = V

# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Prikaži v Finderju
    .accesskey = F

downloads-cmd-use-system-default =
    .label = Odpri v sistemskem pregledovalniku
    .accesskey = s

downloads-cmd-always-use-system-default =
    .label = Vedno odpri v sistemskem pregledovalniku
    .accesskey = V

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Prikaži v Finderju
           *[other] Odpri vsebujočo mapo
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Prikaži v Finderju
           *[other] Odpri vsebujočo mapo
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Prikaži v Finderju
           *[other] Odpri vsebujočo mapo
        }

downloads-cmd-show-downloads =
    .label = Prikaži mapo s prenosi
downloads-cmd-retry =
    .tooltiptext = Poskusi znova
downloads-cmd-retry-panel =
    .aria-label = Poskusi znova
downloads-cmd-go-to-download-page =
    .label = Pojdi na stran za prenos
    .accesskey = O
downloads-cmd-copy-download-link =
    .label = Kopiraj povezavo za prenos
    .accesskey = P
downloads-cmd-remove-from-history =
    .label = Odstrani iz zgodovine
    .accesskey = z
downloads-cmd-clear-list =
    .label = Počisti ploščo predogleda
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = Počisti prenose
    .accesskey = S

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Dovoli prenos
    .accesskey = D

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Odstrani datoteko

downloads-cmd-remove-file-panel =
    .aria-label = Odstrani datoteko

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Odstrani datoteko ali dovoli prenos

downloads-cmd-choose-unblock-panel =
    .aria-label = Odstrani datoteko ali dovoli prenos

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Odpri ali odstrani datoteko

downloads-cmd-choose-open-panel =
    .aria-label = Odpri ali odstrani datoteko

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Več informacij

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Odpri datoteko

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Ponovno zaženi prenos

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Prekliči prenos

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Prikaži vse prenose
    .accesskey = S

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Podrobnosti o prenosu

downloads-clear-downloads-button =
    .label = Počisti prenose
    .tooltiptext = Počisti dokončane, preklicane in spodletele prenose

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Ni prenosov.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Ni prenosov v tej seji.
