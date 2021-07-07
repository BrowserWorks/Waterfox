# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Nieuwe container toevoegen
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Voorkeuren van container { $name }
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update-settings =
    .title = Instellingen van container { $name }
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
containers-name-label = Naam
    .accesskey = N
    .style = { -containers-labels-style }
containers-name-text =
    .placeholder = Voer een containernaam in
containers-icon-label = Pictogram
    .accesskey = P
    .style = { -containers-labels-style }
containers-color-label = Kleur
    .accesskey = K
    .style = { -containers-labels-style }
containers-button-done =
    .label = Gereed
    .accesskey = G
containers-dialog =
    .buttonlabelaccept = Gereed
    .buttonaccesskeyaccept = G
containers-color-blue =
    .label = Blauw
containers-color-turquoise =
    .label = Turquoise
containers-color-green =
    .label = Groen
containers-color-yellow =
    .label = Geel
containers-color-orange =
    .label = Oranje
containers-color-red =
    .label = Rood
containers-color-pink =
    .label = Roze
containers-color-purple =
    .label = Paars
containers-color-toolbar =
    .label = Met de werkbalk overeen laten komen
containers-icon-fence =
    .label = Hekwerk
containers-icon-fingerprint =
    .label = Vingerafdruk
containers-icon-briefcase =
    .label = Werkmap
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Dollarteken
containers-icon-cart =
    .label = Winkelwagen
containers-icon-circle =
    .label = Stip
containers-icon-vacation =
    .label = Vakantie
containers-icon-gift =
    .label = Cadeau
containers-icon-food =
    .label = Eten
containers-icon-fruit =
    .label = Fruit
containers-icon-pet =
    .label = Huisdier
containers-icon-tree =
    .label = Boom
containers-icon-chill =
    .label = Ontspanning
