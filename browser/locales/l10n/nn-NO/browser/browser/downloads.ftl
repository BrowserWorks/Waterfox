# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Nedlastingar
downloads-panel =
    .aria-label = Nedlastingar

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = Pause
    .accesskey = P
downloads-cmd-resume =
    .label = Fortset
    .accesskey = F
downloads-cmd-cancel =
    .tooltiptext = Avbryt
downloads-cmd-cancel-panel =
    .aria-label = Avbryt

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Opne innhaldsmappe
    .accesskey = O

# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Vis i Finder
    .accesskey = F

downloads-cmd-use-system-default =
    .label = Opne i systemvisinga
    .accesskey = v

downloads-cmd-always-use-system-default =
    .label = Alltid opne i systemvisinga
    .accesskey = s

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Vis i Finder
           *[other] Opne innhaldsmappe
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Vis i Finder
           *[other] Opne innhaldsmappe
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Vis i Finder
           *[other] Opne innhaldsmappe
        }

downloads-cmd-show-downloads =
    .label = Vis nedlastingsmappe
downloads-cmd-retry =
    .tooltiptext = Prøv igjen
downloads-cmd-retry-panel =
    .aria-label = Prøv igjen
downloads-cmd-go-to-download-page =
    .label = Gå til nedlastingssida
    .accesskey = G
downloads-cmd-copy-download-link =
    .label = Kopier nedlastingslenke
    .accesskey = K
downloads-cmd-remove-from-history =
    .label = Fjern frå historikk
    .accesskey = e
downloads-cmd-clear-list =
    .label = Tøm førehandsvisingsruta
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = Fjern nedlastingar
    .accesskey = e

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Tillat nedlasting
    .accesskey = e

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Fjern fil

downloads-cmd-remove-file-panel =
    .aria-label = Fjern fil

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Slett fil eller tillat nedlasting

downloads-cmd-choose-unblock-panel =
    .aria-label = Slett fil eller tillat nedlasting

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Opne eller slett fil

downloads-cmd-choose-open-panel =
    .aria-label = Opne eller slett fil

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Vis meir informasjon

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Opne fil

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Prøv å laste ned på nytt

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Avbryt nedlasting

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Vis alle nedlastingar
    .accesskey = V

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Nedlastingsdetaljar

downloads-clear-downloads-button =
    .label = Fjern nedlastingar
    .tooltiptext = Fjernar fullførte, avbrotne og mislykka nedlastingar

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Ingen nedlastingar.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Ingen nedlastingar i denne økta.
