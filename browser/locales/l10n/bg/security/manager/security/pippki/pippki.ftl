# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Качество на паролата

## Change Password dialog

change-password-window =
    .title = Промяна на главната парола

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Устройство по безопасността: { $tokenName }
change-password-old = Текуща парола:
change-password-new = Нова парола:
change-password-reenter = Нова парола (отново):

## Reset Password dialog

reset-password-window =
    .title = Нулиране на главната парола
    .style = width: 40em

## Reset Primary Password dialog

reset-password-button-label =
    .label = Нулиране
reset-password-text = Ако нулирате главната парола, всичките съхранени пароли за сайтове и е-поща, данни за формуляри, лични сертификати и персонални ключове ще бъдат загубени. Сигурни ли сте, че искате да нулирате главната парола?

## Downloading cert dialog

download-cert-window =
    .title = Изтегляне на сертификат
    .style = width: 46em
download-cert-message = Поискано е да се доверите на нов удостоверител на сертификати (CA).
download-cert-trust-ssl =
    .label = Доверяване на този CA за идентифициране на страници.
download-cert-trust-email =
    .label = Доверяване на този CA за идентифициране на потребители на е-поща.
download-cert-message-desc = Преди да се доверите на този CA за каквато и да е цел, трябва да изследвате сертификата му, както и политиката и процедурите на издателя, ако са налични.
download-cert-view-cert =
    .label = Преглед
download-cert-view-text = Изследване на сертификат на CA

## Client Authorization Ask dialog

client-auth-window =
    .title = Заявка за идентификация на потребител
client-auth-site-description = Този сайт изисква да се идентифицирате със сертификат:
client-auth-choose-cert = Избор на сертификат, който да се представи за идентификация:
client-auth-cert-details = Подробности за избрания сертификат:

## Set password (p12) dialog

set-password-window =
    .title = Избор на парола за резервно копие на сертификат
set-password-message = Паролата за резервно копие на сертификат защитава файла с резервно копие, който създавате. Трябва да поставите паролата, за да продължи създаването на резервно копие.
set-password-backup-pw =
    .value = Парола на резервното копие на сертификат:
set-password-repeat-backup-pw =
    .value = Парола на резервното копие на сертификат (отново):
set-password-reminder = Важно: Ако забравите паролата на резервното копие на сертификата, по-късно няма да може да възстановите от това резервно копие. Моля, запишете я на сигурно място.

## Protected Auth dialog

protected-auth-window =
    .title = Защитен удостоверяващ токен
protected-auth-msg = Моля, удостоверете токена. Начинът на удостоверяване зависи от токена.
protected-auth-token = Токен:
