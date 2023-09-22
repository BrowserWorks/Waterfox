# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Medidor de calidad de la contraseña

## Change Password dialog

change-device-password-window =
    .title = Cambiar contraseña
# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Dispositivo de seguridad: { $tokenName }
change-password-old = Contraseña actual:
change-password-new = Nueva contraseña:
change-password-reenter = Nueva contraseña (confirmar):
pippki-failed-pw-change = No se puede cambiar la contraseña.
pippki-incorrect-pw = No ha introducido la actual contraseña maestra correctamente. Vuelva a intentarlo.
pippki-pw-change-ok = Contraseña cambiada correctamente.
pippki-pw-empty-warning = Sus contraseñas almacenadas y claves privadas no estarán protegidas.
pippki-pw-erased-ok = Ha eliminado su contraseña. { pippki-pw-empty-warning }
pippki-pw-not-wanted = ¡Atención! Ha decidido no utilizar una contraseña. { pippki-pw-empty-warning }
pippki-pw-change2empty-in-fips-mode = En este momento está en modo FIPS. FIPS requiere una contraseña no vacía.

## Reset Primary Password dialog

reset-primary-password-window2 =
    .title = Restablecer la contraseña maestra
    .style = min-width: 40em
reset-password-button-label =
    .label = Restablecer
reset-primary-password-text = Si restablece su contraseña maestra, se olvidarán todas las contraseñas de webs, correo electrónico, certificados personales y llaves privadas almacenadas. ¿Está seguro de que quiere restablecer su contraseña maestra?
pippki-reset-password-confirmation-title = Restablecer la contraseña maestra
pippki-reset-password-confirmation-message = Se ha restablecido su contraseña maestra.

## Downloading cert dialog

download-cert-window2 =
    .title = Descargando certificado
    .style = min-width: 46em
download-cert-message = Se le ha pedido que confíe en una nueva Autoridad Certificadora (CA).
download-cert-trust-ssl =
    .label = Confiar en esta CA para identificar sitios web.
download-cert-trust-email =
    .label = Confiar en esta CA para identificar usuarios de correo.
download-cert-message-desc = Antes de confiar en esta CA para cualquier propósito, debe examinar el certificado, política y procedimientos de la CA (si están disponibles).
download-cert-view-cert =
    .label = Ver
download-cert-view-text = Examinar certificado de CA

## Client Authorization Ask dialog


## Client Authentication Ask dialog

client-auth-window =
    .title = Petición de identificación de usuario
client-auth-site-description = El siguiente sitio ha pedido que usted se identifique con un certificado:
client-auth-choose-cert = Elija un certificado para presentarlo como identificación:
client-auth-send-no-certificate =
    .label = No enviar un certificado
# Variables:
# $hostname (String) - The domain name of the site requesting the client authentication certificate
client-auth-site-identification = “{ $hostname }” ha pedido que se identifique con un certificado:
client-auth-cert-details = Detalles del certificado seleccionado:
# Variables:
# $issuedTo (String) - The subject common name of the currently-selected client authentication certificate
client-auth-cert-details-issued-to = Emitido para: { $issuedTo }
# Variables:
# $serialNumber (String) - The serial number of the certificate (hexadecimal of the form "AA:BB:...")
client-auth-cert-details-serial-number = Número de serie: { $serialNumber }
# Variables:
# $notBefore (String) - The date before which the certificate is not valid (e.g. Apr 21, 2023, 1:47:53 PM UTC)
# $notAfter (String) - The date after which the certificate is not valid
client-auth-cert-details-validity-period = Válido de { $notBefore } a { $notAfter }
# Variables:
# $keyUsages (String) - A list of already-localized key usages for which the certificate may be used
client-auth-cert-details-key-usages = Usos de la clave: { $keyUsages }
# Variables:
# $emailAddresses (String) - A list of email addresses present in the certificate
client-auth-cert-details-email-addresses = Direcciones de correo: { $emailAddresses }
# Variables:
# $issuedBy (String) - The issuer common name of the certificate
client-auth-cert-details-issued-by = Emitido por: { $issuedBy }
# Variables:
# $storedOn (String) - The name of the token holding the certificate (for example, "OS Client Cert Token (Modern)")
client-auth-cert-details-stored-on = Guardado en: { $storedOn }
client-auth-cert-remember-box =
    .label = Recordar esta decisión

## Set password (p12) dialog

set-password-window =
    .title = Elegir una contraseña de respaldo para el certificado
set-password-message = La contraseña del certificado de respaldo que ponga aquí protegerá el archivo de respaldo que está a punto de crear. Debe poner esta contraseña para proceder con la copia de respaldo.
set-password-backup-pw =
    .value = Contraseña de respaldo del certificado:
set-password-repeat-backup-pw =
    .value = Contraseña de respaldo del certificado (confirmar):
set-password-reminder = Importante: si olvida la contraseña de respaldo de su certificado, no podrá restaurar esta copia de respaldo más tarde. Guárdela en un lugar seguro.

## Protected authentication alert

# Variables:
# $tokenName (String) - The name of the token to authenticate to (for example, "OS Client Cert Token (Modern)")
protected-auth-alert = Autentíquese utilizando el token “{ $tokenName }”. Cómo hacerlo depende del token (por ejemplo, usando un lector de huellas dactilares o introducoiendo un código con un teclado).
