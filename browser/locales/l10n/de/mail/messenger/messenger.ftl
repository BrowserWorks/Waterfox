# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $count (Number) - Number of unread messages.
unread-messages-os-tooltip =
  { $count ->
     [one] 1 ungelesene Nachricht
    *[other] { $count } ungelesene Nachrichten
  }

about-rights-notification-text = { -brand-short-name } ist freie und quelloffene Software, entwickelt von einer Gemeinschaft tausender Gleichgesinnter, verteilt über die gesamte Welt.

## Content tabs

content-tab-page-loading-icon =
    .alt = Diese Seite wird geladen.
content-tab-security-high-icon =
    .alt = Die Verbindung ist verschlüsselt.
content-tab-security-broken-icon =
    .alt = Die Verbindung ist nicht verschlüsselt.

## Toolbar

addons-and-themes-toolbarbutton =
    .label = Add-ons und Themes
    .tooltiptext = Add-ons verwalten

quick-filter-toolbarbutton =
    .label = Schnellfilter
    .tooltiptext = Nachrichten filtern

redirect-msg-button =
    .label = Umleiten
    .tooltiptext = Umleiten der ausgewählten Nachricht

## Folder Pane

folder-pane-toolbar =
    .toolbarname = Konten-/Ordneransicht
    .accesskey = O

folder-pane-toolbar-options-button =
    .tooltiptext = Einstellungen für Konten-/Ordneransicht

folder-pane-header-label = Ordner

## Folder Toolbar Header Popup

folder-toolbar-hide-toolbar-toolbarbutton =
    .label = Symbolleiste ausblenden
    .accesskey = S

show-all-folders-label =
    .label = Alle Ordner
    .accesskey = A

show-unread-folders-label =
    .label = Ungelesene Ordner
    .accesskey = U

show-favorite-folders-label =
    .label = Favoriten-Ordner
    .accesskey = F

show-smart-folders-label =
    .label = Gruppierte Ordner
    .accesskey = G

show-recent-folders-label =
    .label = Letzte Ordner
    .accesskey = L

folder-toolbar-toggle-folder-compact-view =
    .label = Kompakte Ansicht
    .accesskey = K

## Menu

redirect-msg-menuitem =
    .label = Umleiten
    .accesskey = U

## AppMenu

# Since v89 we dropped the platforms distinction between Options or Preferences
# and consolidated everything with Preferences.
appmenu-preferences =
    .label = Einstellungen

appmenu-addons-and-themes =
    .label = Add-ons und Themes

appmenu-help-enter-troubleshoot-mode =
    .label = Fehlerbehebungsmodus…

appmenu-help-exit-troubleshoot-mode =
    .label = Fehlerbehebungsmodus deaktivieren

appmenu-help-more-troubleshooting-info =
    .label = Weitere Informationen zur Fehlerbehebung

appmenu-redirect-msg =
    .label = Umleiten

## Context menu

context-menu-redirect-msg =
    .label = Umleiten

## Message header pane

other-action-redirect-msg =
    .label = Umleiten

## Action Button Context Menu

toolbar-context-menu-manage-extension =
    .label = Erweiterung verwalten
    .accesskey = w
toolbar-context-menu-remove-extension =
    .label = Erweiterung entfernen
    .accesskey = n

## Message headers

message-header-address-in-address-book-icon =
  .alt = Adresse ist im Adressbuch

message-header-address-not-in-address-book-icon =
  .alt = Adresse ist nicht im Adressbuch

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = { $name } entfernen?
addon-removal-confirmation-button = Entfernen
addon-removal-confirmation-message = Sowohl { $name } als auch seine Einstellungen und Daten in { -brand-short-name } entfernen?

caret-browsing-prompt-title = Mit Textcursor-Steuerung arbeiten
caret-browsing-prompt-text = Das Drücken der Taste F7 schaltet das Arbeiten mit Textcursor-Steuerung an und aus. Diese Funktion fügt einen bewegbaren Textcursor in den Inhaltsbereich ein, mit dem. z.B. Text ausgewählt werden kann. Soll die Textcursor-Steuerung aktiviert werden?
caret-browsing-prompt-check-text = Das nächste Mal nicht nachfragen

repair-text-encoding-button =
  .label = Textkodierung reparieren
  .tooltiptext = Richtige Textkodierung basierend auf dem Nachrichteninhalt erraten

## no-reply handling

no-reply-title = Antwort nicht unterstützt
no-reply-message = Nachrichten an die Antwortadresse ({ $email }) werden wahrscheinlich von niemandem gelesen.
no-reply-reply-anyway-button = Trotzdem antworten
