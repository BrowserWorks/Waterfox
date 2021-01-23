# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Абайлап жалғастырыңыз
about-config-intro-warning-text = Кеңейтілген баптауларды өзгерту { -brand-short-name } өнімділік немесе қауіпсіздігіне әсерін тигізуі мүмкін.
about-config-intro-warning-checkbox = Осы параметрлерді өзгерту кезінде ескертіңіз
about-config-intro-warning-button = Тәуекелді қабылдап, жалғастыру



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Бұл баптауларды өзгерту { -brand-short-name } өнімділік немесе қауіпсіздігіне әсерін тигізуі мүмкін.

about-config-page-title = Кеңейтілген баптаулар

about-config-search-input1 =
    .placeholder = Баптау атынан іздеу
about-config-show-all = Барлығын көрсету

about-config-pref-add-button =
    .title = Қосу
about-config-pref-toggle-button =
    .title = Ауыстыру
about-config-pref-edit-button =
    .title = Түзету
about-config-pref-save-button =
    .title = Сақтау
about-config-pref-reset-button =
    .title = Тастау
about-config-pref-delete-button =
    .title = Өшіру

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Логикалық
about-config-pref-add-type-number = Сан
about-config-pref-add-type-string = Жол

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (бастапқы)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (таңдауыңызша)
