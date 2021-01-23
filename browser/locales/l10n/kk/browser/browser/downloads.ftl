# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Жүктемелер
downloads-panel =
    .aria-label = Жүктемелер

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = Аялдату
    .accesskey = А
downloads-cmd-resume =
    .label = Жалғастыру
    .accesskey = Ж
downloads-cmd-cancel =
    .tooltiptext = Бас тарту
downloads-cmd-cancel-panel =
    .aria-label = Бас тарту

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Файл орналасқан буманы ашу
    .accesskey = а

# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Finder ішінен көрсету
    .accesskey = ш

downloads-cmd-use-system-default =
    .label = Жүйелік көрсету қолданбасында ашу
    .accesskey = л

downloads-cmd-always-use-system-default =
    .label = Әрқашан жүйелік көрсету қолданбасында ашу
    .accesskey = ш

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Finder ішінен көрсету
           *[other] Файл орналасқан буманы ашу
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Finder ішінен көрсету
           *[other] Файл орналасқан буманы ашу
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Finder ішінен көрсету
           *[other] Файл орналасқан буманы ашу
        }

downloads-cmd-show-downloads =
    .label = Жүктемелер бумасын көрсету
downloads-cmd-retry =
    .tooltiptext = Қайталау
downloads-cmd-retry-panel =
    .aria-label = Қайталау
downloads-cmd-go-to-download-page =
    .label = Жүктемелер парағына өту
    .accesskey = Ж
downloads-cmd-copy-download-link =
    .label = Жүктеу сілтемесін көшіріп алу
    .accesskey = к
downloads-cmd-remove-from-history =
    .label = Тарихтан өшіру
    .accesskey = Т
downloads-cmd-clear-list =
    .label = Алдын-ала қарау панелін тазарту
    .accesskey = з
downloads-cmd-clear-downloads =
    .label = Жүктемелерді тазарту
    .accesskey = д

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Жүктемені рұқсат ету
    .accesskey = а

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Файлды өшіру

downloads-cmd-remove-file-panel =
    .aria-label = Файлды өшіру

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Файлды өшіру немесе жүктемені рұқсат ету

downloads-cmd-choose-unblock-panel =
    .aria-label = Файлды өшіру немесе жүктемені рұқсат ету

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Файлды ашу немесе өшіру

downloads-cmd-choose-open-panel =
    .aria-label = Файлды ашу немесе өшіру

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Көбірек ақпаратты көрсету

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Файлды ашу

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Жүктеп алуды қайталау

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Жүктемеден бас тарту

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Барлық жүктемелерді көрсету
    .accesskey = к

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Жүктеме қасиеттері

downloads-clear-downloads-button =
    .label = Жүктемелерді тазарту
    .tooltiptext = Аяқталған, бас тартылған және сәтсіз жүктемелерді тазартады

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Жүктемелер жоқ.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Бұл сессия үшін жүктемелер жоқ.
