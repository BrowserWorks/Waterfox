# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Več o tem
onboarding-button-label-get-started = Začni

## Welcome modal dialog strings

onboarding-welcome-header = Dobrodošli v { -brand-short-name }
onboarding-welcome-body = Brskalnik že imate.<br/>Spoznajte še ostale storitve { -brand-product-name }.
onboarding-welcome-learn-more = Spoznajte prednosti.
onboarding-welcome-modal-get-body = Brskalnik že imate.<br/>Zdaj pa kar najbolje izkoristite { -brand-product-name }.
onboarding-welcome-modal-supercharge-body = Dvignite svojo zaščito zasebnosti.
onboarding-welcome-modal-privacy-body = Brskalnik že imate. Dodajmo še zaščito zasebnosti.
onboarding-welcome-modal-family-learn-more = Spoznajte družino izdelkov { -brand-product-name }.
onboarding-welcome-form-header = Začnite tukaj
onboarding-join-form-body = Za začetek vnesite e-poštni naslov.
onboarding-join-form-email =
    .placeholder = Vnesite e-poštni naslov
onboarding-join-form-email-error = Vnesite veljaven e-poštni naslov
onboarding-join-form-legal = Z nadaljevanjem se strinjate s <a data-l10n-name="terms">pogoji uporabe</a> in z <a data-l10n-name="privacy">obvestilom o zasebnosti</a>.
onboarding-join-form-continue = Nadaljuj
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Že imate račun?
# Text for link to submit the sign in form
onboarding-join-form-signin = Prijavite se
onboarding-start-browsing-button-label = Začnite z brskanjem
onboarding-cards-dismiss =
    .title = Opusti
    .aria-label = Opusti

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Dobrodošli v <span data-l10n-name="zap">{ -brand-short-name }u</span>
onboarding-multistage-welcome-subtitle = Hiter, varen in zaseben brskalnik, ki ga podpira neprofitna organizacija.
onboarding-multistage-welcome-primary-button-label = Začni nastavitev
onboarding-multistage-welcome-secondary-button-label = Prijava
onboarding-multistage-welcome-secondary-button-text = Imate račun?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Uvozite svoja gesla, zaznamke in <span data-l10n-name="zap">drugo</span>
onboarding-multistage-import-subtitle = Prihajate iz drugega brskalnika? Z lahkoto lahko vse prenesete v { -brand-short-name }.
onboarding-multistage-import-primary-button-label = Začni uvoz
onboarding-multistage-import-secondary-button-label = Ne zdaj
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = Ta spletna mesta so bila najdena na tej napravi. { -brand-short-name } ne shranjuje ali sinhronizira podatkov iz drugih brskalnikov, razen če se odločite, da jih uvozite.
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Prvi koraki: zaslon { $current } od { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Izberite <span data-l10n-name="zap">videz</span>
onboarding-multistage-theme-subtitle = Prilagodite svoj { -brand-short-name } s temo.
onboarding-multistage-theme-primary-button-label = Shrani temo
onboarding-multistage-theme-secondary-button-label = Ne zdaj
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Samodejno
# System refers to the operating system
onboarding-multistage-theme-description-automatic = Uporabi sistemsko temo
onboarding-multistage-theme-label-light = Svetla
onboarding-multistage-theme-label-dark = Temna
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic =
    .title =
        Uporabi videz gumbov, menijev in oken
        operacijskega sistema.
    .aria-label = { onboarding-multistage-theme-tooltip-automatic.title }
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light =
    .title =
        Uporabi svetel videz gumbov,
        menijev in oken.
    .aria-label = { onboarding-multistage-theme-tooltip-light.title }
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark =
    .title =
        Uporabi temen videz gumbov,
        menijev in oken.
    .aria-label = { onboarding-multistage-theme-tooltip-dark.title }
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow =
    .title =
        Uporabi barvit videz gumbov,
        menijev in oken.
    .aria-label = { onboarding-multistage-theme-tooltip-alpenglow.title }
# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title =
        Uporabi videz gumbov, menijev in oken
        operacijskega sistema.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        Uporabi videz gumbov, menijev in oken
        operacijskega sistema.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        Uporabi svetel videz gumbov,
        menijev in oken.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        Uporabi svetel videz gumbov,
        menijev in oken.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        Uporabi temen videz gumbov,
        menijev in oken.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        Uporabi temen videz gumbov,
        menijev in oken.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        Uporabi barvit videz gumbov,
        menijev in oken.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        Uporabi barvit videz gumbov,
        menijev in oken.

## Welcome full page string

onboarding-fullpage-welcome-subheader = Začnimo z raziskovanjem vsega, kar lahko storite.
onboarding-fullpage-form-email =
    .placeholder = Vaš e-poštni naslov …

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Vzemite { -brand-product-name } s seboj
onboarding-sync-welcome-content = Imejte dostop do svojih zaznamkov, zgodovine, gesel in drugih podatkov z vseh svojih naprav.
onboarding-sync-welcome-learn-more-link = Več o Firefox Računih
onboarding-sync-form-input =
    .placeholder = E-pošta
onboarding-sync-form-continue-button = Nadaljuj
onboarding-sync-form-skip-login-button = Preskoči ta korak

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Vnesite e-poštni naslov
onboarding-sync-form-sub-header = za nadaljevanje v { -sync-brand-name }.

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Opravite stvari z družino orodij, ki spoštuje vašo zasebnost na vseh napravah.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Vse, kar počnemo, je v skladu z našo obljubo o osebnih podatkih: Vzemi manj. Ohrani varnost. Brez skrivnosti.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Vzemite zaznamke, gesla in druge podatke povsod, kjer uporabljate { -brand-product-name }.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Prejemajte obvestila, ko se vaši podatki pojavijo v znani kraji podatkov.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Upravljajte gesla, ki so zaščitena in prenosna.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Zaščita pred sledenjem
onboarding-tracking-protection-text2 = { -brand-short-name } spletnim mestom preprečuje, da bi vam sledila, tako da vas oglasi težje zasledujejo po spletu.
onboarding-tracking-protection-button2 = Kako deluje
onboarding-data-sync-title = Ponesite svoje nastavitve s seboj
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Sinhronizirajte zaznamke, gesla in druge podatke povsod, kjer uporabljate { -brand-product-name }.
onboarding-data-sync-button2 = Prijava v { -sync-brand-short-name }
onboarding-firefox-monitor-title = Bodite obveščeni o krajah podatkov
onboarding-firefox-monitor-text2 = { -monitor-brand-name } spremlja, ali se je vaš e-poštni naslov pojavil v znani kraji podatkov, in vas obvesti v primeru novih kraj podatkov.
onboarding-firefox-monitor-button = Prijavite se na opozorila
onboarding-browse-privately-title = Brskajte zasebno
onboarding-browse-privately-text = Zasebno brskanje izbriše zgodovino iskanja in brskanja, tako da ostaneta skriti vsem, ki uporabljajo vaš računalnik.
onboarding-browse-privately-button = Odpri zasebno okno
onboarding-firefox-send-title = Ohranite zasebnost datotek, ki jih delite
onboarding-firefox-send-text2 = Naložite datoteke v { -send-brand-name } in jih delite s šifrirano povezavo, ki samodejno poteče.
onboarding-firefox-send-button = Preizkusite { -send-brand-name }
onboarding-mobile-phone-title = Prenesite { -brand-product-name } na svoj telefon
onboarding-mobile-phone-text = Prenesite { -brand-product-name } za iOS ali Android in sinhronizirajte svoje podatke med napravami.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Prenesite mobilni brskalnik
onboarding-send-tabs-title = Takoj si pošljite zavihke
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Enostavno delite strani med napravami brez kopiranja povezav in zapuščanja brskalnika.
onboarding-send-tabs-button = Začnite pošiljati zavihke
onboarding-pocket-anywhere-title = Berite in poslušajte kjerkoli
onboarding-pocket-anywhere-text2 = Shranite si priljubljeno vsebino z aplikacijo { -pocket-brand-name } in jo preberite, poslušajte ali si jo oglejte, kadarkoli vam ustreza.
onboarding-pocket-anywhere-button = Preizkusite { -pocket-brand-name }
onboarding-lockwise-strong-passwords-title = Ustvarite in shranjujte močna gesla
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } ustvari močna gesla na kraju samem in jih shrani na eno mesto.
onboarding-lockwise-strong-passwords-button = Upravljanje prijav
onboarding-facebook-container-title = Postavite meje Facebooku
onboarding-facebook-container-text2 = { -facebook-container-brand-name } ohranja vaš profil ločen od vsega ostalega, kar Facebooku otežuje ciljno oglaševanje.
onboarding-facebook-container-button = Dodaj razširitev
onboarding-import-browser-settings-title = Uvozite svoje zaznamke, gesla in drugo
onboarding-import-browser-settings-text = Ne izgubljajte časa – prinesite strani in nastavitve iz Chroma s seboj.
onboarding-import-browser-settings-button = Uvozi podatke iz Chroma
onboarding-personal-data-promise-title = Zaseben po zasnovi
onboarding-personal-data-promise-text = { -brand-product-name } spoštuje vaše podatke, tako da zahteva samo najosnovnejše, jih ščiti in jasno določa, kako jih uporablja.
onboarding-personal-data-promise-button = Preberite našo obljubo

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Odlično, imate { -brand-short-name }
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Zdaj pa dodajte <icon></icon><b>{ $addon-name }.</b>
return-to-amo-extension-button = Dodaj razširitev
return-to-amo-get-started-button = Začnite s { -brand-short-name }om
