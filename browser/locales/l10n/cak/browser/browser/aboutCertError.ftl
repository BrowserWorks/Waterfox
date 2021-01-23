# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } nrokisaj jun jikomal ruwujil b'i'aj, ri man okel ta.

cert-error-mitm-intro = Ri ajk'amaya'l ruxaq nikik'üt kib'anikil rik'in iqitzijib'äl, ri e'elesan pe kuma molaj taq iqitzijib'äl.

cert-error-mitm-mozilla = { -brand-short-name } ütz tz'eton ruma Mozilla, jun molaj majun ch'akuj rojqan yerunuk'samajij jun nojinäq chi jay taq molaj iqitzijib'äl (CA) ri e jaqel. Ri kik'ayij CA nito'on chi ri kik'amol taq b'ey iqitzijib'äl tikojqaj ri jeb'ël samaj richin kichajixik ri okisanela'.

cert-error-mitm-connection = { -brand-short-name } nrokisaj ri ruyakb'al Mozilla CA richin ninik'öx chi jikïl ri okem, pa ruk'exel ri iqitzijib'äl ya'on ruma ri ruq'inoj samajel okisanel. Ruma ri', we jun antivirus o jun k'amb'ey nrojqaj jun okem rik'in jun riqitzijib'al jikomal elesan ruma ri CA, ri man k'o ta ri ruyakb'al CA richin Mozilla xtitz'et chi itzel el okem ri'.

cert-error-trust-unknown-issuer-intro = Rik'in jub'a' k'o noxk'ob'en ri ruxaq ruma ri' man ta nasamajij chik qa.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Ri ajk'amaya'l taq ruxaq nikitojtob'ej ri ab'anikil rik'in rujikomal taq iqitzijib'äl. { -brand-short-name } man ütz nutz'ët { $hostname } ruma chi man etaman ta ruwäch ri elesayon pe ri rujikomal iqitzijib'äl, ruyon chuwa juch'un pe ri iqitzijib'äl o ri ruk'u'x samaj man tajin ta yerutäq ri ütz nik'aj iqitzijib'äl.

cert-error-trust-cert-invalid = Man kuqül ta k'u'x chi rij ri ruwujil b'i'aj, ruma xelesäx ruma jun ruwujil b'i'aj CA, ri ma nokel ta.

cert-error-trust-untrusted-issuer = Man nikuqub'äx ta k'u'x chi rij re ruwujil b'i'aj ruma chi man nikuqub'äx ta k'u'x chi rij ri tikirisanel rutzij ri ruwujil b'i'aj.

cert-error-trust-signature-algorithm-disabled = Man kuqub'an ta kuxaj chi rij ri ruwujil b'i'aj, ruma chi juch'un rik'in jun rub'eyal jik'oj, ri xchuputäj ruma chi itzel.

cert-error-trust-expired-issuer = Man nikuqub'äx ta k'u'x chi rij re ruwujil b'i'aj ruma chi ri tikirisanel rutzij ri ruwujil b'i'aj xk'is ruq'ijul.

cert-error-trust-self-signed = Man ütz ta re jun ruwujil b'i'aj re' ruma chi yonijuch'un.

cert-error-trust-symantec = Ri taq iqitzijib'äl elesan ruma GeoTrust. RapidSSL, Symantec, Thawte, chuqa' VeriSign yetz'et chi man e jikïl ta chik ruma chi ri kik'amöl taq b'ey iqitzijib'äl man xekojqajta ri taq rusamaj jikomal ke la' kan.

