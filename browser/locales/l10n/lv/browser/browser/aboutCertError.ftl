# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } izmanto nederīgu drošības sertifikātu.

cert-error-mitm-intro = Vietnes apliecina savu identitāti ar sertifikātiem, kurus izsniedz sertifikātu izdevējas iestādes.

cert-error-mitm-mozilla = { -brand-short-name } atbalsta bezpeļņas organoizācija Mozilla, kas administrē pilnīgi atvērtu sertifikātu izsniegšanas iestādes (CA) veikalu. CA veikals palīdz nodrošināt, ka sertifikātu izdevējas iestādes ievēro paraugpraksi lietotāju drošībai.

cert-error-trust-unknown-issuer-intro = Iespējams kāds mēģina izlikties par šo lapu, jums nevajadzētu turpināt.

cert-error-trust-cert-invalid = Šis sertifikāts nav uzticams, jo to ir izdevis nederīgs CA sertifikāts.

cert-error-trust-untrusted-issuer = Šis sertifikāts nav uzticams, jo tā izdevēja sertifikāts nav uzticams.

cert-error-trust-signature-algorithm-disabled = Sertifikāts nav uzticams, jo ir parakstīts ar algoritmu, kas nav uzskatāms par drošu.

cert-error-trust-expired-issuer = Šis sertifikāts nav uzticams, jo tā izdevēja sertifikāta derīguma termiņš ir beidzies.

cert-error-trust-self-signed = Šis sertifikāts nav uzticams, jo tas ir pašparakstīts.

cert-error-untrusted-default = Sertifikāts nāk no nedroša avota.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Kļūdas kods: <a data-l10n-name="error-code-link">{ $error }</a>

cert-error-symantec-distrust-admin = Par šo problēmu varat paziņot vietnes administratoram.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }

cert-error-details-cert-chain-label = Sertifikātu ķēde:

open-in-new-window-for-csp-or-xfo-error = Atvērt vietni jaunā logā

## Messages used for certificate error titles

connectionFailure-title = Nevar pieslēgties
deniedPortAccess-title = Piekļuve šai adresei ir liegta
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Hmm. Diemžēl mums neizdodas atrast šo lapu.
fileNotFound-title = Fails nav atrasts
fileAccessDenied-title = Pieeja failam tika liegta
generic-title = Savādi gan...
captivePortal-title = Pieteikšanās tīklā
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hmm. Šķiet šī adrese nav korekta.
netInterrupt-title = Savienojums tika pārtraukts
notCached-title = Dokumenta derīguma termiņš beidzies
netOffline-title = Nesaistes režīms
contentEncodingError-title = Satura kodējuma kļūda
unsafeContentType-title = Nedrošs faila tips
netReset-title = Savienojums tika pārrauts
netTimeout-title = Savienojumam iestājās noilgums
unknownProtocolFound-title = Adrese netika saprasta
proxyConnectFailure-title = Starpniekserveris (proxy) nepieņem savienojumus
proxyResolveFailure-title = Nevar atrast starpniekserveri
redirectLoop-title = Lapa netiek korekti pāradresēta
unknownSocketType-title = Negaidīta atbilde no servera
nssFailure2-title = Drošais savienojums neizdevās
csp-xfo-error-title = { -brand-short-name } nevar atvērt šo lapu
corruptedContentError-title = Bojāta satura kļūda
remoteXUL-title = Attālināts XUL
sslv3Used-title = Neizdevās droši pieslēgties
inadequateSecurityError-title = Savienojums nav drošs
blockedByPolicy-title = Bloķēta lapa
clockSkewError-title = Jūsu datora pulkstenis ir nepareizs
networkProtocolError-title = Tīkla protokola kļūda
nssBadCert-title = Brīdinājums: Potenciāls drošības risks
nssBadCert-sts-title = Netika izveidots savienojums: potenciāla drošības problēma
certerror-mitm-title = Programmatūra neļauj { -brand-short-name } droši izveidot savienojumu ar šo vietni
