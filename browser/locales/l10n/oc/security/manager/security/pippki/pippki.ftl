# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Mesura de la qualitat del senhal

## Change Password dialog

change-password-window =
    .title = Modificar lo senhal principal

change-device-password-window =
    .title = Cambiar lo senhal

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Periferic de seguretat: { $tokenName }
change-password-old = Senhal actual :
change-password-new = Picatz lo senhal actual :
change-password-reenter = Tornatz picatz lo senhal :

## Reset Password dialog

reset-password-window =
    .title = Tornar inicializar lo senhal principal
    .style = width: 40em

pippki-failed-pw-change = Cambiament del senhal impossible.
pippki-incorrect-pw = Avètz pas picat lo senhal principal actual corrècte. Tornatz ensajar.
pippki-pw-change-ok = Senhal corrèctament modificat.

pippki-pw-empty-warning = Los senhals e claus privadas seràn pas protegidas.
pippki-pw-erased-ok = Avètz suprimit vòstre senhal principal. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Atencion ! Avètz decidit d'utilizar pas de senhal principal. { pippki-pw-empty-warning }

pippki-pw-change2empty-in-fips-mode = Actualament, sètz en mòde FIPS. Lo mòde FIPS necessita un senhal principal pas void.

## Reset Primary Password dialog

reset-primary-password-window =
    .title = Reïnicializar lo senhal principal
    .style = width: 40em
reset-password-button-label =
    .label = Escafar
reset-password-text = S'escafatz vòstre senhal principal, totes vòstres senhals Web e corrièr, vòstras donadas de formularis, vòstres certificats personals e vòstras claus privadas seràn doblidats. Volètz vertadièrament suprimir lo senhal principal ?

reset-primary-password-text = Se reïnicializatz vòstre senhal principal, totes vòstres senhals e email salvats, certificats personals e vòstras claus privadas seràn oblidats. Volètz vertadièrament suprimir lo senhal principal ?

pippki-reset-password-confirmation-title = Reïnicializar lo senhal principal
pippki-reset-password-confirmation-message = Vòstre senhal es estat reïnicializat.

## Downloading cert dialog

download-cert-window =
    .title = Telecargament del certificat
    .style = width: 46em
download-cert-message = Se vos a demandat de confirmar una autoritat de certificacion novèla (AC).
download-cert-trust-ssl =
    .label = Confirmar aquesta AC per identificar de sites Web.
download-cert-trust-email =
    .label = Confirmar aquesta AC per identificar los utilizaires de corrièr.
download-cert-message-desc = Abans de confirmar aquesta AC per quina rason que siá, la deuriatz examinar, ela, sos metòdes e sas proceduras (se possible).
download-cert-view-cert =
    .label = Veire
download-cert-view-text = Examinar lo certificat d'AC

## Client Authorization Ask dialog

client-auth-window =
    .title = Requèsta d'identificacion d'utilizaire
client-auth-site-description = Aqueste sit vos demanda de vos identificar amb un certificat de seguretat :
client-auth-choose-cert = Causir un certificat de presentar coma identificacion :
client-auth-cert-details = Detalhs del certificat seleccionat :

## Set password (p12) dialog

set-password-window =
    .title = Causir un senhal de salvament del certificat
set-password-message = Lo senhal de salvament del certificat que venètz de definir protegís lo fichièr de salvamanet qu'anatz crear. Vos cal balhar lo senhal per començar aqueste salvament.
set-password-backup-pw =
    .value = Senhal de salvament del certificat :
set-password-repeat-backup-pw =
    .value = Senhal de salvament del certificat (encara) :
set-password-reminder = Important : s'avètz oblidat vòstre senhal de seguretat, poiretz pas mai importar aquesta salvagarda mai tard. Conservatz-lo en luòc segur.

## Protected Auth dialog

protected-auth-window =
    .title = Autentificacion protegida per geton
protected-auth-msg = Autentificatz-vos al geton. Lo metòde d'autentificacion depen del tipe de vòstre geton.
protected-auth-token = Geton :
