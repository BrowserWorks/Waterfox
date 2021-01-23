# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Magdagdag ng Bagong Container
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = { $name } Container Preferences
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

containers-name-label = Pangalan
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Magbigay ng pangalan ng container

containers-icon-label = Icon
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = Kulay
    .accesskey = o
    .style = { -containers-labels-style }

containers-button-done =
    .label = Tapusin
    .accesskey = D

containers-color-blue =
    .label = Asul
containers-color-turquoise =
    .label = Turkesa
containers-color-green =
    .label = Berde
containers-color-yellow =
    .label = Dilaw
containers-color-orange =
    .label = Kahel
containers-color-red =
    .label = Pula
containers-color-pink =
    .label = Pink
containers-color-purple =
    .label = Lila
containers-color-toolbar =
    .label = Itugma ang toolbar

containers-icon-fence =
    .label = Bakod
containers-icon-fingerprint =
    .label = Tatak ng daliri
containers-icon-briefcase =
    .label = Lalagyan
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Simbolo ng dolyar
containers-icon-cart =
    .label = Shopping cart
containers-icon-circle =
    .label = Tuldok
containers-icon-vacation =
    .label = Bakasyon
containers-icon-gift =
    .label = Regalo
containers-icon-food =
    .label = Pagkain
containers-icon-fruit =
    .label = Prutas
containers-icon-pet =
    .label = Alagang Hayop
containers-icon-tree =
    .label = Puno
containers-icon-chill =
    .label = Palamig
