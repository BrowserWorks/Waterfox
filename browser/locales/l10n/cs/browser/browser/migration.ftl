# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = Průvodce importem dat z jiného prohlížeče
import-from =
    { PLATFORM() ->
        [windows] Importovat nastavení, záložky, historii, hesla a ostatní údaje z aplikace:
       *[other] Importovat předvolby, záložky, historii, hesla a ostatní údaje z aplikace:
    }
import-from-bookmarks = Importovat záložky z aplikace:
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
    .label = Nic neimportovat
    .accesskey = N
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
    .label = Firefox
    .accesskey = F
import-from-360se =
    .label = 360 Secure Browser
    .accesskey = 3
no-migration-sources = Nebyl nalezen žádný program, který by obsahoval záložky, historii nebo uložená hesla.
import-source-page-title = Import nastavení a údajů
import-items-page-title = Importované položky
import-items-description = Zvolte položky, které chcete importovat:
import-permissions-page-title =
    Udělte prosím { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "dat") }
        [feminine] { -brand-short-name(case: "dat") }
        [neuter] { -brand-short-name(case: "dat") }
       *[other] aplikaci { -brand-short-name }
    } oprávnění
# Do not translate "Bookmarks.plist"; the file name is the same everywhere.
import-permissions-description =
    macOS vyžaduje, abyste { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "dat") }
        [feminine] { -brand-short-name(case: "dat") }
        [neuter] { -brand-short-name(case: "dat") }
       *[other] aplikaci { -brand-short-name }
    } výslovně povolili přístup k záložkám ze Safari. Klikněte na „Pokračovat“ a v zobrazeném panelu Otevřít soubor vyberte soubor „Bookmarks.plist“.
import-migrating-page-title = Probíhá import…
import-migrating-description = Teď jsou importovány následující položky…
import-select-profile-page-title = Volba profilu
import-select-profile-description = Importovat je možné z následujících profilů:
import-done-page-title = Import byl dokončen
import-done-description = Následující položky byly úspěšně importovány:
import-close-source-browser = Před pokračováním se prosím ujistěte, že je vybraný prohlížeč zavřený.
# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = Z prohlížeče { $source }
source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-edge-beta = Microsoft Edge Beta
source-name-safari = Safari
source-name-canary = Google Chrome Canary
source-name-chrome = Google Chrome
source-name-chrome-beta = Google Chrome Beta
source-name-chrome-dev = Google Chrome Dev
source-name-chromium = Chromium
source-name-firefox = Mozilla Firefox
source-name-360se = 360 Secure Browser
imported-safari-reading-list = Seznam ke čtení (ze Safari)
imported-edge-reading-list = Seznam ke čtení (z Edge)

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
    .label =
        { $browser ->
            [firefox] Cookies
            [chrome] Soubory cookie
            [edge] Soubory cookie
            [safari] Cookies
           *[other] Cookies
        }
browser-data-cookies-label =
    .value =
        { $browser ->
            [firefox] Cookies
            [chrome] Soubory cookie
            [edge] Soubory cookie
            [safari] Cookies
           *[other] Cookies
        }
browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] Historie a záložky
            [chrome] Historie
            [edge] Historie
            [safari] Historie
           *[other] Historie
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Historie a záložky
            [chrome] Historie
            [edge] Historie
            [safari] Historie
           *[other] Historie
        }
browser-data-formdata-checkbox =
    .label =
        { $browser ->
            [firefox] Uložené formuláře
            [chrome] Uložené formuláře
            [edge] Vyplňování formulářů
            [safari] Vyplňování formulářů
           *[other] Uložené formuláře
        }
browser-data-formdata-label =
    .value =
        { $browser ->
            [firefox] Uložené formuláře
            [chrome] Uložené formuláře
            [edge] Vyplňování formulářů
            [safari] Vyplňování formulářů
           *[other] Uložené formuláře
        }
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label =
        { $browser ->
            [firefox] Uložené přihlašovací údaje a hesla
            [chrome] Uložená hesla
            [edge] Uložená hesla
            [safari] Hesla
           *[other] Uložené přihlašovací údaje a hesla
        }
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value =
        { $browser ->
            [firefox] Uložené přihlašovací údaje a hesla
            [chrome] Uložená hesla
            [edge] Uložená hesla
            [safari] Hesla
           *[other] Uložené přihlašovací údaje a hesla
        }
browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [firefox] Záložky
            [chrome] Záložky
            [edge] Oblíbené položky
            [ie] Oblíbené
            [safari] Záložky a oblíbené
           *[other] Záložky
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [firefox] Záložky
            [chrome] Záložky
            [edge] Oblíbené položky
            [ie] Oblíbené
            [safari] Záložky a oblíbené
           *[other] Záložky
        }
browser-data-otherdata-checkbox =
    .label = Ostatní data
browser-data-otherdata-label =
    .label = Ostatní data
browser-data-session-checkbox =
    .label = Okna a panely
browser-data-session-label =
    .value = Okna a panely
