# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = ದತ್ತಾಂಶ ಮೂಲವನ್ನು ಪಿಂಗ್ ಮಾಡಿ:
about-telemetry-show-archived-ping-data = ಸಂಗ್ರಹಿಸಿದ ಪಿಂಗ್ ದತ್ತಾಂಶ
about-telemetry-show-subsession-data = ಉಪಅಧಿವೇಶನ ದತ್ತಾಂಶವನ್ನು ತೋರಿಸು
about-telemetry-choose-ping = ಪಿಂಗ್ ಆಯ್ಕೆ ಮಾಡು:
about-telemetry-archive-ping-header = ಪಿಂಗ್
about-telemetry-option-group-today = ಇಂದು
about-telemetry-option-group-yesterday = ನಿನ್ನೆ
about-telemetry-option-group-older = ಹಳೆಯದು
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = ಟೆಲಿಮೆಟ್ರಿ ದತ್ತಾಂಶ
about-telemetry-more-information = ಮತ್ತಷ್ಟು ಮಾಹಿತಿಗಾಗಿ ಹುಡುಕುತ್ತಿರುವಿರಾ?
about-telemetry-show-in-Firefox-json-viewer = JSON ವೀಕ್ಷಕದಲ್ಲಿ ತೆರೆಯಿರಿ
about-telemetry-home-section = ನೆಲೆ
about-telemetry-general-data-section =   ಸಾಮಾನ್ಯ ದತ್ತಾಂಶ
about-telemetry-environment-data-section = ಪರಿಸರ ದತ್ತಾಂಶ
about-telemetry-session-info-section = ಅಧಿವೇಶನದ ಮಾಹಿತಿ
about-telemetry-scalar-section = ಸ್ಕಾಲಾರ್‍‍ಗಳು
about-telemetry-histograms-section = ಹಿಸ್ಟೊಗ್ರಾಮ್‌ಗಳು
about-telemetry-keyed-histogram-section =   ಟೈಪಿಸಿದ ಹಿಸ್ಟೋಗ್ರಾಮ್‌ಗಳು
about-telemetry-events-section = ಕಾರ್ಯಕ್ರಮಗಳು
about-telemetry-simple-measurements-section = ಸರಳವಾದ ಅಳತೆಗಳು
about-telemetry-slow-sql-section = ನಿಧಾನವಾದ SQL ಹೇಳಿಕೆಗಳು
about-telemetry-addon-details-section =   ಆಡ್-ಆನ್ ವಿವರಗಳು
about-telemetry-late-writes-section = ತಡವಾಗಿ ಬರೆಯುವಿಕೆ
about-telemetry-raw = ಸಂಸ್ಕರಿಸದ JSON
about-telemetry-full-sql-warning =   NOTE ನಿಧಾನಗತಿ SQL ದೋಷನಿದಾನವನ್ನು ಸಕ್ರಿಯಗೊಳಿಸಲಾಗಿದೆ. ಸಂಪೂರ್ಣ SQL ವಾಕ್ಯಾಂಶಗಳನ್ನು ಈ ಕೆಳಗೆ ತೋರಿಸಲಾಗುವ ಸಾಧ್ಯತೆ ಇದೆ ಆದರೆ ಅವುಗಳನ್ನು ಟೆಲಿಮೆಟ್ರಿಗೆ ಸಲ್ಲಿಸಲಾಗುವುದಿಲ್ಲ.
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] ಸಕ್ರಿಯಗೊಳಿಸಿದೆ
       *[disabled] ನಿಷ್ಕ್ರಿಯಗೊಳಿಸಿದ
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = ಈ ಪುಟವು, ಟೆಲಿಮೆಟ್ರಿಯಿಂದ ಸಂಗ್ರಹಿಸಲಾದ ಕಾರ್ಯನಿರ್ವಹಣೆ, ಯಂತ್ರಾಂಶ, ಬಳಕೆ, ಮತ್ತು ಅಗತ್ಯಾನುಗುಣಗೊಳಿಕೆಯ ಕುರಿತಾದ ಮಾಹಿತಿಯನ್ನು ಹೊಂದಿರುತ್ತದೆ. { -brand-full-name } ಅನ್ನು ಸುಧಾರಿಸಲು ಈ ಮಾಹಿತಿಯನ್ನು { $telemetryServerOwner } ಗೆ ಸಲ್ಲಿಸಲಾಗಿದೆ.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = ಮಾಹಿತಿಯ ಪ್ರತಿಯೊಂದು ಕಣವನ್ನು “<a data-l10n-name="ping-link">ಪಿಂಗ್‌ಗಳು</a>” ಗೆ ಜೋಡಿಸಲಾಗಿದೆ. ನೀವು { $name }, { $timestamp } ಪಿಂಗ್ ಅನ್ನು ನೋಡುತ್ತಿದ್ದೀರಿ.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = { $selectedTitle } ನಲ್ಲಿ ಹುಡುಕಿ
about-telemetry-filter-all-placeholder =
    .placeholder = ಎಲ್ಲಾ ವಿಭಾಗಗಳಲ್ಲಿ ಹುಡುಕು
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = “{ $searchTerms }” ಗೆ ಫಲಿತಾಂಶಗಳು
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = ಎಲ್ಲ
# button label to copy the histogram
about-telemetry-histogram-copy = ಪ್ರತಿ ಮಾಡು
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = ಮುಖ್ಯ ತ್ರೆಡ್‌ಗಳಲ್ಲಿ ನಿಧಾನವಾದ SQL ಹೇಳಿಕೆಗಳು
about-telemetry-slow-sql-other = ಹೆಲ್ಪರ್ ತ್ರೆಡ್‌ಗಳಲ್ಲಿ ನಿಧಾನವಾದ SQL ಹೇಳಿಕೆಗಳು
about-telemetry-slow-sql-hits = ಭೇಟಿಗಳು
about-telemetry-slow-sql-average = ಸರಾಸರಿ ಸಮಯ (ms)
about-telemetry-slow-sql-statement = ಹೇಳಿಕೆ
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ಆಡ್-ಆನ್ ID
about-telemetry-addon-table-details = ವಿವರಗಳು
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } ಪೂರೈಕೆಗಾರ
about-telemetry-keys-header = ಗುಣ
about-telemetry-names-header = ಹೆಸರು
about-telemetry-values-header = ಮೌಲ್ಯ
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = ತಡವಾದ ಬರೆಯುವಿಕೆ #{ $lateWriteCount }
about-telemetry-stack-title = ಸ್ಟ್ಯಾಕ್:
about-telemetry-memory-map-title = ಮೆಮೊರಿ ನಕ್ಷೆ:
about-telemetry-error-fetching-symbols = ಸಂಕೇತಗಳನ್ನು ಪಡೆದುಕೊಳ್ಳುವಾಗ ಒಂದು ದೋಷವು ಎದುರಾಗಿದೆ. ನೀವು ಅಂತರಜಾಲಕ್ಕೆ ಸಂಪರ್ಕಿತಗೊಂಡಿದ್ದೀರಿ ಎಂದು ಪರೀಕ್ಷಿಸಿ ನಂತರ ಇನ್ನೊಮ್ಮೆ ಪ್ರಯತ್ನಿಸಿ..
about-telemetry-time-stamp-header = ಸಮಯಗುರುತು
about-telemetry-category-header = ವರ್ಗ
about-telemetry-method-header = ವಿಧಾನ
about-telemetry-object-header = ವಸ್ತು
about-telemetry-extra-header = ಹೆಚ್ಚಿನ
