# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Certifikathanteraren
certmgr-tab-mine =
    .label = Dina certifikat
certmgr-tab-remembered =
    .label = Autentiseringsbeslut
certmgr-tab-people =
    .label = Personer
certmgr-tab-servers =
    .label = Servrar
certmgr-tab-ca =
    .label = Utfärdare
certmgr-mine = Du har certifikat från dessa organisationer som identifierar dig
certmgr-remembered = Dessa certifikat används för att identifiera dig till webbplatser
certmgr-people = Du har certifikat lagrade som identifierar dessa personer
certmgr-servers = Du har certifikat lagrade som identifierar dessa servrar
certmgr-server = Dessa poster identifierar undantag för servercertifikatfel
certmgr-ca = Du har certifikat lagrade som identifierar dessa certifikatutfärdare
certmgr-detail-general-tab-title =
    .label = Allmänt
    .accesskey = A
certmgr-detail-pretty-print-tab-title =
    .label = Detaljer
    .accesskey = D
certmgr-pending-label =
    .value = Verifierar certifikat…
certmgr-subject-label = Utfärdat till
certmgr-issuer-label = Utfärdat av
certmgr-period-of-validity = Giltighetstid
certmgr-fingerprints = Fingeravtryck
certmgr-cert-detail =
    .title = Certifikatdetaljer
    .buttonlabelaccept = Stäng
    .buttonaccesskeyaccept = ä
certmgr-cert-detail-commonname = Common Name (CN)
certmgr-cert-detail-org = Organisation (O)
certmgr-cert-detail-orgunit = Organisationsenhet (OU)
certmgr-cert-detail-serial-number = Serienummer
certmgr-cert-detail-sha-256-fingerprint = SHA-256 fingeravtryck
certmgr-cert-detail-sha-1-fingerprint = SHA1-fingeravtryck
certmgr-edit-ca-cert =
    .title = Redigera tillitsinställningarna för CA-certifikat
    .style = width: 48em;
certmgr-edit-cert-edit-trust = Redigera tillitsinställningarna:
certmgr-edit-cert-trust-ssl =
    .label = Detta certifikat får identifiera webbplatser.
certmgr-edit-cert-trust-email =
    .label = Detta certifikat får identifiera e-postanvändare.
certmgr-delete-cert =
    .title = Ta bort certifikat
    .style = width: 48em; height: 24em;
certmgr-cert-host =
    .label = Värd
certmgr-cert-name =
    .label = Certifikatnamn
certmgr-cert-server =
    .label = Server
certmgr-override-lifetime =
    .label = Livslängd
certmgr-token-name =
    .label = Säkerhetsenhet
certmgr-begins-on = Börjar på
certmgr-begins-label =
    .label = Börjar på
certmgr-expires-on = Förfaller
certmgr-expires-label =
    .label = Förfaller
certmgr-email =
    .label = E-postadress
certmgr-serial =
    .label = Serienummer
certmgr-view =
    .label = Visa…
    .accesskey = V
certmgr-edit =
    .label = Redigera tillit…
    .accesskey = R
certmgr-export =
    .label = Exportera…
    .accesskey = x
certmgr-delete =
    .label = Ta bort…
    .accesskey = T
certmgr-delete-builtin =
    .label = Ta bort eller misstro…
    .accesskey = T
certmgr-backup =
    .label = Säkerhetskopiera…
    .accesskey = S
certmgr-backup-all =
    .label = Säkerhetskopiera alla…
    .accesskey = a
certmgr-restore =
    .label = Importera…
    .accesskey = m
certmgr-details =
    .value = Certifikatfält
    .accesskey = e
certmgr-fields =
    .value = Fältvärde
    .accesskey = F
certmgr-hierarchy =
    .value = Certifikathierarki
    .accesskey = H
certmgr-add-exception =
    .label = Lägg till undantag…
    .accesskey = ä
exception-mgr =
    .title = Lägg till säkerhetsundantag
exception-mgr-extra-button =
    .label = Bekräfta säkerhetsundantag
    .accesskey = B
exception-mgr-supplemental-warning = Legitima banker, butiker och andra offentliga webbplatser kommer inte att be dig göra detta.
exception-mgr-cert-location-url =
    .value = Adress:
exception-mgr-cert-location-download =
    .label = Hämta certifikat
    .accesskey = H
exception-mgr-cert-status-view-cert =
    .label = Visa…
    .accesskey = V
exception-mgr-permanent =
    .label = Lagra detta undantag permanent
    .accesskey = L
pk11-bad-password = Lösenordet som skrevs in är inkorrekt.
pkcs12-decode-err = Kan inte avkoda filen.  Antingen har den inte PKCS #12-format, den är korrupt, eller så är lösenordet du skrev in inkorrekt.
pkcs12-unknown-err-restore = Kan av okänd anledning inte återställa PKCS #12-filen.
pkcs12-unknown-err-backup = Kan av okänd anledning inte skapa en säkerhetskopia av PKCS #12-filen.
pkcs12-unknown-err = PKCS #12-operationen misslyckades av okänd anledning.
pkcs12-info-no-smartcard-backup = Det är inte möjligt att säkerhetskopiera certifikat från en hårdvarubaserad enhet, t.ex smartkort.
pkcs12-dup-data = Certifikatet och den hemliga nyckeln finns redan i säkerhetsenheten.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Filnamn att säkerhetskopiera till
file-browse-pkcs12-spec = PKCS12-filer
choose-p12-restore-file-dialog = Certifikatfil att importera

## Import certificate(s) file dialog

file-browse-certificate-spec = Certifikatfiler
import-ca-certs-prompt = Välj en fil som innehåller det rotcertifikat du vill importera
import-email-cert-prompt = Välj en fil som innehåller det e-postcertifikat du vill importera

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = Certifikatet “{ $certName }” representerar en certifikatutfärdare.

