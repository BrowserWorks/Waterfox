# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Nadunínj
downloads-panel =
    .aria-label = Nadunínj

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of 
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = Duyichin' akuan'
    .accesskey = P
downloads-cmd-resume =
    .label = Nayi'i ñun
    .accesskey = R
downloads-cmd-cancel =
    .tooltiptext = Duyichin'
downloads-cmd-cancel-panel =
    .aria-label = Duyichin'

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Nà'nin' riña ma rasun un
    .accesskey = F
  
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Digun' nga Finder
    .accesskey = F

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Digun' nga Finder
           *[other] Nà'nin' riña ma rasun un
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Digun' nga Finder
           *[other] Nà'nin' riña ma rasun un
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Digun' nga Finder
           *[other] Nà'nin' riña ma rasun un
        }

downloads-cmd-show-downloads =
    .label = Na'ni' ña mā sa naduni'
downloads-cmd-retry =
    .tooltiptext = A'ngo ñun
downloads-cmd-retry-panel =
    .aria-label = A'ngo ñun
downloads-cmd-go-to-download-page =
    .label = Gun' riña pagina naduninj
    .accesskey = G
downloads-cmd-copy-download-link =
    .label = Garasun' da'nga' da' naduni'
    .accesskey = L
downloads-cmd-remove-from-history =
    .label = Dure' riña gaché nun'
    .accesskey = e
downloads-cmd-clear-list =
    .label = Nagi'iaj nìñu' riña ni'io'
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = Gùyun' nej sa naduni'
    .accesskey = D

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Gani' naduninj ma
    .accesskey = o

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Guxun' dara'anj

downloads-cmd-remove-file-panel =
    .aria-label = Guxun' dara'anj

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Guxun' dara'anj nej si gani' naduninj ma

downloads-cmd-choose-unblock-panel =
    .aria-label = Guxun' dara'anj nej si gani' naduninj ma

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Na'nin' nej si nadure'

downloads-cmd-choose-open-panel =
    .aria-label = Na'nin' nej si nadure'

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Ni'io' dos nuguan'an

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Na'nïn' chrû ñanj

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Naduni' a'ngo ñu

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Duyichin' sa naduninj

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Ni'io' daran' sa nadunin'
    .accesskey = S

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Daj hua sa naduninjt

downloads-clear-downloads-button =
    .label = Gùyun' nej sa naduni'
    .tooltiptext = Dure' da'ua sa gire'

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Nitaj sa naduni' hua.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Nitaj sa naduni' hua riña sesiôn na.
