# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Shtoni Kontejner të Ri
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Parapëlqime Kontejneri { $name }
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

containers-name-label = Emër
    .accesskey = E
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Jepni emër kontejneri

containers-icon-label = Ikonë
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = Ngjyrë
    .accesskey = N
    .style = { -containers-labels-style }

containers-button-done =
    .label = U bë
    .accesskey = U

containers-color-blue =
    .label = Blu
containers-color-turquoise =
    .label = E bruztë
containers-color-green =
    .label = E gjelbër
containers-color-yellow =
    .label = E verdhë
containers-color-orange =
    .label = Portokalli
containers-color-red =
    .label = E kuqe
containers-color-pink =
    .label = Rozë
containers-color-purple =
    .label = E purpur
containers-color-toolbar =
    .label = Përputhe me panelin

containers-icon-fingerprint =
    .label = Shenja gishtash
containers-icon-briefcase =
    .label = Dosje
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Simboli i dollarit
containers-icon-cart =
    .label = Shportë blerjesh
containers-icon-circle =
    .label = Pikë
containers-icon-vacation =
    .label = Pushime
containers-icon-gift =
    .label = Dhuratë
containers-icon-food =
    .label = Ushqim
containers-icon-fruit =
    .label = Fruta
containers-icon-pet =
    .label = Pet
containers-icon-tree =
    .label = Pemë
containers-icon-chill =
    .label = Chill
