# This Source Code Form is subject to the terms of the Mozilla Public
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
