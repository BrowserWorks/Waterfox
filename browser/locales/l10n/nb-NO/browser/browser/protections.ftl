# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } blokkerte { $count } sporer den siste uken
       *[other] { -brand-short-name } blokkerte { $count } sporere den siste uken
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> sporer blokkert siden { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] <b>{ $count }</b> sporere blokkert siden { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } fortsetter å  blokkere sporere i private vindu, men holder ikke oversikt over hva som ble blokkert.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Sporere { -brand-short-name } blokkerte denne uken

protection-report-webpage-title = Sikkerhetsoversikt
protection-report-page-content-title = Sikkerhetsoversikt
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } kan beskytte personvernet ditt bak kulissene mens du surfer. Dette er en personlig oppsummering av de beskyttelsene, inkludert verktøy for å ta kontroll over din sikkerhet på nettet.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } beskytter personvernet ditt bak kulissene mens du surfer. Dette er en personlig oppsummering av de beskyttelsene, inkludert verktøy for å ta kontroll over din sikkerhet på nettet.

protection-report-settings-link = Behandle personvern- og sikkerhetsinnstillinger

etp-card-title-always = Utvidet sporingsbeskyttelse: alltid på
etp-card-title-custom-not-blocking = Utvidet sporingsbeskyttelse: AV
etp-card-content-description = { -brand-short-name } stopper selskaper automatisk fra å spore aktivitetene dine på nettet det skjulte.
protection-report-etp-card-content-custom-not-blocking = All beskyttelse er for tiden slått av. Velg hvilke sporere du vil blokkere ved å behandle innstillingene for beskyttelse i { -brand-short-name }.
protection-report-manage-protections = Behandle innstillinger

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = I dag

# This string is used to describe the graph for screenreader users.
graph-legend-description = En graf som inneholder det totale antallet for hver type av sporere som har blitt blokkert denne uken.

social-tab-title = Sporing via sosiale medier
social-tab-contant = Sosiale nettverk plasserer sporere på andre nettsteder for å følge det du gjør og ser på nettet. Dette gjør at sosiale media-selskaper kan lære mer om deg utover det du deler på profilene dine på sosiale medier. <a data-l10n-name="learn-more-link">Les mer</a>

cookie-tab-title = Sporingsinfokapsler på tvers av nettsteder
cookie-tab-content = Disse infokapslene følger deg fra nettsted til nettsted for å samle inn data om hva du gjør på nettet. De er satt av tredjeparter som annonsører og analyseselskaper. Blokkering av sporingsinfokapsler på tvers av nettsteder reduserer antall annonser som følger deg. <a data-l10n-name="learn-more-link">Les mer</a>

tracker-tab-title = Sporings-innhold
tracker-tab-description = Nettsteder kan laste inn eksterne annonser, videoer og annet innhold med sporingskode. Blokkering av sporingsinnhold kan hjelpe nettsteder å laste raskere, men noen knapper, skjemaer og innloggingsfelt fungerer kanskje ikke. <a data-l10n-name="learn-more-link">Les mer</a>

fingerprinter-tab-title = Fingerprinters
fingerprinter-tab-content = Fingerprinters samler innstillinger fra nettleseren din og datamaskinen for å opprette en profil av deg. Ved hjelp av dette digitale fingeravtrykket kan de spore deg på forskjellige nettsteder. <a data-l10n-name="learn-more-link">Les mer</a>

cryptominer-tab-title = Kryptoutvinnere
cryptominer-tab-content = Kryptoutvinnere bruker systemets datakraft for å utvinne digitale penger. Kryptoutvinningsskript tapper batteriet, gjør datamaskinen tregere og kan øke strømregningen. <a data-l10n-name="learn-more-link">Les mer</a>

protections-close-button2 =
    .aria-label = Lukk
    .title = Lukk
  
mobile-app-title = Blokker annonsesporere på flere enheter
mobile-app-card-content = Bruk mobilnettleseren med innebygd beskyttelse mot annonsesporing.
mobile-app-links = { -brand-product-name } Nettleser for <a data-l10n-name="android-mobile-inline-link">Android</a> og <a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = Glem aldri et passord igjen
lockwise-title-logged-in2 = Passordbehandling
lockwise-header-content = { -lockwise-brand-name } lagrer passordene dine sikkert i nettleseren din.
lockwise-header-content-logged-in = Lagre passordene dine sikkert og synkroniser dem med alle enhetene dine.
protection-report-save-passwords-button = Lagre passord
    .title = Lagre passord i { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Behandle passord
    .title = Behandle passord i { -lockwise-brand-short-name }
lockwise-mobile-app-title = Ta med deg passordene dine overalt
lockwise-no-logins-card-content = Bruk passord som er lagret i { -brand-short-name } på hvilken som helst enhet.
lockwise-app-links = { -lockwise-brand-name } for <a data-l10n-name="lockwise-android-inline-link">Android</a> og <a data-l10n-name="lockwise-ios-inline-link">iOS</a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] 1 passord kan ha blitt eksponert i en datalekkasje.
       *[other] { $count } passord kan ha blitt eksponert i en datalekkasje.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] 1 passord lagret sikkert.
       *[other] Passordene dine blir lagret sikkert.
    }
lockwise-how-it-works-link = Hvordan det fungerer

turn-on-sync = Slå på { -sync-brand-short-name }…
    .title = Gå til innstillinger for sync

monitor-title = Se opp for på datalekkasjer.
monitor-link = Hvordan det virker
monitor-header-content-no-account = Sjekk { -monitor-brand-name } for å se om du har vært en del av en kjent datalekkasje og få varsler om nye lekkasjer.
monitor-header-content-signed-in = { -monitor-brand-name } advarer deg om informasjonen din har dukket opp i en kjent datalekkasje.
monitor-sign-up-link = Registrer deg for datalekkasjevarsler
    .title = Registrer deg for datalekkasjevarsler på { -monitor-brand-name }
auto-scan = Skannes automatisk i dag

monitor-emails-tooltip =
    .title = Vis overvåkede e-postadresser på { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = Se kjente datalekkasjer på { -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = Se eksponerte passord på { -monitor-brand-short-name }

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] E-postadresse som overvåkes
       *[other] E-postadresser som overvåkes
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] Kjent datalekkasje har eksponert din informasjon
       *[other] Kjente datalekkasjer har eksponert din informasjon
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] Kjent datalekkasje merket som løste
       *[other] Kjente datalekkasjer merket som løste
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] Passord eksponert fra alle datalekkasjer.
       *[other] Passord eksponert fra alle datalekkasjer.
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] Passord eksponerte i uløste datalekkasjer
       *[other] Passord eksponerte i uløste datalekkasjer
    }

monitor-no-breaches-title = Gode nyheter!
monitor-no-breaches-description = Du har ingen kjente datalekkasjer. Hvis det endres, vil vi gi deg beskjed.
monitor-view-report-link = Vis rapport
    .title = Løs datalekkasjer på { -monitor-brand-short-name }
monitor-breaches-unresolved-title = Løs dine datalekkasjer
monitor-breaches-unresolved-description = Etter å ha gått gjennom datalekkasje-detaljer og satt i verk tiltak for å ta vare på den personlige informasjonen din, kan du merke datalekkasjer som løst.
monitor-manage-breaches-link = Behandle datalekkasjer
    .title = Behandle datalekkasjer på { -monitor-brand-short-name }
monitor-breaches-resolved-title = Så bra! Du har løst alle kjente datalekkasjer.
monitor-breaches-resolved-description = Vi vil gi deg beskjed om e-postadressen din dukker opp i nye datalekkasjer.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
       *[other] { $numBreachesResolved } av { $numBreaches } datalekkasjer er merket som løste
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved } % fullført

monitor-partial-breaches-motivation-title-start = Bra start!
monitor-partial-breaches-motivation-title-middle = Fortsett slik!
monitor-partial-breaches-motivation-title-end = Nesten ferdig! Fortsett slik.
monitor-partial-breaches-motivation-description = Løs resten av datalekkasjene dine på { -monitor-brand-short-name }.
monitor-resolve-breaches-link = Løs datalekkasjer
    .title = Løs datalekkasjer på { -monitor-brand-short-name }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Sporere via sosiale medier
    .aria-label =
        { $count ->
            [one] { $count } sporer via sosiale medier ({ $percentage } %)
           *[other] { $count } sporere via sosiale medier ({ $percentage } %)
        }
bar-tooltip-cookie =
    .title = Sporingsinfokapsler på tvers av nettsteder
    .aria-label =
        { $count ->
            [one] { $count } sporingsinfokapsel på tvers av nettsteder ({ $percentage } %)
           *[other] { $count } sporingsinfokapsler på tvers av nettsteder ({ $percentage } %)
        }
bar-tooltip-tracker =
    .title = Sporings-innhold
    .aria-label =
        { $count ->
            [one] { $count } sporings-innhold ({ $percentage } %)
           *[other] { $count } sporings-innhold ({ $percentage } %)
        }
bar-tooltip-fingerprinter =
    .title = Fingerprinters
    .aria-label =
        { $count ->
            [one] { $count } fingerprinter ({ $percentage }%)
           *[other] { $count } fingerprinters ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Kryptoutvinnere
    .aria-label =
        { $count ->
            [one] { $count } kryptominer ({ $percentage }%)
           *[other] { $count } kryptoutvinnere ({ $percentage }%)
        }
