# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Ninviar a los webs un sinyal de "No seguir" indicando que no quiers que te fagan garra seguimiento
do-not-track-learn-more = Saber-ne mas
do-not-track-option-default-content-blocking-known =
    .label = Nomás quan { -brand-short-name } siga configuau pa blocar los elementos de seguimiento
do-not-track-option-always =
    .label = Siempre
pref-page-title =
    { PLATFORM() ->
        [windows] Opcions
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
            [windows] Trobar en Opcions
           *[other] Trobar en Preferencias
        }
managed-notice = Lo tuyo navegador ye chestionau per la tuya organización.
pane-general-title = Cheneral
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = Inicio
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = Mirar
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = Privacidat & Seguranza
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }
pane-experimental-title = Experimentos de { -brand-short-name }
category-experimental =
    .tooltiptext = Experimentos de { -brand-short-name }
pane-experimental-subtitle = Ves con cuenta!
pane-experimental-search-results-header = Experimentos de { -brand-short-name }: Ves con cuenta
pane-experimental-description = Lo cambio d'as preferencias de configuración abanzadas puede afectar a lo rendimiento u la seguranza de { -brand-short-name }.
help-button-label = Soporte de { -brand-short-name }
addons-button-label = Extensions y temas
focus-search =
    .key = f
close-button =
    .aria-label = Zarrar

## Browser Restart Dialog

feature-enable-requires-restart = Ha de reiniciar o { -brand-short-name } ta activar ista caracteristica.
feature-disable-requires-restart = Ha de reiniciar o { -brand-short-name } ta desactivar ista caracteristica.
should-restart-title = Reiniciar o { -brand-short-name }
should-restart-ok = Reiniciar agora lo { -brand-short-name }
cancel-no-restart-button = Cancelar
restart-later = Reiniciar mas entabant

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
extension-controlled-homepage-override = Una extensión, <img data-l10n-name="icon"/> { $name }, ye controlando la tuya pachina d'inicio.
# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = Una extensión, <img data-l10n-name="icon"/> { $name }, ye controlando la tuya pachina de Nueva Pestanya.
# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlled-password-saving = Una extensión, <img data-l10n-name="icon"/> { $name }, ye controlando este parametro.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = Una extensión, <img data-l10n-name="icon"/> { $name }, ye controlando este parametro.
# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = Una extensión, <img data-l10n-name="icon"/> { $name }, ha fixau lo tuyo motor de busqueda per defecto.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = Una extensión, <img data-l10n-name="icon"/> { $name }, requiere Pestanyas Contenederas.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = Una extensión, <img data-l10n-name="icon"/> { $name }, ye controlando este parametro.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = Una extensión, <img data-l10n-name="icon"/> { $name }, ye controlando cómo { -brand-short-name } se connecta a internet.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Pa activar la extensión ves ta <img data-l10n-name="addons-icon"/> extensions en o menú <img data-l10n-name="menu-icon"/>.

## Preferences UI Search Results

search-results-header = Resultaus de buscar
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] No i hai garra resultau en Opcions pa “<span data-l10n-name="query"></span>”.
       *[other] No i hai garra resultau en Preferencias pa “<span data-l10n-name="query"></span>”.
    }
search-results-help-link = Te cal aduya? Vesita <a data-l10n-name="url">Aduya de { -brand-short-name }</a>

## General Section

startup-header = Inicio
# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = Permitir que { -brand-short-name } y Firefox corran de vez
use-firefox-sync = Consello: Isto fa servir perfils deseparaus. Faiga servir { -sync-brand-short-name } pa compartir datos entre ells.
get-started-not-logged-in = Dentrar en { -sync-brand-short-name }…
get-started-configured = Ubrir las preferencias de { -sync-brand-short-name }
always-check-default =
    .label = Comprebar siempre si lo { -brand-short-name } ye o suyo navegador por defecto
    .accesskey = o
is-default = { -brand-short-name } ye agora o suyo navegador por defecto
is-not-default = { -brand-short-name } no ye o suyo navegador por defecto
set-as-my-default-browser =
    .label = Definir per defecto…
    .accesskey = D
startup-restore-previous-session =
    .label = Restaurar la sesión anterior
    .accesskey = s
startup-restore-warn-on-quit =
    .label = Alvertir-te quan se salga d'o navegador
disable-extension =
    .label = Desactivar extensión
tabs-group-header = Pestanyas
ctrl-tab-recently-used-order =
    .label = Ctrl+Tab cambia de pestanya en orden d'uso mas recient
    .accesskey = T
open-new-link-as-tabs =
    .label = Ubrir vinclos en pestanyas en cuenta d'en nuevas finestras
    .accesskey = w
warn-on-close-multiple-tabs =
    .label = Alvertir-me en zarrar multiples pestanyas
    .accesskey = m
warn-on-open-many-tabs =
    .label = Alvertir-me quan ubrir multiples pestanyas pueda enlentir lo { -brand-short-name }
    .accesskey = d
switch-links-to-new-tabs =
    .label = En ubrir un vinclo en una nueva pestanya, cambiar enta ista de camín
    .accesskey = h
show-tabs-in-taskbar =
    .label = Amostrar miniaturas d'as pestanyas en a barra de quefers de Windows
    .accesskey = n
browser-containers-enabled =
    .label = Habilitar las pestanyas de contenedor
    .accesskey = H
browser-containers-learn-more = Saber-ne mas
browser-containers-settings =
    .label = Configuración…
    .accesskey = g
containers-disable-alert-title = Zarrar totas las pestanyas de contenedor?
containers-disable-alert-desc =
    { $tabCount ->
        [one] Si desactiva agora las pestanyas de contenedor, se zarrará { $tabCount } pestanya de contenedor. Ye seguro de fer-lo?
       *[other] Si desactiva agora las pestanyas de contenedor, se zarrará { $tabCount } pestanyas de contenedor. Ye seguro de fer-lo?
    }
containers-disable-alert-ok-button =
    { $tabCount ->
        [one] Zarrar { $tabCount } pestanya de contenedor
       *[other] Zarrar { $tabCount } pestanyas de contenedor
    }
containers-disable-alert-cancel-button = Mantener habilitadas
containers-remove-alert-title = Borrar iste contenedor?
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Si borra iste contenedor agora, { $count } pestanya de contender se zarrará. Ye seguro que quiere borrar iste contenedor?
       *[other] Si borra iste contenedor agora, { $count } pestanyas de contender se zarrarán. Ye seguro que quiere borrar iste contenedor?
    }
containers-remove-ok-button = Borrar iste contenedor
containers-remove-cancel-button = No borrar iste contenedor

## General Section - Language & Appearance

language-and-appearance-header = Idioma y aparición
fonts-and-colors-header = Fuents y Colors
default-font = Tipografía por defecto:
    .accesskey = d
default-font-size = Mida:
    .accesskey = M
advanced-fonts =
    .label = Abanzadas…
    .accesskey = A
colors-settings =
    .label = Colors…
    .accesskey = C
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Zoom
preferences-default-zoom = Zoom per defecto
    .accesskey = Z
preferences-default-zoom-value =
    .label = { $percentage }%
preferences-zoom-text-only =
    .label = Zoom nomás en o texto
    .accesskey = t
language-header = Idioma
choose-language-description = Trigar l'idioma preferiu ta amostrar as pachinas web
choose-button =
    .label = Trigar…
    .accesskey = T
choose-browser-language-description = Triar los idiomas usaus pa amostrar los menús, mensaches y notificacions de { -brand-short-name }.
manage-browser-languages-button =
    .label = Definir alternativas…
    .accesskey = l
confirm-browser-language-change-description = Reiniciar { -brand-short-name } pa aplicar estes cambios
confirm-browser-language-change-button = Aplicar y reiniciar
translate-web-pages =
    .label = Traducir o conteniu web
    .accesskey = T
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Traduccions de <img data-l10n-name="logo"/>
translate-exceptions =
    .label = Excepcions…
    .accesskey = x
# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = Usar los achustes de “{ $localeName }” d'o tuyo sistema operativo pa lo formato de datas, horas, numersos y midas.
check-user-spelling =
    .label = Comprebar la ortografía entre que escribo
    .accesskey = t

## General Section - Files and Applications

files-and-applications-title = Fichers y aplicacions
download-header = Descargas
download-save-to =
    .label = Alzar os fichers en
    .accesskey = A
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Trigar…
           *[other] Examinar…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] T
           *[other] x
        }
download-always-ask-where =
    .label = Preguntar-me siempre aón alzar los fichers
    .accesskey = a
applications-header = Aplicacions
applications-description = Trigar cómo { -brand-short-name } tracta los fichers que has descargaus d'o web u las aplicacions que fas servir quan navegas.
applications-filter =
    .placeholder = Mirar los tipos de fichers u aplicacions
applications-type-column =
    .label = Mena de conteniu
    .accesskey = M
applications-action-column =
    .label = Acción
    .accesskey = A
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = fichero { $extension }
applications-action-save =
    .label = Alzar o fichero
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = Usar { $app-name }
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = Usar { $app-name } (por defecto)
applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] Usar l'aplicación per defecto de macOS
            [windows] Usar l'aplicación per defecto de Windows
           *[other] Usar l'aplicación per defecto d'o sistema
        }
applications-use-other =
    .label = Usar unatra…
applications-select-helper = Trigue l'aplicación d'aduya
applications-manage-app =
    .label = Detalles de l'aplicación…
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
    .label = Usar { $plugin-name } (en o { -brand-short-name })
applications-open-inapp =
    .label = Ubrir en { -brand-short-name }

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

drm-content-header = Conteniu DRM (Digital Rights Management, Chestión de dreitos dichitals)
play-drm-content =
    .label = Reproducir conteniu controlau per DRM
    .accesskey = R
play-drm-content-learn-more = Mas información
update-application-title = Actualizacions d'o { -brand-short-name }:
update-application-description = Mantener { -brand-short-name } a lo día pa tener lo millor rendimiento, estabilidat y seguranza.
update-application-version = Versión { $version } <a data-l10n-name="learn-more">Novedatz</a>
update-history =
    .label = Amostrar l'historial d'actualizacions
    .accesskey = h
update-application-allow-description = Permitir a { -brand-short-name }
update-application-auto =
    .label = Instalar automaticament las actualizacions (recomendau)
    .accesskey = A
update-application-check-choose =
    .label = Comprebar as actualizacions, pero deixar-me trigar si las quiero instalar
    .accesskey = C
update-application-manual =
    .label = No comprebar nunca las actualizacions
    .accesskey = N
update-application-warning-cross-user-setting = Esta configuración s'aplicará a totas las cuentas de Windows y perfils de { -brand-short-name } que fagan servir esta instalación de { -brand-short-name }.
update-application-use-service =
    .label = Instalar as actualizacions en un segundo plan
    .accesskey = p
update-setting-write-failure-title = Error en alzar als preferencias d'actualización
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } ha trobau una error y no ha alzau este cambio. Para cuenta que pa cambiar esta configuración s'ha de poder escribir en o fichero d'abaixo. Tu, u bell administrador de sistema podetz resolver esta error permitiendo a lo grupo d'Usuarios lo control total d'este fichero.
    
    No s'ha puesto escribir en: { $path }
update-in-progress-title = Actualización en curso
update-in-progress-message = Quiers que { -brand-short-name } contine con esta actualización?
update-in-progress-ok-button = &Descartar
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Continar

## General Section - Performance

performance-title = Rendimiento
performance-use-recommended-settings-checkbox =
    .label = Usar las caracteristicas de rendimiento recomendadas
    .accesskey = U
performance-use-recommended-settings-desc = Estos achustes son adaptaus a lo hardware y lo sistema operativo d'o tuyo ordinador.
performance-settings-learn-more = Saber-ne mas
performance-allow-hw-accel =
    .label = Usar l'acceleración d'hardware quan sía disponible
    .accesskey = r
performance-limit-content-process-option = Limite de procesado de conteniu
    .accesskey = L
performance-limit-content-process-enabled-desc = Los procesos de conteniu adicional pueden millorar las prestacions quan se fan servir multiples pestanyas, pero tamién usarán mas memoria.
performance-limit-content-process-blocked-desc = Modificar lo numero de procesos de contenius no ye posible soque con la versión multiproceso de { -brand-short-name }. <a data-l10n-name="learn-more">Aprender a comprebar si los multiprocesos son activaus</a>
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (por defecto)

## General Section - Browsing

browsing-title = Navegación
browsing-use-autoscroll =
    .label = Usar o desplazamiento automatico
    .accesskey = a
browsing-use-smooth-scrolling =
    .label = Usar o desplazamiento suau
    .accesskey = d
browsing-use-onscreen-keyboard =
    .label = Amostrar un teclau tactil quan siga necesario
    .accesskey = t
browsing-use-cursor-navigation =
    .label = Fer servir siempre as teclas d'o cursor ta navegar endentro d'as pachinas
    .accesskey = c
browsing-search-on-start-typing =
    .label = Mirar textos malas que s'escomienza a tecliar
    .accesskey = x
browsing-picture-in-picture-toggle-enabled =
    .label = Activar los controls de video incrustau
    .accesskey = A
browsing-picture-in-picture-learn-more = Saber-ne mas
browsing-cfr-recommendations =
    .label = Recomendar extensions mientres navegas
    .accesskey = R
browsing-cfr-features =
    .label = Recomendar caracteristicas mientres navegas
    .accesskey = c
browsing-cfr-recommendations-learn-more = Saber-ne mas

## General Section - Proxy

network-settings-title = Configuración de ret
network-proxy-connection-description = Configurar cómo { -brand-short-name } se connecta con internet.
network-proxy-connection-learn-more = Saber-ne mas
network-proxy-connection-settings =
    .label = Configuración…
    .accesskey = o

## Home Section

home-new-windows-tabs-header = Nuevas finestras y pestanyas
home-new-windows-tabs-description2 = Triar qué ye lo que se vei quan s'ubre la pachina d'inicio, finestras nuevas y pestanyas nuevas.

## Home Section - Home Page Customization

home-homepage-mode-label = Pachina d'inicio y nuevas finestras
home-newtabs-mode-label = Nuevas pestanyas
home-restore-defaults =
    .label = Restaurar valors per defecto
    .accesskey = R
# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Inicio de Firefox
home-mode-choice-custom =
    .label = URL personalizadas…
home-mode-choice-blank =
    .label = Pachina en blanco
home-homepage-custom-url =
    .placeholder = Apega una URL…
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Usar pachina actual
           *[other] Usar pachinas actuals
        }
    .accesskey = c
choose-bookmark =
    .label = Usar o marcapachinas…
    .accesskey = m

## Home Section - Firefox Home Content Customization

home-prefs-content-header = Conteniu d'inicio de Firefox
home-prefs-content-description = Tría qué contenius quiers veyer en a tuya pachina d'inicio de Firefox.
home-prefs-search-header =
    .label = Busqueda web
home-prefs-topsites-header =
    .label = Puestos mas vesitaus
home-prefs-topsites-description = Los puestos que mas vesitas

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Recomendau per { $provider }
home-prefs-recommended-by-description-update = Conteniu excepcional de tot lo web, triau per { $provider }

##

home-prefs-recommended-by-learn-more = Cómo funciona
home-prefs-recommended-by-option-sponsored-stories =
    .label = Articlos esponsorizaus
home-prefs-highlights-header =
    .label = Destacaus
home-prefs-highlights-description = Una tría d'os puestos que has alzau u vesitau
home-prefs-highlights-option-visited-pages =
    .label = Pachinas visitadas
home-prefs-highlights-options-bookmarks =
    .label = Marcapachinas
home-prefs-highlights-option-most-recent-download =
    .label = Descarga mas recient
home-prefs-highlights-option-saved-to-pocket =
    .label = Pachinas alzadas en { -pocket-brand-name }
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Retallos
home-prefs-snippets-description = Actualizacions de { -vendor-short-name } y { -brand-product-name }
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } ringlera
           *[other] { $num } ringleras
        }

## Search Section

search-bar-header = Barra de busqueda
search-bar-hidden =
    .label = Fe servir la barra d'adrezas pa buscar y navegar
search-bar-shown =
    .label = Anyader la barra de busqueda en a barra de ferramientas
search-engine-default-header = Motor de busca por defecto
search-engine-default-desc-2 = Este ye lo tuyo motor de busqueda per defecto en a barra d'adrezas y en a barra de busqueda. Puetz cambiar-lo en qualsequier momento.
search-engine-default-private-desc-2 = Triar un motor de busqueda per defecto diferent, nomás pa finestras privadas
search-separate-default-engine =
    .label = Fer servir este motor de busqueda en finestras privadas
    .accesskey = v
search-suggestions-header = Sucherencias de busqueda
search-suggestions-desc = Tría cómo amaneixerán las sucherencias d'os motors de busqueda.
search-suggestions-option =
    .label = Dar sucherencia de busca
    .accesskey = b
search-show-suggestions-url-bar-option =
    .label = Amostrar las sucherencias de busqueda en os resultaus d'a barra d'adrezas
    .accesskey = l
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Amostrar las sucherencias de busqueda antes de l'hstorial de navegación en os resultasu d'a barra d'adrezas
search-show-suggestions-private-windows =
    .label = Amostrar las sucherencias de busqueda en as finestras privadas
suggestions-addressbar-settings-generic = Cambiar las preferencias d'atras sucherencias de barra d'adrezas
search-suggestions-cant-show = No s'amostrarán sucherencias de busca a os resultaus d'a barra d'ubicación porque ha configurau o { -brand-short-name } pa que no recuerde nunca o historial.
search-one-click-header = Motors de busca d'un solo click
search-one-click-desc = Triga los motors de busqueda alternativos que amaneixerán debaixo d'a barra d'adrezas y la barra de busqueda quan empecipies a tecliar una parola clau.
search-choose-engine-column =
    .label = Motors de busca
search-choose-keyword-column =
    .label = Parola clau
search-restore-default =
    .label = Restaurar os motors de busca por defecto
    .accesskey = d
search-remove-engine =
    .label = Borrar…
    .accesskey = r
search-add-engine =
    .label = Anyadir
    .accesskey = A
search-find-more-link = Troba mas motors de busqueda
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Duplicar a parola clau
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Ha trigau una parola clau que ya emplega "{ $name }". Trigue-ne unatra.
search-keyword-warning-bookmark = Ha trigau una parola clau que ya emplega unatro marcapachinas. Trigue-ne unatra.

## Containers Section

containers-back-button =
    .aria-label =
        { PLATFORM() ->
            [windows] Tornar ta opcions
           *[other] Tornar ta preferencias
        }
containers-header = Pestanyas contenederas
containers-add-button =
    .label = Anyader nuevo contenedor
    .accesskey = A
containers-new-tab-check =
    .label = Triar un contenedor pa cada pestanya nueva
    .accesskey = T
containers-preferences-button =
    .label = Preferencias
containers-remove-button =
    .label = Borrar

## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Leva-te lo web con tu
sync-signedout-description = Sincroniza os tuyos marcapachinas, historial, pestanyas, claus, complementos y preferencias entre totz os tuyos dispositivos.
sync-signedout-account-signin2 =
    .label = Dentrar en { -sync-brand-short-name }…
    .accesskey = D
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Descargar Firefos pa <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> u bien lo <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> sincronizar con o tuyo dispositivo mobil.

## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = Cambiar a imachen de perfil
sync-sign-out =
    .label = Zarrar la sesión…
    .accesskey = Z
sync-manage-account = Chestionar la cuenta
    .accesskey = t
sync-signedin-unverified = { $email } no ye verificau.
sync-signedin-login-failure = Enciete una sesión ta reconnectar { $email }
sync-resend-verification =
    .label = Reninviar la verificación
    .accesskey = d
sync-remove-account =
    .label = Borrar la cuenta
    .accesskey = o
sync-sign-in =
    .label = Connectar-se
    .accesskey = g

## Sync section - enabling or disabling sync.

prefs-syncing-on = Sincronización: Activada
prefs-syncing-off = Sincronización: Desactivada
prefs-sync-setup =
    .label = Configurar { -sync-brand-short-name }
    .accesskey = C
prefs-sync-offer-setup-label = Sincroniza os tuyos marcapachinas, historial, pestanyas, claus, complementos y preferencias entre totz os tuyos dispositivos.
prefs-sync-now =
    .labelnotsyncing = Sincronizar agora
    .accesskeynotsyncing = N
    .labelsyncing = Se ye sincronizando…

## The list of things currently syncing.

sync-currently-syncing-heading = Actualment se sincronizan estes elementos:
sync-currently-syncing-bookmarks = Marcapachinas
sync-currently-syncing-history = Historial
sync-currently-syncing-tabs = Ubrir as pestanyas
sync-currently-syncing-logins-passwords = Inicios de sesión y claus
sync-currently-syncing-addresses = Adrezas
sync-currently-syncing-creditcards = Tarchetas de credito
sync-currently-syncing-addons = Complementos
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] Opcions
       *[other] Preferencias
    }
sync-change-options =
    .label = Cambiar
    .accesskey = C

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = Tría qué quiers sincronizar
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = Alzar cambios
    .buttonaccesskeyaccept = A
    .buttonlabelextra2 = Desconnectau…
    .buttonaccesskeyextra2 = D
sync-engine-bookmarks =
    .label = Marcapachinas
    .accesskey = M
sync-engine-history =
    .label = Historial
    .accesskey = r
sync-engine-tabs =
    .label = Ubrir las pestanyas
    .tooltiptext = Un listau d'o que ye ubierto en totz los dispositivos sincronizaus
    .accesskey = T
sync-engine-logins-passwords =
    .label = Inicios de sesión y claus
    .tooltiptext = Inicios de sesión y claus que has alzau
    .accesskey = I
sync-engine-addresses =
    .label = Adrezas
    .tooltiptext = Adrezas postals que has alzadas (nomás pa sobremesa)
    .accesskey = e
sync-engine-creditcards =
    .label = Tarchetas de credito
    .tooltiptext = Nombres, numeros y calendatas de caducidat (nomás pa sobremesa)
    .accesskey = c
sync-engine-addons =
    .label = Complementos
    .tooltiptext = Extensions y temas pa lo Firefox de sobremesa
    .accesskey = C
sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] Opcions
           *[other] Preferencias
        }
    .tooltiptext = Achustes chenerals, de privacidat y de seguranza que has cambiaus
    .accesskey = s

## The device name controls.

sync-device-name-header = Nombre d'o dispositivo
sync-device-name-change =
    .label = Cambiar lo nombre d'o dispositivo...
    .accesskey = b
sync-device-name-cancel =
    .label = Cancelar
    .accesskey = n
sync-device-name-save =
    .label = Alzar
    .accesskey = z
sync-connect-another-device = Connectar belatro dispositivo

## Privacy Section

privacy-header = Privacidat d'o navegador

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Inicios de sesión y claus
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Demandar alzar usuarios y claus d'os puestos web
    .accesskey = r
forms-exceptions =
    .label = Excepcions…
    .accesskey = x
forms-generate-passwords =
    .label = Sucherir y chenerar claus fuertes
    .accesskey = u
forms-breach-alerts =
    .label = Amostrar alertas sobre claus en puestos relacionaus con filtracions de datos
    .accesskey = b
forms-breach-alerts-learn-more-link = Saber-ne mas
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Autorreplenar usuarios y claus
    .accesskey = i
forms-saved-logins =
    .label = Inicios de sesión alzaus
    .accesskey = I
forms-master-pw-use =
    .label = Usar una clau mayestra
    .accesskey = s
forms-primary-pw-use =
    .label = Fer servir una clau primaria
    .accesskey = u
forms-primary-pw-learn-more-link = Saber-ne mas
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = Cambiar a clau mayestra…
    .accesskey = m
forms-master-pw-fips-title = Se troba en modo FIPS. Iste modo requiere una clau mayestra no vueda.
forms-primary-pw-change =
    .label = Cambiar a clau primaria…
    .accesskey = P
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = Anteriorment clamada «Clau mayestra»
forms-primary-pw-fips-title = Actualment ye en modo FIPS. FIPS requiere una clau primaria.
forms-master-pw-fips-desc = O cambio de clau ha fallau

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Pa crear una clau mayestra, escribe las tuyas credencials d'acceso a Windows. Esto te aduya a protecher la seguranza d'as tuyas cuentas.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = Crear una clau mayestra
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Pa crear una clau primaria, escribe las tuyas credencials d'acceso a Windows. Esto te aduya a protecher la seguranza d'as tuyas cuentas.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = Crear una clau primaria
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
history-remember-label = Lo { -brand-short-name }:
    .accesskey = L
history-remember-option-all =
    .label = remerará l'historial
history-remember-option-never =
    .label = no remerará l'historial
history-remember-option-custom =
    .label = ferá servir a configuración personalizada de l'historial
history-remember-description = { -brand-short-name } recordará la tuya navegación, descargas, formularios y historial de busqueda.
history-dontremember-description = O { -brand-short-name } ferá servir a mesma configuración que en a navegación privada, y no remerará garra dato d'o suyo historial entre que navega por a Web.
history-private-browsing-permanent =
    .label = Emplegar siempre o modo de navegación privada
    .accesskey = p
history-remember-browser-option =
    .label = Fer acordanza de l'historial de navegación y descargas
    .accesskey = r
history-remember-search-option =
    .label = Remerar l'historial de formularios y buscas
    .accesskey = f
history-clear-on-close-option =
    .label = Porgar l'historial quan o { -brand-short-name } se zarre
    .accesskey = h
history-clear-on-close-settings =
    .label = Configuración…
    .accesskey = g
history-clear-button =
    .label = Borrar l'historial…
    .accesskey = h

## Privacy Section - Site Data

sitedata-header = Cookies y datos de puestos web
sitedata-total-size-calculating = Calculando los datos d'o puesto y la grandaria d'a caché…
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Las tuyas cookies, datos d'o puesto y caché son usando per agora { $value } { $unit } d'o espacio de disco
sitedata-learn-more = Saber-ne mas
sitedata-delete-on-close =
    .label = Borrar las cookies y datos d'o puesto quan { -brand-short-name } siga zarrau
    .accesskey = c
sitedata-delete-on-close-private-browsing = En o modo de navegación privada permanent, las cookies y datos de puesto siempre se borrarán en zarrar { -brand-short-name }.
sitedata-allow-cookies-option =
    .label = Acceptar cookies y datos d'o puesto
    .accesskey = A
sitedata-disallow-cookies-option =
    .label = Blocar cookies y datos d'o puesto
    .accesskey = B
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Tipo de conteniu blocau
    .accesskey = T
sitedata-option-block-cross-site-trackers =
    .label = Elementos de seguimiento entre puestos
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = Elementos de seguimiento de puestos y retz socials
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = Elementos de seguimiento entre puestos y en retz socials, y aíslar las de demás.
sitedata-option-block-unvisited =
    .label = Cookies de webs no visitaus
sitedata-option-block-all-third-party =
    .label = Totas las cookies de tercers (puede causar errors en os puestos web)
sitedata-option-block-all =
    .label = Totas las cookies (qualques puestos no funcionarán correctament)
sitedata-clear =
    .label = Borrar los datos…
    .accesskey = r
sitedata-settings =
    .label = Chestionar datos…
    .accesskey = C
sitedata-cookies-permissions =
    .label = Chestionar permisos…
    .accesskey = P
sitedata-cookies-exceptions =
    .label = Chestionar excepcions…
    .accesskey = x

## Privacy Section - Address Bar

addressbar-header = Barra d'adrezas
addressbar-suggest = Quan s'use la barra d'adrezas, sucherir
addressbar-locbar-history-option =
    .label = Historial de navegación
    .accesskey = H
addressbar-locbar-bookmarks-option =
    .label = Marcapachinas
    .accesskey = M
addressbar-locbar-openpage-option =
    .label = Ubrir as pestanyas
    .accesskey = O
addressbar-locbar-topsites-option =
    .label = Puestos mas visitaus
    .accesskey = F
addressbar-suggestions-settings = Cam&biar las preferencias de sucherencias en motors de busca…

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Protección reforzada contra seguimiento
content-blocking-section-top-level-description = Los elementos de seguimiento te siguen en linia pa replegar información sobre los tuyos habitos de navegación y intereses. { -brand-short-name } bloca muitos d'estes elementos de seguimiento y atros programas maliciosos.
content-blocking-learn-more = Saber-ne mas

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Standard
    .accesskey = d
enhanced-tracking-protection-setting-strict =
    .label = Estricto
    .accesskey = r
enhanced-tracking-protection-setting-custom =
    .label = Personalizau
    .accesskey = P

##

content-blocking-etp-standard-desc = Equilibrau entre protección y rendimiento. Las pachinas se cargarán normalment.
content-blocking-etp-strict-desc = Mayor protección, pero podría fer que bella pachina u conteniu no funcione bien.
content-blocking-etp-custom-desc = Tría qué elementos de seguimiento y seqüencias de comandos blocar.
content-blocking-private-windows = Conteniu que fa seguimiento en as finestras privadas
content-blocking-cross-site-tracking-cookies = Cookies de seguimiento entre puestos
content-blocking-cross-site-tracking-cookies-plus-isolate = Las cookies de seguimiento entre puestos, y aíslar las cookies restants
content-blocking-social-media-trackers = Elementos de seguimiento de retz socials
content-blocking-all-cookies = Totas las cookies
content-blocking-unvisited-cookies = Cookies de puestos no visitaus
content-blocking-all-windows-tracking-content = Conteniu que fa seguimiento en totas las finestras
content-blocking-all-third-party-cookies = Totas las cookies de tercers
content-blocking-cryptominers = Criptominers
content-blocking-fingerprinters = Ditaladas dichitals
content-blocking-warning-title = Atención!
content-blocking-and-isolating-etp-warning-description = Lo bloqueyo d'elementos de seguimiento y l'aíslamiento de cookies podrían afectar a la funcionalidat de bell puesto. Recarga la pachina con elementos de seguimiento pa cargar tot lo conteniu.
content-blocking-warning-learn-how = Aprende cómo
content-blocking-reload-description = Habrás de recargar las tuyas pestanyas pa aplicar estes cambios.
content-blocking-reload-tabs-button =
    .label = Tornar a cargar totas las pestanyas
    .accesskey = r
content-blocking-tracking-content-label =
    .label = Conteniu de seguimiento
    .accesskey = t
content-blocking-tracking-protection-option-all-windows =
    .label = En totas las finestras
    .accesskey = a
content-blocking-option-private =
    .label = Nomás en finestras privadas
    .accesskey = p
content-blocking-tracking-protection-change-block-list = Cambiar a lista de bloqueyos
content-blocking-cookies-label =
    .label = Cookies
    .accesskey = C
content-blocking-expand-section =
    .tooltiptext = Mas información
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Criptominers
    .accesskey = C
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Cheneradors de ditaladas dichitals
    .accesskey = d

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Chestionar excepcions…
    .accesskey = h

## Privacy Section - Permissions

permissions-header = Permisos
permissions-location = Puesto
permissions-location-settings =
    .label = Achustes…
    .accesskey = t
permissions-xr = Realidat Virtual
permissions-xr-settings =
    .label = Configuración…
    .accesskey = C
permissions-camera = Camara
permissions-camera-settings =
    .label = Achustes…
    .accesskey = t
permissions-microphone = Microfono
permissions-microphone-settings =
    .label = Achustes…
    .accesskey = t
permissions-notification = Notificacions
permissions-notification-settings =
    .label = Achustes…
    .accesskey = t
permissions-notification-link = Saber-ne mas
permissions-notification-pause =
    .label = Notificacions de pausa dica que { -brand-short-name } se reinicie
    .accesskey = n
permissions-autoplay = Reproducción automatica
permissions-autoplay-settings =
    .label = Configuración…
    .accesskey = C
permissions-block-popups =
    .label = Blocar finestras emerchents
    .accesskey = B
permissions-block-popups-exceptions =
    .label = Excepcions…
    .accesskey = E
permissions-addon-install-warning =
    .label = Alvertir-te quan bell puesto web mire d'instalar complementos
    .accesskey = v
permissions-addon-exceptions =
    .label = Excepcions…
    .accesskey = E
permissions-a11y-privacy-checkbox =
    .label = Privar que los servicios d'accesibilidat accedan a lo tuyo navegador
    .accesskey = a
