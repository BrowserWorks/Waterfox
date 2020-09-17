# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Управление на устройства
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = Модули за защита и сигурни устройства

devmgr-header-details =
    .label = Подробности

devmgr-header-value =
    .label = Стойност

devmgr-button-login =
    .label = Влизане
    .accesskey = В

devmgr-button-logout =
    .label = Излизане
    .accesskey = И

devmgr-button-changepw =
    .label = Промяна на парола
    .accesskey = П

devmgr-button-load =
    .label = Зареждане
    .accesskey = З

devmgr-button-unload =
    .label = Освобождаване
    .accesskey = О

devmgr-button-enable-fips =
    .label = Включване на FIPS
    .accesskey = F

devmgr-button-disable-fips =
    .label = Изключване на FIPS
    .accesskey = F

## Strings used for load device

load-device =
    .title = Зареждане на драйвер за PKCS#11 устройство

load-device-info = Въведете информация за добавяния модул.

load-device-modname =
    .value = Име на модула
    .accesskey = и

load-device-modname-default =
    .value = Нов модул на PKCS#11

load-device-filename =
    .value = Файл на модула
    .accesskey = ф

load-device-browse =
    .label = Разглеждане…
    .accesskey = Р

## Token Manager

devinfo-status =
    .label = Състояние

devinfo-status-disabled =
    .label = Изключен

devinfo-status-not-present =
    .label = Липсва

devinfo-status-uninitialized =
    .label = Нестартиран

devinfo-status-not-logged-in =
    .label = Не е включен

devinfo-status-logged-in =
    .label = Включен

devinfo-status-ready =
    .label = Готов

devinfo-desc =
    .label = Описание

devinfo-man-id =
    .label = Производител

devinfo-hwversion =
    .label = Версия на HW
devinfo-fwversion =
    .label = Версия на FW

devinfo-modname =
    .label = Модул

devinfo-modpath =
    .label = Път

login-failed = Неуспешно влизане

devinfo-label =
    .label = Етикет

devinfo-serialnum =
    .label = Сериен номер

fips-nonempty-password-required = Режимът FIPS изисква да имате поставена главна парола за всяко сигурно устройство. Моля, поставете паролата преди да включите режима FIPS.

unable-to-toggle-fips = Невъзможно е да се промени режима FIPS за сигурността на устройството. Препоръчва се да излезете и да рестартирате това приложение.
load-pk11-module-file-picker-title = Изберете драйвер за PKCS#11 устройството

# Load Module Dialog
load-module-help-empty-module-name =
    .value = Името на модула не може да е празно.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = Името „Root Certs“ е запазено и не може да бъде използвано за име на модул.

add-module-failure = Добавяне на модул е невъзможно
del-module-warning = Сигурни ли сте, че желаете да изтриете този модул за защита?
del-module-error = Грешка при изтриване на модула
