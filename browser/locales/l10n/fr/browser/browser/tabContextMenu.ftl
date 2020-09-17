# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Actualiser l’onglet
    .accesskey = A
select-all-tabs =
    .label = Sélectionner tous les onglets
    .accesskey = S
duplicate-tab =
    .label = Dupliquer l’onglet
    .accesskey = D
duplicate-tabs =
    .label = Dupliquer les onglets
    .accesskey = D
close-tabs-to-the-end =
    .label = Fermer les onglets situés à droite
    .accesskey = m
close-other-tabs =
    .label = Fermer les autres onglets
    .accesskey = t
reload-tabs =
    .label = Actualiser les onglets
    .accesskey = R
pin-tab =
    .label = Épingler cet onglet
    .accesskey = P
unpin-tab =
    .label = Désépingler cet onglet
    .accesskey = R
pin-selected-tabs =
    .label = Épingler les onglets
    .accesskey = p
unpin-selected-tabs =
    .label = Désépingler les onglets
    .accesskey = R
bookmark-selected-tabs =
    .label = Marquer ces onglets…
    .accesskey = u
bookmark-tab =
    .label = Ajouter l’onglet aux marque-pages
    .accesskey = M
reopen-in-container =
    .label = Rouvrir dans un onglet contextuel
    .accesskey = O
move-to-start =
    .label = Déplacer vers le début
    .accesskey = S
move-to-end =
    .label = Déplacer vers la fin
    .accesskey = E
move-to-new-window =
    .label = Déplacer vers une nouvelle fenêtre
    .accesskey = n
tab-context-close-multiple-tabs =
    .label = Fermer plusieurs onglets
    .accesskey = l

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [one] Annuler la fermeture de l’onglet
           *[other] Annuler la fermeture des onglets
        }
    .accesskey = n
close-tab =
    .label = Fermer l’onglet
    .accesskey = F
close-tabs =
    .label = Fermer les onglets
    .accesskey = S
move-tabs =
    .label = Déplacer les onglets
    .accesskey = D
move-tab =
    .label = Déplacer l’onglet
    .accesskey = D
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Fermer l’onglet
           *[other] Fermer les onglets
        }
    .accesskey = F
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Déplacer l’onglet
           *[other] Déplacer les onglets
        }
    .accesskey = c
