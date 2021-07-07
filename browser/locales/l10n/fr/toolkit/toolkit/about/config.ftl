# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Agissez avec précaution
about-config-intro-warning-text = Modifier les préférences de configuration avancées peut affecter les performances et la sécurité de { -brand-short-name }.
about-config-intro-warning-checkbox = M’avertir lorsque j’essaie d’accéder à ces préférences
about-config-intro-warning-button = Accepter le risque et poursuivre

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Modifier ces préférences peut affecter les performances et la sécurité de { -brand-short-name }.
about-config-page-title = Préférences avancées
about-config-search-input1 =
    .placeholder = Rechercher un nom de préférence
about-config-show-all = Tout afficher
about-config-show-only-modified = Afficher uniquement les préférences modifiées
about-config-pref-add-button =
    .title = Ajouter
about-config-pref-toggle-button =
    .title = Inverser
about-config-pref-edit-button =
    .title = Modifier
about-config-pref-save-button =
    .title = Enregistrer
about-config-pref-reset-button =
    .title = Réinitialiser
about-config-pref-delete-button =
    .title = Supprimer

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Booléen
about-config-pref-add-type-number = Nombre
about-config-pref-add-type-string = Chaîne

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (par défaut)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (personnalisée)
