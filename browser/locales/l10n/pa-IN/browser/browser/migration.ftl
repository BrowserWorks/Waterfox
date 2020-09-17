# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = ਇੰਪੋਰਟ ਸਹਾਇਕ

import-from =
    { PLATFORM() ->
        [windows] ਚੋਣ, ਬੁੱਕਮਾਰਕ, ਅਤੀਤ, ਪਾਸਵਰਡ ਅਤੇ ਹੋਰ ਡਾਟਾ ਇੱਥੋਂ ਇੰਪੋਰਟ ਕਰੋ:
       *[other] ਚੋਣ, ਬੁੱਕਮਾਰਕ, ਅਤੀਤ, ਪਾਸਵਰਡ ਅਤੇ ਹੋਰ ਡਾਟਾ ਇੱਥੋਂ ਇੰਪੋਰਟ ਕਰੋ:
    }

import-from-bookmarks = ਬੁੱਕਮਾਰਕ ਇੱਥੋਂ ਇੰਪੋਰਟ:
import-from-ie =
    .label = ਮਾਈਕ੍ਰੋਸਾਫਟ ਇੰਟਰਨੈੱਟ ਐਕਸਪਲੋਰਰ
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-edge-legacy =
    .label = Microsoft Edge ਪੁਰਾਣਾ
    .accesskey = L
import-from-edge-beta =
    .label = Microsoft Edge Beta
    .accesskey = d
import-from-nothing =
    .label = ਕੁਝ ਵੀ ਇੰਪੋਰਟ ਨਾ ਕਰੋ
    .accesskey = D
import-from-safari =
    .label = ਸਫ਼ਾਰੀ
    .accesskey = S
import-from-canary =
    .label = Chrome Canary
    .accesskey = n
import-from-chrome =
    .label = ਕਰੋਮ
    .accesskey = C
import-from-chrome-beta =
    .label = ਕਰੋਮ ਬੀਟਾ
    .accesskey = B
import-from-chrome-dev =
    .label = ਕਰੋਮ ਡਿਵ
    .accesskey = D
import-from-chromium =
    .label = Chromium
    .accesskey = u
import-from-firefox =
    .label = Firefox
    .accesskey = X
import-from-360se =
    .label = 360 ਸੁਰੱਖਿਆ ਬਰਾਊਜ਼ਰ
    .accesskey = 3

no-migration-sources = ਕੋਈ ਵੀ ਅਜੇਹਾ ਪਰੋਗਰਾਮ ਨਹੀਂ ਲੱਭਿਆ ਹੈ, ਜੋ  ਕਿ ਬੁੱਕਮਾਰਕ, ਅਤੀਤ ਜਾਂ ਪਾਸਵਰਡ ਡਾਟਾ ਰੱਖਦਾ ਹੋਵੇ।

import-source-page-title = ਸੈਟਿੰਗ ਅਤੇ ਡਾਟਾ ਇੰਪੋਰਟ ਕਰੋ
import-items-page-title = ਇੰਪੋਰਟ ਕਰਨ ਲਈ ਆਈਟਮਾਂ

import-items-description = ਇੰਪੋਰਟ ਕਰਨ ਲਈ ਆਈਟਮਾਂ ਚੁਣੋ:

import-migrating-page-title = ਇੰਪੋਰਟ ਕੀਤੀਆਂ ਜਾਂਦੀਆਂ ਹਨ...

import-migrating-description = ਹੇਠ ਦਿੱਤੀਆਂ ਆਈਟਮਾਂ ਇੰਪੋਰਟ ਕੀਤੀਆਂ ਜਾ ਰਹੀਆਂ ਹਨ...

import-select-profile-page-title = ਪਰੋਫਾਇਲ ਚੁਣੋ

import-select-profile-description = ਇਹ ਪਰੋਫਾਇਲ ਇੰਪੋਰਟ ਕਰਨ ਲਈ ਉਪਲੱਬਧ ਹਨ:

import-done-page-title = ਇੰਪੋਰਟ ਮੁਕੰਮਲ ਹੋਇਆ

import-done-description = ਇਹ ਆਈਟਮਾਂ ਸਫਲਤਾਪੂਰਕ ਇੰਪੋਰਟ ਕੀਤੀਆਂ ਗਈਆਂ ਹਨ:

import-close-source-browser = ਜਾਰੀ ਰੱਖਣ ਤੋਂ ਪਹਿਲਾਂ ਚੁਣੇ ਗਏ ਬਰਾਊਜ਼ਰ ਦੇ ਬੰਦ ਕਰਨ ਨੂੰ ਯਕੀਨੀ ਬਣਾਓ।

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = { $source } ਤੋਂ

source-name-ie = ਇੰਟਰਨੈੱਟ ਐਕਸਪਲੋਰਰ
source-name-edge = Microsoft Edge
source-name-edge-beta = Microsoft Edge Beta
source-name-safari = Safari
source-name-canary = Google Chrome Canary
source-name-chrome = ਗੂਗਲ ਕਰੋਮ
source-name-chrome-beta = ਗੂਗਲ ਕਰੋਮ ਬੀਟਾ
source-name-chrome-dev = ਗੂਗਲ ਕਰੋਮ ਡਿਵ
source-name-chromium = Chromium
source-name-firefox = ਮੋਜ਼ੀਲਾ ਫਾਇਰਫਾਕਸ
source-name-360se = 360 ਸੁਰੱਖਿਆ ਬਰਾਊਜ਼ਰ

imported-safari-reading-list = ਪੜ੍ਹਨ ਸੂਚੀ (ਸਫਾਰੀ ਤੋਂ)
imported-edge-reading-list = ਪੜ੍ਹਨ ਸੂਚੀ (Edge ਤੋਂ)

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
    .label = ਕੂਕੀਜ਼
browser-data-cookies-label =
    .value = ਕੂਕੀਜ਼

browser-data-history-checkbox =
    .label =
        { $browser ->
            [firefox] ਬਰਾਊਜ਼ਿੰਗ ਅਤੀਤ ਅਤੇ ਬੁੱਕਮਾਰਕ
           *[other] ਬਰਾਊਜ਼ਿੰਗ ਅਤੀਤ
        }
browser-data-history-label =
    .value =
        { $browser ->
            [firefox] ਬਰਾਊਜ਼ ਕਰਨ ਦਾ ਅਤੀਤ ਅਤੇ ਬੁੱਕਮਾਰਕ
           *[other] ਬਰਾਊਜ਼ ਕਰਨ ਦਾ ਅਤੀਤ
        }

browser-data-formdata-checkbox =
    .label = ਸੰਭਾਲਿਆ ਫਾਰਮ ਅਤੀਤ
browser-data-formdata-label =
    .value = ਸੰਭਾਲਿਆ ਫਾਰਮ ਅਤੀਤ

# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-checkbox =
    .label = ਸੰਭਾਲੇ ਹੋਏ ਲਾਗ-ਇਨ ਅਤੇ ਪਾਸਵਰਡ
# This string should use the same phrase for "logins and passwords" as the
# label in the main hamburger menu that opens about:logins.
browser-data-passwords-label =
    .value = ਸੰਭਾਲੇ ਹੋਏ ਲਾਗ-ਇਨ ਅਤੇ ਪਾਸਵਰਡ

browser-data-bookmarks-checkbox =
    .label =
        { $browser ->
            [ie] ਮਨਪਸੰਦ
            [edge] ਮਨਪਸੰਦ
           *[other] ਬੁੱਕਮਾਰਕ
        }
browser-data-bookmarks-label =
    .value =
        { $browser ->
            [ie] ਮਨਪਸੰਦ
            [edge] ਮਨਪਸੰਦ
           *[other] ਬੁੱਕਮਾਰਕ
        }

browser-data-otherdata-checkbox =
    .label = ਹੋਰ ਡਾਟਾ
browser-data-otherdata-label =
    .label = ਹੋਰ ਡਾਟਾ

browser-data-session-checkbox =
    .label = ਵਿੰਡੋ ਅਤੇ ਟੈਬਾਂ
browser-data-session-label =
    .value = ਵਿੰਡੋ ਅਤੇ ਟੈਬਾਂ
