# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Bæta við nýjum innihaldsflipa
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = { $name } stillingar innihaldsflipa
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

containers-name-label = Nafn
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Sláðu inn nafn innihaldsflipa

containers-icon-label = Táknmynd
    .accesskey = y
    .style = { -containers-labels-style }

containers-color-label = Litur
    .accesskey = L
    .style = { -containers-labels-style }

containers-button-done =
    .label = Lokið
    .accesskey = ð

containers-color-blue =
    .label = Blár
containers-color-turquoise =
    .label = Túrkísgrænn
containers-color-green =
    .label = Grænn
containers-color-yellow =
    .label = Gulur
containers-color-orange =
    .label = Appelsínugulur
containers-color-red =
    .label = Rauður
containers-color-pink =
    .label = Bleikur
containers-color-purple =
    .label = Fjólublár
containers-color-toolbar =
    .label = Eins og verkfæraslá

containers-icon-fence =
    .label = Girðing
containers-icon-fingerprint =
    .label = Fingrafar
containers-icon-briefcase =
    .label = Skjalataska
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Dollaramerki
containers-icon-cart =
    .label = Innkaupakarfa
containers-icon-circle =
    .label = Punktur
containers-icon-vacation =
    .label = Frí
containers-icon-gift =
    .label = Gjöf
containers-icon-food =
    .label = Matur
containers-icon-fruit =
    .label = Ávextir
containers-icon-pet =
    .label = Gæludýr
containers-icon-tree =
    .label = Tré
containers-icon-chill =
    .label = Afslöppun
