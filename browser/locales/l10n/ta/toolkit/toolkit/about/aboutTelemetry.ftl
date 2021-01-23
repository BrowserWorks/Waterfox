# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = தரவு மூலத்தை பிங் பன்னு:
about-telemetry-show-archived-ping-data = காக்கப்பட்ட பிங் தரவு
about-telemetry-show-subsession-data = துணையமர்வு தரவைக் காட்டு
about-telemetry-choose-ping = பிங்கைத் தேர்:
about-telemetry-archive-ping-type = பிங் வகை
about-telemetry-archive-ping-header = பிங்
about-telemetry-option-group-today = இன்று
about-telemetry-option-group-yesterday = நேற்று
about-telemetry-option-group-older = பழையவை
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = டெலிமெட்ரி தரவு
about-telemetry-more-information = மேலும் தகவல் தேடுகிறீர்களா?
about-telemetry-show-in-Firefox-json-viewer = JSON பார்வையில் திறக்கவும்
about-telemetry-home-section = முகப்பு
about-telemetry-general-data-section =   பொது தரவு
about-telemetry-environment-data-section = சூழல் தரவு
about-telemetry-session-info-section = கணினி தகவல்
about-telemetry-scalar-section = அளவுகள்
about-telemetry-keyed-scalar-section = விசை திசையிலிகள்
about-telemetry-histograms-section = செவ்வக வரைபடங்கள்
about-telemetry-keyed-histogram-section =   விசையாலான செவ்வகப்படங்கள்
about-telemetry-events-section = நிகழ்வுகள்
about-telemetry-simple-measurements-section = எளிய அளவீடுகள்
about-telemetry-slow-sql-section = மெதுவான SQL கூற்றுகள்
about-telemetry-addon-details-section = கூடுதல் இணைப்புகளின் விவரங்கள்
about-telemetry-captured-stacks-section = கைப்பற்றிய அடுக்குகள்
about-telemetry-late-writes-section = தாமத எழுதல்கள்
about-telemetry-raw-payload-section = பதனிடப்படாத சரக்கு
about-telemetry-raw = பதனிடப்படாத JSON
about-telemetry-full-sql-warning = குறிப்பு: மெதுவான SQL வழுநீக்கல் செயல்படுத்தப்பட்டுள்ளது. முழு SQL சரங்கள் கீழே காண்பிக்கப்படலாம்ஆனால் அவை டெலிமெட்ரிக்கு சமர்ப்பிக்கப்படாது.
about-telemetry-fetch-stack-symbols = ஸ்டேக்குகளுக்காக செயல்தொகுதி பெயர்களைப் பெறு
about-telemetry-hide-stack-symbols = அடுக்கின் பதனிடாத தரவைக் காண்பி
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] வெளியீட்டு தரவு
       *[prerelease] முன் வெளியீட்டு தரவு
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] செயல்படுத்தப்பட்டது
       *[disabled] முடக்கப்பட்டது
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = இந்தப் பக்கமானது, டெலிமெட்ரியின் மூலம் சேகரிக்கப்பட்ட செயல்திறன், வன்பொருள், பயன்பாடு மற்றும் தனிப்பயனாக்கங்கள் குறித்த தகவல்களைக் காண்பிக்கும். { -brand-full-name } ஐ மேம்படுத்துவதற்கு உதவியாக இந்த தகவல் { $telemetryServerOwner } க்கு சமர்ப்பிக்கப்படும்.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = ஒவ்வொரு துண்டு தகவலும் “<a data-l10n-name="ping-link">பிங்குகள்</a>” பொட்டலத்தில் அனுப்பப்பட்டது. நீங்கள் பார்ப்பது { $name }, { $timestamp } பிங் ஆகும்.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = { $selectedTitle } விவரத்தில் கண்டுபிடி
about-telemetry-filter-all-placeholder =
    .placeholder = அனைத்து பிரிவுகளிலும் தேடு
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = “{ $searchTerms }” என்பதற்கான முடிவுகள்
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = மன்னிக்கவும்! “{ $currentSearchText }” என்பதற்கு { $sectionName } என்பதில் எந்த முடிவுகளும் இல்லை
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = மன்னிக்கவும்! “{ $searchTerms }” என்பதற்கு எந்த பிரிவுகளிலும் முடிவுகள் இல்லை
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = அனைத்தும்
# button label to copy the histogram
about-telemetry-histogram-copy = நகலெடு
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = பிரதான தொடரிழைகளில் மெதுவான SQL கூற்றுகள்
about-telemetry-slow-sql-other = உதவி தொடரிழைகளில் மெதுவான SQL கூற்றுகள்
about-telemetry-slow-sql-hits = சொடுக்கங்கள்
about-telemetry-slow-sql-average = சராசரி நேரம் (ms)
about-telemetry-slow-sql-statement = கூற்று
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = கூடுதல் இணைப்பின் அடையாள எண்
about-telemetry-addon-table-details = விவரங்கள்
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } வழங்குநர்
about-telemetry-keys-header = பண்பு
about-telemetry-names-header = பெயர்
about-telemetry-values-header = மதிப்பு
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (பிடிப்பு எண்ணிக்கை: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = தாமத எழுதுதல் #{ $lateWriteCount }
about-telemetry-stack-title = ஸ்டேக்:
about-telemetry-memory-map-title = நினைவக மேப்:
about-telemetry-error-fetching-symbols = சின்னங்களைப் பெறுவதில் பிழை ஏற்பட்டது. நீங்கள் இணையத்துடன் இணைந்துள்ளீர்களா எனப் பார்த்து மீண்டும் முயற்சிக்கவும்.
about-telemetry-time-stamp-header = காலமுத்திரை
about-telemetry-category-header = வகை
about-telemetry-method-header = முறை
about-telemetry-object-header = பொருள்
about-telemetry-extra-header = கூடுதல்
