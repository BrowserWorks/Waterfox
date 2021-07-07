# This Source Code Form is subject to the terms of the Mozilla Public
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
downloads-panel-list =
    .style = width: 70ch

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

# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = Tartalmazó mappa megnyitása
    .accesskey = m
  
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Megjelenítés a Finderben
    .accesskey = F

downloads-cmd-use-system-default =
    .label = Megnyitás a rendszer megjelenítőjében
    .accesskey = j

downloads-cmd-always-use-system-default =
    .label = Megnyitás mindig a rendszer megjelenítőjében
    .accesskey = m

downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Megjelenítés a Finderben
           *[other] Tartalmazó mappa megnyitása
        }

downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Megjelenítés a Finderben
           *[other] Tartalmazó mappa megnyitása
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Megjelenítés a Finderben
           *[other] Tartalmazó mappa megnyitása
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

# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = Letöltés részletei

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
