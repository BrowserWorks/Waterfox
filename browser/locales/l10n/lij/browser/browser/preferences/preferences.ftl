# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Manda a-o scito un signâ  “No traciame” coscì da faghe savei che ti no veu ese traciou
do-not-track-learn-more = Atre informaçioin
do-not-track-option-default-content-blocking-known =
    .label = Solo quande { -brand-short-name } o l'é inpòstou pe blocâ i elementi che tracian conosciui
do-not-track-option-always =
    .label = De longo

pref-page-title =
    { PLATFORM() ->
        [windows] Inpostaçioin
       *[other] Preferense
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
            [windows] Treuva in Inpostaçioin
           *[other] Treuva in Preferense
        }

pane-general-title = Generale
category-general =
    .tooltiptext = { pane-general-title }

pane-home-title = Pagina prinçipâ
category-home =
    .tooltiptext = { pane-home-title }

pane-search-title = Çerca
category-search =
    .tooltiptext = { pane-search-title }

pane-privacy-title = Privacy e seguessa
category-privacy =
    .tooltiptext = { pane-privacy-title }

pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }

help-button-label = Sopòrto de { -brand-short-name }
addons-button-label = Estenscioin e Temi

focus-search =
    .key = f

close-button =
    .aria-label = Særa

## Browser Restart Dialog

feature-enable-requires-restart = Arvi torna o { -brand-short-name } pe ativâ sta fonçion.
feature-disable-requires-restart = Arvi torna o { -brand-short-name } pe dizativâ sta fonçion.
should-restart-title = Arvi torna o { -brand-short-name }
should-restart-ok = Arvi torna { -brand-short-name } òua
cancel-no-restart-button = Anulla
restart-later = Arvi torna Dòppo

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
extension-controlled-homepage-override = 'Na estenscion, <img data-l10n-name="icon"/> { $name }, a contròlla a teu pagina prinçipâ.

# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = 'Na estenscion, <img data-l10n-name="icon"/> { $name }, a contròlla a teu pagina neuvo feuggio.

# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = 'Na estencion, <img data-l10n-name="icon"/> { $name }, a contròlla sta inpostaçion.

# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = 'Na estenscion, <img data-l10n-name="icon"/> { $name }, a l'à inpostou o teu motô de riçerca.

# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = 'Na estenscion, <img data-l10n-name="icon"/> { $name }, a domanda 'n feuggi contegnitô.

# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = 'Na estenscion <img data-l10n-name="icon"/> { $name }, a contròlla sta inpostaçion.

# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = 'Na estenscion, <img data-l10n-name="icon"/> { $name } a contròlla comme { -brand-short-name } o se conette a l'Internet.

# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Pe abilitâ l'estenscion vanni into conponente azonto <img data-l10n-name="addons-icon"/> into menû <img data-l10n-name="menu-icon"/>.

## Preferences UI Search Results

search-results-header = Exiti da riçerca

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Me spiaxe! No emmo trovou ninte inte Inpostaçioin pe “<span data-l10n-name="query"></span>”.
       *[other] Me spiaxe! No emmo trovou ninte inte Preferense pe “<span data-l10n-name="query"></span>”.
    }

search-results-help-link = Serve agiutto? Vixita <a data-l10n-name="url">Sopòrto de { -brand-short-name }</a>

## General Section

startup-header = Iniçio

# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = Consenti l’ezegoçion de { -brand-short-name } e Firefox a-o mæximo tenpo
use-firefox-sync = Conseggio: coscì ti devi adeuviâ di profî diversci. Ti peu adeuviâ { -sync-brand-short-name } pe-a scincronizaçion di dæti.
get-started-not-logged-in = Intra in{ -sync-brand-short-name }…
get-started-configured = Arvi e inpostaçioin de { -sync-brand-short-name }

always-check-default =
    .label = Contròlla de longo se { -brand-short-name } o l'é o navegatô predefinio
    .accesskey = t

is-default = { -brand-short-name } o l'é o navegatô predefinio
is-not-default = { -brand-short-name } o no l'é o navegatô predefinio

set-as-my-default-browser =
    .label = Adeuvia comme predefinio…
    .accesskey = A

startup-restore-previous-session =
    .label = Repiggia vegia sescion
    .accesskey = s

startup-restore-warn-on-quit =
    .label = Avertime quande særo o navegatô

disable-extension =
    .label = Dizabilita estençion

tabs-group-header = Feuggi

ctrl-tab-recently-used-order =
    .label = Ctrl+Tab mostra l'anteprimma di feuggi averti
    .accesskey = T

open-new-link-as-tabs =
    .label = Arvi colegamento into feuggio in cangio do barcon
    .accesskey = V

warn-on-close-multiple-tabs =
    .label = Avertime quande særo ciù feuggi insemme
    .accesskey = m

warn-on-open-many-tabs =
    .label = Avertime quando l'arvetua de ciù feuggi a peu fâ anâ ciù lento { -brand-short-name }
    .accesskey = d

switch-links-to-new-tabs =
    .label = Quando arvo un colegamento inte un neuvo feuggio ti devi pasâ subito a st'urtimo
    .accesskey = s

show-tabs-in-taskbar =
    .label = Fanni vedde l'anteprimma inta bara di task do Windows
    .accesskey = k

browser-containers-enabled =
    .label = Abilita Contegnitô de Feuggi
    .accesskey = n

browser-containers-learn-more = Ciù informaçioin

browser-containers-settings =
    .label = Inpostaçioin…
    .accesskey = i

containers-disable-alert-title = Særa tutti i contegnitoî de feuggi?
containers-disable-alert-desc =
    { $tabCount ->
        [one] Se ti ti dizabiliti i Contegnitoî de Feuggi òua, { $tabCount } contegnitô de feuggi saiâ seròu. T'ê seguo de dizabilitâ i Contegnitoî de Feuggi?
       *[other] Se ti ti dizabiliti i Contegnitoî de Feuggi òua, { $tabCount } contegnitoî de feuggi saian seræ. T'ê seguo de dizabilitâ i Contegnitoî de Feuggi?
    }

containers-disable-alert-ok-button =
    { $tabCount ->
        [one] Særa { $tabCount } Contegnitô de feuggi
       *[other] Særa { $tabCount } Contegnitoî de feuggi
    }
containers-disable-alert-cancel-button = Lascia abilitou

containers-remove-alert-title = Scancelâ sto contegnitô?

# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Se ti ti scancelli sto Contegnitô òua, { $count } contegnitô de feuggi saiâ seròu. T'ê seguo de scancelâ sto Contegnitô?
       *[other] Se ti ti scancelli sto Contegnitô òua, { $count } contegnitoî de feuggi saian seræ. T'ê seguo de scancelâ sto Contegnitô?
    }

containers-remove-ok-button = Scancella sto Contegnitô
containers-remove-cancel-button = No scancelâ sto Contegnitô


## General Section - Language & Appearance

language-and-appearance-header = Lengoa e Aparensa

fonts-and-colors-header = Coî e testo

default-font = Caratere predefinio
    .accesskey = C
default-font-size = Dimenscion
    .accesskey = D

advanced-fonts =
    .label = Avansæ…
    .accesskey = n

colors-settings =
    .label = Coi…
    .accesskey = C

language-header = Lengoa

choose-language-description = Çerni a lengoa preferia pe-e pagine

choose-button =
    .label = Çerni…
    .accesskey = i

choose-browser-language-description = Çerni a lengoa deuvia pe vedde i menû, mesaggi e notifiche de { -brand-short-name }.
manage-browser-languages-button =
    .label = Inpòsta Alternative
    .accesskey = I
confirm-browser-language-change-description = Arvi torna { -brand-short-name } pe conpletâ i cangiamenti
confirm-browser-language-change-button = Conpleta e Arvi torna

translate-web-pages =
    .label = Traduxi contegnui web
    .accesskey = T

# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Traduçioin de <img data-l10n-name="logo"/>

translate-exceptions =
    .label = Eceçioin…
    .accesskey = z

check-user-spelling =
    .label = Contròlla l'òrtografia quande scrivo
    .accesskey = l

## General Section - Files and Applications

files-and-applications-title = Schedai e aplicaçioin

download-header = Descaregamenti

download-save-to =
    .label = Sarva schedai in
    .accesskey = v

download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Çerni…
           *[other] Çerca…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] i
           *[other] Ç
        }

download-always-ask-where =
    .label = Domanda de longo donde sarvâ i schedai
    .accesskey = D

applications-header = Aplicaçioin

applications-description = Çerni comme { -brand-short-name } o gestisce i teu descaregamenti da-a Ræ ò e aplicaçioin che ti deuvi quande ti naveghi.

applications-filter =
    .placeholder = Çerca tipi de schedai ò aplicaçioin

applications-type-column =
    .label = Tipo de contegnuo
    .accesskey = T

applications-action-column =
    .label = Açion
    .accesskey = A

# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = schedaio { $extension }
applications-action-save =
    .label = Sarva schedaio

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = Adeuvia { $app-name }

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = Adeuvia { $app-name } (predefinio)

applications-use-other =
    .label = Adeuvia atro…
applications-select-helper = Seleçionn-a 'na aplicaçion de agiutto

applications-manage-app =
    .label = Detalli da aplicaçion…
applications-always-ask =
    .label = Domanda de longo
applications-type-pdf = PDF (Portable Document Format)

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
    .label = Adeuvia { $plugin-name } (in { -brand-short-name })

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

drm-content-header = Contegnuo da Gestion di Diritti Digitali (DRM)

play-drm-content =
    .label = Riproduxi o contegnuo DRM-controlled
    .accesskey = R

play-drm-content-learn-more = Atre informaçioin

update-application-title = Agiornamenti de { -brand-short-name }

update-application-description = Mantegni { -brand-short-name } agiornou pe de megio prestaçioin, stabilitæ e seguessa.

update-application-version = Verscion { $version } <a data-l10n-name="learn-more">Novitæ</a>

update-history =
    .label = Fanni vedde a stöia di agiornamenti…
    .accesskey = g

update-application-allow-description = Permetti a { -brand-short-name } de

update-application-auto =
    .label = Installa i agiornamenti in aotomatico (consegiou)
    .accesskey = A

update-application-check-choose =
    .label = Contròlla se gh'é agiornamenti, ma famme decidde se instalali
    .accesskey = C

update-application-manual =
    .label = No controlâ mai se gh'é agiornamenti (no consegiou)
    .accesskey = N

update-application-use-service =
    .label = Deuvia 'n serviçio ascozo pe instalâ i agiornamenti
    .accesskey = v

## General Section - Performance

performance-title = Prestaçioin

performance-use-recommended-settings-checkbox =
    .label = Deuvia e inpostaçioin racomandæ pe-e megio prestaçioin
    .accesskey = U

performance-use-recommended-settings-desc = Ste inpostaçioin en fæte pe l'hardware e scistema òperativo do teu computer.

performance-settings-learn-more = Saccine de ciù

performance-allow-hw-accel =
    .label = Adeuvia l'aceleraçion hardware se a gh'é
    .accesskey = h

performance-limit-content-process-option = Limite de contegnuo do processo
    .accesskey = l

performance-limit-content-process-enabled-desc = Deuviâ ciù contegnui do processo o peu megiorâ e prestaçioin quande ti deuvi tanti feuggi insemme, ma te faiâ stragiâ ciù memöia.
performance-limit-content-process-blocked-desc = Cangiâ o numero de contegnui de processo o l'é poscibile solo in { -brand-short-name } moltiprocesso. <a data-l10n-name="learn-more">Amia comme controlâ se o moltiprocesso o l'é ativo</a>

# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (predefinio)

## General Section - Browsing

browsing-title = Riçerca

browsing-use-autoscroll =
    .label = Adeuvia rebelamento aotomatico
    .accesskey = d

browsing-use-smooth-scrolling =
    .label = Adeuvia rebelamento regolâ
    .accesskey = m

browsing-use-onscreen-keyboard =
    .label = Mostra a tastea da tocâ quande a serve
    .accesskey = t

browsing-use-cursor-navigation =
    .label = Adeuvia de longo i pomelli de direçion pe navegâ in sce pagine
    .accesskey = c

browsing-search-on-start-typing =
    .label = Çerca tanto che son derê a scrive
    .accesskey = s

browsing-picture-in-picture-learn-more = Atre informaçioin

browsing-cfr-recommendations =
    .label = Consegime estenscioin quande navego
    .accesskey = C
browsing-cfr-features =
    .label = Consegime fonçioin quande navego
    .accesskey = f

browsing-cfr-recommendations-learn-more = Atre informaçioin

## General Section - Proxy

network-settings-title = Inpostaçioin da ræ

network-proxy-connection-description = Inpòsta o mòddo de conetise a l'internet de { -brand-short-name }.

network-proxy-connection-learn-more = Pe saveine de ciù

network-proxy-connection-settings =
    .label = Inpostaçioin…
    .accesskey = I

## Home Section

home-new-windows-tabs-header = Neuvi Barcoin e feuggi

home-new-windows-tabs-description2 = Çerni cöse ti veu vedde quande ti arvi a pagina prinçipâ, neuvi barcoin e neuvi feuggi.

## Home Section - Home Page Customization

home-homepage-mode-label = Pagina prinçipâ e neuvi barcoin

home-newtabs-mode-label = Neuvi feuggi

home-restore-defaults =
    .label = Repiggia predefinii
    .accesskey = R

# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Pagina prinçipâ (Predefinia)

home-mode-choice-custom =
    .label = Indirissi cliénti...

home-mode-choice-blank =
    .label = Pagina gianca

home-homepage-custom-url =
    .placeholder = Incòlla indirisso...

# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Adeuvia a pagina corente
           *[other] Adeuvia e pagine corenti
        }
    .accesskey = c

choose-bookmark =
    .label = Adeuvia o segnalibbro…
    .accesskey = s

## Home Section - Firefox Home Content Customization

home-prefs-content-header = Pagina iniçiâ de Firefox
home-prefs-content-description = Çerni i contegnui che ti veu vedde inta pagina iniçiâ de Firefox.

home-prefs-search-header =
    .label = Çerca into Web
home-prefs-topsites-header =
    .label = I megio sciti
home-prefs-topsites-description = I sciti che ti vixiti de ciù

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

# Variables:
#  $provider (String): Name of the corresponding content provider, e.g "Pocket".
home-prefs-recommended-by-header =
    .label = Consegiou da { $provider }
##

home-prefs-recommended-by-learn-more = Comme o fonçionn-a
home-prefs-recommended-by-option-sponsored-stories =
    .label = Stöie sponsorizæ

home-prefs-highlights-header =
    .label = In evidensa
home-prefs-highlights-description = 'Na seleçion di sciti che t'ê sarvou ò vixitou
home-prefs-highlights-option-visited-pages =
    .label = Pagine vixitæ
home-prefs-highlights-options-bookmarks =
    .label = Segnalibbri
home-prefs-highlights-option-most-recent-download =
    .label = Urtimi descaregamenti
home-prefs-highlights-option-saved-to-pocket =
    .label = Pagine sarvæ in { -pocket-brand-name }

# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Snippet
home-prefs-snippets-description = Agiornamenti da { -vendor-short-name } e { -brand-product-name }
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } riga
           *[other] { $num } righe
        }

## Search Section

search-bar-header = Bara de Riçerca
search-bar-hidden =
    .label = Deuvia a bara di indirissi pe çercâ e navegâ
search-bar-shown =
    .label = Azonzi bara de riçerca inta bara di atressi

search-engine-default-header = Motô de riçerca predefinio

search-suggestions-option =
    .label = Fanni vedde conseggi de riçerca
    .accesskey = V

search-show-suggestions-url-bar-option =
    .label = Fanni vedde conseggi de riçerca tra i rizoltæ da bara di indirissi
    .accesskey = l

# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Fanni vedde i conseggi in çimma a-a stöia da navegaçion inta bara di indirissi

search-suggestions-cant-show = I conseggi de riçerca no saian mostræ tra i exiti da-a bara di indirissi perché { -brand-short-name } o l'é inpostou pe no sarvâ a stöia.

search-one-click-header = Motoî de riçerca in un sciacco

search-one-click-desc = Çerni i motoî de riçerca alternativi che saian mostræ sotta a bara di indirissi e bara de riçerca quande ti iniçi a scrive.

search-choose-engine-column =
    .label = Motô de riçerca
search-choose-keyword-column =
    .label = Paròlla ciave

search-restore-default =
    .label = Ripiggia i motoî de riçerca predefinii
    .accesskey = R

search-remove-engine =
    .label = Scancella
    .accesskey = E

search-find-more-link = Treuva ciù motoî de riçerca

# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Sta paròlla ciave a gh'é za
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Ti æ çernuo 'na paròlla ciave ch'a l'é uzâ da "{ $name }". Pe piaxei che ti ne çerni 'n'atra.
search-keyword-warning-bookmark = Ti æ çernuo 'na paròlla ciave che a l'é uzâ da un segnalibbro. Pe piaxei che ti ne çerni 'n'atra.

## Containers Section

containers-header = Contegnitô di feuggi
containers-add-button =
    .label = Azonzi neuvo contegnitô
    .accesskey = A

containers-preferences-button =
    .label = Preferense
containers-remove-button =
    .label = Scancella

## Sync Section - Signed out


## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = A teu Ræ, de longo con ti
sync-signedout-description = Scincronizza segnalibbri, stöia, feuggi, paròlle segrete, conponenti azonti e inpostaçioin con tutti i teu dispoxitivi.

# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Descarega Firefox pe <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> ò <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> pe scincronizate con i dispoxitivi mòbili.

## Sync Section - Signed in


## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = Cangia l’inmagine do profî

sync-manage-account = Gestisci conto
    .accesskey = o

sync-signedin-unverified = { $email } no l'é verificou.
sync-signedin-login-failure = Acedi pe ativâ torna a conescion { $email }

sync-resend-verification =
    .label = Manda torna verifica
    .accesskey = d

sync-remove-account =
    .label = Scancella conto
    .accesskey = p

sync-sign-in =
    .label = Intra
    .accesskey = t

## Sync section - enabling or disabling sync.


## The list of things currently syncing.


## The "Choose what to sync" dialog.

sync-engine-bookmarks =
    .label = Segnalibbri
    .accesskey = S

sync-engine-history =
    .label = Stöia
    .accesskey = S

sync-engine-tabs =
    .label = Arvi Feuggi
    .tooltiptext = ’Na lista de quello ch'o l'é averto in sci dispoxitivi scincronizæ
    .accesskey = F

sync-engine-addresses =
    .label = Indirissi
    .tooltiptext = Indirissi de pòsta che t'æ sarvou (solo desktop)
    .accesskey = e

sync-engine-creditcards =
    .label = Carte de credito
    .tooltiptext = Nommi, numeri e dæte de scadensa (solo desktop)
    .accesskey = C

sync-engine-addons =
    .label = Conponenti azonti
    .tooltiptext = Estenscioin e temi pe Firefox desktop
    .accesskey = a

sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] Opçioin
           *[other] Preferense
        }
    .tooltiptext = Inpostaçioin genarali, de privaçy e seguessa che t'æ cangiou
    .accesskey = P

## The device name controls.

sync-device-name-header = Nomme dispoxitivo

sync-device-name-change =
    .label = Cangia nomme dispoxitivo…
    .accesskey = n

sync-device-name-cancel =
    .label = Anulla
    .accesskey = l

sync-device-name-save =
    .label = Sarva
    .accesskey = v

sync-connect-another-device = Conetti atro dispoxitivo

## Privacy Section

privacy-header = Privacy do navegatô

## Privacy Section - Forms


## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Login e Poule segrete
    .searchkeywords = { -lockwise-brand-short-name }

forms-ask-to-save-logins =
    .label = Domanda se sarvâ acessi e poule segrete pe-i sciti
    .accesskey = r
forms-exceptions =
    .label = Eceçioin…
    .accesskey = ç

forms-saved-logins =
    .label = Acessi sarvæ…
    .accesskey = s
forms-master-pw-use =
    .label = Adeuvia 'na paròlla segreta prinçipâ
    .accesskey = p
forms-master-pw-change =
    .label = Cangia a paròlla segreta prinçipâ…
    .accesskey = C

forms-master-pw-fips-title = Òua t'ê into mòddo FIPS. A-o FIPS serve 'na paròlla segreta prinçipâ che a no segge veua.

forms-master-pw-fips-desc = Cangio de paròlla segreta no riescio

## OS Authentication dialog


## Privacy Section - History

history-header = Stöia

# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Firefox", moving the verb into each option.
#     This will result in "Firefox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = { -brand-short-name } o se
    .accesskey = o

history-remember-option-all =
    .label = aregordiâ a stöia
history-remember-option-never =
    .label = no se aregordiâ mai a stöia
history-remember-option-custom =
    .label = Deuvia inpostaçioin personalizæ pe-a stöia

history-remember-description = { -brand-short-name } o s'aregòrda de teu navegaçioin, descaregamenti e stöia de riçerche.
history-dontremember-description = { -brand-short-name } o deuvia e mæxime preferense da-a navegaçion privâ, e o no se aregòrda da stöia de teu navegaçioin.

history-private-browsing-permanent =
    .label = Deuvia de longo o mòddo de navegaçion privòu
    .accesskey = p

history-remember-browser-option =
    .label = Aregòrda a stöia de navegaçion e descaregamenti
    .accesskey = n

history-remember-search-option =
    .label = Aregòrda e riçerche e a stöia di mòdoli
    .accesskey = l

history-clear-on-close-option =
    .label = Scancella a stöia quande særa o { -brand-short-name }
    .accesskey = r

history-clear-on-close-settings =
    .label = Inpostaçioin…
    .accesskey = t

history-clear-button =
    .label = Scancella Stöia…
    .accesskey = s

## Privacy Section - Site Data

sitedata-header = Cookie e Dæti di Sciti

sitedata-total-size-calculating = Conto a dimenscion di dæti e da cache…

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = I cookie, dæti do scito e cache deuvian { $value } { $unit } de spaçion in sciô disco.

sitedata-learn-more = Pe saveine de ciù

sitedata-allow-cookies-option =
    .label = Acetta cookie e dæti do scito
    .accesskey = A

sitedata-disallow-cookies-option =
    .label = Blòcca cookie e dæti do scito
    .accesskey = B

# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Tipo de contegnuo blocòu
    .accesskey = T

sitedata-option-block-unvisited =
    .label = Cookie de sciti no vixitæ
sitedata-option-block-all-third-party =
    .label = Tutti i cookie de terse parte (quarche scito o porieiva no fonçionâ ben)
sitedata-option-block-all =
    .label = Tutti i cookie (quarche scito no fonçioniâ ben)

sitedata-clear =
    .label = Scancella dæti…
    .accesskey = l

sitedata-settings =
    .label = Gestisci dæti…
    .accesskey = G

sitedata-cookies-permissions =
    .label = Gestisci permissi...
    .accesskey = p

## Privacy Section - Address Bar

addressbar-header = Bara di indirissi

addressbar-suggest = Quande ti deuvi a bara di indirissi, conseggia

addressbar-locbar-history-option =
    .label = Stöia da navegaçion
    .accesskey = S
addressbar-locbar-bookmarks-option =
    .label = Segnalibbri
    .accesskey = b
addressbar-locbar-openpage-option =
    .label = feuggi averti
    .accesskey = g

addressbar-suggestions-settings = Cangia e inpostaçioin di conseggi di motoî de riçerca

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Proteçion anti traciamento avansâ

content-blocking-learn-more = Atre informaçioin

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Standard
    .accesskey = d
enhanced-tracking-protection-setting-strict =
    .label = Restritivo
    .accesskey = R
enhanced-tracking-protection-setting-custom =
    .label = Personalizzou
    .accesskey = P

##

content-blocking-all-cookies = Tutti i cookie
content-blocking-all-third-party-cookies = Tutti i cookie de terse parte

content-blocking-warning-title = Stanni atento!

content-blocking-reload-tabs-button =
    .label = Recarega tutti i feuggi
    .accesskey = R

content-blocking-tracking-protection-option-all-windows =
    .label = In tutti i barcoin
    .accesskey = u
content-blocking-option-private =
    .label = Solo inti barcoin privæ
    .accesskey = p
content-blocking-tracking-protection-change-block-list = Cangia a lista de blòcco

content-blocking-cookies-label =
    .label = Cookie
    .accesskey = C

content-blocking-expand-section =
    .tooltiptext = Ciù informaçioin

# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Minatoî de criptomonæe
    .accesskey = y

# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Rilevatoî de inpronte digitali
    .accesskey = F

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Gestisci eceçioin
    .accesskey = x

## Privacy Section - Permissions

permissions-header = Permissi

permissions-location = Indirisso
permissions-location-settings =
    .label = Inpostaçioin…
    .accesskey = t

permissions-camera = Fòtocamera
permissions-camera-settings =
    .label = Inpostaçioin…
    .accesskey = t

permissions-microphone = Micròfono
permissions-microphone-settings =
    .label = Inpostaçioin…
    .accesskey = t

permissions-notification = Notifiche
permissions-notification-settings =
    .label = Inpostaçioin…
    .accesskey = t
permissions-notification-link = Atre informaçioin

permissions-notification-pause =
    .label = Ferma notificaçioin scinché { -brand-short-name } o no s'arve torna
    .accesskey = n

