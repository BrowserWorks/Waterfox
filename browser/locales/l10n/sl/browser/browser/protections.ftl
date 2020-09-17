# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } je v zadnjem tednu zavrnil { $count } sledilca
        [two] { -brand-short-name } je v zadnjem tednu zavrnil { $count } sledilca
        [few] { -brand-short-name } je v zadnjem tednu zavrnil { $count } sledilce
       *[other] { -brand-short-name } je v zadnjem tednu zavrnil { $count } sledilcev
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> sledilec zavrnjen od { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
        [two] <b>{ $count }</b> sledilca zavrnjena od { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
        [few] <b>{ $count }</b> sledilci zavrnjeni od { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] <b>{ $count }</b> sledilcev zavrnjenih od { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } še naprej zavrača sledilce v zasebnih oknih, vendar ne vodi seznama zavrnjenih vsebin.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Sledilci, ki jih je { -brand-short-name } zavrnil v tem tednu

protection-report-webpage-title = Nadzorna plošča zaščit
protection-report-page-content-title = Nadzorna plošča zaščit
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } lahko med brskanjem neopazno ščiti vašo zasebnost. To je prilagojen povzetek zaščit, vključno z orodji za nadzor nad vašo spletno varnostjo.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } med brskanjem neopazno ščiti vašo zasebnost. To je prilagojen povzetek zaščit, vključno z orodji za nadzor nad vašo spletno varnostjo.

protection-report-settings-link = Upravljaj nastavitve zasebnosti in varnosti

etp-card-title-always = Izboljšana zaščita pred sledenjem: vedno vključena
etp-card-title-custom-not-blocking = Izboljšana zaščita pred sledenjem: izključena
etp-card-content-description = { -brand-short-name } samodejno prepreči, da bi vas podjetja na skrivaj spremljala po spletu.
protection-report-etp-card-content-custom-not-blocking = Vse zaščite so trenutno izklopljene. V nastavitvah { -brand-short-name }a izberite, katere sledilce želite zavračati.
protection-report-manage-protections = Upravljanje nastavitev

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Danes

# This string is used to describe the graph for screenreader users.
graph-legend-description = Graf vključuje skupno število posameznih vrst sledilcev, ki so bili zavrnjeni v tem tednu.

social-tab-title = Sledilci družbenih omrežij
social-tab-contant = Družbena omrežja postavljajo sledilce na druga spletna mesta, da bi spremljali, kaj počnete, vidite in gledate na spletu. To družbenim medijem omogoča, da o vas izvedo več kot le tisto, kar delite na svojih družbenih profilih. <a data-l10n-name="learn-more-link">Več o tem</a>

cookie-tab-title = Spletni sledilni piškotki
cookie-tab-content = Ti piškotki vas spremljajo po straneh in zbirajo podatke o tem, kaj počnete na spletu. Namestijo jih tretje strani, kot so oglaševalci in analitična podjetja. Zavračanje sledilnih piškotkov zmanjša število oglasov, ki vam sledijo. <a data-l10n-name="learn-more-link">Več o tem</a>

tracker-tab-title = Sledilna vsebina
tracker-tab-description = Spletne strani lahko naložijo zunanje oglase, videoposnetke in drugo vsebino s kodo za sledenje. Zavračanje sledilne vsebine lahko pospeši nalaganje spletnih strani, vendar nekateri gumbi in obrazci morda ne bodo delovali. <a data-l10n-name="learn-more-link">Več o tem</a>

fingerprinter-tab-title = Sledilci prstnih odtisov
fingerprinter-tab-content = Sledilci prstnih odtisov zbirajo nastavitve vašega brskalnika in računalnika, da si ustvarijo vaš profil. S pomočjo digitalnega prstnega odtisa vam lahko sledijo na različnih spletnih straneh. <a data-l10n-name="learn-more-link">Več o tem</a>

cryptominer-tab-title = Kriptorudarji
cryptominer-tab-content = Kriptorudarji izrabljajo zmogljivost vašega računalnika za rudarjenje digitalnega denarja. Rudarski skripti vam praznijo baterijo, upočasnjujejo računalnik in zasolijo račun za elektriko. <a data-l10n-name="learn-more-link">Več o tem</a>

protections-close-button2 =
    .aria-label = Zapri
    .title = Zapri
  
mobile-app-title = Zavrnite sledilce oglasov na več napravah
mobile-app-card-content = Uporabljajte mobilni brskalnik z vgrajeno zaščito pred sledilci oglasov.
mobile-app-links = Brskalnik { -brand-product-name } za <a data-l10n-name="android-mobile-inline-link">Android</a> in <a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = Nikoli več ne pozabite gesla
lockwise-title-logged-in2 = Upravljanje gesel
lockwise-header-content = { -lockwise-brand-name } varno hrani vaša gesla v brskalniku.
lockwise-header-content-logged-in = Varno hranite in sinhronizirajte svoja gesla na vseh napravah.
protection-report-save-passwords-button = Shranite gesla
    .title = Shranite gesla v { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Upravljajte gesla
    .title = Upravljajte gesla v { -lockwise-brand-short-name }u
lockwise-mobile-app-title = Vzemite gesla s seboj
lockwise-no-logins-card-content = Uporabljajte gesla, shranjena v { -brand-short-name }, na katerikoli napravi.
lockwise-app-links = { -lockwise-brand-name } za <a data-l10n-name="lockwise-android-inline-link">Android</a> in <a data-l10n-name="lockwise-ios-inline-link">iOS</a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] 1 geslo je morda bilo izpostavljeno v kraji podatkov.
        [two] { $count } gesli sta morda bili izpostavljeni v kraji podatkov.
        [few] { $count } gesla so morda bila izpostavljena v kraji podatkov.
       *[other] { $count } gesel je morda bilo izpostavljenih v kraji podatkov.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] { $count } geslo varno shranjeno.
        [two] { $count } gesli varno shranjeni.
        [few] { $count } gesla varno shranjena.
       *[other] { $count } gesel varno shranjenih.
    }
lockwise-how-it-works-link = Kako deluje

turn-on-sync = Vklopi { -sync-brand-short-name } ...
    .title = Pojdi na nastavitve Synca

monitor-title = Bodite obveščeni o krajah podatkov
monitor-link = Kako deluje
monitor-header-content-no-account = Preverite s { -monitor-brand-name }jem, ali ste bili vpleteni v znano krajo podatkov, ter prejemajte opozorila o novih krajah.
monitor-header-content-signed-in = { -monitor-brand-name } vas opozori, če se vaši podatki pojavijo v znani kraji podatkov.
monitor-sign-up-link = Prijavite se na opozorila o krajah
    .title = Prijavite se na opozorila o krajah v { -monitor-brand-name }ju
auto-scan = Samodejno preverjeno danes

monitor-emails-tooltip =
    .title = Oglejte si nadzorovane e-poštne naslove v { -monitor-brand-short-name }ju
monitor-breaches-tooltip =
    .title = Oglejte si znane kraje podatkov v { -monitor-brand-short-name }ju
monitor-passwords-tooltip =
    .title = Oglejte si izpostavljena gesla v { -monitor-brand-short-name }ju

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] nadzorovan e-poštni naslov
        [two] nadzorovana e-poštna naslova
        [few] nadzorovani e-poštni naslovi
       *[other] nadzorovanih e-poštnih naslovov
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] znana kraja podatkov je izpostavila vaše podatke
        [two] znani kraji podatkov sta izpostavili vaše podatke
        [few] znane kraje podatkov so izpostavile vaše podatke
       *[other] znanih kraj podatkov je izpostavilo vaše podatke
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] znana kraja je bila označena kot razrešena
        [two] znani kraji sta bili označena kot razrešeni
        [few] znane kraje so bile označene kot razrešene
       *[other] znanih kraj je bilo označenih kot razrešenih
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] geslo je bilo izpostavljeno v vseh krajah
        [two] gesli sta bili izpostavljeni v vseh krajah
        [few] gesla so bila izpostavljena v vseh krajah
       *[other] gesel je bilo izpostavljenih v vseh krajah
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] geslo je bilo izpostavljeno v nerazrešenih krajah
        [two] gesli sta bili izpostavljeni v nerazrešenih krajah
        [few] gesla so bila izpostavljena v nerazrešenih krajah
       *[other] gesel je bilo izpostavljenih v nerazrešenih krajah
    }

monitor-no-breaches-title = Dobre novice!
monitor-no-breaches-description = Niste bili udeleženi v znanih krajah. Če se to spremeni, vas bomo obvestili.
monitor-view-report-link = Prikaži poročilo
    .title = Razrešite kraje v { -monitor-brand-short-name }ju
monitor-breaches-unresolved-title = Razrešite svoje kraje
monitor-breaches-unresolved-description = Po pregledu podrobnosti o kraji podatkov in izvedbi ukrepov za zaščito vaših podatkov, lahko kraje podatkov označite kot razrešene.
monitor-manage-breaches-link = Upravljajte kraje
    .title = Upravljajte kraje v { -monitor-brand-short-name }ju
monitor-breaches-resolved-title = Super! Razrešili ste vse znane kraje.
monitor-breaches-resolved-description = Če se bo vaš e-poštni naslov pojavil v novih krajah, vas bomo obvestili.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
        [one] { $numBreachesResolved } od { $numBreaches } kraj podatkov je bila označena kot razrešena
        [two] { $numBreachesResolved } od { $numBreaches } kraj podatkov sta bili označeni kot razrešeni
        [few] { $numBreachesResolved } od { $numBreaches } kraj podatkov so bile označene kot razrešene
       *[other] { $numBreachesResolved } od { $numBreaches } kraj podatkov je bilo označenih kot razrešenih
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved }% dokončano

monitor-partial-breaches-motivation-title-start = Odličen začetek!
monitor-partial-breaches-motivation-title-middle = Nadaljujte!
monitor-partial-breaches-motivation-title-end = Skoraj ste končali! Nadaljujte.
monitor-partial-breaches-motivation-description = Razrešite ostale kraje v { -monitor-brand-short-name }ju.
monitor-resolve-breaches-link = Razreši kraje
    .title = Razrešite kraje v { -monitor-brand-short-name }ju

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Sledilci družbenih omrežij
    .aria-label =
        { $count ->
            [one] { $count } sledilec družbenih omrežij ({ $percentage } %)
            [two] { $count } sledilca družbenih omrežij ({ $percentage } %)
            [few] { $count } sledilci družbenih omrežij ({ $percentage } %)
           *[other] { $count } sledilcev družbenih omrežij ({ $percentage } %)
        }
bar-tooltip-cookie =
    .title = Spletni sledilni piškotki
    .aria-label =
        { $count ->
            [one] { $count } spletni sledilni piškotek ({ $percentage } %)
            [two] { $count } spletna sledilna piškotka ({ $percentage } %)
            [few] { $count } spletni sledilni piškotki ({ $percentage } %)
           *[other] { $count } spletnih sledilnih piškotkov ({ $percentage } %)
        }
bar-tooltip-tracker =
    .title = Sledilna vsebina
    .aria-label =
        { $count ->
            [one] { $count } sledilna vsebina ({ $percentage } %)
            [two] { $count } sledilni vsebini ({ $percentage } %)
            [few] { $count } sledilne vsebine ({ $percentage } %)
           *[other] { $count } sledilnih vsebin ({ $percentage } %)
        }
bar-tooltip-fingerprinter =
    .title = Sledilci prstnih odtisov
    .aria-label =
        { $count ->
            [one] { $count } sledilec prstnih odtisov ({ $percentage } %)
            [two] { $count } sledilca prstnih odtisov ({ $percentage } %)
            [few] { $count } sledilci prstnih odtisov ({ $percentage } %)
           *[other] { $count } sledilcev prstnih odtisov ({ $percentage } %)
        }
bar-tooltip-cryptominer =
    .title = Kriptorudarji
    .aria-label =
        { $count ->
            [one] { $count } kriptorudar ({ $percentage } %)
            [two] { $count } kriptorudarja ({ $percentage } %)
            [few] { $count } kriptorudarji ({ $percentage } %)
           *[other] { $count } kriptorudarjev ({ $percentage } %)
        }
