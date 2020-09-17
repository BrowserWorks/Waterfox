# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Buďte obozretní
about-config-intro-warning-text = Zmeny v pokročilej konfigurácii môžu ovplyvniť výkon a bezpečnosť aplikácie { -brand-short-name }.
about-config-intro-warning-checkbox = Upozorniť ma, keď sa pokúšam upraviť tieto nastavenia
about-config-intro-warning-button = Rozumiem riziku a chcem pokračovať



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Zmeny môžu ovplyvniť výkon a bezpečnosť aplikácie { -brand-short-name }.

about-config-page-title = Rozšírené možnosti

about-config-search-input1 =
    .placeholder = Hľadať
about-config-show-all = Zobraziť všetko

about-config-pref-add-button =
    .title = Pridať
about-config-pref-toggle-button =
    .title = Prepnúť
about-config-pref-edit-button =
    .title = Upraviť
about-config-pref-save-button =
    .title = Uložiť
about-config-pref-reset-button =
    .title = Obnoviť
about-config-pref-delete-button =
    .title = Odstrániť

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Logická hodnota
about-config-pref-add-type-number = Číslo
about-config-pref-add-type-string = Textový reťazec

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (pôvodná)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (upravená)
