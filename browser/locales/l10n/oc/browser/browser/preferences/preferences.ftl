# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Mandar als sites web lo senhal « Me pistar pas » per lor dire que volètz pas èsser pistat
do-not-track-learn-more = Ne saber mai
do-not-track-option-default-content-blocking-known =
    .label = Solament quand { -brand-short-name } es configurat per blocar los traçadors coneguts
do-not-track-option-always =
    .label = Totjorn
pref-page-title =
    { PLATFORM() ->
        [windows] Opcions
       *[other] Preferéncias
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
            [windows] Recercar dins Opcions
           *[other] Recercar dins Preferéncias
        }
managed-notice = Vòstra organizacion gerís vòstre navegador.
pane-general-title = General
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = Acuèlh
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = Recercar
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = Vida privada e seguretat
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }
pane-experimental-title = Experiéncias de { -brand-short-name }
category-experimental =
    .tooltiptext = Experiéncias de { -brand-short-name }
pane-experimental-subtitle = Agissètz amb prudéncia
pane-experimental-search-results-header = Experiéncias de { -brand-short-name } : siatz atentiu
pane-experimental-description = Cambiar las configuracions avançadas pòt influenciar las performanças o la seguretat de { -brand-short-name }.
help-button-label = Assisténcia de { -brand-short-name }
addons-button-label = Extensions e tèmas
focus-search =
    .key = f
close-button =
    .aria-label = Tampar

## Browser Restart Dialog

feature-enable-requires-restart = { -brand-short-name } deu reaviar per activar aquesta foncionalitat.
feature-disable-requires-restart = { -brand-short-name } deu reaviar per activar aquesta foncionalitat.
should-restart-title = Reaviar { -brand-short-name }
should-restart-ok = Reaviar { -brand-short-name } ara
cancel-no-restart-button = Anullar
restart-later = Reaviar mai tard

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
extension-controlled-homepage-override = Una extension, <img data-l10n-name="icon"/> { $name }, contraròtla vòstra pagina d’acuèlh.
# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = Una extension, <img data-l10n-name="icon"/> { $name }, contraròtla la pagina Onglet novèl.
# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlled-password-saving = Una extension, <img data-l10n-name="icon"/> { $name }, contraròtla aqueste paramètre.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = Una extension, <img data-l10n-name="icon"/>{ $name }, contraròtla aqueste paramètre.
# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = Una extension, <img data-l10n-name="icon"/> { $name }, a definit lo motor de recèrca per defaut.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = Una extension, <img data-l10n-name="icon"/> { $name }, requerís los onglets isolats.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = Una extension, <img data-l10n-name="icon"/> { $name }, contraròtla aqueste paramètre.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = Una extension, <img data-l10n-name="icon"/>{ $name }, contraròtla lo biais que { -brand-short-name } se connecta a Internet.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Per activar aquesta extension anatz a <img data-l10n-name="addons-icon"/> Moduls complementaris dels menú <img data-l10n-name="menu-icon"/>.

## Preferences UI Search Results

search-results-header = Resultats de la recèrca
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Desolat ! I a pas de resultats dins Opcions per « <span data-l10n-name="query"></span> ».
       *[other] Desolat ! I a pas de resultats dins Preferéncias per « <span data-l10n-name="query"></span> ».
    }
search-results-help-link = Vos cal d’ajuda ? Consultatz l’<a data-l10n-name="url">Assisténcia de { -brand-short-name }</a>

## General Section

startup-header = Aviada
# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = Autorizar { -brand-short-name } e Firefox a s'executar a l’encòp
use-firefox-sync = Astúcia : aquò utiliza de perfils destriats. Utilizatz { -sync-brand-short-name } per partejar de donadas entre eles.
get-started-not-logged-in = Se connectar a { -sync-brand-short-name }…
get-started-configured = Dobrir las preferéncias del { -sync-brand-short-name }
always-check-default =
    .label = Totjorn verificar se { -brand-short-name } es vòstre navegador per defaut
    .accesskey = T
is-default = { -brand-short-name } es actualament vòstre navegador per defaut
is-not-default = { -brand-short-name } es pas vòstre navegador per defaut
set-as-my-default-browser =
    .label = Definir per defaut…
    .accesskey = D
startup-restore-previous-session =
    .label = Restablir la session precedenta
    .accesskey = s
startup-restore-warn-on-quit =
    .label = Vos avisar en sortir del navegador
disable-extension =
    .label = Desactivar l’extension
tabs-group-header = Onglets
ctrl-tab-recently-used-order =
    .label = Ctrl+Tab fa passar los onglets dins l'òrdre de darrièra utilizacion
    .accesskey = O
open-new-link-as-tabs =
    .label = Dobrir los ligams dins d’onglets allòc de fenèstras
    .accesskey = f
warn-on-close-multiple-tabs =
    .label = Vos avisar en tampar d'onglets multiples
    .accesskey = m
warn-on-open-many-tabs =
    .label = Vos avisar quand dobrir d'onglets multiples pòt alentir { -brand-short-name }
    .accesskey = d
switch-links-to-new-tabs =
    .label = En dobrissent un ligam dins un onglet novèl, i anar sul pic
    .accesskey = d
show-tabs-in-taskbar =
    .label = Afichar los apercebuts d'onglets dins la barra dels prètzfaits de Windows
    .accesskey = c
browser-containers-enabled =
    .label = Activar los onglets de contenidor
    .accesskey = a
browser-containers-learn-more = Ne saber mai
browser-containers-settings =
    .label = Paramètres…
    .accesskey = t
containers-disable-alert-title = Tampar totes los onglets de contenidor ?
containers-disable-alert-desc =
    { $tabCount ->
        [one] Se desactivetz los onglets isolats ara, { $tabCount } onglet isolat serà tampat. Segur que volatz desactivar los onglets isolats ?
       *[other] Se desactivetz los onglets isolats ara, { $tabCount } onglets isolats seràn tampats. Segur que volatz desactivar los onglets isolats ?
    }
containers-disable-alert-ok-button =
    { $tabCount ->
        [one] Tampar { $tabCount } onglet isolat
       *[other] Tampar { $tabCount } onglets isolats
    }
containers-disable-alert-cancel-button = Gardar activat
containers-remove-alert-title = Suprimir aqueste contenidor ?
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Se suprimiscatz aquel contenidor ara, { $count } onglet isolat serà tampat. Segur que volètz suprimir aqueste contenidor ? 
       *[other] Se suprimiscatz aquel contenidor ara, { $count } onglets isolats seràn tampats. Segur que volètz suprimir aqueste contenidor ?
    }
containers-remove-ok-button = Suprimir aqueste contenidor
containers-remove-cancel-button = Suprimir pas aqueste contenidor

## General Section - Language & Appearance

language-and-appearance-header = Lenga e aparéncia
fonts-and-colors-header = Poliças e colors
default-font = Poliça per defaut
    .accesskey = D
default-font-size = Talha
    .accesskey = l
advanced-fonts =
    .label = Avançat…
    .accesskey = A
colors-settings =
    .label = Colors…
    .accesskey = C
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Zoom
preferences-default-zoom = Zoom per defaut
    .accesskey = Z
preferences-default-zoom-value =
    .label = { $percentage } %
preferences-zoom-text-only =
    .label = Zoom tèxte solament
    .accesskey = t
language-header = Lenga
choose-language-description = Causissètz vòstra lenga preferida per l'afichatge de las paginas
choose-button =
    .label = Causir…
    .accesskey = a
choose-browser-language-description = Causissètz la lenga utilizada per mostrar los menús, messatges e las notificacions de { -brand-short-name }.
manage-browser-languages-button =
    .label = Causir d’alernativas…
    .accesskey = l
confirm-browser-language-change-description = Reaviar { -brand-short-name } per aplicar los cambiaments
confirm-browser-language-change-button = Aplicar e reaviar
translate-web-pages =
    .label = Traduire lo contengut web
    .accesskey = T
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Traduccions per <img data-l10n-name="logo"/>
translate-exceptions =
    .label = Excepcions…
    .accesskey = x
# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = Utilizar los paramètres de vòstre sistèma operatiu en « { $localeName } » per formatar las datas, las oras, los nombres e las mesuras.
check-user-spelling =
    .label = Verificar l'ortografia en picant
    .accesskey = t

## General Section - Files and Applications

files-and-applications-title = Fichièrs e aplicacions
download-header = Telecargaments
download-save-to =
    .label = Enregistrar los fichièrs dins lo dossièr
    .accesskey = n
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Causir…
           *[other] Percórrer…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] C
           *[other] P
        }
download-always-ask-where =
    .label = Sempre demandar ont enregistrar los fichièrs
    .accesskey = S
applications-header = Aplicacions
applications-description = Causir cossí { -brand-short-name } tracta los fichièrs qu'avètz telecargats del Web o las aplicacions qu'uilizatz al navegar.
applications-filter =
    .placeholder = Recercar los tipes de fichièr o aplicacions
applications-type-column =
    .label = Tipe de contengut
    .accesskey = T
applications-action-column =
    .label = Accion
    .accesskey = A
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = fichièr { $extension }
applications-action-save =
    .label = Enregistrar lo fichièr
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = Utilizar { $app-name }
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = Utilizar { $app-name } (per defaut)
applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] Utilizar l’aplicacion macOS par defaut
            [windows] Utilizar l’aplicacion Windows per defaut
           *[other] Utilizar l’aplicacion sistèma per defaut
        }
applications-use-other =
    .label = Utilizar un autre…
