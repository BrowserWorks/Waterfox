# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Enviar a los sitios web una señal “No rastrear” indicando que no quiere ser rastreado
do-not-track-learn-more = Más información
do-not-track-option-default-content-blocking-known =
    .label = Solo cuando { -brand-short-name } está configurado para bloquear los rastreadores conocidos
do-not-track-option-always =
    .label = Siempre
pref-page-title =
    { PLATFORM() ->
        [windows] Opciones
       *[other] Preferencias
    }
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 15.4em
    .placeholder =
        { PLATFORM() ->
            [windows] Encontrar en Opciones
           *[other] Encontrar en Preferencias
        }
settings-page-title = Ajustes
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box2 =
    .style = width: 15.4em
    .placeholder = Buscar en ajustes
managed-notice = Su navegador está siendo administrado por su organización.
category-list =
    .aria-label = Categorías
pane-general-title = General
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = Inicio
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = Buscar
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = Privacidad & Seguridad
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }
pane-sync-title3 = Sincronización
category-sync3 =
    .tooltiptext = { pane-sync-title3 }
pane-experimental-title = Experimentos de { -brand-short-name }
category-experimental =
    .tooltiptext = Experimentos de { -brand-short-name }
pane-experimental-subtitle = Continuar con precaución
pane-experimental-search-results-header = Experimentos de { -brand-short-name }: Proceder con precaución
pane-experimental-description2 = Cambiar los ajustes de configuración avanzada puede afectar el rendimiento o la seguridad de { -brand-short-name }.
pane-experimental-reset =
    .label = Restaurar predeterminados
    .accesskey = R
help-button-label = { -brand-short-name } Asistencia
addons-button-label = Extensiones y temas
focus-search =
    .key = f
close-button =
    .aria-label = Cerrar

## Browser Restart Dialog

feature-enable-requires-restart = { -brand-short-name } debe ser reiniciado para activar esta característica.
feature-disable-requires-restart = { -brand-short-name } debe ser reiniciado para activar esta característica.
should-restart-title = Reiniciar { -brand-short-name }
should-restart-ok = Reiniciar { -brand-short-name } ahora
cancel-no-restart-button = Cancelar
restart-later = Reiniciar más tarde

## Extension Control Notifications
##
## These strings are used to inform the user
## about changes made by extensions to browser settings.
##
## <img data-l10n-name="icon"/> is going to be replaced by the extension icon.
##
## Variables:
##   $name (String): name of the extension

# This string is shown to notify the user that their home page
# is being controlled by an extension.
extension-controlled-homepage-override = Una extensión, <img data-l10n-name="icon"/> { $name }, controla su página de inicio.
# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = Una extensión, <img data-l10n-name="icon"/> { $name }, controla su página de nueva pestaña.
# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlled-password-saving = Una extensión, <img data-l10n-name="icon"/> { $name }, está controlando este ajuste.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = Una extensión, <img data-l10n-name="icon"/> { $name }, está controlando esta configuración.
# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = Una exensión, <img data-l10n-name="icon"/> { $name }, ha establecido su buscador predeterminado.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = Una extensión, <img data-l10n-name="icon"/> { $name }, requiere pestañas de contenedores.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = Una extensión, <img data-l10n-name="icon"/> { $name }, está controlando esta configuración.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = Una extensión, <img data-l10n-name="icon"/> { $name }, controla cómo se conecta { -brand-short-name } a Internet.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Para activar la extensión vaya a Complementos <img data-l10n-name="addons-icon"/> en el menú <img data-l10n-name="menu-icon"/>.

## Preferences UI Search Results

search-results-header = Resultados de la búsqueda
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] ¡Lo sentimos! No hay resultados para "<span data-l10n-name="query"></span>" en Opciones.
       *[other] ¡Lo sentimos! No hay resultados para "<span data-l10n-name="query"></span>" en Preferencias.
    }
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message2 = ¡Lo sentimos! No hay resultados para "<span data-l10n-name="query"></span>" en los ajustes.
search-results-help-link = ¿Necesita ayuda? Visite <a data-l10n-name="url">Ayuda de { -brand-short-name }</a>

## General Section

startup-header = Inicio
# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = Permitir a { -brand-short-name } y Firefox ejecutarse al mismo tiempo
use-firefox-sync = Consejo: esto usa perfiles separados. Use { -sync-brand-short-name } para compartir datos entre ellos.
get-started-not-logged-in = Conectarse a { -sync-brand-short-name }…
get-started-configured = Abrir preferencias de { -sync-brand-short-name }
always-check-default =
    .label = Comprobar siempre si { -brand-short-name } es su navegador predeterminado
    .accesskey = o
is-default = { -brand-short-name } es su navegador predeterminado
is-not-default = { -brand-short-name } no es su navegador predet.
set-as-my-default-browser =
    .label = Convertir en predeterminado…
    .accesskey = C
startup-restore-previous-session =
    .label = Restaurar sesión previa
    .accesskey = s
startup-restore-warn-on-quit =
    .label = Advertirle al salir del navegador
disable-extension =
    .label = Desactivar extensión
tabs-group-header = Pestañas
ctrl-tab-recently-used-order =
    .label = Ctrl+Tab pasa por las pestañas en orden de uso reciente
    .accesskey = T
open-new-link-as-tabs =
    .label = Abrir enlaces en pestañas en lugar de en ventanas nuevas
    .accesskey = v
warn-on-close-multiple-tabs =
    .label = Advertirle al cerrar múltiples pestañas
    .accesskey = A
warn-on-open-many-tabs =
    .label = Advertirle cuando al abrir múltiples pestañas se pueda ralentizar { -brand-short-name }
    .accesskey = v
switch-links-to-new-tabs =
    .label = Cuando abra un enlace en una pestaña nueva, cambiar inmediatamente a ella
    .accesskey = C
switch-to-new-tabs =
    .label = Cuando abra un enlace, imagen o archivo multimedia en una pestaña nueva, cambiar inmediatamente a ella
    .accesskey = h
show-tabs-in-taskbar =
    .label = Mostrar miniaturas de las pestañas en la barra de tareas de Windows
    .accesskey = ñ
browser-containers-enabled =
    .label = Activar pestañas contenedoras
    .accesskey = ñ
browser-containers-learn-more = Saber más
browser-containers-settings =
    .label = Configuración…
    .accesskey = C
containers-disable-alert-title = ¿Cerrar todas las pestañas contenedoras?
containers-disable-alert-desc =
    { $tabCount ->
        [one] Si desactiva las pestañas contenedores ahora, se cerrará { $tabCount } pestaña contenedora. ¿Está seguro de que quiere desactivar las pestañas contenedoras?
       *[other] Si desactiva las pestañas contenedores ahora, se cerrarán { $tabCount } pestañas contenedoras. ¿Está seguro de que quiere desactivar las pestañas contenedoras?
    }
containers-disable-alert-ok-button =
    { $tabCount ->
        [one] Cerrar { $tabCount } pestaña contenedora
       *[other] Cerrar { $tabCount } pestañas contenedoras
    }
containers-disable-alert-cancel-button = Mantener activadas
containers-remove-alert-title = ¿Eliminar este contenedor?
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Si elimina este contenedor ahora, se cerrará { $count } pestaña contenedora. ¿Está seguro de que quiere eliminar este contenedor?
       *[other] Si elimina este contenedor ahora, se cerrarán { $count } pestañas contenedoras. ¿Está seguro de que quiere eliminar este contenedor?
    }
containers-remove-ok-button = Eliminar este contenedor
containers-remove-cancel-button = No eliminar este contenedor

## General Section - Language & Appearance

language-and-appearance-header = Idioma y apariencia
fonts-and-colors-header = Tipografías y colores
default-font = Tipografía predeterminada
    .accesskey = T
default-font-size = Tamaño
    .accesskey = m
advanced-fonts =
    .label = Avanzadas…
    .accesskey = A
colors-settings =
    .label = Colores…
    .accesskey = C
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Ampliación
preferences-default-zoom = Ampliación predeterminada
    .accesskey = A
preferences-default-zoom-value =
    .label = { $percentage }%
preferences-zoom-text-only =
    .label = Sólo ampliar texto
    .accesskey = t
language-header = Idioma
choose-language-description = Elegir el idioma preferido para mostrar las páginas web
choose-button =
    .label = Seleccionar…
    .accesskey = o
choose-browser-language-description = Seleccione los idiomas en los que se mostrarán los menús, mensajes y notificaciones de { -brand-short-name }.
manage-browser-languages-button =
    .label = Establecer alternativas…
    .accesskey = l
confirm-browser-language-change-description = Reinicie { -brand-short-name } para aplicar los cambios
confirm-browser-language-change-button = Aplicar y reiniciar
translate-web-pages =
    .label = Traducir contenido web
    .accesskey = d
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Traducciones de <img data-l10n-name="logo"/>
translate-exceptions =
    .label = Excepciones…
    .accesskey = x
# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = Usar la configuración de su sistema operativo para “{ $localeName }” para dar formato a fechas, horas, números y medidas.
check-user-spelling =
    .label = Revisar la ortografía según escribe
    .accesskey = v

## General Section - Files and Applications

files-and-applications-title = Archivos y aplicaciones
download-header = Descargas
download-save-to =
    .label = Guardar archivos en
    .accesskey = G
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Elegir…
           *[other] Examinar…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] e
           *[other] x
        }
download-always-ask-where =
    .label = Preguntar siempre dónde guardar los archivos
    .accesskey = s
applications-header = Aplicaciones
applications-description = Elija cómo gestiona { -brand-short-name } los archivos que usted descarga de la web o las aplicaciones que usa mientras navega.
applications-filter =
    .placeholder = Buscar tipos de archivo o aplicaciones
applications-type-column =
    .label = Tipo de contenido
    .accesskey = T
applications-action-column =
    .label = Acción
    .accesskey = A
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = archivo { $extension }
applications-action-save =
    .label = Guardar archivo
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = Usar { $app-name }
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = Usar { $app-name } (predeterminado)
applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] Usar la aplicación predeterminada de macOS
            [windows] Usar la aplicación predeterminada de Windows
           *[other] Usar la aplicación predeterminada del sistema
        }
applications-use-other =
    .label = Usar otra…
applications-select-helper = Seleccione aplicación auxiliar
applications-manage-app =
    .label = Detalles de la aplicación…
applications-always-ask =
    .label = Preguntar siempre
applications-type-pdf = Portable Document Format (PDF)
# Variables:
#   $type (String) - the MIME type (e.g application/binary)
applications-type-pdf-with-type = { applications-type-pdf } ({ $type })
# Variables:
#   $type-description (String) - Description of the type (e.g "Portable Document Format")
#   $type (String) - the MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })
# Variables:
#   $extension (String) - file extension (e.g .TXT)
#   $type (String) - the MIME type (e.g application/binary)
applications-file-ending-with-type = { applications-file-ending } ({ $type })
# Variables:
#   $plugin-name (String) - Name of a plugin (e.g Adobe Flash)
applications-use-plugin-in =
    .label = Usar { $plugin-name } (en { -brand-short-name })
