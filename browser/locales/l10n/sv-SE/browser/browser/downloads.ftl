# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Filhämtningar
downloads-panel =
    .aria-label = Filhämtningar

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
    .label = Återuppta
    .accesskey = Å
downloads-cmd-cancel =
    .tooltiptext = Avbryt
downloads-cmd-cancel-panel =
    .aria-label = Avbryt

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Öppna objektets mapp
    .accesskey = m
  
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Visa i Finder
    .accesskey = F

downloads-cmd-use-system-default =
    .label = Öppna i systemvisaren
    .accesskey = s

downloads-cmd-always-use-system-default =
    .label = Öppna alltid i systemvisaren
    .accesskey = a

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Visa i Finder
           *[other] Öppna objektets mapp
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Visa i Finder
           *[other] Öppna objektets mapp
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Visa i Finder
           *[other] Öppna objektets mapp
        }

downloads-cmd-show-downloads =
    .label = Visa mapp för hämtade filer
downloads-cmd-retry =
    .tooltiptext = Försök igen
downloads-cmd-retry-panel =
    .aria-label = Försök igen
downloads-cmd-go-to-download-page =
    .label = Gå till hämtningssidan
    .accesskey = G
downloads-cmd-copy-download-link =
    .label = Kopiera filhämtningslänk
    .accesskey = K
downloads-cmd-remove-from-history =
    .label = Ta bort från historik
    .accesskey = T
downloads-cmd-clear-list =
    .label = Rensa förhandsgranskningspanelen
    .accesskey = R
downloads-cmd-clear-downloads =
    .label = Rensa hämtningar
    .accesskey = h

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Tillåt hämtning
    .accesskey = m

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Ta bort fil

downloads-cmd-remove-file-panel =
    .aria-label = Ta bort fil

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Ta bort fil eller tillåt hämtning

downloads-cmd-choose-unblock-panel =
    .aria-label = Ta bort fil eller tillåt hämtning

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Öppna eller ta bort fil

downloads-cmd-choose-open-panel =
    .aria-label = Öppna eller ta bort fil

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Visa mer information

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Öppna fil

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Försök hämta igen

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Avbryt hämtning

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Visa alla hämtningar
    .accesskey = V

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Nedladdningsdetaljer

downloads-clear-downloads-button =
    .label = Rensa hämtningar
    .tooltiptext = Rensar bort slutförda, avbrutna och misslyckade hämtningar

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Det finns inga hämtningar.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Inga nedladdningar för denna session.
