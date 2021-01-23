# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-intro = { $hostname } ужывае няспраўны сертыфікат бяспекі.

cert-error-mitm-intro = Вэб-сайты пацвярджаюць сваю ідэнтычнасць з дапамогай сертыфікатаў, выдадзеных сертыфікацыйнымі ўстановамі.

cert-error-mitm-mozilla = { -brand-short-name } падтрымліваецца некамерцыйнай Mozilla, якая кіруе цалкам адкрытай базай дадзеных сертыфікацыйных устаноў. Гэта база дапамагае пераканацца, што сертыфікацыйныя ўстановы прытрымліваюцца найлепшых практык для бяспекі карыстальніка.

cert-error-mitm-connection = { -brand-short-name } выкарыстоўвае для праверкі бяспекі злучэння базу дадзеных сертыфікацыйных устаноў Mozilla, а не сховішча сертыфікатаў, убудаванае ў аперацыйную сістэму карыстальніка. Такім чынам, калі антывірус або сетка перахоплівае злучэнне з дапамогай сертыфіката, выдадзенага сертыфікацыйнай установай, якой няма ў базе Mozilla, злучэнне не лічыцца бяспечным.

cert-error-trust-unknown-issuer-intro = Хтось можа спрабаваць падмяніць гэты вэб-сайт. Вам лепш не працягваць.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-trust-unknown-issuer = Вэб-сайты пацвярджаюць сваю ідэнтычнасць з дапамогаю сертыфікатаў. { -brand-short-name } не давярае { $hostname }, таму што выдавец яго сертыфіката нявызначаны, сертыфікат самападпісаны, або сервер не дае спраўных прамежкавых сертыфікатаў.

cert-error-trust-cert-invalid = Сертыфікату нельга давяраць, бо ён выдадзены ЦС з няспраўным сертыфікатам.

cert-error-trust-untrusted-issuer = Сертыфікату нельга давяраць, бо сертыфікат выдаўца - не давераны.

cert-error-trust-signature-algorithm-disabled = Сертыфікат не мае даверу, бо ён падпісаны з дапамогай алгарытму подпісаў, які забаронены, бо не з'яўляецца бяспечным.

cert-error-trust-expired-issuer = Сертыфікату нельга давяраць, бо сертыфікат выдаўца састарэў.

cert-error-trust-self-signed = Сертыфікату нельга давяраць, бо ён самападпісаны.

cert-error-trust-symantec = Сертыфікаты, выдадзеныя GeoTrust, RapidSSL, Symantec, Thawte і VeriSign, больш не лічацца бяспечнымі, таму што гэтыя ўстановы не прытрымліваліся практык бяспекі ў мінулым.

cert-error-untrusted-default = Сертыфікат прыйшоў з крыніцы, якой нельга давяраць.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-domain-mismatch = Вэб-сайты пацвярджаюць сваю ідэнтычнасць з дапамогаю сертыфікатаў. { -brand-short-name } не давярае гэтаму сайту, таму што ён выкарыстоўвае сертыфікат, не дзейсны для { $hostname }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single = Вэб-сайты пацвярджаюць сваю ідэнтычнасць з дапамогаю сертыфікатаў. { -brand-short-name } не давярае гэтаму сайту, таму што ён выкарыстоўвае сертыфікат, не дзейсны для { $hostname }. Сертыфікат сапраўдны толькі для <a data-l10n-name="domain-mismatch-link">{ $alt-name }</a>.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $alt-name (String) - Alternate domain name for which the cert is valid.
cert-error-domain-mismatch-single-nolink = Вэб-сайты пацвярджаюць сваю ідэнтычнасць з дапамогаю сертыфікатаў. { -brand-short-name } не давярае гэтаму сайту, таму што ён выкарыстоўвае сертыфікат, не дзейсны для { $hostname }. Сертыфікат сапраўдны толькі для { $alt-name }.

# Variables:
# $subject-alt-names (String) - Alternate domain names for which the cert is valid.
cert-error-domain-mismatch-multiple = Вэб-сайты пацвярджаюць сваю ідэнтычнасць з дапамогаю сертыфікатаў. { -brand-short-name } не давярае гэтаму сайту, таму што ён выкарыстоўвае сертыфікат, не дзейсны для { $hostname }. Сертыфікат дзейсны толькі для наступных: { $subject-alt-names }

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-after-local-time (Date) - Certificate is not valid after this time.
cert-error-expired-now = Вэб-сайты пацвярджаюць сваю ідэнтычнасць з дапамогай сертыфікатаў, дзейсных у пэўны прамежак часу. Тэрмін дзеяння сертыфіката для { $hostname } скончыўся { $not-after-local-time }.

