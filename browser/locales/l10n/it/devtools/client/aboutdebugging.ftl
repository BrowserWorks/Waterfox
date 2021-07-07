# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

### These strings are used inside the about:debugging UI.

# Page Title strings

about-debugging-page-title-setup-page = Debugging - Impostazioni

about-debugging-page-title-runtime-page = Debugging - Runtime / { $selectedRuntimeId }

# Sidebar strings

about-debugging-this-firefox-runtime-name = Questo { -brand-shorter-name }

about-debugging-sidebar-this-firefox =
  .name = { about-debugging-this-firefox-runtime-name }

about-debugging-sidebar-setup =
  .name = Impostazioni

about-debugging-sidebar-usb-enabled = USB attivo

about-debugging-sidebar-usb-disabled = USB disattivato

aboutdebugging-sidebar-runtime-connection-status-connected = Connesso
aboutdebugging-sidebar-runtime-connection-status-disconnected = Disconnesso

about-debugging-sidebar-no-devices = Nessun dispositivo rilevato

about-debugging-sidebar-item-connect-button = Connetti

about-debugging-sidebar-item-connect-button-connecting = Connessione in corso…

about-debugging-sidebar-item-connect-button-connection-failed = Connessione non riuscita

about-debugging-sidebar-item-connect-button-connection-not-responding = Connessione ancora in sospeso, verificare la presenza di messaggi nel browser obiettivo

about-debugging-sidebar-item-connect-button-connection-timeout = Connessione fuori tempo massimo

about-debugging-sidebar-runtime-item-waiting-for-browser = In attesa del browser…

about-debugging-sidebar-runtime-item-unplugged = Disconnesso

about-debugging-sidebar-runtime-item-name =
  .title = { $displayName } ({ $deviceName })
about-debugging-sidebar-runtime-item-name-no-device =
  .title = { $displayName }

about-debugging-sidebar-support = Supporto per Debugging

about-debugging-sidebar-support-icon =
  .alt = Icona aiuto

about-debugging-refresh-usb-devices-button = Aggiorna dispositivi

# Setup Page strings

about-debugging-setup-title = Impostazioni

about-debugging-setup-intro = Configura il metodo di connessione da utilizzare per il debug remoto del dispositivo.

about-debugging-setup-this-firefox2 = Utilizza <a>{ about-debugging-this-firefox-runtime-name }</a> per effettuare il debug di estensioni e service worker in questa versione di { -brand-shorter-name }.

about-debugging-setup-connect-heading = Connetti un dispositivo

about-debugging-setup-usb-title = USB

about-debugging-setup-usb-disabled = Attivando questa opzione verranno scaricati e aggiunti a { -brand-shorter-name } i componenti Android USB necessari per il debug.

about-debugging-setup-usb-enable-button = Attiva dispositivi USB

about-debugging-setup-usb-disable-button = Disattiva dispositivi USB

about-debugging-setup-usb-updating-button = Aggiornamento in corso…

about-debugging-setup-usb-status-enabled = Attivo
about-debugging-setup-usb-status-disabled = Disattivato
about-debugging-setup-usb-status-updating = Aggiornamento in corso…

about-debugging-setup-usb-step-enable-dev-menu2 = Attiva il menu “Opzioni sviluppatori” sul dispositivo Android.

about-debugging-setup-usb-step-enable-debug2 = Attiva “Debug USB” nel menu “Opzioni sviluppatori” sul dispositivo Android.

about-debugging-setup-usb-step-enable-debug-firefox2 = Attiva USB Debugging in Waterfox sul dispositivo Android.

about-debugging-setup-usb-step-plug-device = Connetti il dispositivo Android al computer.

about-debugging-setup-usb-troubleshoot = Problemi con la connessione di un dispositivo USB? <a>Risoluzione dei problemi</a>

about-debugging-setup-network =
  .title = Percorso di rete

about-debugging-setup-network-troubleshoot = Problemi con la connessione via rete? <a>Risoluzione dei problemi</a>

about-debugging-network-locations-add-button = Aggiungi

about-debugging-network-locations-empty-text = Non è ancora stato aggiunto alcun percorso di rete.

about-debugging-network-locations-host-input-label = Host

about-debugging-network-locations-remove-button = Rimuovi

about-debugging-network-location-form-invalid = Host “{ $host-value }” non valido. Il formato previsto è “nome-host:numero-porta”.

about-debugging-network-location-form-duplicate = Host “{ $host-value }” è già registrato

# Runtime Page strings

about-debugging-runtime-temporary-extensions =
  .name = Estensioni temporanee
about-debugging-runtime-extensions =
  .name = Estensioni
about-debugging-runtime-tabs =
  .name = Schede
