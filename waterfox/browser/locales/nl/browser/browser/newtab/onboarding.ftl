# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Welkom bij { -brand-short-name }
onboarding-start-browsing-button-label = Beginnen met browsen
onboarding-not-now-button-label = Niet nu

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Geweldig, u hebt { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Laten we nu <img data-l10n-name="icon"/> <b>{ $addon-name }</b> ophalen.
return-to-amo-add-extension-label = De extensie toevoegen
return-to-amo-add-theme-label = Het thema toevoegen

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Aan de slag: scherm { $current } van { $total }

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages

onboarding-welcome-steps-indicator2 =
    .aria-valuetext = Voortgang: stap { $current } van { $total }
# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Waterfox, how they use
# Waterfox to pursue those passions, as well as the boldness in their
# choice to use Waterfox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text = Het vuur begint hier
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio – Meubelontwerper, Waterfox-fan
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Animaties uitschakelen

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Waterfox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] { -brand-short-name } aan uw Dock toevoegen voor eenvoudige toegang
       *[other] { -brand-short-name } aan uw taakbalk vastzetten voor eenvoudige toegang
    }
# Primary button string used on welcome page when Waterfox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Aan Dock toevoegen
       *[other] Aan taakbalk vastzetten
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Beginnen
mr1-onboarding-welcome-header = Welkom bij { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = { -brand-short-name } mijn voorkeursbrowser maken
    .title = Stelt { -brand-short-name } in als standaardbrowser en maakt het aan de taakbalk vast
# This string will be used on welcome page primary button label
# when Waterfox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = { -brand-short-name } mijn voorkeursbrowser maken
mr1-onboarding-set-default-secondary-button-label = Niet nu
mr1-onboarding-sign-in-button-label = Aanmelden

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

mr1-onboarding-default-header = { -brand-short-name } uw standaardbrowser maken
mr1-onboarding-default-subtitle = Zet snelheid, veiligheid en privacy op de automatische piloot.
mr1-onboarding-default-primary-button-label = Standaardbrowser maken

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = Neem alles met u mee
mr1-onboarding-import-subtitle = Importeer uw wachtwoorden, <br/>bladwijzers en meer.
# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Importeren uit { $previous }
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = Importeren uit vorige browser
mr1-onboarding-import-secondary-button-label = Niet nu
mr2-onboarding-colorway-header = Leven in kleur
mr2-onboarding-colorway-subtitle = Levendige nieuwe kleurstellingen. Beschikbaar gedurende een beperkte tijd.
mr2-onboarding-colorway-primary-button-label = Kleurstelling opslaan
mr2-onboarding-colorway-secondary-button-label = Niet nu
mr2-onboarding-colorway-label-soft = Zacht
mr2-onboarding-colorway-label-balanced = Gebalanceerd
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
mr2-onboarding-colorway-label-bold = Stevig
# Automatic theme uses operating system color settings
mr2-onboarding-theme-label-auto = Automatisch
# This string will be used for Default theme
mr2-onboarding-theme-label-default = Standaard
mr1-onboarding-theme-header = Maak het van uzelf
mr1-onboarding-theme-subtitle = Personaliseer { -brand-short-name } met een thema.
mr1-onboarding-theme-primary-button-label = Thema opslaan
mr1-onboarding-theme-secondary-button-label = Niet nu
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = Systeemthema
mr1-onboarding-theme-label-light = Licht
mr1-onboarding-theme-label-dark = Donker
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpenglow
onboarding-theme-primary-button-label = Gereed

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title =
        Het thema van het besturingssysteem
        voor knoppen, menu’s en vensters volgen.
# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        Het thema van het besturingssysteem
        voor knoppen, menu’s en vensters volgen.
# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title =
        Een licht thema gebruiken voor knoppen,
        menu’s en vensters.
# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description =
        Een licht thema gebruiken voor knoppen,
        menu’s en vensters.
# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title =
        Een donker thema gebruiken voor knoppen,
        menu’s en vensters.
# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description =
        Een donker thema gebruiken voor knoppen,
        menu’s en vensters.
# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title =
        Een dynamisch, kleurrijk thema gebruiken voor knoppen,
        menu’s en vensters.
# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description =
        Een dynamisch, kleurrijk thema gebruiken voor knoppen,
        menu’s en vensters.
# Tooltip displayed on hover of non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-tooltip =
    .title = Deze kleurstelling gebruiken.
# Selector description for non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-description =
    .aria-description = Deze kleurstelling gebruiken.
# Tooltip displayed on hover of colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-tooltip =
    .title = Kleurstellingen { $colorwayName } ontdekken.
# Selector description for colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-label = Kleurstellingen { $colorwayName } ontdekken.
# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = Standaardthema’s ontdekken.
# Selector description for default themes
mr2-onboarding-default-theme-label = Standaardthema’s ontdekken.

## Strings for Thank You page

mr2-onboarding-thank-you-header = Bedankt dat u voor ons kiest
mr2-onboarding-thank-you-text = { -brand-short-name } is een onafhankelijke browser die wordt ondersteund door een non-profitorganisatie. Samen maken we het internet veiliger, gezonder en meer privé.
mr2-onboarding-start-browsing-button-label = Beginnen met surfen

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

onboarding-live-language-header = Kies uw taal
mr2022-onboarding-live-language-text = { -brand-short-name } spreekt uw taal
mr2022-language-mismatch-subtitle = Dankzij onze gemeenschap is { -brand-short-name } vertaald in meer dan 90 talen. Het lijkt erop dat uw systeem { $systemLanguage } gebruikt en { -brand-short-name } { $appLanguage }.
onboarding-live-language-button-label-downloading = Het taalpakket downloaden voor { $negotiatedLanguage }…
onboarding-live-language-waiting-button = Beschikbare talen ophalen...
onboarding-live-language-installing = Het taalpakket voor { $negotiatedLanguage } installeren...
mr2022-onboarding-live-language-switch-to = Overschakelen naar { $negotiatedLanguage }
mr2022-onboarding-live-language-continue-in = Doorgaan in { $appLanguage }
onboarding-live-language-secondary-cancel-download = Annuleren
onboarding-live-language-skip-button-label = Overslaan

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
    Maal
    <span data-l10n-name="zap">dank</span>
fx100-thank-you-subtitle = Dit is onze 100ste versie! Bedankt voor het helpen bouwen aan een beter, gezonder internet.
fx100-thank-you-pin-primary-button-label =
    { PLATFORM() ->
        [macos] { -brand-short-name } aan de Dock vastmaken
       *[other] { -brand-short-name } aan de taakbalk vastmaken
    }
fx100-upgrade-thanks-header = 100 maal dank
# Message shown with a start-browsing button. Emphasis <em> should be for "you"
# but "Thank" can be used instead if there's no "you" in the translation.
fx100-upgrade-thank-you-body = Het is onze 100e versie van { -brand-short-name }. <em>Bedankt</em> voor uw hulp bij het bouwen van een beter, gezonder internet.
# Message shown with either a pin-to-taskbar or set-default button.
fx100-upgrade-thanks-keep-body = Het is onze 100ste versie! Bedankt dat u deel uitmaakt van onze gemeenschap. Houd { -brand-short-name } één klik verwijderd voor de volgende 100.
mr2022-onboarding-secondary-skip-button-label = Deze stap overslaan

## MR2022 New User Pin Waterfox screen strings

# Title used on about:welcome for new users when Waterfox is not pinned.
# In this context, open up is synonymous with "Discover".
# The metaphor is that when they open their Waterfox browser, it helps them discover an amazing internet.
# If this translation does not make sense in your language, feel free to use the word "discover."
mr2022-onboarding-welcome-pin-header = Open een geweldig internet
# Subtitle is used on onboarding page for new users page when Waterfox is not pinned
mr2022-onboarding-welcome-pin-subtitle = Start overal { -brand-short-name } met een enkele klik. Elke keer dat u dat doet, kiest u voor een meer open en onafhankelijk internet.
# Primary button string used on welcome page for when Waterfox is not pinned.
mr2022-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] { -brand-short-name } in Dock houden
       *[other] { -brand-short-name } aan de taakbalk vastmaken
    }
# Subtitle will be used when user already has Waterfox pinned, but
# has not set it as their default browser.
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-only-subtitle = Start met een browser die wordt ondersteund door een non-profitorganisatie. Wij verdedigen uw privacy terwijl u surft op het web.

## MR2022 Existing User Pin Waterfox Screen Strings

# Title used on multistage onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-header = Bedankt voor uw liefde voor { -brand-product-name }
# Subtitle is used on onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-subtitle = Start een gezonder internet vanaf elke locatie met een enkele klik. Onze nieuwste update zit boordevol nieuwe dingen waarvan we denken dat u ze geweldig zult vinden.
# Subtitle will be used on the welcome screen for existing users
# when they already have Waterfox pinned but not set as default
mr2022-onboarding-existing-set-default-only-subtitle = Gebruik een browser die uw privacy verdedigt terwijl u rondsurft op internet. Onze nieuwste update zit boordevol dingen waar u dol op bent.
mr2022-onboarding-existing-pin-checkbox-label = Voeg ook privénavigatie met { -brand-short-name } toe

## MR2022 New User Set Default screen strings

# This string is the title used when the user already has pinned the browser, but has not set default.
mr2022-onboarding-set-default-title = Maak van { -brand-short-name } uw favoriete browser
mr2022-onboarding-set-default-primary-button-label = { -brand-short-name } instellen als standaardbrowser
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-subtitle = Gebruik een browser die wordt ondersteund door een non-profitorganisatie. Wij verdedigen uw privacy terwijl u rondsurft op het internet.

## MR2022 Get Started screen strings.
## These strings will be used on the welcome page
## when Waterfox is already set to default and pinned.

# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-get-started-primary-subtitle = Onze nieuwste versie is rondom u gebouwd, waardoor het eenvoudiger dan ooit is om over het internet te surfen. Het zit boordevol functies waarvan we denken dat u er dol op zult zijn.
mr2022-onboarding-get-started-primary-button-label = Binnen enkele seconden opgezet

## MR2022 Import Settings screen strings

mr2022-onboarding-import-header = Razendsnelle installatie
mr2022-onboarding-import-subtitle = Stel { -brand-short-name } in zoals u het wilt. Voeg uw bladwijzers, wachtwoorden en meer toe vanuit uw oude browser.
mr2022-onboarding-import-primary-button-label-no-attribution = Importeren uit vorige browser

## If your language uses grammatical genders, in the description for the
## colorway feel free to switch from "You are a X. You…" (e.g. "You are a
## Playmaker. You create…") to "X: you…" ("Playmaker: You create…"). This might
## help creating a more inclusive translation.

mr2022-onboarding-colorway-title = Kies de kleur die u inspireert
mr2022-onboarding-colorway-subtitle = Onafhankelijke stemmen kunnen cultuur veranderen.
mr2022-onboarding-colorway-primary-button-label = Kleurstelling instellen
mr2022-onboarding-existing-colorway-checkbox-label = Maak van { -firefox-home-brand-name } uw kleurrijke startpagina
mr2022-onboarding-colorway-label-default = Standaard
mr2022-onboarding-colorway-tooltip-default =
    .title = Standaard
mr2022-onboarding-colorway-description-default = <b>Mijn huidige { -brand-short-name }-kleuren gebruiken.</b>
mr2022-onboarding-colorway-label-playmaker = Spelmaker
mr2022-onboarding-colorway-tooltip-playmaker =
    .title = Spelmaker
mr2022-onboarding-colorway-description-playmaker = <b>U bent een spelmaker.</b> U creëert kansen om te winnen en helpt iedereen om u heen hun spel te verbeteren.
mr2022-onboarding-colorway-label-expressionist = Expressionist
mr2022-onboarding-colorway-tooltip-expressionist =
    .title = Expressionist
mr2022-onboarding-colorway-description-expressionist = <b>U bent een expressionist.</b> U ziet de wereld anders en uw creaties roeren de emoties van anderen.
mr2022-onboarding-colorway-label-visionary = Visionair
mr2022-onboarding-colorway-tooltip-visionary =
    .title = Visionair
mr2022-onboarding-colorway-description-visionary = <b>U bent een visionair.</b> U trekt de status-quo in twijfel en stimuleert anderen om zich een betere toekomst voor te stellen.
mr2022-onboarding-colorway-label-activist = Activist
mr2022-onboarding-colorway-tooltip-activist =
    .title = Activist
mr2022-onboarding-colorway-description-activist = <b>U bent een activist.</b> U laat de wereld mooier achter dan u hem aantrof en laat anderen geloven.
mr2022-onboarding-colorway-label-dreamer = Dromer
mr2022-onboarding-colorway-tooltip-dreamer =
    .title = Dromer
mr2022-onboarding-colorway-description-dreamer = <b>U bent een dromer.</b> U gelooft dat geluk met de stoutmoedigen is en inspireert anderen om dapper te zijn.
mr2022-onboarding-colorway-label-innovator = Innovator
mr2022-onboarding-colorway-tooltip-innovator =
    .title = Innovator
mr2022-onboarding-colorway-description-innovator = <b>U bent een innovator.</b> U ziet overal kansen en hebt invloed op het leven van iedereen om u heen.

## MR2022 Multistage Mobile Download screen strings

mr2022-onboarding-mobile-download-title = Spring van laptop naar telefoon en weer terug
mr2022-onboarding-mobile-download-subtitle = Haal tabbladen van het ene apparaat op en ga verder waar u was gebleven op een ander. Synchroniseer daarnaast uw bladwijzers en wachtwoorden overal waar u { -brand-product-name } gebruikt.
mr2022-onboarding-mobile-download-cta-text = Scan de QR-code om { -brand-product-name } voor mobiel te downloaden of <a data-l10n-name="download-label">stuur uzelf een downloadkoppeling.</a>
mr2022-onboarding-no-mobile-download-cta-text = Scan de QR-code om { -brand-product-name } voor mobiel te downloaden

## MR2022 Upgrade Dialog screens
## Pin private window screen shown only for users who don't have Waterfox private pinned

mr2022-upgrade-onboarding-pin-private-window-header = Ontvang de vrijheid van privénavigatie in één klik
mr2022-upgrade-onboarding-pin-private-window-subtitle = Geen opgeslagen cookies of geschiedenis, rechtstreeks vanaf uw bureaublad. Surf alsof niemand kijkt.
mr2022-upgrade-onboarding-pin-private-window-primary-button-label =
    { PLATFORM() ->
        [macos] { -brand-short-name }-privénavigatie in de Dock houden
       *[other] { -brand-short-name }-privénavigatie aan mijn taakbalk vastmaken
    }

## MR2022 Privacy Segmentation screen strings

mr2022-onboarding-privacy-segmentation-title = We respecteren altijd uw privacy
mr2022-onboarding-privacy-segmentation-subtitle = Van intelligente suggesties tot slimmer zoeken, we werken voortdurend aan een betere, meer persoonlijke { -brand-product-name }.
mr2022-onboarding-privacy-segmentation-text-cta = Wat wilt u zien als we nieuwe functies aanbieden die uw gegevens gebruiken om uw navigatie te verbeteren?
mr2022-onboarding-privacy-segmentation-button-primary-label = { -brand-product-name }-aanbevelingen gebruiken
mr2022-onboarding-privacy-segmentation-button-secondary-label = Detailinformatie tonen

## MR2022 Multistage Gratitude screen strings

mr2022-onboarding-gratitude-title = U helpt ons een beter web te bouwen.
mr2022-onboarding-gratitude-subtitle = Bedankt voor het gebruik van { -brand-short-name }, ondersteund door de Waterfox Limited. Met uw steun werken we eraan om het internet voor iedereen opener, toegankelijker en beter te maken.
mr2022-onboarding-gratitude-primary-button-label = Zie wat er nieuw is
mr2022-onboarding-gratitude-secondary-button-label = Beginnen met browsen
