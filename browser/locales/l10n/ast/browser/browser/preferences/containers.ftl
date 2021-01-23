# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Amestar contenedor nuevu
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Preferencies del contenedor { $name }
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
    .placeholder = Introduz nome del contenedor

containers-icon-label = Iconu
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = Color
    .accesskey = o
    .style = { -containers-labels-style }

containers-button-done =
    .label = Fecho
    .accesskey = D

containers-color-blue =
    .label = Azul
containers-color-turquoise =
    .label = Turquesa
containers-color-green =
    .label = Verde
containers-color-yellow =
    .label = Mariellu
containers-color-orange =
    .label = Naranxa
containers-color-red =
    .label = Bermeyu
containers-color-pink =
    .label = Rosa
containers-color-purple =
    .label = Moráu

containers-icon-fingerprint =
    .label = Buelga
containers-icon-briefcase =
    .label = Cartera
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Símbolu del dólar
containers-icon-cart =
    .label = Carru de merca
containers-icon-circle =
    .label = Puntu
containers-icon-vacation =
    .label = Vacaciones
containers-icon-gift =
    .label = Regalu
containers-icon-food =
    .label = Comida
containers-icon-fruit =
    .label = Fruta
containers-icon-pet =
    .label = Mascota
containers-icon-tree =
    .label = Árbol
containers-icon-chill =
    .label = Relax
