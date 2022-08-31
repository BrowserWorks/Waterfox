# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Certificatenbeheerder

certmgr-tab-mine =
    .label = Uw certificaten

certmgr-tab-remembered =
    .label = Authenticatiebeslissingen

certmgr-tab-people =
    .label = Personen

certmgr-tab-servers =
    .label = Servers

certmgr-tab-ca =
    .label = Organisaties

certmgr-mine = U hebt certificaten van deze organisaties, die u identificeren
certmgr-remembered = Deze certificaten worden gebruikt om u bij websites te identificeren
certmgr-people = U hebt certificaten gearchiveerd die deze personen identificeren
certmgr-server = Deze vermeldingen identificeren uitzonderingen op servercertificaatfouten
certmgr-ca = U hebt certificaten gearchiveerd die deze certificaatautoriteiten identificeren

certmgr-edit-ca-cert =
    .title = CA-certificaat-vertrouwensinstellingen bewerken
    .style = width: 48em;

certmgr-edit-cert-edit-trust = Vertrouwensinstellingen bewerken:

certmgr-edit-cert-trust-ssl =
    .label = Dit certificaat kan websites identificeren.

certmgr-edit-cert-trust-email =
    .label = Dit certificaat kan e-mailgebruikers identificeren.

certmgr-delete-cert =
    .title = Certificaat verwijderen
    .style = width: 48em; height: 24em;

certmgr-cert-host =
    .label = Host

certmgr-cert-name =
    .label = Certificaatnaam

certmgr-cert-server =
    .label = Server

certmgr-override-lifetime =
    .label = Levensduur

certmgr-token-name =
    .label = Beveiligingsapparaat

certmgr-begins-label =
    .label = Begint op

certmgr-expires-label =
    .label = Verloopt op

certmgr-email =
    .label = E-mailadres

certmgr-serial =
    .label = Serienummer

certmgr-view =
    .label = Weergeven…
    .accesskey = W

certmgr-edit =
    .label = Vertrouwen bewerken…
    .accesskey = b

certmgr-export =
    .label = Exporteren…
    .accesskey = x

certmgr-delete =
    .label = Verwijderen…
    .accesskey = V

certmgr-delete-builtin =
    .label = Verwijderen of wantrouwen…
    .accesskey = V

certmgr-backup =
    .label = Reservekopie maken…
    .accesskey = R

certmgr-backup-all =
    .label = Reservekopie van alle maken…
    .accesskey = k

certmgr-restore =
    .label = Importeren…
    .accesskey = m

certmgr-add-exception =
    .label = Uitzondering toevoegen…
    .accesskey = U

exception-mgr =
    .title = Beveiligingsuitzondering toevoegen

exception-mgr-extra-button =
    .label = Beveiligingsuitzondering bevestigen
    .accesskey = b

exception-mgr-supplemental-warning = Legitieme banken, winkels en andere publieke websites zullen dit niet vragen.

exception-mgr-cert-location-url =
    .value = Locatie:

exception-mgr-cert-location-download =
    .label = Certificaat ophalen
    .accesskey = o

exception-mgr-cert-status-view-cert =
    .label = Weergeven…
    .accesskey = W

exception-mgr-permanent =
    .label = Deze uitzondering voor altijd opslaan
    .accesskey = a

pk11-bad-password = Het ingevoerde wachtwoord is onjuist.
pkcs12-decode-err = Het ontcijferen van dit bestand is mislukt. Het is niet in de PKCS #12-opmaak versleuteld, is beschadigd, of het door u ingevoerde wachtwoord is onjuist.
pkcs12-unknown-err-restore = Het herstellen van het PKCS #12-bestand is om onbekende redenen mislukt.
pkcs12-unknown-err-backup = Het maken van een reservekopie van het PKCS #12-bestand is om onbekende redenen mislukt.
pkcs12-unknown-err = De PKCS #12-verwerking is om onbekende redenen mislukt.
pkcs12-info-no-smartcard-backup = Het is niet mogelijk om een reservekopie te maken van certificaten die op een beveiligingsapparaat, zoals een smartcard, staan.
pkcs12-dup-data = Het certificaat en de privésleutel bestaan al op het beveiligingsapparaat.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Bestandsnaam voor reservekopie
file-browse-pkcs12-spec = PKCS12-bestanden
choose-p12-restore-file-dialog = Certificaatbestand voor importeren

## Import certificate(s) file dialog

