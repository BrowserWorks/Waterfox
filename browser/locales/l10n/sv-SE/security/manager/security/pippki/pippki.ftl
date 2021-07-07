# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Kvalitetsmätare för lösenord

## Change Password dialog

change-password-window =
    .title = Ändra huvudlösenord

change-device-password-window =
    .title = Ändra lösenord

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Säkerhetsenhet: { $tokenName }
change-password-old = Nuvarande lösenord:
change-password-new = Nytt lösenord:
change-password-reenter = Nytt lösenord (bekräftas):

## Reset Password dialog

reset-password-window =
    .title = Ta bort huvudlösenord
    .style = width: 40em

pippki-failed-pw-change = Det går inte att ändra lösenord.
pippki-incorrect-pw = Du angav inte rätt lösenord. Var god försök igen.
pippki-pw-change-ok = Lösenordet har ändrats.

pippki-pw-empty-warning = Dina lagrade lösenord och privata nycklar kommer inte att skyddas.
pippki-pw-erased-ok = Du har tagit bort ditt lösenord. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Varning! Du har beslutat att inte använda ett lösenord. { pippki-pw-empty-warning }

pippki-pw-change2empty-in-fips-mode = Du är för närvarande i FIPS-läge. FIPS kräver ett lösenord.

## Reset Primary Password dialog

reset-primary-password-window =
    .title = Återställ huvudlösenord
    .style = width: 40em
reset-password-button-label =
    .label = Ta bort
reset-password-text = Om du tar bort ditt huvudlösenord kommer alla dina lagrade webb- och e-postlösenord, formulärdata, personliga certifikat och hemliga nycklar att tas bort. Är du säker på att du vill ta bort ditt huvudlösenord?

reset-primary-password-text = Om du återställer ditt huvudlösenord kommer alla dina lagrade webb- och e-postlösenord, personliga certifikat och privata nycklar att glömmas. Är du säker på att du vill återställa ditt huvudlösenord?

pippki-reset-password-confirmation-title = Återställ huvudlösenord
pippki-reset-password-confirmation-message = Ditt huvudlösenord har återställts.

## Downloading cert dialog

download-cert-window =
    .title = Hämtar certifikat
    .style = width: 46em
download-cert-message = En ny Certifikatutfärdare(CA) vill ha ditt godkännande.
download-cert-trust-ssl =
    .label = Lita på denna CA för identifiering av webbplatser.
download-cert-trust-email =
    .label = Lita på denna CA för identifiering av e-postanvändare.
download-cert-message-desc = Innan du litar på denna CA för något syfte bör du undersöka dess certifikat, policy och tillvägagångssätt (om möjligt).
download-cert-view-cert =
    .label = Visa
download-cert-view-text = Undersök CA-certifikat

## Client Authorization Ask dialog

client-auth-window =
    .title = Begäran om användaridentifikation
client-auth-site-description = Denna plats har begärt att du identifierar dig med ett certifikat:
client-auth-choose-cert = Välj ett certifikat att ange som identifikation:
client-auth-cert-details = Detaljer om valt certifikat:

## Set password (p12) dialog

set-password-window =
    .title = Välj ett lösenord för certifikatets säkerhetskopia
set-password-message = Det lösenord för certifikatets säkerhetskopia som du anger här skyddar säkerhetskopian som du håller på att skapa. Du måste ange detta lösenord för att kunna fortsätta.
set-password-backup-pw =
    .value = Lösenord för certifikatets säkerhetskopia:
set-password-repeat-backup-pw =
    .value = Lösenord för certifikatets säkerhetskopia (bekräftas):
set-password-reminder = Viktigt: Om du glömmer detta lösenord kommer du inte att kunna återställa denna säkerhetskopia senare. Lagra detta lösenord på en säker plats.

## Protected Auth dialog

protected-auth-window =
    .title = Skyddad informationsbärarautentisering
protected-auth-msg = Var god autentisera till informationsbäraren. Autentiseringsmetoden beror på informationsbärarens typ.
protected-auth-token = Informationsbärare:
