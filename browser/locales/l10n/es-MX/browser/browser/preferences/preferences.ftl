# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Enviar a los sitios web una señal de “No rastrear”, significa que no quieres ser rastreado
do-not-track-learn-more = Aprender más
do-not-track-option-default-content-blocking-known =
    .label = Solo cuando { -brand-short-name } está configurado para bloquear los rastreadores conocidos
do-not-track-option-always =
    .label = Siempre
settings-page-title = Configuraciones
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
managed-notice = Tu organización gestiona el navegador.
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
pane-privacy-title = Privacidad y seguridad
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title3 = Sincronizar
category-sync3 =
    .tooltiptext = { pane-sync-title3 }
pane-experimental-title = Experimentos de { -brand-short-name }
category-experimental =
    .tooltiptext = Experimentos de { -brand-short-name }
pane-experimental-subtitle = Continuar con precaución
pane-experimental-search-results-header = Experimentos de { -brand-short-name }: proceder con precaución
pane-experimental-description2 = Modificar los parámetros de la configuración avanzada puede afectar el rendimiento o la seguridad de { -brand-short-name }.
pane-experimental-reset =
    .label = Restaurar predeterminados
    .accesskey = R
help-button-label = Soporte de { -brand-short-name }
addons-button-label = Complementos y temas
focus-search =
    .key = f
close-button =
    .aria-label = Cerrar

## Browser Restart Dialog

feature-enable-requires-restart = { -brand-short-name } debe reiniciarse para activar esta característica.
feature-disable-requires-restart = { -brand-short-name } debe reiniciarse para desactivar esta característica.
should-restart-title = Reiniciar { -brand-short-name }
should-restart-ok = Reiniciar { -brand-short-name } ahora
cancel-no-restart-button = Cancelar
restart-later = Reiniciar después

## Extension Control Notifications
##
## These strings are used to inform the user
## about changes made by extensions to browser settings.
##
## <img data-l10n-name="icon"/> is going to be replaced by the extension icon.
##
## Variables:
##   $name (String): name of the extension

# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlled-password-saving = Una extensión, <img data-l10n-name="icon"/> { $name }, está controlando esta configuración.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = Un complemento, <img data-l10n-name="icon"/> { $name }, está controlando esta configuración.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = Una extensión, <img data-l10n-name="icon"/> { $name }, requiere contenedor de pestañas.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = Una extensión, <img data-l10n-name="icon"/> { $name }, está controlando esta configuración.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = Una extensión, <img data-l10n-name="icon"/> { $name }, está controlando como { -brand-short-name } se conecta a internet.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Para habilitar la extensión ve a complementos de <img data-l10n-name="addons-icon"/> en el menú de<img data-l10n-name="menu-icon"/>.

## Preferences UI Search Results

search-results-header = Buscar resultados
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message2 = ¡Lo siento! No hay resultados en la Configuración para "<span data-l10n-name="query"></span>".
search-results-help-link = ¿Necesitas ayuda? Visita <a data-l10n-name="url">Apoyo de { -brand-short-name }</a>

## General Section

startup-header = Inicio
always-check-default =
    .label = Siempre revisar si { -brand-short-name } es tu navegador predeterminado
    .accesskey = S
is-default = { -brand-short-name } es tu navegador predeterminado
is-not-default = { -brand-short-name } no es tu navegador predeterminado
set-as-my-default-browser =
    .label = Hacer predeterminado…
    .accesskey = D
startup-restore-previous-session =
    .label = Restaurar sesión anterior
    .accesskey = s
startup-restore-windows-and-tabs =
    .label = Abrir ventanas y pestañas anteriores
    .accesskey = s
startup-restore-warn-on-quit =
    .label = Advertir al salir del navegador
disable-extension =
    .label = Deshabilitar extensión
tabs-group-header = Pestañas
ctrl-tab-recently-used-order =
    .label = Ctrl + Tab recorre pestañas según su uso reciente
    .accesskey = T
open-new-link-as-tabs =
    .label = Abrir enlaces en pestañas en lugar de nuevas ventanas
    .accesskey = w
warn-on-close-multiple-tabs =
    .label = Avisarme al cerrar varias pestañas
    .accesskey = m
# This string is used for the confirm before quitting preference.
# Variables:
#   $quitKey (String) - the quit keyboard shortcut, and formatted
#                       in the same manner as it would appear,
#                       for example, in the File menu.
confirm-on-quit-with-key =
    .label = Confirmar antes de salir con { $quitKey }
    .accesskey = b
warn-on-open-many-tabs =
    .label = Avisarme si al abrir muchas pestañas { -brand-short-name } se pueda poner lento
    .accesskey = d
switch-to-new-tabs =
    .label = Cuando abras un enlace, imagen o un medio en una nueva pestaña, cambiar inmediatamente a ella
    .accesskey = h
show-tabs-in-taskbar =
    .label = Mostrar vista previa de las pestañas en la barra de tareas de Windows
    .accesskey = t
browser-containers-enabled =
    .label = Habilitar pestañas contenedoras
    .accesskey = n
browser-containers-learn-more = Saber más
browser-containers-settings =
    .label = Configuración…
    .accesskey = i
containers-disable-alert-title = ¿Cerrar todo el contenedor de pestañas?
containers-disable-alert-desc =
    { $tabCount ->
        [one] Si deshabilitas las pestañas contenedoras ahora, { $tabCount } pestaña contenedora se cerrará. ¿Seguro que deseas deshabilitar pestañas contenedoras?
       *[other] Si deshabilitas las pestañas contenedoras ahora, { $tabCount } pestañas contenedoras se cerrarán. ¿Seguro que deseas deshabilitar las pestañas contenedoras?
    }
containers-disable-alert-ok-button =
    { $tabCount ->
        [one] Cerrar { $tabCount } pestaña contenedora
       *[other] Cerrar { $tabCount } pestañas contenedoras
    }
containers-disable-alert-cancel-button = Mantenerlas habilitadas
containers-remove-alert-title = ¿Eliminar el marcador?
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Si eliminas este marcador ahora, la pestaña del marcador { $count } se cerrará. ¿Estás seguro de que quieres eliminar este marcador?
       *[other] Si eliminas este marcador ahora, las pestañas del marcador { $count } se cerrarán. ¿Estás seguro de que quieres eliminar este marcador?
    }
containers-remove-ok-button = Eliminar este marcador
containers-remove-cancel-button = No eliminar este marcador

## General Section - Language & Appearance

language-and-appearance-header = Idioma y apariencia
fonts-and-colors-header = Tipografías y colores
default-font = Fuente predeterminada
    .accesskey = D
default-font-size = Tamaño
    .accesskey = S
advanced-fonts =
    .label = Avanzadas…
    .accesskey = A
colors-settings =
    .label = Colores…
    .accesskey = C
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Zoom
preferences-default-zoom = Zoom predeterminado
    .accesskey = Z
preferences-default-zoom-value =
    .label = { $percentage }%
preferences-zoom-text-only =
    .label = Hacer zoom en el texto solamente
    .accesskey = t
language-header = Idioma
choose-language-description = Elegir el idioma preferido para mostrar las páginas web
choose-button =
    .label = Seleccionar…
    .accesskey = o
choose-browser-language-description = Elegir los idiomas usados para mostrar menús, mensajes y notificaciones de { -brand-short-name }.
manage-browser-languages-button =
    .label = Establecer alternativos
    .accesskey = l
confirm-browser-language-change-description = Reiniciar { -brand-short-name } para aplicar los cambios
confirm-browser-language-change-button = Aplicar y reiniciar
translate-web-pages =
    .label = Traducir contenido web
    .accesskey = T
fx-translate-web-pages = { -translations-brand-name }
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Traducciones por <img data-l10n-name="logo"/>
translate-exceptions =
    .label = Excepciones…
    .accesskey = x
# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = Usar la configuración de tu sistema operativo para “{ $localeName }” para dar formato a fechas, horas, números y medidas.
check-user-spelling =
    .label = Verificar la ortografía mientras escribes
    .accesskey = t

## General Section - Files and Applications

files-and-applications-title = Archivos y aplicaciones
download-header = Descargas
download-save-to =
    .label = Guardar automáticamente en
    .accesskey = G
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Elegir…
           *[other] Examinar…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] E
           *[other] x
        }
download-always-ask-where =
    .label = Siempre preguntarme dónde guardar archivos
    .accesskey = A
applications-header = Aplicaciones
applications-description = Decide cómo { -brand-short-name } gestiona los archivos que descargas de la Web o las aplicaciones que utilizas mientras navegas.
applications-filter =
    .placeholder = Buscar tipos de archivos o aplicaciones
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
    .label = Usar otro…
applications-select-helper = Selecciona una aplicación auxiliar
applications-manage-app =
    .label = Detalles de la aplicación…
applications-always-ask =
    .label = Preguntar siempre
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

drm-content-header = Contenido DRM (Digital Rights Management - Administración de Derechos Digitales)
play-drm-content =
    .label = Reproducir contenido controlado por DRM
    .accesskey = P
play-drm-content-learn-more = Saber más
update-application-title = { -brand-short-name } actualizaciones
update-application-description = Mantener { -brand-short-name } actualizado para el mejor rendimiento, estabilidad y seguridad.
update-application-version = Versión { $version } <a data-l10n-name="learn-more">Qué hay de nuevo</a>
update-history =
    .label = Mostrar historial de actualizaciones…
    .accesskey = p
update-application-allow-description = Quiero que { -brand-short-name }
update-application-auto =
    .label = Instale actualizaciones automáticamente (recomendado)
    .accesskey = I
update-application-check-choose =
    .label = Buscar actualizaciones, pero permitirle elegir si instalarlas
    .accesskey = B
update-application-manual =
    .label = Nunca busque actualizaciones (no recomendado)
    .accesskey = N
update-application-background-enabled =
    .label = Cuando { -brand-short-name } no se esté ejecutando
    .accesskey = C
update-application-warning-cross-user-setting = Este ajuste se aplicará a todas las cuentas de Windows y perfiles de { -brand-short-name } usando esta instalación de { -brand-short-name }.
update-application-use-service =
    .label = Utilizar un servicio en segundo plano para instalar las actualizaciones
    .accesskey = s
update-setting-write-failure-title2 = Error al guardar los ajustes de actualización
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message2 =
    { -brand-short-name } encontró un error y no guardó esta modificación. Ten en cuenta que cambiar este ajuste de actualización requiere permiso para escribir en el archivo siguiente. Tú o un administrador del sistema pueden resolver el error otorgando al grupo "Usuarios" el control total de este archivo.
    
    No se pudo escribir en el archivo: { $path }
update-in-progress-title = Actualización en curso
update-in-progress-message = ¿Quieres que { -brand-short-name } continúe con esta actualización?
update-in-progress-ok-button = &Descartar
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Continuar

## General Section - Performance

performance-title = Rendimiento
performance-use-recommended-settings-checkbox =
    .label = Usar las configuraciones de rendimiento recomendadas
    .accesskey = U
performance-use-recommended-settings-desc = Estas configuraciones se adaptan al hardware y sistema operativo de tu equipo.
performance-settings-learn-more = Aprender más
performance-allow-hw-accel =
    .label = Usa aceleración de hardware cuando esté disponible
    .accesskey = r
performance-limit-content-process-option = Número límite de proceso de contenido
    .accesskey = L
performance-limit-content-process-enabled-desc = Los procesos de contenido adicionales mejoran el rendimiento cuando se utilizan múltiples pestañas, pero también consumen más memoria.
performance-limit-content-process-blocked-desc = Es posible modificar el número de procesos de contenido solo con el multiproceso { -brand-short-name }. <a data-l10n-name="learn-more">Aprender a comprobar si el multiproceso está habilitado</a>
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (predeterminado)

## General Section - Browsing

browsing-title = Navegación
browsing-use-autoscroll =
    .label = Usar desplazamiento automático
    .accesskey = d
browsing-use-smooth-scrolling =
    .label = Usar desplazamiento suave
    .accesskey = s
browsing-use-onscreen-keyboard =
    .label = Mostrar el teclado táctil cuando sea necesario
    .accesskey = t
browsing-use-cursor-navigation =
    .label = Usar siempre las teclas del cursor para navegar dentro de las páginas
    .accesskey = c
browsing-search-on-start-typing =
    .label = Buscar el texto cuando empiezas a escribir
    .accesskey = x
browsing-picture-in-picture-toggle-enabled =
    .label = Habilitar controles de video picture-in-picture
    .accesskey = A
browsing-picture-in-picture-learn-more = Saber más
browsing-media-control =
    .label = Controla los medios con el teclado, los auriculares o la interfaz virtual
    .accesskey = v
browsing-media-control-learn-more = Saber más
browsing-cfr-recommendations =
    .label = Recomendar extensiones mientras se navega
    .accesskey = R
browsing-cfr-features =
    .label = Recomendar funciones mientras navegas
    .accesskey = R
browsing-cfr-recommendations-learn-more = Aprender más

## General Section - Proxy

network-settings-title = Configuración de conexión
network-proxy-connection-description = Configurar como { -brand-short-name } se conecta a internet.
network-proxy-connection-learn-more = Saber más
network-proxy-connection-settings =
    .label = Configurar…
    .accesskey = C

## Home Section

home-new-windows-tabs-header = Nuevas ventanas y pestañas
home-new-windows-tabs-description2 = Elige que quieres ver cuando abras tu página de inicio, nuevas ventanas y nuevas pestañas.

## Home Section - Home Page Customization

home-homepage-mode-label = Página de inicio y nuevas ventanas
home-newtabs-mode-label = Nuevas pestañas
home-restore-defaults =
    .label = Restaurar predeterminados
    .accesskey = R
# "Waterfox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Inicio de Waterfox (Predeterminado)
home-mode-choice-custom =
    .label = Personalizar URLs...
home-mode-choice-blank =
    .label = Página en blanco
home-homepage-custom-url =
    .placeholder = Pegar una URL...
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
    .accesskey = c
choose-bookmark =
    .label = Usar marcador…
    .accesskey = m

## Home Section - Waterfox Home Content Customization

home-prefs-content-header = Contenido de la página de inicio de Waterfox
home-prefs-content-description = Selecciona el contenido que desea en la pantalla de inicio de Waterfox.
home-prefs-search-header =
    .label = Búsqueda web
home-prefs-topsites-header =
    .label = Sitios populares
home-prefs-topsites-description = Los sitios que más visitas
home-prefs-topsites-by-option-sponsored =
    .label = Sitios principales patrocinados
home-prefs-shortcuts-header =
    .label = Atajos
home-prefs-shortcuts-description = Sitios que guardas o visitas
home-prefs-shortcuts-by-option-sponsored =
    .label = Atajos patrocinados

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Recomendado por { $provider }
home-prefs-recommended-by-description-update = Contenido excepcional de toda la web, seleccionado por { $provider }
home-prefs-recommended-by-description-new = Contenido excepcional seleccionado por { $provider }, parte de la familia { -brand-product-name }

##

home-prefs-recommended-by-learn-more = Cómo funciona
home-prefs-recommended-by-option-sponsored-stories =
    .label = Artículos patrocinados
home-prefs-highlights-header =
    .label = Destacados
home-prefs-highlights-description = Una selección de sitios que has guardado o visitado
home-prefs-highlights-option-visited-pages =
    .label = Páginas visitadas
home-prefs-highlights-options-bookmarks =
    .label = Marcadores
home-prefs-highlights-option-most-recent-download =
    .label = Descargado recientemente
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
    .label = Fragmentos
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
    .label = Usa la barra de direcciones para buscar y navegar
search-bar-shown =
    .label = Agregar barra de búsqueda en la barra de herramientas
search-engine-default-header = Buscador predeterminado
search-engine-default-desc-2 = Este es tu motor de búsqueda predeterminado en la barra de direcciones y en la barra de búsqueda. Puedes cambiarlo en cualquier momento.
search-engine-default-private-desc-2 = Elige un diferente motor de búsqueda predeterminado solamente para ventanas privadas
search-separate-default-engine =
    .label = Usar este motor de búsqueda en ventanas privadas
    .accesskey = U
search-suggestions-header = Buscar sugerencias
search-suggestions-desc = Seleccionar como las sugerencias del motor búsqueda aparecen.
search-suggestions-option =
    .label = Proporcionar sugerencias de búsqueda
    .accesskey = s
search-show-suggestions-url-bar-option =
    .label = Mostrar sugerencias de búsqueda en los resultados de la barra de direcciones
    .accesskey = l
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Mostrar sugerencias de búsqueda antes del historial de navegación en los resultados de la barra de direcciones
search-show-suggestions-private-windows =
    .label = Mostrar sugerencias de búsqueda en ventanas privadas
suggestions-addressbar-settings-generic2 = Cambiar la configuración para otras sugerencias de la barra de direcciones
search-suggestions-cant-show = Las sugerencias de búsqueda no se mostrarán en los resultados de la barra de direcciones porque has configurado { -brand-short-name } para que nunca recuerde el historial.
search-one-click-header2 = Atajos de búsqueda
search-one-click-desc = Elegir los motores de búsqueda alternativos que aparecen debajo de la barra de direcciones y en la barra de búsqueda cuando comienzas a escribir una palabra.
search-choose-engine-column =
    .label = Motor de búsqueda
search-choose-keyword-column =
    .label = Palabra clave
search-restore-default =
    .label = Restaurar motores de búsqueda predeterminados
    .accesskey = D
search-remove-engine =
    .label = Eliminar
    .accesskey = R
search-add-engine =
    .label = Agregar
    .accesskey = A
search-find-more-link = Encontrar más motores de búsqueda
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Palabra clave duplicada
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Seleccionaste una palabra clave usada por "{ $name }". Selecciona otra.
search-keyword-warning-bookmark = Seleccionaste una palabra clave usada por un marcador. Selecciona otra.

## Containers Section

containers-back-button2 =
    .aria-label = Volver a la configuración
containers-header = Pestañas contenedoras
containers-add-button =
    .label = Agregar un nuevo contenedor
    .accesskey = A
containers-new-tab-check =
    .label = Seleccionar un contenedor para cada nueva pestaña
    .accesskey = S
containers-settings-button =
    .label = Configuración
containers-remove-button =
    .label = Eliminar

## Waterfox Account - Signed out. Note that "Sync" and "Waterfox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Lleva la Web contigo
sync-signedout-description2 = Sincroniza tus marcadores, historial, pestañas, contraseñas, complementos y configuraciones en todos tus dispositivos.
sync-signedout-account-signin3 =
    .label = Iniciar sesión para sincronizar...
    .accesskey = I
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Descargar Waterfox para <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> o <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> para sincronizar con tu dispositivo móvil.

## Waterfox Account - Signed in

sync-profile-picture =
    .tooltiptext = Cambiar imagen de perfil
sync-sign-out =
    .label = Salir…
    .accesskey = g
sync-manage-account = Administrar cuenta
    .accesskey = o
sync-signedin-unverified = Determinando el estado de tu cuenta... { $email } no está verificado.
sync-signedin-login-failure = Inicia sesión para reconectar { $email } Favor de iniciar la sesión para reconectar
sync-resend-verification =
    .label = Enviar verificación nuevamente
    .accesskey = d
sync-remove-account =
    .label = Eliminar cuenta
    .accesskey = R
sync-sign-in =
    .label = Iniciar sesión
    .accesskey = g

## Sync section - enabling or disabling sync.

prefs-syncing-on = Sincronización: ACTIVADA
prefs-syncing-off = Sincronización: DESACTIVADA
prefs-sync-turn-on-syncing =
    .label = Activar sincronización...
    .accesskey = s
prefs-sync-offer-setup-label2 = Sincroniza tus marcadores, historial, pestañas, contraseñas, complementos y configuraciones en todos tus dispositivos.
prefs-sync-now =
    .labelnotsyncing = Sincronizar ahora
    .accesskeynotsyncing = N
    .labelsyncing = Sincronizando…

## The list of things currently syncing.

sync-currently-syncing-heading = Actualmente estás sincronizando estos elementos:
sync-currently-syncing-bookmarks = Marcadores
sync-currently-syncing-history = Historial
sync-currently-syncing-tabs = Abrir pestañas
sync-currently-syncing-logins-passwords = Inicios de sesión y contraseñas
sync-currently-syncing-addresses = Direcciones
sync-currently-syncing-creditcards = Tarjetas de crédito
sync-currently-syncing-addons = Complementos
sync-currently-syncing-settings = Configuración
sync-change-options =
    .label = Cambiar
    .accesskey = C

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = Elegir que sincronizar
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = Guardar cambios
    .buttonaccesskeyaccept = S
    .buttonlabelextra2 = Cerrar sesión…
    .buttonaccesskeyextra2 = D
sync-engine-bookmarks =
    .label = Marcadores
    .accesskey = M
sync-engine-history =
    .label = Historial
    .accesskey = r
sync-engine-tabs =
    .label = Abrir pestañas
    .tooltiptext = Una lista de qué está abierto en todos los dispositivos sincronizados
    .accesskey = t
sync-engine-logins-passwords =
    .label = Inicios de sesión y contraseñas
    .tooltiptext = Nombres de usuario y contraseñas guardadas
    .accesskey = L
sync-engine-addresses =
    .label = Direcciones
    .tooltiptext = Direcciones postales que guardaste (sólo escritorio)
    .accesskey = e
sync-engine-creditcards =
    .label = Tarjetas de crédito
    .tooltiptext = Nombre, números y fechas de expiración (sólo escritorio)
    .accesskey = C
sync-engine-addons =
    .label = Complementos
    .tooltiptext = Extensiones y temas para Waterfox para escritorio
    .accesskey = C
sync-engine-settings =
    .label = Configuración
    .tooltiptext = Ajustes generales, de privacidad y de seguridad que haz modificado
    .accesskey = C

## The device name controls.

sync-device-name-header = Nombre del dispositivo
sync-device-name-change =
    .label = Cambiar el nombre del dispositivo…
    .accesskey = h
sync-device-name-cancel =
    .label = Cancelar
    .accesskey = n
sync-device-name-save =
    .label = Guardar
    .accesskey = v
sync-connect-another-device = Conectar otro dispositivo

## Privacy Section

privacy-header = Navegación privada

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Inicios de sesión y contraseñas
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Preguntar para guardar inicios de sesión y contraseñas para los sitios web
    .accesskey = r
forms-exceptions =
    .label = Excepciones…
    .accesskey = x
forms-generate-passwords =
    .label = Sugiere y genera contraseñas fuertes
    .accesskey = u
forms-breach-alerts =
    .label = Mostrar alertas sobre contraseñas para sitios web comprometidos
    .accesskey = b
forms-breach-alerts-learn-more-link = Saber más
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Autollenar inicios de sesión y contraseñas
    .accesskey = i
forms-saved-logins =
    .label = Inicios de sesión guardados…
    .accesskey = I
forms-primary-pw-use =
    .label = Utilizar una contraseña principal
    .accesskey = U
forms-primary-pw-learn-more-link = Más información
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = Cambiar contraseña maestra…
    .accesskey = m
forms-primary-pw-change =
    .label = Cambiar contraseña primaria…
    .accesskey = P
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = Anteriormente conocida como contraseña maestra
forms-primary-pw-fips-title = Actualmente estás en modo FIPS. FIPS requiere de una contraseña principal que no esté en blanco.
forms-master-pw-fips-desc = Error al cambiar la contraseña
forms-windows-sso =
    .label = Permitir un solo inicio de sesión de Windows para Microsoft, cuentas de trabajo y cuentas escolares
forms-windows-sso-learn-more-link = Saber más
forms-windows-sso-desc = Administrar las cuentas en la configuración de tu dispositivo

## OS Authentication dialog

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Para crear una contraseña principal hace falta proporcionar los datos de acceso de Windows. Esto ayuda a proteger la seguridad de las cuentas.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Waterfox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = crear una contraseña principal
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = Historial
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Waterfox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Waterfox", moving the verb into each option.
#     This will result in "Waterfox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Waterfox history settings:".
history-remember-label = { -brand-short-name }
    .accesskey = w
history-remember-option-all =
    .label = Recuerde el historial
history-remember-option-never =
    .label = No guarde el historial
history-remember-option-custom =
    .label = Utilice configuraciones personalizadas para el historial
history-remember-description = { -brand-short-name } recordará tu navegación, descargas, formularios e historial de búsqueda.
history-dontremember-description = { -brand-short-name } usará la misma configuración de la navegación privada, es decir, no guardará ningún historial de tu navegación.
history-private-browsing-permanent =
    .label = Siempre usar modo de navegación privada
    .accesskey = p
history-remember-browser-option =
    .label = Recordar historial de navegación y descargas
    .accesskey = h
history-remember-search-option =
    .label = Recordar el historial de búsquedas y formularios
    .accesskey = f
history-clear-on-close-option =
    .label = Borrar el historial al cerrar { -brand-short-name }
    .accesskey = B
history-clear-on-close-settings =
    .label = Configuración…
    .accesskey = C
history-clear-button =
    .label = Limpiar historial…
    .accesskey = s

## Privacy Section - Site Data

sitedata-header = Cookies y datos del sitio
sitedata-total-size-calculating = Calculando tamaño de los datos del sitio y el caché…
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Tus cookies, datos del sitio y caché almacenados ocupan actualmente un { $value } { $unit } del espacio en disco.
sitedata-learn-more = Aprender más
sitedata-delete-on-close =
    .label = Eliminar cookies y datos del sitio cuando se cierra { -brand-short-name }
    .accesskey = c
sitedata-delete-on-close-private-browsing = En el modo de navegación privada permanente, las cookies y los datos del sitio se borrarán siempre cuando se cierre { -brand-short-name }.
sitedata-allow-cookies-option =
    .label = Aceptar cookies y datos del sitio
    .accesskey = A
sitedata-disallow-cookies-option =
    .label = Bloquear cookies y datos del sitio
    .accesskey = B
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Tipo de contenido bloqueado
    .accesskey = T
sitedata-option-block-cross-site-trackers =
    .label = Rastreadores multisitio
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = Rastreadores multisitio y de red social
sitedata-option-block-cross-site-tracking-cookies-including-social-media =
    .label = Cookies de rastreo entre sitios — incluye las cookies de redes sociales
sitedata-option-block-cross-site-cookies-including-social-media =
    .label = Cookies entre sitios — incluye las cookies de redes sociales
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = Rastreadores de sitios cruzados y redes sociales, y aislación del resto de las cookies
sitedata-option-block-unvisited =
    .label = Cookies de sitios web no visitados
sitedata-option-block-all-third-party =
    .label = Todas las cookies de terceros (puede causar errores en los sitios web)
sitedata-option-block-all =
    .label = Todas las cookies (causará errores en los sitios web)
sitedata-clear =
    .label = Limpiar datos…
    .accesskey = l
sitedata-settings =
    .label = Administrar datos…
    .accesskey = M
sitedata-cookies-exceptions =
    .label = Administrar excepciones...
    .accesskey = x

## Privacy Section - Address Bar

addressbar-header = Barra de direcciones
addressbar-suggest = Cuando se use la barra de direcciones, sugerir
addressbar-locbar-history-option =
    .label = Historial de navegación
    .accesskey = H
