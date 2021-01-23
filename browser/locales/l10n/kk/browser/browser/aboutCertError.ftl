# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } қолданып тұрған қауіпсіздік сертификаты қате.

cert-error-mitm-intro = Веб-сайттар өз шынайылығын сертификаттар арқылы куәландырады, ал, оларды сертификаттау орталықтары шығарады.

cert-error-mitm-mozilla = { -brand-short-name } қолдауын көрсететін коммерциялық емес Mozilla ұйымы, ол болса, сертификаттау орталықтары сертификаттарының ашық қоймасын басқарады. Бұл қойма сертификаттау орталықтары пайдаланушылар қауіпсіздігін сақтаудың ең жақсы тәсілдерін ұстанатынына көз жеткізуге мүмкін етеді.

cert-error-mitm-connection = Байланыс қауіпсіздігін тексеру үшін, { -brand-short-name } пайдаланушының операциялық жүйесінің құрамындағы қойманы емес, Mozilla ұсынған сертификттау орталықтарының сертификаттар қоймасын пайдаланады. Сондықтан, антивирустық бағдарлама немесе желі Mozilla СО қоймасында жоқ СО шығарған сертификатты қолданатын байланысты жолда ұстап қалатын болса, байланыс қауіпсіз емес ретінде саналады.

cert-error-trust-unknown-issuer-intro = Әлдебіреу бұл сайттың жалған нұсқасын ұсынып тұр, жалғастырмауыңыз керек.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Веб-сайттар өз шынайылығын сертификаттар арқылы дәлелдейді. { -brand-short-name } { $hostname } сайтына сенбейді, өйткені сертификат шығарушысы белгісіз, немесе сертификатқа өздігінен қолтаңба қойылған, немесе сервер жарамды аралық сертификаттарды жіберіп тұрған жоқ.

cert-error-trust-cert-invalid = Сертификатты растау мүмкін емес, өйткені ол қате CA сертификатымен жасалды.

cert-error-trust-untrusted-issuer = Сертификатты растау мүмкін емес, өйткені шығарушы сертификаты расталмады.

cert-error-trust-signature-algorithm-disabled = Бұл сертификат сенімсіз, өйткені оған қауіпсіз емес болғаны үшін сөндірілген алгоритмімен қолтаңба қойылған.

cert-error-trust-expired-issuer = Сертификатты растау мүмкін емес, өйткені шығарушы сертификатының мерзімі аяқталған.

cert-error-trust-self-signed = Сертификатқа сенім жоқ, өйткені оның қолтаңбасы өздігінен қойылған.

cert-error-trust-symantec = GeoTrust, RapidSSL, Symantec, Thawte және VeriSign шығарған сертификаттар бұдан былай қауіпсіз деп саналмайды, себебі бұл сертификаттау орталықтары қауіпсіздік тәжірибелерін бұрын орындамады.

