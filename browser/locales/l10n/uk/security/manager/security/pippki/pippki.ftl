# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Рівень якості пароля

## Change Password dialog

change-password-window =
    .title = Зміна головного пароля

change-device-password-window =
    .title = Змінити пароль

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Пристрій захисту: { $tokenName }
change-password-old = Поточний пароль:
change-password-new = Новий пароль:
change-password-reenter = Новий пароль (ще раз):

## Reset Password dialog

reset-password-window =
    .title = Скидання головного пароля
    .style = width: 40em

pippki-failed-pw-change = Не вдається змінити пароль.
pippki-incorrect-pw = Ви ввели неправильний поточний головний пароль. Спробуйте ще раз.
pippki-pw-change-ok = Пароль змінено.

pippki-pw-empty-warning = Ваші збережені паролі та приватні ключі будуть не захищеними.
pippki-pw-erased-ok = Ви видалили головний пароль. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Попередження! Ви вирішили не використовувати головний пароль. { pippki-pw-empty-warning }

pippki-pw-change2empty-in-fips-mode = Зараз ви в режимі FIPS. Для цього режиму необхідно встановити пароль.

## Reset Primary Password dialog

reset-primary-password-window =
    .title = Скинути головний пароль
    .style = width: 40em
reset-password-button-label =
    .label = Скинути
reset-password-text = Якщо ви скинете свій головний пароль, всі збережені паролі для інтернету і електронної пошти, дані форм, особисті сертифікати і закриті ключі будуть втрачені. Ви дійсно хочете скинути свій головний пароль?

reset-primary-password-text = Якщо ви скинете свій головний пароль, всі збережені паролі для мережі та електронної пошти, особисті сертифікати та приватні ключі буде втрачено. Ви справді хочете скинути свій головний пароль?

pippki-reset-password-confirmation-title = Скинути головний пароль
pippki-reset-password-confirmation-message = Ваш головний пароль скинуто.

## Downloading cert dialog

download-cert-window =
    .title = Завантаження сертифіката
    .style = width: 46em
download-cert-message = Вас просять довіряти новому центру сертифікації (CA).
download-cert-trust-ssl =
    .label = Довіряти при ідентифікації вебсайтів.
download-cert-trust-email =
    .label = Довіряти при ідентифікації користувачів електронної пошти.
download-cert-message-desc = Перед тим, як визначитися з довірою до цього центру, рекомендується перевірити його сертифікат, політику і процедури (якщо можливо).
download-cert-view-cert =
    .label = Перегляд
download-cert-view-text = Перевірити сертифікат центру

## Client Authorization Ask dialog

client-auth-window =
    .title = Запит ідентифікації користувача
client-auth-site-description = Сайт питає, з яким сертифікатом вас асоціювати:
client-auth-choose-cert = Виберіть сертифікат для ідентифікації:
client-auth-cert-details = Подробиці про вибраний сертифікат:

## Set password (p12) dialog

set-password-window =
    .title = Вибір пароля резервної копії сертифіката
set-password-message = Пароль резервної копії сертифіката, який ви вкажете тут, захистить файл нової резервної копії. Для продовження резервного копіювання ви повинні встановити пароль.
set-password-backup-pw =
    .value = Пароль резервної копії:
set-password-repeat-backup-pw =
    .value = Пароль резервної копії (ще раз):
set-password-reminder = Увага: якщо ви забудете ваш пароль резервної копії сертифіката, ви не зможете відновити цю резервну копію пізніше. Цю інформацію треба зберігати в безпечному місці.

## Protected Auth dialog

protected-auth-window =
    .title = Захищена автентифікація з використанням токена
protected-auth-msg = Виконайте автентифікацію з використанням токена. Метод автентифікації залежить від типу вашого токена.
protected-auth-token = Жетон:
