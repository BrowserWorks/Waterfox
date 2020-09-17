# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Pellgargadurioù
downloads-panel =
    .aria-label = Pellgargadurioù

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = Ehan
    .accesskey = E
downloads-cmd-resume =
    .label = Adkregiñ
    .accesskey = A
downloads-cmd-cancel =
    .tooltiptext = Nullañ
downloads-cmd-cancel-panel =
    .aria-label = Nullañ

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Digeriñ an teuliad a endalc'h ar restr
    .accesskey = D

# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Diskouez e-barzh Finder
    .accesskey = F

downloads-cmd-use-system-default =
    .label = Digeriñ e gwelerez ar sistem
    .accesskey = D

downloads-cmd-always-use-system-default =
    .label = Digeriñ bewech e gwelerez ar sistem
    .accesskey = b

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Diskouez e-barzh Finder
           *[other] Digeriñ an teuliad a endalc'h ar restr
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Diskouez e-barzh Finder
           *[other] Digeriñ an teuliad a endalc'h ar restr
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Diskouez e-barzh Finder
           *[other] Digeriñ an teuliad a endalc'h ar restr
        }

downloads-cmd-show-downloads =
    .label = Diskouez teuliad ar pellgargadurioù
downloads-cmd-retry =
    .tooltiptext = Klask en-dro
downloads-cmd-retry-panel =
    .aria-label = Klask en-dro
downloads-cmd-go-to-download-page =
    .label = Mont da bajenn ar pellgargadur
    .accesskey = M
downloads-cmd-copy-download-link =
    .label = Eilañ ere ar pellgargadur
    .accesskey = i
downloads-cmd-remove-from-history =
    .label = Lemel diwar ar roll istor
    .accesskey = e
downloads-cmd-clear-list =
    .label = Skarzhañ ar penel alberz
    .accesskey = z
downloads-cmd-clear-downloads =
    .label = Skarzhañ roll ar pellgargadurioù
    .accesskey = p

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Aotren ar pellgargañ
    .accesskey = o

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Dile&mel ar restr

downloads-cmd-remove-file-panel =
    .aria-label = Dile&mel ar restr

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Dilemel ar restr pe aotren ar pellgargañ

downloads-cmd-choose-unblock-panel =
    .aria-label = Dilemel ar restr pe aotren ar pellgargañ

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Digeriñ pe dilemel ar restr

downloads-cmd-choose-open-panel =
    .aria-label = Digeriñ pe dilemel ar restr

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Diskouez muioc'h a ditouroù

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Digeriñ ar restr

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Adklask ar bellgargañ

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Nullañ ar bellgargañ

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Diskouez an holl bellgargadurioù
    .accesskey = k

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Munudoù ar bellgargardenn

downloads-clear-downloads-button =
    .label = Skarzhañ roll ar pellgargadurioù
    .tooltiptext = Skarzhet eo bet ar pellgargadurioù peurechu, nullet ha c'hwitet

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = N'eus pellgargadur ebet.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Pellgargadur ebet evit an estez-mañ.
