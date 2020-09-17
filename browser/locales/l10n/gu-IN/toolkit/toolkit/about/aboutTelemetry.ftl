# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = ડેટા સ્રોત પિંગ કરો:
about-telemetry-show-archived-ping-data = આર્કાઇવ કરેલ પિંગ ડેટા
about-telemetry-show-subsession-data = ઉપસત્ર ડેટા બતાવો
about-telemetry-choose-ping = પિંગ પસંદ કરો:
about-telemetry-archive-ping-type = પિંગ પ્રકાર
about-telemetry-archive-ping-header = પિંગ
about-telemetry-option-group-today = આજે
about-telemetry-option-group-yesterday = ગઇકાલે
about-telemetry-option-group-older = જૂનું
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = ટેલીમેટ્રી માહિતી
about-telemetry-more-information = વધુ માહિતી જોઈએ છે?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Firefox ડેટા દસ્તાવેજીકરણ</a> માં અમારા ડેટા સાધનો સાથે કેવી રીતે કામ કરવું તે વિશેની માર્ગદર્શિકાઓ છે.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Firefox ટેલિમેટ્રી ક્લાયંટ દસ્તાવેજીકરણ</a> વિભાવનાઓ, API દસ્તાવેજીકરણ અને ડેટા સંદર્ભો માટેની વ્યાખ્યાઓનો સમાવેશ કરે છે.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">ટેલીમેટ્રી ડેશબોર્ડ્સ</a> તમને Mozilla ડેટા મારફતે વિઝ્યુઅલાઈઝ કરવા માટે પરવાનગી આપે છે જે ટેલીમેટ્રી મારફતે મેળવે છે.
about-telemetry-telemetry-probe-dictionary = <a data-l10n-name="probe-dictionary-link">Probe Dictionary</a> એ ટેલિમેટ્રી દ્વારા એકત્રિત કરેલી ચકાસણીઓ માટેની વિગતો અને વર્ણનો પ્રદાન કરે છે.
about-telemetry-show-in-Firefox-json-viewer = JSON દર્શકમાં ખોલો
about-telemetry-home-section = મુખ્ય પાનું
about-telemetry-general-data-section = સામાન્ય ડેટા
about-telemetry-environment-data-section = Environment ડેટા
about-telemetry-session-info-section = સત્ર માહિતી
about-telemetry-scalar-section = સ્કેલર્સ
about-telemetry-keyed-scalar-section = કી સ્કેલર્સ
about-telemetry-histograms-section = હિસ્ટોગ્રામ
about-telemetry-keyed-histogram-section = કી હિસ્ટોગ્રામ
about-telemetry-events-section = ઘટનાઓ
about-telemetry-simple-measurements-section = સાદા માપન
about-telemetry-slow-sql-section = ધીમા SQL વાક્યો
about-telemetry-addon-details-section = ઍડ-ઑન વિગતો
about-telemetry-captured-stacks-section = કેપ્ચર કરેલ સ્ટેક્સ
about-telemetry-late-writes-section = અંતમાં લખે છે
about-telemetry-raw-payload-section = કાચો પેલોડ
about-telemetry-raw = કાચો JSON
about-telemetry-full-sql-warning = નોંધ: ધીમુ SQL ડિબગીંગ સક્રિય થયેલ છે. સંપૂર્ણ SQL શબ્દમાળાઓ એ નીચે દર્શાવી શકાય છે પરંતુ તેઓ ટેલીમેટ્રીમાં સમાવશે નહિં.
about-telemetry-fetch-stack-symbols = સ્ટેક્સ માટે ફકશંન નામો મેળવો
about-telemetry-hide-stack-symbols = કાચા સ્ટેક ડેટા બતાવો
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] રિલીઝ ડેટા
       *[prerelease] પ્રી-રિલીઝ ડેટા
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] સક્ષમ
       *[disabled] અક્ષમ કરેલ
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
        [one] { $sampleCount } નમૂના, સરેરાશ = { $prettyAverage }, સરવાળો = { $sum }
       *[other] { $sampleCount } નમૂનાઓ, સરેરાશ = { $prettyAverage }, સરવાળો = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = This page shows the information about performance, hardware, usage and customizations collected by Telemetry. This information is submitted to { $telemetryServerOwner } to help improve { -brand-full-name }.
about-telemetry-settings-explanation = ટેલીમેટ્રી { about-telemetry-data-type } એકત્રિત કરી રહ્યું છે અને અપલોડ <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a> છે.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = દરેક ભાગની માહિતીને “<a data-l10n-name="ping-link">પિંગ્સ</a>” માં મોકલવામાં આવે છે. તમે { $name }, { $timestamp } પિંગ જોઈ રહ્યાં છો.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = { $selectedTitle } માં શોધો
about-telemetry-filter-all-placeholder =
    .placeholder = બધા વિભાગોમાં શોધો
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = “{ $searchTerms }” માટે પરિણામો
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = માફ કરશો! “{ $currentSearchText }” માટે { $sectionName } માં કોઈ પરિણામો નથી
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = માફ કરશો! “{ $searchTerms }” માટે કોઈ પણ વિભાગોમાં કોઈ પરિણામો નથી
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = માફ કરશો! હાલમાં “{ $sectionName }” માં કોઈ ડેટા ઉપલબ્ધ નથી
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = બધા
# button label to copy the histogram
about-telemetry-histogram-copy = નકલ
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = મુખ્ય થ્રેડ પર ધીમા SQL વાક્યો
about-telemetry-slow-sql-other = મદદકર્તા થ્રેડ પર ધીમા SQL વાક્યો
about-telemetry-slow-sql-hits = હિટ્સ
about-telemetry-slow-sql-average = સરેરાશ સમય (ms)
about-telemetry-slow-sql-statement = વાક્ય
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ઍડ-ઑન ID
about-telemetry-addon-table-details = વિગતો
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } પ્રોવાઇડર
about-telemetry-keys-header = ગુણધર્મ
about-telemetry-names-header = નામ
about-telemetry-values-header = કિંમત
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (કેપ્ચર ગણના: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = #{ $lateWriteCount } ને અંતમાં લખે છે
about-telemetry-stack-title = સ્ટેક:
about-telemetry-memory-map-title = મેમરી નક્ષો:
about-telemetry-error-fetching-symbols = ભૂલ ઉદ્ભવી જ્યારે સંકેતને લાવી રહ્યા હોય. ચકાસો કે તમે ઇન્ટરનેટમાં જોડાયેલ છે અને ફરી પ્રયત્ન કરો.
about-telemetry-time-stamp-header = ટાઇમસ્ટેમ્પ
about-telemetry-category-header = શ્રેણી
about-telemetry-method-header = પદ્ધતિ
about-telemetry-object-header = ઑબ્જેક્ટ
about-telemetry-extra-header = વધારાની
about-telemetry-origin-origin = મૂળ
about-telemetry-origin-count = સંખ્યા
