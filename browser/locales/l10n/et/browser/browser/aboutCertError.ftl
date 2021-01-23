# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } kasutab vigast turvasertifikaati.

cert-error-mitm-intro = Saidid tõestavad oma identiteeti sertifitseerimiskeskuste poolt välja antud sertide abil.

cert-error-mitm-mozilla = { -brand-short-name }i taga seisab mittetulundusühing Mozilla, mis administreerib täielikult avalikku sertifitseerimiskeskuste serdiladu. Sertifitseerimiskeskuste serdiladu aitab tagada seda, et sertifitseerimiskeskused järgivad kasutajate turvalisuse tagamisel parimaid praktikaid.

cert-error-mitm-connection = { -brand-short-name } kasutab ühenduse turvalisuse kontrollimisel operatsioonisüsteemi serdilao asemel Mozilla sertifitseerimiskeskuste serdiladu. Seega, kui viirustõrjeprogramm või muud internetiühendust vahendavad seadmed sekkuvad ühendusse serdiga, mis pole välja antud Mozilla serdilaos oleva SK poolt, siis loetakse selline ühendus ebaturvaliseks.

cert-error-trust-unknown-issuer-intro = Keegi võib üritada selle saidina välja paista ja sa ei peaks jätkama.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Saidid tõestavad oma identiteeti sertide abil. { -brand-short-name } ei usalda saiti { $hostname }, kuna selle serdi väljaandja on tundmatu, sert on allkirjastatud selle omaniku poolt või server ei edasta korrektseid vaheserte.

cert-error-trust-cert-invalid = Sertifikaati ei usaldata, kuna selle välja andnud sertifitseerimiskeskuse sertifikaat on vigane.

cert-error-trust-untrusted-issuer = Sertifikaati ei usaldata, kuna selle väljaandja sertifikaati ei usaldata.

cert-error-trust-signature-algorithm-disabled = Sertifikaati ei usaldata, kuna see signeeriti signeerimisalgoritmiga, mis oli keelatud algoritmi ebaturvalisuse tõttu.

cert-error-trust-expired-issuer = Sertifikaati ei usaldata, kuna selle väljaandja sertifikaat on aegunud.

cert-error-trust-self-signed = Sertifikaati ei usaldata, kuna selle on signeerinud sertifikaadi omanik.

cert-error-trust-symantec = Serte, mille väljaandjaks on GeoTrust, RapidSSL, Symantec, Thawte või VeriSign, ei peeta enam ohutuks, kuna need sertifitseerimiskeskused ei suutnud minevikus järgida vajalikke turvapraktikaid.

cert-error-untrusted-default = Sertifikaat ei tule usaldatud allikast.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Saidid tõestavad oma identiteeti sertide abil. { -brand-short-name } ei usalda seda saiti, kuna selle sert ei ole saidi { $hostname } jaoks korrektne.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Saidid tõestavad oma identiteeti sertide abil. { -brand-short-name } ei usalda seda saiti, kuna selle sert ei ole saidi { $hostname } jaoks korrektne. Sert on välja antud ainult domeenile <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Saidid tõestavad oma identiteeti sertide abil. { -brand-short-name } ei usalda seda saiti, kuna selle sert ei ole saidi { $hostname } jaoks korrektne. Sert on välja antud ainult domeenile { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Saidid tõestavad oma identiteeti sertide abil. { -brand-short-name } ei usalda seda saiti, kuna see kasutab serti, mis ei ole saidi { $hostname } jaoks korrektne. Sert on korrektne ainult järgmistele domeenidele: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Saidid tõestavad oma identiteeti kindlaks määratud aja jooksul kehtivate sertide abil. Saidi { $hostname } sert aegus { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Saidid tõestavad oma identiteeti kindlaks määratud aja jooksul kehtivate sertide abil. Saidi { $hostname } serdi kehtivusaeg algab { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Veakood: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Saidid tõestavad oma identiteeti turvasertide abil, mille on välja andnud sertifitseerimiskeskused. Enamik brausereid ei usalda enam serte, mille on välja andnud GeoTrust, RapidSSL, Symantec, Thawte või VeriSign. Sait { $hostname } kasutab serti, mille on väljastanud üks eelnimetatud sertifitseerimiskeskustest ja seetõttu pole selle saidi identiteeti võimalik tõestada.

cert-error-symantec-distrust-admin = Sa võid teavitada saidi administraatorit sellest probleemist.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security tehnoloogia: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning tehnoloogia: { $hasHPKP }

cert-error-details-cert-chain-label = Sertifikaadiahel:

## Messages used for certificate error titles

connectionFailure-title = Viga ühendumisel
deniedPortAccess-title = See aadress on keelatud
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Hmm. Meil on probleeme selle saidi leidmisel.
fileNotFound-title = Faili ei leitud
fileAccessDenied-title = Ligipääs failile keelati
generic-title = Ups.
captivePortal-title = Võrku sisenemine
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hmm. See aadress ei tundu õige.
netInterrupt-title = Ühendus katkes
notCached-title = Dokument aegus
netOffline-title = Võrguta režiim
contentEncodingError-title = Sisu kodeeringu viga
unsafeContentType-title = Ohtlik faili tüüp
netReset-title = Ühendus katkestati
netTimeout-title = Ühendus aegus
unknownProtocolFound-title = Aadress jäi arusaamatuks
proxyConnectFailure-title = Puhverserver keeldub ühendustest
proxyResolveFailure-title = Ei leitud puhverserverit
redirectLoop-title = Veebileht pole korralikult ümber suunatud
unknownSocketType-title = Ootamatu vastus serverilt
nssFailure2-title = Turvalise ühenduse viga
corruptedContentError-title = Vigane sisu
remoteXUL-title = Remote XUL
sslv3Used-title = Turvaline ühendumine pole võimalik
inadequateSecurityError-title = Ühendus pole turvaline
blockedByPolicy-title = Blokitud leht
clockSkewError-title = Sinu arvuti aeg on vale
networkProtocolError-title = Võrguprotokolli viga
nssBadCert-title = Hoiatus: ees on ootamas võimalik turvarisk
nssBadCert-sts-title = Ühendust ei loodud: võimalik turvarisk
certerror-mitm-title = Tarkvara takistab { -brand-short-name }il selle saidiga turvalise ühenduse loomist
