# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Extensión recomendada
cfr-doorhanger-feature-heading = Característica recomendada
cfr-doorhanger-pintab-heading = Intenta esto: Fijar pestaña

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = ¿Por qué estoy viendo esto?
cfr-doorhanger-extension-cancel-button = Ahora no
    .accesskey = N
cfr-doorhanger-extension-ok-button = Agregar ahora
    .accesskey = A
cfr-doorhanger-pintab-ok-button = Fijar esta pestaña
    .accesskey = F
cfr-doorhanger-extension-manage-settings-button = Administrar configuraciones de recomendación
    .accesskey = m
cfr-doorhanger-extension-never-show-recommendation = No mostrar esta recomendación
    .accesskey = N
cfr-doorhanger-extension-learn-more-link = Saber más
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = por { $name }
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Recomendación
cfr-doorhanger-extension-notification2 = Recomendación
    .tooltiptext = Recomendación de extensión
    .a11y-announcement = Recomendación de extensión disponible
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Recomendación
    .tooltiptext = Recomendación de la característica
    .a11y-announcement = Recomendación de las características disponibles

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } estrella
           *[other] { $total } estrellas
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } usuario
       *[other] { $total } usuarios
    }
cfr-doorhanger-pintab-description = Accede fácilmente a tus sitios más visitados. Mantén los sitios abiertos en una pestaña (incluso cuando reinicies).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Haz clic con el botón derecho</b> en la pestaña que quieres fijar.
cfr-doorhanger-pintab-step2 = Selecciona <b>Fijar pestaña</b> en el menú.
cfr-doorhanger-pintab-step3 = Si el sitio tiene una actualización, verás un punto azul en tu pestaña fijada.
cfr-doorhanger-pintab-animation-pause = Pausar
cfr-doorhanger-pintab-animation-resume = Continuar

## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Sincroniza tus marcadores en todas partes.
cfr-doorhanger-bookmark-fxa-body = ¡Gran hallazgo! Ahora no te quedes sin este marcador en tus dispositivos móviles. Coemienza con una { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Sincronizar marcadores ahora...
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Botón Cerrar
    .title = Cerrar

## Protections panel

cfr-protections-panel-header = Navega sin que te sigan
cfr-protections-panel-body = Que tu información se quede en tus manos. { -brand-short-name } te protege de muchos de los rastreadores comunes que te espían al explorar la web.
cfr-protections-panel-link-text = Más información

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Nueva característica:
cfr-whatsnew-button =
    .label = Novedades
    .tooltiptext = Novedades
cfr-whatsnew-panel-header = Novedades
cfr-whatsnew-release-notes-link-text = Lee el informe de novedades
cfr-whatsnew-fx70-title = { -brand-short-name } ahora lucha más por tu privacidad
cfr-whatsnew-fx70-body =
    La última actualización mejora la función de protección contra rastreo y hace
    que sea muy sencillo crear contraseñas seguras para cada sitio.
cfr-whatsnew-tracking-protect-title = Protégete de los rastreadores
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } bloquea muchos rastreadores sociales y de sitios cruzados comunes que
    siguen tu actividad en línea.
cfr-whatsnew-tracking-protect-link-text = Mira tu reporte
# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Rastreador bloqueado
       *[other] Rastreadores bloqueados
    }
