# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = Letöltések
downloads-panel =
    .aria-label = Letöltések

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-items =
    .style = width: 35em
downloads-cmd-pause =
    .label = Szünet
    .accesskey = S
downloads-cmd-resume =
    .label = Folytatás
    .accesskey = F
downloads-cmd-cancel =
    .tooltiptext = Mégse
downloads-cmd-cancel-panel =
    .aria-label = Mégse
downloads-cmd-show-menuitem-2 =
    .label =
        { PLATFORM() ->
            [macos] Megjelenítés mappában
           *[other] Megjelenítés mappában
        }
    .accesskey = m

## Displayed in the downloads context menu for files that can be opened.
## Variables:
##   $handler (String) - The name of the mime type's default file handler.
##   Example: "Notepad", "Acrobat Reader DC", "7-Zip File Manager"

downloads-cmd-use-system-default =
    .label = Megnyitás a rendszer megjelenítőjében
    .accesskey = j
# This version is shown when the download's mime type has a valid file handler.
downloads-cmd-use-system-default-named =
    .label = Megnyitás itt: { $handler }
    .accesskey = M
# We can use the same accesskey as downloads-cmd-always-open-similar-files.
# Both should not be visible in the downloads context menu at the same time.
downloads-cmd-always-use-system-default =
    .label = Megnyitás mindig a rendszer megjelenítőjében
    .accesskey = m
# We can use the same accesskey as downloads-cmd-always-open-similar-files.
# Both should not be visible in the downloads context menu at the same time.
# This version is shown when the download's mime type has a valid file handler.
downloads-cmd-always-use-system-default-named =
    .label = Megnyitás mindig itt: { $handler }
    .accesskey = d

##

# We can use the same accesskey as downloads-cmd-always-use-system-default.
# Both should not be visible in the downloads context menu at the same time.
downloads-cmd-always-open-similar-files =
    .label = Mindig nyissa meg a hasonló fájlokat
    .accesskey = M
downloads-cmd-show-button-2 =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Megjelenítés mappában
           *[other] Megjelenítés mappában
        }
downloads-cmd-show-panel-2 =
    .aria-label =
        { PLATFORM() ->
            [macos] Megjelenítés mappában
           *[other] Megjelenítés mappában
        }
downloads-cmd-show-description-2 =
    .value =
        { PLATFORM() ->
            [macos] Megjelenítés mappában
           *[other] Megjelenítés mappában
        }
downloads-cmd-show-downloads =
    .label = Letöltési mappa megjelenítése
downloads-cmd-retry =
    .tooltiptext = Újra
downloads-cmd-retry-panel =
    .aria-label = Újra
downloads-cmd-go-to-download-page =
    .label = Ugrás a letöltési oldalra
    .accesskey = U
downloads-cmd-copy-download-link =
    .label = Letöltési hivatkozás másolása
    .accesskey = L
downloads-cmd-remove-from-history =
    .label = Törlés az előzményekből
    .accesskey = e
downloads-cmd-clear-list =
    .label = Előnézeti panel törlése
    .accesskey = t
downloads-cmd-clear-downloads =
    .label = Letöltések törlése
    .accesskey = L
downloads-cmd-delete-file =
    .label = Törlés
    .accesskey = T
# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = Letöltés engedélyezése
    .accesskey = L
# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = Fájl eltávolítása
downloads-cmd-remove-file-panel =
    .aria-label = Fájl eltávolítása
# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = Fájl eltávolítása vagy letöltés engedélyezése
downloads-cmd-choose-unblock-panel =
    .aria-label = Fájl eltávolítása vagy letöltés engedélyezése
# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = Megnyitás vagy fájl eltávolítása
downloads-cmd-choose-open-panel =
    .aria-label = Megnyitás vagy fájl eltávolítása
# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = Több információ megjelenítése
# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = Fájl megnyitása

## Displayed when the user clicked on a download in process. Indicates that the
## downloading file will be opened after certain amount of time using an app
## available in the system.
## Variables:
##   $hours (number) - Amount of hours left till the file opens.
##   $seconds (number) - Amount of seconds left till the file opens.
##   $minutes (number) - Amount of minutes till the file opens.

downloading-file-opens-in-hours-and-minutes-2 =
    .value = Megnyitás { $hours } ó { $minutes } p múlva…
downloading-file-opens-in-minutes-2 =
    .value = Megnyitás { $minutes } p múlva…
downloading-file-opens-in-minutes-and-seconds-2 =
    .value = Megnyitás { $minutes } p { $seconds } mp múlva…
downloading-file-opens-in-seconds-2 =
    .value = Megnyitás { $seconds } mp múlva…
downloading-file-opens-in-some-time-2 =
    .value = Megnyitás a befejezése után…
downloading-file-click-to-open =
    .value = Megnyitás, ha kész

##

# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = Letöltés újrapróbálása
# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = Letöltés megszakítása
# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = Minden letöltés megjelenítése
    .accesskey = M
# This string is shown at the top of the download details sub-panel to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Letöltés részletei

## Displayed when a site attempts to automatically download many files.
## Variables:
##   $num (number) - Number of blocked downloads.
##   $url (string) - The url of the suspicious site, stripped of http, https and www prefix.

downloads-files-not-downloaded =
    { $num ->
        [one] A fájl nincs letöltve.
       *[other] { $num } fájl nincs letöltve.
    }
downloads-blocked-from-url = Letöltések letiltva innen: { $url }.
downloads-blocked-download-detailed-info = A(z) { $url } több fájl automatikus letöltését kísérelte meg. Előfordulhat, hogy a webhely meghibásodott, vagy kéretlen fájlokat próbál tárolni az eszközén.

##

downloads-clear-downloads-button =
    .label = Letöltések törlése
    .tooltiptext = Törli a befejezett, megszakított és meghiúsult letöltéseket
# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = Nincsenek letöltések.
# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = Nincs letöltés ebben a munkamenetben.
# This is displayed in an item at the bottom of the Downloads Panel when there
# are more downloads than can fit in the list in the panel.
#   $count (number) - number of files being downloaded that are not shown in the
#                     panel list.
downloads-more-downloading =
    { $count ->
        [one] { $count } további fájl letöltése folyamatban van
       *[other] { $count } további fájl letöltése folyamatban van
    }

## Download errors

downloads-error-alert-title = Letöltési hiba
# Variables:
#   $extension (String): the name of the blocking extension.
downloads-error-blocked-by = A letöltést nem lehet menteni, mert a(z) { $extension } kiegészítő blokkolja.
# Used when the name of the blocking extension is unavailable.
downloads-error-extension = A letöltést nem lehet menteni, mert egy kiegészítő blokkolja.
# Line breaks in this message are meaningful, and should be maintained.
downloads-error-generic =
    A letöltés nem menthető, mert ismeretlen hiba történt.
    
    Próbálja újra.
