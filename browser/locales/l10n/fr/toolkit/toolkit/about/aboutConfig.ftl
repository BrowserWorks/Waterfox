# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

config-window =
    .title = about:config

## Strings used to display a warning in about:config

# This text should be attention grabbing and playful
config-about-warning-title =
    .value = Attention, danger !
config-about-warning-text = La modification de ces préférences avancées peut être dommageable pour la stabilité, la sécurité et les performances de cette application. Ne continuez que si vous savez ce que vous faites.
config-about-warning-button =
    .label = Je prends le risque
config-about-warning-checkbox =
    .label = Afficher cet avertissement la prochaine fois

config-search-prefs =
    .value = Rechercher :
    .accesskey = R

config-focus-search =
    .key = r

config-focus-search-2 =
    .key = f

## These strings are used for column headers

config-pref-column =
    .label = Nom de l’option
config-lock-column =
    .label = Statut
config-type-column =
    .label = Type
config-value-column =
    .label = Valeur

## These strings are used for tooltips

config-pref-column-header =
    .tooltip = Trier
config-column-chooser =
    .tooltip = Sélectionner les colonnes à afficher

## These strings are used for the context menu

config-copy-pref =
    .key = C
    .label = Copier
    .accesskey = C

config-copy-name =
    .label = Copier le nom
    .accesskey = o

config-copy-value =
    .label = Copier la valeur
    .accesskey = v

config-modify =
    .label = Modifier
    .accesskey = M

config-toggle =
    .label = Inverser
    .accesskey = I

config-reset =
    .label = Réinitialiser
    .accesskey = R

config-new =
    .label = Nouvelle
    .accesskey = N

config-string =
    .label = Chaîne de caractères
    .accesskey = C

config-integer =
    .label = Nombre entier
    .accesskey = n

config-boolean =
    .label = Valeur booléenne
    .accesskey = b

config-default = par défaut
config-modified = modifié
config-locked = verrouillé

config-property-string = chaîne
config-property-int = nombre entier
config-property-bool = booléen

config-new-prompt = Saisissez le nom de l’option

config-nan-title = Valeur invalide
config-nan-text = Le texte saisi n’est pas un nombre.

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-new-title = Nouvelle valeur (type { $type })

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-modify-title = Saisissez une nouvelle valeur (type { $type })
