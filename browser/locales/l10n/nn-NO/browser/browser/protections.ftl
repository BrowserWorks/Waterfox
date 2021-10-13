# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } blokkerte { $count } sporfølgjar den siste veka
       *[other] { -brand-short-name } blokkerte { $count } sporarar den siste veka
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> sporarar blokkerte sidan { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] <b>{ $count }</b> sporarar blokerte sidan { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } fortset å  blokkere sporarar i private vindauge, men held ikkje oversikt over kva som vart blokkert.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Sporarar { -brand-short-name } blokkerte denne veka

protection-report-webpage-title = Tryggingspanel
protection-report-page-content-title = Tryggingspanel
# This message shows when all privacy protections are turned off, which is why we use the word "can", Waterfox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } kan ta vare på personvernet ditt bak kulissene medan du surfar. Dette er ei personleg oppsummering av desse verna, inkludert verktøy for å ta kontroll over sikkerheita di på nettet.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Waterfox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } tar vare på personvernet ditt bak kulissene medan du surfar. Dette er ei personleg oppsummering av desse verna, inkludert verktøy for å ta kontroll over dsikkerheita di på nettet.

protection-report-settings-link = Handter personvern- og tryggingsinnstillingar

etp-card-title-always = Utvida sporingsvern: Alltid på
etp-card-title-custom-not-blocking = Utvida sporingsvern: AV
etp-card-content-description = { -brand-short-name } stoppar selskap automatisk frå å følgje deg rundt på nettet i løynd.
protection-report-etp-card-content-custom-not-blocking = Alt vern er for tida slått av. Vel kva for sporarar du vil blokkere ved å handtere innstillingar for vern i { -brand-short-name }.
protection-report-manage-protections = Handter innstillingar

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = I dag

# This string is used to describe the graph for screenreader users.
graph-legend-description = Ein graf som inneheld det totale antalet for kvar type av sporarar som har blitt blokkerte denne veka.

social-tab-title = Sporing via sosiale medium
social-tab-contant = Sosiale nettverk plasserer sporarar på andre nettstadar for å følgje det du gjer og ser på nettet. Dette gjer at sosiale mediaselskap kan lære meir om deg utover det du deler på profilane dine på sosiale medium. <a data-l10n-name="learn-more-link">Les meir</a>

cookie-tab-title = Sporingsinfokapslar på tvers av nettstadar
cookie-tab-content = Desse infokapslane følgjer deg frå nettstad til nettstad for å samle inn data om kva du gjer på nettet. Dei vert brukte av tredjepartar som annonsørar og analyseselskap. Blokkering av sporingsinfokapslar på tvers av nettstadar reduserer talet på annonsar som følgjer deg. <a data-l10n-name="learn-more-link">Les meir</a>

tracker-tab-title = Sporingsinnhald
tracker-tab-description = Nettstadar kan laste eksterne annonsar, videoar og anna innhald med sporingskode. Blokkering av sporingsinnhald kan gjere at nettstadar lastar raskare, men det kan vere at  nokre knappar, skjema og innloggingsfelt ikkje fungerer. <a data-l10n-name="learn-more-link">Les meir</a>

fingerprinter-tab-title = Fingerprinters
fingerprinter-tab-content = Fingerprinters samlar innstillingar frå nettlesaren din og datamaskina di for å lage ein profil av deg. Ved hjelp av dette digitale fingeravtrykket kan dei spore deg på forskjellige nettstadar. <a data-l10n-name="learn-more-link">Les meir</a>

cryptominer-tab-title = Kryptoutvinnarar
cryptominer-tab-content = Kryptoutvinnarar brukar datakrafta til systemet for å utvinne digitale pengar. Kryptoutvinningsskript tappar batteriet, gjer datamaskina tregare og kan auke straumrekninga. <a data-l10n-name="learn-more-link">Les meir</a>

protections-close-button2 =
    .aria-label = Lat att
    .title = Lat att
  
mobile-app-title = Blokker annonsesporarar på fleire einingar
mobile-app-card-content = Bruk mobilnettlesaren med innebygd vern mot annonsesporing.
mobile-app-links = { -brand-product-name } Nettlesar for <a data-l10n-name="android-mobile-inline-link">Android</a> og <a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = Glæym aldri eit passord igjen
lockwise-title-logged-in2 = Passordhandtering
lockwise-header-content = { -lockwise-brand-name } lagrar passorda dine trygt i nettlesaren din.
lockwise-header-content-logged-in = Lagre passorda dine trygt og synkroniser dei med alle eniningane dine.
protection-report-save-passwords-button = Lagre passord
    .title = Lagre passord i { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Handtere passord
    .title = Handtere passord i { -lockwise-brand-short-name }
lockwise-mobile-app-title = Ta med deg passorda dine overalt
lockwise-no-logins-card-content = Bruk passord som er lagra i { -brand-short-name } på kva som helst eining.
lockwise-app-links = { -lockwise-brand-name } for <a data-l10n-name="lockwise-android-inline-link">Android</a> og <a data-l10n-name="lockwise-ios-inline-link">iOS</a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] 1 passord kan ha blitt eksponert i ein datalekkasje.
       *[other] { $count } passord kan ha blitt eksponerte i ein datalekkasje.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] 1 passord trygt lagra.
       *[other] Passorda dine blir lagra trygt.
    }
lockwise-how-it-works-link = Korleis det fungerer

monitor-title = Sjå opp for datalekkasjer.
monitor-link = Korleis det verkar
monitor-header-content-no-account = SJekk { -monitor-brand-name } for å sjå om du har vore ein del av ein datalekkasje, og få varsel om nye datalekkasjar.
monitor-header-content-signed-in = { -monitor-brand-name } åtvarar deg om informasjonen din har dukka opp i ein kjend datalekkasje.
monitor-sign-up-link = Registrer deg for datalekkasjevarsel
    .title = Registrer deg for datalekkasjevarsel på { -monitor-brand-name }
auto-scan = Automatisk skanna i dag

monitor-emails-tooltip =
    .title = Vis overvaka e-postadresser på { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = Vis kjende datalekkasjar på { -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = Vis eksponerte passord på { -monitor-brand-short-name }

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] E-postadressa vert overvaka
       *[other] E-postadressa vert overvaka
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] Kjend datalekkasje har eksponert informasjonen din
       *[other] Kjende datalekkasjar har eksponert informasjonen din
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] Kjend datalekkasje merkt som løyst
       *[other] Kjende datalekkasjar merkte som løyste
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] Passord eksponert for alle datalekkasjar
       *[other] Passord eksponerte for alle datalekkasjar
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] Passord eksponerte i uløyste datalekkasjar
       *[other] Passord eksponerte i uløyste datalekkasjar
    }

monitor-no-breaches-title = Gode nyheiter!
monitor-no-breaches-description = Du har ingen kjende datalekkasjear. Om det endrar seg, vil vi gi deg beskjed.
monitor-view-report-link = Vis rapport
    .title = Løys datalekkasjar på { -monitor-brand-short-name }
monitor-breaches-unresolved-title = Løys datalekkasjane dine
monitor-breaches-unresolved-description = Etter å ha gått gjennom datalekkasje-detaljar, og sett i verk tiltak for å ta vare på den personlege informasjonen din, kan du merke datalekkasjar som løyste.
monitor-manage-breaches-link = Handter datalekkasjer
    .title = Handter datalekkasjar på { -monitor-brand-short-name }
monitor-breaches-resolved-title = Bra! Du har løyst alle kjende datalekkasjar.
monitor-breaches-resolved-description = Vi vil gi deg beskjed om e-postadressa di dukkar opp i nye datalekkasjar.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
       *[other] { $numBreachesResolved } av { $numBreaches } datalekkasjar er merkte som løyste
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved } % fullført

monitor-partial-breaches-motivation-title-start = Bra start!
monitor-partial-breaches-motivation-title-middle = Hald fram slik!
monitor-partial-breaches-motivation-title-end = Nesten ferdig! Hald fram slik.
monitor-partial-breaches-motivation-description = Løys resten av datalekkasjane dine på { -monitor-brand-short-name }.
monitor-resolve-breaches-link = Løys datalekkasjar
    .title = Løys datalekkasjar på { -monitor-brand-short-name }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Sporing via sosiale medium
    .aria-label =
        { $count ->
            [one] { $count } sosiale media-sporfølgjar ({ $percentage } %)
           *[other] { $count } sosiale media-sporarar ({ $percentage } %)
        }
bar-tooltip-cookie =
    .title = Sporingsinfokapslar på tvers av nettstadar
    .aria-label =
        { $count ->
            [one] { $count } sporingsinfokapsel på tvers av nettstadar ({ $percentage } %)
           *[other] { $count } sporingsinfokapslar på tvers av nettstadar ({ $percentage } %)
        }
bar-tooltip-tracker =
    .title = Sporingsinnhald
    .aria-label =
        { $count ->
            [one] { $count } sporingsinnhald ({ $percentage } %)
           *[other] { $count } sporingsinnhald ({ $percentage } %)
        }
bar-tooltip-fingerprinter =
    .title = Fingerprinters
    .aria-label =
        { $count ->
            [one] { $count } fingerprinter ({ $percentage }%)
           *[other] { $count } fingerprinters ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Kryptoutvinnarar
    .aria-label =
        { $count ->
            [one] { $count } kryptominar ({ $percentage }%)
           *[other] { $count } Kryptoutvinnarar ({ $percentage }%)
        }
