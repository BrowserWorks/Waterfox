# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = Sivuston { $hostname } tietoturvavarmenne ei ole kelvollinen.

cert-error-mitm-intro = Sivustot todistavat identiteettinsä varmenteella, ja varmenteen myöntää varmentaja.

cert-error-mitm-mozilla = { -brand-short-name }in tukena on voittoa tavoittelematon Mozilla, joka hallinnoi täysin avointa varmentajien (CA) säilöä. Varmentajasäilö auttaa varmistamaan, että varmentajat noudattavat käyttäjien tietoturvaan liittyviä hyviä käytäntöjä.

cert-error-mitm-connection = { -brand-short-name } käyttää Mozillan varmentajasäilöä varmentamaan yhteyden turvallisuuden, käyttöjärjestelmään asennettujen varmenteiden sijasta. Siispä jos virustorjuntaohjelma tai verkko kaappaa yhteyden käyttäen varmennetta, jonka varmentaja ei ole Mozillan varmentajasäilössä, yhteyttä pidetään epäturvallisena.

cert-error-trust-unknown-issuer-intro = Joku saattaa yrittää tekeytyä täksi sivustoksi eikä sivustolle siirtymistä siksi tulisi jatkaa.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Sivustot todistavat identiteettinsä varmenteella. { -brand-short-name } ei luota palvelimeen { $hostname }, koska sen varmenteen myöntäjä on tuntematon, varmenne on allekirjoitettu itsellään tai palvelin ei lähetä oikeita välivarmenteita.

cert-error-trust-cert-invalid = Varmenteeseen ei luoteta, koska sen varmentajan varmenne ei ole kelvollinen.

cert-error-trust-untrusted-issuer = Varmenteeseen ei luoteta, koska sen myöntäjän varmenteeseen ei luoteta.

cert-error-trust-signature-algorithm-disabled = Varmenteeseen ei luoteta, koska se on allekirjoitettu allekirjoitusalgoritmilla, joka ei ole turvallinen.

cert-error-trust-expired-issuer = Varmenteeseen ei luoteta, koska sen myöntäjän varmenne on vanhentunut.

cert-error-trust-self-signed = Varmenteeseen ei luoteta, koska se on allekirjoitettu itsellään.

cert-error-trust-symantec = Varmenteisiin, joiden myöntäjänä on GeoTrust, RapidSSL, Symantec, Thawte tai VeriSign, ei enää luoteta, koska nämä varmenteiden myöntäjät eivät noudattaneet tietoturvakäytäntöjä.

cert-error-untrusted-default = Varmenteen lähde ei ole luotettu.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Sivustot todistavat identiteettinsä varmenteella. { -brand-short-name } ei luota tähän sivustoon, koska sen käyttämä varmenne ei ole kelvollinen palvelimelle { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Sivustot todistavat identiteettinsä varmenteella. { -brand-short-name } ei luota tähän sivustoon, koska sen käyttämä varmenne ei ole kelvollinen palvelimelle { $hostname }. Varmenne on kelvollinen vain kohteelle <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Sivustot todistavat identiteettinsä varmenteella. { -brand-short-name } ei luota tähän sivustoon, koska sen käyttämä varmenne ei ole kelvollinen palvelimelle { $hostname }. Varmenne on kelvollinen vain kohteelle { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Sivustot todistavat identiteettinsä varmenteella. { -brand-short-name } ei luota tähän sivustoon, koska sen käyttämä varmenne ei ole kelvollinen palvelimelle { $hostname }. Varmenne on kelvollinen vain palvelimille: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Sivustot todistavat identiteettinsä varmenteella, joka on voimassa määräajan. Varmenne sivustolle { $hostname } vanheni { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Sivustot todistavat identiteettinsä varmenteella, joka on voimassa määräajan. Varmenne sivustolle { $hostname } on voimassa vasta { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Virhekoodi: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Sivustot todistavat identiteettinsä varmenteella, jonka myöntää varmentaja. Useimmat selaimet eivät enää luota varmenteisiin, joiden varmentaja on GeoTrust, RapidSSL, Symantec, Thawte tai VeriSign. { $hostname } käyttää varmennetta, jonka on myöntänyt jokin ennalta mainituista varmentajista. Sivuston identiteettiä ei siksi voida todistaa.

cert-error-symantec-distrust-admin = Voit ilmoittaa tästä ongelmasta sivuston ylläpitäjälle.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }

cert-error-details-cert-chain-label = Certificate chain:

open-in-new-window-for-csp-or-xfo-error = Avaa sivusto uuteen ikkunaan

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Turvallisuutesi suojaamiseksi { $hostname } ei salli, että { -brand-short-name } näyttää sivun, jos se on upotettu toiselle sivulle. Jotta voit nähdä tämän sivun, sinun tulee avata se uudessa ikkunassa.

## Messages used for certificate error titles

connectionFailure-title = Yhdistäminen epäonnistui
deniedPortAccess-title = Osoitteen käyttö on rajoitettu
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Hmm. Sivua ei löydy.
fileNotFound-title = Tiedostoa ei löytynyt
fileAccessDenied-title = Tiedoston käyttö estettiin
generic-title = Verkkopyyntöä ei kyetä toteuttamaan
captivePortal-title = Kirjaudu verkkoon
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hmm. Tuo osoite ei näytä oikealta.
netInterrupt-title = Tiedonsiirto keskeytyi
notCached-title = Dokumentti on vanhentunut
netOffline-title = Yhteydettömässä tilassa
contentEncodingError-title = Sisällön koodausvirhe
unsafeContentType-title = Vaarallinen tiedostotyyppi
netReset-title = Yhteys keskeytyi
netTimeout-title = Yhteyden aikakatkaisu
unknownProtocolFound-title = Osoitetta ei ymmärretty
proxyConnectFailure-title = Välityspalvelin kieltäytyy yhteydestä
proxyResolveFailure-title = Välityspalvelinta ei löytynyt
redirectLoop-title = Sivusto ei uudelleenohjaudu asianmukaisesti
unknownSocketType-title = Odottamaton vastaus palvelimelta
nssFailure2-title = Suojatun yhteyden muodostaminen epäonnistui
csp-xfo-error-title = { -brand-short-name } ei voi avata tätä sivua
corruptedContentError-title = Sisältö vioittunut -virhe
remoteXUL-title = XUL-koodia etänä
sslv3Used-title = Ei voitu muodostaa suojattua yhteyttä
inadequateSecurityError-title = Yhteys ei ole suojattu
blockedByPolicy-title = Estetty sivu
clockSkewError-title = Tietokoneen kello on väärässä ajassa
networkProtocolError-title = Verkkoyhteyskäytännön virhe
nssBadCert-title = Varoitus: mahdollinen tietoturvariski
nssBadCert-sts-title = Ei yhdistetty: mahdollinen turvallisuusongelma
certerror-mitm-title = Ohjelmisto estää { -brand-short-name }ia yhdistämästä turvallisesti tähän sivustoon