about-debugging-runtime-service-workers =
  .name = Service worker
about-debugging-runtime-shared-workers =
  .name = Worker condivisi
about-debugging-runtime-other-workers =
  .name = Altri worker
about-debugging-runtime-processes =
  .name = Processi

about-debugging-runtime-profile-button2 = Crea profilo prestazioni

about-debugging-runtime-service-workers-not-compatible = La configurazione del browser non è compatibile con l’utilizzo dei service worker.  <a>Ulteriori informazioni</a>

about-debugging-browser-version-too-old = Il browser connesso utilizza una versione obsoleta ({ $runtimeVersion }). La versione minima compatibile è ({ $minVersion }). Questa configurazione non è supportata e potrebbe impedire il corretto funzionamento degli strumenti di sviluppo. Aggiornare il browser connesso. <a>Risoluzione dei problemi</a>

about-debugging-browser-version-too-old-fennec = Non è possibile utilizzare questa versione di Waterfox per eseguire il debug di Waterfox per Android (68). Per effettuare test è consigliato installare Waterfox per Android Nightly sul telefono. <a>Ulteriori informazioni</a>

about-debugging-browser-version-too-recent = Il browser connesso ({ $runtimeVersion }, buildID { $runtimeID }) è più recente di quello in uso in { -brand-shorter-name } ({ $localVersion }, buildID { $localID }). Questa configurazione non è supportata e potrebbe impedire il corretto funzionamento degli strumenti di sviluppo. Aggiornare Waterfox. <a>Risoluzione dei problemi</a>

about-debugging-runtime-name = { $name } ({ $version })

about-debugging-runtime-disconnect-button = Disconnetti

about-debugging-connection-prompt-enable-button = Attiva richiesta di connessione

about-debugging-connection-prompt-disable-button = Disattiva richiesta di connessione

about-debugging-profiler-dialog-title2 = Profiler

about-debugging-collapse-expand-debug-targets = Comprimi/espandi

# Debug Targets strings

about-debugging-debug-target-list-empty = Nessun elemento.

about-debugging-debug-target-inspect-button = Analizza

about-debugging-tmp-extension-install-button = Carica componente aggiuntivo temporaneo…

about-debugging-tmp-extension-install-error = Si è verificato un errore durante l’installazione del componente aggiuntivo temporaneo.

about-debugging-tmp-extension-reload-button = Ricarica

about-debugging-tmp-extension-remove-button = Rimuovi

about-debugging-tmp-extension-install-message = Seleziona un file manifest.json o un archivio .xpi/.zip

about-debugging-tmp-extension-temporary-id = Questa WebExtension ha un ID temporaneo. <a>Ulteriori informazioni</a>

about-debugging-extension-manifest-url =
  .label = URL manifesto

about-debugging-extension-uuid =
  .label = UUID interno

about-debugging-extension-location =
  .label = Posizione

about-debugging-extension-id =
  .label = ID estensione

about-debugging-worker-action-push2 = Push
  .disabledTitle = “Push” è attualmente disattivato per service worker in { -brand-shorter-name } multiprocesso.

about-debugging-worker-action-start2 = Avvia
  .disabledTitle = “Avvia” è attualmente disattivato per service worker in { -brand-shorter-name } multiprocesso.

about-debugging-worker-action-unregister = Deregistra

about-debugging-worker-fetch-listening =
  .label = Fetch
  .value = In ascolto di eventi fetch

about-debugging-worker-fetch-not-listening =
  .label = Fetch
  .value = Non in ascolto di eventi fetch

about-debugging-worker-status-running = In esecuzione

about-debugging-worker-status-stopped = Bloccato

about-debugging-worker-status-registering = In registrazione

about-debugging-worker-scope =
  .label = Ambito

about-debugging-worker-push-service =
  .label = Servizio push

about-debugging-worker-inspect-action-disabled =
  .title = L’analisi di service worker è attualmente disattivata in { -brand-shorter-name } multiprocesso.

# Displayed as title of the inspect button for zombie tabs (e.g. tabs loaded via a session restore).
about-debugging-zombie-tab-inspect-action-disabled =
  .title = La scheda non è stata caricata completamente e non può essere analizzata

about-debugging-main-process-name = Processo principale

about-debugging-main-process-description2 = Processo principale per il browser obiettivo

about-debugging-multiprocess-toolbox-name = Cassetta degli attrezzi multiprocesso

about-debugging-multiprocess-toolbox-description = Processo principale e processi per i contenuti per il browser obiettivo

about-debugging-message-close-icon =
  .alt = Chiudi messaggio

about-debugging-message-details-label-error = Dettagli errore

about-debugging-message-details-label-warning = Dettagli avviso

about-debugging-message-details-label = Dettagli
