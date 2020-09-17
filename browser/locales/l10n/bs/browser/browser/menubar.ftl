# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## File Menu

menu-file =
    .label = Fajl
    .accesskey = F
menu-file-new-tab =
    .label = Novi tab
    .accesskey = t
menu-file-new-container-tab =
    .label = Novi Container tab
    .accesskey = b
menu-file-new-window =
    .label = Novi prozor
    .accesskey = N
menu-file-new-private-window =
    .label = Novi privatni prozor
    .accesskey = v
# "Open Location" is only displayed on macOS, and only on windows
# that aren't main browser windows, or when there are no windows
# but Firefox is still running.
menu-file-open-location =
    .label = Otvori lokaciju…
menu-file-open-file =
    .label = Otvori fajl…
    .accesskey = O
menu-file-close =
    .label = Zatvori
    .accesskey = Z
menu-file-close-window =
    .label = Zatvori prozor
    .accesskey = Z
menu-file-save-page =
    .label = Spasi stranicu kao…
    .accesskey = a
menu-file-email-link =
    .label = Pošalji link emailom…
    .accesskey = e
menu-file-print-setup =
    .label = Podešavanje strane…
    .accesskey = P
menu-file-print-preview =
    .label = Pregled prije štampe
    .accesskey = P
menu-file-print =
    .label = Štampaj…
    .accesskey = p
menu-file-import-from-another-browser =
    .label = Uvoz iz drugog browsera…
    .accesskey = I
menu-file-go-offline =
    .label = Radi offline
    .accesskey = R

## Edit Menu

menu-edit =
    .label = Uredi
    .accesskey = e
menu-edit-find-on =
    .label = Pronađi na ovoj stranici…
    .accesskey = P
menu-edit-find-again =
    .label = Pronađi ponovo
    .accesskey = P
menu-edit-bidi-switch-text-direction =
    .label = Promijeni smjer teksta
    .accesskey = P

## View Menu

menu-view =
    .label = Prikaz
    .accesskey = P
menu-view-toolbars-menu =
    .label = Trake sa alatima
    .accesskey = T
menu-view-customize-toolbar =
    .label = Prilagođavanje…
    .accesskey = P
menu-view-sidebar =
    .label = Bočna traka
    .accesskey = B
menu-view-bookmarks =
    .label = Zabilješke
menu-view-history-button =
    .label = Historija
menu-view-synced-tabs-sidebar =
    .label = Sinhronizovani tabovi
menu-view-full-zoom =
    .label = Zumiraj
    .accesskey = Z
menu-view-full-zoom-enlarge =
    .label = Uvećaj
    .accesskey = U
menu-view-full-zoom-reduce =
    .label = Umanji
    .accesskey = U
menu-view-full-zoom-actual-size =
    .label = Stvarna veličina
    .accesskey = A
menu-view-full-zoom-toggle =
    .label = Uvećaj samo tekst
    .accesskey = t
menu-view-page-style-menu =
    .label = Stil stranice
    .accesskey = S
menu-view-page-style-no-style =
    .label = Bez stila
    .accesskey = B
menu-view-page-basic-style =
    .label = Osnovni stil stranice
    .accesskey = O
menu-view-charset =
    .label = Kodna stranica teksta
    .accesskey = e

## These should match what Safari and other Apple applications
## use on macOS.

menu-view-enter-full-screen =
    .label = Uđi u prikaz preko cijelog ekrana
    .accesskey = F
menu-view-exit-full-screen =
    .label = Izađi iz prikaza preko cijelog ekrana
    .accesskey = F
menu-view-full-screen =
    .label = Prikaz preko cijelog ekrana
    .accesskey = c

##

menu-view-show-all-tabs =
    .label = Prikaži sve tabove
    .accesskey = a
menu-view-bidi-switch-page-direction =
    .label = Promijeni smjer stranice
    .accesskey = P

## History Menu

menu-history =
    .label = Historija
    .accesskey = s
menu-history-show-all-history =
    .label = Prikaz cijele historije
menu-history-clear-recent-history =
    .label = Obriši skorašnju historiju…
menu-history-synced-tabs =
    .label = Sinhronizovani tabovi
menu-history-restore-last-session =
    .label = Vrati prethodnu sesiju
menu-history-hidden-tabs =
    .label = Skriveni tabovi
menu-history-undo-menu =
    .label = Nedavno zatvoreni tabovi
menu-history-undo-window-menu =
    .label = Nedavno zatvoreni prozori

## Bookmarks Menu

menu-bookmarks-menu =
    .label = Zabilješke
    .accesskey = b
menu-bookmarks-show-all =
    .label = Prikaži sve zabilješke
menu-bookmark-this-page =
    .label = Zabilježi ovu stranicu
menu-bookmark-edit =
    .label = Uredi ovu Zabilješku
menu-bookmarks-all-tabs =
    .label = Zabilježi sve tabove…
menu-bookmarks-toolbar =
    .label = Traka sa zabilješkama
menu-bookmarks-other =
    .label = Druge zabilješke
menu-bookmarks-mobile =
    .label = Mobilne zabilješke

## Tools Menu

menu-tools =
    .label = Alati
    .accesskey = t
menu-tools-downloads =
    .label = Preuzimanja
    .accesskey = P
menu-tools-addons =
    .label = Add-oni
    .accesskey = A
menu-tools-fxa-sign-in =
    .label = Prijava na { -brand-product-name }…
    .accesskey = S
menu-tools-turn-on-sync =
    .label = Upali { -sync-brand-short-name }…
    .accesskey = n
menu-tools-sync-now =
    .label = Sinhronizuj sada
    .accesskey = S
menu-tools-fxa-re-auth =
    .label = Ponovo se poveži na { -brand-product-name }…
    .accesskey = R
menu-tools-web-developer =
    .label = Web Developer
    .accesskey = W
menu-tools-page-source =
    .label = Izvorni kod stranice
    .accesskey = o
menu-tools-page-info =
    .label = Podaci o strani
    .accesskey = i
menu-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opcije
           *[other] Postavke
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
menu-tools-layout-debugger =
    .label = Debager layouta
    .accesskey = L

## Window Menu

menu-window-menu =
    .label = Prozor
menu-window-bring-all-to-front =
    .label = Prebaci sve u prvi plan

## Help Menu

menu-help =
    .label = Pomoć
    .accesskey = P
menu-help-product =
    .label = { -brand-shorter-name } pomoć
    .accesskey = H
menu-help-show-tour =
    .label = { -brand-shorter-name } vodič
    .accesskey = o
menu-help-import-from-another-browser =
    .label = Uvoz iz drugog browsera…
    .accesskey = I
menu-help-keyboard-shortcuts =
    .label = Shortcuti na tastaturi
    .accesskey = o
menu-help-troubleshooting-info =
    .label = Informacije za rješavanje problema
    .accesskey = I
menu-help-feedback-page =
    .label = Pošalji povratnu informaciju…
    .accesskey = P
menu-help-safe-mode-without-addons =
    .label = Restartuj sa onemogućenim add-onima…
    .accesskey = R
menu-help-safe-mode-with-addons =
    .label = Restartuj sa omogućenim add-onima
    .accesskey = R
# Label of the Help menu item. Either this or
# menu-help-notdeceptive is shown.
menu-help-report-deceptive-site =
    .label = Prijavi obmanjujuću stranicu…
    .accesskey = o
menu-help-not-deceptive =
    .label = Ovo nije obmanjujuća stranica…
    .accesskey = o
