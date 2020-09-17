# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } blokis 1 spurilon du la lasta semajno
       *[other] { -brand-short-name } blokis { $count } spurilojn dum la lasta semajno
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> spurilo blokita ekde { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] <b>{ $count }</b> spuriloj blokitaj ekde { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } plu blokas spurilojn en privataj fenestroj, sed ĝi ne registras tion, kion ĝi blokas.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Spuriloj blokitaj de { -brand-short-name } ĉi semajne

protection-report-webpage-title = Panelo de protektoj
protection-report-page-content-title = Panelo de protektoj
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } povas malantaŭ la scenejo protekti vian privatecon dum vi retumas. Tio ĉi estas personecigita resumo de tiuj protektoj, kaj inkluzivas la ilojn por regi vian sekurecon en la reto.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = Malantaŭ la scenejo { -brand-short-name } protektas vian privatecon dum vi retumas. Tio ĉi estas personecigita resumo de tiuj protektoj, kaj inkluzivas la ilojn por regi vian sekurecon en la reto.

protection-report-settings-link = Administri vian privatecajn kaj sekurecajn agordojn

etp-card-title-always = Plibonigita protekto kontraŭ spurado: ĉiam ŝaltita
etp-card-title-custom-not-blocking = Plibonigita protekto kontraŭ spurado: MALŜALTITA
etp-card-content-description = { -brand-short-name } aŭtomate evitas ke entreprenoj sekrete sekvu vin tra la reto.
protection-report-etp-card-content-custom-not-blocking = Ĉiuj protektoj estas nun malŝaltitaj. Elektu la spurilojn, kiujn vi volas bloki, per administrado de la agordoj pri protekto de { -brand-short-name }.
protection-report-manage-protections = Administri agordojn

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Hodiaŭ

# This string is used to describe the graph for screenreader users.
graph-legend-description = Grafikaĵo, kiu enhavas la nombron de blokitaj spuriloj dum tiu ĉi semajno, apartigitaj laŭ tipo.

social-tab-title = Sociretaj spuriloj
social-tab-contant = Socia retoj aldonas spurilojn en aliaj retejoj por sekvi vin kaj scii kion vi vidas kaj faras dum retumo. Tiu permesas al sociretaj entreprenoj havi informon pri vi, kiun vi ne dividas per viaj sociretaj profiloj. <a data-l10n-name="learn-more-link">Pli da informo</a>

cookie-tab-title = Interretejaj spurilaj kuketoj
cookie-tab-content = Tiuj ĉi kuketoj sekvas vin inter retejoj por kolekti informon pri via retumo. Ili estas difinitaj de aliaj, ekzemple de reklamistoj kaj retumanalizaj entreprenoj. Blokado de interretejaj spurilaj kuketoj reduktas la kvanton de reklamoj kiuj sekvas vin ĉien. <a data-l10n-name="learn-more-link">Pli da informo</a>

tracker-tab-title = Spurila enhavo
tracker-tab-description = Retejoj povas ŝargi eksterajn reklamojn, filmetojn kaj alian enhavon, kiuj havas spurilan kodon. Blokado de spurila enhavo povas rapidigi la ŝargadon de retejoj, sed kelkaj butonoj, formularoj kaj legitimilaj kampoj povus ne funkcii. <a data-l10n-name="learn-more-link">Pli da informo</a>

fingerprinter-tab-title = Identigiloj de ciferecaj spuroj
fingerprinter-tab-content = La identigiloj de ciferecaj spuroj kolektas agordojn de via retumilo kaj komputilo por krei profilon de vi. Per tiu cifereca spuro, ili povas sekvi vin tra malsamaj retejoj.<a data-l10n-name="learn-more-link">Pli da informo</a>

cryptominer-tab-title = Miniloj de ĉifromono
cryptominer-tab-content = La miniloj de ĉifromono uzas la kalkulpovon de via komputilo por mini ciferecan monon. Minado de ĉifromono eluzas vian baterion, malrapidigas vian komputilon kaj povas konsumi pli da elekto, kiun vi devos pagi. <a data-l10n-name="learn-more-link">Pli da informo</a>

protections-close-button2 =
    .aria-label = Fermi
    .title = Fermi
  
mobile-app-title = Bloki reklamajn spurilojn en pli da aparatoj
mobile-app-card-content = Uzi la poŝaparatan retumilon kun integrita protekto kontraŭ reklamaj spuriloj.
mobile-app-links = { -brand-product-name } Retumilo por <a data-l10n-name="android-mobile-inline-link">Android</a> kaj <a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = Neniam denove forgesu pasvorton
lockwise-title-logged-in2 = Administranto de pasvortoj
lockwise-header-content = { -lockwise-brand-name } sekure konservas viajn pasvortojn en via retumilo.
lockwise-header-content-logged-in = Sekure konservu kaj spegulu viajn pasvortojn en ĉiuj viaj aparatoj.
protection-report-save-passwords-button = Konservi pasvortojn
    .title = Konservi pasvortojn per { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Administri pasvortojn
    .title = Administri pasvortojn per { -lockwise-brand-short-name }
lockwise-mobile-app-title = Kunportu viajn pasvortojn ĉien
lockwise-no-logins-card-content = Uzu en iu ajn aparato la pasvortojn konservitaj en { -brand-short-name }.
lockwise-app-links = { -lockwise-brand-name } por <a data-l10n-name="lockwise-android-inline-link">Android</a> kaj <a data-l10n-name="lockwise-ios-inline-link">iOS</a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] unu pasvorto estis elmetita de datumfuĝo.
       *[other] { $count } pasvortoj estis elmetitaj de datumfuĝo.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] unu pasvorto sekure konservita.
       *[other] Viaj pasvortoj estas sekure konservitaj.
    }