file-browse-certificate-spec = Certificaatbestanden
import-ca-certs-prompt = Bestand met te importeren CA-certificaten selecteren
import-email-cert-prompt = Bestand met te importeren e-mailcertificaat van iemand anders selecteren

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = Het certificaat ‘{ $certName }’ vertegenwoordigt een certificaatautoriteit.

## For Deleting Certificates

delete-user-cert-title =
    .title = Uw certificaten verwijderen
delete-user-cert-confirm = Weet u zeker dat u deze certificaten wilt verwijderen?
delete-user-cert-impact = Als u een van uw eigen certificaten verwijdert, kunt u het niet langer gebruiken om uzelf mee te identificeren.


delete-ssl-override-title =
    .title = Servercertificaatuitzondering verwijderen
delete-ssl-override-confirm = Weet u zeker dat u deze serveruitzondering wilt verwijderen?
delete-ssl-override-impact = Als u een serveruitzondering verwijdert, herstelt u de standaard beveiligingscontrole voor die server en vereist u dat deze gebruikmaakt van een geldig certificaat.

delete-ca-cert-title =
    .title = CA-certificaten verwijderen of wantrouwen
delete-ca-cert-confirm = U hebt gevraagd deze CA-certificaten te verwijderen. Bij ingebouwde certificaten zal alle vertrouwen worden verwijderd, wat hetzelfde resultaat heeft. Weet u zeker dat u wilt verwijderen of wantrouwen?
delete-ca-cert-impact = Als u een certificaat van een certificaatautoriteit (CA) verwijdert of niet vertrouwt, zal deze toepassing geen enkel certificaat meer vertrouwen dat door die CA is uitgegeven.


delete-email-cert-title =
    .title = E-mailcertificaten verwijderen
delete-email-cert-confirm = Weet u zeker dat u de e-mailcertificaten van deze personen wilt verwijderen?
delete-email-cert-impact = Als u een e-mailcertificaat van een persoon verwijdert, zult u niet langer versleutelde e-mail naar deze persoon kunnen verzenden.

# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Certificaat met serienummer: { $serialNumber }

## Cert Viewer

# Used to indicate that the user chose not to send a client authentication certificate to a server that requested one in a TLS handshake.
send-no-client-certificate = Geen clientcertificaat verzenden

# Used when no cert is stored for an override
no-cert-stored-for-override = (Niet opgeslagen)

# When a certificate is unavailable (for example, it has been deleted or the token it exists on has been removed).
certificate-not-available = (Niet beschikbaar)

## Used to show whether an override is temporary or permanent

permanent-override = Voor altijd
temporary-override = Tijdelijk

## Add Security Exception dialog

add-exception-branded-warning = U staat op het punt te overschrijven hoe { -brand-short-name } deze website identificeert.
add-exception-invalid-header = Deze website probeert zich te identificeren met ongeldige informatie.
add-exception-domain-mismatch-short = Verkeerde website
add-exception-domain-mismatch-long = Het certificaat behoort toe aan een andere website, wat kan betekenen dat iemand deze website probeert na te bootsen.
add-exception-expired-short = Verouderde informatie
add-exception-expired-long = Het certificaat is momenteel niet geldig. Het kan zijn gestolen of vermist, en kan door iemand worden gebruikt om deze website na te bootsen.
add-exception-unverified-or-bad-signature-short = Onbekende identiteit
add-exception-unverified-or-bad-signature-long = Het certificaat wordt niet vertrouwd, omdat het niet is geverifieerd en uitgegeven door een vertrouwde autoriteit via een beveiligde ondertekening.
add-exception-valid-short = Geldig certificaat
add-exception-valid-long = Deze website verzorgt geldige, geverifieerde identificatie. U hoeft geen uitzondering toe te voegen.
add-exception-checking-short = Informatie controleren
add-exception-checking-long = Poging tot identificatie van deze website…
add-exception-no-cert-short = Geen informatie beschikbaar
add-exception-no-cert-long = Kan geen identificatiestatus van deze website verkrijgen.

## Certificate export "Save as" and error dialogs

save-cert-as = Certificaat opslaan als bestand
cert-format-base64 = X.509-certificaat (PEM)
cert-format-base64-chain = X.509-certificaat met keten (PEM)
cert-format-der = X.509-certificaat (DER)
cert-format-pkcs7 = X.509-certificaat (PKCS#7)
cert-format-pkcs7-chain = X.509-certificaat met keten (PKCS#7)
write-file-failure = Bestandsfout
