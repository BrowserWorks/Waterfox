# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Nowy kontejner pśidaś
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Nastajenja kontejnera { $name }
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

containers-name-label = Mě
    .accesskey = M
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Zapódajśo kontejnerowe mě

containers-icon-label = Symbol
    .accesskey = S
    .style = { -containers-labels-style }

containers-color-label = Barwa
    .accesskey = B
    .style = { -containers-labels-style }

containers-button-done =
    .label = Gótowo
    .accesskey = G

containers-color-blue =
    .label = Módry
containers-color-turquoise =
    .label = Tirkisowy
containers-color-green =
    .label = Zeleny
containers-color-yellow =
    .label = Žołty
containers-color-orange =
    .label = Oranžowy
containers-color-red =
    .label = Cerwjeny
containers-color-pink =
    .label = Pink
containers-color-purple =
    .label = Purpurowy
containers-color-toolbar =
    .label = Symbolowej rědce pśiměriś

containers-icon-fence =
    .label = Płośik
containers-icon-fingerprint =
    .label = Palcowy wótśišć
containers-icon-briefcase =
    .label = Listowka
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Dolarowe znamuško
containers-icon-cart =
    .label = Nakupowański wózyk
containers-icon-circle =
    .label = Dypk
containers-icon-vacation =
    .label = Dowol
containers-icon-gift =
    .label = Dar
containers-icon-food =
    .label = Caroba
containers-icon-fruit =
    .label = Sad
containers-icon-pet =
    .label = Domacne zwěrje
containers-icon-tree =
    .label = Bom
containers-icon-chill =
    .label = Chłodnosć