permissions-autoplay-settings =
    .label = Inpostaçioin…
    .accesskey = t

permissions-block-popups =
    .label = Blòcca i barcoin de pop-up
    .accesskey = B

permissions-block-popups-exceptions =
    .label = Eceçioin…
    .accesskey = E

permissions-addon-install-warning =
    .label = Avizime quande 'n scito o preuva a instalâ conponenti azonti
    .accesskey = A

permissions-addon-exceptions =
    .label = Eceçioin…
    .accesskey = E

permissions-a11y-privacy-checkbox =
    .label = O blòcca i serviççi de acesibiliæ
    .accesskey = a

permissions-a11y-privacy-link = Atre informaçioin

## Privacy Section - Data Collection

collection-header = Acugeita dæti e uzo de { -brand-short-name }

collection-description = Niatri çerchemmo de lasciâ a ti a decixon se sarvâ e quello ch'o o ne serve solo pe megiorâ { -brand-short-name } pe tutti. Niatri te domandiemo de longo o permisso primma de reçeive informaçioin personâ.
collection-privacy-notice = Informativa in sciâ privacy

collection-health-report =
    .label = Permetti a { -brand-short-name } de mandâ dæti tecnichi e de interaçion a { -vendor-short-name }
    .accesskey = r
collection-health-report-link = Atre informaçioin

collection-studies =
    .label = Pemetti a { -brand-short-name } de instalâ e xoâ studdi
collection-studies-link = Amia i studde de { -brand-short-name }

addon-recommendations-link = Atre informaçioin

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = O report di dæti o l'é dizabilitou pe sta configuraçion

collection-backlogged-crash-reports =
    .label = Permetti a { -brand-short-name } de mandâ report di cianti in background pe conto teu
    .accesskey = c
collection-backlogged-crash-reports-link = Atre informaçioin

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Seguessa

security-browsing-protection = Proteçion contra o conegnuo inganevole e pericoloso

security-enable-safe-browsing =
    .label = Blòcca contegnui grammi pericolozi
    .accesskey = B
security-enable-safe-browsing-link = Atre informaçioin

security-block-downloads =
    .label = Blocca descaregamenti pericolozi
    .accesskey = D

security-block-uncommon-software =
    .label = Avertime in sci programmi indexideræ e no comun
    .accesskey = C

## Privacy Section - Certificates

certs-header = Certificati

certs-personal-label = Quande 'n server o domanda o teu certificato personale

certs-select-auto-option =
    .label = Seleçionn-a un in aotomatico
    .accesskey = S

certs-select-ask-option =
    .label = Domandimòu tutte e vòtte
    .accesskey = D

certs-enable-ocsp =
    .label = Domanda a-i risponditoî OCSP pe confermâ a validitæ di certificati òua
    .accesskey = o

certs-view =
    .label = Fanni vedde certificati…
    .accesskey = C

certs-devices =
    .label = Aparati de Seguessa…
    .accesskey = S

space-alert-learn-more-button =
    .label = Atre informaçioin
    .accesskey = A

space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] Arvi inpostaçioin
           *[other] Arvi preferense
        }
    .accesskey =
        { PLATFORM() ->
            [windows] A
           *[other] A
        }

space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] { -brand-short-name } o sta pe finî o spaçio in sciô disco. I contegnui do scito no peuan mostrase ben. Ti peu scancelâ i dæti sarvæ di sciti inte Preferense > Privacy e Seguessa > Cookie e Dæti di sciti.
       *[other] { -brand-short-name } o sta pe finî o spaçio in sciô disco. I contegnui do scito no peuan mostrase ben. Ti peu scancelâ i dæti sarvæ di sciti inte Preferense > Privacy e Seguessa > Cookie e Dæti di sciti.
    }

space-alert-under-5gb-ok-button =
    .label = Va ben, ò capio
    .accesskey = b

space-alert-under-5gb-message = { -brand-short-name } o sta pe finî o spaçio in sciô disco. I contegnui do scito no se peuan mostrase ben. Vixita “Atre informaçioin” pe otimizâ l'uzo do disco pe avei 'na megio esperiensa de navegaçion.

## Privacy Section - HTTPS-Only

## The following strings are used in the Download section of settings

desktop-folder-name = Desktop
downloads-folder-name = Descaregamenti
choose-download-folder-title = Çerni a cartella de descaregamento:

# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Sarva i schedai in { $service-name }
