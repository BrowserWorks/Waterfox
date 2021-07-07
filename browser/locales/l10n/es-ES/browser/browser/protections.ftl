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
graph-week-summary-private-window = Rastreadores bloqueados por { -brand-short-name } esta semana

protection-report-webpage-title = Panel de protecciones
protection-report-page-content-title = Panel de protecciones
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } puede proteger su privacidad entre bastidores mientras navega. Este es un resumen personalizado de esas protecciones, incluidas las herramientas para tomar el control de su seguridad en línea.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name } protege su privacidad entre bastidores mientras navega. Este es un resumen personalizado de esas protecciones, incluidas las herramientas para tomar el control de su seguridad en línea.

protection-report-settings-link = Administrar su configuración de privacidad y seguridad

etp-card-title-always = Protección contra rastreo mejorada: siempre activa
etp-card-title-custom-not-blocking = Protección contra rastreo mejorada: desactivada
etp-card-content-description = { -brand-short-name } bloquea automáticamente a las compañías que le siguen en secreto por la web.
protection-report-etp-card-content-custom-not-blocking = Todas las protecciones están desactivadas. Elija qué rastreadores bloquear cambiando la configuración de protección de { -brand-short-name }.
protection-report-manage-protections = Administrar ajustes

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Hoy

# This string is used to describe the graph for screenreader users.
graph-legend-description = La gráfica muestra el número total de cada tipo de rastreador que se bloqueó esta semana.

social-tab-title = Rastreadores de redes sociales
social-tab-contant = Las redes sociales colocan rastreadores en otros sitios web para saber qué hace, ve y mira en línea. Ese rastreo les permite saber mucho más de lo que comparte en sus perfiles de las redes sociales. <a data-l10n-name="learn-more-link">Saber más</a>

cookie-tab-title = Cookies de rastreo entre sitios
cookie-tab-content = Estas cookies le siguen de página en página para recopilar información sobre su vida en línea. Suelen ser las agencias de publicidad y de analítica las que las configuran. Las cookies de rastreo entre sitios reduce el número de anuncios que le siguen. <a data-l10n-name="learn-more-link">Saber más</a>

tracker-tab-title = Contenido de rastreo
tracker-tab-description = Los sitios web pueden cargar anuncios externos, vídeos y otro contenido con código de rastreo. El bloqueo del contenido de rastreo puede ayudar a que los sitios se carguen más rápido, pero es posible que algunos botones, formularios y campos de inicio de sesión no funcionen. <a data-l10n-name="learn-more-link">Saber más</a>

fingerprinter-tab-title = Detectores de huellas digitales
fingerprinter-tab-content = Los detectores de huellas digitales (fingerprinters) recopilan la configuración de su navegador y su ordenador para crear un perfil de usted. Usando esta huella digital pueden seguirle a través de diferentes sitios web. <a data-l10n-name="learn-more-link">Saber más</a>

cryptominer-tab-title = Criptomineros
cryptominer-tab-content = Los criptomineros utilizan la potencia informática de su sistema para obtener dinero digital. Los scripts de criptominería agotan la batería de su ordenador, lo ralentizan y pueden aumentar su factura de electricidad. <a data-l10n-name="learn-more-link">Saber más</a>

protections-close-button2 =
    .aria-label = Cerrar
    .title = Cerrar
  
mobile-app-title = Bloquee los rastreadores de anuncios en más dispositivos
mobile-app-card-content = Use el navegador móvil con protección integrada contra el rastreo de anuncios.
mobile-app-links = El navegador { -brand-product-name } para <a data-l10n-name="android-mobile-inline-link">Android</a> y <a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = No volverá a olvidar su contraseña
lockwise-title-logged-in2 = Administración de contraseñas
lockwise-header-content = { -lockwise-brand-name } almacena de forma segura sus contraseñas en el navegador.
lockwise-header-content-logged-in = Guarde y sincronice sus contraseñas en todos sus dispositivos de manera segura.
protection-report-save-passwords-button = Guardar contraseñas
    .title = Guardar contraseñas en { -lockwise-brand-short-name }
