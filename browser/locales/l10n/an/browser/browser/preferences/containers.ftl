# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Anyader Nuevo Contenedor
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = { $name } Preferencias de contenedor
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

containers-name-label = Nombre
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Escribir un nombre de contenedor

containers-icon-label = Icono
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = Color
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
    .label = Amariello
containers-color-orange =
    .label = Narancha
containers-color-red =
    .label = Royo
containers-color-pink =
    .label = Rosa
containers-color-purple =
    .label = Morau
containers-color-toolbar =
    .label = Barra de ferramientas de coincidencias

containers-icon-fence =
    .label = Cleta
containers-icon-fingerprint =
    .label = Ditalada
containers-icon-briefcase =
    .label = Cartera
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Signo de dolar
containers-icon-cart =
    .label = Carret d'a crompa
containers-icon-circle =
    .label = Punto
containers-icon-vacation =
    .label = Vacanzas
containers-icon-gift =
    .label = Regalo
containers-icon-food =
    .label = Minchar
containers-icon-fruit =
    .label = Fruita
containers-icon-pet =
    .label = Animal
containers-icon-tree =
    .label = Arbol
containers-icon-chill =
    .label = Relax
