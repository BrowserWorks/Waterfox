# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Mjerač kvaliteta lozinke

## Change Password dialog

change-password-window =
    .title = Promijeni glavnu lozinku

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Sigurnosni uređaj: { $tokenName }
change-password-old = Trenutna lozinka:
change-password-new = Nova lozinka:
change-password-reenter = Nova lozinka (ponovo):

## Reset Password dialog

reset-password-window =
    .title = Resetuj glavnu lozinku
    .style = width: 40em

## Reset Primary Password dialog

reset-password-button-label =
    .label = Resetuj
reset-password-text = Ako resetujete vašu glavnu lozinku, sve pohranjene web i e-mail lozinke, podaci iz formulara, lični certifikati i privatni ključevi će biti izbrisani. Jeste li sigurni da želite resetovati vašu glavnu lozinku?

## Downloading cert dialog

download-cert-window =
    .title = Preuzimam certifikate
    .style = width: 46em
download-cert-message = Upitani ste da li vjerujete novom Certifikacijskom Autoritetu (CA).
download-cert-trust-ssl =
    .label = Vjeruj ovom CA da identifikuje web stranice.
download-cert-trust-email =
    .label = Vjeruj ovom CA da identifikuje email korisnike.
download-cert-message-desc = Prije nego što potvrdite vjerodostojnost ovog CA za bilo koju svrhu, trebali biste pregledati njegove certifikate, police i procedure (ako su dostupne).
download-cert-view-cert =
    .label = Pregled
download-cert-view-text = Ispitaj CA certifikat

## Client Authorization Ask dialog

client-auth-window =
    .title = Zahtjev za identifikaciju korisnika
client-auth-site-description = Ova stranica zahtijeva od vas da se identifikujete pomoću certifikata:
client-auth-choose-cert = Izaberite certifikat koji ćete predstaviti kao identifikaciju:
client-auth-cert-details = Detalji izabranog certifikata:

## Set password (p12) dialog

set-password-window =
    .title = Izaberite lozinku backupa certifikata
set-password-message = Lozinka backupa certifikata koju podesite ovdje štiti fajl backupa koju ćete napraviti. Morate postaviti lozinku da biste nastavili sa izradom backupa.
set-password-backup-pw =
    .value = Lozinka backupa certifikata:
set-password-repeat-backup-pw =
    .value = Lozinka backupa certifikata (opet):
set-password-reminder = Važno: Ukoliko zaboravite lozinku backupa certifikata, kasnije istu nećete moći povratiti.  Molimo da lozinku spremite na sigurno mjesto.

## Protected Auth dialog

protected-auth-window =
    .title = Zaštitite znak za ovjeru vjerodostojnosti
protected-auth-msg = Molimo vas da izvršite ovjeru vjerodostojnosti znaka. Metoda ovjere vjerodostojnosti znaka ovisi o tipu vašeg znaka.
protected-auth-token = Žeton:
