# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $count (Number) - Number of unread messages.
unread-messages-os-tooltip =
    { $count ->
        [one] 1 olvasatlan üzenet
       *[other] { $count } olvasatlan üzenet
    }
about-rights-notification-text = A { -brand-short-name } szabad és nyílt forráskódú szoftver, amit egy ezrekből álló közösség épít szerte a világból.

## Content tabs

content-tab-page-loading-icon =
    .alt = Az oldal betöltődik
content-tab-security-high-icon =
    .alt = A kapcsolat biztonságos
content-tab-security-broken-icon =
    .alt = A kapcsolat nem biztonságos

## Toolbar

addons-and-themes-button =
    .label = Kiegészítők és témák
    .tooltip = Saját kiegészítők kezelése
addons-and-themes-toolbarbutton =
    .label = Kiegészítők és témák
    .tooltiptext = Kiegészítők kezelése
quick-filter-toolbarbutton =
    .label = Gyorsszűrő
    .tooltiptext = Üzenetek szűrése
redirect-msg-button =
    .label = Átirányítás
    .tooltiptext = Kiválasztott üzenet átirányítása

## Folder Pane

folder-pane-toolbar =
    .toolbarname = Mappa ablaktábla eszköztár
    .accesskey = M
folder-pane-toolbar-options-button =
    .tooltiptext = Mappa ablaktábla beállításai
folder-pane-header-label = Mappák

## Folder Toolbar Header Popup

folder-toolbar-hide-toolbar-toolbarbutton =
    .label = Eszköztár elrejtése
    .accesskey = E
show-all-folders-label =
    .label = Minden mappa
    .accesskey = M
show-unread-folders-label =
    .label = Olvasatlan mappák
    .accesskey = O
show-favorite-folders-label =
    .label = Kedvenc mappák
    .accesskey = K
show-smart-folders-label =
    .label = Egyesített mappák
    .accesskey = E
show-recent-folders-label =
    .label = Legutóbbi mappák
    .accesskey = L
folder-toolbar-toggle-folder-compact-view =
    .label = Tömör nézet
    .accesskey = T

## Menu

redirect-msg-menuitem =
    .label = Átirányítás
    .accesskey = i

## AppMenu

# Since v89 we dropped the platforms distinction between Options or Preferences
# and consolidated everything with Preferences.
appmenu-preferences =
    .label = Beállítások
appmenu-addons-and-themes =
    .label = Kiegészítők és témák
appmenu-help-enter-troubleshoot-mode =
    .label = Hibaelhárítási mód…
appmenu-help-exit-troubleshoot-mode =
    .label = Hibakeresési mód kikapcsolása
appmenu-help-more-troubleshooting-info =
    .label = További hibakeresési információ
appmenu-redirect-msg =
    .label = Átirányítás

## Context menu

context-menu-redirect-msg =
    .label = Átirányítás

## Message header pane

other-action-redirect-msg =
    .label = Átirányítás

## Action Button Context Menu

toolbar-context-menu-manage-extension =
    .label = Kiegészítő kezelése
    .accesskey = K
toolbar-context-menu-remove-extension =
    .label = Kiegészítő eltávolítása
    .accesskey = t

## Message headers

message-header-address-in-address-book-icon =
    .alt = A cím a címjegyzékben található
message-header-address-not-in-address-book-icon =
    .alt = A cím nem szerepel a címjegyzékben

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = Eltávoltja a következőt: { $name }?
addon-removal-confirmation-button = Eltávolítás
addon-removal-confirmation-message = Eltávolítja a(z) { $name } kiegészítőt, valamint a beállításait és adatait a { -brand-short-name }ből?
caret-browsing-prompt-title = Kurzoros böngészés
caret-browsing-prompt-text = Az F7 gomb kapcsolja be, illetve ki a kurzoros böngészést. Ebben az üzemmódban egy mozgatható kurzor jelenik egyes tartalmaknál, lehetővé téve a szöveg kijelölését a billentyűzettel. Szeretné bekapcsolni a kurzoros böngészést?
caret-browsing-prompt-check-text = Ne kérdezze meg újra.
repair-text-encoding-button =
    .label = Szövegkódolás javítása
    .tooltiptext = Kitalálja a helyes szövegkódolást az üzenet tartalma alapján
