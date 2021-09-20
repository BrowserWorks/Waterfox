# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Zjistit více
onboarding-button-label-get-started = Začínáme

## Welcome modal dialog strings


### UI strings for the simplified onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Vítá vás { -brand-short-name }
onboarding-welcome-body =
    Prohlížeč teď už máte.<br/>Poznejte ještě zbytek { -brand-product-name.gender ->
        [masculine] { -brand-product-name(case: "gen") }
        [feminine] { -brand-product-name(case: "gen") }
        [neuter] { -brand-product-name(case: "gen") }
       *[other] aplikace { -brand-product-name }
    }.
onboarding-welcome-learn-more = Další výhody.
onboarding-welcome-modal-get-body =
    Prohlížeč teď už máte.<br/>Využijte { -brand-product-name.gender ->
        [masculine] { -brand-product-name(case: "acc") }
        [feminine] { -brand-product-name(case: "acc") }
        [neuter] { -brand-product-name(case: "acc") }
       *[other] aplikaci { -brand-product-name }
    } naplno.
onboarding-welcome-modal-supercharge-body = Dopřejte si silnou ochranu soukromí.
onboarding-welcome-modal-privacy-body = Prohlížeč už teď máte. Přidejme k němu ještě trochu ochrany soukromí.
onboarding-welcome-modal-family-learn-more = Zjistěte více o celé rodině produktů { -brand-product-name }.
onboarding-welcome-form-header = Začněme
onboarding-join-form-body = Zde zadejte svou e-mailovou adresu.
onboarding-join-form-email =
    .placeholder = Zadejte e-mail
onboarding-join-form-email-error = Je požadován platný e-mail
onboarding-join-form-legal = Pokračováním souhlasíte s <a data-l10n-name="terms">podmínkami poskytování služby</a> a <a data-l10n-name="privacy">zásadami ochrany osobních údajů</a>.
onboarding-join-form-continue = Pokračovat
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Už máte účet?
# Text for link to submit the sign in form
onboarding-join-form-signin = Přihlásit se
onboarding-start-browsing-button-label = Začít prohlížet
onboarding-cards-dismiss =
    .title = Skrýt
    .aria-label = Skrýt

## Welcome full page string

onboarding-fullpage-welcome-subheader = Teď vám ukážeme, jaké máte možnosti.
onboarding-fullpage-form-email =
    .placeholder = Vaše e-mailová adresa…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header =
    Vezměte si { -brand-product-name.gender ->
        [masculine] { -brand-product-name(case: "acc") }
        [feminine] { -brand-product-name(case: "acc") }
        [neuter] { -brand-product-name(case: "acc") }
       *[other] aplikaci { -brand-product-name }
    } s sebou
onboarding-sync-welcome-content = Mějte své záložky, historii i uložená hesla s sebou na všech svých zařízeních.
onboarding-sync-welcome-learn-more-link = Zjistit více o účtech Firefoxu
onboarding-sync-form-input =
    .placeholder = E-mail
onboarding-sync-form-continue-button = Pokračovat
onboarding-sync-form-skip-login-button = Přeskočit tento krok

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Zadejte svoji e-mailovou adresu
onboarding-sync-form-sub-header = a používejte { -sync-brand-name(case: "acc") }.

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Používejte nástroje, které respektují vaše soukromí a fungují na všech zařízeních.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Slibujeme, že nezneužijeme vaše data. Méně dat je vždy více, udržíme je v bezpečí a nemáme před vámi žádná tajemství.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text =
    Vezměte si své záložky, hesla, historii a další data všude tam, kde používáte { -brand-product-name.gender ->
        [masculine] { -brand-product-name(case: "acc") }
        [feminine] { -brand-product-name(case: "acc") }
        [neuter] { -brand-product-name(case: "acc") }
       *[other] aplikaci { -brand-product-name }
    }.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Nechte se upozornit, pokud se vaše údaje objeví ve známém úniku dat.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Spravujte hesla bezpečně i na cestách.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Ochrana před sledováním
