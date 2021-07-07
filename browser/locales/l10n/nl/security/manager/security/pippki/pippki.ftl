# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Wachtwoordkwaliteitsmeter

## Change Password dialog

change-password-window =
    .title = Hoofdwachtwoord wijzigen
change-device-password-window =
    .title = Wachtwoord wijzigen
# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Beveiligingsapparaat: { $tokenName }
change-password-old = Huidige wachtwoord:
change-password-new = Nieuw wachtwoord:
change-password-reenter = Nieuw wachtwoord (nogmaals):

## Reset Password dialog

reset-password-window =
    .title = Hoofdwachtwoord herinitialiseren
    .style = width: 40em
pippki-failed-pw-change = Kan hoofdwachtwoord niet wijzigen.
pippki-incorrect-pw = U hebt niet het juiste huidige hoofdwachtwoord ingevoerd. Probeer het opnieuw.
pippki-pw-change-ok = Wachtwoord met succes gewijzigd.
pippki-pw-empty-warning = Uw opgeslagen wachtwoorden en privésleutels zullen niet worden beschermd.
pippki-pw-erased-ok = U hebt uw hoofdwachtwoord verwijderd. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Waarschuwing! U hebt besloten geen hoofdwachtwoord te gebruiken. { pippki-pw-empty-warning }
pippki-pw-change2empty-in-fips-mode = U bent momenteel in FIPS-modus. FIPS vereist een ingesteld hoofdwachtwoord.

## Reset Primary Password dialog

reset-primary-password-window =
    .title = Hoofdwachtwoord opnieuw instellen
    .style = width: 40em
reset-password-button-label =
    .label = Herinitialiseren
reset-password-text = Als u uw hoofdwachtwoord opnieuw instelt, zullen al uw opgeslagen web- en e-mailwachtwoorden, formuliergegevens, persoonlijke certificaten en privésleutels worden vergeten. Weet u zeker dat u uw hoofdwachtwoord wilt herinitialiseren?
reset-primary-password-text = Als u uw hoofdwachtwoord opnieuw instelt, zullen al uw opgeslagen web- en e-mailwachtwoorden, persoonlijke certificaten en privésleutels worden vergeten. Weet u zeker dat u uw hoofdwachtwoord wilt herinitialiseren?
pippki-reset-password-confirmation-title = Hoofdwachtwoord opnieuw instellen
pippki-reset-password-confirmation-message = Uw hoofdwachtwoord is opnieuw ingesteld

## Downloading cert dialog

download-cert-window =
    .title = Certificaat downloaden
    .style = width: 46em
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

client-auth-window =
    .title = Gebruikersidentificatieverzoek
client-auth-site-description = Deze website vraagt u zich te identificeren met een beveiligingscertificaat:
client-auth-choose-cert = Kies een certificaat om als identificatie aan te bieden:
client-auth-cert-details = Details van geselecteerde certificaat:

## Set password (p12) dialog

set-password-window =
    .title = Kies een wachtwoord voor de reservekopie van het certificaat
set-password-message = Het wachtwoord dat u hier instelt voor de reservekopie van het certificaat beschermt het reservekopiebestand dat u wilt gaan maken. U moet dit wachtwoord instellen voordat u verdergaat met de reservekopie.
set-password-backup-pw =
    .value = Wachtwoord voor de reservekopie van het certificaat:
set-password-repeat-backup-pw =
    .value = Wachtwoord voor de reservekopie van het certificaat (nogmaals):
set-password-reminder = Belangrijk: als u uw wachtwoord voor de reservekopie van het certificaat vergeet, kunt u deze reservekopie later niet herstellen. Berg het op een veilige plek op.

## Protected Auth dialog

protected-auth-window =
    .title = Beschermde tokenauthenticatie
protected-auth-msg = Authenticeer bij het token. Authenticatiemethode hangt af van het type van uw token.
protected-auth-token = Token:
