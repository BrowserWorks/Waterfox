# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## File Menu

menu-file =
    .label = Ficheru
    .accesskey = F
menu-file-new-tab =
    .label = Llingüeta nueva
    .accesskey = L
menu-file-new-container-tab =
    .label = Llingüeta contenedora nueva
    .accesskey = c
menu-file-new-window =
    .label = Ventana nueva
    .accesskey = n
menu-file-new-private-window =
    .label = Ventana privada nueva
    .accesskey = p
# "Open Location" is only displayed on macOS, and only on windows
# that aren't main browser windows, or when there are no windows
# but Firefox is still running.
menu-file-open-location =
    .label = Abrir allugamientu…
menu-file-open-file =
    .label = Abrir ficheru…
    .accesskey = A
menu-file-close =
    .label = Zarrar
    .accesskey = Z
menu-file-close-window =
    .label = Zarrar ventana
    .accesskey = v
menu-file-save-page =
    .label = Guardar páxina como…
    .accesskey = A
menu-file-email-link =
    .label = Unviar enllaz…
    .accesskey = U
menu-file-print-setup =
    .label = Configuración de páxina…
    .accesskey = C
menu-file-print-preview =
    .label = Previsualización
    .accesskey = P
menu-file-print =
    .label = Imprentar…
    .accesskey = I
menu-file-go-offline =
    .label = Trabayar ensin conexón
    .accesskey = y

## Edit Menu

menu-edit =
    .label = Editar
    .accesskey = E
menu-edit-find-on =
    .label = Alcontrar nesta páxina…
    .accesskey = G
menu-edit-find-again =
    .label = Alcontrar de nueves
    .accesskey = e
menu-edit-bidi-switch-text-direction =
    .label = Camudar direición del testu
    .accesskey = d

## View Menu

menu-view =
    .label = Ver
    .accesskey = V
menu-view-toolbars-menu =
    .label = Barres de ferramientes
    .accesskey = B
menu-view-customize-toolbar =
    .label = Personalizar…
    .accesskey = P
menu-view-sidebar =
    .label = Panel llateral
    .accesskey = a
menu-view-bookmarks =
    .label = Marcadores
menu-view-history-button =
    .label = Historial
menu-view-synced-tabs-sidebar =
    .label = Llingüetes sincronizaes
menu-view-full-zoom =
    .label = Zoom
    .accesskey = m
menu-view-full-zoom-enlarge =
    .label = Averar
    .accesskey = A
menu-view-full-zoom-reduce =
    .label = Alloñar
    .accesskey = O
menu-view-full-zoom-toggle =
    .label = Namái facer zoom al testu
    .accesskey = T
menu-view-page-style-menu =
    .label = Estilu de páxina
    .accesskey = x
menu-view-page-style-no-style =
    .label = Ensin estilu
    .accesskey = n
menu-view-page-basic-style =
    .label = Estilu de páxina básicu
    .accesskey = b
menu-view-charset =
    .label = Codificación de caráuteres
    .accesskey = C

## These should match what Safari and other Apple applications
## use on macOS.

menu-view-enter-full-screen =
    .label = Poner a pantalla completa
    .accesskey = P
menu-view-exit-full-screen =
    .label = Colar de pantalla completa
    .accesskey = C
menu-view-full-screen =
    .label = Pantalla completa
    .accesskey = C

##

menu-view-show-all-tabs =
    .label = Amosar toles llingüetes
    .accesskey = t
menu-view-bidi-switch-page-direction =
    .label = Camudar direición de la páxina
    .accesskey = D

## History Menu

menu-history =
    .label = Historial
    .accesskey = s
menu-history-show-all-history =
    .label = Amosar tol historial
menu-history-clear-recent-history =
    .label = Llimpiar l'historial recién…
menu-history-synced-tabs =
    .label = Llingüetes sincronizaes
menu-history-restore-last-session =
    .label = Restaurar sesión previa
menu-history-undo-menu =
    .label = Llingüetes zarraes apocayá
menu-history-undo-window-menu =
    .label = Ventanes zarraes apocayá

## Bookmarks Menu

menu-bookmarks-menu =
    .label = Marcadores
    .accesskey = M
menu-bookmarks-show-all =
    .label = Amosar tolos marcadores
menu-bookmark-this-page =
    .label = Amestar esta páxina a marcadores
menu-bookmark-edit =
    .label = Editar esti marcador
menu-bookmarks-all-tabs =
    .label = Amestar toles llingüetes a marcadores…
menu-bookmarks-toolbar =
    .label = Barra de ferramientes de marcadores
menu-bookmarks-other =
    .label = Otros marcadores
menu-bookmarks-mobile =
    .label = Marcadores del móvil

## Tools Menu

menu-tools =
    .label = Ferramientes
    .accesskey = F
menu-tools-downloads =
    .label = Descargues
    .accesskey = D
menu-tools-addons =
    .label = Complementos
    .accesskey = C
menu-tools-sync-now =
    .label = Sincronizar agora
    .accesskey = z
menu-tools-web-developer =
    .label = Desendolcador web
    .accesskey = W
menu-tools-page-source =
    .label = Códigu fonte de la páxina
    .accesskey = o
menu-tools-page-info =
    .label = Información de páxina
    .accesskey = I
menu-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opciones
           *[other] Preferencies
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] n
        }

## Window Menu

menu-window-menu =
    .label = Ventana
menu-window-bring-all-to-front =
    .label = Trayer too al frente

## Help Menu

menu-help =
    .label = Ayuda
    .accesskey = A
menu-help-product =
    .label = Ayuda de { -brand-shorter-name }
    .accesskey = A
menu-help-show-tour =
    .label = Percorríu per { -brand-shorter-name }
    .accesskey = P
menu-help-keyboard-shortcuts =
    .label = Atayos de tecláu
    .accesskey = t
menu-help-troubleshooting-info =
    .label = Información d'igua de problemes
    .accesskey = i
menu-help-feedback-page =
    .label = Unviar feedback…
    .accesskey = U
menu-help-safe-mode-without-addons =
    .label = Reaniciar colos complementos desactivaos…
    .accesskey = R
menu-help-safe-mode-with-addons =
    .label = Reaniciar colos complementos activaos
    .accesskey = R
# Label of the Help menu item. Either this or
# safeb.palm.notdeceptive.label from
# phishing-afterload-warning-message.dtd is shown.
menu-help-report-deceptive-site =
    .label = Reportar sitiu fraudulentu…
    .accesskey = R
menu-help-not-deceptive =
    .label = Esti nun ye un sitiu fraudulentu…
    .accesskey = f
