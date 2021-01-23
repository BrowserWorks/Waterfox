# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Sćehnjenja
downloads-panel =
    .aria-label = Sćehnjenja

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = Přestawka
    .accesskey = P
downloads-cmd-resume =
    .label = Pokročować
    .accesskey = k
downloads-cmd-cancel =
    .tooltiptext = Přetorhnyć
downloads-cmd-cancel-panel =
    .aria-label = Přetorhnyć

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Wobsahowacy rjadowak wočinić
    .accesskey = b
  
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = W programje Finder pokazać
    .accesskey = F

downloads-cmd-use-system-default =
    .label = W systemowym wobhladowaku wočinić
    .accesskey = h

downloads-cmd-always-use-system-default =
    .label = Přeco w systemowym wobhladowaku wočinić
    .accesskey = P

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] W programje Finder pokazać
           *[other] Wobsahowacy rjadowak wočinić
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] W programje Finder pokazać
           *[other] Wobsahowacy rjadowak wočinić
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] W programje Finder pokazać
           *[other] Wobsahowacy rjadowak wočinić
        }

downloads-cmd-show-downloads =
    .label = Rjadowak sćehnjenjow pokazać
downloads-cmd-retry =
    .tooltiptext = Hišće raz spytać
downloads-cmd-retry-panel =
    .aria-label = Hišće raz spytać
downloads-cmd-go-to-download-page =
    .label = K stronje sćehnjenja hić
    .accesskey = s
downloads-cmd-copy-download-link =
    .label = Sćehnjenski wotkaz kopěrować
    .accesskey = w
downloads-cmd-remove-from-history =
    .label = Z historije wotstronić
    .accesskey = h
downloads-cmd-clear-list =
    .label = Přehladowe wokno wuprózdnić
    .accesskey = h
downloads-cmd-clear-downloads =
    .label = Sćehnjenja zhašeć
    .accesskey = z

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Sćehnjenje dowolić
    .accesskey = d

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Dataju wotstronić

downloads-cmd-remove-file-panel =
    .aria-label = Dataju wotstronić

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Dataju wotstronić abo sćehnjenje dowolić

downloads-cmd-choose-unblock-panel =
    .aria-label = Dataju wotstronić abo sćehnjenje dowolić

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Dataju wočinić abo wotstronić

downloads-cmd-choose-open-panel =
    .aria-label = Dataju wočinić abo wotstronić

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Dalše informacije pokazać

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Dataju wočinić

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Sćehnjenje znowa spytać

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Sćehnjenje přetorhnyć

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Wšě sćehnjenja pokazać
    .accesskey = W

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Sćehnjenske podrobnosće

downloads-clear-downloads-button =
    .label = Sćehnjenja zhašeć
    .tooltiptext = Zhaša skónčene, přetorhnjene a njeporadźene sćehnjenja

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Sćehnjenja njejsu.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Žane sćehnjenja za tute posedźenje.
