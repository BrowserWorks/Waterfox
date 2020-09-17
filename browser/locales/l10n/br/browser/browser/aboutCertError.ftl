# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } a arver un testeni diogelroez didalvoudek.

cert-error-mitm-intro = Gant testenioù e vez prouet pivelezh al lec'hiennoù, a zo roet gant aotrouniezhoù testeniañ.

cert-error-mitm-mozilla = Gant ar gevredigezh hep pal kenwerzhel Mozilla eo harpet { -brand-short-name }, a ver ur stal aotrouniezh testenioù (CA)  digor penn-da-benn. Ar stal CA a sikour evit bezañ sur e vez heuliet an hentennoù erbedet gant an aotrouniezhoù testeniañ evit diogelroez an arveriaded.

cert-error-mitm-connection = { -brand-short-name } a implij stal CA Mozilla evit gwiriekaat eo diogel ur c'hennask, kentoc'h eget an testenioù roet gant reizhiad korvoiñ an arveriad. Dre se, ma vez daspaket ur c'hennask gant un enepvirus pe ur rouedad gant un testeni diogelroez pourchaset gant ur CA n'eo ket e stal CA Mozilla eo gwelet evel diziogel ar c'hennask.

cert-error-trust-unknown-issuer-intro = Unan bennak a c'hallfe en em ziskouez evel bezañ al lec'hienn ha ne rankfec'h ket mont pelloc'h.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Pivelezhioù al lec'hiennoù a vez prouet dre testenioù. { -brand-short-name } n'eus ket fiziañs e { $hostname } peogwir n'anavezer ket pourchaser an testeni, emsinet eo an testeni, pe ne gas ket an dafariad an testenioù etre dereat.

cert-error-trust-cert-invalid = N'eus fiziañs ebet en testeni rak skignet eo bet gant un testeni eus un aotrouniezh testeniañ didalvoudek.

cert-error-trust-untrusted-issuer = N'eus fiziañs ebet en testeni rak n'eus fiziañs ebet e skigner an testeni.

cert-error-trust-signature-algorithm-disabled = N'eus fiziañs ebet en testeni rak sinet eo bet gant un treol sinañ a zo bet diweredekaet rak an treol-mañ n'eo ket diogel.

cert-error-trust-expired-issuer = N'eus fiziañs ebet en testeni rak diamzeret eo testeni ar skigner.

cert-error-trust-self-signed = N'eus fiziañs ebet en testeni rak emsinet eo.

cert-error-trust-symantec = Testenioù pourchaset gant GeoTrust, RapidSSL, Symantec, Thawte ha VeriSign n'int ket sellet evel diogel peogwir n'eo ket bet heuliet reolennoù diogelroez gant an aotrouniezhoù testeni-mañ.

cert-error-untrusted-default = An testeni ne zeu ket diouzh un tarzh a fiziañs.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Gant testenioù e vez prouet pivelezh al lec'hiennoù. { -brand-short-name } n'eus ket fiziañs el lec'hienn-mañ dre ma arver un testeni didalvoudek evit { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Gant testenioù e vez prouet pivelezh al lec'hiennoù. { -brand-short-name } n'eus ket fiziañs el lec'hienn-mañ dre ma arver un testeni didalvoudek evit { $hostname }. Talvoudek eo an testeni evit <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a> hepken.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Gant testenioù e vez prouet pivelezh al lec'hiennoù. { -brand-short-name } n'eus ket fiziañs el lec'hienn-mañ dre ma arver un testeni didalvoudek evit { $hostname }. Talvoudek eo an testeni evit { $alt-name } hepken.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Gant testenioù e vez prouet pivelezh al lec'hiennoù. { -brand-short-name } n'eus ket fiziañs el lec'hienn-mañ dre ma arver un testeni didalvoudek evit { $hostname }. Evit an anvioù da-heul eo talvoudek an testeni-mañ hepken: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Gant testenioù e vez prouet pivelezhioù al lec'hiennoù, a zo talvoudek evit ur padelezh termenet hepken. An testeni evit { $hostname } a ziamzero { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Prouet e vez pivelezh al lec'hiennoù gant testenioù, a zo talvoudek evit ur pennad amzer termenet. Ne vo ket talvoudek testeni { $hostname } a-raok { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Boneg fazi: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Gant testenioù e vez prouet pivelezh al lec'hiennoù. Roet e vezont gant aotrouniezhoù testeniañ. Lodenn vrasañ ar merdeerioù na reont ket fiziañ ken en testenioù roet gant GeoTrust, RapidSSL, Symantec, Thawte ha VeriSign. Un testeni roet gant unan eus an aotrouniezhoù-mañ a vez arveret gant { $hostname }, ha n'hall ket bezañ prouet pivelezh al lec'hienn.

cert-error-symantec-distrust-admin = Gallout a rit mont e darempred gant merour al lec'hienn diwar-benn ar gudenn-mañ.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = Diogelroez treuzdougen HTTP strizh: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = Speurennadur alc'hwez foran HTTP: { $hasHPKP }

cert-error-details-cert-chain-label = Chadenn testeni:

open-in-new-window-for-csp-or-xfo-error = Digeriñ al lec'hienn en ur prenestr nevez

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Evit gwareziñ ho surentez, { $hostname } na aotreo ket { -brand-short-name } da ziskouez ar bajenn ma vez ul lec'hienn all enkorfet enni. Evit gwelout ar bajenn-mañ ho peus ezhomm da zigeriñ anezhi en ur prenestr nevez.

## Messages used for certificate error titles

connectionFailure-title = Ne c'haller ket kennaskañ
deniedPortAccess-title = Dindan strishadurioù emañ ar porzh-mañ
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Hum. Diaes eo deomp kavout al lec'hienn-mañ.
fileNotFound-title = Restr dianav
fileAccessDenied-title = Nac'het eo bet haeziñ d'ar restr
generic-title = N'haller ket echuiñ an azgoulenn-mañ.
captivePortal-title = Kennaskañ d'ar rouedad
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hmm. Ne seblant ket bezañ reizh ar chomlec'h-mañ.
netInterrupt-title = Harzet eo bet treuzkas ar roadennoù
notCached-title = Diamzeret eo an teul
netOffline-title = Mod ezlinenn
contentEncodingError-title = Fazi enrinegañ an endalc'had
unsafeContentType-title = Rizh restr arvarus
netReset-title = Ehanet eo bet ar c'hennaskañ
netTimeout-title = Troc'het eo bet ar c'hennask rak re hir e oa
unknownProtocolFound-title = N'eo ket bet komprenet ar chomlec’h
proxyConnectFailure-title = Dafariad ar proksi zo o nac'hañ ar c'hennaskañ
proxyResolveFailure-title = N'eo ket bet kavet an dafariad proksi
redirectLoop-title = Adheñchañ ar bajenn n'eo ket dereat
unknownSocketType-title = Respont direizh
nssFailure2-title = C'hwitadenn war ar c'hennaskañ diarvar
csp-xfo-error-title = { -brand-short-name } n'hall ket digeriñ ar bajenn
corruptedContentError-title = Fazi a-fet endalc'had bet kontronet
remoteXUL-title = XUL a-bell
sslv3Used-title = Ne c'haller ket kennaskañ outi ent diarvar
inadequateSecurityError-title = N'eo ket diarvar ho kennask
blockedByPolicy-title = Pajenn stanket
clockSkewError-title = Direizh eo eurier hoc'h urzhiataer
networkProtocolError-title = Fazi komenad rouedad
nssBadCert-title = Diwallit: gallout a ra bezañ un arvar diogelroez
nssBadCert-sts-title = N'eo ket kennasket: kudenn diogelroez posupl
certerror-mitm-title = Ur meziant a vir { -brand-short-name } da gennaskañ ent diogel d'al lec'hienn-mañ
