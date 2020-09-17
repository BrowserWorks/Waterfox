# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } narán riña  { $count } sa naga'naj a semanâ gâchin
       *[other] { -brand-short-name } narán riña { $count } sa naga'naj a semanâ gâchin
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> naran riña sa naga'naj a asij { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] <b>{ $count }</b> naran riña nej sa naga'naj a asij { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

protection-report-etp-card-content-custom-not-blocking = Gina’àj sa dugumîn sò’ akuan’ nïn nan. Naguī ahuin sa naga’nāj garánt riña sisī garasunt si konfigurasiûn sa dugumîn gu’nàj { -brand-short-name }.
protection-report-manage-protections = Gi’nïnj ra’a configuración

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Gui hìaj

# This string is used to describe the graph for screenreader users.
graph-legend-description = Riña grafikâ nan 'na' daran' nej sa naga'naj narán riña da'hua ngè semanâ nan.

social-tab-title = Nej sa naga'naj riña nej rêd sociâl
social-tab-contant = Da' gini'in nej rêd sosiâl nej sa 'iát ni sa ni'iajt riña lînia ni a'nïn sa naga'naj sò' riña a'nô da'aj nej sîtio. Huê na rugûñun'un da' gini'in nej dukua si sun nej rêd sosiâl nùj huin si hua doj 'iát nga aché nunt. <a data-l10n-name="learn-more-link">Gahuin chrun doj</a>

cookie-tab-title = Nej kokî nikò' riña nej sîtio
cookie-tab-content = Nej kokî nan ni nikò' nej man sò' danè' nanj gahuin huajt da' gini'in sa 'iát. Sa a'nïn guì ânej e huin, dà' rû' guì du'uèj e asi nej sû' nariñu sa aran' ruhuô'. Si naránt riña nej kokî nan ni si gurugui' nìko nej anûnsio gini'iajt. <a data-l10n-name="learn-more-link">Gahuin chrun doj</a>

tracker-tab-title = Sa nikò' nej kontenîdo
tracker-tab-description = Huā da'àj nej sîtio nī ga'ue nadiganj nej anûnsio, sa ni'io' nī a'ngô nej sa ga'ue nikāj sa naga'nāj a. Ga'ue nayi'nïn hìo doj nej sîtio si naránt riña nej sa naga'nāj a, sanī huā da'āj nej butûn, formulario asi riña gayi'ìt sesiûn sī ga'ue gi'iaj sunj. <a data-l10n-name="learn-more-link">Gāhuin chrūn doj</a>

fingerprinter-tab-title = Nej da'nga ra'a
fingerprinter-tab-content = Nej da'nga' digîtal ni nakaj nej man nej sa hua 'iát riña si aga't ni narij 'ngo si pefît. Ngà da'nga' digital nan, ga'ue ganikò' nej si sò' riña ga'ì sîtio. <a data-l10n-name="learn-more-link">Gahuin chrun doj</a>

cryptominer-tab-title = Nej kriptominêro
cryptominer-tab-content = Arâj sun nej kriptominêro sa hua riña si aga't da' gi'iaj tuj san'anj digital. Nej scripts nikaj nej kriptominerîa dunahuij hìo man ñan'an nu riña si aga't, nagi'iaj naj man ni ga'ue gahui yakàn ña'aan riñant. <a data-l10n-name="learn-more-link">Gahuin chrun doj</a>
  
lockwise-title = Si gini'ñûnt da'nga' huì nikajt a'ngô ñû
lockwise-header-content = { -lockwise-brand-name } na'nïn sà' hue'ej nej da'nga' huì nikajt riña aché nunt
lockwise-header-content-logged-in = Nachra sà' ni nagi'iaj guña nej da'nga' huì nikajt riña daran nej si aga't.

turn-on-sync = Na'nïn riña{ -sync-brand-short-name }...
    .title = Guij riña nej si preferencia sa nagi'iaj guñant

monitor-title = Sasà' ni'iajt sisi nadunâ nej si sa hua riña nej dâto
monitor-link = Dàj 'iaj sunj
monitor-header-content-no-account = Nātsij ni'iajt { -monitor-brand-name } da' gini'înt sisī gi'iaj yi'ì nej si si datôt nī ga'ue nahuin ra'at nej nuguan' natà' snan'anj sisī ruhuâ nej si gi'iaj yi'ì ñû nej si.
monitor-header-content-signed-in = { -monitor-brand-name } atāj snan'ānj gunïnt sisī gi'iaj yi'ì nej si nej datô nikājt.
auto-scan = Gui hìaj ni 'iaj eskaneândo man'an man

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] Si direksiûn korreô nikāj ñun'ūnjt
       *[other] Si direksiûn nej korreô nikāj ñun'ūnjt
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] Dunâj ni'nïnj chre sa gire' nej dâto nuguan' hua 'iát
       *[other] Dunâj ni'nïnj chre nej sa gire' nej dâto nuguan' hua 'iát
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] Huā ni'nïnj chre da'nga' huì riña ga'ue huā sa giran't
       *[other] Huā ni'nïnj chre nej da'nga' huì riña ga'ue huā sa giran't
    }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Sa naga'naj nej rêd sosial
    .aria-label =
        { $count ->
            [one] { $count } sa naga'naj nej rêd sosial ({ $percentage }%)
           *[other] { $count } nej sa naga'naj nej rêd sosial ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = Nej Kokî nikò' ni'iaj riña ga'ì sîtio
    .aria-label =
        { $count ->
            [one] { $count } kokî nikò' ni'iaj riña ga'ì sîtio ({ $percentage }%)
           *[other] { $count } nej kokî nikò' ni'iaj riña ga'ì sîtio ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Sa nikò' kontenîdo
    .aria-label =
        { $count ->
            [one] { $count } sa nikò' kontenîdo ({ $percentage }%)
           *[other] { $count } sa nikò' kontenîdo ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Nej da'nga ra'a
    .aria-label =
        { $count ->
            [one] { $count } da'nga ra'a ({ $percentage }%)
           *[other] { $count } nej da'nga' ra'a ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Nej kriptominêro
    .aria-label =
        { $count ->
            [one] { $count } kriptominêro ({ $percentage }%)
           *[other] { $count } nej kriptominêro ({ $percentage }%)
        }
