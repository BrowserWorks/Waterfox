# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Aldoni novan ingon
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Preferoj por ingoj de { $name }
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

containers-name-label = Nomo
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Tajpu nomon de ingo

containers-icon-label = Emblemo
    .accesskey = E
    .style = { -containers-labels-style }

containers-color-label = Koloro
    .accesskey = K
    .style = { -containers-labels-style }

containers-button-done =
    .label = Farita
    .accesskey = F

containers-color-blue =
    .label = Blua
containers-color-turquoise =
    .label = Turkisa
containers-color-green =
    .label = Verda
containers-color-yellow =
    .label = Flava
containers-color-orange =
    .label = Oranĝa
containers-color-red =
    .label = Ruĝa
containers-color-pink =
    .label = Roza
containers-color-purple =
    .label = Purpura
containers-color-toolbar =
    .label = Kongruigi kun ilaro

containers-icon-fence =
    .label = Ĉirkaŭbarilo
containers-icon-fingerprint =
    .label = Fingrospuro
containers-icon-briefcase =
    .label = Teko
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Dolarsimbolo
containers-icon-cart =
    .label = Aĉetĉareto
containers-icon-circle =
    .label = Punkto
containers-icon-vacation =
    .label = Ferioj
containers-icon-gift =
    .label = Donaco
containers-icon-food =
    .label = Manĝaĵo
containers-icon-fruit =
    .label = Frukto
containers-icon-pet =
    .label = Hejmbesto
containers-icon-tree =
    .label = Arbo
containers-icon-chill =
    .label = Malstreĉo
