# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error page titles

neterror-page-title = Problema al cargar la página
certerror-page-title = Advertencia: riesgo potencial de seguridad a continuación
certerror-sts-page-title = No se ha conectado: Posible problema de seguridad
neterror-blocked-by-policy-page-title = Página bloqueada
neterror-captive-portal-page-title = Iniciar sesión en la red
neterror-dns-not-found-title = Servidor no encontrado
neterror-malformed-uri-page-title = URL no válida

## Error page actions

neterror-advanced-button = Avanzado…
neterror-copy-to-clipboard-button = Copiar texto al portapapeles
neterror-learn-more-link = Más información…
neterror-open-portal-login-page-button = Abrir página de inicio de sesión en la red
neterror-override-exception-button = Aceptar el riesgo y continuar
neterror-pref-reset-button = Restablecer configuración predeterminada
neterror-return-to-previous-page-button = Ir atrás
neterror-return-to-previous-page-recommended-button = Retroceder (recomendado)
neterror-try-again-button = Reintentar
neterror-add-exception-button = Continuar siempre para este sitio
neterror-settings-button = Cambiar la configuración de DNS
neterror-view-certificate-link = Ver certificado
neterror-trr-continue-this-time = Continuar esta vez
neterror-disable-native-feedback-warning = Continuar siempre

##

neterror-pref-reset = Parece que su configuración de seguridad de red podría estar causando esto. ¿Quiere restaurar la configuración predeterminada?
neterror-error-reporting-automatic = Informar de errores como esto ayuda a { -vendor-short-name } a identificar y bloquear sitios maliciosos

## Specific error messages

neterror-generic-error = { -brand-short-name } no puede cargar esta página por alguna razón.
neterror-load-error-try-again = El sitio podría estar no disponible temporalmente o demasiado ocupado. Vuelva a intentarlo en unos momentos.
neterror-load-error-connection = Si no puede cargar ninguna página, compruebe la conexión de red de su equipo.
neterror-load-error-firewall = Si su equipo o red están protegidos por un cortafuegos o proxy, asegúrese de que { -brand-short-name } tiene permiso para acceder a la web.
neterror-captive-portal = Debe iniciar sesión en esta red antes de que pueda acceder a Internet.
# Variables:
# $hostAndPath (String) - a suggested site (e.g. "www.example.com") that the user may have meant instead.
neterror-dns-not-found-with-suggestion = ¿Quería ir a <a data-l10n-name="website">{ $hostAndPath }</a>?
neterror-dns-not-found-hint-header = <strong>Si escribió la dirección correcta, puede:</strong>
neterror-dns-not-found-hint-try-again = Probar de nuevo más tarde
neterror-dns-not-found-hint-check-network = Verificar la conexión a internet
neterror-dns-not-found-hint-firewall = Comprobar que { -brand-short-name } tiene permiso para acceder a la web (puede ser que esté conectado pero detrás de un firewall)

## TRR-only specific messages
## Variables:
##   $hostname (String) - Hostname of the website to which the user was trying to connect.
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-trr-only-reason = { -brand-short-name } no puede proteger su solicitud de la dirección de este sitio a través de nuestro sistema de resolución de DNS de confianza. Éste es el motivo:
neterror-dns-not-found-trr-third-party-warning2 = Puede continuar con su servicio de DNS predeterminado. Sin embargo, un tercero podría ser capaz de ver los sitios web que visite.
neterror-dns-not-found-trr-only-could-not-connect = { -brand-short-name } no se ha podido conectar a { $trrDomain }
neterror-dns-not-found-trr-only-timeout = La conexión a { $trrDomain } ha necesitado más tiempo de lo esperado.
neterror-dns-not-found-trr-offline = No está conectado a Internet.
neterror-dns-not-found-trr-unknown-host2 = Este sitio web no fue encontrado por { $trrDomain }.
neterror-dns-not-found-trr-server-problem = Ha habido un problema con { $trrDomain }.
neterror-dns-not-found-bad-trr-url = URL no válida.
neterror-dns-not-found-trr-unknown-problem = Problema inesperado.

## Native fallback specific messages
## Variables:
##   $trrDomain (String) - Hostname of the DNS over HTTPS server that is currently in use.

neterror-dns-not-found-native-fallback-reason = { -brand-short-name } no puede proteger su solicitud de la dirección de este sitio a través de nuestro sistema de resolución de DNS de confianza. Éste es el motivo:
neterror-dns-not-found-native-fallback-heuristic = DNS sobre HTTPS ha sido desactivado en su red.
neterror-dns-not-found-native-fallback-not-confirmed2 = { -brand-short-name } no se ha podido conectar a { $trrDomain }

##

neterror-file-not-found-filename = Compruebe que el nombre de archivo no tiene errores de escritura, incluyendo el uso de mayúsculas.
neterror-file-not-found-moved = Compruebe si el archivo ha sido movido, renombrado o eliminado.
neterror-access-denied = Puede haber sido eliminado, movido o sus permisos de archivo pueden estar impidiendo el acceso al mismo.
neterror-unknown-protocol = Podría necesitar instalar otro software para abrir esta dirección.
neterror-redirect-loop = Este problema a veces está causado por desactivar o rechazar la recepción de cookies.
neterror-unknown-socket-type-psm-installed = Compruebe que su sistema tiene el administrador personal de seguridad instalado.
neterror-unknown-socket-type-server-config = Esto podría deberse a una configuración no estándar en el servidor.
neterror-not-cached-intro = El documento requerido ya no está disponible en la caché de { -brand-short-name }.
neterror-not-cached-sensitive = Como precaución de seguridad, { -brand-short-name } no vuelve a pedir automáticamente documentos sensibles.
neterror-not-cached-try-again = Haga clic en Reintentar para volver a pedir el documento del sitio web.
neterror-net-offline = Presione “Probar de nuevo” para cambiar al modo con conexión y recargar la página.
neterror-proxy-resolve-failure-settings = Compruebe la configuración de proxy para asegurarse de que es correcta.
neterror-proxy-resolve-failure-connection = Compruebe que su equipo tiene una conexión de red operativa.
neterror-proxy-resolve-failure-firewall = Si su equipo o red está protegida por un cortafuegos o proxy, asegúrese de que { -brand-short-name } tiene permiso para acceder a la web.
neterror-proxy-connect-failure-settings = Compruebe la configuración de proxy para asegurarse de que es correcta.
neterror-proxy-connect-failure-contact-admin = Contacte con su administrador de red para asegurarse de que el servidor proxy está funcionando.
neterror-content-encoding-error = Contacte con los propietarios del sitio web para informarles de este problema.
neterror-unsafe-content-type = Contacte con los propietarios del sitio web para informarles de este problema.
neterror-nss-failure-not-verified = La página que está intentando ver no se puede mostrar porque la autenticidad de los datos recibidos no ha podido ser verificada.
neterror-nss-failure-contact-website = Contacte con los propietarios del sitio web para informarles de este problema.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-intro = { -brand-short-name } ha detectado una posible amenaza de seguridad y no ha cargado <b>{ $hostname }</b>. Si visita este sitio, los atacantes podrían intentar robar información como sus contraseñas, correos electrónicos o detalles de su tarjeta de crédito.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-sts-intro = { -brand-short-name } ha detectado una potencial amenaza de seguridad y no ha continuado a <b>{ $hostname }</b> porque este sitio web requiere una conexión segura.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-expired-cert-intro = { -brand-short-name } ha detectado un problema y no ha continuado a <b>{ $hostname }</b>. El sitio web está mal configurado o el reloj de su ordenador está configurado de manera incorrecta.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm = <b>{ $hostname }</b> probablemente es un sitio seguro, pero no se ha podido establecer una conexión segura. Este problema está causado por <b>{ $mitm }</b>, que es un programa en su ordenador o en su red.
neterror-corrupted-content-intro = La página que está intentando ver no se puede mostrar porque se ha detectado un error en la transmisión de datos.
neterror-corrupted-content-contact-website = Contacte con los propietarios del sitio web para informarles de este problema.
# Do not translate "SSL_ERROR_UNSUPPORTED_VERSION".
neterror-sslv3-used = Información avanzada: SSL_ERROR_UNSUPPORTED_VERSION
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
neterror-inadequate-security-intro = <b>{ $hostname }</b> usa tecnología de seguridad que está obsoleta y es vulnerable a ataques. Un atacante podría revelar fácilmente información que usted pensaría que es segura. El administrador del sitio web tendrá que corregir el problema antes de que se pueda visitar el sitio.
# Do not translate "NS_ERROR_NET_INADEQUATE_SECURITY".
neterror-inadequate-security-code = Código de error: NS_ERROR_NET_INADEQUATE_SECURITY
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
neterror-clock-skew-error = Su equipo piensa que la fecha y hora es { DATETIME($now, dateStyle: "medium") }, lo que evita que { -brand-short-name } se conecte de forma segura. Para visitar <b>{ $hostname }</b>, actualice el reloj de su equipo en los ajustes de su sistema a la fecha y hora actuales, y la zona horaria apropiada, y luego refresque <b>{ $hostname }</b>.
neterror-network-protocol-error-intro = La página que está intentando ver no se puede mostrar debido a un error detectado en el protocolo de red.
neterror-network-protocol-error-contact-website = Por favor, contacte con el propietario del sitio para informarle de este problema.
certerror-expired-cert-second-para = Probablemente el certificado del sitio ha expirado, lo que impide a { -brand-short-name } conectarse de forma segura. Si visita este sitio, los atacantes pueden intentar robar información como sus contraseñas, correos o datos de la tarjeta de crédito.
certerror-expired-cert-sts-second-para = Probablemente el certificado del sitio ha expirado, lo que impide a { -brand-short-name } conectarse de forma segura.
certerror-what-can-you-do-about-it-title = ¿Qué puede hacer al respecto?
certerror-unknown-issuer-what-can-you-do-about-it-website = El problema está probablemente en el sitio web, y no hay nada que pueda hacer para resolverlo.
certerror-unknown-issuer-what-can-you-do-about-it-contact-admin = Si está en una red corporativa o utilizando un antivirus, puede ponerse en contacto con el equipo de asistencia para obtener ayuda. También puede notificar el problema al administrador del sitio web.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
# $now (Date) - The current datetime, to be formatted as a date
certerror-expired-cert-what-can-you-do-about-it-clock = El reloj de su equipo está establecido en { DATETIME($now, dateStyle: "medium") }. Asegúrese de que su equipo está configurado, en los ajustes del sistema, en la fecha y hora correctas, así como la zona horaria apropiada, y luego refresque <b>{ $hostname }</b>.
certerror-expired-cert-what-can-you-do-about-it-contact-website = Si su equipo ya está configurado en la hora correcta, entonces lo más probable es que el sitio web esté mal configurado, y no hay nada que pueda hacer para resolver el problema. Puede avisar al administrador del sitio web sobre el problema.
certerror-bad-cert-domain-what-can-you-do-about-it = Lo más probable es que el problema sea con el sitio web, y no hay nada que pueda hacer para resolverlo. Puede notificar el problema al administrador del sitio web.
certerror-mitm-what-can-you-do-about-it-antivirus = Si su antivirus incluye una función que escanea conexiones cifradas (normalmente llamada “escáner web” o “escáner https”), puede desactivar esa función. Si eso no funciona, puede eliminar y volver a instalar el programa antivirus.
certerror-mitm-what-can-you-do-about-it-corporate = Si está en una red corporativa, puede ponerse en contacto con su departamento de informática.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack = Si no está familiarizado con <b>{ $mitm }</b>, entonces esto puede ser un ataque y no debería acceder al sitio.
# Variables:
# $mitm (String) - The name of the software intercepting communications between you and the website (or “man in the middle”)
certerror-mitm-what-can-you-do-about-it-attack-sts = Si no está familiarizado con <b>{ $mitm }</b>, entonces esto puede ser un ataque y no hay nada que pueda hacer para acceder al sitio.
# Variables:
# $hostname (String) - Hostname of the website to which the user was trying to connect.
certerror-what-should-i-do-bad-sts-cert-explanation = <b>{ $hostname }</b> tiene una política de seguridad llamada HTTP Strict Transport Security (HSTS), que significa que { -brand-short-name } solo puede conectarse a él de forma segura. No puede añadir una excepción para visitar este sitio.
