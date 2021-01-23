# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = కొత్త కంటెయినరు చేర్చు
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = { $name } కంటెయినరు అభిరుచులు
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

containers-name-label = పేరు
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = కంటెయినరు పేరును ఇవ్వండి

containers-icon-label = ప్రతీకం
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = రంగు
    .accesskey = o
    .style = { -containers-labels-style }

containers-button-done =
    .label = పూర్తయింది
    .accesskey = D

containers-color-blue =
    .label = నీలం
containers-color-turquoise =
    .label = హరిత నీలం
containers-color-green =
    .label = పచ్చ
containers-color-yellow =
    .label = పసుపు
containers-color-orange =
    .label = నారింజ
containers-color-red =
    .label = ఎరుపు
containers-color-pink =
    .label = గులాబి
containers-color-purple =
    .label = ఊదా

containers-icon-fingerprint =
    .label = వేలిముద్ర
containers-icon-briefcase =
    .label = బ్రీఫ్‌కేస్
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = డాలర్‌ చిహ్నం
containers-icon-cart =
    .label = షాపింగ్ కార్ట్
containers-icon-circle =
    .label = చుక్క
containers-icon-vacation =
    .label = సెలవు
containers-icon-gift =
    .label = బహుమతి
containers-icon-food =
    .label = భోజనం
containers-icon-fruit =
    .label = పండు
containers-icon-pet =
    .label = పెంపుడు జంతువు
containers-icon-tree =
    .label = చెట్టు
containers-icon-chill =
    .label = చిల్
