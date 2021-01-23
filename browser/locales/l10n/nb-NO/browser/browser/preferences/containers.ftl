# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Legg til ny beholder
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Beholderinstillinger for { $name }
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
    .placeholder = Oppgi et beholdernavn

containers-icon-label = Ikon
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = Farge
    .accesskey = a
    .style = { -containers-labels-style }

containers-button-done =
    .label = Ferdig
    .accesskey = d

containers-color-blue =
    .label = Blå
containers-color-turquoise =
    .label = Turkis
containers-color-green =
    .label = Grønn
containers-color-yellow =
    .label = Gul
containers-color-orange =
    .label = Oransje
containers-color-red =
    .label = Rød
containers-color-pink =
    .label = Rosa
containers-color-purple =
    .label = Lilla
containers-color-toolbar =
    .label = Samsvar med verktøylinjen

containers-icon-fence =
    .label = Gjerde
containers-icon-fingerprint =
    .label = Fingeravtrykk
containers-icon-briefcase =
    .label = Dokumentmappe
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Dollartegn
containers-icon-cart =
    .label = Handlevogn
containers-icon-circle =
    .label = Punkt
containers-icon-vacation =
    .label = Ferie
containers-icon-gift =
    .label = Gave
containers-icon-food =
    .label = Mat
containers-icon-fruit =
    .label = Frukt
containers-icon-pet =
    .label = Kjæledyr
containers-icon-tree =
    .label = Tre
containers-icon-chill =
    .label = Avslapping
