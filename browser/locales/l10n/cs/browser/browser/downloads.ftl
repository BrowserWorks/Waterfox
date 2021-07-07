# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Stahování
downloads-panel =
    .aria-label = Stahování

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch
# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-items =
    .style = width: 35em
downloads-cmd-pause =
    .label = Pozastavit
    .accesskey = P
downloads-cmd-resume =
    .label = Pokračovat
    .accesskey = o
downloads-cmd-cancel =
    .tooltiptext = Zrušit
downloads-cmd-cancel-panel =
    .aria-label = Zrušit
# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Otevřít složku
    .accesskey = l
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Zobrazit ve Finderu
    .accesskey = F
downloads-cmd-use-system-default =
    .label = Otevřít v systémovém prohlížeči
    .accesskey = p
downloads-cmd-always-use-system-default =
    .label = Vždy otevírat v systémovém prohlížeči
    .accesskey = V
downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Zobrazit ve Finderu
           *[other] Otevřít složku
        }
downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Zobrazit ve Finderu
           *[other] Otevřít složku
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Zobrazit ve Finderu
           *[other] Otevřít složku
        }
downloads-cmd-show-downloads =
    .label = Otevřít složku se staženými soubory
downloads-cmd-retry =
    .tooltiptext = Opakovat
downloads-cmd-retry-panel =
    .aria-label = Opakovat
downloads-cmd-go-to-download-page =
    .label = Přejít na stránku stahování
    .accesskey = e
downloads-cmd-copy-download-link =
    .label = Kopírovat stahovaný odkaz
    .accesskey = K
downloads-cmd-remove-from-history =
    .label = Odstranit z historie
    .accesskey = d
downloads-cmd-clear-list =
    .label = Vymazat tento seznam
    .accesskey = m
downloads-cmd-clear-downloads =
    .label = Vymazat seznam
    .accesskey = m
# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Povolit stažení
    .accesskey = o
# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Odstranit soubor
downloads-cmd-remove-file-panel =
    .aria-label = Odstranit soubor
# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Odstranit soubor nebo povolit stažení
downloads-cmd-choose-unblock-panel =
    .aria-label = Odstranit soubor nebo povolit stažení
# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Otevřít nebo odstranit soubor
downloads-cmd-choose-open-panel =
    .aria-label = Otevřít nebo odstranit soubor
# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Zobrazit více informací
# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Otevřít soubor

## Displayed when the user clicked on a download in process. Indicates that the
## downloading file will be opened after certain amount of time using an app
## available in the system.
## Variables:
##   $hours (number) - Amount of hours left till the file opens.
##   $seconds (number) - Amount of seconds left till the file opens.
##   $minutes (number) - Amount of minutes till the file opens.

downloading-file-opens-in-hours-and-minutes = Otevře se za { $hours } h { $minutes } m…
downloading-file-opens-in-minutes = Otevře se za { $minutes } m…
downloading-file-opens-in-minutes-and-seconds = Otevře se za { $minutes } m { $seconds } s…
downloading-file-opens-in-seconds = Otevře se za { $seconds } s…
downloading-file-opens-in-some-time = Otevře se po dokončení stahování…

##

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Opakovat stahování
# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Zrušit stahování
# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Zobrazit všechna stahování
    .accesskey = v
# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Podrobnosti o stahování
downloads-clear-downloads-button =
    .label = Vymazat seznam
    .tooltiptext = Vymaže seznam dokončených, zrušených i neúspěšných stahování
# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Nejsou žádná stahování.
# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Žádná stahování pro tuto relaci.
