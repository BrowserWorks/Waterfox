# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name }(e)k jarraipen-elementu bat blokeatu du azken astean
       *[other] { -brand-short-name }(e)k { $count } jarraipen-elementu blokeatu ditu azken astean
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> jarraipen-elementu blokeatuta data honetatik: { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] <b>{ $count }</b> jarraipen-elementu blokeatuta data honetatik: { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name }(e)k jarraipen-elementuak blokeatzen jarraitzen du leiho pribatuetan baina ez du blokeatu denaren erregistrorik gordetzen.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = { -brand-short-name }(e)k aste honetan blokeatu dituen jarraipen-elementuak

protection-report-webpage-title = Babesen panela
protection-report-page-content-title = Babesen panela
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name }(e)k zure pribatutasuna babestu dezake bigarren planoan nabigatzen duzun bitartean. Hau babes horien laburpen pertsonalizatu bat da, zure lineako segurtasunaren kontrola hartzeko tresnak barne.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name }(e)k atzeko planoan zure pribatutasuna babesten du nabigatzen duzun bitartean. Babesen laburpen pertsonalizatua da hau, zure lineako segurtasunaren kontrola hartzeko tresnak barne.

protection-report-settings-link = Kudeatu zure pribatutasun eta segurtasun ezartpenak

etp-card-title-always = Jarraipenaren babes hobetua: Beti aktibo
etp-card-title-custom-not-blocking = Jarraipenaren babes hobetua: Itzalita
etp-card-content-description = { -brand-short-name }(e)k automatikoki eragozten du konpainiek sekretuki zu webean zehar jarraitzea.
protection-report-etp-card-content-custom-not-blocking = Une honetan babes guztiak desgaituta daude. Aukeratu zein jarraipen-elementu blokeatu zure { -brand-short-name } babes-ezarpenak kudeatuz.
protection-report-manage-protections = Kudeatu ezarpenak

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Gaur

# This string is used to describe the graph for screenreader users.
graph-legend-description = Aste honetan blokeatutako jarraipen-elementu mota bakoitzeko guztirako kopurua duen grafikoa.

social-tab-title = Sare sozialetako jarraipen-elementuak
social-tab-contant = Egiten eta ikusten duzunaren jarraipena egin ahal izateko, jarraipen-elementuak ipintzen dituzte sare sozialek beste webguneetan. Honen bitartez sare sozialetako enpresek zuri buruz dagoeneko dakitena baino gehiago jakin dezakete. <a data-l10n-name="learn-more-link">Argibide gehiago</a>

cookie-tab-title = Guneen arteko cookie jarraipen-egileak
cookie-tab-content = Cookie hauek guneen artean jarraitzen zaituzte zure lineako jarduerari buruzko datuak biltzeko. Hirugarrenek ezartzen dituzte hauek, adibidez iragarleen eta estatistiken enpresek. Guneen arteko cookie jarraipen-egileak blokeatzeak zure jarraipena egiten duten iragarkien kopurua murrizten du. <a data-l10n-name="learn-more-link">Argibide gehiago</a>

tracker-tab-title = Edukiaren jarraipena
tracker-tab-description = Webguneek kanpoko iragarkiak, bideoak eta jarraipen-kodea izan lezaketen bestelako edukiak karga ditzakete. Edukiaren jarraipena blokeatzeak guneak azkarrago kargatzen lagun dezake baina zenbait botoi, inprimaki eta saio-hasierako eremu ez ibiltzea eragin lezake. <a data-l10n-name="learn-more-link">Argibide gehiago</a>

fingerprinter-tab-title = Hatz-marka bidezko jarraipena
fingerprinter-tab-content = Hatz-marka bidezko jarraipenak zuri buruzko profil bat osatzen du zure nabigatzailetik eta ordenagailutik ezarpenak bilduz. Hatz-marka digital hau erabiliz, hainbat webgunetan zehar zure jarraipena egin dezakete. <a data-l10n-name="learn-more-link">Argibide gehiago</a>

cryptominer-tab-title = Kriptomeatzariak
cryptominer-tab-content = Kriptomeatzariek zure sistemaren konputazio-ahalmena erabiltzen dute diru digitala ustiatzeko. Script kriptomeatzariek zure bateria agortzen dute, zure ordenagailua makaltzen dute eta zure elektrizitate-faktura igo dezakete. <a data-l10n-name="learn-more-link">Argibide gehiago</a>

protections-close-button2 =
    .aria-label = Itxi
    .title = Itxi
  
mobile-app-title = Blokeatu publizitatearen jarraipen-elementuak gailu gehiagotan
mobile-app-card-content = Erabili mugikorreko nabigatzailea publizitatearen jarraipen-elementuen babesarekin
mobile-app-links = { -brand-product-name } nabigatzailea <a data-l10n-name="android-mobile-inline-link">Android</a> eta <a data-l10n-name="ios-mobile-inline-link">iOS</a> plataformetarako

lockwise-title = Ez ahaztu sekula pasahitzik berriro
lockwise-title-logged-in2 = Pasahitzen kudeaketa
lockwise-header-content = { -lockwise-brand-name }(e)k zure pasahitzak nabigatzailean gordetzen ditu modu seguruan.
lockwise-header-content-logged-in = Gorde eta sinkronizatu zure pasahitzak modu seguruan zure gailu guztietara.
protection-report-save-passwords-button = Gorde pasahitzak
    .title = Gorde pasahitzak { -lockwise-brand-short-name }(e)n
protection-report-manage-passwords-button = Kudeatu pasahitzak
    .title = Kudeatu pasahitzak { -lockwise-brand-short-name }(e)n
lockwise-mobile-app-title = Eraman pasahitzak alboan
lockwise-no-logins-card-content = Erabili { -brand-short-name }(e)n gordetako pasahitzak edozein gailutan.
lockwise-app-links = <a data-l10n-name="lockwise-android-inline-link">Android</a> and <a data-l10n-name="lockwise-ios-inline-link">iOS</a>erako { -lockwise-brand-name }

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] Pasahitz bat datu-urratze batean agerian utzi da agian.
       *[other] { $count } pasahitz datu-urratze batean agerian utzi dira agian.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] Pasahitza modu seguruan gorde da.
       *[other] Zure pasahitzak modu seguruan gorde dira.
    }
lockwise-how-it-works-link = Nola dabilen

turn-on-sync = Aktibatu { -sync-brand-short-name }…
    .title = Joan sinkronizatzeko hobespenetara

monitor-title = Erne ibili datuen inguruko urratzeekin
monitor-link = Nola dabilen
monitor-header-content-no-account = Egiaztatu { -monitor-brand-name } ezaguna den datu-urratze batekin zerikusirik izan duzun ikusteko eta urratze berriei buruzko abisuak jasotzeko.
monitor-header-content-signed-in = { -monitor-brand-name } tresnak abisatu egiten zaitu zure informazioa datuen inguruko urratze ezagunen batean azaldu bada.
monitor-sign-up-link = Eman izena datuen inguruko urratzeen abisuetara
    .title = Eman izena datuen inguruko urratzeen abisuetara { -monitor-brand-name }(e)n
auto-scan = Automatikoki eskaneatuta gaur

monitor-emails-tooltip =
    .title = Ikusi monitorizatutako e-mail helbideak hemen { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = Ikusi datu-urratze ezagunak hemen: { -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = Ikusi agerian utzitako pasahitzak hemen: { -monitor-brand-short-name }

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] Helbide elektroniko monitorizatzen ari da.
       *[other] Helbide elektroniko monitorizatzen ari dira.
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] Datuen inguruko urratzek zure informazioa agerian utzi du
       *[other] Datuen inguruko urratzek zure informazioa agerian utzi dute
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] Pasahitz agerian utzi da datuen inguruko urratze guztien artean
       *[other] Pasahitz agerian utzi dira datuen inguruko urratze guztien artean
    }

monitor-no-breaches-title = Berri onak!
monitor-no-breaches-description = Ez zaude datu-urratze ezagunetan. Hau aldatuko balitz, jakinarazi egingo dizugu.
monitor-view-report-link = Ikusi txostena
    .title = Argitu urratzeak { -monitor-brand-short-name }(e)n
monitor-manage-breaches-link = Kudeatu datu-urratzeak
    .title = Kudeatu datu-urratzeak { -monitor-brand-short-name }(e)n
monitor-breaches-resolved-description = Zure helbide elektronikoa datu-urratze berriren batean agertuko balitz, jakinarazi egingo dizugu.

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = %{ $percentageResolved } osatuta

monitor-partial-breaches-motivation-title-start = Hasiera ona!
monitor-partial-breaches-motivation-title-middle = Eutsi horri!
monitor-partial-breaches-motivation-title-end = Ia eginda! Eutsi horri.

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Sare sozialetako jarraipen-elementuak
    .aria-label =
        { $count ->
            [one] Sare sozialetako jarraipen-elementu bat (%{ $percentage })
           *[other] Sare sozialetako { $count } jarraipen-elementu (%{ $percentage })
        }
bar-tooltip-cookie =
    .title = Guneen arteko cookie jarraipen-egileak
    .aria-label =
        { $count ->
            [one] Guneen arteko cookie jarraipen-egile bat (%{ $percentage })
           *[other] Guneen arteko { $count } cookie jarraipen-egile (%{ $percentage })
        }
bar-tooltip-tracker =
    .title = Edukiaren jarraipena
    .aria-label =
        { $count ->
            [one] Edukiaren jarraipen bat (%{ $percentage })
           *[other] Edukiaren { $count } jarraipen (%{ $percentage })
        }
bar-tooltip-fingerprinter =
    .title = Hatz-marka bidezko jarraipena
    .aria-label =
        { $count ->
            [one] Hatz-marka bidezko jarraipen bat (%{ $percentage })
           *[other] Hatz-marka bidezko { $count } jarraipen (%{ $percentage })
        }
bar-tooltip-cryptominer =
    .title = Kriptomeatzariak
    .aria-label =
        { $count ->
            [one] Kriptomeatzari bat (%{ $percentage })
           *[other] { $count } kriptomeatzari (%{ $percentage })
        }