cfr-whatsnew-tracking-blocked-subtitle = Desde { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Ver el informe
cfr-whatsnew-lockwise-backup-title = Respalda tus contraseñas
cfr-whatsnew-lockwise-backup-body = Ahora puedes generar contraseñas seguras a las que puedes acceder desde donde las necesites.
cfr-whatsnew-lockwise-backup-link-text = Activar copias de seguridad
cfr-whatsnew-lockwise-take-title = Lleva tus contraseñas contigo
cfr-whatsnew-lockwise-take-body =
    La aplicación móvil { -lockwise-brand-short-name } te permite acceder de forma segura a tus
    copias de seguridad de las contraseñas desde cualquier lugar.
cfr-whatsnew-lockwise-take-link-text = Obtener la aplicación

## Search Bar

cfr-whatsnew-searchbar-title = Escribe menos, encuentra más con la barra de direcciones
cfr-whatsnew-searchbar-body-topsites = Ahora, simplemente seleccione la barra de direcciones y se va a expandir un cuadro con enlaces a sus sitios principales.

## Search bar

cfr-whatsnew-searchbar-icon-alt-text = Ícono de lupa

## Picture-in-Picture

cfr-whatsnew-pip-header = Mira videos mientras navegas
cfr-whatsnew-pip-body = La función picture-in-picture muestra el video en una ventana flotante para que puedas verlo mientras trabajas en otras pestañas.
cfr-whatsnew-pip-cta = Saber más

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Reduce molestas ventanas emergentes
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } ahora bloquea los sitios para que no soliciten automáticamente el envío de mensajes emergentes.
cfr-whatsnew-permission-prompt-cta = Saber más

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Detector de huellas digitales bloqueado
       *[other] Detectores de huellas digitales bloqueados
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } bloquea muchos detectores de huellas digitales (fingerprinters) que recopilan en secreto información sobre tu dispositivo y acciones, para crear un perfil tuyo con fines publicitarios.
# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Fingerprinters
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } puede bloquear muchos detectores de huellas digitales (fingerprinters) que recopilan en secreto información sobre tu dispositivo y acciones, para crear un perfil tuyo con fines publicitarios.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Obtener este marcador en tu teléfono
cfr-doorhanger-sync-bookmarks-body = Lleva contigo tus marcadores, contraseñas, historial y más, a dónde sea que inicies sesión en { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Habilitar { -sync-brand-short-name }
    .accesskey = T

## Login Sync

cfr-doorhanger-sync-logins-header = No vuelvas a perder una contraseña
cfr-doorhanger-sync-logins-body = Almacena de forma segura tus contraseñas y sincronízalas en todos tus dispositivos.
cfr-doorhanger-sync-logins-ok-button = Activar { -sync-brand-short-name }
    .accesskey = A

## Send Tab

cfr-doorhanger-send-tab-header = Leer sobre la marcha
cfr-doorhanger-send-tab-recipe-header = Llevar esta receta a la cocina
cfr-doorhanger-send-tab-body = Send Tab te permite compartir fácilmente este enlace a tu teléfono o dónde sea que inicies sesión en { -brand-product-name }
cfr-doorhanger-send-tab-ok-button = Probar Send Tab
    .accesskey = T

## Firefox Send

cfr-doorhanger-firefox-send-header = Compartir este PDF con seguridad
cfr-doorhanger-firefox-send-body = Mantén tus documentos confidenciales a salvo de miradas indiscretas con cifrado de extremo a extremo y un enlace que desaparece cuando hayas terminado.
cfr-doorhanger-firefox-send-ok-button = Probar { -send-brand-name }
    .accesskey = T

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Ver protecciones
    .accesskey = p
cfr-doorhanger-socialtracking-close-button = Cerrar
    .accesskey = C
cfr-doorhanger-socialtracking-dont-show-again = No me muestres mensajes como este de nuevo
    .accesskey = D
cfr-doorhanger-socialtracking-heading = { -brand-short-name } impidió que una red social te rastreara hasta aquí
cfr-doorhanger-socialtracking-description = Tu privacidad importa. Ahora, { -brand-short-name } bloquea los rastreadores de redes sociales más comunes, limitando la cantidad de datos que pueden recopilar sobre lo que haces en línea.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } bloqueó un detector de huellas digitales en esta página
cfr-doorhanger-fingerprinters-description = Tu privacidad importa. { -brand-short-name } ahora bloquea los detectores de huellas digitales, que recopilan piezas de información que identifican de forma única a tu dispositivo para poder rastrearte.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } bloqueó un criptominero en esta página
cfr-doorhanger-cryptominers-description = Tu privacidad es importante. { -brand-short-name } ahora bloquea los criptomineros, que utilizan la potencia informática de tu sistema para extraer dinero digital.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
       *[other] ¡{ -brand-short-name } bloqueó más de <b>{ $blockedCount }</b> rastreadores desde { $date }!
    }
# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
        [one] { -brand-short-name } ha bloqueado más de <b>{ $blockedCount }</b> rastreador desde { DATETIME($date, month: "long", year: "numeric") }
       *[other] { -brand-short-name } ha bloqueado más de <b>{ $blockedCount }</b> rastreadores desde { DATETIME($date, month: "long", year: "numeric") }
    }
