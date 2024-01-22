# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

browser-main-window-window-titles =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } Navigazione anonima
    .data-content-title-default = { $content-title } – { -brand-full-name }
    .data-content-title-private = { $content-title } – { -brand-full-name } Navigazione anonima

browser-main-window-mac-window-titles =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } – Navigazione anonima
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } – Navigazione anonima

# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

private-browsing-shortcut-text-2 = { -brand-shortcut-name } – Navigazione anonima

##

urlbar-identity-button =
    .aria-label = Visualizza informazioni sul sito

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Apri il pannello con il messaggio di installazione
urlbar-web-notification-anchor =
    .tooltiptext = Decidi se ricevere notifiche da questo sito
urlbar-midi-notification-anchor =
    .tooltiptext = Apri pannello MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = Gestisci l’utilizzo del software DRM
urlbar-web-authn-anchor =
    .tooltiptext = Apri pannello autenticazione web
urlbar-canvas-notification-anchor =
    .tooltiptext = Accedere ai dati dei canvas
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Gestisci la condivisione del microfono con il sito
urlbar-default-notification-anchor =
    .tooltiptext = Apri il pannello dei messaggi
urlbar-geolocation-notification-anchor =
    .tooltiptext = Apri il pannello con l’indirizzo della richiesta
urlbar-xr-notification-anchor =
    .tooltiptext = Apri il pannello dei permessi per la realtà virtuale
urlbar-storage-access-anchor =
    .tooltiptext = Apri il pannello relativo ai permessi per la navigazione
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Gestisci la condivisione delle finestre o dello schermo con il sito
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Apri il pannello con il messaggio relativo all’archiviazione non in linea per le app
urlbar-password-notification-anchor =
    .tooltiptext = Apri il pannello per il salvataggio delle password
urlbar-plugins-notification-anchor =
    .tooltiptext = Gestisci l’utilizzo dei plugin
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Gestisci la condivisione di fotocamera e/o microfono con il sito
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
urlbar-web-rtc-share-speaker-notification-anchor =
    .tooltiptext = Gestisci la condivisione di altri altoparlanti con il sito
urlbar-autoplay-notification-anchor =
    .tooltiptext = Apri il pannello relativo alla riproduzione automatica
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Salvataggio dati nell’archivio permanente
urlbar-addons-notification-anchor =
    .tooltiptext = Apri il pannello con il messaggio di installazione componente aggiuntivo
urlbar-tip-help-icon =
    .title = Ottieni assistenza
urlbar-search-tips-confirm = OK
urlbar-search-tips-confirm-short = OK
urlbar-tip-icon-description =
    .alt = Suggerimento:

urlbar-result-menu-button =
    .title = Apri menu
urlbar-result-menu-button-feedback = Feedback
    .title = Apri menu
urlbar-result-menu-learn-more =
    .label = Ulteriori informazioni
    .accesskey = U
urlbar-result-menu-remove-from-history =
    .label = Rimuovi dalla cronologia
    .accesskey = R
urlbar-result-menu-tip-get-help =
    .label = Ottieni assistenza
    .accesskey = a

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Scrivi di meno e trova più risultati: cerca con { $engineName } direttamente dalla barra degli indirizzi.
urlbar-search-tips-redirect-2 = Inizia le tue ricerche dalla barra degli indirizzi per visualizzare suggerimenti da { $engineName } e dalla cronologia di navigazione.

urlbar-search-tips-persist = Cercare è diventato ancora più semplice. Prova a rendere la tua ricerca più specifica qui nella barra degli indirizzi. Se invece preferisci visualizzare l’indirizzo, visita il pannello Ricerca nelle impostazioni.

# Prompts users to use the Urlbar when they are typing in the domain of a
# search engine, e.g. google.com or amazon.com.
urlbar-tabtosearch-onboard = Seleziona questa scorciatoia per trovare ciò che ti serve più rapidamente.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Segnalibri
urlbar-search-mode-tabs = Schede
urlbar-search-mode-history = Cronologia

urlbar-search-mode-actions = Azioni

##

urlbar-geolocation-blocked =
    .tooltiptext = Il rilevamento della posizione è bloccato per questo sito web.
urlbar-xr-blocked =
    .tooltiptext = L’accesso ai dispositivi per realtà virtuale è bloccato per questo sito web.
