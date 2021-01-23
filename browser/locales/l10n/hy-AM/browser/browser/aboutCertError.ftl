# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname }-ը օգտագործում է անվտանգության սխալ վկայագիր:

cert-error-mitm-intro = Կայքերը ապացուցում են իրենց ինքնությունը վկայագրերի միջոցով, որոնք թողարկվում են հավաստագրման մարմինների կողմից:

cert-error-mitm-mozilla = { -brand-short-name } -ն ապահովված է շահույթ չհետապնդող Mozilla- ի կողմից, որը կառավարում է լիովին բաց հավաստագրման իրավասության (CA) խանութ: CA խանութն օգնում է ապահովել, որ հավաստագրման մարմինները հետևում են օգտագործողների անվտանգության լավագույն փորձին:

cert-error-mitm-connection = { -brand-short-name } - ն օգտագործում է Mozilla CA խանութը `հաստատելու, որ կապն ապահով է, այլ ոչ թե օգտագործողի գործառնական համակարգի կողմից տրամադրված վկայագրերի: Այսպիսով, եթե հակավիրուսային ծրագիրը կամ ցանցը ընդհատում են կապը անվտանգության Mozilla- ի կողմից, որը Mozilla CA խանութում չէ, կապը համարվում է անապահով:

cert-error-trust-unknown-issuer-intro = Ինչ-որ մեկը կարող էր փորձել կայքը սանձազերծել, և դուք չպետք է շարունակեք:

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Վեբ կայքերը ապացուցում են իրենց ինքնությունը հավաստագրերի միջոցով: { -brand-short-name }-ը չի վստահում { $hostname } -ին, քանի որ դրա վկայագրի թողարկողը անհայտ է, վկայագիրը ինքնագիր է, կամ սպասարկիչը չի ուղարկում ճիշտ միջանկյալ վկայականներ:

cert-error-trust-cert-invalid = Վկայագիրը վստահելի չէ, քանի որ այն տրամադրվել անվավեր վկայագրող կենտրոնի կողմից:

cert-error-trust-untrusted-issuer = Վկայագիրը վստահելի չէ, որովհետև թողարկողի վկայագիրը վստահելի չէ։

cert-error-trust-signature-algorithm-disabled = Վկայագիրը վստահելի չէ, որովհետև այն ստորագրվել է օգտագործելով ստորագրության հաշվեկարգ, որը անջատվել է, որովհետև այդ հաշվեկարգը անվտանգ չէ։

cert-error-trust-expired-issuer = Վկայագիրը վստահելի չէ, քանի որ արտոնագիր տրամադրողի ժամկետը սպառվել է:

cert-error-trust-self-signed = Վկայագիրը վստահելի չէ քանի որ այն ստորագրվել է իր իսկ կողմից:

cert-error-trust-symantec = GeoTrust- ի, RapidSSL- ի, Symantec- ի, Thawte- ի և VeriSign- ի կողմից թողարկված վկայականներն այլևս անվտանգ չեն համարվում, քանի որ անցյալում արտոնացման այս մարմիններին չի հաջողվել հետևել անվտանգության ունակություններին:

cert-error-untrusted-default = Վկայագիրը ստամադրող աղբյուրը վստահելի չէ:

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Վեբ կայքերը ապացուցում են իրենց ինքնությունը հավաստագրերի միջոցով: { -brand-short-name } չի վստահում այս կայքին, քանի որ այն օգտագործում է վկայագիր, որը վավեր չէ { $hostname }-ի համար:

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Վեբ կայքերը ապացուցում են իրենց ինքնությունը հավաստագրերի միջոցով: { -brand-short-name } չի վստահում այս կայքին, քանի որ այն օգտագործում է վկայագիր, որը վավեր չէ { $hostname } -ի համար: Վկայագիրը վավեր է միայն <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a> համար:

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Վեբ կայքերը ապացուցում են իրենց ինքնությունը հավաստագրերի միջոցով: { -brand-short-name } չի վստահում այս կայքին, քանի որ այն օգտագործում է վկայագիր, որը վավեր չէ { $hostname } -ի համար: Վկայագիրը վավեր է միայն { $alt-name } -ի համար:

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Վեբ կայքերը ապացուցում են իրենց ինքնությունը հավաստագրերի միջոցով: { -brand-short-name } չի վստահում այս կայքին, քանի որ այն օգտագործում է վկայագիր, որը վավեր չէ { $hostname } -ի համար: Հավաստագիրը վավեր է միայն հետևյալ անունների համար՝ { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Վեբ կայքերը ապացուցում են իրենց ինքնությունը վկայականների միջոցով, որոնք վավեր են սահմանված ժամանակահատվածի համար: { $hostname } վկայագիրը լրացել է { $not-after-local-time } հետո:

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Վեբ կայքերը ապացուցում են իրենց ինքնությունը վկայականների միջոցով, որոնք վավեր են սահմանված ժամանակահատվածի համար: { $hostname } վկայագիրը վավեր չի լինի մինչև { $not-before-local-time }։

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Սխալի կոդ՝ <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Վեբ կայքերը ապացուցում են իրենց ինքնությունը վկայականների միջոցով, որոնք թողարկվում են հավաստագրման մարմինների կողմից: Զննարկիչների մեծ մասը այլևս չի վստահում GeoTrust- ի, RapidSSL- ի, Symantec- ի, Thawte- ի և VeriSign- ի կողմից թողարկված վկայագրերին: { $hostname } ն օգտագործում է վկայագիր այս իշխանություններից որևէ մեկի կողմից, ուստի կայքի ինքնությունը չի կարող ապացուցվել:

cert-error-symantec-distrust-admin = Այս խնդրի մասին կարող եք տեղեկացնել վեբ կայքի համակարգավարին:

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP խիստ փոխանցման անվտանգություն. { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }

cert-error-details-cert-chain-label = Վկայագրի նպատակ.

open-in-new-window-for-csp-or-xfo-error = Բացել կայքը նոր պատուհանում

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Ձեր անվտանգությունը պաշտպանելու համար { $hostname }-ը թույլ չի տա, որ { -brand-short-name }-ը ցուցադրի էջը, եթե մեկ այլ կայք ներկառուցել է այն: Այս էջը տեսնելու համար հարկավոր է այն բացել նոր պատուհանում:

## Messages used for certificate error titles

connectionFailure-title = Չհաջողվեց կապ հաստատել
deniedPortAccess-title = Այս հասցեն արգելափակված է
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Հնարավոր չէ գտնել այդ կայքը:
fileNotFound-title = Նիշքը չի գտնվել
fileAccessDenied-title = Նիշքի մուտքը մերժված է
generic-title = Վայ։
captivePortal-title = Մուտք գործել ցանց
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Կարծես հասցեն ճիշտ չէ:
netInterrupt-title = Կապը խզվեց
notCached-title = Փաստաթուղթը սպառվել է
netOffline-title = Անցանց եղանակ
contentEncodingError-title = Բովանդակության Կոդավորման Սխալ
unsafeContentType-title = Ոչ անվտանգ ֆայլի տեսակ
netReset-title = Կապը խզվեց
netTimeout-title = Կապի հաստատման ժամանակը սպառվեց
unknownProtocolFound-title = Հասցեն անհասկանալի էր
proxyConnectFailure-title = Պրոքսի սպասարկիչը մերժել է հրաժարվելով կապերից
proxyResolveFailure-title = Չի ստացվում գտնել պրոքսի սպասարկիչը
redirectLoop-title = Էջի սխալ վերահասցեավորում
unknownSocketType-title = Սպասարկիչի պատասխանը անհասկանալի է:
nssFailure2-title = Չհաջողվեց կատարել Պաշտպանված կապակցում
csp-xfo-error-title = { -brand-short-name } Հնարավոր չէ բացել այս էջը
corruptedContentError-title = Բովանդակությունը վնասված է
remoteXUL-title = Հեռադիր XUL
sslv3Used-title = Չհաջողվեց անվտանգ կապակցումը
inadequateSecurityError-title = Կապակցումն անվտանգ չէ
blockedByPolicy-title = Արգելափակված էջ
clockSkewError-title = Ձեր համակարգչի ժամացույցը սխալ է
networkProtocolError-title = Ցանցի հաղորդակարգի սխալ
nssBadCert-title = Զգուշացում․ հնարավոր է ապահովության վտանգ
nssBadCert-sts-title = Չկապակցվեց․ հնարավոր անվտանգության թողարկող
certerror-mitm-title = Ծրագիրը կանխում է { -brand-short-name } Անվտանգորեն կապվելով այս կայքի հետ։
