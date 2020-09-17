# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } uzas nevalidan sekurecan atestilon.

cert-error-mitm-intro = Retejoj legitimas sin per atestiloj, kiuj estas eldonitaj de atestilaj aŭtoritatoj.

cert-error-mitm-mozilla = { -brand-short-name } estas apogata de la neprofitcela organizo Mozilla, kiu administras tute malfermitan magazenon de atestilaj aŭtoritatoj (CA). Tiu magazeno de CA-j helpas garantii ke la atestilaj aŭtoritatoj plenumos la sekurecajn praktikojn, por protekti la uzantojn.

cert-error-mitm-connection = { -brand-short-name } uzas la magazenon de CA de Mozilla por kontroli ĉu konektoj estas sekuraj, anstataŭ uzi la atestilojn provizitajn de la mastruma sistemo de la uzanto. Se kontraŭvirusa programo, aŭ reto, interkaptas la konekton per sekureca atestilo eldonita de CA, kiu ne estas en la magazeno de CA de Mozilla, do la konekto estos konsiderita nesekura.

cert-error-trust-unknown-issuer-intro = Eble iu klopodas uzurpi la retejon kaj pro tio vi ne devus daŭrigi.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Retejoj legitimas sin per sekurecaj atestiloj. { -brand-short-name } ne fidas { $hostname } ĉar la eldoninto de ĝia sekureca atestilo estas nekonata, la atestilo estas memsubskribita aŭ la servilo ne sendas la ĝustajn interajn atestilojn.

cert-error-trust-cert-invalid = La atestilo ne estas fidata ĉar ĝi estis eldonita de nevalida CA atestilo.

cert-error-trust-untrusted-issuer = La atestilo ne estas fidata ĉar la atestilo de la eldoninto ne estas fidata.

cert-error-trust-signature-algorithm-disabled = La atestilo ne estas fidata ĉar ĝi estis subskribita per subskriba algortimo, kiu ne plu estas aktiva pro ĝia nesekureco.

cert-error-trust-expired-issuer = La atestilo ne estas fidata ĉar la atestilo de la eldoninto senvalidiĝis.

cert-error-trust-self-signed = La atestilo ne estas fidata ĉar ĝi estas memsubskribita.

cert-error-trust-symantec = Atestiloj eldonitaj de RapidSSL, RapidSSL, Symantec, Thawte kaj VeriSign ne plu estas konsiderataj sekuraj, ĉar en la pasinteco tiuj atestilaj aŭtoritatoj ne plenumis sekurecajn praktikojn.

cert-error-untrusted-default = La atestilo ne venas el fidata origino.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Retejoj legitimas sin per sekurecaj atestiloj. { -brand-short-name } ne fidas tiun ĉi retejon ĉar ĝi uzas sekurecan atestilon, kiu ne estas valida por { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Retejoj legitimas sin per sekurecaj atestiloj. { -brand-short-name } ne fidas tiun ĉi retejon ĉar ĝi uzas sekurecan atestilon, kiu ne estas valida por { $hostname }. La atestilo nur validas por <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Retejoj legitimas sin per sekurecaj atestiloj. { -brand-short-name } ne fidas tiun ĉi retejon ĉar ĝi uzas sekurecan atestilon, kiu ne estas valida por { $hostname }. La atestilo nur validas por { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Retejoj legitimas sin per sekurecaj atestiloj. { -brand-short-name } ne fidas tiun ĉi retejon ĉar ĝi uzas sekurecan atestilon, kiu ne estas valida por { $hostname }. La atestilo nur validas por la jenaj nomoj: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Retejoj legitimas sin per sekurecaj atestiloj, kiuj validas nur dum difinita daŭro. La sekureca atestilo por { $hostname } kadukiĝis je { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Retejoj legitimas sin per sekurecaj atestiloj, kiuj validas nur dum difinita daŭro. La sekureca atestilo por { $hostname } ne validos ĝis { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Erarkodo: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Retejoj legitimas sin per sekurecaj atestiloj, kiuj estas eldonitaj de atestilaj aŭtoritatoj. La plimulto de la retumiloj ne plu fidas sekurecajn atestilojn eldonitajn de GeoTrust, RapidSSL, Symantec, Thawte, and VeriSign. { $hostname } uzas atestilon de unu el tiuj aŭtoritatoj kaj do oni ne povas kontroli la identon de la retejo.

cert-error-symantec-distrust-admin = Vi povas sciigi la administraton de la retejo pri tiu ĉi problemo.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }

cert-error-details-cert-chain-label = Atestila ĉeno:

open-in-new-window-for-csp-or-xfo-error = Malfermi retejon en nova fenestro

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Por protekti vian sekurecon, { $hostname } ne permesas al { -brand-short-name } montri la paĝon se ĝi estis enmetita en alian retejon. Por vidi tiun ĉi paĝon, vi devas malfermi ĝin en nova fenestro.

## Messages used for certificate error titles

connectionFailure-title = Ne eblas konektiĝi
deniedPortAccess-title = Aliro al tiu ĉi adreso estas limigata
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Hmm, ni ne sukcesas trovi tiun retejon.
fileNotFound-title = Dosiero ne trovita
fileAccessDenied-title = Rifuzita aliro al dosiero
generic-title = Fuŝ’.
captivePortal-title = Komenci seancon en tiu ĉi reto
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hmm, tiu adreso ne aspektas ĝuste.
netInterrupt-title = La konekto estis ĉesigita
notCached-title = Dokumento malaktuala
netOffline-title = Malkonektita reĝimo
contentEncodingError-title = Eraro de enkodigo de enhavo
unsafeContentType-title = Nesekura tipo de dosiero
netReset-title = La konekto estis haltigita
netTimeout-title = Limtempo por konekto atingita
unknownProtocolFound-title = La adreso ne estis komprenita
proxyConnectFailure-title = La retperanto rifuzas konektojn
proxyResolveFailure-title = Ne eblas trovi la retperanton
redirectLoop-title = La paĝo ne redirektiĝas bone
unknownSocketType-title = Neatendita respondo el servilo
nssFailure2-title = Malsukcesa sekura konekto
csp-xfo-error-title = { -brand-short-name } ne povas malfermi tiun ĉi paĝon
corruptedContentError-title = Eraro pro difektita enhavo
remoteXUL-title = Fora XUL
sslv3Used-title = Ne eblas sekure konektiĝi
inadequateSecurityError-title = Via konekto ne estas sekura
blockedByPolicy-title = Blokita paĝo
clockSkewError-title = La horloĝo de via komputilo estas malĝusta
networkProtocolError-title = Eraro en reta protokolo
nssBadCert-title = Averto: Ebla sekureca risko antaŭ vi
nssBadCert-sts-title = Malsukcesa konekto: ebla sekureca problemo
certerror-mitm-title = Programaro malpermesas al { -brand-short-name } sekure konekti tiun ĉi retejon
