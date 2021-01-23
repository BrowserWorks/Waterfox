# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Rnu amagbar-nniḍen
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Ismenyifen n umagbar { $name }
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

containers-name-label = Isem
    .accesskey = T
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Sekcem isem n umagbar

containers-icon-label = Tignit
    .accesskey = G
    .style = { -containers-labels-style }

containers-color-label = Initen
    .accesskey = w
    .style = { -containers-labels-style }

containers-button-done =
    .label = Immed
    .accesskey = m

containers-color-blue =
    .label = Amidadi
containers-color-turquoise =
    .label = Azenǧaṛi
containers-color-green =
    .label = Azegzaw
containers-color-yellow =
    .label = Awraɣ
containers-color-orange =
    .label = Ačinawi
containers-color-red =
    .label = Azeggaɣ
containers-color-pink =
    .label = Axuxi
containers-color-purple =
    .label = Avyuli
containers-color-toolbar =
    .label = Iṣeggem deg ufeggag n yifecka

containers-icon-fence =
    .label = Talast
containers-icon-fingerprint =
    .label = Adsil umḍin
containers-icon-briefcase =
    .label = Aqwrab
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Azamul n Dollar
containers-icon-cart =
    .label = Taqecwalt n lqeḍyan
containers-icon-circle =
    .label = Taneqqiṭ
containers-icon-vacation =
    .label = Imuras
containers-icon-gift =
    .label = Araz
containers-icon-food =
    .label = Tuččit
containers-icon-fruit =
    .label = Agummu
containers-icon-pet =
    .label = Aɣeṛsiw n uxxam
containers-icon-tree =
    .label = Aseklu
containers-icon-chill =
    .label = Agrud
