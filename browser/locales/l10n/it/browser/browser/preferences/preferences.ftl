# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Invia ai siti web un segnale “Do Not Track” per chiedere di non effettuare alcun tracciamento
do-not-track-learn-more = Ulteriori informazioni
do-not-track-option-default-content-blocking-known =
    .label = Solo quando { -brand-short-name } è impostato per bloccare gli elementi traccianti conosciuti
do-not-track-option-always =
    .label = Sempre

settings-page-title = Impostazioni

search-input-box2 =
    .style = width: 16em
    .placeholder = Cerca nelle impostazioni

managed-notice = Il browser è gestito dalla propria azienda.

category-list =
    .aria-label = Categorie

pane-general-title = Generale
category-general =
    .tooltiptext = { pane-general-title }

pane-home-title = Pagina iniziale
category-home =
    .tooltiptext = { pane-home-title }

pane-search-title = Ricerca
category-search =
    .tooltiptext = { pane-search-title }

pane-privacy-title = Privacy e sicurezza
category-privacy =
    .tooltiptext = { pane-privacy-title }

pane-sync-title3 = Sincronizzazione
category-sync3 =
    .tooltiptext = { pane-sync-title3 }

pane-experimental-title = Esperimenti di { -brand-short-name }
category-experimental =
    .tooltiptext = Esperimenti di { -brand-short-name }
pane-experimental-subtitle = Procedere con cautela
pane-experimental-search-results-header = Esperimenti di { -brand-short-name }: procedere con cautela
pane-experimental-description2 = La modifica delle impostazioni avanzate di configurazione può compromettere le prestazioni e la sicurezza di { -brand-short-name }.

pane-experimental-reset =
  .label = Ripristina predefiniti
  .accesskey = R

help-button-label = Supporto per { -brand-short-name }
addons-button-label = Estensioni e temi

focus-search =
    .key = f

close-button =
    .aria-label = Chiudi

## Browser Restart Dialog

feature-enable-requires-restart = È necessario riavviare { -brand-short-name } per attivare questa funzione.
feature-disable-requires-restart = È necessario riavviare { -brand-short-name } per disattivare questa funzione.
should-restart-title = Riavvia { -brand-short-name }
should-restart-ok = Riavvia { -brand-short-name } adesso
cancel-no-restart-button = Annulla
restart-later = Riavvia in seguito

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
extension-controlled-password-saving = Questa impostazione è attualmente gestita da un’estensione (<img data-l10n-name="icon"/> { $name }).

# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = Questa impostazione è attualmente gestita da un’estensione (<img data-l10n-name="icon"/> { $name }).

# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = Le schede contenitore sono necessarie per il funzionamento di un’estensione (<img data-l10n-name="icon"/> { $name }).

extension-controlled-websites-content-blocking-all-trackers = Questa impostazione è attualmente gestita da un’estensione (<img data-l10n-name="icon"/> { $name }).

# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = Le impostazioni di { -brand-short-name } relative alla connessione a Internet sono attualmente gestite da un’estensione (<img data-l10n-name="icon"/> { $name }).

# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Per attivare questa estensione aprire Componenti aggiuntivi <img data-l10n-name="addons-icon"/> nel menu <img data-l10n-name="menu-icon"/>.

## Preferences UI Search Results

search-results-header = Risultati della ricerca

search-results-empty-message2 = Siamo spiacenti, nessun risultato trovato per “<span data-l10n-name="query"></span>” nelle impostazioni.

search-results-help-link = Hai bisogno di aiuto? Visita <a data-l10n-name="url">il sito web di supporto per { -brand-short-name }</a>.

## General Section

startup-header = Avvio

always-check-default =
    .label = Controlla sempre se { -brand-short-name } è il browser predefinito
    .accesskey = t

is-default = { -brand-short-name } è attualmente il browser predefinito
is-not-default = { -brand-short-name } non è il browser predefinito

set-as-my-default-browser =
    .label = Imposta come browser predefinito…
    .accesskey = o

startup-restore-previous-session =
    .label = Ripristina la sessione precedente
    .accesskey = R
startup-restore-windows-and-tabs =
    .label = Apri finestre e schede esistenti
    .accesskey = r

startup-restore-warn-on-quit =
    .label = Avvisa quando si chiude il browser

disable-extension =
    .label = Disattiva estensione

tabs-group-header = Schede

ctrl-tab-recently-used-order =
    .label = Scorri le schede con Ctrl+Tab ordinandole in base all’utilizzo più recente
    .accesskey = z

open-new-link-as-tabs =
    .label = Apri link in schede invece di nuove finestre
    .accesskey = A

warn-on-close-multiple-tabs =
    .label = Avvisa quando si chiudono più schede
    .accesskey = d
confirm-on-close-multiple-tabs =
    .label = Chiedi conferma quando si chiudono più schede
    .accesskey = d

# This string is used for the confirm before quitting preference.
# Variables:
#   $quitKey (String) - the quit keyboard shortcut, and formatted
#                       in the same manner as it would appear,
#                       for example, in the File menu.
confirm-on-quit-with-key =
    .label = Chiedi conferma prima di uscire con { $quitKey }
    .accesskey = u

warn-on-open-many-tabs =
    .label = Avvisa quando l’apertura contemporanea di più schede potrebbe rallentare { -brand-short-name }
    .accesskey = c

switch-to-new-tabs =
    .label = Porta in primo piano la scheda quando si aprono link, immagini o contenuti multimediali in una nuova scheda
    .accesskey = P

show-tabs-in-taskbar =
    .label = Visualizza un’anteprima delle schede nella barra delle applicazioni di Windows
    .accesskey = V

browser-containers-enabled =
    .label = Attiva schede contenitore
    .accesskey = h

browser-containers-learn-more = Ulteriori informazioni

browser-containers-settings =
    .label = Impostazioni…
    .accesskey = o

containers-disable-alert-title = Chiudere tutte le schede contenitore?
containers-disable-alert-desc =
    { $tabCount ->
        [one] Disattivando questa funzione verrà chiusa { $tabCount } scheda contenitore. Continuare?
       *[other] Disattivando questa funzione verranno chiuse { $tabCount } schede contenitore. Continuare?
    }

containers-disable-alert-ok-button =
    { $tabCount ->
        [one] Chiudi { $tabCount } scheda contenitore
       *[other] Chiudi { $tabCount } schede contenitore
    }
containers-disable-alert-cancel-button = Non disattivare

containers-remove-alert-title = Rimuovere questo contenitore?

# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Rimuovendo questo contenitore verrà chiusa { $count } scheda contenitore. Continuare?
       *[other] Rimuovendo questo contenitore verranno chiuse { $count } schede contenitore. Continuare?
    }

containers-remove-ok-button = Rimuovi questo contenitore
containers-remove-cancel-button = Non rimuovere questo contenitore


## General Section - Language & Appearance

language-and-appearance-header = Lingua e aspetto

fonts-and-colors-header = Caratteri e colori

default-font = Carattere predefinito
    .accesskey = C
default-font-size = Dimensioni
    .accesskey = D

advanced-fonts =
    .label = Avanzate…
    .accesskey = n

colors-settings =
    .label = Colori…
    .accesskey = r

# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Zoom

preferences-default-zoom = Ingrandimento predefinito
    .accesskey = n

preferences-default-zoom-value =
    .label = { $percentage }%

preferences-zoom-text-only =
    .label = Ingrandisci solo il testo
    .accesskey = t

language-header = Lingua

choose-language-description = Scegli la lingua in cui visualizzare le pagine web

choose-button =
    .label = Scegli…
    .accesskey = g

choose-browser-language-description = Scegli le lingue in cui visualizzare menu, messaggi e notifiche di { -brand-short-name }.
manage-browser-languages-button =
    .label = Imposta alternative…
    .accesskey = l
confirm-browser-language-change-description = Riavviare { -brand-short-name } per applicare queste modifiche
confirm-browser-language-change-button = Applica e riavvia

translate-web-pages =
    .label = Traduci contenuti web
    .accesskey = T

fx-translate-web-pages = { -translations-brand-name }

# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Traduzioni a cura di <img data-l10n-name="logo"/>

translate-exceptions =
    .label = Eccezioni…
    .accesskey = z

# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = Utilizza le impostazioni del sistema operativo per “{ $localeName }” per formattare date, orari, numeri e unità di misura.

check-user-spelling =
    .label = Controllo ortografico durante la digitazione
    .accesskey = C

## General Section - Files and Applications

files-and-applications-title = File e applicazioni

download-header = Download

download-save-to =
    .label = Salva i file in
    .accesskey = v

download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Scegli…
           *[other] Sfoglia…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] c
           *[other] f
        }

download-always-ask-where =
    .label = Chiedi dove salvare ogni file
    .accesskey = e

applications-header = Applicazioni

applications-description = Scegli come gestire in { -brand-short-name } i file scaricati da Internet e le applicazioni da utilizzare durante la navigazione.

applications-filter =
    .placeholder = Cerca tipo di contenuto o applicazione

applications-type-column =
    .label = Tipo di contenuto
    .accesskey = T

applications-action-column =
    .label = Azione
    .accesskey = A

# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = file { $extension }
applications-action-save =
    .label = Salva file

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = Usa { $app-name }

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = Usa { $app-name } (predefinito)

applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] Usa applicazione predefinita di macOS
            [windows] Usa applicazione predefinita di Windows
           *[other] Usa applicazione predefinita del sistema
        }

applications-use-other =
    .label = Usa altro…
applications-select-helper = Scelta applicazione

applications-manage-app =
    .label = Dettagli applicazioni…
applications-always-ask =
    .label = Chiedi sempre

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
    .label = Usa { $plugin-name } (in { -brand-short-name })
applications-open-inapp =
    .label = Apri in { -brand-short-name }

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

drm-content-header = Contenuti con DRM (Digital Rights Management)

play-drm-content =
    .label = Riproduci contenuti protetti da DRM
    .accesskey = R

play-drm-content-learn-more = Ulteriori informazioni

update-application-title = Aggiornamenti di { -brand-short-name }

update-application-description = Mantieni { -brand-short-name } aggiornato per garantire il massimo in termini di prestazioni, stabilità e sicurezza.

update-application-version = Versione { $version } <a data-l10n-name="learn-more">Novità</a>

update-history =
    .label = Mostra cronologia aggiornamenti…
    .accesskey = o

update-application-allow-description = Consenti a { -brand-short-name } di

update-application-auto =
    .label = Installare automaticamente gli aggiornamenti (consigliato)
    .accesskey = s

update-application-check-choose =
    .label = Controllare la disponibilità di aggiornamenti ma permettere all’utente di scegliere se installarli
    .accesskey = C

update-application-manual =
    .label = Non controllare mai la disponibilità di aggiornamenti (non consigliato)
    .accesskey = N

update-application-background-enabled =
    .label = Quando { -brand-short-name } non è in esecuzione
    .accesskey = Q

update-application-warning-cross-user-setting = Questa impostazione verrà applicata a tutti gli account di Windows e ai profili di { -brand-short-name } utilizzati da questa installazione del browser.

update-application-use-service =
    .label = Utilizza un servizio di sistema per installare gli aggiornamenti
    .accesskey = U

update-setting-write-failure-title2 = Errore durante il salvataggio delle impostazioni

update-setting-write-failure-message2 =
    Si è verificato un errore e questa modifica non è stata salvata. Per aggiornare le impostazioni è necessario avere i permessi di scrittura sul file indicato in seguito. Dovrebbe essere possibile correggere il problema assegnando al gruppo Utenti il pieno controllo di questo file.

    Impossibile scrivere il file: { $path }

update-in-progress-title = Aggiornamento in corso

update-in-progress-message = Consentire a { -brand-short-name } di completare l’aggiornamento?

update-in-progress-ok-button = I&nterrompi
update-in-progress-cancel-button = &Continua

## General Section - Performance

performance-title = Prestazioni

performance-use-recommended-settings-checkbox =
    .label = Utilizza le impostazioni predefinite
    .accesskey = m

performance-use-recommended-settings-desc = Queste impostazioni sono determinate in base alle caratteristiche hardware del computer e al sistema operativo.

performance-settings-learn-more = Ulteriori informazioni

performance-allow-hw-accel =
    .label = Utilizza l’accelerazione hardware quando disponibile
    .accesskey = h

performance-limit-content-process-option = Numero massimo di processi per i contenuti
    .accesskey = o

performance-limit-content-process-enabled-desc = Un numero maggiore di processi per la gestione dei contenuti può migliorare le prestazioni quando si utilizzano molte schede, comportando però un maggiore utilizzo di memoria.
performance-limit-content-process-blocked-desc = È possibile modificare il numero di processi per i contenuti solo se è attiva la modalità multiprocesso di { -brand-short-name }. <a data-l10n-name="learn-more">Scopri come verificare se la modalità multiprocesso è attiva</a>

# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (predefinito)

## General Section - Browsing

browsing-title = Navigazione

browsing-use-autoscroll =
    .label = Utilizza lo scorrimento automatico
    .accesskey = s

browsing-use-smooth-scrolling =
    .label = Utilizza lo scorrimento fluido
    .accesskey = a

browsing-use-onscreen-keyboard =
    .label = Visualizza una tastiera touch quando necessario
    .accesskey = s

browsing-use-cursor-navigation =
    .label = Utilizza sempre i tasti direzione per navigare nelle pagine
    .accesskey = l

browsing-search-on-start-typing =
    .label = Cerca nel testo quando si digita qualcosa
    .accesskey = e

browsing-picture-in-picture-toggle-enabled =
    .label = Attiva controlli Picture-in-Picture
    .accesskey = A

browsing-picture-in-picture-learn-more = Ulteriori informazioni

browsing-media-control =
    .label = Controlla la riproduzione di file multimediali tramite tastiera, cuffie o interfacce virtuali
    .accesskey = m

browsing-media-control-learn-more = Ulteriori informazioni

browsing-cfr-recommendations =
    .label = Consiglia estensioni durante la navigazione
    .accesskey = C
browsing-cfr-features =
    .label = Consiglia funzioni durante la navigazione
    .accesskey = f

browsing-cfr-recommendations-learn-more = Ulteriori informazioni

## General Section - Proxy

network-settings-title = Impostazioni di rete

network-proxy-connection-description = Determina come { -brand-short-name } si collega a Internet.

network-proxy-connection-learn-more = Ulteriori informazioni

network-proxy-connection-settings =
    .label = Impostazioni…
    .accesskey = z

## Home Section

home-new-windows-tabs-header = Nuove finestre e schede

home-new-windows-tabs-description2 = Scegli cosa visualizzare quando vengono aperti la pagina iniziale, nuove finestre e nuove schede.

## Home Section - Home Page Customization

home-homepage-mode-label = Pagina iniziale e nuove finestre

home-newtabs-mode-label = Nuove schede

home-restore-defaults =
    .label = Ripristina predefiniti
    .accesskey = R

# "Waterfox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Pagina iniziale di Waterfox (predefinita)

home-mode-choice-custom =
    .label = Indirizzi personalizzati…

home-mode-choice-blank =
    .label = Pagina vuota

home-homepage-custom-url =
    .placeholder = Incolla un indirizzo…

# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Usa la pagina corrente
           *[other] Usa le pagine correnti
        }
    .accesskey = U

choose-bookmark =
    .label = Usa un segnalibro…
    .accesskey = b

## Home Section - Waterfox Home Content Customization

home-prefs-content-header = Pagina iniziale di Waterfox
home-prefs-content-description = Scegli i contenuti da visualizzare nella pagina iniziale di Waterfox.

home-prefs-search-header =
    .label = Ricerca sul Web
home-prefs-topsites-header =
    .label = Siti principali
home-prefs-topsites-description = I siti più visitati

home-prefs-topsites-by-option-sponsored =
    .label = Siti principali sponsorizzati
home-prefs-shortcuts-header =
    .label = Scorciatoie
home-prefs-shortcuts-description = Siti che hai salvato oppure visitato
home-prefs-shortcuts-by-option-sponsored =
    .label = Scorciatoie sponsorizzate

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Consigliati da { $provider }
home-prefs-recommended-by-description-update = Contenuti eccezionali da tutto il Web, a cura di { $provider }
home-prefs-recommended-by-description-new = Contenuti eccezionali a cura di { $provider }, un membro della famiglia { -brand-product-name }

##

home-prefs-recommended-by-learn-more = Come funziona
home-prefs-recommended-by-option-sponsored-stories =
    .label = Articoli sponsorizzati

home-prefs-highlights-header =
    .label = In evidenza
home-prefs-highlights-description = Una selezione di siti che hai salvato o visitato in precedenza
home-prefs-highlights-option-visited-pages =
    .label = Pagine visitate
home-prefs-highlights-options-bookmarks =
    .label = Segnalibri
home-prefs-highlights-option-most-recent-download =
    .label = Download più recenti
home-prefs-highlights-option-saved-to-pocket =
    .label = Pagine salvate in { -pocket-brand-name }

home-prefs-recent-activity-header =
    .label = Attività recente
home-prefs-recent-activity-description = Una selezione di siti e contenuti visualizzati di recente

# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Snippet
home-prefs-snippets-description = Aggiornamenti da { -vendor-short-name } e { -brand-product-name }

home-prefs-snippets-description-new = Consigli e notizie da { -vendor-short-name } e { -brand-product-name }

home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } riga
           *[other] { $num } righe
        }

## Search Section

search-bar-header = Barra di ricerca
search-bar-hidden =
    .label = Utilizza la barra degli indirizzi per ricerche e navigazione
search-bar-shown =
    .label = Aggiungi la barra di ricerca alla barra degli strumenti

search-engine-default-header = Motore di ricerca predefinito
search-engine-default-desc-2 = Questo è il motore di ricerca predefinito per la barra degli indirizzi e la barra di ricerca. È possibile cambiarlo in qualunque momento.
search-engine-default-private-desc-2 = Scegli un altro motore di ricerca da utilizzare solo nelle finestre anonime
search-separate-default-engine =
    .label = Utilizza questo motore di ricerca nelle finestre anonime
    .accesskey = U

search-suggestions-header = Suggerimenti di ricerca
search-suggestions-desc = Scegli come visualizzare i suggerimenti dai motori di ricerca.

search-suggestions-option =
    .label = Visualizza suggerimenti di ricerca
    .accesskey = V

search-show-suggestions-url-bar-option =
    .label = Visualizza suggerimenti di ricerca tra i risultati della barra degli indirizzi
    .accesskey = i

# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Visualizza suggerimenti di ricerca prima della cronologia nei risultati della barra degli indirizzi

search-show-suggestions-private-windows =
    .label = Visualizza suggerimenti di ricerca nelle finestre anonime

suggestions-addressbar-settings-generic2 = Modifica le impostazioni per altri tipi di suggerimenti nella barra degli indirizzi

search-suggestions-cant-show = I suggerimenti di ricerca non verranno visualizzati tra i risultati della barra degli indirizzi in quanto { -brand-short-name } è configurato per non salvare la cronologia.

search-one-click-header2 = Scorciatoie di ricerca

search-one-click-desc = Scegli i motori di ricerca alternativi che appaiono nella barra degli indirizzi e nella barra di ricerca quando si inizia a digitare una parola chiave.

search-choose-engine-column =
    .label = Motore di ricerca
search-choose-keyword-column =
    .label = Parola chiave

search-restore-default =
    .label = Ripristina i motori di ricerca predefiniti
    .accesskey = m

search-remove-engine =
    .label = Rimuovi
    .accesskey = R

search-add-engine =
    .label = Aggiungi
    .accesskey = A

search-find-more-link = Trova altri motori di ricerca

# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Parola chiave duplicata
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = La parola chiave scelta è già utilizzata da “{ $name }”. Selezionarne una diversa.
search-keyword-warning-bookmark = La parola chiave scelta è già utilizzata da un segnalibro. Selezionarne una diversa.

## Containers Section

containers-back-button2 =
    .aria-label = Torna alle impostazioni
containers-header = Schede contenitore
containers-add-button =
    .label = Aggiungi nuovo contenitore
    .accesskey = A

containers-new-tab-check =
    .label = Scegli un contenitore per ogni nuova scheda
    .accesskey = c

containers-settings-button =
    .label = Impostazioni
containers-remove-button =
    .label = Rimuovi

## Sync Section - Signed out


## Waterfox Account - Signed out. Note that "Sync" and "Waterfox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Il tuo Web, sempre con te

sync-signedout-description2 = Sincronizza segnalibri, cronologia, schede, password, componenti aggiuntivi e impostazioni attraverso tutti i tuoi dispositivi.

sync-signedout-account-signin3 =
    .label = Accedi per sincronizzare…
    .accesskey = d

# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Scarica Waterfox per <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> o <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> per sincronizzare con cellulari e tablet.

## Sync Section - Signed in


## Waterfox Account - Signed in

sync-profile-picture =
    .tooltiptext = Cambia l’immagine del profilo

sync-sign-out =
    .label = Disconnetti…
    .accesskey = t

sync-manage-account = Gestisci account
    .accesskey = G

sync-signedin-unverified = { $email } non è verificato.
sync-signedin-login-failure = Accedi per riattivare la connessione con { $email }

sync-resend-verification =
    .label = Invia di nuovo email di verifica
    .accesskey = n

sync-remove-account =
    .label = Rimuovi account
    .accesskey = n

sync-sign-in =
    .label = Accedi
    .accesskey = A

## Sync section - enabling or disabling sync.

prefs-syncing-on = Sincronizzazione: ATTIVA

prefs-syncing-off = Sincronizzazione: DISATTIVATA

prefs-sync-turn-on-syncing =
    .label = Attiva sincronizzazione…
    .accesskey = c

prefs-sync-offer-setup-label2 = Sincronizza segnalibri, cronologia, schede, password, componenti aggiuntivi e impostazioni attraverso tutti i tuoi dispositivi.

prefs-sync-now =
    .labelnotsyncing = Sincronizza adesso
    .accesskeynotsyncing = a
    .labelsyncing = Sincronizzazione in corso…

## The list of things currently syncing.

sync-currently-syncing-heading = I seguenti elementi vengono attualmente sincronizzati:

sync-currently-syncing-bookmarks = Segnalibri
sync-currently-syncing-history = Cronologia
sync-currently-syncing-tabs = Schede aperte
sync-currently-syncing-logins-passwords = Credenziali e password
sync-currently-syncing-addresses = Indirizzi
sync-currently-syncing-creditcards = Carte di credito
sync-currently-syncing-addons = Componenti aggiuntivi

sync-currently-syncing-settings = Impostazioni

sync-change-options =
    .label = Cambia…
    .accesskey = b

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = Scelta elementi da sincronizzare
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = Salva modifiche
    .buttonaccesskeyaccept = S
    .buttonlabelextra2 = Disconnetti…
    .buttonaccesskeyextra2 = D

sync-engine-bookmarks =
    .label = Segnalibri
    .accesskey = e

sync-engine-history =
    .label = Cronologia
    .accesskey = C

sync-engine-tabs =
    .label = Schede aperte
    .tooltiptext = Elementi aperti nei dispositivi sincronizzati
    .accesskey = h

sync-engine-logins-passwords =
    .label = Credenziali e password
    .tooltiptext = Nomi utente e password salvati
    .accesskey = i

sync-engine-addresses =
    .label = Indirizzi
    .tooltiptext = Indirizzi salvati come via, città, ecc. (solo per desktop)
    .accesskey = I

sync-engine-creditcards =
    .label = Carte di credito
    .tooltiptext = Nome, numero e data di scadenza (solo per desktop)
    .accesskey = r

sync-engine-addons =
    .label = Componenti aggiuntivi
    .tooltiptext = Estensioni e temi per Waterfox desktop
    .accesskey = o

sync-engine-settings =
    .label = Impostazioni
    .tooltiptext = Impostazioni modificate nei pannelli “Generale” e “Privacy e sicurezza”
    .accesskey = z

## The device name controls.

sync-device-name-header = Nome dispositivo

sync-device-name-change =
    .label = Cambia nome dispositivo…
    .accesskey = d

sync-device-name-cancel =
    .label = Annulla
    .accesskey = n

sync-device-name-save =
    .label = Salva
    .accesskey = S

sync-connect-another-device = Connetti un altro dispositivo

## Privacy Section

privacy-header = Privacy del browser

## Privacy Section - Forms


## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Credenziali e password
    .searchkeywords = { -lockwise-brand-short-name }

forms-ask-to-save-logins =
    .label = Chiedi se salvare le credenziali di accesso ai siti web
    .accesskey = C
forms-exceptions =
    .label = Eccezioni…
    .accesskey = z
forms-generate-passwords =
    .label = Suggerisci e genera password complesse
    .accesskey = u
forms-breach-alerts =
    .label = Visualizza avvisi per le password di siti coinvolti in violazioni di dati
    .accesskey = a
forms-breach-alerts-learn-more-link = Ulteriori informazioni

forms-fill-logins-and-passwords =
    .label = Compila automaticamente le credenziali di accesso
    .accesskey = i
forms-saved-logins =
    .label = Credenziali salvate…
    .accesskey = s
forms-primary-pw-use =
    .label = Utilizza una password principale
    .accesskey = U
forms-primary-pw-learn-more-link = Ulteriori informazioni
forms-master-pw-change =
    .label = Cambia la password principale…
    .accesskey = w

forms-primary-pw-change =
    .label = Cambia la password principale…
    .accesskey = w
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = { "" }

forms-primary-pw-fips-title = Si è in modalità FIPS. FIPS richiede che la password principale sia impostata.
forms-master-pw-fips-desc = Modifica della password non riuscita

forms-windows-sso =
    .label = Consenti single sign-on di Windows per account Microsoft, del lavoro o della scuola
forms-windows-sso-learn-more-link = Ulteriori informazioni
forms-windows-sso-desc = Gestisci account nelle impostazioni del dispositivo

## OS Authentication dialog

primary-password-os-auth-dialog-message-win = Per creare una password principale, inserire le credenziali di accesso a Windows. Questo aiuta a garantire la sicurezza dei tuoi account.

primary-password-os-auth-dialog-message-macosx = creare una password principale
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = Cronologia

# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Waterfox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Waterfox", moving the verb into each option.
#     This will result in "Waterfox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Waterfox history settings:".
history-remember-label = Impostazioni cronologia:
    .accesskey = m

history-remember-option-all =
    .label = salva la cronologia
history-remember-option-never =
    .label = non salvare la cronologia
history-remember-option-custom =
    .label = utilizza impostazioni personalizzate

history-remember-description = Verranno salvate la cronologia di navigazione, i download, le informazioni inserite nei moduli o nei campi di ricerca.
history-dontremember-description = Verranno utilizzate le stesse impostazioni della Navigazione anonima: in questo modo non verrà salvata alcuna cronologia relativa alla navigazione.

history-private-browsing-permanent =
    .label = Utilizza sempre la modalità Navigazione anonima
    .accesskey = U

history-remember-browser-option =
    .label = Conserva la cronologia di navigazione e dei download
    .accesskey = d

history-remember-search-option =
    .label = Conserva la cronologia delle ricerche e dei moduli
    .accesskey = g

history-clear-on-close-option =
    .label = Cancella la cronologia alla chiusura di { -brand-short-name }
    .accesskey = C

history-clear-on-close-settings =
    .label = Impostazioni…
    .accesskey = I

history-clear-button =
    .label = Cancella cronologia…
    .accesskey = e

## Privacy Section - Site Data

sitedata-header = Cookie e dati dei siti web

sitedata-total-size-calculating = Calcolo dimensioni…

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = I cookie, i dati salvati dai siti web e la cache stanno utilizzando { $value } { $unit } di spazio su disco

sitedata-learn-more = Ulteriori informazioni

sitedata-delete-on-close =
    .label = Elimina cookie e dati dei siti web alla chiusura di { -brand-short-name }
    .accesskey = c

sitedata-delete-on-close-private-browsing = Se la modalità Navigazione anonima è sempre attiva, i cookie e i dati dei siti web verranno eliminati alla chiusura di { -brand-short-name }.

sitedata-allow-cookies-option =
    .label = Accetta cookie e dati dei siti web
    .accesskey = A

sitedata-disallow-cookies-option =
    .label = Blocca cookie e dati dei siti web
    .accesskey = B

# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Contenuti bloccati:
    .accesskey = C

sitedata-option-block-cross-site-trackers =
    .label = Traccianti intersito
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = Traccianti intersito e dei social media
sitedata-option-block-cross-site-tracking-cookies-including-social-media =
    .label = Cookie traccianti intersito, inclusi cookie dei social media
sitedata-option-block-cross-site-cookies-including-social-media =
    .label = Cookie intersito, inclusi cookie dei social media
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = Traccianti intersito e dei social media, isola i cookie restanti
sitedata-option-block-unvisited =
    .label = Cookie da siti web non visitati
sitedata-option-block-all-third-party =
    .label = Tutti i cookie di terze parti (alcuni siti potrebbero non funzionare correttamente)
sitedata-option-block-all =
    .label = Tutti i cookie (alcuni siti non funzioneranno correttamente)

sitedata-clear =
    .label = Elimina dati…
    .accesskey = i

sitedata-settings =
    .label = Gestisci dati…
    .accesskey = d

sitedata-cookies-exceptions =
    .label = Gestisci eccezioni…
    .accesskey = z

## Privacy Section - Address Bar

addressbar-header = Barra degli indirizzi

addressbar-suggest = Nella barra degli indirizzi visualizza suggerimenti da:

addressbar-locbar-history-option =
    .label = Cronologia di navigazione
    .accesskey = n
addressbar-locbar-bookmarks-option =
    .label = Segnalibri
    .accesskey = g
addressbar-locbar-openpage-option =
    .label = Schede aperte
    .accesskey = d
# Shortcuts refers to the shortcut tiles on the new tab page, previously known as top sites. Translation should be consistent.
addressbar-locbar-shortcuts-option =
    .label = Scorciatoie
    .accesskey = S
addressbar-locbar-topsites-option =
    .label = Siti principali
    .accesskey = a

addressbar-locbar-engines-option =
    .label = Motori di ricerca
    .accesskey = M

addressbar-suggestions-settings = Modifica le impostazioni relative ai suggerimenti dei motori di ricerca

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Protezione antitracciamento avanzata

content-blocking-section-top-level-description = Gli elementi traccianti ti seguono online al fine di raccogliere informazioni sui tuoi interessi e le tue abitudini di navigazione. { -brand-short-name } blocca molti di questi traccianti e altri script dannosi.

content-blocking-learn-more = Ulteriori informazioni

content-blocking-fpi-incompatibility-warning = La funzione First Party Isolation (FPI) è attualmente attiva e sostituisce alcune impostazioni di { -brand-short-name } relative ai cookie.

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

enhanced-tracking-protection-setting-standard =
    .label = Normale
    .accesskey = N
enhanced-tracking-protection-setting-strict =
    .label = Restrittiva
    .accesskey = R
enhanced-tracking-protection-setting-custom =
    .label = Personalizzata
    .accesskey = P

##

content-blocking-etp-standard-desc = Equilibrio tra protezione e prestazioni. Le pagine si caricheranno normalmente.
content-blocking-etp-strict-desc = Maggiore protezione, ma alcuni siti o contenuti potrebbero non funzionare correttamente.
content-blocking-etp-custom-desc = Scegli quali traccianti e script bloccare.

content-blocking-etp-blocking-desc = { -brand-short-name } blocca i seguenti elementi:

content-blocking-private-windows = Contenuti traccianti in finestre anonime
content-blocking-cross-site-cookies-in-all-windows = Cookie intersito in tutte le finestre (inclusi cookie traccianti)
content-blocking-cross-site-tracking-cookies = Cookie traccianti intersito
content-blocking-all-cross-site-cookies-private-windows = Cookie traccianti intersito in finestre anonime
content-blocking-cross-site-tracking-cookies-plus-isolate = Cookie traccianti intersito, isola i cookie restanti
content-blocking-social-media-trackers = Traccianti dei social media
content-blocking-all-cookies = Tutti i cookie
content-blocking-unvisited-cookies = Cookie da siti web non visitati
content-blocking-all-windows-tracking-content = Contenuti traccianti in qualunque finestra
content-blocking-all-third-party-cookies = Tutti i cookie di terze parti
content-blocking-cryptominers = Cryptominer
content-blocking-fingerprinters = Fingerprinter

content-blocking-warning-title = Attenzione
content-blocking-and-isolating-etp-warning-description = Il blocco degli elementi traccianti e l’isolamento dei cookie possono impedire il corretto funzionamento di alcuni siti. Ricaricare la pagina con gli elementi traccianti per visualizzare tutti i contenuti.
content-blocking-and-isolating-etp-warning-description-2 = Questa impostazione potrebbe causare in alcuni siti la mancata visualizzazione di contenuti o altri problemi di funzionamento. Se una pagina non viene visualizzata correttamente, provare a disattivare la protezione antitracciamento per quel sito per ricaricare tutti i contenuti.
content-blocking-warning-learn-how = Scopri come

content-blocking-reload-description = È necessario ricaricare le schede per applicare le modifiche.
content-blocking-reload-tabs-button =
    .label = Ricarica tutte le schede
    .accesskey = R

content-blocking-tracking-content-label =
    .label = Contenuti traccianti
    .accesskey = C
content-blocking-tracking-protection-option-all-windows =
    .label = In tutte le finestre
    .accesskey = u
content-blocking-option-private =
    .label = Solo in finestre anonime
    .accesskey = a
content-blocking-tracking-protection-change-block-list = Cambia elenco per blocco contenuti

content-blocking-cookies-label =
    .label = Cookie
    .accesskey = C

content-blocking-expand-section =
    .tooltiptext = Ulteriori informazioni

content-blocking-cryptominers-label =
    .label = Cryptominer
    .accesskey = y

content-blocking-fingerprinters-label =
    .label = Fingerprinter
    .accesskey = F

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Gestisci eccezioni…
    .accesskey = G

## Privacy Section - Permissions

permissions-header = Permessi

permissions-location = Posizione
permissions-location-settings =
    .label = Impostazioni…
    .accesskey = m

permissions-xr = Realtà virtuale
permissions-xr-settings =
    .label = Impostazioni…
    .accesskey = o

permissions-camera = Fotocamera
permissions-camera-settings =
    .label = Impostazioni…
    .accesskey = s

permissions-microphone = Microfono
permissions-microphone-settings =
    .label = Impostazioni…
    .accesskey = t

permissions-notification = Notifiche
permissions-notification-settings =
    .label = Impostazioni…
    .accesskey = a
permissions-notification-link = Ulteriori informazioni

permissions-notification-pause =
    .label = Sospendi notifiche fino al riavvio di { -brand-short-name }
    .accesskey = n

permissions-autoplay = Riproduzione automatica

permissions-autoplay-settings =
    .label = Impostazioni…
    .accesskey = t

permissions-block-popups =
    .label = Blocca le finestre pop-up
    .accesskey = B

permissions-block-popups-exceptions =
    .label = Eccezioni…
    .accesskey = o

permissions-block-popups-exceptions-button =
    .label = Eccezioni…
    .accesskey = o
    .searchkeywords = popup

permissions-addon-install-warning =
    .label = Avvisa se un sito web cerca di installare un componente aggiuntivo
    .accesskey = A

permissions-addon-exceptions =
    .label = Eccezioni…
    .accesskey = E

## Privacy Section - Data Collection

collection-header = Raccolta e utilizzo dati di { -brand-short-name }

collection-description = Cerchiamo di garantire agli utenti la possibilità di scegliere, raccogliendo solo i dati necessari per realizzare e migliorare { -brand-short-name } per tutti. Chiediamo sempre l’autorizzazione prima di raccogliere dati personali.
collection-privacy-notice = Informativa sulla privacy

collection-health-report-telemetry-disabled = È stato revocato il permesso a { -vendor-short-name } di raccogliere dati tecnici e relativi all’interazione con il browser. Tutti i dati esistenti verranno rimossi entro 30 giorni.
collection-health-report-telemetry-disabled-link = Ulteriori informazioni

collection-health-report =
    .label = Consenti a { -brand-short-name } di inviare a { -vendor-short-name } dati tecnici e relativi all’interazione con il browser
    .accesskey = v
collection-health-report-link = Ulteriori informazioni

collection-studies =
    .label = Consenti a { -brand-short-name } di installare e condurre studi
collection-studies-link = Visualizza studi di { -brand-short-name }

addon-recommendations =
    .label = Consenti a { -brand-short-name } di visualizzare suggerimenti personalizzati relativi alle estensioni
addon-recommendations-link = Ulteriori informazioni

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = L’invio dei dati è stato disattivato nella configurazione utilizzata per questa build

collection-backlogged-crash-reports-with-link = Consenti a { -brand-short-name } di inviare segnalazioni di arresto anomalo in sospeso <a data-l10n-name="crash-reports-link">Ulteriori informazioni</a>
    .accesskey = C

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Sicurezza

security-browsing-protection = Protezione contro contenuti ingannevoli e software a rischio

security-enable-safe-browsing =
    .label = Blocca contenuti a rischio e ingannevoli
    .accesskey = B
security-enable-safe-browsing-link = Ulteriori informazioni

security-block-downloads =
    .label = Blocca download a rischio
    .accesskey = c

security-block-uncommon-software =
    .label = Avvisa in caso di software indesiderato e non scaricato abitualmente
    .accesskey = w

## Privacy Section - Certificates

certs-header = Certificati

certs-enable-ocsp =
    .label = Interroga risponditori OCSP per confermare la validità attuale dei certificati
    .accesskey = P

certs-view =
    .label = Mostra certificati…
    .accesskey = M

certs-devices =
    .label = Dispositivi di sicurezza…
    .accesskey = D

space-alert-over-5gb-settings-button =
    .label = Apri impostazioni
    .accesskey = A

space-alert-over-5gb-message2 = <strong>Lo spazio a disposizione di { -brand-short-name } sta per esaurirsi.</strong> Il contenuto dei siti web potrebbe non essere visualizzato correttamente. È possibile eliminare i dati salvati dai siti web in Impostazioni > Privacy e sicurezza > Cookie e dati dei siti web.

space-alert-under-5gb-message2 = <strong>Lo spazio a disposizione di { -brand-short-name } sta per esaurirsi.</strong> Il contenuto dei siti web potrebbe non essere visualizzato correttamente. Visita il link “Ulteriori informazioni” per scoprire come ottimizzare l’utilizzo dello spazio su disco e migliorare l’esperienza di navigazione.

## Privacy Section - HTTPS-Only

httpsonly-header = Modalità solo HTTPS

httpsonly-description = HTTPS garantisce una connessione sicura e crittata tra { -brand-short-name } e i siti web visitati. La maggior parte dei siti web supporta HTTPS e, quando la modalità solo HTTPS è attiva, { -brand-short-name } si connetterà automaticamente con HTTPS.

httpsonly-learn-more = Ulteriori informazioni

httpsonly-radio-enabled =
    .label = Attiva in tutte le finestre

httpsonly-radio-enabled-pbm =
    .label = Attiva solo in finestre anonime

httpsonly-radio-disabled =
    .label = Non attivare

## The following strings are used in the Download section of settings

desktop-folder-name = Desktop
downloads-folder-name = Download
choose-download-folder-title = Selezionare la cartella di download:

# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Salva file in { $service-name }
