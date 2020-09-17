# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Okukhutshelweyo
downloads-panel =
    .aria-label = Okukhutshelweyo

##

downloads-cmd-pause =
    .label = Isiqabu
    .accesskey = I
downloads-cmd-resume =
    .label = Buyela kwakhona
    .accesskey = B
downloads-cmd-cancel =
    .tooltiptext = Rhoxisa
downloads-cmd-cancel-panel =
    .aria-label = Rhoxisa

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Vula ifolda enento
    .accesskey = f
  
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Bonisa KwiSifumanisi
    .accesskey = S

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Bonisa KwiSifumanisi
           *[other] Vula ifolda enento
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Bonisa KwiSifumanisi
           *[other] Vula ifolda enento
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Bonisa KwiSifumanisi
           *[other] Vula ifolda enento
        }

downloads-cmd-retry =
    .tooltiptext = Phinda uzame
downloads-cmd-retry-panel =
    .aria-label = Phinda uzame
downloads-cmd-go-to-download-page =
    .label = Yiya kwikhasi lokukhutshelwayo
    .accesskey = Y
downloads-cmd-copy-download-link =
    .label = Khuphela iqhosha lokukhutshelwayo
    .accesskey = i
downloads-cmd-remove-from-history =
    .label = Khupha kwimbali
    .accesskey = u
downloads-cmd-clear-list =
    .label = Cima iPhanele yamaVandlakanya
    .accesskey = m
downloads-cmd-clear-downloads =
    .label = Susa okukhutshelwayo
    .accesskey = u

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Vumela Ukudawunlowuda
    .accesskey = e

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Susa iFayile

downloads-cmd-remove-file-panel =
    .aria-label = Susa iFayile

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Susa iFayile okanye uVumele ukuDawnlowuda

downloads-cmd-choose-unblock-panel =
    .aria-label = Susa iFayile okanye uVumele ukuDawnlowuda

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Vula okanye uSuse iFayile

downloads-cmd-choose-open-panel =
    .aria-label = Vula okanye uSuse iFayile

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Bonisa inkcazelo engakumbi

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Vula iFayile

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Phinda uZame ukuDawnlowuda

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Rhoxisa ukuDawnlowuda

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Bonisa konke okukhutshelwayo
    .accesskey = o

downloads-clear-downloads-button =
    .label = Susa okukhutshelwayo
    .tooltiptext = Isusa okukhutshelwayo okugqityiweyo, okurhoxisiweyo nokungaphumelelanga

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Akukho okukhutshelwayo.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Akukho lukhuphelo lwale seshoni.
