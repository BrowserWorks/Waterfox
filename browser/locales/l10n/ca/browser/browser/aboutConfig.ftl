# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Aneu amb compte.
about-config-intro-warning-text = La modificació de les preferències avançades de configuració pot afectar el rendiment o la seguretat del { -brand-short-name }.
about-config-intro-warning-checkbox = Avisa'm en intentar accedir a aquestes preferències
about-config-intro-warning-button = Accepto el risc i vull continuar



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = La modificació d'aquestes preferències de configuració pot afectar el rendiment o la seguretat del { -brand-short-name }.

about-config-page-title = Preferències avançades

about-config-search-input1 =
    .placeholder = Cerca el nom de la preferència
about-config-show-all = Mostra-ho tot

about-config-pref-add-button =
    .title = Afegeix
about-config-pref-toggle-button =
    .title = Commuta
about-config-pref-edit-button =
    .title = Edita
about-config-pref-save-button =
    .title = Desa
about-config-pref-reset-button =
    .title = Reinicia
about-config-pref-delete-button =
    .title = Suprimeix

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Booleà
about-config-pref-add-type-number = Nombre
about-config-pref-add-type-string = Cadena

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (per defecte)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (personalitzat)
