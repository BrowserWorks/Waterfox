# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# NOTE: For English locales, strings in this file should be in APA-style Title Case.
# See https://apastyle.apa.org/style-grammar-guidelines/capitalization/title-case
#
# NOTE: For Engineers, please don't re-use these strings outside of the menubar.


## Application Menu (macOS only)

menu-application-preferences =
    .label = Předvolby
menu-application-services =
    .label = Služby
menu-application-hide-this =
    .label =
        Skrýt { -brand-shorter-name.gender ->
            [masculine] { -brand-shorter-name(case: "acc") }
            [feminine] { -brand-shorter-name(case: "acc") }
            [neuter] { -brand-shorter-name(case: "acc") }
           *[other] aplikaci { -brand-shorter-name }
        }
menu-application-hide-other =
    .label = Skrýt ostatní
menu-application-show-all =
    .label = Zobrazit vše
menu-application-touch-bar =
    .label = Nastavit Touch Bar…

##

# These menu-quit strings are only used on Windows and Linux.
menu-quit =
    .label = Ukončit
    .accesskey = k
# This menu-quit-mac string is only used on macOS.
menu-quit-mac =
    .label =
        Ukončit { -brand-shorter-name.gender ->
            [masculine] { -brand-shorter-name(case: "acc") }
            [feminine] { -brand-shorter-name(case: "acc") }
            [neuter] { -brand-shorter-name(case: "acc") }
           *[other] aplikaci { -brand-shorter-name }
        }
# This menu-quit-button string is only used on Linux.
menu-quit-button =
    .label = { menu-quit.label }
# This menu-quit-button-win string is only used on Windows.
menu-quit-button-win =
    .label = { menu-quit.label }
    .tooltip =
        Ukončí { -brand-shorter-name.gender ->
            [masculine] { -brand-shorter-name(case: "acc") }
            [feminine] { -brand-shorter-name(case: "acc") }
            [neuter] { -brand-shorter-name(case: "acc") }
           *[other] aplikaci { -brand-shorter-name }
        }
menu-about =
    .label =
        O { -brand-shorter-name.gender ->
            [masculine] { -brand-shorter-name(case: "loc") }
            [feminine] { -brand-shorter-name(case: "loc") }
            [neuter] { -brand-shorter-name(case: "loc") }
           *[other] aplikaci { -brand-shorter-name }
        }
    .accesskey = O

## File Menu

menu-file =
    .label = Soubor
    .accesskey = S
menu-file-new-tab =
    .label = Nový panel
    .accesskey = p
menu-file-new-container-tab =
    .label = Nový kontejnerový panel
    .accesskey = j
menu-file-new-window =
    .label = Nové okno
    .accesskey = N
menu-file-new-private-window =
    .label = Nové anonymní okno
    .accesskey = a
# "Open Location" is only displayed on macOS, and only on windows
# that aren't main browser windows, or when there are no windows
# but Firefox is still running.
menu-file-open-location =
    .label = Otevřít umístění…
menu-file-open-file =
    .label = Otevřít soubor…
    .accesskey = s
menu-file-close =
    .label = Zavřít
    .accesskey = Z
menu-file-close-window =
    .label = Zavřít okno
    .accesskey = v
menu-file-save-page =
    .label = Uložit stránku jako…
    .accesskey = U
menu-file-email-link =
    .label = Poslat odkaz e-mailem…
    .accesskey = e
menu-file-print-setup =
    .label = Vzhled stránky…
    .accesskey = V
menu-file-print-preview =
    .label = Náhled tisku
    .accesskey = h
menu-file-print =
    .label = Vytisknout stránku…
    .accesskey = T
menu-file-import-from-another-browser =
    .label = Importovat z jiného prohlížeče…
    .accesskey = m
menu-file-go-offline =
    .label = Pracovat offline
    .accesskey = l

## Edit Menu

menu-edit =
    .label = Úpravy
    .accesskey = a
menu-edit-find-on =
    .label = Najít na této stránce…
    .accesskey = N
menu-edit-find-in-page =
    .label = Najít na stránce
    .accesskey = N
menu-edit-find-again =
    .label = Najít další
    .accesskey = t
menu-edit-bidi-switch-text-direction =
    .label = Změnit směr textu
    .accesskey = r

## View Menu

