# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## App Menu

appmenuitem-banner-update-downloading =
    .label = Descargando actualización de { -brand-shorter-name }

appmenuitem-banner-update-available =
    .label = Actualización disponible — descargar ahora

appmenuitem-banner-update-manual =
    .label = Actualización disponible — descargar ahora

appmenuitem-banner-update-unsupported =
    .label = No se puede actualizar — sistema incompatible

appmenuitem-banner-update-restart =
    .label = Actualización disponible — reiniciar ahora

appmenuitem-new-tab =
    .label = Nueva pestaña
appmenuitem-new-window =
    .label = Nueva ventana
appmenuitem-new-private-window =
    .label = Nueva ventana privada
appmenuitem-history =
    .label = Historial
appmenuitem-downloads =
    .label = Descargas
appmenuitem-passwords =
    .label = Contraseñas
appmenuitem-addons-and-themes =
    .label = Complementos y temas
appmenuitem-print =
    .label = Imprimir…
appmenuitem-find-in-page =
    .label = Buscar en la página…
appmenuitem-translate =
    .label = Traducir página…
appmenuitem-zoom =
    .value = Tamaño
appmenuitem-more-tools =
    .label = Más herramientas
appmenuitem-help =
    .label = Ayuda
appmenuitem-exit2 =
    .label =
        { PLATFORM() ->
            [linux] Salir
           *[other] Salir
        }
appmenu-menu-button-closed2 =
    .tooltiptext = Abrir el menú de la aplicación
    .label = { -brand-short-name }
appmenu-menu-button-opened2 =
    .tooltiptext = Cerrar el menú de la aplicación
    .label = { -brand-short-name }

# Settings is now used to access the browser settings across all platforms,
# instead of Options or Preferences.
appmenuitem-settings =
    .label = Ajustes

## Zoom and Fullscreen Controls

appmenuitem-zoom-enlarge =
    .label = Aumentar
appmenuitem-zoom-reduce =
    .label = Reducir
appmenuitem-fullscreen =
    .label = Pantalla completa

## Waterfox Account toolbar button and Sync panel in App menu.

appmenu-remote-tabs-sign-into-sync =
    .label = Iniciar sesión en Sync…
appmenu-remote-tabs-turn-on-sync =
    .label = Activar Sync…

# This is shown after the tabs list if we can display more tabs by clicking on the button
appmenu-remote-tabs-showmore =
    .label = Mostrar más pestañas
    .tooltiptext = Mostrar más pestañas de este dispositivo

# This is shown beneath the name of a device when that device has no open tabs
appmenu-remote-tabs-notabs = No hay pestañas abiertas

# This is shown when Sync is configured but syncing tabs is disabled.
appmenu-remote-tabs-tabsnotsyncing = Active la sincronización de pestañas para ver una lista de las mismas de sus otros dispositivos.

appmenu-remote-tabs-opensettings =
    .label = Ajustes

# This is shown when Sync is configured but this appears to be the only device attached to
# the account. We also show links to download Waterfox for android/ios.
appmenu-remote-tabs-noclients = ¿Quiere ver sus pestañas de otros dispositivos aquí?

appmenu-remote-tabs-connectdevice =
    .label = Conectar otro dispositivo
appmenu-remote-tabs-welcome = Ver una lista de pestañas de sus otros dispositivos.
appmenu-remote-tabs-unverified = Su cuenta debe ser verificada.

appmenuitem-fxa-toolbar-sync-now2 = Sincronizar ahora
appmenuitem-fxa-sign-in = Iniciar sesión en { -brand-product-name }
appmenuitem-fxa-manage-account = Administrar cuenta
appmenu-fxa-header2 = { -fxaccount-brand-name }
# Variables
# $time (string) - Localized relative time since last sync (e.g. 1 second ago,
# 3 hours ago, etc.)
appmenu-fxa-last-sync = Última sincronización { $time }
    .label = Última sincronización { $time }
appmenu-fxa-sync-and-save-data2 = Sincronizar y guardar datos
appmenu-fxa-signed-in-label = Iniciar sesión
appmenu-fxa-setup-sync =
    .label = Activar la sincronización…

appmenuitem-save-page =
    .label = Guardar como…

## What's New panel in App menu.

whatsnew-panel-header = Novedades

# Checkbox displayed at the bottom of the What's New panel, allowing users to
# enable/disable What's New notifications.
whatsnew-panel-footer-checkbox =
    .label = Notificar sobre nuevas funciones
    .accesskey = f

## The Waterfox Profiler – The popup is the UI to turn on the profiler, and record
## performance profiles. To enable it go to profiler.firefox.com and click
## "Enable Profiler Menu Button".

profiler-popup-button-idle =
    .label = Analizador
    .tooltiptext = Grabar un perfil de rendimiento

