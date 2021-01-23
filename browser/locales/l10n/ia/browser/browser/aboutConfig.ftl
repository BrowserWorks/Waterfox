# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Proceder con cautela
about-config-intro-warning-text = Cambiar preferentias de configuration avantiate pote haber impacto sur le prestationes e le securitate de { -brand-short-name }.
about-config-intro-warning-checkbox = Avisar me quando io tenta de acceder a iste preferentias
about-config-intro-warning-button = Acceptar le risco e continuar



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Cambiar iste preferentias pote haber impacto sur le prestationes e le securitate de { -brand-short-name }.

about-config-page-title = Preferentias avantiate

about-config-search-input1 =
    .placeholder = Cercar nomine de preferentia
about-config-show-all = Monstrar toto

about-config-pref-add-button =
    .title = Adder
about-config-pref-toggle-button =
    .title = Commutar
about-config-pref-edit-button =
    .title = Modificar
about-config-pref-save-button =
    .title = Salvar
about-config-pref-reset-button =
    .title = Reinitialisar
about-config-pref-delete-button =
    .title = Deler

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Booleano
about-config-pref-add-type-number = Numero
about-config-pref-add-type-string = Catena

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (predefinite)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (personalisate)
