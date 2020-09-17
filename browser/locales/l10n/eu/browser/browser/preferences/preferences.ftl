# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Bidali webguneei "Do Not Track" seinalea zure jarraipena ez egitea adierazteko
do-not-track-learn-more = Argibide gehiago
do-not-track-option-default-content-blocking-known =
    .label = Bakarrik { -brand-short-name } jarraipen-elementu ezagunak blokeatzeko ezarrita dagoenean
do-not-track-option-always =
    .label = Beti

pref-page-title =
    { PLATFORM() ->
        [windows] Aukerak
       *[other] Hobespenak
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
            [windows] Bilatu aukeretan
           *[other] Bilatu hobespenetan
        }

managed-notice = Nabigatzailea zure erakundeak kudeatzen du.

pane-general-title = Orokorra
category-general =
    .tooltiptext = { pane-general-title }

pane-home-title = Hasiera-orria
category-home =
    .tooltiptext = { pane-home-title }

pane-search-title = Bilaketa
category-search =
    .tooltiptext = { pane-search-title }

pane-privacy-title = Pribatutasuna eta segurtasuna
category-privacy =
    .tooltiptext = { pane-privacy-title }

pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }

pane-experimental-title = { -brand-short-name } esperimentuak
category-experimental =
    .tooltiptext = { -brand-short-name } esperimentuak
pane-experimental-subtitle = Kontuz jarraitu
pane-experimental-description = Konfigurazio-hobespen aurreratuak aldatzeak { -brand-short-name }(r)en errendimendu edo segurtasunean eragin lezake.

help-button-label = { -brand-short-name } laguntza
addons-button-label = Hedapenak eta itxurak

focus-search =
    .key = f

close-button =
    .aria-label = Itxi

## Browser Restart Dialog

feature-enable-requires-restart = { -brand-short-name } berrabiarazi behar da eginbide hau gaitzeko.
feature-disable-requires-restart = { -brand-short-name } berrabiarazi behar da eginbide hau desgaitzeko.
should-restart-title = Berrabiarazi { -brand-short-name }
should-restart-ok = Berrabiarazi { -brand-short-name } orain
cancel-no-restart-button = Utzi
restart-later = Berrabiarazi geroago

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
extension-controlled-homepage-override = <img data-l10n-name="icon"/> { $name } hedapenak zure hasiera-orria kontrolatzen du.

# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = <img data-l10n-name="icon"/> { $name } hedapenak zure fitxa berriaren orria kontrolatzen du.

# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = Hedapen bat, <img data-l10n-name="icon"/> { $name }, ezarpen hau kontrolatzen ari da.

# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = Hedapen batek (<img data-l10n-name="icon"/> { $name }) zure bilaketa-motor lehenetsia ezarri du.

# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = <img data-l10n-name="icon"/> { $name } hedapenak edukiontzi-fitxak behar ditu.

# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = Hedapen bat, <img data-l10n-name="icon"/> { $name }, ezarpen hau kontrolatzen ari da.

# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = <img data-l10n-name="icon"/> { $name } hedapenak { -brand-short-name } Internetera nola konektatzen den kontrolatzen du.

# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Hedapena gaitzeko, zoaz <img data-l10n-name="addons-icon"/> Gehigarriak aukerara <img data-l10n-name="menu-icon"/> menuan.

## Preferences UI Search Results

search-results-header = Bilaketaren emaitzak

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Barkatu! Aukeretan ez dago "<span data-l10n-name="query"></span>" bilaketarako emaitzarik.
       *[other] Barkatu! Hobespenetan ez dago "<span data-l10n-name="query"></span>" bilaketarako emaitzarik.
    }

search-results-help-link = Laguntza behar duzu? Bisitatu <a data-l10n-name="url">{ -brand-short-name }(r)en laguntza</a>

## General Section

startup-header = Abioa

# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = Baimendu { -brand-short-name } eta Firefox aldi berean exekutatzea
use-firefox-sync = Aholkua: bereizitako profilak erabiltzen ditu honek. Erabili { -sync-brand-short-name } hauen artean datuak partekatzeko.
get-started-not-logged-in = Hasi saioa { -sync-brand-short-name }(e)n…
get-started-configured = Ireki { -sync-brand-short-name } hobespenak

always-check-default =
    .label = Egiaztatu beti ea { -brand-short-name } nabigatzaile lehenetsia den
    .accesskey = E

is-default = { -brand-short-name } nabigatzaile lehenetsia da une honetan
is-not-default = { -brand-short-name } ez da zure nabigatzaile lehenetsia

set-as-my-default-browser =
    .label = Lehenetsi…
    .accesskey = L

startup-restore-previous-session =
    .label = Berreskuratu aurreko saioa
    .accesskey = B

startup-restore-warn-on-quit =
    .label = Abisatu nabigatzailetik irtetean

disable-extension =
    .label = Desgaitu hedapena

tabs-group-header = Fitxak

ctrl-tab-recently-used-order =
    .label = Ktrl+Tab konbinazioak fitxaz aldatzen du azkenekoz erabilitako ordenan
    .accesskey = T

open-new-link-as-tabs =
    .label = Ireki loturak fitxetan eta ez leiho berrietan
    .accesskey = x

warn-on-close-multiple-tabs =
    .label = Abisatu hainbat fitxa ixterakoan
    .accesskey = b

warn-on-open-many-tabs =
    .label = Abisatu hainbat fitxa irekitzean honek { -brand-short-name } moteldu balezake
    .accesskey = A

switch-links-to-new-tabs =
    .label = Aldatu fitxa berrira lotura bat fitxa berrian irekitzean
    .accesskey = A

show-tabs-in-taskbar =
    .label = Erakutsi fitxen aurrebistak Windowseko ataza-barran
    .accesskey = z

browser-containers-enabled =
    .label = Gaitu edukiontzi-fitxak
    .accesskey = G

browser-containers-learn-more = Argibide gehiago

browser-containers-settings =
    .label = Ezarpenak…
    .accesskey = r

containers-disable-alert-title = Itxi edukiontzi-fitxa gutziak?
containers-disable-alert-desc =
    { $tabCount ->
        [one] Edukiontzi-fitxak orain desgaituz gero, edukiontzi-fitxa bat itxi egingo da. Ziur zaude edukiontzi-fitxak desgaitu nahi dituzula?
       *[other] Edukiontzi-fitxak orain desgaituz gero, { $tabCount } edukiontzi-fitxa itxi egingo dira. Ziur zaude edukiontzi-fitxak desgaitu nahi dituzula?
    }

containers-disable-alert-ok-button =
    { $tabCount ->
        [one] Itxi edukiontzi-fitxa bat
       *[other] Itxi { $tabCount } edukiontzi-fitxa
    }
containers-disable-alert-cancel-button = Mantendu gaituta

containers-remove-alert-title = Edukiontzi hau kendu?

# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Edukiontzi hau orain kenduz gero, edukiontzi-fitxa bat itxi egingo da. Ziur zaude edukiontzi hau kendu nahi duzula?
       *[other] Edukiontzi hau orain kenduz gero, { $count } edukiontzi-fitxa itxi egingo dira. Ziur zaude edukiontzi hau kendu nahi dituzula?
    }

containers-remove-ok-button = Kendu edukiontzia
containers-remove-cancel-button = Ez kendu edukiontzia


## General Section - Language & Appearance

language-and-appearance-header = Hizkuntza eta itxura

fonts-and-colors-header = Letra-tipoak eta koloreak

default-font = Letra-tipo lehenetsia
    .accesskey = n
default-font-size = Tamaina
    .accesskey = T

advanced-fonts =
    .label = Aurreratua…
    .accesskey = u

colors-settings =
    .label = Koloreak…
    .accesskey = o

# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Zooma

preferences-default-zoom = Zoom lehenetsia
    .accesskey = Z

preferences-default-zoom-value =
    .label = %{ $percentage }

preferences-zoom-text-only =
    .label = Zooma testuan soilik
    .accesskey = t

language-header = Hizkuntza

choose-language-description = Aukeratu orriak bistaratzeko hizkuntza hobetsia

choose-button =
    .label = Aukeratu…
    .accesskey = A

choose-browser-language-description = Aukeratu { -brand-short-name }(r)en menuak, mezuak eta jakinarazpenak bistaratzeko hizkuntzak.
manage-browser-languages-button =
    .label = Ezarri ordezkoak…
    .accesskey = d
confirm-browser-language-change-description = Berrabiarazi { -brand-short-name } aldaketa hauek aplikatzeko
confirm-browser-language-change-button = Aplikatu eta berrabiarazi

translate-web-pages =
    .label = Itzuli webeko edukia
    .accesskey = I

# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Itzulpenak: <img data-l10n-name="logo"/>

translate-exceptions =
    .label = Salbuespenak…
    .accesskey = S

# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = Erabili zure sitema eragilearen "{ $localeName }" hizkuntzaren ezarpenak datak, orduak, zenbakiak eta neurriak formateatzeko.

check-user-spelling =
    .label = Egiaztatu ortografia idatzi ahala
    .accesskey = z

## General Section - Files and Applications

files-and-applications-title = Fitxategiak eta aplikazioak

download-header = Deskargak

download-save-to =
    .label = Gorde fitxategiak hemen:
    .accesskey = G

download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Aukeratu…
           *[other] Arakatu…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] e
           *[other] A
        }

download-always-ask-where =
    .label = Galdetu beti non gorde fitxategiak
    .accesskey = n

applications-header = Aplikazioak

applications-description = Aukeratu { -brand-short-name }(e)k nola maneiatzen dituen webetik edo erabiltzen dituzun aplikazioetatik deskargatzen dituzun fitxategiak.

applications-filter =
    .placeholder = Bilatu fitxategi motak edo aplikazioak

applications-type-column =
    .label = Eduki mota
    .accesskey = t

applications-action-column =
    .label = Ekintza
    .accesskey = E

# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = { $extension } fitxategia
applications-action-save =
    .label = Gorde fitxategia

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = Erabili { $app-name }

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = { $app-name } erabili (lehenetsia)

applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] Erabili macOS aplikazio lehenetsia
            [windows] Erabili Windows aplikazio lehenetsia
           *[other] Erabili sistemaren aplikazio lehenetsia
        }

applications-use-other =
    .label = Beste bat…
applications-select-helper = Hautatu laguntza-aplikazioa

applications-manage-app =
    .label = Aplikazioaren xehetasunak…
applications-always-ask =
    .label = Galdetu beti
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
    .label = Erabili { $plugin-name } ({ -brand-short-name }(e)n)
applications-open-inapp =
    .label = Ireki { -brand-short-name }(e)n

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

drm-content-header = DRM edukia

play-drm-content =
    .label = Erreproduzitu DRM bidez kontrolatutako edukia
    .accesskey = E

play-drm-content-learn-more = Argibide gehiago

update-application-title = { -brand-short-name } eguneraketak

update-application-description = Mantendu { -brand-short-name } eguneratuta errendimendu, egonkortasun eta segurtasun onena bermatzeko.

update-application-version = { $version }bertsioa <a data-l10n-name="learn-more">Nobedadeak</a>

update-history =
    .label = Erakutsi eguneraketen historia…
    .accesskey = E

update-application-allow-description = Baimendu { -brand-short-name }(r)i

update-application-auto =
    .label = Instalatu eguneraketak automatikoki (gomendatua)
    .accesskey = a

update-application-check-choose =
    .label = Eguneraketak bilatzen baina utzi aukeratzen instalatuko diren edo ez
    .accesskey = b

update-application-manual =
    .label = Ez egiaztatu inoiz eguneraketarik dagoen (ez gomendatua)
    .accesskey = n

update-application-warning-cross-user-setting = Ezarpen honek Windows kontu guztiei eta { -brand-short-name }(r)en instalazio hau darabilten profilei eragingo die.

update-application-use-service =
    .label = Erabili atzeko planoko zerbitzua eguneraketak instalatzeko
    .accesskey = z

update-setting-write-failure-title = Errorea eguneraketen hobespenak gordetzean

# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name }(e)k errore bat aurkitu du eta ez du aldaketa hau gorde. Kontuan izan eguneraketen hobespen hau ezartzeak azpiko fitxategia idazteko baimenak behar dituela. Zu edo sistema-kudeatzaile bat errorea konpontzeko moduan izan zaitezkete erabiltzaileen taldeari fitxategi honetarako kontrol osoa emanez.
    
     Ezin da fitxategira idatzi: { $path }

update-in-progress-title = Eguneraketa burutzen ari da

update-in-progress-message = { -brand-short-name }(e)k eguneraketa honekin jarraitzea nahi duzu?

update-in-progress-ok-button = &Baztertu
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Jarraitu

## General Section - Performance

performance-title = Errendimendua

performance-use-recommended-settings-checkbox =
    .label = Erabili gomendatutako errendimendu-ezarpenak
    .accesskey = E

performance-use-recommended-settings-desc = Ezarpen hauek zure ordenagailuaren hardwareari eta sistema eragileari egokituta daude.

performance-settings-learn-more = Argibide gehiago

performance-allow-hw-accel =
    .label = Erabili hardware-azelerazioa erabilgarri dagoenean
    .accesskey = h

performance-limit-content-process-option = Eduki-prozesuen muga
    .accesskey = m

performance-limit-content-process-enabled-desc = Eduki-prozesu gehigarriek errendimendua hobe dezakete hainbat fitxa erabiltzean baina memoria gehiago ere erabiliko du.
performance-limit-content-process-blocked-desc = Edukien prozesu kopurua multiprozesu moduko { -brand-short-name }(r)ekin alda daiteke soilik. <a data-l10n-name="learn-more">Argibide gehiago multiprozesu modua gaituta dagoen egiaztatzeko</a>

# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (lehenetsia)

## General Section - Browsing

browsing-title = Nabigatzea

browsing-use-autoscroll =
    .label = Erabili korritze automatikoa
    .accesskey = a

browsing-use-smooth-scrolling =
    .label = Erabili korritze leuna
    .accesskey = u

browsing-use-onscreen-keyboard =
    .label = Beharrezkoa denean, erakutsi ukipen-teklatua
    .accesskey = k

browsing-use-cursor-navigation =
    .label = Erabili beti kurtsore-teklak orriak nabigatzeko
    .accesskey = k

browsing-search-on-start-typing =
    .label = Bilatu testua idazten hasi bezain laster
    .accesskey = B

browsing-picture-in-picture-toggle-enabled =
    .label = Gaitu bideoa beste leiho batean ikusteko kontrolak
    .accesskey = G

browsing-picture-in-picture-learn-more = Argibide gehiago

browsing-cfr-recommendations =
    .label = Gomendatu hedapenak nabigatu ahala
    .accesskey = G
browsing-cfr-features =
    .label = Gomendatu eginbideak nabigatu ahala
    .accesskey = G

