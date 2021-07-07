# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } blokerede  { $count } sporings-mekanisme den seneste uge
       *[other] { -brand-short-name } blokerede { $count } sporings-mekanismer den seneste uge
    }
# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> sporings-mekanismer blokeret siden { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] <b>{ $count }</b> sporings-mekanismer blokeret siden { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }
# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } fortsætter med at blokere sporings-teknologier i private vinduer, men gemmer ikke en oversigt over, hvad der blev blokeret.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Sporings-mekanismer, { -brand-short-name } blokerede denne uge
protection-report-webpage-title = Oversigt over beskyttelse
protection-report-page-content-title = Oversigt over beskyttelse
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } kan beskytte dit privatliv, mens du bruger nettet. Dette viser dit personlige resume over, hvordan du er beskyttet - samt værktøj til at tage kontrol over din online identitet.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } beskytter dit privatliv på nettet. Denne side viser dit personlige resume over, hvordan du er beskyttet - samt værktøj til at tage kontrol over din online identitet.
protection-report-settings-link = Håndter dine indstillinger for sikkerhed og privatlivs-beskyttelse
etp-card-title-always = Udvidet beskyttelse mod sporing: Altid slået til
etp-card-title-custom-not-blocking = Udvidet beskyttelse mod sporing: SLÅET FRA
etp-card-content-description = { -brand-short-name } forhindrer automatisk virksomheder i at følge dig i smug på nettet.
protection-report-etp-card-content-custom-not-blocking = Beskyttelse er slået fra. Du kan vælge, hvilke sporings-teknologier der skal blokeres, i indstillingerne for beskyttelse i { -brand-short-name }.
protection-report-manage-protections = Håndter indstillinger
# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = I dag
# This string is used to describe the graph for screenreader users.
graph-legend-description = En graf, der viser det totale antal af hver type sporings-teknologi, der er blevet blokeret i denne uge
social-tab-title = Sporing via sociale medier
social-tab-contant = Sociale medier placerer sporings-mekanismer på andre websteder for at følge med i, hvad du gør og ser på nettet. Det giver virksomhederne bag de sociale medier mulighed for at lære mere om dig, end det du ellers selv deler på de sociale medier. <a data-l10n-name="learn-more-link">Læs mere</a>
cookie-tab-title = Sporings-cookies på tværs af websteder
cookie-tab-content = Disse cookies følger dig fra websted til websted for at indsamle data om, hvad du gør på nettet. De anvendes af tredjeparter som fx annoncører og analyse-virksomheder. Du kan reducere antallet af reklamer, der følger dig rundt på nettet, ved at blokere sporings-cookies på tværs af websteder. <a data-l10n-name="learn-more-link">Læs mere</a>
tracker-tab-title = Sporings-indhold
tracker-tab-description = Websteder kan indlæse eksterne annoncer, video og andet indhold, der indeholder sporings-kode. Ved at blokere sporings-indhold kan websteder blive hurtigere indlæst, men nogle knapper formularer og login-bokse virker måske ikke. <a data-l10n-name="learn-more-link">Læs mere</a>
fingerprinter-tab-title = Fingerprinters
fingerprinter-tab-content = Fingerprinters indsamler indstillinger fra din browser og din computer for at skabe en profil af dig. Ved at bruge dette digitale fingeraftryk kan de spore dig på tværs af forskellige websteder. <a data-l10n-name="learn-more-link">Læs mere</a>
cryptominer-tab-title = Cryptominers
cryptominer-tab-content = Cryptominers bruger din computers ressourcer til at udvinde digital valuta. Cryptomining-scripts gør din computer langsommere og får den til at bruge mere strøm, og de kan dermed dræne dit batteri. <a data-l10n-name="learn-more-link">Læs mere</a>
protections-close-button2 =
    .aria-label = Luk
    .title = Luk
mobile-app-title = Bloker sporing fra reklamer på alle enheder
mobile-app-card-content = Brug mobil-browseren med indbygget beskyttelse mod sporing fra reklamer.
mobile-app-links = { -brand-product-name }-browser til <a data-l10n-name="android-mobile-inline-link">Android</a> og <a data-l10n-name="ios-mobile-inline-link">iOS</a>
lockwise-title = Glem aldrig en adgangskode igen
lockwise-title-logged-in2 = Håndtering af adgangskoder
lockwise-header-content = { -lockwise-brand-name } gemmer dine adgangskoder i din browser på en sikker måde.
lockwise-header-content-logged-in = Gem og synkroniser dine adgangskoder på alle dine enheder.
protection-report-save-passwords-button = Gem adgangskoder
    .title = Gem adgangskoder i { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Håndter adgangskoder
    .title = Håndter adgangskoder i { -lockwise-brand-short-name }
lockwise-mobile-app-title = Tag dine adgangskoder med overalt
lockwise-no-logins-card-content = Brug adgangskoder gemt i { -brand-short-name } på enhver enhed.
lockwise-app-links = { -lockwise-brand-name } til <a data-l10n-name="lockwise-android-inline-link">Android</a> og <a data-l10n-name="lockwise-ios-inline-link">iOS</a>
# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] 1 adgangskode kan være kompromitteret i en datalæk.
       *[other] { $count } adgangskoder kan være kompromitteret i en datalæk.
    }
# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] 1 adgangskode gemt sikkert.
       *[other] Dine adgangskoder er gemt sikkert.
    }
lockwise-how-it-works-link = Sådan virker det
turn-on-sync = Aktivér { -sync-brand-short-name }…
    .title = Gå til sync-indstillinger
monitor-title = Hold øje med datalæk
monitor-link = Sådan virker det
monitor-header-content-no-account = Brug { -monitor-brand-name } til at se, om dine informationer har været ramt af en datalæk - og få advarsler om nye datalæk.
monitor-header-content-signed-in = { -monitor-brand-name } advarer dig, hvis dine informationer har været ramt af en datalæk.
monitor-sign-up-link = Tilmeld dig advarsler om datalæk
    .title = Tilmed dig advarsler om datalæk fra { -monitor-brand-name }
auto-scan = Automatisk skannet i dag
monitor-emails-tooltip =
    .title = Vis overvågede mailadresser på { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = Vis kendte datalæk på { -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = Vis kompromitterede adgangskoder på { -monitor-brand-short-name }
# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] mailadresse bliver overvåget
       *[other] mailadresser bliver overvåget
    }
# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] kendt datalæk har kompromitteret dine informationer
       *[other] kendte datalæk har kompromitteret dine informationer
    }
# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] kendt datalæk markeret som løst
       *[other] kendte datalæk markeret som løste
    }
# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] adgangskode er blevet kompromitteret i datalæk
       *[other] adgangskoder er blevet kompromitteret i datalæk
    }
# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] adgangskode kompromitteret i uløste datalæk
       *[other] adgangskoder kompromitteret i uløste datalæk
    }
monitor-no-breaches-title = Gode nyheder!
monitor-no-breaches-description = Du er ikke blevet ramt af datalæk. Vi giver dig besked, hvis det sker.
monitor-view-report-link = Se rapport
    .title = Løste datalæk på { -monitor-brand-short-name }
monitor-breaches-unresolved-title = Løs dine datalæk
monitor-breaches-unresolved-description = Når du har kigget på detaljerne i et datalæk og har taget forholdsregler for at beskytte dine oplysninger, så kan du markere datalækket som løst.
monitor-manage-breaches-link = Håndter datalæk
    .title = Håndter datalæk på { -monitor-brand-short-name }
monitor-breaches-resolved-title = Godt gået! Du har løst alle kendte datalæk.
monitor-breaches-resolved-description = Vi giver dig besked, hvis din mailadresse optræder i nye datalæk.
# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
       *[other] { $numBreachesResolved } ud af { $numBreaches } datalæk markeret som løst
    }
# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved }% færdig
monitor-partial-breaches-motivation-title-start = Godt begyndt!
monitor-partial-breaches-motivation-title-middle = Bare lidt endnu!
monitor-partial-breaches-motivation-title-end = Du er næsten færdig!
monitor-partial-breaches-motivation-description = Løs resten af dine datalæk på { -monitor-brand-short-name }.
monitor-resolve-breaches-link = Løs datalæk
    .title = Løs datalæk på { -monitor-brand-short-name }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Sporing via sociale medier
    .aria-label =
        { $count ->
            [one] { $count } sporing via sociale medier ({ $percentage }%)
           *[other] { $count } sporinger via sociale medier  ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = Sporings-cookies på tværs af websteder
    .aria-label =
        { $count ->
            [one] { $count } sporings-cookie på tværs af websteder ({ $percentage }%)
           *[other] { $count } sporings-cookies på tværs af websteder ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Sporings-indhold
    .aria-label =
        { $count ->
            [one] { $count } sporings-indhold ({ $percentage }%)
           *[other] { $count } sporings-indhold ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Fingerprinters
    .aria-label =
        { $count ->
            [one] { $count } fingerprinter ({ $percentage }%)
           *[other] { $count } fingerprinters ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Cryptominers
    .aria-label =
        { $count ->
            [one] { $count } cryptominer ({ $percentage }%)
           *[other] { $count } cryptominers ({ $percentage }%)
        }
