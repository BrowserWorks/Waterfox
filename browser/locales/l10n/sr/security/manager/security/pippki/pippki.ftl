# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Ниво квалитета лозинке

## Change Password dialog

change-password-window =
    .title = Промена главне лозинке

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Безбедносни уређај: { $tokenName }
change-password-old = Тренутна лозинка:
change-password-new = Нова лозинка:
change-password-reenter = Нова лозинка (још једном):

## Reset Password dialog

reset-password-window =
    .title = Ресетуј главну лозинку
    .style = width: 40em

## Reset Primary Password dialog

reset-password-button-label =
    .label = Ресетуј
reset-password-text = Ако ресетујете главну лозинку, све сачуване лозинке за интернет и е-пошту, садржаји формулара, лични сертификати и кључеви биће "изгубљени". Да ли заиста желите ресетовати своју главну лозинку?

## Downloading cert dialog

download-cert-window =
    .title = Пријем сертификата
    .style = width: 46em
download-cert-message = Тражено је да верујете новом сертификационом телу (СА).
download-cert-trust-ssl =
    .label = Веруј овом сертификационом телу (CA) да идентификује веб сајтова.
download-cert-trust-email =
    .label = Веруј овом сертификационом телу (CA) да идентификује е-поште корисника.
download-cert-message-desc = Пре указивања поверења овој компанији за било коју намену испитајте њен сертификат и њене полисе и процедуре (ако постоје).
download-cert-view-cert =
    .label = Преглед
download-cert-view-text = Испитај сертификат сертификационог тела

## Client Authorization Ask dialog

client-auth-window =
    .title = Захтев за идентификацију корисника
client-auth-site-description = Овај веб сајт је тражио да се идентификујете помоћу сертификата:
client-auth-choose-cert = Изаберите сертификат који ће служити за идентификацију:
client-auth-cert-details = Детаљи о изабраном сертификату:

## Set password (p12) dialog

set-password-window =
    .title = Изаберите резервну лозинку за сертификат
set-password-message = Резервна лозинка за сертификат, коју изаберете овде, штитиће датотеку која ће бити направљена. За исте наставили морате поставити лозинку.
set-password-backup-pw =
    .value = Резервна лозинка за сертификат:
set-password-repeat-backup-pw =
    .value = Резервна лозинка за сертификат (опет):
set-password-reminder = Важно: ако заборавите лозинку за резервну лозинку сертификата, нећете моћи да касније вратите сертификат.  Лозинку сачувајте на безбедно место.

## Protected Auth dialog

protected-auth-window =
    .title = Потврда идентитета заштићеним знаком
protected-auth-msg = Пријавите се са знаком распознавања (token). Врста потврде идентитета зависи од врсте знака распознавања.
protected-auth-token = Знак:
