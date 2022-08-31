# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Willkommen bei { -brand-short-name }
onboarding-start-browsing-button-label = Hier geht’s zum Browser
onboarding-not-now-button-label = Jetzt nicht

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Fantastisch, du hast jetzt { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Hol dir auch <img data-l10n-name="icon"/> <b>{ $addon-name }</b>.
return-to-amo-add-extension-label = Erweiterung hinzufügen
return-to-amo-add-theme-label = Das Theme hinzufügen

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Erste Schritte: Bildschirm { $current } von { $total }

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages

onboarding-welcome-steps-indicator2 =
    .aria-valuetext = Fortschritt: Schritt { $current } von { $total }
# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Waterfox, how they use
# Waterfox to pursue those passions, as well as the boldness in their
# choice to use Waterfox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text =
    Wenn der Funke
    zündet
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio – Möbeldesignerin, Waterfox-Fan
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Animationen deaktivieren

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Waterfox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] Behalte { -brand-short-name } für einfachen Zugriff im Dock
       *[other] Hefte { -brand-short-name } für einfachen Zugriff an die Taskleiste an
    }
# Primary button string used on welcome page when Waterfox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Im Dock behalten
       *[other] An die Taskleiste anheften
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Einführung
mr1-onboarding-welcome-header = Willkommen bei { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = { -brand-short-name } als Hauptbrowser festlegen
    .title = Setzt { -brand-short-name } als Standardbrowser und heftet ihn an die Taskleiste
# This string will be used on welcome page primary button label
# when Waterfox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = { -brand-short-name } als Standardbrowser festlegen
mr1-onboarding-set-default-secondary-button-label = Nicht jetzt
mr1-onboarding-sign-in-button-label = Anmelden

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

mr1-onboarding-default-header = Lege { -brand-short-name } als Standard fest
mr1-onboarding-default-subtitle = Schalte Geschwindigkeit, Sicherheit und Datenschutz auf Autopilot.
mr1-onboarding-default-primary-button-label = Als Standardbrowser festlegen

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = Nimm alles mit
mr1-onboarding-import-subtitle = Importiere deine Passwörter, <br/>Lesezeichen und mehr.
# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Aus { $previous } importieren
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = Aus vorherigem Browser importieren
mr1-onboarding-import-secondary-button-label = Nicht jetzt
mr2-onboarding-colorway-header = Leben in Farbe
mr2-onboarding-colorway-subtitle = Lebendige neue Farbwelten. Verfügbar für eine begrenzte Zeit.
mr2-onboarding-colorway-primary-button-label = Farbwelt speichern
mr2-onboarding-colorway-secondary-button-label = Nicht jetzt
mr2-onboarding-colorway-label-soft = Weich
mr2-onboarding-colorway-label-balanced = Ausgewogen
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
mr2-onboarding-colorway-label-bold = Kühn
# Automatic theme uses operating system color settings
mr2-onboarding-theme-label-auto = Automatisch
# This string will be used for Default theme
mr2-onboarding-theme-label-default = Standard
mr1-onboarding-theme-header = Ganz dein Style
mr1-onboarding-theme-subtitle = Personalisiere { -brand-short-name } mit einem Theme.
mr1-onboarding-theme-primary-button-label = Theme speichern
mr1-onboarding-theme-secondary-button-label = Nicht jetzt
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = System-Theme
mr1-onboarding-theme-label-light = Hell
mr1-onboarding-theme-label-dark = Dunkel
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpenglow
onboarding-theme-primary-button-label = Fertig

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title =
        Dem Theme des Betriebssystems
        für Schaltflächen, Menüs und Fenster folgen.
# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        Dem Theme des Betriebssystems
        für Schaltflächen, Menüs und Fenster folgen.
# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title =
        Ein helles Theme für Schaltflächen,
        Menüs und Fenster verwenden.
# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description =
        Ein helles Theme für Schaltflächen,
        Menüs und Fenster verwenden.
# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title =
        Ein dunkles Theme für Schaltflächen,
        Menüs und Fenster verwenden.
# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description =
        Ein dunkles Theme für Schaltflächen,
        Menüs und Fenster verwenden.
# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title =
        Ein dynamisches, farbenfrohes Theme
        für Schaltflächen, Menüs und Fenster verwenden.
# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description =
        Ein dynamisches, farbenfrohes Theme
        für Schaltflächen, Menüs und Fenster verwenden.
# Tooltip displayed on hover of non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-tooltip =
    .title = Diese Farbwelt verwenden.
# Selector description for non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-description =
    .aria-description = Diese Farbwelt verwenden.
# Tooltip displayed on hover of colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-tooltip =
    .title = { $colorwayName }-Farbwelten erkunden
# Selector description for colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-label = { $colorwayName }-Farbwelten erkunden
# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = Standard-Themes erkunden
# Selector description for default themes
mr2-onboarding-default-theme-label = Standard-Themes erkunden

## Strings for Thank You page

mr2-onboarding-thank-you-header = Danke, dass du dich für uns entschieden hast
mr2-onboarding-thank-you-text = { -brand-short-name } ist ein unabhängiger Browser, der von einer gemeinnützigen Organisation unterstützt wird. Gemeinsam machen wir das Web sicherer, gesünder und privater.
mr2-onboarding-start-browsing-button-label = Lossurfen

## Multistage live language reloading onboarding strings (about:welcome pages)
##
## The following language names are generated by the browser's Intl.DisplayNames API.
##
## Variables:
##   $negotiatedLanguage (String) - The name of the langpack's language, e.g. "Español (ES)"


## Multistage live language reloading onboarding strings (about:welcome pages)
##
## The following language names are generated by the browser's Intl.DisplayNames API.
##
## Variables:
##   $negotiatedLanguage (String) - The name of the langpack's language, e.g. "Español (ES)"
##   $systemLanguage (String) - The name of the system language, e.g "Español (ES)"
##   $appLanguage (String) - The name of the language shipping in the browser build, e.g. "English (EN)"

onboarding-live-language-header = Wähle deine Sprache
mr2022-onboarding-live-language-text = { -brand-short-name } spricht deine Sprache
mr2022-language-mismatch-subtitle = Dank unserer Gemeinschaft wird { -brand-short-name } in über 90 Sprachen übersetzt. Offenbar verwendet Ihr System { $systemLanguage }, und { -brand-short-name } verwendet { $appLanguage }.
onboarding-live-language-button-label-downloading = Das Sprachpaket für { $negotiatedLanguage } wird heruntergeladen…
onboarding-live-language-waiting-button = Verfügbare Sprachen werden abgerufen…
onboarding-live-language-installing = Das Sprachpaket für { $negotiatedLanguage } wird installiert…
mr2022-onboarding-live-language-switch-to = Zu { $negotiatedLanguage } wechseln
mr2022-onboarding-live-language-continue-in = Auf { $appLanguage } fortfahren
onboarding-live-language-secondary-cancel-download = Abbrechen
onboarding-live-language-skip-button-label = Überspringen

## Waterfox 100 Thank You screens

# "Hero Text" displayed on left side of welcome screen. This text can be
# formatted to span multiple lines as needed. The <span data-l10n-name="zap">
# </span> in this string allows a "zap" underline style to be automatically
# added to the text inside it. "Yous" should stay inside the zap span, but
# "Thank" can be put inside instead if there's no "you" in the translation.
# The English text would normally be "100 Thank-Yous" i.e., plural noun, but for
# aesthetics of splitting it across multiple lines, the hyphen is omitted.
fx100-thank-you-hero-text =
    100
    Mal
    <span data-l10n-name="zap">Danke</span>
fx100-thank-you-subtitle = Dies ist unsere 100. Version! Danke, dass du uns beim Aufbau eines besseren und gesünderen Internets hilfst.
fx100-thank-you-pin-primary-button-label =
    { PLATFORM() ->
        [macos] { -brand-short-name } im Dock behalten
       *[other] { -brand-short-name } an Taskleiste anheften
    }
fx100-upgrade-thanks-header = 100 Mal Danke
# Message shown with a start-browsing button. Emphasis <em> should be for "you"
# but "Thank" can be used instead if there's no "you" in the translation.
fx100-upgrade-thank-you-body = Dies ist unsere 100. Version von { -brand-short-name }. <em>Danke</em>, dass du uns beim Aufbau eines besseren und gesünderen Internets hilfst.
# Message shown with either a pin-to-taskbar or set-default button.
fx100-upgrade-thanks-keep-body = Dies ist unsere 100. Version! Danke, dass du Teil unserer Gemeinschaft bist. Halte { -brand-short-name } nur einen Klick entfernt für die nächsten 100.
mr2022-onboarding-secondary-skip-button-label = Diesen Schritt überspringen

## MR2022 New User Pin Waterfox screen strings

# Title used on about:welcome for new users when Waterfox is not pinned.
# In this context, open up is synonymous with "Discover".
# The metaphor is that when they open their Waterfox browser, it helps them discover an amazing internet.
# If this translation does not make sense in your language, feel free to use the word "discover."
mr2022-onboarding-welcome-pin-header = Öffne ein großartiges Internet
# Subtitle is used on onboarding page for new users page when Waterfox is not pinned
mr2022-onboarding-welcome-pin-subtitle = Starte { -brand-short-name } von überall aus mit einem einzigen Klick. Jedes Mal, wenn du dies tust, wählst du ein offeneres und unabhängigeres Web.
# Primary button string used on welcome page for when Waterfox is not pinned.
mr2022-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] { -brand-short-name } im Dock behalten
       *[other] { -brand-short-name } an Taskleiste anheften
    }
