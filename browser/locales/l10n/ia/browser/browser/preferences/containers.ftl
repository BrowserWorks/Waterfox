# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Adder un nove contexto
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Preferentias del contexto { $name }
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

containers-name-label = Nomine
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Scribe un nomine pro le contexto

containers-icon-label = Icone
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = Color
    .accesskey = o
    .style = { -containers-labels-style }

containers-button-done =
    .label = Facite
    .accesskey = F

containers-color-blue =
    .label = Blau
containers-color-turquoise =
    .label = Turchese
containers-color-green =
    .label = Verde
containers-color-yellow =
    .label = Jalne
containers-color-orange =
    .label = Orange
containers-color-red =
    .label = Rubie
containers-color-pink =
    .label = Rosate
containers-color-purple =
    .label = Violette
containers-color-toolbar =
    .label = Color del barra del instrumentos

containers-icon-fence =
    .label = Barriera
containers-icon-fingerprint =
    .label = Dactylogramma
containers-icon-briefcase =
    .label = Valise
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Signo de dollar
containers-icon-cart =
    .label = Carretta de compras
containers-icon-circle =
    .label = Puncto
containers-icon-vacation =
    .label = Vacantias
containers-icon-gift =
    .label = Presente
containers-icon-food =
    .label = Alimento
containers-icon-fruit =
    .label = Fructo
containers-icon-pet =
    .label = Animal domestic
containers-icon-tree =
    .label = Arbore
containers-icon-chill =
    .label = Relaxamento
