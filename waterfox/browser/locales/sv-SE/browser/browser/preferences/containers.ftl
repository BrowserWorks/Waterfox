# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Lägg till ny behållare
    .style = width: 45em

# Variables
#   $name (String) - Name of the container
containers-window-update-settings =
    .title = Behållarinställningar för { $name }
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

containers-name-label = Namn
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Ange ett behållarnamn

containers-icon-label = Ikon
    .accesskey = k
    .style = { -containers-labels-style }

containers-color-label = Färg
    .accesskey = F
    .style = { -containers-labels-style }

containers-dialog =
    .buttonlabelaccept = Klar
    .buttonaccesskeyaccept = K

containers-color-blue =
    .label = Blå
containers-color-turquoise =
    .label = Turkos
containers-color-green =
    .label = Grön
containers-color-yellow =
    .label = Gul
containers-color-orange =
    .label = Orange
containers-color-red =
    .label = Röd
containers-color-pink =
    .label = Rosa
containers-color-purple =
    .label = Lila
containers-color-toolbar =
    .label = Färgverktygsfält

containers-icon-fence =
    .label = Staket
containers-icon-fingerprint =
    .label = Fingeravtryck
containers-icon-briefcase =
    .label = Portfölj
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Dollartecken
containers-icon-cart =
    .label = Varukorg
containers-icon-circle =
    .label = Punkt
containers-icon-vacation =
    .label = Semester
containers-icon-gift =
    .label = Present
containers-icon-food =
    .label = Livsmedel
containers-icon-fruit =
    .label = Frukt
containers-icon-pet =
    .label = Husdjur
containers-icon-tree =
    .label = Träd
containers-icon-chill =
    .label = Relax
