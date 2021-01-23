# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Pasahitz kalitatearen neurgailua

## Change Password dialog

change-password-window =
    .title = Aldatu pasahitz nagusia

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Segurtasun-gailua: { $tokenName }
change-password-old = Uneko pasahitza:
change-password-new = Pasahitz berria:
change-password-reenter = Pasahitz berria (berriro):

## Reset Password dialog

reset-password-window =
    .title = Berrezarri pasahitz nagusia
    .style = width: 40em

## Reset Primary Password dialog

reset-password-button-label =
    .label = Berezarri
reset-password-text = Pasahitz nagusia berrezartzen baduzu, gordeta dituzun webetako eta epostetako pasahitzak, inprimaki datuak, ziurtagiri pertsonalak eta gako pribatuak ahaztu egingo dira. Ziur zaude pasahitz nagusia berrezarri nahi duzula?

## Downloading cert dialog

download-cert-window =
    .title = Ziurtagiria deskargatzen
    .style = width: 46em
download-cert-message = Autoritate ziurtagiri (AZ) berri batez fidatzeko eskatu zaizu.
download-cert-trust-ssl =
    .label = Fidatu AZ honetaz webguneak identifikatzeko.
download-cert-trust-email =
    .label = Fidatu AZ honetaz e-posta erabiltzaileak identifikatzeko.
download-cert-message-desc = Edozein xedetarako AZ honetaz fidatu aurretik, bere ziurtagiria eta bere gidalerroak eta prozedurak (eskuragarri badaude) aztertu behar dituzu.
download-cert-view-cert =
    .label = Ikusi
download-cert-view-text = Aztertu AZren ziurtagiriak

## Client Authorization Ask dialog

client-auth-window =
    .title = Erabiltzaile identifikazioaren eskaera
client-auth-site-description = Gune honek zeure burua ziurtagiri batez identifikatzeko eskatu dizu:
client-auth-choose-cert = Aukeratu ziurtagiri bat identifikazio gisa aurkezteko:
client-auth-cert-details = Hautatutako ziurtagiriaren xehetasunak:

## Set password (p12) dialog

set-password-window =
    .title = Aukeratu ziurtagiri babeskopiaren pasahitza
set-password-message = Hemen ezarritako ziurtagiriaren babeskopiak sortu behar duzun babeskopia babestuko du.  Pasahitz hori ezarri behar duzu babeskopiarekin jarraitzeko.
set-password-backup-pw =
    .value = Ziurtagiri babeskopiaren pasahitza:
set-password-repeat-backup-pw =
    .value = Ziurtagiri babeskopiaren pasahitza (berriro):
set-password-reminder = Garrantzizkoa: Ziurtagiri-babeskopiaren pasahitza ahazten bazaizu, ezin izango duzu geroago babeskopia hori berreskuratu.  Gorde ezazu leku seguru batean.

## Protected Auth dialog

protected-auth-window =
    .title = Babesturiko token autentifikazioa
protected-auth-msg = Mesedez token-ean autentifikatu. Autentifikazio metodoa token moetaren arabera aldatzen da.
protected-auth-token = Token-a:
