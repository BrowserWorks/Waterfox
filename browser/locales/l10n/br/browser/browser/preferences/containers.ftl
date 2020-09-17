# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Ouzhpennañ un endalc'her nevez
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Gwellvezioù Endalc'her { $name }
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

containers-name-label = Anv
    .accesskey = A
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Enankit anv un endalc'her

containers-icon-label = Arlun
    .accesskey = A
    .style = { -containers-labels-style }

containers-color-label = Liv
    .accesskey = i
    .style = { -containers-labels-style }

containers-button-done =
    .label = Mat eo
    .accesskey = M

containers-color-blue =
    .label = Glas
containers-color-turquoise =
    .label = Glas-gwer
containers-color-green =
    .label = Gwer
containers-color-yellow =
    .label = Melen
containers-color-orange =
    .label = Orañjez
containers-color-red =
    .label = Ruz
containers-color-pink =
    .label = Roz
containers-color-purple =
    .label = Limestra
containers-color-toolbar =
    .label = A glot gant ar varrenn ostilhoù

containers-icon-fence =
    .label = Kloued
containers-icon-fingerprint =
    .label = Roudoù biz
containers-icon-briefcase =
    .label = Malizenn
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Arouezenn Dollar
containers-icon-cart =
    .label = Paner prenadennoù
containers-icon-circle =
    .label = Pik
containers-icon-vacation =
    .label = Vakañsoù
containers-icon-gift =
    .label = Prof
containers-icon-food =
    .label = Boued
containers-icon-fruit =
    .label = Frouezh
containers-icon-pet =
    .label = Loen-ti
containers-icon-tree =
    .label = Gwezenn
containers-icon-chill =
    .label = Yen
