# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Качество пароля

## Change Password dialog

change-device-password-window =
    .title = Сменить пароль
# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Устройство защиты: { $tokenName }
change-password-old = Текущий пароль:
change-password-new = Новый пароль:
change-password-reenter = Новый пароль (повторно):
pippki-failed-pw-change = Не удалось изменить пароль.
pippki-incorrect-pw = Вы ввели некорректный текущий пароль. Попробуйте снова.
pippki-pw-change-ok = Пароль успешно изменён.
pippki-pw-empty-warning = Ваши сохранённые пароли и закрытые ключи не будут защищены.
pippki-pw-erased-ok = Вы удалили свой пароль. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Предупреждение! Вы решили не использовать пароль. { pippki-pw-empty-warning }
pippki-pw-change2empty-in-fips-mode = Вы работаете в режиме соответствия FIPS. При работе в этом режиме необходимо установить пароль.

## Reset Primary Password dialog

reset-primary-password-window2 =
    .title = Сбросить основной пароль
    .style = min-width: 40em
reset-password-button-label =
    .label = Сбросить
reset-primary-password-text = При сбросе основного пароля все сохранённые пароли для веб-сайтов и электронной почты, личные сертификаты и закрытые ключи будут утеряны. Вы действительно хотите сбросить свой основной пароль?
pippki-reset-password-confirmation-title = Сброс основного пароля
pippki-reset-password-confirmation-message = Ваш основной пароль был сброшен.

## Downloading cert dialog

download-cert-window2 =
    .title = Загрузка сертификата
    .style = min-width: 46em
download-cert-message = Вам предлагают доверять новому центру сертификации (CA).
download-cert-trust-ssl =
    .label = Доверять при идентификации веб-сайтов.
download-cert-trust-email =
    .label = Доверять при идентификации пользователей электронной почты.
download-cert-message-desc = Перед тем, как определиться с доверием к этому центру, рекомендуется проверить его сертификат, политику и процедуры (если возможно).
download-cert-view-cert =
    .label = Просмотреть
download-cert-view-text = Проверить сертификат центра

## Client Authorization Ask dialog


## Client Authentication Ask dialog

client-auth-window =
    .title = Запрос идентификации пользователя
client-auth-site-description = Сайту необходимо определить, с каким сертификатом вас ассоциировать:
client-auth-choose-cert = Выберите сертификат для идентификации:
client-auth-send-no-certificate =
    .label = Не отправлять сертификат
# Variables:
# $hostname (String) - The domain name of the site requesting the client authentication certificate
client-auth-site-identification = «{ $hostname }» запросил у вас идентификацию с помощью сертификата:
client-auth-cert-details = Информация о выбранном сертификате:
# Variables:
# $issuedTo (String) - The subject common name of the currently-selected client authentication certificate
client-auth-cert-details-issued-to = Кому выдан: { $issuedTo }
# Variables:
# $serialNumber (String) - The serial number of the certificate (hexadecimal of the form "AA:BB:...")
client-auth-cert-details-serial-number = Серийный номер: { $serialNumber }
# Variables:
# $notBefore (String) - The date before which the certificate is not valid (e.g. Apr 21, 2023, 1:47:53 PM UTC)
# $notAfter (String) - The date after which the certificate is not valid
client-auth-cert-details-validity-period = Действителен с { $notBefore } по { $notAfter }
# Variables:
# $keyUsages (String) - A list of already-localized key usages for which the certificate may be used
client-auth-cert-details-key-usages = Использования ключа: { $keyUsages }
# Variables:
# $emailAddresses (String) - A list of email addresses present in the certificate
client-auth-cert-details-email-addresses = Адреса эл. почты: { $emailAddresses }
# Variables:
# $issuedBy (String) - The issuer common name of the certificate
client-auth-cert-details-issued-by = Кем выдан: { $issuedBy }
# Variables:
# $storedOn (String) - The name of the token holding the certificate (for example, "OS Client Cert Token (Modern)")
client-auth-cert-details-stored-on = Место хранения: { $storedOn }
client-auth-cert-remember-box =
    .label = Запомнить это решение

## Set password (p12) dialog

set-password-window =
    .title = Выбор пароля резервной копии сертификата
set-password-message = Введённый пароль служит для защиты резервной копии сертификата. Для продолжения резервного копирования требуется установка пароля.
set-password-backup-pw =
    .value = Пароль резервной копии:
set-password-repeat-backup-pw =
    .value = Пароль резервной копии (повторно):
set-password-reminder = Внимание: если вы забудете пароль резервной копии сертификата, то потом не сможете восстановить из неё сертификат. Эту информацию следует хранить в безопасном месте.

## Protected authentication alert

# Variables:
# $tokenName (String) - The name of the token to authenticate to (for example, "OS Client Cert Token (Modern)")
protected-auth-alert = Пожалуйста, авторизуйтесь с токеном «{ $tokenName }». Как это сделать, зависит от токена (например, с помощью считывателя отпечатков пальцев или ввода кода с клавиатуры).
