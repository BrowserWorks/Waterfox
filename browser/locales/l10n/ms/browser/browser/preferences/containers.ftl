# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Tambah Penyimpan Baru
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = { $name } Keutamaan Penyimpan
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

containers-name-label = Nama
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Masukkan nama penyimpan

containers-icon-label = Ikon
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = Warna
    .accesskey = W
    .style = { -containers-labels-style }

containers-button-done =
    .label = Siap
    .accesskey = S

containers-color-blue =
    .label = Biru
containers-color-turquoise =
    .label = Firus
containers-color-green =
    .label = Hijau
containers-color-yellow =
    .label = Kuning
containers-color-orange =
    .label = Oren
containers-color-red =
    .label = Merah
containers-color-pink =
    .label = Merah jambu
containers-color-purple =
    .label = Ungu

containers-icon-fingerprint =
    .label = Cap jari
containers-icon-briefcase =
    .label = Beg bimbit
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Dollar sign
containers-icon-cart =
    .label = Karung belian
containers-icon-circle =
    .label = Dot
containers-icon-vacation =
    .label = Percutian
containers-icon-gift =
    .label = Hadiah
containers-icon-food =
    .label = Makanan
containers-icon-fruit =
    .label = Buah-buahan
containers-icon-pet =
    .label = Haiwan Peliharaan
containers-icon-tree =
    .label = Pepohon
containers-icon-chill =
    .label = Kedinginan
