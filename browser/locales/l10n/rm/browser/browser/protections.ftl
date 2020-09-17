# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } ha bloccà { $count } fastizader durant l'emna passada
       *[other] { -brand-short-name } ha bloccà { $count } fastizaders durant l'emna passada
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> fastizader bloccà dapi ils { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] <b>{ $count }</b> fastizaders bloccads dapi ils { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } cuntinuescha a bloccar fastizaders en fanestras privatas ma na registrescha betg tge ch'è vegnì bloccà.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Fastizaders che { -brand-short-name } ha bloccà questa emna

protection-report-webpage-title = Armaturas da protecziun
protection-report-page-content-title = Armaturas da protecziun
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } po proteger davos las culissas tias datas privatas durant che ti navigheschas. Quai è ina resumaziun persunalisada da questas protecziuns, inclus utensils per garantir la segirezza online.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } protegia tias datas privatas davos las culissas durant che ti navigheschas. Quai è ina resumaziun persunalisada da questas protecziuns, inclus utensils che garanteschan tia segirezza online.

protection-report-settings-link = Administrescha tes parameters da protecziun da datas e da segirezza

etp-card-title-always = Protecziun avanzada cunter il fastizar: Adina activà
etp-card-title-custom-not-blocking = Protecziun avanzada cunter il fastizar: DEACTIVÀ
etp-card-content-description = { -brand-short-name } impedescha automaticamain che interpresas ta persequiteschian a la zuppada en il web.
protection-report-etp-card-content-custom-not-blocking = Tut las protecziuns èn actualmain deactivadas. Tscherna ils fastizaders che duain vegnir bloccads cun administrar ils parameters da protecziuns da { -brand-short-name }.
protection-report-manage-protections = Administrar ils parameters

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Oz

# This string is used to describe the graph for screenreader users.
graph-legend-description = In diagram che cuntegna il dumber total da mintga tip da fastizader bloccà quest'emna.

social-tab-title = Fastizaders da raits socialas
social-tab-contant = Raits socialas plazzeschan fastizaders sin autras websites per observar tge che ti fas, vesas e guardas online. Quai lubescha als concerns da medias socialas dad intervegnir chaussas davart tai che surpassan quai che ti cundividas sin tes profils da medias socialas. <a data-l10n-name="learn-more-link">Ulteriuras infurmaziuns</a>

cookie-tab-title = Cookies che fastizeschan tranter websites
cookie-tab-content = Quests cookies ta suondan dad ina website a l'autra per rimnar datas davart quai che ti fas online. Els vegnan plazzads da terzas partidas sco firmas da reclama ed analisa da datas. Cun bloccar ils cookies che fastizeschan tranter websites sa reducescha il dumber da reclamas che ta suondan. <a data-l10n-name="learn-more-link">Ulteriuras infurmaziuns</a>

tracker-tab-title = Cuntegn che fastizescha
tracker-tab-description = Websites pon chargiar reclamas, videos ed auter cuntegn extern cun code per fastizar. Bloccar quest cuntegn che fastizescha po gidar a websites da chargiar pli svelt, ma tscherts buttuns, formulars e champs d'annunzia na funcziunan eventualmain betg pli. <a data-l10n-name="learn-more-link">Ulteriuras infurmaziuns</a>

fingerprinter-tab-title = Improntaders
fingerprinter-tab-content = Improntaders rimnan parameters da tes navigatur e computer per crear in profil da tai. Cun utilisar questa impronta dal det digitala pon els suandar tes fastiz tranter ina website e la proxima. <a data-l10n-name="learn-more-link">Ulteriuras infurmaziuns</a>

cryptominer-tab-title = Criptominiers
cryptominer-tab-content = Criptominiers maldovran las resursas da tes sistem per generar daners digitals. Scripts da criptominiers consuman la battaria, ralenteschan tes computer e pon augmentar il quint da l'electricitad. <a data-l10n-name="learn-more-link">Ulteriuras infurmaziuns</a>

protections-close-button2 =
    .aria-label = Serrar
    .title = Serrar
  
mobile-app-title = Bloccar fastizaders da reclama sin plirs apparats
mobile-app-card-content = Utilisar il navigatur mobil cun protecziun cunter fastizaders da reclama integrada.
mobile-app-links = { -brand-product-name } Navigatur per <a data-l10n-name="android-mobile-inline-link">Android</a> ed <a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = Mai pli perder in pled-clav
lockwise-title-logged-in2 = Administraziun da pleds-clav
lockwise-header-content = { -lockwise-brand-name } memorisescha tes pleds-clav a moda segira en tes navigatur.
lockwise-header-content-logged-in = Memorisescha e sincronisescha a moda segira tes pleds-clav sin tut tes apparats.
protection-report-save-passwords-button = Memorisar ils pleds-clav
    .title = Memorisar ils pleds-clav en { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Administrar ils pleds-clav
    .title = Administrar ils pleds-clav cun { -lockwise-brand-short-name }
lockwise-mobile-app-title = Prenda tes pleds-clav adina cun tai
lockwise-no-logins-card-content = Dovra ils pleds-clav memorisads en { -brand-short-name } sin mintga apparat.
lockwise-app-links = { -lockwise-brand-name } per <a data-l10n-name="lockwise-android-inline-link">Android</a> ed <a data-l10n-name="lockwise-ios-inline-link">iOS</a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] 1 pled-clav pudess esser pertutgà dad ina sperdita da datas.
       *[other] { $count } pleds-clav pudessan esser pertutgads dad ina sperdita da datas.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] 1 pled-clav è memorisà a moda segira.
       *[other] Tes pleds-clav èn memorisads a moda segira.
    }
