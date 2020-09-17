# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = İçe aktarma sihirbazı

import-from =
    { PLATFORM() ->
        [windows] Seçenekleri, yer imlerini, gezinti geçmişini, parolaları ve diğer verileri şu tarayıcıdan aktar:
       *[other] Tercihleri, yer imlerini, gezinti geçmişini, parolaları ve diğer verileri şu tarayıcıdan aktar:
    }

import-from-bookmarks = Yer imlerini buradan içe aktar:
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-edge-legacy =
    .label = Microsoft Edge (Eski Sürüm)
    .accesskey = d
import-from-edge-beta =
    .label = Microsoft Edge Beta
    .accesskey = d
import-from-nothing =
    .label = İçe bir şey aktarma
    .accesskey = b
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
    .accesskey = x
import-from-360se =
    .label = 360 Secure Browser
    .accesskey = 3

no-migration-sources = Yer imlerinin, geçmişin veya parola verilerinin kayıtlı olduğu hiçbir program bulunamadı.

import-source-page-title = Ayarları ve verileri içe aktarma
import-items-page-title = İçe aktarılacak öğeler

import-items-description = İçe aktarılacak öğeleri seçin:

import-migrating-page-title = İçe aktarılıyor…

import-migrating-description = Aşağıdaki öğeler şu anda içe aktarılıyor…

import-select-profile-page-title = Profil seçin

import-select-profile-description = Aşağıdaki profiller buradan içe aktarılabilir:

import-done-page-title = İçe aktarma tamamlandı

import-done-description = Aşağıdaki öğeler başarıyla içe aktarıldı:

import-close-source-browser = Devam etmeden önce lütfen seçtiğiniz tarayıcının kapalı olduğundan emin olun.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = { $source } yer imleri

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

imported-safari-reading-list = Okuma Listesi (Safari’den)
imported-edge-reading-list = Okuma Listesi (Edge’den)

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
    .label = Çerezler
browser-data-cookies-label =
    .value = Çerezler

browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] Gezinti geçmişi ve yer imleri
           *[other] Gezinti geçmişi
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] Gezinti geçmişi ve yer imleri
           *[other] Gezinti geçmişi
        }

browser-data-formdata-checkbox =
    .label = Kayıtlı form geçmişi
browser-data-formdata-label =
    .value = Kayıtlı form geçmişi

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = Kayıtlı hesaplar ve parolalar
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = Kayıtlı hesaplar ve parolalar

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] Sık kullanılanlar
            [edge] Sık kullanılanlar
           *[other] Yer imleri
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] Sık kullanılanlar
            [edge] Sık kullanılanlar
           *[other] Yer imleri
        }

browser-data-otherdata-checkbox =
    .label = Diğer veriler
browser-data-otherdata-label =
    .label = Diğer veriler

browser-data-session-checkbox =
    .label = Pencereler ve sekmeler
browser-data-session-label =
    .value = Pencereler ve sekmeler
