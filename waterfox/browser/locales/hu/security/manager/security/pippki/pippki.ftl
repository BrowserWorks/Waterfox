# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Jelszó minősége

## Change Password dialog

change-device-password-window =
    .title = Jelszó módosítása
# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Adatvédelmi eszköz: { $tokenName }
change-password-old = Jelenlegi jelszó:
change-password-new = Új jelszó:
change-password-reenter = Új jelszó (ismét):
pippki-failed-pw-change = Nem sikerült megváltoztatni a jelszót.
pippki-incorrect-pw = Nem helyesen adta meg a jelenlegi jelszót. Próbálja újra.
pippki-pw-change-ok = A jelszó megváltoztatása sikeres.
pippki-pw-empty-warning = A tárolt jelszavai és privát kulcsai nem lesznek védve.
pippki-pw-erased-ok = Törölte a jelszót. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Figyelem! Úgy döntött, hogy nem használ jelszót. { pippki-pw-empty-warning }
pippki-pw-change2empty-in-fips-mode = Jelenleg FIPS-módban van. A FIPS-hez kötelező nem üres jelszót megadni.

## Reset Primary Password dialog

reset-primary-password-window2 =
    .title = Elsődleges jelszó visszaállítása
    .style = min-width: 40em
reset-password-button-label =
    .label = Alaphelyzet
reset-primary-password-text = Ha visszaállítja az elsődleges jelszót, akkor minden tárolt webes és e-mail-jelszó, űrlapadat, valamint személyes tanúsítvány és privát kulcs elvész. Biztos, hogy visszaállítja az elsődleges jelszót?
pippki-reset-password-confirmation-title = Elsődleges jelszó visszaállítása
pippki-reset-password-confirmation-message = Az elsődleges jelszó vissza lett állítva.

## Downloading cert dialog

download-cert-window2 =
    .title = Tanúsítvány letöltése
    .style = min-width: 46em
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


## Client Authentication Ask dialog

client-auth-window =
    .title = Felhasználóazonosítási kérelem
client-auth-site-description = A webhely azt kéri, hogy igazolja magát egy tanúsítvánnyal:
client-auth-choose-cert = Válassza ki az azonosításhoz használandó tanúsítványt:
client-auth-send-no-certificate =
    .label = Ne küldjön tanúsítványt
# Variables:
# $hostname (String) - The domain name of the site requesting the client authentication certificate
client-auth-site-identification = A(z) „{ $hostname }” azt kéri, hogy igazolja magát egy tanúsítvánnyal:
client-auth-cert-details = A kijelölt tanúsítvány részletei:
# Variables:
# $issuedTo (String) - The subject common name of the currently-selected client authentication certificate
client-auth-cert-details-issued-to = Kiadva ennek: { $issuedTo }
# Variables:
# $serialNumber (String) - The serial number of the certificate (hexadecimal of the form "AA:BB:...")
client-auth-cert-details-serial-number = Sorozatszám: { $serialNumber }
# Variables:
# $notBefore (String) - The date before which the certificate is not valid (e.g. Apr 21, 2023, 1:47:53 PM UTC)
# $notAfter (String) - The date after which the certificate is not valid
client-auth-cert-details-validity-period = Érvényes ettől: { $notBefore } eddig: { $notAfter }
# Variables:
# $keyUsages (String) - A list of already-localized key usages for which the certificate may be used
client-auth-cert-details-key-usages = Kulcs használható: { $keyUsages }
# Variables:
# $emailAddresses (String) - A list of email addresses present in the certificate
client-auth-cert-details-email-addresses = E-mail címek: { $emailAddresses }
# Variables:
# $issuedBy (String) - The issuer common name of the certificate
client-auth-cert-details-issued-by = Kibocsátó: { $issuedBy }
# Variables:
# $storedOn (String) - The name of the token holding the certificate (for example, "OS Client Cert Token (Modern)")
client-auth-cert-details-stored-on = Tárolva ezen: { $storedOn }
client-auth-cert-remember-box =
    .label = A döntés megjegyzése

## Set password (p12) dialog

set-password-window =
    .title = Tanúsítványok biztonsági mentésének jelszava
set-password-message = A tanúsítványok biztonsági mentésének jelszava arra szolgál, hogy védje a most létrehozandó mentésfájlt.  A folytatáshoz meg kell adni a jelszót.
set-password-backup-pw =
    .value = Jelszó:
set-password-repeat-backup-pw =
    .value = Jelszó (ismét):
set-password-reminder = Fontos: Ha elfelejti a tanúsítványokról készült biztonsági mentéshez használt jelszót, nem fogja tudni visszaállítani a tanúsítványokat a mentésből.  Írja fel biztonságos helyre.

## Protected authentication alert

# Variables:
# $tokenName (String) - The name of the token to authenticate to (for example, "OS Client Cert Token (Modern)")
protected-auth-alert = Hitelesítsen a(z) „{ $tokenName }” tokennel. Ennek módja a tokentől függ (például ujjlenyomat-olvasó használata vagy kód beírása billentyűzettel).
