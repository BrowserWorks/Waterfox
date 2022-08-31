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

downloads-cmd-show-menuitem-2 =
    .label =
        { PLATFORM() ->
            [macos] Zobrazit ve Finderu
           *[other] Otevřít složku
        }
    .accesskey =
        { PLATFORM() ->
            [macos] F
           *[other] l
        }

## Displayed in the downloads context menu for files that can be opened.
## Variables:
##   $handler (String) - The name of the mime type's default file handler.
##   Example: "Notepad", "Acrobat Reader DC", "7-Zip File Manager"

downloads-cmd-use-system-default =
    .label = Otevřít v systémovém prohlížeči
    .accesskey = p
# This version is shown when the download's mime type has a valid file handler.
downloads-cmd-use-system-default-named =
    .label = Otevřít v programu { $handler }
    .accesskey = O

# We can use the same accesskey as downloads-cmd-always-open-similar-files.
# Both should not be visible in the downloads context menu at the same time.
downloads-cmd-always-use-system-default =
    .label = Vždy otevírat v systémovém prohlížeči
    .accesskey = V
# We can use the same accesskey as downloads-cmd-always-open-similar-files.
# Both should not be visible in the downloads context menu at the same time.
# This version is shown when the download's mime type has a valid file handler.
downloads-cmd-always-use-system-default-named =
    .label = Vždy otevírat v programu { $handler }
    .accesskey = V

##

# We can use the same accesskey as downloads-cmd-always-use-system-default.
# Both should not be visible in the downloads context menu at the same time.
downloads-cmd-always-open-similar-files =
    .label = Vždy otevírat podobné soubory
    .accesskey = V

downloads-cmd-show-button-2 =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Zobrazit ve Finderu
           *[other] Otevřít složku
        }

downloads-cmd-show-panel-2 =
    .aria-label =
        { PLATFORM() ->
            [macos] Zobrazit ve Finderu
           *[other] Otevřít složku
        }
downloads-cmd-show-description-2 =
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
downloads-cmd-delete-file =
    .label = Smazat
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
downloading-file-click-to-open =
    .value = Otevřít po dokončení stahování

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

## Displayed when a site attempts to automatically download many files.
## Variables:
##   $num (number) - Number of blocked downloads.
##   $url (string) - The url of the suspicious site, stripped of http, https and www prefix.

downloads-files-not-downloaded =
    { $num ->
        [one] Soubor nebyl stažen.
        [few] { $num } soubory nebyly staženy.
       *[other] { $num } souborů nebylo staženo.
    }
downloads-blocked-from-url = Stahování ze stránky { $url } bylo zablokováno.
downloads-blocked-download-detailed-info = Stránka { $url } se pokusila automaticky stáhnout několik souborů. Může se jednat o chybu na stránce, ale také o její záměr na vaše zařízení uložit nevyžádané soubory.

##

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

# This is displayed in an item at the bottom of the Downloads Panel when there
# are more downloads than can fit in the list in the panel.
#   $count (number) - number of files being downloaded that are not shown in the
#                     panel list.
downloads-more-downloading =
    { $count ->
        [one] Stahuje se jeden další soubor
        [few] Stahují se { $count } další soubory
       *[other] Stahuje se { $count } dalších souborů
    }
