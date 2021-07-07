# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Sveiki, čia „{ -brand-short-name }“
onboarding-start-browsing-button-label = Pradėti naršymą
onboarding-not-now-button-label = Ne dabar

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Puiku, jūs turite „{ -brand-short-name }“
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Dabar įdiekime jums <img data-l10n-name="icon"/> <b>„{ $addon-name }“</b>.
return-to-amo-add-extension-label = Įdiegti priedą

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Sveiki, čia <span data-l10n-name="zap">„{ -brand-short-name }“</span>
onboarding-multistage-welcome-subtitle = Sparti, saugi, ir privati naršyklė, kurią palaiko ne pelno siekianti įmonė.
onboarding-multistage-welcome-primary-button-label = Pradėti sąranką
onboarding-multistage-welcome-secondary-button-label = Prisijunkite
onboarding-multistage-welcome-secondary-button-text = Turite paskyrą?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "default" should stay inside the span.
onboarding-multistage-set-default-header = Padarykite „{ -brand-short-name }“ jūsų <span data-l10n-name="zap">numatytąja</span>
onboarding-multistage-set-default-subtitle = Greitis, saugumas, ir privatumas kiekvieno naršymo metu.
onboarding-multistage-set-default-primary-button-label = Padaryti numatytąja
onboarding-multistage-set-default-secondary-button-label = Ne dabar
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-pin-default-header = Pradžiai padarykite <span data-l10n-name="zap">„{ -brand-short-name }“</span> pasiekiamą vienu paspaudimu
onboarding-multistage-pin-default-subtitle = Spartus, saugus, ir privatus naršymas kiekvieną kartą.
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-waiting-subtitle = Atsivėrus nustatymams, pasirinkite „{ -brand-short-name }“ ties naršykle (angl. „Web browser“)
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-help-text = Tai padarius, „{ -brand-short-name }“ bus įsegta į užduočių juostą, ir bus atverti nustatymai
onboarding-multistage-pin-default-primary-button-label = Paskirti „{ -brand-short-name }“ mano pagrindine naršykle
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Importuokite savo slaptažodžius, <br/>adresyną, ir <span data-l10n-name="zap">daugiau</span>
onboarding-multistage-import-subtitle = Pereinate iš kitos naršyklės? Labai paprasta viską perkelti į „{ -brand-short-name }“.
onboarding-multistage-import-primary-button-label = Pradėti importavimą
onboarding-multistage-import-secondary-button-label = Ne dabar
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = Čia išvardintos svetainės buvo rastos šiame įrenginyje. „{ -brand-short-name }“ nesaugo ir nesinchronizuoja duomenų iš kitų naršyklių, nebent juos importuojate.

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Pradžia: žingsnis { $current } iš { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Pasirinkite <span data-l10n-name="zap">išvaizdą</span>
onboarding-multistage-theme-subtitle = Individualizuokite „{ -brand-short-name }“ su grafiniu apvalkalu.
onboarding-multistage-theme-primary-button-label2 = Gerai
onboarding-multistage-theme-secondary-button-label = Ne dabar
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Automatinis
onboarding-multistage-theme-label-light = Šviesus
onboarding-multistage-theme-label-dark = Tamsus
# "Waterfox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = „Waterfox Alpenglow“
# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Waterfox, how they use
# Waterfox to pursue those passions, as well as the boldness in their
# choice to use Waterfox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text = Tai prasideda čia
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio – baldų dizainerė, „Waterfox“ gerbėja
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Išjungti animacijas

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Waterfox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] Laikykite „{ -brand-short-name }“ savo užduočių juostoje sparčiam pasiekimui
       *[other] Įsekite „{ -brand-short-name }“ į savo užduočių juostą sparčiam pasiekimui
    }
# Primary button string used on welcome page when Waterfox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Laikyti užduočių juostoje
       *[other] Įsegti į užduočių juostą
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Pradėti
mr1-onboarding-welcome-header = Sveiki, čia „{ -brand-short-name }“
mr1-onboarding-set-default-pin-primary-button-label = Paskirti „{ -brand-short-name }“ mano pagrindine naršykle
    .title = Padaro „{ -brand-short-name }“ numatytąja naršykle ir prisega į užduočių juostą
# This string will be used on welcome page primary button label
# when Waterfox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = Paskirti „{ -brand-short-name }“ mano pagrindine naršykle
mr1-onboarding-set-default-secondary-button-label = Ne dabar
mr1-onboarding-sign-in-button-label = Prisijungti

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

mr1-onboarding-default-header = Paskirti „{ -brand-short-name }“ jūsų pagrindine
mr1-onboarding-default-subtitle = Įjunkite autopilotą greičiui, saugumui, ir privatumui.
mr1-onboarding-default-primary-button-label = Skirti numatytąja naršykle

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = Pasiimkite visa tai su savimi
mr1-onboarding-import-subtitle = Importuokite savo slaptažodžius, <br/>adresyną, ir dar daugiau.
# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Importuoti iš „{ $previous }“
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = Importuoti iš ankstesnės naršyklės
mr1-onboarding-import-secondary-button-label = Ne dabar
mr2-onboarding-colorway-header = Spalvotas gyvenimas
mr2-onboarding-colorway-subtitle = Ryškūs spalvų rinkiniai. Pasiekiami ribotą laiką.
mr2-onboarding-colorway-primary-button-label = Įrašyti spalvų rinkinį
mr2-onboarding-colorway-secondary-button-label = Ne dabar
mr2-onboarding-colorway-label-soft = Švelnus
mr2-onboarding-colorway-label-balanced = Subalansuotas
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
mr2-onboarding-colorway-label-bold = Ryškus
# Automatic theme uses operating system color settings
mr2-onboarding-theme-label-auto = Automatinis
# This string will be used for Default theme
mr2-onboarding-theme-label-default = Numatytasis
mr1-onboarding-theme-header = Pritaikykite sau
mr1-onboarding-theme-subtitle = Individualizuokite „{ -brand-short-name }“ su grafiniu apvalkalu.
mr1-onboarding-theme-primary-button-label = Įrašyti grafinį apvalkalą
mr1-onboarding-theme-secondary-button-label = Ne dabar
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = Sistemos grafinis apvalkalas
mr1-onboarding-theme-label-light = Šviesus
mr1-onboarding-theme-label-dark = Tamsus
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.


## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title =
        Paveldėti jūsų operacinės sistemos spalvas
        mygtukams, meniu elementams, ir langams.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        Paveldėti jūsų operacinės sistemos spalvas
        mygtukams, meniu elementams, ir langams.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        Naudoti šviesias spalvas mygtukams,
        meniu elementams, ir langams.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        Naudoti šviesias spalvas mygtukams,
        meniu elementams, ir langams.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        Naudoti tamsias spalvas mygtukams,
        meniu elementams, ir langams.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        Naudoti tamsias spalvas mygtukams,
        meniu elementams, ir langams.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        Naudoti įvairiaspalvę išvaizdą mygtukams,
        meniu elementams, ir langams.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        Naudoti įvairiaspalvę išvaizdą mygtukams,
        meniu elementams, ir langams.

## Multistage MR1 onboarding strings (MR1 about:welcome pages)

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title =
        Atsižvelgti į operacinės sistemos grafinį
        apvalkalą mygtukams, meniu, ir langams.
# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        Atsižvelgti į operacinės sistemos grafinį
        apvalkalą mygtukams, meniu, ir langams.
# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title =
        Naudoti šviesų grafinį apvalkalą
        mygtukams, meniu, ir langams.
# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description =
        Naudoti šviesų grafinį apvalkalą
        mygtukams, meniu, ir langams.
# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title =
        Naudoti tamsų grafinį apvalkalą
        mygtukams, meniu, ir langams.
# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description =
        Naudoti tamsų grafinį apvalkalą
        mygtukams, meniu, ir langams.
# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title =
        Naudoti dinamišką, spalvingą grafinį apvalkalą
        mygtukams, meniu, ir langams.
# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description =
        Naudoti dinamišką, spalvingą grafinį apvalkalą
        mygtukams, meniu, ir langams.
# Tooltip displayed on hover of non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-tooltip =
    .title = Naudoti šį spalvų rinkinį.
# Selector description for non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-description =
    .aria-description = Naudoti šį spalvų rinkinį.
# Tooltip displayed on hover of colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-tooltip =
    .title = Atraskite „{ $colorwayName }“ spalvų rinkinius.
# Selector description for colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-description =
    .aria-description = Atraskite „{ $colorwayName }“ spalvų rinkinius.
# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = Atraskite numatytuosius grafinius apvalkalus.
# Selector description for default themes
mr2-onboarding-default-theme-description =
    .aria-description = Atraskite numatytuosius grafinius apvalkalus.

## Strings for Thank You page

mr2-onboarding-thank-you-header = Ačiū, kad pasirinkote mus
mr2-onboarding-thank-you-text = „{ -brand-short-name }“ yra nepriklausoma naršyklė, remiama ne pelno siekiančios organizacijos. Kartu mes kuriame saugesnį, sveikesnį, privatesnį internetą.
mr2-onboarding-start-browsing-button-label = Pradėti naršymą
