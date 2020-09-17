# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = புதிய கலனைச் சேர்
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = { $name } கலன்களின் முன்னுரிமைகள்
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

containers-name-label = பெயர்
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = ஒரு கலனின் பெயரை இடுக

containers-icon-label = சின்னம்
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = நிறம்
    .accesskey = o
    .style = { -containers-labels-style }

containers-button-done =
    .label = முடிந்தது
    .accesskey = D

containers-color-blue =
    .label = நீலம்
containers-color-turquoise =
    .label = நீல பச்சை
containers-color-green =
    .label = பச்சை
containers-color-yellow =
    .label = மஞ்சள்
containers-color-orange =
    .label = செம்மஞ்சள்
containers-color-red =
    .label = சிகப்பு
containers-color-pink =
    .label = இளஞ்சிவப்பு
containers-color-purple =
    .label = ஊதா
containers-color-toolbar =
    .label = கருவிப்பட்டையை பொருத்து

containers-icon-fence =
    .label = வேலி
containers-icon-fingerprint =
    .label = கைரேகை
containers-icon-briefcase =
    .label = பெட்டி
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = டாலர் குறி
containers-icon-cart =
    .label = கடை வண்டி
containers-icon-circle =
    .label = புள்ளி
containers-icon-vacation =
    .label = விடுமுறை
containers-icon-gift =
    .label = அன்பளிப்பு
containers-icon-food =
    .label = உணவு
containers-icon-fruit =
    .label = பழம்
containers-icon-pet =
    .label = செல்லப்பிராணி
containers-icon-tree =
    .label = மரம்
containers-icon-chill =
    .label = குளிர்ச்சி