# Variables:
# $hostname (String) - Hostname of the website with cert error.
# $not-before-local-time (Date) - Certificate is not valid before this time.
cert-error-not-yet-valid-now = Вэб-сайты пацвярджаюць сваю ідэнтычнасць з дапамогай сертыфікатаў, дзейсных у пэўны прамежак часу. Сертыфіката для { $hostname } будзе нядзейсны да { $not-before-local-time }.

# Variables:
# $error (String) - NSS error code string that specifies type of cert error. e.g. unknown issuer, invalid cert, etc.
cert-error-code-prefix-link = Код памылкі: <a data-l10n-name="error-code-link">{ $error }</a>

# Variables:
# $hostname (String) - Hostname of the website with cert error.
cert-error-symantec-distrust-description = Вэб-сайты пацвярджаюць сваю ідэнтычнасць з дапамогай сертыфікатаў, выдадзеных сертыфікацыйнымі ўстановамі. Большасць браўзераў больш не давяраюць сертыфікатам, выдадзеным GeoTrust, RapidSSL, Symantec, Thawte і VeriSign. { $hostname } выкарыстоўвае сертыфікат ад адной з гэтых устаноў, таму ідэнтычнасць сайта не можа быць пацверджана.

cert-error-symantec-distrust-admin = Вы можаце паведаміць адміністратару вэб-сайта аб гэтай праблеме.

# Variables:
# $hasHSTS (Boolean) - Indicates whether HSTS header is present.
cert-error-details-hsts-label = Фарсіраванае абароненае злучэнне HTTP: { $hasHSTS }

# Variables:
# $hasHPKP (Boolean) - Indicates whether HPKP header is present.
cert-error-details-key-pinning-label = Прывязка адкрытага ключа HTTP: { $hasHPKP }

cert-error-details-cert-chain-label = Ланцужок сертыфіката:

open-in-new-window-for-csp-or-xfo-error = Адкрыць сайт у новым акне

# Variables:
# $hostname (String) - Hostname of the website blocked by csp or xfo error.
csp-xfo-blocked-long-desc = Каб захаваць вашу бяспеку, { $hostname } не дазволіць { -brand-short-name } паказаць старонку, калі яна ўбудавана ў іншы сайт. Каб убачыць гэтую старонку, трэба адкрыць яе ў новым акне.

## Messages used for certificate error titles

connectionFailure-title = Нельга злучыцца
deniedPortAccess-title = Гэты адрас абмежаваны
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
dnsNotFound-title = Хм. Ніяк не выходзіць знайсці гэты сайт.
fileNotFound-title = Файл не знойдзены
fileAccessDenied-title = Доступ да файла забаронены
generic-title = Ух?!
captivePortal-title = Злучыцца з сеткай
# "Hmm" is a sound made when considering or puzzling over something.
# You don't have to include it in your translation if your language does not have a written word like this.
malformedURI-title = Хм. Гэты адрас не выглядае сапраўдным.
netInterrupt-title = Злучэнне перарвана
notCached-title = Дакумент састарэў
netOffline-title = Пазасеткавы рэжым
contentEncodingError-title = Памылка кадавання змесціва
unsafeContentType-title = Небяспечны тып файла
netReset-title = Злучэнне скінута
netTimeout-title = Час чакання злучэння выйшаў
unknownProtocolFound-title = Немагчыма распазнаць адрас
proxyConnectFailure-title = Проксі-сервер адмовіўся злучацца
proxyResolveFailure-title = Немагчыма знайсці проксі-сервер
redirectLoop-title = Старонка няправільна перанакіроўваецца
unknownSocketType-title = Нечаканы адказ сервера
nssFailure2-title = Няўдача бяспечнага злучэння
csp-xfo-error-title = { -brand-short-name } не можа адкрыць гэту старонку
corruptedContentError-title = Памылка пашкоджанага змесціва
remoteXUL-title = Аддалены XUL
sslv3Used-title = Немагчыма злучыцца бяспечна
inadequateSecurityError-title = Ваша злучэнне не бяспечнае
blockedByPolicy-title = Заблакаваная старонка
clockSkewError-title = Гадзіннік вашага камп'ютара ідзе няправільна
networkProtocolError-title = Памылка сеткавага пратаколу
nssBadCert-title = Папярэджанне: наперадзе патэнцыяльная пагроза бяспецы
nssBadCert-sts-title = Не злучаны: Патэнцыяльная праблема бяспекі
certerror-mitm-title = Праграмнае забеспячэнне не дазваляе { -brand-short-name } бяспечна злучыцца з гэтым сайтам
