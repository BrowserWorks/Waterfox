# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = नया पात्र जोड़े
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = { $name } पात्र प्राथमिकताएँ
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

containers-name-label = नाम
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = एक पात्र का नाम प्रविष्ट करें

containers-icon-label = प्रती‌क
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = रंग
    .accesskey = o
    .style = { -containers-labels-style }

containers-button-done =
    .label = कर दिया है
    .accesskey = D

containers-color-blue =
    .label = नीला
containers-color-turquoise =
    .label = फ़ीरोज़ी रंग
containers-color-green =
    .label = हरा
containers-color-yellow =
    .label = पीला
containers-color-orange =
    .label = नारंगी
containers-color-red =
    .label = लाल
containers-color-pink =
    .label = गुलाबी
containers-color-purple =
    .label = बैंगनी
containers-color-toolbar =
    .label = टूलबार से मिलाएं

containers-icon-fence =
    .label = घेरा
containers-icon-fingerprint =
    .label = फिंगरप्रिंट
containers-icon-briefcase =
    .label = अटैची
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = डॉलर चिन्ह
containers-icon-cart =
    .label = खरीदारी सूची
containers-icon-circle =
    .label = बिंदु
containers-icon-vacation =
    .label = छुट्टी
containers-icon-gift =
    .label = उपहार
containers-icon-food =
    .label = भोजन
containers-icon-fruit =
    .label = फल
containers-icon-pet =
    .label = पालतू पशु
containers-icon-tree =
    .label = पेड़
containers-icon-chill =
    .label = सर्द