urlbar-web-notifications-blocked =
    .tooltiptext = Le notifiche sono bloccate per questo sito web.
urlbar-camera-blocked =
    .tooltiptext = La fotocamera è bloccata per questo sito web.
urlbar-microphone-blocked =
    .tooltiptext = Il microfono è bloccato per questo sito web.
urlbar-screen-blocked =
    .tooltiptext = La condivisione dello schermo è bloccata per questo sito web.
urlbar-persistent-storage-blocked =
    .tooltiptext = Il salvataggio dati nell’archivio permanente è bloccato per questo sito web.
urlbar-popup-blocked =
    .tooltiptext = Sono state bloccate delle finestre pop-up per questo sito web web.
urlbar-autoplay-media-blocked =
    .tooltiptext = È stata bloccata la riproduzione automatica di contenuti sonori per questo sito web.
urlbar-canvas-blocked =
    .tooltiptext = È stato bloccato l’accesso ai dati dei canvas per questo sito web.
urlbar-midi-blocked =
    .tooltiptext = È stato bloccato l’accesso alle funzioni MIDI per questo sito web.
urlbar-install-blocked =
    .tooltiptext = È stata bloccata l’installazione di componenti aggiuntivi per questo sito.

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Modifica questo segnalibro ({ $shortcut })

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Aggiungi ai segnalibri ({ $shortcut })

## Page Action Context Menu

page-action-manage-extension2 =
    .label = Gestisci estensione…
    .accesskey = G
page-action-remove-extension2 =
    .label = Rimuovi estensione
    .accesskey = v

## Auto-hide Context Menu

full-screen-autohide =
    .label = Nascondi barre degli strumenti
    .accesskey = N
full-screen-exit =
    .label = Esci da schermo intero
    .accesskey = E

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Adesso cerca con:

search-one-offs-change-settings-compact-button =
    .tooltiptext = Modifica le impostazioni di ricerca

search-one-offs-context-open-new-tab =
    .label = Cerca in una nuova scheda
    .accesskey = n
search-one-offs-context-set-as-default =
    .label = Imposta come motore di ricerca predefinito
    .accesskey = m
search-one-offs-context-set-as-default-private =
    .label = Imposta come motore di ricerca predefinito in finestre anonime
    .accesskey = a

# Search engine one-off buttons with an @alias shortcut/keyword.
# Variables:
#  $engineName (String): The name of the engine.
#  $alias (String): The @alias shortcut/keyword.
search-one-offs-engine-with-alias =
    .tooltiptext = { $engineName } ({ $alias })

# Shown when adding new engines from the address bar shortcut buttons or context
# menu, or from the search bar shortcut buttons.
# Variables:
#  $engineName (String): The name of the engine.
search-one-offs-add-engine =
    .label = Aggiungi “{ $engineName }”
    .tooltiptext = Aggiungi motore di ricerca “{ $engineName }”
    .aria-label = Aggiungi motore di ricerca “{ $engineName }”
# When more than 5 engines are offered by a web page, they are grouped in a
# submenu using this as its label.
search-one-offs-add-engine-menu =
    .label = Aggiungi motore di ricerca

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).

search-one-offs-bookmarks =
    .tooltiptext = Segnalibri ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Schede ({ $restrict })
search-one-offs-history =
    .tooltiptext = Cronologia ({ $restrict })

search-one-offs-actions =
    .tooltiptext = Azioni ({ $restrict })

## QuickActions are shown in the urlbar as the user types a matching string
## The -cmd- strings are comma separated list of keywords that will match
## the action.

quickactions-addons = Visualizza componenti aggiuntivi
quickactions-cmd-addons2 = componenti aggiuntivi

quickactions-bookmarks2 = Gestisci segnalibri
quickactions-cmd-bookmarks = segnalibri

quickactions-clearhistory = Cancella cronologia
quickactions-cmd-clearhistory = cancella cronologia

quickactions-downloads2 = Mostra download
quickactions-cmd-downloads = download

quickactions-extensions = Gestisci estensioni
quickactions-cmd-extensions = estensioni

quickactions-inspector2 = Apri strumenti di sviluppo
quickactions-cmd-inspector = analisi pagina, devtools, sviluppatori

quickactions-logins2 = Gestisci password
quickactions-cmd-logins = credenziali, password

quickactions-plugins = Gestisci plugin
quickactions-cmd-plugins = plugin

