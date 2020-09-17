# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Indicatorul de calitate a parolei

## Change Password dialog

change-password-window =
    .title = Schimbă parola generală

change-device-password-window =
    .title = Schimbă parola

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Dispozitiv de securitate: { $tokenName }
change-password-old = Parola actuală:
change-password-new = Parola nouă:
change-password-reenter = Parola nouă (din nou):

## Reset Password dialog

reset-password-window =
    .title = Resetare parolă generală
    .style = width: 40em

pippki-failed-pw-change = Parola nu a putut fi modificată.
pippki-incorrect-pw = Nu ai introdus corect parola curentă. Te rugăm să încerci din nou.
pippki-pw-change-ok = Parola a fost schimbată cu succes.

pippki-pw-empty-warning = Parolele și cheile private salvate nu vor fi protejate.
pippki-pw-erased-ok = Ți-ai șters parola. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Avertisment! Ai decis să nu folosești o parolă. { pippki-pw-empty-warning }

pippki-pw-change2empty-in-fips-mode = Acum ești în modul FIPS. FIPS necesită existența unei parole.

## Reset Primary Password dialog

reset-primary-password-window =
    .title = Resetează parola primară
    .style = width: 40em
reset-password-button-label =
    .label = Resetează
reset-password-text = Dacă resetezi parola generală, toate parolele de la site-urile web și conturile de e-mail pe care le-ai memorat, precum și datele formularelor, certificatele personale și cheile private, vor fi pierdute. Sigur vrei să resetezi parola generală?

reset-primary-password-text = Dacă îți resetezi parola primară, toate parolele tale salvate de web și de e-mail, certificatele personale și cheile private vor fi uitate. Sigur vrei să îți resetezi parola primară?

pippki-reset-password-confirmation-title = Resetează parola primară
pippki-reset-password-confirmation-message = Parola primară a fost resetată.

## Downloading cert dialog

download-cert-window =
    .title = Descărcare certificat
    .style = width: 46em
download-cert-message = Vi se cere să acreditați o autoritate nouă de certificare (AC).
download-cert-trust-ssl =
    .label = Acreditează această AC pentru identificarea site-urilor web.
download-cert-trust-email =
    .label = Acreditează această AC pentru identificarea utilizatorilor de e-mail.
download-cert-message-desc = Înainte de a acredita această AC, ar trebui să îi examinați certificatul, precum și politicile și procedurile (dacă există).
download-cert-view-cert =
    .label = Vizualizează
download-cert-view-text = Examinează certificatul AC

## Client Authorization Ask dialog

client-auth-window =
    .title = Cerere identificare utilizator
client-auth-site-description = Acest site îți cere să te identifici cu un certificat:
client-auth-choose-cert = Alege un certificat care să fie prezentat drept identificare:
client-auth-cert-details = Detaliile certificatului selectat:

## Set password (p12) dialog

set-password-window =
    .title = Alege o parolă de siguranță pentru certificate
set-password-message = Parola pe care o setezi aici protejează fișierul de siguranță pe care ești pe cale să-l creezi.  Trebuie să setezi această parolă pentru a continua salvarea de siguranță.
set-password-backup-pw =
    .value = Parola de siguranță pentru certificate:
set-password-repeat-backup-pw =
    .value = Parola de siguranță pentru certificate (din nou):
set-password-reminder = Important: Dacă uiți parola de siguranță pentru certificate, nu vei putea reface această copie mai târziu.  Te rugăm să ai grijă să o păstrezi într-un loc sigur.

## Protected Auth dialog

protected-auth-window =
    .title = Autentificare prin jeton protejat
protected-auth-msg = Te rugăm te autentifici cu cod. Metoda de autentificare depinde de tipul codului tău.
protected-auth-token = Cod:
