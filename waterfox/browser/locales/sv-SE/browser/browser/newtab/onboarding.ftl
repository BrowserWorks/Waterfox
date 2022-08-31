# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Välkommen till { -brand-short-name }
onboarding-start-browsing-button-label = Börja surfa
onboarding-not-now-button-label = Inte nu

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Toppen, du har { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Låt oss nu hämta <img data-l10n-name="icon"/> <b>{ $addon-name }</b>.
return-to-amo-add-extension-label = Lägg till tillägget
return-to-amo-add-theme-label = Lägg till temat

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Kom igång:  skärm { $current } av { $total }

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages

onboarding-welcome-steps-indicator2 =
    .aria-valuetext = Framsteg: steg { $current } av { $total }
# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Waterfox, how they use
# Waterfox to pursue those passions, as well as the boldness in their
# choice to use Waterfox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text = Det börjar här
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio — Möbeldesigner, Waterfox-fan
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Stäng av animationer

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Waterfox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] Behåll { -brand-short-name } i Dock för enkel åtkomst
       *[other] Fäst { -brand-short-name } i ditt aktivitetsfält för enkel åtkomst
    }
# Primary button string used on welcome page when Waterfox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Behåll i Dock
       *[other] Fäst till aktivitetsfältet
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Kom igång
mr1-onboarding-welcome-header = Välkommen till { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = Gör { -brand-short-name } till min primära webbläsare
    .title = Ställer in { -brand-short-name } som standardwebbläsare och fäster den i aktivitetsfältet
# This string will be used on welcome page primary button label
# when Waterfox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = Gör { -brand-short-name } till min standardwebbläsare
mr1-onboarding-set-default-secondary-button-label = Inte nu
mr1-onboarding-sign-in-button-label = Logga in

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

mr1-onboarding-default-header = Gör { -brand-short-name } till din standardwebbläsare
mr1-onboarding-default-subtitle = Sätt hastighet, säkerhet och integritet på autopilot.
mr1-onboarding-default-primary-button-label = Gör till standardwebbläsare

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = Ta med dig allt
mr1-onboarding-import-subtitle = Importera dina lösenord, <br/>bokmärken och mer.
# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Importera från { $previous }
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = Importera från tidigare webbläsare
mr1-onboarding-import-secondary-button-label = Inte nu
mr2-onboarding-colorway-header = Ett liv i färg
mr2-onboarding-colorway-subtitle = Levande nya colorways. Tillgängliga under en begränsad tid.
mr2-onboarding-colorway-primary-button-label = Spara colorway
mr2-onboarding-colorway-secondary-button-label = Inte nu
mr2-onboarding-colorway-label-soft = Mjuk
mr2-onboarding-colorway-label-balanced = Balanserad
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
mr2-onboarding-colorway-label-bold = Djärv
# Automatic theme uses operating system color settings
mr2-onboarding-theme-label-auto = Automatisk
# This string will be used for Default theme
mr2-onboarding-theme-label-default = Standard
mr1-onboarding-theme-header = Gör den till din egen
mr1-onboarding-theme-subtitle = Anpassa { -brand-short-name } med ett tema.
mr1-onboarding-theme-primary-button-label = Spara tema
mr1-onboarding-theme-secondary-button-label = Inte nu
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = Systemtema
mr1-onboarding-theme-label-light = Ljust
mr1-onboarding-theme-label-dark = Mörkt
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpenglow
onboarding-theme-primary-button-label = Klar

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title =
        Använder samma färgschema som operativsystemet
        för knappar, menyer och fönster.
# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        Använder samma färgtema som operativsystemet
        för knappar, menyer och fönster.
# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title =
        Använd ett ljust tema för knappar,
        menyer och fönster.
# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description =
        Använd ett ljust tema för knappar,
        menyer och fönster.
# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title =
        Använd ett mörkt tema för knappar,
        menyer och fönster.
# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description =
        Använd ett mörkt tema för knappar,
        menyer och fönster.
# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title =
        Använd ett dynamiskt färgglatt tema för knappar,
        menyer och fönster.
# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description =
        Använd ett dynamiskt färgglatt tema för knappar,
        menyer och fönster.
# Tooltip displayed on hover of non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-tooltip =
    .title = Använd denna colorway.
# Selector description for non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-description =
    .aria-description = Använd denna colorway.
# Tooltip displayed on hover of colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-tooltip =
    .title = Utforska colorways { $colorwayName }.
# Selector description for colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-label = Utforska colorways { $colorwayName }.
# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = Utforska standardteman.
# Selector description for default themes
mr2-onboarding-default-theme-label = Utforska standardteman.

## Strings for Thank You page

mr2-onboarding-thank-you-header = Tack för att du väljer oss
mr2-onboarding-thank-you-text = { -brand-short-name } är en oberoende webbläsare som stöds av en ideell organisation. Tillsammans gör vi webben säkrare, hälsosammare och mer privat.
mr2-onboarding-start-browsing-button-label = Börja surfa

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

onboarding-live-language-header = Välj ditt språk
mr2022-onboarding-live-language-text = { -brand-short-name } talar ditt språk
mr2022-language-mismatch-subtitle = Tack vare vår community är { -brand-short-name } översatt till över 90 språk. Det verkar som att ditt system använder { $systemLanguage } och { -brand-short-name } använder { $appLanguage }.
onboarding-live-language-button-label-downloading = Laddar ned språkpaketet för { $negotiatedLanguage }…
onboarding-live-language-waiting-button = Hämtar tillgängliga språk…
onboarding-live-language-installing = Installerar språkpaketet för { $negotiatedLanguage }…
mr2022-onboarding-live-language-switch-to = Byt till { $negotiatedLanguage }
mr2022-onboarding-live-language-continue-in = Fortsätt med { $appLanguage }
onboarding-live-language-secondary-cancel-download = Avbryt
onboarding-live-language-skip-button-label = Hoppa över

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
    <span data-l10n-name="zap">Tack</span>
fx100-thank-you-subtitle = Det är vår 100:e utgåva! Tack för att du hjälper oss att bygga ett bättre och hälsosammare internet.
fx100-thank-you-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Behåll { -brand-short-name } i Dock
       *[other] Fäst { -brand-short-name } i aktivitetsfältet
    }
fx100-upgrade-thanks-header = 100 Tack
# Message shown with a start-browsing button. Emphasis <em> should be for "you"
# but "Thank" can be used instead if there's no "you" in the translation.
fx100-upgrade-thank-you-body = Det är vår 100:e version av { -brand-short-name }. Tack för att <em>du</em> hjälper oss att bygga ett bättre och hälsosammare internet.
# Message shown with either a pin-to-taskbar or set-default button.
fx100-upgrade-thanks-keep-body = Det är vår 100:e utgåva! Tack för att du är en del av vår gemenskap. Ha { -brand-short-name } ett klick bort för de kommande 100.
mr2022-onboarding-secondary-skip-button-label = Hoppa över det här steget

## MR2022 New User Pin Waterfox screen strings

# Title used on about:welcome for new users when Waterfox is not pinned.
# In this context, open up is synonymous with "Discover".
# The metaphor is that when they open their Waterfox browser, it helps them discover an amazing internet.
# If this translation does not make sense in your language, feel free to use the word "discover."
mr2022-onboarding-welcome-pin-header = Öppna upp ett fantastiskt internet
# Subtitle is used on onboarding page for new users page when Waterfox is not pinned
mr2022-onboarding-welcome-pin-subtitle = Starta { -brand-short-name } från var som helst med ett enda klick. Varje gång du gör det väljer du en mer öppen och oberoende webb.
# Primary button string used on welcome page for when Waterfox is not pinned.
mr2022-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Behåll { -brand-short-name } i Dock
       *[other] Fäst { -brand-short-name } i aktivitetsfältet
    }
# Subtitle will be used when user already has Waterfox pinned, but
# has not set it as their default browser.
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-only-subtitle = Börja med en webbläsare som stöds av en ideell organisation. Vi försvarar din integritet medan du surfar runt på webben.

## MR2022 Existing User Pin Waterfox Screen Strings

# Title used on multistage onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-header = Tack för att du älskar { -brand-product-name }
# Subtitle is used on onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-subtitle = Starta ett hälsosammare internet från var som helst med ett enda klick. Vår senaste uppdatering är full av nya saker som vi tror att du kommer att älska.
# Subtitle will be used on the welcome screen for existing users
# when they already have Waterfox pinned but not set as default
mr2022-onboarding-existing-set-default-only-subtitle = Använd en webbläsare som skyddar din integritet medan du surfar runt på webben. Vår senaste uppdatering är full av saker som du älskar.
mr2022-onboarding-existing-pin-checkbox-label = Lägg även till { -brand-short-name } privat surfning

## MR2022 New User Set Default screen strings

# This string is the title used when the user already has pinned the browser, but has not set default.
mr2022-onboarding-set-default-title = Gör { -brand-short-name } till din favoritwebbläsare
mr2022-onboarding-set-default-primary-button-label = Ställ in { -brand-short-name } som standardwebbläsare
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-subtitle = Använd en webbläsare som stöds av en ideell organisation. Vi försvarar din integritet medan du surfar runt på webben.

## MR2022 Get Started screen strings.
## These strings will be used on the welcome page
## when Waterfox is already set to default and pinned.

# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-get-started-primary-subtitle = Vår senaste version är byggd runt dig, vilket gör det enklare än någonsin att surfa runt på webben. Den är fullproppad med funktioner som vi tror att du kommer att älska.
mr2022-onboarding-get-started-primary-button-label = Konfigurera på några sekunder

## MR2022 Import Settings screen strings

mr2022-onboarding-import-header = Blixtsnabb konfiguration
mr2022-onboarding-import-subtitle = Ställ in { -brand-short-name } som du vill. Lägg till dina bokmärken, lösenord och mer från din gamla webbläsare.
mr2022-onboarding-import-primary-button-label-no-attribution = Importera från tidigare webbläsare

## If your language uses grammatical genders, in the description for the
## colorway feel free to switch from "You are a X. You…" (e.g. "You are a
## Playmaker. You create…") to "X: you…" ("Playmaker: You create…"). This might
## help creating a more inclusive translation.

mr2022-onboarding-colorway-title = Välj den färg som inspirerar dig
mr2022-onboarding-colorway-subtitle = Oberoende röster kan förändra samhället.
mr2022-onboarding-colorway-primary-button-label = Ange colorway
mr2022-onboarding-existing-colorway-checkbox-label = Gör { -firefox-home-brand-name } till din färgglada startsida
mr2022-onboarding-colorway-label-default = Standard
mr2022-onboarding-colorway-tooltip-default =
    .title = Standard
mr2022-onboarding-colorway-description-default = <b>Använd mina nuvarande { -brand-short-name } färger.</b>
mr2022-onboarding-colorway-label-playmaker = Spelare
mr2022-onboarding-colorway-tooltip-playmaker =
    .title = Spelare
mr2022-onboarding-colorway-description-playmaker = <b>Du är en spelare.</b> Du skapar möjligheter att vinna och hjälper alla runt omkring dig att lyfta sitt spel.
mr2022-onboarding-colorway-label-expressionist = Expressionist
mr2022-onboarding-colorway-tooltip-expressionist =
    .title = Expressionist
mr2022-onboarding-colorway-description-expressionist = <b>Du är en expressionist.</b> Du ser världen annorlunda och dina skapelser rör upp andras känslor.
mr2022-onboarding-colorway-label-visionary = Visionär
mr2022-onboarding-colorway-tooltip-visionary =
    .title = Visionär
