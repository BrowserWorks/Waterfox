# This Source Code Form is subject to the terms of the Waterfox Public
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

## Reset Password dialog

pippki-failed-pw-change = Не удалось изменить пароль.
pippki-incorrect-pw = Вы ввели некорректный текущий пароль. Попробуйте снова.
pippki-pw-change-ok = Пароль успешно изменён.

pippki-pw-empty-warning = Ваши сохранённые пароли и закрытые ключи не будут защищены.
pippki-pw-erased-ok = Вы удалили свой пароль. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Предупреждение! Вы решили не использовать пароль. { pippki-pw-empty-warning }

pippki-pw-change2empty-in-fips-mode = Вы работаете в режиме соответствия FIPS. При работе в этом режиме необходимо установить пароль.

## Reset Primary Password dialog

reset-primary-password-window =
    .title = Сбросить мастер-пароль
    .style = width: 40em
reset-password-button-label =
    .label = Сбросить

reset-primary-password-text = При сбросе мастер-пароля, все сохранённые пароли для веб-сайтов, электронной почты, личные сертификаты и закрытые ключи будут утеряны. Вы действительно хотите сбросить свой мастер-пароль?

pippki-reset-password-confirmation-title = Сбросить мастер-пароль
pippki-reset-password-confirmation-message = Мастер-пароль был сброшен.

## Downloading cert dialog

download-cert-window =
    .title = Загрузка сертификата
    .style = width: 46em
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

client-auth-window =
    .title = Запрос идентификации пользователя
client-auth-site-description = Сайту необходимо определить, с каким сертификатом вас ассоциировать:
client-auth-choose-cert = Выберите сертификат для идентификации:
client-auth-cert-details = Информация о выбранном сертификате:

## Set password (p12) dialog

set-password-window =
    .title = Выбор пароля резервной копии сертификата
set-password-message = Введённый пароль служит для защиты резервной копии сертификата. Для продолжения резервного копирования требуется установка пароля.
set-password-backup-pw =
    .value = Пароль резервной копии:
set-password-repeat-backup-pw =
    .value = Пароль резервной копии (повторно):
set-password-reminder = Внимание: если вы забудете пароль резервной копии сертификата, то потом не сможете восстановить из неё сертификат. Эту информацию следует хранить в безопасном месте.

## Protected Auth dialog

protected-auth-window =
    .title = Защищённая идентификация с использованием токена
protected-auth-msg = Пожалуйста, пройдите процедуру идентификации, используя токен. Метод идентификации зависит от типа вашего токена.
protected-auth-token = Токен:
