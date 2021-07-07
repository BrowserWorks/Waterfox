# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Продолжайте с осторожностью
about-config-intro-warning-text = Изменение расширенных настроек может затронуть производительность или безопасность { -brand-short-name }.
about-config-intro-warning-checkbox = Предупреждать меня, когда я попытаюсь получить доступ к этим настройкам
about-config-intro-warning-button = Принять риск и продолжить

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Изменение этих настроек может затронуть производительность или безопасность { -brand-short-name }.
about-config-page-title = Расширенные настройки
about-config-search-input1 =
    .placeholder = Искать параметр по имени
about-config-show-all = Показать все
about-config-show-only-modified = Показывать только изменённые параметры
about-config-pref-add-button =
    .title = Добавить
about-config-pref-toggle-button =
    .title = Переключить
about-config-pref-edit-button =
    .title = Изменить
about-config-pref-save-button =
    .title = Сохранить
about-config-pref-reset-button =
    .title = Сбросить
about-config-pref-delete-button =
    .title = Удалить

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Логическое
about-config-pref-add-type-number = Число
about-config-pref-add-type-string = Строка

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (по умолчанию)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (изменено пользователем)
