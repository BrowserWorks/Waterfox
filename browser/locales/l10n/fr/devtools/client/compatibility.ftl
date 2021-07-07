# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = Élément sélectionné
compatibility-all-elements-header = Tous les problèmes

## Message used as labels for the type of issue

compatibility-issue-deprecated = (obsolète)
compatibility-issue-experimental = (expérimental)
compatibility-issue-prefixneeded = (préfixe nécessaire)
compatibility-issue-deprecated-experimental = (obsolète, expérimental)

compatibility-issue-deprecated-prefixneeded = (obsolète, préfixe nécessaire)
compatibility-issue-experimental-prefixneeded = (expérimental, préfixe nécessaire)
compatibility-issue-deprecated-experimental-prefixneeded = (obsolète, expérimental, préfixe nécessaire)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = Paramètres
compatibility-settings-button-title =
    .title = Paramètres
compatibility-feedback-button-label = Réagir
compatibility-feedback-button-title =
    .title = Réagir

## Messages used as headers in settings pane

compatibility-settings-header = Paramètres
compatibility-target-browsers-header = Navigateurs cibles

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
        [one] { $number } occurrence
       *[other] { $number } occurrences
    }

compatibility-no-issues-found = Aucun problème de compatibilité trouvé.
compatibility-close-settings-button =
    .title = Fermer les paramètres
