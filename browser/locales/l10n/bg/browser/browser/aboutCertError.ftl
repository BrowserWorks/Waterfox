# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } използва невалиден сертификат.

cert-error-mitm-intro = Страниците потвърждават самоличността си чрез сертификати, издавани от сертифициращи органи.

cert-error-mitm-mozilla = { -brand-short-name } е подкрепен от Mozilla - организация с нестопанска цел, която управлява изцяло отворено хранилище за администратори на сертификати (CA). Хранилището на СА дава допълнителни гаранции, че сертифициращите органи следват най-добрите практики за защита на потребителите.

cert-error-mitm-connection = { -brand-short-name } използва хранилището на Mozilla с администратори на сертификати (CA), за да провери дали връзката е защитена,  вместо сертификатите, предоставени от операционната система на потребителя. Така, ако антивирусна програма или мрежа прехваща връзката и променя сертификата за сигурност, с издаден от СА, който не е в хранилището на Mozilla с CA, връзката не се счита за защитена.

cert-error-trust-unknown-issuer-intro = Някой може би се опитва да подмени истинската страница и по-добре да не продължавате.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Страниците потвърждават самоличността си чрез сертификати. { -brand-short-name } не се доверява на { $hostname }, защото издателят на сертификата е неизвестен, сертификатът е самоподписан или сървърът не изпраща верните посреднически сертификати.

cert-error-trust-cert-invalid = Няма увереност в сертификата, защото е издаден от невалиден сертификат CA.

cert-error-trust-untrusted-issuer = Няма увереност в сертификата, защото няма увереност в сертификата на издателя.

cert-error-trust-signature-algorithm-disabled = Сертификатът не е доверен, защото е подписан с алгоритъм за подписване, който е деактивиран, защото не е безопасен.

cert-error-trust-expired-issuer = Няма увереност в сертификата, защото издателят на сертификата е с изтекла валидност.

cert-error-trust-self-signed = Няма увереност в сертификата, защото е самоподписан.

cert-error-trust-symantec = Сертификатите, издадени от GeoTrust, RapidSSL, Symantec, Thawte и VeriSign вече не се считат за безопасни, тъй като тези сертификационни органи не са спазвали практиките за сигурност в миналото.

cert-error-untrusted-default = Сертификатът идва от недостоверен източник.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Страниците потвърждават самоличността си чрез сертификати. { -brand-short-name } не се доверява на тази страница, защото сертификатът не е валиден за { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Страниците потвърждават самоличността си чрез сертификати. { -brand-short-name } не се доверява на тази страница, защото сертификатът не е валиден за { $hostname }. Сертификатът е валиден само за <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Страниците потвърждават самоличността си чрез сертификати. { -brand-short-name } не се доверява на тази страница, защото сертификатът не е валиден за { $hostname }. Сертификатът е валиден само за { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Страниците потвърждават самоличността си чрез сертификати. { -brand-short-name } не се доверява на тази страница, защото сертификатът не е валиден за { $hostname }. Сертификатът е валиден само за следните домейни { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Страниците потвърждават самоличността си чрез сертификати, които важат ограничен период от време. Сертификатът на { $hostname } е изтекъл на { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Страниците потвърждават самоличността си чрез сертификати, които важат ограничен период от време. Сертификатът на { $hostname } няма да е валиден преди { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Код на грешката: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Страниците потвърждават самоличността си чрез сертификати, издавани от сертифициращи органи. Повечето мрежови четци вече не се доверяват на сертификатите, издадени от GeoTrust, RapidSSL, Symantec, Thawte и VeriSign. { $hostname } използва сертификат от един от тези издатели и затова самоличността на страницата не може да бъде потвърдена.

cert-error-symantec-distrust-admin = Може да уведомите администратора на страницата за този проблем.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = Сигурен HTTP чрез ограничаване на транспорта (HSTS): { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = Закотвен публичен ключ на HTTP: { $hasHPKP }

cert-error-details-cert-chain-label = Верига на сертификата:

## Messages used for certificate error titles

connectionFailure-title = Не може да бъде установена връзка
deniedPortAccess-title = Този адрес е ограничен
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Хмм. Страницата не е намерена
fileNotFound-title = Файлът не е намерен
fileAccessDenied-title = Достъпът до файла е отказан
generic-title = Олеле.
captivePortal-title = Влизане в мрежа
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Хм. Адресът не изглежда правилен
netInterrupt-title = Връзката беше прекъсната
notCached-title = Документът е с изтекъл срок на валидност
netOffline-title = Работа извън мрежата
contentEncodingError-title = Грешка в кодировката на съдържанието
unsafeContentType-title = Опасен вид файл
netReset-title = Връзката е прекъсната
netTimeout-title = Времето за изчакване на връзка изтече
unknownProtocolFound-title = Адресът не е разпознат
proxyConnectFailure-title = Мрежовият посредник отказва връзката
proxyResolveFailure-title = Мрежовия посредник не може да бъде открит
redirectLoop-title = Страницата не пренасочва правилно
unknownSocketType-title = Неочакван отговор от сървъра
nssFailure2-title = Неуспешно установяване на шифрована връзка
corruptedContentError-title = Грешка поради развалено съдържание
remoteXUL-title = Отдалечен XUL
sslv3Used-title = Невъзможно създаване на защитена връзка
inadequateSecurityError-title = Връзката е незащитена
blockedByPolicy-title = Забранена страница
clockSkewError-title = Часовникът на компютъра не е верен
networkProtocolError-title = Нарушение на мрежовия протокол
nssBadCert-title = Внимание: Вероятен риск за сигурността
nssBadCert-sts-title = Неуспешно свързване: Евентуален проблем със сигурността
certerror-mitm-title = Софтуер пречи на { -brand-short-name } да осъществи защитена връзка към страницата
