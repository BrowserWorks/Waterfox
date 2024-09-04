# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Invia ai siti web un segnale “Do Not Track” per chiedere di non effettuare alcun tracciamento
do-not-track-description2 =
    .label = Invia ai siti web una richiesta “Do Not Track”
    .accesskey = b
do-not-track-learn-more = Ulteriori informazioni
do-not-track-option-default-content-blocking-known =
    .label = Solo quando { -brand-short-name } è impostato per bloccare gli elementi traccianti conosciuti
do-not-track-option-always =
    .label = Sempre

global-privacy-control-description =
    .label = Segnala ai siti web di non vendere o condividere i miei dati
    .accesskey = S

settings-page-title = Impostazioni
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
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
##   $name (string) - Name of the extension

# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlling-password-saving = Questa impostazione è attualmente gestita da <img data-l10n-name="icon"/> <strong>{ $name }</strong>.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlling-web-notifications = Questa impostazione è attualmente gestita da <img data-l10n-name="icon"/> <strong>{ $name }</strong>.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlling-privacy-containers = Le schede contenitore sono necessarie per il funzionamento di <img data-l10n-name="icon"/> <strong>{ $name }</strong>.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlling-websites-content-blocking-all-trackers = Questa impostazione è attualmente gestita da <img data-l10n-name="icon"/> <strong>{ $name }</strong>.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlling-proxy-config = Le impostazioni di { -brand-short-name } relative alla connessione a Internet sono attualmente gestite da <img data-l10n-name="icon"/> <strong>{ $name }</strong>.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Per attivare questa estensione aprire Componenti aggiuntivi <img data-l10n-name="addons-icon"/> nel menu <img data-l10n-name="menu-icon"/>.

## Preferences UI Search Results

search-results-header = Risultati della ricerca
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
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
startup-restore-windows-and-tabs =
    .label = Apri finestre e schede esistenti
    .accesskey = r
startup-restore-warn-on-quit =
    .label = Avvisa quando si chiude il browser
disable-extension =
    .label = Disattiva estensione
preferences-data-migration-header = Importa dati del browser
preferences-data-migration-description = Importa segnalibri, password, cronologia e dati per la compilazione automatica dei moduli in { -brand-short-name }.
preferences-data-migration-button =
    .label = Importa dati
    .accesskey = m
tabs-group-header = Schede
ctrl-tab-recently-used-order =
    .label = Scorri le schede con Ctrl+Tab ordinandole in base all’utilizzo più recente
    .accesskey = z
open-new-link-as-tabs =
    .label = Apri link in schede invece di nuove finestre
    .accesskey = A
confirm-on-close-multiple-tabs =
    .label = Chiedi conferma quando si chiudono più schede
    .accesskey = d
# This string is used for the confirm before quitting preference.
# Variables:
#   $quitKey (string) - the quit keyboard shortcut, and formatted
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

## Variables:
##   $tabCount (number) - Number of tabs

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

##

containers-disable-alert-cancel-button = Non disattivare
containers-remove-alert-title = Rimuovere questo contenitore?
# Variables:
#   $count (number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Rimuovendo questo contenitore verrà chiusa { $count } scheda contenitore. Continuare?
       *[other] Rimuovendo questo contenitore verranno chiuse { $count } schede contenitore. Continuare?
    }
containers-remove-ok-button = Rimuovi questo contenitore
containers-remove-cancel-button = Non rimuovere questo contenitore

## General Section - Language & Appearance

language-and-appearance-header = Lingua e aspetto
preferences-web-appearance-header = Aspetto dei siti web
preferences-web-appearance-description = Alcuni siti web possono adattare il proprio schema di colori in base alle preferenze del visitatore. Scegli lo schema di colori da seguire per questi siti.
preferences-web-appearance-choice-auto = Automatico
preferences-web-appearance-choice-light = Chiaro
preferences-web-appearance-choice-dark = Scuro
preferences-web-appearance-choice-tooltip-auto =
    .title = Cambia automaticamente i colori dello sfondo e dei contenuti dei siti in base alle impostazioni del sistema e del tema di { -brand-short-name }.
preferences-web-appearance-choice-tooltip-light =
    .title = Preferisci una combinazione di colori chiara per lo sfondo e i contenuti dei siti.
preferences-web-appearance-choice-tooltip-dark =
    .title = Preferisci una combinazione di colori scura per lo sfondo e i contenuti dei siti.
