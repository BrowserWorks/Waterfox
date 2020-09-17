# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = Під час з’єднання з { $hostname } сталася помилка бо він використовує нечинний сертифікат безпеки.

cert-error-mitm-intro = Вебсайти засвідчують свою справжність за допомогою сертифікатів, що видаються сертифікаційними центрами.

cert-error-mitm-mozilla = { -brand-short-name } підтримується некомерційною організацією Mozilla, яка керує цілком відкритою базою даних сертифікаційних центрів (CA). База даних сертифікаційних центрів допомагає переконатися, що сертифікаційні центри дотримуються найкращих практик щодо безпеки користувачів.

cert-error-mitm-connection = Щоб перевірити захищеність з'єднання, { -brand-short-name } використовує базу даних сертифікаційних центрів від Mozilla, а не сертифікати, надані операційною системою користувача. Отже, якщо антивірусне програмне забезпечення чи мережа перехоплюють з'єднання з сертифікатом безпеки, виданим сертифікаційним центром, якого немає в базі даних сертифікаційних центрів Mozilla, таке з'єднання вважається небезпечним.

cert-error-trust-unknown-issuer-intro = Хтось може намагатися підмінити справжній вебсайт і вам краще не продовжувати.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Вебсайти засвідчують свою справжність за допомогою сертифікатів. { -brand-short-name } не довіряє { $hostname }, тому що видавець його сертифіката невідомий, сертифікат самостійно підписаний, або сервер не передає коректні посередницькі сертифікати.

cert-error-trust-cert-invalid = Немає довіри до сертифіката, бо він був випущений нечинним центром сертифікації.

cert-error-trust-untrusted-issuer = Немає довіри до сертифіката, бо він випущений недовіреним центром сертифікації.

cert-error-trust-signature-algorithm-disabled = Немає довіри до сертифіката, бо він був підписаний алгоритмом підпису, котрий відтоді був вимкнений через небезпечність.

cert-error-trust-expired-issuer = Сертифікат не є довіреним через те, що термін дії сертифіката видавця завершився.

cert-error-trust-self-signed = Немає довіри до сертифіката, бо він самопідписаний.

cert-error-trust-symantec = Сертифікати, видані GeoTrust, RapidSSL, Symantec, Thawte та VeriSign, більше не вважаються безпечними, оскільки ці видавці раніше не дотримувалися практики безпеки.

cert-error-untrusted-default = Сертифікат надійшов із недостовірного джерела.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Сайти підтверджують свою справжність за допомогою сертифікатів. { -brand-short-name } не довіряє цьому сайту, оскільки він використовує сертифікат, який недійсний для { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Сайти підтверджують свою справжність за допомогою сертифікатів. { -brand-short-name } не довіряє цьому сайту, оскільки він використовує сертифікат, який недійсний для { $hostname }. Сертифікат чинний лише для <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Сайти підтверджують свою справжність за допомогою сертифікатів. { -brand-short-name } не довіряє цьому сайту, оскільки він використовує сертифікат, який недійсний для { $hostname }. Сертифікат чинний лише для { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Сайти підтверджують свою справжність за допомогою сертифікатів. { -brand-short-name } не довіряє цьому сайту, оскільки він використовує сертифікат, який недійсний для { $hostname }. Сертифікат дійсний тільки для таких доменів: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Вебсайти засвідчують свою справжність за допомогою сертифікатів, що мають обмежений термін дії. Термін дії сертифіката для { $hostname } завершився { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Вебсайти засвідчують свою справжність за допомогою сертифікатів, що мають обмежений термін дії. Сертифікат для { $hostname } не буде дійсним до { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Код помилки: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Сайти підтверджують свою справжність за допомогою сертифікатів, що видаються центрами сертифікації. Більшість браузерів більше не довіряють сертифікатам, виданим GeoTrust, RapidSSL, Symantec, Thawte та VeriSign. { $hostname } використовує сертифікат від одного з цих видавців, тому справжність вебсайту не може бути засвідчена.

cert-error-symantec-distrust-admin = Ви можете сповістити про цю проблему адміністратора вебсайту.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = Примусове захищене з'єднання HTTP: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = HTTP Прикріплення публічного ключа: { $hasHPKP }

cert-error-details-cert-chain-label = Ланцюжок сертифіката:

open-in-new-window-for-csp-or-xfo-error = Відкрити сайт у новому вікні

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Щоб захистити вашу безпеку, { $hostname } не дозволятиме { -brand-short-name } показувати сторінку, якщо її вбудовано на іншому сайті. Щоб побачити цю сторінку, її потрібно відкрити в новому вікні.

## Messages used for certificate error titles

connectionFailure-title = Не вдалося з'єднатися
deniedPortAccess-title = Звернення до цієї адреси заборонено
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Гм. Ніяк не вдається знайти цей сайт.
fileNotFound-title = Файл не знайдено
fileAccessDenied-title = Доступ до файлу заборонено
generic-title = Ой.
captivePortal-title = Увійдіть до мережі
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Гм. Схоже, ця адреса неправильна.
netInterrupt-title = З’єднання перервано
notCached-title = Документ застарів
netOffline-title = Автономний режим
contentEncodingError-title = Помилка кодування вмісту
unsafeContentType-title = Небезпечний тип файлу
netReset-title = З’єднання скинуто
netTimeout-title = Перевищено термін очікування з’єднання
unknownProtocolFound-title = Незрозуміла адреса
proxyConnectFailure-title = Проксі-сервер відмовляється приймати з’єднання
proxyResolveFailure-title = Неможливо знайти проксі-сервер
redirectLoop-title = Неналежне перенаправлення на сторінці
unknownSocketType-title = Неочікувана відповідь сервера
nssFailure2-title = Не вдалося встановити безпечне з’єднання
csp-xfo-error-title = { -brand-short-name } не може відкрити цю сторінку
corruptedContentError-title = Помилка. Вміст пошкоджено
remoteXUL-title = Віддалений XUL
sslv3Used-title = Неможливо безпечно з’єднатися
inadequateSecurityError-title = Ваше з'єднання незахищене
blockedByPolicy-title = Заблокована сторінка
clockSkewError-title = Годинник вашого комп'ютера налаштовано неправильно
networkProtocolError-title = Помилка мережевого протоколу
nssBadCert-title = Обережно: Попереду ймовірна загроза безпеки
nssBadCert-sts-title = З'єднання не встановлено: Ймовірна загроза безпеки
certerror-mitm-title = Програмне забезпечення не дозволяє { -brand-short-name } безпечно з'єднатися з цим сайтом