mr2022-onboarding-colorway-description-visionary = <b>Du är en visionär.</b> Du ifrågasätter status quo och får andra att föreställa sig en bättre framtid.
mr2022-onboarding-colorway-label-activist = Aktivist
mr2022-onboarding-colorway-tooltip-activist =
    .title = Aktivist
mr2022-onboarding-colorway-description-activist = <b>Du är en aktivist.</b> Du lämnar världen till en bättre plats än du hittade den och får andra att tro.
mr2022-onboarding-colorway-label-dreamer = Drömmare
mr2022-onboarding-colorway-tooltip-dreamer =
    .title = Drömmare
mr2022-onboarding-colorway-description-dreamer = <b>Du är en drömmare.</b> Du tror att förmögenhet gynnar de djärva och inspirerar andra att vara modiga.
mr2022-onboarding-colorway-label-innovator = Innovatör
mr2022-onboarding-colorway-tooltip-innovator =
    .title = Innovatör
mr2022-onboarding-colorway-description-innovator = <b>Du är en innovatör.</b> Du ser möjligheter överallt och påverkar livet för alla runt omkring dig.

## MR2022 Multistage Mobile Download screen strings

mr2022-onboarding-mobile-download-title = Byt från bärbar dator till telefon och tillbaka igen
mr2022-onboarding-mobile-download-subtitle = Hämta flikar från en annan enhet och fortsätt precis där du slutade. Synkronisera även dina bokmärken och lösenord var du än använder { -brand-product-name }.
mr2022-onboarding-mobile-download-cta-text = Skanna QR-koden för att hämta { -brand-product-name } för mobil eller <a data-l10n-name="download-label">skicka en nedladdningslänk till dig själv.</a>
mr2022-onboarding-no-mobile-download-cta-text = Skanna QR-koden för att skaffa { -brand-product-name } för mobil.

## MR2022 Upgrade Dialog screens
## Pin private window screen shown only for users who don't have Waterfox private pinned

mr2022-upgrade-onboarding-pin-private-window-header = Få privat surffrihet med ett klick
mr2022-upgrade-onboarding-pin-private-window-subtitle = Inga sparade kakor eller historik, direkt från ditt skrivbord. Surfa som om ingen tittar.
mr2022-upgrade-onboarding-pin-private-window-primary-button-label =
    { PLATFORM() ->
        [macos] Behåll { -brand-short-name } privat surfning i Dock
       *[other] Fäst { -brand-short-name } privat surfning i aktivitetsfältet
    }

## MR2022 Privacy Segmentation screen strings

mr2022-onboarding-privacy-segmentation-title = Vi respekterar alltid din integritet
mr2022-onboarding-privacy-segmentation-subtitle = Från intelligenta förslag till smartare sökningar, vi arbetar ständigt med att skapa ett bättre och mer personligt { -brand-product-name }.
mr2022-onboarding-privacy-segmentation-text-cta = Vad vill du se när vi erbjuder nya funktioner som använder din data för att förbättra din surfning?
mr2022-onboarding-privacy-segmentation-button-primary-label = Använd rekommendationer från { -brand-product-name }
mr2022-onboarding-privacy-segmentation-button-secondary-label = Visa detaljerad information

## MR2022 Multistage Gratitude screen strings

mr2022-onboarding-gratitude-title = Du hjälper oss att bygga en bättre webb.
mr2022-onboarding-gratitude-subtitle = Tack för att du använder { -brand-short-name }, med stöd av Waterfox Limited. Med ditt stöd arbetar vi för att göra internet mer öppet, tillgängligt och bättre för alla.
mr2022-onboarding-gratitude-primary-button-label = Se vad som är nytt
mr2022-onboarding-gratitude-secondary-button-label = Börja surfa