cert-error-untrusted-default = Ri ruwujil b'i'aj man petenäq ta pa jun kuqel ruxe'el.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Ri ajk'amaya'l taq ruxaq nikitojtob'ej ri ab'anikil rik'in taq iqitzijib'äl. { -brand-short-name } man ütz nutz'ët re ruxaq re' ruma chi man okel ta ri iqitzijib'äl chuwäch ri { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Ri ajk'amaya'l taq ruxaq nikitojtob'ej ri ab'anikil rik'in iqitzijib'äl. { -brand-short-name } man ütz nutz'ët re rixaq re' ruma chi man okel ta ri iqitzijib'äl chuwäch ri { $hostname }. Ri ruwujil b'i'aj xa xe okel richin <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Ri ajk'amaya'l taq ruxaq nikitojtob'ej ri ab'anikil rik'in iqitzijib'äl. { -brand-short-name } man ütz nutz'ët re rixaq re' ruma chi man okel ta ri iqitzijib'äl chuwäch ri { $hostname }. Ri ruwujil b'i'aj xa xe okel richin { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Ri ajk'amaya'l taq ruxaq nikitojtob'ej ri ab'anikil rik'in iqitzijib'äl. { -brand-short-name } man ütz nutz'ët re ruxaq re' ruma chi man okel ta ri iqitzijib'äl chuwäch ri { $hostname }. Xa xe okel ri iqitzijib'äl chi ke re taq b'i'aj: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Ri ajk'amaya'l ruxaq nikitojtob'ej ri ab'anikil kik'in iqitzijib'äl, ri e okel richin jun q'ijul jikib'an. Ri iqitzijib'äl richin { $hostname } xik'o yan ruq'ijul pa { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Ri ajk'amaya'l ruxaq nikitojtob'ej ri ab'anikil kik'in iqitzijib'äl, ri e okel richin jun q'ijul jikib'an. Ri iqitzijib'äl richin { $hostname } xa xe okel pa { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Rusachoj b'itz'ib': <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Ri ajk'amaya'l taq ruxaq nikitojtob'ej ri ab'anikil kik'in taq iqitzijib'äl e'elesan kuma ri kik'amöl taq b'ey iqitzijib'anem. Konojel ri taq okik'amaya'l man nikikuqub'a' ta chik kik'u'x chi kij ri taq iqitzijib'äl elesan kuma GeoTrust, RapidSSL, Symantec, Thawte, chuqa' VeriSign. { $hostname } nrokisaj jun riqitzijib'al jun chi ke re k'amöl taq b'ey re' ruma ri' toq man tikirel ta nitojtob'ëx rub'anikil ri ajk'amaya'l ruxaq.

cert-error-symantec-distrust-admin = Yatikïr naya' rutzijol chi re ri runuk'samajel ajk'amaya'l ruxaq chi rij re k'ayewal re'.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Jikïl ruchajixik ruk'waxik: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Xjikib'äx ri ewan tzij kichin winäq: { $hasHPKP }

cert-error-details-cert-chain-label = Rucholajil wujil:

open-in-new-window-for-csp-or-xfo-error = Tijaq Ruxaq pa jun K'ak'a' Tzuwäch

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Richin nichajïx ri ajikomal, man xtuya' ta q'ij ri { $hostname } chi re ri { -brand-short-name } richin nuk'üt pe ri ruxaq we jun chik ruxaq k'amaya'l ruch'ikib'an. Richin nitz'et re ruxaq re', k'o chi nijaq pa jun k'ak'a' tzuwäch.

## Messages used for certificate error titles

connectionFailure-title = Man tikirel ta nok
deniedPortAccess-title = Q'aton re ochochib'äl re'
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Hmm. K'o qak'ayewal richin niqïl ri ruxaq k'amaya'l.
fileNotFound-title = Man xilitäj ta ri yakb'äl
fileAccessDenied-title = Xq'at rutz'etik ri yakb'äl
generic-title = Uy.
captivePortal-title = Tok pa k'amab'ey
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hmm. Man ütz ta niwachin ri ochochib'äl ri'.
netInterrupt-title = Xq'at ri okem
notCached-title = Xk'is Ruq'ijul ri Wuj
netOffline-title = Pa rub'eyal majun okem
contentEncodingError-title = Sachoj pa rucholajil rupam
unsafeContentType-title = Itzel ruwäch chi yakb'äl
netReset-title = Tikirisan chik ri okem
netTimeout-title = Xxik'o ruq'ijul ri okem
unknownProtocolFound-title = Man nich'ob'otäj ta ri ochochib'äl
proxyConnectFailure-title = Ja ri proxy k'uxasamaj nixutun ri okem
proxyResolveFailure-title = Man nilitäj ta ri proxi ruk'u'x samaj
redirectLoop-title = Man ütz ta tajin niq'axan ri ruxaq k'amaya'l
unknownSocketType-title = Man oyob'en ta re rutzijol tajin nuya' pe ri ruk'u'x samaj
nssFailure2-title = Xq'ate' ri ütz okem
csp-xfo-error-title = { -brand-short-name } Man Nitikïr Ta Nujäq Re Ruxaq Re'
corruptedContentError-title = Sachoj Ruma Itzel Rupam
remoteXUL-title = Näj XUL
sslv3Used-title = Man tikirel ta ütz nok
inadequateSecurityError-title = Itzel ri awokem
blockedByPolicy-title = Xq'at Ruxaq
clockSkewError-title = Sachinäq ri ruch'utiq'ijub'al akematz'ib'
networkProtocolError-title = Rusachoj Rub'eyal Nisamäj K'amb'ey
nssBadCert-title = Rutzijol K'ayewal: Nimaläj Ruk'ayewal Jikomal Petenäq
nssBadCert-sts-title = Man Xok Ta: Jikïl jun Ruk'ayewal Jikomal
certerror-mitm-title = Software Nuq'äch chi ri { -brand-short-name } Ütz tok pa re Ruxaq K'amaya'l Re'
