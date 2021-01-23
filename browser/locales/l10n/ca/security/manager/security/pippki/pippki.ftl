# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Avaluador de qualitat de la contrasenya

## Change Password dialog

change-password-window =
    .title = Canvia la contrasenya mestra

change-device-password-window =
    .title = Canvia la contrasenya

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Dispositiu de seguretat: { $tokenName }
change-password-old = Contrasenya actual:
change-password-new = Contrasenya nova:
change-password-reenter = Contrasenya nova (un altre cop):

## Reset Password dialog

reset-password-window =
    .title = Reinicia la contrasenya mestra
    .style = width: 40em

pippki-failed-pw-change = No s'ha pogut canviar la contrasenya.
pippki-incorrect-pw = No heu introduït la contrasenya actual correcta. Torneu-ho a provar.
pippki-pw-change-ok = La contrasenya s'ha canviat correctament.

pippki-pw-empty-warning = Les contrasenyes i claus privades que deseu no estaran protegides.
pippki-pw-erased-ok = Heu suprimit la vostra contrasenya. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Avís! Heu decidit no utilitzar cap contrasenya. { pippki-pw-empty-warning }

pippki-pw-change2empty-in-fips-mode = Us trobeu en mode FIPS. El FIPS requereix una contrasenya que no sigui buida.

## Reset Primary Password dialog

reset-primary-password-window =
    .title = Reinicia la contrasenya principal
    .style = width: 40em
reset-password-button-label =
    .label = Reinicia
reset-password-text = Si reinicieu la vostra contrasenya mestra, totes les vostres contrasenyes de web i de correu electrònic, les dades dels formularis, els certificats personals i les claus privades emmagatzemades es perdran. Esteu segur que voleu reiniciar la vostra contrasenya mestra?

reset-primary-password-text = Si reinicieu la vostra contrasenya principal, totes les vostres contrasenyes de web i de correu electrònic, els certificats personals i les claus privades emmagatzemades es perdran. Esteu segur que voleu reiniciar la vostra contrasenya principal?

pippki-reset-password-confirmation-title = Reinicia la contrasenya principal
pippki-reset-password-confirmation-message = S'ha reiniciat la vostra contrasenya principal.

## Downloading cert dialog

download-cert-window =
    .title = Baixada de certificats
    .style = width: 46em
download-cert-message = Se us ha demanat que confieu en una entitat certificadora (CA) nova.
download-cert-trust-ssl =
    .label = Confia en aquesta CA per identificar llocs web.
download-cert-trust-email =
    .label = Confia en aquesta CA per identificar usuaris de correu electrònic.
download-cert-message-desc = Abans de confiar en aquesta CA amb qualsevol finalitat, cal que n'examineu el certificat i les polítiques i procediments (si estan disponibles).
download-cert-view-cert =
    .label = Visualitza
download-cert-view-text = Examina el certificat de la CA

## Client Authorization Ask dialog

client-auth-window =
    .title = Sol·licitud d'identificació de l'usuari
client-auth-site-description = Aquest lloc ha sol·licitat que us identifiqueu amb un certificat:
client-auth-choose-cert = Trieu un certificat per presentar-lo com a identificació:
client-auth-cert-details = Detalls del certificat seleccionat:

## Set password (p12) dialog

set-password-window =
    .title = Trieu una contrasenya per a la còpia de seguretat del certificat
set-password-message = La contrasenya per a la còpia de seguretat del certificat que definiu aquí protegeix el fitxer de còpia de seguretat que ara creareu. Heu de definir-la per seguir amb la còpia de seguretat.
set-password-backup-pw =
    .value = Contrasenya de la còpia de seguretat del certificat:
set-password-repeat-backup-pw =
    .value = Contrasenya de la còpia de seguretat del certificat (un altre cop):
set-password-reminder = Important: si oblideu la contrasenya de la còpia de seguretat del certificat no podreu recuperar-la més endavant. Deseu-la en un lloc segur.

## Protected Auth dialog

protected-auth-window =
    .title = Autenticació de testimoni protegit
protected-auth-msg = Autentiqueu al testimoni. El mètode d'autenticació depèn del tipus del vostre testimoni.
protected-auth-token = Testimoni:
