# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = Server { $hostname } používa neplatný bezpečnostný certifikát.

cert-error-mitm-intro = Webové stránky preukazujú svoju identitu pomocou certifikátov, ktoré vydávajú certifikačné autority.

cert-error-mitm-mozilla = Za aplikáciou { -brand-short-name } stojí nezisková organizácia Mozilla, ktorá spravuje otvorené úložisko certifikačných autorít (CA). Toto úložisko zaisťuje, že certifikačné autority dodržiavajú osvedčené bezpečnostné postupy.

cert-error-mitm-connection = { -brand-short-name } používa úložisko certifikačných autorít od Mozilly, nie úložisko z operačného systému. Ak antivírusový program alebo niekto v sieti zachytáva spojenie s použitím certifikátov od autority, ktorá v úložisku Mozilly nie je, je toto spojenie považované za nezabezpečené.

cert-error-trust-unknown-issuer-intro = Niekto sa môže za danú stránku vydávať a preto by ste nemali pokračovať v pripájaní sa.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Webové stránky preukazujú svoju identitu pomocou bezpečnostných certifikátov. { -brand-short-name } nemôže stránku { $hostname } overiť, pretože vydavateľ daného certifikátu je neznámy, certifikát je podpísaný vlastným podpisom alebo server neposiela správne sprostredkujúce certifikáty.

cert-error-trust-cert-invalid = Certifikát nie je dôveryhodný, pretože bol vydaný neplatnou certifikačnou autoritou.

cert-error-trust-untrusted-issuer = Certifikát nie je dôveryhodný, pretože vydavateľ certifikátu nie je dôveryhodný.

cert-error-trust-signature-algorithm-disabled = Certifikát nie je dôveryhodný, pretože bol podpísaný použitím algoritmu, ktorý nie je bezpečný.

cert-error-trust-expired-issuer = Certifikát nie je dôveryhodný, pretože platnosť certifikátu vydavateľa uplynula.

cert-error-trust-self-signed = Certifikát nie je dôveryhodný, pretože je podpísaný vlastným podpisom.

cert-error-trust-symantec = Kvôli bezpečnostným previneniam spoločností GeoTrust, RapidSSL, Symantec, Thawte a VeriSign, nie sú certifikáty vydávané týmito spoločnosťami naďalej považované za bezpečné.

cert-error-untrusted-default = Certifikát nepochádza z dôveryhodného zdroja.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Webové stránky preukazujú svoju identitu pomocou certifikátov. { -brand-short-name } nemôže túto stránku overiť, pretože používa bezpečnostný certifikát, ktorý nie je platný pre { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Webové stránky preukazujú svoju identitu pomocou certifikátov. { -brand-short-name } nemôže túto stránku overiť, pretože používa bezpečnostný certifikát, ktorý nie je platný pre { $hostname }. Certifikát je platný len pre <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Webové stránky preukazujú svoju identitu pomocou certifikátov. { -brand-short-name } nemôže túto stránku overiť, pretože používa bezpečnostný certifikát, ktorý nie je platný pre { $hostname }. Certifikát je platný len pre { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Webové stránky preukazujú svoju identitu pomocou certifikátov. { -brand-short-name } nemôže túto stránku overiť, pretože používa certifikát, ktorý nie je platný pre { $hostname }. Certifikát je platný pre nasledujúce názvy domén: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Webové stránky preukazujú svoju identitu pomocou certifikátov, ktoré majú obmedzenú platnosť. Platnosť certifikátu pre { $hostname } vypršala { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Webové stránky preukazujú svoju identitu pomocou certifikátov, ktoré majú obmedzenú platnosť. Certifikát pre { $hostname } bude platný až od { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Kód chyby: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Webové stránky preukazujú svoju identitu pomocou certifikátov. Väčšina prehliadačov už nedôveruje certifikátom od spoločností GeoTrust, RapidSSL, Symantec, Thawte a VeriSign. Stránka { $hostname } používa certifikát vydaný jednou z týchto spoločností a preto jej totožnosť nie je možné overiť.

cert-error-symantec-distrust-admin = O tomto probléme môžete informovať správcu webovej stránky.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }

cert-error-details-cert-chain-label = Certifikačná reťaz:

open-in-new-window-for-csp-or-xfo-error = Otvoriť stránku v novom okne

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Pre vašu bezpečnosť { $hostname } nepovolí { -brand-short-name(case: "acc") } zobraziť stránku, ak je vložená z inej stránky. Ak chcete zobraziť túto stránku, musíte ju otvoriť v novom okne.

## Messages used for certificate error titles

connectionFailure-title = Nedá sa pripojiť
deniedPortAccess-title = Táto adresa je zakázaná
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Hmm, túto stránku sa nám nepodarilo nájsť.
fileNotFound-title = Súbor sa nenašiel
fileAccessDenied-title = Prístup k súboru bol zamietnutý
generic-title = Problém.
captivePortal-title = Prihlásiť sa do siete
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hmm, táto adresa nevyzerá v poriadku.
netInterrupt-title = Pripojenie bolo prerušené
notCached-title = Platnosť dokumentu vypršala
netOffline-title = Režim offline
contentEncodingError-title = Chyba kódovania obsahu
unsafeContentType-title = Nebezpečný typ obsahu
netReset-title = Výpadok pripojenia
netTimeout-title = Čas pripojenia vypršal
unknownProtocolFound-title = Adresa nebola rozpoznaná
proxyConnectFailure-title = Server proxy odmieta pripojenia
proxyResolveFailure-title = Server proxy nemožno nájsť
redirectLoop-title = Stránku sa nepodarilo správne presmerovať
unknownSocketType-title = Neočakávaná odpoveď servera
nssFailure2-title = Zabezpečené pripojenie zlyhalo
csp-xfo-error-title = { -brand-short-name } nedokáže otvoriť túto stránku
corruptedContentError-title = Poškodený obsah stránky
remoteXUL-title = Vzdialené XUL
sslv3Used-title = Nie je možné sa pripojiť zabezpečene
inadequateSecurityError-title = Vaše pripojenie nie je zabezpečené
blockedByPolicy-title = Zablokovaná stránka
clockSkewError-title = Hodiny vo vašom počítači sú zle nastavené
networkProtocolError-title = Chyba sieťového protokolu
nssBadCert-title = Varovanie: možné bezpečnostné riziko
nssBadCert-sts-title = Nepripojené: možné bezpečnostné riziko
certerror-mitm-title = { -brand-short-name } nemôže nadviazať zabezpečené pripojenie s touto stránkou
