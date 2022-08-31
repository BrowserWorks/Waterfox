# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Prossiga com cautela
about-config-intro-warning-text = Alterar preferências de configuração avançadas pode afetar o desempenho ou a segurança do { -brand-short-name }.
about-config-intro-warning-checkbox = Mostrar este aviso quando eu for acessar essas preferências
about-config-intro-warning-button = Aceitar o risco e continuar

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Alterar essas preferências pode afetar o desempenho ou a segurança do { -brand-short-name }.

about-config-page-title = Preferências avançadas

about-config-search-input1 =
    .placeholder = Pesquisar preferências por nome
about-config-show-all = Mostrar tudo

about-config-show-only-modified = Mostrar apenas preferências modificadas

about-config-pref-add-button =
    .title = Adicionar
about-config-pref-toggle-button =
    .title = Alternar
about-config-pref-edit-button =
    .title = Editar
about-config-pref-save-button =
    .title = Salvar
about-config-pref-reset-button =
    .title = Redefinir
about-config-pref-delete-button =
    .title = Excluir

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Booleano
about-config-pref-add-type-number = Número
about-config-pref-add-type-string = Texto

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (padrão)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (personalizado)
