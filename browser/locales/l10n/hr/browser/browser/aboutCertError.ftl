# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } koristi neispravni sigurnosni certifikat.
cert-error-mitm-intro = Web stranice dokazuju svoj identitet putem certifikata, koje izdaju certifikacijska tijela.
cert-error-mitm-mozilla = { -brand-short-name } podupire neprofitna organizacija Mozilla, koja upravlja potpuno otvorenim spremištem za certifikacijska tijela (CA). CA spremište osigurava, da se certifikacijska tijela pridržavaju najboljih sigurnosnih praksa.
cert-error-mitm-connection = { -brand-short-name } koristi Mozilla CA spremište kako bi se provjerila sigurnost veze, a ne koristi certifikate koje je isporučio operacijski sustav korisnika. Dakle, ako antivirusni program ili mreža presreću vezu sa sigurnosnim certifikatom kojeg je izdao CA, a koji nije u Mozilla CA spremištu, veza se smatra nesigurnom.
cert-error-trust-unknown-issuer-intro = Netko možda pokušava oponašati stranicu i ne biste trebali nastaviti.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Web stranice dokazuju svoj identitet putem certifikata. { -brand-short-name } ne vjeruje { $hostname } jer je izdavač certifikata nepoznat, certifikat je samostalno potpisan ili poslužitelj ne šalje ispravne intermedijarne certifikate.
cert-error-trust-cert-invalid = Certifikat nije pouzdan jer ga je izdalo nevažeće certifikacijsko tijelo (CA).
cert-error-trust-untrusted-issuer = Certifikat nije pouzdan jer izdavač certifikata nije pouzdan.
cert-error-trust-signature-algorithm-disabled = Certifikat nije pouzdan, jer je potpisan s algoritmom potpisa koji je deaktiviran iz sigurnosnih razloga.
cert-error-trust-expired-issuer = Certifikat nije pouzdan jer je certifikat izdavača istekao.
cert-error-trust-self-signed = Certifikat nije pouzdan jer je samo-potpisan.
cert-error-trust-symantec = Certifikati koje izdaju GeoTrust, RapidSSL, Symantec, Thawte i VeriSign više se ne smatraju sigurnima, jer ta certifikacijska tijela u prošlosti nisu slijedile sigurnosne prakse.
cert-error-untrusted-default = Certifikat ne dolazi iz pouzdanog izvora.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Web stranice dokazuju svoj identitet putem certifikata. { -brand-short-name } ne vjeruje ovoj stranici iz razloga što koristi certifikat koji nije valjan za { $hostname }.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Web stranice dokazuju svoj identitet putem certifikata. { -brand-short-name } ne vjeruje ovoj stranici iz razloga što koristi certifikat koji nije valjan za { $hostname }. Certifikat je valjan samo za <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Web stranice dokazuju svoj identitet putem certifikata. { -brand-short-name } ne vjeruje ovoj stranici iz razloga što koristi certifikat koji nije valjan za { $hostname }. Certifikat je valjan samo za { $alt-name }.
# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Web stranice dokazuju svoj identitet putem certifikata. { -brand-short-name } ne vjeruje ovoj stranici iz razloga što koristi certifikat koji nije valjan za { $hostname }. Certifikat je valjan samo za sljedeće nazive: { $subject-alt-names }
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Web stranice dokazuju svoj identitet putem certifikata, koji vrijede samo određeno vrijeme. Certifikat za { $hostname } je istekao { $not-after-local-time }.
# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Web stranice dokazuju svoj identitet putem certifikata, koji vrijede samo određeno vrijeme. Certifikat za { $hostname } vrijedit će tek od { $not-before-local-time }.
# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Kȏd pogreške: <a data-l10n-name="error-code-link">{ $error }</a>
# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Web stranice dokazuju svoj identitet putem certifikata koje izdaju certifikacijska tijela. Većina preglednika više ne vjeruje certifikatima koje izdaju GeoTrust, RapidSSL, Symantec, Thawte i VeriSign. { $hostname } koristi certifikat jednog od ovih izdavatelja, pa se identitet web stranice ne može dokazati.
cert-error-symantec-distrust-admin = O ovom problemu možeš obavijestiti administratora web stranice.
# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }
# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }
cert-error-details-cert-chain-label = Lanac certifikata:
open-in-new-window-for-csp-or-xfo-error = Otvori stranicu u novom prozoru
# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Iz sigurnosnih razloga, { $hostname } neće dopustiti da { -brand-short-name } prikaže stranicu, ako je u nju ugrađena jedna druga web-stranica. Za prikaz ove stranice, moraš je otvoriti u novom prozoru.

## Messages used for certificate error titles

connectionFailure-title = Povezivanje nije moguće
deniedPortAccess-title = Port je ograničen radi sigurnosnih razloga
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Ne možemo pronaći tu stranicu.
fileNotFound-title = Datoteka nije pronađena
fileAccessDenied-title = Pristup datoteci je odbijen
generic-title = Ups.
captivePortal-title = Prijava na mrežu
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hmm. Ta adresa ne izgleda dobro.
netInterrupt-title = Podatkovni prijenos je prekinut
notCached-title = Dokument je istekao
netOffline-title = Izvanmrežni rad
contentEncodingError-title = Greška kodiranja sadržaja
unsafeContentType-title = Nesiguran tip datoteke
netReset-title = Veza je prekinuta
netTimeout-title = Vezi je isteklo vrijeme
unknownProtocolFound-title = Nepoznata vrsta adrese
proxyConnectFailure-title = Proxy poslužitelj odbio vezu
proxyResolveFailure-title = Proxy poslužitelj nije pronađen
redirectLoop-title = Petlja preusmjeravanja
unknownSocketType-title = Neočekivani odgovor od poslužitelja
nssFailure2-title = Sigurna veza nije uspostavljena
csp-xfo-error-title = { -brand-short-name } ne može otvoriti ovu stranicu
corruptedContentError-title = Greška oštećenog sadržaja
remoteXUL-title = Udaljeni XUL
sslv3Used-title = Uspostava sigurne veze nije uspjela
inadequateSecurityError-title = Tvoja veza nije sigurna
blockedByPolicy-title = Blokirana stranica
clockSkewError-title = Vrijeme na tvom računalu je krivo
networkProtocolError-title = Greška mrežnog protokola
nssBadCert-title = Upozorenje: potencijalni sigurnosni rizik
nssBadCert-sts-title = Neuspjelo povezivanje: potencijalni sigurnosni problem
certerror-mitm-title = Program spriječava { -brand-short-name } da se sigurno poveže s ovom stranicom
