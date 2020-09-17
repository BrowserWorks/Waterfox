# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Unvia la señal «Nun rastrexar» a los sitios web p'avisalos de que nun quies que te rastrexen
do-not-track-learn-more = Deprendi más
do-not-track-option-default-content-blocking-known =
    .label = Namái cuando { -brand-short-name } ta configuráu pa bloquiar los rastrexadores conocíos
do-not-track-option-always =
    .label = Siempres

pref-page-title =
    { PLATFORM() ->
        [windows] Opciones
       *[other] Preferencies
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
            [windows] Atopar n'opciones
           *[other] Atopar en preferencies
        }

pane-general-title = Xeneral
category-general =
    .tooltiptext = { pane-general-title }

pane-home-title = Aniciu
category-home =
    .tooltiptext = { pane-home-title }

pane-search-title = Guetar
category-search =
    .tooltiptext = { pane-search-title }

pane-privacy-title = Privacidá y Seguranza
category-privacy =
    .tooltiptext = { pane-privacy-title }

help-button-label = Ayuda de { -brand-short-name }
addons-button-label = Estensiones y temes

focus-search =
    .key = f

close-button =
    .aria-label = Zarrar

## Browser Restart Dialog

feature-enable-requires-restart = { -brand-short-name } tien de reaniciase p'activar esta carauterística.
feature-disable-requires-restart = { -brand-short-name } tien de reaniciase pa desactivar esta carauterística.
should-restart-title = Reaniciar { -brand-short-name }
should-restart-ok = Reiniciar { -brand-short-name } agora
cancel-no-restart-button = Encaboxar
restart-later = Reaniciar dempués

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
extension-controlled-homepage-override = Una estensión, <img data-l10n-name="icon"/> { $name }, ta controlado la páxina d'aniciu.

# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = Una estensión, <img data-l10n-name="icon"/> { $name }, ta controlado la páxina de llingüeta nueva.

# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = Una estensión, <img data-l10n-name="icon"/> { $name }, ta controlando esta configuración.

# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = Una estensión, <img data-l10n-name="icon"/> { $name }, afitó'l motor predetermináu de gueta.

# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = Una estensión, <img data-l10n-name="icon"/> { $name }, rique llingüetes de contenedores.

# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = Una estensión, <img data-l10n-name="icon"/> { $name }, ta controlando esti axuste.

# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = Una estensión, <img data-l10n-name="icon"/> { $name }, controla cómo se coneuta { -brand-short-name } a Internet.

# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = P'activar la estensión vete a <img data-l10n-name="addons-icon"/> Complementos del menú <img data-l10n-name="menu-icon"/>.

## Preferences UI Search Results

search-results-header = Resultaos de gueta

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] ¡Sentímoslo! Nun hai resultaos pa "<span data-l10n-name="query"></span>" n'opciones.
       *[other] ¡Sentímoslo! Nun hai resultaos pa "<span data-l10n-name="query"></span>" en preferencies.
    }

search-results-help-link = ¿Necesites ayuda? Visita <a data-l10n-name="url">Ayuda de { -brand-short-name }</a>

## General Section

startup-header = Aniciu

# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = Permitir a { -brand-short-name } y Firefox executase al empar
use-firefox-sync = Conseyu: esto usa perfiles separtaos. Usa { -sync-brand-short-name } pa compartir datos ente ellos.
get-started-not-logged-in = Coneutase a { -sync-brand-short-name }…
get-started-configured = Abrir preferencies de { -sync-brand-short-name }

always-check-default =
    .label = Comprobar siempres si { -brand-short-name } ye'l to restolador por defeutu
    .accesskey = o

is-default = { -brand-short-name } ye'l to restolador web predetermináu
is-not-default = { -brand-short-name } nun ye'l to restolador web predetermináu

set-as-my-default-browser =
    .label = Facelu predetermináu…
    .accesskey = D

startup-restore-previous-session =
    .label = Restaurar sesión previa
    .accesskey = R

startup-restore-warn-on-quit =
    .label = Avisa al colar del navegador

disable-extension =
    .label = Deshabilitar estensión

tabs-group-header = Llingüetes

ctrl-tab-recently-used-order =
    .label = Ctrl+Tab circula pente les llingüetes nel orde según el so usu recién
    .accesskey = T

open-new-link-as-tabs =
    .label = Abrir enllaces en llingüetes en cuenta d'en ventanes nueves
    .accesskey = A

warn-on-close-multiple-tabs =
    .label = Avisar cuando zarres múltiples llingüetes
    .accesskey = m

warn-on-open-many-tabs =
    .label = Avisar si al abrir munches llingüetes { -brand-short-name } pue dir lentu
    .accesskey = d

switch-links-to-new-tabs =
    .label = Al abrir un enllaz nuna llingüeta nueva, cambiar a ella darréu
    .accesskey = a

show-tabs-in-taskbar =
    .label = Amosar previsualizaciones de llingüetes na barra de xeres de Windows
    .accesskey = m

browser-containers-enabled =
    .label = Habilitar llingüetes contenedores
    .accesskey = n

browser-containers-learn-more = Deprendi más

browser-containers-settings =
    .label = Axustes…
    .accesskey = u

containers-disable-alert-title = ¿Zarrar toles llingüetes contenedores?
containers-disable-alert-desc =
    { $tabCount ->
        [one] Si deshabilites les llingüetes contenedores agora, va zarrase { $tabCount } llingüeta contenedora. ¿Daveres que quies deshabilitar llingüetes contenedores?
       *[other] Si deshabilites les llingüetes contenedores agora, van zarrase { $tabCount } llingüetes contenedores. ¿Daveres que quies deshabilitar llingüetes contenedores?
    }

containers-disable-alert-ok-button =
    { $tabCount ->
        [one] Zarrar { $tabCount } llingüeta contenedora
       *[other] Zarrar { $tabCount } llingüetes contenedores
    }
containers-disable-alert-cancel-button = Calteneles habilitaes

containers-remove-alert-title = ¿Desaniciar esti contenedor?

# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Si desanicies esti contenedor agora, va zarrase { $count } llingüeta contenedora. ¿Daveres que quies desaniciar esti contenedor?
       *[other] Si desanicies esti contenedor agora, van zarrase { $count } llingüetes contenedores. ¿Daveres que quies desaniciar esti contenedor?
    }

containers-remove-ok-button = Desaniciar esti contenedor
containers-remove-cancel-button = Nun desaniciar esti contenedor


## General Section - Language & Appearance

language-and-appearance-header = Llingua y aspeutu

fonts-and-colors-header = Fontes y colores

default-font = Fonte predeterminada
    .accesskey = F
default-font-size = Tamañu
    .accesskey = T

advanced-fonts =
    .label = Avanzaes…
    .accesskey = v

colors-settings =
    .label = Colores…
    .accesskey = C

language-header = Llingua

choose-language-description = Escoyer llingua preferida p'amosar les páxines web

choose-button =
    .label = Escoyer…
    .accesskey = o

choose-browser-language-description = Seleiciona les llingües nes que van amosase los menús, mensaxes y notificaciones de { -brand-short-name }.
manage-browser-languages-button =
    .label = Afitar alternatives…
    .accesskey = A
confirm-browser-language-change-description = Reanicia { -brand-short-name } p'aplicar los cambeos
confirm-browser-language-change-button = Aplicar y reaniciar

translate-web-pages =
    .label = Traducir conteníu web
    .accesskey = d

# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Traducciones de <img data-l10n-name="logo"/>

translate-exceptions =
    .label = Esceiciones…
    .accesskey = s

check-user-spelling =
    .label = Revisar la ortografía según s'escribe
    .accesskey = R

## General Section - Files and Applications

files-and-applications-title = Ficheros y aplicaciones

download-header = Descargues

download-save-to =
    .label = Guardar ficheros en
    .accesskey = G

download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Escoyer…
           *[other] Restolar…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] e
           *[other] l
        }

download-always-ask-where =
    .label = Entrugar siempres aú guardar los ficheros
    .accesskey = A

applications-header = Aplicaciones

applications-description = Escueye cómo xestiona { -brand-short-name } los ficheros que descargues de la Web o les aplicaciones qu'uses mentanto restoles.

applications-filter =
    .placeholder = Guetar tipos de ficheros o aplicaciones

applications-type-column =
    .label = Mena de conteníu
    .accesskey = M

applications-action-column =
    .label = Aición
    .accesskey = A

# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = ficheru { $extension }
applications-action-save =
    .label = Guardar ficheru

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = Usar { $app-name }

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = Usar { $app-name } (predetermináu)

applications-use-other =
    .label = Usar otru…
applications-select-helper = Esbilla aplicación auxiliar

applications-manage-app =
    .label = Detalles de l'aplicación…
applications-always-ask =
    .label = Entrugar siempre
applications-type-pdf = Portable Document Format (PDF)

# Variables:
#   $type (String) - the MIME type (e.g application/binary)
applications-type-pdf-with-type = { applications-type-pdf } ({ $type })

# Variables:
#   $type-description (String) - Description of the type (e.g "Portable Document Format")
#   $type (String) - the MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })

# Variables:
#   $plugin-name (String) - Name of a plugin (e.g Adobe Flash)
applications-use-plugin-in =
    .label = Usar { $plugin-name } (en { -brand-short-name })

## The strings in this group are used to populate
## selected label element based on the string from
## the selected menu item.

applications-use-plugin-in-label =
    .value = { applications-use-plugin-in.label }

applications-action-save-label =
    .value = { applications-action-save.label }

applications-use-app-label =
    .value = { applications-use-app.label }

applications-always-ask-label =
    .value = { applications-always-ask.label }

applications-use-app-default-label =
    .value = { applications-use-app-default.label }

applications-use-other-label =
    .value = { applications-use-other.label }

##

drm-content-header = Conteníu con Digital Rights Management (DRM)

play-drm-content =
    .label = Reproducir conteníu remanáu por DRM
    .accesskey = R

play-drm-content-learn-more = Deprender más

update-application-title = Anovamientos de { -brand-short-name }

update-application-description = Caltén { -brand-short-name } anováu pa un meyor rindimientu, estabilidá y seguranza.

update-application-version = Versión { $version } <a data-l10n-name="learn-more">Qué hai nuevo</a>

update-history =
    .label = Amosar l'historial d'anovamientos…
    .accesskey = t

update-application-allow-description = Permitir a { -brand-short-name }:

update-application-auto =
    .label = Instalar anovamientos automáticamente (recomiéndase)
    .accesskey = I

update-application-check-choose =
    .label = Guetar anovamientos, pero permitir escoyer si instalalos
    .accesskey = G

update-application-manual =
    .label = Nun guetar por anovamientos (nun se recomienda)
    .accesskey = N

update-application-use-service =
    .label = Usar serviciu en segundu planu pa instalar los anovamientos
    .accesskey = v

update-in-progress-title = Anovamientu en cursu

update-in-progress-message = ¿Quies que { -brand-short-name } siga con esti anovamientu?

update-in-progress-ok-button = &Escartar
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Siguir

## General Section - Performance

performance-title = Rindimientu

performance-use-recommended-settings-checkbox =
    .label = Usar axustes recomendaos de rindimientu
    .accesskey = U

performance-use-recommended-settings-desc = Estos axustes adáutense al hardware y sistema operativu del to equipu.

performance-settings-learn-more = Deprendi más

performance-allow-hw-accel =
    .label = Usar aceleración de hardware cuando tea disponible
    .accesskey = h

performance-limit-content-process-option = Llende de procesos de conteníu
    .accesskey = L

performance-limit-content-process-enabled-desc = Más procesos de conteníu puen ameyorar el rindimientu al usar múltiples llingüetes, pero tamién van usar más memoria.
performance-limit-content-process-blocked-desc = Modificar el númberu de procesos de conteníu namái ye dable con { -brand-short-name } multiprocesu. <a data-l10n-name="learn-more">Saber cómo comprobar si'l multiprocesu ta activáu</a>

# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (predetermináu)

## General Section - Browsing

browsing-title = Restolar

browsing-use-autoscroll =
    .label = Usar desplazamientu automáticu
    .accesskey = d

browsing-use-smooth-scrolling =
    .label = Usar desplazamientu sele
    .accesskey = l

browsing-use-onscreen-keyboard =
    .label = Amosar un tecláu en pantalla cuando seya necesario
    .accesskey = t

browsing-use-cursor-navigation =
    .label = Usar siempre les tecles del cursor pa restolar dientro de les páxines
    .accesskey = c

browsing-search-on-start-typing =
    .label = Guetar el testu mientres s'escribe
    .accesskey = s

browsing-cfr-recommendations =
    .label = Recomendar estensiones mentanto se navega
    .accesskey = R

browsing-cfr-recommendations-learn-more = Deprendi más

## General Section - Proxy

network-settings-title = Axustes de rede

network-proxy-connection-description = Configura cómo { -brand-short-name } se coneute a internet.

network-proxy-connection-learn-more = Deprendi más

network-proxy-connection-settings =
    .label = Configuración…
    .accesskey = o

## Home Section

home-new-windows-tabs-header = Ventanes y llingüetes nueves

home-new-windows-tabs-description2 = Escueyi lo que ves cuando abres la páxina d'aniciu, ventanes y llingüetes nueves.

## Home Section - Home Page Customization

home-homepage-mode-label = Páxina d'aniciu y ventanes nueves

home-newtabs-mode-label = Llingüetes nueves

home-restore-defaults =
    .label = Restaurar axustes predeterminaos
    .accesskey = R

# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Aniciu de Firefox (predetermináu)

home-mode-choice-custom =
    .label = URLs personalizaes...

home-mode-choice-blank =
    .label = Páxina en blanco

home-homepage-custom-url =
    .placeholder = Apegar URL...

# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Usar páxina actual
           *[other] Usar páxines actuales
        }
    .accesskey = U

choose-bookmark =
    .label = Usar marcador…
    .accesskey = m

## Home Section - Firefox Home Content Customization

home-prefs-topsites-header =
    .label = Más visitaos

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

# Variables:
#  $provider (String): Name of the corresponding content provider, e.g "Pocket".
home-prefs-recommended-by-header =
    .label = Recomendáu por { $provider }
##

home-prefs-recommended-by-learn-more = Cómo funciona

home-prefs-highlights-header =
    .label = Destacaos
home-prefs-highlights-option-visited-pages =
    .label = Páxines visitaes
home-prefs-highlights-options-bookmarks =
    .label = Marcadores

# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Retayos
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } filera
           *[other] { $num } fileres
        }

## Search Section

search-bar-header = Barra de gueta
search-bar-hidden =
    .label = Usar la barra de direiciones pa guetar y restolar
search-bar-shown =
    .label = Amestar barra de gueta na barra de ferramientes

search-engine-default-header = Guetador por defeutu

search-suggestions-option =
    .label = Apurrir suxerencies de gueta
    .accesskey = D

search-show-suggestions-url-bar-option =
    .label = Amosar suxerencies de gueta nos resultaos de la barra direiciones
    .accesskey = A

# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Amosar suxerencies de gueta enantes del historial nos resultaos de la barra direiciones

search-suggestions-cant-show = Les suxerencies de gueta nun van amosase nos resultaos de la barra de direiciones porque configurasti { -brand-short-name } pa que nun recuerde l'historial.

search-one-click-header = Motores de gueta nun clic

search-one-click-desc = Escoyer los motores de gueta alternativos qu'apaecen baxo la barra de direiciones y la barra de gueta cuando entames a escribir una pallabra clave.

search-choose-engine-column =
    .label = Guetador
search-choose-keyword-column =
    .label = Pallabra clave

search-restore-default =
    .label = Reafitar motores de gueta por defeutu
    .accesskey = R

search-remove-engine =
    .label = Desaniciar
    .accesskey = D

search-find-more-link = Atopar más motores de gueta

# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Pallabra clave duplicada
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Esbillesti una pallabra clave qu'anguaño s'usa por «{ $name }». Esbilla otra, por favor.
search-keyword-warning-bookmark = Esbillesti una pallabra clave qu'anguaño s'usa nun marcador. Esbilla otra, por favor.

## Containers Section

containers-header = Llingüetes contenedor
containers-add-button =
    .label = Amestar contenedor nuevu
    .accesskey = A

containers-preferences-button =
    .label = Preferencies
containers-remove-button =
    .label = Desaniciar

## Sync Section - Signed out


## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Lleva la web contigo
sync-signedout-description = Sincroniza los tos marcadores, historial, llingüetes, contraseñes, add-ons y preferencies pente tolos tos preseos.

# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Baxa Firefox pa <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> o <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> pa sincronizar col to preséu móvil.

## Sync Section - Signed in


## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = Camudar semeya de perfil

sync-manage-account = Xestionar cuenta
    .accesskey = o

sync-signedin-unverified = { $email } nun ta verificada.
sync-signedin-login-failure = Anicia sesión pa reconeutate, por favor { $email }

