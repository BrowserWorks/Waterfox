# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Mensurator de qualitate del contrasigno

## Change Password dialog

change-password-window =
    .title = Modificar le contrasigno maestro

change-device-password-window =
    .title = Cambiar contrasigno

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Dispositivo de securitate: { $tokenName }
change-password-old = Contrasigno actual:
change-password-new = Nove contrasigno:
change-password-reenter = Nove contrasigno (novemente):

## Reset Password dialog

reset-password-window =
    .title = Reinitialisar le contrasigno maestro
    .style = width: 40em

pippki-failed-pw-change = Impossibile cambiar contrasigno.
pippki-incorrect-pw = Tu non insereva le actual contrasigno correcte. Prova ancora.
pippki-pw-change-ok = Contrasigno cambiate con successo.

pippki-pw-empty-warning = Tu contrasignos e claves private reservate non essera plus protegite.
pippki-pw-erased-ok = Tu ha delite tu contrasigno. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Attention! Tu ha decidite non usar un contrasigno. { pippki-pw-empty-warning }

pippki-pw-change2empty-in-fips-mode = Tu es actualmente in modo FIPS. FIPS require un contrasigno non vacue.

## Reset Primary Password dialog

reset-primary-password-window =
    .title = Restabilir contrasigno primari
    .style = width: 40em
reset-password-button-label =
    .label = Reinitialisar
reset-password-text = Si tu reinitialisa tu contrasigno maestro, tote tu contrasignos email e web, tu datos de formularios e claves private essera oblidate. Desira tu vermente reinitialisar tu contrasigno maestro?

reset-primary-password-text = Si tu reinitialisa tu contrasigno primari, tote tu contrasignos web e email, tu certificatos personal e claves private essera oblidate. Desira tu vermente reinitialisar tu contrasigno primari?

pippki-reset-password-confirmation-title = Restabilir contrasigno primari
pippki-reset-password-confirmation-message = Tu contrasigno primari ha essite reinitialisate.

## Downloading cert dialog

download-cert-window =
    .title = Discargante certificato
    .style = width: 46em
download-cert-message = On te ha demandate confider a un nove autoritate de certification (CA).
download-cert-trust-ssl =
    .label = Confider a iste CA pro identificar sitos del web.
download-cert-trust-email =
    .label = Confider a iste CA pro identificar le usatores de email.
download-cert-message-desc = Ante confider a iste CA pro qualcunque proposito, tu debe examinar su certificato e su politica e proceduras (si disponibile).
download-cert-view-cert =
    .label = Vider
download-cert-view-text = Examinar le certificato de CA

## Client Authorization Ask dialog

client-auth-window =
    .title = Requesta de identification de usator
client-auth-site-description = Iste sito ha requestate que tu identificar te per un certificato:
client-auth-choose-cert = Elige un certificato a presentar como identification:
client-auth-cert-details = Detalios de certificato seligite:

## Set password (p12) dialog

set-password-window =
    .title = Elige un contrasigno de salveguarda de certificato
set-password-message = Le contrasigno de salveguarda del certificato que tu ha definite hic protege le file de salveguarda que tu es a crear.  Tu debe definir iste contrasigno pro proceder con le salveguarda.
set-password-backup-pw =
    .value = Contrasigno de salveguarda del certificato:
set-password-repeat-backup-pw =
    .value = Contrasigno de salveguarda del certificato (novemente):
set-password-reminder = Importante: Si tu oblida le contrasigno de tu copia de reserva del certificato, tu non potera restaurar iste copia de reserva plus tarde. Per favor guarda lo in un loco secur.

## Protected Auth dialog

protected-auth-window =
    .title = Authentication a token protegite
protected-auth-msg = Per favor authentica te al token. Le methodo de authentication depende del typo de tu token.
protected-auth-token = Token:
