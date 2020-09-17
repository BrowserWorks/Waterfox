# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## File Menu

menu-file =
    .label = File
    .accesskey = F
menu-file-new-tab =
    .label = Nove scheda
    .accesskey = s
menu-file-new-container-tab =
    .label = Nove scheda contextual
    .accesskey = c
menu-file-new-window =
    .label = Nove fenestra
    .accesskey = N
menu-file-new-private-window =
    .label = Nove fenestra private
    .accesskey = p
# "Open Location" is only displayed on macOS, and only on windows
# that aren't main browser windows, or when there are no windows
# but Firefox is still running.
menu-file-open-location =
    .label = Aperir adresse…
menu-file-open-file =
    .label = Aperir un file…
    .accesskey = A
menu-file-close =
    .label = Clauder
    .accesskey = C
menu-file-close-window =
    .label = Clauder le fenestra
    .accesskey = d
menu-file-save-page =
    .label = Salvar le pagina como…
    .accesskey = v
menu-file-email-link =
    .label = Inviar le ligamine per email…
    .accesskey = l
menu-file-print-setup =
    .label = Configurar le pagina…
    .accesskey = u
menu-file-print-preview =
    .label = Vista preliminar del impression
    .accesskey = v
menu-file-print =
    .label = Imprimer…
    .accesskey = I
menu-file-import-from-another-browser =
    .label = Importar ab un altere navigator…
    .accesskey = I
menu-file-go-offline =
    .label = Travaliar disconnectite
    .accesskey = T

## Edit Menu

menu-edit =
    .label = Edition
    .accesskey = E
menu-edit-find-on =
    .label = Cercar in iste pagina…
    .accesskey = r
menu-edit-find-again =
    .label = Cercar le sequente
    .accesskey = n
menu-edit-bidi-switch-text-direction =
    .label = Cambiar le direction del texto
    .accesskey = a

## View Menu

menu-view =
    .label = Vider
    .accesskey = V
menu-view-toolbars-menu =
    .label = Barras de instrumentos
    .accesskey = B
menu-view-customize-toolbar =
    .label = Personalisar…
    .accesskey = P
menu-view-sidebar =
    .label = Barra lateral
    .accesskey = l
menu-view-bookmarks =
    .label = Marcapaginas
menu-view-history-button =
    .label = Chronologia
menu-view-synced-tabs-sidebar =
    .label = Schedas synchronisate
menu-view-full-zoom =
    .label = Zoom
    .accesskey = Z
menu-view-full-zoom-enlarge =
    .label = Zoom avante
    .accesskey = A
menu-view-full-zoom-reduce =
    .label = Zoom retro
    .accesskey = R
menu-view-full-zoom-actual-size =
    .label = Dimension actual
    .accesskey = a
menu-view-full-zoom-toggle =
    .label = Zoom del texto solmente
    .accesskey = t
menu-view-page-style-menu =
    .label = Stilo del pagina
    .accesskey = S
menu-view-page-style-no-style =
    .label = Nulle stilo
    .accesskey = n
menu-view-page-basic-style =
    .label = Stilo basic del pagina
    .accesskey = b
menu-view-charset =
    .label = Codification del texto
    .accesskey = C

## These should match what Safari and other Apple applications
## use on macOS.

menu-view-enter-full-screen =
    .label = Entrar in plen schermo
    .accesskey = E
menu-view-exit-full-screen =
    .label = Exir del plen schermo
    .accesskey = E
menu-view-full-screen =
    .label = Plen schermo
    .accesskey = P

##

menu-view-show-all-tabs =
    .label = Monstrar tote le schedas
    .accesskey = A
menu-view-bidi-switch-page-direction =
    .label = Cambiar le direction del pagina
    .accesskey = D

## History Menu

menu-history =
    .label = Chronologia
    .accesskey = C
menu-history-show-all-history =
    .label = Monstrar tote le chronologia
menu-history-clear-recent-history =
    .label = Vacuar le chronologia recente…
menu-history-synced-tabs =
    .label = Schedas synchronisate
menu-history-restore-last-session =
    .label = Restaurar le session previe
menu-history-hidden-tabs =
    .label = Schedas celate
menu-history-undo-menu =
    .label = Schedas claudite recentemente
menu-history-undo-window-menu =
    .label = Fenestras claudite recentemente

## Bookmarks Menu

menu-bookmarks-menu =
    .label = Marcapaginas
    .accesskey = M
menu-bookmarks-show-all =
    .label = Monstrar tote le marcapaginas
menu-bookmark-this-page =
    .label = Adder un marcapaginas
menu-bookmark-edit =
    .label = Modificar iste marcapaginas
menu-bookmarks-all-tabs =
    .label = Adder marcapaginas sur tote le schedas…
menu-bookmarks-toolbar =
    .label = Barra de marcapaginas
menu-bookmarks-other =
    .label = Altere marcapaginas
menu-bookmarks-mobile =
    .label = Marcapaginas del apparatos mobile

## Tools Menu

menu-tools =
    .label = Instrumentos
    .accesskey = I
menu-tools-downloads =
    .label = Discargamentos
    .accesskey = D
menu-tools-addons =
    .label = Additivos
    .accesskey = A
menu-tools-fxa-sign-in =
    .label = Aperir session in { -brand-product-name }…
    .accesskey = A
menu-tools-turn-on-sync =
    .label = Activar { -sync-brand-short-name }…
    .accesskey = A
menu-tools-sync-now =
    .label = Synchronisar ora
    .accesskey = S
menu-tools-fxa-re-auth =
    .label = Reconnecter se a { -brand-product-name }…
    .accesskey = R
menu-tools-web-developer =
    .label = Disveloppamento web
    .accesskey = W
menu-tools-page-source =
    .label = Codice fonte del pagina
    .accesskey = f
menu-tools-page-info =
    .label = Informationes del pagina
    .accesskey = I
menu-preferences =
    .label =
        { PLATFORM() ->
            [windows] Optiones
           *[other] Preferentias
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
menu-tools-layout-debugger =
    .label = Depurator de disposition
    .accesskey = D

## Window Menu

menu-window-menu =
    .label = Fenestra
menu-window-bring-all-to-front =
    .label = Traher toto al avante

## Help Menu

menu-help =
    .label = Adjuta
    .accesskey = A
menu-help-product =
    .label = Adjuta de { -brand-shorter-name }
    .accesskey = A
menu-help-show-tour =
    .label = Visita guidate de { -brand-shorter-name }
    .accesskey = V
menu-help-import-from-another-browser =
    .label = Importar ab un altere navigator…
    .accesskey = I
menu-help-keyboard-shortcuts =
    .label = Claves de accesso directe
    .accesskey = C
menu-help-troubleshooting-info =
    .label = Informationes de diagnostico
    .accesskey = I
menu-help-feedback-page =
    .label = Submitter tu opinion…
    .accesskey = S
menu-help-safe-mode-without-addons =
    .label = Reinitiar con le additivos inactive…
    .accesskey = R
menu-help-safe-mode-with-addons =
    .label = Reinitiar con le additivos active
    .accesskey = R
# Label of the Help menu item. Either this or
# menu-help-notdeceptive is shown.
menu-help-report-deceptive-site =
    .label = Denunciar un sito fraudulente…
    .accesskey = D
menu-help-not-deceptive =
    .label = Iste sito non es fraudulente…
    .accesskey = d
