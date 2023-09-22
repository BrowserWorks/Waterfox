# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Each migrator is expected to include a display name string, and that display
# name string should have a key with "migration-wizard-migrator-display-name-"
# as a prefix followed by the unique identification key for the migrator.

migration-wizard-migrator-display-name-canary = كروم كناري
migration-wizard-migrator-display-name-chrome = كروم
migration-wizard-migrator-display-name-chrome-beta = كروم بيتا
migration-wizard-migrator-display-name-chrome-dev = إصدارة كروم التطويرية
migration-wizard-migrator-display-name-chromium = كروميوم
migration-wizard-migrator-display-name-chromium-360se = متصفح ٣٦٠ الآمن
migration-wizard-migrator-display-name-chromium-edge = ميكروسوفت إدج
migration-wizard-migrator-display-name-chromium-edge-beta = ميكروسوفت إدج بيتا
migration-wizard-migrator-display-name-edge-legacy = ميكروسوفت إدج العتيق
migration-wizard-migrator-display-name-firefox = Waterfox
migration-wizard-migrator-display-name-ie = ميكروسوفت إنترنت إكسبلورر
migration-wizard-migrator-display-name-safari = سافاري

## These strings will be displayed based on how many resources are selected to import


##

# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
migration-passwords-from-file-csv-filter-title =
    { PLATFORM() ->
        [macos] مستند CSV
       *[other] ملف CSV
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
migration-passwords-from-file-tsv-filter-title =
    { PLATFORM() ->
        [macos] مستند TSV
       *[other] ملف TSV
    }

## These strings will be used to create a dynamic list of items that can be
## imported. The list will be created using Intl.ListFormat(), so it will
## follow each locale's rules, and the first item will be capitalized by code.
## When applicable, the resources should be in their plural form.
## For example, a possible list could be "Bookmarks, passwords and autofill data".


##


## The import process identifies extensions installed in other supported
## browsers and installs the corresponding (matching) extensions compatible
## with Waterfox, if available.

##

