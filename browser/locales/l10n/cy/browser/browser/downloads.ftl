# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Llwythi
downloads-panel =
    .aria-label = Llwythi

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = Oedi
    .accesskey = O
downloads-cmd-resume =
    .label = Ailgychwyn
    .accesskey = A
downloads-cmd-cancel =
    .tooltiptext = Diddymu
downloads-cmd-cancel-panel =
    .aria-label = Diddymu

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Agor Ffolder Cynnwys
    .accesskey = F

# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Dangos yn Finder
    .accesskey = F

downloads-cmd-use-system-default =
    .label = Agor yn Narllenydd System
    .accesskey = N

downloads-cmd-always-use-system-default =
    .label = Agor Bob Tro mewn Darllenydd System
    .accesskey = B

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Dangos yn Finder
           *[other] Agor Ffolder Cynnwys
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Dangos yn Finder
           *[other] Agor Ffolder Cynnwys
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Dangos yn Finder
           *[other] Agor Ffolder Cynnwys
        }

downloads-cmd-show-downloads =
    .label = Dangos y Ffowleder Llwythi
downloads-cmd-retry =
    .tooltiptext = Ceisio eto
downloads-cmd-retry-panel =
    .aria-label = Ceisio eto
downloads-cmd-go-to-download-page =
    .label = Mynd i'r Dudalen Llwytho i Lawr
    .accesskey = M
downloads-cmd-copy-download-link =
    .label = Copïo Dolen Llwytho i Lawr
    .accesskey = C
downloads-cmd-remove-from-history =
    .label = Tynnu o'r Hanes
    .accesskey = y
downloads-cmd-clear-list =
    .label = Clirio'r Panel Rhagolwg
    .accesskey = r
downloads-cmd-clear-downloads =
    .label = Clirio Llwythi
    .accesskey = L

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Caniatáu Llwytho i Lawr
    .accesskey = a

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Tynnu Ffeil

downloads-cmd-remove-file-panel =
    .aria-label = Tynnu Ffeil

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Tynnu Ffeil neu Ganiatáu Llwytho i Lawr

downloads-cmd-choose-unblock-panel =
    .aria-label = Tynnu Ffeil neu Ganiatáu Llwytho i Lawr

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Agor neu Dynnu'r Ffeil

downloads-cmd-choose-open-panel =
    .aria-label = Agor neu Dynnu'r Ffeil

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Dangos rhagor o wybodaeth

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Agor Ffeil

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Ceisio Llwytho i Lawr Eto

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Diddymu Llwytho i Lawr

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Dangos Pob Llwyth
    .accesskey = D

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Manylion y Llwytho i Lawr

downloads-clear-downloads-button =
    .label = Clirio'r Llwythi
    .tooltiptext = Yn clirio llwythi cwblhawyd, dilëwyd a methwyd

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Nid oes llwythi.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Dim llwytho i lawr yn ystod y sesiwn yma.
