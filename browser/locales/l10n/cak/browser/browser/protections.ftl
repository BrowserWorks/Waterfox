# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } q'aton { $count } wuqub'ixir chik ojqan
       *[other] { -brand-short-name } q'aton { $count } wuqub'ixir chik e'ojqan
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> ojqanel q'aton chik pe pa { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] <b>{ $count }</b> ojqanela' eq'aton chik pe pa { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } k'a yeruq'atala' rojqanela' Ichinan Tzuwäch, po man yeruyäk ri kitz'ib'axik ri xeq'at.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Ojqanela' { -brand-short-name } xeq'at re wuqq'ij re'

protection-report-webpage-title = Rupas taq Chajinïk
protection-report-page-content-title = Rupas taq Chajinïk
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } nitikïr nuchajij ri awichinaem toq atokinäq pa k'amaya'l. Rere' jun ichinan ch'uti kitzijol ri taq chajinïk, achi'el chuqa' ri taq samajib'äl richin nichap ri jikomal pa k'amab'ey.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } nuchajij ri awichinaem toq atokinäq pa k'amaya'l. Rere' jun ichinan ch'uti kitzijol ri taq chajinïk, achi'el chuqa' ri taq samajib'äl richin nichap ri jikomal pa k'amab'ey.

protection-report-settings-link = Tanuk'samajij runuk'ulem awichinanem chuqa' ajikomal

etp-card-title-always = Utzirisan Chajinïk chuwäch Ojqanem: Jutaqil Tzijïl
etp-card-title-custom-not-blocking = Utzirisan Chajinïk chuwäch Ojqanem: CHUPÜL
etp-card-content-description = { -brand-short-name } ruyonil yeruq'ät ri ajk'ayij moloj yatkojqaj pan ewäl pan ajk'amaya'l.
protection-report-etp-card-content-custom-not-blocking = Echupun ronojel ri taq chajinïk wakami. Ke'acha' ri taq ojqanela' yeq'at rik'in nanuk'samajij kinuk'ulem taq ruchajinik { -brand-short-name }.
protection-report-manage-protections = Tinuk'samajïx Runuk'ulem

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Wakami

# This string is used to describe the graph for screenreader users.
graph-legend-description = Wachib'äl nuk'üt ronojel ri kajilab'al kiwäch ojqanela' eq'aton re wuqq'ij re'.

social-tab-title = Kojqanela' aj Winäq K'amab'ey
social-tab-contant = Ri aj winäq taq k'amab'ey yekiya' taq ojqanela' pa ch'aqa' chik taq ajk'amaya'l ruxaq richin nikojqaj ri nasamajij, natz'ët chuqa' natzu' pan k'amab'ey. Ri nuya' q'ij chi ke ri ajk'ayij taq moloj richin aj winäq k'amab'ey, niketamaj chawij, man xa xe ta ri nakomonij pa ri ruwäch ab'i' richin aj winäq k'amab'ey. <a data-l10n-name="learn-more-link">Tetamäx ch'aqa' chik</a>

cookie-tab-title = Kikuki Rojqanela' Xoch'in taq Ruxaq
cookie-tab-content = Re taq kuki re' yatkojqaj pa taq ruxaq richin nikimöl awetamab'al chi rij ri nab'än pa k'amab'ey. Yekiya' kajk'ayij aj rox winäq achi'el eltzijob'äl moloj chuqa' ch'ob'onela' tzij. Ri ruq'atik k'ïy ruxaq nuqasaj jarupe' taq eltzijol yatkojqaj xab'akuchi' yab'e'. <a data-l10n-name="learn-more-link">Tetamäx ch'aqa' chik</a>

tracker-tab-title = Rojqanem Rupam
tracker-tab-description = Ri ajk'amaya'l ruxaq yetikïr yekijotob'a' taq eltzijol, taq silowäch chuqa' jun chik rupam kik'wan rub'itz'ib' ojqanem. Toq yeq'at kojqanem rupam, nito'on chi anin yesamäj ri taq ruxaq, xa xe chi jujun taq pitz'ib'äl, taq nojwuj chuqa' taq k'ojlib'äl rik'in jub'a' man ütz ta yesamäj. <a data-l10n-name="learn-more-link">Tetamäx ch'aqa' chik</a>

fingerprinter-tab-title = Fingerprinters
fingerprinter-tab-content = Ri b'anöy ruwi' q'ab'aj nikimöl taq runuk'ulem awokik'amaya'l chuqa' akematz'ib' richin nikitz'ük jun ruwäch ab'i'. Toq nikokisaj re retal ruwi' q'ab'aj, yetikïr yatkitzeqelib'ej pa jalajoj taq ajk'amaya'l ruxaq. <a data-l10n-name="learn-more-link">Tetamäx ch'aqa' chik</a>

cryptominer-tab-title = Cryptominers
cryptominer-tab-content = Ri ajkriptom nikokisaj ruchuq'a' ruq'inoj akematz'ib' richin rub'anik kematz'ib'il pwäq. Ri taq skrip ye'okisäx chi kipam, nikokisaj ri awateriya', eqal nikib'än chi re ri akematz'ib' chuqa' nikijotob'a' rajil ruwujil asaqil. <a data-l10n-name="learn-more-link">Tetamäx ch'aqa' chik</a>

protections-close-button2 =
    .aria-label = Titz'apïx
    .title = Titz'apïx
  
mobile-app-title = Keq'at ri rojqanela' eltzijol pa ch'aqa' okisab'äl
mobile-app-card-content = Tokisäx ri oyonib'äl okik'amaya'l rik'in ri kemon chajinïk chuwäch ri retal eltzijol.
mobile-app-links = { -brand-product-name } Okik'amaya'l richin <a data-l10n-name="android-mobile-inline-link">Android</a> chuqa' <a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = Man tamestaj chik jun ewan tzij
lockwise-title-logged-in2 = Runuk'samajel Ewan Tzij
lockwise-header-content = { -lockwise-brand-name } ütz ke'ayaka' ri ewan taq atzij pan awokik'amaya'l.
lockwise-header-content-logged-in = Ütz ke'ayaka' ri ewan taq atzij chuqa' ke'axima' pa ronojel awokisab'al.
protection-report-save-passwords-button = Keyak Ewan taq Tzij
    .title = Keyak Ewan taq Tzij pa { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Kenuk'samajïx Ewan taq Tzij
    .title = Kenuk'samajïx Ewan taq Tzij pa { -lockwise-brand-short-name }
lockwise-mobile-app-title = Xab'akuchi' ke'ak'waj ri ewan taq atzij
lockwise-no-logins-card-content = Tawokisaj ewan taq tzij eyakon pa { -brand-short-name } pa xab'achike okisab'äl.
lockwise-app-links = { -lockwise-brand-name } richin <a data-l10n-name="lockwise-android-inline-link">Android</a> chuqa' <a data-l10n-name="lockwise-ios-inline-link">iOS</a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] 1 ewan tzij rik'in jub'a' xtz'iläx pa jun tanaj tzij.
       *[other] { $count } ewan taq tzij rik'in jub'a' xetz'iläx pa jun tanaj tzij.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] 1 ewan tzij pa rub'eyal niyak.
       *[other] Ri ewan taq atzij pa rub'eyal yeyak.
    }
lockwise-how-it-works-link = Achike rub'eyal nisamäj

turn-on-sync = Titzij { -sync-brand-short-name }...
    .title = B'enam pa kajowab'al ximoj

monitor-title = Taya' retal ri kitz'ilanem taq tzij
monitor-link = Achike rub'eyal nisamäj
monitor-header-content-no-account = Tanik'oj { -monitor-brand-name } richin natz'ët we xatz'iläx pa jun tz'ilanem tzij etaman ruwäch chuqa' tak'ulu' rutzijol k'ayewal chi kij k'ak'a' taq tz'ilanem.
monitor-header-content-signed-in = { -monitor-brand-name } nuya' rutzijol chawe toq ri awetamab'al k'o pa jun rutz'ilanem tzij etaman ruwäch.
monitor-sign-up-link = Tatz'ib'aj awi' richin Ye'ak'ül Kitzijol K'ayewal
    .title = Tatz'ib'aj awi' richin Ye'ak'ül Kitzijol K'ayewal pa { -monitor-brand-name }
auto-scan = Ruyonil nitz'ajwachib'ëx wakami

