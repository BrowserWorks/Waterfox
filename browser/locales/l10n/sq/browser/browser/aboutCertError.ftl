# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } përdor një dëshmi sigurie të pavlefshme.

cert-error-mitm-intro = Sajtet e dëshmojnë identitetin e tyre përmes dëshmish, të cilat lëshohen nga autoritete dëshmish.

cert-error-mitm-mozilla = { -brand-short-name } ka nga pas entin jofitimprurës Mozilla, i cili administron një shitore tërësisht të hapur autoriteti dëshmish (AD). Shitorja AD ndihmon të garantohet se autoritetet e dëshmive ndjekin praktikat më të mirë mbi sigurinë e përdoruesve.

cert-error-mitm-connection = { -brand-short-name } përdor shitoren AD të Mozilla-s për të verifikuar se një lidhje është e sigurt, në vend se dëshmi të furnizuara nga sistemi operativ i përdoruesit. Kështu, nëse një program antivirus apo një rrjet përgjon një lidhje me një dëshmi sigurie të lëshuar nga një Autoritet Dëshmish që s’gjendet te shitorja AD Mozilla, lidhja konsiderohet jo e parrezik.

cert-error-trust-unknown-issuer-intro = Dikush mund të jetë duke u rrekur të hiqet si sajti dhe s’duhet të vazhdoni.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Sajtet e dëshmojnë identitetin e tyre përmes dëshmish. { -brand-short-name } s’i zë besë { $hostname } ngaqë lëshuesi i dëshmisë është i panjohur, dëshmia është e vetë-nënshkruar, ose shërbyesi nuk po dërgon dëshmitë e sakta ndërmjetëse.

cert-error-trust-cert-invalid = Dëshmia nuk është besuar, sepse qe lëshuar nga një autoritet i pavlefshëm dëshmish.

cert-error-trust-untrusted-issuer = Dëshmia nuk është besuar, sepse lëshuesi i dëshmisë nuk është besuar.

cert-error-trust-signature-algorithm-disabled = Dëshmia nuk është e besueshme, ngaqë është nënshkruar duke përdorur një algoritëm nënshkrimesh i cili është i çaktivizuar, pasi nuk është i sigurt.

cert-error-trust-expired-issuer = Dëshmia nuk është besuar, sepse dëshmia e lëshuesit ka skaduar.

cert-error-trust-self-signed = Dëshmia nuk besohet, ngaqë është e vetënënshkruar.

cert-error-trust-symantec = Dëshmitë e lëshuara nga GeoTrust, RapidSSL, Symantec, Thawte, dhe VeriSign nuk konsiderohen më gjatë të sigurta, ngaqë këto autoritete dëshmish nuk kanë ndjekur praktika sigurie në të kaluarën.

cert-error-untrusted-default = Dëshmia nuk vjen nga një burim i besuar.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Sajtet e dëshmojnë identitetin e tyre përmes dëshmish. { -brand-short-name } nuk i zë besë këtij sajti ngaqë përdor një dëshmi që s’është e vlefshme për { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Sajtet e dëshmojnë identitetin e tyre përmes dëshmish. { -brand-short-name } nuk i zë besë këtij sajti, ngaqë përdor një dëshmi që s’është e vlefshme për { $hostname }. Dëshmia është e vlefshme vetëm për <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Sajtet e dëshmojnë identitetin e tyre përmes dëshmish. { -brand-short-name } nuk i zë besë këtij sajti, ngaqë përdor një dëshmi që s’është e vlefshme për { $hostname }. Dëshmia është e vlefshme vetëm për { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Sajtet e dëshmojnë identitetin e tyre përmes dëshmish. { -brand-short-name } nuk i zë besë këtij sajti, ngaqë përdor një dëshmi që s’është e vlefshme për { $hostname }. Dëshmia është e vlefshme vetëm për emrat vijues: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Sajtet e dëshmojnë identitetin e tyre përmes dëshmish, që janë të vlefshme për një periudhë të caktuar kohe. Dëshmia për { $hostname } skadoi më { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Sajtet e dëshmojnë identitetin e tyre përmes dëshmish, që janë të vlefshme për një periudhë të caktuar kohe. Dëshmia për { $hostname } s’do të jetë e vlefshme deri më { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Kod gabimi: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Sajtet e dëshmojnë identitetin e tyre përmes dëshmish, të cilat lëshohen nga autoritete dëshmish. Shumica e shfletuesve nuk u besojnë më dëshmive të lëshuara nga GeoTrust, RapidSSL, Symantec, Thawte, dhe VeriSign. { $hostname } përdor një dëshmi nga njëri prej këtyre autoriteteve, ndaj identiteti i sajtit s’mund të provohet.

cert-error-symantec-distrust-admin = Mundeni të njoftoni përgjegjësin e sajtit mbi këtë problem.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }

cert-error-details-cert-chain-label = Varg dëshmish:

open-in-new-window-for-csp-or-xfo-error = Hape Sajtin në Dritare të Re

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Për të mbrojtur sigurinë tuaj, { $hostname } s’do ta lejojë { -brand-short-name }-in të shfaqë faqen, nëse e ka trupëzuar një sajt tjetër. Që të shihni këtë faqe, duhet ta hapni në një dritare tjetër.

## Messages used for certificate error titles

connectionFailure-title = S'arrin të lidhet
deniedPortAccess-title = Kjo adresë është e ndaluar
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Hmm. Po kemi probleme me gjetjen e atij sajti.
fileNotFound-title = S'u gjet kartelë
fileAccessDenied-title = Hyrja te kartela u mohua
generic-title = Hëm.
captivePortal-title = Hyni në rrjet
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Hmm. AJo adresë s’duket në rregull.
netInterrupt-title = Lidhja u ndërpre
notCached-title = Dokumenti Ka Skaduar
netOffline-title = Mënyrë jo në linjë
contentEncodingError-title = Gabim Kodimi Lënde
unsafeContentType-title = Lloj Kartele Jo i Parrezik
netReset-title = Lidhja u rivendos
netTimeout-title = Lidhjes i mbaroi koha
unknownProtocolFound-title = Adresa nuk u kuptua
proxyConnectFailure-title = Shërbyesi ndërmjetës po hedh poshtë lidhjet
proxyResolveFailure-title = S'arrihet të gjendet shërbyesi ndërmjetës
redirectLoop-title = Faqja nuk është ridrejtuar si duhet
unknownSocketType-title = Përgjigje e papritur prej shërbyesit
nssFailure2-title = Dështoi Lidhja e Sigurt
csp-xfo-error-title = { -brand-short-name }-i S’mund Ta Hapë Këtë Faqe
corruptedContentError-title = Gabim nga Lëndë e Dëmtuar
remoteXUL-title = XUL i Largët
sslv3Used-title = S'arrin të Lidhet Në Mënyrë të Sigurt
inadequateSecurityError-title = Lidhja juaj s'është e sigurt
blockedByPolicy-title = Faqe e Bllokuar
clockSkewError-title = Ora e kompjuterit tuaj është gabim
networkProtocolError-title = Gabim Protokolli Rrjeti
nssBadCert-title = Kujdes: Rrezik Potencial Sigurie Përpara
nssBadCert-sts-title = Nuk U Lidh: Çështje Potenciale Sigurie
certerror-mitm-title = Një software po i pengon { -brand-short-name }-it të Lidhet Në Mënyrë të Sigurt te Ky Sajt
