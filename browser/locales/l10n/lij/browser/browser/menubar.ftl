# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## File Menu

menu-file =
    .label = Schedaio
    .accesskey = S
menu-file-new-tab =
    .label = Neuvo feuggio
    .accesskey = N
menu-file-new-container-tab =
    .label = Neuvo feuggio contenitô
    .accesskey = c
menu-file-new-window =
    .label = Neuvo barcon
    .accesskey = N
menu-file-new-private-window =
    .label = Neuvo barcon privòu
    .accesskey = u
# "Open Location" is only displayed on macOS, and only on windows
# that aren't main browser windows, or when there are no windows
# but Firefox is still running.
menu-file-open-location =
    .label = Arvi Indirisso…
menu-file-open-file =
    .label = Arvi schedaio…
    .accesskey = v
menu-file-close =
    .label = Særa
    .accesskey = S
menu-file-close-window =
    .label = Særa o barcon
    .accesskey = S
menu-file-save-page =
    .label = Sarva pagina co-o nomme…
    .accesskey = a
menu-file-email-link =
    .label = Manda colegamento pe pòsta…
    .accesskey = c
menu-file-print-setup =
    .label = Inpòsta pagina…
    .accesskey = I
menu-file-print-preview =
    .label = Anteprimma de Stanpa
    .accesskey = A
menu-file-print =
    .label = Stanpa…
    .accesskey = p
menu-file-import-from-another-browser =
    .label = Inportâ da 'n atro navegatô…
    .accesskey = I
menu-file-go-offline =
    .label = Lòua feua linia
    .accesskey = L

## Edit Menu

menu-edit =
    .label = Cangia
    .accesskey = C
menu-edit-find-on =
    .label = Treuva…
    .accesskey = T
menu-edit-find-again =
    .label = Treuva pròscimo
    .accesskey = T
menu-edit-bidi-switch-text-direction =
    .label = Cangia a direçion do testo
    .accesskey = C

## View Menu

menu-view =
    .label = Fanni vedde
    .accesskey = F
menu-view-toolbars-menu =
    .label = Bare
    .accesskey = B
menu-view-customize-toolbar =
    .label = Personalizza…
    .accesskey = P
menu-view-sidebar =
    .label = Bara de scianco
    .accesskey = e
menu-view-bookmarks =
    .label = Segnalibbri
menu-view-history-button =
    .label = Stöia
menu-view-synced-tabs-sidebar =
    .label = Feuggi scincronizæ
menu-view-full-zoom =
    .label = Zoom
    .accesskey = Z
menu-view-full-zoom-enlarge =
    .label = Aomenta zoom
    .accesskey = A
menu-view-full-zoom-reduce =
    .label = Diminoisci zoom
    .accesskey = o
menu-view-full-zoom-toggle =
    .label = Zoom do solo testo
    .accesskey = t
menu-view-page-style-menu =
    .label = Stile da pagina
    .accesskey = S
menu-view-page-style-no-style =
    .label = No stile
    .accesskey = N
menu-view-page-basic-style =
    .label = Stile de baze da pagina
    .accesskey = b
menu-view-charset =
    .label = Codifica do testo
    .accesskey = C

## These should match what Safari and other Apple applications
## use on macOS.

menu-view-enter-full-screen =
    .label = Amia a tutto schermo
    .accesskey = h
menu-view-exit-full-screen =
    .label = Sciòrti da a tutto schermo
    .accesskey = h
menu-view-full-screen =
    .label = A tutto schermo
    .accesskey = A

##

menu-view-show-all-tabs =
    .label = Fanni vedde tutte e schede
    .accesskey = a
menu-view-bidi-switch-page-direction =
    .label = Cangia a direçion da pagina
    .accesskey = d

## History Menu

menu-history =
    .label = Stöia
    .accesskey = i
menu-history-show-all-history =
    .label = Fanni vedde tutta a stöia
menu-history-clear-recent-history =
    .label = Scancella a stöia ciù neuva…
menu-history-synced-tabs =
    .label = Feuggi scincronizæ
menu-history-restore-last-session =
    .label = Repiggia a vegia sescion
menu-history-hidden-tabs =
    .label = Feuggi ascozi
menu-history-undo-menu =
    .label = Feuggi seræ urtimamente
menu-history-undo-window-menu =
    .label = Barcoin seræ urtimamente

## Bookmarks Menu

menu-bookmarks-menu =
    .label = Segnalibbri
    .accesskey = b
menu-bookmarks-show-all =
    .label = Fanni vedde tutti i segnalibbri
menu-bookmark-this-page =
    .label = Azonzi questa pagina a-i segnalibbri
menu-bookmark-edit =
    .label = Cangia segnalibbro
menu-bookmarks-all-tabs =
    .label = Azonzi tutti i feuggi a-i segnalibbri…
menu-bookmarks-toolbar =
    .label = Bara di segnalibbri
menu-bookmarks-other =
    .label = Atri segnalibbri
menu-bookmarks-mobile =
    .label = Segnalibbri mòbili

## Tools Menu

menu-tools =
    .label = Atressi
    .accesskey = t
menu-tools-downloads =
    .label = Descaregamenti
    .accesskey = D
menu-tools-addons =
    .label = Conponenti azonti
    .accesskey = a
menu-tools-fxa-sign-in =
    .label = Acedi a { -brand-product-name }…
    .accesskey = A
menu-tools-turn-on-sync =
    .label = Ativa { -sync-brand-short-name }…
    .accesskey = A
menu-tools-sync-now =
    .label = Scincronizza òua
    .accesskey = S
menu-tools-web-developer =
    .label = Svilupatô web
    .accesskey = W
menu-tools-page-source =
    .label = Sorgente da Pagina
    .accesskey = o
menu-tools-page-info =
    .label = Informaçioin da pagina
    .accesskey = I
menu-preferences =
    .label =
        { PLATFORM() ->
            [windows] Inpostaçioin
           *[other] Preferense
        }
    .accesskey =
        { PLATFORM() ->
            [windows] o
           *[other] n
        }
menu-tools-layout-debugger =
    .label = Aspeto do Debugger
    .accesskey = A

## Window Menu

menu-window-menu =
    .label = Barcon
menu-window-bring-all-to-front =
    .label = Pòrta tutto in primmo cian

## Help Menu

menu-help =
    .label = Agiutto
    .accesskey = A
menu-help-product =
    .label = Guidda de { -brand-shorter-name }
    .accesskey = G
menu-help-show-tour =
    .label = Vixita guidâ de { -brand-shorter-name }
    .accesskey = o
menu-help-import-from-another-browser =
    .label = Inportâ da 'n atro navegatô…
    .accesskey = d
menu-help-keyboard-shortcuts =
    .label = Scorsaieu da tastea
    .accesskey = S
menu-help-troubleshooting-info =
    .label = Informaçioin in sciâ soluçion di problemi
    .accesskey = I
menu-help-feedback-page =
    .label = Manda comento…
    .accesskey = M
menu-help-safe-mode-without-addons =
    .label = Arvi torna co-i conponenti azonti dizabilitæ
    .accesskey = R
menu-help-safe-mode-with-addons =
    .label = Arvi torna co-i conponente azonti ativæ
    .accesskey = R
# Label of the Help menu item. Either this or
# menu-help-notdeceptive is shown.
menu-help-report-deceptive-site =
    .label = Segnala scito mascarson…
    .accesskey = R
menu-help-not-deceptive =
    .label = Questo o no l'é 'n scito inganevole…
    .accesskey = g
