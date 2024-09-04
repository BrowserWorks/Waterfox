# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Slaptažodžio kokybės matavimas

## Change Password dialog

change-device-password-window =
    .title = Keisti slaptažodį
# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Saugumo priemonė: { $tokenName }
change-password-old = Dabartinis slaptažodis:
change-password-new = Naujas slaptažodis:
change-password-reenter = Naujas slaptažodis (pakartoti):
pippki-failed-pw-change = Nepavyko pakeisti slaptažodžio.
pippki-incorrect-pw = Neteisingai surinkote dabartinį slaptažodį. Bandykite dar kartą.
pippki-pw-change-ok = Slaptažodis sėkmingai pakeistas.
pippki-pw-empty-warning = Jūsų įrašyti slaptažodžiai ir privatūs raktai nebus apsaugoti.
pippki-pw-erased-ok = Pašalinote slaptažodį. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Įspėjimas! Nusprendėte nesinaudoti pagrindiniu slaptažodžiu. { pippki-pw-empty-warning }
pippki-pw-change2empty-in-fips-mode = Šiuo metu pasirinkta FIPS veiksena. Jai reikia slaptažodžio.

## Reset Primary Password dialog

reset-primary-password-window2 =
    .title = Atšaukti pagrindinį slaptažodį
    .style = min-width: 40em
reset-password-button-label =
    .label = Atšaukti
reset-primary-password-text = Jei atšauksite pagrindinį slaptažodį, prarasite visus įrašytus svetainių ir el. pašto dėžučių slaptažodžius, liudijimus ir asmeninius raktus. Ar atšaukti?
pippki-reset-password-confirmation-title = Atšaukti pagrindinį slaptažodį
pippki-reset-password-confirmation-message = Pagrindinis slaptažodis atšauktas.

## Downloading cert dialog

download-cert-window2 =
    .title = Liudijimo atsiuntimas
    .style = min-width: 46em
download-cert-message = Jūsų prašoma nurodyti, ką patikite naujai liudijimų įstaigai (LĮ).
download-cert-trust-ssl =
    .label = Patikėti šiai LĮ paliudyti svetainių tapatumą.
download-cert-trust-email =
    .label = Patikėti šiai LĮ paliudyti el. pašto abonentų tapatumą.
download-cert-message-desc = Prieš ką nors patikint liudijimo įstaigai, reikėtų susipažinti su jos liudijimu, politika ir veikla (jei tokia galimybė yra).
download-cert-view-cert =
    .label = Peržiūra
download-cert-view-text = Susipažinti su LĮ liudijimu

## Client Authorization Ask dialog


## Client Authentication Ask dialog

client-auth-window =
    .title = Naudotojo tapatybės nustatymas
client-auth-site-description = Svetainė prašo pateikti jūsų tapatybę patvirtinantį liudijimą.
client-auth-choose-cert = Pasirinkite liudijimą tapatybei patvirtinti:
client-auth-cert-details = Išsamesnė informacija apie pasirinktą liudijimą:
# Variables:
# $issuedTo (String) - The subject common name of the currently-selected client authentication certificate
client-auth-cert-details-issued-to = Kam išduotas: „{ $issuedTo }“
# Variables:
# $serialNumber (String) - The serial number of the certificate (hexadecimal of the form "AA:BB:...")
client-auth-cert-details-serial-number = Numeris: { $serialNumber }
# Variables:
# $notBefore (String) - The date before which the certificate is not valid (e.g. Apr 21, 2023, 1:47:53 PM UTC)
# $notAfter (String) - The date after which the certificate is not valid
client-auth-cert-details-validity-period = Galioja nuo { $notBefore } iki { $notAfter }
# Variables:
# $keyUsages (String) - A list of already-localized key usages for which the certificate may be used
client-auth-cert-details-key-usages = Rakto panaudojimai: { $keyUsages }
# Variables:
# $emailAddresses (String) - A list of email addresses present in the certificate
client-auth-cert-details-email-addresses = El. pašto adresai: { $emailAddresses }
# Variables:
# $issuedBy (String) - The issuer common name of the certificate
client-auth-cert-details-issued-by = Kas išdavė: „{ $issuedBy }“
# Variables:
# $storedOn (String) - The name of the token holding the certificate (for example, "OS Client Cert Token (Modern)")
client-auth-cert-details-stored-on = Saugojimo vieta: „{ $storedOn }“
client-auth-cert-remember-box =
    .label = Įsiminti šį pasirinkimą

## Set password (p12) dialog

set-password-window =
    .title = Liudijimo atsarginės kopijos slaptažodis
set-password-message = Atsarginės kopijos slaptažodis, kurį čia įvedate, apsaugos kopijos failą, kurį ketinate sukurti. Jį reikia parinkti prieš darant atsarginę kopiją.
set-password-backup-pw =
    .value = Liudijimo atsarginės kopijos slaptažodis:
set-password-repeat-backup-pw =
    .value = Liudijimo atsarginės kopijos slaptažodis (pakartoti):
set-password-reminder = Svarbu. Jei pamiršite atsarginės kopijos slaptažodį, jo atkurti negalėsite. Todėl jį užsirašykite ir paslėpkite saugioje vietoje.

## Protected authentication alert

