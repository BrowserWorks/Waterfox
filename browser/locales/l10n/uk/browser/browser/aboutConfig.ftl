# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Продовжуйте обережно
about-config-intro-warning-text = Зміна розширених налаштувань може вплинути на швидкодію і безпеку { -brand-short-name }.
about-config-intro-warning-checkbox = Попереджати мене, коли я намагаюся отримати доступ до цих налаштувань
about-config-intro-warning-button = Погодитись на ризик і продовжити



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Зміна цих налаштувань може вплинути на швидкодію чи безпеку { -brand-short-name }.

about-config-page-title = Розширені налаштування

about-config-search-input1 =
    .placeholder = Шукати параметр за назвою
about-config-show-all = Показати все

about-config-pref-add-button =
    .title = Додати
about-config-pref-toggle-button =
    .title = Перемкнути
about-config-pref-edit-button =
    .title = Змінити
about-config-pref-save-button =
    .title = Зберегти
about-config-pref-reset-button =
    .title = Скинути
about-config-pref-delete-button =
    .title = Видалити

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Логічне
about-config-pref-add-type-number = Число
about-config-pref-add-type-string = Рядок

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (типово)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (власне)
