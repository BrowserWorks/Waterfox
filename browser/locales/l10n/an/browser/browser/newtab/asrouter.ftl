# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Extensión recomendada
cfr-doorhanger-feature-heading = Función recomendada
cfr-doorhanger-pintab-heading = Intenta esto: Fixar pestanya

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Per qué soi veyendo esto?

cfr-doorhanger-extension-cancel-button = No pas agora
    .accesskey = N

cfr-doorhanger-extension-ok-button = Anyadir agora
    .accesskey = A
cfr-doorhanger-pintab-ok-button = Fixar esta pestanya
    .accesskey = A

cfr-doorhanger-extension-manage-settings-button = Administrar achustes de recomendacions
    .accesskey = M

cfr-doorhanger-extension-never-show-recommendation = No amostrar-me esta recomendación
    .accesskey = N

cfr-doorhanger-extension-learn-more-link = Saber-ne mas

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = per { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Recomendación
cfr-doorhanger-extension-notification2 = Recomendación
    .tooltiptext = Recomendación d'extensión
    .a11y-announcement = Recomendación d'extensión disponible

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Recomendación
    .tooltiptext = Recomendación de caracteristica
    .a11y-announcement = Recomendación de caracteristica disponible

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

cfr-doorhanger-pintab-description = Obtienga acceso rapido a los suyos puestos mas visitaus. Mantienga puestos ubiertos en una pestanya (mesmo quan reinicie).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Fe clic con o botón dreito</b> en a pestanya que quiers fixar.
cfr-doorhanger-pintab-step2 = Tría <b>Fixar pestanya</b> en o menú.
cfr-doorhanger-pintab-step3 = Si lo puesto tiene una actualización, veyerás un punto azul en a pestanya fixada.

cfr-doorhanger-pintab-animation-pause = Pausar
cfr-doorhanger-pintab-animation-resume = Continar


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Sincronice los suyos marcapachinas sía an sía.
cfr-doorhanger-bookmark-fxa-body = Buena troballa! Agora no se quede sin este marcapachinas en os suyos dispositivos mobils. Empecipie con una { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Sincronizando marcapachinas...
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Zarrar botón
    .title = Zarrar

## Protections panel

cfr-protections-panel-header = Navegue sin que le sigan
cfr-protections-panel-body = Alce los suyos datos nomás pa vusté. { -brand-short-name } le proteche de muitos d'os elementos de seguimiento mas comuns que espían lo que fa en linia.
cfr-protections-panel-link-text = Saber mas

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Nueva función:

cfr-whatsnew-button =
    .label = Novedatz
    .tooltiptext = Novedatz

cfr-whatsnew-panel-header = Novedatz

cfr-whatsnew-release-notes-link-text = Consulte las notas de lanzamiento

cfr-whatsnew-fx70-title = Agora, { -brand-short-name } luita mas en pro d'a suya privacidat
cfr-whatsnew-fx70-body = La zaguera actualización millora la función de protección contra seguimiento y fa que sía mas facil que nunca la creación de claus seguras pa cada puesto.

cfr-whatsnew-tracking-protect-title = Se protecha d'os elementos de seguimiento
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } bloca los elementos de seguimiento socials y entre puestos mas comuns que
    le fan seguimiento mientres navega.
cfr-whatsnew-tracking-protect-link-text = Veyer lo suyo informe

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Rastreador bloqueado
       *[other] Elementos de seguimiento bloqueados
    }
