# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Сцягванні
downloads-panel =
    .aria-label = Сцягванні

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch

downloads-cmd-pause =
    .label = Прыпыніць
    .accesskey = П
downloads-cmd-resume =
    .label = Працягнуць
    .accesskey = П
downloads-cmd-cancel =
    .tooltiptext = Скасаваць
downloads-cmd-cancel-panel =
    .aria-label = Скасаваць

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Адкрыць змяшчальную папку
    .accesskey = А

# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Паказаць у шукальніку
    .accesskey = ш

downloads-cmd-use-system-default =
    .label = Адкрыць у сістэмным праглядальніку
    .accesskey = м

downloads-cmd-always-use-system-default =
    .label = Заўжды адкрываць у сістэмным праглядальніку
    .accesskey = ц

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Паказаць у шукальніку
           *[other] Адкрыць змяшчальную папку
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Паказаць у шукальніку
           *[other] Адкрыць змяшчальную папку
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Паказаць у шукальніку
           *[other] Адкрыць змяшчальную папку
        }

downloads-cmd-show-downloads =
    .label = Паказаць папку сцягванняў
downloads-cmd-retry =
    .tooltiptext = Паўтарыць
downloads-cmd-retry-panel =
    .aria-label = Паўтарыць
downloads-cmd-go-to-download-page =
    .label = Паказаць старонку сцягвання
    .accesskey = з
downloads-cmd-copy-download-link =
    .label = Капіяваць спасылку сцягвання
    .accesskey = К
downloads-cmd-remove-from-history =
    .label = Выдаліць з гісторыі
    .accesskey = г
downloads-cmd-clear-list =
    .label = Ачысціць панэль перадпаказу
    .accesskey = ч
downloads-cmd-clear-downloads =
    .label = Ачысціць сцягванні
    .accesskey = с

# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Дазволіць сцягванне
    .accesskey = о

# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Сцерці файл

downloads-cmd-remove-file-panel =
    .aria-label = Сцерці файл

# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Сцерці файл ці дазволіць сцягванне

downloads-cmd-choose-unblock-panel =
    .aria-label = Сцерці файл ці дазволіць сцягванне

# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Адкрыць ці сцерці файл

downloads-cmd-choose-open-panel =
    .aria-label = Адкрыць ці сцерці файл

# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Паказаць больш звестак

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Адкрыць файл

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Паўтарыць сцягванне

# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Скасаваць сцягванне

# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Паказаць усе сцягванні
    .accesskey = у

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Падрабязнасці сцягвання

downloads-clear-downloads-button =
    .label = Ачысціць сцягванні
    .tooltiptext = Ачысціць скончаныя, скасованыя і няўдачныя сцягванні

# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Няма сцягванняў.

# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Няма сцягванняў у гэтым сеансе.
