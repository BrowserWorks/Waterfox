# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Continúe con precaución
about-config-intro-warning-text = O cambio de preferencias avanzadas de configuración pode afectar o rendemento ou a seguridade de { -brand-short-name }.
about-config-intro-warning-checkbox = Avíseme cando eu intente acceder a estas preferencias
about-config-intro-warning-button = Aceptar o risco e continuar

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = O cambio destas preferencias pode afectar o rendemento ou a seguridade de { -brand-short-name }.
about-config-page-title = Preferencias avanzadas
about-config-search-input1 =
    .placeholder = Buscar polo nome da preferencia
about-config-show-all = Amosar todo
about-config-pref-add-button =
    .title = Engadir
about-config-pref-toggle-button =
    .title = Alternar
about-config-pref-edit-button =
    .title = Editar
about-config-pref-save-button =
    .title = Gardar
about-config-pref-reset-button =
    .title = Restabelecer
about-config-pref-delete-button =
    .title = Eliminar

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Lóxico
about-config-pref-add-type-number = Número
about-config-pref-add-type-string = Cadea

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (predeterminado)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (personalizado)
