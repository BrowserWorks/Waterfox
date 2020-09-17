# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## File Menu

menu-file =
    .label = Archivo
    .accesskey = A
menu-file-new-tab =
    .label = Nueva pestaña
    .accesskey = t
menu-file-new-container-tab =
    .label = Nueva pestaña contenedora
    .accesskey = C
menu-file-new-window =
    .label = Nueva ventana
    .accesskey = N
menu-file-new-private-window =
    .label = Nueva ventana privada
    .accesskey = W
# "Open Location" is only displayed on macOS, and only on windows
# that aren't main browser windows, or when there are no windows
# but Firefox is still running.
menu-file-open-location =
    .label = Abrir ubicación…
menu-file-open-file =
    .label = Abrir archivo…
    .accesskey = o
menu-file-close =
    .label = Cerrar
    .accesskey = C
menu-file-close-window =
    .label = Cerrar ventana
    .accesskey = C
menu-file-save-page =
    .label = Guardar página como…
    .accesskey = a
menu-file-email-link =
    .label = Enviar enlace por email
    .accesskey = E
menu-file-print-setup =
    .label = Configuración de página…
    .accesskey = u
menu-file-print-preview =
    .label = Vista previa
    .accesskey = V
menu-file-print =
    .label = Imprimir…
    .accesskey = p
menu-file-import-from-another-browser =
    .label = Importar desde otro navegador…
    .accesskey = I
menu-file-go-offline =
    .label = Trabajar desconectado
    .accesskey = j

## Edit Menu

menu-edit =
    .label = Editar
    .accesskey = E
menu-edit-find-on =
    .label = Buscar en esta página…
    .accesskey = B
menu-edit-find-again =
    .label = Volver a buscar
    .accesskey = B
menu-edit-bidi-switch-text-direction =
    .label = Cambiar dirección del texto
    .accesskey = C

## View Menu

menu-view =
    .label = Ver
    .accesskey = V
menu-view-toolbars-menu =
    .label = Barras de herramientas
    .accesskey = t
menu-view-customize-toolbar =
    .label = Personalizar…
    .accesskey = P
menu-view-sidebar =
    .label = Barra lateral
    .accesskey = e
menu-view-bookmarks =
    .label = Marcadores
menu-view-history-button =
    .label = Historial
menu-view-synced-tabs-sidebar =
    .label = Pestañas sincronizadas
menu-view-full-zoom =
    .label = Acercar
    .accesskey = A
menu-view-full-zoom-enlarge =
    .label = Acercar
    .accesskey = A
menu-view-full-zoom-reduce =
    .label = Alejar
    .accesskey = A
menu-view-full-zoom-actual-size =
    .label = Tamaño real
    .accesskey = A
menu-view-full-zoom-toggle =
    .label = Zoom solo en el texto
    .accesskey = t
menu-view-page-style-menu =
    .label = Estilo de página
    .accesskey = E
menu-view-page-style-no-style =
    .label = Sin estilo
    .accesskey = n
menu-view-page-basic-style =
    .label = Estilo básico de página
    .accesskey = b
menu-view-charset =
    .label = Codificación del texto
    .accesskey = c

## These should match what Safari and other Apple applications
## use on macOS.

menu-view-enter-full-screen =
    .label = Pasar a pantalla completa
    .accesskey = F
menu-view-exit-full-screen =
    .label = Salir de pantalla completa
    .accesskey = F
menu-view-full-screen =
    .label = Pantalla completa
    .accesskey = l

##

menu-view-show-all-tabs =
    .label = Mostrar todas las pestañas
    .accesskey = a
menu-view-bidi-switch-page-direction =
    .label = Cambiar dirección de la página
    .accesskey = g

## History Menu

menu-history =
    .label = Historial
    .accesskey = s
menu-history-show-all-history =
    .label = Mostrar todo el historial
menu-history-clear-recent-history =
    .label = Limpiar el historial reciente…
menu-history-synced-tabs =
    .label = Pestañas sincronizadas
menu-history-restore-last-session =
    .label = Restaurar sesión anterior
menu-history-hidden-tabs =
    .label = Pestañas ocultas
menu-history-undo-menu =
    .label = Pestañas cerradas recientemente
menu-history-undo-window-menu =
    .label = Ventanas cerradas recientemente

## Bookmarks Menu

menu-bookmarks-menu =
    .label = Marcadores
    .accesskey = M
menu-bookmarks-show-all =
    .label = Mostrar todos los marcadores
menu-bookmark-this-page =
    .label = Guardar esta página en marcadores
menu-bookmark-edit =
    .label = Editar este marcador
menu-bookmarks-all-tabs =
    .label = Guardar todas las pestañas en marcadores…
menu-bookmarks-toolbar =
    .label = Barra de marcadores
menu-bookmarks-other =
    .label = Otros marcadores
menu-bookmarks-mobile =
    .label = Marcadores en dispositivo móvil

## Tools Menu

menu-tools =
    .label = Herramientas
    .accesskey = t
menu-tools-downloads =
    .label = Descargas
    .accesskey = D
menu-tools-addons =
    .label = Complementos
    .accesskey = o
menu-tools-fxa-sign-in =
    .label = Conectarse a { -brand-product-name }…
    .accesskey = g
menu-tools-turn-on-sync =
    .label = Activar { -sync-brand-short-name }…
    .accesskey = n
menu-tools-sync-now =
    .label = Sincronizar ahora
    .accesskey = S
menu-tools-fxa-re-auth =
    .label = Reconectar a { -brand-product-name }…
    .accesskey = R
menu-tools-web-developer =
    .label = Desarrollador web
    .accesskey = w
menu-tools-page-source =
    .label = Código fuente de la página
    .accesskey = o
menu-tools-page-info =
    .label = Información de la página
    .accesskey = I
menu-preferences =
    .label =
        { PLATFORM() ->
            [windows] Opciones
           *[other] Preferencias
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] n
        }
menu-tools-layout-debugger =
    .label = Depurador de diseño
    .accesskey = L

## Window Menu

menu-window-menu =
    .label = Ventana
menu-window-bring-all-to-front =
    .label = Traer todo hacia al frente

## Help Menu

menu-help =
    .label = Ayuda
    .accesskey = H
menu-help-product =
    .label = Ayuda de { -brand-shorter-name }
    .accesskey = H
menu-help-show-tour =
    .label = Tour de { -brand-shorter-name }
    .accesskey = o
menu-help-import-from-another-browser =
    .label = Importar desde otro navegador…
    .accesskey = I
menu-help-keyboard-shortcuts =
    .label = Atajos del teclado
    .accesskey = K
menu-help-troubleshooting-info =
    .label = Información para resolver problemas
    .accesskey = T
menu-help-feedback-page =
    .label = Enviar comentarios…
    .accesskey = s
menu-help-safe-mode-without-addons =
    .label = Reiniciar con los complementos deshabilitados…
    .accesskey = R
menu-help-safe-mode-with-addons =
    .label = Reiniciar con los complementos habilitados…
    .accesskey = R
# Label of the Help menu item. Either this or
# menu-help-notdeceptive is shown.
menu-help-report-deceptive-site =
    .label = Reportar sitio fraudulento…
    .accesskey = F
menu-help-not-deceptive =
    .label = Este no es un sitio fraudulento…
    .accesskey = d
