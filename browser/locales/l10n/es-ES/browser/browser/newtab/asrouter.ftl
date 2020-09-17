# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Extensión recomendada
cfr-doorhanger-feature-heading = Función recomendada
cfr-doorhanger-pintab-heading = Intenta esto: Fijar pestaña

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = ¿Por qué estoy viendo esto?

cfr-doorhanger-extension-cancel-button = Ahora no
    .accesskey = N

cfr-doorhanger-extension-ok-button = Añadir ahora
    .accesskey = A
cfr-doorhanger-pintab-ok-button = Fijar esta pestaña
    .accesskey = A

cfr-doorhanger-extension-manage-settings-button = Administrar ajustes de recomendaciones
    .accesskey = m

cfr-doorhanger-extension-never-show-recommendation = No mostrarme esta recomendación
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
    .tooltiptext = Recomendación de característica
    .a11y-announcement = Recomendación de característica disponible

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

cfr-doorhanger-pintab-description = Obtenga acceso rápido a sus sitios más visitados. Mantenga sitios abiertos en una pestaña (incluso cuando reinicie).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Haz clic con el botón derecho</b> en la pestaña que quieres fijar.
cfr-doorhanger-pintab-step2 = Selecciona <b>Fijar pestaña</b> en el menú.
cfr-doorhanger-pintab-step3 = Si el sitio tiene una actualización, verás un punto azul en la pestaña fijada.

cfr-doorhanger-pintab-animation-pause = Pausar
cfr-doorhanger-pintab-animation-resume = Reanudar


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Sincronice sus marcadores esté donde esté.
cfr-doorhanger-bookmark-fxa-body = ¡Gran hallazgo! Ahora no se quede sin este marcador en sus dispositivos móviles. Empiece con una { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Sincronizando marcadores...
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Cerrar botón
    .title = Cerrar

## Protections panel

cfr-protections-panel-header = Navegue sin que le sigan
cfr-protections-panel-body = Guarde sus datos solo para usted. { -brand-short-name } le protege de muchos de los rastreadores más comunes que espían lo que hace en línea.
cfr-protections-panel-link-text = Saber más

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Nueva función:

cfr-whatsnew-button =
    .label = Novedades
    .tooltiptext = Novedades

cfr-whatsnew-panel-header = Novedades

cfr-whatsnew-release-notes-link-text = Consulte las notas de lanzamiento

cfr-whatsnew-fx70-title = Ahora, { -brand-short-name } lucha más en pro de su privacidad
cfr-whatsnew-fx70-body = La última actualización mejora la función de protección contra rastreo y hace que sea más fácil que nunca la creación de contraseñas seguras para cada sitio.

cfr-whatsnew-tracking-protect-title = Protéjase de los rastreadores
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } bloquea los rastreadores sociales y entre sitios más comunes que
    le rastrean mientras navega.
cfr-whatsnew-tracking-protect-link-text = Ver su informe

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Rastreador bloqueado
       *[other] Rastreadores bloqueados
    }
