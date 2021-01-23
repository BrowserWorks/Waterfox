# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Coimeádán Nua
    .style = width: 50em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Sainroghanna don Choimeádán { $name }
    .style = width: 50em

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
-containers-labels-style = min-width: 5rem

containers-name-label = Ainm
    .accesskey = n
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Cuir ainm an choimeádáin isteach

containers-icon-label = Deilbhín
    .accesskey = i
    .style = { -containers-labels-style }

containers-color-label = Dath
    .accesskey = h
    .style = { -containers-labels-style }

containers-button-done =
    .label = Críochnaithe
    .accesskey = C

containers-color-blue =
    .label = Gorm
containers-color-turquoise =
    .label = Turcaidghorm
containers-color-green =
    .label = Uaine
containers-color-yellow =
    .label = Buí
containers-color-orange =
    .label = Oráiste
containers-color-red =
    .label = Dearg
containers-color-pink =
    .label = Bándearg
containers-color-purple =
    .label = Corcra

containers-icon-fence =
    .label = Claí
containers-icon-fingerprint =
    .label = Méarlorg
containers-icon-briefcase =
    .label = Mála cáipéisí
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Comhartha dollair
containers-icon-cart =
    .label = Tralaí siopadóireachta
containers-icon-circle =
    .label = Ponc
containers-icon-vacation =
    .label = Saoire
containers-icon-gift =
    .label = Bronntanas
containers-icon-food =
    .label = Bia
containers-icon-fruit =
    .label = Toradh
containers-icon-pet =
    .label = Peata
containers-icon-tree =
    .label = Crann
