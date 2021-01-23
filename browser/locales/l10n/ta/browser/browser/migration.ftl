# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = விசார்டை இறக்குமதி செய்

import-from =
    { PLATFORM() ->
        [windows] தேர்வுகள், புத்தகக்குறிகள், வரலாறு, கடவுச்சொற்கள் மற்றும் வேறு தரவு போன்றவற்றை இதிலிருந்து இறக்கு:
       *[other] முன்னுரிமைகள், புத்தகக்குறிகள், வரலாறு, கடவுச்சொற்கள் மற்றும் வேறு தரவு போன்றவற்றை இதிலிருந்து இறக்கு:
    }

import-from-bookmarks = இதிலிருந்து புத்தகக்குறிகளை இறக்கு:
import-from-ie =
    .label = மைக்ரோசாப்ட் இன்டர்நெட் எக்ஸ்ப்லோரர்
    .accesskey = ம
import-from-edge =
    .label = மைக்ரொசொப்ட் எட்ஜ்
    .accesskey = E
import-from-nothing =
    .label = எதையும் இறக்க வேண்டாம்
    .accesskey = D
import-from-safari =
    .label = சபாரி
    .accesskey = ச
import-from-canary =
    .label = குரோம் கெனரி
    .accesskey = n
import-from-chrome =
    .label = கொறோம்
    .accesskey = க
import-from-chrome-beta =
    .label = குரோம் பீட்டா
    .accesskey = B
import-from-chrome-dev =
    .label = குரோம் டெவ்
    .accesskey = D
import-from-chromium =
    .label = குரோமியம்
    .accesskey = u
import-from-firefox =
    .label = பயர்பாக்ஸ்(x)
    .accesskey = x
import-from-360se =
    .label = 360 சுழற்சியில் பாதுகாப்பான உலாவி
    .accesskey = 3

no-migration-sources = புத்தகக்குறிகள், வரலாறு அல்லது கடவுச்சொல் தரவு போன்றவற்றைக் கொண்ட நிரல்களை காண முடியவில்லை.

import-source-page-title = இறக்குதல் அமைவுகள் மற்றும் தரவு
import-items-page-title = இறக்க வேண்டிய உருப்படிகள்

import-items-description = எந்த உருப்படிகளை இறக்க வேண்டும் என தேர்ந்தெடுக்கவும்:

import-migrating-page-title = இறக்குகிறது…

import-migrating-description = பின்வரும் உருப்படிகள் தற்போது இறக்கப்பட வேண்டும்…

import-select-profile-page-title = விவரக்குறிப்பை தேர்ந்தெடு

import-select-profile-description = பின்வரும் விவரக்குறிப்புகள் இறக்க தயாராக உள்ளன:

import-done-page-title = இறக்குதல் முடிவு

import-done-description = பின்வரும் உருப்படிகள் வெற்றிகரமாக இறக்கப்பட்டது:

import-close-source-browser = தொடரும் முன் தேர்ந்தெடுக்கப்பட்ட உலாவி மூடப்பட்டுள்ளதா என உறுதிப்படுத்து.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = { $source } லிருந்து

source-name-ie = இன்டர்நெட் எக்ஸ்ப்ளோரர்
source-name-edge = மைக்ரொசொப்ட் எட்ஜ்
source-name-safari = சபாரி
source-name-canary = கூகுள் குரோம் கெனரி
source-name-chrome = கூகுள் கொறோம்
source-name-chrome-beta = கூகுள் குரோம் பீட்டா
source-name-chrome-dev = கூகுள் குரோம் டெவ்
source-name-chromium = குரோமியம்
source-name-firefox = மொசில்லா பயர்பாக்ஸ்
source-name-360se = 360 சுழற்சியில் பாதுகாப்பான உலாவி

imported-safari-reading-list = (சபாரியில் இருந்து ) பட்டியல் படிக்கப்படுகிறது
imported-edge-reading-list = (எட்ஜ்லிருந்து) பட்டியல் படிக்கப்படுகிறது

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
    .label = சாளரங்களும் கீற்றுகளும்
browser-data-session-label =
    .value = சாளரங்களும் கீற்றுகளும்
