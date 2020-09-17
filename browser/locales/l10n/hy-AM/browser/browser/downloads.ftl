# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Ներբեռնումներ
downloads-panel =
    .aria-label = Ներբեռնումներ

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = Ընդմիջել
    .accesskey = P
downloads-cmd-resume =
    .label = Շարունակել
    .accesskey = R
downloads-cmd-cancel =
    .tooltiptext = Չեղարկել
downloads-cmd-cancel-panel =
    .aria-label = Չեղարկել

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Բացել թղթապանակը
    .accesskey = F

# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Ցուցադրել Finder-ում
    .accesskey = F

downloads-cmd-use-system-default =
    .label = Բացել համակարգի դիտակում
    .accesskey = V

downloads-cmd-always-use-system-default =
    .label = Միշտ բացել համակարգի դիտակում
    .accesskey = w

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Ցուցադրել Finder-ում
           *[other] Բացել թղթապանակը
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Ցուցադրել Finder-ում
           *[other] Բացել թղթապանակը
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Ցուցադրել Finder-ում
           *[other] Բացել թղթապանակը
        }

downloads-cmd-show-downloads =
    .label = Ցուցադրել Ներբեռնումների թղթապանակը
downloads-cmd-retry =
    .tooltiptext = Կրկնել
downloads-cmd-retry-panel =
    .aria-label = Կրկնել
downloads-cmd-go-to-download-page =
    .label = Բացել բեռնելու կայքը
    .accesskey = Բ
downloads-cmd-copy-download-link =
    .label = Պատճենել ներբեռնելու հղումը
    .accesskey = հ
downloads-cmd-remove-from-history =
    .label = Ջնջել Պատմությունից
    .accesskey = ն
downloads-cmd-clear-list =
    .label = Մաքրել նախադիտման վահանակը
    .accesskey = ր
downloads-cmd-clear-downloads =
    .label = Մաքրել Ներբեռնումները
    .accesskey = Ն

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Թույլատրել ներբեռնումը
    .accesskey = ա

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Հեռացնել ֆայլը

downloads-cmd-remove-file-panel =
    .aria-label = Հեռացնել ֆայլը

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Հեռացնել ֆայլը կամ Թույլատրել ներբեռնումը

downloads-cmd-choose-unblock-panel =
    .aria-label = Հեռացնել ֆայլը կամ Թույլատրել ներբեռնումը

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Բացել կամ հեռացնել ֆայլը

downloads-cmd-choose-open-panel =
    .aria-label = Բացել կամ հեռացնել ֆայլը

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Ցուցադրել լր. տեղեկություն

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Բացել Ֆայլ

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Կրկնել ներբեռնումը

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Չեղարկել ներբեռնումը

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Ցուցադրել բոլոր ներբեռնումները
    .accesskey = S

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Ներբեռնմանի մանրամասները

downloads-clear-downloads-button =
    .label = Մաքրել ներբեռնումները
    .tooltiptext = Հեռացնում է ավարտված, չեղարկված և ձախողված ներբեռնումները

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Չկան ներբեռնումներ։

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Չկան ներբեռնումներ այս աշխատաշրջանում:
