# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $count (Number) - Number of unread messages.
unread-messages-os-tooltip =
    { $count ->
        [one] neperskaitytas laiškas
        [few] { $count } neperskaityti laiškai
       *[other] { $count } neperskaitytų laiškų
    }

about-rights-notification-text = „{ -brand-short-name }“ yra nemokama ir atvirojo kodo programinė įranga, sukurta pasaulio bendruomenės.

## Content tabs

## Toolbar

## Folder Pane

folder-pane-toolbar =
    .toolbarname = Aplankų polangio priemonių juosta
    .accesskey = A

folder-pane-toolbar-options-button =
    .tooltiptext = Aplanko polangio parinktys

folder-pane-header-label = Aplankai

## Folder Toolbar Header Popup

folder-toolbar-hide-toolbar-toolbarbutton =
    .label = Slėpti mygtukų juostą
    .accesskey = S

show-all-folders-label =
    .label = Visi aplankai
    .accesskey = V

show-unread-folders-label =
    .label = Turintys neskaitytų laiškų
    .accesskey = n

show-favorite-folders-label =
    .label = Parankiniai aplankai
    .accesskey = P

show-smart-folders-label =
    .label = Suvestiniai aplankai
    .accesskey = S

show-recent-folders-label =
    .label = Paskiausiai naudoti aplankai
    .accesskey = P

folder-toolbar-toggle-folder-compact-view =
    .label = Kompaktiškas vaizdas
    .accesskey = K

## Menu

## AppMenu

# Since v89 we dropped the platforms distinction between Options or Preferences
# and consolidated everything with Preferences.
appmenu-preferences =
    .label = Nuostatos

appmenu-addons-and-themes =
    .label = Priedai ir grafiniai apvalkalai

appmenu-help-enter-troubleshoot-mode =
    .label = Trikčių šalinimo veiksena…

appmenu-help-exit-troubleshoot-mode =
    .label = Išjungti trikčių šalinimo veikseną

appmenu-help-more-troubleshooting-info =
    .label = Daugiau informacijos apie trikčių šalinimą

## Context menu

## Message header pane

## Action Button Context Menu

toolbar-context-menu-manage-extension =
    .label = Tvarkyti priedą
    .accesskey = T
toolbar-context-menu-remove-extension =
    .label = Pašalinti priedą
    .accesskey = P

## Message headers

message-header-address-in-address-book-icon =
    .alt = Adresas yra adresų knygoje

message-header-address-not-in-address-book-icon =
    .alt = Adreso nėra adresų knygoje

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = Pašalinti „{ $name }“?
addon-removal-confirmation-button = Pašalinti
addon-removal-confirmation-message = Pašalinti „{ $name }“ ir jo konfigūraciją bei duomenis iš „{ -brand-short-name }“?

## no-reply handling

