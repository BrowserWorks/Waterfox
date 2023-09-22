# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error page titles

neterror-page-title = Problemas al cargar la página
certerror-page-title = Advertencia: Riesgo potencial de seguridad a continuación
certerror-sts-page-title = No se conectó: Potencial problema de seguridad
neterror-blocked-by-policy-page-title = Página bloqueada
neterror-captive-portal-page-title = Iniciar sesión en la red
neterror-dns-not-found-title = Servidor no encontrado
neterror-malformed-uri-page-title = URL inválida

## Error page actions

neterror-advanced-button = Avanzado…
neterror-copy-to-clipboard-button = Copiar texto al portapapeles
neterror-learn-more-link = Saber más…
neterror-open-portal-login-page-button = Abrir página de ingreso a la red
neterror-override-exception-button = Aceptar el riesgo y continuar
neterror-pref-reset-button = Restaurar ajustes predeterminados
neterror-return-to-previous-page-button = Regresar
neterror-return-to-previous-page-recommended-button = Volver (recomendado)
neterror-try-again-button = Intentar de nuevo
neterror-add-exception-button = Continuar siempre para este sitio
neterror-settings-button = Cambiar la configuración de DNS
neterror-view-certificate-link = Ver certificado
neterror-trr-continue-this-time = Continuar esta vez
neterror-disable-native-feedback-warning = Continuar siempre

##

neterror-pref-reset = Parece que la configuración de seguridad de la red podría estar provocando esto. ¿Quieres la configuración predeterminada para restaurar?
neterror-error-reporting-automatic = Informa errores de este tipo para ayudar a { -vendor-short-name } a identificar y bloquear sitios maliciosos.

## Specific error messages

neterror-generic-error = { -brand-short-name } no puede cargar esta página por alguna razón.

neterror-load-error-try-again = El sitio podría estar temporalmente fuera de servicio o muy ocupado. Intenta nuevamente en un momento.
neterror-load-error-connection = Si no puedes cargar ninguna página, verifica la conexión de red de tu computadora.
neterror-load-error-firewall = Si la red o tu computadora están protegidas por un firewall o proxy, asegúrate que { -brand-short-name } pueda acceder a internet.

neterror-captive-portal = Hay que iniciar sesión en esta red antes de poder acceder a Internet.

# Variables:
# $hostAndPath (String) - a suggested site (e.g. "www.example.com") that the user may have meant instead.
neterror-dns-not-found-with-suggestion = ¿Querías ir a <a data-l10n-name="website">{ $hostAndPath }</a>?
neterror-dns-not-found-hint-header = <strong>Si ingresaste la dirección correcta, puedes:</strong>
neterror-dns-not-found-hint-try-again = Intentar de nuevo más tarde
neterror-dns-not-found-hint-check-network = Comprueba tu conexión de red
neterror-dns-not-found-hint-firewall = Verifica que { -brand-short-name } tenga permiso para acceder a la web (es posible que estés conectado pero detrás de un firewall)

## TRR-only specific messages
## Variables:
##   $hostname (String) - Hostname of the website to which the user was trying to connect.
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-trr-only-reason = { -brand-short-name } no puede proteger tu solicitud para la dirección de este sitio a través de nuestro sistema de resolución de nuestro DNS de confianza. Esta es la razón:
neterror-dns-not-found-trr-third-party-warning2 = Puedes continuar con tu solucionador de DNS predeterminado. Sin embargo, un tercero podría ver qué sitios web visitas.

neterror-dns-not-found-trr-only-could-not-connect = { -brand-short-name } no pudo conectarse a { $trrDomain }.
neterror-dns-not-found-trr-only-timeout = La conexión a { $trrDomain } tomó más tiempo de lo esperado.
neterror-dns-not-found-trr-offline = No estás conectado a Internet.
neterror-dns-not-found-trr-unknown-host2 = Este sitio web no fue encontrado por { $trrDomain }.
neterror-dns-not-found-trr-server-problem = Hubo un problema con { $trrDomain }.
neterror-dns-not-found-trr-unknown-problem = Problema inesperado.