protection-report-manage-passwords-button = Administrar contraseñas
    .title = Administrar contraseñas en { -lockwise-brand-short-name }
lockwise-mobile-app-title = Lleve sus contraseñas a todas partes
lockwise-no-logins-card-content = Use contraseñas guardadas en { -brand-short-name } en cualquier dispositivo.
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
       *[other] Sus contraseñas se almacenan de forma segura.
    }
lockwise-how-it-works-link = Cómo funciona

turn-on-sync = Activar { -sync-brand-short-name }...
    .title = Ir a las preferencias de sincronización

monitor-title = Buscar filtraciones de datos
monitor-link = Cómo funciona
monitor-header-content-no-account = Consulte { -monitor-brand-name } para ver si sus datos aparecen en una filtración de datos y reciba alertas sobre nuevas filtraciones.
monitor-header-content-signed-in = { -monitor-brand-name } le advierte si su información ha aparecido en una filtración de datos conocida.
monitor-sign-up-link = Suscribirse a las alertas de filtraciones
    .title = Suscribirse a las alertas de filtraciones en { -monitor-brand-name }
auto-scan = Se escaneó automáticamente hoy

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
        [one] Dirección de correo electrónico monitorizada
       *[other] Direcciones de correo electrónico monitorizadas
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
        [one] La filtración de datos que ha expuesto su información
       *[other] La filtraciones de datos que han expuesto su información
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
        [one] Contraseña expuesta en todas las filtraciones
       *[other] Contraseñas expuestas en todas las filtraciones
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
monitor-no-breaches-description = No tiene filtraciones conocidas. Si eso cambia, se lo haremos saber.
monitor-view-report-link = Ver el informe
    .title = Resolver las filtraciones en { -monitor-brand-short-name }
monitor-breaches-unresolved-title = Resolver sus filtraciones
monitor-breaches-unresolved-description =
    Después de revisar los detalles sobre una filtración y tomar medidas para proteger 
    su información, puede marcar las filtraciones como resueltas.
monitor-manage-breaches-link = Gestionar filtraciones
    .title = Gestiona filtraciones en { -monitor-brand-short-name }
monitor-breaches-resolved-title = ¡Bien! Ha resuelto todas las filtraciones conocidas.
monitor-breaches-resolved-description = Si su correo electrónico aparece en cualquier nueva filtración, le avisaremos.

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

monitor-partial-breaches-motivation-title-start = ¡Gran comienzo!
monitor-partial-breaches-motivation-title-middle = ¡Siga así!
monitor-partial-breaches-motivation-title-end = ¡Casi terminado! Siga así.
monitor-partial-breaches-motivation-description = Resuelva las demás filtraciones en { -monitor-brand-short-name }.
monitor-resolve-breaches-link = Resolver filtraciones
    .title = Resolver filtraciones en { -monitor-brand-short-name }

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
    .title = Cookies de rastreo entre sitios
    .aria-label =
        { $count ->
            [one] { $count } cookie de rastreo entre sitios ({ $percentage }%)
           *[other] { $count } cookies de rastreo entre sitios ({ $percentage }%)
        }
bar-tooltip-tracker =
    .title = Contenido de rastreo
    .aria-label =
        { $count ->
            [one] { $count } contenido de rastreo ({ $percentage }%)
           *[other] { $count } contenido de rastreo ({ $percentage }%)
        }
bar-tooltip-fingerprinter =
    .title = Detectores de huellas digitales
    .aria-label =
        { $count ->
            [one] { $count } detector de huellas digitales ({ $percentage }%)
           *[other] { $count } detectores de huellas digitales ({ $percentage }%)
        }
bar-tooltip-cryptominer =
    .title = Criptomineros
    .aria-label =
        { $count ->
            [one] { $count } criptominero ({ $percentage }%)
           *[other] { $count } criptomineros ({ $percentage }%)
        }
