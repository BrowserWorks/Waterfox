# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Zumandey
downloads-panel =
    .aria-label = Zumandey

##

downloads-cmd-pause =
    .label = Hunanzam
    .accesskey = H
downloads-cmd-resume =
    .label = Šintin taaga
    .accesskey = Š
downloads-cmd-cancel =
    .tooltiptext = Naŋ
downloads-cmd-cancel-panel =
    .aria-label = Naŋ

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Feeri foolo kaŋ goo nda
    .accesskey = f
  
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Cebe Finder ra
    .accesskey = F

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Cebe Finder ra
           *[other] Feeri foolo kaŋ goo nda
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Cebe Finder ra
           *[other] Feeri foolo kaŋ goo nda
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Cebe Finder ra
           *[other] Feeri foolo kaŋ goo nda
        }

downloads-cmd-retry =
    .tooltiptext = Šii taaga
downloads-cmd-retry-panel =
    .aria-label = Šii taaga
downloads-cmd-go-to-download-page =
    .label = Koy zumandiyan moo ga
    .accesskey = K
downloads-cmd-copy-download-link =
    .label = Zumandi doboo berandi
    .accesskey = d
downloads-cmd-remove-from-history =
    .label = Kaa taarikoo ra
    .accesskey = a
downloads-cmd-clear-list =
    .label = Moofur feddiyoo kaa
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = Zumandey tuusu
    .accesskey = d

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Zumandiyan noo fondo
    .accesskey = o

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Tukoo kaa

downloads-cmd-remove-file-panel =
    .aria-label = Tukoo kaa

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Tuku kaa wala yadda zumandiyan ga

downloads-cmd-choose-unblock-panel =
    .aria-label = Tuku kaa wala yadda zumandiyan ga

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Tuku feeri wal'a kaa

downloads-cmd-choose-open-panel =
    .aria-label = Tuku feeri wal'a kaa

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Alhabar cebe ka tonton

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Tuku feeri

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Zumandoo ceeci koyne

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Zumandoo naŋ

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Zumandey kul cebe
    .accesskey = c

downloads-clear-downloads-button =
    .label = Zumandey tuusu
    .tooltiptext = Zumandey kaŋ timme, naŋandi nda hasara tuusu

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Zumandi kul ši bara.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Zumandi kul ši batoo woo se.
