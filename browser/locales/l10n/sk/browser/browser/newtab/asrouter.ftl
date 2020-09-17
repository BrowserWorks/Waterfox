# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Odporúčané rozšírenie
cfr-doorhanger-feature-heading = Odporúčaná funkcia
cfr-doorhanger-pintab-heading = Vyskúšajte pripnúť kartu

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Prečo sa mi toto zobrazuje

cfr-doorhanger-extension-cancel-button = Teraz nie
    .accesskey = n

cfr-doorhanger-extension-ok-button = Pridať
    .accesskey = P
cfr-doorhanger-pintab-ok-button = Pripnúť túto kartu
    .accesskey = P

cfr-doorhanger-extension-manage-settings-button = Nastavenia odporúčania
    .accesskey = d

cfr-doorhanger-extension-never-show-recommendation = Toto odporúčanie už nezobrazovať
    .accesskey = n

cfr-doorhanger-extension-learn-more-link = Ďalšie informácie

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = od vývojára { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Odporúčanie
cfr-doorhanger-extension-notification2 = Odporúčanie
    .tooltiptext = Odporúčanie rozšírenia
    .a11y-announcement = K dispozícii je odporúčané rozšírenie

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Odporúčanie
    .tooltiptext = Odporúčaná funkcia
    .a11y-announcement = Je k dispozícii odporúčaná funkcia

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } hviezdička
            [few] { $total } hviezdičky
           *[other] { $total } hviezdičiek
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } používateľ
        [few] { $total } používatelia
       *[other] { $total } používateľov
    }

cfr-doorhanger-pintab-description = Majte svoje najpoužívanejšie stránky po ruke. Karty nezmiznú ani pri reštarte.

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = Ak chcete pripnúť kartu, kliknite na ňu <b>pravým tlačidlom</b>.
cfr-doorhanger-pintab-step2 = V ponuke vyberte možnosť <b>pripnúť kartu</b>.
cfr-doorhanger-pintab-step3 = Ak sa na stránke objaví niečo nové, uvidíte pri jej ikone modrú bodku.

cfr-doorhanger-pintab-animation-pause = Pozastaviť
cfr-doorhanger-pintab-animation-resume = Pokračovať


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Majte svoje záložky všade so sebou.
cfr-doorhanger-bookmark-fxa-body = Skvelý nález! Chcete mať túto záložku aj vo svojom mobilnom zariadení? Použite { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Synchronizujte svoje záložky…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Tlačidlo Zavrieť
    .title = Zavrieť

## Protections panel

cfr-protections-panel-header = Nenechajte sa pri prehliadaní sledovať
cfr-protections-panel-body = { -brand-short-name } vás chráni pred mnohými sledovacími prvkami, ktoré zbierajú informácie o tom, čo robíte na internete.
cfr-protections-panel-link-text = Ďalšie informácie

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Nová funkcia:

cfr-whatsnew-button =
    .label = Čo je nové
    .tooltiptext = Čo je nové

cfr-whatsnew-panel-header = Čo je nové

cfr-whatsnew-release-notes-link-text = Prečítajte si poznámky k vydaniu

cfr-whatsnew-fx70-title = { -brand-short-name } tvrdo bojuje za vaše súkromie
cfr-whatsnew-fx70-body =
    Najnovšia aktualizácia vylepšuje ochranu pred sledovaním a zjednodušuje 
    tvorbu bezpečných hesiel pre akúkoľvek stránku.

cfr-whatsnew-tracking-protect-title = Chráňte sa pred sledovacími prvkami
cfr-whatsnew-tracking-protect-body = { -brand-short-name } blokuje mnohé sledovacie prvky, ktoré monitorujú vašu aktivitu na internete.
cfr-whatsnew-tracking-protect-link-text = Podrobnosti

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Počet zablokovaných sledovacích prvkov
        [few] Počet zablokovaných sledovacích prvkov
       *[other] Počet zablokovaných sledovacích prvkov
    }
cfr-whatsnew-tracking-blocked-subtitle = Od { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Podrobnosti

cfr-whatsnew-lockwise-backup-title = Zálohujte svoje heslá
cfr-whatsnew-lockwise-backup-body = Vygenerujte si bezpečné heslá ku ktorým budete mať prístup bez ohľadu na to, odkiaľ sa budete prihlasovať.
cfr-whatsnew-lockwise-backup-link-text = Zapnúť zálohovanie

cfr-whatsnew-lockwise-take-title = Vezmite si svoje heslá so sebou
cfr-whatsnew-lockwise-take-body = S mobilnou aplikáciou { -lockwise-brand-short-name } získate bezpečný prístup k vašim zálohovaným prihlasovacím údajom - a to kdekoľvek.
cfr-whatsnew-lockwise-take-link-text = Prevziať aplikáciu

## Search Bar

cfr-whatsnew-searchbar-title = Používajte panel s adresou - píšte menej, nájdite viac
cfr-whatsnew-searchbar-body-topsites = Teraz stačí vybrať panel s adresou, ktorý sa zväčší a zobrazí odkazy na vaše najnavštevovanejšie stránky.
cfr-whatsnew-searchbar-icon-alt-text = Ikona lupy

## Picture-in-Picture

cfr-whatsnew-pip-header = Pozerajte videá počas prehliadania
cfr-whatsnew-pip-body = V režime obraz v obraze sa video prehráva v samostatnom okne, takže ho môžete sledovať aj pri práci na iných kartách.
cfr-whatsnew-pip-cta = Ďalšie informácie

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Menej otravných vyskakovacích okien
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } teraz zabraňuje stránkam automaticky požadovať odosielanie vyskakovacích správ.
cfr-whatsnew-permission-prompt-cta = Ďalšie informácie

## Fingerprinter Counter


## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Zdieľajte túto záložku aj do svojho telefónu
cfr-doorhanger-sync-bookmarks-body = Majte svoje záložky, heslá, históriu prehliadania a ďalšie vždy po ruke. Prihláste sa do aplikácie { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Zapnúť { -sync-brand-short-name }
    .accesskey = Z

## Login Sync

cfr-doorhanger-sync-logins-header = Už žiadne zabudnuté heslá
cfr-doorhanger-sync-logins-body = Ukladajte a synchronizujte heslá bezpečne naprieč svojimi zariadeniami.
cfr-doorhanger-sync-logins-ok-button = Zapnúť { -sync-brand-short-name }
    .accesskey = Z

## Send Tab

cfr-doorhanger-send-tab-header = Prečítajte si tento článok aj na cestách
cfr-doorhanger-send-tab-recipe-header = Vezmite si tento recept do kuchyne
cfr-doorhanger-send-tab-body = Odosielanie kariet funguje ako jednoduché zdieľanie odkazov do vášho telefónu alebo kamkoľvek, kde ste prihlásení v aplikácii { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Vyskúšajte odosielanie kariet
    .accesskey = o

## Firefox Send

cfr-doorhanger-firefox-send-header = Zdieľajte bezpečne toto PDF
cfr-doorhanger-firefox-send-body = Zdieľajte svoje dokumenty bez toho, aby vám niekto nazeral cez plece - ochrana pomocou end-to-end šifrovania a odkazov s obmedzenou platnosťou.
cfr-doorhanger-firefox-send-ok-button = Vyskúšajte { -send-brand-name }
    .accesskey = V

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Podrobnosti
    .accesskey = P
cfr-doorhanger-socialtracking-close-button = Zavrieť
    .accesskey = Z
cfr-doorhanger-socialtracking-dont-show-again = Nabudúce už nezobrazovať
    .accesskey = N
cfr-doorhanger-socialtracking-heading = Aplikácia { -brand-short-name } zabránila vášmu sledovaniu sociálnou sieťou
cfr-doorhanger-socialtracking-description = Na vašom súkromí záleží. { -brand-short-name } odteraz blokuje bežné sledovacie prvky sociálnych sietí, čím obmedzuje množstvo údajov, ktoré o vás môžu získať na internete.
cfr-doorhanger-fingerprinters-heading = Aplikácia { -brand-short-name } zabránila vytvoreniu odtlačku prehliadača
cfr-doorhanger-fingerprinters-description = Na vašom súkromí záleží. Aplikácia { -brand-short-name } odteraz blokuje tvorbu odtlačkov prehliadača, ktoré sa používajú na vaše sledovanie.
cfr-doorhanger-cryptominers-heading = Aplikácia { -brand-short-name } zablokovala na tejto stránke ťažbu kryptomien
cfr-doorhanger-cryptominers-description = Na vašom súkromí záleží. { -brand-short-name } odteraz blokuje ťažbu kryptomien, ktorá spotrebúva výkon vášho počítača na ťažbu digitálnej meny.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
       *[other] Aplikácia { -brand-short-name } zablokovala od { $date } viac než <b>{ $blockedCount }</b> sledovacích prvkov!
    }
cfr-doorhanger-milestone-ok-button = Zobraziť všetko
    .accesskey = v

cfr-doorhanger-milestone-close-button = Zavrieť
    .accesskey = Z

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Vytvárajte zabezpečené heslá s ľahkosťou
cfr-whatsnew-lockwise-icon-alt = Ikona { -lockwise-brand-short-name(case: "gen") }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Dostávajte upozornenia na zraniteľné heslá
cfr-whatsnew-passwords-icon-alt = Ikona zraniteľného hesla

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Prejdite do režimu obraz v obraze na celú obrazovku
cfr-whatsnew-pip-fullscreen-body = Teraz môžete dvojitým kliknutím zväčšiť vyskakovacie plávajúce okno do režimu na celú obrazovku.
cfr-whatsnew-pip-fullscreen-icon-alt = Ikona obrazu v obraze

## Protections Dashboard message

cfr-whatsnew-protections-header = Prehľad ochrany na jednom mieste
cfr-whatsnew-protections-icon-alt = Ikona štítu

## Better PDF message

cfr-whatsnew-better-pdf-header = Lepšia práca s PDF

## DOH Message

cfr-doorhanger-doh-header = Bezpečnejšie a šifrované vyhľadávanie DNS
cfr-doorhanger-doh-primary-button = OK, rozumiem
    .accesskey = O

## What's new: Cookies message