## For Deleting Certificates

delete-user-cert-title =
    .title = Ta bort certifikat
delete-user-cert-confirm = Är du säker på att du vill ta bort dessa certifikat?
delete-user-cert-impact = Om du tar bort ett av dina egna certifikat kan du inte längre använda det för att identifiera dig med det.
delete-ssl-cert-title =
    .title = Ta bort undantag för servercertifikat
delete-ssl-cert-confirm = Är du säker på att du vill ta bort dessa serverundantag?
delete-ssl-cert-impact = Om du tar bort ett serverundantag återställer du de normala säkerhetskontrollerna för servern och kräver att den använder ett giltigt certifikat.
delete-ssl-override-title =
    .title = Ta bort undantag för servercertifikat
delete-ssl-override-confirm = Är du säker på att du vill ta bort detta serverundantag?
delete-ssl-override-impact = Om du tar bort ett serverundantag återställer du de vanliga säkerhetskontrollerna för den servern och kräver att den använder ett giltigt certifikat.
delete-ca-cert-title =
    .title = Ta bort eller misstro CA-certifikat
delete-ca-cert-confirm = Du försöker ta bort dessa CA-certifikat. För inbyggda certifikat som inte kan raderas kommer i stället all tillit att tas bort, vilket har samma effekt. Är du säker på att du vill ta bort eller misstro certifikaten?
delete-ca-cert-impact = Om du tar bort eller misstror ett certifikat från en certifikatutfärdare (CA), kommer programmet inte längre att lita på certifikat som utfärdats av denna CA.
delete-email-cert-title =
    .title = Ta bort e-postcertifikat
delete-email-cert-confirm = Är du säker på att du vill ta bort dessa personers e-postcertifikat?
delete-email-cert-impact = Om du tar bort en persons e-postcertifikat kommer du inte längre att kunna skicka krypterade e-postmeddelanden till den personen.
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
    .title = Certifikatvisare: “{ $certName }”
not-present =
    .value = <Ej del av certifikat>
# Cert verification
cert-verified = Detta certifikat har verifierats för följande tillämpningar:
# Add usage
verify-ssl-client =
    .value = SSL-klientcertifikat
verify-ssl-server =
    .value = SSL-servercertifikat
verify-ssl-ca =
    .value = SSL-certifikatutfärdare (CA)
verify-email-signer =
    .value = Signeringscertifikat för e-post
verify-email-recip =
    .value = Mottagarcertifikat för e-post
# Cert verification
cert-not-verified-cert-revoked = Kan inte verifiera detta certifikat eftersom det har dragits in.
cert-not-verified-cert-expired = Kan inte verifiera detta certifikat eftersom det har förfallit.
cert-not-verified-cert-not-trusted = Det går inte att verifiera detta certifikat eftersom det inte är tillförlitligt.
cert-not-verified-issuer-not-trusted = Kan inte verifiera detta certifikat eftersom utfärdaren inte är tillförlitlig.
cert-not-verified-issuer-unknown = Kan inte verifiera detta certifikat eftersom utfärdaren är okänd.
cert-not-verified-ca-invalid = Kan inte verifiera detta certifikat eftersom CA-certifikatet är ogiltigt.
cert-not-verified_algorithm-disabled = Kan inte verifiera detta certifikat eftersom det signerades med en signaturalgoritm som är inaktiverad på grund av att den är osäker.
cert-not-verified-unknown = Kan inte verifiera detta certifikat av okänd anledning.
# Used to indicate that the user chose not to send a client authentication certificate to a server that requested one in a TLS handshake.
send-no-client-certificate = Skicka inget klientcertifikat
# Used when no cert is stored for an override
no-cert-stored-for-override = (Lagras ej)

## Used to show whether an override is temporary or permanent

permanent-override = Permanent
temporary-override = Temporär

## Add Security Exception dialog

add-exception-branded-warning = Du håller på att åsidosätta hur { -brand-short-name } identifierar denna webbplats.
add-exception-invalid-header = Den här webbplatsen försöker identifiera sig med ogiltig information.
add-exception-domain-mismatch-short = Fel webbplats
add-exception-domain-mismatch-long = Certifikatet tillhör en annan webbplats, vilket skulle kunna innebära att någon försöker imitera denna webbplats.
add-exception-expired-short = Föråldrad information
add-exception-expired-long = Certifikatet är inte giltigt. Det kan ha blivit stulet eller förlorat och kan användas av någon att imitera denna webbplats.
add-exception-unverified-or-bad-signature-short = Okänd identitet
add-exception-unverified-or-bad-signature-long = Certifikatet är inte betrott eftersom det inte har verifierats av en betrodd certifikatutfärdare med hjälp av en säker signatur.
add-exception-valid-short = Giltigt certifikat
add-exception-valid-long = Platsen har presenterat en giltig och verifierad identifikation.  Du behöver inte lägga till något undantag.
add-exception-checking-short = Kontrollerar information
add-exception-checking-long = Försöker att identifiera webbplatsen…
add-exception-no-cert-short = Ingen information tillgänglig
add-exception-no-cert-long = Kunde inte erhålla identifieringsstatus för webbplatsen.

## Certificate export "Save as" and error dialogs

save-cert-as = Spara certifikat till fil
cert-format-base64 = X.509-certifikat (PEM)
cert-format-base64-chain = X.509-certifikat med kedja (PEM)
cert-format-der = X.509-certifikat (DER)
cert-format-pkcs7 = X.509-certifikat (PKCS#7)
cert-format-pkcs7-chain = X.509-certifikat med kedja (PKCS#7)
write-file-failure = Filfel