menu-view =
    .label = Zobrazit
    .accesskey = Z
menu-view-toolbars-menu =
    .label = Nástrojové lišty
    .accesskey = N
menu-view-customize-toolbar =
    .label = Nastavení tlačítek a lišt…
    .accesskey = V
menu-view-customize-toolbar2 =
    .label = Nastavení tlačítek a lišt…
    .accesskey = v
menu-view-sidebar =
    .label = Postranní lišta
    .accesskey = P
menu-view-bookmarks =
    .label = Záložky
menu-view-history-button =
    .label = Historie
menu-view-synced-tabs-sidebar =
    .label = Synchronizované panely
menu-view-full-zoom =
    .label = Velikost stránky
    .accesskey = V
menu-view-full-zoom-enlarge =
    .label = Zvětšit
    .accesskey = v
menu-view-full-zoom-reduce =
    .label = Zmenšit
    .accesskey = m
menu-view-full-zoom-actual-size =
    .label = Skutečná velikost
    .accesskey = k
menu-view-full-zoom-toggle =
    .label = Pouze velikost textu
    .accesskey = t
menu-view-page-style-menu =
    .label = Styl stránky
    .accesskey = y
menu-view-page-style-no-style =
    .label = Bez stylu
    .accesskey = B
menu-view-page-basic-style =
    .label = Základní styl
    .accesskey = Z
menu-view-charset =
    .label = Znaková sada textu
    .accesskey = k
menu-view-repair-text-encoding =
    .label = Opravit znakovou sadu textu
    .accesskey = z

## These should match what Safari and other Apple applications
## use on macOS.

menu-view-enter-full-screen =
    .label = Spustit režim celé obrazovky
    .accesskey = r
menu-view-exit-full-screen =
    .label = Ukončit režim celé obrazovky
    .accesskey = r
menu-view-full-screen =
    .label = Celá obrazovka
    .accesskey = C

##

menu-view-show-all-tabs =
    .label = Zobrazit všechny panely
    .accesskey = b
menu-view-bidi-switch-page-direction =
    .label = Změnit orientaci stránky
    .accesskey = o

## History Menu

menu-history =
    .label = Historie
    .accesskey = H
menu-history-show-all-history =
    .label = Zobrazit celou historii
menu-history-clear-recent-history =
    .label = Vymazat nedávnou historii…
menu-history-synced-tabs =
    .label = Synchronizované panely
menu-history-restore-last-session =
    .label = Obnovit předchozí relaci
menu-history-hidden-tabs =
    .label = Skryté panely
menu-history-undo-menu =
    .label = Naposledy zavřené panely
menu-history-undo-window-menu =
    .label = Naposledy zavřená okna
menu-history-reopen-all-tabs = Znovu otevřít všechny panely
menu-history-reopen-all-windows = Znovu otevřít všechna okna

## Bookmarks Menu

menu-bookmarks-menu =
    .label = Záložky
    .accesskey = o
menu-bookmarks-show-all =
    .label = Zobrazit všechny záložky
menu-bookmark-this-page =
    .label = Přidat stránku do záložek
menu-bookmarks-manage =
    .label = Správa záložek
menu-bookmark-current-tab =
    .label = Přidat současný panel do záložek
menu-bookmark-edit =
    .label = Upravit záložku
menu-bookmarks-all-tabs =
    .label = Přidat všechny panely do záložek…
menu-bookmarks-toolbar =
    .label = Lišta záložek
menu-bookmarks-other =
    .label = Ostatní záložky
menu-bookmarks-mobile =
    .label = Záložky z mobilu

## Tools Menu

menu-tools =
    .label = Nástroje
    .accesskey = N
menu-tools-downloads =
    .label = Stahování
    .accesskey = t
menu-tools-addons =
    .label = Doplňky
    .accesskey = D
menu-tools-fxa-sign-in =
    .label =
        Přihlásit se k { -brand-product-name.gender ->
            [masculine] { -brand-product-name(case: "dat") }
            [feminine] { -brand-product-name(case: "dat") }
            [neuter] { -brand-product-name(case: "dat") }
           *[other] aplikaci { -brand-product-name }
        }…
    .accesskey = p
menu-tools-turn-on-sync =
    .label = Zapnout { -sync-brand-short-name(case: "acc") }…
    .accesskey = n
menu-tools-addons-and-themes =
    .label = Doplňky a vzhledy
    .accesskey = a
menu-tools-fxa-sign-in2 =
    .label = Přihlásit se
    .accesskey = P
menu-tools-turn-on-sync2 =
    .label = Zapnout synchronizaci…
    .accesskey = n
menu-tools-sync-now =
    .label = Synchronizovat
    .accesskey = S
menu-tools-fxa-re-auth =
    .label =
        Znovu připojit k účtu { -brand-product-name.gender ->
            [masculine] { -brand-product-name(case: "gen") }
            [feminine] { -brand-product-name(case: "gen") }
            [neuter] { -brand-product-name(case: "gen") }
           *[other] aplikace { -brand-product-name }
        }…
    .accesskey = n
menu-tools-web-developer =
    .label = Nástroje pro vývojáře
    .accesskey = v
menu-tools-browser-tools =
    .label = Nástroje prohlížeče
    .accesskey = j
menu-tools-task-manager =
    .label = Správce úloh
    .accesskey = h
menu-tools-page-source =
    .label = Zdrojový kód stránky
    .accesskey = j
menu-tools-page-info =
    .label = Informace o stránce
    .accesskey = I
menu-preferences =
    .label =
        { PLATFORM() ->
            [windows] Možnosti
           *[other] Předvolby
        }
    .accesskey =
        { PLATFORM() ->
            [windows] M
           *[other] v
        }
menu-settings =
    .label = Nastavení
    .accesskey =
        { PLATFORM() ->
            [windows] s
           *[other] s
        }
menu-tools-layout-debugger =
    .label = Debugger rozložení
    .accesskey = l

## Window Menu

menu-window-menu =
    .label = Okno
menu-window-bring-all-to-front =
    .label = Přenést vše do popředí

## Help Menu


# NOTE: For Engineers, any additions or changes to Help menu strings should
# also be reflected in the related strings in appmenu.ftl. Those strings, by
# convention, will have the same ID as these, but prefixed with "app".
# Example: appmenu-get-help
#
# These strings are duplicated to allow for different casing depending on
# where the strings appear.

menu-help =
    .label = Nápověda
    .accesskey = v
menu-help-product =
    .label =
        Nápověda { -brand-shorter-name.gender ->
            [masculine] { -brand-shorter-name(case: "gen") }
            [feminine] { -brand-shorter-name(case: "gen") }
            [neuter] { -brand-shorter-name(case: "gen") }
           *[other] aplikace { -brand-shorter-name }
        }
    .accesskey = N
menu-help-show-tour =
    .label =
        Průvodce { -brand-shorter-name.gender ->
            [masculine] { -brand-shorter-name(case: "ins") }
            [feminine] { -brand-shorter-name(case: "ins") }
            [neuter] { -brand-shorter-name(case: "ins") }
           *[other] aplikací { -brand-shorter-name }
        }
    .accesskey = P
menu-help-import-from-another-browser =
    .label = Importovat z jiného prohlížeče…
    .accesskey = I
menu-help-keyboard-shortcuts =
    .label = Klávesové zkratky
    .accesskey = K
menu-help-troubleshooting-info =
    .label = Technické informace
    .accesskey = T
menu-get-help =
    .label = Získat pomoc
    .accesskey = p
menu-help-more-troubleshooting-info =
    .label = Další technické informace
    .accesskey = t
menu-help-report-site-issue =
    .label = Nahlásit problém se stránkou…
menu-help-feedback-page =
    .label = Odeslat zpětnou vazbu…
    .accesskey = d
menu-help-safe-mode-without-addons =
    .label = Restartovat se zakázanými doplňky…
    .accesskey = R
menu-help-safe-mode-with-addons =
    .label = Restartovat s povolenými doplňky
    .accesskey = R
menu-help-enter-troubleshoot-mode2 =
    .label = Režim řešení potíží…
    .accesskey = m
menu-help-exit-troubleshoot-mode =
    .label = Ukončit režim řešení potíží
    .accesskey = m
# Label of the Help menu item. Either this or
# menu-help-notdeceptive is shown.
menu-help-report-deceptive-site =
    .label = Nahlásit klamavou stránku…
    .accesskey = l
menu-help-not-deceptive =
    .label = Tato stránka není klamavá…
    .accesskey = l
