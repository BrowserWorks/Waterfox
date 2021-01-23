# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Ześěgnjenja
downloads-panel =
    .aria-label = Ześěgnjenja

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = Pawza
    .accesskey = P
downloads-cmd-resume =
    .label = Pókšacowaś
    .accesskey = k
downloads-cmd-cancel =
    .tooltiptext = Pśetergnuś
downloads-cmd-cancel-panel =
    .aria-label = Pśetergnuś

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Celowy zarědnik wócyniś
    .accesskey = C

# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = W programje Finder pokazaś
    .accesskey = F

downloads-cmd-use-system-default =
    .label = W systemowem wobglědowaku wócyniś
    .accesskey = l

downloads-cmd-always-use-system-default =
    .label = Pśecej w systemowem wobglědowaku wócyniś
    .accesskey = P

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] W programje Finder pokazaś
           *[other] Celowy zarědnik wócyniś
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] W programje Finder pokazaś
           *[other] Celowy zarědnik wócyniś
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] W programje Finder pokazaś
           *[other] Celowy zarědnik wócyniś
        }

downloads-cmd-show-downloads =
    .label = Zarědnik ześěgnjenjow pokazaś
downloads-cmd-retry =
    .tooltiptext = Hyšći raz wopytaś
downloads-cmd-retry-panel =
    .aria-label = Hyšći raz wopytaś
downloads-cmd-go-to-download-page =
    .label = K bokoju ześěgnjenja
    .accesskey = b
downloads-cmd-copy-download-link =
    .label = Ześěgnjeński wótkaz kopěrowaś
    .accesskey = w
downloads-cmd-remove-from-history =
    .label = Z historije wótpóraś
    .accesskey = h
downloads-cmd-clear-list =
    .label = Pśegladowe wokno wuprozniś
    .accesskey = l
downloads-cmd-clear-downloads =
    .label = Ześěgnjenja lašowaś
    .accesskey = Z

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Ześěgnjenje dowóliś
    .accesskey = d

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Dataju wótpóraś

downloads-cmd-remove-file-panel =
    .aria-label = Dataju wótpóraś

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Dataju wótpóraś abo ześěgnjenje dowóliś

downloads-cmd-choose-unblock-panel =
    .aria-label = Dataju wótpóraś abo ześěgnjenje dowóliś

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Dataju wócyniś abo wótpóraś

downloads-cmd-choose-open-panel =
    .aria-label = Dataju wócyniś abo wótpóraś

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Dalšne informacije pokazaś

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Dataju wócyniś

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Ześěgnjenje znowego wopytaś

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Ześěgnjenje pśetergnuś

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Wšykne ześěgnjenja pokazaś
    .accesskey = W

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Ześěgnjeńske drobnostki

downloads-clear-downloads-button =
    .label = Ześěgnjenja lašowaś
    .tooltiptext = Wulašujo skóńcone, pśetergnjone a njeraźone ześěgnjenja

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Ześěgnjenja njejsu.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Žedne ześěgnjenja za toś to pósejźenje.
