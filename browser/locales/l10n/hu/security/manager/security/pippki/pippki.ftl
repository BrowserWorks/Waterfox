# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Jelszó minősége

## Change Password dialog

change-password-window =
    .title = Mesterjelszó megváltoztatása

change-device-password-window =
    .title = Jelszó módosítása

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Adatvédelmi eszköz: { $tokenName }
change-password-old = Jelenlegi jelszó:
change-password-new = Új jelszó:
change-password-reenter = Új jelszó (ismét):

## Reset Password dialog

reset-password-window =
    .title = Mesterjelszó törlése
    .style = width: 40em

pippki-failed-pw-change = Nem sikerült megváltoztatni a jelszót.
pippki-incorrect-pw = Nem helyesen adta meg a jelenlegi jelszót. Próbálja újra.
pippki-pw-change-ok = A jelszó megváltoztatása sikeres.

pippki-pw-empty-warning = A tárolt jelszavai és privát kulcsai nem lesznek védve.
pippki-pw-erased-ok = Törölte a jelszót. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Figyelem! Úgy döntött, hogy nem használ jelszót. { pippki-pw-empty-warning }

pippki-pw-change2empty-in-fips-mode = Jelenleg FIPS-módban van. A FIPS-hez kötelező nem üres jelszót megadni.

## Reset Primary Password dialog

reset-primary-password-window =
    .title = Elsődleges jelszó visszaállítása
    .style = width: 40em
reset-password-button-label =
    .label = Alaphelyzet
reset-password-text = Ha törli a mesterjelszót, minden tárolt webes és e-mail jelszó, űrlapadat, valamint a személyes tanúsítványok és a személyes kulcsok elvesznek. Biztosan törli a mesterjelszót?

reset-primary-password-text = Ha visszaállítja az elsődleges jelszót, akkor minden tárolt webes és e-mail-jelszó, űrlapadat, valamint személyes tanúsítvány és privát kulcs elvész. Biztos, hogy visszaállítja az elsődleges jelszót?

pippki-reset-password-confirmation-title = Elsődleges jelszó visszaállítása
pippki-reset-password-confirmation-message = Az elsődleges jelszó vissza lett állítva.

## Downloading cert dialog

download-cert-window =
    .title = Tanúsítvány letöltése
    .style = width: 46em
download-cert-message = Arra kérik, hogy bízzon meg egy új hitelesítésszolgáltatóban (CA-ban).
download-cert-trust-ssl =
    .label = Megbízás webhelyek azonosítására
download-cert-trust-email =
    .label = Megbízás a levelezőpartnerek azonosítására
download-cert-message-desc = Mielőtt megbízna ebben a CA-ban bármilyen célból, vizsgálja meg a tanúsítványát, valamint az irányelveit (házirendjét) és folyamatait (ha vannak ilyenek).
download-cert-view-cert =
    .label = Megjelenítés
download-cert-view-text = A CA tanúsítványának megvizsgálása

## Client Authorization Ask dialog

client-auth-window =
    .title = Felhasználóazonosítási kérelem
client-auth-site-description = A webhely azt kívánja, hogy Ön igazolja magát egy tanúsítvánnyal:
client-auth-choose-cert = Válassza ki az azonosításhoz használandó tanúsítványt:
client-auth-cert-details = A kijelölt tanúsítvány részletei:

## Set password (p12) dialog

set-password-window =
    .title = Tanúsítványok biztonsági mentésének jelszava
set-password-message = A tanúsítványok biztonsági mentésének jelszava arra szolgál, hogy védje a most létrehozandó mentésfájlt.  A folytatáshoz meg kell adni a jelszót.
set-password-backup-pw =
    .value = Jelszó:
set-password-repeat-backup-pw =
    .value = Jelszó (ismét):
set-password-reminder = Fontos: Ha elfelejti a tanúsítványokról készült biztonsági mentéshez használt jelszót, nem fogja tudni visszaállítani a tanúsítványokat a mentésből.  Írja fel biztonságos helyre.

## Protected Auth dialog

protected-auth-window =
    .title = Hitelesítés védett tokennel
protected-auth-msg = Hitelesítse magát a tokennél. A hitelesítési módszer a token típusától függ.
protected-auth-token = Token:
