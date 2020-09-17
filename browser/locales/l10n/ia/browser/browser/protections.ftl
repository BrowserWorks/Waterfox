# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } ha blocate { $count } traciator durante le passate septimana
       *[other] { -brand-short-name } ha blocate { $count } traciatores durante le passate septimana
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> traciator blocate desde { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] <b>{ $count }</b> traciatores blocate desde { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } continua a blocar traciatores in fenestras private, ma non conserva alcun information de lo que ha essite blocate.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Traciatores que { -brand-short-name } ha blocate iste septimana

protection-report-webpage-title = Pannello de protectiones
protection-report-page-content-title = Pannello de protectiones
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } pote proteger tu vita private durante que tu naviga. Ecce un summario personal de iste protectiones, con utensiles pro prender le controlo de tu securitate in linea.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } protege tu confidentialitate durante que tu naviga. Ecce un summario personalisate de iste protectiones, con utensiles pro prender le controlo de tu securitate in linea.

protection-report-settings-link = Gerer tu confidentialitate e parametros de securitate

etp-card-title-always = Protection antitraciamento reinfortiate: Sempre active
etp-card-title-custom-not-blocking = Protection antitraciamento reinfortiate: NON ACTIVE
etp-card-content-description = { -brand-short-name } impedi automaticamente que interprisas te seque secretemente sur le web.
protection-report-etp-card-content-custom-not-blocking = Tote le protectiones es actualmente disactivate. Selige le traciatores a blocar per gerer le parametros de protection de { -brand-short-name }.
protection-report-manage-protections = Gerer le parametros

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Hodie

# This string is used to describe the graph for screenreader users.
graph-legend-description = Un graphico que contine le numero total de cata typo de traciator blocate iste septimana.

social-tab-title = Traciatores de retes social
social-tab-contant = Le retes social placia traciatores sur altere sitos web pro sequer lo que tu face, vide e reguarda in linea. Isto permitte al companias de rete social de saper plus sur te, ultra lo que tu comparti sur tu profilos de rete social. <a data-l10n-name="learn-more-link">Saper plus</a>

cookie-tab-title = Cookies de traciamento inter sitos
cookie-tab-content = Iste cookies te seque de sito a sito pro colliger datos sur lo que tu face in linea. Illos es deponite per tertios, p.ex. companias de publicitate e de analyse de datos. Blocar le cookies de traciamento inter sitos reduce le numero de annuncios que te seque. <a data-l10n-name="learn-more-link">Lege plus</a>

tracker-tab-title = Contento traciator
tracker-tab-description = Sitos web pote cargar annuncios externe, videos e altere contento con codice de traciamento. Blocar contento de traciamento pote adjutar sitos a cargar se plus rapidemente, ma alcun buttones, formularios e campos de aperir session pote non functionar. <a data-l10n-name="learn-more-link">Saper plus</a>

fingerprinter-tab-title = Dactylogrammatores
fingerprinter-tab-content = Le dactylogrammatores collige parametros de tu navigator e computator pro crear un profilo de te. Usante iste identitate digital, illos pote traciar te inter differente sitos web. <a data-l10n-name="learn-more-link">Lege plus</a>

cryptominer-tab-title = Cryptominatores
cryptominer-tab-content = Cryptominatores usa le potentia de calculo de tu systema pro excavar moneta digital. Scripts de cryptominage exhauri tu batteria, relenta tu computator e pote accrescer le factura de tu energia.<a data-l10n-name="learn-more-link">Saper plus</a>

protections-close-button2 =
    .aria-label = Clauder
    .title = Clauder
  
mobile-app-title = Blocar traciatores publicitari sur plure apparatos
mobile-app-card-content = Usa le navigator mobile con protection integrate contra traciamento publicitari.
mobile-app-links = Navigator { -brand-product-name } pro <a data-l10n-name="android-mobile-inline-link">Android</a> e <a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = Non oblida plus tu contrasignos
lockwise-title-logged-in2 = Gestion de contrasignos
lockwise-header-content = { -lockwise-brand-name } immagazina con securitate tu contrasignos in tu navigator.
lockwise-header-content-logged-in = Memorisa e synchronisa tu contrasignos sur tote tu apparatos in tote securitate.
protection-report-save-passwords-button = Salvar contrasignos
    .title = Salvar contrasignos sur { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Gerer contrasignos
    .title = Gerer contrasignos sur { -lockwise-brand-short-name }
lockwise-mobile-app-title = Porta tu contrasignos sempre con te
lockwise-no-logins-card-content = Usa le contrasignos salvate in { -brand-short-name } sur qualcunque apparato.
lockwise-app-links = { -lockwise-brand-name } pro <a data-l10n-name="lockwise-android-inline-link">Android</a> e <a data-l10n-name="lockwise-ios-inline-link">iOS</a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] 1 contrasigno pote haber essite exponite in un violation de datos.
       *[other] { $count } contrasignos pote haber essite exponite in un violation de datos.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] 1 contrasigno immagazinate in modo secur.
       *[other] Tu contrasignos es immagazinate in modo secur.
    }