cert-error-untrusted-default = Сертификат сенуге болатын көзден шыққан емес.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Веб-сайттар өздерінің шынайылығын сертификаттар арқылы дәлелдейді. { -brand-short-name } бұл веб-сайтқа сенбей тұр, өйткені ол { $hostname } үшін жарамсыз сертификатты қолданып тұр.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Веб-сайттар өздерінің шынайылығын сертификаттар арқылы дәлелдейді. { -brand-short-name } бұл веб-сайтқа сенбей тұр, өйткені ол { $hostname } үшін жарамсыз сертификатты қолданып тұр. Сертификат тек келесі үшін жарамды: <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Веб-сайттар өздерінің шынайылығын сертификаттар арқылы дәлелдейді. { -brand-short-name } бұл веб-сайтқа сенбей тұр, өйткені ол { $hostname } үшін жарамсыз сертификатты қолданып тұр. Сертификат тек келесі үшін жарамды: { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Веб-сайттар өздерінің шынайылығын сертификаттар арқылы дәлелдейді. { -brand-short-name } бұл веб-сайтқа сенбей тұр, өйткені ол { $hostname } үшін жарамсыз сертификатты қолданып тұр. Сертификат тек келесі аттар үшін жарамды: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Веб-сайттар өздерінің шынайылығын сертификаттар арқылы дәлелдейді, олар тек белгілі уақыт аралығында жарамды болады. { $hostname } сертификатының мерзімі { $not-after-local-time } аяқталған.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Веб-сайттар өздерінің шынайылығын сертификаттар арқылы дәлелдейді, олар тек белгілі уақыт аралығында жарамды болады. { $hostname } сертификатының мерзімі { $not-before-local-time } дейін әлі басталмайды.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Қате коды: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Веб-сайттар өздерінің шынайлығын сертификаттау орталықтары шығарған сертификаттар арқылы дәлелдейді. Браузерлердің көбі GeoTrust, RapidSSL, Symantec, Thawte және VeriSign шығарған сертификаттарға енді сенбейді. { $hostname } осы орталықтарының бірімен шығарылған сертификатты пайдаланады, сондықтан веб-сайт шынайылығын дәлелдеу мүмкін емес.

cert-error-symantec-distrust-admin = Веб-сайт әкімшісіне бұл мәселе туралы хабарлай аласыз.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }

cert-error-details-cert-chain-label = Сертификаттар тізбегі:

open-in-new-window-for-csp-or-xfo-error = Сайтты жаңа терезеде ашу

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Қауіпсіздігіңізді қорғау үшін, { $hostname } { -brand-short-name } үшін бетті көрсетуге рұқсат етпейді, егер оны басқа сайт ендірілген болса. Бұл бетті қарау үшін, оны жаңа терезеде ашыңыз.

## Messages used for certificate error titles

connectionFailure-title = Байланысты орнату сәтсіз аяқталды
deniedPortAccess-title = Бұл портқа тыйым салынған
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Кешіріңіз, бұл сайтты таба алмадық.
fileNotFound-title = Файл табылмады
fileAccessDenied-title = Файлға қатынау құқығы жоқ
generic-title = Қате.
captivePortal-title = Желіге кіру
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Кешіріңіз, бұл адрес дұрыс адреске ұқсамайды.
netInterrupt-title = Байланыс үзілген
notCached-title = Құжат ескірген
netOffline-title = Дербес жұмыс істеу режимі
contentEncodingError-title = Құраманы декодтау кезінде қате кетті
unsafeContentType-title = Қауіпсіз емес файл түрі
netReset-title = Байланыс үзілген
netTimeout-title = Байланысты күту уақыты аяқталды
unknownProtocolFound-title = Адресті талдау қатесі
proxyConnectFailure-title = Прокси сервері сұранымдарды үзіп тұр
proxyResolveFailure-title = Прокси сервері табылмады
redirectLoop-title = Парақтағы бағдарлау дұрыс емес
unknownSocketType-title = Сервердің жауабы күтпеген түрде
nssFailure2-title = Қорғалған байланысты орнату сәтсіз аяқталды
csp-xfo-error-title = { -brand-short-name } бұл парақты аша алмайды
corruptedContentError-title = Зақымдалған құрама қатесі
remoteXUL-title = Қашықтағы XUL
sslv3Used-title = Қауіпсіз түрде байланысу мүмкін емес
inadequateSecurityError-title = Сіздің байланысыңыз қауіпсіз емес
blockedByPolicy-title = Бұғатталған бет
clockSkewError-title = Сіздің компьютеріңіздің сағаты қате
networkProtocolError-title = Желілік хаттама қатесі
nssBadCert-title = Назарыңызға: алдыңызда тәуекел бар сияқты
nssBadCert-sts-title = Байланыс орнатылмады: мүмкін қауіпсіздік мәселесі
certerror-mitm-title = Бағдарламалық қамтама { -brand-short-name } үшін бұл сайтқа қауіпсіз түрде байланысуға жол бермейді
