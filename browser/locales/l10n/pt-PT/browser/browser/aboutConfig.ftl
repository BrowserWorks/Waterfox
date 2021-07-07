# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Prosseguir com cuidado
about-config-intro-warning-text = Alterar as preferências avançadas de configuração pode interferir com o desempenho ou segurança do { -brand-short-name }.
about-config-intro-warning-checkbox = Avisar quando eu tento aceder a estas preferências
about-config-intro-warning-button = Aceitar o risco e continuar



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Alterar estas preferências pode interferir com o desempenho ou segurança do { -brand-short-name }.

about-config-page-title = Preferências avançadas

about-config-search-input1 =
    .placeholder = Procurar pelo nome da preferência
about-config-show-all = Mostrar tudo

about-config-pref-add-button =
    .title = Adicionar
about-config-pref-toggle-button =
    .title = Alternar
about-config-pref-edit-button =
    .title = Editar
about-config-pref-save-button =
    .title = Guardar
about-config-pref-reset-button =
    .title = Repor
about-config-pref-delete-button =
    .title = Apagar

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Booleano
about-config-pref-add-type-number = Número
about-config-pref-add-type-string = String

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (predefinido)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (personalizado)
