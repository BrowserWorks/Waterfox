# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

permissions-window =
    .title = Administrador de imágenes
    .style = width: 45em

permissions-close-key =
    .key = w

permissions-address = Dirección del sitio web
    .accesskey = d

permissions-block =
    .label = Bloquear
    .accesskey = B

permissions-session =
    .label = Permitir durante la sesión
    .accesskey = s

permissions-allow =
    .label = Permitir
    .accesskey = P

permissions-button-off =
    .label = Desactivar
    .accesskey = D

permissions-button-off-temporarily =
    .label = Desactivar temporalmente
    .accesskey = t

permissions-site-name =
    .label = Sitio web

permissions-status =
    .label = Estado

permissions-remove =
    .label = Eliminar sitio web
    .accesskey = R

permissions-remove-all =
    .label = Eliminar todos los sitios web
    .accesskey = e

permission-dialog =
    .buttonlabelaccept = Guardar cambios
    .buttonaccesskeyaccept = G

permissions-autoplay-menu = Predeterminado para todos los sitios web:

permissions-searchbox =
    .placeholder = Buscar sitio web

permissions-capabilities-autoplay-allow =
    .label = Permitir audio y video
permissions-capabilities-autoplay-block =
    .label = Bloquear audio
permissions-capabilities-autoplay-blockall =
    .label = Bloquear audio y video

permissions-capabilities-allow =
    .label = Permitir
permissions-capabilities-block =
    .label = Bloquear
permissions-capabilities-prompt =
    .label = Preguntar siempre

permissions-capabilities-listitem-allow =
    .value = Permitir
permissions-capabilities-listitem-block =
    .value = Bloquear
permissions-capabilities-listitem-allow-session =
    .value = Permitir para la sesión

permissions-capabilities-listitem-off =
    .value = Desactivado
permissions-capabilities-listitem-off-temporarily =
    .value = Desactivado temporalmente

## Invalid Hostname Dialog

permissions-invalid-uri-title = La dirección del servidor no es válida
permissions-invalid-uri-label = Introduzca un nombre de servidor válido

## Exceptions - Tracking Protection

permissions-exceptions-etp-window =
    .title = Excepciones a la protección antirrastreo mejorada
    .style = { permissions-window.style }
permissions-exceptions-etp-desc = Has desactivado las protecciones en estos sitios.

## Exceptions - Cookies

permissions-exceptions-cookie-window =
    .title = Excepciones: Cookies y datos del sitio
    .style = { permissions-window.style }
permissions-exceptions-cookie-desc = Puedes especificar qué sitios web pueden o no pueden utilizar siempre cookies y datos del sitio.  Escribe la dirección exacta del sitio que quieras gestionar y haz clic en Bloquear, Permitir en esta sesión o Permitir.

## Exceptions - HTTPS-Only Mode

permissions-exceptions-https-only-window =
    .title = Excepciones - Modo solo HTTPS
    .style = { permissions-window.style }
permissions-exceptions-https-only-desc = Puedes desactivar el modo solo HTTPS para sitios web específicos. { -brand-short-name } no intentará actualizar la conexión a HTTPS seguro para esos sitios. Las excepciones no se aplican a las ventanas privadas.

## Exceptions - Pop-ups

permissions-exceptions-popup-window =
    .title = Sitios web permitidos - Ventanas emergentes
    .style = { permissions-window.style }
permissions-exceptions-popup-desc = Puedes especificar los sitios web que podrán abrir ventanas emergentes. Introduce su dirección y da clic en Permitir.

## Exceptions - Saved Logins

permissions-exceptions-saved-logins-window =
    .title = Excepciones - Inicios de sesión guardados
    .style = { permissions-window.style }
permissions-exceptions-saved-logins-desc = Los inicios de sesión para los siguientes sitios web no se guardarán

## Exceptions - Add-ons

permissions-exceptions-addons-window =
    .title = Sitios web permitidos - Instalación de complementos
    .style = { permissions-window.style }
permissions-exceptions-addons-desc = Puedes especificar los sitios web que podrán instalar complementos. Introduce su dirección exacta y da clic en Permitir.

