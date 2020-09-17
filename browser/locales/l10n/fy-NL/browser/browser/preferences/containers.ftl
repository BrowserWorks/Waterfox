# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Nije kontener tafoegje
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = { $name } kontenerfoarkarren
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

containers-name-label = Namme
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Kontenernamme ynfiere

containers-icon-label = Piktogram
    .accesskey = P
    .style = { -containers-labels-style }

containers-color-label = Kleur
    .accesskey = e
    .style = { -containers-labels-style }

containers-button-done =
    .label = Dien
    .accesskey = D

containers-color-blue =
    .label = Blau
containers-color-turquoise =
    .label = Turkoaisk
containers-color-green =
    .label = Grien
containers-color-yellow =
    .label = Giel
containers-color-orange =
    .label = Oranje
containers-color-red =
    .label = Read
containers-color-pink =
    .label = Roze
containers-color-purple =
    .label = Pears
containers-color-toolbar =
    .label = Mei de arkbalke oerien komme litte

containers-icon-fence =
    .label = Stek
containers-icon-fingerprint =
    .label = Fingerôfdruk
containers-icon-briefcase =
    .label = Sammeling
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Dollar-teken
containers-icon-cart =
    .label = Winkelwein
containers-icon-circle =
    .label = Punt
containers-icon-vacation =
    .label = Fakânsje
containers-icon-gift =
    .label = Kado
containers-icon-food =
    .label = Iten
containers-icon-fruit =
    .label = Fruit
containers-icon-pet =
    .label = Húsdier
containers-icon-tree =
    .label = Beam
containers-icon-chill =
    .label = Ferdivedaasje
