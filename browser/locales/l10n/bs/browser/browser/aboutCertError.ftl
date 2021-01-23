# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } koristi neispravan sigurnosni certifikat.

cert-error-trust-cert-invalid = Certifikat nije povjerljiv jer ga je izdao nevažeći CA certifikat.

cert-error-trust-untrusted-issuer = Certifikat nije povjerljiv jer izdavač certifikata nije od povjerenja.

cert-error-trust-signature-algorithm-disabled = Certifikat nije povjerljiv jer je potpisan pomoću algoritma koji je onemogućen iz razloga što taj algoritam nije siguran.

cert-error-trust-expired-issuer = Certifikat nije povjerljiv jer je certifikat izdavača istekao.

cert-error-trust-self-signed = Ovaj certifikat nije povjerljiv jer je samopotpisan.

cert-error-untrusted-default = Certifikat ne dolazi od pouzdanog izvora.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Kod greške: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }

cert-error-details-cert-chain-label = Lanac certifikata:

open-in-new-window-for-csp-or-xfo-error = Otvori stranicu u novom prozoru

## Messages used for certificate error titles

connectionFailure-title = Neuspješno povezivanje
deniedPortAccess-title = Pristup adresi je ograničen
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Hmm. Imamo problema s pronalaženjem stranice.
fileNotFound-title = Fajl nije pronađen
fileAccessDenied-title = Pristup fajlu je odbijen
generic-title = Ups.
captivePortal-title = Prijavi se na mrežu
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hmm. Ova adresa ne izgleda dobro.
netInterrupt-title = Veza je prekinuta
notCached-title = Dokument je nestao
netOffline-title = Offline režim
contentEncodingError-title = Greška u enkodiranju sadržaja
unsafeContentType-title = Nesiguran tip fajla
netReset-title = Veza je resetovana
netTimeout-title = Veza je istekla
unknownProtocolFound-title = Adresa nije razumiva
proxyConnectFailure-title = Proxy server odbija veze
proxyResolveFailure-title = Ne mogu da pronađem proxy server
redirectLoop-title = Stranica ne preusmjerava pravilno
unknownSocketType-title = Neočekivani odgovor od servera
nssFailure2-title = Neuspjela sigurna veza
csp-xfo-error-title = { -brand-short-name } ne može otvoriti ovu stranicu
corruptedContentError-title = Oštećen sadržaj
remoteXUL-title = Remote XUL
sslv3Used-title = Uspostava sigurne veze nije uspjela
inadequateSecurityError-title = Vaša veza nije sigurna
blockedByPolicy-title = Blokirana stranica
clockSkewError-title = Sat vašeg računara je pogrešan
networkProtocolError-title = Greška mrežnog protokola
nssBadCert-title = Upozorenje: Potencijalni sigurnosni rizik
nssBadCert-sts-title = Nisam se povezao: Potencijalni sigurnosni problem
certerror-mitm-title = Softver sprječava da se { -brand-short-name } sigurno poveže na ovu stranicu
