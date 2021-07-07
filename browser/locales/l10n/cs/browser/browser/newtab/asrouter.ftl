# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Doporučené rozšíření
cfr-doorhanger-feature-heading = Doporučená funkce
cfr-doorhanger-pintab-heading = Vyzkoušejte připnout panel

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Co to je
cfr-doorhanger-extension-cancel-button = Teď ne
    .accesskey = n
cfr-doorhanger-extension-ok-button = Přidat
    .accesskey = a
cfr-doorhanger-pintab-ok-button = Připnout tento panel
    .accesskey = P
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
cfr-doorhanger-pintab-description = Nechte si nejpoužívanější stránky po ruce v panelu, který neztratíte ani při restartu počítače.

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = Pokud chcete panel připnout, klikněte na něj <b>pravým tlačítkem</b>.
cfr-doorhanger-pintab-step2 = V nabídce vyberte <b>Připnout panel</b>.
cfr-doorhanger-pintab-step3 = Pokud je na stránce něco nového, uvidíte u ní na liště panelů modrý puntík.
cfr-doorhanger-pintab-animation-pause = Pozastavit
cfr-doorhanger-pintab-animation-resume = Pokračovat

## Firefox Accounts Message

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
cfr-whatsnew-panel-header = Co je nového
cfr-whatsnew-release-notes-link-text = Přečtěte si poznámky k vydání
cfr-whatsnew-fx70-title = { -brand-short-name } tvrdě bojuje za vaše soukromí
cfr-whatsnew-fx70-body = Nejnovější aktualizace vylepšuje funkci ochrany proti sledování a usnadňuje vytváření bezpečných hesel pro každý server.
cfr-whatsnew-tracking-protect-title = Chraňte se před sledovacími prvky
cfr-whatsnew-tracking-protect-body = { -brand-short-name } blokuje mnoho prvků sociálních sítí a třetích stran, které jsou známé sledováním vašeho chování na internetu.
cfr-whatsnew-tracking-protect-link-text = Zobrazit podrobnosti
# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title = Blokování sledovacích prvků
cfr-whatsnew-tracking-blocked-subtitle = Od { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Zobrazit podrobnosti
cfr-whatsnew-lockwise-backup-title = Zálohujte svá hesla
cfr-whatsnew-lockwise-backup-body = Používejte generovaná a bezpečná hesla, ke kterým máte přístup všude, kde se přihlásíte.
cfr-whatsnew-lockwise-backup-link-text = Zapnout zálohování
cfr-whatsnew-lockwise-take-title = Vezměte si svá hesla všude s sebou
cfr-whatsnew-lockwise-take-body = S mobilní aplikací { -lockwise-brand-short-name } získáte bezpečný přístup k vašim zálohovaným přihlašovacím údajům kdekoliv budete potřebovat.
cfr-whatsnew-lockwise-take-link-text = Stáhnout aplikaci

## Search Bar

cfr-whatsnew-searchbar-title = Použijte adresní řádek - pište méně, najdete více
cfr-whatsnew-searchbar-body-topsites = Po klepnutí do adresního řádku uvidíte odkazy na své top stránky.

## Search bar

cfr-whatsnew-searchbar-icon-alt-text = Ikona lupy

## Picture-in-Picture

cfr-whatsnew-pip-header = Sledujte videa během brouzdání
cfr-whatsnew-pip-body = V režimu obraz v obraze se video přehrává v samostatném plovoucím okně, takže ho můžete sledovat i při práci v jiných panelech.
cfr-whatsnew-pip-cta = Zjistit více

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Méně otravných vyskakovacích oken
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } brání stránkám v dotazech na posílání vyskakovacích upozornění.
cfr-whatsnew-permission-prompt-cta = Zjistit více

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header = Zablokováno vytvoření otisku prohlížeče
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } blokuje mnoho způsobů vytváření otisku prohlížeče, které tajně sbírají informace o vašem zařízení, aby si vytvořily profil pro sledování vašich dalších aktivit.
# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Blokování otisku prohlížeče
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } blokuje vytváření otisku prohlížeče, které tajně sbírá informace o vašem zařízení pro vytvoření vašeho reklamního profilu

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Sdílejte tuto záložku i do svého telefonu
cfr-doorhanger-sync-bookmarks-body =
    Mějte své záložky, hesla, historii prohlížení a další vždy po ruce. Přihlaste se { -brand-product-name.gender ->
        [masculine] ve { -brand-product-name(case: "loc") }
        [feminine] v { -brand-product-name(case: "loc") }
        [neuter] v { -brand-product-name(case: "loc") }
       *[other] v aplikaci { -brand-product-name }
    }.
cfr-doorhanger-sync-bookmarks-ok-button = Zapnout { -sync-brand-short-name(case: "gen") }
    .accesskey = Z

## Login Sync

cfr-doorhanger-sync-logins-header = Už žádná zapomenutá hesla
cfr-doorhanger-sync-logins-body = Ukládejte a synchronizujte hesla bezpečně napříč svými zařízeními.
cfr-doorhanger-sync-logins-ok-button = Zapnout { -sync-brand-short-name(case: "gen") }
    .accesskey = t

## Send Tab

cfr-doorhanger-send-tab-header = Přečtěte si tento článek i na cestách
cfr-doorhanger-send-tab-recipe-header = Vezměte si tento recept rovnou do kuchyně
cfr-doorhanger-send-tab-body =
    Posílání panelů funguje pro snadné sdílení odkazů do vašeho telefonu nebo kamkoliv, kde jste přihlášeni { -brand-product-name.gender ->
        [masculine] ve { -brand-product-name(case: "loc") }
        [feminine] v { -brand-product-name(case: "loc") }
        [neuter] v { -brand-product-name(case: "loc") }
       *[other] v aplikaci { -brand-product-name }
    }.
cfr-doorhanger-send-tab-ok-button = Vyzkoušet posílání panelů
    .accesskey = V

## Firefox Send

cfr-doorhanger-firefox-send-header = Sdílejte bezpečně toto PDF
cfr-doorhanger-firefox-send-body = Sdílejte své dokumenty bez toho, aby vám někdo koukal přes rameno. Ochráníme je pomocí end-to-end šifrování a odkazů s omezenou platností.
cfr-doorhanger-firefox-send-ok-button = Vyzkoušet { -send-brand-name(case: "acc") }
    .accesskey = V

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Podrobnosti
    .accesskey = P
cfr-doorhanger-socialtracking-close-button = Zavřít
    .accesskey = Z
cfr-doorhanger-socialtracking-dont-show-again = Příště už nezobrazovat
    .accesskey = n
cfr-doorhanger-socialtracking-heading =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } zabránil
        [feminine] { -brand-short-name } zabránila
        [neuter] { -brand-short-name } zabránilo
       *[other] Aplikace { -brand-short-name } zabránila
    } vašemu sledování sociální sítí
cfr-doorhanger-socialtracking-description = Na vašem soukromí záleží. { -brand-short-name } blokuje běžné sledovací prvky sociálních sítí a tím omezuje množství dat, které o vás mohou na internetu sbírat.
cfr-doorhanger-fingerprinters-heading =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } zabránil
        [feminine] { -brand-short-name } zabránila
        [neuter] { -brand-short-name } zabránilo
       *[other] Aplikace { -brand-short-name } zabránila
    } vytvoření otisku vašeho prohlížeče
cfr-doorhanger-fingerprinters-description = Na vašem soukromí záleží. { -brand-short-name } blokuje vytváření otisku vašeho prohlížeče, který může být využit k vaší identifikaci nebo vašemu sledování.
cfr-doorhanger-cryptominers-heading =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } zablokoval
        [feminine] { -brand-short-name } zablokovala
        [neuter] { -brand-short-name } zablokovalo
       *[other] Aplikace { -brand-short-name } zablokovala
    } těžbu kryptoměn
cfr-doorhanger-cryptominers-description = Na vašem soukromí záleží. { -brand-short-name } blokuje těžbu kryptoměn, která spotřebovává výkon vašeho počítače k těžbě digitálních mincí.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    Od { $date } { -brand-short-name.gender ->
        [masculine] { -brand-short-name } zablokoval
        [feminine] { -brand-short-name } zablokovala
        [neuter] { -brand-short-name } zablokovalo
       *[other] aplikace { -brand-short-name } zablokovala
    } { $blockedCount ->
        [one] jeden sledovací prvek
        [few] více než <b>{ $blockedCount }</b> sledovací prvky
       *[other] více než <b>{ $blockedCount }</b> sledovacích prvků
    }.
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

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Snadná tvorba bezpečných hesel
cfr-whatsnew-lockwise-body = Není jednoduché vymýšlet vždy nové bezpečné heslo pro každý účet. Místo vymýšlení nového hesla, klepněte do pole pro heslo a použijte bezpečné heslo vygenerované { -brand-shorter-name(case: "ins") }.
cfr-whatsnew-lockwise-icon-alt = Ikona { -lockwise-brand-short-name(case: "gen") }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Nechte se upozornit na zranitelná hesla
cfr-whatsnew-passwords-body = Hackeři vědí, že lidé často používají stejná hesla. Pokud používáte stejné heslo na více serverech a na některém dojde k úniku dat, { -lockwise-brand-short-name } vás upozorní a doporučí změnu hesla na všech serverech s tímto heslem.
cfr-whatsnew-passwords-icon-alt = Ikona zranitelného hesla

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Otevřete si obraz v obraze na celou obrazovku
cfr-whatsnew-pip-fullscreen-body = Při otevření videa v plovoucím okně ho můžete poklepáním zvětšit na celou obrazovku.
cfr-whatsnew-pip-fullscreen-icon-alt = Ikona obrazu v obraze

## Protections Dashboard message

cfr-doorhanger-milestone-close-button = Zavřít
    .accesskey = Z

## What’s New Panel Content for Firefox 76
## Protections Dashboard message

cfr-whatsnew-protections-header = Ochrana soukromí na dosah ruky
cfr-whatsnew-protections-body = Přehled ochrany soukromí obsahuje souhrnné informace o únicích dat a správě vašich hesel. Snad také zjistíte, následky kolika úniků dat už jste vyřešili, nebo jestli mohly být vaše přihlašovací údaje součástí nějakého nového úniku dat.
cfr-whatsnew-protections-cta-link = Zobrazit přehled ochrany soukromí
cfr-whatsnew-protections-icon-alt = Ikona štítu

## Better PDF message

cfr-whatsnew-better-pdf-header = Vylepšené prohlížení PDF
cfr-whatsnew-better-pdf-body =
    Soubory PDF se nyní otevírají přímo { -brand-short-name.gender ->
        [masculine] ve { -brand-short-name(case: "loc") }
        [feminine] v { -brand-short-name(case: "loc") }
        [neuter] v { -brand-short-name(case: "loc") }
       *[other] v aplikaci { -brand-short-name }
    }, takže je máte hned po ruce.

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

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Automatická ochrana před záludnými sledovacími taktikami
cfr-whatsnew-clear-cookies-body = Některé sledovací prvky vás přesměrovávají na jiné stránky, které tajně ukládají cookies. { -brand-short-name } nyní tyto cookies automaticky vymaže, abyste nemohli být sledováni.
cfr-whatsnew-clear-cookies-image-alt = Ukázka zablokovaných cookies

## What's new: Media controls message

cfr-whatsnew-media-keys-header = Více možností ovládání médií
cfr-whatsnew-media-keys-body = Přehrávejte a pozastavujte zvuk nebo video přímo z klávesnice nebo náhlavní soupravy, což usnadňuje ovládání médií z jiného panelu, programu nebo dokonce i když je počítač uzamčen. Také můžete přecházet mezi skladbami pomocí kláves vpřed a vzad.
cfr-whatsnew-media-keys-button = Jak na to

## What's new: Search shortcuts

cfr-whatsnew-search-shortcuts-header = Vyhledávače v adresním řádku
cfr-whatsnew-search-shortcuts-body = Nyní když do adresního řádku zadáte vyhledávač nebo konkrétní web, se níže v našeptávači zobrazí modrá zkratka. Klepněte na tuto zkratku a dokončete vyhledávání přímo z adresního řádku.

## What's new: Cookies protection

cfr-whatsnew-supercookies-header = Ochrana před škodlivými supercookies
cfr-whatsnew-supercookies-body = Některé servery tajně posílají vašemu prohlížeči tzv. „supercookies“, pomocí kterých vás mohou na internetu sledovat i po smazání cookies. { -brand-short-name } poskytuje silnou ochranu proti supercookies, aby nemohly sloužit ke sledování vašeho brouzdání napříč různými webovými stránkami.

## What's new: Better bookmarking

cfr-whatsnew-bookmarking-header = Vylepšená funkce záložek
cfr-whatsnew-bookmarking-body = Zpráva vašich oblíbených stránek je nyní jednodušší. { -brand-short-name } si pamatuje vámi preferované umístění pro ukládání nových záložek, ve výchozím nastavení zobrazuje lištu záložek při otevření nového panelu, která zároveň poskytuje snadný přístup k ostatním záložkám.

## What's new: Cross-site cookie tracking

cfr-whatsnew-cross-site-tracking-header = Důkladná ochrana proti sledování pomocí cookies třetích stran
cfr-whatsnew-cross-site-tracking-body = Nově můžete využít lepší ochranu proti sledování skrze cookies. { -brand-short-name } vaše vnitřně oddělí uložené informace o vašich aktivitách a data navštívených stránek, takže nebudou sdíleny mezi servery.

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
