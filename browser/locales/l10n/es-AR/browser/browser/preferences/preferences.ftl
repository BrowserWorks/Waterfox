# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Enviar a los sitios web una señal de "No rastrear" que significa que no quiere ser rastreado
do-not-track-learn-more = Conocer más
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
            [windows] Buscar en opciones
           *[other] Buscar en preferencias
        }
managed-notice = El navegador está administrado por su organización.
pane-general-title = General
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = Inicio
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = Búsquedas
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = Privacidad y seguridad
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }
pane-experimental-title = Experimentos { -brand-short-name }
category-experimental =
    .tooltiptext = Experimentos { -brand-short-name }
pane-experimental-subtitle = Proceder con precaución
pane-experimental-search-results-header = { -brand-short-name } Experimentos: proceder con precaución
pane-experimental-description = Cambiar las preferencias de configuración avanzada puede afectar el rendimiento o la seguridad de { -brand-short-name }.
help-button-label = Soporte de { -brand-short-name }
addons-button-label = Extensiones y temas
focus-search =
    .key = f
close-button =
    .aria-label = Cerrar

## Browser Restart Dialog

feature-enable-requires-restart = { -brand-short-name } debe reiniciarse para habilitar esta característica.
feature-disable-requires-restart = { -brand-short-name } debe reiniciarse para deshabilitar esta característica.
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

# This string is shown to notify the user that their home page
# is being controlled by an extension.
extension-controlled-homepage-override = La extensión <img data-l10n-name="icon"/> { $name } controla su página de inicio.
# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = Una extensión, <img data-l10n-name="icon"/> { $name }, controla la página de pestaña nueva.
# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlled-password-saving = Una extensión, <img data-l10n-name="icon"/> { $name }, está controlando esta configuración.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = Una extensión, <img data-l10n-name="icon"/> { $name }, está controlando esta configuración.
# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = Una extensión, <img data-l10n-name="icon"/> { $name }, ha cambiado el buscador predeterminado.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = Una extensión, <img data-l10n-name="icon"/> { $name }, precisa de pestañas Contenedoras.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = Una extensión, <img data-l10n-name="icon"> { $name }, está controlando esta configuración.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = Una extensión, <img data-l10n-name="icon"/> { $name }, está controlando cómo { -brand-short-name } se conecta a Internet.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Para habilitar la extensión vaya a <img data-l10n-name="addons-icon"/> Complementos en el menú <img data-l10n-name="menu-icon"/>.

## Preferences UI Search Results

search-results-header = Resultados de búsqueda
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] ¡Lo sentimos! No hay resultados en opciones para “<span data-l10n-name="query"></span>”.
       *[other] ¡Lo sentimos! No hay resultados en preferencias para “<span data-l10n-name="query"></span>”.
    }
search-results-help-link = ¿Necesita ayuda? Visite <a data-l10n-name="url">Ayuda de { -brand-short-name }</a>

## General Section

startup-header = Inicio
# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = Permitir que { -brand-short-name } y Firefox se ejecuten al mismo tiempo
use-firefox-sync = Consejo: Esta opción usa perfiles separados. Use { -sync-brand-short-name } para compartir datos entre ellos.
get-started-not-logged-in = Ingresar a { -sync-brand-short-name }…
get-started-configured = Abrir preferencias de { -sync-brand-short-name }
always-check-default =
    .label = Siempre verificar si { -brand-short-name } es el navegador predeterminado
    .accesskey = g
is-default = { -brand-short-name } es actualmente su navegador predeterminado
is-not-default = { -brand-short-name } no es su navegador predeterminado
set-as-my-default-browser =
    .label = Hacer predeterminado…
    .accesskey = D
startup-restore-previous-session =
    .label = Restaurar sesión previa
    .accesskey = s
startup-restore-warn-on-quit =
    .label = Avisarle cuando salgas del navegador.
disable-extension =
    .label = Deshabilitar extensión
tabs-group-header = Pestañas
ctrl-tab-recently-used-order =
    .label = Ctrl+Tab rota las pestañas según su uso reciente
    .accesskey = T
open-new-link-as-tabs =
    .label = Abrir enlaces en pestañas en lugar de ventanas nuevas
    .accesskey = b
warn-on-close-multiple-tabs =
    .label = Avisarme cuando cierre múltiples pestañas
    .accesskey = m
warn-on-open-many-tabs =
    .label = Avisarme cuando abrir múltiples pestañas pueda hacer más lento a { -brand-short-name }
    .accesskey = d
switch-links-to-new-tabs =
    .label = Cuando abra un enlace en una nueva pestaña, cambiar a ella inmediatamente
    .accesskey = u
show-tabs-in-taskbar =
    .label = Mostrar vista previa de pestañas en la barra de tareas de Windows
    .accesskey = v
browser-containers-enabled =
    .label = Habilitar pestañas contenedoras
    .accesskey = n
browser-containers-learn-more = Conocer más
browser-containers-settings =
    .label = Configuración…
    .accesskey = i
containers-disable-alert-title = ¿Cerrar todas las pestañas contenedoras?
containers-disable-alert-desc =
    { $tabCount ->
        [one] Si se deshabilitan las pestañas contenedoras ahora, { $tabCount } pestaña contenedora se cerrará. ¿Seguro desea deshabilitar pestañas contenedoras?
       *[other] Si se deshabilitan las pestañas contenedoras ahora, { $tabCount } pestañas contenedoras se cerrarán. ¿Seguro desea deshabilitar pestañas contenedoras?
    }
containers-disable-alert-ok-button =
    { $tabCount ->
        [one] Cerrar { $tabCount } pestaña contenedora
       *[other] Cerrar { $tabCount } pestañas contenedoras
    }
containers-disable-alert-cancel-button = Mantener habilitadas
containers-remove-alert-title = ¿Eliminar este contenedor?
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Si elimina este contenedor ahora, { $count } pestaña contenedora se cerrará. ¿Está seguro de querer eliminar este contenedor?
       *[other] Si elimina este contenedor ahora, { $count } pestañas contenedoras se cerrarán. ¿Está seguro de querer eliminar este contenedor?
    }
containers-remove-ok-button = Eliminar este contenedor
containers-remove-cancel-button = No eliminar este contenedor

## General Section - Language & Appearance

language-and-appearance-header = Idioma y apariencia
fonts-and-colors-header = Fuentes y colores
default-font = Fuente por defecto
    .accesskey = D
default-font-size = Tamaño
    .accesskey = T
advanced-fonts =
    .label = Avanzado…
    .accesskey = z
colors-settings =
    .label = Colores…
    .accesskey = C
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Zoom
preferences-default-zoom = Zoom predeterminado
    .accesskey = z
preferences-default-zoom-value =
    .label = { $percentage }%
preferences-zoom-text-only =
    .label = Zoom solamente en el texto
    .accesskey = t
language-header = Idioma
choose-language-description = Seleccione su idioma preferido para mostrar las páginas
choose-button =
    .label = Seleccionar…
    .accesskey = o
choose-browser-language-description = Elegir los idiomas usados para mostrar menús, mensajes y notificaciones de { -brand-short-name }.
manage-browser-languages-button =
    .label = Establecer alternativos...
    .accesskey = l
confirm-browser-language-change-description = Reinicie { -brand-short-name } para aplicar estos cambios
confirm-browser-language-change-button = Aplicar y reiniciar
translate-web-pages =
    .label = Traducir contenido web
    .accesskey = T
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Traducciones por <img data-l10n-name="logo"/>
translate-exceptions =
    .label = Excepciones…
    .accesskey = x
# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = Use la configuración de su sistema operativo para "{ $localeName }" para formatear fechas, horas, números y medidas.
check-user-spelling =
    .label = Verificar ortografía al escribir
    .accesskey = t

## General Section - Files and Applications

files-and-applications-title = Archivos y aplicaciones
download-header = Descargas
download-save-to =
    .label = Guardar archivos en
    .accesskey = v
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Seleccionar…
           *[other] Examinar…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] e
           *[other] x
        }
download-always-ask-where =
    .label = Siempre preguntarme dónde guardar archivos
    .accesskey = S
applications-header = Aplicaciones
applications-description = Elegir cómo { -brand-short-name } administra los archivos descargados desde la web o las aplicaciones que se usan al navegar.
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
    .label = Usar otra…
applications-select-helper = Seleccionar aplicación
applications-manage-app =
    .label = Detalles de la aplicación…
applications-always-ask =
    .label = Siempre preguntar
applications-type-pdf = Formato de documento portable (PDF)
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

drm-content-header = Contenido con Digital Rights Management (DRM)
play-drm-content =
    .label = Reproducir contenido controlado por DRM-
    .accesskey = p
play-drm-content-learn-more = Conocer más
update-application-title = Actualizaciones de { -brand-short-name }
update-application-description = Hay que mantener a { -brand-short-name } actualizado para un mejor rendimiento, estabilidad y seguridad.
update-application-version = Versión { $version } <a data-l10n-name="learn-more">Que hay de nuevo</a>
update-history =
    .label = Mostrar historial de actualizaciones…
    .accesskey = h
update-application-allow-description = Permitir que { -brand-short-name }
update-application-auto =
    .label = Instale actualizaciones automáticamente (recomendado)
    .accesskey = a
update-application-check-choose =
    .label = Busque actualizaciones pero dejarme elegir si las instalo
    .accesskey = C
update-application-manual =
    .label = No buscar actualizaciones (no recomendado)
    .accesskey = N
update-application-warning-cross-user-setting = Esta configuración se aplicará a todas las cuentas de Windows y los perfiles de { -brand-short-name } usando esta instalación de { -brand-short-name }.
update-application-use-service =
    .label = Usar un servicio en segundo plano para instalar actualizaciones
    .accesskey = U
update-setting-write-failure-title = Error al guardar las preferencias de actualización
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } encontró un error y no guardó este cambio. Tenga en cuenta que la configuración de esta preferencia de actualización requiere permiso para escribir en el archivo a continuación. Es posible que usted o un administrador del sistema puedan resolver el error otorgando al grupo de Usuarios el control total de este archivo.
    
    No se pudo escribir en el archivo: { $path }
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
performance-use-recommended-settings-desc = Esta configuración se ajusta al hardware y sistema operativo de su computadora.
performance-settings-learn-more = Conocer más
performance-allow-hw-accel =
    .label = Usar aceleración por hardware cuando esté disponible
    .accesskey = h
performance-limit-content-process-option = Límite del proceso de contenido
    .accesskey = L
performance-limit-content-process-enabled-desc = Los procesos de contenido adicionales pueden mejorar el rendimiento cuando se usan múltiples pestañas pero también consumirán más memoria.
performance-limit-content-process-blocked-desc = Modificar el número de procesos contenidos sólo es posible con multiproceso { -brand-short-name }. <a data-l10n-name="learn-more">Aprender a comprobar si multiproceso está habilitado</a>
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (predeterminado)

## General Section - Browsing

browsing-title = Navegar
browsing-use-autoscroll =
    .label = Usar desplazamiento automático
    .accesskey = a
browsing-use-smooth-scrolling =
    .label = Usar desplazamiento suave
    .accesskey = s
browsing-use-onscreen-keyboard =
    .label = Mostrar un teclado táctil cuando sea necesario
    .accesskey = M
browsing-use-cursor-navigation =
    .label = Siempre usar las teclas del cursor para navegar entre páginas
    .accesskey = c
browsing-search-on-start-typing =
    .label = Buscar texto al empezar a escribir
    .accesskey = x
browsing-picture-in-picture-toggle-enabled =
    .label = Habilitar controles de video picture-in-picture
    .accesskey = e
browsing-picture-in-picture-learn-more = Conocer más
browsing-cfr-recommendations =
    .label = Recomendar extensiones mientras se navega
    .accesskey = R
browsing-cfr-features =
    .label = Recomendar funciones mientras navega
    .accesskey = f
browsing-cfr-recommendations-learn-more = Conocer más

## General Section - Proxy

network-settings-title = Configuración de la conexión
network-proxy-connection-description = Configurar cómo { -brand-short-name } se conecta con Internet.
network-proxy-connection-learn-more = Conocer más
network-proxy-connection-settings =
    .label = Configuración…
    .accesskey = C

## Home Section

home-new-windows-tabs-header = Nuevas ventanas y pestañas
home-new-windows-tabs-description2 = Elija lo que se ve al abrir su página principal, ventanas nuevas y nuevas pestañas.

## Home Section - Home Page Customization

home-homepage-mode-label = Inicio y nuevas ventanas
home-newtabs-mode-label = Nuevas pestañas
home-restore-defaults =
    .label = Restaurar predeterminados
    .accesskey = R
# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Inicio de Firefox (Predeterminado)
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
    .accesskey = c
choose-bookmark =
    .label = Usar un marcador…
    .accesskey = m

## Home Section - Firefox Home Content Customization

home-prefs-content-header = Contenido de la página de inicio de Firefox
home-prefs-content-description = Elija qué contenido desea en la Pantalla de inicio de Firefox.
home-prefs-search-header =
    .label = Búsqueda en la web
home-prefs-topsites-header =
    .label = Más visitados
home-prefs-topsites-description = Los sitios que más visita

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Recomendado por { $provider }
home-prefs-recommended-by-description-update = Contenido excepcional de toda la web  por patrocinado por { $provider }

##

home-prefs-recommended-by-learn-more = Cómo funciona
home-prefs-recommended-by-option-sponsored-stories =
    .label = Historias patrocinadas
home-prefs-highlights-header =
    .label = Destacados
home-prefs-highlights-description = Una selección de sitios que guardó o visitó
home-prefs-highlights-option-visited-pages =
    .label = Sitios visitados
home-prefs-highlights-options-bookmarks =
    .label = Marcadores
home-prefs-highlights-option-most-recent-download =
    .label = Descargado recientemente
home-prefs-highlights-option-saved-to-pocket =
    .label = Páginas guardadas en { -pocket-brand-name }
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Recortes
home-prefs-snippets-description = Actualizaciones de { -vendor-short-name } y { -brand-product-name }
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] fila de { $num }
           *[other] filas de { $num }
        }

## Search Section

search-bar-header = Barra de búsqueda
search-bar-hidden =
    .label = Usar la barra de direcciones para buscar y navegar
search-bar-shown =
    .label = Agregar barra de búsqueda a la barra de herramientas
search-engine-default-header = Buscador predeterminado
search-engine-default-desc-2 = Este es su motor de búsqueda predeterminado en la barra de direcciones y la barra de búsqueda. Puede cambiarlo en cualquier momento.
search-engine-default-private-desc-2 = Establecer como motor de búsqueda predeterminado solo para ventanas privadas
search-separate-default-engine =
    .label = Utilice este motor de búsqueda en ventanas privadas
    .accesskey = U
search-suggestions-header = Sugerencias de búsqueda
search-suggestions-desc = Elija cómo aparecen las sugerencias de los motores de búsqueda.
search-suggestions-option =
    .label = Proveer sugerencias de búsqueda
    .accesskey = s
search-show-suggestions-url-bar-option =
    .label = Mostrar sugerencias de búsqueda en los resultados de la barra de direcciones
    .accesskey = M
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Mostrar sugerencias de búsqueda antes que el historial en los resultados de la barra de direcciones
search-show-suggestions-private-windows =
    .label = Mostrar sugerencias de búsqueda en pestañas privadas
suggestions-addressbar-settings-generic = Cambiar preferencias para otras sugerencias de la barra de direcciones
search-suggestions-cant-show = Las sugerencias de búsqueda no se mostrarán en la barra de direcciones porque ha configurado { -brand-short-name } para que nunca recuerde el historial.
search-one-click-header = Buscadores con un clic
search-one-click-desc = Seleccionar los buscadores alternativos que aparecen debajo de la barra de direcciones y barra de búsqueda al comenzar a escribir una palabra.
search-choose-engine-column =
    .label = Buscador
search-choose-keyword-column =
    .label = Palabra clave
search-restore-default =
    .label = Restaurar buscador predeterminado
    .accesskey = d
search-remove-engine =
    .label = Eliminar
    .accesskey = r
search-add-engine =
    .label = Agregar
    .accesskey = A
search-find-more-link = Agregar más buscadores
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Palabra clave duplicada
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Ha elegido una palabra clave que está actualmente en uso por "{ $name }". Seleccione otra.
search-keyword-warning-bookmark = Ha elegido una palabra clave que está actualmente en uso por un marcador. Seleccione otra.

## Containers Section

containers-back-button =
    .aria-label =
        { PLATFORM() ->
            [windows] Regresar a Opciones
           *[other] Regresar a Preferencias
        }
containers-header = Pestañas contenedoras
containers-add-button =
    .label = Agregar nuevo contenedor
    .accesskey = A
containers-new-tab-check =
    .label = Seleccionar un contenedor para cada nueva pestaña
    .accesskey = S
containers-preferences-button =
    .label = Preferencias
containers-remove-button =
    .label = Eliminar

## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Llévese la web con usted
sync-signedout-description = Sincronice marcadores, historial, pestañas, contraseñas, complementos y preferencias en todos sus dispositivos.
sync-signedout-account-signin2 =
    .label = Iniciar sesión en { -sync-brand-short-name }…
    .accesskey = i
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
    .tooltiptext = Cambiar imagen de perfil
sync-sign-out =
    .label = Cerrar sesión…
    .accesskey = g
sync-manage-account = Administrar cuenta
    .accesskey = u
sync-signedin-unverified = { $email } no está verificada.
sync-signedin-login-failure = Ingrese para reconectar { $email }
sync-resend-verification =
    .label = Reenviar verificación
    .accesskey = e
sync-remove-account =
    .label = Eliminar cuenta
    .accesskey = E
sync-sign-in =
    .label = Ingresar
    .accesskey = g

## Sync section - enabling or disabling sync.

prefs-syncing-on = Sincronización: activada
prefs-syncing-off = Sincronización: desactivada
prefs-sync-setup =
    .label = Configurar { -sync-brand-short-name }…
    .accesskey = S
prefs-sync-offer-setup-label = Sincronice marcadores, historial, pestañas, contraseñas, complementos y preferencias en todos sus dispositivos.
prefs-sync-now =
    .labelnotsyncing = Sincronizar ahora
    .accesskeynotsyncing = N
    .labelsyncing = Sincronizando…

## The list of things currently syncing.

sync-currently-syncing-heading = En este momento está sincronizando estos elementos:
sync-currently-syncing-bookmarks = Marcadores
sync-currently-syncing-history = Historial
sync-currently-syncing-tabs = Pestañas abiertas
sync-currently-syncing-logins-passwords = Inicios de sesión y contraseñas
sync-currently-syncing-addresses = Direcciones
sync-currently-syncing-creditcards = Tarjetas de crédito
sync-currently-syncing-addons = Complementos
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] Opciones
       *[other] Preferencias
    }
sync-change-options =
    .label = Cambiar…
    .accesskey = C

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = Elegir lo que quiere sincronizar
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
    .label = Pestañas abiertas
    .tooltiptext = Una lista de que está abierto en todos los dispositivos sincronizados
    .accesskey = t
sync-engine-logins-passwords =
    .label = Inicios de sesión y contraseñas
    .tooltiptext = Nombres de usuario y contraseñas guardadas
    .accesskey = L
sync-engine-addresses =
    .label = Direcciones
    .tooltiptext = Direcciones postales que se hayan guardado (solo escritorio)
    .accesskey = e
sync-engine-creditcards =
    .label = Tarjetas de crédito
    .tooltiptext = Nombres, números y fechas de expiración (solo escritorio)
    .accesskey = C
sync-engine-addons =
    .label = Complementos
    .tooltiptext = Extensiones y temas para Firefox de escritorio
    .accesskey = o
sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] Opciones
           *[other] Preferencias
        }
    .tooltiptext = Configuración general, de provacidad y de seguridad que hayan cambiado
    .accesskey = s

## The device name controls.

sync-device-name-header = Nombre de dispositivo
sync-device-name-change =
    .label = Cambie el nombre del dispositivo …
    .accesskey = d
sync-device-name-cancel =
    .label = Cancelar
    .accesskey = n
sync-device-name-save =
    .label = Guardar
    .accesskey = G
sync-connect-another-device = Conectar otro dispositivo

## Privacy Section

privacy-header = Privacidad del navegador

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Inicios de sesión y contraseñas
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Preguntar acerca de guardar inicios de sesión y contraseñas para los sitios web
    .accesskey = r
forms-exceptions =
    .label = Excepciones…
    .accesskey = x
forms-generate-passwords =
    .label = Sugerir y generar contraseñas seguras.
    .accesskey = u
forms-breach-alerts =
    .label = Mostrar alertas sobre contraseñas para sitios web violados
    .accesskey = b
forms-breach-alerts-learn-more-link = Conocer más
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Autocompletar inicios de sesión y contraseñas
    .accesskey = i
forms-saved-logins =
    .label = Ingresos guardados…
    .accesskey = I
forms-master-pw-use =
    .label = Usar una contraseña maestra
    .accesskey = U
forms-primary-pw-use =
    .label = Usar una contraseña maestra
    .accesskey = U
forms-primary-pw-learn-more-link = Conocer más
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = Cambiar la contraseña maestra…
    .accesskey = M
forms-master-pw-fips-title = Se encuentra actualmente en modo FIPS. FIPS requiera una contraseña maestra no vacía.
forms-primary-pw-change =
    .label = Cambiar la contraseña maestra…
    .accesskey = P
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = { "" }
forms-primary-pw-fips-title = Se encuentra actualmente en modo FIPS. FIPS requiere una contraseña maestra no vacía.
forms-master-pw-fips-desc = Cambio Fallido de contraseña

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Para crear una contraseña maestra, ingrese sus credenciales de inicio de sesión de Windows. Esto ayuda a proteger la seguridad de sus cuentas.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = crear una contraseña maestra
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Para crear una contraseña maestra, ingrese sus credenciales de inicio de sesión de Windows. Esto ayuda a proteger la seguridad de sus cuentas.
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
#   - Simply as "Firefox", moving the verb into each option.
#     This will result in "Firefox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = { -brand-short-name } podrá
    .accesskey = o
history-remember-option-all =
    .label = Recordar el historial
history-remember-option-never =
    .label = Nunca recordar el historial
history-remember-option-custom =
    .label = Usar la configuración personalizada para el historial
history-remember-description = { -brand-short-name } recordará su historial de navegación, descargas, formularios e historial de búsquedas.
history-dontremember-description = { -brand-short-name } utilizará la misma configuración que para las búsquedas privadas y no recordará el historial mientras navegue por la web.
history-private-browsing-permanent =
    .label = Siempre usar el modo de navegación privada
    .accesskey = p
history-remember-browser-option =
    .label = Recordar mi historial de navegación y de descargas
    .accesskey = h
history-remember-search-option =
    .label = Recordar lo que haya ingresado en formularios y en la barra de búsqueda
    .accesskey = R
history-clear-on-close-option =
    .label = Eliminar el historial cuando cierre { -brand-short-name }
    .accesskey = h
history-clear-on-close-settings =
    .label = Opciones…
    .accesskey = O
history-clear-button =
    .label = Limpiar historial…
    .accesskey = s

## Privacy Section - Site Data

sitedata-header = Cookies y datos del sitio
sitedata-total-size-calculating = Calculando el tamaño de los datos del sitio y del caché…
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Sus cookies almacenadas, los datos del sitio y caché están usando { $value } { $unit } de espacio en disco en este momento.
sitedata-learn-more = Conocer más
sitedata-delete-on-close =
    .label = Eliminar cookies y datos del sitio cuando se cierra { -brand-short-name }
    .accesskey = c
sitedata-delete-on-close-private-browsing = En el modo de navegación privada permanente, las cookies y los datos del sitio siempre se borrarán cuando se cierre { -brand-short-name }.
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
    .label = Rastreadores de sitios cruzados
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = Rastreadores de sitios y redes sociales
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = Rastreadores de sitios cruzados y redes sociales, y aislación del resto de las cookies
sitedata-option-block-unvisited =
    .label = Cookies de sitios web no visitados
sitedata-option-block-all-third-party =
    .label = Todas las cookies de terceros (puede causar fallas en los sitios web)
sitedata-option-block-all =
    .label = Todas las cookies (hará que fallen los sitios web)
sitedata-clear =
    .label = Limpiar datos…
    .accesskey = L
sitedata-settings =
    .label = Administrar datos…
    .accesskey = M
sitedata-cookies-permissions =
    .label = Administrar permisos…
    .accesskey = P
sitedata-cookies-exceptions =
    .label = Administrar excepciones…
    .accesskey = x

## Privacy Section - Address Bar

addressbar-header = Barra de direcciones
addressbar-suggest = Al usar la barra de direcciones, sugerir
addressbar-locbar-history-option =
    .label = Historial de navegación
    .accesskey = H
addressbar-locbar-bookmarks-option =
    .label = Marcadores
    .accesskey = d
addressbar-locbar-openpage-option =
    .label = Abrir pestañas
    .accesskey = O
addressbar-locbar-topsites-option =
    .label = Sitios importantes
    .accesskey = T
addressbar-suggestions-settings = Cambiar preferencias para sugerencias de buscadores

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Protección contra rastreo aumentada
content-blocking-section-top-level-description = Los rastreadores lo siguen en línea para recolectar información sobre sus hábitos e intereses de navegación. { -brand-short-name } bloquea muchos de estos rastreadores y otros scripts maliciosos.
content-blocking-learn-more = Conocer más

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Estándar
    .accesskey = d
enhanced-tracking-protection-setting-strict =
    .label = Estricta
    .accesskey = r
enhanced-tracking-protection-setting-custom =
    .label = Personalizada
    .accesskey = z

##

content-blocking-etp-standard-desc = Equilibrado para protección y rendimiento. Las páginas se van a cargar normalmente.
content-blocking-etp-strict-desc = Mayor protección, pero puede causar que algunos sitios o contenido no se carguen.
content-blocking-etp-custom-desc = Elija qué rastreadores y secuencias de comandos quiere bloquear.
content-blocking-private-windows = Rastreo de contenido en ventanas privadas
content-blocking-cross-site-tracking-cookies = Cookies de rastreo de sitios cruzados
content-blocking-cross-site-tracking-cookies-plus-isolate = Cookies de rastreo de sitios cruzados, y aislación del resto de las cookies
content-blocking-social-media-trackers = Rastreadores de redes sociales
content-blocking-all-cookies = Todas las cookies
content-blocking-unvisited-cookies = Cookies de sitios no visitados
content-blocking-all-windows-tracking-content = Rastreo de contenido en todas las ventanas
content-blocking-all-third-party-cookies = Todas las cookies de terceros
content-blocking-cryptominers = Cryptominers
content-blocking-fingerprinters = Detectores de huellas digitales
content-blocking-warning-title = ¡Atención!
content-blocking-and-isolating-etp-warning-description = Bloquear los rastreadores y aislar las cookies puede impactar en la funcionalidad de algunos sitios. Recargue una página con los rastreadores para cargar todo el contenido.
content-blocking-warning-learn-how = Aprender como
content-blocking-reload-description = Tendrá que volver a cargar las pestañas para aplicar estos cambios.
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
    .label = Cryptominers
    .accesskey = y
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Fingerprinters
    .accesskey = F

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Administrar excepciones ...
    .accesskey = x

## Privacy Section - Permissions

permissions-header = Permisos
permissions-location = Ubicación
permissions-location-settings =
    .label = Configuración…
    .accesskey = U
permissions-xr = Realidad virtual
permissions-xr-settings =
    .label = Opciones…
    .accesskey = t
permissions-camera = Cámara
permissions-camera-settings =
    .label = Configuración…
    .accesskey = c
permissions-microphone = Micrófono
permissions-microphone-settings =
    .label = Configuración…
    .accesskey = n
permissions-notification = Notificaciones
permissions-notification-settings =
    .label = Configuración…
    .accesskey = n
permissions-notification-link = Conocer más
permissions-notification-pause =
    .label = Pausar notificaciones hasta que se reinicie { -brand-short-name }
    .accesskey = n
permissions-autoplay = Autoreproducción
permissions-autoplay-settings =
    .label = Configuración…
    .accesskey = t
permissions-block-popups =
    .label = Bloquear ventanas emergentes
    .accesskey = B
permissions-block-popups-exceptions =
    .label = Excepciones…
    .accesskey = E
permissions-addon-install-warning =
    .label = Avisar cuando sitios web traten de instalar complementos
    .accesskey = v
permissions-addon-exceptions =
    .label = Excepciones…
    .accesskey = E
permissions-a11y-privacy-checkbox =
    .label = Evitar que los servicios de accesibilidad accedan a tu navegador
    .accesskey = a
permissions-a11y-privacy-link = Conocer más

## Privacy Section - Data Collection

