# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Dodaj nov vsebnik
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Nastavitve vsebnika { $name }
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

containers-name-label = Ime
    .accesskey = m
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Vnesite ime vsebnika

containers-icon-label = Ikona
    .accesskey = k
    .style = { -containers-labels-style }

containers-color-label = Barva
    .accesskey = B
    .style = { -containers-labels-style }

containers-button-done =
    .label = Končaj
    .accesskey = K

containers-color-blue =
    .label = Modro
containers-color-turquoise =
    .label = Turkizno
containers-color-green =
    .label = Zeleno
containers-color-yellow =
    .label = Rumeno
containers-color-orange =
    .label = Oranžno
containers-color-red =
    .label = Rdeče
containers-color-pink =
    .label = Roza
containers-color-purple =
    .label = Vijolično
containers-color-toolbar =
    .label = Ujemanje z orodno vrstico

containers-icon-fence =
    .label = Ograja
containers-icon-fingerprint =
    .label = Prstni odtis
containers-icon-briefcase =
    .label = Aktovka
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Dolarski znak
containers-icon-cart =
    .label = Nakupovalni voziček
containers-icon-circle =
    .label = Pika
containers-icon-vacation =
    .label = Počitnice
containers-icon-gift =
    .label = Darilo
containers-icon-food =
    .label = Hrana
containers-icon-fruit =
    .label = Sadje
containers-icon-pet =
    .label = Domači ljubljenček
containers-icon-tree =
    .label = Drevo
containers-icon-chill =
    .label = Kul
