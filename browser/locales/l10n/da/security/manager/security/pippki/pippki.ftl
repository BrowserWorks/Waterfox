# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Kvalitetsmåler for adgangskode

## Change Password dialog

change-password-window =
    .title = Skift hovedadgangskode

change-device-password-window =
    .title = Skift adgangskode

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Sikkerhedsenhed: { $tokenName }
change-password-old = Nuværende adgangskode:
change-password-new = Ny adgangskode:
change-password-reenter = Ny adgangskode (igen):

## Reset Password dialog

reset-password-window =
    .title = Nulstil hovedadgangskode
    .style = width: 40em

pippki-failed-pw-change = Kan ikke ændre adgangskode.
pippki-incorrect-pw = Du indtastede ikke den nuværende adgangskode. Prøv igen.
pippki-pw-change-ok = Adgangskoden blev ændret.

pippki-pw-empty-warning = Dine gemte afgangskoder og private nøgler vil ikke blive beskyttet.
pippki-pw-erased-ok = Du har slettet din adgangskode. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Advarsel! Du har valgt ikke at bruge en adgangskode. { pippki-pw-empty-warning }

pippki-pw-change2empty-in-fips-mode = Du befinder dig for øjeblikket i FIPS-tilstand. FIPS kræver, at du bruger en adgangskode.

## Reset Primary Password dialog

reset-primary-password-window =
    .title = Nulstil hovedadgangskode
    .style = width: 40em
reset-password-button-label =
    .label = Nulstil
reset-password-text = Hvis du nulstiller din hovedadgangskode, vil alle dine gemte web- og mail-adgangskoder, formulardata, personlige certifikater og private nøgler blive slettet. Er du sikker på, at du vil nulstille din hovedadgangskode?

reset-primary-password-text = Hvis du nulstiller din hovedadgangskode, vil alle dine gemte websteds- og mail-adgangskoder, personlige certifikater og private nøgler blive glemt. Er du sikker på, at du vil nulstille din hovedadgangskode?

pippki-reset-password-confirmation-title = Nulstil hovedadgangskode
pippki-reset-password-confirmation-message = Din hovedadgangskode er blevet nulstillet.

## Downloading cert dialog

download-cert-window =
    .title = Henter certifikat
    .style = width: 46em
download-cert-message = Du er blevet bedt om at stole på en ny certifikatautoritet (CA).
download-cert-trust-ssl =
    .label = Stol på denne CA til at identificere websteder.
download-cert-trust-email =
    .label = Stol på denne CA til at identificere mailbrugere.
download-cert-message-desc = Før du bruger denne CA til noget som helst, bør du undersøge dens certifikat, dens holdninger og fremgangsmåder (hvis de findes).
download-cert-view-cert =
    .label = Vis
download-cert-view-text = Undersøg CA-certifikat

## Client Authorization Ask dialog

client-auth-window =
    .title = Vælg brugeridentifikation
client-auth-site-description = Dette websted har bedt om, at du identificerer dig selv med et certifikat:
client-auth-choose-cert = Vælg et certifikat, der skal vises som identifikation:
client-auth-cert-details = Detaljer for det valgte certifikat:

## Set password (p12) dialog

set-password-window =
    .title = Vælg en adgangskode for sikkerhedskopi af certifikatet
set-password-message = Adgangskoden beskytter din sikkerhedskopi af certifikatet. Du skal angive en adgangskode for at fortsætte sikkerhedskopieringen.
set-password-backup-pw =
    .value = Adgangskode for sikkerhedskopi af certifikat:
set-password-repeat-backup-pw =
    .value = Adgangskode for sikkerhedskopi af certifikat (igen):
set-password-reminder = Vigtigt: Hvis du glemmer din adgangskode, vil du ikke kunne gendanne denne sikkerhedskopi senere.  Gem den et sikkert sted.

## Protected Auth dialog

protected-auth-window =
    .title = Beskyttet token-godkendelse
protected-auth-msg = Identificer dig selv over for denne token. Godkendelsesmetoden afhænger af typen af dit token.
protected-auth-token = Token:
