# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Изтегляния
downloads-panel =
    .aria-label = Изтегляния

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of 
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = Пауза
    .accesskey = П
downloads-cmd-resume =
    .label = Продължаване
    .accesskey = П
downloads-cmd-cancel =
    .tooltiptext = Прекъсване
downloads-cmd-cancel-panel =
    .aria-label = Прекъсване

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Отваряне на съдържащата папка
    .accesskey = п
  
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Показване във Finder
    .accesskey = F

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Показване във Finder
           *[other] Отваряне на съдържащата папка
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Показване във Finder
           *[other] Отваряне на съдържащата папка
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Показване във Finder
           *[other] Отваряне на съдържащата папка
        }

downloads-cmd-show-downloads =
    .label = Отваряне на папка Изтегляния
downloads-cmd-retry =
    .tooltiptext = Повторен опит
downloads-cmd-retry-panel =
    .aria-label = Повторен опит
downloads-cmd-go-to-download-page =
    .label = Отваряне на целевата страница
    .accesskey = О
downloads-cmd-copy-download-link =
    .label = Копиране на препратка за изтегляне
    .accesskey = К
downloads-cmd-remove-from-history =
    .label = Премахване от списъка
    .accesskey = П
downloads-cmd-clear-list =
    .label = Изчистване на списъка
    .accesskey = п
downloads-cmd-clear-downloads =
    .label = Почистване на списъка
    .accesskey = п

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Разрешаване на изтеглянето
    .accesskey = Р

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Премахване на файла

downloads-cmd-remove-file-panel =
    .aria-label = Премахване на файла

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Премахване на файла или разрешаване на изтеглянето

downloads-cmd-choose-unblock-panel =
    .aria-label = Премахване на файла или разрешаване на изтеглянето

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Отваряне или премахване на файл

downloads-cmd-choose-open-panel =
    .aria-label = Отваряне или премахване на файл

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Повече информация

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Отваряне

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Повторен опит за изтегляне

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Прекъсване

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Показване на всички изтегляния
    .accesskey = в

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Подробности за изтеглянето

downloads-clear-downloads-button =
    .label = Почистване на списъка
    .tooltiptext = Премахва завършили, отменени и неуспешни изтегляния от списъка

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Списъкът с изтегляния е празен.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = За момента няма изтеглени файлове.
