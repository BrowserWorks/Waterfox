# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Ves con cuenta!
about-config-intro-warning-text = Lo cambio d'as preferencia de configuración abanzadas puede afectar a lo rendimiento u la seguranza de { -brand-short-name }.
about-config-intro-warning-checkbox = Avisar-me cuan yo mire d'acceder a estas preferencias
about-config-intro-warning-button = Acceptar lo risgo y continar

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Lo cambio d'esta preferencia puede afectar a lo rendimiento u la seguranza de { -brand-short-name }.
about-config-page-title = Preferencias Abanzadas
about-config-search-input1 =
    .placeholder = Buscar por o nombre de preferencia
about-config-show-all = Amostrar-lo tot
about-config-pref-add-button =
    .title = Anyadir
about-config-pref-toggle-button =
    .title = Commutar
about-config-pref-edit-button =
    .title = Editar
about-config-pref-save-button =
    .title = Alzar
about-config-pref-reset-button =
    .title = Reiniciar
about-config-pref-delete-button =
    .title = Borrar

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Booleano
about-config-pref-add-type-number = Numero
about-config-pref-add-type-string = Cadena

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (per defecto)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (personalizau)
