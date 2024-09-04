# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Velkommen til { -brand-short-name }
onboarding-start-browsing-button-label = Kom i gang
onboarding-not-now-button-label = Ikke nu
mr1-onboarding-get-started-primary-button-label = Kom i gang

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Perfekt, du har installeret { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Lad os nu hente <img data-l10n-name="icon"/><b>{ $addon-name }</b>.
return-to-amo-add-extension-label = Tilføj udvidelsen
return-to-amo-add-theme-label = Tilføj temaet

##  Variables: $addon-name (String) - Name of the add-on to be installed

mr1-return-to-amo-subtitle = Velkommen til { -brand-short-name }
mr1-return-to-amo-addon-title = Du har en hurtig browser, der beskytter dit privatliv. Nu kan du tilføje <b>{ $addon-name }</b> og gøre endnu mere med { -brand-short-name }.
mr1-return-to-amo-add-extension-label = Tilføj { $addon-name }

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages

onboarding-welcome-steps-indicator-label =
    .aria-label = Status: Skridt { $current } af { $total }

# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Slå animationer fra

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

## Multistage MR1 onboarding strings (about:welcome pages)

# String for the Waterfox Accounts button
mr1-onboarding-sign-in-button-label = Log ind

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

## Multistage MR1 onboarding strings (about:welcome pages)

# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Importer fra { $previous }

mr1-onboarding-theme-header = Du bestemmer
mr1-onboarding-theme-subtitle = Gør { -brand-short-name } mere personlig med et tema.
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

## MR2022 New User Easy Setup screen strings

# Primary button string used on new user onboarding first screen showing multiple actions such as Set Default, Import from previous browser.
mr2022-onboarding-easy-setup-primary-button-label = Gem og fortsæt
# Set Default action checkbox label used on new user onboarding first screen
mr2022-onboarding-easy-setup-set-default-checkbox-label = Gør { -brand-short-name } til min standard-browser
# Import action checkbox label used on new user onboarding first screen
mr2022-onboarding-easy-setup-import-checkbox-label = Importer fra tidligere browser

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
mr2022-onboarding-colorway-primary-button-label-continue = Indstil og fortsæt
mr2022-onboarding-existing-colorway-checkbox-label = Gør { -firefox-home-brand-name } til din farverige startside

mr2022-onboarding-colorway-label-default = Standard
mr2022-onboarding-colorway-tooltip-default2 =
    .title = Aktuelle { -brand-short-name }-farver
mr2022-onboarding-colorway-description-default = <b>Brug mine nuværende { -brand-short-name }-farver.</b>

mr2022-onboarding-colorway-label-playmaker = Playmaker
mr2022-onboarding-colorway-tooltip-playmaker2 =
    .title = Playmaker (rød)
mr2022-onboarding-colorway-description-playmaker = <b>Du er en playmaker.</b> Du skaber muligheder for at vinde og hjælper alle omkring dig med at forbedre deres spil.

mr2022-onboarding-colorway-label-expressionist = Ekspressionist
mr2022-onboarding-colorway-tooltip-expressionist2 =
    .title = Ekspressionist (gul)
mr2022-onboarding-colorway-description-expressionist = <b>Du er en ekspressionist.</b> Du ser verden på en anden måde, og dine værker vækker andres følelser.

mr2022-onboarding-colorway-label-visionary = Visionær
mr2022-onboarding-colorway-tooltip-visionary2 =
    .title = Visionær (grøn)
mr2022-onboarding-colorway-description-visionary = <b>Du er en visionær.</b> Du stiller spørgsmålstegn til tingenes tilstand og får andre til at forestille sig en bedre fremtid.

mr2022-onboarding-colorway-label-activist = Aktivist
mr2022-onboarding-colorway-tooltip-activist2 =
    .title = Aktivist (blå)
mr2022-onboarding-colorway-description-activist = <b>Du er en aktivist.</b> Du engagerer dig for at gøre verden bedre og får andre med dig.

mr2022-onboarding-colorway-label-dreamer = Drømmer
mr2022-onboarding-colorway-tooltip-dreamer2 =
    .title = Drømmer (lilla)
mr2022-onboarding-colorway-description-dreamer = <b>Du er en drømmer.</b> Du mener, at lykken står den kække bi, og inspirerer andre til at være modige.

mr2022-onboarding-colorway-label-innovator = Nyskaber
mr2022-onboarding-colorway-tooltip-innovator2 =
    .title = Nyskaber (orange)
mr2022-onboarding-colorway-description-innovator = <b>Du er en nyskaber.</b> Du ser muligheder overalt og påvirker livet for alle omkring dig.

## MR2022 Multistage Mobile Download screen strings

mr2022-onboarding-mobile-download-title = Hop fra din computer til din telefon og tilbage igen.
mr2022-onboarding-mobile-download-subtitle = Hent faneblade fra én enhed og fortsæt hvor du slap på en anden enhed. Synkroniser desuden dine bogmærker og adgangskoder overalt, hvor du bruger { -brand-product-name }.
mr2022-onboarding-mobile-download-cta-text = Skan QR-koden for at hente { -brand-product-name } til din mobil, eller <a data-l10n-name="download-label">send et link til dig selv, så du kan hente filen.</a>
mr2022-onboarding-no-mobile-download-cta-text = Skan QR-koden for at hente { -brand-product-name } til din mobil.

## MR2022 Upgrade Dialog screens
## Pin private window screen shown only for users who don't have Waterfox private pinned

mr2022-upgrade-onboarding-pin-private-window-header = Få privat browsing-frihed med et enkelt klik
mr2022-upgrade-onboarding-pin-private-window-subtitle = Ingen gemte cookies eller historik, direkte fra dit skrivebord. Brug nettet uden tilskuere.
mr2022-upgrade-onboarding-pin-private-window-primary-button-label =
    { PLATFORM() ->
        [macos] Behold { -brand-short-name } privat browsing i Dock
       *[other] Fastgør { -brand-short-name } privat browsing til proceslinjen
    }

## MR2022 Privacy Segmentation screen strings

mr2022-onboarding-privacy-segmentation-title = Vi respekterer altid din ret til et privatliv
mr2022-onboarding-privacy-segmentation-subtitle = Fra intelligente forslag til smartere søgning. Vi arbejder altid på at gøre { -brand-product-name } bedre og mere personlig.
mr2022-onboarding-privacy-segmentation-text-cta = Hvad vil du gerne se, når vi laver nye funktioner, der bruger dine data til at forbedre din browsing?
mr2022-onboarding-privacy-segmentation-button-primary-label = Brug { -brand-product-name }-anbefalinger
mr2022-onboarding-privacy-segmentation-button-secondary-label = Vis detaljeret information

## MR2022 Multistage Gratitude screen strings

mr2022-onboarding-gratitude-title = Du hjælper os med at bygge et bedre internet
mr2022-onboarding-gratitude-subtitle = Tak for at du bruger { -brand-short-name }, der er støttet af BrowserWorks. Med din hjælp arbejder vi for at gøre internettet bedre for alle, mere åbent og mere tilgængeligt.
mr2022-onboarding-gratitude-primary-button-label = Se nyhederne
mr2022-onboarding-gratitude-secondary-button-label = Afslut rundvisningen

## Onboarding spotlight for infrequent users

onboarding-infrequent-import-title = Føl dig hjemme
onboarding-infrequent-import-subtitle = Uanset om du er ved at flytte ind eller bare kigger forbi: Husk at du kan importere dine bogmærker, adgangskoder og mere.
onboarding-infrequent-import-primary-button = Importer til { -brand-short-name }

## MR2022 Illustration alt tags
## Descriptive tags for illustrations used by screen readers and other assistive tech

mr2022-onboarding-pin-image-alt =
    .aria-label = Person, der arbejder på en bærbar computer, omgivet af stjerner og blomster
mr2022-onboarding-default-image-alt =
    .aria-label = Person, der omfavner { -brand-product-name }-logoet
mr2022-onboarding-import-image-alt =
    .aria-label = Person, der kører på skateboard med en kasse software-ikoner
mr2022-onboarding-mobile-download-image-alt =
    .aria-label = Frøer, der hopper på åkandeblade med QR-koden til at hente { -brand-product-name } til mobil i midten
mr2022-onboarding-pin-private-image-alt =
    .aria-label = En tryllestav får logoet for { -brand-product-name } privat browsing til at komme ud af en hat
mr2022-onboarding-privacy-segmentation-image-alt =
    .aria-label = Lyshudede og mørkhudede hænder giver hinanden en high-five
mr2022-onboarding-gratitude-image-alt =
    .aria-label = Udsigt til en solnedgang gennem et vindue med en ræv og en stueplante i en vindueskarm
mr2022-onboarding-colorways-image-alt =
    .aria-label = En hånd spraymaler en farverig kollage bestående af et grønt øje, en orange sko, en rød basketball, lilla hovedtelefoner, et blåt hjerte og en gul krone

## Device migration onboarding

onboarding-device-migration-image-alt =
    .aria-label = En vinkende ræv på en bærbar computers skærm. Den bærbare computer har en mus tilsluttet.
onboarding-device-migration-title = Velkommen tilbage!
onboarding-device-migration-subtitle = Log ind på din { -fxaccount-brand-name } for at få adgang til dine bogmærker, adgangskoder og historik på din nye enhed.
onboarding-device-migration-primary-button-label = Log ind
