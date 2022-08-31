# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = Προσθήκη νέας θεματικής ενότητας
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update-settings =
    .title = Ρυθμίσεις θεματικής ενότητας «{ $name }»
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

containers-name-label = Όνομα
    .accesskey = Ο
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = Εισαγάγετε το όνομα θεματικής ενότητας

containers-icon-label = Εικονίδιο
    .accesskey = Ε
    .style = { -containers-labels-style }

containers-color-label = Χρώμα
    .accesskey = ρ
    .style = { -containers-labels-style }

containers-dialog =
    .buttonlabelaccept = Τέλος
    .buttonaccesskeyaccept = Τ

containers-color-blue =
    .label = Μπλε
containers-color-turquoise =
    .label = Τιρκουάζ
containers-color-green =
    .label = Πράσινο
containers-color-yellow =
    .label = Κίτρινο
containers-color-orange =
    .label = Πορτοκαλί
containers-color-red =
    .label = Κόκκινο
containers-color-pink =
    .label = Ροζ
containers-color-purple =
    .label = Μοβ
containers-color-toolbar =
    .label = Αντιστοίχιση με γραμμή εργαλείων

containers-icon-fence =
    .label = Περίφραξη
containers-icon-fingerprint =
    .label = Αποτύπωμα
containers-icon-briefcase =
    .label = Χαρτοφύλακας
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = Σήμα δολαρίου
containers-icon-cart =
    .label = Καλάθι αγορών
containers-icon-circle =
    .label = Κουκκίδα
containers-icon-vacation =
    .label = Διακοπές
containers-icon-gift =
    .label = Δώρο
containers-icon-food =
    .label = Φαγητό
containers-icon-fruit =
    .label = Φρούτα
containers-icon-pet =
    .label = Κατοικίδιο
containers-icon-tree =
    .label = Δέντρο
containers-icon-chill =
    .label = Ξεκούραση
