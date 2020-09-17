# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = નવું કન્ટેઈનર ઉમેરો
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = { $name } કન્ટેઈનર પસંદગીઓ
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

containers-name-label = નામ
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = કન્ટેઈનરમાં નામ દાખલ કરો

containers-icon-label = ચિહ્ન
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = રંગ
    .accesskey = o
    .style = { -containers-labels-style }

containers-button-done =
    .label = પૂર્ણ થયું
    .accesskey = D

containers-color-blue =
    .label = ભૂરી
containers-color-turquoise =
    .label = ફિરોઝી
containers-color-green =
    .label = લીલો
containers-color-yellow =
    .label = પીળો
containers-color-orange =
    .label = કેસરી
containers-color-red =
    .label = લાલ
containers-color-pink =
    .label = ગુલાબી
containers-color-purple =
    .label = જાંબલી

containers-icon-fingerprint =
    .label = આંગળીની છાપ
containers-icon-briefcase =
    .label = દસ્તાવેજપાત્ર
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = ડૉલર ચિહ્ન
containers-icon-cart =
    .label = શોપિંગ ગાડી
containers-icon-circle =
    .label = ટપકું
containers-icon-vacation =
    .label = રજા
containers-icon-gift =
    .label = ભેટસોગાદો
containers-icon-food =
    .label = ભોજન
containers-icon-fruit =
    .label = ફળ
containers-icon-pet =
    .label = પાલતુ
containers-icon-tree =
    .label = વૃક્ષ
containers-icon-chill =
    .label = ઠંડી
