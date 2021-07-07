# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tab-context-new-tab =
    .label = Nouvel onglet
    .accesskey = N
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
# The following string is displayed on a menuitem that will close the tabs from the start of the tabstrip to the currently targeted tab (excluding the currently targeted and any other selected tabs).
# In left-to-right languages this should use "Left" and in right-to-left languages this should use "Right".
close-tabs-to-the-start =
    .label = Fermer les onglets sur la gauche
    .accesskey = l
# The following string is displayed on a menuitem that will close the tabs from the end of the tabstrip to the currently targeted tab (excluding the currently targeted and any other selected tabs).
# In left-to-right languages this should use "Right" and in right-to-left languages this should use "Left".
close-tabs-to-the-end =
    .label = Fermer les onglets sur la droite
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
tab-context-open-in-new-container-tab =
    .label = Ouvrir dans un nouvel onglet conteneur
    .accesskey = e
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
tab-context-share-url =
    .label = Partager
    .accesskey = P
tab-context-share-more =
    .label = Plus…

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-reopen-closed-tabs =
    .label =
        { $tabCount ->
            [1] Rouvrir l’onglet fermé
            [one] Rouvrir l’onglet fermé
           *[other] Rouvrir les onglets fermés
        }
    .accesskey = o
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Fermer l’onglet
           *[other] Fermer les onglets
        }
    .accesskey = F
tab-context-close-n-tabs =
    .label =
        { $tabCount ->
            [1] Fermer l’onglet
            [one] Fermer l’onglet
           *[other] Fermer { $tabCount } onglets
        }
    .accesskey = F
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Déplacer l’onglet
           *[other] Déplacer les onglets
        }
    .accesskey = c

tab-context-send-tabs-to-device =
    .label =
        { $tabCount ->
            [one] Envoyer l’onglet à un appareil
           *[other] Envoyer { $tabCount } onglets à un appareil
        }
    .accesskey = v