quickactions-print2 = Stampa pagina
quickactions-cmd-print = stampa

quickactions-private2 = Apri finestra anonima
quickactions-cmd-private = navigazione anonima, incognito

quickactions-refresh = Ripristina { -brand-short-name }
quickactions-cmd-refresh = ripristina

quickactions-restart = Riavvia { -brand-short-name }
quickactions-cmd-restart = riavvia

quickactions-screenshot3 = Cattura schermata
quickactions-cmd-screenshot = schermata, screenshot

quickactions-settings2 = Gestisci impostazioni
quickactions-cmd-settings = impostazioni, preferenze, opzioni

quickactions-themes = Gestisci temi
quickactions-cmd-themes = temi

quickactions-update = Aggiorna { -brand-short-name }
quickactions-cmd-update = aggiorna

quickactions-viewsource2 = Visualizza sorgente pagina
quickactions-cmd-viewsource = visualizza sorgente, sorgente

# Tooltip text for the help button shown in the result.
quickactions-learn-more =
    .title = Ulteriori informazioni sulle azioni rapide

## Bookmark Panel

bookmarks-add-bookmark = Aggiungi segnalibro
bookmarks-edit-bookmark = Modifica segnalibro
bookmark-panel-cancel =
    .label = Annulla
    .accesskey = A
# Variables:
#  $count (number): number of bookmarks that will be removed
bookmark-panel-remove =
    .label =
        { $count ->
            [1] Elimina segnalibro
           *[other] Elimina { $count } segnalibri
        }
    .accesskey = s
bookmark-panel-show-editor-checkbox =
    .label = Visualizza editor quando si salva
    .accesskey = V
bookmark-panel-save-button =
    .label = Salva

# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 28em

## Identity Panel

# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-site-information = Informazioni sito { $host }
# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-header-security-with-host =
    .title = Sicurezza connessione per { $host }
identity-connection-not-secure = Connessione non sicura
identity-connection-secure = Connessione sicura
identity-connection-failure = Errore di connessione
identity-connection-internal = Questa è una pagina sicura di { -brand-short-name }.
identity-connection-file = Questa pagina è salvata sul dispositivo in uso.
identity-extension-page = Questa pagina è caricata da un’estensione.
identity-active-blocked = Alcuni elementi non sicuri di questa pagina sono stati bloccati da { -brand-short-name }.
identity-custom-root = Connessione verificata da un certificato emesso da un’autorità non riconosciuta da BrowserWorks.
identity-passive-loaded = Alcuni elementi di questa pagina non sono sicuri (ad esempio immagini).
identity-active-loaded = La protezione è disattivata per questa pagina.
identity-weak-encryption = Questa pagina utilizza una crittografia debole.
identity-insecure-login-forms = Gli accessi effettuati in questa pagina potrebbero essere vulnerabili.

identity-https-only-connection-upgraded = (aggiornato a HTTPS)
identity-https-only-label = Modalità solo HTTPS
identity-https-only-label2 = Aggiorna automaticamente questo sito a una connessione sicura
identity-https-only-dropdown-on =
    .label = Attiva
identity-https-only-dropdown-off =
    .label = Disattivata
identity-https-only-dropdown-off-temporarily =
    .label = Disattivata temporaneamente
identity-https-only-info-turn-on2 = Attivare la modalità solo HTTPS per fare in modo che { -brand-short-name } aggiorni la connessione quando possibile.
identity-https-only-info-turn-off2 = Se la pagina non funziona correttamente, provare a disattivare per questo sito la modalità solo HTTPS per ricaricare utilizzando una connessione non sicura HTTP.
identity-https-only-info-turn-on3 = Attiva l’aggiornamento a HTTPS per questo sito per fare in modo che { -brand-short-name } aggiorni la connessione quando possibile.
identity-https-only-info-turn-off3 = Se la pagina non funziona correttamente, prova a disattivare l’aggiornamento a HTTPS per questo sito. Il sito verrà ricaricato usando una connessione HTTP non sicura.
identity-https-only-info-no-upgrade = Impossibile aggiornare la connessione da HTTP.

identity-permissions-storage-access-header = Cookie intersito
identity-permissions-storage-access-hint = Questi soggetti possono utilizzare cookie intersito e dati dei siti web quando ti trovi in questo sito.
identity-permissions-storage-access-learn-more = Ulteriori informazioni

identity-permissions-reload-hint = Potrebbe essere necessario ricaricare la pagina per rendere effettive le modifiche.
identity-clear-site-data =
    .label = Elimina cookie e dati dei siti web…
identity-connection-not-secure-security-view = La connessione con questo sito non è sicura.
identity-connection-verified = La connessione con questo sito è sicura.
identity-ev-owner-label = Certificato rilasciato a:
identity-description-custom-root2 = BrowserWorks non riconosce il soggetto che ha emesso questo certificato. Potrebbe essere stato aggiunto dal sistema operativo o da un amministratore.
identity-remove-cert-exception =
    .label = Elimina eccezione
    .accesskey = E
identity-description-insecure = La connessione con questo sito non è privata. Le informazioni inviate, come ad esempio password, messaggi, dati delle carte di credito, ecc. potrebbero essere visibili ad altri soggetti.
identity-description-insecure-login-forms = Le credenziali di accesso inserite in questa pagina non sono sicure e potrebbero essere vulnerabili.
identity-description-weak-cipher-intro = La connessione con questo sito web utilizza una crittografia debole e non è privata.
identity-description-weak-cipher-risk = Altri soggetti potrebbero visualizzare le informazioni trasmesse o modificare il comportamento del sito.
identity-description-active-blocked2 = Alcuni elementi non sicuri di questa pagina sono stati bloccati da { -brand-short-name }.
identity-description-passive-loaded = La connessione non è privata e le informazioni trasmesse al sito potrebbero essere visibili ad altri soggetti.
identity-description-passive-loaded-insecure2 = Alcuni elementi di questo sito web non sono sicuri (ad esempio immagini).
identity-description-passive-loaded-mixed2 = Nonostante alcuni elementi siano stati bloccati da { -brand-short-name }, in questa pagina sono ancora presenti elementi non sicuri (ad esempio immagini).
identity-description-active-loaded = La connessione con questo sito web non è sicura in quanto presenta contenuti non sicuri (ad esempio script).
identity-description-active-loaded-insecure = Le informazioni inviate, come ad esempio password, messaggi, dati delle carte di credito, ecc. potrebbero essere visibili ad altri soggetti.
identity-disable-mixed-content-blocking =
    .label = Disattiva temporaneamente protezione
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = Attiva protezione
    .accesskey = A
identity-more-info-link-text =
    .label = Ulteriori informazioni

## Window controls

browser-window-minimize-button =
    .tooltiptext = Riduci a icona
browser-window-maximize-button =
    .tooltiptext = Ingrandisci
browser-window-restore-down-button =
    .tooltiptext = Ripristina giù
browser-window-close-button =
    .tooltiptext = Chiudi

## Tab actions

# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-playing2 = RIPRODUZIONE IN CORSO
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-muted2 = AUDIO DISATTIVATO
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-blocked = RIPRODUZ. AUTOMATICA BLOCCATA
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-pip = PICTURE-IN-PICTURE

## These labels should be written in all capital letters if your locale supports them.
## Variables:
##  $count (number): number of affected tabs

browser-tab-mute =
    { $count ->
        [1] DISATTIVA AUDIO
       *[other] DISATTIVA AUDIO ({ $count } SCHEDE)
    }

browser-tab-unmute =
    { $count ->
        [1] ATTIVA AUDIO
       *[other] ATTIVA AUDIO ({ $count } SCHEDE)
    }

browser-tab-unblock =
    { $count ->
        [1] AVVIA RIPRODUZIONE
       *[other] AVVIA RIPRODUZIONE ({ $count } SCHEDE)
    }

## Bookmarks toolbar items

browser-import-button2 =
    .label = Importa segnalibri…
    .tooltiptext = Importa i segnalibri di un altro browser in { -brand-short-name }.

bookmarks-toolbar-empty-message = Salva i tuoi segnalibri qui, nella barra dei segnalibri, per accedervi più rapidamente. <a data-l10n-name="manage-bookmarks">Gestisci i segnalibri…</a>

## WebRTC Pop-up notifications

popup-select-camera-device =
    .value = Fotocamera:
    .accesskey = F
popup-select-camera-icon =
    .tooltiptext = Fotocamera
popup-select-microphone-device =
    .value = Microfono:
    .accesskey = M
popup-select-microphone-icon =
    .tooltiptext = Microfono
