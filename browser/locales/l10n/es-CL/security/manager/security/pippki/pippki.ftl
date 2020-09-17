# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Medidor de calidad de la contraseña

## Change Password dialog

change-password-window =
    .title = Cambiar la contraseña maestra

change-device-password-window =
    .title = Cambiar contraseña

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Dispositivo de seguridad: { $tokenName }
change-password-old = Contraseña actual:
change-password-new = Nueva contraseña:
change-password-reenter = Nueva contraseña (otra vez):

## Reset Password dialog

reset-password-window =
    .title = Restablecer la contraseña maestra
    .style = width: 40em

pippki-failed-pw-change = No se pudo cambiar la contraseña primaria.
pippki-incorrect-pw = No ingresaste correctamente la contraseña primaria. Por favor, vuelve a intentarlo.
pippki-pw-change-ok = La contraseña ha sido cambiada exitosamente.

pippki-pw-empty-warning = Tus contraseñas almacenadas y claves privadas no estarán protegidas.
pippki-pw-erased-ok = Has eliminado tu contraseña. { pippki-pw-empty-warning }
pippki-pw-not-wanted = ¡Advertencia! Has decidido no usar una contraseña. { pippki-pw-empty-warning }

pippki-pw-change2empty-in-fips-mode = Actualmente estás en modo FIPS. FIPS requiere de una contraseña que no esté en blanco.

## Reset Primary Password dialog

reset-primary-password-window =
    .title = Restablecer la contraseña primaria
    .style = width: 40em
reset-password-button-label =
    .label = Restablecer
reset-password-text = Si restableces tu contraseña maestra, todas las contraseñas de webs y de correo electrónico, los datos de los formularios, certificados personales y llaves privadas almacenados serán olvidados. ¿Estás seguro de que quieres restablecer tu contraseña maestra?

reset-primary-password-text = Si restableces tu contraseña primaria, todas las contraseñas de webs y de correo electrónico, certificados personales y llaves privadas almacenados serán olvidados. ¿Estás seguro de que quieres restablecer tu contraseña primaria?

pippki-reset-password-confirmation-title = Restablecer la contraseña primaria
pippki-reset-password-confirmation-message = Tu contraseña primaria ha sido restablecida.

## Downloading cert dialog

download-cert-window =
    .title = Bajando certificado
    .style = width: 46em
download-cert-message = Se te ha pedido que confíes en una nueva autoridad de certificación (CA).
download-cert-trust-ssl =
    .label = Confiar en esta CA para identificar sitios web.
download-cert-trust-email =
    .label = Confiar en este CA para identificar usuarios de email.
download-cert-message-desc = Antes de confiar en esta CA para cualquier propósito, debería examinar su certificado, su política y procedimientos (si están disponibles).
download-cert-view-cert =
    .label = Ver
download-cert-view-text = Examinar certificado CA

## Client Authorization Ask dialog

client-auth-window =
    .title = Solicitud de identificación de usuario
client-auth-site-description = Este sitio ha solicitado que te identifiques con un certificado:
client-auth-choose-cert = Elije un certificado para presentar como identificación:
client-auth-cert-details = Detalles del certificado seleccionado:

## Set password (p12) dialog

set-password-window =
    .title = Seleccione una Contraseña de Respaldo del Certificado
set-password-message = La contraseña de respaldo del certificado que establezca aquí protege el archivo de respaldo que está por crear.  Debe ingresar una contraseña para proceder con el respaldo.
set-password-backup-pw =
    .value = Contraseña de respaldo de certificado:
set-password-repeat-backup-pw =
    .value = Contraseña de respaldo de certificado (nuevamente):
set-password-reminder = Importante: Si olvida su contraseña de respaldo del certificado, no podrá restaurar el respaldo posteriormente. Por favor, guárdela en un lugar seguro.

## Protected Auth dialog

protected-auth-window =
    .title = Identificación protegida por token
protected-auth-msg = Por favor, identifíquese con el token. El método de identificación depende del tipo de su token.
protected-auth-token = Token:
