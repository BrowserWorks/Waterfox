# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Apondre un contenidor novèl
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Preferéncias de contenidor { $name }
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
-containers-labels-style = min-width: 4rem

containers-name-label = Nom
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Marcar un nom de contenidor

containers-icon-label = Icòna
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = Color
    .accesskey = C
    .style = { -containers-labels-style }

containers-button-done =
    .label = Acabat
    .accesskey = A

containers-color-blue =
    .label = Blau
containers-color-turquoise =
    .label = Turquesa
containers-color-green =
    .label = Verd
containers-color-yellow =
    .label = Jaune
containers-color-orange =
    .label = Irange
containers-color-red =
    .label = Roge
containers-color-pink =
    .label = Ròse
containers-color-purple =
    .label = Violet
containers-color-toolbar =
    .label = Apariar la barra d’aisinas

containers-icon-fence =
    .label = Barrièra
containers-icon-fingerprint =
    .label = Emprenta digitala
containers-icon-briefcase =
    .label = Maleta
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Signe dolar
containers-icon-cart =
    .label = Carriòt de crompas
containers-icon-circle =
    .label = Punt
containers-icon-vacation =
    .label = Vacanças
containers-icon-gift =
    .label = Present
containers-icon-food =
    .label = Manjar
containers-icon-fruit =
    .label = Frut
containers-icon-pet =
    .label = Animal
containers-icon-tree =
    .label = Arbre
containers-icon-chill =
    .label = Divertiment
