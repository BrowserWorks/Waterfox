# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Continuar con precaución
about-config-intro-warning-text = Cambiar las preferencias de configuración avanzada puede afectar el rendimiento o la seguridad de { -brand-short-name }.
about-config-intro-warning-checkbox = Avisarme cuando intento acceder a estas preferencias
about-config-intro-warning-button = Aceptar el riesgo y continuar



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Cambiar estas preferencias puede afectar el rendimiento o la seguridad de { -brand-short-name }.

about-config-page-title = Preferencias avanzadas

about-config-search-input1 =
    .placeholder = Nombre de preferencia de búsqueda
about-config-show-all = Mostrar todo

about-config-pref-add-button =
    .title = Añadir
about-config-pref-toggle-button =
    .title = Alternar
about-config-pref-edit-button =
    .title = Editar
about-config-pref-save-button =
    .title = Guardar
about-config-pref-reset-button =
    .title = Restablecer
about-config-pref-delete-button =
    .title = Eliminar

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Booleano
about-config-pref-add-type-number = Número
about-config-pref-add-type-string = Cadena

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
