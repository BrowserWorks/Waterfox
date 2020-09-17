# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## File Menu

menu-file =
    .label = Fichièr
    .accesskey = F
menu-file-new-tab =
    .label = Onglet novèl
    .accesskey = t
menu-file-new-container-tab =
    .label = Onglet contèxtual novèl
    .accesskey = t
menu-file-new-window =
    .label = Fenèstra novèla
    .accesskey = n
menu-file-new-private-window =
    .label = Novèla fenèstra de navegacion privada
    .accesskey = N
# "Open Location" is only displayed on macOS, and only on windows
# that aren't main browser windows, or when there are no windows
# but Firefox is still running.
menu-file-open-location =
    .label = Dobrir l’emplaçament…
menu-file-open-file =
    .label = Dobrir un fichièr…
    .accesskey = o
menu-file-close =
    .label = Tampar
    .accesskey = a
menu-file-close-window =
    .label = Tampar la fenèstra
    .accesskey = f
menu-file-save-page =
    .label = Enregistrar jos…
    .accesskey = E
menu-file-email-link =
    .label = Enviar per corrièl lo ligam d’aquesta pagina…
    .accesskey = E
menu-file-print-setup =
    .label = Mesa en pagina…
    .accesskey = M
menu-file-print-preview =
    .label = Apercebut abans impression
    .accesskey = A
menu-file-print =
    .label = Imprimir…
    .accesskey = i
menu-file-import-from-another-browser =
    .label = Importar d’un autre navegador…
    .accesskey = I
menu-file-go-offline =
    .label = Trabalhar fòra connexion
    .accesskey = T

## Edit Menu

menu-edit =
    .label = Edicion
    .accesskey = E
menu-edit-find-on =
    .label = Recercar dins la pagina…
    .accesskey = R
menu-edit-find-again =
    .label = Recercar lo seguent
    .accesskey = g
menu-edit-bidi-switch-text-direction =
    .label = Cambiar lo sens del tèxte
    .accesskey = x

## View Menu

menu-view =
    .label = Afichatge
    .accesskey = f
menu-view-toolbars-menu =
    .label = Barras d'aisinas
    .accesskey = s
menu-view-customize-toolbar =
    .label = Personalizar…
    .accesskey = P
menu-view-sidebar =
    .label = Panèl lateral
    .accesskey = e
menu-view-bookmarks =
    .label = Marcapaginas
menu-view-history-button =
    .label = Istoric
menu-view-synced-tabs-sidebar =
    .label = Onglets sincronizats
menu-view-full-zoom =
    .label = Zoom
    .accesskey = Z
menu-view-full-zoom-enlarge =
    .label = Zoom avant
    .accesskey = v
menu-view-full-zoom-reduce =
    .label = Zoom arrièr
    .accesskey = r
menu-view-full-zoom-actual-size =
    .label = Talha reala
    .accesskey = a
menu-view-full-zoom-toggle =
    .label = Zoom tèxte solament
    .accesskey = x
menu-view-page-style-menu =
    .label = Estil de la pagina
    .accesskey = i
menu-view-page-style-no-style =
    .label = Pas cap d'estil
    .accesskey = P
menu-view-page-basic-style =
    .label = Estil de pagina basic
    .accesskey = b
menu-view-charset =
    .label = Encodatge del tèxte
    .accesskey = E

## These should match what Safari and other Apple applications
## use on macOS.

menu-view-enter-full-screen =
    .label = Passar en mòde ecran complet
    .accesskey = c
menu-view-exit-full-screen =
    .label = Quitar lo mòde Ecran complet
    .accesskey = p
menu-view-full-screen =
    .label = Ecran complet
    .accesskey = p

##

menu-view-show-all-tabs =
    .label = Afichar totes los onglets
    .accesskey = A
menu-view-bidi-switch-page-direction =
    .label = Cambiar lo sens de la pagina
    .accesskey = g

## History Menu

menu-history =
    .label = Istoric
    .accesskey = s
menu-history-show-all-history =
    .label = Afichar tot l'istoric
menu-history-clear-recent-history =
    .label = Suprimir l'istoric recent…
menu-history-synced-tabs =
    .label = Onglets sincronizats
menu-history-restore-last-session =
    .label = Restablir la session precedenta
menu-history-hidden-tabs =
    .label = Onglets amagats
menu-history-undo-menu =
    .label = Onglets tampats recentament
menu-history-undo-window-menu =
    .label = Fenèstras tampadas recentament

## Bookmarks Menu

menu-bookmarks-menu =
    .label = Marcapaginas
    .accesskey = M
menu-bookmarks-show-all =
    .label = Afichar totes los marcapaginas
menu-bookmark-this-page =
    .label = Marcar aquesta pagina
menu-bookmark-edit =
    .label = Modificar aqueste marcapagina
menu-bookmarks-all-tabs =
    .label = Marcar totes los onglets…
menu-bookmarks-toolbar =
    .label = Barra personala
menu-bookmarks-other =
    .label = Autres marcapaginas
menu-bookmarks-mobile =
    .label = Marcapaginas del mobile

## Tools Menu

menu-tools =
    .label = Aisinas
    .accesskey = A
menu-tools-downloads =
    .label = Telecargaments
    .accesskey = T
menu-tools-addons =
    .label = Moduls complementaris
    .accesskey = M
menu-tools-fxa-sign-in =
    .label = Se connectar a { -brand-product-name }…
    .accesskey = c
menu-tools-turn-on-sync =
    .label = Activar { -sync-brand-short-name }
    .accesskey = a
menu-tools-sync-now =
    .label = Sincronizar ara
    .accesskey = S
menu-tools-fxa-re-auth =
    .label = Se reconnectar a { -brand-product-name }…
    .accesskey = r
menu-tools-web-developer =
    .label = Desvolopaire web
    .accesskey = w
menu-tools-page-source =
    .label = Còdi font de la pagina
    .accesskey = C
menu-tools-page-info =
    .label = Informacion sus la pagina
    .accesskey = I
menu-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opcions
           *[other] Preferéncias
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] f
        }
menu-tools-layout-debugger =
    .label = Desbugador de disposicion
    .accesskey = d

## Window Menu

menu-window-menu =
    .label = Tot menar al primièr plan
menu-window-bring-all-to-front =
    .label = Tot menar al primièr plan

## Help Menu

menu-help =
    .label = Ajuda
    .accesskey = u
menu-help-product =
    .label = Ajuda de { -brand-shorter-name }
    .accesskey = u
menu-help-show-tour =
    .label = Visita guidada de { -brand-shorter-name }
    .accesskey = V
menu-help-import-from-another-browser =
    .label = Importar d’un autre navegador…
    .accesskey = I
menu-help-keyboard-shortcuts =
    .label = Acorchis de clavièr
    .accesskey = c
menu-help-troubleshooting-info =
    .label = Informacions de depanatge
    .accesskey = d
menu-help-feedback-page =
    .label = Balhar vòstre vejaire…
    .accesskey = B
menu-help-safe-mode-without-addons =
    .label = Reaviar amb los moduls desactivats…
    .accesskey = R
menu-help-safe-mode-with-addons =
    .label = Reaviar, moduls activats…
    .accesskey = R
# Label of the Help menu item. Either this or
# menu-help-notdeceptive is shown.
menu-help-report-deceptive-site =
    .label = Senhalar un site enganaire…
    .accesskey = S
menu-help-not-deceptive =
    .label = Es pas un site malvolent…
    .accesskey = m
