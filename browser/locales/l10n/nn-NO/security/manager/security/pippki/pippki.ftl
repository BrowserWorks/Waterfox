# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Kvalitetsmåling av passord

## Change Password dialog

change-password-window =
    .title = Endre hovudpassord

change-device-password-window =
    .title = Endre passord

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Tryggingseining: { $tokenName }
change-password-old = Gjeldande passord:
change-password-new = Nytt passord:
change-password-reenter = Nytt passord (igjen):

## Reset Password dialog

reset-password-window =
    .title = Still tilbake hovudpassord
    .style = width: 40em

pippki-failed-pw-change = Klarte ikkje å endre passord.
pippki-incorrect-pw = Du skreiv ikkje inn rett gjeldande passord. Prøv igjen.
pippki-pw-change-ok = Passordet er endra.

pippki-pw-empty-warning = Lagra passord og private nøklar vil ikkje bli verna.
pippki-pw-erased-ok = Passordet er no sletta. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Åtvaring! Du har valt å ikkje bruke eit passord. { pippki-pw-empty-warning }

pippki-pw-change2empty-in-fips-mode = Du er i FIPS-modus. FIPS krev at du brukar eit primærpasssord.

## Reset Primary Password dialog

reset-primary-password-window =
    .title = Tilbakestill hovudpassord
    .style = width: 40em
reset-password-button-label =
    .label = Still tilbake
reset-password-text = Dersom du stiller tilbake hovudpassordet, vil alle nett- og e-post-passord, skjemadata, personlege sertifikat og private nøklar som er lagra gå tapt. Vil du stille tilbake hovudpassordet?

reset-primary-password-text = Dersom du stiller tilbake hovudpassordet vil alle lagra nettside- og e-postpassord, personlege sertifikat og private nøklar gå tapt. Er du sikker på at du vil tilbakestille hovudpassordet?

pippki-reset-password-confirmation-title = Tilbakestill hovudpassord
pippki-reset-password-confirmation-message = Hovudpassordet ditt er tilbakestilt.

## Downloading cert dialog

download-cert-window =
    .title = Lastar ned sertifikat
    .style = width: 46em
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

client-auth-window =
    .title = Førespurnad om brukaridentifikasjon
client-auth-site-description = Denne nettstaden har bede om at du identifiserer deg sjølv med eit sertifikat:
client-auth-choose-cert = Vel sertifikat som du vil bruka som identifikasjon:
client-auth-cert-details = Detaljar om valt sertifikat:

## Set password (p12) dialog

set-password-window =
    .title = Vel passord for tryggingskopi av sertifikat
set-password-message = Passordet for tryggingskopien du vel her, vil verna tryggingskopi-fila du lagar no. Du må skriva inn dette passordet for å halda fram med tryggingskopieringa.
set-password-backup-pw =
    .value = Passord for tryggingskopi:
set-password-repeat-backup-pw =
    .value = Passord for tryggingskopi (igjen):
set-password-reminder = Viktig: Dersom du gløymer passordet til tryggingskopien, vil du ikkje kunna få tilbake innhaldet i tryggingskopien seinare. Skriv det ned på ein trygg stad.

## Protected Auth dialog

protected-auth-window =
    .title = Godkjenning med verna symbol
protected-auth-msg = Gjer vel og godkjenn symbolet. Godkjenningsmetoden er avhengig av type signeringseining
protected-auth-token = Symbol:
