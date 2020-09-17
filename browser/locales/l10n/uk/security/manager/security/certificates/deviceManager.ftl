# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Менеджер пристроїв
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = Модулі і пристрої захисту

devmgr-header-details =
    .label = Подробиці

devmgr-header-value =
    .label = Значення

devmgr-button-login =
    .label = Почати сеанс
    .accesskey = о

devmgr-button-logout =
    .label = Завершити сеанс
    .accesskey = а

devmgr-button-changepw =
    .label = Змінити пароль
    .accesskey = і

devmgr-button-load =
    .label = Завантажити
    .accesskey = З

devmgr-button-unload =
    .label = Вивантажити
    .accesskey = и

devmgr-button-enable-fips =
    .label = Використовувати FIPS
    .accesskey = F

devmgr-button-disable-fips =
    .label = Вимкнути FIPS
    .accesskey = F

## Strings used for load device

load-device =
    .title = Завантажити драйвер пристрою PKCS#11

load-device-info = Введіть інформацію про модуль, який хочете додати.

load-device-modname =
    .value = Назва модуля
    .accesskey = м

load-device-modname-default =
    .value = Новий модуль PKCS#11

load-device-filename =
    .value = Назва файлу модуля
    .accesskey = в

load-device-browse =
    .label = Перегляд…
    .accesskey = я

## Token Manager

devinfo-status =
    .label = Стан

devinfo-status-disabled =
    .label = Вимкнено

devinfo-status-not-present =
    .label = Відсутній

devinfo-status-uninitialized =
    .label = Не ініціалізовано

devinfo-status-not-logged-in =
    .label = Незареєстрований в системі

devinfo-status-logged-in =
    .label = Зареєстрований в системі

devinfo-status-ready =
    .label = Готовий

devinfo-desc =
    .label = Опис

devinfo-man-id =
    .label = Виробник

devinfo-hwversion =
    .label = Версія HW
devinfo-fwversion =
    .label = Версія FW

devinfo-modname =
    .label = Модуль

devinfo-modpath =
    .label = Шлях

login-failed = Помилка реєстрації в систему

devinfo-label =
    .label = Мітка

devinfo-serialnum =
    .label = Серійний номер

fips-nonempty-password-required = Для роботи в режимі відповідності FIPS потрібно вказати головний пароль для кожного пристрою захисту. Вкажіть ці паролі до перемикання в цей режим.

fips-nonempty-primary-password-required = Для роботи в режимі відповідності FIPS потрібно вказати головний пароль для кожного пристрою захисту. Вкажіть ці паролі до перемикання в цей режим.
unable-to-toggle-fips = Неможливо змінити режим FIPS для пристрою захисту. Рекомендується вийти і перезапустити програму.
load-pk11-module-file-picker-title = Оберіть драйвер пристрою PKCS#11 для завантаження

# Load Module Dialog
load-module-help-empty-module-name =
    .value = Назва модуля не може бути порожньою.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = ‘Root Certs‘ зарезервовано і не може використовуватись для назви модуля.

add-module-failure = Не вдалося додати модуль
del-module-warning = Ви дійсно хочете вилучити цей модуль захисту?
del-module-error = Неможливо вилучити модуль