lockwise-how-it-works-link = Co ch'i funcziuna

turn-on-sync = Activar { -sync-brand-short-name }…
    .title = Acceder a las preferenzas da sync

monitor-title = Tegna en egl las sperditas da datas
monitor-link = Co ch'i funcziuna
monitor-header-content-no-account = Consultescha { -monitor-brand-name } per verifitgar sche ti es pertutgà dad ina sperdita da datas e per retschaiver avertiments en cas da novas sperditas.
monitor-header-content-signed-in = { -monitor-brand-name } t'avertescha en cas che tias infurmaziuns cumparan en ina sperdita da datas enconuschenta.
monitor-sign-up-link = S'inscriver per avertiments da sperditas da datas
    .title = S'inscriver en { -monitor-brand-name } per avertiments da sperditas da datas
auto-scan = Controllà automaticamain oz

monitor-emails-tooltip =
    .title = Mussar las adressas d'e-mail survegliadas en { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = Mussar las sperditas da datas enconuschentas en { -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = Mussar ils pleds-clav pertutgads en { -monitor-brand-short-name }

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] Adressa dad e-mail survegliada
       *[other] Adressas dad e-mail survegliadas
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] sperdita da datas enconuschenta ha cumpromess tias infurmaziuns
       *[other] sperditas da datas enconuschentas han cumpromess tias infurmaziuns
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] Sperdita da datas enconuschenta marcada sco schliada
       *[other] Sperditas da datas enconuschentas marcadas sco schliadas
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] pled-clav cumpromess en tut las sperditas da datas
       *[other] pleds-clav cumpromess en tut las sperditas da datas
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] Pled-clav cumpromess en sperditas da datas betg schliadas
       *[other] Pleds-clav cumpromess en sperditas da datas betg schliadas
    }

monitor-no-breaches-title = Bunas novas!
monitor-no-breaches-description = Ti na cumparas en naginas sperditas da datas enconuschentas. Sche quai sa mida, ta faschain nus a savair.
monitor-view-report-link = Vesair il rapport
    .title = Reglar sperditas da datas en { -monitor-brand-short-name }
monitor-breaches-unresolved-title = Reglar tias sperditas da datas
monitor-breaches-unresolved-description = Suenter avair controllà ils detagls dad ina sperdita da datas ed avair prendì las mesiras necessarias per proteger tai e tias datas, pos ti marcar la sperdita da datas sco schliada.
monitor-manage-breaches-link = Administrar las sperditas da datas
    .title = Administrar las sperditas da datas en { -monitor-brand-short-name }
monitor-breaches-resolved-title = Bun! Ti has reglà tut ils problems en connex cun sperditas da datas enconuschentas.
monitor-breaches-resolved-description = Sche tia adressa cumpara en ina nova sperdita da datas, ta faschain nus a savair.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
        [one] Marcà sco schlià { $numBreachesResolved } sperdita da datas da { $numBreaches }
       *[other] Marcà sco schlià { $numBreachesResolved } sperditas da datas da { $numBreaches }
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = Cumplettà per { $percentageResolved }%

monitor-partial-breaches-motivation-title-start = In bun cumenzament!
monitor-partial-breaches-motivation-title-middle = Cuntinuescha uschia!
monitor-partial-breaches-motivation-title-end = Quasi finì! Cuntinuescha uschia.
monitor-partial-breaches-motivation-description = Schlia il rest da tias sperditas da datas en { -monitor-brand-short-name }.
monitor-resolve-breaches-link = Schliar sperditas da datas
    .title = Schliar sperditas da datas en { -monitor-brand-short-name }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Fastizaders da medias socialas
    .aria-label =
        { $count ->
            [one] { $count } fastizader da medias socialas ({ $percentage }%)
           *[other] { $count } fastizaders da medias socialas ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = Cookies che fastizeschan tranter websites
    .aria-label =
        { $count ->
            [one] { $count } cookie che fastizescha tranter websites ({ $percentage }%)
           *[other] { $count } cookies che fastizescha tranter websites ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Cuntegn che fastizescha
    .aria-label =
        { $count ->
            [one] { $count } cuntegn che fastizescha ({ $percentage }%)
           *[other] { $count } cuntegns che fastizeschan ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Improntaders
    .aria-label =
        { $count ->
            [one] { $count } improntader ({ $percentage }%)
           *[other] { $count } improntaders ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Criptominiers
    .aria-label =
        { $count ->
            [one] { $count } criptominier ({ $percentage }%)
           *[other] { $count } criptominiers ({ $percentage }%)
        }
