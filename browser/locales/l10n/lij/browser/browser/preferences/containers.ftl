# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Azonzi neuvo contegnitô
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = Preferense do Contegnitô { $name }
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

containers-name-label = Nomme
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Scrivi o nomme do contegnitô

containers-icon-label = Icöna
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = Cô
    .accesskey = C
    .style = { -containers-labels-style }

containers-button-done =
    .label = Fæto
    .accesskey = F

containers-color-blue =
    .label = Bleu
containers-color-turquoise =
    .label = Turcheize
containers-color-green =
    .label = Verde
containers-color-yellow =
    .label = Giano
containers-color-orange =
    .label = Cô de çetrón
containers-color-red =
    .label = Rosso
containers-color-pink =
    .label = Rêuza
containers-color-purple =
    .label = Pórpoa
containers-color-toolbar =
    .label = Cô da bara di atressi

containers-icon-fence =
    .label = Recinto
containers-icon-fingerprint =
    .label = Inpronta digitale
containers-icon-briefcase =
    .label = Valixe
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Segno do dòllaro
containers-icon-cart =
    .label = Carta pe acatâ
containers-icon-circle =
    .label = Ponto
containers-icon-vacation =
    .label = Vacansa
containers-icon-gift =
    .label = Regallo
containers-icon-food =
    .label = Çibbo
containers-icon-fruit =
    .label = Fruta
containers-icon-pet =
    .label = Bestia
containers-icon-tree =
    .label = Erbo
containers-icon-chill =
    .label = Fresco
