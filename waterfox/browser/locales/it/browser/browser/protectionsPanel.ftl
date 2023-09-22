# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = Si è verificato un errore durante l’invio della segnalazione. Riprova più tardi.

protections-panel-sitefixedsendreport-label = Problema risolto? Invia una segnalazione

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

protections-popup-footer-protection-label-strict = Restrittiva
    .label = Restrittiva
protections-popup-footer-protection-label-custom = Personalizzata
    .label = Personalizzata
protections-popup-footer-protection-label-standard = Normale
    .label = Normale

##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = Ulteriori informazioni sulla protezione antitracciamento avanzata

protections-panel-etp-on-header = La protezione antitracciamento avanzata è ATTIVA per questo sito.
protections-panel-etp-off-header = La protezione antitracciamento avanzata è DISATTIVATA per questo sito

## Text for the toggles shown when ETP is enabled/disabled for a given site.
## .description is transferred into a separate paragraph by the moz-toggle
## custom element code.
##   $host (String): the hostname of the site that is being displayed.

protections-panel-etp-on-toggle =
  .label = Protezione antitracciamento avanzata
  .description = Attiva per questo sito
  .aria-label = Disattiva protezioni per { $host }
protections-panel-etp-off-toggle =
  .label = Protezione antitracciamento avanzata
  .description = Disattivata per questo sito
  .aria-label = Attiva protezioni per { $host }

# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = Il sito non funziona?

# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = Sito non funzionante

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = Perché?
protections-panel-not-blocking-why-etp-on-tooltip = Il blocco di questi elementi potrebbe causare il parziale malfunzionamento di alcuni siti web. Senza elementi traccianti, alcuni pulsanti, moduli e campi di accesso non funzionano correttamente.
protections-panel-not-blocking-why-etp-off-tooltip = Tutti gli elementi traccianti in questo sito sono stati caricati in quanto le protezioni sono disattivate.

##

protections-panel-no-trackers-found = Nessun elemento tracciante conosciuto da { -brand-short-name } è stato rilevato in questa pagina.

protections-panel-content-blocking-tracking-protection = Contenuti traccianti

protections-panel-content-blocking-socialblock = Traccianti dei social media
protections-panel-content-blocking-cryptominers-label = Cryptominer
protections-panel-content-blocking-fingerprinters-label = Fingerprinter

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = Bloccati
protections-panel-not-blocking-label = Consentiti
protections-panel-not-found-label = Non rilevati

##

protections-panel-settings-label = Impostazioni protezione
protections-panel-protectionsdashboard-label = Pannello protezioni

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = Disattivare le protezioni se si riscontrano problemi con:

# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = Campi di accesso
protections-panel-site-not-working-view-issue-list-forms = Moduli
protections-panel-site-not-working-view-issue-list-payments = Pagamenti
protections-panel-site-not-working-view-issue-list-comments = Commenti
protections-panel-site-not-working-view-issue-list-videos = Video

protections-panel-site-not-working-view-issue-list-fonts = Caratteri

protections-panel-site-not-working-view-send-report = Invia una segnalazione

##

protections-panel-cross-site-tracking-cookies = Questi cookie ti seguono da un sito all’altro per raccogliere informazioni su ciò che fai online. Sono impostati da terze parti come agenzie pubblicitarie e di analisi dati.
protections-panel-cryptominers = I cryptominer utilizzano le risorse del sistema per effettuare il “mining” di valute digitali. Questi script consumano la batteria, rallentano il computer e possono aumentare il costo della bolletta elettrica.
protections-panel-fingerprinters = I fingerprinter raccolgono informazioni sulle impostazioni del browser e del computer al fine di creare un tuo profilo. Utilizzando questa “impronta digitale” sono in grado di seguirti attraverso siti diversi.
protections-panel-tracking-content = I siti web possono caricare pubblicità, video e altri contenuti da fonti esterne che includono elementi traccianti. Il blocco degli elementi traccianti può velocizzare il caricamento dei siti, ma può causare il malfunzionamento di pulsanti, moduli e campi di accesso.
protections-panel-social-media-trackers = I social network impostano elementi traccianti in altri siti per scoprire cosa fai, leggi e guardi quando sei online. In questo modo sono in grado di raccogliere molte più informazioni rispetto a quello che condividi nei tuoi profili online.

protections-panel-description-shim-allowed = Alcuni elementi traccianti, indicati in seguito, sono stati parzialmente sbloccati in quanto hai interagito con loro.
protections-panel-description-shim-allowed-learn-more = Ulteriori informazioni
protections-panel-shim-allowed-indicator =
    .tooltiptext = Elemento tracciante parzialmente sbloccato

protections-panel-content-blocking-manage-settings =
    .label = Gestisci impostazioni protezione
    .accesskey = G

protections-panel-content-blocking-breakage-report-view =
    .title = Segnala problemi con il sito
protections-panel-content-blocking-breakage-report-view-description = Il blocco di determinati elementi traccianti può creare problemi in alcuni siti web. Segnalando questi problemi contribuisci a migliorare { -brand-short-name } per tutti gli utenti. Questa segnalazione verrà inviata a BrowserWorks e include l’indirizzo del sito e informazioni sulle impostazioni del browser. <label data-l10n-name="learn-more">Ulteriori informazioni</label>
protections-panel-content-blocking-breakage-report-view-description2 = Il blocco di determinati elementi traccianti può creare problemi in alcuni siti web. Segnalando questi problemi contribuisci a migliorare { -brand-short-name } per tutti gli utenti. Questa segnalazione verrà inviata a { -vendor-short-name } e include l’indirizzo del sito e informazioni sulle impostazioni del browser.
protections-panel-content-blocking-breakage-report-view-collection-url = Indirizzo
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = Indirizzo
protections-panel-content-blocking-breakage-report-view-collection-comments = Facoltativo: descrivi il problema
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = Facoltativo: descrivi il problema
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = Annulla
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = Invia segnalazione

# Cookie Banner Handling

protections-panel-cookie-banner-handling-header = Riduzione banner per i cookie
protections-panel-cookie-banner-handling-enabled = Attiva per questo sito
protections-panel-cookie-banner-handling-disabled = Disattivata per questo sito
protections-panel-cookie-banner-handling-undetected = Sito attualmente non supportato

protections-panel-cookie-banner-view-title =
    .title = Riduzione banner per i cookie
# Variables
#  $host (String): the hostname of the site that is being displayed.
protections-panel-cookie-banner-view-turn-off-for-site = Disattivare Riduzione banner per i cookie per { $host }?
protections-panel-cookie-banner-view-turn-on-for-site = Attivare Riduzione banner per i cookie per questo sito?
protections-panel-cookie-banner-view-cookie-clear-warning = { -brand-short-name } eliminerà i cookie per questo sito e aggiornerà la pagina. L’eliminazione dei cookie potrebbe disconnetterti dal sito o svuotare eventuali carrelli in sospeso.
protections-panel-cookie-banner-view-turn-on-description = { -brand-short-name } cerca di rifiutare automaticamente tutte le richieste per i cookie nei siti supportati.
protections-panel-cookie-banner-view-cancel = Annulla
protections-panel-cookie-banner-view-turn-off = Disattiva
protections-panel-cookie-banner-view-turn-on = Attiva
