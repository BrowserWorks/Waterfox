# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Mjerač kvalitete lozinke

## Change Password dialog

change-password-window =
    .title = Promijeni glavnu lozinku

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Sigurnosni uređaj: { $tokenName }
change-password-old = Trenutna lozinka:
change-password-new = Nova lozinka:
change-password-reenter = Ponovo upiši novu lozinku:

## Reset Password dialog

reset-password-window =
    .title = Poništi glavnu lozinku
    .style = width: 40em

## Reset Primary Password dialog

reset-password-button-label =
    .label = Poništi
reset-password-text = Ako poništiš glavnu lozinku, zaboravit će se sve spremljene lozinke web stranica i e-pošte, te spremljeni formulari, osobni certifikati i privatni ključevi. Zaista želiš poništiti svoju glavnu lozinku?

## Downloading cert dialog

download-cert-window =
    .title = Preuzimanje certifikata
    .style = width: 46em
download-cert-message = Novo certifikacijsko tijelo (CA) traži da mu se vjeruje.
download-cert-trust-ssl =
    .label = Vjeruj ovom CA-u za identifikaciju web stranica.
download-cert-trust-email =
    .label = Vjeruj ovom CA-u za identifikaciju korisnika e-pošte.
download-cert-message-desc = Prije vjerovanju ovom CA-u za bilo koju svrhu, trebali biste ispitati njegov certifikat, politiku i procedure (ako je dostupno).
download-cert-view-cert =
    .label = Pogled
download-cert-view-text = Ispitaj CA-ov certifikat

## Client Authorization Ask dialog

client-auth-window =
    .title = Zahtjev identifikacije korisnika
client-auth-site-description = Ova stranica je zatražila da se identificirate s certifikatom:
client-auth-choose-cert = Odaberi certifikat za identifikaciju:
client-auth-cert-details = Detalji odabranog certifikata:

## Set password (p12) dialog

set-password-window =
    .title = Odaberi sigurnosnu kopiju lozinke certifikata
set-password-message = Sigurnosna kopija lozinke certifikata koju ćete ovdje postaviti štiti sigurnosnu kopiju datoteke koju ćete upravo stvoriti. Da biste nastaviti s izradom sigurnosne kopije, morate upisati lozinku.
set-password-backup-pw =
    .value = Sigurnosna kopija lozinke certifikata:
set-password-repeat-backup-pw =
    .value = Sigurnosna kopija lozinke certifikata (opet):
set-password-reminder = Važno: ako zaboraviš svoju lozinku sigurnosne kopije certifikata, kasnije nećeš moći vratiti ovu sigurnosnu kopiju. Spremi lozinku na sigurno mjesto.

## Protected Auth dialog

protected-auth-window =
    .title = Zaštićena token autentifikacija
protected-auth-msg = Autentificiraj se tokenu. Metoda autentifikacije ovisi o vrsti tvog tokena.
protected-auth-token = Token:
