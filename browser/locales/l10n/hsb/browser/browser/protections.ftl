# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } je { $count } přesćěhowak zańdźeny tydźeń zablokował
        [two] { -brand-short-name } je { $count } přesćěhowakaj zańdźeny tydźeń zablokował
        [few] { -brand-short-name } je { $count } přesćěhowaki zańdźeny tydźeń zablokował
       *[other] { -brand-short-name } je { $count } přesćěhowakow zańdźeny tydźeń zablokował
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> přesćěhowak je so wot { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") } zablokował
        [two] <b>{ $count }</b> přesćěhowakaj je so wot { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") } zablokowałoj
        [few] <b>{ $count }</b> přesćěhowaki je so wot { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") } zablokowali
       *[other] <b>{ $count }</b> přesćěhowakow je so wot { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") } zablokowało
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } přesćěhowaki w priwatnych woknach dale blokuje, ale njezapřijima, što je so zablokowało.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Přesćěhowaki, kotrež { -brand-short-name } je so tutón tydźeń zablokował

protection-report-webpage-title = Přehlad škitow
protection-report-page-content-title = Přehlad škitow
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } móže wašu priwatnosć za kulisami škitać, mjeztym zo přehladujeće. To je personalizowane zjeće tutych škitnych naprawow, mjez nimi nastroje, kotrež wašu wěstotu online kontroluja.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } wašu priwatnosć za kulisami škita, mjeztym zo přehladujeće. To je personalizowane zjeće tutych škitnych naprawow, mjez nimi nastroje, kotrež wašu wěstotu online kontroluja.

protection-report-settings-link = Nastajenja priwatnosće a wěstoty rjadować

etp-card-title-always = Polěpšeny slědowanski škit: přeco zmóžnjeny
etp-card-title-custom-not-blocking = Polěpšeny slědowanski škit: ZNJEMÓŽNJENY
etp-card-content-description = { -brand-short-name } awtomatisce zadźěwa tomu, zo předewzaća wam skradźu po webje slěduja.
protection-report-etp-card-content-custom-not-blocking = Kóždy škit je tuchwilu wotpinjeny. Wubjerće, kotre přesćěhowaki maja so přez rjadowanje wašich škitnych nastajenjow { -brand-short-name } blokować.
protection-report-manage-protections = Nastajenja rjadować

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Dźensa

# This string is used to describe the graph for screenreader users.
graph-legend-description = Graf, kotryž cyłkownu ličbu kóždeho typa přesćěhowaka pokazuje, kotryž je so tutón tydźeń zablokował.

social-tab-title = Přesćěhowaki socialnych medijow
social-tab-contant = Socialne syće placěruja přesćěhowaki na druhich websydłach, zo bychu slědowali, što online činiće, widźiće a wobkedźbujeće. To předewzaćam socialnych medijow dowola, wjace wo was zhonił hač w profilach socialnych medijow dźěliće. <a data-l10n-name="learn-more-link">Dalše informacije</a>

cookie-tab-title = Slědowace placki mjez sydłami
cookie-tab-content = Tute placki wam wot sydła do sydła slěduja, zo byšće daty wo tym hromadźili, štož online činiće. Stajeja so wot třećich poskićowarjow kaž na přikład wabjerjo a analyzowe předewzaća, Blokowanje slědowacych plackow mjez sydłami ličbu wabjenjow redukuje, kotrež wam slěduja. <a data-l10n-name="learn-more-link">Dalše informacije</a>

tracker-tab-title = Slědowacy wobsah
tracker-tab-description = Websydła móža eksterne wabjenje, wideja a druhi wobsah ze slědowacym kodom začitać. Hdyž slědowacy wobsah blokujeće, móže to pomhać, sydła spěšnišo začitać, ale někotre tłóčatka, formulary a přizjewjenske pola snano hižo njebudu fungować. <a data-l10n-name="learn-more-link">Dalše informacije</a>

fingerprinter-tab-title = Porstowe wotćišće
fingerprinter-tab-content = Porstowe wotćišće zběraja nastajenja z wašeho wobhladowaka a ličaka, zo bychu profil wo was wutworili. Hdyž tutón digitalny porstowy wotćišć wužiwaće, móža wam přez rozdźělne websydła slědować. <a data-l10n-name="learn-more-link">Dalše informacije</a>

cryptominer-tab-title = Kryptokopanje
cryptominer-tab-content = Kryptokopanje ličenski wukon wašeho systema wužiwa, zo by digitalne pjenjezy dobyło. Kryptokopanske skripty wašu bateriju prózdnja, waš ličak spomaleja a móža wašu přetrjebu energije powyšić. <a data-l10n-name="learn-more-link">Dalše informacije</a>

protections-close-button2 =
    .aria-label = Začinić
    .title = Začinić
  
mobile-app-title = Wabjenske přesćěhowaki přez dalše graty blokować
mobile-app-card-content = Mobilny wobhladowak ze zatwarjenym škitom přećiwo wabjenskemu slědowanju wužiwać
mobile-app-links = Wobhladowak { -brand-product-name } za <a data-l10n-name="android-mobile-inline-link">Android</a> a <a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = Njezabywajće ženje wjace hesło
lockwise-title-logged-in2 = Rjadowanje hesłow
lockwise-header-content = { -lockwise-brand-name } waše hesła we wašim wobhladowaku wěsće składuje.
lockwise-header-content-logged-in = Składujće a synchronizujće hesła za wšě waše graty.
protection-report-save-passwords-button = Hesła składować
    .title = Hesła w { -lockwise-brand-short-name } składować
protection-report-manage-passwords-button = Hesła rjadować
    .title = Hesła w { -lockwise-brand-short-name } rjadować
lockwise-mobile-app-title = Wzmiće swoje hesła wšudźe sobu
lockwise-no-logins-card-content = Wužiwajće hesła, kotrež sće w { -brand-short-name } składował, na kóždym graće.
lockwise-app-links = { -lockwise-brand-name } za <a data-l10n-name="lockwise-android-inline-link">Android</a> a <a data-l10n-name="lockwise-ios-inline-link"></a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] { $count } hesło je so datowej dźěrje wustajiło.
        [two] { $count } hesle stej so datowej dźěrje wustajiłoj.
        [few] { $count } hesła su so datowej dźěrje wustajili.
       *[other] { $count } hesłow je so datowej dźěrje wustajiło.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] { $count } hesło je so wěsće składowało.
        [two] { $count } hesle stej so wěsće składowałoj.
        [few] { $count } hesła su so wěsće składowali.
       *[other] { $count } hesłow je so wěsće składowało.
    }
lockwise-how-it-works-link = Kak funguje

turn-on-sync = { -sync-brand-short-name } zmóžnić
    .title = K synchronizowanskim nastajenjam

monitor-title = Rozhladujće so za datowymi dźěrami
monitor-link = Kak funguje
monitor-header-content-no-account = Přepruwujće { -monitor-brand-name }, zo byšće zwěsćił, hač sće na znatu datowu dźěru padnył a warnowanja wo nowych dźěrach dóstawaće.
monitor-header-content-signed-in = { -monitor-brand-name } was warnuje, jeli waše informacije su so w znatej datowej dźěrje zjewili.
monitor-sign-up-link = Registrujće so za warnowanja wo datowych dźěrach
    .title = Registrujće so za warnowanja wo datowych dźěrach na { -monitor-brand-name }
auto-scan = Dźensa awtomatisce skenowany

monitor-emails-tooltip =
    .title = Dohladowane e-mejlowe adresy w { -monitor-brand-short-name } pokazać
monitor-breaches-tooltip =
    .title = Znate datowe dźěry w { -monitor-brand-short-name } pokazać
monitor-passwords-tooltip =
    .title = Wotkryte hesła w { -monitor-brand-short-name } pokazać

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] E-mejlowa adresa, kotraž so dohladuje
        [two] E-mejlowej adresy, kotrejž so dohladujetej
        [few] E-mejlowe adresy, kotrež so dohladuja
       *[other] E-mejlowe adresy, kotrež so dohladuja
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] Znata datowa dźěra je waše informacije přeradźiła
        [two] Znatej datowej dźěrje stej waše informacije přeradźiłoj
        [few] Znate datowe dźěry su waše informacije přeradźili
       *[other] Znate datowe dźěry su waše informacije přeradźili
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] znata datowa dźěra je so jako rozrisana markěrowała
        [two] znatej datowej dźěrje stej so jako rozrisanej markěrowałoj
        [few] znate datowe dźěry su so jako rozrisane markěrowali
       *[other] znatych datowych dźěrow je so jako rozrisane markěrowało
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] Hesło je so přez wšě datowe dźery přeradźiło
        [two] Hesle stejso přez wšě datowe dźery přeradźiłoj
        [few] Hesła su so přez wšě datowe dźery přeradźili
       *[other] Hesła su so přez wšě datowe dźery přeradźili
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] hesło je so w njerozrisanych datowych dźěrach pokazało
        [two] hesle stej so w njerozrisanych datowych dźěrach pokazałoj
        [few] hesła su so w njerozrisanych datowych dźěrach pokazali
       *[other] hesłow je so w njerozrisanych datowych dźěrach pokazało
    }

monitor-no-breaches-title = Dobre powěsće!
monitor-no-breaches-description = Nimaće žane znate datowe dźěry. Jeli so to změni, zdźělimy wam to.
monitor-view-report-link = Rozprawu pokazać
    .title = Datowe dźěry na { -monitor-brand-short-name } wotstronić
monitor-breaches-unresolved-title = Wotstrońće swoje datowe dźěry
monitor-breaches-unresolved-description = Po tym zo sće podrobnosće datoweje dźěry přepruwował a něšto činił, zo byšće swoje informacije škitał, móžeće datowe dźěry ako rozrisane markěrować.
monitor-manage-breaches-link = Datowe dźěry rjadować
    .title = Datowe dźěry na { -monitor-brand-short-name } rjadować
monitor-breaches-resolved-title = Wulkotnje! Sće wšě znate datowe dźěry wotstronił.
monitor-breaches-resolved-description = Jeli so waša e-mejlowa adresa w nowych datowych dźěrach jewi, zdźělimy wam to.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
        [one] { $numBreachesResolved } z { $numBreaches } datowych dźěrow je so jako wotstronjena markěrowała.
        [two] { $numBreachesResolved } z { $numBreaches } datowych dźěrow stej so jako wotstronjenej markěrowałoj.
        [few] { $numBreachesResolved } z { $numBreaches } datowych dźěrow su so jako wotstronjene markěrowali.
       *[other] { $numBreachesResolved } z { $numBreaches } datowych dźěrow je so jako wotstronjene markěrowało.
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved } % dokónčene

monitor-partial-breaches-motivation-title-start = Wulkotny spočatk!
monitor-partial-breaches-motivation-title-middle = Dale tak!
monitor-partial-breaches-motivation-title-end = Nimale dokónčene! Dale tak.
monitor-partial-breaches-motivation-description = Wotstrońće zbytk swojich datowych dźěrow na { -monitor-brand-short-name }.
monitor-resolve-breaches-link = Datowe dźěry wotstronić
    .title = Datowe dźěry na { -monitor-brand-short-name } wotstronić

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Přesćěhowaki socialnych medijow
    .aria-label =
        { $count ->
            [one] { $count } přesćěhowak socialnych medijow ({ $percentage } %)
            [two] { $count } přesćěhowakaj socialnych medijow ({ $percentage } %)
            [few] { $count } přesćěhowaki socialnych medijow ({ $percentage } %)
           *[other] { $count } přesćěhowakow socialnych medijow ({ $percentage } %)
        }
bar-tooltip-cookie =
    .title = Slědowace placki mjez sydłami
    .aria-label =
        { $count ->
            [one] { $count } slědowacy plack mjez sydłami ({ $percentage } %)
            [two] { $count } slědowacej plackaj mjez sydłami ({ $percentage } %)
            [few] { $count } slědowace placki mjez sydłami ({ $percentage } %)
           *[other] { $count } slědowacych plackow mjez sydłami ({ $percentage } %)
        }
bar-tooltip-tracker =
    .title = Slědowacy wobsah
    .aria-label =
        { $count ->
            [one] { $count } slědowacy wobsah ({ $percentage } %)
            [two] { $count } slědowacej wobsahaj ({ $percentage } %)
            [few] { $count } slědowace wobsahi ({ $percentage } %)
           *[other] { $count } slědowacych wobsahow ({ $percentage } %)
        }
bar-tooltip-fingerprinter =
    .title = Porstowe wotćišće
    .aria-label =
        { $count ->
            [one] { $count } porstowy wotćišć ({ $percentage } %)
            [two] { $count } porstowej wotćišćej ({ $percentage } %)
            [few] { $count } porstowe wotćišće ({ $percentage } %)
           *[other] { $count } porstowych wotćišćow ({ $percentage } %)
        }
bar-tooltip-cryptominer =
    .title = Kryptokopaki
    .aria-label =
        { $count ->
            [one] { $count } kryptokopak ({ $percentage } %)
            [two] { $count } kryptokopakaj ({ $percentage } %)
            [few] { $count } kryptokopaki ({ $percentage } %)
           *[other] { $count } kryptokopakow ({ $percentage } %)
        }