## Site Permissions - Autoplay

permissions-site-autoplay-window =
    .title = Configuración. Reproducción automática
    .style = { permissions-window.style }
permissions-site-autoplay-desc = Puedes administrar aquí los sitios que no siguen la configuración predeterminada de reproducción automática.

## Site Permissions - Notifications

permissions-site-notification-window =
    .title = Ajustes - Permisos de notificaciones
    .style = { permissions-window.style }
permissions-site-notification-desc = Los siguientes sitios han solicitado que desean enviarte notificaciones. Puedes especificar qué sitios web tienen permitido enviarte notificaciones. También puedes bloquear nuevas solicitudes preguntando para permitir notificaciones.
permissions-site-notification-disable-label =
    .label = Bloquear nuevas solicitudes preguntando para permitir notificaciones
permissions-site-notification-disable-desc = Esto prevendrá que cualquier sitio web que no esté listado solicite permiso para enviarte notificaciones. Bloqueando notificaciones pueden fallar algunas características de los sitios web.

## Site Permissions - Location

permissions-site-location-window =
    .title = Ajustes - Permisos de ubicación
    .style = { permissions-window.style }
permissions-site-location-desc = Los siguientes sitios web han solicitado acceso a tu ubicación. Puedes elegir específicamente que sitios tengan permitido acceder a tu ubicación. Puedes también bloquear nuevas solicitudes solicitando acceso a tu ubicación.
permissions-site-location-disable-label =
    .label = Bloquear nuevas solicitudes preguntando para acceder a tu ubicación
permissions-site-location-disable-desc = Esto evitará que cualquier sitio web que no esté listado solicite permiso para acceder a tu ubicación. Bloqueando el acceso a tu ubicación pueden fallar algunas características de los sitios web.

## Site Permissions - Virtual Reality

permissions-site-xr-window =
    .title = Ajustes - Permisos de realidad virtual
    .style = { permissions-window.style }
permissions-site-xr-desc = Los siguientes sitios web han solicitado acceder a tus dispositivos de realidad virtual. Puedes especificar qué sitios web tienen permitido acceder a tus dispositivos de realidad virtual. También puedes bloquear nuevas solicitudes que quieran acceder a tus dispositivos de realidad virtual.
permissions-site-xr-disable-label =
    .label = Bloquear nuevas solicitudes que quieran acceder a tus dispositivos de realidad virtual
permissions-site-xr-disable-desc = Este prevendrá que cualquier sitio web que no esté en la lista solicite permiso para acceder a tus dispositivos de realidad virtual. Bloquear el accesos a tus dispositivos de realidad virtual puede estropear algunas características de los sitios web.

## Site Permissions - Camera

permissions-site-camera-window =
    .title = Ajustes - Permisos de cámara
    .style = { permissions-window.style }
permissions-site-camera-desc = Los siguientes sitios web han solicitado acceso a tu cámara. Puedes especificar que sitios web tiene permitido acceder a tu cámara. También puedes bloquear nuevas solicitudes solicitando acceder a tu cámara.
permissions-site-camera-disable-label =
    .label = Bloquear nuevas solicitudes solicitando acceder a tu cámara
permissions-site-camera-disable-desc = Este evitará que cualquier sitio web no listado solicite permite para acceder a tu cámara. Bloqueando el acceso a tu cámara pueden fallar algunas características de los sitios web.

## Site Permissions - Microphone

permissions-site-microphone-window =
    .title = Ajustes - Permisos de micrófono
    .style = { permissions-window.style }
permissions-site-microphone-desc = Los siguientes sitios web han solicitado permiso para acceder a tu micrófono. Puedes especificar que sitios web tienen permitido acceder a tu micrófono. También puedes bloquear nuevas solicitudes solicitando acceso a tu micrófono.
permissions-site-microphone-disable-label =
    .label = Bloquear nuevas solicitudes para acceder a tu micrófono
permissions-site-microphone-disable-desc = Esto evitará que cualquier sitio web no listado solicite permite para acceder a tu micrófono. Bloqueando el acceso a tu micrófono pueden fallar algunas características de los sitios web.