onboarding-tracking-protection-text2 = { -brand-short-name } vám pomůže zastavit sledování webovými stránkami a znesnadní reklamám, aby vás následovaly na další weby.
onboarding-tracking-protection-button2 = Jak to funguje
onboarding-data-sync-title = Mějte svá nastavení všude s sebou
# "Sync" is short for synchronize.
onboarding-data-sync-text2 =
    Synchronizujte své záložky, hesla a další data všude, kde používáte { -brand-product-name.gender ->
        [masculine] { -brand-product-name(case: "acc") }
        [feminine] { -brand-product-name(case: "acc") }
        [neuter] { -brand-product-name(case: "acc") }
       *[other] aplikaci { -brand-product-name }
    }.
onboarding-data-sync-button2 = Přihlásit k { -sync-brand-short-name(case: "dat") }
onboarding-firefox-monitor-title = Buďte informování o únicích dat
onboarding-firefox-monitor-text2 = { -monitor-brand-name } hlídá, jestli vaše e-mailová adresa nebyla součástí nějakého známého úniku dat, a dá vám vědět, pokud ji v nějakém najde.
onboarding-firefox-monitor-button = Nechte si posílat upozornění
onboarding-browse-privately-title = Prohlížejte v soukromí
onboarding-browse-privately-text = Funkce anonymního prohlížení smaže vaši historii vyhledávání a prohlížení a uchová vaše tajemství před ostatními uživateli vašeho počítače.
onboarding-browse-privately-button = Otevřít anonymní okno
onboarding-firefox-send-title = Sdílejte své soubory soukromě a bezpečně
onboarding-firefox-send-text2 = Sdílejte své soubory s { -send-brand-name(case: "ins") }, která je chrání pomocí end-to-end šifrování a odkazů s omezenou platností.
onboarding-firefox-send-button = Vyzkoušet { -send-brand-name(case: "acc") }
onboarding-mobile-phone-title =
    Nainstalujte si { -brand-product-name.gender ->
        [masculine] { -brand-product-name(case: "acc") }
        [feminine] { -brand-product-name(case: "acc") }
        [neuter] { -brand-product-name(case: "acc") }
       *[other] aplikaci { -brand-product-name }
    } do telefonu
onboarding-mobile-phone-text =
    Stáhněte si { -brand-product-name.gender ->
        [masculine] { -brand-product-name(case: "acc") }
        [feminine] { -brand-product-name(case: "acc") }
        [neuter] { -brand-product-name(case: "acc") }
       *[other] aplikaci { -brand-product-name }
    } do telefonu pro iOS nebo Android a synchronizujte svá data mezi zařízeními.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Stáhnout mobilní prohlížeč
onboarding-send-tabs-title = Posílejte si panely mezi zařízeními
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Sdílejte a posílejte stránky mezi svými zařízeními. Nemusíte kopírovat žádné odkazy ani opouštět prohlížeč.
onboarding-send-tabs-button = Začít posílat panely
onboarding-pocket-anywhere-title = Čtěte a nechte si číst
onboarding-pocket-anywhere-text2 = Uložte si svůj oblíbený obsah offline s { -pocket-brand-name(case: "ins") } pro přečtení nebo poslech ve chvíli, kdy se vám to opravdu hodí.
onboarding-pocket-anywhere-button = Vyzkoušet { -pocket-brand-name(case: "acc") }
onboarding-lockwise-strong-passwords-title = Vytváření silných hesel
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } vám na místě vygeneruje silná hesla a uloží je bezpečně na jednom místě.
onboarding-lockwise-strong-passwords-button = Správa přihlašovacích údajů
onboarding-facebook-container-title = Nastavte hranice pro Facebook
onboarding-facebook-container-text2 = Doplněk { -facebook-container-brand-name } oddělí váš účet od zbytku internetu, takže pro Facebook a jeho reklamy nebude tak snadné vás na internetu vysledovat.
onboarding-facebook-container-button = Nainstalovat rozšíření
onboarding-import-browser-settings-title = Importujte své záložky, hesla a další data
onboarding-import-browser-settings-text = Pojďme na to — přenos oblíbených stránek a nastavení z Chromu je velmi jednoduchý.
onboarding-import-browser-settings-button = Import dat z prohlížeče Chrome
onboarding-personal-data-promise-title = Soukromí už v návrhu
onboarding-personal-data-promise-text = { -brand-product-name } chrání vaše soukromí, respektujte a chrání vaše data a jasně říká, jak je používáme.
onboarding-personal-data-promise-button = Přečtěte si náš slib

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Skvěle, nyní máte aplikaci { -brand-short-name }
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Teď zpět k doplňku <icon></icon><b>{ $addon-name }</b>.
return-to-amo-extension-button = Přidat rozšíření
return-to-amo-get-started-button =
    Jak začít s { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "ins") }
        [feminine] { -brand-short-name(case: "ins") }
        [neuter] { -brand-short-name(case: "ins") }
       *[other] aplikací { -brand-short-name }
    }
