# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

### These strings are used inside the Application panel which is available
### by setting the preference `devtools-application-enabled` to true.

### The correct localization of this file might be to keep it in English, or another
### language commonly spoken among web developers. You want to make that choice consistent
### across the developer tools. A good criteria is the language in which you'd find the
### best documentation on web development on the web.

serviceworker-list-header = Service worker

serviceworker-list-aboutdebugging = Apri <a>about:debugging</a> per service worker da altri domini

serviceworker-worker-unregister = Deregistra

serviceworker-worker-debug = Avvia debug
  .title = Il debug è disponibile solo per service worker in esecuzione

# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
  .alt = Ispeziona

serviceworker-worker-start3 = Avvia

serviceworker-worker-updated = Ultimo aggiornamento: <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

serviceworker-worker-status-running = In esecuzione

serviceworker-worker-status-stopped = Bloccato

serviceworker-empty-intro2 = Non è stato trovato alcun service worker

serviceworker-empty-intro-link = Ulteriori informazioni

serviceworker-empty-suggestions2 = Se si ritiene che questa pagina debba mostrare un service worker, controllare la presenza di errori nella <a>Console</a> o analizzare passo per passo la registrazione del service worker nel <span>Debugger</span>.

serviceworker-empty-suggestions-aboutdebugging2 = Visualizza i service worker da altri domini

manifest-view-header = Manifesto dell’app

manifest-empty-intro2 = Non è stato trovato alcun manifesto web app

manifest-empty-intro-link = Scopri come aggiungere un manifesto

manifest-item-warnings = Errori e avvisi

manifest-item-identity = Identità

manifest-item-presentation = Presentazione

manifest-item-icons = Icone

manifest-loading = Caricamento manifesto in corso…

manifest-loaded-ok = Caricato manifesto.

manifest-loaded-error = Si è verificato un errore durante il caricamento del manifesto:

manifest-loaded-devtools-error = Errore in Waterfox DevTools

manifest-non-existing = Nessun manifesto trovato da analizzare.

manifest-json-link-data-url = Il manifesto è incorporato in un Data URL.

manifest-icon-purpose = Scopo: <code>{$purpose}</code>

manifest-icon-img =
  .alt = Icona

manifest-icon-img-title = Icona con dimensioni: {$sizes}

manifest-icon-img-title-no-sizes = Dimensioni icona non specificate

# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = Manifesto
  .alt = Icona manifesto
  .title = Manifesto

# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Service worker
  .alt = Icona service worker
  .title = Service worker

icon-warning =
  .alt = Icona avviso
  .title = Avviso

icon-error =
  .alt = Icona errore
  .title = Errore

