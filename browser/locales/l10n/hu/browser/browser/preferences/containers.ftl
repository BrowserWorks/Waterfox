# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Új konténer hozzáadása
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = { $name } konténer beállításai
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update-settings =
    .title = { $name } konténer beállításai
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
containers-name-label = Név
    .accesskey = N
    .style = { -containers-labels-style }
containers-name-text =
    .placeholder = Adjon meg egy konténernevet
containers-icon-label = Ikon
    .accesskey = I
    .style = { -containers-labels-style }
containers-color-label = Szín
    .accesskey = z
    .style = { -containers-labels-style }
containers-button-done =
    .label = Kész
    .accesskey = K
containers-dialog =
    .buttonlabelaccept = Kész
    .buttonaccesskeyaccept = K
containers-color-blue =
    .label = Kék
containers-color-turquoise =
    .label = Türkiz
containers-color-green =
    .label = Zöld
containers-color-yellow =
    .label = Sárga
containers-color-orange =
    .label = Narancs
containers-color-red =
    .label = Vörös
containers-color-pink =
    .label = Rózsaszín
containers-color-purple =
    .label = Lila
containers-color-toolbar =
    .label = Egyezzen meg az eszköztárral
containers-icon-fence =
    .label = Kerítés
containers-icon-fingerprint =
    .label = Ujjlenyomat
containers-icon-briefcase =
    .label = Aktatáska
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Dollárjel
containers-icon-cart =
    .label = Bevásárlókosár
containers-icon-circle =
    .label = Pont
containers-icon-vacation =
    .label = Vakáció
containers-icon-gift =
    .label = Ajándék
containers-icon-food =
    .label = Étel
containers-icon-fruit =
    .label = Gyümölcs
containers-icon-pet =
    .label = Állatok
containers-icon-tree =
    .label = Fa
containers-icon-chill =
    .label = Nyugalom
