# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = Willkommen zum neuen { -brand-short-name }
upgrade-dialog-new-subtitle = Entwickelt, um dich schneller ans Ziel zu bringen
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline
# style to be automatically added to the text inside it. { -brand-short-name }
# should stay inside the span.
upgrade-dialog-new-alt-subtitle = Sorge zuerst dafür, dass <span data-l10n-name="zap">{ -brand-short-name }</span> nur einen Klick entfernt ist
upgrade-dialog-new-item-menu-title = Angepasste Symbolleisten und Menüs
upgrade-dialog-new-item-menu-description = Stellen die wichtigen Dinge in den Vordergrund, damit du das findest, was du brauchst.
upgrade-dialog-new-item-tabs-title = Moderne Tabs
upgrade-dialog-new-item-tabs-description = Enthalten übersichtlich Informationen und unterstützen sowohl fokussiertes als auch flexibles Arbeiten.
upgrade-dialog-new-item-icons-title = Neue Symbole und klarere Nachrichten
upgrade-dialog-new-item-icons-description = Helfen dir, schneller an dein Ziel zu kommen.
upgrade-dialog-new-primary-primary-button = { -brand-short-name } als Hauptbrowser festlegen
    .title = Setzt { -brand-short-name } als Standardbrowser und heftet ihn an die Taskleiste
upgrade-dialog-new-primary-default-button = { -brand-short-name } als Standardbrowser festlegen
upgrade-dialog-new-primary-pin-button = { -brand-short-name } an die Taskleiste anheften
upgrade-dialog-new-primary-pin-alt-button = An die Taskleiste anheften
upgrade-dialog-new-primary-theme-button = Ein Theme auswählen
upgrade-dialog-new-secondary-button = Nicht jetzt
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = OK, verstanden!

## Pin Firefox screen
##
## These title, subtitle and button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-pin-title =
    { PLATFORM() ->
        [macos] Behalte { -brand-short-name } im Dock
       *[other] Hefte { -brand-short-name } an die Taskleiste
    }
# The English macOS string avoids repeating "Keep" a third time, so if your
# translations don't repeat anyway, the same string can be used cross-platform.
upgrade-dialog-pin-subtitle =
    { PLATFORM() ->
        [macos] Habe den neuesten { -brand-short-name } immer zur Hand.
       *[other] Habe den neuesten { -brand-short-name } immer zur Hand.
    }
upgrade-dialog-pin-primary-button =
    { PLATFORM() ->
        [macos] Im Dock behalten
       *[other] An die Taskleiste anheften
    }
upgrade-dialog-pin-secondary-button = Nicht jetzt

## Default browser screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title = { -brand-short-name } als Standardbrowser festlegen?
upgrade-dialog-default-subtitle = Holen Sie sich Geschwindigkeit, Sicherheit und Datenschutz bei jedem Surfen.
upgrade-dialog-default-primary-button = Als Standardbrowser festlegen
# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title-2 = Lege { -brand-short-name } als Standard fest
upgrade-dialog-default-subtitle-2 = Schalte Geschwindigkeit, Sicherheit und Datenschutz auf Autopilot.
upgrade-dialog-default-primary-button-2 = Als Standardbrowser festlegen
upgrade-dialog-default-secondary-button = Nicht jetzt

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title =
    Starte neu durch
    mit einem aktualisierten Theme
# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 = Starte neu durch mit einem frischen Theme
upgrade-dialog-theme-system = System-Theme
    .title = Den Betriebssystemeinstellungen für Schaltflächen, Menüs und Fenster folgen
upgrade-dialog-theme-light = Hell
    .title = Ein helles Theme für Schaltflächen, Menüs und Fenster verwenden
upgrade-dialog-theme-dark = Dunkel
    .title = Ein dunkles Theme für Schaltflächen, Menüs und Fenster verwenden
upgrade-dialog-theme-alpenglow = Alpenglow
    .title = Ein dynamisches, farbenfrohes Theme für Schaltflächen, Menüs und Fenster verwenden
upgrade-dialog-theme-keep = Vorheriges behalten
    .title = Das Theme verwenden, welches vor der Aktualisierung von { -brand-short-name } installiert war
upgrade-dialog-theme-primary-button = Theme speichern
upgrade-dialog-theme-secondary-button = Nicht jetzt
