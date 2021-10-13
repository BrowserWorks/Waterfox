# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Importowanie ustawień i danych

import-from =
    { PLATFORM() ->
        [windows] Importuj opcje, zakładki, historię, hasła i inne dane z:
       *[other] Importuj preferencje, zakładki, historię, hasła i inne dane z:
    }

import-from-bookmarks = Importuj zakładki z:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-edge-legacy =
    .label = Microsoft Edge w starszej wersji
    .accesskey = w
import-from-edge-beta =
    .label = Microsoft Edge Beta
    .accesskey = d
import-from-nothing =
    .label = Nie importuj niczego
    .accesskey = R
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
    .accesskey = h
import-from-chromium =
    .label = Chromium
    .accesskey = u
import-from-firefox =
    .label = Waterfox
    .accesskey = F
import-from-360se =
    .label = 360 Secure
    .accesskey = 3

no-migration-sources = Nie odnaleziono żadnych programów, z których można by zaimportować zakładki, historię lub hasła.

import-source-page-title = Importuj ustawienia i dane
import-items-page-title = Elementy do zaimportowania

import-items-description = Wybierz elementy do zaimportowania:

import-permissions-page-title = Proszę dać uprawnienia przeglądarce { -brand-short-name }

# Do not translate "Bookmarks.plist"; the file name is the same everywhere.
import-permissions-description = macOS wymaga zezwolenia przeglądarce { -brand-short-name } na dostęp do zakładek przeglądarki Safari przez użytkownika. Kliknij „Kontynuuj” i wybierz plik „Bookmarks.plist” w panelu otwierania pliku, który zostanie otwarty.

import-migrating-page-title = Importowanie…

import-migrating-description = Poniższe elementy są właśnie importowane…

import-select-profile-page-title = Wybierz profil

import-select-profile-description = Można zaimportować następujące profile:

import-done-page-title = Importowanie ukończone

import-done-description = Poniższe elementy zostały zaimportowane:

import-close-source-browser = Przed przejściem dalej proszę upewnić się, że wybrana przeglądarka jest wyłączona.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Z programu { $source }

source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-edge-beta = Microsoft Edge Beta
source-name-safari = Safari
source-name-canary = Google Chrome Canary
source-name-chrome = Google Chrome
source-name-chrome-beta = Google Chrome Beta
source-name-chrome-dev = Google Chrome Dev
source-name-chromium = Chromium
source-name-firefox = Waterfox Waterfox
source-name-360se = 360 Secure

imported-safari-reading-list = Lista Czytelnia (z Safari)
imported-edge-reading-list = Do przeczytania (z Edge)

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
    .label = Ciasteczka
browser-data-cookies-label =
    .value = Ciasteczka

browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] Historia przeglądania i zakładki
           *[other] Historia przeglądania
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Historia przeglądania i zakładki
           *[other] Historia przeglądania
        }

browser-data-formdata-checkbox =
    .label = Zapamiętane dane formularzy
browser-data-formdata-label =
    .value = Zapamiętane dane formularzy

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Zachowane dane logowania i hasła
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Zachowane dane logowania i hasła

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Ulubione
            [edge] Ulubione
           *[other] Zakładki
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Ulubione
            [edge] Ulubione
           *[other] Zakładki
        }

browser-data-otherdata-checkbox =
    .label = Inne dane
browser-data-otherdata-label =
    .label = Inne dane

browser-data-session-checkbox =
    .label = Okna i karty
browser-data-session-label =
    .value = Okna i karty
