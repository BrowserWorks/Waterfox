# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## Window controls

messenger-window-minimize-button =
    .tooltiptext = Minimieren
messenger-window-maximize-button =
    .tooltiptext = Maximieren
messenger-window-restore-down-button =
    .tooltiptext = Verkleinern
messenger-window-close-button =
    .tooltiptext = Schließen

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

menu-file-save-as-file =
    .label = Datei…
    .accesskey = D

## AppMenu

appmenu-save-as-file =
    .label = Datei…

appmenu-settings =
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

mail-context-delete-messages =
  .label = { $count ->
     [one] Nachricht löschen
    *[other] Ausgewählte Nachrichten löschen
  }

context-menu-decrypt-to-folder =
    .label = Entschlüsselt kopieren nach
    .accesskey = E

## Message header pane

other-action-redirect-msg =
    .label = Umleiten

message-header-msg-flagged =
    .title = Gekennzeichnet
    .aria-label = Gekennzeichnet

message-header-msg-not-flagged =
    .title = Nicht gekennzeichnet
    .aria-label = Nicht gekennzeichnet

# Variables:
# $address (String) - The email address of the recipient this picture belongs to.
message-header-recipient-avatar =
    .alt = Profilbild von { $address }

## Message header cutomize panel

message-header-customize-panel-title = Kopfzeilen - Einstellungen

message-header-customize-button-style =
    .value = Schaltflächendarstellung
    .accesskey = S

message-header-button-style-default =
    .label = Symbole und Text

message-header-button-style-text =
    .label = Text

message-header-button-style-icons =
    .label = Symbole

message-header-show-sender-full-address =
    .label = Immer vollständige Adresse des Absenders anzeigen
    .accesskey = A

message-header-show-sender-full-address-description = Die E-Mail-Adresse wird unter dem Anzeigenamen angezeigt.

message-header-show-recipient-avatar =
    .label = Profilbild des Absenders anzeigen
    .accesskey = P

message-header-hide-label-column =
    .label = Keine Spalte für Beschriftungen verwenden
    .accesskey = K

message-header-large-subject =
    .label = Betreff in großer Schrift
    .accesskey = B

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

## error messages

decrypt-and-copy-failures = { $failures } von { $total } Nachrichten konnten nicht entschlüsselt werden und wurden daher nicht kopiert.

## Spaces toolbar

spaces-toolbar-element =
    .toolbarname = Bereiche-Symbolleiste
    .aria-label = Bereiche-Symbolleiste
    .aria-description = Vertikale Symbolleiste zum Wechseln zwischen verschiedenen Bereichen der Anwendung. Verwenden Sie die Pfeiltasten, um zwischen den verfügbaren Schaltflächen zu wechseln.

spaces-toolbar-button-mail2 =
    .title = E-Mail

spaces-toolbar-button-address-book2 =
    .title = Adressbuch

spaces-toolbar-button-calendar2 =
    .title = Kalender

spaces-toolbar-button-tasks2 =
    .title = Aufgaben

spaces-toolbar-button-chat2 =
    .title = Chat

spaces-toolbar-button-overflow =
    .title = Weitere Bereiche…

spaces-toolbar-button-settings2 =
    .title = Einstellungen

spaces-toolbar-button-hide =
    .title = Bereiche-Symbolleiste ausblenden

spaces-toolbar-button-show =
    .title = Bereiche-Symbolleiste anzeigen

spaces-context-new-tab-item =
    .label = In neuem Tab öffnen

spaces-context-new-window-item =
    .label = In neuem Fenster öffnen

# Variables:
# $tabName (String) - The name of the tab this item will switch to.
spaces-context-switch-tab-item =
    .label = Wechseln zu { $tabName }

settings-context-open-settings-item =
    .label = Einstellungen öffnen

settings-context-open-account-settings-item =
    .label = Konten-Einstellungen öffnen

settings-context-open-addons-item =
    .label = Add-ons und Themes öffnen

settings-context-open-settings-item2 =
    .label = Einstellungen

settings-context-open-account-settings-item2 =
    .label = Konten-Einstellungen

settings-context-open-addons-item2 =
    .label = Add-ons und Themes

## Spaces toolbar pinned tab menupopup

spaces-toolbar-pinned-tab-button =
    .tooltiptext = Bereiche-Menü

spaces-pinned-button-menuitem-mail =
    .label = { spaces-toolbar-button-mail2.title }

spaces-pinned-button-menuitem-address-book =
    .label = { spaces-toolbar-button-address-book2.title }

spaces-pinned-button-menuitem-calendar =
    .label = { spaces-toolbar-button-calendar2.title }

spaces-pinned-button-menuitem-tasks =
    .label = { spaces-toolbar-button-tasks2.title }

spaces-pinned-button-menuitem-chat =
    .label = { spaces-toolbar-button-chat2.title }

spaces-pinned-button-menuitem-settings =
    .label = { spaces-toolbar-button-settings2.title }

spaces-pinned-button-menuitem-show =
    .label = { spaces-toolbar-button-show.title }

# Variables:
# $count (Number) - Number of unread messages.
chat-button-unread-messages = { $count }
    .title = { $count ->
        [one] Eine ungelesene Nachricht
        *[other] { $count } ungelesene Nachrichten
    }

## Spaces toolbar customize panel

menuitem-customize-label =
    .label = Anpassen…

spaces-customize-panel-title = Bereiche-Symbolleiste - Einstellungen

spaces-customize-background-color = Hintergrundfarbe

spaces-customize-icon-color = Schaltflächenfarbe

# The background color used on the buttons of the spaces toolbar when they are
# `current`, meaning the related space/tab is active and visible.
spaces-customize-accent-background-color = Hintergrundfarbe für ausgewählte Schaltfläche

# The icon color used on the buttons of the spaces toolbar when they are
# `current`, meaning the related space/tab is active and visible.
spaces-customize-accent-text-color = Farbe für ausgewählte Schaltfläche

spaces-customize-button-restore = Standard wiederherstellen
    .accesskey = w

customize-panel-button-save = Fertig
    .accesskey = F