# Subtitle will be used when user already has Waterfox pinned, but
# has not set it as their default browser.
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-only-subtitle = Lege los mit einem Browser, der von einer gemeinnützigen Organisation unterstützt wird. Wir schützen deine Privatsphäre, während du im Internet unterwegs bist.

## MR2022 Existing User Pin Waterfox Screen Strings

# Title used on multistage onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-header = Danke, dass du { -brand-product-name } liebst
# Subtitle is used on onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-subtitle = Starte mit einem einzigen Klick von überall aus ein gesünderes Internet. Unser neuestes Update ist vollgepackt mit neuen Dingen, von denen wir glauben, dass du sie lieben wirst.
# Subtitle will be used on the welcome screen for existing users
# when they already have Waterfox pinned but not set as default
mr2022-onboarding-existing-set-default-only-subtitle = Verwende einen Browser, der deine Privatsphäre schützt, während du im Internet unterwegs bist. Unser neuestes Update ist vollgepackt mit Dingen, die du liebst.
mr2022-onboarding-existing-pin-checkbox-label = { -brand-short-name } Privater Modus auch hinzufügen

## MR2022 New User Set Default screen strings

mr2022-onboarding-set-default-primary-button-label = { -brand-short-name } als Standardbrowser festlegen
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-subtitle = Verwende einen Browser, der von einer gemeinnützigen Organisation unterstützt wird. Wir schützen deine Privatsphäre, während du im Internet unterwegs bist.

## MR2022 Get Started screen strings.
## These strings will be used on the welcome page
## when Waterfox is already set to default and pinned.

# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-get-started-primary-subtitle = Unsere neueste Version ist um dich herum aufgebaut und macht es einfacher als je zuvor, im Internet zu surfen. Es ist vollgepackt mit Funktionen, von denen wir glauben, dass du sie lieben wirst.
mr2022-onboarding-get-started-primary-button-label = In Sekunden eingerichtet

## MR2022 Import Settings screen strings

mr2022-onboarding-import-header = Blitzschnelle Einrichtung
mr2022-onboarding-import-subtitle = Richte { -brand-short-name } nach deinen Wünschen ein. Füge deine Lesezeichen, Passwörter und mehr aus deinem alten Browser hinzu.
mr2022-onboarding-import-primary-button-label-no-attribution = Aus vorherigem Browser importieren

## If your language uses grammatical genders, in the description for the
## colorway feel free to switch from "You are a X. You…" (e.g. "You are a
## Playmaker. You create…") to "X: you…" ("Playmaker: You create…"). This might
## help creating a more inclusive translation.

mr2022-onboarding-colorway-title = Wähle die Farbe, die dich inspiriert
mr2022-onboarding-colorway-subtitle = Unabhängige Stimmen können die Kultur verändern.
mr2022-onboarding-colorway-primary-button-label = Farbwelt festlegen
mr2022-onboarding-colorway-label-default = Standard
mr2022-onboarding-colorway-tooltip-default =
    .title = Standard
mr2022-onboarding-colorway-label-playmaker = Spielmacher
mr2022-onboarding-colorway-tooltip-playmaker =
    .title = Spielmacher
mr2022-onboarding-colorway-label-expressionist = Expressionist
mr2022-onboarding-colorway-tooltip-expressionist =
    .title = Expressionist
mr2022-onboarding-colorway-label-visionary = Visionär
mr2022-onboarding-colorway-tooltip-visionary =
    .title = Visionär
mr2022-onboarding-colorway-label-activist = Aktivist
mr2022-onboarding-colorway-tooltip-activist =
    .title = Aktivist
mr2022-onboarding-colorway-label-dreamer = Träumer
mr2022-onboarding-colorway-tooltip-dreamer =
    .title = Träumer
mr2022-onboarding-colorway-label-innovator = Innovator
mr2022-onboarding-colorway-tooltip-innovator =
    .title = Innovator

## MR2022 Multistage Mobile Download screen strings


## MR2022 Upgrade Dialog screens
## Pin private window screen shown only for users who don't have Waterfox private pinned


## MR2022 Privacy Segmentation screen strings


## MR2022 Multistage Gratitude screen strings