onboarding-not-now-button-label = Teď ne

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Skvěle, nyní máte aplikaci { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Teď zpět k doplňku <img data-l10n-name="icon"/> </icon><b>{ $addon-name }</b>.
return-to-amo-add-extension-label = Přidat rozšíření

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Vítá vás <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = Rychlý, bezpečný a soukromý prohlížeč od neziskové organizace.
onboarding-multistage-welcome-primary-button-label = Nastavit
onboarding-multistage-welcome-secondary-button-label = Přihlášení
onboarding-multistage-welcome-secondary-button-text = Už máte účet?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "default" should stay inside the span.
onboarding-multistage-set-default-header = Nastavte si { -brand-short-name(case: "acc") } jako <span data-l10n-name="zap">výchozí</span>
onboarding-multistage-set-default-subtitle = Rychlost, bezpečnost a soukromí pro vaše prohlížení.
onboarding-multistage-set-default-primary-button-label = Nastavit jako výchozí
onboarding-multistage-set-default-secondary-button-label = Teď ne
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-pin-default-header =
    { -brand-short-name.gender ->
        [masculine] <span data-l10n-name="zap">{ -brand-short-name(case: "acc") }</span>
        [feminine] <span data-l10n-name="zap">{ -brand-short-name(case: "acc") }</span>
        [neuter] <span data-l10n-name="zap">{ -brand-short-name(case: "acc") }</span>
       *[other] Aplikaci <span data-l10n-name="zap">{ -brand-short-name }</span>
    } můžete mít na klik myší
onboarding-multistage-pin-default-subtitle = Rychlé, bezpečné a soukromé prohlížení kdykoliv jste na webu.
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-waiting-subtitle =
    Po otevření systémového nastavení vyberte jako Webový prohlížeč { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    }
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-help-text =
    Tím si { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    } připnete na lištu a otevřete nastavení
onboarding-multistage-pin-default-primary-button-label =
    Nastavit { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    } jako můj hlavní prohlížeč
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Importujte svá hesla, <br/> záložky a <span data-l10n-name="zap">další data</span>
onboarding-multistage-import-subtitle =
    Přecházíte z jiného prohlížeče? Přenést data do { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    } je velmi snadné.
onboarding-multistage-import-primary-button-label = Spustit import
onboarding-multistage-import-secondary-button-label = Teď ne
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = Na tomto zařízení byly nalezeny následující stránky. { -brand-short-name } si neuloží a nebude synchronizovat dat uložená v jiném prohlížeči, dokud mu nepovolíte je importovat.
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label =
        Úvod: strana { $current } { NUMBER($totla) ->
            [one] z { $total }
            [few] ze { $total }
           *[other] z { $total }
        }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Vyberte si <span data-l10n-name="zap">vzhled</span>
onboarding-multistage-theme-subtitle =
    Přizpůsobte si vzhled { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    }
onboarding-multistage-theme-primary-button-label2 = Hotovo
onboarding-multistage-theme-secondary-button-label = Teď ne
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Automatický
onboarding-multistage-theme-label-light = Světlý
onboarding-multistage-theme-label-dark = Tmavý
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Waterfox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title = Použije vzhled tlačítek, nabídek a oken podle nastavení vašeho operačního systému.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description = Použije vzhled tlačítek, nabídek a oken podle nastavení vašeho operačního systému.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title = Použije světlý vzhled tlačítek, nabídek a oken.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description = Použije světlý vzhled tlačítek, nabídek a oken.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title = Použije tmavý vzhled tlačítek, nabídek a oken.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description = Použije tmavý vzhled tlačítek, nabídek a oken.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title = Použije barevný vzhled tlačítek, nabídek a oken.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description = Použije barevný vzhled tlačítek, nabídek a oken.

## Multistage MR1 onboarding strings (MR1 about:welcome pages)

# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Firefox, how they use
# Firefox to pursue those passions, as well as the boldness in their
# choice to use Firefox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text = Začínáme
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio — návrhářka nábytku a fanynka Firefoxu
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Vypnout animace

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Firefox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos]
            { -brand-short-name.gender ->
                [masculine] Mějte { -brand-short-name(case: "acc") } na dosah připnutý ve svém docku.
                [feminine] Mějte { -brand-short-name(case: "acc") } na dosah připnutou ve svém docku.
                [neuter] Mějte { -brand-short-name(case: "acc") } na dosah připnuté ve svém docku.
               *[other] Mějte aplikaci { -brand-short-name } na dosah připnutou ve svém docku.
            }
       *[other]
            { -brand-short-name.gender ->
                [masculine] Mějte { -brand-short-name(case: "acc") } na dosah připnutý na své liště.
                [feminine] Mějte { -brand-short-name(case: "acc") } na dosah připnutou na své liště.
                [neuter] Mějte { -brand-short-name(case: "acc") } na dosah připnuté na své liště.
               *[other] Mějte aplikaci { -brand-short-name } na dosah připnutou na své liště.
            }
    }
# Primary button string used on welcome page when Firefox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Připnout do docku
       *[other] Připnout na lištu
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Firefox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Jdeme na to
mr1-onboarding-welcome-header = Vítá vás { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label =
    Nastavit { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    } jako můj hlavní prohlížeč
    .title =
        Nastaví { -brand-short-name.gender ->
            [masculine] { -brand-short-name(case: "acc") }
            [feminine] { -brand-short-name(case: "acc") }
            [neuter] { -brand-short-name(case: "acc") }
           *[other] aplikaci { -brand-short-name }
        } jako výchozí prohlížeč a připne { -brand-short-name.gender ->
            [masculine] ho
            [feminine] ji
            [neuter] ho
           *[other] ji
        } na lištu
# This string will be used on welcome page primary button label
# when Firefox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label =
    Nastavit { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    } jako můj výchozí prohlížeč
mr1-onboarding-set-default-secondary-button-label = Teď ne
mr1-onboarding-sign-in-button-label = Přihlásit se

## Title, subtitle and primary button string used on set default onboarding screen
## when Firefox is not default browser

mr1-onboarding-default-header =
    Nastavit { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    } jako výchozí prohlížeč
mr1-onboarding-default-subtitle = Rychlost, bezpečnost a soukromí především.
mr1-onboarding-default-primary-button-label = Nastavit jako výchozí prohlížeč

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = Všechno, vždy a po ruce
mr1-onboarding-import-subtitle = Importujte svá hesla, <br/>záložky a další
# The primary import button label will depend on whether we can detect which browser was used to download Firefox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Importovat z prohlížeče { $previous }
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = Importovat z dříve používaného prohlížeče
mr1-onboarding-import-secondary-button-label = Teď ne
mr1-onboarding-theme-header = Přizpůsobení
mr1-onboarding-theme-subtitle =
    Přizpůsobte si vzhled { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    }
mr1-onboarding-theme-primary-button-label = Uložit vzhled
mr1-onboarding-theme-secondary-button-label = Teď ne
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = Podle systému
mr1-onboarding-theme-label-light = Světlý
mr1-onboarding-theme-label-dark = Tmavý
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title =
        Vzhled s barevným tématem
        podle nastavení operačního systému.
# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        Vzhled s barevným tématem
        podle nastavení operačního systému.
# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title =
        Vzhled se světlým barevným tématem
        pro tlačítka, nabídky a okna.
# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description =
        Vzhled se světlým barevným tématem
        pro tlačítka, nabídky a okna.
# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title =
        Vzhled s tmavým barevným tématem
        pro tlačítka, nabídky a okna.
# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description =
        Vzhled s tmavým barevným tématem
        pro tlačítka, nabídky a okna.
# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title =
        Vzhled s barevným tématem
        pro tlačítka, nabídky a okna.
# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description =
        Vzhled s barevným tématem
        pro tlačítka, nabídky a okna.
