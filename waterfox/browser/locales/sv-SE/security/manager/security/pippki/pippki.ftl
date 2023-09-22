# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Kvalitetsmätare för lösenord

## Change Password dialog

change-device-password-window =
    .title = Ändra lösenord
# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Säkerhetsenhet: { $tokenName }
change-password-old = Nuvarande lösenord:
change-password-new = Nytt lösenord:
change-password-reenter = Nytt lösenord (bekräftas):
pippki-failed-pw-change = Det går inte att ändra lösenord.
pippki-incorrect-pw = Du angav inte rätt lösenord. Var god försök igen.
pippki-pw-change-ok = Lösenordet har ändrats.
pippki-pw-empty-warning = Dina lagrade lösenord och privata nycklar kommer inte att skyddas.
pippki-pw-erased-ok = Du har tagit bort ditt lösenord. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Varning! Du har beslutat att inte använda ett lösenord. { pippki-pw-empty-warning }
pippki-pw-change2empty-in-fips-mode = Du är för närvarande i FIPS-läge. FIPS kräver ett lösenord.

## Reset Primary Password dialog

reset-primary-password-window2 =
    .title = Återställ huvudlösenord
    .style = min-width: 40em
reset-password-button-label =
    .label = Ta bort
reset-primary-password-text = Om du återställer ditt huvudlösenord kommer alla dina lagrade webb- och e-postlösenord, personliga certifikat och privata nycklar att glömmas. Är du säker på att du vill återställa ditt huvudlösenord?
pippki-reset-password-confirmation-title = Återställ huvudlösenord
pippki-reset-password-confirmation-message = Ditt huvudlösenord har återställts.

## Downloading cert dialog

download-cert-window2 =
    .title = Hämtar certifikat
    .style = min-width: 46em
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


## Client Authentication Ask dialog

client-auth-window =
    .title = Begäran om användaridentifikation
client-auth-site-description = Denna plats har begärt att du identifierar dig med ett certifikat:
client-auth-choose-cert = Välj ett certifikat att ange som identifikation:
client-auth-send-no-certificate =
    .label = Skicka inte ett certifikat
# Variables:
# $hostname (String) - The domain name of the site requesting the client authentication certificate
client-auth-site-identification = "{ $hostname }" har begärt att du ska identifiera dig med ett certifikat:
client-auth-cert-details = Detaljer om valt certifikat:
# Variables:
# $issuedTo (String) - The subject common name of the currently-selected client authentication certificate
client-auth-cert-details-issued-to = Utfärdat till: { $issuedTo }
# Variables:
# $serialNumber (String) - The serial number of the certificate (hexadecimal of the form "AA:BB:...")
client-auth-cert-details-serial-number = Serienummer: { $serialNumber }
# Variables:
# $notBefore (String) - The date before which the certificate is not valid (e.g. Apr 21, 2023, 1:47:53 PM UTC)
# $notAfter (String) - The date after which the certificate is not valid
client-auth-cert-details-validity-period = Giltig från { $notBefore } till { $notAfter }
# Variables:
# $keyUsages (String) - A list of already-localized key usages for which the certificate may be used
client-auth-cert-details-key-usages = Nyckelanvändningar: { $keyUsages }
# Variables:
# $emailAddresses (String) - A list of email addresses present in the certificate
client-auth-cert-details-email-addresses = E-postadresser: { $emailAddresses }
# Variables:
# $issuedBy (String) - The issuer common name of the certificate
client-auth-cert-details-issued-by = Utfärdad av: { $issuedBy }
# Variables:
# $storedOn (String) - The name of the token holding the certificate (for example, "OS Client Cert Token (Modern)")
client-auth-cert-details-stored-on = Lagrad på: { $storedOn }
client-auth-cert-remember-box =
    .label = Kom ihåg detta beslut

## Set password (p12) dialog

set-password-window =
    .title = Välj ett lösenord för certifikatets säkerhetskopia
set-password-message = Det lösenord för certifikatets säkerhetskopia som du anger här skyddar säkerhetskopian som du håller på att skapa. Du måste ange detta lösenord för att kunna fortsätta.
set-password-backup-pw =
    .value = Lösenord för certifikatets säkerhetskopia:
set-password-repeat-backup-pw =
    .value = Lösenord för certifikatets säkerhetskopia (bekräftas):
set-password-reminder = Viktigt: Om du glömmer detta lösenord kommer du inte att kunna återställa denna säkerhetskopia senare. Lagra detta lösenord på en säker plats.

## Protected authentication alert

# Variables:
# $tokenName (String) - The name of the token to authenticate to (for example, "OS Client Cert Token (Modern)")
protected-auth-alert = Vänligen autentisera till token "{ $tokenName }". Hur man gör det beror på token (till exempel genom att använda en fingeravtrycksläsare eller ange en kod med en knappsats).
