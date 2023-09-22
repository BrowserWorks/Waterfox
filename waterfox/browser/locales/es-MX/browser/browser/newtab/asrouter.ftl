# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Extensión recomendada
cfr-doorhanger-feature-heading = Característica recomendada

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = ¿Por qué estoy viendo esto?

cfr-doorhanger-extension-cancel-button = Ahora no
    .accesskey = N

cfr-doorhanger-extension-ok-button = Agregar ahora
    .accesskey = A

cfr-doorhanger-extension-manage-settings-button = Administrar ajustes de recomendación
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

## Waterfox Accounts Message

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

cfr-whatsnew-release-notes-link-text = Lee el informe de novedades

## Enhanced Tracking Protection Milestones

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
cfr-doorhanger-milestone-close-button = Cerrar
    .accesskey = C

## DOH Message

cfr-doorhanger-doh-body = Tu privacidad importa. { -brand-short-name } ahora enruta de forma segura tus solicitudes DNS siempre que sea posible a un servicio asociado para protegerte mientras navegas.
cfr-doorhanger-doh-header = Búsquedas DNS más seguras y encriptadas
cfr-doorhanger-doh-primary-button-2 = Aceptar
    .accesskey = A
cfr-doorhanger-doh-secondary-button = Deshabilitar
    .accesskey = D

## Fission Experiment Message

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Es posible que los videos de este sitio no se reproduzcan correctamente en esta versión de { -brand-short-name }. Para obtener compatibilidad completa de video, actualiza { -brand-short-name } ahora.
cfr-doorhanger-video-support-header = Actualiza { -brand-short-name } para reproducir video
cfr-doorhanger-video-support-primary-button = Actualizar ahora
    .accesskey = A

## Spotlight modal shared strings

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the BrowserWorks VPN page and a link to dismiss the dialog.

# This header text can be explicitly wrapped.
spotlight-public-wifi-vpn-header = Parece que estás usando una red Wi-Fi pública
spotlight-public-wifi-vpn-body = Para ocultar tu ubicación y actividad de navegación, considera usar una red privada virtual. Te ayudará a mantenerte protegido al navegar en lugares públicos como aeropuertos y cafeterías.
spotlight-public-wifi-vpn-primary-button = Mantente en privado con { -mozilla-vpn-brand-name }
    .accesskey = S
spotlight-public-wifi-vpn-link = Ahora no
    .accesskey = A

## Total Cookie Protection Rollout

## Emotive Continuous Onboarding

spotlight-better-internet-header = Un mejor internet comienza contigo
spotlight-better-internet-body = Cuando usas { -brand-short-name } estás eligiendo un internet abierto y accesible, lo cual es mejor para todos.
spotlight-peace-mind-header = Nosotros te protegemos
spotlight-peace-mind-body = Cada mes, { -brand-short-name } bloquea un promedio de 3,000 rastreadores por usuario. Porque nada, especialmente lo que molesta tu privacidad como los rastreadores, debe interponerse para que tengas un buen Internet.
spotlight-pin-primary-button =
    { PLATFORM() ->
        [macos] Mantener en el Dock
       *[other] Fijar en la barra de tareas
    }
spotlight-pin-secondary-button = Ahora no

## MR2022 Background Update Windows native toast notification strings.
##
## These strings will be displayed by the Windows operating system in
## a native toast, like:
##
## <b>multi-line title</b>
## multi-line text
## <img>
## [ primary button ] [ secondary button ]
##
## The button labels are fitted into narrow fixed-width buttons by
## Windows and therefore must be as narrow as possible.

mr2022-background-update-toast-title = Nuevo { -brand-short-name }. Más privado. Menos rastreadores. Sin compromisos.
mr2022-background-update-toast-text = Prueba el nuevo { -brand-short-name } ahora, mejorado con nuestra protección anti-rastreo más fuerte hasta el momento.

# This button label will be fitted into a narrow fixed-width button by
# Windows. Try to not exceed the width of the English text (compare it
# using a variable font like Arial): the button can only fit 1-2
# additional characters, exceeding characters will be truncated.
mr2022-background-update-toast-primary-button-label = Abrir { -brand-shorter-name } ahora

# This button label will be fitted into a narrow fixed-width button by
# Windows. Try to not exceed the width of the English text (compare it using a
# variable font like Arial): the button can only fit 1-2 additional characters,
# exceeding characters will be truncated.
mr2022-background-update-toast-secondary-button-label = Recordarme después

## Waterfox View CFR

firefoxview-cfr-primarybutton = Intentalo
    .accesskey = I
firefoxview-cfr-secondarybutton = Ahora no
    .accesskey = n
firefoxview-cfr-header-v2 = Continúa rápidamente donde lo dejaste
firefoxview-cfr-body-v2 = Recupera las pestañas cerradas recientemente y salta sin problemas entre dispositivos con { -firefoxview-brand-name }.

## Waterfox View Spotlight

firefoxview-spotlight-promo-title = Saluda a { -firefoxview-brand-name }

# “Poof” refers to the expression to convey when something or someone suddenly disappears, or in this case, reappears. For example, “Poof, it’s gone.”
firefoxview-spotlight-promo-subtitle = ¿Quieres esa pestaña abierta en tu teléfono? Tómala. ¿Necesitas ese sitio que acabas de visitar? Puf, ha vuelto con { -firefoxview-brand-name }.
firefoxview-spotlight-promo-primarybutton = Ver cómo funciona
firefoxview-spotlight-promo-secondarybutton = Saltar

## Colorways expiry reminder CFR

colorways-cfr-primarybutton = Elegir combinación de colores
    .accesskey = E

# "shades" refers to the different color options available to users in colorways.
colorways-cfr-body = Colorea tu navegador con { -brand-short-name } tonos exclusivos inspirados en voces que cambiaron la cultura.
colorways-cfr-header-28days = Las combinaciones de colores de Voces Independientes vencen el 16 de enero
colorways-cfr-header-14days = Las combinaciones de colores de Voces Independientes caducan en dos semanas
colorways-cfr-header-7days = Las combinaciones de colores de Voces Independientes expiran esta semana
colorways-cfr-header-today = Las combinaciones de colores de Voces Independiente expiran hoy

## Cookie Banner Handling CFR

cfr-cbh-header = ¿Permitir que { -brand-short-name } rechace los banners de cookies?
cfr-cbh-body = { -brand-short-name } puede rechazar automáticamente muchas solicitudes de banner de cookies.
cfr-cbh-confirm-button = Rechazar banners de cookies
    .accesskey = R
cfr-cbh-dismiss-button = Ahora no
    .accesskey = n

## These strings are used in the Fox doodle Pin/set default spotlights

july-jam-headline = Nosotros te protegemos
july-jam-body = Cada mes, { -brand-short-name } bloquea un promedio de más de 3,000 rastreadores por usuario, lo que brinda un acceso rápido y seguro a Internet bueno.
july-jam-set-default-primary = Abrir mis enlaces con { -brand-short-name }
fox-doodle-pin-headline = Te damos de nuevo la bienvenida

# “indie” is short for the term “independent”.
# In this instance, free from outside influence or control.
fox-doodle-pin-body = Un recordatorio rápido de que puedes mantener tu navegador independiente favorito a solo un clic de distancia.
fox-doodle-pin-primary = Abrir mis enlaces con { -brand-short-name }
fox-doodle-pin-secondary = Ahora no

## These strings are used in the Set Waterfox as Default PDF Handler for Existing Users experiment

set-default-pdf-handler-headline = <strong>Tus archivos PDF ahora se abren en { -brand-short-name }.</strong> Edita o firma formularios directamente en tu navegador. Para cambiar, busca "PDF" en ajustes.
set-default-pdf-handler-primary = Entendido

## FxA sync CFR

fxa-sync-cfr-header = ¿Está planeando obtener un nuevo dispositivo en el futuro?
fxa-sync-cfr-body = Asegúrate de que tus últimos marcadores, contraseñas y pestañas estén contigo cada vez que abras un nuevo navegador { -brand-product-name }.
fxa-sync-cfr-primary = Saber más
    .accesskey = L
fxa-sync-cfr-secondary = Recordarme luego
    .accesskey = R

## Device Migration FxA Spotlight

device-migration-fxa-spotlight-header = ¿Usando un dispositivo más antiguo?
device-migration-fxa-spotlight-body = Realiza una copia de seguridad de tus datos para asegurarte de no perder información importante como marcadores y contraseñas, especialmente si cambias a un nuevo dispositivo.
device-migration-fxa-spotlight-primary-button = Cómo hacer una copia de seguridad de mis datos
device-migration-fxa-spotlight-link = Recordarme luego
