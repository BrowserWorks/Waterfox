# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Пароль сапасы

## Change Password dialog

change-password-window =
    .title = Мастер-парольді ауыстыру

change-device-password-window =
    .title = Парольді өзгерту

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Қорғаныс құрылғысы: { $tokenName }
change-password-old = Ағымдағы пароль:
change-password-new = Жаңа пароль:
change-password-reenter = Жаңа пароль (қайтадан):

## Reset Password dialog

reset-password-window =
    .title = Мастер-парольді тастау
    .style = width: 40em

pippki-failed-pw-change = Парольді өзгерту мүмкін емес.
pippki-incorrect-pw = Сіз ағымдағы парольді қате енгіздіңіз. Қайтадан енгізіп көріңіз.
pippki-pw-change-ok = Пароль сәтті өзгертілді.

pippki-pw-empty-warning = Сіздің сақталған парольдер мен жеке кілттер қорғалмайтын болады.
pippki-pw-erased-ok = Сіз өз пароліңізді өшірдіңіз. { pippki-pw-empty-warning }

## Reset Primary Password dialog

reset-primary-password-window =
    .title = Басты парольді қолдану
    .style = width: 40em
reset-password-button-label =
    .label = Тастау
reset-password-text = Мастер-пароліңізді тастасаңыз, сақталған электронды пошта парольдері, жеке сертификаттар және жеке кілттер жоғалып кетеді. Мастер-пароліңізді тастауды шынымен қалайсыз ба?

reset-primary-password-text = Басты пароліңізді тастасаңыз, сақталған электронды пошта парольдері, жеке сертификаттар және жеке кілттер жоғалып кетеді. Басты парольді тастауды шынымен қалайсыз ба?

pippki-reset-password-confirmation-title = Басты парольді қалпына тастау
pippki-reset-password-confirmation-message = Сіздің басты пароліңіз тасталды.

## Downloading cert dialog

download-cert-window =
    .title = Сертификатты жүктеу
    .style = width: 46em
download-cert-message = Сізден жаңа Сертификаттау Орталығына (CA) сену сұранды.
download-cert-trust-ssl =
    .label = Веб-сайттарды идентификациялауда осы CA сену.
download-cert-trust-email =
    .label = Электронды пошта пайдаланушыларын идентификациялауда осы CA сену.
download-cert-message-desc = Осы сертификаттау орталығына (CA) әр мақсаттарға сену алдында, оның сертификатын тексеруіңіз керек (мүмкін болса).
download-cert-view-cert =
    .label = Қарап шығу
download-cert-view-text = CA сертификатын тексеру

## Client Authorization Ask dialog

client-auth-window =
    .title = Пайдаланушыны идентификациялаұ сұранымы
client-auth-site-description = Сайт сізден өзіңізді сертификат арқылы анықтауды сұрап тұр:
client-auth-choose-cert = Өзіңізді анықтайтын сертификатты таңдаңыз:
client-auth-cert-details = Таңдалған сертификат ақпараты:

## Set password (p12) dialog

set-password-window =
    .title = Сертификатты қалмына келтіру паролі
set-password-message = Сертификаттың көшірме жасау паролі осы көшірмені қорғау үшін арналған. Жалғастырар алдында осы парольді орнатуыңыз керек.
set-password-backup-pw =
    .value = Сертификатты қалпына келтіру паролі:
set-password-repeat-backup-pw =
    .value = Сертификатты қалпына келтіру паролі(қайтадан):
set-password-reminder = Маңызды: Егер сертификатты қалпана келтіру паролін жоғалтсаңыз, кейін оны қалпына келтіре алмайсыз.  Паролді қауіпсіз жерге жазыңыз.

## Protected Auth dialog

protected-auth-window =
    .title = Қорғалған токен аутентификациясы
protected-auth-msg = Токен үшін аутентификация керек. Оның түрі токен түріне байланысты.
protected-auth-token = Токен:
