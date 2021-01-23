# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } arâj sunj 'ngo serfifikadô dugumîn nitaj si hua hue'ê.

cert-error-mitm-intro = Ngà nej sertifikâdo nadigân web dàj huat, ni sertifikadô nan ni hua niña dukua sun narikî man.

cert-error-mitm-mozilla = { -brand-short-name } ni yi'nïn' Mozilla rugûñun'unj rukû man, dadin' huê yi'nïn' nan dugumîn dukua si sin nej sertifikâdo (CA).

cert-error-mitm-connection = { -brand-short-name } arâj sun riña màn sà' sertifikâdo CA 'iaj Mozilla guendâ ga hue'ê gache nun', lugâ garasunj nej si sertifikadô si sistemâ operatibô'. Ô' ni, sisi 'ngo sa duguêj yi'ìi asi 'ngo red nani'in sisi hua sertifikadô se si'iaj Mozilla CA huin ni, nanai'in sisi 'ngo koneksiûn ahii nahuin man.

cert-error-trust-unknown-issuer-intro = Hua 'ngo sa ruhuâ gi'iaj yi'ì riña sîtio yi'ì dan nitaj si da'uît gatut riñanj.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Ngà nej sertifikâdo nadigân nej sîtio daj huat. { -brand-short-name } nitaj si hua nika ruhuaj { $hostname } dadin' nu ni'în ahuin si giri si sertifikadôt, sê 'ngo sertifikadô yitïnj ïn huin asi serbidôr nu a'nïn 'ngo sertifikadô hia.

cert-error-trust-cert-invalid = 'Ngo sertifikadô diga'ñun'unj un huin dadin' sa giri 'ngo CA nu ni'în' huin.

cert-error-trust-untrusted-issuer = 'Ngo sertifikadô diga'ñun'unj un huin dadin' nitaj si hua hue'ê si sertifikadô sa giri man.

cert-error-trust-signature-algorithm-disabled = 'Ngo sertifikadô diga'ñun'unj un huin nan dadin' da'nga' ga'ui' si riñanj nu ni'în si 'ngo da'nga' hia huin man.

cert-error-trust-expired-issuer = 'Ngo sertifikadô diga'ñun'unj un huin na dadin' si sertifikadô sa giri man ni ngà ganahuij si diuj.

cert-error-trust-self-signed = 'Ngo sertifikadô diga'ñun'unj huin nan dadin' man' an giri man'an.

cert-error-trust-symantec = Nej sertifikadô ri Geo Trust, RapidSSL, Symantec, Thawte ni VeriSign nitaj si hua nika nìko nej man dadin' nej yi'nïn' nan ni nu gi'iaj sun hue'ê nej man da' dugumîn sò' diû gâchin.

cert-error-untrusted-default = Nitaj si hua yitïnj riña gahui sertifikadô nan.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Ngà sertifikâdo nadigan nej sîtio sisi hua nika nej man. { -brand-short-name } nitaj si hua nika ruhuaj ngà sitiô nan dadin' nitaj si ni'ñanj si sertifikadoj guendâ { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Ngà sertifikâdo nadigan nej sîtio sisi hua nika nej man. { -brand-short-name } nitaj si hua nika ruhuaj ngà sitiô nan dadin' nitaj si ni'ñanj si sertifikadoj guendâ { $hostname }. Màn guendâ <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a> hua hue'ê sitiô nan.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Ngà sertifikâdo nadigan nej sîtio sisi hua nika nej man. { -brand-short-name } nitaj si hua nika ruhuaj ngà sitiô nan dadin' nitaj si ni'ñanj si sertifikadoj guendâ { $hostname }. Màn guendâ { $alt-name } hua nika sitiô nan.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Ngà sertifikâdo nadigan nej sîtio sisi hua nika nej man. { -brand-short-name } nitaj si hua nika ruhuaj ngà sitiô nan dadin' nitaj si ni'ñanj si sertifikadoj guendâ { $hostname }. Màn guendâ nej na: { $subject-alt-names } hua nika sitiô nan.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Ngà serifikâdo nadigan nej sîtio sisi hua nika nej man, nej nan ni nadunaj da' diû. Serfifikadô guendâ { $hostname } ganahuij si diuj gui { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Ngà serifikâdo nadigan nej sîtio sisi hua nika nej man, nej nan ni nadunaj da' diû. Serfifikadô guendâ { $hostname } nitaj si gini'ñan ndà { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Gire' kodigo: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Ngà serifikâdo nadigan nej sîtio sisi hua nika nej man, ni hua nej dukua sun ri nej sertifikadô nan. ga'ì nej sa nana'ui' nuguan'an ni nitaj si hua nika ruhuâ nej man ngà sertifikadô ri  GeoTrust, RapidSSL, Symantec, Thawte ni VeriSign. { $hostname } arâj sun 'ngo sertifikadô ri nej dukua sun nan, yi'ì dan si ga'ue gini'în' dàj gi'iaj sun yangà' web nan.

cert-error-symantec-distrust-admin = Ga'ue ganatà't riña sa nikaj ñun'unj sitiô nan rayi'î sa gahui a'nan nan.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = Yitïnj hauw ga'anj ma riña HTTP ahī: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = Gachrun' klave HTTP: { $hasHPKP }

cert-error-details-cert-chain-label = Daj niko' dugui' sertifikadô:

open-in-new-window-for-csp-or-xfo-error = Na’nīn sitio riña a’ngô bentanâ nākàa

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Da’ dūgumij sò’, { $hostname } sī gâ’nïnj { -brand-short-name } da’ nāyi’nïn pâjina sisī a’ngô sitio nâ’nïnj man. Da’ gā’ue gīni’iājt pajinâ nan nī da’uît nā’nïnt man riña a’ngô bendtanâ nākàa.

## Messages used for certificate error titles

connectionFailure-title = Na'ue gatu riña internet ma
deniedPortAccess-title = Hua arán riña sitiô na
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Mmmm. Na'ue nari' ma sitio na ma.
fileNotFound-title = Nu narì'ij archivo
fileAccessDenied-title = Nun raj yinaj gun' aa atû'
generic-title = 'Uà'
captivePortal-title = Gayi'i' sesion riña red
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Mmm. Nitaj si ra'nga' hue'ê direksiôn na.
netInterrupt-title = Giyichin' ngè conexión
notCached-title = Ngà gire' ñanj na
netOffline-title = Si gida'aj internet
contentEncodingError-title = Gire' 'ngo chrej nana'uij sa gachrûnt
unsafeContentType-title = 'Ngo archivo hua ahii huin
netReset-title = Nayi'ì ñû conexión
netTimeout-title = Ganahuij diû ana'uijt
unknownProtocolFound-title = Nu gachrun hue'êt direksiôn
proxyConnectFailure-title = Nu a'nïnj servidor proxy gatut riña internet
proxyResolveFailure-title = Na'ue nari'ìj proxy ma
redirectLoop-title = Nitaj si 'iaj redireksionando hue'ê pajinâ nan
unknownSocketType-title = Se 'ngo nuguan' hue'ê nariki servidor
nssFailure2-title = Gire' conexión hia
csp-xfo-error-title = { -brand-short-name } Na'ue nāyi'nïn pajinâ nan
corruptedContentError-title = Gire'ej dadin' sa nun riñan hua a'nan'
remoteXUL-title = XUL nagi'iaj mun'ûn'
sslv3Used-title = Si ga'ue guida'a hue'e man
inadequateSecurityError-title = Nitaj si gua hue'e si conexion re'
blockedByPolicy-title = Hua blokeado pagina
clockSkewError-title = Nitaj si nū hue'ê hora riña si aga't
networkProtocolError-title = Gire' si protokolo red
nssBadCert-title = Gadadut: Nū 'ngò yi'ì nukuaj
nssBadCert-sts-title = Nu ga'ue gida'aj: Siruaj ni hua ahī ma
certerror-mitm-title = Na’uēj Software ga’nïn riña { -brand-short-name } da’ gatū sa’àj riña sitiô nan
