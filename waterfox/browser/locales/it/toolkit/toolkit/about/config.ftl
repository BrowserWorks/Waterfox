# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Procedere con cautela
about-config-intro-warning-text = La modifica delle impostazioni avanzate di configurazione può compromettere le prestazioni e la sicurezza di { -brand-short-name }.
about-config-intro-warning-checkbox = Mostra questo avviso quando si accede a queste preferenze
about-config-intro-warning-button = Accetta il rischio e continua

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = La modifica di queste impostazioni può compromettere le prestazioni e la sicurezza di { -brand-short-name }.

about-config-page-title = Impostazioni avanzate

about-config-search-input1 =
    .placeholder = Cerca nome preferenza
about-config-show-all = Visualizza tutto

about-config-show-only-modified = Visualizza solo preferenze modificate

about-config-pref-add-button =
    .title = Aggiungi
about-config-pref-toggle-button =
    .title = Cambia
about-config-pref-edit-button =
    .title = Modifica
about-config-pref-save-button =
    .title = Salva
about-config-pref-reset-button =
    .title = Ripristina
about-config-pref-delete-button =
    .title = Elimina

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Booleano
about-config-pref-add-type-number = Numero
about-config-pref-add-type-string = Stringa

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (predefinito)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (personalizzato)
