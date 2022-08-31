# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Extensión recomendada
cfr-doorhanger-feature-heading = Función recomendada

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = ¿Por qué estoy viendo esto?
cfr-doorhanger-extension-cancel-button = Ahora no
    .accesskey = N
cfr-doorhanger-extension-ok-button = Añadir ahora
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

## Waterfox Accounts Message

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
cfr-whatsnew-release-notes-link-text = Consulte las notas de lanzamiento

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
       *[other] { -brand-short-name } bloqueado en <b>{ $blockedCount }</b> rastreadores desde { DATETIME($date, month: "long", year: "numeric") }!
    }
cfr-doorhanger-milestone-ok-button = Ver todo
    .accesskey = V
cfr-doorhanger-milestone-close-button = Cerrar
    .accesskey = C

## DOH Message

cfr-doorhanger-doh-body = Su privacidad importa. { -brand-short-name } ahora enruta de forma segura sus peticiones de DNS, siempre que sea posible, a un servicio proporcionado para protegerle mientras navega.
cfr-doorhanger-doh-header = Búsquedas DNS más seguras y cifradas.
cfr-doorhanger-doh-primary-button-2 = Aceptar
    .accesskey = A
cfr-doorhanger-doh-secondary-button = Deshabilitar
    .accesskey = D

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = Su privacidad importa. { -brand-short-name } ahora aísla, sitios web unos de otros, lo que hace que sea más difícil que los piratas informáticos roben contraseñas, números de tarjetas de crédito y otra información sensible.
cfr-doorhanger-fission-header = Aislamiento del sitio
cfr-doorhanger-fission-primary-button = OK, entendido
    .accesskey = O
cfr-doorhanger-fission-secondary-button = Aprender más
    .accesskey = A

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Los videos en este sitio web podrían no reproducirse correctamente en esta versión de { -brand-short-name }. Para una compatibilidad completa de vídeo, actualiza { -brand-short-name } ahora.
cfr-doorhanger-video-support-header = Actualice { -brand-short-name } para reproducir vídeo
cfr-doorhanger-video-support-primary-button = Actualizar ahora
    .accesskey = u

## Spotlight modal shared strings

spotlight-learn-more-collapsed = Saber más
    .title = Expandir para saber más sobre esta característica
spotlight-learn-more-expanded = Saber más
    .title = Cerrar

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the Waterfox VPN page and a link to dismiss the dialog.

# This header text can be explicitly wrapped.
spotlight-public-wifi-vpn-header = Parece que estás usando una red Wi-Fi pública
spotlight-public-wifi-vpn-body = Para ocultar su ubicación y actividad de navegación, considere usar una red privada virtual. Le ayudará a mantenerse protegido al navegar en lugares públicos como aeropuertos y cafeterías.
spotlight-public-wifi-vpn-primary-button = Proteja su privacidad con { -mozilla-vpn-brand-name }
    .accesskey = s
spotlight-public-wifi-vpn-link = Ahora no
    .accesskey = n

## Total Cookie Protection Rollout

# "Test pilot" is used as a verb. Possible alternatives: "Be the first to try",
# "Join an early experiment". This header text can be explicitly wrapped.
spotlight-total-cookie-protection-header =
    Prueba nuestra experiencia de 
    privacidad más poderosa de la historia
spotlight-total-cookie-protection-body = La protección total contra las cookies evita que los rastreadores usen cookies para seguirte en la web.
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch" as not everybody will get it yet.
spotlight-total-cookie-protection-expanded = { -brand-short-name } construye una valla alrededor de las cookies y las limita al sitio en el que se encuentra para que los rastreadores no puedan usarlas para seguirle. Con el acceso anticipado, ayudará a optimizar esta función para que podamos seguir construyendo una web mejor para todos.
spotlight-total-cookie-protection-primary-button = Activar la protección total contra las cookies
spotlight-total-cookie-protection-secondary-button = Ahora no
cfr-total-cookie-protection-header = Gracias a usted, { -brand-short-name } es más privado y seguro que nunca
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch". Only those who received it and accepted are shown this message.
cfr-total-cookie-protection-body = La protección total contra cookies es nuestra protección de privacidad más robusta hasta la fecha y ahora es el ajuste predeterminado para los usuarios de { -brand-short-name }. No podríamos haberlo logrado sin participantes de acceso anticipado como usted. Por lo que le agradecemos su ayuda para crear un internet mejor y más privado.

## Emotive Continuous Onboarding

spotlight-better-internet-header = Un internet mejor comienza con usted
spotlight-better-internet-body = Cuando usa { -brand-short-name }, está votando por una internet abierta y accesible que es mejor para todos.
spotlight-peace-mind-header = Siempre de tu parte
spotlight-peace-mind-body = Cada mes, { -brand-short-name } bloquea un promedio de más de 3.000 rastreadores por usuario. Porque nada, especialmente lo que molesta a su privacidad como los rastreadores, deberían meterse entre usted y lo mejor de internet.
spotlight-pin-primary-button =
    { PLATFORM() ->
        [macos] Mantener en el Dock
       *[other] Fijar a la barra de tareas
    }
spotlight-pin-secondary-button = Ahora no