monitor-emails-tooltip =
    .title = Ketz'et ri kochochib'al taqoya'al xetz'ët pa { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = Ketz'et kitz'ilanem taq tzij etaman kiwa pa { -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = Ketz'et ewan taq tzij xk'ut pa { -monitor-brand-short-name }

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] Rochochib'al taqoya'l ninik'öx.
       *[other] Taq rochochib'al taqoya'l yenik'öx.
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] Tz'ilanem tzij etaman ruwäch, xuk'üt ri awetamab'al.
       *[other] Taq tz'ilanem tzij etaman kiwäch, xkik'üt ri awetamab'al.
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] Rutz'ilanem tzij etaman ruwa ya'on retal chi xsol yan ruwäch
       *[other] Kitz'ilanem taq tzij etaman kiwa ya'on ketal chi xsol yan kiwäch
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] Ewan tzij k'utun pa ronojel taq tz'ilanem
       *[other] Ewan taq tzij ek'utun pa ronojel taq tz'ilanem
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] Ewan tzij k'utun pa taq tz'ilanem ri man solon ta
       *[other] Ewan taq tzij ek'utun pa taq tz'ilanem ri man esolon ta
    }

monitor-no-breaches-title = ¡Jeb'ël rutzijol!
monitor-no-breaches-description = Majun atz'ilanem etaman ruwa. We nujäl riri', xtiqaya' rutzijol chawe.
monitor-view-report-link = Titz'et Rutzijol
    .title = Kesol taq tz'ilanem pa { -monitor-brand-short-name }
monitor-breaches-unresolved-title = Kesol ri taq tz'ilanem
monitor-breaches-unresolved-description = Chi rij ninik'öx rucholajil ri tz'ilanem chuqa' noqäx rub'eyal richin nichajïx ri awetamab'al, yatikïr naya' kan retal achi'el chi xsol.
monitor-manage-breaches-link = Kenuk'samajïx taq tz'ilanem
    .title = Kenuk'samajïx taq tz'ilanem pa { -monitor-brand-short-name }
monitor-breaches-resolved-title = ¡Yalan ütz! Xe'asöl ronojel ri taq tz'ilanem etaman kiwa.
monitor-breaches-resolved-description = We ri ataqoya'l xtiwachin pa xab'achike k'ak'a' tz'ilanem, xtiqaya' rutzijol chawe.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
        [one] { $numBreachesResolved } richin { $numBreaches } tz'ilanem ya'on retal achi'el solon
       *[other] { $numBreachesResolved } richin { $numBreaches } taq tz'ilanem ya'on ketal achi'el esolon
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved } % tz'aqatisan

monitor-partial-breaches-motivation-title-start = ¡Xatikirisaj ütz!
monitor-partial-breaches-motivation-title-middle = ¡Ke ri' tab'ana'!
monitor-partial-breaches-motivation-title-end = ¡Nik'is yan! Ke ri' tab'ana'.
monitor-partial-breaches-motivation-description = Ke'asolo' ri ch'aqa' chik taq tz'ilanem pa { -monitor-brand-short-name }
monitor-resolve-breaches-link = Kesol taq Tz'ilanem
    .title = Kesol taq tz'ilanem pa { -monitor-brand-short-name }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Kojqanela' aj Winäq K'amab'ey
    .aria-label =
        { $count ->
            [one] { $count } rojqanel aj winäq k'amab'ey ({ $percentage }%)
           *[other] { $count } kojqanela' aj winäq k'amab'ey ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = Kikuki Rojqanela' Xoch'in taq Ruxaq
    .aria-label =
        { $count ->
            [one] { $count } rukuki rojqanel' xoch'in taq ruxaq ({ $percentage }%)
           *[other] { $count } kikuki rojqanela' xoch'in taq ruxaq ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Rojqanem Rupam
    .aria-label =
        { $count ->
            [one] { $count } rojqanem rupam({ $percentage }%)
           *[other] { $count } rojqanem rupam({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Fingerprinters
    .aria-label =
        { $count ->
            [one] { $count } Fingerprinter ({ $percentage }%)
           *[other] { $count } fingerprinters ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Cryptominers
    .aria-label =
        { $count ->
            [one] { $count } cryptominers ({ $percentage }%)
           *[other] { $count } cryptominers ({ $percentage }%)
        }
