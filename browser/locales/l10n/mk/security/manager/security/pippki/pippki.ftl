# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Мерач на квалитетот на лозинките

## Change Password dialog

change-password-window =
    .title = Менување на главната лозинка

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Безбедносен уред: { $tokenName }
change-password-old = Актуелна лозинка:
change-password-new = Нова лозинка:
change-password-reenter = Нова лозинка (повторно):

## Reset Password dialog

reset-password-window =
    .title = Ресетирање на главната лозинка
    .style = width: 40em

## Reset Primary Password dialog

reset-password-button-label =
    .label = Ресетирај
reset-password-text = Ако ја ресетирате главната лозинка сите ваши снимени лозикни, податоци за обрасци, сертификати и приватни клучеви ќе бидат загубени. Сигурно сакате да ја ресетирате главната лозинка?

## Downloading cert dialog

download-cert-window =
    .title = Преземање на сертификат
    .style = width: 46em
download-cert-message = Од вас е побарано да му верувате на нов авторитет за сертификати (CA).
download-cert-trust-ssl =
    .label = Верувај му на овој CA во идентифукувањето на мрежни места.
download-cert-trust-email =
    .label = Верувај му на овој CA во идентифукувањето на поштенски корисници.
download-cert-message-desc = Пред да му верувате на овој CA за било што, треба да го испитате неговиот сертификат и неговата политика и процедури (доколку ги има).
download-cert-view-cert =
    .label = Поглед
download-cert-view-text = Испитај го CA сертификатот

## Client Authorization Ask dialog

client-auth-window =
    .title = Барање за идентификација на корисникот
client-auth-site-description = Ова место побара од вас да се идентификувате со сертификат:
client-auth-choose-cert = Изберете сертификат кој ќе служи како идентификација:
client-auth-cert-details = Детали за избраниот сертификат:

## Set password (p12) dialog

set-password-window =
    .title = Избор на резервна лозинка за сертификатот
set-password-message = Лозинка за резервниот сертификат која ќе ја поставите овде, ќе ја заштитува резервната датотека која сакате да ја креирата.  Мора да ја поставите оваа лозинка пред да продолжите.
set-password-backup-pw =
    .value = Резервна лозинка за сертификатот:
set-password-repeat-backup-pw =
    .value = Резервна лозинка за сертификатот (повторно):
set-password-reminder = Важно: ако ја заборавите лозинката за резервниот сертификат, нема да можете да му пристапите на истиот. Чувајте ја лозинката на сигурно место.

## Protected Auth dialog

protected-auth-window =
    .title = Проверка со зашитетен белег
protected-auth-msg = Проверете се со белегот. Методот зависи од типот на белегот.
protected-auth-token = Белег:
