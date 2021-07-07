# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $count (Number) - Number of unread messages.
unread-messages-os-tooltip =
    { $count ->
        [one] 1 oläst meddelande
       *[other] { $count } olästa meddelanden
    }
about-rights-notification-text = { -brand-short-name } är fri programvara baserad på öppen källkod, byggd av en community av tusentals personer över hela världen.

## Content tabs

content-tab-page-loading-icon =
    .alt = Sidan laddas
content-tab-security-high-icon =
    .alt = Anslutningen är säker
content-tab-security-broken-icon =
    .alt = Anslutningen är inte säker

## Toolbar

addons-and-themes-toolbarbutton =
    .label = Tillägg och teman
    .tooltiptext = Hantera dina tillägg
quick-filter-toolbarbutton =
    .label = Snabbfiltrering
    .tooltiptext = Filtrera meddelanden
redirect-msg-button =
    .label = Omdirigera
    .tooltiptext = Omdirigera valt meddelande

## Folder Pane

folder-pane-toolbar =
    .toolbarname = Verktygsfältet mappfönster
    .accesskey = m
folder-pane-toolbar-options-button =
    .tooltiptext = Alternativ för mappfönster
folder-pane-header-label = Mappar

## Folder Toolbar Header Popup

folder-toolbar-hide-toolbar-toolbarbutton =
    .label = Dölj verktygsfält
    .accesskey = D
show-all-folders-label =
    .label = Alla mappar
    .accesskey = A
show-unread-folders-label =
    .label = Olästa mappar
    .accesskey = O
show-favorite-folders-label =
    .label = Favoritmappar
    .accesskey = F
show-smart-folders-label =
    .label = Sammanförda mappar
    .accesskey = S
show-recent-folders-label =
    .label = Senaste mappar
    .accesskey = S
folder-toolbar-toggle-folder-compact-view =
    .label = Kompakt vy
    .accesskey = K

## Menu

redirect-msg-menuitem =
    .label = Omdirigera
    .accesskey = d
menu-file-save-as-file =
    .label = Arkiv…
    .accesskey = A

## AppMenu

appmenu-save-as-file =
    .label = Arkiv…
# Since v89 we dropped the platforms distinction between Options or Preferences
# and consolidated everything with Preferences.
appmenu-preferences =
    .label = Inställningar
appmenu-addons-and-themes =
    .label = Tillägg och teman
appmenu-help-enter-troubleshoot-mode =
    .label = Felsökningsläge…
appmenu-help-exit-troubleshoot-mode =
    .label = Stäng av felsökningsläge
appmenu-help-more-troubleshooting-info =
    .label = Mer felsökningsinformation
appmenu-redirect-msg =
    .label = Omdirigera

## Context menu

context-menu-redirect-msg =
    .label = Omdirigera

## Message header pane

other-action-redirect-msg =
    .label = Omdirigera

## Action Button Context Menu

toolbar-context-menu-manage-extension =
    .label = Hantera tillägg
    .accesskey = H
toolbar-context-menu-remove-extension =
    .label = Ta bort tillägg
    .accesskey = T

## Message headers

message-header-address-in-address-book-icon =
    .alt = Adressen finns i adressboken
message-header-address-not-in-address-book-icon =
    .alt = Adressen finns inte i adressboken

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = Ta bort { $name }?
addon-removal-confirmation-button = Ta bort
addon-removal-confirmation-message = Ta bort { $name } samt dess konfiguration och data från { -brand-short-name }?
caret-browsing-prompt-title = Textmarkörläge
caret-browsing-prompt-text = Genom att trycka på F7 aktiveras eller inaktiveras textmarkörläge. Denna funktion placerar en rörlig markör i innehållet, så att du kan välja text med tangentbordet. Vill du aktivera textmarkörläge?
caret-browsing-prompt-check-text = Fråga inte igen.
repair-text-encoding-button =
    .label = Reparera textkodning
    .tooltiptext = Gissa korrekt textkodning från meddelandets innehåll

## no-reply handling

no-reply-title = Svar stöds inte
no-reply-message = Svarsadressen ({ $email }) verkar inte vara en övervakad adress. Meddelanden till den här adressen kommer sannolikt inte att läsas av någon.
no-reply-reply-anyway-button = Svara ändå
