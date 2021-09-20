# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Importguiden
import-from =
    { PLATFORM() ->
        [windows] Importera inställningar, bokmärken, historik, lösenord och annan data från:
       *[other] Importera inställningar, bokmärken, historik, lösenord och annan data från:
    }
import-from-bookmarks = Importera bokmärken från:
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
    .label = Importera ingenting
    .accesskey = n
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
no-migration-sources = Hittade inget program som innehåller bokmärken, historik eller lösenord.
import-source-page-title = Importera inställningar och data
import-items-page-title = Objekt som ska importeras
import-items-description = Välj poster att importera:
import-permissions-page-title = Ge { -brand-short-name } behörigheter
# Do not translate "Bookmarks.plist"; the file name is the same everywhere.
import-permissions-description = macOS kräver att du uttryckligen tillåter { -brand-short-name } att komma åt Safaris bokmärken. Klicka på "Fortsätt" och välj filen "Bookmarks.plist" i panelen öppna fil som visas.
import-migrating-page-title = Importerar…
import-migrating-description = Följande poster importeras för närvarande…
import-select-profile-page-title = Välj profil
import-select-profile-description = Följande profiler är tillgängliga att importera från:
import-done-page-title = Import slutförd
import-done-description = Följande poster har importerats:
import-close-source-browser = Kontrollera att den valda webbläsaren är stängd innan du fortsätter.
# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Från { $source }
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
imported-safari-reading-list = Läslista (från Safari)
imported-edge-reading-list = Läslista (från Edge)

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
    .label = Kakor
browser-data-cookies-label =
    .value = Kakor
browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] Webbhistorik och bokmärken
           *[other] Webbhistorik
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Webbhistorik och bokmärken
           *[other] Webbhistorik
        }
browser-data-formdata-checkbox =
    .label = Sparad formulärdata
browser-data-formdata-label =
    .value = Sparad formulärdata
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Sparade inloggningar och lösenord
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Sparade inloggningar och lösenord
browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Favoriter
            [edge] Favoriter
           *[other] Bokmärken
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Favoriter
            [edge] Favoriter
           *[other] Bokmärken
        }
browser-data-otherdata-checkbox =
    .label = Annan data
browser-data-otherdata-label =
    .label = Annan data
browser-data-session-checkbox =
    .label = Fönster och flikar
browser-data-session-label =
    .value = Fönster och flikar
