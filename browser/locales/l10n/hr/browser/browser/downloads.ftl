# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Preuzimanja
downloads-panel =
    .aria-label = Preuzimanja

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch
downloads-cmd-pause =
    .label = Pauziraj
    .accesskey = P
downloads-cmd-resume =
    .label = Nastavi
    .accesskey = N
downloads-cmd-cancel =
    .tooltiptext = Odustani
downloads-cmd-cancel-panel =
    .aria-label = Odustani
# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Otvori direktorij preuzimanja
    .accesskey = t
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Prikaži u Finderu
    .accesskey = F
downloads-cmd-use-system-default =
    .label = Otvori u pregledniku sustava
    .accesskey = v
downloads-cmd-always-use-system-default =
    .label = Uvijek otvori u pregledniku sustava
    .accesskey = U
downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Prikaži u Finderu
           *[other] Otvori direktorij preuzimanja
        }
downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Prikaži u Finderu
           *[other] Otvori direktorij preuzimanja
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Prikaži u Finderu
           *[other] Otvori direktorij preuzimanja
        }
downloads-cmd-show-downloads =
    .label = Prikaži mapu preuzimanja
downloads-cmd-retry =
    .tooltiptext = Pokušaj ponovo
downloads-cmd-retry-panel =
    .aria-label = Pokušaj ponovo
downloads-cmd-go-to-download-page =
    .label = Idi na stranicu preuzimanja
    .accesskey = I
downloads-cmd-copy-download-link =
    .label = Kopiraj poveznicu preuzimanja
    .accesskey = K
downloads-cmd-remove-from-history =
    .label = Ukloni iz povijesti
    .accesskey = s
downloads-cmd-clear-list =
    .label = Izbriši ploču pregleda
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = Izbriši preuzimanja
    .accesskey = e
# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Dozvoli preuzimanje
    .accesskey = o
# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Ukloni datoteku
downloads-cmd-remove-file-panel =
    .aria-label = Ukloni datoteku
# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Ukloni datoteku ili dozvoli preuzimanje
downloads-cmd-choose-unblock-panel =
    .aria-label = Ukloni datoteku ili dozvoli preuzimanje
# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Otvori ili ukloni datoteku
downloads-cmd-choose-open-panel =
    .aria-label = Otvori ili ukloni datoteku
# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Prikaži više informacija
# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Otvaranje datoteke
# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Ponavljanje preuzimanja
# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Otkazivanje preuzimanja
# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Prikaži sva preuzimanja
    .accesskey = s
# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Detalji preuzimanja
downloads-clear-downloads-button =
    .label = Izbriši preuzimanja
    .tooltiptext = Briše dovršena, otkazana i neuspjela preuzimanja
# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Nema preuzimanja.
# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Nema preuzimanja u ovoj sesiji.