popup-select-speaker-icon =
    .tooltiptext = Altoparlanti
popup-select-window-or-screen =
    .label = Finestra o schermo:
    .accesskey = F
popup-all-windows-shared = Tutte le finestre visibili sullo schermo verranno condivise.

## WebRTC window or screen share tab switch warning

sharing-warning-window = { -brand-short-name } è attualmente condiviso. Altre persone possono vedere quando passi a un’altra scheda.
sharing-warning-screen = L’intero schermo è attualmente condiviso. Altre persone possono vedere quando passi a un’altra scheda.
sharing-warning-proceed-to-tab =
    .label = Passa alla scheda
sharing-warning-disable-for-session =
    .label = Disattiva avvisi relativi alla condivisione in questa sessione

## DevTools F12 popup

enable-devtools-popup-description2 = Per utilizzare la scorciatoia da tastiera F12, aprire prima gli strumenti di sviluppo usando il menu ”Strumenti del browser”.

## URL Bar

urlbar-placeholder =
    .placeholder = Cerca o inserisci un indirizzo

# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Cerca sul Web
    .aria-label = Cerca con { $name }

# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Immetti i termini di ricerca
    .aria-label = Cerca in { $name }

# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Immetti i termini di ricerca
    .aria-label = Cerca nei segnalibri

# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Immetti i termini di ricerca
    .aria-label = Cerca nella cronologia

# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Immetti i termini di ricerca
    .aria-label = Cerca nelle schede

# This placeholder is used when searching quick actions.
urlbar-placeholder-search-mode-other-actions =
    .placeholder = Immetti i termini di ricerca
    .aria-label = Cerca nelle azioni

# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Cerca con { $name } o inserisci un indirizzo

# Variables
#  $component (String): the name of the component which forces remote control.
#    Example: "DevTools", "Marionette", "RemoteAgent".
urlbar-remote-control-notification-anchor2 =
    .tooltiptext = Il browser è attualmente controllato da remoto (motivo: { $component })
urlbar-permissions-granted =
    .tooltiptext = Sono stati concessi permessi aggiuntivi a questo sito web.
urlbar-switch-to-tab =
    .value = Passa alla scheda:

# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Estensione:

urlbar-go-button =
    .tooltiptext = Vai all’URL inserito nella barra degli indirizzi
urlbar-page-action-button =
    .tooltiptext = Azioni per questa pagina

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".

# Used when the private browsing engine differs from the default engine.
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-in-private-w-engine = Cerca con { $engine } in una finestra anonima
# Used when the private browsing engine is the same as the default engine.
urlbar-result-action-search-in-private = Cerca in una finestra anonima
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-w-engine = Cerca con { $engine }
urlbar-result-action-sponsored = Sponsorizzato
urlbar-result-action-switch-tab = Passa alla scheda
urlbar-result-action-visit = Apri
# Allows the user to visit a URL that was previously copied to the clipboard.
urlbar-result-action-visit-from-your-clipboard = Apri indirizzo dagli appunti

# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-before-tabtosearch-web = Premi il tasto di tabulazione (TAB) per cercare con { $engine }
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-before-tabtosearch-other = Premi il tasto di tabulazione (TAB) per cercare in { $engine }
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-tabtosearch-web = Cerca con { $engine } direttamente dalla barra degli indirizzi
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-tabtosearch-other-engine = Cerca in { $engine } direttamente dalla barra degli indirizzi
# Action text for copying to clipboard.
urlbar-result-action-copy-to-clipboard = Copia
# Shows the result of a formula expression being calculated, the last = sign will be shown
# as part of the result (e.g. "= 2").
# Variables
#  $result (String): the string representation for a formula result
urlbar-result-action-calculator-result = = { $result }

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".
## In these actions "Search" is a verb, followed by where the search is performed.

urlbar-result-action-search-bookmarks = Cerca nei segnalibri
urlbar-result-action-search-history = Cerca nella cronologia
urlbar-result-action-search-tabs = Cerca nelle schede

urlbar-result-action-search-actions = Cerca nelle azioni

## Labels shown above groups of urlbar results

# A label shown above the "Waterfox Suggest" (bookmarks/history) group in the
# urlbar results.
urlbar-group-firefox-suggest =
    .label = { -firefox-suggest-brand-name }

