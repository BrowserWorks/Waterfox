# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

third-party-page-title = Informace o modulu třetí strany
third-party-section-title =
    { -brand-short-name.case-status ->
        [with-cases] Seznam modulů třetích stran načtených v { -brand-short-name(case: "loc") }
       *[no-cases] Seznam modulů třetích stran načtených v aplikaci { -brand-short-name }
    }
third-party-intro =
    { -vendor-short-name.case-status ->
        [with-cases] Tato stránka zobrazuje seznam modulů třetích stran, které byly vneseny do vaší aplikace { -brand-short-name }. Za modul třetí strany je považovaný každý modul, který není podepsaný Microsoftem nebo { -vendor-short-name(case: "ins") }.
       *[other] Tato stránka zobrazuje seznam modulů třetích stran, které byly vneseny do vaší aplikace { -brand-short-name }. Za modul třetí strany je považovaný každý modul, který není podepsaný Microsoftem nebo organizací { -vendor-short-name }.
    }
third-party-message-empty = Nebyly nalezeny žádné moduly třetích stran.
third-party-message-no-duration = Nezaznamenáno
third-party-detail-version = Verze souboru
third-party-detail-vendor = Informace poskytovatele
third-party-detail-occurrences = Výskyty
    .title = Kolikrát byl tento modul načten.
third-party-detail-duration = Průměrný čas blokování (ms)
    .title = Jak dlouho tento modul aplikaci blokoval.
third-party-detail-app = Aplikace
third-party-detail-publisher = Autor
third-party-th-process = Proces
third-party-th-duration = Doba načítání (ms)
third-party-th-status = Stav
third-party-tag-ime = IME
    .title = Tento typ modulu, je načten když používáte IME třetí strany.
third-party-tag-shellex = Rozšíření shellu
    .title = Tento typ modulu je načten, když otevřete systémový dialog pro výběr souborů.
third-party-tag-background = Pozadí
    .title = Tento modul aplikaci neblokoval, protože byl načten na pozadí.
third-party-icon-unsigned =
    .title = Tento modul není podepsaný
    .alt = Tento modul není podepsaný
third-party-icon-warning =
    .title =
        { -brand-short-name.gender ->
            [masculine] { -brand-short-name } spadl při vykonávání kódu tohoto modulu
            [feminine] { -brand-short-name } spadla při vykonávání kódu tohoto modulu
            [neuter] { -brand-short-name } spadlo při vykonávání kódu tohoto modulu
           *[other] Aplikace { -brand-short-name } spadla při vykonávání kódu tohoto modulu
        }
    .alt =
        { -brand-short-name.gender ->
            [masculine] { -brand-short-name } spadl při vykonávání kódu tohoto modulu
            [feminine] { -brand-short-name } spadla při vykonávání kódu tohoto modulu
            [neuter] { -brand-short-name } spadlo při vykonávání kódu tohoto modulu
           *[other] Aplikace { -brand-short-name } spadla při vykonávání kódu tohoto modulu
        }
third-party-status-loaded = Načtený
third-party-status-blocked = Zablokovaný
third-party-status-redirected = Přesměrovaný
third-party-button-copy-to-clipboard = Zkopírovat data do schránky
third-party-loading-data =
    .alt = Načítání systémových informací…
    .title = Načítají se systémové informace…
third-party-button-reload = Znovu načíst se systémovými informacemi
    .title = Znovu načíst se systémovými informacemi
third-party-button-open =
    .title = Otevřít umístění souboru…
third-party-button-to-block =
    .title = Zablokovat tento modul
    .aria-label = Zablokovat tento modul
third-party-button-to-unblock =
    .title = Blokováno. Klepněte pro odblokování.
    .aria-label = Blokováno. Klepněte pro odblokování.
third-party-button-to-unblock-disabled =
    .title =
        { -brand-short-name.case-status ->
            [with-cases] Označeno jako blokované, nicméně seznam blokovaných modulů je pro toto spuštění { -brand-short-name(case: "gen") } vypnutý. Klepněte pro odblokování.
           *[no-cases] Označeno jako blokované, nicméně seznam blokovaných modulů je pro toto spuštění aplikace { -brand-short-name } vypnutý. Klepněte pro odblokování.
        }
    .aria-label =
        { -brand-short-name.case-status ->
            [with-cases] Označeno jako blokované, nicméně seznam blokovaných modulů je pro toto spuštění { -brand-short-name(case: "gen") } vypnutý. Klepněte pro odblokování.
           *[no-cases] Označeno jako blokované, nicméně seznam blokovaných modulů je pro toto spuštění aplikace { -brand-short-name } vypnutý. Klepněte pro odblokování.
        }
third-party-button-to-block-module = Zablokovat tento modul
    .title = Zablokovat tento modul
    .aria-label = Zablokovat tento modul
third-party-button-to-unblock-module = Odblokovat tento modul
    .title = Aktuálně blokován. Klepnutím jej odblokujete.
    .aria-label = Aktuálně blokován. Klepnutím jej odblokujete.
third-party-button-to-unblock-module-disabled = Odblokovat tento modul (seznam blokovaných je aktuálně zakázán)
    .title =
        { -brand-short-name.case-status ->
            [with-cases] Aktuálně označeno jako blokované, ačkoliv je pro toto spuštění { -brand-short-name(case: "gen") } seznam blokovaných zakázán. Pro odblokování klepněte.
           *[no-cases] Aktuálně označeno jako blokované, ačkoliv je pro toto spuštění aplikace { -brand-short-name } seznam blokovaných zakázán. Pro odblokování klepněte.
        }
    .aria-label =
        { -brand-short-name.case-status ->
            [with-cases] Aktuálně označeno jako blokované, ačkoliv je pro toto spuštění { -brand-short-name(case: "gen") } seznam blokovaných zakázán. Pro odblokování klepněte.
           *[no-cases] Aktuálně označeno jako blokované, ačkoliv je pro toto spuštění aplikace { -brand-short-name } seznam blokovaných zakázán. Pro odblokování klepněte.
        }
third-party-button-expand =
    .title = Zobrazit podrobnosti
third-party-button-collapse =
    .title = Skrýt podrobnosti
third-party-blocking-requires-restart =
    { -brand-short-name.case-status ->
        [with-cases] Chcete-li zablokovat modul třetí strany, musíte { -brand-short-name(case: "acc") } restartovat.
       *[no-cases] Chcete-li zablokovat modul třetí strany, musíte aplikaci { -brand-short-name } restartovat.
    }
third-party-should-restart-title =
    { -brand-short-name.case-status ->
        [with-cases] Restartovat { -brand-short-name(case: "acc") }
       *[no-cases] Restartovat aplikaci { -brand-short-name }
    }
third-party-restart-now = Restartovat
third-party-restart-later = Restartovat později
third-party-blocked-by-builtin =
    .title =
        { -brand-short-name.case-status ->
            [with-cases] Blokováno { -brand-short-name(case: "gen") }
           *[no-cases] Blokováno aplikací { -brand-short-name }
        }
    .alt =
        { -brand-short-name.case-status ->
            [with-cases] Blokováno { -brand-short-name(case: "gen") }
           *[no-cases] Blokováno aplikací { -brand-short-name }
        }
