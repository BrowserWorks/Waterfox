# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Añadir nuevo contenedor
    .style = width: 49em

# Variables
#   $name (String) - Name of the container
containers-window-update-settings =
    .title = Ajustes del contenedor { $name }
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
-containers-labels-style = min-width: 5rem

containers-name-label = Nombre
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Escriba un nombre de contenedor

containers-icon-label = Icono
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = Color
    .accesskey = o
    .style = { -containers-labels-style }

containers-dialog =
    .buttonlabelaccept = Hecho
    .buttonaccesskeyaccept = H

containers-color-blue =
    .label = Azul
containers-color-turquoise =
    .label = Turquesa
containers-color-green =
    .label = Verde
containers-color-yellow =
    .label = Amarillo
containers-color-orange =
    .label = Naranja
containers-color-red =
    .label = Rojo
containers-color-pink =
    .label = Rosa
containers-color-purple =
    .label = Púrpura
containers-color-toolbar =
    .label = Emparejar la barra de herramientas

containers-icon-fence =
    .label = Cerco
containers-icon-fingerprint =
    .label = Huella digital
containers-icon-briefcase =
    .label = Maletín
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Signo del dólar
containers-icon-cart =
    .label = Carrito de la compra
containers-icon-circle =
    .label = Punto
containers-icon-vacation =
    .label = Vacaciones
containers-icon-gift =
    .label = Regalos
containers-icon-food =
    .label = Comida
containers-icon-fruit =
    .label = Fruta
containers-icon-pet =
    .label = Mascotas
containers-icon-tree =
    .label = Árbol
containers-icon-chill =
    .label = Calma
