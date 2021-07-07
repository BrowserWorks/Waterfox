# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

### These strings are used in DevTools’ performance-new panel, about:profiling, and
### the remote profiling panel. There are additional profiler strings in the appmenu.ftl
### file that are used for the profiler popup.

perftools-intro-title = Impostazioni profiler
perftools-intro-description =
  L’avvio di una nuova registrazione apre profiler.firefox.com in una nuova
  scheda. Tutti i dati vengono conservati sul dispositivo, ma è possibile
  scegliere di pubblicarli per condividerli.

## All of the headings for the various sections.

perftools-heading-settings = Impostazioni complete
perftools-heading-buffer = Impostazioni buffer
perftools-heading-features = Funzioni
perftools-heading-features-default = Funzioni di base (è consigliato mantenerle attive)
perftools-heading-features-disabled = Funzioni disattivate
perftools-heading-features-experimental = Sperimentali
perftools-heading-threads = Thread
perftools-heading-local-build = Build locale

##

perftools-description-intro =
  L’avvio di una nuova registrazione apre <a>profiler.firefox.com</a> in una
  nuova scheda. Tutti i dati vengono conservati sul dispositivo, ma è possibile
  scegliere di pubblicarli per condividerli.
perftools-description-local-build =
  Se si sta creando il profilo di una build compilata localmente su questo
  dispositivo, aggiungere la cartella “objdir” della build all’elenco seguente
  affinché possa essere utilizzata per la ricerca di informazioni sui simboli.

## The controls for the interval at which the profiler samples the code.

perftools-range-interval-label = Intervallo di campionamento:
perftools-range-interval-milliseconds = {NUMBER($interval, maxFractionalUnits: 2)} ms

##

# The size of the memory buffer used to store things in the profiler.
perftools-range-entries-label = Dimensione buffer:

perftools-custom-threads-label = Aggiungere i nomi dei thread personalizzati:

perftools-devtools-interval-label = Intervallo:
perftools-devtools-threads-label = Thread:
perftools-devtools-settings-label = Impostazioni

## Various statuses that affect the current state of profiling, not typically displayed.

perftools-status-private-browsing-notice =
  Il profiler è disattivato quanto la navigazione anonima è in uso. Chiudere
  tutte le finestre anonime per riattivare il profiler.
perftools-status-recording-stopped-by-another-tool = La registrazione è stata bloccata da un altro strumento.
perftools-status-restart-required = È necessario riavviare il browser per attivare questa funzione.

## These are shown briefly when the user is waiting for the profiler to respond.

perftools-request-to-stop-profiler = Interruzione registrazione in corso
perftools-request-to-get-profile-and-stop-profiler = Acquisizione profilo in corso

##

perftools-button-start-recording = Avvia registrazione
perftools-button-capture-recording = Acquisizione registrazione
perftools-button-cancel-recording = Annulla registrazione
perftools-button-save-settings = Salva impostazioni e torna indietro
perftools-button-restart = Riavvia
perftools-button-add-directory = Aggiungi una cartella
perftools-button-remove-directory = Rimuovi selezionate
perftools-button-edit-settings = Modifica impostazioni…

## These messages are descriptions of the threads that can be enabled for the profiler.

perftools-thread-gecko-main =
  .title = I processi principali sia per il processo “parent” che per i processi per i contenuti
perftools-thread-compositor =
  .title = Combina i diversi elementi disegnati della pagina
perftools-thread-dom-worker =
  .title = Gestisce sia web worker che service worker
perftools-thread-renderer =
  .title = Quando WebRender è attivo, il thread che esegue le chiamate OpenGL
perftools-thread-render-backend =
  .title = Il thread WebRender RenderBackend
perftools-thread-paint-worker =
  .title = Quando è attivo il painting fuori dal thread principale (“off-main-thread”), il painting viene eseguito in questo thread
perftools-thread-style-thread =
  .title = Il calcolo degli stili viene eseguito in thread multipli
pref-thread-stream-trans =
  .title = Network stream transport
perftools-thread-socket-thread =
  .title = Il thread in cui il codice di rete esegue qualsiasi chiamata bloccante ai socket
perftools-thread-img-decoder =
  .title = Thread per la decodifica delle immagini
perftools-thread-dns-resolver =
  .title = La risoluzione DNS viene eseguita in questo thread

perftools-thread-task-controller =
  .title = Thread del pool TaskController

##

perftools-record-all-registered-threads =
  Ignora gli elementi selezionati e registra tutti i thread registrati

perftools-tools-threads-input-label =
  .title = Elenco di nomi di thread, separati da virgole, utilizzato per attivare la profilazione di thread specifici nel profiler. È sufficiente una corrispondenza parziale con il nome del thread affinché venga incluso. Gli spazi sono significativi.

## Onboarding UI labels. These labels are displayed in the new performance panel UI, when
## both devtools.performance.new-panel-onboarding & devtools.performance.new-panel-enabled
## preferences are true.

perftools-onboarding-message = <b>Novità</b>: { -profiler-brand-name } ora è integrato negli strumenti di sviluppo. <a>Scopri altre informazioni</a> su questo potente strumento.

# `options-context-advanced-settings` is defined in toolbox-options.ftl
perftools-onboarding-reenable-old-panel = (per un periodo limitato di tempo sarà possibile accedere al pannello Prestazioni originale tramite <a>{ options-context-advanced-settings }</a>)

perftools-onboarding-close-button =
  .aria-label = Chiudi il messaggio introduttivo

perftools-presets-web-developer-description = Preset consigliato per il debug della maggior parte delle applicazioni web, con overhead limitato.
perftools-presets-web-developer-label = Sviluppo web

perftools-presets-firefox-platform-description = Preset consigliato per il debug degli aspetti interni della piattaforma di Waterfox.
perftools-presets-firefox-platform-label = Waterfox - Piattaforma

perftools-presets-firefox-front-end-description = Preset consigliato per il debug degli aspetti interni dell’interfaccia (front-end) di Waterfox.
perftools-presets-firefox-front-end-label = Waterfox - Front-end

perftools-presets-firefox-graphics-description = Preset consigliato per l’analisi delle prestazioni grafiche di Waterfox.
perftools-presets-firefox-graphics-label = Waterfox - Grafica

perftools-presets-media-description = Preset consigliato per la diagnosi di problemi audio e video.
perftools-presets-media-label = Multimediale

perftools-presets-custom-label = Personalizzato
