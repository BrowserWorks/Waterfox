# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = הוספת מגירה חדשה
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = העדפות המגירה { $name }
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

containers-name-label = שם
    .accesskey = ש
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = נא להזין שם מגירה

containers-icon-label = סמל
    .accesskey = ס
    .style = { -containers-labels-style }

containers-color-label = צבע
    .accesskey = צ
    .style = { -containers-labels-style }

containers-button-done =
    .label = סיום
    .accesskey = ס

containers-color-blue =
    .label = כחול
containers-color-turquoise =
    .label = טורקיז
containers-color-green =
    .label = ירוק
containers-color-yellow =
    .label = צהוב
containers-color-orange =
    .label = כתום
containers-color-red =
    .label = אדום
containers-color-pink =
    .label = ורוד
containers-color-purple =
    .label = סגול

containers-icon-fence =
    .label = גדר
containers-icon-fingerprint =
    .label = טביעת אצבע
containers-icon-briefcase =
    .label = מזוודה
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = סימן דולר
containers-icon-cart =
    .label = עגלת קניות
containers-icon-circle =
    .label = נקודה
containers-icon-vacation =
    .label = חופשה
containers-icon-gift =
    .label = מתנה
containers-icon-food =
    .label = אוכל
containers-icon-fruit =
    .label = פירות
containers-icon-pet =
    .label = חיות מחמד
containers-icon-tree =
    .label = עץ
containers-icon-chill =
    .label = רגוע