applications-open-inapp =
    .label = Abrir en { -brand-short-name }

## The strings in this group are used to populate
## selected label element based on the string from
## the selected menu item.

applications-use-plugin-in-label =
    .value = { applications-use-plugin-in.label }
applications-action-save-label =
    .value = { applications-action-save.label }
applications-use-app-label =
    .value = { applications-use-app.label }
applications-open-inapp-label =
    .value = { applications-open-inapp.label }
applications-always-ask-label =
    .value = { applications-always-ask.label }
applications-use-app-default-label =
    .value = { applications-use-app-default.label }
applications-use-other-label =
    .value = { applications-use-other.label }
applications-use-os-default-label =
    .value = { applications-use-os-default.label }

##

drm-content-header = Contenido sujeto a administración de derechos de autor (DRM)
play-drm-content =
    .label = Reproducir contenido controlado por DRM
    .accesskey = R
play-drm-content-learn-more = Saber más
update-application-title = Actualizaciones de { -brand-short-name }
update-application-description = Mantenga { -brand-short-name } actualizado para un rendimiento, estabilidad y seguridad óptimos.
update-application-version = Versión { $version } <a data-l10n-name="learn-more">Novedades</a>
update-history =
    .label = Mostrar historial de actualizaciones…
    .accesskey = M
update-application-allow-description = Permitir a { -brand-short-name }
update-application-auto =
    .label = Instalar actualizaciones automáticamente (recomendado)
    .accesskey = I
update-application-check-choose =
    .label = Buscar actualizaciones, pero permitirle elegir si instalarlas
    .accesskey = B
update-application-manual =
    .label = No buscar actualizaciones (no recomendado)
    .accesskey = N
update-application-background-enabled =
    .label = Cuando { -brand-short-name } no se esté ejecutando
    .accesskey = C
update-application-warning-cross-user-setting = Esta configuración se aplicará a todas las cuentas de Windows y los perfiles { -brand-short-name } usando esta instalación de { -brand-short-name }.
update-application-use-service =
    .label = Usar un servicio en segundo plano para instalar actualizaciones
    .accesskey = p
update-setting-write-failure-title = Error al guardar las preferencias de actualización
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } ha encontrado un error y no ha guardado los cambios.  Tenga en cuenta que establecer esta preferencia de actualización requiere permiso para escribir en el archivo indicado a continuación. Usted o un administrador del sistema pueden resolver el error otorgando al grupo de Usuarios el control total de este archivo.
    
    No se puede escribir en el archivo: { $path }
update-setting-write-failure-title2 = Error al guardar los ajustes de actualización
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message2 =
    { -brand-short-name } ha encontrado un error y no ha guardado este cambio.  Tenga en cuenta que establecer este ajuste de actualización requiere permiso para escribir en el archivo indicado a continuación. Usted o un administrador del sistema pueden resolver el error otorgando al grupo de Usuarios el control total de este archivo.
    
    No se puede escribir en el archivo: { $path }
update-in-progress-title = Actualización en curso
update-in-progress-message = ¿Quiere que { -brand-short-name } continúe con la actualización?
update-in-progress-ok-button = &Ignorar
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Continuar

## General Section - Performance

performance-title = Rendimiento
performance-use-recommended-settings-checkbox =
    .label = Usar configuración de rendimiento recomendada
    .accesskey = U
performance-use-recommended-settings-desc = Esta configuración está ajustada al hardware y sistema operativo de su equipo.
performance-settings-learn-more = Saber más
performance-allow-hw-accel =
    .label = Usar aceleración de hardware cuando esté disponible
    .accesskey = r
performance-limit-content-process-option = Límite de procesos de contenido
    .accesskey = L
performance-limit-content-process-enabled-desc = Más procesos de contenido pueden mejorar el rendimiento al usar múltiples pestañas, pero también usarán más memoria.
performance-limit-content-process-blocked-desc = Modificar el número de procesos de contenido solo es posible con { -brand-short-name } multiproceso. <a data-l10n-name="learn-more">Sepa cómo comprobar si el multiproceso está activado</a>
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (predeterminado)

## General Section - Browsing

browsing-title = Navegación
browsing-use-autoscroll =
    .label = Usar desplazamiento automático
    .accesskey = a
browsing-use-smooth-scrolling =
    .label = Usar desplazamiento suave
    .accesskey = v
browsing-use-onscreen-keyboard =
    .label = Mostrar un teclado táctil cuando sea necesario
    .accesskey = s
browsing-use-cursor-navigation =
    .label = Usar siempre las teclas del cursor para navegar dentro de las páginas
    .accesskey = c
browsing-search-on-start-typing =
    .label = Buscar texto cuando comience a escribir
    .accesskey = x
browsing-picture-in-picture-toggle-enabled =
    .label = Activar controles de vídeo picture-in-picture
    .accesskey = A
browsing-picture-in-picture-learn-more = Saber más
browsing-media-control =
    .label = Controlar los medios con el teclado, los auriculares o la interfaz virtual
    .accesskey = v
browsing-media-control-learn-more = Saber más
browsing-cfr-recommendations =
    .label = Recomendar extensiones mientras se navega
    .accesskey = R
browsing-cfr-features =
    .label = Recomendar funciones mientras navega
    .accesskey = R
browsing-cfr-recommendations-learn-more = Saber más

## General Section - Proxy

network-settings-title = Configuración de red
network-proxy-connection-description = Configurar cómo se conecta { -brand-short-name } a Internet.
network-proxy-connection-learn-more = Saber más
network-proxy-connection-settings =
    .label = Configuración…
    .accesskey = o

## Home Section

home-new-windows-tabs-header = Nuevas ventanas y pestañas
home-new-windows-tabs-description2 = Elige lo que ves cuando abres tu página de inicio, nuevas ventanas y nuevas pestañas.

## Home Section - Home Page Customization

home-homepage-mode-label = Página de inicio y ventanas nuevas
home-newtabs-mode-label = Nuevas pestañas
home-restore-defaults =
    .label = Restaurar ajustes predeterminados
    .accesskey = R
# "Waterfox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Inicio de Firefox (predeterminado)
home-mode-choice-custom =
    .label = URLs personalizadas...
home-mode-choice-blank =
    .label = Página en blanco
home-homepage-custom-url =
    .placeholder = Pegar URL...
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Usar página actual
           *[other] Usar páginas actuales
        }
    .accesskey = C
choose-bookmark =
    .label = Usar marcador…
    .accesskey = m

## Home Section - Firefox Home Content Customization

home-prefs-content-header = Contenido de la página de inicio de Firefox
home-prefs-content-description = Seleccione el contenido que desea en la pantalla de inicio de Firefox.
home-prefs-search-header =
    .label = Búsqueda web
home-prefs-topsites-header =
    .label = Sitios populares
home-prefs-topsites-description = Los sitios que más visita
home-prefs-topsites-by-option-sponsored =
    .label = Sitios principales patrocinados
home-prefs-shortcuts-header =
    .label = Accesos directos
home-prefs-shortcuts-description = Sitios que guarda o visita
home-prefs-shortcuts-by-option-sponsored =
    .label = Accesos directos patrocinados

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Recomendado por { $provider }
home-prefs-recommended-by-description-update = Contenido excepcional de toda la web, patrocinado por { $provider }
home-prefs-recommended-by-description-new = Contenido excepcional seleccionado por { $provider }, parte de la familia { -brand-product-name }

##

home-prefs-recommended-by-learn-more = Cómo funciona
home-prefs-recommended-by-option-sponsored-stories =
    .label = Historias patrocinadas
home-prefs-highlights-header =
    .label = Destacados
home-prefs-highlights-description = Una selección de sitios que ha guardado o visitado
home-prefs-highlights-option-visited-pages =
    .label = Páginas visitadas
home-prefs-highlights-options-bookmarks =
    .label = Marcadores
home-prefs-highlights-option-most-recent-download =
    .label = Descargas más recientes
home-prefs-highlights-option-saved-to-pocket =
    .label = Páginas guardadas en { -pocket-brand-name }
home-prefs-recent-activity-header =
    .label = Actividad reciente
home-prefs-recent-activity-description = Una selección de sitios y contenidos recientes
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Mensajes interactivos
home-prefs-snippets-description = Actualizaciones de { -vendor-short-name } y { -brand-product-name }
home-prefs-snippets-description-new = Consejos y noticias de { -vendor-short-name } y { -brand-product-name }
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } fila
           *[other] { $num } filas
        }

## Search Section

search-bar-header = Barra de búsqueda
search-bar-hidden =
    .label = Use la barra de direcciones para búsquedas y navegación
search-bar-shown =
    .label = Añadir barra de búsqueda en la barra de herramientas
search-engine-default-header = Buscador predeterminado
search-engine-default-desc-2 = Este es su buscador predeterminado en la barra de direcciones y la barra de búsqueda. Puede cambiarlo en cualquier momento.
search-engine-default-private-desc-2 = Elija un buscador predeterminado diferente para usar solo en ventanas privadas
search-separate-default-engine =
    .label = Usar este buscador en ventanas privadas
    .accesskey = U
search-suggestions-header = Sugerencias de búsqueda
search-suggestions-desc = Elija cómo aparecen las sugerencias de los buscadores.
search-suggestions-option =
    .label = Proporcionar sugerencias de búsqueda
    .accesskey = P
search-show-suggestions-url-bar-option =
    .label = Mostrar sugerencias de búsqueda en los resultados de la barra de direcciones
    .accesskey = M
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Mostrar sugerencias de búsqueda antes del historial de navegación en los resultados de la barra de direcciones
search-show-suggestions-private-windows =
    .label = Mostrar sugerencias de búsqueda en ventanas privadas
suggestions-addressbar-settings-generic = Cambiar preferencias para otras sugerencias de la barra de direcciones
suggestions-addressbar-settings-generic2 = Cambiar configuración para otras sugerencias de la barra de direcciones
search-suggestions-cant-show = Las sugerencias de búsqueda no se mostrarán en los resultados de la barra de direcciones porque ha configurado { -brand-short-name } para que nunca recuerde el historial.
search-one-click-header = Buscadores con un clic
search-one-click-header2 = Atajos de búsqueda
search-one-click-desc = Elija los buscadores alternativos que aparecen bajo las barras de direcciones y de búsqueda cuando comienza a escribir una palabra clave.
search-choose-engine-column =
    .label = Buscador
search-choose-keyword-column =
    .label = Palabra clave
search-restore-default =
    .label = Restaurar buscadores predeterminados
    .accesskey = R