addressbar-locbar-bookmarks-option =
    .label = Marcadores
    .accesskey = M
addressbar-locbar-openpage-option =
    .label = Abrir pestañas
    .accesskey = O
# Shortcuts refers to the shortcut tiles on the new tab page, previously known as top sites. Translation should be consistent.
addressbar-locbar-shortcuts-option =
    .label = Accesos directos
    .accesskey = S
addressbar-locbar-topsites-option =
    .label = Sitios frecuentes
    .accesskey = t
addressbar-locbar-engines-option =
    .label = Motores de búsqueda
    .accesskey = a
addressbar-suggestions-settings = Cambiar las preferencias para las sugerencias del motor de navegación

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Protección antirrastreo mejorada
content-blocking-section-top-level-description = Los rastreadores le siguen en línea para recopilar información sobre sus hábitos e intereses de navegación. { -brand-short-name } bloquea muchos de estos rastreadores y otros scripts maliciosos.
content-blocking-learn-more = Saber más
content-blocking-fpi-incompatibility-warning = Está usando First Party Isolation (FPI), que anula algunas de las configuraciones de cookies de { -brand-short-name }.

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Estándar
    .accesskey = E
enhanced-tracking-protection-setting-strict =
    .label = Estricto
    .accesskey = r
enhanced-tracking-protection-setting-custom =
    .label = Personalizar
    .accesskey = P

##

content-blocking-etp-standard-desc = Equilibrada entre protección y rendimiento. Las páginas se cargarán con normalidad.
content-blocking-etp-strict-desc = Protección más elevada, pero puede causar que algunos sitios o contenidos fallen.
content-blocking-etp-custom-desc = Elige cuáles rastreadores y scripts quieres bloquear.
content-blocking-etp-blocking-desc = { -brand-short-name } bloquea lo siguiente:
content-blocking-private-windows = Contenido de rastreo en ventanas privadas
content-blocking-cross-site-cookies-in-all-windows = Cookies de sitios cruzados en todas las ventanas (incluye cookies de rastreo)
content-blocking-cross-site-tracking-cookies = Cookies de rastreo multisitio
content-blocking-all-cross-site-cookies-private-windows = Cookies de sitios cruzados en ventanas privadas
content-blocking-cross-site-tracking-cookies-plus-isolate = Cookies de rastreo de sitios cruzados, y aislación del resto de las cookies
content-blocking-social-media-trackers = Rastreadores de red social
content-blocking-all-cookies = Todas las cookies
content-blocking-unvisited-cookies = Cookies de sitios no visitados
content-blocking-all-windows-tracking-content = Contenido de rastreo en todas las ventanas
content-blocking-all-third-party-cookies = Todas las cookies de terceros
content-blocking-cryptominers = Criptomineros
content-blocking-fingerprinters = Huellas dactilares
content-blocking-warning-title = ¡Atención!
content-blocking-and-isolating-etp-warning-description = Bloquear los rastreadores y aislar las cookies puede impactar en la funcionalidad de algunos sitios. Recarga una página con rastreadores para cargar todo el contenido.
content-blocking-and-isolating-etp-warning-description-2 = Este ajuste puede hacer que algunos sitios web no muestren contenido o que no funcionen correctamente. Si un sitio parece roto, puede que desees desactivar la protección contra seguimiento para que ese sitio cargue todo el contenido.
content-blocking-warning-learn-how = Aprende cómo
content-blocking-reload-description = Tendrás que volver a cargar tus pestañas para aplicar estos cambios.
content-blocking-reload-tabs-button =
    .label = Recargar todas las pestañas
    .accesskey = R
content-blocking-tracking-content-label =
    .label = Contenido de rastreo
    .accesskey = C
content-blocking-tracking-protection-option-all-windows =
    .label = En todas las ventanas
    .accesskey = A
content-blocking-option-private =
    .label = Solo en ventanas privadas
    .accesskey = P
content-blocking-tracking-protection-change-block-list = Cambiar listas de bloqueo
content-blocking-cookies-label =
    .label = Cookies
    .accesskey = C
content-blocking-expand-section =
    .tooltiptext = Más información
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Criptomineros
    .accesskey = y
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Fingerprinters
    .accesskey = F

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Administrar excepciones
    .accesskey = x

## Privacy Section - Permissions

permissions-header = Permisos
permissions-location = Ubicación
permissions-location-settings =
    .label = Ajustes…
    .accesskey = l
permissions-xr = Realidad virtual
permissions-xr-settings =
    .label = Ajustes…
    .accesskey = t
permissions-camera = Cámara
permissions-camera-settings =
    .label = Ajustes…
    .accesskey = c
permissions-microphone = Micrófono
permissions-microphone-settings =
    .label = Ajustes…
    .accesskey = m
permissions-notification = Notificaciones
permissions-notification-settings =
    .label = Ajustes…
    .accesskey = n
permissions-notification-link = Saber más
permissions-notification-pause =
    .label = Pausar las notificaciones hasta que { -brand-short-name } reinicie
    .accesskey = n
permissions-autoplay = Reproducción automática
permissions-autoplay-settings =
    .label = Configuración…
    .accesskey = C
permissions-block-popups =
    .label = Bloquear ventanas emergentes
    .accesskey = B
permissions-block-popups-exceptions =
    .label = Excepciones…
    .accesskey = E
# "popup" is a misspelling that is more popular than the correct spelling of
# "pop-up" so it's included as a search keyword, not displayed in the UI.
permissions-block-popups-exceptions-button =
    .label = Excepciones…
    .accesskey = E
    .searchkeywords = emergentes
permissions-addon-install-warning =
    .label = Advertirte cuando los sitios web intenten instalar complementos
    .accesskey = W
permissions-addon-exceptions =
    .label = Excepciones…
    .accesskey = E

## Privacy Section - Data Collection

collection-header = Recolección de datos y uso de { -brand-short-name }
collection-description = Nos esforzamos en proporcionar opciones y recolectar solamente lo que necesitamos para proveer y mejorar { -brand-short-name } para todo el mundo. Siempre pedimos permiso antes de recibir información personal.
collection-privacy-notice = Política de privacidad
collection-health-report-telemetry-disabled = Ya no permites que { -vendor-short-name } capture datos técnicos y de interacción. Todos los datos anteriores se eliminarán en 30 días.
collection-health-report-telemetry-disabled-link = Saber más
collection-health-report =
    .label = Permitir que { -brand-short-name } envíe información técnica y de interacción a { -vendor-short-name }
    .accesskey = r
collection-health-report-link = Saber más
collection-studies =
    .label = Permitir { -brand-short-name } para instalar y ejecutar estudios
collection-studies-link = Ver estudios de { -brand-short-name }
addon-recommendations =
    .label = Permitir que { -brand-short-name } haga recomendaciones personalizadas de extensiones
addon-recommendations-link = Saber más
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = El reporte de datos está deshabilitado para esta configuración de compilación
collection-backlogged-crash-reports-with-link = Permitir que { -brand-short-name } envié informes de fallos acumulados en tu nombre. <a data-l10n-name="crash-reports-link">Aprender más</a>
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
    .accesskey = D
security-block-uncommon-software =
    .label = Te avisa de software no solicitado y poco común
    .accesskey = C

## Privacy Section - Certificates

certs-header = Certificados
certs-enable-ocsp =
    .label = Consultar servidores de respuesta OCSP para confirmar la validez actual de los certificados
    .accesskey = O
certs-view =
    .label = Ver certificados…
    .accesskey = C
certs-devices =
    .label = Dispositivos de seguridad…
    .accesskey = D
space-alert-over-5gb-settings-button =
    .label = Abrir ajustes
    .accesskey = A
space-alert-over-5gb-message2 = <strong>{ -brand-short-name } se está quedando sin espacio en disco. </strong> Los contenidos del sitio web pueden no mostrarse correctamente. Puede limpiar los datos de sitios guardados en Ajustes > Privacidad y Seguridad > Cookies y datos del sitio.
space-alert-under-5gb-message2 = <strong>{ -brand-short-name } se está quedando sin espacio en disco. </strong> los contenidos de los sitios web no pueden mostrarse correctamente. Visita “Saber más” para optimizar el uso del disco para una mejor experiencia de navegación.

## Privacy Section - HTTPS-Only

httpsonly-header = Modo solo HTTPS
httpsonly-description = HTTPS proporciona una conexión segura y cifrada entre { -brand-short-name } y los sitios web que visitas. La mayoría de los sitios web admiten HTTPS, y si el modo HTTPS-Only está habilitado, entonces { -brand-short-name } actualizará todas las conexiones a HTTPS.
httpsonly-learn-more = Saber más
httpsonly-radio-enabled =
    .label = Habilitar el modo solo HTTPS en todas las ventanas
httpsonly-radio-enabled-pbm =
    .label = Habilitar el modo solo HTTPS solo en ventanas privadas
httpsonly-radio-disabled =
    .label = No habilitar el modo solo HTTPS

## The following strings are used in the Download section of settings

desktop-folder-name = Escritorio
downloads-folder-name = Descargas
choose-download-folder-title = Selecciona la carpeta que almacenará las descargas:
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Guardar archivos en { $service-name }
