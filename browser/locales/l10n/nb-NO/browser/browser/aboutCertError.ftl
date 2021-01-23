# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } bruker et ugyldig sikkerhetssertifikat.

cert-error-mitm-intro = Nettsteder beviser sin identitet via sertifikater, som utstedes av sertifikatmyndigheter.

cert-error-mitm-mozilla = { -brand-short-name } er støttet av den ideelle organisasjonen Mozilla, som driver en fullstendig åpen database for sertifiseringsmyndigheter (CA Store). Denne databasen bidrar til å sikre at sertifiseringsmyndighetene overholder brukerens beste praksis for brukersikkerhet.

cert-error-mitm-connection = { -brand-short-name } bruker Mozilla sin database for sertifiseringsmyndigheter (CA Store) for å bekrefte om en forbindelse er trygg, istedenfor sertifikat som leveres av brukerens operativsystem. Så om et antivirusprogram eller et nettverk avlytter en tilkobling med et sikkerhetssertifikat utstedt av en sertifiseringsmyndighet som ikke finnes i Mozillas database, anses forbindelsen som usikker.

cert-error-trust-unknown-issuer-intro = Noen kan prøve å etterligne nettstedet, og du bør ikke fortsette.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Nettsteder beviser identiteten sin via sertifikater. { -brand-short-name } stoler ikke på { $hostname } fordi sertifikatutstederen er ukjent, sertifikatet er selv-signert, eller fordi serveren ikke sender de rette mellomsertifikatene.

cert-error-trust-cert-invalid = Sertifikatet er ikke tiltrodd fordi det er utstedt av et ugyldig CA-sertifikat.

cert-error-trust-untrusted-issuer = Sertifikatet er ikke tiltrodd fordi utstedersertifikatet ikke er tiltrodd.

cert-error-trust-signature-algorithm-disabled = Sertifikatet er ikke tiltrodd fordi det ble signert med en signaturalgoritme som er avslått fordi algoritmen ikke er sikker.

cert-error-trust-expired-issuer = Sertifikatet er ikke tiltrodd fordi utstedersertifikatet har gått ut på dato.

cert-error-trust-self-signed = Sertifikatet er ikke tiltrodd fordi det er selvsignert.

cert-error-trust-symantec = Sertifikater utstedt av GeoTrust, RapidSSL, Symantec, Thawte og VeriSign anses ikke lenger som trygge fordi disse sertifikatmyndighetene ikke klarte å følge sikkerhetspraksis tidligere.

cert-error-untrusted-default = Sertifikatet kommer ikke fra en tiltrodd kilde.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Nettsteder beviser identiteten sin via sertifikater. { -brand-short-name } stoler ikke på dette nettstedet fordi det bruker et sertifikat som ikke er gyldig for { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Nettsteder beviser identiteten sin via sertifikater. { -brand-short-name } stoler ikke på dette nettstedet fordi det bruker et sertifikat som ikke er gyldig for { $hostname }. Sertifikatet er bare gyldig for <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Nettsteder beviser identiteten sin via sertifikater. { -brand-short-name } stoler ikke på dette nettstedet fordi det bruker et sertifikat som ikke er gyldig for { $hostname }. Sertifikatet er bare gyldig for { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Nettsteder beviser identiteten sin via sertifikater. { -brand-short-name } stoler ikke på dette nettstedet fordi det bruker et sertifikat som ikke er gyldig for { $hostname }. Sertifikatet er bare gyldig for følgende navn: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Nettsteder bekrefter deres identitet ved hjelp av sikkerhets-sertifikater som er gyldige i en bestemt periode. Sertifikatet for { $hostname } utløp { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Nettsteder bekrefter deres identitet ved hjelp av sikkerhets-sertifikater som er gyldige i en bestemt periode. Sertifikatet for { $hostname } vil ikke være gyldig før { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Feilkode: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Nettsteder viser sin identitet via sertifikater, som utstedes av sertifikatmyndigheter. De fleste nettlesere stoler ikke lenger på sertifikater utstedt av GeoTrust, RapidSSL, Symantec, Thawte og VeriSign. { $hostname } bruker et sertifikat fra en av disse myndighetene, og dermed kan nettstedets identitet ikke bevises.

cert-error-symantec-distrust-admin = Du kan varsle nettstedets administrator om dette problemet.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }

cert-error-details-cert-chain-label = Sertifikatkjede:

open-in-new-window-for-csp-or-xfo-error = Åpne nettsted i nytt vindu

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = For å ta vare på sikkerheten din, vil { $hostname } ikke tillate at { -brand-short-name } viser siden hvis et annet nettsted har bygd den inn. For å se denne siden, må du åpne den i et nytt vindu.

## Messages used for certificate error titles

connectionFailure-title = Kan ikke koble til
deniedPortAccess-title = Tilgang til denne adressen er begrenset
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Hmm. Vi har problemer med å finne nettstedet.
fileNotFound-title = Fil ikke funnet
fileAccessDenied-title = Tilgang til filen ble nektet
generic-title = Ops.
captivePortal-title = Logg inn på nettverket
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hmm. Den adressen ser ikke riktig ut.
netInterrupt-title = Tilkoblingen ble avbrutt
notCached-title = Dokumentet er utgått på dato
netOffline-title = Frakoblet modus
contentEncodingError-title = Feil med tegnkoding
unsafeContentType-title = Utrygg filtype
netReset-title = Tilkoblingen ble avbrutt
netTimeout-title = Tilkoblingen fikk tidsavbrudd
unknownProtocolFound-title = Klarte ikke forstå adressen
proxyConnectFailure-title = Proxy godtar ikke tilkoblinger
proxyResolveFailure-title = Klarte ikke finne proxy
redirectLoop-title = Nettsiden videresender ikke ordentlig
unknownSocketType-title = Uventet svar fra server
nssFailure2-title = Sikker tilkobling mislyktes
csp-xfo-error-title = { -brand-short-name } kan ikke åpne denne siden
corruptedContentError-title = Ødelagt innhold
remoteXUL-title = Ekstern XUL
sslv3Used-title = Klarte ikke å koble til sikkert
inadequateSecurityError-title = Tilkoblingen din er ikke sikker
blockedByPolicy-title = Blokkert side
clockSkewError-title = Klokken på datamaskinen din er feil
networkProtocolError-title = Nettverksprotokollfeil
nssBadCert-title = Advarsel: Potensiell sikkerhetsrisiko forut
nssBadCert-sts-title = Koblet ikke til: Potensielt sikkerhetsproblem
certerror-mitm-title = Programvare hindrer { -brand-short-name } fra sikker tilkobling til dette nettstedet