applications-select-helper = Seleccionatz l'ajuda de l'aplicacion
applications-manage-app =
    .label = Detalhs de l'aplicacion…
applications-always-ask =
    .label = Totjorn demandar
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
    .label = Utilizar { $plugin-name } (dins { -brand-short-name })
applications-open-inapp =
    .label = Dobrir dins { -brand-short-name }

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

drm-content-header = Contengut amb Digital Rights Management (DRM)
play-drm-content =
    .label = Legir lo contengut contrarotlat per DRM
    .accesskey = L
play-drm-content-learn-more = Ne saber mai
update-application-title = Mesas a jorn de { -brand-short-name }
update-application-description = Manténer { -brand-short-name } a jorn per de performança, estabilitat, e seguretat melhoras.
update-application-version = Version { $version } <a data-l10n-name="learn-more">Novetats</a>
update-history =
    .label = Afichar l'istoric de las mesas a jorn…
    .accesskey = M
update-application-allow-description = Autorizar { -brand-short-name } a
update-application-auto =
    .label = Installar automaticament las mesas a jorn (recomandat)
    .accesskey = A
update-application-check-choose =
    .label = Verificar las mesas a jorn disponiblas, mas podètz decidir de las installar o non
    .accesskey = V
update-application-manual =
    .label = Verificar pas jamai las mesas a jorns (pas recomandat)
    .accesskey = N
update-application-warning-cross-user-setting = Aqueste paramètres s’aplicarà a totes los comptes Windows e perfils { -brand-short-name } qu’utilizant aquesta installacion de { -brand-short-name }.
update-application-use-service =
    .label = Utilizar un servici en rèireplan per installar las mesas a jorn
    .accesskey = z
update-setting-write-failure-title = Error en enregistrant las preferéncias de mesas a jorn
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } a rescontrat una error e pas enregistrat aquesta modificacion. Notatz que modificar aqueste preferéncia de mesa a jorn requerís la permission d’escriure sul fichièr çai-jos. Vosautres o un administrator sistèma podètz benlèu corregir aquò en donant al grop Users l’accès complet a aqueste fichièr.
    
    Escritura impossibla sul fichièr : { $path }
update-in-progress-title = Actualizacion en cors
update-in-progress-message = Volètz que { -brand-short-name } contunhe amb aquesta mesa a jorn ?
update-in-progress-ok-button = &Ignorar
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Contunhar

## General Section - Performance

performance-title = Performanças
performance-use-recommended-settings-checkbox =
    .label = Utilizar los paramètres de performança recomandadas
    .accesskey = U
performance-use-recommended-settings-desc = Aquestes paramètres son adaptats al material e sistèma operatiu de vòstre ordenador.
performance-settings-learn-more = Ne saber mai
performance-allow-hw-accel =
    .label = Utilisar l'acceleracion grafica materiala se disponibla
    .accesskey = n
performance-limit-content-process-option = Limita del procediment del contengut
    .accesskey = L
performance-limit-content-process-enabled-desc = De procediments de contengut suplementaris pòdon melhorar las performanças en utilizant d'onglets multiples, pasmens aquò utiliza mai de memòria.
performance-limit-content-process-blocked-desc = Modificar lo nombre de procediments de contenguts es possible sonque amb la version multiprocediment de { -brand-short-name }. <a data-l10n-name="learn-more">Aprendre a verificar se de multiprocediments son activats</a>
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (defaut)

## General Section - Browsing

browsing-title = Navegacion
browsing-use-autoscroll =
    .label = Utilizar lo desfilament automatic
    .accesskey = a
browsing-use-smooth-scrolling =
    .label = Utilizar lo desfilament doç
    .accesskey = d
browsing-use-onscreen-keyboard =
    .label = Mostrar un clavièr tactil quand es necessari
    .accesskey = t
browsing-use-cursor-navigation =
    .label = Utilizar totjorn las tòcas de navegacion per se desplaçar a l'interior d'una pagina
    .accesskey = t
browsing-search-on-start-typing =
    .label = Començar la recèrca en picant lo tèxte
    .accesskey = x
browsing-picture-in-picture-toggle-enabled =
    .label = Activar lo contraròtle per l’incrustacion vidèo
    .accesskey = A
browsing-picture-in-picture-learn-more = Ne saber mai
browsing-cfr-recommendations =
    .label = Recomandar d’extensions pendent la navegacion
    .accesskey = R
browsing-cfr-features =
    .label = Recomandar de foncionalitats pendent la navegacion
    .accesskey = R
browsing-cfr-recommendations-learn-more = Ne saber mai

## General Section - Proxy

network-settings-title = Paramètres ret
network-proxy-connection-description = Configurar lo biais de { -brand-short-name } de se connectar a Internet.
network-proxy-connection-learn-more = Ne saber mai
network-proxy-connection-settings =
    .label = Paramètres…
    .accesskey = e

## Home Section

home-new-windows-tabs-header = Novèlas fenèstras e novèls onglets
home-new-windows-tabs-description2 = Causissètz çò que volètz veire en dobrir la pagina d’acuèlh, de fenèstras novèlas o d’onglets novèls.

## Home Section - Home Page Customization

home-homepage-mode-label = Pagina d’acuèlh e novèlas fenèstras
home-newtabs-mode-label = Onglets novèls
home-restore-defaults =
    .label = Restablir los paramètres per defaut
    .accesskey = R
# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Pagina d'acuèlh de Firefox (Per defaut)
home-mode-choice-custom =
    .label = Adreças personalizadas…
home-mode-choice-blank =
    .label = Pagina voida
home-homepage-custom-url =
    .placeholder = Pegar una adreça…
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Utilizar la pagina activa
           *[other] Utilizar las paginas activas
        }
    .accesskey = U
choose-bookmark =
    .label = Favorits…
    .accesskey = s

## Home Section - Firefox Home Content Customization

home-prefs-content-header = Contengut de la pagina d’acuèlh de Firefox
home-prefs-content-description = Causissètz lo contengut que volètz a la pagina d’acuèlh de Fireofx.
home-prefs-search-header =
    .label = Recèrca web
home-prefs-topsites-header =
    .label = Sites populars
home-prefs-topsites-description = Los sites que visitatz mai sovent

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Recomandat per { $provider }
home-prefs-recommended-by-description-update = Contengut excepcional de pertot del web, seleccionat per { $provider }

##

home-prefs-recommended-by-learn-more = Cossí fonciona
home-prefs-recommended-by-option-sponsored-stories =
    .label = Articles pairinejats
home-prefs-highlights-header =
    .label = Notables
home-prefs-highlights-description = Una seleccion de sites qu’avètz enregistrats o visitats
home-prefs-highlights-option-visited-pages =
    .label = Paginas visitadas
home-prefs-highlights-options-bookmarks =
    .label = Marcapaginas
home-prefs-highlights-option-most-recent-download =
    .label = Telecargament mai recent
home-prefs-highlights-option-saved-to-pocket =
    .label = Paginas enregistradas dins { -pocket-brand-name }
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Extraches
home-prefs-snippets-description = Actualitat de { -vendor-short-name } e { -brand-product-name }
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } linha
           *[other] { $num } linhas
        }

## Search Section

search-bar-header = Barra de recèrca
search-bar-hidden =
    .label = Emplegar la barra d’adreças per navegar e recercar
search-bar-shown =
    .label = Apondre la barre de recèrca a la barra d'aisinas
search-engine-default-header = Motor de cerca per defaut
search-engine-default-desc-2 = Aqueste es lo motor de recèrca per defaut de la barra d’adreça e de a barra de recèrca. Podètz lo cambiar quand volgatz.
search-engine-default-private-desc-2 = Causissètz un motor de recèrca diferent solament per las fenèstras privadas
search-separate-default-engine =
    .label = Utilizar aqueste motor de recèrca en navegacion privada
    .accesskey = U
search-suggestions-header = Suggestions de recèrca
search-suggestions-desc = Causissètz cossí apareisseràn las suggestions dels motors de recèrca.
search-suggestions-option =
    .label = Afichar de suggestions de recèrca
    .accesskey = A
search-show-suggestions-url-bar-option =
    .label = Mostrar las suggestions dins los resultats de la barra d'adreça
    .accesskey = l
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Mostrar las suggestions avant l’istoric dins la barra d’adreça
search-show-suggestions-private-windows =
    .label = Mostrar las suggestions de recèrca en navegacion privada
suggestions-addressbar-settings-generic = Cambiar las preferéncias per las suggestions de la barra d’adreça
search-suggestions-cant-show = Recercar las suggestions que son pas afichadas dins los resultats de la barra d'adreça qu'avètz configurat { -brand-short-name } per pas jamai servar l'istoric.
search-one-click-header = Motor de recèrca en un clic
search-one-click-desc = Causissètz de motors de recerca altenatius qu'apareisson jos las barras d'adreça e de recèrca quand començatz d’escriure un mot-clau.
search-choose-engine-column =
    .label = Motor de recèrca
search-choose-keyword-column =
    .label = Mot clau
search-restore-default =
    .label = Restablir los motors de recèrca per defaut
    .accesskey = d
search-remove-engine =
    .label = Suprimir
    .accesskey = S
search-add-engine =
    .label = Apondre
    .accesskey = p
search-find-more-link = Trobar mai de motors de recèrcas
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Doblon de mot clau
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Avètz causit un mot clau que ja es utilizat per « { $name } ». Causissètz-ne un autre.
search-keyword-warning-bookmark = Avètz causit un mot clau que ja es utilizat per un marcapaginas. Causissètz-ne un autre.

## Containers Section

containers-back-button =
    .aria-label =
        { PLATFORM() ->
            [windows] Tornar a las opcions
           *[other] Tornar a las preferéncias
        }
containers-header = Onglets de contenidor
containers-add-button =
    .label = Apondre un contenidor novèl
    .accesskey = A
containers-new-tab-check =
    .label = Seleccionar un contenidor diferent per cada onglet novèl
    .accesskey = S
containers-preferences-button =
    .label = Preferéncias
containers-remove-button =
    .label = Suprimir

## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Emportatz vòstre Web pertot
sync-signedout-description = Sincronizatz vòstres marcapaginas, istoric, onglets, senhals, moduls, e preferéncias per totes vòstres periferics.
sync-signedout-account-signin2 =
    .label = Se connectar a { -sync-brand-short-name }…
    .accesskey = c
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Telecargatz Firefox per <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> o <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> per sincronizar vòstre periferic mobil.

## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = Cambiar la fòto de perfil de l'utilizaire
sync-sign-out =
    .label = Se desconnectar
    .accesskey = d
sync-manage-account = Gestion del compte
    .accesskey = o
sync-signedin-unverified = { $email } es pas verificat.
sync-signedin-login-failure = Vos cal vos reconnectar { $email }
sync-resend-verification =
    .label = Tornar mandar la verificacion
    .accesskey = t
sync-remove-account =
    .label = Suprimir lo compte
    .accesskey = S
sync-sign-in =
    .label = Connexion
    .accesskey = x

## Sync section - enabling or disabling sync.

prefs-syncing-on = Sincronizacion : ACTIVADA
prefs-syncing-off = Sincronizacion : DESACTIVADA
prefs-sync-setup =
    .label = Configurar { -sync-brand-short-name }…
    .accesskey = C
prefs-sync-offer-setup-label = Sincronizar vòstres marcapaginas, istoric, onglets, senhals, moduls, e preferéncias per totes vòstres periferics.
prefs-sync-now =
    .labelnotsyncing = Sincronizar ara
    .accesskeynotsyncing = n
    .labelsyncing = Sincronizacion…

## The list of things currently syncing.

sync-currently-syncing-heading = Los elements seguents son actualament sincronizats :
sync-currently-syncing-bookmarks = Marcapaginas
sync-currently-syncing-history = Istoric
sync-currently-syncing-tabs = Onglets dobèrts
sync-currently-syncing-logins-passwords = Identificants e senhals
sync-currently-syncing-addresses = Adreças
sync-currently-syncing-creditcards = Cartas de crèdit
sync-currently-syncing-addons = Moduls complementaris
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] Opcions
       *[other] Preferéncias
    }
sync-change-options =
    .label = Modificar…
    .accesskey = M

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = Causir qué sincronizar
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = Enregistrar
    .buttonaccesskeyaccept = E
    .buttonlabelextra2 = Desconnectar…
    .buttonaccesskeyextra2 = D
sync-engine-bookmarks =
    .label = Marcapaginas
    .accesskey = M
sync-engine-history =
    .label = Istoric
    .accesskey = r
sync-engine-tabs =
    .label = Onglets dobèrts
    .tooltiptext = Una lista de çò qu’es dobèrts suls periferics sincronizats
    .accesskey = O
sync-engine-logins-passwords =
    .label = Identificants e senhals
    .tooltiptext = Identificants e senhals que gardatz
    .accesskey = I
sync-engine-addresses =
    .label = Adreças
    .tooltiptext = Las adreças postalas qu’avètz salvadas (pas qu’al ordenador)
    .accesskey = e
sync-engine-creditcards =
    .label = Cartas de crèdit
    .tooltiptext = Noms, numeròs e data d’expiracion (pas qu’al ordenador)
    .accesskey = C
sync-engine-addons =
    .label = los moduls complementaris
    .tooltiptext = Extensions e tèmas per Firefox per ordenador
    .accesskey = u
sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] Opcions
           *[other] Preferéncias
        }
    .tooltiptext = Los paramètres qu’avètz cambiat dins General, Vida Privada e Seguretat
    .accesskey = s

## The device name controls.

sync-device-name-header = Nom de l'aparelh
sync-device-name-change =
    .label = Cambiar lo nom del periferic…
    .accesskey = h
sync-device-name-cancel =
    .label = Anullar
    .accesskey = n
sync-device-name-save =
    .label = Enregistrar
    .accesskey = g
sync-connect-another-device = Connectar un periferic de mai

## Privacy Section

privacy-header = Confidencialitat del navegador

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Identificants e senhals
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Demandar per salvar los identificants e senhals dels sites
    .accesskey = r
forms-exceptions =
    .label = Excepcions…
    .accesskey = x
forms-generate-passwords =
    .label = Suggerir e generar de senhals fòrts
    .accesskey = u
forms-breach-alerts =
    .label = Afichar las alèrtas pels senhals dels sites concernits per de pèrdas de donadas
    .accesskey = A
forms-breach-alerts-learn-more-link = Ne saber mai
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Emplenar automaticament los identificants e senhals
    .accesskey = i
forms-saved-logins =
    .label = Identificants salvats…
    .accesskey = S
forms-master-pw-use =
    .label = Utilizar un senhal principal
    .accesskey = U
forms-primary-pw-use =
    .label = Utilizar un senhal principal
    .accesskey = U
forms-primary-pw-learn-more-link = Ne saber mai
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = Modificar lo senhal principal…
    .accesskey = M
forms-master-pw-fips-title = Actualament, sètz en mòde FIPS. Lo mòde FIPS necessita un senhal principal pas void.
forms-primary-pw-change =
    .label = Modificar lo senhal principal…
    .accesskey = M
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = { "" }
forms-primary-pw-fips-title = Actualament, sètz en mòde FIPS. Lo mòde FIPS requerís un senhal principal pas void.
forms-master-pw-fips-desc = La modificacion de senhal a pas capitat

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Per crear un senhal màger, picatz vòstras informacions de connexion Windows. Aquò permet de servar la seguretat dels comptes.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = crear un senhal principal
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Per crear un senhal principal, picatz vòstras informacions de connexion Windows. Aquò permet de servar la seguretat dels comptes.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = crear un senhal principal
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = Istoric
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Firefox", moving the verb into each option.
#     This will result in "Firefox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = { -brand-short-name }
    .accesskey = w
history-remember-option-all =
    .label = Conservar l'istoric
history-remember-option-never =
    .label = Conservar pas jamai l'istoric
history-remember-option-custom =
    .label = Utilizar los paramètres personalizats per l'istoric
history-remember-description = { -brand-short-name } enregistrarà vòstres istorics, telecargaments e recèrcas.
history-dontremember-description = { -brand-short-name } utilizarà los meteisses paramètres que per la navegacion privada e conservarà pas cap d'istoric quand navegaretz sus internet.
history-private-browsing-permanent =
    .label = Utilizar totjorn lo mòde de navegacion privada
    .accesskey = p
history-remember-browser-option =
    .label = Servar l'istoric de navegacion e dels telecargaments
    .accesskey = i
history-remember-search-option =
    .label = Conservar l'istoric de las recèrcas e dels formularis
    .accesskey = f
history-clear-on-close-option =
    .label = Voidar l'istoric quand { -brand-short-name } se tampa
    .accesskey = q
history-clear-on-close-settings =
    .label = Paramètres…
    .accesskey = t
history-clear-button =
    .label = Escafar l’istoric…
    .accesskey = s

## Privacy Section - Site Data

sitedata-header = Cookies e donadas de sites
sitedata-total-size-calculating = Calcul del pès de las donadas dels sites e del cache…
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Los cookies, lo cache e las donadas dels sites utilizan actualament { $value } { $unit } d’espaci disc.
sitedata-learn-more = Ne saber mai
sitedata-delete-on-close =
    .label = Suprimir los cookies e donadas de sites en tampant { -brand-short-name }
    .accesskey = c
sitedata-delete-on-close-private-browsing = En mòde de navegacion privada permanent, los cookies e las donadas de sites son totjorn escafats a la tampadura de { -brand-short-name }.
sitedata-allow-cookies-option =
    .label = Acceptar los cookies e dondas de site
    .accesskey = A
sitedata-disallow-cookies-option =
    .label = Blocar los cookies e donadas de site
    .accesskey = B
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Tipe de contengut blocat
    .accesskey = T
sitedata-option-block-cross-site-trackers =
    .label = Traçadors intersites
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = Traçadors intersites e de malhums socials
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = Los traçadors intersites e de malhums socials e isolar los cookies restants
sitedata-option-block-unvisited =
    .label = Cookies de sites pas visitats
sitedata-option-block-all-third-party =
    .label = Totes los cookies tèrces (pòt arribar qu’unes sites quitan de foncionar)
sitedata-option-block-all =
    .label = Totes los cookies (pòt arribar qu’unes sites quitan de foncionar)
sitedata-clear =
    .label = Escafar las donadas…
    .accesskey = s
sitedata-settings =
    .label = Gerir las donadas…
    .accesskey = G
sitedata-cookies-permissions =
    .label = Gerir las autorizacions…
    .accesskey = a
sitedata-cookies-exceptions =
    .label = Gerir las excepcions…
    .accesskey = x

## Privacy Section - Address Bar

addressbar-header = Barra d'adreça
addressbar-suggest = Quand utilizi la barra d'adreça, suggerir
addressbar-locbar-history-option =
    .label = Istoric de navegacion
    .accesskey = I
addressbar-locbar-bookmarks-option =
    .label = Marcapaginas
    .accesskey = M
addressbar-locbar-openpage-option =
    .label = Onglets dobèrts
    .accesskey = D
addressbar-locbar-topsites-option =
    .label = Mai visitats
    .accesskey = M
addressbar-suggestions-settings = Cambiar las preferéncias per las suggestions del motor de recèrca

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Proteccion contra lo seguiment renfortida
content-blocking-section-top-level-description = Los traçadors vos pistan en linha per reculhir d’informacions sus vòstras abituds de navegacion e vòstres interèsses. { -brand-short-name } bloca fòrça d’aqueles elements de seguiment e scripts malvolents.
content-blocking-learn-more = Ne saber mai

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Estandard
    .accesskey = d
enhanced-tracking-protection-setting-strict =
    .label = Estricte
    .accesskey = r
enhanced-tracking-protection-setting-custom =
    .label = Personalizat
    .accesskey = P

##

content-blocking-etp-standard-desc = Equilibri entre proteccion e performança. Las pagina cargaràn normalament.
content-blocking-etp-strict-desc = Proteccion renfortida, pòt copar unes sites o contenguts.
content-blocking-etp-custom-desc = Causissètz quins traçadors e scripts cal blocar.
content-blocking-private-windows = Contengut utilizat per pistar dins las fenèstras de navegacion privada
content-blocking-cross-site-tracking-cookies = Cookies de seguiment entre sites
content-blocking-cross-site-tracking-cookies-plus-isolate = Los traçadors intersites, e isolar los cookies restants
content-blocking-social-media-trackers = Traçadors de malhums socials
content-blocking-all-cookies = Totes los cookies
content-blocking-unvisited-cookies = Cookies dels sites pas visitats
content-blocking-all-windows-tracking-content = Contengut utilizat per pistar totas las fenèstras
content-blocking-all-third-party-cookies = Totes los cookies tèrces
content-blocking-cryptominers = Minaires de criptomonedas
content-blocking-fingerprinters = Generadors d’emprentas numericas
content-blocking-warning-title = Atencion !
content-blocking-and-isolating-etp-warning-description = Lo blocatge de traçadors e l’isolacion dels cookies pòdon aver una incidéncia sus las foncionalitats de certans sites. Tornatz cargar una pagina amb los traçadors per cargar tot lo contengut.
content-blocking-warning-learn-how = M’ensenhar cossí far
content-blocking-reload-description = Car tornar cargar los onglets per aplicar aquestas modificacions.
content-blocking-reload-tabs-button =
    .label = Tornar cargar totes los onglets
    .accesskey = r
content-blocking-tracking-content-label =
    .label = Contengut utilizat pel seguiment
    .accesskey = t
content-blocking-tracking-protection-option-all-windows =
    .label = Dins totas las fenèstras
    .accesskey = D
content-blocking-option-private =
    .label = Sonque dins las fenèstras privadas
    .accesskey = p
content-blocking-tracking-protection-change-block-list = Cambiar la lista de blocatge
content-blocking-cookies-label =
    .label = Cookies
    .accesskey = C
content-blocking-expand-section =
    .tooltiptext = Mai d’informacions
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Minaires de criptomonedas
    .accesskey = i
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Generadors d’emprentas numericas
    .accesskey = G

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Gerir las excepcions…
    .accesskey = x

## Privacy Section - Permissions

permissions-header = Permissions
permissions-location = Localizacion
permissions-location-settings =
    .label = Paramètres…
    .accesskey = P
permissions-xr = Realitat virtuala
permissions-xr-settings =
    .label = Paramètres…
    .accesskey = P
permissions-camera = Camèra
permissions-camera-settings =
    .label = Paramètres…
    .accesskey = P
permissions-microphone = Microfòn
permissions-microphone-settings =
    .label = Paramètres…
    .accesskey = P
permissions-notification = Notificacions
permissions-notification-settings =
    .label = Paramètres…
    .accesskey = P
permissions-notification-link = Ne saber mai
permissions-notification-pause =
    .label = Pausar las notificacions fins que { -brand-short-name } reavie
    .accesskey = n
permissions-autoplay = Lectura automatica
permissions-autoplay-settings =
    .label = Paramètres…
    .accesskey = P
permissions-block-popups =
    .label = Blocar las fenèstras sorgissentas
    .accesskey = B
permissions-block-popups-exceptions =
    .label = Excepcions…
    .accesskey = E
permissions-addon-install-warning =
    .label = M'avisar quand de sites web ensajen d'installar de moduls
    .accesskey = A
permissions-addon-exceptions =
    .label = Excepcions…
    .accesskey = E
permissions-a11y-privacy-checkbox =
    .label = Empachar los servicis d’accessibilitat d’accedir a vòstre navegador
    .accesskey = a
permissions-a11y-privacy-link = Ne saber mai

## Privacy Section - Data Collection

collection-header = Recuèlh de donadas e utilizacion per { -brand-short-name }
collection-description = Nos esforçam de vos daissar causir e reculhir sonque las informacions qu'avèm besonh per provesir e melhorar { -brand-short-name } per tot lo mond. Sempre demandam vòstra permission abans de recebre de donadas personalas.
collection-privacy-notice = Politica de confidencialitat
collection-health-report-telemetry-disabled = Autorizatz pas mai { -vendor-short-name } a capturar de donadas tecnicas e d’interaccion. Totas las donadas passadas seràn suprimidas d’aquí 30 jorns.
collection-health-report-telemetry-disabled-link = Ne saber mai
collection-health-report =
    .label = Autorizar { -brand-short-name } a mandar de donadas tecnicas e d’interaccions a { -vendor-short-name }
    .accesskey = A
collection-health-report-link = Ne saber mai
collection-studies =
    .label = Autorizar { -brand-short-name } d’installar e lançar d’estudis
collection-studies-link = Veire los estudis de { -brand-short-name }
addon-recommendations =
    .label = Permetre a { -brand-short-name } de realizar de recomandacion d’extensions
addon-recommendations-link = Ne saber mai
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Lo rapòrt de donadas es desactivat per aquela configuracion de compilacion
collection-backlogged-crash-reports =
    .label = Permetre a { -brand-short-name } d’enviar los rapòrts de bugs en espèra
    .accesskey = P
collection-backlogged-crash-reports-link = Ne saber mai

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Seguretat
security-browsing-protection = Proteccion contra los contenguts enganaires e los logicials perilhoses
security-enable-safe-browsing =
    .label = Blocar lo contengut perilhós e enganaire
    .accesskey = B
security-enable-safe-browsing-link = Ne saber mai
security-block-downloads =
    .label = Blocar los telecargaments perilhoses
    .accesskey = B
security-block-uncommon-software =
    .label = Vos avisar dels logicials pas desirats e pauc coneguts
    .accesskey = C

## Privacy Section - Certificates

certs-header = Certificats
certs-personal-label = Quand un servidor demanda vòstre certificat personal
certs-select-auto-option =
    .label = ne seleccionar un automaticament
    .accesskey = S
certs-select-ask-option =
    .label = Vos demandar cada còp
    .accesskey = D
certs-enable-ocsp =
    .label = Consultar los servidors respondeires OCSP per confirmar la validitat actuala de vòstres certificats
    .accesskey = C
certs-view =
    .label = Afichar los certificats…
    .accesskey = C
certs-devices =
    .label = Periferics de seguretat…
    .accesskey = P
space-alert-learn-more-button =
    .label = Ne saber mai
    .accesskey = S
space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] Dobrir las opcions
           *[other] Dobrir las preferéncias
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] D
        }
space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] { -brand-short-name } manca d’espaci disc. Lo contengut dels sites web poiriá s’afichar mal. Podètz escafar las donadas de site enregistradas dins Opcions > Vida privada e seguretat > Cookies e donadas de sites.
       *[other] { -brand-short-name } manca d’espaci disc. Lo contengut dels sites web poiriá s’afichar mal. Podètz escafar las donadas de site enregistradas dins Preferéncias > Vida privada e seguretat > Cookies e donadas de sites.
    }
space-alert-under-5gb-ok-button =
    .label = Òc, plan comprés
    .accesskey = O
space-alert-under-5gb-message = { -brand-short-name } a pas mai d'espaci disc. Los contenguts del site web pòdon s'afichar pas coma cal. Clicatz « Ne saber mai » per optimizar l'utilizacion de vòstre disc per melhorar la navegacion.

## Privacy Section - HTTPS-Only

httpsonly-header = Mòde HTTPS solament
httpsonly-description = Lo HTTPS provesís una connexion segura e chifrada entre { -brand-short-name } e lo site web que visitatz. La màger part dels site web son compatibles HTTPS, se lo mòde HTTPS solament es activat { -brand-short-name } passarà totas las connexion en HTTPS.
httpsonly-learn-more = Ne saber mai
httpsonly-radio-enabled =
    .label = Activar lo mòde HTTPS solament dins totas las fenèstras
httpsonly-radio-enabled-pbm =
    .label = Activar lo mòde HTTPS solament dins totas las fenèstras privadas
httpsonly-radio-disabled =
    .label = Activar pas lo mòde HTTS solament

## The following strings are used in the Download section of settings

desktop-folder-name = Burèu
downloads-folder-name = Telecargaments
choose-download-folder-title = Causissètz lo dossièr de telecargament :
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Enregistrar los fichièrs dins { $service-name }