lockwise-how-it-works-link = Como functiona

turn-on-sync = Accende { -sync-brand-short-name }…
    .title = Ir al preferentias de Sync

monitor-title = Vigilantia contra violationes de datos
monitor-link = Como illo functiona
monitor-header-content-no-account = Consulta { -monitor-brand-name } pro vider si tu ha essite parte de un violation cognoscite de datos e reciper avisos sur nove violationes.
monitor-header-content-signed-in = { -monitor-brand-name } te adverti si tu information ha apparite in un violation cognoscite de datos.
monitor-sign-up-link = Inscriber te al Avisos de violation
    .title = Inscriber te al Avisos de violation sur { -monitor-brand-name }
auto-scan = Controlate automaticamente hodie

monitor-emails-tooltip =
    .title = Vider le adresses de e-mail surveliate sur { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = Vider le violationes de datos cognoscite sur { -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = Vider le contrasignos exponite sur { -monitor-brand-short-name }

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] Adresse de e-mail surveliate
       *[other] Adresses de e-mail surveliate
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] violation cognoscite de datos ha exponite tu information
       *[other] violationes cognoscite de datos ha exponite tu information
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] Violation de datos note marcate como resolvite
       *[other] Violationes de datos note marcate como resolvite
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] Contrasigno exponite inter tote le violationes
       *[other] Contrasignos exponite inter tote le violationes
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] Contrasigno exponite in violationes non resolvite
       *[other] Contrasignos exponite in violationes non resolvite
    }

monitor-no-breaches-title = Bon novas!
monitor-no-breaches-description = Tu non ha ulle violationes note. Si isto cambia, nos te facera saper.
monitor-view-report-link = Vider reporto
    .title = Resolve violationes sur { -monitor-brand-short-name }
monitor-breaches-unresolved-title = Resolver tu violationes
monitor-breaches-unresolved-description = Post revider detalios del violationes e prender mesuras pro proteger tu informationes, tu potera marcar le violationes como resolvite.
monitor-manage-breaches-link = Gerer violationes
    .title = Gerer violationes sur { -monitor-brand-short-name }
monitor-breaches-resolved-title = Optimo! Tu ha resolvite tote le violationes.
monitor-breaches-resolved-description = Si tu email appare in ulle nove violationes, nos te facera saper.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
        [one] { $numBreachesResolved } de { $numBreaches } violationes marcate como resolvite
       *[other] { $numBreachesResolved } de { $numBreaches } violationes marcate como resolvite
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved }% complete

monitor-partial-breaches-motivation-title-start = Comencia!
monitor-partial-breaches-motivation-title-middle = Continua assi!
monitor-partial-breaches-motivation-title-end = Quasi finite. Continua assi!
monitor-partial-breaches-motivation-description = Resolve le altere tu violationes sur { -monitor-brand-short-name }.
monitor-resolve-breaches-link = Resolver violationes
    .title = Resolver violationes sur { -monitor-brand-short-name }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Traciatores de retes social
    .aria-label =
        { $count ->
            [one] { $count } traciator de retes social ({ $percentage }%)
           *[other] { $count } traciatores de retes social ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = Cookies de traciamento inter sitos
    .aria-label =
        { $count ->
            [one] { $count } cookie de traciamento inter sitos ( { $percentage } %)
           *[other] { $count } cookies de traciamento inter sitos ( { $percentage } %)
        }
bar-tooltip-tracker =
    .title = Contento traciator
    .aria-label =
        { $count ->
            [one] { $count } contento traciator ({ $percentage }%)
           *[other] { $count } contento traciator ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Dactylogrammatores
    .aria-label =
        { $count ->
            [one] { $count } dactylogrammator ({ $percentage }%)
           *[other] { $count } dactylogrammatores ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Cryptominatores
    .aria-label =
        { $count ->
            [one] { $count } cryptominator ({ $percentage }%)
           *[other] { $count } cryptominatores ({ $percentage }%)
        }
