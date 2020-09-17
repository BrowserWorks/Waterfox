# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Yangi konteyner qo‘shish
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = { $name } konteyner parametrlari
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

containers-name-label = Nomi
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Konteyner nomini kiriting

containers-icon-label = Belgi
    .accesskey = B
    .style = { -containers-labels-style }

containers-color-label = Rangi
    .accesskey = o
    .style = { -containers-labels-style }

containers-button-done =
    .label = Tayyor
    .accesskey = T

containers-color-blue =
    .label = Ko‘k
containers-color-turquoise =
    .label = Firuza rang
containers-color-green =
    .label = Yashil
containers-color-yellow =
    .label = Sariq
containers-color-orange =
    .label = Zarg‘aldoq rang
containers-color-red =
    .label = Qizil
containers-color-pink =
    .label = Pushti
containers-color-purple =
    .label = Binafsha rang
containers-color-toolbar =
    .label = Asboblar paneli sifatida

containers-icon-fence =
    .label = Toʻsiq
containers-icon-fingerprint =
    .label = Barmoq izi
containers-icon-briefcase =
    .label = Portfel
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Dollar belgisi
containers-icon-cart =
    .label = Xarid kartasi
containers-icon-circle =
    .label = Nuqta
containers-icon-vacation =
    .label = Ta’til
containers-icon-gift =
    .label = Sovg’a
containers-icon-food =
    .label = Ovqat
containers-icon-fruit =
    .label = Meva
containers-icon-pet =
    .label = Uy hayvoni
containers-icon-tree =
    .label = Daraxt
containers-icon-chill =
    .label = Sovuq
