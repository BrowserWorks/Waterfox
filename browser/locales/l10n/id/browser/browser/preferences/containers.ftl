# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Tambahkan Kontainer Baru
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Pengaturan Kontainer { $name }
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update-settings =
    .title = Pengaturan Kontainer { $name }
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
    .placeholder = Masukan nama kontainer
containers-icon-label = Ikon
    .accesskey = I
    .style = { -containers-labels-style }
containers-color-label = Warna
    .accesskey = a
    .style = { -containers-labels-style }
containers-button-done =
    .label = Selesai
    .accesskey = S
containers-dialog =
    .buttonlabelaccept = Selesai
    .buttonaccesskeyaccept = S
containers-color-blue =
    .label = Biru
containers-color-turquoise =
    .label = Biru Kehijauan
containers-color-green =
    .label = Hijau
containers-color-yellow =
    .label = Kuning
containers-color-orange =
    .label = Jingga
containers-color-red =
    .label = Merah
containers-color-pink =
    .label = Merah Muda
containers-color-purple =
    .label = Ungu
containers-color-toolbar =
    .label = Cocokkan bilah alat
containers-icon-fence =
    .label = Pagar
containers-icon-fingerprint =
    .label = Sidik Jari
containers-icon-briefcase =
    .label = Tas Kerja
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Lambang dolar
containers-icon-cart =
    .label = Keranjang belanja
containers-icon-circle =
    .label = Titik
containers-icon-vacation =
    .label = Liburan
containers-icon-gift =
    .label = Hadiah
containers-icon-food =
    .label = Makanan
containers-icon-fruit =
    .label = Buah
containers-icon-pet =
    .label = Peliharaan
containers-icon-tree =
    .label = Pohon
containers-icon-chill =
    .label = Dingin
