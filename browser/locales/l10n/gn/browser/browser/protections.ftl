# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } ojoko { $count } rapykuehoha arapokõindy ohasaramóvape
       *[other] { -brand-short-name } ojoko { $count } rapykuehoha arapokõindy ohasaramóvape
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> tapykuehoha jokopyre { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") } guive
       *[other] <b>{ $count }</b> tapykuehoha jokopyre { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") } guive
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } ojoko gueteri  tapykuehoha ovetã megua, hákatu noñongatúi pe jokopyre rapykuere.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Tapykuehoha { -brand-short-name } ojejokóva ko arapokõindýpe

protection-report-webpage-title = Ñemo’ãha renda
protection-report-page-content-title = Ñemo’ãha renda
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } omo’ãkuaa ne ñemigua heta pa’ũme eikundaha aja. Kóva ha’e momichĩmbyre umi ñemo’ã rehegua, oikehápe avei umi tembipuru eñangarekokuaa hag̃ua ne tekorosã ñandutípe.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } omo’ãkuaa ne ñemigua heta pa’ũme eikundaha aja. Kóva ha’e momichĩmbyre umi ñemo’ã rehegua, oikehápe avei umi tembipuru eñangarekokuaa hag̃ua ne tekorosã ñandutípe.

protection-report-settings-link = Eñangareko ne ñemigua ha tekorosã ñembohekóre

etp-card-title-always = Ñemo’ã tapykuehoha iporãvéva rovake: Hendy tapia
etp-card-title-custom-not-blocking = Ñemo’ã tapykuehoha iporãvéva rovake: Ogue
etp-card-content-description = { -brand-short-name } ombyke ijehegui umi atyguasúpe ani ohapykuehóvo ñanduti rupi kañyhápe.
protection-report-etp-card-content-custom-not-blocking = Opaite ñemo’ã oñemboguepa ko’ág̃a. Eiporavo mba’e tapykuehohápa ejokóta emoambuévo { -brand-short-name } mo’ãha ñemboheko.
protection-report-manage-protections = Eñangareko ñembohekóre

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Ko árape

# This string is used to describe the graph for screenreader users.
graph-legend-description = Ta’ãnga’i oguerekóva papapy tuichaháicha opaichagua tapykuehoha jokopyre ko arapokõindýpe guare.

social-tab-title = Ava ñandutieta rapykuehoha
social-tab-contant = Umi ava ñandutieta ohechakuaa tapykuehoha ambue tendápe oikuaa hag̃ua ne rembiapo, omoñe’ẽ ha ohecha ñandutípe. Kóva omoneĩ mba’apohaguasúpe oikuaavévo ndehegui umi emoherakuãvagui nde ava ñandutietápe. <a data-l10n-name="learn-more-link">Kuaave</a>

cookie-tab-title = Kookie rapykuehoha tenda ojoasávape
cookie-tab-content = Ko’ã kookie ohapykueho opaite hendápe ombyaty hag̃ua mba’ekuaarã ojapóva ñandutípe. Omboaje mbohapyháva, mombe’uháramo ha mba’apoha tesa’ỹijoha. Pe kookie rapykuehoha jejoko tendakuéra pa’ũme omomichĩ maranduñemurã ehecháva. <a data-l10n-name="learn-more-link">Kuaave</a>

tracker-tab-title = Tetepy mo’ãha
tracker-tab-description = Ñandutikuéra renda ikatu omyanyhẽ marandu ñemurã okayguáva, ta’ãngamýi ha ambue tetepy orekóva tapykuehoha ayvu. Tetepy rapykuehoha jejoko ikatu oipytyvõ tendakuérape henyhẽ pya’eve hag̃ua, hákatu heta votõ, myanyhẽha ha tembiapo ñepyrũ kora ikatu ndoikovéi. <a data-l10n-name="learn-more-link">Kuaave</a>

fingerprinter-tab-title = Ñemokuãhũ
fingerprinter-tab-content = Umi kuãhũ kuaaukaha ombyaty ne kundahára ñemoĩporã ha ne mohendaha omoheñói hag̃ua mba’ete nenba’erã. Oipurúvo ko kuãhũ ikatu ohapykueho opaichagua ñanduti renda guive. <a data-l10n-name="learn-more-link">Kuaave</a>

cryptominer-tab-title = Criptomineros
cryptominer-tab-content = Umi criptominero oipurúva nde apopyvusu rembipurupyahu oguenohẽ hag̃ua viru ñandutiguáva. Umi ojuapykuerigua ipapapýva mbohapeha oipurupa ibatería, omombegue ne mohendaha ha ikatu ohupi electricidad repy. <a data-l10n-name="learn-more-link">Kuaave</a>

protections-close-button2 =
    .aria-label = Mboty
    .title = Mboty
  
mobile-app-title = Ejoko ñemurã rapykuehoha hetave mba’e’okápe
mobile-app-card-content = Eipuru kundahára oku’éva ñemo’ã ijeheguáva ndive ñemurã rapykuehoha rovake.
mobile-app-links = Pe kundahára { -brand-product-name } <a data-l10n-name="android-mobile-inline-link">Android</a> peg̃uarã ha <a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = Anivéke nderesarái ne ñe’ẽñemígui
lockwise-title-logged-in2 = Ñe’ẽñemi ñeñangareko
lockwise-header-content = { -lockwise-brand-name } ombyaty iñe’ẽñemi ikundahápe tekorosãme.
lockwise-header-content-logged-in = Embyaty ha embojuehe ne ñe’ẽñemi opaite ne mba’e’okápe tekorosãme.
protection-report-save-passwords-button = Eñongatu Ñe’ẽñemi
    .title = Eñongatu Ñe’ẽñemi { -lockwise-brand-short-name }-pe
protection-report-manage-passwords-button = Eñangareko Ñe’ẽñemíre
    .title = Eñangareko Ñe’ẽñemíre { -lockwise-brand-short-name }-pe
lockwise-mobile-app-title = Egueraha ne ñe’ẽñemi opa hendápe
lockwise-no-logins-card-content = Eipuru ñe’ẽñemi eñongatupyre { -brand-short-name } oimeraẽva mba’e’okápe.
lockwise-app-links = { -lockwise-brand-name } <a data-l10n-name="lockwise-android-inline-link">Android</a> peg̃uarã ha <a data-l10n-name="lockwise-ios-inline-link">iOS</a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] 1 ñe’ẽñemi oikekuaákuri peteĩ mba’ekuaarã ñembyaípe.
       *[other] { $count } ñe’ẽñemi oikekuaákuri peteĩ mba’ekuaarã ñembyaípe.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] 1 ñe’ẽñemi oñembyaty tekorosãme.
       *[other] Iñe’ẽñeminguéra oñembyaty tekorosãme.
    }
lockwise-how-it-works-link = Mba’éicha omba’apo

turn-on-sync = Emyandy { -sync-brand-short-name }...
    .title = Eho ñembojuehe erohoryvévape

monitor-title = Ema’ẽag̃uíke mba’ekuaarã ñembyaíre
monitor-link = Mba’éichapa omba’apo
monitor-header-content-no-account = Ehecha { -monitor-brand-name } eikuaa hag̃ua oĩpara’e mba’ekuaarã kuaapýva ñembyaípe ha oñembou hag̃ua ndéve kyhyjyrã mba’evai rehegua.
monitor-header-content-signed-in = { -monitor-brand-name } ne nemongyhyje ne marandu’i oĩ haguére mba’ekuaarã ñembyai kuaapývape.
monitor-sign-up-link = Eñemboheraguapy ñembogua kyhyjerãme
    .title = Eñemboheraguapy ñembogua kyhyjerãme { -monitor-brand-name } rupi
auto-scan = Ijehegui ohechajey ko árape

monitor-emails-tooltip =
    .title = Ehecha ñanduti veve kundaharape hechapyre { -monitor-brand-short-name }-pe
monitor-breaches-tooltip =
    .title = Ehecha mba’ekuaarã ñembogua kuaapyre { -monitor-brand-short-name }-pe
