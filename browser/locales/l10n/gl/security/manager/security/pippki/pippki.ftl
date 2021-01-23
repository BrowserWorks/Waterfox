# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Medidor de calidade de contrasinais

## Change Password dialog

change-password-window =
    .title = Mudar o contrasinal principal
change-device-password-window =
    .title = Cambiar o contrasinal
# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Dispositivo de seguranza: { $tokenName }
change-password-old = Contrasinal actual:
change-password-new = Novo contrasinal:
change-password-reenter = Novo contrasinal (outra vez):

## Reset Password dialog

reset-password-window =
    .title = Restabelecer o contrasinal principal
    .style = width: 40em
pippki-failed-pw-change = Non foi posíbel cambiar o contrasinal.
pippki-incorrect-pw = Non introduciu o contrasinal actual correcto. Por favor, inténteo de novo.
pippki-pw-change-ok = Cambiouse correctamente o contrasinal.
pippki-pw-empty-warning = Non se protexerán os seus contrasinais e chaves privadas almacenadas.
pippki-pw-erased-ok = Eliminou o seu contrasinal. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Advertencia! Decidiu non usar un contrasinal. { pippki-pw-empty-warning }
pippki-pw-change2empty-in-fips-mode = Actualmente está en modo FIPS. FIPS require un contrasinal non baleiro.

## Reset Primary Password dialog

reset-primary-password-window =
    .title = Restablecer contrasinal principal
    .style = width: 40em
reset-password-button-label =
    .label = Restabelecer
reset-password-text = Se restabelece o contrasinal principal esqueceranse os contrasinais de web e correo electrónico, os datos dos formularios, os certificados persoais e as chaves privadas que estean almacenados. Confirma que quere restabelecelo?
reset-primary-password-text = Se restablece o seu contrasinal principal, esqueceranse todos os seus contrasinais de correo electrónico e correo electrónico, certificados persoais e chaves privadas. Confirma que desexa restablecer o seu contrasinal principal?
pippki-reset-password-confirmation-title = Restablecer contrasinal principal
pippki-reset-password-confirmation-message = Restableceuse o seu contrasinal principal.

## Downloading cert dialog

download-cert-window =
    .title = Descargando certificado
    .style = width: 46em
download-cert-message = Solicitouse que confíe nunha nova entidade de acreditación (AC).
download-cert-trust-ssl =
    .label = Confiar nesta AC para identificar sitios web.
download-cert-trust-email =
    .label = Confiar nesta AC para identificar usuarios de correo electrónico.
download-cert-message-desc = Antes de confiar nesta AC para calquera finalidade, debería examinar o seu certificado e a súa política e procedementos (se están dispoñíbeis).
download-cert-view-cert =
    .label = Ver
download-cert-view-text = Examinar o certificado da AC

## Client Authorization Ask dialog

client-auth-window =
    .title = Solicitude de identificación de usuario
client-auth-site-description = Este sitio solicitou que se identifique cun certificado:
client-auth-choose-cert = Escolla un certificado para presentar como identificación:
client-auth-cert-details = Detalles do certificado seleccionado:

## Set password (p12) dialog

set-password-window =
    .title = Escolla un contrasinal para a copia de seguranza do certificado
set-password-message = O contrasinal da copia de seguranza do certificado protexe o ficheiro que vai crear. Estabeleza ese contrasinal para realizar a copia de seguranza.
set-password-backup-pw =
    .value = Contrasinal da copia de seguranza do certificado:
set-password-repeat-backup-pw =
    .value = Contrasinal da copia de seguranza do certificado (outra vez):
set-password-reminder = Importante: Se esquece o contrasinal da copia de seguranza do certificado non poderá restaurar esa copia. Gárdeo nun lugar seguro.

## Protected Auth dialog

protected-auth-window =
    .title = Autenticación protexida da chave electrónica
protected-auth-msg = Autentíquese coa chave electrónica. O método de autenticación depende do tipo da súa chave electrónica.
protected-auth-token = Chave electrónica:
