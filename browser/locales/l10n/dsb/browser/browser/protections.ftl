# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } jo zablokěrował { $count } pśeslědowak zajźony tyźeń
        [two] { -brand-short-name } jo zablokěrował { $count } pśeslědowaka zajźony tyźeń
        [few] { -brand-short-name } jo zablokěrował { $count } pśeslědowaki zajźony tyźeń
       *[other] { -brand-short-name } jo zablokěrował { $count } pśeslědowakow zajźony tyźeń
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> pśeslědowak jo se  zablokěrował wót { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
        [two] <b>{ $count }</b> pśeslědowaka stej se  zablokěrowałej wót { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
        [few] <b>{ $count }</b> pśeslědowaki su se  zablokěrowali wót { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] <b>{ $count }</b> pśeslědowakow jo se  zablokěrowało wót { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } pśeslědowaki w priwatnych woknach dalej blokěrujo, ale njeregistrěrujo, co jo se zablokěrowało.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Pśeslědowaki, kótarež { -brand-short-name } jo se blokěrował toś ten tyźeń

protection-report-webpage-title = Pśeglěd šćitow
protection-report-page-content-title = Pśeglěd šćitow
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } móžo wašu priwatnosć za kulisami šćitaś, mjaztym až pśeglědujośo. To jo personalizěrowane zespominanje toś tych šćitnych napšawow, mjazy nimi rědy, kótarež wašu wěstotu online kontrolěruju.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } wašu priwatnosć za kulisami šćita, mjaztym až pśeglědujośo. To jo personalizěrowane zespominanje toś tych šćitnych napšawow, mjazy nimi rědy, kótarež wašu wěstotu online kontrolěruju.

protection-report-settings-link = Nastajenja priwatnosći a wěstoty zastojaś

etp-card-title-always = Pólěpšony slědowański šćit: pśecej zmóžnjony
etp-card-title-custom-not-blocking = Pólěpšony slědowański šćit: ZNJEMÓŽNJONY
etp-card-content-description = { -brand-short-name } awtomatiski pśedewześam zawoborujo, wam kšajźu pó webje slědowaś.
protection-report-etp-card-content-custom-not-blocking = Kuždy šćit jo tuchylu wótšaltowany. Wubjeŕśo, kótare pśeslědowaki maju se pśez zastojanje wašych šćitnych nastajenjow { -brand-short-name } blokěrowaś.
protection-report-manage-protections = Nastajenja zastojaś

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Źinsa

# This string is used to describe the graph for screenreader users.
graph-legend-description = Graf, kótaryž cełkownu licbu kuždego typa pśeslědowaka pokazujo, kótaryž jo se zablokěrował toś ten tyźeń.

social-tab-title = Pśeslědowaki socialnych medijow
social-tab-contant = Socialne seśi placěruju pśeslědowaki na drugich websedłach, aby slědowali, což online gótujośo, wiźiśo a se wobglědujośo. To pśedewześam socialnych medijow dowólujo, wěcej wó was zgónił ako w profilach socialnych medijow źěliśo. <a data-l10n-name="learn-more-link">Dalšne informacije</a>

cookie-tab-title = Slědujuce cookieje mjazy sedłami
cookie-tab-content = Toś te cookieje wam wót sedła do sedła slěduju, aby wy daty wó tom gromaźili, což online gótujośo. Stajaju se wót tśeśich póbitowarjow ako na pśikład wabjarje a analyzowe pśedewześa, Blokěrowanje slědujucych cookiejow mjazy sedłami licbu wabjenjow reducěrujo, kótarež wam slěduju. <a data-l10n-name="learn-more-link">Dalšne informacije</a>

tracker-tab-title = Slědujuce wopśimjeśe
tracker-tab-description = Websedła mógu eksterne wabjenje, wideo a druge wośimjeśe ze slědujucym kodom zacytaś. Gaž slědujuce wopśimjeśe blokěrujośo, móžo to pomagaś, sedła malsnjej zacytaś, ale někotare tłocaški, formulary a pśizjawjeńske póla snaź wěcej njebudu funkcioněrowaś. <a data-l10n-name="learn-more-link">Dalšne informacije</a>

fingerprinter-tab-title = Palcowe wótśišće
fingerprinter-tab-content = Palcowe wótśišće zběraju nastajenja z wašogo wobglědowaka a licadła, aby profil wó was napórali. Gaž toś ten digitalny palcowy wótśišć wužywaśo, mógu wam pśez rozdźělne websedła slědowaś. <a data-l10n-name="learn-more-link">Dalšne informacije</a>

cryptominer-tab-title = Kryptokopaki
cryptominer-tab-content = Kryptokopaki liceńske wugbaśe wašogo systema wužywaju, aby digitalne pjenjeze dobyli. Kryptokopańske skripty wašu bateriju proznje, wašo licadło spómałšuju a mógu wašu pśetrjebu energije pówušyś. <a data-l10n-name="learn-more-link">Dalšne informacije</a>

protections-close-button2 =
    .aria-label = Zacyniś
    .title = Zacyniś
  
mobile-app-title = Wabjeńske pśeslědowaki pśez dalšne rěy blokěrowaś
mobile-app-card-content = Mobilny wobglědowak ze zatwarjonym šćitom pśeśiwo wabjeńskemu slědowanjeju wužywaś
mobile-app-links = Wobglědowak { -brand-product-name } za <a data-l10n-name="android-mobile-inline-link">Android</a> a <a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = Njezabywajśo nigda wěcej gronidło
lockwise-title-logged-in2 = Zastojanje gronidłow
lockwise-header-content = { -lockwise-brand-name } waše gronidła we wašom wobglědowaku wěsće składujo.
lockwise-header-content-logged-in = Składujśo a synchronizěrujśo gronidła za wšykne waše rědy.
protection-report-save-passwords-button = Gronidła składowaś
    .title = Gronidła w { -lockwise-brand-short-name } składowaś
protection-report-manage-passwords-button = Gronidła zastojaś
    .title = Gronidła w { -lockwise-brand-short-name } zastojaś
lockwise-mobile-app-title = Wzejśo swóje gronidła wšuźi sobu
lockwise-no-logins-card-content = Wužywajśo gronidła, kótarež sćo składł w { -brand-short-name }, na kuždem rěźe.
lockwise-app-links = { -lockwise-brand-name } za <a data-l10n-name="lockwise-android-inline-link">Android</a> a <a data-l10n-name="lockwise-ios-inline-link"></a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] { $count } gronidło jo se datowej źěrje wustajiło.
        [two] { $count } gronidle stej se datowej źěrje wustajiłej.
        [few] { $count } gronidła su se datowej źěrje wustajili.
       *[other] { $count } gronidłow jo se datowej źěrje wustajiło.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] { $count } gronidło jo se wěsće składło.
        [two] { $count } gronidle stej se wěsće składłej.
        [few] { $count } gronidła su se wěsće składli.
       *[other] { $count } gronidła jo se wěsće składło.
    }
lockwise-how-it-works-link = Kak funkcioněrujo

turn-on-sync = { -sync-brand-short-name } zmóžniś
    .title = K synchronizěrowańskim nastajenjam

monitor-title = Rozglědujśo se za datowymi źěrami
monitor-link = Kak funkcioněrujo
monitor-header-content-no-account = Pśeglědajśo { -monitor-brand-name }, aby zwěsćił, lěc sćo padnuł na znatu datowu źěru a warnowanja wó nowych źěrach dostawaśo.
monitor-header-content-signed-in = { -monitor-brand-name } was warnujo, jolic waše informacije su se pokazali w znatej datowej źěrje.
monitor-sign-up-link = Registrěrujśo se za warnowanja wó datowych źěrach
    .title = Registrěrujśo se za warnowanja wó datowych źěrach na { -monitor-brand-name }
auto-scan = Źinsa awtomatiski skannowany

monitor-emails-tooltip =
    .title = Doglědowane e-mailowe adrese w { -monitor-brand-short-name } pokazaś
monitor-breaches-tooltip =
    .title = Znate datowe źěry w { -monitor-brand-short-name } pokazaś
monitor-passwords-tooltip =
    .title = Wótekšyte gronidła w { -monitor-brand-short-name } pokazaś

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] E-mailowa adresa, kótarež se doglědujo
        [two] E-mailowej adresy, kótarež se doglědujotej
        [few] E-mailowe adrese, kótarež se doglěduju
       *[other] E-mailowe adrese, kótarež se doglěduju
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] Znata datowa źěra jo pśeraźiła waše informacije
        [two] Znatej datowej źěrje stej pśeraźiłej waše informacije
        [few] Znate datowe źěry su pśeraźili waše informacije
       *[other] Znate datowe źěry su pśeraźili waše informacije
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] znata datowa źěra jo se markěrowała ako rozwězana
        [two] znatej datowej źěrje stej se markěrowałej ako rozwězanej
        [few] znate datowe źěry su se markěrowali ako rozwězane
       *[other] znatych datowych źěrow jo se markěrowało ako rozwězane
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] Gronidło jo se pśeraźiło pśez wšykne datowe źery
        [two] Gronidle stej se pśeraźiłej pśez wšykne datowe źery
        [few] Gronidła su se pśeraźili pśez wšykne datowe źery
       *[other] Gronidła su se pśeraźili pśez wšykne datowe źery
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] gronidło jo se pokazało w njerozwězanych datowych źěrach
        [two] gronidle stej se pokazałej w njerozwězanych datowych źěrach
        [few] gronidła su se pokazali w njerozwězanych datowych źěrach
       *[other] gronidłow jo se pokazało w njerozwězanych datowych źěrach
    }

monitor-no-breaches-title = Dobre powěsći!
monitor-no-breaches-description = Njamaśo žedne znate datowe źěry. Jolic se to změnijo, dajomy wam to k wěsći.
monitor-view-report-link = Rozpšawu pokazaś
    .title = Datowe źěry na { -monitor-brand-short-name } rozwězaś
monitor-breaches-unresolved-title = Rozwěźćo swóje datowe źěry
monitor-breaches-unresolved-description = Za tym až sćo pśeglědał drobnostki datoweje źěry a něco cynił, aby swóje informacije šćitał, móžośo datowe źěry ako rozwězane markěrowaś.
monitor-manage-breaches-link = Datowe źěry zastojaś
    .title = Datowe źěry na { -monitor-brand-short-name } zastojaś
monitor-breaches-resolved-title = Wjelicnje! Sćo rozwězał wšykne znate datowe źěry.
monitor-breaches-resolved-description = Jolic se waša e-mailowa adresa w nowych datowych źěrach pokazujo, dajomy wam to k wěsći.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
        [one] { $numBreachesResolved } z { $numBreaches } datowych źěrow jo se markěrowała ako rozwězana.
        [two] { $numBreachesResolved } z { $numBreaches } datowych źěrow stej se markěrowałej ako rozwězanej.
        [few] { $numBreachesResolved } z { $numBreaches } datowych źěrow su se markěrowali ako rozwězane.
       *[other] { $numBreachesResolved } z { $numBreaches } datowych źěrow jo se markěrowało ako rozwězane.
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved } % dokóńcone

monitor-partial-breaches-motivation-title-start = Wjelicny zachopjeńk!
monitor-partial-breaches-motivation-title-middle = Dalej tak!
monitor-partial-breaches-motivation-title-end = Pśisamem dokóńcone! Dalej tak.
monitor-partial-breaches-motivation-description = Rozwěźćo zbytk swójich datowych źěrow na { -monitor-brand-short-name }.
monitor-resolve-breaches-link = Datowe źěry rozwězaś
    .title = Datowe źěry na { -monitor-brand-short-name } rozwězaś

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Pśeslědowaki socialnych medijow
    .aria-label =
        { $count ->
            [one] { $count } pśeslědowak socialnych medijow({ $percentage } %)
            [two] { $count } pśeslědowaka socialnych medijow ({ $percentage } %)
            [few] { $count } pśeslědowaki socialnych medijow ({ $percentage } %)
           *[other] { $count } pśeslědowakow socialnych medijow ({ $percentage } %)
        }
bar-tooltip-cookie =
    .title = Slědujuce cookieje mjazy sedłami
    .aria-label =
        { $count ->
            [one] { $count } slědujucy cookie mjazy sedłami ({ $percentage } %)
            [two] { $count } slědujucej cookieja mjazy sedłami ({ $percentage } %)
            [few] { $count } slědujuce cookieje mjaz sedłami ({ $percentage } %)
           *[other] { $count } slědujucych cookiejow mjazy sedłami ({ $percentage } %)
        }
bar-tooltip-tracker =
    .title = Slědujuce wopśimjeśe
    .aria-label =
        { $count ->
            [one] { $count } slědujuce wopśimjeśe ({ $percentage } %)
            [two] { $count } slědujucej wopśimjeśi ({ $percentage } %)
            [few] { $count } slědujuce wopśimjeśa ({ $percentage } %)
           *[other] { $count } slědujucych wopśimjeśow ({ $percentage } %)
        }
bar-tooltip-fingerprinter =
    .title = Palcowe wótśišće
    .aria-label =
        { $count ->
            [one] { $count } palcowy wótśišć ({ $percentage } %)
            [two] { $count } palcowej wótśišća ({ $percentage } %)
            [few] { $count } palcowe wótśišće ({ $percentage } %)
           *[other] { $count } palcowych wótśišćow ({ $percentage } %)
        }
bar-tooltip-cryptominer =
    .title = kryptokopaki
    .aria-label =
        { $count ->
            [one] { $count } kryptokopak ({ $percentage } %)
            [two] { $count } kryptokopaka ({ $percentage } %)
            [few] { $count } kryptokopaki ({ $percentage } %)
           *[other] { $count } kryptokopakow ({ $percentage } %)
        }
