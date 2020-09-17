# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] A semana pasada { -brand-short-name } bloqueou { $count } rastrexador nesta semana pasada
       *[other] A semana pasada { -brand-short-name } bloqueou { $count } rastrexadores nesta semana pasada
    }
# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> tracexador bloqueado desde o { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] <b>{ $count }</b> tracexadores bloqueados desde o { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }
# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } segue  bloqueando os rastrexadores nas xanelas privadas pero non garda un rexistro do bloqueado.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Rastrexadores bloqueados polo { -brand-short-name } nesta semana
protection-report-webpage-title = Panel de proteccións
protection-report-page-content-title = Panel de proteccións
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } pode protexer a súa privacidade entre bastidores mentres navega. Este é un resumo personalizado destas proteccións, incluíndo ferramentas para controlar a seguridade en liña.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } protexe a súa privacidade entre bastidores mentres navega. Este é un resumo personalizado destas proteccións, incluíndo ferramentas para controlar a seguridade en liña.
protection-report-settings-link = Xestione a súa configuración de privacidade e seguridade
etp-card-title-always = Protección de seguimento mellorada: sempre activada
etp-card-title-custom-not-blocking = Protección avanzada de rastreo: Desactivada
etp-card-content-description = { -brand-short-name } impide automaticamente que as empresas sigan a súa presenza en segredo pola rede.
protection-report-etp-card-content-custom-not-blocking = Actualmente todas as proteccións están desactivadas. Escolla que rastreadores bloquear xestionando a súa configuración de protección { -brand-short-name }.
protection-report-manage-protections = Xestionar configuración
# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Hoxe
# This string is used to describe the graph for screenreader users.
graph-legend-description = Unha gráfica que contén o número total de cada tipo de rastrexador bloqueado esta semana.
social-tab-title = Rastrexadores de redes sociais
social-tab-contant = As redes sociais colocan rastrexadores noutros sitios web para seguir o que vostede fai, vexa e mire na Rede. Isto permitelles ás empresas de redes sociais aprenderen máis sobre vostede máis alá do que comparta nos seus perfís de redes sociais. <a data-l10n-name="learn-more-link">Máis información</a>
cookie-tab-title = Cookies de rastrexo entre sitios
cookie-tab-content = Estas cookies seguen a súa presenza de sitio en sitio para recolleren datos sobre o que faga en liña. Están establecidos por terceiros, como anunciantes e empresas de análise. O bloqueo de cookies de rastrexo entre sitios reduce o número de anuncios que o seguen. <a data-l10n-name="learn-more-link">Máis información</a>
tracker-tab-title = Rastrexamento de contido
tracker-tab-description = Os sitios web poden cargar anuncios externos, vídeos e outro contido con código de rastrexo. O bloqueo de contido de rastrexo pode axudar a que os sitios se carguen máis rápido, pero é posible que algúns botóns, formularios e campos de inicio de sesión non funcionen. <a data-l10n-name="learn-more-link">Máis información</a>
fingerprinter-tab-title = Pegadas dixitais
fingerprinter-tab-content = As pegadas dixitais recollen a configuración do seu navegador e computador para crearen un perfil de vostede. Usando esta pegada dixital, poden rastrear a súa presenza en diferentes sitios web. <a data-l10n-name="learn-more-link">Máis información</a>
cryptominer-tab-title = Criptomineiros
cryptominer-tab-content = Os criptomineiros usan o poder informático do seu sistema para minar cartos dixitais. Os scripts de criptomoeda drenan a batería, desaceleran o ordenador e poden aumentar a súa factura enerxética. <a data-l10n-name="learn-more-link">Máis información</a>
protections-close-button2 =
    .aria-label = Pechar
    .title = Pechar
mobile-app-title = Bloqueo de rastrexadores de anuncios en máis dispositivos
mobile-app-card-content = Use o navegador móbil con protección integrada contra o rastrexamento de anuncios.
mobile-app-links = { -brand-product-name } Navegador para <a data-l10n-name="android-mobile-inline-link">Android</a> e <a data-l10n-name="ios-mobile-inline-link">iOS</a>
lockwise-title = Non esqueza nunca máis un contrasinal
lockwise-title-logged-in2 = Xestor de contrasinais
lockwise-header-content = { -lockwise-brand-name } almacena os seus contrasinais de forma segura no seu navegador.
lockwise-header-content-logged-in = Almacene e sincronice os seus contrasinais con seguridade en todos os seus dispositivos.
protection-report-save-passwords-button = Gardar contrasinais
    .title = Gardar contrasinais en { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Xestionar contrasinais
    .title = Xestionar contrasinais en { -lockwise-brand-short-name }
lockwise-mobile-app-title = Leve os seus contrasinais a todas partes
lockwise-no-logins-card-content = Empregue os contrasinais gardados en { -brand-short-name } en calquera dispositivo.
lockwise-app-links = { -lockwise-brand-name } para <a data-l10n-name="lockwise-android-inline-link">Android</a> e <a data-l10n-name = "lockwise-ios-inline-link" >iOS</a>
# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] 1 contrasinal puido estar exposto nun roubo de datos.
       *[other] { $count } contrasinais poderían estaren expostos nun roubo de datos.
    }
# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] 1 contrasinal almacenado de maneira segura.
       *[other] Os seus contrasinais están almacenados de forma segura.
    }
lockwise-how-it-works-link = Como funciona
turn-on-sync = Active { -sync-brand-short-name } ...
    .title = Ir ás preferencias sincronizadas
monitor-title = Coidado cos roubos de datos
monitor-link = Como funciona
monitor-header-content-no-account = Comprobe { -monitor-brand-name } para ver se puido ser vítima dun roubo de datos coñecido e obteña alertas sobre novas violacións.
monitor-header-content-signed-in = { -monitor-brand-name } advírte se a súa información apareceu nun roubo de datos coñecido.
monitor-sign-up-link = Inscríbase en alertas de vulneración de datos
    .title = Inscríbase en alertas de vulneración de datos en { -monitor-brand-name }
auto-scan = Analizado automaticamente hoxe
monitor-emails-tooltip =
    .title = Ver os enderezos de correo electrónico vixiados en { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = Ver vulneracións de datos coñecidos en { -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = Ver os contrasinais expostos en { -monitor-brand-short-name }
# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] Enderezo de correo electrónico que se está a vixiar
       *[other] Enderezos de correo electrónico que se están a vixiar
    }
# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] A vulneración de datos coñecidos expuxo a súa información
       *[other] As vulneracións de datos coñecidos expuxeron a súa información
    }
# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] A vulneración de datos coñecida marcouse como resolta
       *[other] As vulneracións de datos coñecidas marcáronse como resoltas
    }
# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] Contrasinal exposto en todas as vulneracións
       *[other] Contrasinais expostos en todas as vulneracións
    }
# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] Contrasinal exposto en vulneracións non resoltas
       *[other] Contrasinais expostos en vulneracións non resoltas
    }
monitor-no-breaches-title = Boas novas!
monitor-no-breaches-description = Non ten vulneracións coñecidas. Se iso cambia, avisarémoslle.
monitor-view-report-link = Ver o informe
    .title = Resolver vulneracións en { -monitor-brand-short-name }
monitor-breaches-unresolved-title = Resolver as súas vulneracións
monitor-breaches-unresolved-description = Despois de revisar os detalles de vulneracións e tomar medidas para protexer a súa información, pode marcar as vulneracións como resoltas.
monitor-manage-breaches-link = Xestionar as vulneracións
    .title = Xestionar as vulneracións en { -monitor-brand-short-name }
monitor-breaches-resolved-title = Ben! Resolveu todas as vulneracións de datos.
monitor-breaches-resolved-description = Se aparece o seu correo electrónico en calquera vulneración nova, avisarémoslle
# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
        [one] { $numBreachesResolved } de { $numBreaches } vulneracións marcadas como resoltas
       *[other] { $numBreachesResolved } de { $numBreaches } vulneracións marcadas como resoltas
    }
# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = Completouse o { $percentageResolved }%
monitor-partial-breaches-motivation-title-start = Gran comezo!
monitor-partial-breaches-motivation-title-middle = Siga así!
monitor-partial-breaches-motivation-title-end = Case feito! Siga así.
monitor-partial-breaches-motivation-description = Resolva o resto de vulneracións en { -monitor-brand-short-name }.
monitor-resolve-breaches-link = Resolver vulneracións
    .title = Resolver vulneracións en { -monitor-brand-short-name }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Rastrexadores de redes sociais
    .aria-label =
        { $count ->
            [one] { $count } rastrexador de redes sociais ({ $percentage }%)
           *[other] { $count } rastrexadores de redes sociais ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = Cookies de rastrexo entre sitios
    .aria-label =
        { $count ->
            [one] { $count } Cookie de rastrexo entre sitios ({ $percentage }%)
           *[other] { $count } Cookies de rastrexo entre sitios ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Rastrexamento de contido
    .aria-label =
        { $count ->
            [one] { $count } rastrexamento de contido ({ $percentage }%)
           *[other] { $count } rastrexamento de contido ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Pegadas dixitais
    .aria-label =
        { $count ->
            [one] { $count } pegada dixital ({ $percentage }%)
           *[other] { $count } pegadas dixitais ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Criptomineiros
    .aria-label =
        { $count ->
            [one] { $count } criptomineiro ({ $percentage }%)
           *[other] { $count } criptomineiros ({ $percentage }%)
        }
