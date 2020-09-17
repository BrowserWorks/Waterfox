# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = Der is in flater bard by in ferbining mei { $hostname }, omdat it in ferkeard feiligheidssertifikaat brûkt.

cert-error-mitm-intro = Websites bewize harren identiteit fia sertifikaten, dy't troch sertifikaatautoriteiten útjûn wurde.

cert-error-mitm-mozilla = { -brand-short-name } wurdt stipe troch de non-profitorganisaasje Mozilla, dy't in folslein iepen argyf foar sertifikaatautoriteiten (CA) beheart. It CA-argyf helpt te fersekerjen dat sertifikaatautoriteiten de bêste prosedueren foar brûkersbefeiliging folgje.

cert-error-mitm-connection = { -brand-short-name } brûkt it CA-argyf fan Mozilla om te ferifiearjen dat in ferbining befeilige is yn stee fan sertifikaten dy't troch it bestjoeringssysteem fan de brûker levere wurde. As in antifirusprogramma of in netwurk dus in ferbining ûnderskept mei in troch in CA útjûn befeiligingssertifikaat dat him yn it CA-argyf fan Mozilla stiet, wurdt de ferbining as ûnfeilich beskôge.

cert-error-trust-unknown-issuer-intro = Ien kin probearje de website nei te meitsjen, en jo kinne better net fierdergean.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Websites bewize harren identiteit fia sertifikaten. { -brand-short-name } fertrout { $hostname } net, omdat de útjouwer fan it sertifikaat ûnbekend is, it sertifikaat selsûndertekene is, of de server net de krekte tuskensertifikaten stjoert.

cert-error-trust-cert-invalid = It sertifikaat is net fertroud, omdat it útjûn is troch in ferkeard CA-sertifikaat.

cert-error-trust-untrusted-issuer = It sertifikaat is net fertroud, omdat it útjousertifikaat net fertroud is.

cert-error-trust-signature-algorithm-disabled = It sertifikaat is net fertroud omdat it ûndertekene is mei in algoritme dat útskeakele is omdat dat algoritme net feilich is.

cert-error-trust-expired-issuer = It sertifikaat is net fertroud, omdat it útjousertifikaat ferrûn is.

cert-error-trust-self-signed = It sertifikaat is net fertroud, omdat it sels ûndertekene is.

cert-error-trust-symantec = Sertifikaten dy't troch GeoTrust, RapidSSL, Symantec, Thawte en VeriSign útjûn binne, wurde net mear as feilich beskôge, omdat dizze sertifikaatautoriteiten yn it ferline gjin befeiligingsprosedueres folge hawwe.

cert-error-untrusted-default = It sertifikaat komt net fan in fertroude boarne.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Websites bewize harren identiteit fia sertifikaten. { -brand-short-name } fertrout dizze website net, omdat it in sertifikaat brûkt dat net jildich is foar { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Websites bewize harren identiteit fia sertifikaten. { -brand-short-name } fertrout dizze website net, omdat it in sertifikaat brûkt dat net jildich is foar { $hostname }. It sertifikaat is allinnich jildich foar <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Websites bewize harren identiteit fia sertifikaten. { -brand-short-name } fertrout dizze website net, omdat it in sertifikaat brûkt dat net jildich is foar { $hostname }. It sertifikaat is allinnich jildich foar { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Websites bewize harren identiteit fia sertifikaten. { -brand-short-name } fertrout dizze website net, omdat it in sertifikaat brûkt dat net jildich is foar { $hostname }. It sertifikaat is allinnich jildich foar de folgjende nammen: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Websites bewize harren identiteit fia sertifikaten dy't foar in bepaalde perioade jildich binne. It sertifikaat foar { $hostname } is op { $not-after-local-time } ferrûn.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Websites bewize harren identiteit fia sertifikaten dy't foar in bepaalde perioade jildich binne. It sertifikaat foar { $hostname } wurdt pas jildich fan { $not-before-local-time } ôf.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Flaterkoade: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Websites bewize harren identiteit fia sertifikaten, dy't troch sertifikaatautoriteiten útjûn wurde. De measte browsers fertrouwe gjin sertifikaten mear dy't troch GeoTrust, RapidSSL, Symantec, Thawte en VeriSign útjûn binne. { $hostname } brûkt in sertifikaat fan ien fan dizze autoriteiten, wêrtroch de identiteit fan de website net bewiisd wurde kin.

cert-error-symantec-distrust-admin = Jo kinne de behearder fan de website oer it probleem ynformearje.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }

cert-error-details-cert-chain-label = Sertifikaatketen:

open-in-new-window-for-csp-or-xfo-error = Website iepenje yn nij finster

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Om jo feilichheid te beskermjen, stiet { $hostname } net ta dat { -brand-short-name } de side toant as in oare website dizze opnommen hat. Om dizze side te besjen moatte jo dizze iepenje yn in nij finster.

## Messages used for certificate error titles

connectionFailure-title = Kin gjin ferbining meitsje
deniedPortAccess-title = Dit adres hat in beheinde tagong
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Hmm. Wy kinne dizze website net fine.
fileNotFound-title = Bestân net fûn
fileAccessDenied-title = Tagong ta it bestân is wegere
generic-title = Oei.
captivePortal-title = Oanmelde by netwurk
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hmm. Dat adres sjocht der net goed út.
netInterrupt-title = De ferbining waard ferbrutsen
notCached-title = Dokumint ferrûn
netOffline-title = Offline-modus
contentEncodingError-title = Ynhâldkodearringsflater
unsafeContentType-title = Unfeilich bestânstype
netReset-title = De ferbining waard opnij inisjalisearre
netTimeout-title = De wachttiid foar de ferbining is ferstrutsen
unknownProtocolFound-title = It adres waard net begrepen
proxyConnectFailure-title = De proxyserver wegeret ferbiningen
proxyResolveFailure-title = Kin de proxyserver net fine
redirectLoop-title = De side ferwiist net op in krekte wize troch
unknownSocketType-title = Unferwacht antwurd fan de server
nssFailure2-title = Befeilige ferbining mislearre
csp-xfo-error-title = { -brand-short-name } kin dizze side net iepenje
corruptedContentError-title = Skansearre-ynhâldsflater
remoteXUL-title = Remote XUL
sslv3Used-title = Kin gjin befeilige ferbining meitsje
inadequateSecurityError-title = Jo ferbining is net befeilige
blockedByPolicy-title = Blokkearre side
clockSkewError-title = Jo kompjûterklok jout de ferkearde tiid oan
networkProtocolError-title = Netwurkprotokolflater
nssBadCert-title = Warskôging: mooglik befeiligingsrisiko
nssBadCert-sts-title = Gjin ferbining makke: mooglik befeiligingsprobleem
certerror-mitm-title = Software foarkomt dat { -brand-short-name } in befeilige ferbining mei dizze website meitsje kin
