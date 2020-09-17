# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Extensión recomendada
cfr-doorhanger-feature-heading = Funcionalidad recomendada
cfr-doorhanger-pintab-heading = Prueba esto: Fijar pestaña

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Por qué estoy viendo esto

cfr-doorhanger-extension-cancel-button = Ahora no
    .accesskey = N

cfr-doorhanger-extension-ok-button = Añadir ahora
    .accesskey = A
cfr-doorhanger-pintab-ok-button = Fijar esta pestaña
    .accesskey = P

cfr-doorhanger-extension-manage-settings-button = Gestionar ajustes de recomendaciones
    .accesskey = M

cfr-doorhanger-extension-never-show-recommendation = No volver a mostrar esta recomendación
    .accesskey = S

cfr-doorhanger-extension-learn-more-link = Aprender más

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
    .tooltiptext = Recomendación de funcionalidad
    .a11y-announcement = Recomendación de funcionalidad disponible

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

cfr-doorhanger-pintab-description = Obtén acceso rápido a tus sitios más visitados. Mantén los sitios abiertos en una pestaña (incluso cuando reinicies).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Clic derecho</b> en la pestaña que quieres fijar.
cfr-doorhanger-pintab-step2 = Selecciona <b>Fijar pestaña</b> desde el menú.
cfr-doorhanger-pintab-step3 = Si el sitio tiene una actualización, verás un punto azul en tu pestaña fijada.

cfr-doorhanger-pintab-animation-pause = Pausar
cfr-doorhanger-pintab-animation-resume = Continuar


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Sincroniza tus marcadores en cualquier lugar.
cfr-doorhanger-bookmark-fxa-body = ¡Gran hallazgo! Ahora no se quedes sin este marcador en tus dispositivos móviles. Empieza con una { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Sincronizar marcadores ahora…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Botón de cierre
    .title = Cerrar

## Protections panel

cfr-protections-panel-header = Navega sin ser seguido
cfr-protections-panel-body = Mantén tus datos privados. { -brand-short-name } te protege de la mayoría de los rastreadores comunes que siguen lo que haces en línea.
cfr-protections-panel-link-text = Aprender más

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Nueva funcionalidad:

cfr-whatsnew-button =
    .label = Qué hay de nuevo
    .tooltiptext = Qué hay de nuevo

cfr-whatsnew-panel-header = Qué hay de nuevo

cfr-whatsnew-release-notes-link-text = Lee las notas de la versión

cfr-whatsnew-fx70-title = { -brand-short-name } ahora lucha con más fuerza por tu privacidad
cfr-whatsnew-fx70-body =
    La última actualización mejora la función de protección contra seguimiento y hace
    que sea más fácil que nunca el crear contraseñas seguras para cada sitio.

cfr-whatsnew-tracking-protect-title = Protégete de los rastreadores
cfr-whatsnew-tracking-protect-body = { -brand-short-name } bloquea muchos de los rastreadores sociales y de sitios cruzados comunes que siguen lo que haces en línea.
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
cfr-whatsnew-tracking-blocked-link-text = Ver reporte

cfr-whatsnew-lockwise-backup-title = Respalda tus contraseñas
cfr-whatsnew-lockwise-backup-body = Ahora genera contraseñas seguras a las que puedes acceder donde sea que te conectes.
cfr-whatsnew-lockwise-backup-link-text = Activar respaldos

cfr-whatsnew-lockwise-take-title = Lleva tus contraseñas contigo
cfr-whatsnew-lockwise-take-body = La app para móviles { -lockwise-brand-short-name } te permite acceder de forma segura a tus contraseñas respaldadas desde cualquier parte.
cfr-whatsnew-lockwise-take-link-text = Obtener la aplicación

## Search Bar

cfr-whatsnew-searchbar-title = Escribe menos, encuentra más con la barra de direcciones
cfr-whatsnew-searchbar-body-topsites = Ahora, solo selecciona la barra de direcciones y una caja se expandirá con los enlaces a tus sitios frecuentes.
cfr-whatsnew-searchbar-icon-alt-text = Ícono de lupa

## Picture-in-Picture

cfr-whatsnew-pip-header = Mira videos mientras navegas
cfr-whatsnew-pip-body = La función picture-in-picture muestra el vídeo en una ventana flotante para que puedas verlo mientras trabajas en otras pestañas.
cfr-whatsnew-pip-cta = Aprender más

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Menos ventanas emergentes de sitios molestos
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } ahora bloquea sitios para que no pidan automáticamente enviarte mensajes emergentes.
cfr-whatsnew-permission-prompt-cta = Aprender más

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Se bloqueó un creador de huellas (fingerprinter)
       *[other] Se bloquearon creadores de huellas (fingerprinters)
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } muchos creadores de huellas (fingerprinter) que reúnen secretamente información acerca de tu dispositivo y acciones para crear un perfil de publicidad para ti.

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Creadores de huellas (Fingerprinters)
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } puede bloquear creadores de huellas (fingerprinter) que reúnen secretamente información acerca de tu dispositivo y acciones para crear un perfil de publicidad para ti.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Lleva este marcador a tu teléfono
cfr-doorhanger-sync-bookmarks-body = Lleva tus marcadores, contraseñas, historial y más a todas partes en que te conectes con tu { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Activa { -sync-brand-short-name }
    .accesskey = T

## Login Sync

cfr-doorhanger-sync-logins-header = Nunca pierdas una contraseña nuevamente
cfr-doorhanger-sync-logins-body = Guarda de forma segura y sincroniza tus contraseñas en todos tus dispositivos
cfr-doorhanger-sync-logins-ok-button = Activar { -sync-brand-short-name }
    .accesskey = T

## Send Tab

cfr-doorhanger-send-tab-header = Lee esto en el camino
cfr-doorhanger-send-tab-recipe-header = Lleva esta receta a la cocina
cfr-doorhanger-send-tab-body = Send Tab te permite compartir fácilmente este enlace con tu teléfono o a otro equipo en que estés conectado a { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Probar Send Tab
    .accesskey = T

## Firefox Send

cfr-doorhanger-firefox-send-header = Comparte este PDF de forma segura
cfr-doorhanger-firefox-send-body = Mantén tus documentos sensibles lejos de miradas intrusas con cifrado de extremo a extremo y un enlace que desaparece cuando estés listo.
cfr-doorhanger-firefox-send-ok-button = Prueba { -send-brand-name }
    .accesskey = T

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Ver protecciones
    .accesskey = P
cfr-doorhanger-socialtracking-close-button = Cerrar
    .accesskey = C
cfr-doorhanger-socialtracking-dont-show-again = No volver a mostrar mensajes como este
    .accesskey = D
cfr-doorhanger-socialtracking-heading = { -brand-short-name } detuvo a una red social de rastrearte hasta aquí
cfr-doorhanger-socialtracking-description = Tu privacidad importa. { -brand-short-name } ahora bloquea rastreadores de redes sociales comunes, limitando la cantidad de datos que recolectan sobre lo que haces en línea.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } bloqueó un creador de huellas digitales (fingerprinter) en esta página
cfr-doorhanger-fingerprinters-description = Tu privacidad importa. { -brand-short-name } ahora bloquea creadores de huellas digitales (fingerprinters), los que recolectan piezas de información única e identificable sobre tu dispositivo para rastrearte.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } bloqueó un criptominero en esta página
cfr-doorhanger-cryptominers-description = Tu privacidad importa. { -brand-short-name } ahora bloquea criptomineros, los que usan la potencia de cómputo de tu sistema para minar dinero digital.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
       *[other] ¡{ -brand-short-name } bloqueó más de <b>{ $blockedCount }</b> rastreadores desde el { $date }!
    }
cfr-doorhanger-milestone-ok-button = Ver todos
    .accesskey = S

cfr-doorhanger-milestone-close-button = Cerrar
    .accesskey = C

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Crea fácilmente contraseñas seguras
cfr-whatsnew-lockwise-body = Es difícil pensar contraseñas únicas y seguras para cada cuenta. Al crear una contraseña, selecciona el campo de contraseña para usar una contraseña segura generada por { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = Ícono de { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Recibe alertas sobre contraseñas vulnerables
cfr-whatsnew-passwords-body = Los hackers saben que la gente reutiliza sus contraseñas. Si usaste la misma contraseña en múltiples sitios, y uno de esos sitios sufre una filtración de datos, verás una alerta en { -lockwise-brand-short-name } para cambiar tu contraseña en esos sitios.
cfr-whatsnew-passwords-icon-alt = Ícono de contraseña vulnerable

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Llevar el picture-in-picture a pantalla completa
cfr-whatsnew-pip-fullscreen-body = Cuando llevas un video a una ventana flotante, puedes a continuación hacer doble clic en esa ventana para llevarlo a pantalla completa.
cfr-whatsnew-pip-fullscreen-icon-alt = Ícono de picture-in-picture

## Protections Dashboard message

cfr-whatsnew-protections-header = Protecciones de un vistazo
cfr-whatsnew-protections-body = El Panel de protección incluye informes resumidos sobre filtraciones de datos y administración de contraseñas. Ahora puede realizar un seguimiento de la cantidad de filtraciones que has resuelto y ver si alguna de tus contraseñas guardadas puede haberse visto expuesta en una filtración de datos.
cfr-whatsnew-protections-cta-link = Ver panel de protecciones
cfr-whatsnew-protections-icon-alt = Ícono de escudo

## Better PDF message

cfr-whatsnew-better-pdf-header = Mejor experiencia en PDF
cfr-whatsnew-better-pdf-body = Los documentos PDF ahora se abren directamente en { -brand-short-name }, manteniendo tu flujo de trabajo al alcance.

## DOH Message

cfr-doorhanger-doh-body = Tu privacidad importa. { -brand-short-name } ahora enruta de forma segura tus solicitudes DNS siempre que sea posible a un servicio asociado para protegerte mientras navegas.
cfr-doorhanger-doh-header = Búsquedas DNS más seguras y encriptadas
cfr-doorhanger-doh-primary-button = Ok, me quedó clarito
    .accesskey = O
cfr-doorhanger-doh-secondary-button = Desactivar
    .accesskey = D

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Protección automática contra tácticas de rastreo furtivas
cfr-whatsnew-clear-cookies-body = Algunos rastreadores te redirigen a otros sitios web que configuran cookies en secreto. { -brand-short-name } ahora borra automáticamente esas cookies para que no puedan seguirte.
cfr-whatsnew-clear-cookies-image-alt = Ilustración de cookie bloqueada
