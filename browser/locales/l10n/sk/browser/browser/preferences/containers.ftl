# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Pridať nový kontajner
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Nastavenia kontajnera { $name }
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

containers-name-label = Názov
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Zadajte názov kontajnera

containers-icon-label = Ikona
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = Farba
    .accesskey = a
    .style = { -containers-labels-style }

containers-button-done =
    .label = Hotovo
    .accesskey = H

containers-color-blue =
    .label = Modrá
containers-color-turquoise =
    .label = Tyrkysová
containers-color-green =
    .label = Zelená
containers-color-yellow =
    .label = Žltá
containers-color-orange =
    .label = Oranžová
containers-color-red =
    .label = Červená
containers-color-pink =
    .label = Ružová
containers-color-purple =
    .label = Fialová
containers-color-toolbar =
    .label = Ako panel nástrojov

containers-icon-fence =
    .label = Plot
containers-icon-fingerprint =
    .label = Odtlačok prsta
containers-icon-briefcase =
    .label = Aktovka
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Znak dolára
containers-icon-cart =
    .label = Nákupný košík
containers-icon-circle =
    .label = Bodka
containers-icon-vacation =
    .label = Dovolenka
containers-icon-gift =
    .label = Darček
containers-icon-food =
    .label = Jedlo
containers-icon-fruit =
    .label = Ovocie
containers-icon-pet =
    .label = Zviera
containers-icon-tree =
    .label = Strom
containers-icon-chill =
    .label = Odpočinok
