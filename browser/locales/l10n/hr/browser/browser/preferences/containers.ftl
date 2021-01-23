# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Dodaj novi kontejner
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Postavke kontejnera { $name }
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

containers-name-label = Naziv
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Upiši ime kontejnera

containers-icon-label = Ikona
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = Boja
    .accesskey = o
    .style = { -containers-labels-style }

containers-button-done =
    .label = Gotovo
    .accesskey = G

containers-color-blue =
    .label = Plava
containers-color-turquoise =
    .label = Tirkizna
containers-color-green =
    .label = Zelena
containers-color-yellow =
    .label = Žuta
containers-color-orange =
    .label = Narančasta
containers-color-red =
    .label = Crvena
containers-color-pink =
    .label = Ružičasta
containers-color-purple =
    .label = Ljubičasta
containers-color-toolbar =
    .label = Uskladi s alatnom trakom

containers-icon-fence =
    .label = Ograda
containers-icon-fingerprint =
    .label = Otisak prsta
containers-icon-briefcase =
    .label = Kovčeg
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Dolar znak
containers-icon-cart =
    .label = Kolica za kupnju
containers-icon-circle =
    .label = Točka
containers-icon-vacation =
    .label = Odmor
containers-icon-gift =
    .label = Poklon
containers-icon-food =
    .label = Hrana
containers-icon-fruit =
    .label = Voće
containers-icon-pet =
    .label = Ljubimci
containers-icon-tree =
    .label = Stablo
containers-icon-chill =
    .label = Odmor