collection-header = Recolección de datos y uso de { -brand-short-name }
collection-description = Nos esforzamos en proporcionar opciones y recolectar solamente lo que necesitamos para proveer y mejorar { -brand-short-name } para todo el mundo. Siempre pedimos permiso antes de recibir información personal.
collection-privacy-notice = Nota de privacidad
collection-health-report-telemetry-disabled = Ya no permite que { -vendor-short-name } capture datos técnicos y de interacción. Todos los datos anteriores se eliminarán dentro de los 30 días.
collection-health-report-telemetry-disabled-link = Conocer más
collection-health-report =
    .label = Permitir que { -brand-short-name } envíe información técnica y de interacción a { -vendor-short-name }
    .accesskey = r
collection-health-report-link = Conocer más
collection-studies =
    .label = Permitir { -brand-short-name } para instalar y ejecutar estudios
collection-studies-link = Ver los estudios { -brand-short-name }
addon-recommendations =
    .label = Permitir que { -brand-short-name } haga recomendaciones personalizadas de extensiones
addon-recommendations-link = Conocer más
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = La información de datos está deshabilitado para esta configuración de compilación
collection-backlogged-crash-reports =
    .label = Permitir que { -brand-short-name } envíe informes de fallos pendientes en su nombre
    .accesskey = n
collection-backlogged-crash-reports-link = Conocer más

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Seguridad
security-browsing-protection = Protección contra contenido engañoso y software peligroso
security-enable-safe-browsing =
    .label = Bloquear contenido peligroso y engañoso
    .accesskey = B
security-enable-safe-browsing-link = Conocer más
security-block-downloads =
    .label = Bloquear descargas peligrosas
    .accesskey = D
security-block-uncommon-software =
    .label = Avisarme sobre software no deseado y poco común
    .accesskey = c

## Privacy Section - Certificates

certs-header = Certificados
certs-personal-label = Cuando un servidor solicite su certificado personal
certs-select-auto-option =
    .label = Seleccionar uno automáticamente
    .accesskey = S
certs-select-ask-option =
    .label = Preguntarme cada vez
    .accesskey = a
certs-enable-ocsp =
    .label = Solicitar a los servidores de respuesta de OCSP que confirmen la validez actual de los certificados
    .accesskey = O
certs-view =
    .label = Ver certificados…
    .accesskey = c
certs-devices =
    .label = Dispositivos de seguridad…
    .accesskey = D
space-alert-learn-more-button =
    .label = Conocer más
    .accesskey = m
space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] Abrir opciones
           *[other] Abrir preferencias
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] p
        }
space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] { -brand-short-name } se está quedando sin espacio en el disco. Puede que los contenidos de los sitios web no se muestren adecuadamente. Puede eliminar los datos almacenados en Opciones > Privacidad y seguridad > Cookies y Datos del sitio.
       *[other] { -brand-short-name } se está quedando sin espacio en el disco. Puede que los contenidos de los sitios web no se muestren adecuadamente. Puede eliminar los datos almacenados en Preferencias > Privacidad y seguridad > Cookies y Datos del sitio.
    }
space-alert-under-5gb-ok-button =
    .label = Perfecto, lo entiendo
    .accesskey = P
space-alert-under-5gb-message = { -brand-short-name } se está quedando sin espacio en disco. Contenidos del sitio web pueden no mostrarse correctamente. Ver “Conocer más” para optimizar el uso del disco para una mejor experiencia de navegación.

## Privacy Section - HTTPS-Only

httpsonly-header = Modo solo HTTPS
httpsonly-description = HTTPS proporciona una conexión segura y encriptada entre { -brand-short-name } y los sitios web que visita. La mayoría de los sitios web admiten HTTPS, y si el modo HTTPS-Only está habilitado, entonces { -brand-short-name } actualizará todas las conexiones a HTTPS.
httpsonly-learn-more = Conocer más
httpsonly-radio-enabled =
    .label = Habilitar el modo solo HTTPS en todas las ventanas
httpsonly-radio-enabled-pbm =
    .label = Habilitar el modo solo HTTPS solo en ventanas privadas
httpsonly-radio-disabled =
    .label = No habilitar el modo solo HTTPS

## The following strings are used in the Download section of settings

desktop-folder-name = Escritorio
downloads-folder-name = Descargas
choose-download-folder-title = Elegir carpeta para descargas:
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Guardar archivos en { $service-name }