lockwise-how-it-works-link = Funkciado

turn-on-sync = Ŝalti { -sync-brand-short-name }…
    .title = Iri al la preferoj de spegulado

monitor-title = Estu atenta je datumfuĝoj
monitor-link = Kiel funkcias tio
monitor-header-content-no-account = Kontrolu { -monitor-brand-name } por vidi ĉu vi estis viktimo de konata datumfuĝo kaj ricevu atentigojn pri novaj datumfuĝoj.
monitor-header-content-signed-in = { -monitor-brand-name } avertas vin se viaj informoj aperas en konata datumfuĝo.
monitor-sign-up-link = Aboni la atentigojn pri datumfuĝoj
    .title = Aboni la atentigojn pri datumfuĝoj en { -monitor-brand-name }
auto-scan = Aŭtomate kontrolitaj hodiaŭ

monitor-emails-tooltip =
    .title = Vidi prizorgatajn retpoŝtajn adresojn en { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = Vidi konatajn datumfuĝojn en { -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = Vidi elmetitajn pasvortojn en { -monitor-brand-short-name }

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] retpoŝta adreso kontrolata
       *[other] retpoŝtaj adresoj kontrolataj
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] konata datumfuĝo elmetis viajn informojn
       *[other] konataj datumfuĝoj elmetis viajn informojn
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] Konata datumfuĝo markita kiel solvita
       *[other] Konataj datumfuĝoj markitaj kiel solvitaj
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] pasvorto elmetita en ĉiuj datumfuĝoj
       *[other] pasvortoj elmetitaj en ĉiuj datumfuĝoj
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] Pasvorto elmetita en ne solvitaj datumfuĝoj
       *[other] Pasvortoj elmetitaj en ne solvitaj datumfuĝoj
    }

monitor-no-breaches-title = Bonaj novaĵoj!
monitor-no-breaches-description = Vi ne aperas en iu ajn konata datumfuĝo. Se tio ŝanĝiĝas, ni sciigos vin pri tio.
monitor-view-report-link = Vidi raporton
    .title = Solvi datumfuĝojn en { -monitor-brand-short-name }
monitor-breaches-unresolved-title = Solvu viajn datumfuĝojn
monitor-breaches-unresolved-description = Post revizio de la datumfuĝaj detaloj kaj farinte ion por protekti viajn informojn, vi povas marki datumfuĝojn kiel solvitajn.
monitor-manage-breaches-link = Administri datumfuĝoj
    .title = Administri datumfuĝoj en { -monitor-brand-short-name }
monitor-breaches-resolved-title = Tre bone! Vi solvis ĉiujn konatajn datumfuĝojn.
monitor-breaches-resolved-description = Se via retadreso aperas en nova datumfuĝo, ni sciigos vin pri tio.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
        [one] { $numBreachesResolved } el { $numBreaches } datumfuĝo markitaj kiel solvita
       *[other] { $numBreachesResolved } el { $numBreaches } datumfuĝoj markitaj kiel solvitaj
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved }% finita

monitor-partial-breaches-motivation-title-start = Bona komenco!
monitor-partial-breaches-motivation-title-middle = Daŭrigu tiel!
monitor-partial-breaches-motivation-title-end = Preskaŭ finita! Ne ĉesu.
monitor-partial-breaches-motivation-description = Solvu viajn ceterajn datumfuĝoj en { -monitor-brand-short-name }.
monitor-resolve-breaches-link = Solvi datumfuĝoj
    .title = Solvi datumfuĝoj en { -monitor-brand-short-name }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Sociretaj spuriloj
    .aria-label =
        { $count ->
            [one] Unu socireta spurilo ({ $percentage }%)
           *[other] { $count } sociretaj spuriloj ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = Interretejaj spurilaj kuketoj
    .aria-label =
        { $count ->
            [one] Unu interreteja spurila kuketo ({ $percentage }%)
           *[other] { $count } interretejaj spurilaj kuketoj ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Spurila enhavo
    .aria-label =
        { $count ->
            [one] Unu elemento de spurila enhavo ({ $percentage }%)
           *[other] { $count } elementoj de spurila enhavo ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Identigiloj de ciferecaj spuroj
    .aria-label =
        { $count ->
            [one] unu identigilo de ciferecaj spuroj ({ $percentage }%)
           *[other] { $count } identigiloj de ciferecaj spuroj ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Miniloj de ĉifromono
    .aria-label =
        { $count ->
            [one] { $count } minilo de ĉifromono ({ $percentage }%)
           *[other] { $count } miniloj de ĉifromono ({ $percentage }%)
        }
