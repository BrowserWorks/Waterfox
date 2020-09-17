# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = Менаџер уређаја
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = Безбедносни модули и уређаји

devmgr-header-details =
    .label = Детаљи

devmgr-header-value =
    .label = Вредност

devmgr-button-login =
    .label = Пријава
    .accesskey = П

devmgr-button-logout =
    .label = Одјава
    .accesskey = О

devmgr-button-changepw =
    .label = Промена лозинке
    .accesskey = л

devmgr-button-load =
    .label = Учитај
    .accesskey = ч

devmgr-button-unload =
    .label = Уклони
    .accesskey = к

devmgr-button-enable-fips =
    .label = Омогући FIPS
    .accesskey = г

devmgr-button-disable-fips =
    .label = Онемогући FIPS
    .accesskey = г

## Strings used for load device

load-device =
    .title = Учитај драјвер PKCS#11 уређаја

load-device-info = Унесите податке о модулу који желите да додате.

load-device-modname =
    .value = Име модула
    .accesskey = И

load-device-modname-default =
    .value = Нови модул PKCS#11

load-device-filename =
    .value = Назив модула
    .accesskey = Н

load-device-browse =
    .label = Преглед…
    .accesskey = П

## Token Manager

devinfo-status =
    .label = Стање

devinfo-status-disabled =
    .label = Искључен

devinfo-status-not-present =
    .label = Не постоји

devinfo-status-uninitialized =
    .label = Није покренут

devinfo-status-not-logged-in =
    .label = Није пријављен

devinfo-status-logged-in =
    .label = Пријављен

devinfo-status-ready =
    .label = Крај

devinfo-desc =
    .label = Опис

devinfo-man-id =
    .label = Произвођач

devinfo-hwversion =
    .label = Верзија HW
devinfo-fwversion =
    .label = Верзија FW

devinfo-modname =
    .label = Модул

devinfo-modpath =
    .label = Путања

login-failed = Грешка при пријави на систем

devinfo-label =
    .label = Ознака

devinfo-serialnum =
    .label = Серијски број

fips-nonempty-password-required = За рад у режиму одговарања FIPS неопходно је унети главну лозинку за сваку врсту заштите. Подесите главну лозинке пре преласка у дати режим.

unable-to-toggle-fips = Није могуће променити FIPS начин за безбедносни уређај. Препоручљиво је да изађете и поново покренете апликацију.
load-pk11-module-file-picker-title = Изаберите драјвер PKCS#11 уређаја за учитавање

# Load Module Dialog
load-module-help-empty-module-name =
    .value = Име модуле не може бити празно

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = ‘Root Certs‘ је резервисано и не може се искористити као име модула.

add-module-failure = Немогуће је додати модул
del-module-warning = Да ли заиста желите да уклоните овај модул заштите?
del-module-error = Неуспешно брисање модула
