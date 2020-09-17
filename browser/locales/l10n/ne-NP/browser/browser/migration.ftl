# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = आयात विजार्ड

import-from =
    { PLATFORM() ->
        [windows] विकल्पहरू, पुस्तकचिनोहरू, इतिहास, गोप्यशब्दहरू र अन्य डाटा आयात गर्नुहोस्:
       *[other] प्राथमिकताहरू ,पुस्तकचिनोहरू, इतिहास, गोप्यशब्दहरू र अन्य डाटा आयात गर्नुहोस्:
    }

import-from-bookmarks = बाट पुस्तकचिनो आयात गर्नुहोस्:
import-from-ie =
    .label = माइक्रोसफ्ट इन्टरनेट एक्सप्लोरर
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-nothing =
    .label = केहि पनि आयात नगर्नुहोस्
    .accesskey = D
import-from-safari =
    .label = सफारी
    .accesskey = S
import-from-canary =
    .label = Chrome Canary
    .accesskey = n
import-from-chrome =
    .label = क्रोम
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

no-migration-sources = पुस्तकचिनोहरू, इतिहास अथवा गोप्यशब्द डाटा नभएका कार्यक्रमहरू भेटिन सक्छन्।

import-source-page-title = डाटा र सेटिङहरू आयात गर्नुहोस्
import-items-page-title = आयत गर्नपर्ने कुराहरू

import-items-description = आयात गर्ने चिज छान्नुहोस:

import-migrating-page-title = आयात हुँदैछ…

import-migrating-description = निम्नलिखित चिजहरू आयात हुँदै…

import-select-profile-page-title = प्रोफाइल छान्नुहोस्

import-select-profile-description = निम्न लिखित प्रोफाइलहरू आयात गर्न उपलब्ध छन्:

import-done-page-title = आयात पूरा भयो

import-done-description = निम्नलिखित चिजहरू सफलतापूर्वक आयात गरियो:

import-close-source-browser = कृपया जारी गर्नु पुर्व, चयन गरिएको ब्राउजर बन्द भएको सुनिश्चित गर्नुहोस्।

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = { $source } बाट

source-name-ie = ईन्टरनेट एक्स्पोलर
source-name-edge = Microsoft Edge
source-name-safari = सफारी
source-name-canary = Google Chrome Canary
source-name-chrome = गूगल क्रोम
source-name-chrome-beta = Google Chrome Beta
source-name-chrome-dev = Google Chrome Dev
source-name-chromium = Chromium
source-name-firefox = Mozilla Firefox
source-name-360se = 360 Secure Browser

imported-safari-reading-list = पढ्ने सुची (सफारी बाट)
imported-edge-reading-list = पढ्ने सूची (किनाराबाट)

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

browser-data-session-checkbox =
    .label = संझ्याल तथा ट्याबहरू
browser-data-session-label =
    .value = संझ्याल तथा ट्याबहरू