## Native fallback specific messages
## Variables:
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-native-fallback-reason = { -brand-short-name } no puede proteger tu solicitud para la dirección de este sitio a través de nuestro sistema de resolución de nuestro DNS de confianza. Esta es la razón:
neterror-dns-not-found-native-fallback-heuristic = DNS sobre HTTPS ha sido deshabilitado en tu red.
neterror-dns-not-found-native-fallback-not-confirmed2 = { -brand-short-name } no pudo conectarse a { $trrDomain }.

##

neterror-file-not-found-filename = Comprueba que el nombre del archivo no contenga errores.
neterror-file-not-found-moved = Verifica si el archivo se borró, movió o renombró.

neterror-access-denied = Puede haber sido eliminado, movido o los permisos del archivo pueden evitar el acceso.

neterror-unknown-protocol = Necesitas instalar otro programa para abrir esta dirección.

neterror-redirect-loop = Este problema puede estar pasando por haber deshabilitado las cookies.

neterror-unknown-socket-type-psm-installed = Verifica que tu sistema tiene instalado el administrador de seguridad personal.
neterror-unknown-socket-type-server-config = Esto podría ser ocasionado por una configuración no estándar en el servidor.

neterror-not-cached-intro = El documento solicitado no está disponible en la caché de { -brand-short-name }.
neterror-not-cached-sensitive = Como precaución de seguridad, { -brand-short-name } no solicita automáticamente documentos sensibles.
neterror-not-cached-try-again = Haz clic en Intentar de nuevo para volver a solicitar el documento del sitio web.

neterror-net-offline = Pulsa “Intentar de nuevo” para cambiar al modo con conexión y recargar la página.

neterror-proxy-resolve-failure-settings = Comprueba que la configuración del proxy esté correcta.
neterror-proxy-resolve-failure-connection = Comprueba que la conexión de red de tu computadora esté funcionando.
neterror-proxy-resolve-failure-firewall = Si tu computadora o red están protegidos por un firewall o proxy, asegúrate que { -brand-short-name } tiene permisos para acceder a la web.

neterror-proxy-connect-failure-settings = Comprueba que la configuración del proxy esté correcta.
neterror-proxy-connect-failure-contact-admin = Comunícate con el administrador de la red para comprobar que el servidor proxy está funcionando.

neterror-content-encoding-error = Contacta a los propietarios del sitio web para informarles sobre este problema.

neterror-unsafe-content-type = Contacta a los propietarios del sitio web para informarles sobre este problema.

neterror-nss-failure-not-verified = La página que estás tratando de ver no se puede mostrar porque la autenticidad de los datos recibidos no pueden ser verificados.
neterror-nss-failure-contact-website = Por favor contacta a los propietarios del sitio web para informarles de este problema.

# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-intro = { -brand-short-name } ha detectado una potencial amenaza y no ha continuado a <b>{ $hostname }</b>. Si visitas este sitio, los atacantes podrían intentar robar tu información como tus contraseñas, correo o datos de tu tarjeta de crédito.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-sts-intro = { -brand-short-name } ha detectado una potencial amenaza de seguridad y no ha continuado a <b>{ $hostname }</b> porque este sitio web requiere una conexión segura.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-expired-cert-intro = { -brand-short-name } ha detectado un problema y no continuó a <b>{ $hostname }</b>. El sitio web está mal configurado o el reloj de tu computadora tiene una hora incorrecta.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm = <b>{ $hostname }</b> es probablemente un sitio seguro, pero no se puede realizar una conexión segura. Este problema es causado por <b>{ $mitm }</b>, el cual es un programa en su computadora o en tu red.

neterror-corrupted-content-intro = La página que estás tratando de ver no puede mostrarse porque se detectó un error en la transmisión de los datos.
neterror-corrupted-content-contact-website = Por favor, contacta a los dueños del sitio web para informarles de este problema.

# Do not translate "SSL_ERROR_UNSUPPORTED_VERSION".
neterror-sslv3-used = Información avanzada: SSL_ERROR_UNSUPPORTED_VERSION

# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
neterror-inadequate-security-intro = <b>{ $hostname }</b> usa tecnología de seguridad que es obsoleta y vulnerable a los ataques. Un atacante podría fácilmente revelar información que se piensa segura. El administrador del sitio web necesitará corregir el servidor antes de poder visitar el sitio.
# Do not translate "NS_ERROR_NET_INADEQUATE_SECURITY".
neterror-inadequate-security-code = Código de error: NS_ERROR_NET_INADEQUATE_SECURITY

# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
neterror-clock-skew-error = Tu computadora cree que son las { DATETIME($now, dateStyle: "medium") }, lo que previene a { -brand-short-name } de conectarse de forma segura. Para visitar <b>{ $hostname }</b>, actualiza la hora de tu computadora en los ajustes de tu sistema a la hora, fecha y zona horaria actuales, y luego recarga <b>{ $hostname }</b>.

neterror-network-protocol-error-intro = La página que estás intentando ver no se puede mostrar porque fue detectado un error del protocolo de red.
neterror-network-protocol-error-contact-website = Por favor, contacta con los propietarios del sitio web para informarles de este problema.

certerror-expired-cert-second-para = Es probable que el certificado del sitio esté expirado, lo que previene a { -brand-short-name } de conectarse de forma segura. Si visitas este sitio, los atacantes pueden intentar robar tu información como contraseñas, correos electrónicos o detalles de tu tarjeta de crédito.
certerror-expired-cert-sts-second-para = Probablemente el certificado del sitio ha expirado, impidiendo que { -brand-short-name } se conecte con seguridad.

certerror-what-can-you-do-about-it-title = ¿Qué puedes hacer al respecto?

certerror-unknown-issuer-what-can-you-do-about-it-website = Es probable que haya un problema con el sitio web y no hay nada que puedas hacer al respecto.
certerror-unknown-issuer-what-can-you-do-about-it-contact-admin = Si estás usando una red corporativa o un software antivirus, puedes contactarte con el equipo de asistencia técnica. También puedes notificarle al administrador del sitio sobre el problema.

# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
certerror-expired-cert-what-can-you-do-about-it-clock = El reloj de tu computadora está ajustado a las { DATETIME($now, dateStyle: "medium") }. Asegúrate de que tu computadora está ajustada a la fecha, hora y zona horaria correctas en los ajustes de tu sistema, y luego recarga <b>{ $hostname }</b>.
certerror-expired-cert-what-can-you-do-about-it-contact-website = Si tu reloj ya está ajustado a la hora correcta, el sitio web probablemente está mal configurado, y no hay nada que puedas hacer para resolverlo. Podrías intentar notificar al administrador del sitio sobre el problema.

certerror-bad-cert-domain-what-can-you-do-about-it = Es probable que haya un problema con el sitio web, y no hay nada que puedas hacer para resolverlo. Puedes notificar al administrador del sitio web sobre el problema.

certerror-mitm-what-can-you-do-about-it-antivirus = Si tu antivirus tiene una característica que escanea conexiones encriptadas (normalmente llamado “web scanning” o “https scanning”), puedes desactivar esta característica. Si no funciona, puedes eliminar y reinstalar el antivirus.
certerror-mitm-what-can-you-do-about-it-corporate = Si estás en una red corporativa, puedes comunicarte con el departamento de informática.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack = Si no estás familiarizado con <b>{ $mitm }</b>, entonces esto puede ser un ataque y no sería bueno continuar al sitio.

# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack-sts = Si no estás familiarizado con <b>{ $mitm }</b>, entonces esto puede ser un ataque y no hay nada que puedas hacer para acceder al sitio.

# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-what-should-i-do-bad-sts-cert-explanation = <b>{ $hostname }</b> tiene una política de seguridad llamada HTTP Strict transporte Security (HSTS), que significa que { -brand-short-name } solo puede conectarse a él con seguridad. No puedes agregar una excepción para visitar este sitio.
