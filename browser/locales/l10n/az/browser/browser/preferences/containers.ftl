# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Yeni konteyner əlavə et
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = { $name } Konteyneri Nizamlamaları
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
    .placeholder = Konteyner adını daxil edin

containers-icon-label = İkon
    .accesskey = k
    .style = { -containers-labels-style }

containers-color-label = Rəng
    .accesskey = g
    .style = { -containers-labels-style }

containers-button-done =
    .label = Hazır
    .accesskey = H

containers-color-blue =
    .label = Göy
containers-color-turquoise =
    .label = Firuzəyi
containers-color-green =
    .label = Yaşıl
containers-color-yellow =
    .label = Sarı
containers-color-orange =
    .label = Narıncı
containers-color-red =
    .label = Qırmızı
containers-color-pink =
    .label = Çəhrayı
containers-color-purple =
    .label = Bənövşəyi
containers-color-toolbar =
    .label = Alət paneli ilə uyğunlaşdır

containers-icon-fence =
    .label = Hasar
containers-icon-fingerprint =
    .label = Barmaq izi
containers-icon-briefcase =
    .label = Portfel
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Dollar işarəsi
containers-icon-cart =
    .label = Alış-veriş çantası
containers-icon-circle =
    .label = Nöqtə
containers-icon-vacation =
    .label = Məzuniyyət
containers-icon-gift =
    .label = Hədiyyə
containers-icon-food =
    .label = Qida
containers-icon-fruit =
    .label = Meyvə
containers-icon-pet =
    .label = Evcil heyvan
containers-icon-tree =
    .label = Ağac
containers-icon-chill =
    .label = İstirahət
