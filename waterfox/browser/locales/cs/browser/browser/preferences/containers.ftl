# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Přidat kontejner
    .style = width: 45em

# Variables
#   $name (String) - Name of the container
containers-window-update-settings =
    .title = Nastavení kontejneru { $name }
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

containers-name-label = Název
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Zadejte název kontejneru

containers-icon-label = Ikona
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = Barva
    .accesskey = r
    .style = { -containers-labels-style }

containers-dialog =
    .buttonlabelaccept = Hotovo
    .buttonaccesskeyaccept = H

containers-color-blue =
    .label = Modrá
containers-color-turquoise =
    .label = Tyrkysová
containers-color-green =
    .label = Zelená
containers-color-yellow =
    .label = Žlutá
containers-color-orange =
    .label = Oranžová
containers-color-red =
    .label = Červená
containers-color-pink =
    .label = Růžová
containers-color-purple =
    .label = Fialová
containers-color-toolbar =
    .label = Jako nástrojová lišta

containers-icon-fence =
    .label = Plot
containers-icon-fingerprint =
    .label = Otisk
containers-icon-briefcase =
    .label = Kufřík
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Značka dolaru
containers-icon-cart =
    .label = Nákupní košík
containers-icon-circle =
    .label = Tečka
containers-icon-vacation =
    .label = Dovolená
containers-icon-gift =
    .label = Dárek
containers-icon-food =
    .label = Jídlo
containers-icon-fruit =
    .label = Ovoce
containers-icon-pet =
    .label = Zvíře
containers-icon-tree =
    .label = Strom
containers-icon-chill =
    .label = Odpočinek
