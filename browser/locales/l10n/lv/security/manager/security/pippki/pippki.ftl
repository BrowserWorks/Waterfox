# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Paroles kvalitātes mērītājs

## Change Password dialog

change-password-window =
    .title = Mainīt galveno paroli

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Drošības ierīce: { $tokenName }
change-password-old = Pašreizējā parole:
change-password-new = Jaunā parole:
change-password-reenter = Jaunā parole (vēlreiz):

## Reset Password dialog

reset-password-window =
    .title = Atstatīt galveno paroli
    .style = width: 40em

## Reset Primary Password dialog

reset-password-button-label =
    .label = Atstatīt
reset-password-text = Ja atstatīsiet galveno paroli, tiks aizmirstas visas saglabātās tīmekļa un e-pasta paroles, formu dati, personīgie sertifikāti un privātās atslēgas.  Vai esat pārliecināts, ka vēlaties atstatīt galveno paroli?

## Downloading cert dialog

download-cert-window =
    .title = Lejupielādē sertifikātus
    .style = width: 46em
download-cert-message = Jums tiek vaicāts uzticēties jaunai Sertifikātu Autoritātei (CA).
download-cert-trust-ssl =
    .label = Uzticēties šai CA tīmekļa vietņu identificēšanai.
download-cert-trust-email =
    .label = Uzticēties šai CA epasta lietotāju identificēšanai.
download-cert-message-desc = Pirms uzticaties šai CA jebkādam mērķim, jums vajadzētu izpētīt tās sertifikātu un (ja pieejams) tās sertifikātu izsniegšanas politiku un procedūras.
download-cert-view-cert =
    .label = Apskatīt
download-cert-view-text = Apskatīt CA sertifikātu

## Client Authorization Ask dialog

client-auth-window =
    .title = Lietotāja identifikācijas pieprasījums
client-auth-site-description = Šī vietne pieprasīja, lai jūs identificētu sevi ar sertifikātu:
client-auth-choose-cert = Izvēlieties sertifikātu, ar kuru identificēt sevi:
client-auth-cert-details = Izvēlētā sertifikāta detaļas:

## Set password (p12) dialog

set-password-window =
    .title = Izvēlieties sertifikāta rezerves kopijas paroli
set-password-message = Sertifikāta rezerves kopijas parole aizsargās izveidoto rezerves kopijas failu. Lai turpinātu obligāti jāievada parole.
set-password-backup-pw =
    .value = Sertifikāta rezerves kopijas parole:
set-password-repeat-backup-pw =
    .value = Sertifikāta rezerves kopijas parole (vēlreiz):
set-password-reminder = Svarīgi: Ja aizmirsīsiet šo paroli, nevarēsiet atjaunot šo rezerves kopiju. Lūdzu saglabājiet to drošā vietā.

## Protected Auth dialog

protected-auth-window =
    .title = Aizsargātas marķierierīces autentificēšana
protected-auth-msg = Lūdzu autentificējiet marķierierīci. Autentificēšanas metode atkarīga no ierīces tipa.
protected-auth-token = Marķierieīce:
