# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Kvalitetsmåling av passord

## Change Password dialog

change-device-password-window =
    .title = Endre passord
# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Tryggingseining: { $tokenName }
change-password-old = Gjeldande passord:
change-password-new = Nytt passord:
change-password-reenter = Nytt passord (igjen):
pippki-failed-pw-change = Klarte ikkje å endre passord.
pippki-incorrect-pw = Du skreiv ikkje inn rett gjeldande passord. Prøv på nytt.
pippki-pw-change-ok = Passordet er endra.
pippki-pw-empty-warning = Lagra passord og private nøklar vil ikkje bli verna.
pippki-pw-erased-ok = Passordet er no sletta. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Åtvaring! Du har valt å ikkje bruke eit passord. { pippki-pw-empty-warning }
pippki-pw-change2empty-in-fips-mode = Du er i FIPS-modus. FIPS krev at du brukar eit primærpasssord.

## Reset Primary Password dialog

reset-primary-password-window2 =
    .title = Tilbakestill hovudpassordet
    .style = min-width: 40em
reset-password-button-label =
    .label = Still tilbake
reset-primary-password-text = Dersom du stiller tilbake hovudpassordet vil alle lagra nettside- og e-postpassord, personlege sertifikat og private nøklar gå tapt. Er du sikker på at du vil tilbakestille hovudpassordet?
pippki-reset-password-confirmation-title = Tilbakestill hovudpassordet
pippki-reset-password-confirmation-message = Hovudpassordet ditt er tilbakestilt.

## Downloading cert dialog

download-cert-window2 =
    .title = Lastar ned sertifikat
    .style = min-width: 46em
download-cert-message = Du har vorte beden om å stola på ei ny sertifikat-fullmakt (CA)
download-cert-trust-ssl =
    .label = Stol på denne CA-en til å identifisere nettsider.
download-cert-trust-email =
    .label = Stol på denne CA-en til å identifisere e-postbrukarar.
download-cert-message-desc = Før du vel å ha tillit til denne sertifikat-fullmakta (CA), bør du undersøkja fullmakta sitt sertifikat, framgangsmåtar og prosedyrar.
download-cert-view-cert =
    .label = Vis
download-cert-view-text = Undersøk CA-sertifikat

## Client Authorization Ask dialog


## Client Authentication Ask dialog

client-auth-window =
    .title = Førespurnad om brukaridentifikasjon
client-auth-site-description = Denne nettstaden har bede om at du identifiserer deg sjølv med eit sertifikat:
client-auth-choose-cert = Vel sertifikat som du vil bruka som identifikasjon:
client-auth-send-no-certificate =
    .label = Ikkje send eit sertifikat
# Variables:
# $hostname (String) - The domain name of the site requesting the client authentication certificate
client-auth-site-identification = «{ $hostname }» ber om at du identifiserer deg med eit sertifikat:
client-auth-cert-details = Detaljar om valt sertifikat:
# Variables:
# $issuedTo (String) - The subject common name of the currently-selected client authentication certificate
client-auth-cert-details-issued-to = Utferda til: { $issuedTo }
# Variables:
# $serialNumber (String) - The serial number of the certificate (hexadecimal of the form "AA:BB:...")
client-auth-cert-details-serial-number = Serienummer: { $serialNumber }
# Variables:
# $notBefore (String) - The date before which the certificate is not valid (e.g. Apr 21, 2023, 1:47:53 PM UTC)
# $notAfter (String) - The date after which the certificate is not valid
client-auth-cert-details-validity-period = Gyldig frå { $notBefore } to { $notAfter }
# Variables:
# $keyUsages (String) - A list of already-localized key usages for which the certificate may be used
client-auth-cert-details-key-usages = Nykelbruk: { $keyUsages }
# Variables:
# $emailAddresses (String) - A list of email addresses present in the certificate
client-auth-cert-details-email-addresses = E-postadresser: { $emailAddresses }
# Variables:
# $issuedBy (String) - The issuer common name of the certificate
client-auth-cert-details-issued-by = Utferda av: { $issuedBy }
# Variables:
# $storedOn (String) - The name of the token holding the certificate (for example, "OS Client Cert Token (Modern)")
client-auth-cert-details-stored-on = Lagra på: { $storedOn }
client-auth-cert-remember-box =
    .label = Hugs denne avgjerdsla

## Set password (p12) dialog

set-password-window =
    .title = Vel passord for tryggingskopi av sertifikat
set-password-message = Passordet for tryggingskopien du vel her, vil verna tryggingskopi-fila du lagar no. Du må skriva inn dette passordet for å halda fram med tryggingskopieringa.
set-password-backup-pw =
    .value = Passord for tryggingskopi:
set-password-repeat-backup-pw =
    .value = Passord for tryggingskopi (igjen):
set-password-reminder = Viktig: Dersom du gløymer passordet til tryggingskopien, vil du ikkje kunna få tilbake innhaldet i tryggingskopien seinare. Skriv det ned på ein trygg stad.

## Protected authentication alert

# Variables:
# $tokenName (String) - The name of the token to authenticate to (for example, "OS Client Cert Token (Modern)")
protected-auth-alert = Godkjenn i samsvar med tryggingsmetoden «{ $tokenName }». Korleis du gjer det, er avhengig av metoden (til dømes ved bruk av fingeravtrykklesar eller ved å taste inn ein kode med eit tastatur).
