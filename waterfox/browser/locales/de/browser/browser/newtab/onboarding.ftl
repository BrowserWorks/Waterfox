# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Willkommen bei { -brand-short-name }
onboarding-start-browsing-button-label = Hier geht’s zum Browser
onboarding-not-now-button-label = Jetzt nicht
mr1-onboarding-get-started-primary-button-label = Einführung

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Fantastisch, du hast jetzt { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Hol dir auch <img data-l10n-name="icon"/> <b>{ $addon-name }</b>.
return-to-amo-add-extension-label = Erweiterung hinzufügen
return-to-amo-add-theme-label = Das Theme hinzufügen

##  Variables: $addon-name (String) - Name of the add-on to be installed

mr1-return-to-amo-subtitle = Willkommen bei { -brand-short-name }
mr1-return-to-amo-addon-title = Du hast einen schnellen, privaten Browser zur Hand. Jetzt kannst du <b>{ $addon-name }</b> hinzufügen und noch mehr mit { -brand-short-name } machen.
mr1-return-to-amo-add-extension-label = { $addon-name } hinzufügen

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages

onboarding-welcome-steps-indicator-label =
    .aria-label = Fortschritt: Schritt { $current } von { $total }

# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Animationen deaktivieren

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

## Multistage MR1 onboarding strings (about:welcome pages)

# String for the Waterfox Accounts button
mr1-onboarding-sign-in-button-label = Anmelden

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

## Multistage MR1 onboarding strings (about:welcome pages)

# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Aus { $previous } importieren

mr1-onboarding-theme-header = Ganz dein Style
mr1-onboarding-theme-subtitle = Personalisiere { -brand-short-name } mit einem Theme.
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

mr2022-language-mismatch-subtitle = Dank unserer Gemeinschaft wird { -brand-short-name } in über 90 Sprachen übersetzt. Offenbar verwendet Ihr System { $systemLanguage } und { -brand-short-name } verwendet { $appLanguage }.

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

## MR2022 New User Easy Setup screen strings

# Primary button string used on new user onboarding first screen showing multiple actions such as Set Default, Import from previous browser.
mr2022-onboarding-easy-setup-primary-button-label = Speichern und fortfahren
# Set Default action checkbox label used on new user onboarding first screen
mr2022-onboarding-easy-setup-set-default-checkbox-label = { -brand-short-name } als Standardbrowser festlegen
# Import action checkbox label used on new user onboarding first screen
mr2022-onboarding-easy-setup-import-checkbox-label = Aus vorherigem Browser importieren

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

# This string is the title used when the user already has pinned the browser, but has not set default.
mr2022-onboarding-set-default-title = Mache { -brand-short-name } zu deinem bevorzugten Browser
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
mr2022-onboarding-colorway-primary-button-label-continue = Einstellen und weiter
mr2022-onboarding-existing-colorway-checkbox-label = { -firefox-home-brand-name } zu deiner farbenfrohen Startseite machen

mr2022-onboarding-colorway-label-default = Standard
mr2022-onboarding-colorway-tooltip-default2 =
    .title = Aktuelle { -brand-short-name }-Farben
mr2022-onboarding-colorway-description-default = <b>Meine aktuellen { -brand-short-name }-Farben verwenden.</b>

mr2022-onboarding-colorway-label-playmaker = Spielmacher
mr2022-onboarding-colorway-tooltip-playmaker2 =
    .title = Spielmacher (rot)
mr2022-onboarding-colorway-description-playmaker = <b>Du bist Spielmacher.</b> Du schaffst Gewinnmöglichkeiten und hilfst allen um dich herum, ihr Spiel zu verbessern.

mr2022-onboarding-colorway-label-expressionist = Expressionist
mr2022-onboarding-colorway-tooltip-expressionist2 =
    .title = Expressionist (gelb)
mr2022-onboarding-colorway-description-expressionist = <b>Du bist Expressionist.</b> Du siehst die Welt anders, und deine Kreationen wecken die Emotionen anderer.

mr2022-onboarding-colorway-label-visionary = Visionär
mr2022-onboarding-colorway-tooltip-visionary2 =
    .title = Visionär (grün)
mr2022-onboarding-colorway-description-visionary = <b>Du bist Visionär.</b> Du hinterfragst den Status quo und bewegst andere dazu, sich eine bessere Zukunft vorzustellen.

mr2022-onboarding-colorway-label-activist = Aktivist
mr2022-onboarding-colorway-tooltip-activist2 =
    .title = Aktivist (blau)
mr2022-onboarding-colorway-description-activist = <b>Du bist Aktivist.</b> Du hinterlässt die Welt als einen besseren Ort, als du ihn vorgefunden hast, und lässt andere an deine Sache glauben.

mr2022-onboarding-colorway-label-dreamer = Träumer
mr2022-onboarding-colorway-tooltip-dreamer2 =
    .title = Träumer (lila)
mr2022-onboarding-colorway-description-dreamer = <b>Du bist Träumer.</b> Du glaubst, dass das Glück den Mutigen hilft, und inspirierst andere dazu, tapfer zu sein.

mr2022-onboarding-colorway-label-innovator = Innovator
mr2022-onboarding-colorway-tooltip-innovator2 =
    .title = Innovator (orange)
mr2022-onboarding-colorway-description-innovator = <b>Du bist Innovator.</b> Du siehst überall Möglichkeiten und beeinflusst das Leben aller um dich herum.

## MR2022 Multistage Mobile Download screen strings

mr2022-onboarding-mobile-download-title = Wechsle vom Laptop zum Telefon und wieder zurück
mr2022-onboarding-mobile-download-subtitle = Greife auf Tabs von einem Gerät zu und mache dort weiter, wo du auf einem anderen aufgehört hast. Außerdem kannst du deine Lesezeichen und Passwörter überall dort synchronisieren, wo du { -brand-product-name } verwendest.
mr2022-onboarding-mobile-download-cta-text = Scanne den QR-Code, um { -brand-product-name } für Mobilgeräte zu erhalten, oder <a data-l10n-name="download-label">sende dir selbst einen Download-Link.</a>
mr2022-onboarding-no-mobile-download-cta-text = Scanne den QR-Code, um dir { -brand-product-name } für Mobilgeräte zu holen.

## MR2022 Upgrade Dialog screens
## Pin private window screen shown only for users who don't have Waterfox private pinned

mr2022-upgrade-onboarding-pin-private-window-header = Hole dir die Freiheit des privaten Surfens mit einem Klick
mr2022-upgrade-onboarding-pin-private-window-subtitle = Keine gespeicherten Cookies oder Chronik, direkt von deinem Desktop. Surfe, als würde niemand zusehen.
mr2022-upgrade-onboarding-pin-private-window-primary-button-label =
    { PLATFORM() ->
        [macos] { -brand-short-name } Privater Modus im Dock behalten
       *[other] { -brand-short-name } Privater Modus an die Taskleiste anheften
    }

## MR2022 Privacy Segmentation screen strings

mr2022-onboarding-privacy-segmentation-title = Wir respektieren immer deine Privatsphäre
mr2022-onboarding-privacy-segmentation-subtitle = Von intelligenten Vorschlägen bis hin zu einer schlaueren Suche arbeiten wir ständig daran, einen besseren, persönlicheren { -brand-product-name } zu schaffen.
mr2022-onboarding-privacy-segmentation-text-cta = Was soll passieren, wenn wir neue Funktionen anbieten, die deine Daten verwenden, um dein Surfen zu verbessern?
mr2022-onboarding-privacy-segmentation-button-primary-label = { -brand-product-name }-Empfehlungen verwenden
mr2022-onboarding-privacy-segmentation-button-secondary-label = Detaillierte Informationen anzeigen

## MR2022 Multistage Gratitude screen strings

mr2022-onboarding-gratitude-title = Du hilfst uns, ein besseres Web aufzubauen
mr2022-onboarding-gratitude-subtitle = Vielen Dank, dass du { -brand-short-name } verwendest, unterstützt von der BrowserWorks. Mit deiner Unterstützung arbeiten wir daran, das Internet für alle offener, zugänglicher und besser zu machen.
mr2022-onboarding-gratitude-primary-button-label = Neue Funktionen und Änderungen anschauen
mr2022-onboarding-gratitude-secondary-button-label = Lossurfen

## Onboarding spotlight for infrequent users

onboarding-infrequent-import-title = Fühl dich wie zu Hause
onboarding-infrequent-import-subtitle = Egal, ob du hierbleibst oder nur vorbeischaust, denk daran, dass du deine Lesezeichen, Passwörter und mehr importieren kannst.
onboarding-infrequent-import-primary-button = In { -brand-short-name } importieren

## MR2022 Illustration alt tags
## Descriptive tags for illustrations used by screen readers and other assistive tech

mr2022-onboarding-pin-image-alt =
    .aria-label = Person arbeitet an einem Laptop umgeben von Sternen und Blumen
mr2022-onboarding-default-image-alt =
    .aria-label = Person umarmt das { -brand-product-name }-Logo
mr2022-onboarding-import-image-alt =
    .aria-label = Person, die ein Skateboard mit einer Kiste mit Softwaresymbolen fährt
mr2022-onboarding-mobile-download-image-alt =
    .aria-label = Frösche hüpfen über Seerosenblätter mit einem QR-Code zum Herunterladen von { -brand-product-name } für Mobilgeräte in der Mitte
mr2022-onboarding-pin-private-image-alt =
    .aria-label = Zauberstab lässt das Logo von { -brand-product-name } Privater Modus aus einem Hut erscheinen
mr2022-onboarding-privacy-segmentation-image-alt =
    .aria-label = Hellhäutige und dunkelhäutige Hände machen einen High Five
mr2022-onboarding-gratitude-image-alt =
    .aria-label = Blick auf einen Sonnenuntergang durch ein Fenster mit einem Fuchs und einer Zimmerpflanze auf einer Fensterbank
mr2022-onboarding-colorways-image-alt =
    .aria-label = Eine Hand sprüht eine farbenfrohe Collage eines grünen Auges, einem orangefarbenen Schuh, einem roten Basketball, lila Kopfhörern, einem blauen Herz und einer gelben Krone

## Device migration onboarding

onboarding-device-migration-image-alt =
    .aria-label = Ein Fuchs winkt auf dem Bildschirm eines Laptop-Computers. Der Laptop ist mit einer Maus verbunden.
onboarding-device-migration-title = Willkommen zurück!
onboarding-device-migration-subtitle = Melden Sie sich mit Ihrem { -fxaccount-brand-name } an, um Ihre Lesezeichen, Passwörter und Chronik auf Ihr neues Gerät zu bringen.
onboarding-device-migration-primary-button-label = Anmelden
