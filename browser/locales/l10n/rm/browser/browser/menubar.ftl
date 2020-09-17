# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## File Menu

menu-file =
    .label = Datoteca
    .accesskey = D
menu-file-new-tab =
    .label = Nov tab
    .accesskey = t
menu-file-new-container-tab =
    .label = Nov tab da container
    .accesskey = C
menu-file-new-window =
    .label = Nova fanestra
    .accesskey = N
menu-file-new-private-window =
    .label = Nova fanestra privata
    .accesskey = e
# "Open Location" is only displayed on macOS, and only on windows
# that aren't main browser windows, or when there are no windows
# but Firefox is still running.
menu-file-open-location =
    .label = Avrir in lieu…
menu-file-open-file =
    .label = Avrir ina datoteca…
    .accesskey = d
menu-file-close =
    .label = Serrar
    .accesskey = S
menu-file-close-window =
    .label = Serrar la fanestra
    .accesskey = r
menu-file-save-page =
    .label = Memorisar la pagina sut…
    .accesskey = u
menu-file-email-link =
    .label = Trametter la colliaziun via e-mail…
    .accesskey = E
menu-file-print-setup =
    .label = Organisar la pagina…
    .accesskey = O
menu-file-print-preview =
    .label = Prevista per stampar
    .accesskey = P
menu-file-print =
    .label = Stampar…
    .accesskey = S
menu-file-import-from-another-browser =
    .label = Importar dad in auter navigatur…
    .accesskey = I
menu-file-go-offline =
    .label = Lavurar offline
    .accesskey = o

## Edit Menu

menu-edit =
    .label = Modifitgar
    .accesskey = M
menu-edit-find-on =
    .label = Tschertgar en la pagina
    .accesskey = s
menu-edit-find-again =
    .label = Tschertgar vinavant
    .accesskey = n
menu-edit-bidi-switch-text-direction =
    .label = Midar la direcziun dal text
    .accesskey = M

## View Menu

menu-view =
    .label = Vista
    .accesskey = V
menu-view-toolbars-menu =
    .label = Travs da simbols
    .accesskey = T
menu-view-customize-toolbar =
    .label = Persunalisar…
    .accesskey = a
menu-view-sidebar =
    .label = Trav laterala
    .accesskey = T
menu-view-bookmarks =
    .label = Segnapaginas
menu-view-history-button =
    .label = Cronologia
menu-view-synced-tabs-sidebar =
    .label = Tabs sincronisads
menu-view-full-zoom =
    .label = Zoom
    .accesskey = Z
menu-view-full-zoom-enlarge =
    .label = Engrondir
    .accesskey = g
menu-view-full-zoom-reduce =
    .label = Empitschnir
    .accesskey = E
menu-view-full-zoom-actual-size =
    .label = Dimensiun reala
    .accesskey = D
menu-view-full-zoom-toggle =
    .label = Mo midar il text
    .accesskey = t
menu-view-page-style-menu =
    .label = Stil da la pagina d'internet
    .accesskey = S
menu-view-page-style-no-style =
    .label = Nagin stil
    .accesskey = N
menu-view-page-basic-style =
    .label = Stil da standard
    .accesskey = S
menu-view-charset =
    .label = Codaziun dal text
    .accesskey = C

## These should match what Safari and other Apple applications
## use on macOS.

menu-view-enter-full-screen =
    .label = Modus da maletg entir
    .accesskey = e
menu-view-exit-full-screen =
    .label = Bandunar il modus da maletg entir
    .accesskey = e
menu-view-full-screen =
    .label = Maletg entir
    .accesskey = M

##

menu-view-show-all-tabs =
    .label = Mussar tut ils tabs
    .accesskey = t
menu-view-bidi-switch-page-direction =
    .label = Midar la direcziun da la pagina
    .accesskey = M

## History Menu

menu-history =
    .label = Cronologia
    .accesskey = C
menu-history-show-all-history =
    .label = Mussar l'entira cronologia
menu-history-clear-recent-history =
    .label = Stizzar la cronologia pli nova…
menu-history-synced-tabs =
    .label = Tabs sincronisads
menu-history-restore-last-session =
    .label = Restaurar l'ultima sesida
menu-history-hidden-tabs =
    .label = Tabs zuppentads
menu-history-undo-menu =
    .label = Tabs serrads dacurt
menu-history-undo-window-menu =
    .label = Fanestras serradas dacurt

## Bookmarks Menu

menu-bookmarks-menu =
    .label = Segnapagina
    .accesskey = S
menu-bookmarks-show-all =
    .label = Mussar tut ils segnapaginas
menu-bookmark-this-page =
    .label = Agiuntar in segnapagina…
menu-bookmark-edit =
    .label = Modifitgar quest segnapagina
menu-bookmarks-all-tabs =
    .label = Agiuntar segnapaginas per tut ils tabs…
menu-bookmarks-toolbar =
    .label = Trav d'utensils dals segnapaginas
menu-bookmarks-other =
    .label = Auters segnapaginas
menu-bookmarks-mobile =
    .label = Segnapaginas mobils

## Tools Menu

menu-tools =
    .label = Utensils
    .accesskey = U
menu-tools-downloads =
    .label = Telechargiadas
    .accesskey = D
menu-tools-addons =
    .label = Supplements
    .accesskey = S
menu-tools-fxa-sign-in =
    .label = S'annunziar tar { -brand-product-name }…
    .accesskey = z
menu-tools-turn-on-sync =
    .label = Activar { -sync-brand-short-name }…
    .accesskey = v
menu-tools-sync-now =
    .label = Sincronisar ussa
    .accesskey = S
menu-tools-fxa-re-auth =
    .label = Reconnectar cun { -brand-product-name }…
    .accesskey = R
menu-tools-web-developer =
    .label = Sviluppaders dal web
    .accesskey = w
menu-tools-page-source =
    .label = Mussar il code da funtauna da la pagina
    .accesskey = c
menu-tools-page-info =
    .label = Infurmaziuns davart la pagina
    .accesskey = s
menu-preferences =
    .label =
        { PLATFORM() ->
            [windows] Preferenzas
           *[other] Preferenzas
        }
    .accesskey =
        { PLATFORM() ->
            [windows] e
           *[other] e
        }
menu-tools-layout-debugger =
    .label = Debugadi da layout
    .accesskey = l

## Window Menu

menu-window-menu =
    .label = Fanestra
menu-window-bring-all-to-front =
    .label = Prender tuts enavant

## Help Menu

menu-help =
    .label = Agid
    .accesskey = A
menu-help-product =
    .label = Agid da { -brand-shorter-name }
    .accesskey = d
menu-help-show-tour =
    .label = Tura da { -brand-shorter-name }
    .accesskey = u
menu-help-import-from-another-browser =
    .label = Importar dad in auter navigatur…
    .accesskey = I
menu-help-keyboard-shortcuts =
    .label = Scursanidas da tastas
    .accesskey = c
menu-help-troubleshooting-info =
    .label = Infurmaziuns per schliar problems
    .accesskey = p
menu-help-feedback-page =
    .label = Trametter in resun…
    .accesskey = s
menu-help-safe-mode-without-addons =
    .label = Reaviar e deactivar ils supplements…
    .accesskey = R
menu-help-safe-mode-with-addons =
    .label = Reaviar ed activar ils supplements
    .accesskey = R
# Label of the Help menu item. Either this or
# menu-help-notdeceptive is shown.
menu-help-report-deceptive-site =
    .label = Rapportar ina pagina che engiona…
    .accesskey = E
menu-help-not-deceptive =
    .label = Quai n'è betg ina website che engiona…
    .accesskey = e