monitor-passwords-tooltip =
    .title = Ehecha ñe’ẽñemi ivaikuaáva { -monitor-brand-short-name }-pe

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] Ñanduti veve kundaharape jehechameméva
       *[other] Ñanduti veve kundaharape jehechameméva
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] Mba’ekuaarã kuaapýva ñembyai omomarãkuaa ne marandu
       *[other] Mba’ekuaarãkuéra kuaapýva ñembyai omomarãkuaa ne marandu
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] Mba’ekuaarã ñembyai ojekuaáva ikurusúva oĩporãmavaramo
       *[other] Mba’ekuaarãkuéra ñembyai ojekuaáva ikurusúva oĩporãmavaramo
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] Ñe’ẽñemi ojehecháva heta ñemboguaha rupive
       *[other] Ñe’ẽñemi ojehecháva heta ñemboguaha rupive
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] Ñe’ẽñemi ojehecháva ñembogua oĩporã’ỹvaramo
       *[other] Ñe’ẽñemikuéra ojehecháva ñembogua oĩporã’ỹvaramo
    }

monitor-no-breaches-title = ¡Marandu iporãva!
monitor-no-breaches-description = Ndaipóri ñembogua ojekuaáva. Eñambuéramo, roikuaaukáta ndéve.
monitor-view-report-link = Ehecha marandu’i
    .title = Emoĩporã  ñembogua { -monitor-brand-short-name }-pe
monitor-breaches-unresolved-title = Emoĩporã umi ñembyai
monitor-breaches-unresolved-description = Ahechajey rire mba’emimi ñembyai rehegua ha roñeha’ã romo’ã ne marandu, ikatúma eikuaa ñembyai oĩporãmaha.
monitor-manage-breaches-link = Emongu’e ñembogua
    .title = Emongu’e ñembogua { -monitor-brand-short-name }-pe
monitor-breaches-resolved-title = ¡Iporã! Emoĩporãmbáma ñembogua ojekuaáva.
monitor-breaches-resolved-description = Ne ñanduti veve ojehechárõ oĩha ñembyai pyahúpe, romomarandúta.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
        [one] { $numBreachesResolved } { $numBreaches } mba’e ñembyai mongurusupyre oĩporãmavaramo
       *[other] { $numBreachesResolved } { $numBreaches } mba’e ñembyai mongurusupyre oĩporãmavaramo
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved }% oĩmbáma

monitor-partial-breaches-motivation-title-start = ¡Ñepyrũ guasu!
monitor-partial-breaches-motivation-title-middle = ¡Eku’e péicha!
monitor-partial-breaches-motivation-title-end = ¡Opapotáma! Eho hese péicha.
monitor-partial-breaches-motivation-description = Emoĩporã hembýva ñembogua { -monitor-brand-short-name } rupive.
monitor-resolve-breaches-link = Emoĩpórã ñembogua
    .title = Emoĩpórã ñembogua { -monitor-brand-short-name }-pe

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Ava ñandutieta rapykuehoha
    .aria-label =
        { $count ->
            [one] { $count } ava ñandutieta rapykuehoha ({ $percentage } %)
           *[other] { $count } ava ñandutieta rapykuehoha ({ $percentage } %)
        }
bar-tooltip-cookie =
    .title = Kookie rapykuehoha tenda ojoasahápe
    .aria-label =
        { $count ->
            [one] { $count } kookie rapykuehoha tenda ojoasahápe ({ $percentage }%)
           *[other] { $count } kookie rapykuehoha tenda ojoasahápe ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Tetepy mo’ãha
    .aria-label =
        { $count ->
            [one] { $count } tetepy mo’ãha ({ $percentage }%)
           *[other] { $count } tetepy mo’ãha ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Ñemokuãhũ
    .aria-label =
        { $count ->
            [one] { $count } ñemokuãhũ ({ $percentage }%)
           *[other] { $count } ñemokuãhũ ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Criptomineros
    .aria-label =
        { $count ->
            [one] { $count } criptominero ({ $percentage }%)
           *[other] { $count } criptomineros ({ $percentage }%)
        }
