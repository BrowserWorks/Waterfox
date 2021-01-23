# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Agissètz amb prudéncia
about-config-intro-warning-text = Cambiar las configuracions avançadas pòt influenciar las performanças o la seguretat de { -brand-short-name }.
about-config-intro-warning-checkbox = M'avertir quand ensagi d'accedir a aquestas configuracions
about-config-intro-warning-button = Prendre lo risc e contunhar

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Modificar aquelas preferéncias pòt damatjar las performanças o l'estabilitat de { -brand-short-name }.

about-config-page-title = Preferéncias avançadas

about-config-search-input1 =
    .placeholder = Recercar un nom de preferéncia
about-config-show-all = O afichar tot

about-config-pref-add-button =
    .title = Apondre
about-config-pref-toggle-button =
    .title = Inversar
about-config-pref-edit-button =
    .title = Modificar
about-config-pref-save-button =
    .title = Enregistrar
about-config-pref-reset-button =
    .title = Reïnicializar
about-config-pref-delete-button =
    .title = Suprimir

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Valor booleana
about-config-pref-add-type-number = Nombre
about-config-pref-add-type-string = Cadena de tèxte

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (per defaut)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (personalizada)
