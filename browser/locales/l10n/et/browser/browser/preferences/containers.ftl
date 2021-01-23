# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Uue konteineri lisamine
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Konteineri eelistused - { $name }
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

containers-name-label = Nimi
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Sisesta konteineri nimi

containers-icon-label = Ikoon
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = Värv
    .accesskey = V
    .style = { -containers-labels-style }

containers-button-done =
    .label = Valmis
    .accesskey = a

containers-color-blue =
    .label = Sinine
containers-color-turquoise =
    .label = Türkiis
containers-color-green =
    .label = Roheline
containers-color-yellow =
    .label = Kollane
containers-color-orange =
    .label = Oranž
containers-color-red =
    .label = Punane
containers-color-pink =
    .label = Roosa
containers-color-purple =
    .label = Lilla
containers-color-toolbar =
    .label = Tööriistaribaga ühilduv

containers-icon-fence =
    .label = Piirdeaed
containers-icon-fingerprint =
    .label = Sõrmejälg
containers-icon-briefcase =
    .label = Portfell
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Dollarimärk
containers-icon-cart =
    .label = Ostukorv
containers-icon-circle =
    .label = Punkt
containers-icon-vacation =
    .label = Puhkus
containers-icon-gift =
    .label = Kingitused
containers-icon-food =
    .label = Toit
containers-icon-fruit =
    .label = Puuviljad
containers-icon-pet =
    .label = Lemmikloomad
containers-icon-tree =
    .label = Puud
containers-icon-chill =
    .label = Vaba aeg