permissions-a11y-privacy-link = Saber-ne mas

## Privacy Section - Data Collection

collection-header = Replega de datos y uso de { -brand-short-name }
collection-description = Nos esforzamos pa dar-te opcions y replegar nomás lo que necesitamos pa ofrir y amillorar  { -brand-short-name } pa totz. Siempre demandamos permiso antes de recibir información personal.
collection-privacy-notice = Nota sobre privacidat
collection-health-report-telemetry-disabled = Ya no permites que { -vendor-short-name } obtienga datos tecnicos y d'interacción. Totz los datos anteriors se borrarán en 30 días.
collection-health-report-telemetry-disabled-link = Saber-ne mas
collection-health-report =
    .label = Permitir que { -brand-short-name } ninvie datos tecnicos y d'interacción ta { -vendor-short-name }
    .accesskey = r
collection-health-report-link = Saber-ne mas
collection-studies =
    .label = Permitir que { -brand-short-name } instale y execute estudios
collection-studies-link = Veyer estudios de { -brand-short-name }
addon-recommendations =
    .label = Permite que { -brand-short-name } faga recomendacions d'extensión personalizadas
addon-recommendations-link = Saber-ne mas
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Lo reporte de datos ye desactivau en esta configuración de programa
collection-backlogged-crash-reports =
    .label = Permitir que { -brand-short-name } ninvie de parte suya los reportes de fallos rechistraus previament
    .accesskey = c
collection-backlogged-crash-reports-link = Saber-ne mas

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Seguranza
security-browsing-protection = Protección contra los contenius enganyosos y los programas periglosos
security-enable-safe-browsing =
    .label = Blocar lo conteniu perigloso y malicioso
    .accesskey = B
security-enable-safe-browsing-link = Saber-ne mas
security-block-downloads =
    .label = Blocar las descargas periglosas
    .accesskey = d
security-block-uncommon-software =
    .label = Alvertir-me sobre software no deseyau u poco común
    .accesskey = c

## Privacy Section - Certificates

certs-header = Certificaus
certs-personal-label = Quan un servidor requiera lo mío certificau personal
certs-select-auto-option =
    .label = Trigar-ne un automaticament
    .accesskey = e
certs-select-ask-option =
    .label = Preguntar-me-lo cada vegada
    .accesskey = m
certs-enable-ocsp =
    .label = Consultar a os servidors respondedors OCSP ta confirmar a valideza actual d'os certificaus
    .accesskey = u
certs-view =
    .label = Veyer los certificaus…
    .accesskey = C
certs-devices =
    .label = Dispositivos de seguranza…
    .accesskey = D
space-alert-learn-more-button =
    .label = Saber-ne mas
    .accesskey = S
space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] Ubrir las opcions
           *[other] Ubrir las preferencias
        }
    .accesskey =
        { PLATFORM() ->
            [windows] U
           *[other] U
        }
space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] { -brand-short-name } se ye quedando sin espacio de disco. Los contenius web puede que no s'amuestren correctament. Puetz borrar los datos almagazenaus en Opcions > Privacidat & Seguranza > Cookies y datos d'o puesto.
       *[other] { -brand-short-name } se ye quedando sin espacio de disco. Los contenius web puede que no s'amuestren correctament. Puetz borrar los datos almagazenaus en Preferencias > Privacidat & Seguranza > Cookies y datos d'o puesto.
    }
space-alert-under-5gb-ok-button =
    .label = Entendiu
    .accesskey = d
space-alert-under-5gb-message = { -brand-short-name } se ye quedando sin espacio de disco. Los contenius d'os webs puede que no s'amuestren como cal. Vesite “Saber-ne mas” ta optimizar lo suyos uso de disco, pa tener una millor experiencia de navegación.

## Privacy Section - HTTPS-Only

httpsonly-header = Modo nomás HTTPS
httpsonly-description = HTTPS permite una connexión segura, encriptada entre { -brand-short-name } y las pachinas web que vesitas. La mayor parte d'os web funcionan con HTTPS, y si s'activa lo modo Nomás-HTTPS, { -brand-short-name } pasará totas las connexions a HTTPS.
httpsonly-learn-more = Saber-ne mas
httpsonly-radio-enabled =
    .label = Activar lo modo Nomás-HTTPS en totas las finestras
httpsonly-radio-enabled-pbm =
    .label = Activar lo modo Nomás-HTTPS nomás en as finestras privadas
httpsonly-radio-disabled =
    .label = No activar lo modo Nomás-HTTPS

## The following strings are used in the Download section of settings

desktop-folder-name = Escritorio
downloads-folder-name = Descargas
choose-download-folder-title = Trigar a carpeta de descargas:
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Alzar fichers en { $service-name }