browsing-cfr-recommendations-learn-more = Argibide gehiago

## General Section - Proxy

network-settings-title = Sareko ezarpenak

network-proxy-connection-description = Konfiguratu { -brand-short-name } nola konektatzen den Internetera.

network-proxy-connection-learn-more = Argibide gehiago

network-proxy-connection-settings =
    .label = Ezarpenak…
    .accesskey = E

## Home Section

home-new-windows-tabs-header = Leiho eta fitxa berriak

home-new-windows-tabs-description2 = Aukeratu zer ikusi nahi duzun zure hasiera-orria, leiho berriak eta fitxa berriak irekitzean.

## Home Section - Home Page Customization

home-homepage-mode-label = Hasiera-orria eta leiho berriak

home-newtabs-mode-label = Fitxa berriak

home-restore-defaults =
    .label = Berrezarri lehenetsiak
    .accesskey = B

# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Firefoxen hasiera-orria (lehenetsia)

home-mode-choice-custom =
    .label = URL pertsonalizatuak…

home-mode-choice-blank =
    .label = Orri zuria

home-homepage-custom-url =
    .placeholder = Itsatsi URLa…

# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Erabili uneko orria
           *[other] Erabili uneko orriak
        }
    .accesskey = u

choose-bookmark =
    .label = Erabili laster-marka…
    .accesskey = b

## Home Section - Firefox Home Content Customization

home-prefs-content-header = Firefoxen hasiera-orriko edukia
home-prefs-content-description = Aukeratu zein eduki nahi duzun Firefoxen hasiera-orriko pantailan.

home-prefs-search-header =
    .label = Web bilaketa
home-prefs-topsites-header =
    .label = Gune erabilienak
home-prefs-topsites-description = Gehien bisitatzen dituzun guneak

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = { $provider } hornitzaileak gomendatuta
home-prefs-recommended-by-description-update = Webeko aparteko edukia, { $provider } hornitzaileak bilduta

##

home-prefs-recommended-by-learn-more = Nola dabilen
home-prefs-recommended-by-option-sponsored-stories =
    .label = Babesleen istorioak

home-prefs-highlights-header =
    .label = Nabarmendutakoak
home-prefs-highlights-description = Gorde edo bisitatu dituzun guneen hautapena
home-prefs-highlights-option-visited-pages =
    .label = Bisitatutako orriak
home-prefs-highlights-options-bookmarks =
    .label = Laster-markak
home-prefs-highlights-option-most-recent-download =
    .label = Azken deskarga
home-prefs-highlights-option-saved-to-pocket =
    .label = { -pocket-brand-name }-en gordetako orriak

# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Mezu-zatiak
home-prefs-snippets-description = { -vendor-short-name } eta { -brand-product-name }i buruzko eguneraketak
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] Errenkada bat
           *[other] { $num } errenkada
        }

## Search Section

search-bar-header = Bilaketa-barra
search-bar-hidden =
    .label = Erabili helbide-barra bilaketarako eta nabigaziorako
search-bar-shown =
    .label = Gehitu bilaketa-barra tresna-barran

search-engine-default-header = Bilaketa-motor lehenetsia
search-engine-default-desc-2 = Zure bilaketa-motor lehenetsia da hau, bai helbide- nahiz bilaketa-barran. Edozein unetan alda dezakezu.
search-engine-default-private-desc-2 = Aukeratu leiho pribatuetarako beste bilaketa-motor lehenetsi bat
search-separate-default-engine =
    .label = Erabili bilaketa-motor hau leiho pribatuetan
    .accesskey = r

search-suggestions-header = Bilaketa-iradokizunak
search-suggestions-desc = Aukeratu nola agertzen diren bilaketa-motorren iradokizunak.

search-suggestions-option =
    .label = Hornitu bilaketa-iradokizunak
    .accesskey = b

search-show-suggestions-url-bar-option =
    .label = Erakutsi bilaketa-iradokizunak helbide-barrako emaitzetan
    .accesskey = h

# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Helbide-barrako emaitzetan, erakutsi bilaketa-gomendioak nabigatze-historiaren aurretik

search-show-suggestions-private-windows =
    .label = Erakutsi bilaketa-iradokizunak leiho pribatuetan

suggestions-addressbar-settings-generic = Aldatu hobespenak bilaketa-motorren bestelako iradokizunetarako

search-suggestions-cant-show = Bilaketa-iradokizunak ez dira helbide-barran erakutsiko { -brand-short-name }(e)k historia inoiz ez gogoratzeko konfiguratu duzulako.

search-one-click-header = Klik bakarreko bilaketa-motorrak

search-one-click-desc = Aukeratu gako-hitz bat idazten hastean helbide- eta bilaketa-barren azpian agertzen diren ordezko bilaketa-motorrak.

search-choose-engine-column =
    .label = Bilaketa-motorra
search-choose-keyword-column =
    .label = Gako-hitza

search-restore-default =
    .label = Berrezarri bilaketa-motor lehenetsiak
    .accesskey = h

search-remove-engine =
    .label = Kendu
    .accesskey = K

search-find-more-link = Bilatu bilaketa-motor gehiago

# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Bikoiztutako gako-hitza
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Aukeratu duzun gako-hitza dagoeneko "{ $name }"(e)k erabiltzen du. Aukeratu beste bat.
search-keyword-warning-bookmark = Aukeratu duzun gako-hitza dagoeneko laster-marka batek erabiltzen du. Aukeratu beste bat.

## Containers Section

containers-back-button =
    .aria-label =
        { PLATFORM() ->
            [windows] Itzuli aukeretara
           *[other] Itzuli hobespenetara
        }
containers-header = Edukiontzi-fitxak
containers-add-button =
    .label = Gehitu edukiontzi berria
    .accesskey = G

containers-new-tab-check =
    .label = Hautatu edukiontzi bat fitxa berri bakoitzeko
    .accesskey = H

containers-preferences-button =
    .label = Hobespenak
containers-remove-button =
    .label = Kendu

## Sync Section - Signed out


## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Eraman ezazu weba zurekin
sync-signedout-description = Sinkronizatu laster-markak, historia, fitxak, pasahitzak, gehigarriak eta hobespenak zure gailu guztien artean.

sync-signedout-account-signin2 =
    .label = Hasi saioa { -sync-brand-short-name }(e)n…
    .accesskey = H

# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Deskargatu <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> edo <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a>erako Firefox zure gailu mugikorrarekin sinkronizatzeko.

## Sync Section - Signed in


## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = Aldatu profileko argazkia

sync-sign-out =
    .label = Amaitu saioa…
    .accesskey = A

sync-manage-account = Kudeatu kontua
    .accesskey = o

sync-signedin-unverified = { $email } ez dago egiaztatuta.
sync-signedin-login-failure = Hasi saioa berriro konektatzeko { $email }

sync-resend-verification =
    .label = Birbidali egiaztapena
    .accesskey = B

sync-remove-account =
    .label = Kendu kontua
    .accesskey = K

sync-sign-in =
    .label = Hasi saioa
    .accesskey = H

## Sync section - enabling or disabling sync.

prefs-syncing-on = Sinkronizazioa: aktibo

prefs-syncing-off = Sinkronizazioa: inaktibo

prefs-sync-setup =
    .label = Konfiguratu { -sync-brand-short-name }…
    .accesskey = K

prefs-sync-offer-setup-label = Sinkronizatu laster-markak, historia, fitxak, pasahitzak, gehigarriak eta hobespenak zure gailu guztien artean.

prefs-sync-now =
    .labelnotsyncing = Sinkronizatu orain
    .accesskeynotsyncing = S
    .labelsyncing = Sinkronizatzen…

## The list of things currently syncing.

sync-currently-syncing-heading = Une honetan ondorengo elementuak sinkronizatzen dira:

sync-currently-syncing-bookmarks = Laster-markak
sync-currently-syncing-history = Historia
sync-currently-syncing-tabs = Irekitako fitxak
sync-currently-syncing-logins-passwords = Saio-hasierak eta pasahitzak
sync-currently-syncing-addresses = Helbideak
sync-currently-syncing-creditcards = Kreditu-txartelak
sync-currently-syncing-addons = Gehigarriak
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] Aukerak
       *[other] Hobespenak
    }

sync-change-options =
    .label = Aldatu…
    .accesskey = A

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = Aukeratu zer sinkronizatu
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = Gorde aldaketak
    .buttonaccesskeyaccept = G
    .buttonlabelextra2 = Deskonektatu…
    .buttonaccesskeyextra2 = D

sync-engine-bookmarks =
    .label = Laster-markak
    .accesskey = m

sync-engine-history =
    .label = Historia
    .accesskey = H

sync-engine-tabs =
    .label = Irekitako fitxak
    .tooltiptext = Sinkronizatutako gailu guztietan irekita dagoenaren zerrenda
    .accesskey = t

sync-engine-logins-passwords =
    .label = Saio-hasierak eta pasahitzak
    .tooltiptext = Gorde dituzun saio-hasiera eta pasahitzak
    .accesskey = S

sync-engine-addresses =
    .label = Helbideak
    .tooltiptext = Gorde dituzun helbide postalak (mahaigainerako soilik)
    .accesskey = e

sync-engine-creditcards =
    .label = Kreditu-txartelak
    .tooltiptext = Izenak, zenbakiak eta iraungitze-datak (mahaigainerako soilik)
    .accesskey = K

sync-engine-addons =
    .label = Gehigarriak
    .tooltiptext = Mahaigaineko Firefoxerako hedapenak eta itxurak
    .accesskey = G

sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] Aukerak
           *[other] Hobespenak
        }
    .tooltiptext = Aldatu dituzun 'Orokorra', 'Pribatutasuna' eta 'Segurtasuna' ataletako ezarpenak
    .accesskey = o

## The device name controls.

sync-device-name-header = Gailuaren izena

sync-device-name-change =
    .label = Aldatu gailuaren izena…
    .accesskey = d

sync-device-name-cancel =
    .label = Utzi
    .accesskey = U

sync-device-name-save =
    .label = Gorde
    .accesskey = G

sync-connect-another-device = Konektatu beste gailu bat

## Privacy Section

privacy-header = Nabigatzailearen pribatutasuna

## Privacy Section - Forms

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Saio-hasierak eta pasahitzak
    .searchkeywords = { -lockwise-brand-short-name }

# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Galdetu webguneetako saio-hasierak eta pasahitzak gordetzeko
    .accesskey = G
forms-exceptions =
    .label = Salbuespenak…
    .accesskey = n
forms-generate-passwords =
    .label = Iradoki eta sortu pasahitz sendoak
    .accesskey = d
forms-breach-alerts =
    .label = Erakutsi datu-urratzeak izan dituzten webguneetako pasahitzei buruzko abisuak
    .accesskey = E
forms-breach-alerts-learn-more-link = Argibide gehiago

# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Automatikoki bete erabiltzaile-izen eta pasahitzak
    .accesskey = A
forms-saved-logins =
    .label = Gordetako saio-hasierak…
    .accesskey = s
forms-master-pw-use =
    .label = Erabili pasahitz nagusia
    .accesskey = E
forms-master-pw-change =
    .label = Aldatu pasahitz nagusia…
    .accesskey = A

forms-master-pw-fips-title = Une honetan FIPS moduan zaude. FIPS moduak pasahitz nagusia ezartzea eskatzen du.

forms-master-pw-fips-desc = Pasahitz aldaketak huts egin du

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Pasahitz nagusi bat sortzeko, sartu zure Windows kredentzialak. Honek zure kontuen segurtasuna babesten laguntzen du.

# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = sortu pasahitz nagusia

master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = Historia

# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Firefox", moving the verb into each option.
#     This will result in "Firefox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = { -brand-short-name }(e)k
    .accesskey = k

history-remember-option-all =
    .label = Historia gogoratuko du
history-remember-option-never =
    .label = Ez du historia gogoratuko inoiz
history-remember-option-custom =
    .label = Ezarpen pertsonalizatuak erabiliko ditu historiarako

history-remember-description = { -brand-short-name }(e)k zure nabigazio-, deskarga-, inprimaki- eta bilaketa-historia gogoratuko ditu.
history-dontremember-description = { -brand-short-name }(e)k nabigatze pribatuaren ezarpen berak erabiliko ditu, eta ez du gogoratuko historia webean nabigatzen ari zarenean.

history-private-browsing-permanent =
    .label = Erabili beti nabigatze pribatuko modua
    .accesskey = a

history-remember-browser-option =
    .label = Gogoratu nabigazioaren eta deskargen historia
    .accesskey = n

history-remember-search-option =
    .label = Gogoratu bilaketa- eta inprimaki-historia
    .accesskey = n

history-clear-on-close-option =
    .label = Garbitu historia { -brand-short-name } ixtean
    .accesskey = x

history-clear-on-close-settings =
    .label = Ezarpenak…
    .accesskey = r

history-clear-button =
    .label = Garbitu historia…
    .accesskey = s

## Privacy Section - Site Data

sitedata-header = Cookieak eta guneetako datuak

sitedata-total-size-calculating = Gunearen datuen eta cachearen tamaina kalkulatzen…

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Gordetako zure cookiek, gunearen datuek eta cacheak une honetan { $value } { $unit } hartzen dute diskoan.

sitedata-learn-more = Argibide gehiago

sitedata-delete-on-close =
    .label = Ezabatu cookieak eta guneetako datuak { -brand-short-name } ixtean
    .accesskey = c

sitedata-delete-on-close-private-browsing = Nabigatze pribatu modu iraunkorrean cookieak eta guneetako datuak beti garbituko dira { -brand-short-name } ixtean.

sitedata-allow-cookies-option =
    .label = Onartu cookieak eta guneetako datuak
    .accesskey = O

sitedata-disallow-cookies-option =
    .label = Blokeatu cookieak eta guneetako datuak
    .accesskey = B

# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Mota blokeatuta
    .accesskey = M

sitedata-option-block-cross-site-trackers =
    .label = Guneen arteko jarraipen-elementuak
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = Guneen arteko eta sare sozialetako jarraipen-elementuak
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = Guneen arteko eta sare sozialetako jarraipen-elementuak; bakartu gainerako cookieak
sitedata-option-block-unvisited =
    .label = Bisitatu gabeko guneetako cookieak
sitedata-option-block-all-third-party =
    .label = Hirugarrenen cookie guztiak (webguneak haustea eragin lezake)
sitedata-option-block-all =
    .label = Cookie guztiak (webguneak haustea eragingo du)

sitedata-clear =
    .label = Garbitu datuak…
    .accesskey = G

sitedata-settings =
    .label = Kudeatu datuak…
    .accesskey = K

sitedata-cookies-permissions =
    .label = Kudeatu baimenak
    .accesskey = b

sitedata-cookies-exceptions =
    .label = Kudeatu salbuespenak…
    .accesskey = s

## Privacy Section - Address Bar

addressbar-header = Helbide-barra

addressbar-suggest = Helbide-barra erabiltzean, gomendatu

addressbar-locbar-history-option =
    .label = Nabigatze-historia
    .accesskey = h
addressbar-locbar-bookmarks-option =
    .label = Laster-markak
    .accesskey = L
addressbar-locbar-openpage-option =
    .label = Irekitako fitxak
    .accesskey = I
addressbar-locbar-topsites-option =
    .label = Gune erabilienak
    .accesskey = r

addressbar-suggestions-settings = Aldatu bilaketa-motorren iradokizunetarako hobespenak

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Jarraipenaren babes hobetua

content-blocking-section-top-level-description = Jarraipen-elementuek zure lineako jarraipena egiten dute zure nabigatze-ohitura eta -interesei buruzko informazioa biltzeko. Jarraipen-elementu eta bestelako script maltzurretako asko blokeatzen ditu { -brand-short-name }(e)k.

content-blocking-learn-more = Argibide gehiago

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Oinarrizkoa
    .accesskey = O
enhanced-tracking-protection-setting-strict =
    .label = Zorrotza
    .accesskey = r
enhanced-tracking-protection-setting-custom =
    .label = Pertsonalizatua
    .accesskey = s

##

content-blocking-etp-standard-desc = Babeserako eta errendimendurako orekatua. Orriak ohi bezala kargatuko dira.
content-blocking-etp-strict-desc = Babes sendoagoa baina zenbait gune edo eduki apurtzea eragin lezake.
content-blocking-etp-custom-desc = Aukeratu blokeatu beharreko jarraipen-elementu eta scriptak.

content-blocking-private-windows = Edukiaren jarraipena leiho pribatuetan
content-blocking-cross-site-tracking-cookies = Guneen arteko cookie jarraipen-egileak
content-blocking-cross-site-tracking-cookies-plus-isolate = Guneen arteko jarraipen cookieak; bakartu gainerako cookieak
content-blocking-social-media-trackers = Sare sozialetako jarraipen-elementuak
content-blocking-all-cookies = Cookie guztiak
content-blocking-unvisited-cookies = Bisitatu gabeko guneetako cookieak
content-blocking-all-windows-tracking-content = Edukiaren jarraipena leiho guztietan
content-blocking-all-third-party-cookies = Hirugarrenen cookie guztiak
content-blocking-cryptominers = Kriptomeatzariak
content-blocking-fingerprinters = Hatz-marka bidezko jarraipena egiten duten elementuak

content-blocking-warning-title = Argi!
content-blocking-and-isolating-etp-warning-description = Jarraipen-elementuak blokeatuz eta cookieak bakartuz gero, zenbait gunetako eginbideak kaltetu litezke. Eduki guztiak kargatzeko, berritu jarraipen-elementuak dituen orria.
content-blocking-warning-learn-how = Ikasi nola

content-blocking-reload-description = Zure fitxak berritu beharko dituzu aldaketa hauek eragina izan dezaten.
content-blocking-reload-tabs-button =
    .label = Berritu fitxa guztiak
    .accesskey = B

content-blocking-tracking-content-label =
    .label = Edukiaren jarraipena
    .accesskey = E
content-blocking-tracking-protection-option-all-windows =
    .label = Leiho guztietan
    .accesskey = z
content-blocking-option-private =
    .label = Leiho pribatuetan soilik
    .accesskey = r
content-blocking-tracking-protection-change-block-list = Aldatu blokeo-zerrenda

content-blocking-cookies-label =
    .label = Cookieak
    .accesskey = C

content-blocking-expand-section =
    .tooltiptext = Informazio gehiago

# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Kriptomeatzariak
    .accesskey = K

# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Hatz-marka bidezko jarraipena
    .accesskey = H

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Kudeatu salbuespenak…
    .accesskey = s

## Privacy Section - Permissions

permissions-header = Baimenak

permissions-location = Kokapena
permissions-location-settings =
    .label = Ezarpenak…
    .accesskey = n

permissions-xr = Errealitate birtuala
permissions-xr-settings =
    .label = Ezarpenak…
    .accesskey = E

permissions-camera = Kamera
permissions-camera-settings =
    .label = Ezarpenak…
    .accesskey = k

permissions-microphone = Mikrofonoa
permissions-microphone-settings =
    .label = Ezarpenak…
    .accesskey = E

permissions-notification = Jakinarazpenak
permissions-notification-settings =
    .label = Ezarpenak…
    .accesskey = n
permissions-notification-link = Argibide gehiago

permissions-notification-pause =
    .label = Pausatu jakinarazpenak { -brand-short-name } berrabiarazi arte
    .accesskey = n

permissions-autoplay = Erreprodukzio automatikoa

permissions-autoplay-settings =
    .label = Ezarpenak…
    .accesskey = E

permissions-block-popups =
    .label = Blokeatu pop-up leihoak
    .accesskey = B

