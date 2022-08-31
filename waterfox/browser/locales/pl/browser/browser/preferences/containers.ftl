# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Dodawanie kontekstu
    .style = width: 45em

# Variables
#   $name (String) - Name of the container
containers-window-update-settings =
    .title = Ustawienia kontekstu „{ $name }”
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

containers-name-label = Nazwa:
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Nazwa kontekstu

containers-icon-label = Ikona:
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = Kolor:
    .accesskey = K
    .style = { -containers-labels-style }

containers-dialog =
    .buttonlabelaccept = Gotowe
    .buttonaccesskeyaccept = G

containers-color-blue =
    .label = Niebieski
containers-color-turquoise =
    .label = Turkusowy
containers-color-green =
    .label = Zielony
containers-color-yellow =
    .label = Żółty
containers-color-orange =
    .label = Pomarańczowy
containers-color-red =
    .label = Czerwony
containers-color-pink =
    .label = Różowy
containers-color-purple =
    .label = Purpurowy
containers-color-toolbar =
    .label = Pasujący do paska narzędzi

containers-icon-fence =
    .label = Płotek
containers-icon-fingerprint =
    .label = Odcisk palca
containers-icon-briefcase =
    .label = Aktówka
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Znak dolara
containers-icon-cart =
    .label = Wózek zakupowy
containers-icon-circle =
    .label = Kropka
containers-icon-vacation =
    .label = Wakacje
containers-icon-gift =
    .label = Prezent
containers-icon-food =
    .label = Jedzenie
containers-icon-fruit =
    .label = Owoc
containers-icon-pet =
    .label = Zwierzę
containers-icon-tree =
    .label = Drzewo
containers-icon-chill =
    .label = Relaks
