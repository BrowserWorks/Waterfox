# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Neue Umgebung hinzufügen
    .style = width: 45em

# Variables
#   $name (String) - Name of the container
containers-window-update-settings =
    .title = Einstellungen für Umgebung "{ $name }"
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

containers-name-label = Name:
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Umgebungsnamen eingeben

containers-icon-label = Symbol:
    .accesskey = S
    .style = { -containers-labels-style }

containers-color-label = Farbe:
    .accesskey = F
    .style = { -containers-labels-style }

containers-dialog =
    .buttonlabelaccept = Fertig
    .buttonaccesskeyaccept = e

containers-color-blue =
    .label = Blau
containers-color-turquoise =
    .label = Türkis
containers-color-green =
    .label = Grün
containers-color-yellow =
    .label = Gelb
containers-color-orange =
    .label = Orange
containers-color-red =
    .label = Rot
containers-color-pink =
    .label = Pink
containers-color-purple =
    .label = Purpur
containers-color-toolbar =
    .label = An Symbolleiste anpassen

containers-icon-fence =
    .label = Zaun
containers-icon-fingerprint =
    .label = Fingerabdruck
containers-icon-briefcase =
    .label = Aktenkoffer
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Dollar-Symbol
containers-icon-cart =
    .label = Einkaufswagen
containers-icon-circle =
    .label = Punkt
containers-icon-vacation =
    .label = Urlaub
containers-icon-gift =
    .label = Geschenk
containers-icon-food =
    .label = Essen
containers-icon-fruit =
    .label = Frucht
containers-icon-pet =
    .label = Haustier
containers-icon-tree =
    .label = Baum
containers-icon-chill =
    .label = Entspannung
