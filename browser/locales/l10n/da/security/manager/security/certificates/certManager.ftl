# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Certifikatadministration
certmgr-tab-mine =
    .label = Dine certifikater
certmgr-tab-remembered =
    .label = Beslutninger om godkendelse
certmgr-tab-people =
    .label = Personer
certmgr-tab-servers =
    .label = Servere
certmgr-tab-ca =
    .label = Autoriteter
certmgr-mine = Du har certifikater fra disse organisationer, der identificerer dig
certmgr-remembered = Disse certifikater bruges til at identificere dig overfor websteder
certmgr-people = Du har certifikater liggende, der identificerer disse personer
certmgr-servers = Du har certifikater liggende, der identificerer disse servere
certmgr-server = Disse poster identificerer undtagelser for servercertifikatfejl
certmgr-ca = Du har certifikater liggende, der identificerer disse certifikatautoriteter
certmgr-detail-general-tab-title =
    .label = Generelt
    .accesskey = G
certmgr-detail-pretty-print-tab-title =
    .label = Detaljer
    .accesskey = D
certmgr-pending-label =
    .value = Verificerer certifikat…
certmgr-subject-label = Udstedt til
certmgr-issuer-label = Udstedt af
certmgr-period-of-validity = Gyldighedsperiode
certmgr-fingerprints = Fingeraftryk
certmgr-cert-detail =
    .title = Certifikatdetalje
    .buttonlabelaccept = Luk
    .buttonaccesskeyaccept = L
certmgr-cert-detail-commonname = Normalt Navn (CN)
certmgr-cert-detail-org = Organisation (O)
certmgr-cert-detail-orgunit = Organisatorisk enhed (OU)
certmgr-cert-detail-serial-number = Serienummer
certmgr-cert-detail-sha-256-fingerprint = SHA-256-fingeraftryk
certmgr-cert-detail-sha-1-fingerprint = SHA1-fingeraftryk
certmgr-edit-ca-cert =
    .title = Rediger tillidsindstillinger for CA-certifikat
    .style = width: 48em;
certmgr-edit-cert-edit-trust = Rediger tillidsindstillinger:
certmgr-edit-cert-trust-ssl =
    .label = Dette certifikat kan identificere websteder.
certmgr-edit-cert-trust-email =
    .label = Dette certifikat kan identificere mailbrugere.
certmgr-delete-cert =
    .title = Slet certifikat
    .style = width: 48em; height: 24em;
certmgr-cert-host =
    .label = Vært
certmgr-cert-name =
    .label = Certifikatnavn
certmgr-cert-server =
    .label = Server
certmgr-override-lifetime =
    .label = Levetid
certmgr-token-name =
    .label = Sikkerhedsenhed
certmgr-begins-on = Begynder den
certmgr-begins-label =
    .label = Begynder den
certmgr-expires-on = Udløber den
certmgr-expires-label =
    .label = Udløber den
certmgr-email =
    .label = Mailadresse
certmgr-serial =
    .label = Serienummer
certmgr-view =
    .label = Vis…
    .accesskey = V
certmgr-edit =
    .label = Rediger tillid…
    .accesskey = R
certmgr-export =
    .label = Eksporter…
    .accesskey = E
certmgr-delete =
    .label = Slet…
    .accesskey = S
certmgr-delete-builtin =
    .label = Slet eller fjern tillid…
    .accesskey = S
certmgr-backup =
    .label = Lav sikkerhedskopi…
    .accesskey = k
certmgr-backup-all =
    .label = Lav sikkerhedskopi af alle…
    .accesskey = a
certmgr-restore =
    .label = Importer…
    .accesskey = I
certmgr-details =
    .value = Certifikatfelter
    .accesskey = f
certmgr-fields =
    .value = Feltværdi
    .accesskey = v
certmgr-hierarchy =
    .value = Certifikathierarki
    .accesskey = H
certmgr-add-exception =
    .label = Tilføj undtagelse…
    .accesskey = U
exception-mgr =
    .title = Tilføj sikkerhedsundtagelse
exception-mgr-extra-button =
    .label = Bekræft sikkerhedsundtagelse
    .accesskey = B
exception-mgr-supplemental-warning = Legitime banker, forretninger og andre offentlige websteder vil ikke bede dig om at gøre dette.
exception-mgr-cert-location-url =
    .value = Adresse:
exception-mgr-cert-location-download =
    .label = Hent certifikat
    .accesskey = H
exception-mgr-cert-status-view-cert =
    .label = Vis…
    .accesskey = V
exception-mgr-permanent =
    .label = Gem denne undtagelse permanent
    .accesskey = p
pk11-bad-password = Den indtastede mærkeadgangskode var forkert.
pkcs12-decode-err = Kunne ikke afkode filen.  Enten er den ikke i PKCS #12 format, er gået i stykker, eller den indtastede adgangskode var forkert.
pkcs12-unknown-err-restore = Kunne ikke gendanne PKCS #12 filen af ukendte årsager.
pkcs12-unknown-err-backup = Kunne ikke oprette PKCS #12 backupfilen af ukendte årsager.
pkcs12-unknown-err = PKCS #12 handlingen mislykkedes af ukendte årsager.
pkcs12-info-no-smartcard-backup = Hvis det ikke er muligt at sikkerhedskopiere certifikater fra en hardware sikkerhedsenhed så som et smart card.
pkcs12-dup-data = Certifikatet og den private nøgle eksisterer allerede på sikkerhedsenheden.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Vælg filnavn på sikkerhedskopi
file-browse-pkcs12-spec = PKCS12 filer
choose-p12-restore-file-dialog = Vælg certifikatet, du ønsker at importere

## Import certificate(s) file dialog

file-browse-certificate-spec = Certifikatfiler
import-ca-certs-prompt = Vælg den fil som CA-certifikaterne, du vil indlæse, er i
import-email-cert-prompt = Vælg den fil der indeholder det mailcertifikat du vil importere

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = Certifikatet "{ $certName }" repræsenterer en Certifikat Autoritet.

## For Deleting Certificates

delete-user-cert-title =
    .title = Slet dine certifikater
delete-user-cert-confirm = Er du sikker på, at du vil slette disse certifikater?
delete-user-cert-impact = Hvis du sletter et af dine egne certifikater, kan du ikke længere bruge det til at identificere dig selv.
delete-ssl-cert-title =
    .title = Slet undtagelser for servercertifikat
delete-ssl-cert-confirm = Er du sikker på, at du vil slette disse serverundtagelser?
delete-ssl-cert-impact = Hvis du sletter en serverundtagelse, gendanner du den sædvanlige sikkerhedskontrol for serveren og kræver, at den bruger et gyldigt certifikat.
delete-ssl-override-title =
    .title = Slet undtagelse for servercertifikat
delete-ssl-override-confirm = Er du sikker på, at du vil slette denne serverundtagelse?
delete-ssl-override-impact = Hvis du sletter en serverundtagelse, så gendanner du de almindelige sikkerhedschecks for denne server og kræver, at den anvender et gyldigt certifikat.
delete-ca-cert-title =
    .title = Slet eller fjern tillid til CA-certifikater
delete-ca-cert-confirm = Du har bedt om at få slette disse CA-certifikater. For indlejrede certifikater vil al tillid blive fjernet, hvilket har samme virkning. Er du sikker på, at du vil slette eller fjerne tilliden?
delete-ca-cert-impact = Hvis du sletter eller fjerner tilliden til et Certificate Authority (CA)-certifikat vil programmet ikke længere stole på certifikater udstedt af denne CA.
delete-email-cert-title =
    .title = Slet mailcertifikater
delete-email-cert-confirm = Er du sikker på, at du vil slette disse personers mailcertifikater?
delete-email-cert-impact = Hvis du sletter en persons mailcertifikat, vil du ikke længere kunne sende krypterede mails til personen.
# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Certifikat med serienummer: { $serialNumber }

## Cert Viewer

# Title used for the Certificate Viewer.
#
# Variables:
#   $certificate : a string representative of the certificate being viewed.
cert-viewer-title =
    .title = Certifikatfremviser: '{ $certName }'
not-present =
    .value = <Er ikke en del af certifikat>
# Cert verification
cert-verified = Dette certifikat er godkendt til følgende formål:
# Add usage
verify-ssl-client =
    .value = SSL klient-certifikat
verify-ssl-server =
    .value = SSL server-certifikat
verify-ssl-ca =
    .value = SSL certifikatautoritet
verify-email-signer =
    .value = Mailunderskriftscertifikat
verify-email-recip =
    .value = Mailmodtagercertifikat
# Cert verification
cert-not-verified-cert-revoked = Kunne ikke godkende dette certifikat, da det er trukket tilbage.
cert-not-verified-cert-expired = Kunne ikke godkende dette certifikat, da det er udløbet.
cert-not-verified-cert-not-trusted = Kunne ikke godkende dette certifikat, da der ikke stoles på det.
cert-not-verified-issuer-not-trusted = Kunne ikke godkende dette certifikat da der ikke stoles på udstederen.
cert-not-verified-issuer-unknown = Kunne ikke godkende dette certifikat, da udstederen er ukendt.
cert-not-verified-ca-invalid = Kunne ikke godkende dette certifikat da CA-certifikatet er forkert.
cert-not-verified_algorithm-disabled = Kunne ikke godkende dette certifikat, fordi det er underskrevet med en usikker algoritme.
cert-not-verified-unknown = Kunne ikke godkende dette certifikat af ukendte årsager.
# Used to indicate that the user chose not to send a client authentication certificate to a server that requested one in a TLS handshake.
send-no-client-certificate = Send intet klient-certifikat
# Used when no cert is stored for an override
no-cert-stored-for-override = (Ikke gemt)

## Used to show whether an override is temporary or permanent

permanent-override = Permanent
temporary-override = Midlertidig

## Add Security Exception dialog

add-exception-branded-warning = Du er ved at tilsidesætte hvordan { -brand-short-name } identificerer dette websted.
add-exception-invalid-header = Dette websted forsøger at identificere sig selv med ugyldig information.
add-exception-domain-mismatch-short = Forkert websted
add-exception-domain-mismatch-long = Certifikatet tilhører et andet websted, hvilket kan indikere forsøg på identitetstyveri.
add-exception-expired-short = Forældet information
add-exception-expired-long = Certifikatet er ikke gyldigt i øjeblikket. Det kan være blevet stjålet, hvorefter nogen så forsøger at bruge det til identitetstyveri.
add-exception-unverified-or-bad-signature-short = Ukendt identitet
add-exception-unverified-or-bad-signature-long = Der er ikke tillid til certifikatet, da det ikke er blevet verificeret af en kendt autoritet ved hjælp af en sikker signatur.
add-exception-valid-short = Gyldigt certifikat
add-exception-valid-long = Dette certifikat indeholder gyldig, verificeret information. Der er ingen grund til at tilføje en undtagelse.
add-exception-checking-short = Kontrollerer information
add-exception-checking-long = Forsøger at identificere webstedet…
add-exception-no-cert-short = Ingen tilgængelig information
add-exception-no-cert-long = Kan ikke fastslå status for webstedets certifikat.

## Certificate export "Save as" and error dialogs

save-cert-as = Gem certifikatet i en fil
cert-format-base64 = X.509-certifikat (PEM)
cert-format-base64-chain = X.509-certifikat med kæde (PEM)
cert-format-der = X.509-certifikat (DER)
cert-format-pkcs7 = X.509-certifikat (PKCS#7)
cert-format-pkcs7-chain = X.509-certifikat med kæde (PKCS#7)
write-file-failure = Fejl i filen
