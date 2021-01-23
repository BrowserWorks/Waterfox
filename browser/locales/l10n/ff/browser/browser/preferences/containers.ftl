# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Ɓeydu Mooftiree Hesere
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Cuɓoraaɗe Mooftirɗe { $name }
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

containers-name-label = Innde
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Winndu innde mooftirde

containers-icon-label = Ikon
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = Noordi
    .accesskey = o
    .style = { -containers-labels-style }

containers-button-done =
    .label = Gasii
    .accesskey = G

containers-color-blue =
    .label = Bulaajo
containers-color-turquoise =
    .label = Bakaajo
containers-color-green =
    .label = Haakeejo
containers-color-yellow =
    .label = Oolo
containers-color-orange =
    .label = Orayso
containers-color-red =
    .label = Boɗeejo
containers-color-pink =
    .label = Rooso
containers-color-purple =
    .label = Boruujo

containers-icon-fingerprint =
    .label = Temmbelol
containers-icon-briefcase =
    .label = Sakkoos
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Maande dolaar
containers-icon-cart =
    .label = Jige nduggu
containers-icon-circle =
    .label = Toɓɓere
containers-icon-vacation =
    .label = Guurte
containers-icon-gift =
    .label = Jeenal
containers-icon-food =
    .label = Ñaamdu
containers-icon-fruit =
    .label = Ɓiɗɗe
containers-icon-pet =
    .label = Nehaandi
containers-icon-tree =
    .label = Lekki
containers-icon-chill =
    .label = Chill