search-remove-engine =
    .label = Eliminar
    .accesskey = E
search-add-engine =
    .label = Añadir
    .accesskey = A
search-find-more-link = Encontrar más buscadores
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Palabra clave duplicada
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Ha seleccionado una palabra clave que está siendo usada por "{ $name }". Por favor, seleccione otra.
search-keyword-warning-bookmark = Ha seleccionado una palabra clave que está siendo usada por otro marcador. Por favor, seleccione otra.

## Containers Section

containers-back-button =
    .aria-label =
        { PLATFORM() ->
            [windows] Volver a Opciones
           *[other] Volver a Preferencias
        }
containers-back-button2 =
    .aria-label = Volver a los ajustes
containers-header = Pestañas contenedoras
containers-add-button =
    .label = Añadir nuevo contenedor
    .accesskey = A
containers-new-tab-check =
    .label = Seleccionar un contenedor para cada nueva pestaña
    .accesskey = S
containers-preferences-button =
    .label = Preferencias
containers-settings-button =
    .label = Ajustes
containers-remove-button =
    .label = Eliminar

## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Llévese la web con usted
sync-signedout-description = Sincronice sus marcadores, historial, pestañas, contraseñas, complementos y preferencias en todos sus dispositivos.
sync-signedout-account-signin2 =
    .label = Iniciar sesión en{ -sync-brand-short-name }…
    .accesskey = I
sync-signedout-description2 = Sincronice sus marcadores, historial, pestañas, contraseñas, complementos y ajustes en todos sus dispositivos.
sync-signedout-account-signin3 =
    .label = Iniciar sesión para sincronizar…
    .accesskey = I
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Descargar Firefox para <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> o <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> para sincronizar con su dispositivo móvil.

## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = Cambiar imagen del perfil
sync-sign-out =
    .label = Cerrar sesión…
    .accesskey = C
sync-manage-account = Administrar cuenta
    .accesskey = A
sync-signedin-unverified = { $email } no está verificado.
sync-signedin-login-failure = Inicie sesión para reconectar { $email }
sync-resend-verification =
    .label = Reenviar verificación
    .accesskey = v
sync-remove-account =
    .label = Eliminar cuenta
    .accesskey = E
sync-sign-in =
    .label = Conectarse
    .accesskey = n

## Sync section - enabling or disabling sync.

prefs-syncing-on = Sincronización: ACTIVADA
prefs-syncing-off = Sincronización: DESACTIVADA
prefs-sync-setup =
    .label = Configurar { -sync-brand-short-name }…
    .accesskey = C
prefs-sync-offer-setup-label = Sincronice sus marcadores, historial, pestañas, contraseñas, complementos y preferencias en todos sus dispositivos.
prefs-sync-turn-on-syncing =
    .label = Activar la sincronización…
    .accesskey = s
prefs-sync-offer-setup-label2 = Sincronice sus marcadores, historial, pestañas, contraseñas, complementos y ajustes en todos sus dispositivos.
prefs-sync-now =
    .labelnotsyncing = Sincronizar ahora
    .accesskeynotsyncing = N
    .labelsyncing = Sincronizando…

## The list of things currently syncing.

sync-currently-syncing-heading = En este momento está sincronizando estos elementos:
sync-currently-syncing-bookmarks = Marcadores
sync-currently-syncing-history = Historial
sync-currently-syncing-tabs = Pestañas abiertas
sync-currently-syncing-logins-passwords = Usuarios y contraseñas
sync-currently-syncing-addresses = Direcciones
sync-currently-syncing-creditcards = Tarjetas de crédito
sync-currently-syncing-addons = Complementos
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] Opciones
       *[other] Preferencias
    }
sync-currently-syncing-settings = Ajustes
sync-change-options =
    .label = Cambiar…
    .accesskey = C

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = Elija lo que quiere sincronizar
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = Guardar cambios
    .buttonaccesskeyaccept = S
    .buttonlabelextra2 = Cerrar sesión…
    .buttonaccesskeyextra2 = D
sync-engine-bookmarks =
    .label = Marcadores
    .accesskey = m
sync-engine-history =
    .label = Historial
    .accesskey = r
sync-engine-tabs =
    .label = Pestañas abiertas
    .tooltiptext = Una lista de lo que está abierto en todos los dispositivos sincronizados
    .accesskey = t
sync-engine-logins-passwords =
    .label = Usuarios y contraseñas
    .tooltiptext = Nombres de usuario y contraseñas guardadas
    .accesskey = U
sync-engine-addresses =
    .label = Direcciones
    .tooltiptext = Direcciones postales que ha guardado (solo escritorio)
    .accesskey = D
sync-engine-creditcards =
    .label = Tarjetas de crédito
    .tooltiptext = Nombres, números y fechas de caducidad (solo escritorio)
    .accesskey = T
sync-engine-addons =
    .label = Complementos
    .tooltiptext = Extensiones y temas para Firefox de escritorio
    .accesskey = C
sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] Opciones
           *[other] Preferencias
        }
    .tooltiptext = Configuración general, de privacidad y de seguridad que ha cambiado
    .accesskey = S
sync-engine-settings =
    .label = Ajustes
    .tooltiptext = Cambios en los ajustes de General, Privacidad y Seguridad
    .accesskey = s

## The device name controls.

sync-device-name-header = Nombre del dispositivo
sync-device-name-change =
    .label = Cambiar nombre del dispositivo…
    .accesskey = a
sync-device-name-cancel =
    .label = Cancelar
    .accesskey = e
sync-device-name-save =
    .label = Guardar
    .accesskey = u
sync-connect-another-device = Conectar otro dispositivo

## Privacy Section

privacy-header = Privacidad del navegador

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Usuarios y contraseñas
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Preguntar para guardar contraseñas e inicios de sesión de sitios web
    .accesskey = r
forms-exceptions =
    .label = Excepciones…
    .accesskey = x
forms-generate-passwords =
    .label = Sugerir y generar contraseñas seguras
    .accesskey = u
forms-breach-alerts =
    .label = Mostrar alertas sobre contraseñas para sitios web comprometidos
    .accesskey = b
forms-breach-alerts-learn-more-link = Saber más
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Autocompletar inicios de sesión y contraseñas
    .accesskey = i
forms-saved-logins =
    .label = Cuentas guardadas…
    .accesskey = C
forms-master-pw-use =
    .label = Usar una contraseña maestra
    .accesskey = s
forms-primary-pw-use =
    .label = Usar una contraseña maestra
    .accesskey = U
forms-primary-pw-learn-more-link = Saber más
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = Cambiar contraseña maestra…
    .accesskey = M
forms-master-pw-fips-title = En este momento está en modo FIPS. FIPS requiere una contraseña maestra no vacía.
forms-primary-pw-change =
    .label = Cambiar la contraseña maestra…
    .accesskey = P
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = { "" }
forms-primary-pw-fips-title = Se encuentra actualmente en modo FIPS. FIPS requiere una contraseña maestra no vacía.
forms-master-pw-fips-desc = Fallo al cambiar la contraseña

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Para crear una contraseña maestra, introduzca sus credenciales de inicio de sesión de Windows. Esto ayuda a proteger la seguridad de sus cuentas.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = crear una contraseña maestra
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Para crear una contraseña maestra, introduzca sus credenciales de inicio de sesión de Windows. Esto ayuda a proteger la seguridad de sus cuentas.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = crear una contraseña maestra
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = Historial
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Waterfox", moving the verb into each option.
#     This will result in "Waterfox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = { -brand-short-name } podrá
    .accesskey = o
history-remember-option-all =
    .label = Recordar el historial
history-remember-option-never =
    .label = No recordar el historial
history-remember-option-custom =
    .label = Usar una configuración personalizada para el historial
history-remember-description = { -brand-short-name } recordará su historial de navegación, descargas, formularios y búsqueda.
history-dontremember-description = { -brand-short-name } usará la misma configuración que en la navegación privada, y no recordará ningún dato de su historial mientras navega por la Web.
history-private-browsing-permanent =
    .label = Modo permanente de navegación privada
    .accesskey = n
history-remember-browser-option =
    .label = Recordar historial de navegación y descargas
    .accesskey = h
history-remember-search-option =
    .label = Recordar el historial de formularios y búsquedas
    .accesskey = f
history-clear-on-close-option =
    .label = Limpiar el historial cuando { -brand-short-name } se cierre
    .accesskey = h
history-clear-on-close-settings =
    .label = Configuración…
    .accesskey = g
history-clear-button =
    .label = Limpiar historial…
    .accesskey = s

## Privacy Section - Site Data

sitedata-header = Cookies y datos del sitio
sitedata-total-size-calculating = Calculando el tamaño de los datos del sitio y del caché…
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Sus cookies, datos del sitio y caché almacenados ocupan actualmente un { $value } { $unit } del espacio en disco.
sitedata-learn-more = Saber más
sitedata-delete-on-close =
    .label = Eliminar cookies y datos del sitio cuando cierre { -brand-short-name }
    .accesskey = c
sitedata-delete-on-close-private-browsing = En el modo de navegación privada permanente, las cookies y los datos del sitio siempre se borrarán cuando se cierre { -brand-short-name } .
sitedata-allow-cookies-option =
    .label = Aceptar cookies y datos del sitio
    .accesskey = A
sitedata-disallow-cookies-option =
    .label = Bloquear cookies y datos del sitio
    .accesskey = B
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Tipo bloqueado
    .accesskey = T
sitedata-option-block-cross-site-trackers =
    .label = Rastreadores entre sitios
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = Rastreadores entre sitios y de redes sociales
sitedata-option-block-cross-site-tracking-cookies-including-social-media =
    .label = Cookies de rastreo entre sitios — incluye las cookies de redes sociales
sitedata-option-block-cross-site-cookies-including-social-media =
    .label = Cookies entre sitios — incluye las cookies de redes sociales
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = Rastreadores de sitios cruzados y redes sociales, y aislamiento del resto de las cookies
sitedata-option-block-unvisited =
    .label = Cookies de sitios web no visitados
sitedata-option-block-all-third-party =
    .label = Todas las cookies de terceros (puede causar errores en algunos sitios web)
sitedata-option-block-all =
    .label = Todas las cookies (causará errores en sitios web)
sitedata-clear =
    .label = Limpiar datos…
    .accesskey = L
sitedata-settings =
    .label = Administrar datos…
    .accesskey = M
sitedata-cookies-permissions =
    .label = Administrar permisos...
    .accesskey = p
sitedata-cookies-exceptions =
    .label = Gestionar excepciones…
    .accesskey = x

## Privacy Section - Address Bar

addressbar-header = Barra de direcciones
addressbar-suggest = Al usar la barra de direcciones, sugerir
addressbar-locbar-history-option =
    .label = Historial de navegación
    .accesskey = t
addressbar-locbar-bookmarks-option =
    .label = Marcadores
    .accesskey = M
addressbar-locbar-openpage-option =
    .label = Abrir pestañas
    .accesskey = A
# Shortcuts refers to the shortcut tiles on the new tab page, previously known as top sites. Translation should be consistent.
addressbar-locbar-shortcuts-option =
    .label = Accesos directos
    .accesskey = s
addressbar-locbar-topsites-option =
    .label = Sitios populares
    .accesskey = t
addressbar-locbar-engines-option =
    .label = Buscadores
    .accesskey = a
addressbar-suggestions-settings = Cambiar preferencias de sugerencias de buscadores

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Protección contra el rastreo mejorada
content-blocking-section-top-level-description = Los rastreadores le siguen en línea para recopilar información sobre sus hábitos e intereses de navegación. { -brand-short-name } bloquea muchos de estos rastreadores y otros scripts maliciosos.
content-blocking-learn-more = Saber más
content-blocking-fpi-incompatibility-warning = Está usando First Party Isolation (FPI), que anula algunas de las configuraciones de cookies de { -brand-short-name }.

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Estándar
    .accesskey = d
enhanced-tracking-protection-setting-strict =
    .label = Estricto
    .accesskey = r
enhanced-tracking-protection-setting-custom =
    .label = Personalizado
    .accesskey = P

##

content-blocking-etp-standard-desc = Equilibrado para protección y rendimiento. Las páginas se cargarán normalmente.
content-blocking-etp-strict-desc = Mayor protección, pero puede provocar que fallen algunos sitios o contenidos.
content-blocking-etp-custom-desc = Elija qué rastreadores y scripts quiere bloquear.
content-blocking-etp-blocking-desc = { -brand-short-name } bloquea lo siguiente:
content-blocking-private-windows = Rastreo de contenido en ventanas privadas
content-blocking-cross-site-cookies-in-all-windows = Cookies de sitios cruzados en todas las ventanas (incluye cookies de rastreo)
content-blocking-cross-site-tracking-cookies = Cookies de rastreo entre sitios
content-blocking-all-cross-site-cookies-private-windows = Cookies de sitios cruzados en ventanas privadas
content-blocking-cross-site-tracking-cookies-plus-isolate = Cookies de rastreo de sitios cruzados, y aislamiento del resto de las cookies
content-blocking-social-media-trackers = Rastreadores sociales
content-blocking-all-cookies = Todas las cookies
content-blocking-unvisited-cookies = Cookies de sitios no visitados
content-blocking-all-windows-tracking-content = Contenido de rastreo en todas las ventanas
content-blocking-all-third-party-cookies = Todas las cookies de terceros
content-blocking-cryptominers = Criptomineros
content-blocking-fingerprinters = Fingerprinters
content-blocking-warning-title = ¡Atención!
content-blocking-and-isolating-etp-warning-description = Bloquear los rastreadores y aislar las cookies puede afectar a la funcionalidad de algunos sitios. Recargue una página con los rastreadores para cargar todo el contenido.
content-blocking-and-isolating-etp-warning-description-2 = Este ajuste puede hacer que algunos sitios web no muestren contenido o que no funcionen correctamente. Si un sitio no se muestra correctamente, puede que quiera desactivar la protección contra el rastreo para que ese sitio cargue todo el contenido.
content-blocking-warning-learn-how = Saber cómo
content-blocking-reload-description = Tiene que recargar las pestañas para que los cambios surtan efecto.
content-blocking-reload-tabs-button =
    .label = Recargar todas las pestañas
    .accesskey = R
content-blocking-tracking-content-label =
    .label = Contenido de rastreo
    .accesskey = T
content-blocking-tracking-protection-option-all-windows =
    .label = En todas las ventanas
    .accesskey = A
content-blocking-option-private =
    .label = Solo en ventanas privadas
    .accesskey = P
content-blocking-tracking-protection-change-block-list = Cambiar la lista de bloqueo
content-blocking-cookies-label =
    .label = Cookies
    .accesskey = C
content-blocking-expand-section =
    .tooltiptext = Más información
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Criptomineros
    .accesskey = r
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Fingerprinters
    .accesskey = F

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Administrar excepciones...
    .accesskey = x

## Privacy Section - Permissions

permissions-header = Permisos
permissions-location = Ubicación
permissions-location-settings =
    .label = Configuración…
    .accesskey = u
permissions-xr = Realidad virtual
permissions-xr-settings =
    .label = Ajustes…
    .accesskey = t
permissions-camera = Cámara
permissions-camera-settings =
    .label = Configuración…
    .accesskey = u
permissions-microphone = Micrófono
permissions-microphone-settings =
    .label = Configuración…
    .accesskey = u
permissions-notification = Notificaciones
permissions-notification-settings =
    .label = Configuración…
    .accesskey = u
permissions-notification-link = Saber más
permissions-notification-pause =
    .label = Pausar notificaciones hasta que { -brand-short-name } se reinicie
    .accesskey = n
permissions-autoplay = Reproducción automática
permissions-autoplay-settings =
    .label = Configuración...
    .accesskey = C
permissions-block-popups =
    .label = Bloquear ventanas emergentes
    .accesskey = B
permissions-block-popups-exceptions =
    .label = Excepciones…
    .accesskey = E
permissions-addon-install-warning =
    .label = Advertirle cuando los sitios web intenten instalar complementos
    .accesskey = A
permissions-addon-exceptions =
    .label = Excepciones…
    .accesskey = E
permissions-a11y-privacy-checkbox =
    .label = Impedir que los servicios de accesibilidad accedan a su navegador
    .accesskey = I
permissions-a11y-privacy-link = Saber más

## Privacy Section - Data Collection

collection-header = Recopilación y uso de datos de { -brand-short-name }
collection-description = Nos esforzamos en proporcionarle opciones y recopilamos solo lo que necesitamos para proporcionarle y mejorar { -brand-short-name } para todos. Siempre pedimos permiso antes de recibir información personal.
collection-privacy-notice = Aviso sobre privacidad
collection-health-report-telemetry-disabled = Ya no permite que { -vendor-short-name } capture datos técnicos y de interacción. Todos los datos anteriores se eliminarán en 30 días.
collection-health-report-telemetry-disabled-link = Saber más
collection-health-report =
    .label = Permitir a { -brand-short-name } enviar datos técnicos y de interacción a { -vendor-short-name }
    .accesskey = P
collection-health-report-link = Saber más
collection-studies =
    .label = Permitir que { -brand-short-name } instale y ejecute estudios
collection-studies-link = Ver los estudios de { -brand-short-name }
addon-recommendations =
    .label = Permitir que { -brand-short-name } haga recomendaciones personalizadas de extensiones
addon-recommendations-link = Saber más
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = La recopilación de datos está deshabilitada en esta configuración de compilación
collection-backlogged-crash-reports =
    .label = Permitir que { -brand-short-name } envíe los informes de fallos pendientes en su nombre
    .accesskey = r
collection-backlogged-crash-reports-link = Saber más
collection-backlogged-crash-reports-with-link = Permitir que { -brand-short-name } envíe informes de fallos acumulados en su nombre <a data-l10n-name="crash-reports-link">Saber más</a>
    .accesskey = c

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Seguridad
security-browsing-protection = Protección contra contenido engañoso y software peligroso
security-enable-safe-browsing =
    .label = Bloquear contenido peligroso y engañoso
    .accesskey = B
security-enable-safe-browsing-link = Saber más
security-block-downloads =
    .label = Bloquear descargas peligrosas
    .accesskey = d
security-block-uncommon-software =
    .label = Advertirle sobre software no deseado y poco usual
    .accesskey = v

## Privacy Section - Certificates

certs-header = Certificados
certs-personal-label = Cuando un servidor solicite su certificado personal
certs-select-auto-option =
    .label = Seleccionar uno automáticamente
    .accesskey = S
certs-select-ask-option =
    .label = Preguntar cada vez
    .accesskey = P
certs-enable-ocsp =
    .label = Consultar a los servidores respondedores OCSP para confirmar la validez actual de los certificados
    .accesskey = u
certs-view =
    .label = Ver certificados…
    .accesskey = e
certs-devices =
    .label = Dispositivos de seguridad…
    .accesskey = D
space-alert-learn-more-button =
    .label = Saber más
    .accesskey = S
space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] Abrir opciones
           *[other] Abrir preferencias
        }
    .accesskey =
        { PLATFORM() ->
            [windows] A
           *[other] A
        }
space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] { -brand-short-name } se está quedando sin espacio en el disco. Puede que los contenidos del sitio web no se muestren adecuadamente. Puede limpiar los datos almacenados en Opciones > Privacidad y seguridad > Cookies y datos del sitio.
       *[other] { -brand-short-name } necesita espacio en el disco. Puede que los contenidos del sitio web no se muestren adecuadamente. Puede limpiar los datos almacenados en Preferencias > Privacidad y seguridad > Cookies y datos del sitio.
    }
space-alert-under-5gb-ok-button =
    .label = De acuerdo, entendido
    .accesskey = u
space-alert-under-5gb-message = { -brand-short-name } se está quedando sin espacio en disco. Los contenidos del sitio web pueden no mostrarse correctamente. Visite "Saber más" para optimizar su uso de disco para mejorar la experiencia de navegación.
space-alert-over-5gb-settings-button =
    .label = Abrir ajustes
    .accesskey = A
space-alert-over-5gb-message2 = <strong>{ -brand-short-name } se está quedando sin espacio en disco. </strong>Los contenidos del sitio web pueden no mostrarse correctamente. Puede limpiar los datos de sitios guardados en Ajustes > Privacidad & Seguridad> Cookies y datos del sitio.
space-alert-under-5gb-message2 = <strong>{ -brand-short-name } se está quedando sin espacio en disco.</strong> Los contenidos del sitio web pueden no mostrarse correctamente. Visite “Saber más” para optimizar su uso de disco y mejorar la experiencia de navegación.

## Privacy Section - HTTPS-Only

httpsonly-header = Modo solo-HTTPS
httpsonly-description = HTTPS proporciona una conexión segura y cifrada entre { -brand-short-name } y los sitios web que visita. La mayoría de los sitios web admiten HTTPS, y si el modo solo-HTTPS está habilitado, entonces { -brand-short-name } actualizará todas las conexiones a HTTPS.
httpsonly-learn-more = Más información
httpsonly-radio-enabled =
    .label = Activar el modo solo-HTTPS en todas las ventanas
httpsonly-radio-enabled-pbm =
    .label = Activar el modo solo-HTTPS solamente en ventanas privadas
httpsonly-radio-disabled =
    .label = No activar el modo solo-HTTPS

## The following strings are used in the Download section of settings

desktop-folder-name = Escritorio
downloads-folder-name = Descargas
choose-download-folder-title = Elegir carpeta de descarga:
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Guardar archivos en { $service-name }
