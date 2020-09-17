# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## File Menu

menu-file =
    .label = Fichero
    .accesskey = F
menu-file-new-tab =
    .label = Nueva pestanya
    .accesskey = t
menu-file-new-container-tab =
    .label = Nueva pestanya de contenedor
    .accesskey = c
menu-file-new-window =
    .label = Nueva finestra
    .accesskey = N
menu-file-new-private-window =
    .label = Nueva finestra privada
    .accesskey = p
# "Open Location" is only displayed on macOS, and only on windows
# that aren't main browser windows, or when there are no windows
# but Firefox is still running.
menu-file-open-location =
    .label = Ubrir a ubicación...
menu-file-open-file =
    .label = Ubrir un fichero…
    .accesskey = U
menu-file-close =
    .label = Zarrar
    .accesskey = Z
menu-file-close-window =
    .label = Zarrar a finestra
    .accesskey = f
menu-file-save-page =
    .label = Alzar a pachina como…
    .accesskey = a
menu-file-email-link =
    .label = Ninviar vinclo por correu…
    .accesskey = e
menu-file-print-setup =
    .label = Configurar pachina…
    .accesskey = f
menu-file-print-preview =
    .label = Previsualización
    .accesskey = r
menu-file-print =
    .label = Imprentar…
    .accesskey = m
menu-file-import-from-another-browser =
    .label = Importar datos de belatro navegador…
    .accesskey = I
menu-file-go-offline =
    .label = Treballar difuera de linia
    .accesskey = d

## Edit Menu

menu-edit =
    .label = Editar
    .accesskey = E
menu-edit-find-on =
    .label = Trobar en esta pachina…
    .accesskey = T
menu-edit-find-again =
    .label = Tornar a mirar
    .accesskey = o
menu-edit-bidi-switch-text-direction =
    .label = Cambiar o sentiu d'o texto
    .accesskey = b

## View Menu

menu-view =
    .label = Veyer
    .accesskey = V
menu-view-toolbars-menu =
    .label = Barras de ferramientas
    .accesskey = t
menu-view-customize-toolbar =
    .label = Personalizar…
    .accesskey = P
menu-view-sidebar =
    .label = Panel lateral
    .accesskey = e
menu-view-bookmarks =
    .label = Marcapachinas
menu-view-history-button =
    .label = Historial
menu-view-synced-tabs-sidebar =
    .label = Pestanyas sincronizadas
menu-view-full-zoom =
    .label = Mida d'a pachina
    .accesskey = d
menu-view-full-zoom-enlarge =
    .label = Agrandir
    .accesskey = A
menu-view-full-zoom-reduce =
    .label = Achiquir
    .accesskey = q
menu-view-full-zoom-actual-size =
    .label = Mida real
    .accesskey = a
menu-view-full-zoom-toggle =
    .label = Nomás agrandir o texto
    .accesskey = i
menu-view-page-style-menu =
    .label = Estilo de pachina
    .accesskey = i
menu-view-page-style-no-style =
    .label = Sin estilo
    .accesskey = n
menu-view-page-basic-style =
    .label = Estilo de pachina basico
    .accesskey = b
menu-view-charset =
    .label = Codificación d'o texto
    .accesskey = C

## These should match what Safari and other Apple applications
## use on macOS.

menu-view-enter-full-screen =
    .label = Activar a pantalla completa
    .accesskey = p
menu-view-exit-full-screen =
    .label = Desactivar a pantalla completa
    .accesskey = p
menu-view-full-screen =
    .label = Pantalla completa
    .accesskey = P

##

menu-view-show-all-tabs =
    .label = Amostrar todas as pestanyas
    .accesskey = a
menu-view-bidi-switch-page-direction =
    .label = Cambiar o sentiu d'a pachina
    .accesskey = d

## History Menu

menu-history =
    .label = Historial
    .accesskey = s
menu-history-show-all-history =
    .label = Amostrar tot l'historial
menu-history-clear-recent-history =
    .label = Borrar o historial recient…
menu-history-synced-tabs =
    .label = Pestanyas sincronizadas
menu-history-restore-last-session =
    .label = Restaurar a sesión anterior
menu-history-hidden-tabs =
    .label = Pestanyas amagadas
menu-history-undo-menu =
    .label = Pestanyas zarradas en zagueras
menu-history-undo-window-menu =
    .label = Finestras zarradas en zagueras

## Bookmarks Menu

menu-bookmarks-menu =
    .label = Marcapachinas
    .accesskey = c
menu-bookmarks-show-all =
    .label = Amostrar totz os marcapachinas
menu-bookmark-this-page =
    .label = Marcar ista pachina con marcapachinas
menu-bookmark-edit =
    .label = Editar iste marcapachinas
menu-bookmarks-all-tabs =
    .label = Adhibir pestanyas ta marcapachinas…
menu-bookmarks-toolbar =
    .label = Barra de ferramientas de marcapachinas
menu-bookmarks-other =
    .label = Atros marcapachinas
menu-bookmarks-mobile =
    .label = Marcapachinas d'o mobil

## Tools Menu

menu-tools =
    .label = Ferramientas
    .accesskey = t
menu-tools-downloads =
    .label = Descargas
    .accesskey = D
menu-tools-addons =
    .label = Complementos
    .accesskey = C
menu-tools-fxa-sign-in =
    .label = Iniciar sesión en { -brand-product-name }
    .accesskey = n
menu-tools-turn-on-sync =
    .label = Enchegar { -sync-brand-short-name }…
    .accesskey = n
menu-tools-sync-now =
    .label = Sincronizar agora
    .accesskey = z
menu-tools-fxa-re-auth =
    .label = Reconnectar a { -brand-product-name }…
    .accesskey = R
menu-tools-web-developer =
    .label = Desembolicador web
    .accesskey = w
menu-tools-page-source =
    .label = Codigo fuent d'a pachina
    .accesskey = o
menu-tools-page-info =
    .label = Información d'a pachina
    .accesskey = I
menu-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opcions
           *[other] Preferencias
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] n
        }
menu-tools-layout-debugger =
    .label = Depurador de disenyo
    .accesskey = L

## Window Menu

menu-window-menu =
    .label = Finestra
menu-window-bring-all-to-front =
    .label = Trayer tot ta debant

## Help Menu

menu-help =
    .label = Aduya
    .accesskey = u
menu-help-product =
    .label = Aduya d'o { -brand-shorter-name }
    .accesskey = A
menu-help-show-tour =
    .label = Vesita guiada por { -brand-shorter-name }
    .accesskey = s
menu-help-import-from-another-browser =
    .label = Importar dende belatro navegador…
    .accesskey = I
menu-help-keyboard-shortcuts =
    .label = Alcorces de teclau
    .accesskey = t
menu-help-troubleshooting-info =
    .label = Información pa solucionar problemas
    .accesskey = f
menu-help-feedback-page =
    .label = Ninviar una opinión…
    .accesskey = v
menu-help-safe-mode-without-addons =
    .label = Reiniciar con os complementos desactivaus…
    .accesskey = R
menu-help-safe-mode-with-addons =
    .label = Reiniciar con os complementos activaus
    .accesskey = R
# Label of the Help menu item. Either this or
# menu-help-notdeceptive is shown.
menu-help-report-deceptive-site =
    .label = Informar de puesto malicioso…
    .accesskey = I
menu-help-not-deceptive =
    .label = Iste no ye un puesto malicioso…
    .accesskey = m
