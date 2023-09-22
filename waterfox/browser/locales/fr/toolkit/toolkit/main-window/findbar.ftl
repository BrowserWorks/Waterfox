# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = Trouver la prochaine occurrence de l’expression
findbar-previous =
    .tooltiptext = Trouver l’occurrence précédente de l’expression

findbar-find-button-close =
    .tooltiptext = Fermer la barre de recherche

findbar-highlight-all2 =
    .label = Tout surligner
    .accesskey =
        { PLATFORM() ->
            [macos] T
           *[other] T
        }
    .tooltiptext = Surligner toutes les occurrences de la phrase

findbar-case-sensitive =
    .label = Respecter la casse
    .accesskey = R
    .tooltiptext = Effectuer une recherche en respectant la casse

findbar-match-diacritics =
    .label = Respecter les accents et diacritiques
    .accesskey = s
    .tooltiptext = Effectuer une recherche en respectant les caractères accentués et la cédille (exemple : aucun résultat ne sera trouvé en saisissant « francais » au lieu du mot « français »)

findbar-entire-word =
    .label = Mots entiers
    .accesskey = M
    .tooltiptext = Rechercher seulement les mots entiers

findbar-not-found = Expression non trouvée

findbar-wrapped-to-top = Bas de la page atteint, poursuite au début
findbar-wrapped-to-bottom = Haut de la page atteint, poursuite depuis le bas

findbar-normal-find =
    .placeholder = Rechercher dans la page
findbar-fast-find =
    .placeholder = Recherche rapide
findbar-fast-find-links =
    .placeholder = Recherche rapide (liens seulement)

findbar-case-sensitive-status =
    .value = (Sensible à la casse)
findbar-match-diacritics-status =
    .value = (respect des diacritiques)
findbar-entire-word-status =
    .value = (Mots entiers seulement)

# Variables:
#   $current (Number): Index of the currently selected match
#   $total (Number): Total count of matches
findbar-found-matches =
    .value =
        { $total ->
            [one] Occurrence { $current } sur { $total }
           *[other] Occurrence { $current } sur { $total }
        }

# Variables:
#   $limit (Number): Total count of matches allowed before counting stops
findbar-found-matches-count-limit =
    .value =
        { $limit ->
            [one] Plus d’une occurrence
           *[other] Plus de { $limit } occurrences
        }
