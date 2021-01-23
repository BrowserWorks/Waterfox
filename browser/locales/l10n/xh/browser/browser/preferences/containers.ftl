# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Yongeza iKhonteyina eNtsha
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Ukhetho lweKhonteyina { $name }
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

containers-button-done =
    .label = Igqibile
    .accesskey = I

containers-color-blue =
    .label = eBlue
containers-color-turquoise =
    .label = ETurquoise
containers-color-green =
    .label = Luhlaza
containers-color-yellow =
    .label = eYellow
containers-color-orange =
    .label = EOrenji
containers-color-red =
    .label = eBomvu
containers-color-pink =
    .label = EPinki
containers-color-purple =
    .label = Epurple

containers-icon-fingerprint =
    .label = Umzila womnwe
containers-icon-briefcase =
    .label = Ibrufkheyisi
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Umqondiso wedola
containers-icon-cart =
    .label = Itroli yokuthenga
containers-icon-circle =
    .label = IChaphaza
