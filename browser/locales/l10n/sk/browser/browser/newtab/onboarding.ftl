# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Ďalšie informácie
onboarding-button-label-get-started = Začíname

## Welcome modal dialog strings


### UI strings for the simplified onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Víta vás { -brand-short-name }
onboarding-welcome-body = Prehliadač už máte.<br/>Spoznajte ešte zvyšok aplikácie { -brand-product-name }.
onboarding-welcome-learn-more = Ďalšie výhody.
onboarding-welcome-modal-get-body = Prehliadač už máte.<br/>Využite { -brand-product-name } naplno.
onboarding-welcome-modal-supercharge-body = Silná ochrana súkromia.
onboarding-welcome-modal-privacy-body = Prehliadač už máte. Pridajme k nemu ešte ochranu súkromia.
onboarding-welcome-modal-family-learn-more = Zistite viac o celej rodine produktov { -brand-product-name }.
onboarding-welcome-form-header = Začať
onboarding-join-form-body = Začnite uvedením svojej e-mailovej adresy.
onboarding-join-form-email =
    .placeholder = Zadajte e-mailovú adresu
onboarding-join-form-email-error = Vyžaduje sa platná e-mailová adresa
onboarding-join-form-legal = Pokračovaním vyjadrujete súhlas s <a data-l10n-name="terms">podmienkami používania služby</a> a so <a data-l10n-name="privacy">zásadami ochrany súkromia</a>.
onboarding-join-form-continue = Pokračovať
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Máte už účet?
# Text for link to submit the sign in form
onboarding-join-form-signin = Prihláste sa
onboarding-start-browsing-button-label = Začať prehliadať
onboarding-cards-dismiss =
    .title = Skryť
    .aria-label = Skryť

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Víta vás <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = Rýchly a bezpečný prehliadač, ktorý vyvíja nezisková organizácia.
onboarding-multistage-welcome-primary-button-label = Začať nastavenie
onboarding-multistage-welcome-secondary-button-label = Prihlásiť sa
onboarding-multistage-welcome-secondary-button-text = Už máte účet?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Importujte svoje heslá, záložky a <span data-l10n-name="zap">mnoho ďalšieho</span>
onboarding-multistage-import-subtitle = Prechádzate z iného prehliadača? Všetko si môžete jednoducho preniesť.
onboarding-multistage-import-primary-button-label = Importovať
onboarding-multistage-import-secondary-button-label = Teraz nie
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Začíname: stránka { $current } z { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Vyberte si <span data-l10n-name="zap">vzhľad</span>
onboarding-multistage-theme-subtitle = Prispôsobte si { -brand-short-name }.
onboarding-multistage-theme-primary-button-label = Uložiť vzhľad
onboarding-multistage-theme-secondary-button-label = Teraz nie
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Automatický
onboarding-multistage-theme-label-light = Svetlý
onboarding-multistage-theme-label-dark = Tmavý
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.


## Welcome full page string

onboarding-fullpage-welcome-subheader = Pozrite sa, čo všetko vám ponúkame.
onboarding-fullpage-form-email =
    .placeholder = Vaša e-mailová adresa…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Vezmite si { -brand-product-name } so sebou
onboarding-sync-welcome-content = Majte svoje záložky, históriu, heslá a ostatné nastavenia na všetkých vašich zariadeniach.
onboarding-sync-welcome-learn-more-link = Ďalšie informácie o účtoch Firefox
onboarding-sync-form-input =
    .placeholder = E-mail
onboarding-sync-form-continue-button = Pokračovať
onboarding-sync-form-skip-login-button = Preskočiť tento krok

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Zadajte e-mailovú adresu
onboarding-sync-form-sub-header = a používajte službu { -sync-brand-name }.

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Používajte nástroje, ktoré rešpektujú vaše súkromie a fungujú na všetkých zariadeniach.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Zaväzujeme sa, že nezneužijeme vaše údaje. Menej dát je niekedy viac. Udržiavame ich v bezpečí a nemáme pred vami žiadne tajomstvá.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Vezmite si svoje záložky, heslá, históriu a ďalšie údaje všade, kde používate { -brand-product-name }.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Pošleme vám upozornenie vždy, keď sa vaše údaje objavia v úniku dát.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Spravujte si heslá bezpečne aj na cestách.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Ochrana pred sledovaním
onboarding-tracking-protection-text2 = { -brand-short-name } vám pomôže zastaviť sledovanie webovými stránkami a reklamami.
onboarding-tracking-protection-button2 = Ako to funguje
onboarding-data-sync-title = Vezmite si svoje nastavenia so sebou
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Synchronizujte svoje záložky, heslá a ďalšie údaje všade, kde používate { -brand-product-name }.
onboarding-data-sync-button2 = Prihláste sa do služby { -sync-brand-short-name }
onboarding-firefox-monitor-title = Nechajte sa informovať o únikoch údajov
onboarding-firefox-monitor-text2 = { -monitor-brand-name } sleduje, či sa vaša e-mailová adresa neobjavila v nejakom úniku dát a dá vám vedieť, ak ju v nejakom nájde.
onboarding-firefox-monitor-button = Prihláste sa na odber upozornení
onboarding-browse-privately-title = Súkromné prehliadanie
onboarding-browse-privately-text = Súkromné prehliadanie odstráni vašu históriu prehliadania a uchová vaše tajomstvá pred ostatnými používateľmi vášho počítača.
onboarding-browse-privately-button = Otvoriť súkromné okno
onboarding-firefox-send-title = Udržujte svoje zdieľané súbory v súkromí
onboarding-firefox-send-text2 = Zdieľajte svoje súbory prostredníctvom služby { -send-brand-name }, ktorá ich chráni pomocou end-to-end šifrovania a odkazov, ktorých platnosť automaticky vyprší.
onboarding-firefox-send-button = Vyskúšajte { -send-brand-name }
onboarding-mobile-phone-title = Nainštalujte si { -brand-product-name } do svojho telefónu
onboarding-mobile-phone-text = Prevezmite si { -brand-product-name } pre iOS a Android a zosynchronizujte svoje údaje medzi zariadeniami.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Prevziať mobilný prehliadač
onboarding-send-tabs-title = Odosielajte si karty medzi zariadeniami
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Zdieľajte a posielajte stránky medzi svojimi zariadeniami. Nemusíte kopírovať žiadne odkazy ani opúšťať prehliadač.
onboarding-send-tabs-button = Začnite s odosielaním kariet
onboarding-pocket-anywhere-title = Čítajte a počúvajte kdekoľvek
onboarding-pocket-anywhere-text2 = Uložte si svoj obľúbený obsah offline s aplikáciou { -pocket-brand-name } a čítajte či počúvajte kedykoľvek.
onboarding-pocket-anywhere-button = Vyskúšajte { -pocket-brand-name }
onboarding-lockwise-strong-passwords-title = Tvorba silných hesiel
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } vám okamžite vygeneruje silné heslá a uloží ich bezpečne na jednom mieste.
onboarding-lockwise-strong-passwords-button = Správa prihlasovacích údajov
onboarding-facebook-container-title = Stanovte hranice pre Facebook
onboarding-facebook-container-text2 = { -facebook-container-brand-name } oddeľuje váš účet od zvyšku internetu, takže pre Facebook a jeho reklamy je zložité vás na internete vysledovať.
onboarding-facebook-container-button = Pridať rozšírenie
onboarding-import-browser-settings-title = Importujte svoje záložky, heslá a ďalšie údaje
onboarding-import-browser-settings-text = Poďme na to - jednoduchý prenos obľúbených stránok a nastavení z Chromu.
onboarding-import-browser-settings-button = Import údajov z prehliadača Chrome
onboarding-personal-data-promise-title = Súkromie už v návrhu
onboarding-personal-data-promise-text = { -brand-product-name } chráni vaše súkromie, rešpektuje a chráni vaše údaje a jasne hovorí, ako ich používa.
onboarding-personal-data-promise-button = Prečítajte si náš sľub

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Skvelé, odteraz máte { -brand-short-name }
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Teraz naspäť k doplnku <icon></icon><b>{ $addon-name }.</b>
return-to-amo-extension-button = Pridať rozšírenie
return-to-amo-get-started-button = Začíname s aplikáciou { -brand-short-name }
