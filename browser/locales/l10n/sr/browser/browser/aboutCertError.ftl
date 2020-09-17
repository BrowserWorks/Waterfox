# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } користи неважећи безбедносни сертификат.

cert-error-mitm-intro = Веб странице доказују свој идентитет путем сертификата које издају сертификациона тела.

cert-error-mitm-mozilla = { -brand-short-name } је подржан од непрофитне организације Mozilla, која управља потпуно отвореном продавницом сертификационих тела (СТ). Продавница осигурава да се сертификациона тела придржавају најбољих сигурносних пракси.

cert-error-mitm-connection = { -brand-short-name } користи Mozilla продавницу сертификационих тела да потврди сигурну везу, а не користи сертификате које испоручује оперативни систем корисника. Дакле, ако антивирус или мрежа пресрећу везу са безбедносним сертификатом издатим од стране СТ које нису у Mozilla продавници СТ, веза се сматра несигурном.

cert-error-trust-unknown-issuer-intro = Неко можда покушава да лажира сајт и не би требало да наставите.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Веб странице доказују свој идентитет путем сертификата. { -brand-short-name } не верује { $hostname } зато што је издавач сертификата непознат, сертификат је самопотписан или зато што сервер не шаље исправне посредне сертификате.

cert-error-trust-cert-invalid = Сертификат није од поверења јер га је издао неважећи ауторитет.

cert-error-trust-untrusted-issuer = Сертификат није од поверења јер је издавач није од поверења.

cert-error-trust-signature-algorithm-disabled = Сертификат није од поверења јер је коришћен алгоритам који није безбедан.

cert-error-trust-expired-issuer = Сертификат није од поверења јер је издавачев сертификат истекао.

cert-error-trust-self-signed = Сертификат није од поверења јер је самопотписан.

cert-error-trust-symantec = Сертификати које издају GeoTrust, RapidSSL, Symantec, Thawte, and VeriSign се више не сматрају безбедним, зато што ова сертификациона тела нису поштовала сигурносне праксе у прошлости.

cert-error-untrusted-default = Сертификат не долази из извора од поверења.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Веб странице доказују свој идентитет путем сертификата. { -brand-short-name } не верује овој страници зато што користи сертификат који није важећи за { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Веб странице доказују свој идентитет путем сертификата. { -brand-short-name } не верује овој страници зато што користи сертификат који није важећи за { $hostname }. Сертификат важи само за <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Веб странице доказују свој идентитет путем сертификата. { -brand-short-name } не верује овој страници зато што користи сертификат који није важећи за { $hostname }. Сертификат важи само за { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Веб странице доказују свој идентитет путем сертификата. { -brand-short-name } не верује овој страници зато што користи сертификат који није важећи за { $hostname }. Сертификат важи само за следећа имена: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Веб странице доказују свој идентитет путем сертификата, који важе само за одређени временски период. Сертификат за { $hostname } је истекао { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Веб странице доказују свој идентитет путем сертификата, који важи само за одређени временски период. Сертификат за { $hostname } ће постати важећи од { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Код грешке: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Веб странице доказују свој идентитет путем сертификата које издају сертификациона тела. Већина прегледача више не верује у сертификате које издају GeoTrust, RapidSSL, Symantec, Thawte, and VeriSign. { $hostname } користи сертификат једног од ових тела и зато се не може доказати идентитет веб странице.

cert-error-symantec-distrust-admin = Можете да обавестите администратора веб странице о овом проблему.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = HTTP Strict Transport Security: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Public Key Pinning: { $hasHPKP }

cert-error-details-cert-chain-label = Certificate chain:

open-in-new-window-for-csp-or-xfo-error = Отворите страницу у новом прозору

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Да би заштитио вашу сигурност, { $hostname } неће дозволити { -brand-short-name }-у да прикаже страницу ако ју је уградио неки други сајт. Да бисте видели ову страницу, потребно је да је отворите у новом прозору.

## Messages used for certificate error titles

connectionFailure-title = Повезивање није успело
deniedPortAccess-title = Ова адреса је забрањена
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Хмм. Имамо проблем са проналажењем тог сајта.
fileNotFound-title = Датотека није пронађена
fileAccessDenied-title = Приступ датотеци је одбијен
generic-title = Упс.
captivePortal-title = Пријави се на мрежу
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Хмм. Та адреса не изгледа исправно.
netInterrupt-title = Веза је прекинута
notCached-title = Документ је истекао
netOffline-title = Рад ван мреже
contentEncodingError-title = Грешка у кодирању садржаја
unsafeContentType-title = Небезбедна врста датотеке
netReset-title = Веза је ресетована
netTimeout-title = Веза је истекла
unknownProtocolFound-title = Нејасна адреса
proxyConnectFailure-title = Прокси сервер одбија везе
proxyResolveFailure-title = Не могу да пронађем прокси сервер
redirectLoop-title = Страница се не преусмерава исправно
unknownSocketType-title = Неочекиван одговор од сервера
nssFailure2-title = Безбедна веза није успостављена
csp-xfo-error-title = { -brand-short-name } не може да отвори ову страницу
corruptedContentError-title = Грешка оштећеног садржаја
remoteXUL-title = Удаљени XUL
sslv3Used-title = Не могу се повезати безбедно
inadequateSecurityError-title = Веза није сугурна
blockedByPolicy-title = Блокиране странице
clockSkewError-title = Време на вашем рачунару је погрешно
networkProtocolError-title = Грешка мрежног протокола
nssBadCert-title = Упозорење: Потенцијални безбедносни ризик
nssBadCert-sts-title = Нисам се повезао: могући безбедносни проблем
certerror-mitm-title = Програм спречава { -brand-short-name } да се безбедно повеже на ову страницу