profiler-popup-button-recording =
    .label = Analizador
    .tooltiptext = El analizador está grabando un perfil

profiler-popup-button-capturing =
    .label = Analizador
    .tooltiptext = El analizador está capturando un perfil

profiler-popup-header-text = { -profiler-brand-name }

profiler-popup-reveal-description-button =
    .aria-label = Revelar más información

profiler-popup-description-title =
    .value = Grabar, analizar, compartir

profiler-popup-description = Colabore en problemas de rendimiento publicando perfiles para compartirlos con su equipo.

profiler-popup-learn-more-button =
    .label = Saber más

profiler-popup-settings =
    .value = Ajustes

# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings-button =
    .label = Editar ajustes…

profiler-popup-recording-screen = Grabando…

profiler-popup-start-recording-button =
    .label = Iniciar grabación

profiler-popup-discard-button =
    .label = Descartar

profiler-popup-capture-button =
    .label = Capturar

profiler-popup-start-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧1
       *[other] Ctrl+Mayús+1
    }

profiler-popup-capture-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧2
       *[other] Ctrl+Mayús+2
    }

## Profiler presets
## They are shown in the popup's select box.


# Presets and their l10n IDs are defined in the file
# devtools/client/performance-new/popup/background.jsm.js
# Please take care that the same values are also defined in devtools' perftools.ftl.


# Presets and their l10n IDs are defined in the file
# devtools/client/performance-new/shared/background.jsm.js
# Please take care that the same values are also defined in devtools' perftools.ftl.

profiler-popup-presets-web-developer-description = Configuración recomendada para la depuración de la mayoría de aplicaciones web, con poca sobrecarga.
profiler-popup-presets-web-developer-label =
    .label = Desarrollador web

profiler-popup-presets-firefox-description = Valor predeterminado recomendado para la creación de perfiles { -brand-shorter-name }.
profiler-popup-presets-firefox-label =
    .label = { -brand-shorter-name }

profiler-popup-presets-graphics-description = Preestablecido para investigar errores gráficos en { -brand-shorter-name }.
profiler-popup-presets-graphics-label =
    .label = Gráficos

profiler-popup-presets-media-description2 = Preestablecido para investigar errores de audio y vídeo en { -brand-shorter-name }.
profiler-popup-presets-media-label =
    .label = Multimedia

profiler-popup-presets-networking-description = Preestablecido para investigar problemas de red en { -brand-shorter-name }.
profiler-popup-presets-networking-label =
    .label = Red

profiler-popup-presets-power-description = Preestablecido para investigar errores relacionados con el consumo de energía en { -brand-shorter-name }, con poca sobrecarga.
# "Power" is used in the sense of energy (electricity used by the computer).
profiler-popup-presets-power-label =
    .label = Energía

profiler-popup-presets-custom-label =
    .label = Personalizado

## History panel

appmenu-manage-history =
    .label = Administrar historial
appmenu-restore-session =
    .label = Restaurar sesión anterior
appmenu-clear-history =
    .label = Limpiar el historial reciente…
appmenu-recent-history-subheader = Historial reciente
appmenu-recently-closed-tabs =
    .label = Pestañas cerradas recientemente
appmenu-recently-closed-windows =
    .label = Ventanas cerradas recientemente
# This allows to search through the browser's history.
appmenu-search-history =
    .label = Buscar en el historial

## Help panel

appmenu-help-header =
    .title = Ayuda de { -brand-shorter-name }
appmenu-about =
    .label = Acerca de { -brand-shorter-name }
    .accesskey = A
appmenu-get-help =
    .label = Obtener ayuda
    .accesskey = O
appmenu-help-more-troubleshooting-info =
    .label = Más información para solucionar problemas
    .accesskey = T
appmenu-help-report-site-issue =
    .label = Informar de problema en sitio…
appmenu-help-share-ideas =
    .label = Compartir ideas y opiniones…
    .accesskey = s
appmenu-help-switch-device =
    .label = Cambiar a un nuevo dispositivo

## appmenu-help-enter-troubleshoot-mode and appmenu-help-exit-troubleshoot-mode
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-enter-troubleshoot-mode2 =
    .label = Modo de resolución de problemas…
    .accesskey = M
appmenu-help-exit-troubleshoot-mode =
    .label = Desactivar modo de resolución de problemas
    .accesskey = M

## appmenu-help-report-deceptive-site and appmenu-help-not-deceptive
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-report-deceptive-site =
    .label = Informar de sitio engañoso…
    .accesskey = I
appmenu-help-not-deceptive =
    .label = Este no es un sitio engañoso…
    .accesskey = E

## More Tools

appmenu-customizetoolbar =
    .label = Personalizar barra de herramientas…

appmenu-developer-tools-subheader = Herramientas del navegador
appmenu-developer-tools-extensions =
    .label = Extensiones para desarrolladores
