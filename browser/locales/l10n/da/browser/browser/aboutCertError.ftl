# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } bruger et ugyldigt sikkerhedscertifikat.

cert-error-mitm-intro = Websteder bekræfter deres identitet ved hjælp af sikkerhedscertifikater, der er udstedt af certifikat-autoriteter (CA).

cert-error-mitm-mozilla = { -brand-short-name } er støttet af nonprofit-organisationen Mozilla, der administrer et helt åbent lager for certifikat-autoriter (CA-lager). Dette lager sikrer, at certifikat-autoriteter følger de korrekte retningslinjer for brugernes sikkerhed.

cert-error-mitm-connection = { -brand-short-name } bruger Mozillas CA-lager til at sikre, at en forbindelse er sikker - fremfor at bruge de certifikater, brugerens operativsystem leverer. Det vil sige, at forbindelsen betragtes som usikker, hvis et antivirus-program eller et netværk opfanger en forbindelse med et sikkerhedscertifikat, udstedt af en CA, der ikke findes i Mozillas CA-lager.

cert-error-trust-unknown-issuer-intro = Nogen kan have lavet en falsk version af webstedet, og du bør ikke fortsætte.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Websteder bekræfter deres identitet ved hjælp af sikkerhedscertifikater. { -brand-short-name } stoler ikke på { $hostname }, fordi udstederen af webstedets certifikat er ukendt, fordi certifikatet er underskrevet af indehaveren selv, eller fordi serveren ikke sender de korrekte mellemliggende certifikater.

cert-error-trust-cert-invalid = Der stoles ikke på certifikatet, fordi det er udstedt af et ugyldigt CA-certifikat.

cert-error-trust-untrusted-issuer = Der stoles ikke på certifikatet, fordi der ikke stoles på udstederens certifikat.

cert-error-trust-signature-algorithm-disabled = Der stoles ikke på certifikatet, fordi det er underskrevet med en usikker algoritme.

cert-error-trust-expired-issuer = Der stoles ikke på certifikatet, fordi udstederens certifikat er udløbet.

cert-error-trust-self-signed = Der stoles ikke på certifikatet, da det er underskrevet af indehaveren selv.

cert-error-trust-symantec = Sikkerhedscertifikater udstedt af GeoTrust, RapidSSL, Symantec, Thawte, og VeriSign bliver ikke længere opdattet som sikre, fordi disse certifikat-udstedere tidligere ikke har fulgt gængse sikkerheds-praksisser.

cert-error-untrusted-default = Certifikatet stammer ikke fra en kilde, der er tillid til.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Websteder bekræfter deres identitet ved hjælp af sikkerhedscertifikater. { -brand-short-name } stoler ikke på { $hostname }, fordi webstedet bruger et certifikat, der ikke er gyldigt for { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Websteder bekræfter deres identitet ved hjælp af sikkerhedscertifikater. { -brand-short-name } stoler ikke på { $hostname }, fordi webstedet bruger et certifikat, der ikke er gyldigt for { $hostname }. Certifikatet er kun gyldigt for <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Websteder bekræfter deres identitet ved hjælp af sikkerhedscertifikater. { -brand-short-name } stoler ikke på { $hostname }, fordi webstedet bruger et certifikat, der ikke er gyldigt for { $hostname }. Certifikatet er kun gyldigt for { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Websteder bekræfter deres identitet ved hjælp af sikkerhedscertifikater. { -brand-short-name } stoler ikke på { $hostname }, fordi webstedet bruger et certifikat, der ikke er gyldigt for { $hostname }. Certifikatet er kun gyldigt for følgende navne: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Websteder bekræfter deres identitet ved hjælp af sikkerhedscertifikater, der er gyldige i en bestemt periode. Certifikatet for { $hostname } udløb { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Websteder bekræfter deres identitet ved hjælp af sikkerhedscertifikater, der er gyldige i en bestemt periode. Certifikatet for { $hostname } er ikke gyldigt før { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Fejlkode: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Websteder bekræfter deres identitet ved hjælp af sikkerhedscertifikater, der er udstedt af certifikat-autoriteter. De fleste browsere stoler ikke længere på certifikater udstedt af GeoTrust, RapidSSL, Symantec, Thawte, og VeriSign. { $hostname } bruger et certifikat fra én af disse autoriteter, og webstedets identitet kan derfor ikke bekræftes.

cert-error-symantec-distrust-admin = Du kan prøve at kontakte webstedets administrator for at gøre opmærksom på problemet.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }

cert-error-details-cert-chain-label = Certifikatkæde:

open-in-new-window-for-csp-or-xfo-error = Åbn websted i et nyt vindue

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = For at beskytte din sikkerhed vil { $hostname } ikke tillade, at { -brand-short-name } viser siden, hvis et andet websted har indlejret den. Du skal åbne siden i et nyt vindue for at se den. 

## Messages used for certificate error titles

connectionFailure-title = Ude af stand til at oprette forbindelse
deniedPortAccess-title = Adgang til denne adresse er underlagt begrænsninger
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Hmm. Den side kan vi ikke finde…
fileNotFound-title = Fil ikke fundet
fileAccessDenied-title = Filen kunne ikke tilgås
generic-title = Hovsa.
captivePortal-title = Login til netværk
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hmm. Den adresse ser ikke rigtig ud.
netInterrupt-title = Forbindelsen blev afbrudt
notCached-title = Siden er udløbet
netOffline-title = Offline-tilstand
contentEncodingError-title = Indholdskodningsfejl
unsafeContentType-title = Usikker filtype
netReset-title = Forbindelsen blev nulstillet
netTimeout-title = Forbindelsens tidsfrist udløb
unknownProtocolFound-title = Adressen kunne ikke forstås
proxyConnectFailure-title = Proxyserveren afviser forbindelser
proxyResolveFailure-title = Kunne ikke finde proxyserveren
redirectLoop-title = Denne side viderestiller ikke forespørgslen korrekt
unknownSocketType-title = Uventet svar fra server
nssFailure2-title = Sikker forbindelse mislykkedes
csp-xfo-error-title = { -brand-short-name } kan ikke åbne denne side
corruptedContentError-title = Fejlbehæftet indhold
remoteXUL-title = Remote XUL
sslv3Used-title = Kan ikke oprette sikker forbindelse
inadequateSecurityError-title = Din forbindelse er ikke sikker
blockedByPolicy-title = Blokeret side
clockSkewError-title = Uret i din computer er indstillet forkert
networkProtocolError-title = Fejl i netværksprotokol
nssBadCert-title = Advarsel: Mulig sikkerhedsrisiko
nssBadCert-sts-title = Oprettede ikke forbindelse: Muligt sikkerhedsproblem
certerror-mitm-title = Et program forhindrer { -brand-short-name } i at oprette en sikker forbindelse til dette websted.
