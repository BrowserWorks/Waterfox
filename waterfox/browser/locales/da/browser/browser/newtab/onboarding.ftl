# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Velkommen til { -brand-short-name }
onboarding-start-browsing-button-label = Kom i gang
onboarding-not-now-button-label = Ikke nu

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Perfekt, du har installeret { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Lad os nu hente <img data-l10n-name="icon"/><b>{ $addon-name }</b>.
return-to-amo-add-extension-label = Tilføj udvidelsen
return-to-amo-add-theme-label = Tilføj temaet

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Kom i gang: Side { $current } af { $total }

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages

onboarding-welcome-steps-indicator2 =
    .aria-valuetext = Status: Skridt { $current } af { $total }
# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Waterfox, how they use
# Waterfox to pursue those passions, as well as the boldness in their
# choice to use Waterfox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text = Alt starter her
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio - møbeldesigner og Waterfox-fan
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Slå animationer fra

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Waterfox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] Behold { -brand-short-name } i din Dock for nem adgang
       *[other] Fastgør { -brand-short-name } til din proceslinje for nem adgang
    }
# Primary button string used on welcome page when Waterfox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Behold i Dock
       *[other] Fastgør til proceslinjen
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Kom i gang
mr1-onboarding-welcome-header = Velkommen til { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = Gør { -brand-short-name } til min foretrukne browser
    .title = Sætter { -brand-short-name } som standard-browser og fastgør den til proceslinjen
# This string will be used on welcome page primary button label
# when Waterfox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = Gør { -brand-short-name } til min standard-browser
mr1-onboarding-set-default-secondary-button-label = Ikke nu
mr1-onboarding-sign-in-button-label = Log ind

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

mr1-onboarding-default-header = Gør { -brand-short-name } til din standard-browser
mr1-onboarding-default-subtitle = Sæt hastighed, sikkerhed og privatlivsbeskyttelse på autopilot.
mr1-onboarding-default-primary-button-label = Angiv som standard-browser

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = Tag det hele med dig
mr1-onboarding-import-subtitle = Importer dine adgangskoder, <br/>bogmærker med mere.
# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Importer fra { $previous }
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = Importer fra tidligere browser
mr1-onboarding-import-secondary-button-label = Ikke nu
mr2-onboarding-colorway-header = Nye farver
mr2-onboarding-colorway-subtitle = Dynamiske nye farvekombinationer. Findes kun i begrænset tid.
mr2-onboarding-colorway-primary-button-label = Gem farvekombination
mr2-onboarding-colorway-secondary-button-label = Ikke nu
mr2-onboarding-colorway-label-soft = Blød
mr2-onboarding-colorway-label-balanced = Balanceret
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
mr2-onboarding-colorway-label-bold = Dristig
# Automatic theme uses operating system color settings
mr2-onboarding-theme-label-auto = Automatisk
# This string will be used for Default theme
mr2-onboarding-theme-label-default = Standard
mr1-onboarding-theme-header = Du bestemmer
mr1-onboarding-theme-subtitle = Gør { -brand-short-name } mere personlig med et tema.
mr1-onboarding-theme-primary-button-label = Gem tema
mr1-onboarding-theme-secondary-button-label = Ikke nu
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = Systemets tema
mr1-onboarding-theme-label-light = Lyst
mr1-onboarding-theme-label-dark = Mørkt
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpenglow
onboarding-theme-primary-button-label = Færdig

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title =
        Følg operativsystems tema
        til knapper, menuer og vinduer.
# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        Følg operativsystems tema
        til knapper, menuer og vinduer.
# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title =
        Brug et lyst tema til knapper, 
        menuer og vinduer.
# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description =
        Brug et lyst tema til knapper, 
        menuer og vinduer.
# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title =
        Brug et mørkt tema til knapper, 
        menuer og vinduer.
# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description =
        Brug et mørkt tema til knapper, 
        menuer og vinduer.
# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title =
        Brug et dynamisk og farverigt tema til knapper, 
        menuer og vinduer.
# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description =
        Brug et dynamisk og farverigt tema til knapper, 
        menuer og vinduer.
# Tooltip displayed on hover of non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-tooltip =
    .title = Brug denne farvekombination.
# Selector description for non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-description =
    .aria-description = Brug denne farvekombination.
# Tooltip displayed on hover of colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-tooltip =
    .title = Udforsk { $colorwayName }-farvekombinationer.
# Selector description for colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-label = Udforsk { $colorwayName }-farvekombinationer.
# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = Udforsk standard-temaer.
# Selector description for default themes
mr2-onboarding-default-theme-label = Udforsk standard-temaer.

## Strings for Thank You page

mr2-onboarding-thank-you-header = Tak for at du valgte os
mr2-onboarding-thank-you-text = { -brand-short-name } er en uafhængig browser støttet af en nonprofit-organisation. Sammen sørger vi for, at internettet er sikrere, sundere og respekterer folks privatliv.
mr2-onboarding-start-browsing-button-label = Afslut rundvisningen

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

onboarding-live-language-header = Vælg dit sprog
mr2022-onboarding-live-language-text = { -brand-short-name } taler dit sprog
mr2022-language-mismatch-subtitle = Takket være vores fællesskab er { -brand-short-name } oversat til mere end 90 sprog. Det ser ud til, at dit system bruger { $systemLanguage } og { -brand-short-name } bruger { $appLanguage }.
onboarding-live-language-button-label-downloading = Henter sprogpakke til { $negotiatedLanguage }…
onboarding-live-language-waiting-button = Henter tilgængelige sprog…
onboarding-live-language-installing = Installerer sprogpakke til { $negotiatedLanguage }…
mr2022-onboarding-live-language-switch-to = Skift til { $negotiatedLanguage }
mr2022-onboarding-live-language-continue-in = Fortsæt med { $appLanguage }
onboarding-live-language-secondary-cancel-download = Annuller
onboarding-live-language-skip-button-label = Spring over

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
    gange
    <span data-l10n-name="zap">tak</span>
fx100-thank-you-subtitle = Det er vores version nummer 100! Tak for at du hjælper os med at skabe et bedre og sundere internet.
fx100-thank-you-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Behold { -brand-short-name } i Dock
       *[other] Fastgør { -brand-short-name } til proceslinjen
    }
fx100-upgrade-thanks-header = 100 gange tak
# Message shown with a start-browsing button. Emphasis <em> should be for "you"
# but "Thank" can be used instead if there's no "you" in the translation.
fx100-upgrade-thank-you-body = Det er vores version nummer 100 af { -brand-short-name }. Tak for at <em>du</em> hjælper os med at skabe et bedre og sundere internet.
# Message shown with either a pin-to-taskbar or set-default button.
fx100-upgrade-thanks-keep-body = Det er vores version nummer 100! Tak for at du er en del af fællesskabet. Hav { -brand-short-name } indenfor rækkevide i de næste 100.
mr2022-onboarding-secondary-skip-button-label = Spring dette trin over

## MR2022 New User Pin Waterfox screen strings

# Title used on about:welcome for new users when Waterfox is not pinned.
# In this context, open up is synonymous with "Discover".
# The metaphor is that when they open their Waterfox browser, it helps them discover an amazing internet.
# If this translation does not make sense in your language, feel free to use the word "discover."
mr2022-onboarding-welcome-pin-header = Åbn op for et fantastisk internet
# Subtitle is used on onboarding page for new users page when Waterfox is not pinned
mr2022-onboarding-welcome-pin-subtitle = Start { -brand-short-name } hvor som helst med et enkelt klik. Hver gang du gør det, vælger du et mere åbent og uafhængigt internet.
# Primary button string used on welcome page for when Waterfox is not pinned.
mr2022-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Behold { -brand-short-name } i Dock
       *[other] Fastgør { -brand-short-name } til proceslinjen
    }
# Subtitle will be used when user already has Waterfox pinned, but
# has not set it as their default browser.
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-only-subtitle = Start med en browser, der er støttet af en nonprofit-organisation. Vi forsvarer din ret til et privatliv, mens du bevæger dig rundt på nettet.

## MR2022 Existing User Pin Waterfox Screen Strings

# Title used on multistage onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-header = Tak for at du støtter { -brand-product-name }
# Subtitle is used on onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-subtitle = Få adgang til et sundere internet med et enkelt klik. Vores seneste opdatering er fyldt med nyheder, vi tror du kommer til at elske.
# Subtitle will be used on the welcome screen for existing users
# when they already have Waterfox pinned but not set as default
mr2022-onboarding-existing-set-default-only-subtitle = Brug en browser, der forsvarer din ret til et privatliv, mens du bevæger dig rundt på nettet. Vores seneste opdatering er fyldt med nyheder, du kommer til at elske.
mr2022-onboarding-existing-pin-checkbox-label = Tilføj også { -brand-short-name } privat browsing

## MR2022 New User Set Default screen strings

# This string is the title used when the user already has pinned the browser, but has not set default.
mr2022-onboarding-set-default-title = Gør { -brand-short-name } til din standard-browser
mr2022-onboarding-set-default-primary-button-label = Gør { -brand-short-name } til min standard-browser
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-subtitle = Brug en browser, der er støttet af en nonprofit-organisation. Vi forsvarer din ret til et privatliv, mens du bevæger dig rundt på nettet.

## MR2022 Get Started screen strings.
## These strings will be used on the welcome page
## when Waterfox is already set to default and pinned.

# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-get-started-primary-subtitle = Vores seneste version er bygget for at opfylde dine behov og gøre det nemmere at bevæge dig rundt på nettet. Den er fyldt med funktioner, vi tror du kommer til at elske.
mr2022-onboarding-get-started-primary-button-label = Hurtig opsætning

## MR2022 Import Settings screen strings

mr2022-onboarding-import-header = Lynhurtig opsætning
mr2022-onboarding-import-subtitle = Opsæt { -brand-short-name } som du vil. Tilføj dine bogmærker, adgangskoder og mere fra din gamle browser.
mr2022-onboarding-import-primary-button-label-no-attribution = Importer fra tidligere browser

## If your language uses grammatical genders, in the description for the
## colorway feel free to switch from "You are a X. You…" (e.g. "You are a
## Playmaker. You create…") to "X: you…" ("Playmaker: You create…"). This might
## help creating a more inclusive translation.

mr2022-onboarding-colorway-title = Vælg den farve, der inspirerer dig
mr2022-onboarding-colorway-subtitle = Uafhængige stemmer kan ændre kulturen.
mr2022-onboarding-colorway-primary-button-label = Indstil farvekombination
mr2022-onboarding-existing-colorway-checkbox-label = Gør { -firefox-home-brand-name } til din farverige startside
mr2022-onboarding-colorway-label-default = Standard
mr2022-onboarding-colorway-tooltip-default =
    .title = Standard
mr2022-onboarding-colorway-description-default = <b>Brug mine nuværende { -brand-short-name }-farver.</b>
mr2022-onboarding-colorway-label-playmaker = Playmaker
mr2022-onboarding-colorway-tooltip-playmaker =
    .title = Playmaker
mr2022-onboarding-colorway-description-playmaker = <b>Du er en playmaker.</b> Du skaber muligheder for at vinde og hjælper alle omkring dig med at forbedre deres spil.
mr2022-onboarding-colorway-label-expressionist = Ekspressionist
mr2022-onboarding-colorway-tooltip-expressionist =
    .title = Ekspressionist
mr2022-onboarding-colorway-description-expressionist = <b>Du er en ekspressionist.</b> Du ser verden på en anden måde, og dine værker vækker andres følelser.
mr2022-onboarding-colorway-label-visionary = Visionær
mr2022-onboarding-colorway-tooltip-visionary =
    .title = Visionær
mr2022-onboarding-colorway-description-visionary = <b>Du er en visionær.</b> Du stiller spørgsmålstegn til tingenes tilstand og får andre til at forestille sig en bedre fremtid.
mr2022-onboarding-colorway-label-activist = Aktivist
mr2022-onboarding-colorway-tooltip-activist =
    .title = Aktivist
mr2022-onboarding-colorway-description-activist = <b>Du er en aktivist.</b> Du engagerer dig for at gøre verden bedre og får andre med dig.
mr2022-onboarding-colorway-label-dreamer = Drømmer
mr2022-onboarding-colorway-tooltip-dreamer =
    .title = Drømmer
mr2022-onboarding-colorway-description-dreamer = <b>Du er en drømmer.</b> Du mener, at lykken står den kække bi, og inspirerer andre til at være modige.
mr2022-onboarding-colorway-label-innovator = Nyskaber
mr2022-onboarding-colorway-tooltip-innovator =
    .title = Nyskaber
mr2022-onboarding-colorway-description-innovator = <b>Du er en nyskaber.</b> Du ser muligheder overalt og påvirker livet for alle omkring dig.

## MR2022 Multistage Mobile Download screen strings

mr2022-onboarding-mobile-download-title = Hop fra din computer til din telefon og tilbage igen.
mr2022-onboarding-mobile-download-subtitle = Hent faneblade fra én enhed og fortsæt hvor du slap på en anden enhed. Synkroniser desuden dine bogmærker og adgangskoder overalt, hvor du bruger { -brand-product-name }.
mr2022-onboarding-mobile-download-cta-text = Skan QR-koden for at hente { -brand-product-name } til din mobil, eller <a data-l10n-name="download-label">send et link til dig selv, så du kan hente filen.</a>
mr2022-onboarding-no-mobile-download-cta-text = Skan QR-koden for at hente { -brand-product-name } til din mobil.

## MR2022 Upgrade Dialog screens
## Pin private window screen shown only for users who don't have Waterfox private pinned

mr2022-upgrade-onboarding-pin-private-window-subtitle = Ingen gemte cookies eller historik, direkte fra dit skrivebord. Brug nettet uden tilskuere.
mr2022-upgrade-onboarding-pin-private-window-primary-button-label =
    { PLATFORM() ->
        [macos] Behold { -brand-short-name } privat browsing i Dock
       *[other] Fastgør { -brand-short-name } privat browsing til proceslinjen
    }

## MR2022 Privacy Segmentation screen strings

mr2022-onboarding-privacy-segmentation-title = Vi respekterer altid din ret til et privatliv
mr2022-onboarding-privacy-segmentation-subtitle = Fra intelligente forslag til smartere søgning. Vi arbejder altid på at gøre { -brand-product-name } bedre og mere personlig.

## MR2022 Multistage Gratitude screen strings

