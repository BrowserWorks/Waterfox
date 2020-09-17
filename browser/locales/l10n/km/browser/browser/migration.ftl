# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard =
    .title = អ្នក​ជំនួយ​ការ​នាំចូល

import-from =
    { PLATFORM() ->
        [windows] នាំចូល​ជម្រើស​ ចំណាំ​ ប្រវត្តិ ពាក្យសម្ងាត់ និង ទិន្នន័យ​ផ្សេងៗ​ពី ៖
       *[other] នាំចូល​ចំណង់​ចំណូល​ចិត្ត ចំណាំ​ ប្រវត្តិ ពាក្យ​សម្ងាត់ និង ទិន្នន័យ​ផ្សេងៗ​ពី ៖
    }

import-from-bookmarks = នាំចូល​ចំណាំ​ពី ៖
import-from-ie =
    .label = Microsoft Internet Explorer
    .accesskey = M
import-from-edge =
    .label = Microsoft Edge
    .accesskey = E
import-from-nothing =
    .label = កុំ​នាំចូល​អ្វីៗ​ទាំងអស់
    .accesskey = D
import-from-safari =
    .label = Safari
    .accesskey = S
import-from-canary =
    .label = Chrome Canary
    .accesskey = n
import-from-chrome =
    .label = Chrome
    .accesskey = C
import-from-chromium =
    .label = Chromium
    .accesskey = u
import-from-firefox =
    .label = Firefox
    .accesskey = F
import-from-360se =
    .label = កម្មវិធី​អ៊ីនធឺណិត​សុវត្ថិភាព 360
    .accesskey = 3

no-migration-sources = រក​មិន​ឃើញ​កម្មវិធី​ដែល​មាន ចំណាំ ប្រវត្តិ ឬ​ទិន្នន័យ​ពាក្យ​សម្ងាត់​ទេ ។

import-source-page-title = នាំចូល​ការ​កំណត់ និង​ទិន្នន័យ
import-items-page-title = ធាតុ​ដែល​ត្រូវ​នាំចូល

import-items-description = ជ្រើស​វត្ថុ​ណាមួយ​ ដែល​ត្រូវ​នាំចូល ៖

import-migrating-page-title = កំពុង​នាំចូល...

import-migrating-description = ធាតុ​ដូច​ខាង​ក្រោយ​បច្ចុប្បន្ន​កំពុង​ត្រូវ​បាននាំចូល...

import-select-profile-page-title = ជ្រើស​ទម្រង់

import-select-profile-description = ទម្រង់​ខាងក្រោម​ អាច​នាំចូល​បាន​ពី ៖

import-done-page-title = ការ​នាំ​ចូល​បញ្ចប់​ទាំងស្រុង

import-done-description = ធាតុ​ខាងក្រោម ត្រូវ​បាន​នាំចូល​ដោយ​ជោគជ័យ ៖

import-close-source-browser = សូម​ប្រាកដ​ថា​​បាន​បិទ​កម្មវិធី​អ៊ីនធឺណិត​​ដែល​បាន​ជ្រើស​​មុន​ពេល​បន្ត។

# Displays which browser the bookmarks are being imported from
#
# Variables:
#   $source (String): The browser the user has chosen to import bookmarks from.
imported-bookmarks-source = ពី { $source }

source-name-ie = Internet Explorer
source-name-edge = Microsoft Edge
source-name-safari = Safari
source-name-canary = Google Chrome Canary
source-name-chrome = Google Chrome
source-name-chromium = Chromium
source-name-firefox = Mozilla Firefox
source-name-360se = 360 Secure Browser

imported-safari-reading-list = បញ្ជី​អំណាន (ពី Safari)
imported-edge-reading-list = បញ្ជី​អំណាន (ពី​​ Edge)

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
    .label = បង្អួច និង​ផ្ទាំង
browser-data-session-label =
    .value = បង្អួច និង​ផ្ទាំង
