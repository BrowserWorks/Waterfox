# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Sužinoti daugiau
onboarding-button-label-get-started = Pradėti

## Welcome modal dialog strings


### UI strings for the simplified onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Sveiki, čia „{ -brand-short-name }“
onboarding-welcome-body = Naršyklę jau turite.<br/>Dabar susipažinkite su likusia „{ -brand-product-name }“ šeima.
onboarding-welcome-learn-more = Sužinokite apie privalumus daugiau.
onboarding-welcome-modal-get-body = Naršyklę jau turite.<br/>Dabar išnaudokite visas „{ -brand-product-name }“ galimybes.
onboarding-welcome-modal-supercharge-body = Pagerinkite savo privatumo apsaugą.
onboarding-welcome-modal-privacy-body = Naršyklę jau turite. Pridėkime daugiau privatumo apsaugos.
onboarding-welcome-modal-family-learn-more = Susipažinkite su „{ -brand-product-name }“ produktų grupe.
onboarding-welcome-form-header = Pradėkite čia
onboarding-join-form-body = Įveskite savo el. pašto adresą.
onboarding-join-form-email =
    .placeholder = Įveskite el. paštą
onboarding-join-form-email-error = Reikalingas teisingas el. paštas
onboarding-join-form-legal = Tęsdami, išreiškiate sutikimą su <a data-l10n-name="terms">Paslaugos teikimo nuostatais</a> ir <a data-l10n-name="privacy">Privatumo pranešimu</a>.
onboarding-join-form-continue = Tęsti
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Jau turite paskyrą?
# Text for link to submit the sign in form
onboarding-join-form-signin = Prisijungti
onboarding-start-browsing-button-label = Pradėti naršymą
onboarding-cards-dismiss =
    .title = Paslėpti
    .aria-label = Paslėpti

## Welcome full page string

onboarding-fullpage-welcome-subheader = Susipažinkite su viskuo, ką galite atlikti.
onboarding-fullpage-form-email =
    .placeholder = Jūsų el. pašto adresas…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Pasiimkite „{ -brand-product-name }“ su savimi
onboarding-sync-welcome-content = Turėkite savo adresyną, žurnalą, slaptažodžius ir kitas nuostatas visuose savo įrenginiuose.
onboarding-sync-welcome-learn-more-link = Sužinokite apie „Firefox“ paskyras daugiau
onboarding-sync-form-input =
    .placeholder = El. paštas
onboarding-sync-form-continue-button = Tęsti
onboarding-sync-form-skip-login-button = Praleisti šį žingsnį

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Įveskite savo el. paštą
onboarding-sync-form-sub-header = norėdami tęsti su „{ -sync-brand-name }“.

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Atlikite darbus su įrankių šeima, kuri gerbia jūsų privatumą visuose jūsų įrenginiuose.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Viskas, ką darome, atitinka mūsų Asmeninių duomenų pažadą: imti mažiau. Laikyti saugiai. Jokių paslapčių.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Turėkite savo adresyną, slaptažodžius, žurnalą ir kitką visur, kur naudojate „{ -brand-product-name }“.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Gaukite pranešimą, kai jūsų asmeniniai duomenys pateks tarp nutekėjusių duomenų.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Tvarkykite saugius ir patogiai pasiekiamus slaptažodžius.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Apsauga nuo stebėjimo
onboarding-tracking-protection-text2 = „{ -brand-short-name }“ padeda sustabdyti svetaines nuo jūsų stebėjimo internete, taip apsunkinant jus sekančių reklamų veikimą naršant.
onboarding-tracking-protection-button2 = Kaip tai veikia
onboarding-data-sync-title = Pasiimkite savo nuostatas kartu
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Sinchronizuokite adresyną, slaptažodžius ir daugiau visur, kur naudojate „{ -brand-product-name }“.
onboarding-data-sync-button2 = Prisijungti prie „{ -sync-brand-short-name }“
onboarding-firefox-monitor-title = Būkite įspėti apie duomenų pažeidimus
onboarding-firefox-monitor-text2 = „{ -monitor-brand-name }“ stebi, ar jūsų el. paštas pasirodo tarp žinomų nutekėjusių duomenų ir apie tai jums praneša.
onboarding-firefox-monitor-button = Gauti pranešimus
onboarding-browse-privately-title = Naršykite privačiai
onboarding-browse-privately-text = Privatuiss naršymas išvalo jūsų paieškos ir naršymo žurnalą, kad jis nebūti matomas kitiems, besinaudojantiems šiuo kompiuteriu.
onboarding-browse-privately-button = Atverti privatųjį langą
onboarding-firefox-send-title = Išlaikykite pasidalintų failų privatumą
onboarding-firefox-send-text2 = Įkelkite savo failus į „{ -send-brand-name }“, norėdami jais pasidalinti užšifruojant ir suteikiant automatiškai susinaikinantį saitą.
onboarding-firefox-send-button = Išbandykite „{ -send-brand-name }“
onboarding-mobile-phone-title = Gaukite „{ -brand-product-name }“ savo telefonui
onboarding-mobile-phone-text = Parsisiųskite „{ -brand-product-name }“ savo „iOS“ arba „Android“ įrenginiui ir sinchronizuokite duomenis.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Parsiųsti mobiliąją naršyklę
onboarding-send-tabs-title = Siųskite sau korteles akimirksniu
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Paprastai dalinkitės tinklalapiais tarp savo įrenginių, taip išvengdami kopijavimo, ar išėjimo iš naršyklės.
onboarding-send-tabs-button = Pradėti naudotis kortelių persiuntimu
onboarding-pocket-anywhere-title = Skaityti ir klausyti bet kur
onboarding-pocket-anywhere-text2 = Įrašykite savo mėgstamiausią interneto turinį įrenginyje, naudodamiesi „{ -pocket-brand-name }“ programa. Vėliau galėsite skaityti, klausyti, ar žiūrėti jums patogiu metu.
onboarding-pocket-anywhere-button = Išbandyti „{ -pocket-brand-name }“
onboarding-lockwise-strong-passwords-title = Susikurkite ir saugokite stiprius slaptažodžius
onboarding-lockwise-strong-passwords-text = „{ -lockwise-brand-name }“ sukuria stiprius slaptažodžius ir saugo juos visus vienoje vietoje.
onboarding-lockwise-strong-passwords-button = Tvarkykite savo prisijungimus
onboarding-facebook-container-title = Nustatykite „Facebook“ ribas
onboarding-facebook-container-text2 = „{ -facebook-container-brand-name }“ laiko jūsų „Facebook“ tapatybę atskirtą nuo viso kito, taip apsunkinant jų galimybę jums pritaikyti reklamas.
onboarding-facebook-container-button = Pridėti priedą
onboarding-import-browser-settings-title = Importuokite savo adresyną, slaptažodžius, ir dar daugiau
onboarding-import-browser-settings-text = Nerkite pirmyn – lengvai perkelkite savo svetaines ir nuostatas iš „Chrome“.
onboarding-import-browser-settings-button = Importuoti duomenis iš „Chrome“
onboarding-personal-data-promise-title = Privatumas – numatytas
onboarding-personal-data-promise-text = „{ -brand-product-name }“ gerbia jūsų duomenis. Jų renkama mažiau, jie apsaugomi, ir aiškiai nurodoma, kam jie naudojami.
onboarding-personal-data-promise-button = Perskaitykite mūsų pažadą

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Puiku, jūs turite „{ -brand-short-name }“
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Dabar įdiekime jums <icon></icon><b>„{ $addon-name }“</b>.
return-to-amo-extension-button = Įtraukti priedą
return-to-amo-get-started-button = Pradėkite su „{ -brand-short-name }“
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
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = „Firefox Alpenglow“

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

# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Firefox, how they use
# Firefox to pursue those passions, as well as the boldness in their
# choice to use Firefox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text = Tai prasideda čia
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio – baldų dizainerė, „Firefox“ gerbėja
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Išjungti animacijas

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Firefox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] Laikykite „{ -brand-short-name }“ savo užduočių juostoje sparčiam pasiekimui
       *[other] Įsekite „{ -brand-short-name }“ į savo užduočių juostą sparčiam pasiekimui
    }
# Primary button string used on welcome page when Firefox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Laikyti užduočių juostoje
       *[other] Įsegti į užduočių juostą
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Firefox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Pradėti
mr1-onboarding-welcome-header = Sveiki, čia „{ -brand-short-name }“
mr1-onboarding-set-default-pin-primary-button-label = Paskirti „{ -brand-short-name }“ mano pagrindine naršykle
    .title = Padaro „{ -brand-short-name }“ numatytąja naršykle ir prisega į užduočių juostą
# This string will be used on welcome page primary button label
# when Firefox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = Paskirti „{ -brand-short-name }“ mano pagrindine naršykle
mr1-onboarding-set-default-secondary-button-label = Ne dabar
mr1-onboarding-sign-in-button-label = Prisijungti

## Title, subtitle and primary button string used on set default onboarding screen
## when Firefox is not default browser

mr1-onboarding-default-header = Paskirti „{ -brand-short-name }“ jūsų pagrindine
mr1-onboarding-default-subtitle = Įjunkite autopilotą greičiui, saugumui, ir privatumui.
mr1-onboarding-default-primary-button-label = Skirti numatytąja naršykle

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = Pasiimkite visa tai su savimi
mr1-onboarding-import-subtitle = Importuokite savo slaptažodžius, <br/>adresyną, ir dar daugiau.
# The primary import button label will depend on whether we can detect which browser was used to download Firefox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Importuoti iš „{ $previous }“
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = Importuoti iš ankstesnės naršyklės
mr1-onboarding-import-secondary-button-label = Ne dabar
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
