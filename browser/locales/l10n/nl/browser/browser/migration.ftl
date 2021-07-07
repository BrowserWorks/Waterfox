# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Importeerwizard

import-from =
    { PLATFORM() ->
        [windows] Opties, bladwijzers, geschiedenis, wachtwoorden en andere gegevens importeren uit:
       *[other] Voorkeuren, bladwijzers, geschiedenis, wachtwoorden en andere gegevens importeren uit:
    }

import-from-bookmarks = Bladwijzers importeren uit:
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
    .label = Niets importeren
    .accesskey = t
import-from-safari =
    .label = Safari
    .accesskey = S
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
    .accesskey = x
import-from-360se =
    .label = 360 Secure Browser
    .accesskey = 3

no-migration-sources = Er zijn geen programma’s gevonden die bladwijzers, geschiedenis of wachtwoorden bevatten.

import-source-page-title = Instellingen en gegevens importeren
import-items-page-title = Te importeren items

import-items-description = Selecteer de te importeren items:

import-permissions-page-title = Geef { -brand-short-name } toestemmingen

# Do not translate "Bookmarks.plist"; the file name is the same everywhere.
import-permissions-description = In macOS dient u { -brand-short-name } expliciet toegang te geven tot de bladwijzers van Safari. Klik op ‘Doorgaan’ en selecteer in het getoonde paneel Bestand openen het bestand ‘Bookmarks.plist’.

import-migrating-page-title = Importeren…

import-migrating-description = De volgende items worden momenteel geïmporteerd…

import-select-profile-page-title = Profiel selecteren

import-select-profile-description = De volgende profielen zijn beschikbaar om uit te importeren:

import-done-page-title = Importeren voltooid

import-done-description = De volgende items zijn met succes geïmporteerd:

import-close-source-browser = Zorg ervoor dat de geselecteerde browser is gesloten voordat u verdergaat.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Uit { $source }

source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-edge-beta = Microsoft Edge Beta
source-name-safari = Safari
source-name-canary = Google Chrome Canary
source-name-chrome = Google Chrome
source-name-chrome-beta = Google Chrome Beta
source-name-chrome-dev = Google Chrome Dev
source-name-chromium = Chromium
source-name-firefox = Waterfox
source-name-360se = 360 Secure Browser

imported-safari-reading-list = Leeslijst (uit Safari)
imported-edge-reading-list = Leeslijst (uit Edge)

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
            [firefox] Navigatiegeschiedenis en bladwijzers
           *[other] Navigatiegeschiedenis
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Navigatiegeschiedenis en bladwijzers
           *[other] Navigatiegeschiedenis
        }

browser-data-formdata-checkbox =
    .label = Opgeslagen formuliergeschiedenis
browser-data-formdata-label =
    .value = Opgeslagen formuliergeschiedenis

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Opgeslagen aanmeldingen en wachtwoorden
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Opgeslagen aanmeldingen en wachtwoorden

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Favorieten
            [edge] Favorieten
           *[other] Bladwijzers
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Favorieten
            [edge] Favorieten
           *[other] Bladwijzers
        }

browser-data-otherdata-checkbox =
    .label = Andere gegevens
browser-data-otherdata-label =
    .label = Andere gegevens

browser-data-session-checkbox =
    .label = Vensters en tabbladen
browser-data-session-label =
    .value = Vensters en tabbladen