cfr-whatsnew-tracking-blocked-subtitle = Dende { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Veyer informe

cfr-whatsnew-lockwise-backup-title = Alce una copia d'as suyas claus
cfr-whatsnew-lockwise-backup-body = Agora puede chenerar claus seguras a las qualas puede acceder dende qualsequier puesto an enciete sesión.
cfr-whatsnew-lockwise-backup-link-text = Activar copias de seguridat

cfr-whatsnew-lockwise-take-title = se Leve siempre las suyas claus con ell
cfr-whatsnew-lockwise-take-body = L'aplicación pa mobils { -lockwise-brand-short-name } le permite acceder a las suyas claus de forma segura  dende qualsequier parte.
cfr-whatsnew-lockwise-take-link-text = Obtener l'aplicación

## Search Bar

cfr-whatsnew-searchbar-title = Escriba menos, trobe mas con a barra d'adrezas
cfr-whatsnew-searchbar-body-topsites = Agora, simplament tríe la barra d'adrezas y se va a expandir un quadro con vinclos a los suyos puestos prencipals.
cfr-whatsnew-searchbar-icon-alt-text = Icono de lupa

## Picture-in-Picture

cfr-whatsnew-pip-header = Veiga los suyos videos mientres navega
cfr-whatsnew-pip-body = La función picture-in-picture amuestra lo video en una finestra flotant pa que pueda veyer-lo mientres treballa en atras pestanyas.
cfr-whatsnew-pip-cta = Saber-ne mas

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Reduce molestas finestras emerchents
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } agora bloca los puestos pa que no soliciten automaticament lo ninvio de mensaches emerchents.
cfr-whatsnew-permission-prompt-cta = Saber mas

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Detector de ditaladas dichitals blocau
       *[other] Detectors de ditaladas dichitals blocaus
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } bloca muitos detectores de ditaladas (fingerprinters) que recopilan en secreto información sobre lo suyo dispositivo y accions, pa creyar un perfil suyo con fins publicitarias.

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Ditaladas dichitals
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } puede blocar muitos detectores de ditaladas dichitals (fingerprinters) que recopilan en secreto información sobre lo suyo dispositivo y accions, pa creyar un perfil suyo con fins publicitarias.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Obtener este marcapachinas en o suyo telefono
cfr-doorhanger-sync-bookmarks-body = Leve los suyos marcapachinas, claus, historial y mas a totas partes an enciete sesión en { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Activar { -sync-brand-short-name }
    .accesskey = T

## Login Sync

cfr-doorhanger-sync-logins-header = No torne a perder una clau
cfr-doorhanger-sync-logins-body = Almagazene y sincronice de forma segura las suyas claus en totz los suyos dispositivos.
cfr-doorhanger-sync-logins-ok-button = Activar { -sync-brand-short-name }
    .accesskey = T

## Send Tab

cfr-doorhanger-send-tab-header = Lo leiga en qualsequier momento
cfr-doorhanger-send-tab-recipe-header = Se leve esta receta a la cocina
cfr-doorhanger-send-tab-body = Send Tab le permite compartir este vinclo con o suyo telefono u con qualsequier dispositivo en o qual haiga encetau sesión con { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Prebar Send Tab
    .accesskey = T

## Firefox Send

cfr-doorhanger-firefox-send-header = Compartir este PDF de forma segura
cfr-doorhanger-firefox-send-body = Mantienga los suyos documentos confidencials a resguardo de miradas indiscretas con zifrau de cabo a cabo y un vinclo que desapareixe quan haiga rematau.
cfr-doorhanger-firefox-send-ok-button = Prebe { -send-brand-name }
    .accesskey = T

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Veyer proteccions
    .accesskey = P
cfr-doorhanger-socialtracking-close-button = Zarrar
    .accesskey = C
cfr-doorhanger-socialtracking-dont-show-again = No tornar a amostrar mensaches como este
    .accesskey = N
cfr-doorhanger-socialtracking-heading = { -brand-short-name } impidió que un ret social le seguise dica aquí
cfr-doorhanger-socialtracking-description = La suya privacidat importa. Agora, { -brand-short-name } bloca los elementos de seguimiento de retz socials mas comuns, limitando la cantidat de datos que pueden recopilar sobre lo que fa en linia.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } blocó un detector de ditaladas dichitals en esta pachina
cfr-doorhanger-fingerprinters-description = La suya privacidat ye important. { -brand-short-name } agora bloca los detectores de ditaladas, que recopilan piezas d'información que identifican de forma sola a lo suyo dispositivo pa poder seguir-lo.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } blocó un criptominero en esta pachina
cfr-doorhanger-cryptominers-description = La suya privacidat ye important. { -brand-short-name } agora bloca los criptomineros, que utilizan la potencia informatica d'o suyo sistema pa extrayer diners dichitals.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
       *[other] ¡{ -brand-short-name } bloqueó más de <b>{ $blockedCount }</b> elementos de seguimiento desde { $date }!
    }
cfr-doorhanger-milestone-ok-button = Veyer tot
    .accesskey = V

cfr-doorhanger-milestone-close-button = Zarrar
    .accesskey = Z

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Creye facilment claus seguras
cfr-whatsnew-lockwise-body = Ye dificil pensar en claus solas y seguras pa cada cuenta. En creyar una clau, tríe lo campo de clau pa usar una clau segura y chenerada per { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = Icono de { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Reciba alertas sobre claus vulnerables
cfr-whatsnew-passwords-body = Los hackers saben que la chent reutiliza las suyas claus. Si usó la mesma clau en quantos puestos, y un d'ixes puestos sufre una filtración de datos, veyerá una alerta en { -lockwise-brand-short-name } pa cambiar la suya clau en ixes puestos.
cfr-whatsnew-passwords-icon-alt = Icono de clau vulnerable

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Levar lo picture-in-picture a pantalla completa
cfr-whatsnew-pip-fullscreen-body = Quan leva un video a una finestra flotant, puede fer dople clic en ixa finestra pa levar-lo a pantalla completa.
cfr-whatsnew-pip-fullscreen-icon-alt = Icono de picture-in-picture

## Protections Dashboard message

cfr-whatsnew-protections-header = Proteccions d'un vistazo
cfr-whatsnew-protections-body = Lo panel de proteccions incluye informes resumius sobre filtracions de datos y administración de claus. Agora puede realizar un seguimiento d'a cantidat de filtracions que ha resuelto y veyer si bella d'as suyas claus alzadas puede haber estau exposada en una filtración de datos.
cfr-whatsnew-protections-cta-link = Veyer panel de proteccions
cfr-whatsnew-protections-icon-alt = Icono de escudo

## Better PDF message

cfr-whatsnew-better-pdf-header = Millor experiencia con PDF
cfr-whatsnew-better-pdf-body = Los documentos PDF agora s'ubren dreitament en { -brand-short-name }, mantenendo lo suyo fluxo de treballo a l'aconsiga d'a man.

## DOH Message

cfr-doorhanger-doh-body = La tuya privacidat ye important. Agora lo { -brand-short-name } encamina de forma segura las tuyas solicitutz DNS, siempre que siga posible, a un servicio asociau pa protecher-te mientres navegas.
cfr-doorhanger-doh-header = Consultas DNS mas seguras y cifradas
cfr-doorhanger-doh-primary-button = Vale, entendiu
    .accesskey = V
cfr-doorhanger-doh-secondary-button = Desactivar
    .accesskey = D

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Protección automatica contra tacticas de seguimiento enganyosas
cfr-whatsnew-clear-cookies-body = Bell elemento de seguimiento te rediriche ta atras pachinas web que meten cookies secretament. { -brand-short-name } agora borra automaticament ixas cookies pa que no te puedan fer seguimiento.
cfr-whatsnew-clear-cookies-image-alt = Illustracion d’una cookie blocau
