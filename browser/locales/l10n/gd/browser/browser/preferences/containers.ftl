# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Cuir soitheach ùr ris
    .style = width: 50em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Roghainnean an t-soithich “{ $name }”
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
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Cuir a-steach ainm dhan t-soitheach

containers-icon-label = Ìomhaigheag
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = Dath
    .accesskey = o
    .style = { -containers-labels-style }

containers-button-done =
    .label = Deiseil
    .accesskey = D

containers-color-blue =
    .label = Gorm
containers-color-turquoise =
    .label = Tuirceas
containers-color-green =
    .label = Uaine
containers-color-yellow =
    .label = Buidhe
containers-color-orange =
    .label = Orains
containers-color-red =
    .label = Dearg
containers-color-pink =
    .label = Pinc
containers-color-purple =
    .label = Purpaidh
containers-color-toolbar =
    .label = Match toolbar

containers-icon-fence =
    .label = Feansa
containers-icon-fingerprint =
    .label = Lorg-meòir
containers-icon-briefcase =
    .label = Màileid-oifise
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Comharra an dolair
containers-icon-cart =
    .label = Cairt nan ceannachd
containers-icon-circle =
    .label = Dotag
containers-icon-vacation =
    .label = Làithean-saora
containers-icon-gift =
    .label = Prèasant
containers-icon-food =
    .label = Biadh
containers-icon-fruit =
    .label = Meas
containers-icon-pet =
    .label = Peata
containers-icon-tree =
    .label = Craobh
containers-icon-chill =
    .label = Fois
