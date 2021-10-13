# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

### Strings used in about:unloads, allowing users to manage the "tab unloading"
### feature.

about-unloads-page-title = Scaricamento schede
about-unloads-intro =
    { -brand-short-name } include una funzione che permette di scaricare
    automaticamente le schede per impedire un arresto anomalo dell’applicazione
    nel caso in cui la memoria disponibile nel sistema diventi insufficiente. La
    scheda successiva da scaricare viene scelta in base a diversi criteri.
    Questa pagina mostra in che modo { -brand-short-name } assegna la priorità
    alle schede e la prossima scheda che verrà scaricata. È possibile
    scaricare manualmente una scheda utilizzando il pulsante <em>Scarica</em>.

# The link points to a Waterfox documentation page, only available in English,
# with title "Tab Unloading"
about-unloads-learn-more =
    Consultare il documento <a data-l10n-name="doc-link">Tab Unloading</a>
    per ulteriori informazioni su questa funzione e questa pagina.
about-unloads-intro-1 =
    { -brand-short-name } include una funzione che permette di scaricare
    automaticamente le schede per impedire un arresto anomalo dell’applicazione
    nel caso in cui la memoria disponibile nel sistema diventi insufficiente. La
    scheda successiva da scaricare viene scelta in base a diversi criteri.
    Questa pagina mostra in che modo { -brand-short-name } assegna la priorità
    alle schede e la prossima scheda che verrà scaricata.
about-unloads-intro-2 =
    Le schede esistenti vengono visualizzate nella tabella con lo stesso ordine
    utilizzato da { -brand-short-name } per scegliere la prossima scheda da
    scaricare. L’ID del processo è visualizzato in <strong>grassetto</strong>
    quando il processo ospita il frame principale della scheda, in
    <em>corsivo</em> quando il processo è condiviso tra più schede. È possibile
    scaricare manualmente una scheda utilizzando il pulsante <em>Scarica</em>.

about-unloads-last-updated =
    Ultimo aggiornamento: { DATETIME($date,
        year: "numeric", month: "numeric", day: "numeric",
        hour: "numeric", minute: "numeric", second: "numeric",
        hour12: "false") }
about-unloads-button-unload = Scarica
  .title = Scarica la scheda con la priorità più alta
about-unloads-no-unloadable-tab = Non ci sono schede scaricabili.

about-unloads-column-priority = Priorità
about-unloads-column-host = Indirizzo
about-unloads-column-last-accessed = Ultimo accesso
about-unloads-column-weight = Peso base
  .title = Per prima cosa le schede vengono ordinate in base a questo valore, determinato dalle funzioni in uso nella scheda (ad es. riproduzione di suoni, WebRTC, ecc.
about-unloads-column-sortweight = Peso secondario
  .title = Se definito, a parità di peso base le schede vengono poi ordinate utilizzando questo valore. Questo valore è determinato dall’utilizzo di memoria e dal numero di processi.
about-unloads-column-memory = Memoria
  .title = Stima della memoria utilizzata dalla scheda
about-unloads-column-processes = ID processi
  .title = ID dei processi che ospitano il contenuto della scheda

about-unloads-last-accessed = { DATETIME($date,
        year: "numeric", month: "numeric", day: "numeric",
        hour: "numeric", minute: "numeric", second: "numeric",
        hour12: "false") }
about-unloads-memory-in-mb = { NUMBER($mem, maxFractionalUnits: 2) } MB
about-unloads-memory-in-mb-tooltip =
  .title = { NUMBER($mem, maxFractionalUnits: 2) } MB
