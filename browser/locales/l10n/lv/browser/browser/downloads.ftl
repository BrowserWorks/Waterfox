# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Lejupielādes
downloads-panel =
    .aria-label = Lejupielādes

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of 
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = Apturēt
    .accesskey = p
downloads-cmd-resume =
    .label = Atkārtot
    .accesskey = r
downloads-cmd-cancel =
    .tooltiptext = Atcelt
downloads-cmd-cancel-panel =
    .aria-label = Atcelt

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Atvērt mapi
    .accesskey = m
  
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Parādīt Finder
    .accesskey = F

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Parādīt Finder
           *[other] Atvērt mapi
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Parādīt Finder
           *[other] Atvērt mapi
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Parādīt Finder
           *[other] Atvērt mapi
        }

downloads-cmd-show-downloads =
    .label = Rādīt lejupielāžu mapi
downloads-cmd-retry =
    .tooltiptext = Atkārtot
downloads-cmd-retry-panel =
    .aria-label = Atkārtot
downloads-cmd-go-to-download-page =
    .label = Iet uz lejupielādes lapu
    .accesskey = e
downloads-cmd-copy-download-link =
    .label = Kopēt lejupielādes adresi
    .accesskey = l
downloads-cmd-remove-from-history =
    .label = Notīrīt no vēstures
    .accesskey = o
downloads-cmd-clear-list =
    .label = Notīrīt priekšskatījuma paneli
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = Notīrīt lejupielādes
    .accesskey = d

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Atļaut lejupielādi
    .accesskey = a

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Aizvākt failu

downloads-cmd-remove-file-panel =
    .aria-label = Aizvākt failu

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Aizvākt failu vai atļaut lejupielādi

downloads-cmd-choose-unblock-panel =
    .aria-label = Aizvākt failu vai atļaut lejupielādi

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Atvērt vai aizvākt failu

downloads-cmd-choose-open-panel =
    .aria-label = Atvērt vai aizvākt failu

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Rādīt papildus informāciju

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Atvērt failu

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Mēģināt vēlreiz lejupielādēt

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Atcelt lejupielādi

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Rādīt visas lejupielādes
    .accesskey = s

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Lejupielādes informācija

downloads-clear-downloads-button =
    .label = Notīrīt lejupielādes
    .tooltiptext = Notīra pabeigtās, atceltās un neveiksmīgās lejupielādes

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Nav nevienas lejupielādes.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Šajā sesijā nav nevienas lejupielādes.
