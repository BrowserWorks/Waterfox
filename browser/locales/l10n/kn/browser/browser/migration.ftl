# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = ವಿಝಾರ್ಡನ್ನು ಆಮದು ಮಾಡಿಕೊ

import-from =
    { PLATFORM() ->
        [windows] ಇಲ್ಲಿಂದ ಆಯ್ಕೆಗಳನ್ನು, ಬುಕ್‍ಮಾರ್ಕುಗಳನ್ನು, ಇತಿಹಾಸ, ಗುಪ್ತಪದ ಹಾಗು ಇತರೆ ಮಾಹಿತಿಯನ್ನು ಆಮದು ಮಾಡಿಕೊ:
       *[other] ಇಲ್ಲಿಂದ ಆದ್ಯತೆಗಳನ್ನು, ಬುಕ್‍ಮಾರ್ಕುಗಳನ್ನು, ಇತಿಹಾಸ, ಗುಪ್ತಪದ ಹಾಗು ಇತರೆ ಮಾಹಿತಿಯನ್ನು ಆಮದು ಮಾಡಿಕೊ:
    }

import-from-bookmarks = ಇಲ್ಲಿಂದ ಬುಕ್‍ಮಾರ್ಕುಗಳನ್ನು ಆಮದು ಮಾಡಿಕೊ:
import-from-ie =
    .label = ಮೈಕ್ರೋಸಾಫ್ಟ್‍ ಇಂಟರ್ನೆಟ್ ಎಕ್ಸ್‍ಪ್ಲೋರರ್
    .accesskey = M
import-from-edge =
    .label = ಮೈಕ್ರೋಸಾಫ್ಟ್ ಎಜ್
    .accesskey = E
import-from-nothing =
    .label = ಏನನ್ನೂ ಆಮದು ಮಾಡಿಕೊಳ್ಳಬೇಡ
    .accesskey = D
import-from-safari =
    .label = ಸಫಾರಿ
    .accesskey = S
import-from-canary =
    .label = ಕ್ರೋಮ್ ಕ್ಯಾನರಿ
    .accesskey = n
import-from-chrome =
    .label = ಕ್ರೋಮ್
    .accesskey = C
import-from-chrome-beta =
    .label = ಕ್ರೋಮ್ ಬೀಟಾ
    .accesskey = B
import-from-chrome-dev =
    .label = ಕ್ರೋಮ್ ಡೆವ್
    .accesskey = D
import-from-chromium =
    .label = ಕ್ರೋಮಿಯಮ್
    .accesskey = u
import-from-firefox =
    .label = ಫೈರ್ಫಾಕ್ಸ್
    .accesskey = x
import-from-360se =
    .label = 360 ಸುರಕ್ಷಿತ ವೀಕ್ಷಕ
    .accesskey = 3

no-migration-sources = ಬುಕ್‍ಮಾರ್ಕುಗಳನ್ನು, ಇತಿಹಾಸ, ಅಥವ ಗುಪ್ತಪದವನ್ನು ಹೊಂದಿರುವ ಯಾವುದೆ ಪ್ರೊಗ್ರಾಂ ಕಂಡು ಬಂದಿಲ್ಲ.

import-source-page-title = ಸಿದ್ಧತೆಗಳನ್ನು ಹಾಗು ಮಾಹಿತಿಯನ್ನು ಆಮದು ಮಾಡಿಕೊ
import-items-page-title = ಆಮದು ಮಾಡಿಕೊಳ್ಳಲು ಅಂಶಗಳು

import-items-description = ಯಾವ ಅಂಶಗಳನ್ನು ಆಮದು ಮಾಡಬೇಕೆಂದು ಆರಿಸಿ:

import-migrating-page-title = ಆಮದು ಮಾಡಲಾಗುತ್ತಿದೆ...

import-migrating-description = ಈ ಕೆಳಗಿನ ಅಂಶಗಳು ಈಗ ಆಮದು ಮಾಡಿಕೊಳ್ಳಲಾಗುತ್ತಿದೆ...

import-select-profile-page-title = ಪ್ರೊಫೈಲ್‌ ಅನ್ನು ಆರಿಸಿ

import-select-profile-description = ಇಲ್ಲಿಂದ ಈ ಕೆಳಗಿನ ಪ್ರೊಫೈಲ್‌ಗಳು ಆಮದಿಗೆ ಲಭ್ಯವಿವೆ:

import-done-page-title = ಆಮದು ಪೂರ್ಣಗೊಂಡಿದೆ

import-done-description = ಈ ಕೆಳಗಿನ ಅಂಶಗಳನ್ನು ಯಶಸ್ವಿಯಾಗಿ ಆಮದು ಮಾಡಿಕೊಳ್ಳಲಾಯಿತು:

import-close-source-browser = ಮುಂದುವರೆಯುವ ಮೊದಲು, ಆಯ್ಕೆ ಮಾಡಲಾದ ಜಾಲವೀಕ್ಷಕವನ್ನು ಮುಚ್ಚಲಾಗಿದೆ ಎಂದು ಖಚಿತಪಡಿಸಿಕೊಳ್ಳಿ.

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = { $source } ನಿಂದ

source-name-ie = ಇಂಟರ್ನೆಟ್ ಎಕ್ಸ್‍ಪ್ಲೋರರ್
source-name-edge = ಮೈಕ್ರೋಸಾಫ್ಟ್ ಎಜ್
source-name-safari = ಸಫಾರಿ
source-name-canary = ಗೂಗಲ್ ಕ್ರೋಮ್ ಕ್ಯಾನರಿ
source-name-chrome = ಗೂಗಲ್ ಕ್ರೋಮ್
source-name-chrome-beta = ಗೂಗಲ್ ಕ್ರೋಮ್ ಬೀಟಾ
source-name-chrome-dev = ಗೂಗಲ್ ಕ್ರೋಮ್ ಡೆವ್
source-name-chromium = ಕ್ರೋಮಿಯಮ್
source-name-firefox = ಮೋಝಿಲ್ಲಾ ಫೈರ್ಫಾಕ್ಸ್
source-name-360se = 360 ಸುರಕ್ಷಿತ ವೀಕ್ಷಕ

imported-safari-reading-list = ಓದುವ ಪಟ್ಟಿ (ಸಫಾರಿಯಿಂದ)
imported-edge-reading-list = ಓದುವ ಪಟ್ಟಿ (ಎಜ್‌ನಿಂದ)

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
    .label = ವಿಂಡೋಗಳು ಹಾಗು ಹಾಳೆಗಳು
browser-data-session-label =
    .value = ವಿಂಡೋಗಳು ಹಾಗು ಹಾಳೆಗಳು
