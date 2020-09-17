# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Продължете с повишено внимание
about-config-intro-warning-text = Промяната на разширените настройки може да повлияе на бързодействието или сигурността на { -brand-short-name }.
about-config-intro-warning-checkbox = Повторно предупреждаване при отваряне на тези настройки
about-config-intro-warning-button = Продължаване въпреки риска



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Промяната на тези настройки може да повлияе на бързодействието или сигурността на { -brand-short-name }.

about-config-page-title = Разширени настройки

about-config-search-input1 =
    .placeholder = Търсене в настройките
about-config-show-all = Показване на всички

about-config-pref-add-button =
    .title = Добавяне
about-config-pref-toggle-button =
    .title = Превключване
about-config-pref-edit-button =
    .title = Променяне
about-config-pref-save-button =
    .title = Запазване
about-config-pref-reset-button =
    .title = Нулиране
about-config-pref-delete-button =
    .title = Изтриване

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Булева
about-config-pref-add-type-number = Цифри
about-config-pref-add-type-string = Низ

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (по подразбиране)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (персонализирано)
