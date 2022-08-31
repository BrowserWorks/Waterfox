# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Aggiungi nuovo contenitore
    .style = width: 45em

containers-window-update-settings =
    .title = Impostazioni contenitore “{ $name }”
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
    .placeholder = Inserire il nome del contenitore

containers-icon-label = Icona
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = Colore
    .accesskey = C
    .style = { -containers-labels-style }

containers-dialog =
    .buttonlabelaccept = Fatto
    .buttonaccesskeyaccept = F

containers-color-blue =
    .label = Blu
containers-color-turquoise =
    .label = Turchese
containers-color-green =
    .label = Verde
containers-color-yellow =
    .label = Giallo
containers-color-orange =
    .label = Arancio
containers-color-red =
    .label = Rosso
containers-color-pink =
    .label = Rosa
containers-color-purple =
    .label = Viola
containers-color-toolbar =
    .label = Colore della barra degli strumenti

containers-icon-fence =
    .label = Recinto
containers-icon-fingerprint =
    .label = Impronta digitale
containers-icon-briefcase =
    .label = Valigetta
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Dollaro
containers-icon-cart =
    .label = Carrello
containers-icon-circle =
    .label = Punto
containers-icon-vacation =
    .label = Vacanza
containers-icon-gift =
    .label = Regalo
containers-icon-food =
    .label = Cibo
containers-icon-fruit =
    .label = Frutta
containers-icon-pet =
    .label = Cucciolo
containers-icon-tree =
    .label = Natura
containers-icon-chill =
    .label = Svago