sync-resend-verification =
    .label = Reunviar verificación
    .accesskey = R

sync-remove-account =
    .label = Desaniciar cuenta
    .accesskey = D

sync-sign-in =
    .label = Aniciar sesión
    .accesskey = g

## Sync section - enabling or disabling sync.


## The list of things currently syncing.


## The "Choose what to sync" dialog.

sync-engine-bookmarks =
    .label = Marcadores
    .accesskey = m

sync-engine-history =
    .label = Historial
    .accesskey = r

sync-engine-tabs =
    .label = Llingüetes abiertes
    .tooltiptext = Una llista de lo que ta abierto en tolos preseos sincronizaos
    .accesskey = L

sync-engine-addresses =
    .label = Direiciones
    .tooltiptext = Direiciones postales que guardasti (namái escritoriu)
    .accesskey = D

sync-engine-creditcards =
    .label = Tarxetes de creitu
    .tooltiptext = Nomes, númberos y dates de caducidá (namái escritoriu)
    .accesskey = T

sync-engine-addons =
    .label = Complementos
    .tooltiptext = Estensiones y temes pa Firefox d'escritoriu
    .accesskey = C

sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] Opciones
           *[other] Preferencies
        }
    .tooltiptext = Configuración xeneral, de privacidá y de seguranza que cambiasti
    .accesskey = O

## The device name controls.

sync-device-name-header = Nome del preséu

sync-device-name-change =
    .label = Camudar nome del preséu…
    .accesskey = C

sync-device-name-cancel =
    .label = Encaboxar
    .accesskey = n

sync-device-name-save =
    .label = Guardar
    .accesskey = v

## Privacy Section

privacy-header = Privacidá del restolador

## Privacy Section - Forms


## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Usuarios y contraseñes
    .searchkeywords = { -lockwise-brand-short-name }

forms-ask-to-save-logins =
    .label = Entrugar pa guardar contraseñes y anicios de sesión de sitios web
    .accesskey = E
forms-exceptions =
    .label = Esceiciones…
    .accesskey = s

forms-saved-logins =
    .label = Anicios de sesión guardaos…
    .accesskey = A
forms-master-pw-use =
    .label = Usar una contraseña maestra
    .accesskey = U
forms-master-pw-change =
    .label = Camudar contraseña maestra…
    .accesskey = m

forms-master-pw-fips-title = Nesti intre tas en mou FIPS. FIPS requier una contraseña maestra non erma.

forms-master-pw-fips-desc = Fallu al camudar la contraseña

## OS Authentication dialog


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
history-remember-label = { -brand-short-name } podrá:
    .accesskey = o

history-remember-option-all =
    .label = Recordar l'historial
history-remember-option-never =
    .label = Nun recordar historial
history-remember-option-custom =
    .label = Usar una configuración personalizada pal historial

history-remember-description = { -brand-short-name } va recordar l'historial de navegación, descargues, formularios y guetes.
history-dontremember-description = { -brand-short-name } usará los mesmos axustes que Restolar en privao u nun rescordará historial dalu cuando restoles la web.

history-private-browsing-permanent =
    .label = Usar siempres el mou Restolar en privao
    .accesskey = p

history-remember-browser-option =
    .label = Recordar historial de navegación y descargues
    .accesskey = R

history-remember-search-option =
    .label = Recordar l'historial de formularios y guetes
    .accesskey = f

history-clear-on-close-option =
    .label = Llimpiar l'historial cuando { -brand-short-name } se zarre
    .accesskey = r

history-clear-on-close-settings =
    .label = Axustes…
    .accesskey = C

history-clear-button =
    .label = Llimpiar historial…
    .accesskey = L

## Privacy Section - Site Data

sitedata-header = Cookies y datos del sitiu

sitedata-total-size-calculating = Calculando'l tamañu de los datos del sitiu y del caché…

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Les  cookies, datos del sitiu y caché almacenaos ocupen anguaño un { $value } { $unit } d'espaciu en discu.

sitedata-learn-more = Deprendi más

sitedata-delete-on-close =
    .label = Desaniciar cookies y datos del sitiu cuando zarre { -brand-short-name }
    .accesskey = D

sitedata-allow-cookies-option =
    .label = Aceutar cookies y datos del sitiu
    .accesskey = A

sitedata-disallow-cookies-option =
    .label = Bloquiar cookies y datos del sitiu
    .accesskey = B

# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Tipu bloquiáu
    .accesskey = T

sitedata-option-block-unvisited =
    .label = Cookies de sitios web non andaos
sitedata-option-block-all-third-party =
    .label = Toles cookies de terceros (pue facer que dalgunos sitios web nun furrulen)
sitedata-option-block-all =
    .label = Toles cookies (fadrá que dalgunos sitios web nun furrulen)

sitedata-clear =
    .label = Llimpiar datos…
    .accesskey = L

sitedata-settings =
    .label = Xestionar datos…
    .accesskey = X

sitedata-cookies-permissions =
    .label = Xestionar permisos...
    .accesskey = X

## Privacy Section - Address Bar

addressbar-header = Barra de direiciones

addressbar-suggest = Al usar la barra de direiciones, suxerir:

addressbar-locbar-history-option =
    .label = Historial de navegación
    .accesskey = H
addressbar-locbar-bookmarks-option =
    .label = Marcadores
    .accesskey = M
addressbar-locbar-openpage-option =
    .label = Abrir llingüetes
    .accesskey = A

addressbar-suggestions-settings = Camudar preferencies pa les suxerencies de los motores de gueta

## Privacy Section - Content Blocking

## These strings are used to define the different levels of
## Enhanced Tracking Protection.


##

content-blocking-tracking-protection-option-all-windows =
    .label = En toles ventanes
    .accesskey = t

content-blocking-cookies-label =
    .label = Cookies
    .accesskey = C

## Privacy Section - Tracking


## Privacy Section - Permissions

permissions-header = Permisos

permissions-location = Allugamientu
permissions-location-settings =
    .label = Axustes…
    .accesskey = t

permissions-camera = Cámara
permissions-camera-settings =
    .label = Axustes…
    .accesskey = t

permissions-microphone = Micrófonu
permissions-microphone-settings =
    .label = Axustes…
    .accesskey = t

permissions-notification = Avisos
permissions-notification-settings =
    .label = Axustes…
    .accesskey = t
permissions-notification-link = Deprendi más

permissions-autoplay = Reproducción automática

permissions-autoplay-settings =
    .label = Axustes...
    .accesskey = e

permissions-block-popups =
    .label = Bloquiar ventanes emerxentes
    .accesskey = B

permissions-block-popups-exceptions =
    .label = Esceiciones…
    .accesskey = E

permissions-addon-install-warning =
    .label = Avisar cuando los sitios web intenten instalar add-ons
    .accesskey = A

permissions-addon-exceptions =
    .label = Esceiciones…
    .accesskey = E

permissions-a11y-privacy-link = Deprendi más

## Privacy Section - Data Collection

collection-privacy-notice = Avisu de privacidá

collection-health-report-link = Deprender más

collection-backlogged-crash-reports-link = Deprender más

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Seguranza

security-enable-safe-browsing =
    .label = Bloquiar conteníu peligrosu y fraudulentu
    .accesskey = B
security-enable-safe-browsing-link = Deprendi más

security-block-downloads =
    .label = Bloquiar descargues peligroses
    .accesskey = D

## Privacy Section - Certificates

certs-header = Certificaos

certs-personal-label = Cuando un sirvidor solicite'l to certificáu personal:

certs-select-auto-option =
    .label = Seleicionar ún automáticamente
    .accesskey = S

certs-select-ask-option =
    .label = Entrugame cada vegada
    .accesskey = A

certs-enable-ocsp =
    .label = Consultar a los sirvidores respondedores OCSP pa confirmar la validez actual de los certificaos
    .accesskey = u

certs-view =
    .label = Ver certificaos…
    .accesskey = C

certs-devices =
    .label = Preseos de seguridá…
    .accesskey = D

space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] Abrir opciones
           *[other] Abrir preferencies
        }
    .accesskey =
        { PLATFORM() ->
            [windows] b
           *[other] A
        }

space-alert-under-5gb-ok-button =
    .label = Val, píllolo
    .accesskey = a

## Privacy Section - HTTPS-Only

## The following strings are used in the Download section of settings

desktop-folder-name = Escritoriu
downloads-folder-name = Descargues
choose-download-folder-title = Escoyer carpeta de descarga:

