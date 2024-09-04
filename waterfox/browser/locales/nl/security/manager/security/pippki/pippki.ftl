# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Wachtwoordkwaliteitsmeter

## Change Password dialog

change-device-password-window =
    .title = Wachtwoord wijzigen
# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Beveiligingsapparaat: { $tokenName }
change-password-old = Huidige wachtwoord:
change-password-new = Nieuw wachtwoord:
change-password-reenter = Nieuw wachtwoord (nogmaals):
pippki-failed-pw-change = Kan hoofdwachtwoord niet wijzigen.
pippki-incorrect-pw = U hebt niet het juiste huidige hoofdwachtwoord ingevoerd. Probeer het opnieuw.
pippki-pw-change-ok = Wachtwoord met succes gewijzigd.
pippki-pw-empty-warning = Uw opgeslagen wachtwoorden en privésleutels zullen niet worden beschermd.
pippki-pw-erased-ok = U hebt uw hoofdwachtwoord verwijderd. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Waarschuwing! U hebt besloten geen hoofdwachtwoord te gebruiken. { pippki-pw-empty-warning }
pippki-pw-change2empty-in-fips-mode = U bent momenteel in FIPS-modus. FIPS vereist een ingesteld hoofdwachtwoord.

## Reset Primary Password dialog

reset-primary-password-window2 =
    .title = Hoofdwachtwoord opnieuw instellen
    .style = min-width: 40em
reset-password-button-label =
    .label = Herinitialiseren
reset-primary-password-text = Als u uw hoofdwachtwoord opnieuw instelt, zullen al uw opgeslagen web- en e-mailwachtwoorden, persoonlijke certificaten en privésleutels worden vergeten. Weet u zeker dat u uw hoofdwachtwoord wilt herinitialiseren?
pippki-reset-password-confirmation-title = Hoofdwachtwoord opnieuw instellen
pippki-reset-password-confirmation-message = Uw hoofdwachtwoord is opnieuw ingesteld

## Downloading cert dialog

download-cert-window2 =
    .title = Certificaat downloaden
    .style = min-width: 46em
download-cert-message = U wordt gevraagd een nieuwe certificaatautoriteit (CA) te vertrouwen.
download-cert-trust-ssl =
    .label = Deze CA vertrouwen voor het identificeren van websites.
download-cert-trust-email =
    .label = Deze CA vertrouwen voor het identificeren van e-mailgebruikers.
download-cert-message-desc = Voordat u deze CA voor enig gebruik vertrouwt, dient u het certificaat ervan te bestuderen, evenals het beleid en de procedures (wanneer beschikbaar).
download-cert-view-cert =
    .label = Weergeven
download-cert-view-text = CA-certificaat bestuderen

## Client Authorization Ask dialog


## Client Authentication Ask dialog

client-auth-window =
    .title = Gebruikersidentificatieverzoek
client-auth-site-description = Deze website vraagt u zich te identificeren met een beveiligingscertificaat:
client-auth-choose-cert = Kies een certificaat om als identificatie aan te bieden:
client-auth-send-no-certificate =
    .label = Stuur geen certificaat
# Variables:
# $hostname (String) - The domain name of the site requesting the client authentication certificate
client-auth-site-identification = ‘{ $hostname }’ vraagt u zich te identificeren met een beveiligingscertificaat:
client-auth-cert-details = Details van geselecteerde certificaat:
# Variables:
# $issuedTo (String) - The subject common name of the currently-selected client authentication certificate
client-auth-cert-details-issued-to = Uitgegeven aan: { $issuedTo }
# Variables:
# $serialNumber (String) - The serial number of the certificate (hexadecimal of the form "AA:BB:...")
client-auth-cert-details-serial-number = Serienummer: { $serialNumber }
# Variables:
# $notBefore (String) - The date before which the certificate is not valid (e.g. Apr 21, 2023, 1:47:53 PM UTC)
# $notAfter (String) - The date after which the certificate is not valid
client-auth-cert-details-validity-period = Geldig van { $notBefore } tot en met { $notAfter }
# Variables:
# $keyUsages (String) - A list of already-localized key usages for which the certificate may be used
client-auth-cert-details-key-usages = Sleutelgebruik: { $keyUsages }
# Variables:
# $emailAddresses (String) - A list of email addresses present in the certificate
client-auth-cert-details-email-addresses = E-mailadressen: { $emailAddresses }
# Variables:
# $issuedBy (String) - The issuer common name of the certificate
client-auth-cert-details-issued-by = Uitgegeven door: { $issuedBy }
# Variables:
# $storedOn (String) - The name of the token holding the certificate (for example, "OS Client Cert Token (Modern)")
client-auth-cert-details-stored-on = Opgeslagen op: { $storedOn }
client-auth-cert-remember-box =
    .label = Deze beslissing onthouden

## Set password (p12) dialog

set-password-window =
    .title = Kies een wachtwoord voor de reservekopie van het certificaat
set-password-message = Het wachtwoord dat u hier instelt voor de reservekopie van het certificaat beschermt het reservekopiebestand dat u wilt gaan maken. U moet dit wachtwoord instellen voordat u verdergaat met de reservekopie.
set-password-backup-pw =
    .value = Wachtwoord voor de reservekopie van het certificaat:
set-password-repeat-backup-pw =
    .value = Wachtwoord voor de reservekopie van het certificaat (nogmaals):
set-password-reminder = Belangrijk: als u uw wachtwoord voor de reservekopie van het certificaat vergeet, kunt u deze reservekopie later niet herstellen. Berg het op een veilige plek op.

## Protected authentication alert

# Variables:
# $tokenName (String) - The name of the token to authenticate to (for example, "OS Client Cert Token (Modern)")
protected-auth-alert = Authenticeer bij het token ‘{ $tokenName }’. Hoe u dit doet, hangt af van het token (bijvoorbeeld met behulp van een vingerafdruklezer of het invoeren van een code met een toetsenbord).
