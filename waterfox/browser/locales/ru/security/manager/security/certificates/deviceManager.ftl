# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr-window =
    .title = Управление устройствами
    .style = min-width: 67em; min-height: 32em;

devmgr-devlist =
    .label = Модули и устройства защиты

devmgr-header-details =
    .label = Подробности

devmgr-header-value =
    .label = Значение

devmgr-button-login =
    .label = Начать сеанс
    .accesskey = ч

devmgr-button-logout =
    .label = Закончить сеанс
    .accesskey = о

devmgr-button-changepw =
    .label = Сменить пароль
    .accesskey = а

devmgr-button-load =
    .label = Загрузить
    .accesskey = г

devmgr-button-unload =
    .label = Выгрузить
    .accesskey = ы

devmgr-button-enable-fips =
    .label = Использовать FIPS
    .accesskey = F

devmgr-button-disable-fips =
    .label = Отключить FIPS
    .accesskey = F

## Strings used for load device

load-device =
    .title = Загрузить драйвер устройства PKCS#11

load-device-info = Введите информацию о модуле, который вы хотите добавить.

load-device-modname =
    .value = Имя модуля
    .accesskey = м

load-device-modname-default =
    .value = Новый модуль PKCS#11

load-device-filename =
    .value = Имя файла модуля
    .accesskey = ф

load-device-browse =
    .label = Обзор…
    .accesskey = б

## Token Manager

devinfo-status =
    .label = Состояние

devinfo-status-disabled =
    .label = Отключено

devinfo-status-not-present =
    .label = Не присутствует

devinfo-status-uninitialized =
    .label = Не инициализировано

devinfo-status-not-logged-in =
    .label = Не зарегистрирован в системе

devinfo-status-logged-in =
    .label = Зарегистрирован в системе

devinfo-status-ready =
    .label = Готово

devinfo-desc =
    .label = Описание

devinfo-man-id =
    .label = Изготовитель

devinfo-hwversion =
    .label = Версия HW
devinfo-fwversion =
    .label = Версия FW

devinfo-modname =
    .label = Модуль

devinfo-modpath =
    .label = Путь

login-failed = Ошибка регистрации в системе

devinfo-label =
    .label = Метка

devinfo-serialnum =
    .label = Серийный номер

fips-nonempty-primary-password-required = Для работы в режиме FIPS необходим основной пароль для каждого устройства защиты. Установите этот пароль перед переходом в режим FIPS.
unable-to-toggle-fips = Не удалось сменить режим соответствия FIPS для устройства защиты. Мы рекомендуем вам закрыть и перезапустить это приложение.
load-pk11-module-file-picker-title = Выберите для загрузки драйвер устройства PKCS#11

# Load Module Dialog
load-module-help-empty-module-name =
    .value = Имя модуля не может быть пустым.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = ‘Root Certs‘ зарезервировано и не может использоваться как имя модуля.

add-module-failure = Не удалось добавить модуль
del-module-warning = Вы действительно хотите удалить этот модуль защиты?
del-module-error = Не удалось удалить модуль