# A label shown above the search suggestions group in the urlbar results. It
# should use title case.
# Variables
#  $engine (String): the name of the search engine providing the suggestions
urlbar-group-search-suggestions =
    .label = Suggerimenti da { $engine }

# A label shown above Quick Actions in the urlbar results.
urlbar-group-quickactions =
    .label = Azioni rapide

## Reader View toolbar buttons

# This should match menu-view-enter-readerview in menubar.ftl
reader-view-enter-button =
    .aria-label = Attiva Modalità lettura
# This should match menu-view-close-readerview in menubar.ftl
reader-view-close-button =
    .aria-label = Chiudi Modalità lettura

## Picture-in-Picture urlbar button
## Variables:
##   $shortcut (String) - Keyboard shortcut to execute the command.

picture-in-picture-urlbar-button-open =
    .tooltiptext = Apri Picture-in-Picture ({ $shortcut })

picture-in-picture-urlbar-button-close =
    .tooltiptext = Chiudi Picture-in-Picture ({ $shortcut })

picture-in-picture-panel-header = Picture-in-Picture
picture-in-picture-panel-headline = Questo sito web sconsiglia l’utilizzo di Picture-in-Picture
picture-in-picture-panel-body = I video potrebbero non essere visualizzati come previsto dallo sviluppatore utilizzando Picture-in-Picture.
picture-in-picture-enable-toggle =
  .label = Attiva comunque

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> è ora visualizzato a schermo intero
fullscreen-warning-no-domain = Questo documento è ora visualizzato a schermo intero


fullscreen-exit-button = Esci da schermo intero (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Esci da schermo intero (esc)

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> sta controllando il puntatore del mouse. Premere Esc per riprenderne il controllo.
pointerlock-warning-no-domain = Questo documento sta controllando il puntatore del mouse. Premere Esc per riprenderne il controllo.

## Subframe crash notification

## Bookmarks panels, menus and toolbar

bookmarks-manage-bookmarks =
    .label = Gestisci segnalibri
bookmarks-recent-bookmarks-panel-subheader = Segnalibri recenti
bookmarks-toolbar-chevron =
    .tooltiptext = Visualizza altri segnalibri
bookmarks-sidebar-content =
    .aria-label = Segnalibri
bookmarks-menu-button =
    .label = Menu segnalibri
bookmarks-other-bookmarks-menu =
    .label = Altri segnalibri
bookmarks-mobile-bookmarks-menu =
    .label = Segnalibri da dispositivi mobile

## Variables:
##   $isVisible (boolean): if the specific element (e.g. bookmarks sidebar,
##                         bookmarks toolbar, etc.) is visible or not.

bookmarks-tools-sidebar-visibility =
    .label =
        { $isVisible ->
            [true] Nascondi la barra laterale dei segnalibri
           *[other] Visualizza la barra laterale dei segnalibri
        }
bookmarks-tools-toolbar-visibility-menuitem =
    .label =
        { $isVisible ->
            [true] Nascondi la barra dei segnalibri
           *[other] Visualizza la barra dei segnalibri
        }
bookmarks-tools-toolbar-visibility-panel =
    .label =
        { $isVisible ->
            [true] Nascondi la barra dei segnalibri
           *[other] Visualizza la barra dei segnalibri
        }
bookmarks-tools-menu-button-visibility =
    .label =
        { $isVisible ->
            [true] Rimuovi Segnalibri dalla barra degli strumenti
           *[other] Aggiungi Segnalibri alla barra degli strumenti
        }

##

bookmarks-search =
    .label = Cerca nei segnalibri
bookmarks-tools =
    .label = Strumenti per i segnalibri

bookmarks-subview-edit-bookmark =
    .label = Modifica segnalibro…

# The aria-label is a spoken label that should not include the word "toolbar" or
# such, because screen readers already know that this container is a toolbar.
# This avoids double-speaking.
bookmarks-toolbar =
    .toolbarname = Barra dei segnalibri
    .accesskey = s
    .aria-label = Segnalibri
bookmarks-toolbar-menu =
    .label = Barra dei segnalibri
bookmarks-toolbar-placeholder =
    .title = Elementi della barra dei segnalibri
bookmarks-toolbar-placeholder-button =
    .label = Elementi della barra dei segnalibri

bookmarks-subview-bookmark-tab =
    .label = Aggiungi scheda corrente ai segnalibri…

## Library Panel items

library-bookmarks-menu =
    .label = Segnalibri
library-recent-activity-title =
    .value = Attività recente

## Pocket toolbar button

save-to-pocket-button =
    .label = Salva in { -pocket-brand-name }
    .tooltiptext = Salva in { -pocket-brand-name }

## Repair text encoding toolbar button

repair-text-encoding-button =
    .label = Correggi codifica testo
    .tooltiptext = Cerca di identificare la codifica testo corretta in base al contenuto della pagina

## Customize Toolbar Buttons

# Variables:
#  $shortcut (String): keyboard shortcut to open settings (only on macOS)
toolbar-settings-button =
    .label = Impostazioni
    .tooltiptext =
        { PLATFORM() ->
            [macos] Apri le impostazioni ({ $shortcut })
           *[other] Apri le impostazioni
        }

toolbar-overflow-customize-button =
    .label = Personalizza barra degli strumenti…
    .accesskey = z

toolbar-button-email-link =
    .label = Invia link
    .tooltiptext = Invia link a questa pagina per email

toolbar-button-logins =
    .label = Password
    .tooltiptext = Visualizza e gestisci le password salvate

# Variables:
#  $shortcut (String): keyboard shortcut to save a copy of the page
toolbar-button-save-page =
    .label = Salva pagina
    .tooltiptext = Salva questa pagina ({ $shortcut })

# Variables:
#  $shortcut (String): keyboard shortcut to open a local file
toolbar-button-open-file =
    .label = Apri file
    .tooltiptext = Apri file ({ $shortcut })

toolbar-button-synced-tabs =
    .label = Schede sincronizzate
    .tooltiptext = Visualizza schede da altri dispositivi

# Variables
# $shortcut (string) - Keyboard shortcut to open a new private browsing window
toolbar-button-new-private-window =
    .label = Nuova finestra anonima
    .tooltiptext = Apri una nuova finestra anonima ({ $shortcut })

## EME notification panel

eme-notifications-drm-content-playing = Alcuni contenuti audio o video in questo sito utilizzano software DRM. Questo potrebbe limitare le azioni disponibili per l’utente in { -brand-short-name }.
eme-notifications-drm-content-playing-manage = Gestisci impostazioni
eme-notifications-drm-content-playing-manage-accesskey = G
eme-notifications-drm-content-playing-dismiss = Chiudi
eme-notifications-drm-content-playing-dismiss-accesskey = C

## Password save/update panel

panel-save-update-username = Nome utente
panel-save-update-password = Password

## Add-on removal warning

##

# "More" item in macOS share menu
menu-share-more =
    .label = Altro…
ui-tour-info-panel-close =
    .tooltiptext = Chiudi

## Variables:
##  $uriHost (String): URI host for which the popup was allowed or blocked.

popups-infobar-allow =
    .label = Consentire a { $uriHost } di aprire finestre pop-up
    .accesskey = P

popups-infobar-block =
    .label = Blocca finestre pop-up per { $uriHost }
    .accesskey = P

##

popups-infobar-dont-show-message =
    .label = Non mostrare questo messaggio quando vengono bloccate delle finestre pop-up
    .accesskey = N

edit-popup-settings =
    .label = Gestisci impostazioni pop-up…
    .accesskey = G

picture-in-picture-hide-toggle =
    .label = Nascondi selettore Picture-in-Picture
    .accesskey = N

## Since the default position for PiP controls does not change for RTL layout,
## right-to-left languages should use "Left" and "Right" as in the English strings,

picture-in-picture-move-toggle-right =
    .label = Sposta selettore Picture-in-Picture a destra
    .accesskey = d

picture-in-picture-move-toggle-left =
    .label = Sposta selettore Picture-in-Picture a sinistra
    .accesskey = s

##


# Navigator Toolbox

# This string is a spoken label that should not include
# the word "toolbar" or such, because screen readers already know that
# this container is a toolbar. This avoids double-speaking.
navbar-accessible =
    .aria-label = Navigazione

navbar-downloads =
    .label = Download

navbar-overflow =
    .tooltiptext = Altri strumenti…

# Variables:
#   $shortcut (String): keyboard shortcut to print the page
navbar-print =
    .label = Stampa
    .tooltiptext = Stampa questa pagina… ({ $shortcut })

navbar-home =
    .label = Pagina iniziale
    .tooltiptext = Pagina iniziale di { -brand-short-name }

navbar-library =
    .label = Libreria
    .tooltiptext = Visualizza cronologia, password salvate e altro ancora

navbar-search =
    .title = Cerca

# Name for the tabs toolbar as spoken by screen readers. The word
# "toolbar" is appended automatically and should not be included in
# in the string
tabs-toolbar =
    .aria-label = Schede del browser

tabs-toolbar-new-tab =
    .label = Nuova scheda

tabs-toolbar-list-all-tabs =
    .label = Elenco di tutte le schede
    .tooltiptext = Elenco di tutte le schede

## Infobar shown at startup to suggest session-restore

# <img data-l10n-name="icon"/> will be replaced by the application menu icon
restore-session-startup-suggestion-message = <strong>Vuoi riaprire le schede aperte in precedenza?</strong> È possibile ripristinare la sessione precedente dal menu <img data-l10n-name="icon"/> di { -brand-short-name }, nella sezione Cronologia.
restore-session-startup-suggestion-button = Mostra come fare

## BrowserWorks data reporting notification (Telemetry, Waterfox Health Report, etc)

data-reporting-notification-message = Alcune informazioni vengono inviate automaticamente a { -vendor-short-name } da { -brand-short-name } per migliorarne l’utilizzo.
data-reporting-notification-button =
    .label = Scegli cosa condividere
    .accesskey = S

private-browsing-indicator-label = Navigazione anonima

## Unified extensions (toolbar) button

unified-extensions-button =
    .label = Estensioni
    .tooltiptext = Estensioni

## Unified extensions button when permission(s) are needed.
## Note that the new line is intentionally part of the tooltip.

unified-extensions-button-permissions-needed =
    .label = Estensioni
    .tooltiptext =
        Estensioni
        Permessi richiesti

## Unified extensions button when some extensions are quarantined.
## Note that the new line is intentionally part of the tooltip.

unified-extensions-button-quarantined =
    .label = Estensioni
    .tooltiptext =
        Estensioni
        Alcune estensioni non sono consentite

## Autorefresh blocker

refresh-blocked-refresh-label = { -brand-short-name } ha impedito a questa pagina di ricaricarsi automaticamente.
refresh-blocked-redirect-label = { -brand-short-name } ha impedito a questa pagina il reindirizzamento automatico verso un’altra pagina.

refresh-blocked-allow =
    .label = Consenti
    .accesskey = C

## Waterfox Relay integration

## Popup Notification

firefox-relay-offer-why-to-use-relay = I nostri alias di posta elettronica, sicuri e facili da utilizzare, proteggono la tua identità e bloccano lo spam nascondendo il tuo indirizzo reale.

firefox-relay-offer-what-relay-provides = Tutte le email inviate al tuo alias verranno inoltrate a <strong>{ $useremail }</strong> (a meno che tu non decida di bloccarle).

firefox-relay-offer-legal-notice = Facendo clic su “Utilizza alias di posta elettronica”, accetti le <label data-l10n-name="tos-url">Condizioni di utilizzo del servizio</label> e l’<label data-l10n-name="privacy-url">Informativa sulla privacy</label>.

## Add-on Pop-up Notifications

popup-notification-addon-install-unsigned =
    .value = (non verificato)
popup-notification-xpinstall-prompt-learn-more = Scopri come installare componenti aggiuntivi in completa sicurezza

## Pop-up warning

# Variables:
#   $popupCount (Number): the number of pop-ups blocked.
popup-warning-message =
    { $popupCount ->
        [one] { -brand-short-name } ha impedito a questo sito di aprire una finestra pop-up.
       *[other] { -brand-short-name } ha impedito a questo sito di aprire { $popupCount } finestre pop-up.
    }
# The singular form is left out for English, since the number of blocked pop-ups is always greater than 1.
# Variables:
#   $popupCount (Number): the number of pop-ups blocked.
popup-warning-exceeded-message = { -brand-short-name } ha impedito a questo sito di aprire più di { $popupCount } finestre pop-up.
popup-warning-button =
    .label =
        { PLATFORM() ->
            [windows] Opzioni
           *[other] Preferenze
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] r
        }

# Variables:
#   $popupURI (String): the URI for the pop-up window
popup-show-popup-menuitem =
    .label = Visualizza “{ $popupURI }”