cfr-whatsnew-tracking-blocked-subtitle = Desde { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Ver informe

cfr-whatsnew-lockwise-backup-title = Guarde una copia de sus contraseñas
cfr-whatsnew-lockwise-backup-body = Ahora puede generar contraseñas seguras a las que puede acceder desde cualquier lugar donde inicie sesión.
cfr-whatsnew-lockwise-backup-link-text = Activar copias de seguridad

cfr-whatsnew-lockwise-take-title = Llévese siempre sus contraseñas consigo
cfr-whatsnew-lockwise-take-body = La aplicación para móviles { -lockwise-brand-short-name } le permite acceder a sus contraseñas de forma segura  desde cualquier parte.
cfr-whatsnew-lockwise-take-link-text = Obtener la aplicación

## Search Bar

cfr-whatsnew-searchbar-title = Escriba menos, encuentre más con la barra de direcciones
cfr-whatsnew-searchbar-body-topsites = Ahora, simplemente seleccione la barra de direcciones y se va a expandir un cuadro con enlaces a sus sitios principales.
cfr-whatsnew-searchbar-icon-alt-text = Icono de lupa

## Picture-in-Picture

cfr-whatsnew-pip-header = Vea sus vídeos mientras navega
cfr-whatsnew-pip-body = La función picture-in-picture muestra el vídeo en una ventana flotante para que pueda verlo mientras trabaja en otras pestañas.
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
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } bloquea muchos detectores de huellas digitales (fingerprinters) que recopilan en secreto información sobre su dispositivo y acciones, para crear un perfil suyo con fines publicitarios.

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Fingerprinters
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } puede bloquear muchos detectores de huellas digitales (fingerprinters) que recopilan en secreto información sobre su dispositivo y acciones, para crear un perfil suyo con fines publicitarios.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Obtener este marcador en su teléfono
cfr-doorhanger-sync-bookmarks-body = Lleve sus marcadores, contraseñas, historial y más a todas partes donde inicie sesión en { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Activar { -sync-brand-short-name }
    .accesskey = T

## Login Sync

cfr-doorhanger-sync-logins-header = No vuelva a perder una contraseña
cfr-doorhanger-sync-logins-body = Almacene y sincronice de forma segura sus contraseñas en todos sus dispositivos.
cfr-doorhanger-sync-logins-ok-button = Activar { -sync-brand-short-name }
    .accesskey = T

## Send Tab

cfr-doorhanger-send-tab-header = Léalo en cualquier momento
cfr-doorhanger-send-tab-recipe-header = Llévese esta receta a la cocina
cfr-doorhanger-send-tab-body = Send Tab le permite compartir este enlace con su teléfono o con cualquier dispositivo en el que haya iniciado sesión con { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Probar Send Tab
    .accesskey = T

## Firefox Send

cfr-doorhanger-firefox-send-header = Compartir este PDF de forma segura
cfr-doorhanger-firefox-send-body = Mantenga sus documentos confidenciales a salvo de miradas indiscretas con cifrado de extremo a extremo y un enlace que desaparece cuando haya terminado.
cfr-doorhanger-firefox-send-ok-button = Pruebe { -send-brand-name }
    .accesskey = T

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Ver protecciones
    .accesskey = P
cfr-doorhanger-socialtracking-close-button = Cerrar
    .accesskey = C
cfr-doorhanger-socialtracking-dont-show-again = No volver a mostrar mensajes como este
    .accesskey = N
cfr-doorhanger-socialtracking-heading = { -brand-short-name } impidió que una red social le rastreara hasta aquí
cfr-doorhanger-socialtracking-description = Su privacidad importa. Ahora, { -brand-short-name } bloquea los rastreadores de redes sociales más comunes, limitando la cantidad de datos que pueden recopilar sobre lo que hace en línea.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } bloqueó un detector de huellas digitales en esta página
cfr-doorhanger-fingerprinters-description = Su privacidad es importante. { -brand-short-name } ahora bloquea los detectores de huellas digitales, que recopilan piezas de información que identifican de forma única a su dispositivo para poder rastrearlo.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } bloqueó un criptominero en esta página
cfr-doorhanger-cryptominers-description = Su privacidad es importante. { -brand-short-name } ahora bloquea los criptomineros, que utilizan la potencia informática de su sistema para extraer dinero digital.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
       *[other] ¡{ -brand-short-name } bloqueó más de <b>{ $blockedCount }</b> rastreadores desde { $date }!
    }
cfr-doorhanger-milestone-ok-button = Ver todo
    .accesskey = V

cfr-doorhanger-milestone-close-button = Cerrar
    .accesskey = C

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Cree fácilmente contraseñas seguras
cfr-whatsnew-lockwise-body = Es difícil pensar en contraseñas únicas y seguras para cada cuenta. Al crear una contraseña, seleccione el campo de contraseña para usar una contraseña segura y generada por { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = Icono de { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Reciba alertas sobre contraseñas vulnerables
cfr-whatsnew-passwords-body = Los hackers saben que la gente reutiliza sus contraseñas. Si usó la misma contraseña en varios sitios, y uno de esos sitios sufre una filtración de datos, verá una alerta en { -lockwise-brand-short-name } para cambiar su contraseña en esos sitios.
cfr-whatsnew-passwords-icon-alt = Icono de contraseña vulnerable

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Llevar el picture-in-picture a pantalla completa
cfr-whatsnew-pip-fullscreen-body = Cuando lleva un video a una ventana flotante, puede hacer doble clic en esa ventana para llevarlo a pantalla completa.
cfr-whatsnew-pip-fullscreen-icon-alt = Icono de picture-in-picture

## Protections Dashboard message

cfr-whatsnew-protections-header = Protecciones de un vistazo
cfr-whatsnew-protections-body = El panel de protecciones incluye informes resumidos sobre filtraciones de datos y administración de contraseñas. Ahora puede realizar un seguimiento de la cantidad de filtraciones que ha resuelto y ver si alguna de sus contraseñas guardadas puede haber sido expuesta en una filtración de datos.
cfr-whatsnew-protections-cta-link = Ver panel de protecciones
cfr-whatsnew-protections-icon-alt = Icono de escudo

## Better PDF message

cfr-whatsnew-better-pdf-header = Mejor experiencia con PDF
cfr-whatsnew-better-pdf-body = Los documentos PDF ahora se abren directamente en { -brand-short-name }, manteniendo su flujo de trabajo al alcance de la mano.

## DOH Message

cfr-doorhanger-doh-body = Su privacidad importa. { -brand-short-name } ahora enruta de forma segura sus peticiones de DNS, siempre que sea posible, a un servicio proporcionado para protegerle mientras navega.
cfr-doorhanger-doh-header = Búsquedas DNS más seguras y cifradas.
cfr-doorhanger-doh-primary-button = De acuerdo, entendido
    .accesskey = D
cfr-doorhanger-doh-secondary-button = Deshabilitar
    .accesskey = D

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Protección automática contra tácticas de rastreo encubiertas
cfr-whatsnew-clear-cookies-body = Algunos rastreadores lo redirigen a otros sitios web que configuran cookies en secreto. { -brand-short-name } ahora borra automáticamente esas cookies para que no puedan seguirte.
cfr-whatsnew-clear-cookies-image-alt = Ilustración de cookie bloqueada
