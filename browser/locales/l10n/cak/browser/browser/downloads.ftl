# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Taq qasanïk
downloads-panel =
    .aria-label = Taq qasanïk

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = Rupab'axik
    .accesskey = R
downloads-cmd-resume =
    .label = Titikïr chik el
    .accesskey = T
downloads-cmd-cancel =
    .tooltiptext = Tiq'at
downloads-cmd-cancel-panel =
    .aria-label = Tiq'at

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Tijaq K'wayöl Yakwuj
    .accesskey = Y

# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Tik'ut Pa Finder
    .accesskey = F

downloads-cmd-use-system-default =
    .label = Tijaq pa ri Rutz'etöy Q'inoj
    .accesskey = t

downloads-cmd-always-use-system-default =
    .label = Junelïk tijaq pa ri Rutz'etöy Q'inoj
    .accesskey = J

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Tik'ut pe pan ilonel
           *[other] Tijaq ri yaksamaj k'o rupam
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Tik'ut pe pan ilonel
           *[other] Tijaq ri yaksamaj k'o rupam
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Tik'ut pe pan ilonel
           *[other] Tijaq ri yaksamaj k'o rupam
        }

downloads-cmd-show-downloads =
    .label = Tik'ut pe Kiyakwuj taq Qasanïk
downloads-cmd-retry =
    .tooltiptext = Titojtob'ëx chik
downloads-cmd-retry-panel =
    .aria-label = Titojtob'ëx chik
downloads-cmd-go-to-download-page =
    .label = Tib'e pa ri ruxaq akuchi' niqasäx
    .accesskey = T
downloads-cmd-copy-download-link =
    .label = Tiwachib'ëx Ruximonel Qasanïk
    .accesskey = R
downloads-cmd-remove-from-history =
    .label = Tiyuj Pa Natab'äl
    .accesskey = y
downloads-cmd-clear-list =
    .label = Tiyuj nab'ey tz'ub'al pas
    .accesskey = y
downloads-cmd-clear-downloads =
    .label = Kejosq'ïx taq Qasanïk
    .accesskey = Q

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Tiya' q'ij chi tiqasäx
    .accesskey = a

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Tiyuj Yakb'äl

downloads-cmd-remove-file-panel =
    .aria-label = Tiyuj Yakb'äl

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Telesäx el ri yakb'äl o Tiya' q'ij chi tiqasäx

downloads-cmd-choose-unblock-panel =
    .aria-label = Telesäx el ri yakb'äl o Tiya' q'ij chi tiqasäx

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Tijaq o telesäx el ri yakb'äl

downloads-cmd-choose-open-panel =
    .aria-label = Tijaq o telesäx el ri yakb'äl

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Kek'ut pe ch'aqa' chik rutzijol

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Tijaq Yakb'äl

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Titojtob'ëx chik Niqasäx

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Tiq'at qasanïk

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Kekut pe ronojel ri qasan
    .accesskey = K

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Rub'anikil Qasanïk

downloads-clear-downloads-button =
    .label = Kejosq'ïx taq Qasanïk
    .tooltiptext = Tijosq'ïx ronojel, q'aton chuqa' man ütz ta taq qasanïk

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Majun chik qasan

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Majun ruqasanik re molojri'ïl re'.
