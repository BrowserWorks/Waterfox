# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [zero] Mae { -brand-short-name } wedi rhwystro { $count } tracwyr dros yr wythnos ddiwethaf
        [one] Mae { -brand-short-name } wedi rhwystro { $count } traciwr dros yr wythnos ddiwethaf
        [two] Mae { -brand-short-name } wedi rhwystro { $count } draciwr dros yr wythnos ddiwethaf
        [few] Mae { -brand-short-name } wedi rhwystro { $count } traciwr dros yr wythnos ddiwethaf
        [many] Mae { -brand-short-name } wedi rhwystro { $count } traciwr dros yr wythnos ddiwethaf
       *[other] Mae { -brand-short-name } wedi rhwystro { $count } traciwr dros yr wythnos ddiwethaf
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [zero] <b>{ $count }</b> tracwyr wedi eu rhwystro ers{ DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
        [one] <b>{ $count }</b> traciwr wedi ei rwystro ers{ DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
        [two] <b>{ $count }</b> draciwr wedi eu rwystro ers{ DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
        [few] <b>{ $count }</b> traciwr wedi eu rwystro ers{ DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
        [many] <b>{ $count }</b> thraciwr wedi eu rwystro ers{ DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] <b>{ $count }</b> traciwr wedi eu rwystro ers{ DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = Mae { -brand-short-name } yn parhau i rwystro tracwyr mewn Ffenestri Preifat, ond nid yw'n cadw cofnod o'r hyn gafodd ei rwystro.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Tracwyr rhwystrodd { -brand-short-name } yr wythnos hon

protection-report-webpage-title = Bwrdd Gwaith Diogelwch
protection-report-page-content-title = Bwrdd Gwaith Diogelwch
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = Gall { -brand-short-name } ddiogelu eich preifatrwydd y tu ôl i'r llenni wrth i chi bori. Mae hwn yn grynodeb wedi'i bersonoli o'r diogelwch hynny, gan gynnwys offer i reoli eich diogelwch ar-lein.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = Mae { -brand-short-name } yn diogelu eich preifatrwydd y tu ôl i'r llenni wrth i chi bori. Mae hwn yn grynodeb wedi'i bersonoli o'r diogelwch hynny, gan gynnwys offer i reoli'ch diogelwch ar-lein.

protection-report-settings-link = Rheoli eich gosodiadau preifatrwydd a diogelwch

etp-card-title-always = Diogelwch Uwch Rhag Tracio: Ymlaen Drwy'r Amser
etp-card-title-custom-not-blocking = Diogelwch Uwch Rhag Tracio: I FFWRDD
etp-card-content-description = Mae { -brand-short-name } yn atal cwmnïau rhag eich dilyn yn gyfrinachol o amgylch y we, yn awtomatig.
protection-report-etp-card-content-custom-not-blocking = Mae'r holl ddiogelu wedi'u diffodd ar hyn o bryd. Dewiswch pa dracwyr i'w rhwystro trwy reoli eich gosodiadau diogelu { -brand-short-name }.
protection-report-manage-protections = Rheoli Gosodiadau

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Heddiw

# This string is used to describe the graph for screenreader users.
graph-legend-description = Graff sy'n cynnwys cyfanswm nifer pob math o draciwr gafodd ei rwystro yr wythnos hon.

social-tab-title = Tracwyr Cyfryngau Cymdeithasol
social-tab-contant = Mae rhwydweithiau cymdeithasol yn gosod tracwyr ar wefannau eraill i ddilyn yr hyn rydych chi'n ei wneud, ei weld, a'i wylio ar-lein. Mae hyn yn caniatáu i gwmnïau cyfryngau cymdeithasol ddysgu rhagor amdanoch chi y tu hwnt i'r hyn rydych chi'n ei rannu ar eich proffiliau cyfryngau cymdeithasol. <a data-l10n-name="learn-more-link">Dysgu rhagor</a>

cookie-tab-title = Cwcis Tracio Traws-Gwefan
cookie-tab-content = Mae'r cwcis hyn yn eich dilyn o wefan i wefan i gasglu data am yr hyn rydych chi'n ei wneud ar-lein. Mae nhw'n cael eu gosod gan drydydd partïon fel hysbysebwyr a chwmnïau dadansoddeg. Mae rhwystro cwcis tracio traws-safle yn lleihau'r nifer o hysbysebion sy'n eich dilyn. <a data-l10n-name="learn-more-link">Dysgu rhagor</a>

tracker-tab-title = Tracio Cynnwys
tracker-tab-description = Gall gwefannau lwytho hysbysebion allanol, fideos a chynnwys eraill sy'n cynnwys cod tracio. Gall rhwystro cynnwys tracio helpu gwefannau i lwytho'n gynt, ond efallai na fydd rhai botymau, ffurflenni a meysydd mewngofnodi'n gweithio. <a data-l10n-name="learn-more-link">Dysgu rhagor</a>

fingerprinter-tab-title = Bysbrintwyr
fingerprinter-tab-content = Mae bysbrintwyr yn casglu gosodiadau o'ch porwr a'ch cyfrifiadur i greu proffil ohonoch. Gan ddefnyddio'r olion bys digidol hwn, mae nhw'n gallu'ch tracio ar draws gwahanol wefannau. <a data-l10n-name="learn-more-link">Dysgu rhagor</a>

cryptominer-tab-title = Cryptogloddwyr
cryptominer-tab-content = Mae cryptogloddwyr yn defnyddio pŵer cyfrifiadurol eich system i gloddio arian digidol. Mae sgriptiau cryptogloddio yn gwagio eich batri, arafu eich cyfrifiadur, a gall gynyddu eich bil trydan. <a data-l10n-name="learn-more-link">Dysgu rhagor</a>

protections-close-button2 =
    .aria-label = Cau
    .title = Cau
  
mobile-app-title = Rhwystrwch dracwyr hysbysebion ar draws rhagor o ddyfeisiau
mobile-app-card-content = Defnyddiwch y porwr symudol gydag diogelwch mewnol rhag tracio gan hysbysebion.
mobile-app-links = Porwr { -brand-product-name } ar gyfer <a data-l10n-name="android-mobile-inline-link">Android</a> a <a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = Peidiwch byth ag anghofio cyfrinair eto
lockwise-title-logged-in2 = Rheoli Cyfrineiriau
lockwise-header-content = Mae { -lockwise-brand-name } yn cadw'ch cyfrineiriau yn ddiogel yn eich porwr.
lockwise-header-content-logged-in = Cadwch a chydweddwch eich cyfrineiriau'n ddiogel i'ch holl ddyfeisiau.
protection-report-save-passwords-button = Cadw Cyfrineiriau
    .title = Cadw Cyfrineiriau ar { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Rheoli Cyfrineiriau
    .title = Rheoli Cyfrineiriau ar { -lockwise-brand-short-name }
lockwise-mobile-app-title = Ewch â'ch cyfrineiriau i bob man
lockwise-no-logins-card-content = Defnyddiwch gyfrineiriau wedi'u cadw yn { -brand-short-name } ar unrhyw ddyfais.
lockwise-app-links = { -lockwise-brand-name } ar gyfer <a data-l10n-name="lockwise-android-inline-link">Android</a> a <a data-l10n-name = "lockwise-ios-inline-link" >iOS</a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [zero] Efallai bod { $count } cyfrineiriau wedi cael eu hamlygu mewn tor-data.
        [one] Efallai bod i 1 cyfrinair wedi cael ei amlygu mewn tor-data.
        [two] Efallai bod { $count } gyfrinair wedi cael eu hamlygu mewn tor-data.
        [few] Efallai bod { $count } cyfrinair wedi cael eu hamlygu mewn tor-data.
        [many] Efallai bod { $count } chyfrinair wedi cael eu hamlygu mewn tor-data.
       *[other] Efallai bod { $count } cyfrinair wedi cael eu hamlygu mewn tor-data.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [zero] Mae'ch cyfrineiriau'n cael eu cadw'n ddiogel.
        [one] Mae 1 cyfrinair yn cael ei gadw'n ddiogel.
        [two] Mae'ch cyfrineiriau'n cael eu cadw'n ddiogel.
        [few] Mae'ch cyfrineiriau'n cael eu cadw'n ddiogel.
        [many] Mae'ch cyfrineiriau'n cael eu cadw'n ddiogel.
       *[other] Mae'ch cyfrineiriau'n cael eu cadw'n ddiogel.
    }
lockwise-how-it-works-link = Sut mae'n gweithio

turn-on-sync = Cychwyn { -sync-brand-short-name }…
    .title = Mynd i ddewisiadau cydweddu

monitor-title = Cadw llygad allan am dor-data.
monitor-link = Sut mae'n gweithio
monitor-header-content-no-account = Edrychwch ar { -monitor-brand-name } i weld a ydych chi wedi bod yn rhan o dor-data a chael rhybuddion am dor-data newydd.
monitor-header-content-signed-in = Mae { -monitor-brand-name } yn eich rhybuddio os yw'ch manylion wedi ymddangos mewn tor-data hysbys
monitor-sign-up-link = Cofrestrwch ar gyfer Rhybuddion Tor-data
    .title = Cofrestrwch am rybuddion tor-data ar { -monitor-brand-name }
auto-scan = Wedi'u sganio'n awtomatig heddiw

monitor-emails-tooltip =
    .title = Gweld cyfeiriadau e-bost wedi'u monitro ar { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = Gweld tor-data hysbys ar { -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = Gweld cyfrineiriau wedi'u datgelu ar { -monitor-brand-short-name }

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [zero] Cyfeiriadau e-bost yn cael eu monitro
        [one] Cyfeiriad e-bost yn cael ei fonitro
        [two] Gyfeiriad e-bost yn cael eu monitro
        [few] Cyfeiriad e-bost yn cael eu monitro
        [many] Chyfeiriad e-bost yn cael eu monitro
       *[other] Cyfeiriad e-bost yn cael eu monitro
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [zero] Tor-data hysbys wedi amlygu eich manylion
        [one] Tor-data hysbys wedi amlygu eich manylion
        [two] Dor-data hysbys wedi amlygu eich manylion
        [few] Tor-data hysbys wedi amlygu eich manylion
        [many] Thor-data hysbys wedi amlygu eich manylion
       *[other] Tor-data hysbys wedi amlygu eich manylion
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [zero] Tor-data hysbys wedi'u nodi fel wedi'u datrys
        [one] Tor-data hysbys wedi'i nodi fel wedi'i ddatrys
        [two] Dor-data hysbys wedi'u nodi fel wedi'u datrys
        [few] Tor-data hysbys wedi'u nodi fel wedi'u datrys
        [many] Thor-data hysbys wedi'u nodi fel wedi'u datrys
       *[other] Tor-data hysbys wedi'u nodi fel wedi'u datrys
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [zero] Cyfrineiriau wedi'u hamlygu ym mhob tor-data
        [one] Cyfrinair wedi'i amlygu ym mhob tor-data
        [two] Cyfrinair wedi'u hamlygu ym mhob tor-data
        [few] Cyfrinair wedi'u hamlygu ym mhob tor-data
        [many] Chyfrinair wedi'u hamlygu ym mhob tor-data
       *[other] Cyfrinair wedi'u hamlygu ym mhob tor-data
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [zero] Cyfrineiriau wedi'u hamlygu mewn tor-data heb eu datrys
        [one] Cyfrinair wedi'i amlygu mewn tor-data heb ei ddatrys
        [two] Gyfrinair wedi'u hamlygu mewn tor-data heb eu datrys
        [few] Cyfrinair wedi'u hamlygu mewn tor-data heb eu datrys
        [many] Chyfrinair wedi'u hamlygu mewn tor-data heb eu datrys
       *[other] Cyfrinair wedi'u hamlygu mewn tor-data heb eu datrys
    }

monitor-no-breaches-title = Newyddion da!
monitor-no-breaches-description = Nid oes gennych unrhyw dor-data hysbys. Os bydd hynny'n newid, byddwn yn rhoi gwybod i chi.
monitor-view-report-link = Gweld yr Adroddiad
    .title = Datrys tor-data ar { -monitor-brand-short-name }
monitor-breaches-unresolved-title = Datrys eich tor-data
monitor-breaches-unresolved-description = Ar ôl adolygu manylion tor-data a chymryd camau i ddiogelu eich manylion, gallwch nodi fod eich tor-data wedi'u datrys.
monitor-manage-breaches-link = Rheoli Tor-data
    .title = Rheoli tor-data ar { -monitor-brand-short-name }
monitor-breaches-resolved-title = Da! Rydych wedi datrys pob achos o dor-data hysbys.
monitor-breaches-resolved-description = Os bydd eich e-bost yn ymddangos mewn unrhyw dor-data newydd, byddwn yn rhoi gwybod i chi.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
        [zero] { $numBreachesResolved } allan o { $numBreaches } tor-data wedi'u marcio fel wedi'u datrys
        [one] { $numBreachesResolved } allan o { $numBreaches } tor-data wedi'i farcio fel wedi'i ddatrys
        [two] { $numBreachesResolved } allan o { $numBreaches } tor-data wedi'u marcio fel wedi'u datrys
        [few] { $numBreachesResolved } allan o { $numBreaches } tor-data wedi'u marcio fel wedi'u datrys
        [many] { $numBreachesResolved } allan o { $numBreaches } tor-data wedi'u marcio fel wedi'u datrys
       *[other] { $numBreachesResolved } allan o { $numBreaches } tor-data wedi'u marcio fel wedi'u datrys
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved }% wedi'u cwblhau

monitor-partial-breaches-motivation-title-start = Dechrau da!
monitor-partial-breaches-motivation-title-middle = Daliwch ati!
monitor-partial-breaches-motivation-title-end = Bron wedi ei wneud! Daliwch ati.
monitor-partial-breaches-motivation-description = Datryswch weddill eich tor-data ar { -monitor-brand-short-name }
monitor-resolve-breaches-link = Datrys Tor-data
    .title = Datrys tor-data ar { -monitor-brand-short-name }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Tracwyr Cyfryngau Cymdeithasol
    .aria-label =
        { $count ->
            [zero] { $count } tracwyr cyfryngau cymdeithasol ({ $percentage }%)
            [one] { $count } traciwr cyfryngau cymdeithasol ({ $percentage }%)
            [two] { $count } draciwr cyfryngau cymdeithasol ({ $percentage }%)
            [few] { $count } traciwr cyfryngau cymdeithasol ({ $percentage }%)
            [many] { $count } traciwr cyfryngau cymdeithasol ({ $percentage }%)
           *[other] { $count } traciwr cyfryngau cymdeithasol ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = Cwcis Tracio Traws-Gwefan
    .aria-label =
        { $count ->
            [zero] { $count } cwcis tracio traws-gwefan ({ $percentage }%)
            [one] { $count } cwci tracio traws-gwefan ({ $percentage }%)
            [two] { $count } gwci tracio traws-gwefan ({ $percentage }%)
            [few] { $count } cwci tracio traws-gwefan ({ $percentage }%)
            [many] { $count } cwci tracio traws-gwefan ({ $percentage }%)
           *[other] { $count } cwci tracio traws-gwefan ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Cynnwys Tracio
    .aria-label =
        { $count ->
            [zero] { $count } cynnwys tracio ({ $percentage }%)
            [one] { $count } cynnwys tracio ({ $percentage }%)
            [two] { $count } cynnwys tracio ({ $percentage }%)
            [few] { $count } cynnwys tracio ({ $percentage }%)
            [many] { $count } cynnwys tracio ({ $percentage }%)
           *[other] { $count } cynnwys tracio ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Bysbrintwyr
    .aria-label =
        { $count ->
            [zero] { $count } bysbrintwyr ({ $percentage }%)
            [one] { $count } bysbrintwyr ({ $percentage }%)
            [two] { $count } bysbrintwyr ({ $percentage }%)
            [few] { $count } bysbrintwyr ({ $percentage }%)
            [many] { $count } bysbrintwyr ({ $percentage }%)
           *[other] { $count } bysbrintwyr ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Cryptogloddwyr
    .aria-label =
        { $count ->
            [zero] { $count } cryptogloddwyr ({ $percentage }%)
            [one] { $count } cryptogloddwyr ({ $percentage }%)
            [two] { $count } cryptogloddwyr ({ $percentage }%)
            [few] { $count } cryptogloddwyr ({ $percentage }%)
            [many] { $count } cryptogloddwyr ({ $percentage }%)
           *[other] { $count } cryptogloddwyr ({ $percentage }%)
        }
