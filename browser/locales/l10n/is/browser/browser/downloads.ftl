# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Niðurhal
downloads-panel =
    .aria-label = Niðurhal

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of 
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = Í bið
    .accesskey = b
downloads-cmd-resume =
    .label = Halda áfram
    .accesskey = r
downloads-cmd-cancel =
    .tooltiptext = Hætta við
downloads-cmd-cancel-panel =
    .aria-label = Hætta við

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Opna möppu
    .accesskey = m
  
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Sýna í Finder
    .accesskey = F

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Sýna í Finder
           *[other] Opna möppu
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Sýna í Finder
           *[other] Opna möppu
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Sýna í Finder
           *[other] Opna möppu
        }

downloads-cmd-show-downloads =
    .label = Sýna niðurhalsmöppu
downloads-cmd-retry =
    .tooltiptext = Reyna aftur
downloads-cmd-retry-panel =
    .aria-label = Reyna aftur
downloads-cmd-go-to-download-page =
    .label = Fara á niðurhalssíðu
    .accesskey = F
downloads-cmd-copy-download-link =
    .label = Afrita niðurhalstengil
    .accesskey = l
downloads-cmd-remove-from-history =
    .label = Fjarlægja úr feril
    .accesskey = e
downloads-cmd-clear-list =
    .label = Hreinsa forskoðunarrúðu
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = Hreinsa niðurhal
    .accesskey = n

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Leyfa niðurhal
    .accesskey = ð

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Fjarlægja skrá

downloads-cmd-remove-file-panel =
    .aria-label = Fjarlægja skrá

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Fjarlægja skrá eða leyfa niðurhal

downloads-cmd-choose-unblock-panel =
    .aria-label = Fjarlægja skrá eða leyfa niðurhal

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Opna eða fjarlægja skrá

downloads-cmd-choose-open-panel =
    .aria-label = Opna eða fjarlægja skrá

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Sýna meiri upplýsingar

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Opna skrá

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Reyna aftur niðurhal

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Hætta við niðurhal

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Sýna öll niðurhöl
    .accesskey = S

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Upplýsingar um niðurhal

downloads-clear-downloads-button =
    .label = Hreinsa niðurhöl
    .tooltiptext = Hreinsa niðurhöl sem er lokið, hætt við eða sem mistókust

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Engin niðurhöl.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Engin niðurhöl í þessari lotu.
