# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Pridėti naują sudėtinį rodinį
    .style = width: 45em

# Variables
#   $name (String) - Name of the container
containers-window-update-settings =
    .title = Sudėtinio rodinio „{ $name }“ nuostatos
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

containers-name-label = Pavadinimas
    .accesskey = P
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Įveskite sudėtinio rodinio pavadinimą

containers-icon-label = Piktograma
    .accesskey = i
    .style = { -containers-labels-style }

containers-color-label = Spalva
    .accesskey = v
    .style = { -containers-labels-style }

containers-dialog =
    .buttonlabelaccept = Atlikta
    .buttonaccesskeyaccept = A

containers-color-blue =
    .label = Mėlyna
containers-color-turquoise =
    .label = Žydra
containers-color-green =
    .label = Žalia
containers-color-yellow =
    .label = Geltona
containers-color-orange =
    .label = Oranžinė
containers-color-red =
    .label = Raudona
containers-color-pink =
    .label = Rožinė
containers-color-purple =
    .label = Purpurinė
containers-color-toolbar =
    .label = Kaip priemonių juostos

containers-icon-fence =
    .label = Tvora
containers-icon-fingerprint =
    .label = Piršto atspaudas
containers-icon-briefcase =
    .label = Portfelis
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Dolerio ženklas
containers-icon-cart =
    .label = Pirkinių vežimėlis
containers-icon-circle =
    .label = Taškas
containers-icon-vacation =
    .label = Atostogos
containers-icon-gift =
    .label = Dovana
containers-icon-food =
    .label = Maistas
containers-icon-fruit =
    .label = Vaisius
containers-icon-pet =
    .label = Naminis gyvūnas
containers-icon-tree =
    .label = Medis
containers-icon-chill =
    .label = Poilsis
