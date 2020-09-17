# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Elŝutoj
downloads-panel =
    .aria-label = Elŝutoj

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = Paŭzigi
    .accesskey = P
downloads-cmd-resume =
    .label = Daŭrigi
    .accesskey = D
downloads-cmd-cancel =
    .tooltiptext = Nuligi
downloads-cmd-cancel-panel =
    .aria-label = Nuligi

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Malfermi entenantan dosierujon
    .accesskey = E

# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Montri en dosierserĉilo
    .accesskey = M

downloads-cmd-use-system-default =
    .label = Malfermi per norma sistema programo
    .accesskey = M

downloads-cmd-always-use-system-default =
    .label = Ĉiam malfermi per norma sistema programo
    .accesskey = n

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Montri en dosierserĉilo
           *[other] Malfermi entenantan dosierujon
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Montri en dosierserĉilo
           *[other] Malfermi entenantan dosierujon
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Montri en dosierserĉilo
           *[other] Malfermi entenantan dosierujon
        }

downloads-cmd-show-downloads =
    .label = Montri dosierujon por elŝutoj
downloads-cmd-retry =
    .tooltiptext = Klopodi denove
downloads-cmd-retry-panel =
    .aria-label = Klopodi denove
downloads-cmd-go-to-download-page =
    .label = Iri al la paĝo de elŝuto
    .accesskey = I
downloads-cmd-copy-download-link =
    .label = Kopii la elŝutan ligilon
    .accesskey = L
downloads-cmd-remove-from-history =
    .label = Forigi el la historio
    .accesskey = h
downloads-cmd-clear-list =
    .label = Viŝi antaŭvidan panelon
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = Viŝi elŝutojn
    .accesskey = e

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Permesi elŝuton
    .accesskey = P

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Forigi dosieron

downloads-cmd-remove-file-panel =
    .aria-label = Forigi dosieron

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Forigi dosieron aŭ permesi elŝuton

downloads-cmd-choose-unblock-panel =
    .aria-label = Forigi dosieron aŭ permesi elŝuton

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Malfermi aŭ forigi dosieron

downloads-cmd-choose-open-panel =
    .aria-label = Malfermi aŭ forigi dosieron

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Montri pli da informo

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Malfermi dosieron

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Reprovi elŝuton

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Nuligi elŝuton

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Montri ĉiujn elŝutojn
    .accesskey = M

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Detaloj de elŝuto

downloads-clear-downloads-button =
    .label = Viŝi elŝutojn
    .tooltiptext = Viŝi finintajn, nuligitajn kaj malsukcesajn elŝutojn

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Estas neniu elŝuto.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Neniu elŝuto por tiu ĉi seanco.
