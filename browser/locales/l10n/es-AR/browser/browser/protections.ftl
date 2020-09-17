# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
        [one] { -brand-short-name } bloqueó { $count } rastreador durante la semana pasada
       *[other] { -brand-short-name } bloqueó { $count } rastreadores durante la semana pasada
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
graph-private-window = { -brand-short-name } sigue bloqueando rastreadores en ventanas , pero no guarda el registro de lo que se bloqueó.
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = Rastreadores { -brand-short-name } bloqueados esta semana

protection-report-webpage-title = Panel de protecciones
protection-report-page-content-title = Panel de protecciones
# This message shows when all privacy protections are turned off, which is why we use the word "can", Firefox is able to protect your privacy, but it is currently not.
protection-report-page-summary = { -brand-short-name } puede proteger su privacidad detrás de escena mientras navega. Este es un resumen personalizado de esas protecciones, incluidas las herramientas para tomar el control de su seguridad en línea.
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Firefox is actively protecting you.
protection-report-page-summary-default = { -brand-short-name }  protege su privacidad detrás de escena mientras navega. Este es un resumen personalizado de esas protecciones, incluidas las herramientas para tomar el control de su seguridad en línea.

protection-report-settings-link = Administrar su configuración de privacidad y seguridad

etp-card-title-always = Protección de seguimiento mejorada: siempre activa
etp-card-title-custom-not-blocking = Protección contra rastreo aumentada: desactivada
etp-card-content-description = { -brand-short-name } evita automáticamenteque las compañías lo sigan en secreto por la web.
protection-report-etp-card-content-custom-not-blocking = Todas las protecciones están desactivadas ahora. Elija qué rastreadores bloquear cambiando la configuración de protección de { -brand-short-name }.
protection-report-manage-protections = Administrar configuraciones

# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = Hoy

# This string is used to describe the graph for screenreader users.
graph-legend-description = Gráfico que contiene el número total de cada tipo de rastreador bloqueado esta semana.

social-tab-title = Rastreadores de redes sociales
social-tab-contant = Las redes sociales ubican rastreadores en otros sitios para saber qué hace, lee y mira en la red. Esto permite que las empresas lo conozcan más allá de lo que comparte en sus perfiles sociales. <a data-l10n-name="learn-more-link">Conocer más</a>

cookie-tab-title = Cookies de rastreo de sitios cruzados
cookie-tab-content = Estas cookies lo siguen de un sitio a otro para recopilar datos sobre lo que hace en línea. Las establecen terceros, como anunciantes y empresas de análisis. El bloqueo de las cookies de rastreo entre sitios reduce la cantidad de publicidad que lo sigue. <a data-l10n-name="learn-more-link"> Conocer más </a>

tracker-tab-title = Contenido de rastreo
tracker-tab-description = Los sitios web pueden cargar anuncios externos, videos y otro contenido con código de rastreo. El bloqueo del contenido de rastreo puede ayudar a que los sitios se carguen más rápido, pero es posible que algunos botones, formularios y campos de inicio de sesión no funcionen. <a data-l10n-name="learn-more-link">Conocer más</a>

fingerprinter-tab-title = Detectores de huellas digitales
fingerprinter-tab-content = Los detectores de huellas digitales recolectan los ajustes de su navegador y su computadora para crear un perfil suyo. Usando esta huella digital pueden seguirlo a través de diferentes sitios web. <a data-l10n-name="learn-more-link">Conocer más</a>

cryptominer-tab-title = Criptomineros
cryptominer-tab-content = Los criptomineros utilizan la potencia informática de su sistema para extraer dinero digital. Las secuencias de comandos de cifrado de los mismos agotan su batería, ralentizan su computadora y pueden aumentar su factura de electricidad. <a data-l10n-name="learn-more-link">. Conocer más </a>

protections-close-button2 =
    .aria-label = Cerrar
    .title = Cerrar
  
mobile-app-title = Bloquear los rastreadores de anuncios en más dispositivos
mobile-app-card-content = Usar el navegador móvil con protección integrada contra el rastro de publicidad.
mobile-app-links = Navegador { -brand-product-name } para <a data-l10n-name="android-mobile-inline-link">Android </a> y <a data-l10n-name="ios-mobile-inline-link">iOS</a>

lockwise-title = Nunca más olvide una contraseña
lockwise-title-logged-in2 = Gestión de contraseñas
lockwise-header-content = { -lockwise-brand-name } almacena sus contraseñas en su navegador de manera segura.
lockwise-header-content-logged-in = Almacene y sincronice sus contraseñas en todos sus dispositivos de manera segura.
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
        [one] 1 contraseña podría haber sido expuestaen una violación de datos.
       *[other] Las contraseñas de { $count } pueden haber estado expuestas en una violación de datos.
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

turn-on-sync = Habilitar { -sync-brand-short-name }...
    .title = Vaya a preferencias de sync

monitor-title = Esté atento a las violaciones de datos
monitor-link = Cómo funciona
monitor-header-content-no-account = Controle { -monitor-brand-name } para ver si fue parte de una violación de datos conocida y para recibir alertas sobre nuevas violaciones.
monitor-header-content-signed-in = { -monitor-brand-name } le advierte si su información apareció en una violación de datos conocida.
monitor-sign-up-link = Regístrese para recibir alertas de violaciones
    .title = Regístrese  en { -monitor-brand-name } para recibir alertas de violaciones
auto-scan = Escaneado automáticamente hoy

monitor-emails-tooltip =
    .title = Ver las direcciones de correo electrónico monitoreadas en { -monitor-brand-short-name }
monitor-breaches-tooltip =
    .title = Ver violaciones de datos conocidas en { -monitor-brand-short-name }
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
        [one] Una violación de datos conocida expuso su información
       *[other] Violaciones de datos conocidas que expusieron su información
    }

# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
        [one] Violación de datos conocida marcada como resuelta
       *[other] Violaciones de datos conocidas marcadas como resueltas
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
        [one] Contraseña expuesta a través de todas las filtraciones
       *[other] Contraseñas expuestas a través de todas las filtraciones
    }

# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
        [one] Contraseña expuesta en violaciones no resueltas
       *[other] Contraseñas expuestas en violaciones no resueltas
    }

monitor-no-breaches-title = ¡Buenas noticias!
monitor-no-breaches-description = No tiene violaciones conocidas. Si eso cambia, se lo vamos a comunicar.
monitor-view-report-link = Ver el informe
    .title = Resolver las violaciones en { -monitor-brand-short-name }
monitor-breaches-unresolved-title = Resuelva las violaciones
monitor-breaches-unresolved-description =
    Después de revisar los detalles de la violaciones y tomar medidas para proteger
    su información personal, puede marcarlas como resueltas.
monitor-manage-breaches-link = Administrar violaciones
    .title = Administrar violaciones en { -monitor-brand-short-name }
monitor-breaches-resolved-title = ¡Bien! Resolvió todas las violaciones conocidas.
monitor-breaches-resolved-description = Si su correo electrónico aparece en cualquier nueva violación, se lo vamos a comunicar.

# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
        [one] { $numBreachesResolved } de { $numBreaches } violación marcada como resuelta
       *[other] { $numBreachesResolved } de { $numBreaches } violaciones marcadas como resueltas
    }

# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = { $percentageResolved } % completo

monitor-partial-breaches-motivation-title-start = ¡Gran comienzo!
monitor-partial-breaches-motivation-title-middle = ¡Siga así!
monitor-partial-breaches-motivation-title-end = ¡Casi terminado! Siga así.
monitor-partial-breaches-motivation-description = Resuelva las demás violaciones en { -monitor-brand-short-name }.
monitor-resolve-breaches-link = Resolver violaciones
    .title = Resolver violaciones en { -monitor-brand-short-name }

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
            [one] { $count } rastreador de redes sociales  ({ $percentage }%)
           *[other] { $count } rastreador de redes sociales ({ $percentage }%)
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
