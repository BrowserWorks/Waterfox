# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = Информации околу решавање на проблеми
page-subtitle =
    Оваа страна содржи технички информации кои може да Ви послужат кога се
    обидувате да решите некој проблем. Ако барате одговори на често поставувани прашања
    за { -brand-short-name }, појдете на нашиот <a data-l10n-name="support-link">веб сајт за поддршка</a>.

extensions-title = Проширувања
extensions-name = Име
extensions-enabled = Вклучен
extensions-version = Верзија
extensions-id = ID
support-addons-name = Име
support-addons-version = Верзија
support-addons-id = ID
app-basics-title = Основи за апликацијата
app-basics-name = Име
app-basics-version = Верзија
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] Директориум на профилот
       *[other] Папка на профилот
    }
app-basics-enabled-plugins = Овозможени приклучоци
app-basics-build-config = Конфигурација на изданието
app-basics-user-agent = Кориснички агент
app-basics-memory-use = Искористеност на меморија
modified-key-prefs-title = Важни променети параметри
modified-prefs-name = Име
modified-prefs-value = Вредност
user-js-title = Поставки за user.js
user-js-description = Вашата папка за профил содржи <a data-l10n-name="user-js-link">user.js датотека</a>, која што вклучува поставки што не биле создадени од { -brand-short-name }.
graphics-title = Графика
a11y-title = Пристапност
a11y-activated = Активирана
a11y-force-disabled = Сопри пристапност
library-version-title = Верзија на библиотеката
copy-text-to-clipboard-label = Копирај го текстот
copy-raw-data-to-clipboard-label = Копирај ги сировите податоци

## Media titles


##


## Remote Debugging
##
## The Firefox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/


##

raw-data-copied = Сировите податоци се ископирани
text-copied = Текстот е ископиран

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = Блокирано за верзијата на графичкиот драјвер.
blocked-gfx-card = Блокирано за графичката картичка поради нерешени проблеми со драјверот.
blocked-os-version = Блокирано за верзијата на оперативниот систем.
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver =
    Блокирано за верзијата на графичкиот драјвер. Пробајте да го надградите
    на верзија { $driverVersion } или понова.

# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = Параметри за ClearType

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

min-lib-versions = Очекувана минимална верзија
loaded-lib-versions = Верзија во употреба

# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
multi-process-status-4 = Оневозможено од алатките за пристапност

drag-enabled = влечење на лизгач овозможено

## Variables
## $preferenceKey (string) - String ID of preference


## Strings representing the status of the Enterprise Policies engine.

