# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Importvegvisar
import-from =
    { PLATFORM() ->
        [windows] Importer innstillingar, bokmerke, historikk, passord og annan informasjon frå:
       *[other] Importer innstillingar, bokmerke, historikk, passord og annan informasjon frå:
    }
import-from-bookmarks = Importer bokmerke frå:
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
    .label = Ikkje importer noko
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
    .accesskey = F
import-from-360se =
    .label = 360 sikker nettlesar
    .accesskey = 3
no-migration-sources = Klarte ikkje å finne program som inneheld bokmerke, historikk eller passordinformasjon.
import-source-page-title = Importer innstillingar og data
import-items-page-title = Element som skal importerast
import-items-description = Vel kva for element som skal importerast:
import-permissions-page-title = Gi { -brand-short-name } løyve
# Do not translate "Bookmarks.plist"; the file name is the same everywhere.
import-permissions-description = macOS krev at du eksplisitt gir { -brand-short-name } tilgang til Safaris bokmerke. Klikk på «Fortset» og vel «Bookmarks.plist»-fila i Opne fil-panelet som vert vist.
import-migrating-page-title = Importerer…
import-migrating-description = Følgjande element vert no importerte…
import-select-profile-page-title = Vel profil
import-select-profile-description = Du kan importere frå følgjande profilar:
import-done-page-title = Import fullført
import-done-description = Følgjande element er importerte:
import-close-source-browser = Kontroller at den valde nettlesaren er attlaten før du held fram.
# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Frå { $source }
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
source-name-360se = 360 trygg nettlesar
imported-safari-reading-list = Leseliste (frå Safari)
imported-edge-reading-list = Leseliste (frå Edge)

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
    .label = Infokapslar
browser-data-cookies-label =
    .value = Infokapslar
browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] Nettlesarhistorikk og bokmerke
           *[other] Nettlesarhistorikk
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Nettlesarhistorikk og bokmerke
           *[other] Nettlesarhistorikk
        }
browser-data-formdata-checkbox =
    .label = Lagra skjemahistorikk
browser-data-formdata-label =
    .value = Lagra skjemahistorikk
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Lagra innloggingar og passord
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Lagra innloggingar og passord
browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Favorittar
            [edge] Favorittar
           *[other] Bokmerke
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Favorittar
            [edge] Favorittar
           *[other] Bokmerke
        }
browser-data-otherdata-checkbox =
    .label = Andre data
browser-data-otherdata-label =
    .label = Andre data
browser-data-session-checkbox =
    .label = Vindauge og faner
browser-data-session-label =
    .value = Vindauge og faner
