# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Import-Assistent

import-from =
    { PLATFORM() ->
        [windows] Einstellungen, Lesezeichen, Chronik, Passwörter und sonstige Daten importieren von:
       *[other] Einstellungen, Lesezeichen, Chronik, Passwörter und sonstige Daten importieren von:
    }

import-from-bookmarks = Lesezeichen importieren aus:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-edge-legacy =
    .label = Microsoft Edge Legacy
    .accesskey = L
import-from-edge-beta =
    .label = Microsoft Edge Beta
    .accesskey = d
import-from-nothing =
    .label = Nichts importieren
    .accesskey = h
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
    .accesskey = n
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
    .accesskey = F
import-from-360se =
    .label = 360 Secure Browser
    .accesskey = 3
import-from-opera-gx =
    .label = Opera GX
    .accesskey = G

no-migration-sources = Es konnte kein Programm gefunden werden, das Lesezeichen-, Chronik- oder Passwortdaten enthält.

import-source-page-title = Einstellungen und Daten importieren
import-items-page-title = Zu importierende Daten

import-items-description = Wählen Sie bitte aus, welche Daten importiert werden sollen:

import-permissions-page-title = Bitte geben Sie { -brand-short-name } Berechtigungen

# Do not translate "Safari" (the name of the browser on Apple devices)
import-safari-permissions-string = macOS erfordert, dass Sie { -brand-short-name } ausdrücklich erlauben, auf die Daten von Safari zuzugreifen. Klicken Sie auf "Fortsetzen", wählen Sie den Ordner "Safari" im erscheinenden Finder-Dialog, und klicken Sie "Öffnen".

import-migrating-page-title = Importieren…

import-migrating-description = Folgende Daten werden momentan importiert:

import-select-profile-page-title = Profil wählen

import-select-profile-description = Es stehen folgende Profile zum Import zur Verfügung:

import-done-page-title = Importieren abgeschlossen

import-done-description = Folgende Daten wurden erfolgreich importiert:

import-close-source-browser = Bitte überprüfen Sie vor dem Fortfahren, dass der gewählte Browser beendet ist.

source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-chrome = Google Chrome

imported-safari-reading-list = Leseliste (von Safari)
imported-edge-reading-list = Leseliste (von Edge)

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
    .label = Cookies
browser-data-cookies-label =
    .value = Cookies

browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] Browserverlauf und Lesezeichen
           *[other] Browserverlauf
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Browserverlauf und Lesezeichen
           *[other] Browserverlauf
        }

browser-data-formdata-checkbox =
    .label = Gespeicherte Formulardaten
browser-data-formdata-label =
    .value = Gespeicherte Formulardaten

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Gespeicherte Zugangsdaten und Passwörter
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Gespeicherte Zugangsdaten und Passwörter

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Favoriten
            [edge] Favoriten
           *[other] Lesezeichen
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Favoriten
            [edge] Favoriten
           *[other] Lesezeichen
        }

browser-data-otherdata-checkbox =
    .label = Sonstige Daten
browser-data-otherdata-label =
    .label = Sonstige Daten

browser-data-session-checkbox =
    .label = Fenster und Tabs
browser-data-session-label =
    .value = Fenster und Tabs

browser-data-payment-methods-checkbox =
    .label = Zahlungsmethoden
browser-data-payment-methods-label =
    .value = Zahlungsmethoden
