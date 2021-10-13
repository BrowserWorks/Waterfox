# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Ajouter un nouveau conteneur
    .style = width: 45em

# Variables
#   $name (String) - Name of the container
containers-window-update-settings =
    .title = Paramètres du conteneur « { $name } »
    .style = width: 45em

containers-window-close =
    .key = w

# This is a term to store style to be applied
# on the three labels in the containers add/edit dialog:
#   - name
#   - icon
#   - color
#
# Using this term and referencing it in the `.style` attribute
# of the three messages ensures that all three labels
# will be aligned correctly.
-containers-labels-style = min-width: 6rem

containers-name-label = Nom
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Saisir un nom de conteneur

containers-icon-label = Icône
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = Couleur
    .accesskey = o
    .style = { -containers-labels-style }

containers-dialog =
    .buttonlabelaccept = Terminer
    .buttonaccesskeyaccept = T

containers-color-blue =
    .label = Bleu
containers-color-turquoise =
    .label = Turquoise
containers-color-green =
    .label = Vert
containers-color-yellow =
    .label = Jaune
containers-color-orange =
    .label = Orange
containers-color-red =
    .label = Rouge
containers-color-pink =
    .label = Rose
containers-color-purple =
    .label = Violet
containers-color-toolbar =
    .label = Assortie à la barre d’outils

containers-icon-fence =
    .label = Barrière
containers-icon-fingerprint =
    .label = Empreinte digitale
containers-icon-briefcase =
    .label = Mallette
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Signe dollar
containers-icon-cart =
    .label = Charriot
containers-icon-circle =
    .label = Point
containers-icon-vacation =
    .label = Vacances
containers-icon-gift =
    .label = Cadeau
containers-icon-food =
    .label = Nourriture
containers-icon-fruit =
    .label = Fruit
containers-icon-pet =
    .label = Animal
containers-icon-tree =
    .label = Arbre
containers-icon-chill =
    .label = Détente
