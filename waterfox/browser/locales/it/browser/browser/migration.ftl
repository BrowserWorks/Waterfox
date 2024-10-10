# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Importazione guidata

import-from =
    { PLATFORM() ->
        [windows] Importa opzioni, segnalibri, cronologia, password e altri dati da:
       *[other] Importa le opzioni, i segnalibri, la cronologia, le password e altri dati da:
    }

import-from-bookmarks = Importa segnalibri da:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-edge-legacy =
    .label = Microsoft Edge Legacy
    .accesskey = y
import-from-edge-beta =
    .label = Microsoft Edge Beta
    .accesskey = B
import-from-nothing =
    .label = Non importare nulla
    .accesskey = N
import-from-safari =
    .label = Safari
    .accesskey = S
import-from-opera =
    .label = Opera
    .accesskey = O
import-from-vivaldi =
    .label = Vivaldi
    .accesskey = V
import-from-brave =
    .label = Brave
    .accesskey = r
import-from-canary =
    .label = Chrome Canary
    .accesskey = h
import-from-chrome =
    .label = Chrome
    .accesskey = C
import-from-chrome-beta =
    .label = Chrome Beta
    .accesskey = B
import-from-chrome-dev =
    .label = Chrome Dev
    .accesskey = D
import-from-chromium =
    .label = Chromium
    .accesskey = u
import-from-firefox =
    .label = Waterfox
    .accesskey = x
import-from-360se =
    .label = 360 Secure Browser
    .accesskey = 3

import-from-opera-gx =
    .label = Opera GX
    .accesskey = G

no-migration-sources = Non è stato trovato alcun programma contenente segnalibri, cronologie o password.

import-source-page-title = Importa impostazioni e dati
import-items-page-title = Oggetti da importare

import-items-description = Selezionare gli oggetti da importare:

import-permissions-page-title = Garantire a { -brand-short-name } i permessi necessari

import-safari-permissions-string = In macOS è necessario garantire esplicitamente a { -brand-short-name } il permesso di accedere ai dati di Safari. Fare clic su “Continua”, selezionare la cartella “Safari” nella finestra del Finder che verrà visualizzata e fare clic su “Apri”.

import-migrating-page-title = Importazione…

import-migrating-description = I seguenti oggetti stanno per essere importati…

import-select-profile-page-title = Seleziona un profilo

import-select-profile-description = Sono disponibili i seguenti profili da importare:

import-done-page-title = Importazione completata

import-done-description = I seguenti oggetti sono stati correttamente importati:

import-close-source-browser = Assicurarsi che il browser selezionato sia chiuso prima di procedere.

source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-chrome = Google Chrome

imported-safari-reading-list = Elenco lettura (da Safari)
imported-edge-reading-list = Elenco di lettura (da Edge)

## Browser data types
## All of these strings get a $browser variable passed in.
## You can use the browser variable to differentiate the name of items,
## which may have different labels in different browsers.
## The supported values for the $browser variable are:
## 360se
## chrome
## edge
## firefox
## safari
## The various beta and development versions of edge and chrome all get
## normalized to just "edge" and "chrome" for these strings.

## Browser data types
## All of these strings get a $browser variable passed in.
## You can use the browser variable to differentiate the name of items,
## which may have different labels in different browsers.
## The supported values for the $browser variable are:
## 360se
## chrome
## edge
## firefox
## ie
## safari
## The various beta and development versions of edge and chrome all get
## normalized to just "edge" and "chrome" for these strings.

browser-data-cookies-checkbox =
    .label = Cookie
browser-data-cookies-label =
    .value = Cookie

browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] Cronologia di navigazione e segnalibri
           *[other] Cronologia di navigazione
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Cronologia di navigazione e segnalibri
           *[other] Cronologia di navigazione
        }

browser-data-formdata-checkbox =
    .label = Dati salvati nei moduli
browser-data-formdata-label =
    .value = Dati salvati nei moduli

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Credenziali e password salvate
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Credenziali e password salvate

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Preferiti
            [edge] Preferiti
           *[other] Segnalibri
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Preferiti
            [edge] Preferiti
           *[other] Segnalibri
        }

browser-data-otherdata-checkbox =
    .label = Altri dati
browser-data-otherdata-label =
    .label = Altri dati

browser-data-session-checkbox =
    .label = Finestre e schede
browser-data-session-label =
    .value = Finestre e schede

browser-data-payment-methods-checkbox =
  .label = Metodi di pagamento
browser-data-payment-methods-label =
  .value = Metodi di pagamento
