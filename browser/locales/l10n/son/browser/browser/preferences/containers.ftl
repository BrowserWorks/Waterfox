# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Sun taaga tonton
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = { $name } sun ibaayey
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

containers-name-text =
    .placeholder = Sun maa dam

containers-button-done =
    .label = A ben
    .accesskey = b

containers-color-blue =
    .label = Bula
containers-color-turquoise =
    .label = Bula kaaray
containers-color-green =
    .label = Firži
containers-color-yellow =
    .label = Woole
containers-color-orange =
    .label = Konkoma
containers-color-red =
    .label = Ciray
containers-color-pink =
    .label = Talhannaboosu
containers-color-purple =
    .label = Boy

containers-icon-fingerprint =
    .label = Kabežeerey
containers-icon-briefcase =
    .label = Adiika
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Doolar tammaasa
containers-icon-cart =
    .label = Dayday torko
containers-icon-circle =
    .label = Tonbi
