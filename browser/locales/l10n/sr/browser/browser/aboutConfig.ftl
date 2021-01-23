# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Наставите с опрезом
about-config-intro-warning-text = Измена напредних подешавања може деловати на { -brand-short-name } перформансе или безбедност.
about-config-intro-warning-checkbox = Обавести ме када покушам да изменим основна подешавања
about-config-intro-warning-button = Прихватите ризик и наставите

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Измена ових подешавања може деловати на { -brand-short-name } перформансе или безбедност

about-config-page-title = Напредна подешавања

about-config-search-input1 =
    .placeholder = Потражите назив подешавања
about-config-show-all = Прикажи све

about-config-pref-add-button =
    .title = Додај
about-config-pref-toggle-button =
    .title = Промени стање
about-config-pref-edit-button =
    .title = Уреди
about-config-pref-save-button =
    .title = Сачувај
about-config-pref-reset-button =
    .title = Поново постави
about-config-pref-delete-button =
    .title = Обриши

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Булова вредност
about-config-pref-add-type-number = Број
about-config-pref-add-type-string = Ниска

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (подразумевано)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (прилагођено)