cfr-doorhanger-milestone-ok-button = Ver todo
    .accesskey = V

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Crea fácilmente contraseñas seguras
cfr-whatsnew-lockwise-body = Es difícil pensar contraseñas únicas y seguras para cada cuenta. Al crear una contraseña, selecciona el campo de contraseña para usar una contraseña segura generada por { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = Ícono de { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Recibe alertas sobre contraseñas vulnerables
cfr-whatsnew-passwords-body = Los hackers saben que la gente reutiliza sus contraseñas. Si usaste la misma contraseña en múltiples sitios y uno de esos sitios sufre una filtración de datos, verás una alerta en { -lockwise-brand-short-name } para cambiar tu contraseña en esos sitios.
cfr-whatsnew-passwords-icon-alt = Ícono de contraseña vulnerable

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Llevar el picture-in-picture a pantalla completa
cfr-whatsnew-pip-fullscreen-body = Cuando llevas un video a una ventana flotante, puedes a continuación hacer doble clic en esa ventana para llevarlo a pantalla completa.
cfr-whatsnew-pip-fullscreen-icon-alt = Ícono de picture-in-picture

## Protections Dashboard message

cfr-doorhanger-milestone-close-button = Cerrar
    .accesskey = C

## What’s New Panel Content for Firefox 76
## Protections Dashboard message

cfr-whatsnew-protections-header = Protecciones a la vista
cfr-whatsnew-protections-body = El Panel de protecciones incluye informes resumidos sobre filtraciones de datos y administración de contraseñas. Ahora puedes realizar un seguimiento de cuántas filtraciones se resolvieron y ver si alguna de tus contraseñas guardadas pudo estar expuesta en una filtración de datos.
cfr-whatsnew-protections-cta-link = Ver panel de protecciones
cfr-whatsnew-protections-icon-alt = Icono de escudo

## Better PDF message

cfr-whatsnew-better-pdf-header = Mejor experiencia con PDF
cfr-whatsnew-better-pdf-body = Los documentos PDF ahora se abren directamente en { -brand-short-name }, manteniendo su flujo de trabajo al alcance de la mano.

## DOH Message

cfr-doorhanger-doh-body = Tu privacidad importa. { -brand-short-name } ahora enruta de forma segura tus solicitudes DNS siempre que sea posible a un servicio asociado para protegerte mientras navegas.
cfr-doorhanger-doh-header = Búsquedas DNS más seguras y encriptadas
cfr-doorhanger-doh-primary-button-2 = Aceptar
    .accesskey = A
cfr-doorhanger-doh-secondary-button = Deshabilitar
    .accesskey = D

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = Tu privacidad importa. { -brand-short-name } ahora aísla, sitios web unos de otros, lo que hace que sea más difícil que los piratas informáticos roben contraseñas, números de tarjetas de crédito y otra información sensible.
cfr-doorhanger-fission-header = Aislamiento del sitio
cfr-doorhanger-fission-primary-button = OK, entendido
    .accesskey = O
cfr-doorhanger-fission-secondary-button = Saber más
    .accesskey = L

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Protección automática contra tácticas de rastreo furtivas
cfr-whatsnew-clear-cookies-body = Algunos rastreadores te redirigen a otros sitios web que configuran cookies en secreto. { -brand-short-name } ahora elimina automáticamente esas cookies para que no puedan seguirte.
cfr-whatsnew-clear-cookies-image-alt = Ilustración de cookie bloqueada

## What's new: Media controls message

cfr-whatsnew-media-keys-header = Más controles multimedia
cfr-whatsnew-media-keys-body = Reproducir y pausar audio o video directamente desde tu teclado o audífonos facilita el control de medios desde otra pestaña, programa o incluso cuando tu computadora está bloqueada. También puedes moverte entre pistas usando las teclas de avance y retroceso.
cfr-whatsnew-media-keys-button = Saber cómo

## What's new: Search shortcuts

cfr-whatsnew-search-shortcuts-header = Atajos de búsqueda en la barra de direcciones
cfr-whatsnew-search-shortcuts-body = Ahora, cuando escribas un motor de búsqueda o un sitio específico en la barra de direcciones, aparecerá un atajo azul en las sugerencias de búsqueda. Selecciona ese acceso directo para completar tu búsqueda directamente desde la barra de direcciones.

## What's new: Cookies protection

cfr-whatsnew-supercookies-header = Protección contra supercookies maliciosas
cfr-whatsnew-supercookies-body = Los sitios web pueden adjuntar en secreto una "supercookie" a tu navegador que puede seguirte por la web, incluso después de limpiar tus cookies. { -brand-short-name } ahora proporciona una fuerte protección contra las supercookies para que no puedan usarse para rastrear tus actividades en línea de un sitio a otro.

## What's new: Better bookmarking

cfr-whatsnew-bookmarking-header = Mejores marcadores
cfr-whatsnew-bookmarking-body = Es más fácil realizar un seguimiento de tus sitios favoritos. { -brand-short-name } ahora recuerda tu ubicación preferida para los marcadores guardados, muestra la barra de herramientas de marcadores de forma predeterminada en las pestañas nuevas y te brinda fácil acceso al resto de tus marcadores a través de una carpeta de la barra de herramientas.

## What's new: Cross-site cookie tracking

cfr-whatsnew-cross-site-tracking-header = Protección integral contra el rastreo de cookies entre sitios
cfr-whatsnew-cross-site-tracking-body = Ahora puedes optar por una mejor protección contra el rastreo de cookies. { -brand-short-name } puedes aislar tus actividades y datos al sitio en el que te encuentras actualmente, así que la información almacenada en el navegador no se comparte entre sitios web.

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Es posible que los videos de este sitio no se reproduzcan correctamente en esta versión de { -brand-short-name }. Para obtener compatibilidad completa de video, actualiza { -brand-short-name } ahora.
cfr-doorhanger-video-support-header = Actualiza { -brand-short-name } para reproducir video
cfr-doorhanger-video-support-primary-button = Actualizar ahora
    .accesskey = A
