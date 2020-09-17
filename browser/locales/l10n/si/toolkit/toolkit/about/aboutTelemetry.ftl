# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = පින්ග් දත්ත මූලය:
about-telemetry-show-archived-ping-data = සංරක්ශිත පින්ග් දත්ත
about-telemetry-show-subsession-data = අනුවාර දත්ත පෙන්වන්න
about-telemetry-choose-ping = පින්ග් තෝරන්න:
about-telemetry-archive-ping-header = පින්ග්
about-telemetry-option-group-today = අද
about-telemetry-option-group-yesterday = ඊයේ
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = දූරමිතික දත්ත
about-telemetry-home-section = නිවස
about-telemetry-general-data-section = සාමාන්‍ය දත්ත
about-telemetry-environment-data-section = පාරිසරික දත්ත
about-telemetry-session-info-section = වාර තොරතුරු
about-telemetry-histograms-section =     හිස්ටොග්‍රෑම්
about-telemetry-keyed-histogram-section = යතුරුකළ ජාලරේඛය
about-telemetry-events-section = සිදුවීම්
about-telemetry-simple-measurements-section =   සරල මිනුම්
about-telemetry-slow-sql-section =     SQL ප්‍රකාශ පෙන්වන්න
about-telemetry-addon-details-section =   ඇඩෝන තොරතුරු
about-telemetry-late-writes-section =   පසු ලිවීම්
about-telemetry-raw = දළ JSON
about-telemetry-full-sql-warning =     NOTE: මන්දගාමි SQL නිරාකරණය සක්‍රීයයි. සම්පූර්ණ SQL යෙදීම් පහතින් දැක්වෙනු ඇති නමුත් ඒවා දූරමිතියට පළ නොකෙරේ.
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] සක්‍රීය කළ
       *[disabled] අක්‍රීයයි
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Mozilla"
about-telemetry-page-subtitle = මෙම පිටුව දූරාමිතිය මගින් එක්රැස් කරන කාර්ය්‍යක්ෂමතාව, දෘඩාංග, භාවිතය හා රුචිකරණ තොරතුරු පෙන්වයි. මෙම තොරතුරු { -brand-full-name } වැඩිදියුණු කිරීමට සහයවීම සඳහා { $telemetryServerOwner } වෙත පළ කෙරේ.
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = සියල්ල
# button label to copy the histogram
about-telemetry-histogram-copy = පිටපත් කරන්න
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = ප්‍රධාන තීරුව මත මන්දගාමී SQL ප්‍රකාශ
about-telemetry-slow-sql-other = සහායක තීරු මත මන්දගාමී SQL ප්‍රකාශ
about-telemetry-slow-sql-hits = පිවිසුම්
about-telemetry-slow-sql-average = සාමාන්‍ය.කාලය (මිත)
about-telemetry-slow-sql-statement = ප්‍රකාශය
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = ඇඩෝන් හැඳිනීම
about-telemetry-addon-table-details = තොරතුරු
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } සැපයුම්කරු
about-telemetry-keys-header = වත්කම
about-telemetry-names-header = නම
about-telemetry-values-header = අගය
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = පසු ලිවීම #{ $lateWriteCount }
about-telemetry-stack-title = ගොඩ:
about-telemetry-memory-map-title = මතක සිතියම:
about-telemetry-error-fetching-symbols = සංඛේත ලැබීමේ දෝශයක් ඇතිවිය. ඔබ අන්තර්ජාලයට සබඳ දැයි පිරික්සා නැවත උත්සහ කරන්න.
about-telemetry-time-stamp-header = කාල මුද්‍රාව
about-telemetry-category-header = ප්‍රභේදය
about-telemetry-method-header = ක්‍රමය
about-telemetry-object-header = වස්තුව
about-telemetry-extra-header = අමතර