permissions-block-popups-exceptions =
    .label = Salbuespenak…
    .accesskey = e

permissions-addon-install-warning =
    .label = Abisatu webgune bat gehigarriak instalatzen saiatzen bada
    .accesskey = A

permissions-addon-exceptions =
    .label = Salbuespenak…
    .accesskey = S

permissions-a11y-privacy-checkbox =
    .label = Eragotzi erabilgarritasun-zerbitzuei zure nabigatzailerako sarbidea
    .accesskey = a

permissions-a11y-privacy-link = Argibide gehiago

## Privacy Section - Data Collection

collection-header = { -brand-short-name } datuen bilketa eta erabilera

collection-description = Aukerak ematen ahalegintzen gara { -brand-short-name } denontzat hobetzeko behar ditugun datuak soilik biltzeko. Informazio pertsonala jaso aurretik zure baimena eskatzen dugu beti.
collection-privacy-notice = Pribatutasun-oharra

collection-health-report-telemetry-disabled = Jada ez duzu baimentzen { -vendor-short-name }(e)k datu tekniko eta interakziozkoak kapturatzea. Iraganeko datu guztiak 30 egunen buruan ezabatuko dira.
collection-health-report-telemetry-disabled-link = Argibide gehiago

collection-health-report =
    .label = Baimendu { -brand-short-name }(r)i datu tekniko eta interakziozkoak { -vendor-short-name }ra bidaltzea
    .accesskey = r
collection-health-report-link = Argibide gehiago

collection-studies =
    .label = Baimendu { -brand-short-name }(e)k esperimentuak instalatu eta exekutatzea
collection-studies-link = Ikusi { -brand-short-name } esperimentuak

addon-recommendations =
    .label = Baimendu { -brand-short-name }(r)i hedapenen gomendio pertsonalizatuak egitea
addon-recommendations-link = Argibide gehiago

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Datuen berri ematea desgaituta dago eraikitze-konfigurazio honetarako

collection-backlogged-crash-reports =
    .label = Baimendu { -brand-short-name }(r)i atzeratutako hutsegite-txostenak zuregatik bidaltzea
    .accesskey = h
collection-backlogged-crash-reports-link = Argibide gehiago

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Segurtasuna

security-browsing-protection = Eduki iruzurgilearen eta software arriskutsuaren babesa

security-enable-safe-browsing =
    .label = Blokeatu eduki arriskutsu eta iruzurtia
    .accesskey = B
security-enable-safe-browsing-link = Argibide gehiago

security-block-downloads =
    .label = Blokeatu deskarga arriskutsuak
    .accesskey = s

security-block-uncommon-software =
    .label = Abisatu nahi ez den eta ezohikoa den softwareari buruz
    .accesskey = o

## Privacy Section - Certificates

certs-header = Ziurtagiriak

certs-personal-label = Webgune batek nire ziurtagiri pertsonala eskatzen duenean:

certs-select-auto-option =
    .label = Hautatu bat automatikoki
    .accesskey = t

certs-select-ask-option =
    .label = Galdetu beti
    .accesskey = G

certs-enable-ocsp =
    .label = Galdetu OCSP erantzule-zerbitzariei ziurtagiriak baliozkoak diren egiaztatzeko
    .accesskey = G

certs-view =
    .label = Ikusi ziurtagiriak…
    .accesskey = k

certs-devices =
    .label = Segurtasun-gailuak…
    .accesskey = S

space-alert-learn-more-button =
    .label = Argibide gehiago
    .accesskey = A

space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] Ireki aukerak
           *[other] Ireki hobespenak
        }
    .accesskey =
        { PLATFORM() ->
            [windows] I
           *[other] I
        }

space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] { -brand-short-name } leku erabilgarririk gabe gelditzen ari da diskoan. Webgunearen edukiak agian ez dira ondo bistaratuko. Biltegiratutako gunearen datuak Aukerak > Pribatutasuna eta segurtasuna > Cookieak eta guneetako datuak atalean garbi ditzakezu.
       *[other] { -brand-short-name } leku erabilgarririk gabe gelditzen ari da diskoan. Webgunearen edukiak agian ez dira ondo bistaratuko. Biltegiratutako gunearen datuak Hobespenak > Pribatutasuna eta segurtasuna > Cookieak eta guneetako datuak atalean garbi ditzakezu.
    }

space-alert-under-5gb-ok-button =
    .label = Ados, ulertu dut
    .accesskey = A

space-alert-under-5gb-message = { -brand-short-name } leku erabilgarririk gabe gelditzen ari da diskoan. Webgunearen edukiak agian ez dira ondo bistaratuko. Bisitatu "Argibide gehiago" diskoaren erabilpena optimizatu eta nabigatze-esperientzia hobetzeko.

## Privacy Section - HTTPS-Only

## The following strings are used in the Download section of settings

desktop-folder-name = Mahaigaina
downloads-folder-name = Deskargak
choose-download-folder-title = Aukeratu deskarga-karpeta:

# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Gorde fitxategiak { $service-name } zerbitzura
