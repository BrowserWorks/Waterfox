# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## App Menu

appmenuitem-update-banner3 =
    .label-update-downloading = Download aggiornamento di { -brand-shorter-name } in corso
    .label-update-available = Aggiornamento disponibile — scarica adesso
    .label-update-manual = Aggiornamento disponibile — scarica adesso
    .label-update-unsupported = Aggiornamento non riuscito - sistema non compatibile
    .label-update-restart = Aggiornamento disponibile — riavvia adesso
appmenuitem-protection-dashboard-title = Pannello protezioni
appmenuitem-new-tab =
    .label = Nuova scheda
appmenuitem-new-window =
    .label = Nuova finestra
appmenuitem-new-private-window =
    .label = Nuova finestra anonima
appmenuitem-history =
    .label = Cronologia
appmenuitem-downloads =
    .label = Download
appmenuitem-passwords =
    .label = Password
appmenuitem-addons-and-themes =
    .label = Estensioni e temi
appmenuitem-print =
    .label = Stampa…
appmenuitem-find-in-page =
    .label = Trova nella pagina…
appmenuitem-zoom =
    .value = Zoom
appmenuitem-more-tools =
    .label = Altri strumenti
appmenuitem-help =
    .label = Aiuto
appmenuitem-exit2 =
    .label = Esci
appmenu-menu-button-closed2 =
    .tooltiptext = Apri menu applicazione
    .label = { -brand-short-name }
appmenu-menu-button-opened2 =
    .tooltiptext = Chiudi menu applicazione
    .label = { -brand-short-name }
# Settings is now used to access the browser settings across all platforms,
# instead of Options or Preferences.
appmenuitem-settings =
    .label = Impostazioni

## Zoom and Fullscreen Controls

appmenuitem-zoom-enlarge =
    .label = Aumenta zoom
appmenuitem-zoom-reduce =
    .label = Riduci zoom
appmenuitem-fullscreen =
    .label = Schermo intero

## Waterfox Account toolbar button and Sync panel in App menu.

appmenu-remote-tabs-sign-into-sync =
    .label = Accedi per sincronizzare…
appmenu-remote-tabs-turn-on-sync =
    .label = Attiva sincronizzazione…
# This is shown after the tabs list if we can display more tabs by clicking on the button
appmenu-remote-tabs-showmore =
    .label = Mostra più schede
    .tooltiptext = Visualizza altre schede da questo dispositivo
# This is shown beneath the name of a device when that device has no open tabs
appmenu-remote-tabs-notabs = Nessuna scheda aperta
# This is shown when Sync is configured but syncing tabs is disabled.
appmenu-remote-tabs-tabsnotsyncing = Attiva la sincronizzazione delle schede per visualizzare le schede disponibili negli altri dispositivi.
appmenu-remote-tabs-opensettings =
    .label = Impostazioni
# This is shown when Sync is configured but this appears to be the only device attached to
# the account. We also show links to download Waterfox for android/ios.
appmenu-remote-tabs-noclients = Come fare per visualizzare in questa sezione le schede da altri dispositivi?
appmenu-remote-tabs-connectdevice =
    .label = Connetti un altro dispositivo
appmenu-remote-tabs-welcome = Visualizza un elenco delle schede aperte in altri dispositivi.
appmenu-remote-tabs-unverified = L’account non è ancora stato verificato.
appmenuitem-fxa-toolbar-sync-now2 = Sincronizza adesso
appmenuitem-fxa-sign-in = Accedi a { -brand-product-name }
appmenuitem-fxa-manage-account = Gestisci account
appmenu-fxa-header2 = { -fxaccount-brand-name(capitalization: "uppercase") }
# Variables
# $time (string) - Localized relative time since last sync (e.g. 1 second ago,
# 3 hours ago, etc.)
appmenu-fxa-last-sync = Ultima sincronizzazione: { $time }
    .label = Ultima sincronizzazione: { $time }
appmenu-fxa-sync-and-save-data2 = Sincronizza e salva i dati
appmenu-fxa-signed-in-label = Accedi
appmenu-fxa-setup-sync =
    .label = Attiva sincronizzazione…
appmenu-fxa-show-more-tabs = Mostra più schede
appmenuitem-save-page =
    .label = Salva pagina con nome…

## What's New panel in App menu.

whatsnew-panel-header = Novità
# Checkbox displayed at the bottom of the What's New panel, allowing users to
# enable/disable What's New notifications.
whatsnew-panel-footer-checkbox =
    .label = Notifica nuove funzionalità
    .accesskey = f

## The Waterfox Profiler – The popup is the UI to turn on the profiler, and record
## performance profiles. To enable it go to profiler.firefox.com and click
## "Enable Profiler Menu Button".

profiler-popup-button-idle =
    .label = Profiler
    .tooltiptext = Registra un profilo delle prestazioni
profiler-popup-button-recording =
  .label = Profiler
  .tooltiptext = Registrazione del profilo in corso…

profiler-popup-button-capturing =
  .label = Profiler
  .tooltiptext = Cattura del profilo in corso…
profiler-popup-title =
    .value = { -profiler-brand-name }
profiler-popup-reveal-description-button =
    .aria-label = Visualizza ulteriori informazioni
profiler-popup-description-title =
    .value = Registra, analizza, condividi
profiler-popup-description = Collabora su problemi di prestazioni pubblicando profili da condividere con il tuo team.
profiler-popup-learn-more = Ulteriori informazioni
profiler-popup-learn-more-button =
    .label = Ulteriori informazioni
profiler-popup-settings =
    .value = Impostazioni
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings = Modifica impostazioni…
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings-button =
    .label = Modifica impostazioni…
profiler-popup-disabled =
    Il profiler è attualmente disattivato, molto probabilmente perché ci sono
    delle finestre di navigazione anonima aperte.
profiler-popup-recording-screen = Registrazione in corso…
# The profiler presets list is generated elsewhere, but the custom preset is defined
# here only.
profiler-popup-presets-custom =
    .label = Personalizzato
profiler-popup-start-recording-button =
    .label = Avvia registrazione
profiler-popup-discard-button =
    .label = Rimuovi
profiler-popup-capture-button =
    .label = Acquisisci
profiler-popup-start-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧1
       *[other] Ctrl+Maiusc+1
    }
profiler-popup-capture-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧2
       *[other] Ctrl+Maiusc+2
    }

## Profiler presets
## They are shown in the popup's select box.


# Presets and their l10n IDs are defined in the file
# devtools/client/performance-new/popup/background.jsm.js
# Please take care that the same values are also defined in devtools' perftools.ftl.

profiler-popup-presets-web-developer-description = Preset consigliato per il debug della maggior parte delle applicazioni web, con overhead limitato.
profiler-popup-presets-web-developer-label =
    .label = Sviluppo web
profiler-popup-presets-firefox-platform-description = Preset consigliato per il debug degli aspetti interni della piattaforma di Waterfox.
profiler-popup-presets-firefox-platform-label =
    .label = Waterfox - Piattaforma
profiler-popup-presets-firefox-front-end-description = Preset consigliato per il debug degli aspetti interni dell’interfaccia (front-end) di Waterfox.
profiler-popup-presets-firefox-front-end-label =
    .label = Waterfox - Front-end
profiler-popup-presets-firefox-graphics-description = Preset consigliato per l’analisi delle prestazioni grafiche di Waterfox.
profiler-popup-presets-firefox-graphics-label =
    .label = Waterfox - Grafica
profiler-popup-presets-media-description = Preset consigliato per la diagnosi di problemi audio e video.
profiler-popup-presets-media-label =
    .label = Multimediale
profiler-popup-presets-custom-label =
    .label = Personalizzato

## History panel

appmenu-manage-history =
    .label = Gestisci cronologia
appmenu-reopen-all-tabs = Riapri tutte le schede
appmenu-reopen-all-windows = Riapri tutte le finestre
appmenu-restore-session =
    .label = Ripristina la sessione precedente
appmenu-clear-history =
    .label = Cancella la cronologia recente…
appmenu-recent-history-subheader = Cronologia recente
appmenu-recently-closed-tabs =
    .label = Schede chiuse di recente
appmenu-recently-closed-windows =
    .label = Finestre chiuse di recente

## Help panel

appmenu-help-header =
    .title = Aiuto per { -brand-shorter-name }
appmenu-about =
    .label = Informazioni su { -brand-shorter-name }
    .accesskey = I
appmenu-get-help =
    .label = Ottieni assistenza
    .accesskey = O
appmenu-help-more-troubleshooting-info =
    .label = Altre info per la risoluzione di problemi
    .accesskey = r
appmenu-help-report-site-issue =
    .label = Segnala problema con questo sito…
appmenu-help-feedback-page =
    .label = Invia feedback…
    .accesskey = k

## appmenu-help-enter-troubleshoot-mode and appmenu-help-exit-troubleshoot-mode
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-enter-troubleshoot-mode2 =
    .label = Modalità risoluzione problemi…
    .accesskey = M
appmenu-help-exit-troubleshoot-mode =
    .label = Disattiva Modalità risoluzione problemi
    .accesskey = m

## appmenu-help-report-deceptive-site and appmenu-help-not-deceptive
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-report-deceptive-site =
    .label = Segnala un sito ingannevole…
    .accesskey = e
appmenu-help-not-deceptive =
    .label = Non è un sito ingannevole…
    .accesskey = e

## More Tools

appmenu-customizetoolbar =
    .label = Personalizza barra degli strumenti…
appmenu-taskmanager =
    .label = Gestione attività
appmenu-developer-tools-subheader = Strumenti del browser
appmenu-developer-tools-extensions =
    .label = Estensioni per sviluppatori
