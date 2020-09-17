# This Source Code Form is subject to the terms of the Mozilla Public
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
graph-private-window = { -brand-short-name } sigue bloqueando rastreadores en ventanas privadas, pero no mantiene un registro de lo que se bloqueó.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Rastreadores que { -brand-short-name } bloqueó esta semana

protection-report-webpage-title = Panel de protecciones
protection-report-page-content-title = Panel de protecciones
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } puede proteger tu privacidad tras bambalinas mientras navegas. Este es un resumen personalizado de aquellas protecciones, incluyendo las herramientas para tomar el control de tu vida en línea.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } protege tu privacidad tras bambalinas mientras navegas. Este es un resumen personalizado de aquellas protecciones, incluyendo las herramientas para tomar el control de tu vida en línea.

protection-report-settings-link = Gestiona tu configuración de privacidad y seguridad

etp-card-title-always = Protección de seguimiento mejorada: Siempre activa
etp-card-title-custom-not-blocking = Protección de seguimiento mejorada: DESACTIVADA
etp-card-content-description = { -brand-short-name } automáticamente detiene a las compañías que te sigen en secreto por la web.
protection-report-etp-card-content-custom-not-blocking = Actualmente están todas las protecciones desactivadas. Elije que rastreadores bloquear en tus ajustes de protección de { -brand-short-name }.
protection-report-manage-protections = Administrar ajustes

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Hoy

# This string is used to describe the graph for screenreader users.
graph-legend-description = Gráfico que contiene el número total de cada tipo de rastreador bloqueado esta semana.

social-tab-title = Rastreadores de redes sociales
social-tab-contant = Las redes sociales colocan rastreadores en otros sitios web para seguir lo que haces y miras en línea. Esto le permite a las compañías de redes sociales aprender más sobre tu comportamiento yendo más allá de lo que compartes en tus perfiles de redes sociales. <a data-l10n-name="learn-more-link">Aprender más</a>

cookie-tab-title = Cookies de rastreo de sitios cruzados
cookie-tab-content = Estas cookies te siguen de sitio en sitio para recopilar datos sobre lo que haces en línea. Son colocadas por terceros, tales como empresas de publicidad y de analítica. loquear las cookies de rastreo de sitios cruzados reduce el número de anuncios que te siguen. <a data-l10n-name="learn-more-link">Aprender más</a>

tracker-tab-title = Contenido de rastreo
tracker-tab-description = Los sitios web pueden cargar anuncios publicitarios, videos y otros elementos con códigos para seguimiento. Bloquearlos contenidos de seguimiento puede ayudar a que los sitios carguen más rápido, pero algunos botones, formularios y campos para conectarse podrían dejar de funcionar. <a data-l10n-name="learn-more-link">Aprender más</a>

fingerprinter-tab-title = Creadores de huellas (Fingerprinters)
fingerprinter-tab-content = Los creadores de huellas (Fingerprinters) recolectan ajustes de tu navegador y computador para crear un perfil tuyo. Usando esta huella digital ellos pueden seguirte a través de diferentes sitios web. <a data-l10n-name="learn-more-link">Aprender más</a>

cryptominer-tab-title = Criptomineros
cryptominer-tab-content = Los criptomineros utilizan la potencia de cómputo de tu sistema para la minería de dinero digital. Los scripts utilizados para ello consumen tu batería, relentecen tu computador e incrementan el valor de tu boleta de electricidad. <a data-l10n-name="learn-more-link">Aprender más</a>

protections-close-button2 =
    .aria-label = Cerrar
    .title = Cerrar
  
mobile-app-title = Bloquear los rastreadores de anuncios en más dispositivos
mobile-app-card-content = Usa el navegador móvil con protección integrada contra el rastreo de la publicidad.
mobile-app-links = { -brand-product-name } Browser para <a data-l10n-name="android-mobile-inline-link">Android</a> e <a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = No vuelvas a olvidar una contraseña
lockwise-title-logged-in2 = Administración de contraseñas
lockwise-header-content = { -lockwise-brand-name } almacena de forma segura tus contraseñas en tu navegador.
lockwise-header-content-logged-in = Almacena de forma segura tus contraseñas y sincronízalas en todos tus dispositivos.
protection-report-save-passwords-button = Guardar contraseñas
    .title = Guardar contraseñas en { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Gestionar contraseñas
    .title = Gestionar contraseñas en { -lockwise-brand-short-name }
lockwise-mobile-app-title = Lleva tus contraseñas a todas partes
lockwise-no-logins-card-content = Usa las contraseñas guardadas en { -brand-short-name } en cualquier dispositivo.
lockwise-app-links = { -lockwise-brand-name } para <a data-l10n-name="lockwise-android-inline-link">Android</a> e <a data-l10n-name="lockwise-ios-inline-link">iOS</a>

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
       *[other] Tus contraseñas están siendo almacenadas de forma segura.
    }
lockwise-how-it-works-link = Cómo funciona

turn-on-sync = Activar { -sync-brand-short-name }…
    .title = Ir a las preferencias de sincronización

monitor-title = Presta atención a las filtraciones de datos
monitor-link = Cómo funciona
monitor-header-content-no-account = Revisa { -monitor-brand-name } para ver si has sido parte de una filtración de datos conocida, y recibe alertas sobre nuevas filtraciones.
monitor-header-content-signed-in = { -monitor-brand-name } te advierte si tu información ha aparecido en una filtración de datos conocida.
monitor-sign-up-link = Regístrate para recibir alertas de filtraciones
    .title = Regístrate para recibir alertas de filtraciones en { -monitor-brand-name }
auto-scan = Escaneado automáticamente el día de hoy

monitor-emails-tooltip =
    .title = Ver las direcciones de correo supervisadas en { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = Ver filtraciones de datos conocidas en { -monitor-brand-short-name }
monitor-passwords-tooltip =
    .title = Ver contraseñas expuestas en { -monitor-brand-short-name }

# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
        [one] dirección de correo monitoreada
       *[other] direcciones de correo monitoreadas
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] filtración conocida ha expuesto tu información
       *[other] filtraciones conocidas han expuesto tu información
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
        [one] contraseña expuesta en todas las filtraciones
       *[other] contraseñas expuestas en todas las filtraciones
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
monitor-no-breaches-description = No tienes filtraciones conocidas. Si eso cambia, te lo haremos saber.
monitor-view-report-link = Ver reporte
    .title = Resuelve las filtraciones en { -monitor-brand-short-name }
monitor-breaches-unresolved-title = Resuelve tus filtraciones
monitor-breaches-unresolved-description = Después de revisar los detalles de una filtración y tomar los pasos para proteger tu información, puedes marcar las filtraciones como resueltas.
monitor-manage-breaches-link = Gestionar filtraciones
    .title = Gestiona filtraciones en { -monitor-brand-short-name }
monitor-breaches-resolved-title = ¡Genial! Has resuelto todas las filtraciones conocidas.
monitor-breaches-resolved-description = Si su correo aparece en cualquier filtración nueva, te lo haremos saber.

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

monitor-partial-breaches-motivation-title-start = ¡Empezaste bien!
monitor-partial-breaches-motivation-title-middle = ¡Sigue así!
monitor-partial-breaches-motivation-title-end = ¡Casi listo! Continúa.
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
    .title = Rastreadores de redes sociales
    .aria-label =
        { $count ->
            [one] { $count } rastreador de redes sociales ({ $percentage }%)
           *[other] { $count } rastreadores de redes sociales ({ $percentage }%)
        }
bar-tooltip-cookie =
    .title = Cookies de rastreo de sitios cruzados
    .aria-label =
        { $count ->
            [one] { $count } cookie de rastreo de sitios cruzados ({ $percentage }%)
           *[other] { $count } cookies de rastreo de sitios cruzados ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Contenido de rastreo
    .aria-label =
        { $count ->
            [one] { $count } contenido de rastreo ({ $percentage }%)
           *[other] { $count } contenidos de rastreo ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Creadores de huellas (Fingerprinters)
    .aria-label =
        { $count ->
            [one] { $count } creador de huellas (fingerprinter) ({ $percentage }%)
           *[other] { $count } creadores de huellas (fingerprinters) ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Criptomineros
    .aria-label =
        { $count ->
            [one] { $count } criptominero ({ $percentage }%)
           *[other] { $count } criptomineros ({ $percentage }%)
        }
