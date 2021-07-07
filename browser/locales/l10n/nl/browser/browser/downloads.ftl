# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Downloads
downloads-panel =
    .aria-label = Downloads

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
    .label = Pauzeren
    .accesskey = P
downloads-cmd-resume =
    .label = Hervatten
    .accesskey = H
downloads-cmd-cancel =
    .tooltiptext = Annuleren
downloads-cmd-cancel-panel =
    .aria-label = Annuleren
# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Bijbehorende map openen
    .accesskey = m
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Tonen in Finder
    .accesskey = F
downloads-cmd-use-system-default =
    .label = In systeemviewer openen
    .accesskey = v
downloads-cmd-always-use-system-default =
    .label = Altijd in systeemviewer openen
    .accesskey = w
downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Tonen in Finder
           *[other] Bijbehorende map openen
        }
downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Tonen in Finder
           *[other] Bijbehorende map openen
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Tonen in Finder
           *[other] Bijbehorende map openen
        }
downloads-cmd-show-downloads =
    .label = Map Downloads tonen
downloads-cmd-retry =
    .tooltiptext = Opnieuw proberen
downloads-cmd-retry-panel =
    .aria-label = Opnieuw proberen
downloads-cmd-go-to-download-page =
    .label = Naar downloadpagina gaan
    .accesskey = d
downloads-cmd-copy-download-link =
    .label = Downloadkoppeling kopiëren
    .accesskey = k
downloads-cmd-remove-from-history =
    .label = Verwijderen uit geschiedenis
    .accesskey = V
downloads-cmd-clear-list =
    .label = Voorbeeldpaneel wissen
    .accesskey = w
downloads-cmd-clear-downloads =
    .label = Downloads wissen
    .accesskey = w
# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Downloaden toestaan
    .accesskey = o
# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Bestand verwijderen
downloads-cmd-remove-file-panel =
    .aria-label = Bestand verwijderen
# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Bestand verwijderen of downloaden toestaan
downloads-cmd-choose-unblock-panel =
    .aria-label = Bestand verwijderen of downloaden toestaan
# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Bestand openen of verwijderen
downloads-cmd-choose-open-panel =
    .aria-label = Bestand openen of verwijderen
# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Meer informatie tonen
# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Bestand openen

## Displayed when the user clicked on a download in process. Indicates that the
## downloading file will be opened after certain amount of time using an app
## available in the system.
## Variables:
##   $hours (number) - Amount of hours left till the file opens.
##   $seconds (number) - Amount of seconds left till the file opens.
##   $minutes (number) - Amount of minutes till the file opens.

downloading-file-opens-in-hours-and-minutes = Wordt geopend over { $hours } u { $minutes } m…
downloading-file-opens-in-minutes = Wordt geopend over { $minutes } m…
downloading-file-opens-in-minutes-and-seconds = Wordt geopend over { $minutes } m { $seconds } s…
downloading-file-opens-in-seconds = Wordt geopend over { $seconds } s…
downloading-file-opens-in-some-time = Wordt geopend bij voltooien…

##

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Downloaden opnieuw proberen
# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Downloaden annuleren
# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Alle downloads tonen
    .accesskey = A
# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Downloadgegevens
downloads-clear-downloads-button =
    .label = Downloads wissen
    .tooltiptext = Wist voltooide, geannuleerde en mislukte downloads
# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Er zijn geen downloads.
# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Geen downloads voor deze sessie.
