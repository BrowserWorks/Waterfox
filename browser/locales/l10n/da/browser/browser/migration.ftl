# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Guiden Importer fra andre programmer
import-from =
    { PLATFORM() ->
        [windows] Importer indstillinger, bogmærker, historik, adgangskoder og andre data fra:
       *[other] Importer indstillinger, bogmærker, historik, adgangskoder og andre data fra:
    }
import-from-bookmarks = Importer bogmærker fra:
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
    .label = Importer intet
    .accesskey = I
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
    .accesskey = X
import-from-360se =
    .label = 360 Secure Browser
    .accesskey = 3
no-migration-sources = Der blev ikke fundet nogen programmer, der indeholder bogmærker, historik eller adgangskoder.
import-source-page-title = Importer indstillinger og data
import-items-page-title = Objekter som skal importeres
import-items-description = Vælg hvilke objekter, der skal importeres:
import-permissions-page-title = Giv { -brand-short-name } tilladelser
# Do not translate "Bookmarks.plist"; the file name is the same everywhere.
import-permissions-description = macOS kræver, at du giver { -brand-short-name } eksplicit tilladelse til at tilgå bogmærker i Safari. Klik på "Fortsæt" og vælg filen "Bookmarks.plist" i det viste Åbn fil-panel.
import-migrating-page-title = Importerer…
import-migrating-description = Følgende objekter er igang med at blive importeret…
import-select-profile-page-title = Vælg profil
import-select-profile-description = Følgende profiler kan importeres:
import-done-page-title = Import fuldført
import-done-description = Følgende elementer blev importeret korrekt:
import-close-source-browser = Tjek om den valgte browser er lukket, før du fortsætter.
# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Fra { $source }
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
imported-safari-reading-list = Læseliste (fra Safari)
imported-edge-reading-list = Læseliste (fra Edge)

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
            [firefox] Browserhistorik og bogmærker
           *[other] Browserhistorik
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Browserhistorik og bogmærker
           *[other] Browserhistorik
        }
browser-data-formdata-checkbox =
    .label = Gemt formularhistorik
browser-data-formdata-label =
    .value = Gemt formularhistorik
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Gemte logins og adgangskoder
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Gemte logins og adgangskoder
browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Favoritter
            [edge] Favoritter
           *[other] Bogmærker
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Favoritter
            [edge] Favoritter
           *[other] Bogmærker
        }
browser-data-otherdata-checkbox =
    .label = Andre data
browser-data-otherdata-label =
    .label = Andre data
browser-data-session-checkbox =
    .label = Vinduer og faneblade
browser-data-session-label =
    .value = Vinduer og faneblade
