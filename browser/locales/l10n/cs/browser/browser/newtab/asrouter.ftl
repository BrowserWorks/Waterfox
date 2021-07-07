# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Doporučené rozšíření
cfr-doorhanger-feature-heading = Doporučená funkce

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Co to je
cfr-doorhanger-extension-cancel-button = Teď ne
    .accesskey = n
cfr-doorhanger-extension-ok-button = Přidat
    .accesskey = a
cfr-doorhanger-extension-manage-settings-button = Nastavení doporučování
    .accesskey = d
cfr-doorhanger-extension-never-show-recommendation = Toto doporučení už nezobrazovat
    .accesskey = N
cfr-doorhanger-extension-learn-more-link = Zjistit více
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = autor: { $name }
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Doporučení
cfr-doorhanger-extension-notification2 = Doporučení
    .tooltiptext = Doporučené rozšíření
    .a11y-announcement = Je dostupné doporučené rozšíření
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Doporučení
    .tooltiptext = Doporučená funkce
    .a11y-announcement = Je dostupné doporučení funkce

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } hvězdička
            [few] { $total } hvězdičky
           *[other] { $total } hvězdiček
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } uživatel
        [few] { $total } uživatelé
       *[other] { $total } uživatelů
    }

## Waterfox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Mějte své záložky všude s sebou.
cfr-doorhanger-bookmark-fxa-body = Skvělý nález! Chcete mít tuto záložku i ve svém mobilním zařízení? Použijte { -fxaccount-brand-name(case: "acc", capitalization: "lower") }.
cfr-doorhanger-bookmark-fxa-link-text = Synchronizujte své záložky…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Zavírací tlačítko
    .title = Zavřít

## Protections panel

cfr-protections-panel-header = Nenechte se při prohlížení sledovat
cfr-protections-panel-body = { -brand-short-name } vás chrání před nejběžnějšími sledovacími prvky, které sbírají informace o tom, co děláte na internetu.
cfr-protections-panel-link-text = Zjistit více

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Nové funkce
cfr-whatsnew-button =
    .label = Co je nového
    .tooltiptext = Co je nového
cfr-whatsnew-release-notes-link-text = Přečtěte si poznámky k vydání

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] Aplikace { -brand-short-name }
    } od { DATETIME($date, month: "long", year: "numeric") } { -brand-short-name.gender ->
        [masculine] zablokoval
        [feminine] zablokovala
        [neuter] zablokovalo
       *[other] zablokovala
    } { $blockedCount ->
        [one] jeden sledovací prvek
        [few] <b>{ $blockedCount }</b> sledovací prvky
       *[other] <b>{ $blockedCount }</b> sledovacích prvků
    }.
cfr-doorhanger-milestone-ok-button = Zobrazit vše
    .accesskey = v
cfr-doorhanger-milestone-close-button = Zavřít
    .accesskey = Z

## DOH Message

cfr-doorhanger-doh-body = Na vašem soukromí záleží. V zájmu vaší ochrany nyní { -brand-short-name }, kdykoli je to možné, bezpečně směruje vaše DNS požadavky na partnerskou službu.
cfr-doorhanger-doh-header = Bezpečnější, šifrované vyhledávání v DNS
cfr-doorhanger-doh-primary-button-2 = OK
    .accesskey = O
cfr-doorhanger-doh-secondary-button = Zakázat
    .accesskey = Z

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = Vaše soukromí je důležité. { -brand-short-name } nyní navzájem izoluje jednotlivé weby, což hackerům ztěžuje krádež hesel, čísel platebních karet nebo jiných citlivých informací.
cfr-doorhanger-fission-header = Izolace webů
cfr-doorhanger-fission-primary-button = OK, rozumím
    .accesskey = O
cfr-doorhanger-fission-secondary-button = Zjistit více
    .accesskey = Z

## Full Video Support CFR message

cfr-doorhanger-video-support-body =
    V této verzi { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    } se videa na tomto serveru nemusí přehrávat správně. Pro plnou podporu videí { -brand-short-name.gender ->
        [masculine] svůj { -brand-short-name(case: "acc") }
        [feminine] svou { -brand-short-name(case: "acc") }
        [neuter] své { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    } aktualizujte.
cfr-doorhanger-video-support-header =
    Pro přehrání videa aktualizujte { -brand-short-name.gender ->
        [masculine] svůj { -brand-short-name(case: "acc") }
        [feminine] svou { -brand-short-name(case: "acc") }
        [neuter] své { -brand-short-name(case: "acc") }
       *[other] svou aplikaci { -brand-short-name }
    }.
cfr-doorhanger-video-support-primary-button = Aktualizovat
    .accesskey = A

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the Waterfox VPN page and a link to dismiss the dialog.

spotlight-public-wifi-vpn-header = Zdá se, že používáte veřejnou Wi-Fi síť
spotlight-public-wifi-vpn-body = Pokud chcete skrýt svou polohu a aktivity během prohlížení internetu, zvažte využítí služby virtuální privátní sítě. Poskytne vám ochranu během prohlížení internetu na veřejných místech, v kavárně nebo na letišti.
spotlight-public-wifi-vpn-primary-button =
    Ochraňte své soukromí { -mozilla-vpn-brand-name.gender ->
        [masculine] s { -mozilla-vpn-brand-name(case: "ins") }
        [feminine] s { -mozilla-vpn-brand-name(case: "ins") }
        [neuter] s { -mozilla-vpn-brand-name(case: "ins") }
       *[other] se službou { -mozilla-vpn-brand-name }
    }
    .accesskey = s
spotlight-public-wifi-vpn-link = Teď ne
    .accesskey = n