preferences-web-appearance-choice-input-auto =
    .aria-description = { preferences-web-appearance-choice-tooltip-auto.title }
preferences-web-appearance-choice-input-light =
    .aria-description = { preferences-web-appearance-choice-tooltip-light.title }
preferences-web-appearance-choice-input-dark =
    .aria-description = { preferences-web-appearance-choice-tooltip-dark.title }
# This can appear when using windows HCM or "Override colors: always" without
# system colors.
preferences-web-appearance-override-warning = Le impostazioni per l’aspetto dei siti web sono sostituite dall’attuale selezione di colori. <a data-l10n-name="colors-link">Gestisci colori</a>
# This message contains one link. It can be moved within the sentence as needed
# to adapt to your language, but should not be changed.
preferences-web-appearance-footer = Gestisci i temi di { -brand-short-name } in <a data-l10n-name="themes-link">Estensioni e temi</a>
preferences-colors-header = Colori
preferences-colors-description = Sostituisci i colori predefiniti di { -brand-short-name } per testo, sfondo dei siti e link.
preferences-colors-manage-button =
    .label = Gestisci colori…
    .accesskey = r
preferences-fonts-header = Caratteri
default-font = Carattere predefinito
    .accesskey = C
default-font-size = Dimensioni
    .accesskey = D
advanced-fonts =
    .label = Avanzate…
    .accesskey = n
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Zoom
preferences-default-zoom = Ingrandimento predefinito
    .accesskey = n
# Variables:
#   $percentage (number) - Zoom percentage value
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
download-save-where = Salva i file in
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
#   $type-description (string) - Description of the type (e.g "Portable Document Format")
#   $type (string) - The MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })
# Variables:
#   $extension (string) - File extension (e.g .TXT)
#   $type (string) - The MIME type (e.g application/binary)
applications-file-ending-with-type = { applications-file-ending } ({ $type })
# Variables:
#   $plugin-name (string) - Name of a plugin (e.g Adobe Flash)
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

applications-handle-new-file-types-description = Che cosa deve fare { -brand-short-name } con altri file?
applications-save-for-new-types =
    .label = Salva i file
    .accesskey = S
applications-ask-before-handling =
    .label = Chiedi se aprire o salvare i file
    .accesskey = C
drm-content-header = Contenuti con DRM (Digital Rights Management)
play-drm-content =
    .label = Riproduci contenuti protetti da DRM
    .accesskey = R
play-drm-content-learn-more = Ulteriori informazioni
update-application-title = Aggiornamenti di { -brand-short-name }
update-application-description = Mantieni { -brand-short-name } aggiornato per garantire il massimo in termini di prestazioni, stabilità e sicurezza.
# Variables:
# $version (string) - Waterfox version
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
update-application-suppress-prompts =
    .label = Visualizza meno notifiche per gli aggiornamenti
    .accesskey = n
update-setting-write-failure-title2 = Errore durante il salvataggio delle impostazioni
# Variables:
#   $path (string) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message2 =
    Si è verificato un errore e questa modifica non è stata salvata. Per aggiornare le impostazioni è necessario avere i permessi di scrittura sul file indicato in seguito. Dovrebbe essere possibile correggere il problema assegnando al gruppo Utenti il pieno controllo di questo file.

    Impossibile scrivere il file: { $path }
update-in-progress-title = Aggiornamento in corso
update-in-progress-message = Consentire a { -brand-short-name } di completare l’aggiornamento?
update-in-progress-ok-button = I&nterrompi
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
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
#   $num (number) - Default value of the `dom.ipc.processCount` pref.
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
browsing-gtk-use-non-overlay-scrollbars =
    .label = Mostra sempre le barre di scorrimento
    .accesskey = o
browsing-use-onscreen-keyboard =
    .label = Visualizza una tastiera touch quando necessario
    .accesskey = s
browsing-use-cursor-navigation =
    .label = Utilizza sempre i tasti direzione per navigare nelle pagine
    .accesskey = l
browsing-use-full-keyboard-navigation =
    .label = Utilizza il tasto di tabulazione (TAB) per spostare la selezione tra i controlli dei moduli e i link
    .accesskey = u
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
home-mode-choice-default-fx =
    .label = { -firefox-home-brand-name } (predefinita)
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

home-prefs-content-header2 = Contenuti per { -firefox-home-brand-name }
home-prefs-content-description2 = Scegli i contenuti da visualizzare in { -firefox-home-brand-name }.
home-prefs-search-header =
    .label = Ricerca sul Web
home-prefs-shortcuts-header =
    .label = Scorciatoie
home-prefs-shortcuts-description = Siti che hai salvato oppure visitato
home-prefs-shortcuts-by-option-sponsored =
    .label = Scorciatoie sponsorizzate

## Variables:
##  $provider (string) - Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Consigliati da { $provider }
home-prefs-recommended-by-description-new = Contenuti eccezionali a cura di { $provider }, un membro della famiglia { -brand-product-name }

##

home-prefs-recommended-by-learn-more = Come funziona
home-prefs-recommended-by-option-sponsored-stories =
    .label = Articoli sponsorizzati
home-prefs-recommended-by-option-recent-saves =
    .label = Mostra elementi salvati di recente
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
home-prefs-snippets-description-new = Consigli e notizie da { -vendor-short-name } e { -brand-product-name }
# Variables:
#   $num (number) - Number of rows displayed
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
# With this option enabled, on the search results page
# the URL will be replaced by the search terms in the address bar
# when using the current default search engine.
search-show-search-term-option =
    .label = Mostra i termini di ricerca invece dell’indirizzo nella pagina dei risultati del motore di ricerca predefinito
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
#   $name (string) - Name of a search engine.
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

## Waterfox account - Signed out. Note that "Sync" and "Waterfox account" are now
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

## Waterfox account - Signed in

sync-profile-picture =
    .tooltiptext = Cambia l’immagine del profilo
sync-sign-out =
    .label = Disconnetti…
    .accesskey = t
sync-manage-account = Gestisci account
    .accesskey = G

## Variables
## $email (string) - Email used for Waterfox account

sync-signedin-unverified = { $email } non è verificato.
sync-signedin-login-failure = Accedi per riattivare la connessione con { $email }

##

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
prefs-sync-now-button =
    .label = Sincronizza adesso
    .accesskey = a
prefs-syncing-button =
    .label = Sincronizzazione in corso…

## The list of things currently syncing.

sync-syncing-across-devices-heading = I seguenti elementi vengono attualmente sincronizzati fra tutti i dispositivi connessi:
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

sync-choose-what-to-sync-dialog3 =
    .title = Scelta elementi da sincronizzare
    .style = min-width: 36em;
    .buttonlabelaccept = Salva modifiche
    .buttonaccesskeyaccept = S
    .buttonlabelextra2 = Disconnetti…
    .buttonaccesskeyextra2 = D
sync-choose-dialog-subtitle = Le modifiche all’elenco di elementi da sincronizzare verranno applicate a tutti i dispositivi connessi.
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

## These strings are shown in a desktop notification after the
## user requests we resend a verification email.

sync-verification-sent-title = Verifica inviata
# Variables:
#   $email (String): Email address of user's Waterfox account.
sync-verification-sent-body = È stato inviato un link di verifica a { $email }.
sync-verification-not-sent-title = Impossibile inviare la verifica
sync-verification-not-sent-body = Non è stato possibile inviare la mail di verifica, riprovare più tardi.

## Privacy Section

privacy-header = Privacy del browser

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Credenziali e password
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
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
preferences-relay-integration-checkbox =
    .label = Suggerisci alias di posta elettronica { -relay-brand-name } per proteggere il tuo indirizzo email
relay-integration-learn-more-link = Ulteriori informazioni
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
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
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
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

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Per creare una password principale, inserire le credenziali di accesso a Windows. Questo aiuta a garantire la sicurezza dei tuoi account.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Waterfox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
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
#   $value (number) - Value of the unit (for example: 4.6, 500)
#   $unit (string) - Name of the unit (for example: "bytes", "KB")
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
sitedata-option-block-cross-site-tracking-cookies =
    .label = Cookie traccianti intersito
sitedata-option-block-cross-site-cookies =
    .label = Cookie traccianti intersito, isola gli altri cookie intersito
sitedata-option-block-unvisited =
    .label = Cookie da siti web non visitati
sitedata-option-block-all-cross-site-cookies =
    .label = Tutti i cookie intersito (alcuni siti potrebbero non funzionare correttamente)
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

## Privacy Section - Cookie Banner Handling

cookie-banner-handling-header = Riduzione banner per i cookie
cookie-banner-handling-description = { -brand-short-name } cerca di rifiutare automaticamente le richieste dei banner per i cookie nei siti supportati.
cookie-banner-learn-more = Ulteriori informazioni
forms-handle-cookie-banners =
    .label = Riduci banner per i cookie

## Privacy Section - Address Bar

addressbar-header = Barra degli indirizzi
addressbar-suggest = Nella barra degli indirizzi visualizza suggerimenti da:
addressbar-locbar-history-option =
    .label = Cronologia di navigazione
    .accesskey = n
addressbar-locbar-bookmarks-option =
    .label = Segnalibri
    .accesskey = g
addressbar-locbar-clipboard-option =
    .label = Appunti
    .accesskey = u
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
addressbar-locbar-quickactions-option =
    .label = Azioni rapide
    .accesskey = z
addressbar-suggestions-settings = Modifica le impostazioni relative ai suggerimenti dei motori di ricerca
addressbar-quickactions-learn-more = Ulteriori informazioni

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Protezione antitracciamento avanzata
content-blocking-section-top-level-description = Gli elementi traccianti ti seguono online al fine di raccogliere informazioni sui tuoi interessi e le tue abitudini di navigazione. { -brand-short-name } blocca molti di questi traccianti e altri script dannosi.
content-blocking-learn-more = Ulteriori informazioni
content-blocking-fpi-incompatibility-warning = La funzione First Party Isolation (FPI) è al momento attiva e sostituisce alcune impostazioni di { -brand-short-name } relative ai cookie.
content-blocking-rfp-incompatibility-warning = La funzione Resist Fingerprinting (RFP) è al momento attiva e sostituisce alcune impostazioni di { -brand-short-name } relative alla protezione dai fingerprinter. Questo potrebbe causare il malfunzionamento di alcuni siti.

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
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
content-blocking-cross-site-cookies-in-all-windows2 = Cookie intersito in tutte le finestre
content-blocking-cross-site-tracking-cookies = Cookie traccianti intersito
content-blocking-all-cross-site-cookies-private-windows = Cookie traccianti intersito in finestre anonime
content-blocking-cross-site-tracking-cookies-plus-isolate = Cookie traccianti intersito, isola i cookie restanti
content-blocking-social-media-trackers = Traccianti dei social media
content-blocking-all-cookies = Tutti i cookie
content-blocking-unvisited-cookies = Cookie da siti web non visitati
content-blocking-all-windows-tracking-content = Contenuti traccianti in qualunque finestra
content-blocking-all-cross-site-cookies = Tutti i cookie intersito
content-blocking-cryptominers = Cryptominer
content-blocking-fingerprinters = Fingerprinter
content-blocking-known-and-suspected-fingerprinters = Fingerprinter conosciuti e sospetti

# The tcp-rollout strings are no longer used for the rollout but for tcp-by-default in the standard section

# "Contains" here means "isolates", "limits".
content-blocking-etp-standard-tcp-rollout-description = La Protezione totale per i cookie isola i cookie del sito in cui ti trovi. In questo modo non è possibile utilizzarli per seguirti da un sito all’altro.
content-blocking-etp-standard-tcp-rollout-learn-more = Ulteriori informazioni
content-blocking-etp-standard-tcp-title = Include Protezione totale per i cookie, lo strumento più potente per la protezione della privacy che abbiamo mai realizzato
content-blocking-warning-title = Attenzione
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
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Cryptominer
    .accesskey = y
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Fingerprinter
    .accesskey = F
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
#
# The known fingerprinters are those that are known for collecting browser fingerprints from user devices.
content-blocking-known-fingerprinters-label =
    .label = Fingerprinter conosciuti
    .accesskey = F
# The suspected fingerprinters are those that we are uncertain about browser fingerprinting activities. But they could
# possibly acquire browser fingerprints because of the behavior on accessing APIs that expose browser fingerprints.
content-blocking-suspected-fingerprinters-label =
    .label = Sospetti fingerprinter
    .accesskey = S

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
# Short form for "the act of choosing sound output devices and redirecting audio to the chosen devices".
permissions-speaker = Selezione altoparlanti
permissions-speaker-settings =
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
# "popup" is a misspelling that is more popular than the correct spelling of
# "pop-up" so it's included as a search keyword, not displayed in the UI.
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
collection-header2 = Raccolta e utilizzo dati di { -brand-short-name }
    .searchkeywords = telemetria
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
privacy-segmentation-section-header = Nuove funzioni per migliorare la navigazione
privacy-segmentation-section-description = Quando introduciamo nuove funzioni che utilizzano i tuoi dati per offrire un’esperienza più personale:
privacy-segmentation-radio-off =
    .label = Usa le impostazioni consigliate da { -brand-product-name }
privacy-segmentation-radio-on =
    .label = Mostra informazioni dettagliate

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

## DoH Section

preferences-doh-header = DNS su HTTPS
preferences-doh-description = Il meccanismo di risoluzione dei nomi di dominio tramite HTTPS (DNS su HTTPS) invia le richieste per i nomi di dominio tramite una connessione crittata, creando un sistema sicuro che rende più difficile ad altri soggetti scoprire quali siti stai per visitare.
# Variables:
#   $status (string) - The status of the DoH connection
preferences-doh-status = Stato: { $status }
# Variables:
#   $name (string) - The name of the DNS over HTTPS resolver. If a custom resolver is used, the name will be the domain of the URL.
preferences-doh-resolver = Fornitore: { $name }
# This is displayed instead of $name in preferences-doh-resolver
# when the DoH URL is not a valid URL
preferences-doh-bad-url = URL non valido
preferences-doh-steering-status = Fornitore locale in uso
preferences-doh-status-active = Attivo
preferences-doh-status-disabled = Disattivato
# Variables:
#   $reason (string) - A string representation of the reason DoH is not active. For example NS_ERROR_UNKNOWN_HOST or TRR_RCODE_FAIL.
preferences-doh-status-not-active = Non attivo ({ $reason })
preferences-doh-group-message = Attiva DNS sicuro utilizzando:
preferences-doh-expand-section =
    .tooltiptext = Ulteriori informazioni
preferences-doh-setting-default =
    .label = Protezione predefinita
    .accesskey = d
preferences-doh-default-desc = { -brand-short-name } decide quando utilizzare un DNS sicuro per proteggere la tua privacy.
preferences-doh-default-detailed-desc-1 = Utilizza un DNS sicuro nei Paesi in cui è disponibile
preferences-doh-default-detailed-desc-2 = Utilizza il sistema predefinito di risoluzione dei nomi se si verifica un problema con il fornitore di DNS sicuro
preferences-doh-default-detailed-desc-3 = Utilizza un fornitore locale dove possibile
preferences-doh-default-detailed-desc-4 = Disattiva in presenza di VPN, controllo parentale o criteri a livello aziendale
preferences-doh-default-detailed-desc-5 = Disattiva nel caso in cui la rete richieda a { -brand-short-name } di non utilizzare un DNS sicuro
preferences-doh-setting-enabled =
    .label = Protezione maggiore
    .accesskey = o
preferences-doh-enabled-desc = Puoi decidere quando utilizzare un DNS sicuro e scegliere il fornitore.
preferences-doh-enabled-detailed-desc-1 = Utilizza il fornitore che hai selezionato
preferences-doh-enabled-detailed-desc-2 = Utilizza il sistema predefinito di risoluzione dei nomi solo se si verifica un problema con il DNS sicuro
preferences-doh-setting-strict =
    .label = Protezione massima
    .accesskey = m
preferences-doh-strict-desc = { -brand-short-name } utilizzerà sempre un DNS sicuro. Verrà visualizzato un avviso prima di utilizzare il DNS di sistema.
preferences-doh-strict-detailed-desc-1 = Utilizza solo il fornitore che hai selezionato
preferences-doh-strict-detailed-desc-2 = Avvisa sempre se il DNS sicuro non è disponibile
preferences-doh-strict-detailed-desc-3 = Se il DNS sicuro non è disponibile, i siti potrebbero non caricarsi o non funzionare correttamente
preferences-doh-setting-off =
    .label = Disattivato
    .accesskey = O
preferences-doh-off-desc = Utilizza il sistema predefinito di risoluzione dei nomi
preferences-doh-checkbox-warn =
    .label = Avvisa se un soggetto di terze parti impedisce l’utilizzo del DNS sicuro
    .accesskey = A
preferences-doh-select-resolver = Scegli il fornitore:
preferences-doh-exceptions-description = { -brand-short-name } non utilizzerà il DNS sicuro in questi siti
preferences-doh-manage-exceptions =
    .label = Gestisci eccezioni…
    .accesskey = z

## The following strings are used in the Download section of settings

desktop-folder-name = Desktop
downloads-folder-name = Download
choose-download-folder-title = Selezionare la cartella di download:





