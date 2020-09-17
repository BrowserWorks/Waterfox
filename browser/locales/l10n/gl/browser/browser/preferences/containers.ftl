# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Engadir un novo contedor
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Preferencias do contedor «{ $name }»
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
containers-name-label = Nome
    .accesskey = N
    .style = { -containers-labels-style }
containers-name-text =
    .placeholder = Escriba un nome para o contedor
containers-icon-label = Icona
    .accesskey = I
    .style = { -containers-labels-style }
containers-color-label = Cor
    .accesskey = o
    .style = { -containers-labels-style }
containers-button-done =
    .label = Feito
    .accesskey = F
containers-color-blue =
    .label = Azul
containers-color-turquoise =
    .label = Turquesa
containers-color-green =
    .label = Verde
containers-color-yellow =
    .label = Amarelo
containers-color-orange =
    .label = Laranxa
containers-color-red =
    .label = Vermello
containers-color-pink =
    .label = Rosa
containers-color-purple =
    .label = Púrpura
containers-color-toolbar =
    .label = O mesmo que a barra de ferramentas
containers-icon-fence =
    .label = Valado
containers-icon-fingerprint =
    .label = Pegada dactilar
containers-icon-briefcase =
    .label = Maletín
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Signo do dólar
containers-icon-cart =
    .label = Carro da compra
containers-icon-circle =
    .label = Punto
containers-icon-vacation =
    .label = Vacacións
containers-icon-gift =
    .label = Regalo
containers-icon-food =
    .label = Comida
containers-icon-fruit =
    .label = Froita
containers-icon-pet =
    .label = Mascota
containers-icon-tree =
    .label = Árbore
containers-icon-chill =
    .label = Relax
