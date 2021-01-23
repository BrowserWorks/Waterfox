# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

config-window =
    .title = about:config

## Strings used to display a warning in about:config

# This text should be attention grabbing and playful
config-about-warning-title =
    .value = Това ще отмени всякакви гаранции за стабилност!
config-about-warning-text = Промяната на някои от тези разширени настройки може да се отрази пагубно върху стабилността, безопасността и производителността на приложението. Продължете, само ако сте сигурни какво правите.
config-about-warning-button =
    .label = Приемам риска!
config-about-warning-checkbox =
    .label = Показване на предупреждението и следващия път

config-search-prefs =
    .value = Търсене:
    .accesskey = с

config-focus-search =
    .key = r

config-focus-search-2 =
    .key = f

## These strings are used for column headers

config-pref-column =
    .label = Име на настройката
config-lock-column =
    .label = Състояние
config-type-column =
    .label = Вид
config-value-column =
    .label = Стойност

## These strings are used for tooltips

config-pref-column-header =
    .tooltip = Натиснете за сортиране
config-column-chooser =
    .tooltip = Изберете колоните, които да се показват

## These strings are used for the context menu

config-copy-pref =
    .key = C
    .label = Копиране
    .accesskey = К

config-copy-name =
    .label = Копиране на името
    .accesskey = и

config-copy-value =
    .label = Копиране на стойността
    .accesskey = с

config-modify =
    .label = Промяна
    .accesskey = м

config-toggle =
    .label = Превключване
    .accesskey = П

config-reset =
    .label = Нулиране
    .accesskey = Н

config-new =
    .label = Нов
    .accesskey = в

config-string =
    .label = Низ
    .accesskey = Н

config-integer =
    .label = Целочислен
    .accesskey = е

config-boolean =
    .label = Булев
    .accesskey = Б

config-default = стандартна
config-modified = променена
config-locked = заключена

config-property-string = низ
config-property-int = целочислена
config-property-bool = булева

config-new-prompt = Въведете име на свойството

config-nan-title = Невалидна стойност
config-nan-text = Въведеният текст не е число.

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-new-title = Нова стойност на { $type }

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-modify-title = Въведете стойност на { $type }
