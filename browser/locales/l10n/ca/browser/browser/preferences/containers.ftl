# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Afegeix un contenidor nou
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Preferències del contenidor { $name }
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
    .placeholder = Escriviu un nom de contenidor

containers-icon-label = Icona
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = Color
    .accesskey = o
    .style = { -containers-labels-style }

containers-button-done =
    .label = Fet
    .accesskey = F

containers-color-blue =
    .label = Blau
containers-color-turquoise =
    .label = Turquesa
containers-color-green =
    .label = Verd
containers-color-yellow =
    .label = Groc
containers-color-orange =
    .label = Taronja
containers-color-red =
    .label = Vermell
containers-color-pink =
    .label = Rosa
containers-color-purple =
    .label = Porpra
containers-color-toolbar =
    .label = Fes coincidir amb la barra d'eines

containers-icon-fence =
    .label = Tanca
containers-icon-fingerprint =
    .label = Empremta
containers-icon-briefcase =
    .label = Maletí
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Signe de dòlar
containers-icon-cart =
    .label = Carro de la compra
containers-icon-circle =
    .label = Punt
containers-icon-vacation =
    .label = Vacances
containers-icon-gift =
    .label = Regal
containers-icon-food =
    .label = Menjar
containers-icon-fruit =
    .label = Fruita
containers-icon-pet =
    .label = Mascota
containers-icon-tree =
    .label = Arbre
containers-icon-chill =
    .label = Relax
