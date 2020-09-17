# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } oipuru mboajepyre rekorosã oiko’ỹva.

cert-error-mitm-intro = Ko’ã ñanduti renda ohechauka heratee mboajepyre rupi oguenohẽva mboajepyre umi mburuvicha.

cert-error-mitm-mozilla = { -brand-short-name } oykeko Mozilla, atyguasu viru’ỹgua oñangarekóva tendaguasu mboajepyre myakãha ijurujáva. Ko mboajepyre myakãha oipytyvõ oñemoañete hag̃ua mboajepyre myakãha rembiapo potĩ puruhára rekorosãrã rekávo.

cert-error-mitm-connection = { -brand-short-name } oipuru Mozilla ñemuha CA ohecha hag̃ua hekorosãpa jeike, mboajepyre ome’ẽva puruhára apopyvusu rendaguépe. Upéicha rupi, pe tembiaporape mba’echu’i jukaha térã ñanduti ohapejokórõ jeike mboajepyre hekorosãva ndive ome’ẽva peteĩ CA oĩ’ỹva Mozilla ñemuhápe, pe jeike nahekorosãmo’ãi.

cert-error-trust-unknown-issuer-intro = Ikatu hína peteĩva oha’ãnga tendápe ha nde repytamava’erã.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Umi ñanduti renda oha’ã heraite mboajepyre rupive. { -brand-short-name } ndojeroviái { $hostname } rehe pe mboajepyre me’ẽha ndojekuaái rehe, ko mboajepyre oñemboheraguapy, térã pe mohendahavusu nomondói mboajepyre mbytegua oikóva.

cert-error-trust-cert-invalid = Ndojejeroviái mboajepyre rehe ha’e rupi pe CA mboajepyre oiko’ỹva guenohẽmbyre.

cert-error-trust-untrusted-issuer = Ndojejeroviái pe mboajepyréva rehe pe ime’ẽhare rehe ndojejeroviavéima rupi.

cert-error-trust-signature-algorithm-disabled = Ndojejeroviái pe mboajepyréva rehe omboheraguapy rupi oipurúvo algoritmo mboheraguapy rehegua ojejokomava’ekue nahekorosãi haguére.

cert-error-trust-expired-issuer = Ndojejeroviái pe mboajepyre rehe pe ime’ẽhare ndoikovéima rupi.

cert-error-trust-self-signed = Ndojejeroviái pe mboajepyre rehe oñemboheraguapyjehegui rupi.

cert-error-trust-symantec = Umi mboajepyre oguenohẽva GeoTrust, RapidSSL, Symantec, Thawte y VeriSign nahekorosãvéima mboajepyre myakãharakuéra ndoguatái tekorosã rapére ymave.

cert-error-untrusted-default = Pe mboajepyre ndoúi peteĩ teñoiha ijeroviahávagui.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Umi ñanduti renda ohechauka heratee mboajepyre rupive. { -brand-short-name } ndojeroviái ko tendáre oipuru rupi mboajepyre ndoikóiva { $hostname } peg̃uarã.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Umi ñanduti renda ohechauka heratee mboajepyre rupive. { -brand-short-name } ndojeroviái ko tendáre oipuru rupi mboajepyre ndoikóiva { $hostname } peg̃uarã. Ko mboajepyre oiko <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a> peg̃uarã año.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Umi ñanduti renda ohechauka heratee mboajepyre rupive. { -brand-short-name } ndojeroviái ko tendáre oipuru rupi mboajepyre ndoikóiva { $hostname } peg̃uarã. Ko mboajepyre oiko { $alt-name } peg̃uarã año.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Umi ñanduti renda ohechauka heratee mboajepyre rupive. { -brand-short-name } ndojeroviái ko tendáre oipuru rupi mboajepyre ndoikóiva { $hostname } peg̃uarã. Pe mboajepyre oiko ko’ã térape g̃uarã añónte. { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Umi ñanduti renda ohechauka heratee mboajepyre rupive, oikóva ndahetái ára. Pe mboajepyre { $hostname } peg̃uarã ndoikovéima { $not-after-local-time }-pe.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Umi ñanduti renda ohechauka heratee mboajepyre rupive, oikóva ndahetái ára. Pe mboajepyre { $hostname } pegua oikojeýta { $not-before-local-time } rupive añoite.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Ayvu jejavy; <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Umi ñanduti renda ohechauka heratee mboajepyre rupive, oguenohẽva mboajepyre myakãharakuéra. Hetave umi kundaha ndojeroviái oguenohẽva GeoTrust, RapidSSL, Symantec, Thawte y VeriSign. { $hostname } oipuru peteĩ mboajepyre peteĩva ko’ã myakãhárava ha, upéicha rupi, ndaikatúi eikua pe ñanduti renda réra.

cert-error-symantec-distrust-admin = Ikatu emomarandu ñanduti renda ñangarekohárape ko apañuãi rehegua.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Tekorosãite Jegueraha Katu: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Ñe’ẽñemi Pavẽrovapeguáva Ñesa’ỹijo: { $hasHPKP }

cert-error-details-cert-chain-label = Kuatia mboajepyre rysýi:

open-in-new-window-for-csp-or-xfo-error = Embojuruja tenda ovetã pyahúpe

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Emo’ã hag̃ua ne rekorosã, { $hostname } nomoneĩmo’ãi { -brand-short-name } ohechaukávo kuatiarogue ambue tenda omoingéramo. Ehecha hag̃ua ko kuatiarogue, embojurujava’erã ovetã pyahúpe.

## Messages used for certificate error titles

connectionFailure-title = Ndaikatúi eike
deniedPortAccess-title = Ko kundaharenda ndaikatúi eipuru
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Hmm. Oĩ apañuãi ejuhu hag̃ua ko tenda.
fileNotFound-title = Marandurenda ndojejuhúiva
fileAccessDenied-title = Marandurendápe jeike noñemoneĩri
generic-title = Oops.
captivePortal-title = Eñepyrũ tembiapo ñandutípe
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hmm. Ko kundaharape ndojehechaporãi.
netInterrupt-title = Pe jeike ojejokóma
notCached-title = Kuatiaite ndoikovéima
netOffline-title = Jeike’ỹ ayvu
contentEncodingError-title = Tetepy mbopapapy jejavy
unsafeContentType-title = Peteĩchagua marandurenda hekorosã’ỹva
netReset-title = Jeike oñepyrũjeýma
netTimeout-title = Pe jeike ndoikovéima
unknownProtocolFound-title = Pe kundaharape nahesakãi
proxyConnectFailure-title = Mohendahavusu proxy ombotove jeike
proxyResolveFailure-title = Ndaikatúi ojejuhu mohendahavusu proxy
redirectLoop-title = Ko kuatiarogue ndoguerahajeýi hekoitépe
unknownSocketType-title = Mbohovái eha’ãrõ’ỹva mohendahavusúgui
nssFailure2-title = Jeikekatu jejavýva
csp-xfo-error-title = { -brand-short-name } ndoikekuaái ko kuatiaroguépe
corruptedContentError-title = Tetepy marãva jejavy
remoteXUL-title = XUL okaygua
sslv3Used-title = Ndaikatúi eikekatu
inadequateSecurityError-title = Nde jeike ndahekokatúi
blockedByPolicy-title = Kuatiarogue jokopyre
clockSkewError-title = Aravopapaha mohendaha rehegua oĩvai
networkProtocolError-title = Jejavy guasu ñandutípe
nssBadCert-title = Jesarekorã: Imarãkuaáva tenondeve
nssBadCert-sts-title = Ndoikéi: Ikatu hína iñapañuãi tekorosãrã
certerror-mitm-title = Ko software ojokohína { -brand-short-name } ani oike ko tendápe tekorasãme
