# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } ha bloccato { $count } elemento tracciante nell’ultima settimana
       *[other] { -brand-short-name } ha bloccato { $count } elementi traccianti nell’ultima settimana
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> elemento tracciante bloccato dal { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] <b>{ $count }</b> elementi traccianti bloccati dal { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } continua a bloccare gli elementi traccianti in navigazione anonima, ma non viene conservato un registro di ciò che è stato bloccato.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Elementi traccianti bloccati da { -brand-short-name } questa settimana

# The terminology used to refer to categories of Content Blocking is also used in chrome/browser/browser.properties and should be translated consistently.
# "Standard" in this case is an adjective, meaning "default" or "normal".
# The category name in the <b> tag will be bold.
protection-report-webpage-title = Pannello protezioni
protection-report-page-content-title = Pannello protezioni
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } è in grado di proteggere la tua privacy mentre navighi. Questa è una sintesi personalizzata delle protezioni attive e include strumenti per garantire la tua sicurezza online.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } protegge la tua privacy mentre navighi. Questa è una sintesi personalizzata delle protezioni attive e include strumenti per garantire la tua sicurezza online.

protection-report-settings-link = Gestisci le impostazioni relative a privacy e sicurezza

etp-card-title-always = Protezione antitracciamento avanzata: sempre attiva
etp-card-title-custom-not-blocking = Protezione antitracciamento avanzata: DISATTIVATA
etp-card-content-description = { -brand-short-name } blocca automaticamente le società che, di nascosto, cercano di seguire le tue attività sul Web.
protection-report-etp-card-content-custom-not-blocking = Tutte le protezioni sono attualmente disattivate. Scegli quali elementi traccianti bloccare nelle impostazioni di { -brand-short-name }.
protection-report-manage-protections = Gestisci impostazioni

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = oggi

# This string is used to describe the graph for screenreader users.
graph-legend-description = Grafico contenente il numero totale di elementi traccianti bloccati questa settimana, suddiviso per tipologia.

social-tab-title = Traccianti dei social media
social-tab-contant = I social network impostano elementi traccianti in altri siti per scoprire cosa fai, leggi e guardi quando sei online. In questo modo sono in grado di raccogliere molte più informazioni rispetto a quello che condividi nei tuoi profili online. <a data-l10n-name="learn-more-link">Ulteriori informazioni</a>

cookie-tab-title = Cookie traccianti intersito
cookie-tab-content = Questi cookie ti seguono da un sito all’altro per raccogliere informazioni su ciò che fai online. Sono impostati da terze parti come agenzie pubblicitarie e di analisi dati. Il blocco di questi cookie riduce il numero di pubblicità personalizzate che ti seguono attraverso tutto il Web. <a data-l10n-name="learn-more-link">Ulteriori informazioni</a>

tracker-tab-title = Contenuti traccianti
tracker-tab-description = I siti web possono caricare pubblicità, video e altri contenuti da fonti esterne che includono elementi traccianti. Il blocco degli elementi traccianti può velocizzare il caricamento dei siti, ma può causare il malfunzionamento di pulsanti, moduli e campi di accesso. <a data-l10n-name="learn-more-link">Ulteriori informazioni</a>

fingerprinter-tab-title = Fingerprinter
fingerprinter-tab-content = I fingerprinter raccolgono informazioni sulle impostazioni del browser e del computer al fine di creare un tuo profilo. Utilizzando questa “impronta digitale” sono in grado di seguirti attraverso siti diversi. <a data-l10n-name="learn-more-link">Ulteriori informazioni</a>

cryptominer-tab-title = Cryptominer
cryptominer-tab-content = I cryptominer utilizzano le risorse del sistema per effettuare il “mining” di valute digitali. Questi script consumano la batteria, rallentano il computer e possono aumentare il costo della bolletta elettrica. <a data-l10n-name="learn-more-link">Ulteriori informazioni</a>

protections-close-button2 =
    .aria-label = Chiudi
    .title = Chiudi
  
mobile-app-title = Blocca le pubblicità traccianti su tutti i tuoi dispositivi
mobile-app-card-content = Utilizza il browser <em>mobile</em> con protezione integrata contro le pubblicità traccianti.
mobile-app-links = Browser { -brand-product-name } per <a data-l10n-name="android-mobile-inline-link">Android</a> e <a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = Non dimenticare più le tue password
lockwise-title-logged-in2 = Gestione password
lockwise-header-content = { -lockwise-brand-name } salva le tue password in modo sicuro direttamente nel browser.
lockwise-header-content-logged-in = Salva le password in modo sicuro e sincronizzale su tutti i tuoi dispositivi.
protection-report-save-passwords-button = Salva password
    .title = Salva password in { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Gestisci password
    .title = Gestisci password in { -lockwise-brand-short-name }
lockwise-mobile-app-title = Porta le tue password sempre con te
lockwise-no-logins-card-content = Utilizza le password salvate in { -brand-short-name } su qualsiasi dispositivo.
lockwise-app-links = { -lockwise-brand-name } per <a data-l10n-name="lockwise-android-inline-link">Android</a> e <a data-l10n-name="lockwise-ios-inline-link">iOS</a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] 1 password potrebbe essere stata compromessa in una violazione di dati.
       *[other] { $count } password potrebbero essere state compromesse in una violazione di dati.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
  { $count ->
      [one] 1 password salvata in modo sicuro.
     *[other] Le tue password sono salvate in modo sicuro.
  }
lockwise-how-it-works-link = Come funziona

turn-on-sync = Attiva { -sync-brand-short-name }…
    .title = Apri le impostazioni di sincronizzazione

monitor-title = Tieni sotto controllo le violazioni di dati
monitor-link = Come funziona
monitor-header-content-no-account = Controlla { -monitor-brand-name } per verificare se sei stato coinvolto in una violazione di dati conosciuta e ricevere avvisi per nuove violazioni.
monitor-header-content-signed-in = { -monitor-brand-name } ti avvisa se le tue informazioni compaiono in una violazione di dati conosciuta.
monitor-sign-up-link = Iscriviti per ricevere avvisi sulle violazioni
  .title = Iscriviti per ricevere avvisi sulle violazioni in { -monitor-brand-name }
auto-scan = Controllato automaticamente oggi

monitor-emails-tooltip =
  .title = Visualizza indirizzi email gestiti in { -monitor-brand-short-name }
monitor-breaches-tooltip =
  .title = Visualizza violazioni di dati conosciute in { -monitor-brand-short-name }
monitor-passwords-tooltip =
  .title = Visualizza password compromesse in { -monitor-brand-short-name }

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] Indirizzo email monitorato
       *[other] Indirizzi email monitorati
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] Violazione di dati conosciuta che ha compromesso le tue informazioni
       *[other] Violazioni di dati conosciute che hanno compromesso le tue informazioni
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] Violazione di dati conosciuta contrassegnata come risolta
       *[other] Violazioni di dati conosciute contrassegnate come risolte
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] Password compromessa in tutte le violazioni
       *[other] Password compromesse in tutte le violazioni
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved = =
    { $count ->
        [one] Password compromessa in violazioni non risolte
       *[other] Password compromesse in violazioni non risolte
    }

monitor-no-breaches-title = Ottime notizie
monitor-no-breaches-description = Non sono presenti violazioni di dati conosciute. Ti faremo sapere se la situazione dovesse cambiare.
monitor-view-report-link = Visualizza rapporto
  .title = Risolvi le violazioni su { -monitor-brand-short-name }
monitor-breaches-unresolved-title = Risolvi le tue violazioni
monitor-breaches-unresolved-description = Dopo aver verificato i dettagli di ogni violazione e aver preso le misure necessarie per proteggere i tuoi dati, puoi contrassegnare le violazioni come risolte.
monitor-manage-breaches-link = Gestisci violazioni
  .title = Gestisci le violazioni su { -monitor-brand-short-name }
monitor-breaches-resolved-title = Ottimo, hai risolto tutte le violazioni di dati conosciute.
monitor-breaches-resolved-description = Ti faremo sapere se la tua email dovesse apparire in una nuova violazione.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
  { $numBreachesResolved ->
    [one] { $numBreachesResolved } violazione su { $numBreaches } contrassegnata come risolta
   *[other] { $numBreachesResolved } violazioni su { $numBreaches } contrassegnate come risolte
  }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved }% completato

monitor-partial-breaches-motivation-title-start = Ottimo inizio!
monitor-partial-breaches-motivation-title-middle = Continua così!
monitor-partial-breaches-motivation-title-end = Quasi finito. Continua così!
monitor-partial-breaches-motivation-description = Risolvi le altre violazioni su { -monitor-brand-short-name }.
monitor-resolve-breaches-link = Risolvi violazioni
  .title = Risolvi le violazioni su { -monitor-brand-short-name }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Traccianti dei social media
    .aria-label =
        { $count ->
            [one] { $count } tracciante dei social media ({ $percentage }%)
           *[other] { $count } traccianti dei social media ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = Cookie traccianti intersito
    .aria-label =
        { $count ->
            [one] { $count } cookie tracciante intersito ({ $percentage }%)
           *[other] { $count } cookie traccianti intersito ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Contenuti traccianti
    .aria-label =
        { $count ->
            [one] { $count } contenuto tracciante ({ $percentage }%)
           *[other] { $count } contenuti traccianti ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Fingerprinter
    .aria-label = { $count } fingerprinter ({ $percentage }%)
bar-tooltip-cryptominer =
    .title = Cryptominer
    .aria-label = { $count } cryptominer ({ $percentage }%)
