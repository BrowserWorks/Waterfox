# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } huutortoo ko seedamfaagu kisal ngu moƴƴaani..

cert-error-mitm-intro = Lowe geese ndallinirta keɓtinirɗe mum en ko seedanteeje ɗe hoolaaɓe seedamafaagu ndokkata ɗum en.

cert-error-mitm-mozilla = Ko fedde Mozilla, nde yiylaaki dañal, yiiloore faawru mbaawka seedanteeje (CA) udditiindu, wammbi { -brand-short-name }. Faawru CA ina wallita gaddaade mbele mbaawkaaji seedamfaaguuji ina ndewa golle moƴƴe ko faati e kisal huutorɓe.

cert-error-trust-unknown-issuer-intro = Won baawɗo etaade wujjude heɓtinirde lowre ndee etee a fotaani jokkude.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Lowe geese ndallinirta keɓtinirɗe mum en ko e seedanteeji. { -brand-short-name } hoolaaki { $hostname } sabu dokkoowo seedamfaagu makko oo anndaaka, seedamfaagu nguu ko siifngu hoore mum, walla sarworde ndee neldaani seedanteeji hakundeeji moƴƴi.

cert-error-trust-cert-invalid = Seedamfaagu nguu hoolaaka sabu bayyino ngu ko kohowo seedamfaaje mo moƴƴaani.

cert-error-trust-untrusted-issuer = Seedamfaagu nguu hoolaaka sabu seedamfaagu bayyinɗo oo hoolaaka.

cert-error-trust-signature-algorithm-disabled = Seedamfaagu nguu hoolaaka sabu ngu siiforaa ko huutoraade algoritmol daaƴangol sabu nol hisaani.

cert-error-trust-expired-issuer = Seedamfaagu nguu hoolaaka sabu seedamfaagu bayyinɗo oo yawtii happo.

cert-error-trust-self-signed = Seedamfaagu nguu hoolaaka sabu ko siifnde hoore mayre.

cert-error-trust-symantec = Seedanteeji ɗi GeoTrust,RapidSSL, Symantec, Thawte, e VeriSign ndokkirta ɗii nattii jaggireede koolniiɗe sabu ɓee hoolaaɓe seedamfaagu ndonkii rewde e golle kisal e ko ɓenni.

cert-error-untrusted-default = Seedamfaagu nguu ummaaki e iwdi koolaandi.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Lowe geese ndallinirta keɓtinirɗe mum enko  e seedanteeji. { -brand-short-name } hoolaaki nde lowre sabu nde huutortoo ko seedamfaagu ngu moƴƴaani ngam { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Lowe geese ndallinirta keɓtinirɗe mum en ko e seedanteeji. { -brand-short-name } hoolaaki ndee lowre sabu nde huutortoo ko seedamfaagu ngu moƴƴaani ngam { $hostname }. Seedamfaagu nguu moƴƴi tan ko e <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Lowe geese ndallinirta keɓtinirɗe mum en ko e seedanteeji. { -brand-short-name } hoolaaki ndee lowre sabu nde huutortoo ko seedamfaagu ngu moƴƴaani ngam { $hostname }. Seedamfaagu nguu moƴƴi tan ko e { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Lowe geese ndallinirta keɓtinirɗe mum en ko e seedanteeji. { -brand-short-name } hoolaaki ndee lowre sabu nde huutortoo ko seedamfaagu ngu moƴƴaani ngam { $hostname }. Seedamfaagu nguu moƴƴi tan ko e ɗee inle: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Lowe geese ndallinirta keɓtinirɗe mum en ko e seedanteeje, moƴƴuɗi e tuma ganndaaɗo. Seedamfaagu ngam { $hostname } nguu suytii e { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Lowe geese ndallinirta keɓtinirɗe mum en ko e seedamfaagu, moƴƴuɗi e tuma ganndaaɗo. Seedamfaagu ngam { $hostname } moƴƴoytaa haa { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Kod juumre: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Lowe geese ndallinirta keɓtinirɗe mum en ko seedanteeje ɗe hoolaaɓe seedamafaagu ndokkata ɗum en. Ko ɓuri heewde e banngorɗe nattii hoolaade seedamfeeji ɗi GeoTrust, RapidSSL, Symantec, Thawte, e VeriSign ndokkirta. { $hostname } ina huutoroo seedamfaagu ummiingu e ɓee hoolaaɓe ndeen noon innitol lowre ndee waawataa dallineede.

cert-error-symantec-distrust-admin = Aɗa waawi humpit-de jiiloowo lowre ndee saɗeende ndee.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }

cert-error-details-cert-chain-label = Calol Seedamfaagu:

## Messages used for certificate error titles

connectionFailure-title = Horiima seŋaade
deniedPortAccess-title = Ndee ñiiɓirde ko suraande
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Hmm. Min ndañii saɗeende e yiytude hello ngo.
fileNotFound-title = Fiilde yiytaaka
fileAccessDenied-title = Ballagol fiilde salaama
generic-title = Ndo.
captivePortal-title = Seŋo e laylaytol hee
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hmm. Ndee ñiiɓirde nanndaani e moƴƴere.
netInterrupt-title = Ceŋagol ngol taƴii
notCached-title = Fiilannde Hiiɗtii
netOffline-title = Mbaydi ceŋtol
contentEncodingError-title = Juumre Dokkitannde Loowdi
unsafeContentType-title = Ndee Fiilde Toolnaaki
netReset-title = Ceŋagol ngol fuɗɗitaama
netTimeout-title = Ceŋagol ngol honaama waktu
unknownProtocolFound-title = Ñiiɓirde ndee faamaaka
proxyConnectFailure-title = Sarworde proxy ndee saliima ceŋanɗe
proxyResolveFailure-title = Horiima yiytude sarworde proxy ndee
redirectLoop-title = Ngoo hello wonaani e yiiltude no feewiri
unknownSocketType-title = Jaatol sarworde faamaaka
nssFailure2-title = Ceŋagol Kisnangol Woorii
corruptedContentError-title = Juumre Loowdi Jiibndi
remoteXUL-title = XUL Poottiiɗo
sslv3Used-title = Horiima Seŋaade e Kisal
inadequateSecurityError-title = Ceŋagol maa hisaani
blockedByPolicy-title = Hello Daaƴaango
clockSkewError-title = Montoor ordinateer maa goongɗaani
networkProtocolError-title = Juumre jaɓɓitorde geese
nssBadCert-title = Jeertino: Soomi tanaa kisal yeeso
nssBadCert-sts-title = Hoto seŋo: soomi saɗeende kisal
certerror-mitm-title = Topirde ndee haɗii { -brand-short-name } ceŋaade e kisal e ndee lowre
