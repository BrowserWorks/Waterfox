# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = Willkommen zum neuen { -brand-short-name }
upgrade-dialog-new-subtitle = Entwickelt, um dich schneller ans Ziel zu bringen
upgrade-dialog-new-item-menu-title = Angepasste Symbolleisten und Menüs
upgrade-dialog-new-item-menu-description = Stellen die wichtigen Dinge in den Vordergrund, damit du das findest, was du brauchst.
upgrade-dialog-new-item-tabs-title = Moderne Tabs
upgrade-dialog-new-item-tabs-description = Enthalten übersichtlich Informationen und unterstützen sowohl fokussiertes als auch flexibles Arbeiten.
upgrade-dialog-new-item-icons-title = Neue Symbole und klarere Nachrichten
upgrade-dialog-new-item-icons-description = Helfen dir, schneller an dein Ziel zu kommen.
upgrade-dialog-new-primary-default-button = { -brand-short-name } als Standardbrowser festlegen
upgrade-dialog-new-primary-theme-button = Ein Theme auswählen
upgrade-dialog-new-secondary-button = Nicht jetzt
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = OK, verstanden!

## Pin Waterfox screen
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
upgrade-dialog-default-title-2 = Lege { -brand-short-name } als Standard fest
upgrade-dialog-default-subtitle-2 = Schalte Geschwindigkeit, Sicherheit und Datenschutz auf Autopilot.
upgrade-dialog-default-primary-button-2 = Als Standardbrowser festlegen
upgrade-dialog-default-secondary-button = Nicht jetzt

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 = Starte neu durch mit einem frischen Theme
upgrade-dialog-theme-system = System-Theme
    .title = Den Betriebssystemeinstellungen für Schaltflächen, Menüs und Fenster folgen

## Start screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-start-title = Leben in Farbe
upgrade-dialog-start-subtitle = Lebendige neue Farbgebungen. Verfügbar für eine begrenzte Zeit.
upgrade-dialog-start-primary-button = Farbgebungen erkunden
upgrade-dialog-start-secondary-button = Nicht jetzt

## Colorway screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-colorway-title = Wähle deine Palette
upgrade-dialog-colorway-home-checkbox = Zu Waterfox-Startseite mit einem Hintergrund mit Theme wechseln
upgrade-dialog-colorway-primary-button = Farbgebung speichern
upgrade-dialog-colorway-secondary-button = Vorheriges Theme beibehalten
upgrade-dialog-colorway-theme-tooltip =
    .title = Standard-Themes erkunden
# $colorwayName (String) - Name of colorway, e.g., Abstract, Cheers
upgrade-dialog-colorway-colorway-tooltip =
    .title = { $colorwayName }-Farbgebungen erkunden
upgrade-dialog-colorway-default-theme = Standard
# "Auto" is short for "Automatic"
upgrade-dialog-colorway-theme-auto = Automatisch
    .title = Dem Theme des Betriebssystems für Schaltflächen, Menüs und Fenster folgen
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
upgrade-dialog-colorway-variation-soft = Weich
    .title = Diese Farbgebung verwenden
upgrade-dialog-colorway-variation-balanced = Ausgewogen
    .title = Diese Farbgebung verwenden
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
upgrade-dialog-colorway-variation-bold = Kühn
    .title = Diese Farbgebung verwenden

## Thank you screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-thankyou-title = Danke, dass du dich für uns entschieden hast
upgrade-dialog-thankyou-subtitle = { -brand-short-name } ist ein unabhängiger Browser, der von einer gemeinnützigen Organisation unterstützt wird. Gemeinsam machen wir das Web sicherer, gesünder und privater.
upgrade-dialog-thankyou-primary-button = Lossurfen
