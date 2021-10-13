# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } bloqueó { $count } rastreador en la última semana
       *[other] { -brand-short-name } bloqueó { $count } rastreadores en la última semana
    }

# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
        [one] <b>{ $count }</b> rastreador bloqueado desde { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
       *[other] <b>{ $count }</b> rastreadores bloqueados desde { DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }
    }

# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } sigue bloqueado rastreadores en ventanas privadas, pero no mantiene un registro de lo que se bloqueó.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Rastreadores que { -brand-short-name } bloqueó esta semana

protection-report-webpage-title = Panel de protecciones
protection-report-page-content-title = Panel de protecciones
# This message shows when all privacy protections are turned off, which is why we use the word "can", Waterfox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } puede proteger tu privacidad entre bastidores mientras navegas. Este es un resumen personalizado de esas protecciones, incluidas las herramientas para tomar el control de tu seguridad en línea.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Waterfox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } protege tu privacidad tras bambalinas mientras navegas. Este es un resumen personalizado de estas protecciones, incluyendo herramientas para tomar el control de tu vida en línea.

protection-report-settings-link = Administrar tu configuración de privacidad y seguridad

etp-card-title-always = Protección contra rastreo mejorada: siempre activa
etp-card-title-custom-not-blocking = Protección contra rastreo mejorada: desactivada
etp-card-content-description = { -brand-short-name } bloquea automáticamente a las compañías que te siguen en secreto por la web.
protection-report-etp-card-content-custom-not-blocking = Todas las protecciones están desactivadas en este momento. Selecciona qué rastreadores bloquear administrando las configuraciones de protección de { -brand-short-name }.
protection-report-manage-protections = Administrar configuración

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Hoy

# This string is used to describe the graph for screenreader users.
graph-legend-description = Una gráfica que contiene el número total de rastreadores, desglosados por tipo, que se bloquearon esta semana.

social-tab-title = Rastreadores de red social
social-tab-contant = Las redes sociales colocan rastreadores en otros sitios para saber qué haces, lees y miras en la red. Ello permite a esas empresas conocerte más allá de lo que pones en tus perfiles sociales. <a data-l10n-name="learn-more-link">Más información</a>

cookie-tab-title = Cookies de rastreo multisitio
cookie-tab-content = Estas cookies te siguen de sitio en sitio para recabar información sobre lo que haces en línea. Las colocan empresas de terceros como agencias publicitarias y analizadoras de datos. El bloqueo multisitio reduce la cantidad de anuncios que te siguen allí a donde vas. <a data-l10n-name="learn-more-link">Más información</a>

tracker-tab-title = Contenido de rastreo
tracker-tab-description = Los sitios web pueden cargar anuncios externos, videos y otro contenido con código de rastreo. El bloqueo del contenido de rastreo puede ayudar a que los sitios se carguen más rápido, pero es posible que algunos botones, formularios y campos de inicio de sesión no funcionen. <a data-l10n-name="learn-more-link">Conocer más</a>

fingerprinter-tab-title = Huellas dactilares
fingerprinter-tab-content = Las huellas dactilares recopilan la configuración de tu navegador y tu equipo para crear un perfil de ti. Con esta huella numérica pueden rastrearte por varios sitios web. <a data-l10n-name="learn-more-link">Más información</a>

cryptominer-tab-title = Criptomineros
cryptominer-tab-content = Los criptomineros utilizan los recursos de tu sistema para minar dinero digital. Los scripts de criptominería te agotan la batería, ralentizan la computadora y pueden provocar que el recibo de la luz llegue más caro. <a data-l10n-name="learn-more-link">Más información</a>

protections-close-button2 =
    .aria-label = Cerrar
    .title = Cerrar
  
mobile-app-title = Bloquear los rastreadores de anuncios en más dispositivos
mobile-app-card-content = Usa el navegador móvil con protección integrada contra el rastreo de anuncios.
mobile-app-links = El navegador { -brand-product-name } para <a data-l10n-name="android-mobile-inline-link">Android</a> y <a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = Que ya no se te olvide ninguna otra contraseña
lockwise-title-logged-in2 = Administración de contraseñas
lockwise-header-content = { -lockwise-brand-name } guarda de manera segura tus contraseñas en el navegador.
lockwise-header-content-logged-in = Almacena y sincroniza tus contraseñas en todos tus dispositivos.
protection-report-save-passwords-button = Guardar contraseñas
    .title = Guardar contraseñas en { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Administar contraseñas
    .title = Administrar contraseñas en{ -lockwise-brand-short-name }
lockwise-mobile-app-title = Lleva tus contraseñas a todos lados
lockwise-no-logins-card-content = Usa contraseñas guardadas en { -brand-short-name } en cualquier dispositivo.
lockwise-app-links = { -lockwise-brand-name } para <a data-l10n-name="lockwise-android-inline-link">Android</a> y <a data-l10n-name="lockwise-ios-inline-link">iOS</a>

# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
        [one] 1 contraseña podría haber sido expuesta en una filtración de datos.
       *[other] { $count } contraseñas podrían haber sido expuestas en una filtración de datos.
    }

# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
        [one] 1 contraseña almacenada de forma segura.
       *[other] Tus contraseñas se están almacenando de forma segura.
    }
lockwise-how-it-works-link = Cómo funciona

monitor-title = Mantente atento a las fugas de datos
monitor-link = Cómo funciona
monitor-header-content-no-account = Revisa { -monitor-brand-name } para ver si has sido parte de una violación de datos conocida y recibir alertas sobre nuevas violaciones.
monitor-header-content-signed-in = { -monitor-brand-name } te avisa si tu información apareció en una violación de datos conocida.
monitor-sign-up-link = Suscribirse a las alertas de filtraciones
    .title = Suscribirse a las alertas de filtraciones en { -monitor-brand-name }
auto-scan = Analizado automáticamente hoy

monitor-emails-tooltip =
    .title = Ver las direcciones de correo electrónico supervisadas en { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = Ver filtraciones de datos conocidas en { -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = Ver contraseñas expuestas en { -monitor-brand-short-name }

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] Dirección de correo electrónico monitoreada
       *[other] Direcciones de correo electrónico monitoreadas
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] violación de datos conocida expuso tu información
       *[other] violaciones de datos conocidas que expusieron tu información
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] Filtración de datos conocida marcada como resuelta
       *[other] Filtraciones de datos conocidas marcadas como resueltas
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] contraseña expuesta a través de todas las filtraciones
       *[other] contraseñas expuestas a través de todas las filtraciones
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] Contraseña expuesta en filtraciones no resueltas
       *[other] Contraseñas expuestas en filtraciones no resueltas
    }

monitor-no-breaches-title = ¡Buenas noticias!
monitor-no-breaches-description = No tienes filtraciones conocidas. Si esto cambia, te lo haremos saber.
monitor-view-report-link = Ver reporte
    .title = Resuelve las filtraciones en { -monitor-brand-short-name }
monitor-breaches-unresolved-title = Resuelve tus filtraciones
monitor-breaches-unresolved-description = Después de revisar los detalles de una filtración y tomar los pasos para proteger tu información, puedes marcar las filtraciones como resueltas.
monitor-manage-breaches-link = Gestionar filtraciones
    .title = Gestiona filtraciones en { -monitor-brand-short-name }
monitor-breaches-resolved-title = ¡Genial! Has resuelto todas las filtraciones conocidas.
monitor-breaches-resolved-description = Si tu correo aparece en cualquier filtración nueva, te lo haremos saber.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
        [one] { $numBreachesResolved } de { $numBreaches } filtración marcada como resuelta
       *[other] { $numBreachesResolved } de { $numBreaches } filtraciones marcadas como resueltas
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved }% completo

monitor-partial-breaches-motivation-title-start = ¡Gran inicio!
monitor-partial-breaches-motivation-title-middle = ¡Sigue así!
monitor-partial-breaches-motivation-title-end = ¡Casi terminamos! Sigue así.
monitor-partial-breaches-motivation-description = Resuelve el resto de tus filtraciones en { -monitor-brand-short-name }.
monitor-resolve-breaches-link = Resolver filtraciones
    .title = Resuelve filtraciones en { -monitor-brand-short-name }

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = Rastreadores de red social
    .aria-label =
        { $count ->
            [one] { $count } rastreador de red social ({ $percentage } %)
           *[other] { $count } rastreadores de red social ({ $percentage } %)
        }
bar-tooltip-cookie =
    .title = Cookies de rastreo multisitio
    .aria-label =
        { $count ->
            [one] { $count } cookie de rastreo multisitio ({ $percentage } %)
           *[other] { $count } cookies de rastreo multisitio ({ $percentage } %)
        }
bar-tooltip-tracker =
    .title = Contenido de rastreo
    .aria-label =
        { $count ->
            [one] { $count } contenido de rastreo ({ $percentage } %)
           *[other] { $count } contenidos de rastreo ({ $percentage } %)
        }
bar-tooltip-fingerprinter =
    .title = Huellas dactilares
    .aria-label =
        { $count ->
            [one] { $count } identificador ({ $percentage } %)
           *[other] { $count } identificadores ({ $percentage } %)
        }
bar-tooltip-cryptominer =
    .title = Criptomineros
    .aria-label =
        { $count ->
            [one] { $count } criptominero ({ $percentage } %)
           *[other] { $count } criptomineros ({ $percentage } %)
        }
