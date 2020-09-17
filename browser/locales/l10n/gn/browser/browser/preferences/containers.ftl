# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Embojuaju guerekoha pyahu
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = { $name } Guerekoha jeguerohoryvéva
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

containers-name-label = Téra
    .accesskey = T
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Emoinge guerekoha réra

containers-icon-label = Ta’ãngachu’i
    .accesskey = T
    .style = { -containers-labels-style }

containers-color-label = Sa’y
    .accesskey = o
    .style = { -containers-labels-style }

containers-button-done =
    .label = Apopyre
    .accesskey = A

containers-color-blue =
    .label = Hovy
containers-color-turquoise =
    .label = Turquesa
containers-color-green =
    .label = Hovyũ
containers-color-yellow =
    .label = Sa’yju
containers-color-orange =
    .label = Naraha
containers-color-red =
    .label = Ñanduti
containers-color-pink =
    .label = Pytãngy
containers-color-purple =
    .label = Pytãũ
containers-color-toolbar =
    .label = Embojoja tembipuru renda

containers-icon-fence =
    .label = Korajere
containers-icon-fingerprint =
    .label = Kuã rapykuere
containers-icon-briefcase =
    .label = Kuatiaryru
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Dólar reheguaite
containers-icon-cart =
    .label = Mba’yruguata’i jejoguaha
containers-icon-circle =
    .label = Kyta
containers-icon-vacation =
    .label = Pytu’upuku
containers-icon-gift =
    .label = Jopói
containers-icon-food =
    .label = Tembi’u
containers-icon-fruit =
    .label = Yva
containers-icon-pet =
    .label = Mymba
containers-icon-tree =
    .label = Yvyra
containers-icon-chill =
    .label = To’ysã
