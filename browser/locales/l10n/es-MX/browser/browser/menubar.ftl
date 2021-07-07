# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# NOTE: For English locales, strings in this file should be in APA-style Title Case.
# See https://apastyle.apa.org/style-grammar-guidelines/capitalization/title-case
#
# NOTE: For Engineers, please don't re-use these strings outside of the menubar.


## Application Menu (macOS only)

menu-application-preferences =
    .label = Preferencias
menu-application-services =
    .label = Servicios
menu-application-hide-this =
    .label = Ocultar { -brand-shorter-name }
menu-application-hide-other =
    .label = Ocultar otros
menu-application-show-all =
    .label = Mostrar todo
menu-application-touch-bar =
    .label = Personalizar barra táctil…

##

# These menu-quit strings are only used on Windows and Linux.
menu-quit =
    .label =
        { PLATFORM() ->
            [windows] Salir
           *[other] Salir
        }
    .accesskey =
        { PLATFORM() ->
            [windows] S
           *[other] S
        }

# This menu-quit-mac string is only used on macOS.
menu-quit-mac =
    .label = Salir de { -brand-shorter-name }

# This menu-quit-button string is only used on Linux.
menu-quit-button =
    .label = { menu-quit.label }

# This menu-quit-button-win string is only used on Windows.
menu-quit-button-win =
    .label = { menu-quit.label }
    .tooltip = Salir de { -brand-shorter-name }

menu-about =
    .label = Acerca de { -brand-shorter-name }
    .accesskey = A

## File Menu

menu-file =
    .label = Archivo
    .accesskey = A
menu-file-new-tab =
    .label = Nueva pestaña
    .accesskey = t
menu-file-new-container-tab =
    .label = Nueva pestaña contenedora
    .accesskey = c
menu-file-new-window =
    .label = Nueva ventana
    .accesskey = N
menu-file-new-private-window =
    .label = Nueva ventana privada
    .accesskey = p
# "Open Location" is only displayed on macOS, and only on windows
# that aren't main browser windows, or when there are no windows
# but Waterfox is still running.
menu-file-open-location =
    .label = Abrir ubicación…
menu-file-open-file =
    .label = Abrir archivo…
    .accesskey = A
menu-file-close =
    .label = Cerrar
    .accesskey = C
menu-file-close-window =
    .label = Cerrar ventana
    .accesskey = v
menu-file-save-page =
    .label = Guardar como…
    .accesskey = G
menu-file-email-link =
    .label = Enviar enlace…
    .accesskey = E
menu-file-share-url =
    .label = Compartir
    .accesskey = C
menu-file-print-setup =
    .label = Configurar página…
    .accesskey = p
menu-file-print-preview =
    .label = Vista previa
    .accesskey = l
menu-file-print =
    .label = Imprimir…
    .accesskey = I
menu-file-import-from-another-browser =
    .label = Importar desde otro navegador…
    .accesskey = I
menu-file-go-offline =
    .label = Trabajar sin conexión
    .accesskey = x

## Edit Menu

menu-edit =
    .label = Editar
    .accesskey = E
menu-edit-find-in-page =
    .label = Buscar en la página…
    .accesskey = F
menu-edit-find-again =
    .label = Repetir la búsqueda
    .accesskey = R
menu-edit-bidi-switch-text-direction =
    .label = Cambiar la orientación del texto
    .accesskey = o

## View Menu

menu-view =
    .label = Ver
    .accesskey = V
menu-view-toolbars-menu =
    .label = Barras de herramientas
    .accesskey = h
menu-view-customize-toolbar2 =
    .label = Personalizar barra de herramientas…
    .accesskey = C
menu-view-sidebar =
    .label = Barra lateral
    .accesskey = l
menu-view-bookmarks =
    .label = Marcadores
menu-view-history-button =
    .label = Historial
menu-view-synced-tabs-sidebar =
    .label = Pestañas sincronizadas
menu-view-full-zoom =
    .label = Tamaño
    .accesskey = T
menu-view-full-zoom-enlarge =
    .label = Aumentar
    .accesskey = A
menu-view-full-zoom-reduce =
    .label = Reducir
    .accesskey = R
menu-view-full-zoom-actual-size =
    .label = Tamaño actual
    .accesskey = T
menu-view-full-zoom-toggle =
    .label = Solo cambiar texto
    .accesskey = S
menu-view-page-style-menu =
    .label = Estilo de página
    .accesskey = E
menu-view-page-style-no-style =
    .label = Deshabilitar
    .accesskey = D
menu-view-page-basic-style =
    .label = Básico
    .accesskey = B
menu-view-repair-text-encoding =
    .label = Reparar la codificación de texto
    .accesskey = c

## These should match what Safari and other Apple applications
## use on macOS.

menu-view-enter-full-screen =
    .label = Iniciar Pantalla completa
    .accesskey = P
menu-view-exit-full-screen =
    .label = Salir de pantalla completa
    .accesskey = p
menu-view-full-screen =
    .label = Pantalla completa
    .accesskey = P

##

menu-view-show-all-tabs =
    .label = Mostrar todas las pestañas
    .accesskey = t
menu-view-bidi-switch-page-direction =
    .label = Cambiar la orientación de esta página
    .accesskey = d

## History Menu

menu-history =
    .label = Historial
    .accesskey = H
menu-history-show-all-history =
    .label = Mostrar todo el historial
menu-history-clear-recent-history =
    .label = Borrar el historial reciente…
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
menu-history-reopen-all-tabs = Reabrir todas las pestañas
menu-history-reopen-all-windows = Reabrir todas las ventanas

## Bookmarks Menu

menu-bookmarks-menu =
    .label = Marcadores
    .accesskey = M
menu-bookmarks-manage =
    .label = Administrar marcadores
menu-bookmark-current-tab =
    .label = Marcar pestaña actual
menu-bookmark-edit =
    .label = Modificar este marcador
menu-bookmarks-all-tabs =
    .label = Agregar las pestañas abiertas…
menu-bookmarks-toolbar =
    .label = Marcadores
menu-bookmarks-other =
    .label = Otros Marcadores
menu-bookmarks-mobile =
    .label = Marcadores móviles

## Tools Menu

menu-tools =
    .label = Herramientas
    .accesskey = t
menu-tools-downloads =
    .label = Descargas
    .accesskey = D
menu-tools-addons-and-themes =
    .label = Complementos y temas
    .accesskey = A
menu-tools-fxa-sign-in2 =
    .label = Iniciar sesión
    .accesskey = i
menu-tools-turn-on-sync2 =
    .label = Activar Sync…
    .accesskey = n
menu-tools-sync-now =
    .label = Sincronizar ahora
    .accesskey = S
menu-tools-fxa-re-auth =
    .label = Reconectar a { -brand-product-name }...
    .accesskey = R
menu-tools-browser-tools =
    .label = Herramientas del navegador
    .accesskey = B
menu-tools-task-manager =
    .label = Administrador de tareas
    .accesskey = M
menu-tools-page-source =
    .label = Código fuente de esta página
    .accesskey = o
menu-tools-page-info =
    .label = Información sobre esta página
    .accesskey = I
menu-settings =
    .label = Configuración
    .accesskey =
        { PLATFORM() ->
            [windows] S
           *[other] n
        }
menu-tools-layout-debugger =
    .label = Depurador de diseño
    .accesskey = L

## Window Menu

menu-window-menu =
    .label = Ventana
menu-window-bring-all-to-front =
    .label = Traer todo al frente

## Help Menu


# NOTE: For Engineers, any additions or changes to Help menu strings should
# also be reflected in the related strings in appmenu.ftl. Those strings, by
# convention, will have the same ID as these, but prefixed with "app".
# Example: appmenu-get-help
#
# These strings are duplicated to allow for different casing depending on
# where the strings appear.

menu-help =
    .label = Ayuda
    .accesskey = y
menu-get-help =
    .label = Obtener ayuda
    .accesskey = H
menu-help-more-troubleshooting-info =
    .label = Más información para solucionar problemas
    .accesskey = T
menu-help-report-site-issue =
    .label = Reportar problema con el sitio…
menu-help-feedback-page =
    .label = Enviar comentarios...
    .accesskey = S
menu-help-enter-troubleshoot-mode2 =
    .label = Modo de resolución de problemas…
    .accesskey = M
menu-help-exit-troubleshoot-mode =
    .label = Desactivar modo de resolución de problemas
    .accesskey = M
# Label of the Help menu item. Either this or
# menu-help-notdeceptive is shown.
menu-help-report-deceptive-site =
    .label = Reportar sitio fraudulento…
    .accesskey = f
menu-help-not-deceptive =
    .label = Este no es un sitio engañoso…
    .accesskey = d
