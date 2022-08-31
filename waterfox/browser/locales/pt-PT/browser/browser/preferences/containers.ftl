# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Adicionar novo contentor
    .style = width: 45em

# Variables
#   $name (String) - Name of the container
containers-window-update-settings =
    .title = Definições do contentor { $name }
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
    .placeholder = Introduza um nome de contentor

containers-icon-label = Ícone
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = Cor
    .accesskey = o
    .style = { -containers-labels-style }

containers-dialog =
    .buttonlabelaccept = Feito
    .buttonaccesskeyaccept = F

containers-color-blue =
    .label = Azul
containers-color-turquoise =
    .label = Turquesa
containers-color-green =
    .label = Verde
containers-color-yellow =
    .label = Amarelo
containers-color-orange =
    .label = Laranja
containers-color-red =
    .label = Vermelho
containers-color-pink =
    .label = Rosa
containers-color-purple =
    .label = Roxo
containers-color-toolbar =
    .label = Corresponder à da barra de ferramentas

containers-icon-fence =
    .label = Cerca
containers-icon-fingerprint =
    .label = Impressão digital
containers-icon-briefcase =
    .label = Pasta
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Cifrão
containers-icon-cart =
    .label = Carrinho de compras
containers-icon-circle =
    .label = Ponto
containers-icon-vacation =
    .label = Férias
containers-icon-gift =
    .label = Prenda
containers-icon-food =
    .label = Comida
containers-icon-fruit =
    .label = Fruta
containers-icon-pet =
    .label = Animal de estimação
containers-icon-tree =
    .label = Árvore
containers-icon-chill =
    .label = Descanço
