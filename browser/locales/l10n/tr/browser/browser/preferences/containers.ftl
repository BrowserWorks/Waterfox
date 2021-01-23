# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Yeni kapsayıcı ekle
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = { $name } Kapsayıcısı Tercihleri
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

containers-name-label = Ad
    .accesskey = A
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Bir kapsayıcı ismi yazın

containers-icon-label = Simge
    .accesskey = S
    .style = { -containers-labels-style }

containers-color-label = Renk
    .accesskey = R
    .style = { -containers-labels-style }

containers-button-done =
    .label = Tamam
    .accesskey = m

containers-color-blue =
    .label = Mavi
containers-color-turquoise =
    .label = Turkuaz
containers-color-green =
    .label = Yeşil
containers-color-yellow =
    .label = Sarı
containers-color-orange =
    .label = Turuncu
containers-color-red =
    .label = Kırmızı
containers-color-pink =
    .label = Pembe
containers-color-purple =
    .label = Mor
containers-color-toolbar =
    .label = Araç çubuğunu eşleştir

containers-icon-fence =
    .label = Çit
containers-icon-fingerprint =
    .label = Parmak izi
containers-icon-briefcase =
    .label = Çanta
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Dolar işareti
containers-icon-cart =
    .label = Alışveriş arabası
containers-icon-circle =
    .label = Nokta
containers-icon-vacation =
    .label = Tatil
containers-icon-gift =
    .label = Hediye
containers-icon-food =
    .label = Yemek
containers-icon-fruit =
    .label = Meyve
containers-icon-pet =
    .label = Hayvan
containers-icon-tree =
    .label = Ağaç
containers-icon-chill =
    .label = Soğuk
