# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } folosește un certificat de securitate nevalid.

cert-error-mitm-intro = Site-urile își demonstrează identitatea prin certificate, care sunt eliberate de autorități de certificare.

cert-error-mitm-mozilla = { -brand-short-name } este susținut de organizația nonprofit Mozilla, care administrează un magazin de autorități de certificare (CA) complet deschis. Magazinul CA ajută la asigurarea că autoritățile de certificare respectă cele mai bune practici pentru securitatea utilizatorului.

cert-error-mitm-connection = { -brand-short-name } utilizează preponderent magazinul CA Mozilla pentru a verifica dacă o conexiune este securizată, nu certificatele furnizate de sistemul de operare al utilizatorului. Așadar, dacă un program antivirus sau o rețea interceptează o conexiune cu un certificat emis de o CA, care nu se află în magazinul CA Mozilla , conexiunea este considerată nesigură.

cert-error-trust-unknown-issuer-intro = Cineva ar putea încerca să uzurpe identitatea site-ului și nu ar trebui să continui.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Site-urile web își demonstrează identitatea prin intermediul certificatelor. { -brand-short-name } nu are încredere în { $hostname } deoarece emițătorul certificatului este necunoscut, certificatul este autosemnat sau serverul nu trimite certificatele intermediare corecte.

cert-error-trust-cert-invalid = Certificatul nu prezintă încredere deoarece a fost emis de o autoritate de certificare nevalidă.

cert-error-trust-untrusted-issuer = Certificatul nu prezintă încredere deoarece certificatul emitentului nu prezintă încredere.

cert-error-trust-signature-algorithm-disabled = Certificatul nu prezintă încredere deoarece a fost semnat folosind un algoritm de semnare care a fost dezactivat deoarece acel algoritm nu este securizat.

cert-error-trust-expired-issuer = Certificatul nu prezintă încredere deoarece certificatul emitentului a expirat.

cert-error-trust-self-signed = Certificatul nu prezintă încredere deoarece este semnat de el însuși.

cert-error-trust-symantec = Certificatele emise de GeoTrust, RapidSSL, Symantec, Thawte și VeriSign nu mai sunt considerate sigure deoarece aceste autorități de certificare nu au respectat în trecut practicile de securitate.

cert-error-untrusted-default = Certificatul nu provine de la o sursă de încredere.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Site-urile web își demonstrează identitatea prin intermediul certificatelor. { -brand-short-name } nu are încredere în acest site deoarece folosește un certificat care nu este valid pentru { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Site-urile web își demonstrează identitatea prin intermediul certificatelor. { -brand-short-name } nu are încredere în acest site deoarece folosește un certificat care nu este valid pentru { $hostname }. Certificatul este valid numai pentru <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Site-urile web își demonstrează identitatea prin intermediul certificatelor. { -brand-short-name } nu are încredere în acest site deoarece folosește un certificat care nu este valid pentru { $hostname }. Certificatul este valid numai pentru { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Site-urile web își demonstrează identitatea prin intermediul certificatelor. { -brand-short-name } nu are încredere în acest site deoarece folosește un certificat care nu este valid pentru { $hostname }. Certificatul este valid numai pentru următoarele nume: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Site-urile web își demonstrează identitatea prin certificate, care sunt valide pe un interval definit de timp. Certificatul pentru { $hostname } a expirat la { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Site-urile web își demonstrează identitatea prin certificate, care sunt valide pe un interval definit de timp. Certificatul pentru { $hostname } nu va fi valabil până la { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Codul erorii: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Site-urile web își demonstrează identitatea prin intermediul certificatelor, care sunt emise de autorități de certificare. Majoritatea browserelor nu mai au încredere în certificatele emise de GeoTrust, RapidSSL, Symantec, Thawte și VeriSign. { $hostname } folosește un certificat de la una dintre aceste autorități și, prin urmare, identitatea site-ului web nu poate fi demonstrată.

cert-error-symantec-distrust-admin = Poți notifica administratorul site-ului web despre această problemă.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = Securitate strictă la transport HTTP: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = Fixarea cheii publice HTTP: { $hasHPKP }

cert-error-details-cert-chain-label = Lanț de certificate:

open-in-new-window-for-csp-or-xfo-error = Deschide site-ul într-o fereastră nouă

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Pentru a-ți proteja securitatea, { $hostname } nu va permite { -brand-short-name } să afișeze pagina dacă a fost încorporată de alt site. Pentru a vedea această pagină, trebuie să o deschizi într-o fereastră nouă.

## Messages used for certificate error titles

connectionFailure-title = Nu se poate conecta
deniedPortAccess-title = Adresa este restricționată
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Hmm. Întâmpinăm dificultăți în găsirea acestui site.
fileNotFound-title = Fișier negăsit
fileAccessDenied-title = Accesul la fișier a fost refuzat
generic-title = Ups.
captivePortal-title = Autentifică-te în rețea
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hmm. Adresa nu pare să fie în regulă.
netInterrupt-title = Conexiunea a fost întreruptă
notCached-title = Document expirat
netOffline-title = Mod offline
contentEncodingError-title = Eroare în codarea conținutului
unsafeContentType-title = Tip de fișier nesigur
netReset-title = Conexiunea a fost reinițializată
netTimeout-title = Timpul de conectare a expirat
unknownProtocolFound-title = Adresa nu a fost înțeleasă
proxyConnectFailure-title = Serverul proxy refuză conexiuni
proxyResolveFailure-title = Nu se poate găsi serverul proxy
redirectLoop-title = Pagina nu redirecționează corect
unknownSocketType-title = Răspuns neașteptat de la server
nssFailure2-title = Conexiunea securizată a eșuat
csp-xfo-error-title = { -brand-short-name } nu poate deschide această pagină
corruptedContentError-title = Eroare cauzată de conținut corupt
remoteXUL-title = XUL la distanță
sslv3Used-title = Nu se poate conecta în mod securizat
inadequateSecurityError-title = Conexiunea nu este securizată
blockedByPolicy-title = Pagină blocată
clockSkewError-title = Ceasul calculatorului indică o oră greșită
networkProtocolError-title = Eroare legată de protocolul de rețea
nssBadCert-title = Avertisment: Urmează un posibil risc de securitate
nssBadCert-sts-title = Nu s-a realizat conectarea: Posibilă problemă de securitate
certerror-mitm-title = Un program împiedică { -brand-short-name } să se conecteze în siguranță la acest site
