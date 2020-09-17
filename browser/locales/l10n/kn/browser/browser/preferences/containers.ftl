# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = ಹೊಸ ಕಂಟೈನರ್ ಸೇರಿಸಿ
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = { $name } ಕಂಟೈನರ್ ಆದ್ಯತೆಗಳು
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

containers-name-label = ಹೆಸರು
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = ಕಂಟೈನರ್ ಹೆಸರು ನಮೂದಿಸಿ

containers-icon-label = ಲಾಂಛನ
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = ಬಣ್ಣ
    .accesskey = o
    .style = { -containers-labels-style }

containers-button-done =
    .label = ಆಯಿತು
    .accesskey = D

containers-color-blue =
    .label = ನೀಲಿ
containers-color-turquoise =
    .label = ಹಸಿರುನೀಲಿ
containers-color-green =
    .label = ಹಸಿರು
containers-color-yellow =
    .label = ಹಳದಿ
containers-color-orange =
    .label = ಕಿತ್ತಳೆ
containers-color-red =
    .label = ಕೆಂಪು
containers-color-pink =
    .label = ಗುಲಾಬಿ
containers-color-purple =
    .label = ನೇರಳೆ

containers-icon-fingerprint =
    .label = ಬೆರಳಚ್ಚು
containers-icon-briefcase =
    .label = ಬ್ರೀಫ್ ಕೇಸ್
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = ಡಾಲರ್ ಚಿಹ್ನೆ
containers-icon-cart =
    .label = ಶಾಪಿಂಗ್ ಬುಟ್ಟಿ
containers-icon-circle =
    .label = ಚುಕ್ಕಿ
containers-icon-vacation =
    .label = ಬಿಡುವು
containers-icon-gift =
    .label = ಕೊಡುಗೆ
containers-icon-food =
    .label = ಆಹಾರ
containers-icon-fruit =
    .label = ಹಣ್ಣು
containers-icon-pet =
    .label = ಸಾಕುಪ್ರಾಣಿ
containers-icon-tree =
    .label = ವೃಕ್ಷ
containers-icon-chill =
    .label = ಚಿಲ್
