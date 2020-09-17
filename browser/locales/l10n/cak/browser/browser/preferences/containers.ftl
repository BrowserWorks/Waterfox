# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Titz'aqatisäx k'ak'a' k'wayöl
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = { $name } taq rajowab'al k'wayöl
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

containers-name-label = B'i'aj
    .accesskey = B
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Tatz'ib'aj jun rub'i' k'wayöl

containers-icon-label = Wachib'äl
    .accesskey = W
    .style = { -containers-labels-style }

containers-color-label = B'onil
    .accesskey = o
    .style = { -containers-labels-style }

containers-button-done =
    .label = Xk'is
    .accesskey = X

containers-color-blue =
    .label = Xar
containers-color-turquoise =
    .label = Turkesa
containers-color-green =
    .label = Räx
containers-color-yellow =
    .label = Q'än
containers-color-orange =
    .label = Kaqköj
containers-color-red =
    .label = Käq
containers-color-pink =
    .label = Ronqs
containers-color-purple =
    .label = Purpura'
containers-color-toolbar =
    .label = Titun ri rukajtz'ik samajib'äl

containers-icon-fence =
    .label = Tik'ojöx
containers-icon-fingerprint =
    .label = Retal ruwi' q'ab'aj
containers-icon-briefcase =
    .label = Ejqatel
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Retal Dolar
containers-icon-cart =
    .label = Loq'ob'äl ch'ich'
containers-icon-circle =
    .label = Rajil
containers-icon-vacation =
    .label = Uxlanem
containers-icon-gift =
    .label = Sipanïk
containers-icon-food =
    .label = Wa'im
containers-icon-fruit =
    .label = Ruwäch che'
containers-icon-pet =
    .label = Ala's
containers-icon-tree =
    .label = Che'
containers-icon-chill =
    .label = Tew
