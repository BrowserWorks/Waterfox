# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } använder ett ogiltigt säkerhetscertifikat.

cert-error-mitm-intro = Webbplatser bevisar sin identitet via certifikat, som utfärdas av certifikatutfärdare.

cert-error-mitm-mozilla = { -brand-short-name } stöds av den icke-kommersiella Mozilla, som administrerar en helt öppen CA-butik. CA-butiken hjälper till att säkerställa att certifikatutfärdare följer bästa praxis för användarsäkerhet.

cert-error-mitm-connection = { -brand-short-name } använder Mozillas CA-butik för att verifiera att en anslutning är säker, snarare än certifikat som tillhandahålls av användarens operativsystem. Så om ett antivirusprogram eller ett nätverk avlyssnar en anslutning med ett säkerhetscertifikat utfärdat av en CA som inte finns i Mozilla CA-butik, anses anslutningen vara osäker.

cert-error-trust-unknown-issuer-intro = Någon försöker att efterlikna webbplatsen och du borde inte fortsätta.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Webbplatser bevisar sin identitet via certifikat. { -brand-short-name } litar inte på { $hostname } eftersom certifikatutgivaren är okänd, certifikatet är självsignerat eller servern skickar inte rätt mellanliggande certifikat.

cert-error-trust-cert-invalid = Certifikatet är inte betrott eftersom det är utfärdat av ett ogiltigt CA-certifikat.

cert-error-trust-untrusted-issuer = Certifikatet är inte betrott eftersom utfärdarcertifikatet inte är betrott.

cert-error-trust-signature-algorithm-disabled = Certifikatet är inte betrott eftersom det signerades med en signaturalgoritm som är inaktiverad på grund av att den är osäker.

cert-error-trust-expired-issuer = Certifikatet är inte betrott eftersom utfärdarcertifikatet har förfallit.

cert-error-trust-self-signed = Certifikatet är inte betrott eftersom det är självsignerat.

cert-error-trust-symantec = Certifikat som utfärdas av GeoTrust, RapidSSL, Symantec, Thawte och VeriSign anses inte längre säkra eftersom dessa certifikatmyndigheter misslyckades med att följa säkerhetspraxis tidigare.

cert-error-untrusted-default = Certifikatet kommer inte från en betrodd källa.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Webbplatser bevisar sin identitet via certifikat. { -brand-short-name } litar inte på den här webbplatsen eftersom den använder ett certifikat som inte är giltigt för { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Webbplatser bevisar sin identitet via certifikat. { -brand-short-name } litar inte på den här webbplatsen eftersom den använder ett certifikat som inte är giltigt för { $hostname }. Certifikatet är endast giltigt för <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Webbplatser bevisar sin identitet via certifikat. { -brand-short-name } litar inte på den här webbplatsen eftersom den använder ett certifikat som inte är giltigt för { $hostname }. Certifikatet är endast giltigt för { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Webbplatser bevisar sin identitet via certifikat. { -brand-short-name } litar inte på den här webbplatsen eftersom den använder ett certifikat som inte är giltigt för { $hostname }. Certifikatet är endast giltigt för följande namn: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Webbplatser bevisar sin identitet via certifikat, som gäller för en viss tidsperiod. Certifikatet för { $hostname } upphörde den { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Webbplatser bevisar sin identitet via certifikat, som gäller för en viss tidsperiod. Certifikatet för { $hostname } är inte giltigt till { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Felkod: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Webbplatser bevisar sin identitet via certifikat, som utfärdas av certifikatmyndigheter. De flesta webbläsare litar inte längre på certifikat som utfärdats av GeoTrust, RapidSSL, Symantec, Thawte och VeriSign. { $hostname } använder ett certifikat från en av dessa myndigheter och så kan inte webbplatsens identitet bevisas.

cert-error-symantec-distrust-admin = Du kan meddela webbplatsens administratör om detta problem.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = Pinnad offentlig HTTP nyckel: { $hasHPKP }

cert-error-details-cert-chain-label = Certifikatkedja:

open-in-new-window-for-csp-or-xfo-error = Öppna webbplatsen i nytt fönster

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = För att skydda din säkerhet tillåter { $hostname } inte { -brand-short-name } att visa sidan om en annan webbplats har den inbäddad. För att se den här sidan måste du öppna den i ett nytt fönster.

## Messages used for certificate error titles

connectionFailure-title = Anslutningen misslyckades
deniedPortAccess-title = Adressen har säkerhetsrestriktioner
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Hmm. Vi har problem med att hitta den webbplatsen.
fileNotFound-title = Filen hittades inte
fileAccessDenied-title = Åtkomst till filen nekades
generic-title = Hoppsan.
captivePortal-title = Logga in till nätverk
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hmm. Den adressen ser inte rätt ut.
netInterrupt-title = Anslutningen avbröts
notCached-title = Utgånget dokument
netOffline-title = Nedkopplat läge
contentEncodingError-title = Kodningsfel av innehållet
unsafeContentType-title = Osäker filtyp
netReset-title = Anslutningen avbröts
netTimeout-title = Anslutningen avbröts
unknownProtocolFound-title = Adressen förstods inte
proxyConnectFailure-title = Proxyservern avvisar anslutningen
proxyResolveFailure-title = Kan inte hitta proxyservern
redirectLoop-title = Sidan dirigeras om felaktigt
unknownSocketType-title = Oväntat svar från servern
nssFailure2-title = Säker anslutning misslyckades
csp-xfo-error-title = { -brand-short-name } Kan inte öppna den här sidan
corruptedContentError-title = Skadat innehåll
remoteXUL-title = Extern XUL
sslv3Used-title = Kan inte ansluta säkert
inadequateSecurityError-title = Din anslutning är inte säker
blockedByPolicy-title = Blockerad sida
clockSkewError-title = Din dators klocka går fel
networkProtocolError-title = Nätverksprotokollfel
nssBadCert-title = Varning: Möjlig säkerhetsrisk framöver
nssBadCert-sts-title = Kunde inte ansluta: Potentiellt säkerhetsproblem
certerror-mitm-title = Programvaran hindrar { -brand-short-name } från säker anslutning till den här webbplatsen
