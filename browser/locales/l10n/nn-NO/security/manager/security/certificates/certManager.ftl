# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Sertifikat-handterar

certmgr-tab-mine =
    .label = Dine sertifikat

certmgr-tab-remembered =
    .label = Autentiseringsavgjerder

certmgr-tab-people =
    .label = Personar

certmgr-tab-servers =
    .label = Tenarar

certmgr-tab-ca =
    .label = Sertifikatstyremakter

certmgr-mine = Du har sertifikat frå desse organisasjonene som identifiserer deg
certmgr-remembered = Desse sertifikata vert brukte til å identifisere deg til nettstadar
certmgr-people = Du har lagra sertifikat som identifiserer desse personane
certmgr-server = Desse oppføringane identifiserer unntak frå serversertifikat
certmgr-ca = Du har lagra sertifikat som identifiserer desse sertifikatstyremaktene

certmgr-edit-ca-cert =
    .title = Rediger tiltru for CA-sertifikatet
    .style = width: 48em;

certmgr-edit-cert-edit-trust = Rediger tiltru:

certmgr-edit-cert-trust-ssl =
    .label = Dette sertifikatet kan identifisera nettsider.

certmgr-edit-cert-trust-email =
    .label = Dette sertifikatet kan identifisera e-postbrukarar.

certmgr-delete-cert =
    .title = Slett sertifikat
    .style = width: 48em; height: 24em;

certmgr-cert-host =
    .label = Vert

certmgr-cert-name =
    .label = Sertifikatnamn

certmgr-cert-server =
    .label = Tenar

certmgr-override-lifetime =
    .label = Levetid

certmgr-token-name =
    .label = Tryggingseining

certmgr-begins-label =
    .label = Startar den

certmgr-expires-label =
    .label = Går ut

certmgr-email =
    .label = E-postadresse

certmgr-serial =
    .label = Serienummer

certmgr-view =
    .label = Vis…
    .accesskey = V

certmgr-edit =
    .label = Rediger tiltru…
    .accesskey = R

certmgr-export =
    .label = Eksporter…
    .accesskey = k

certmgr-delete =
    .label = Slett…
    .accesskey = S

certmgr-delete-builtin =
    .label = Slett/opphev tiltru…
    .accesskey = e

certmgr-backup =
    .label = Tryggingskopiar…
    .accesskey = r

certmgr-backup-all =
    .label = Tryggingskopier alt…
    .accesskey = s

certmgr-restore =
    .label = Importer…
    .accesskey = m

certmgr-add-exception =
    .label = Legg til unntak…
    .accesskey = e

exception-mgr =
    .title = Legg til tryggingsunntak

exception-mgr-extra-button =
    .label = Stadfest tryggingsunntak
    .accesskey = S

exception-mgr-supplemental-warning = Lovlege bankar, butikkar, og andre offentlege nettsider vil ikkje be deg om å gjere dette.

exception-mgr-cert-location-url =
    .value = Adresse:

exception-mgr-cert-location-download =
    .label = Hent sertifikat
    .accesskey = H

exception-mgr-cert-status-view-cert =
    .label = Vis…
    .accesskey = V

exception-mgr-permanent =
    .label = Lagre dette unntaket permanent
    .accesskey = L

pk11-bad-password = Passordet du skreiv inn er ugyldig.
pkcs12-decode-err = Klarte ikkje å dekode fila. Det kan vera at fila ikkje er lagra i PKCS #12-format, at ho er øydelagd, eller at passordet du skreiv inn var feil.
pkcs12-unknown-err-restore = Klarte ikkje å byggja opp att PKCS #12-fila av ukjende årsaker.
pkcs12-unknown-err-backup = Klarte ikkje å oppretta PKCS #12-fil av ukjende årsaker.
pkcs12-unknown-err = Klarte ikkje å utføra PKCS #12-operasjonen av ukjende årsaker.
pkcs12-info-no-smartcard-backup = Det er ikkje mogleg å ta Tryggingskopiar frå maskinvare tryggingseining, som til dømes Smart Card.
pkcs12-dup-data = Sertifikatet og den private nykelen finst allereie på tryggingseininga.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Filnamn for reservekopi
file-browse-pkcs12-spec = PKCS12-filer
choose-p12-restore-file-dialog = Sertifikatfil som skal importerast

## Import certificate(s) file dialog

file-browse-certificate-spec = Sertifikatfiler
import-ca-certs-prompt = Vel fil som inneheld CA-sertifikat(a) du vil importerae
import-email-cert-prompt = Vel fil som inneheld e-postsertifikatet du vil importere

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = Sertifikatet «{ $certName }» representerer ein sertifikatutskrivar.

## For Deleting Certificates

delete-user-cert-title =
    .title = Slett sertifikata dine
delete-user-cert-confirm = Er du sikker på at du vil sletta desse sertifikata?
delete-user-cert-impact = Dersom du slettar eitt av dine eigne sertifikat, kan du ikkje lenger bruka det for å identifisere deg sjølv.


delete-ssl-override-title =
    .title = Slett unntak i nettstadsertifikat
delete-ssl-override-confirm = Er du sikker på at du vil slette dette nettstadunntaket?
delete-ssl-override-impact = Dersom du slettar eit nettstadunntak vil du gjenopprette den vanlege sikkerheitskontrollen for nettstaden og krev at det brukar eit gyldig sertifikat.

delete-ca-cert-title =
    .title = Slett eller fjern tiltru til CA-sertifikat
delete-ca-cert-confirm = Du har førespurt å slette desse CA-sertifikata. For innebygde sertifikat vil all tiltru til desse verte fjerna, noko som vil ha den same effekten som å sletta dei. Er du sikker på at du vil sletta og/eller fjerna tiltru?
delete-ca-cert-impact = Dersom du slettar eller fjernar tiltru til ein sertifikatutskrivar (CA) vil dette programmet ikkje lenger stola på sertifikat som vart utskrivne av den CA-en.


delete-email-cert-title =
    .title = Slett e-postsertifikat
delete-email-cert-confirm = Er du sikker på at du vil sletta e-postsertifikata åt desse personane?
delete-email-cert-impact = Dersom du slettar ein person sitt e-postsertifikat vil du ikkje lenger kunne senda kryptert e-post til den personen.

# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Sertifikat med serienummer: { $serialNumber }

## Cert Viewer

# Used to indicate that the user chose not to send a client authentication certificate to a server that requested one in a TLS handshake.
send-no-client-certificate = Ikkje send klientsertifikat

# Used when no cert is stored for an override
no-cert-stored-for-override = (Ikkje lagra)

# When a certificate is unavailable (for example, it has been deleted or the token it exists on has been removed).
certificate-not-available = (Utilgjengeleg)

## Used to show whether an override is temporary or permanent

permanent-override = Permanent
temporary-override = Mellombels

## Add Security Exception dialog

add-exception-branded-warning = Du overstyrer no korleis { -brand-short-name } identifiserer denne tenaren.
add-exception-invalid-header = Denne netstaden prøver å identifisera seg med ugyldig informasjon.
add-exception-domain-mismatch-short = Feil nettstad
add-exception-domain-mismatch-long = Sertifikatet høyrer til ein annan nettstad, noko som kan tyda at nokon freistar å etterlikna nettstaden.
add-exception-expired-short = Forelda informasjon
add-exception-expired-long = Sertifikatet er ikkje gyldig no. Sertifikatet kan ha vorte stole eller tapt, og det kan vera at nokon brukar det til å etterlikna denne nettstaden.
add-exception-unverified-or-bad-signature-short = Ukjend identitet
add-exception-unverified-or-bad-signature-long = Sertifikatet er ikkje tiltrudd fordi det ikkje er stadfesta at sertifikatet er skrive ut av ein kjend utskrivar med ein trygg signatur.
add-exception-valid-short = Gyldig sertifikat
add-exception-valid-long = Denne nettstaden har ein gyldig, stadfesta identitet. Det er ikkje nødvendig å leggja til eit unntak.
add-exception-checking-short = Kontrollerer informasjon
add-exception-checking-long = Freistar å identifisera denne nettstaden …
add-exception-no-cert-short = Ingen informasjon er tilgjengeleg
add-exception-no-cert-long = Klarte ikkje å henta identitetsinformasjon for denne nettstaden.

## Certificate export "Save as" and error dialogs

save-cert-as = Lagre sertifikat til fil
cert-format-base64 = X.509 sertifikat (PEM)
cert-format-base64-chain = X.509 sertifikat med kjede (PEM)
cert-format-der = X.509 sertifikat (DER)
cert-format-pkcs7 = X.509 sertifikat (PKCS#7)
cert-format-pkcs7-chain = X.509 sertifikat med kjede (PKCS#7)
write-file-failure = Feil med fil
