# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Преузимања
downloads-panel =
    .aria-label = Преузимања

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 74ch

downloads-cmd-pause =
    .label = Паузирај
    .accesskey = P
downloads-cmd-resume =
    .label = Настави
    .accesskey = R
downloads-cmd-cancel =
    .tooltiptext = Откажи
downloads-cmd-cancel-panel =
    .aria-label = Откажи

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Отвори фасциклу са преузетим садржајем
    .accesskey = F

# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Прикажи у Finder-у
    .accesskey = F

downloads-cmd-use-system-default =
    .label = Отворите у системском прегледачу
    .accesskey = V

downloads-cmd-always-use-system-default =
    .label = Увек отворите у системском прегледачу
    .accesskey = w

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Прикажи у Finder-у
           *[other] Отвори фасциклу са преузетим садржајем
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Прикажи у Finder-у
           *[other] Отвори фасциклу са преузетим садржајем
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Прикажи у Finder-у
           *[other] Отвори фасциклу са преузетим садржајем
        }

downloads-cmd-show-downloads =
    .label = Прикажи фасциклу преузимања
downloads-cmd-retry =
    .tooltiptext = Покушај поново
downloads-cmd-retry-panel =
    .aria-label = Покушај поново
downloads-cmd-go-to-download-page =
    .label = Иди на станицу за преузимања
    .accesskey = G
downloads-cmd-copy-download-link =
    .label = Копирај везу за преузимање
    .accesskey = L
downloads-cmd-remove-from-history =
    .label = Уклони из историје
    .accesskey = e
downloads-cmd-clear-list =
    .label = Обриши панел за преглед
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = Обриши преузимања
    .accesskey = D

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Дозволи преузимање
    .accesskey = o

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Уклони датотеку

downloads-cmd-remove-file-panel =
    .aria-label = Уклони датотеку

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Отвори датотеку или дозволи преузимање

downloads-cmd-choose-unblock-panel =
    .aria-label = Отвори датотеку или дозволи преузимање

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Отвори или уклони датотеку

downloads-cmd-choose-open-panel =
    .aria-label = Отвори или уклони датотеку

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Прикажи више информација

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Отвори датотеку

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Понови преузимање

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Откажи преузимање

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Прикажи сва преузимања
    .accesskey = S

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Детаљи преузимања

downloads-clear-downloads-button =
    .label = Обриши преузимања
    .tooltiptext = Брише завршена, отказана и неуспела преузимања

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Нема преузимања.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Нема преузимања у току ове сесије.
