# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-central-title = Vítá vás { -brand-full-name }
account-settings = Nastavení účtu

#   $accounts (Number) - the number of configured accounts
setup-title =
    { $accounts ->
        [0] Přidání účtu
       *[other] Nastavení dalšího účtu
    }
about-title =
    O { -brand-full-name.gender ->
        [masculine] { -brand-full-name(case: "loc") }
        [feminine] { -brand-full-name(case: "loc") }
        [neuter] { -brand-full-name(case: "loc") }
       *[other] aplikaci { -brand-full-name }
    }
resources-title = Užitečné odkazy

release-notes =
    .title =
        O { -brand-full-name.gender ->
            [masculine] { -brand-full-name(case: "loc") }
            [feminine] { -brand-full-name(case: "loc") }
            [neuter] { -brand-full-name(case: "loc") }
           *[other] aplikaci { -brand-full-name }
        }

email-label = E-mail
    .aria-label = Připojení k vašemu stávajícímu e-mailovému účtu
email-description = S { -brand-short-name(case: "ins") } se můžete připojit ke svému stávajícímu e-mailovému účtu a číst své e-maily pohodlně a efektivně.

calendar-label = Kalendář
    .aria-label = Vytvoření nového kalendáře
calendar-description = { -brand-short-name } vám umožňuje zpracovávat události a udržovat si o nich přehled. Připojení se ke vzdálenému kalendáři umožní synchronizaci jeho celého obsahu napříč všemi vašimi zařízeními.

chat-label = Chat
    .aria-label = Připojení k vašemu chatovacímu účtu
chat-description = { -brand-short-name } se umí připojit a ovládat účty několika chatovacích služeb a platforem.

filelink-label = Posílání souborů
    .aria-label = Nastavení webového úložiště
filelink-description = { -brand-short-name } vám umožňuje nastavit si pohodlný cloudový účet pro snadné odesílání velkých příloh.

addressbook-label = Kontakty
    .aria-label = Vytvoření nové složky kontaktů
addressbook-description = { -brand-short-name } vám umožňuje uspořádat si všechny své kontakty do složek. Můžete se také připojit ke vzdálenému adresáři kontaktů a udržovat tak všechny své kontakty synchronizované.

feeds-label = Účet kanálů
    .aria-label = Připojení k informačním kanálům
feeds-description = { -brand-short-name } se umí připojit a získávat zprávy a novinky pomocí kanálů RSS či Atom.

newsgroups-label = Diskusní skupiny
    .aria-label = Připojení k diskuzní skupině
newsgroups-description = { -brand-short-name } vám umožní připojit se do jakékoliv diskusní skupiny budete chtít.

import-title = Import z jiného programu
import-paragraph = { -brand-short-name } umí importovat e-mailové zprávy, kontakty, odebírané kanály, předvolby i filtry zpráv z jiných poštovních programů a běžných formátů.

import-label = Importovat
    .aria-label = Importovat data z jiného programu

about-paragraph = Thunderbird je hlavní otevřený a multiplatformní e-mailový klient, který je zdarma pro osobní použití i pro firmy. Chceme, aby zůstal i nadále bezpečný a stále se zlepšoval. I díky vašim příspěvkům máme na platy vývojářů, údržbu infrastruktury a další vylepšování.

about-paragraph-consider-donation = <b>Thunderbird je financován uživateli, jako jste vy! Pokud se vám Thunderbird líbí, zvažte prosím možnost poskytnutí daru.</b> Nejlepší způsob, jak můžete zajistit, aby byl Thunderbird stále k dispozici, je <a data-l10n-name="donation-link">věnování peněžního daru</a>.

explore-link = Prozkoumejte všechny funkce
support-link = Nápověda
involved-link = Zapojit se
developer-link = Dokumentace pro vývojáře

read = Přečíst zprávy
compose = Napsat novou zprávu
search = Hledat ve zprávách
filter = Spravovat filtry zpráv
nntp-subscription = Spravovat odběry diskusních skupin
rss-subscription = Spravovat odběry kanálů
e2e = Koncové šifrování
