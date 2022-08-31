# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Tilføj ny kontekst
    .style = width: 33em

# Variables
#   $name (String) - Name of the container
containers-window-update-settings =
    .title = Indstillinger for konteksten { $name }
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

containers-name-label = Navn
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Indtast et navn til konteksten

containers-icon-label = Ikon
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = Farve
    .accesskey = a
    .style = { -containers-labels-style }

containers-dialog =
    .buttonlabelaccept = Færdig
    .buttonaccesskeyaccept = F

containers-color-blue =
    .label = Blå
containers-color-turquoise =
    .label = Tyrkis
containers-color-green =
    .label = Grøn
containers-color-yellow =
    .label = Gul
containers-color-orange =
    .label = Orange
containers-color-red =
    .label = Rød
containers-color-pink =
    .label = Pink
containers-color-purple =
    .label = Lilla
containers-color-toolbar =
    .label = Match værktøjslinje

containers-icon-fence =
    .label = Hegn
containers-icon-fingerprint =
    .label = Fingeraftryk
containers-icon-briefcase =
    .label = Attachemappe
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Dollartegn
containers-icon-cart =
    .label = Indkøbsvogn
containers-icon-circle =
    .label = Prik
containers-icon-vacation =
    .label = Ferie
containers-icon-gift =
    .label = Gaver
containers-icon-food =
    .label = Mad
containers-icon-fruit =
    .label = Frugt
containers-icon-pet =
    .label = Kæledyr
containers-icon-tree =
    .label = Træ
containers-icon-chill =
    .label = Afslapning
