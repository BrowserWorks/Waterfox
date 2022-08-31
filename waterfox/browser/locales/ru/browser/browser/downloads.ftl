# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Загрузки
downloads-panel =
    .aria-label = Загрузки

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-items =
    .style = width: 35em

downloads-cmd-pause =
    .label = Приостановить
    .accesskey = н
downloads-cmd-resume =
    .label = Возобновить
    .accesskey = б
downloads-cmd-cancel =
    .tooltiptext = Отменить
downloads-cmd-cancel-panel =
    .aria-label = Отменить

downloads-cmd-show-menuitem-2 =
    .label =
        { PLATFORM() ->
            [macos] Показать в Finder
           *[other] Показать в папке
        }
    .accesskey = а

## Displayed in the downloads context menu for files that can be opened.
## Variables:
##   $handler (String) - The name of the mime type's default file handler.
##   Example: "Notepad", "Acrobat Reader DC", "7-Zip File Manager"

downloads-cmd-use-system-default =
    .label = Открыть в программе просмотра по умолчанию
    .accesskey = м
# This version is shown when the download's mime type has a valid file handler.
downloads-cmd-use-system-default-named =
    .label = Открыть в { $handler }
    .accesskey = ы

# We can use the same accesskey as downloads-cmd-always-open-similar-files.
# Both should not be visible in the downloads context menu at the same time.
downloads-cmd-always-use-system-default =
    .label = Всегда открывать в программе просмотра по умолчанию
    .accesskey = ю
# We can use the same accesskey as downloads-cmd-always-open-similar-files.
# Both should not be visible in the downloads context menu at the same time.
# This version is shown when the download's mime type has a valid file handler.
downloads-cmd-always-use-system-default-named =
    .label = Всегда открывать в { $handler }
    .accesskey = е

##

# We can use the same accesskey as downloads-cmd-always-use-system-default.
# Both should not be visible in the downloads context menu at the same time.
downloads-cmd-always-open-similar-files =
    .label = Всегда открывать подобные файлы
    .accesskey = й

downloads-cmd-show-button-2 =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Показать в Finder
           *[other] Показать в папке
        }

downloads-cmd-show-panel-2 =
    .aria-label =
        { PLATFORM() ->
            [macos] Показать в Finder
           *[other] Показать в папке
        }
downloads-cmd-show-description-2 =
    .value =
        { PLATFORM() ->
            [macos] Показать в Finder
           *[other] Показать в папке
        }

downloads-cmd-show-downloads =
    .label = Показать папку загрузок
downloads-cmd-retry =
    .tooltiptext = Повторить
downloads-cmd-retry-panel =
    .aria-label = Повторить
downloads-cmd-go-to-download-page =
    .label = Перейти на страницу загрузки
    .accesskey = н
downloads-cmd-copy-download-link =
    .label = Копировать ссылку на загрузку
    .accesskey = с
downloads-cmd-remove-from-history =
    .label = Удалить из истории
    .accesskey = л
downloads-cmd-clear-list =
    .label = Очистить панель предпросмотра
    .accesskey = ч
downloads-cmd-clear-downloads =
    .label = Очистить загрузки
    .accesskey = и
downloads-cmd-delete-file =
    .label = Удалить
    .accesskey = л

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Разрешить загрузку
    .accesskey = р

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Удалить файл

downloads-cmd-remove-file-panel =
    .aria-label = Удалить файл

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Удалить файл или разрешить загрузку

downloads-cmd-choose-unblock-panel =
    .aria-label = Удалить файл или разрешить загрузку

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Открыть или удалить файл

downloads-cmd-choose-open-panel =
    .aria-label = Открыть или удалить файл

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Показать больше информации

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Открыть файл

## Displayed when the user clicked on a download in process. Indicates that the
## downloading file will be opened after certain amount of time using an app
## available in the system.
## Variables:
##   $hours (number) - Amount of hours left till the file opens.
##   $seconds (number) - Amount of seconds left till the file opens.
##   $minutes (number) - Amount of minutes till the file opens.

downloading-file-opens-in-hours-and-minutes = Откроется через { $hours } ч { $minutes } мин…
downloading-file-opens-in-minutes = Откроется через { $minutes } мин…
downloading-file-opens-in-minutes-and-seconds = Откроется через { $minutes } мин { $seconds } с…
downloading-file-opens-in-seconds = Откроется через { $seconds } с…
downloading-file-opens-in-some-time = Откроется после завершения…
downloading-file-click-to-open =
    .value = Открыть по завершении

##

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Повторить загрузку

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Отменить загрузку

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Показать все загрузки
    .accesskey = а

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Сведения о загрузке

## Displayed when a site attempts to automatically download many files.
## Variables:
##   $num (number) - Number of blocked downloads.
##   $url (string) - The url of the suspicious site, stripped of http, https and www prefix.

downloads-files-not-downloaded =
    { $num ->
        [one] { $num } файл не загружен.
        [few] { $num } файла не загружено.
       *[many] { $num } файлов не загружены.
    }
downloads-blocked-from-url = Загрузки с { $url } заблокированы.
downloads-blocked-download-detailed-info = { $url } пытался автоматически загрузить большое число файлов. Возможно, сайт был неисправен или пытался разместить спам-файлы на вашем устройстве.

##

downloads-clear-downloads-button =
    .label = Очистить загрузки
    .tooltiptext = Очистить завершённые, отменённые и неудавшиеся загрузки

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Загрузок нет.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = В этой сессии загрузок не было.

# This is displayed in an item at the bottom of the Downloads Panel when there
# are more downloads than can fit in the list in the panel.
#   $count (number) - number of files being downloaded that are not shown in the
#                     panel list.
downloads-more-downloading =
    { $count ->
        [one] Загружается ещё { $count } файл
        [few] Загружается ещё { $count } файла
       *[many] Загружается ещё { $count } файлов
    }
