# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-httpsonly-insecure-title = Connessione sicura non disponibile

# Variables:
#   $websiteUrl (String) - Url of the website that failed to load. Example: www.example.com
about-httpsonly-insecure-explanation-unavailable = Stai navigando in modalità solo HTTPS e non è disponibile una versione sicura HTTPS di <em>{ $websiteUrl }</em>.
about-httpsonly-insecure-explanation-reasons = Molto probabilmente il sito non supporta HTTPS, ma potrebbe anche trattarsi di un attacco che blocca l’accesso alla versione HTTPS.
about-httpsonly-insecure-explanation-exception = Anche se il rischio per la sicurezza è limitato, se decidi di visitare la versione HTTP del sito non inserire informazioni riservate come password, indirizzi email o dati delle carte di credito.

about-httpsonly-button-make-exception = Accetta il rischio e continua sul sito

about-httpsonly-title-alert = Avviso modalità solo HTTPS
about-httpsonly-title-connection-not-available = Connessione sicura non disponibile

about-httpsonly-explanation-unavailable2 = È stata attivata la modalità solo HTTPS per una maggiore sicurezza ma non è disponibile una versione HTTPS di <em>{ $websiteUrl }</em>.
about-httpsonly-explanation-question = Quale potrebbe essere la causa?
about-httpsonly-explanation-nosupport = Molto probabilmente il sito non supporta HTTPS.
about-httpsonly-explanation-risk = Potrebbe anche trattarsi di un tentativo di attacco. Se decidi di visitare il sito non inserire informazioni riservate come password, indirizzi email o dati delle carte di credito.
about-httpsonly-explanation-continue = Proseguendo, la modalità solo HTTPS verrà temporaneamente disattivata per questo sito.

about-httpsonly-button-continue-to-site = Prosegui sul sito HTTP
about-httpsonly-button-go-back = Torna indietro
about-httpsonly-link-learn-more = Ulteriori informazioni…

## Suggestion Box that only shows up if a secure connection to www can be established
## Variables:
##   $websiteUrl (String) - Url of the website that can be securely loded with these alternatives. Example: example.com

about-httpsonly-suggestion-box-header = Possibile alternativa
about-httpsonly-suggestion-box-www-text = È disponibile una versione sicura di <em>www.{ $websiteUrl }</em>. È possibile visitare questa pagina invece di <em>{ $websiteUrl}</em>.
about-httpsonly-suggestion-box-www-button = Vai a www.{ $websiteUrl }
