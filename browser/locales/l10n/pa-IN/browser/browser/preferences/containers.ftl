# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = ਨਵਾਂ ਕਨਟੇਨਰ ਜੋੜੋ
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = { $name } ਕਨਟੇਨਰ ਤਰਜੀਹਾਂ
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

containers-name-label = ਨਾਂ
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = ਕਨਟੇਨਰ ਨਾਂ ਭਰੋ

containers-icon-label = ਆਈਕਾਨ
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = ਰੰਗ
    .accesskey = o
    .style = { -containers-labels-style }

containers-button-done =
    .label = ਹੋ ਗਿਆ
    .accesskey = D

containers-color-blue =
    .label = ਨੀਲਾ
containers-color-turquoise =
    .label = ਮੋਰ-ਪੰਖੀਆ
containers-color-green =
    .label = ਹਰਾ
containers-color-yellow =
    .label = ਪੀਲਾ
containers-color-orange =
    .label = ਸੰਤਰੀ
containers-color-red =
    .label = ਲਾਲ
containers-color-pink =
    .label = ਗੁਲਾਬੀ
containers-color-purple =
    .label = ਬੈਂਗਣੀ
containers-color-toolbar =
    .label = ਟੂਲਬਾਰ ਨਾਲ ਮਿਲਾਓ

containers-icon-fence =
    .label = ਵਾੜ
containers-icon-fingerprint =
    .label = ਫਿੰਗਰਪਰਿੰਟ
containers-icon-briefcase =
    .label = ਸੰਦੂਕੜੀ
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = ਡਾਲਰ ਸਾਈਨ
containers-icon-cart =
    .label = ਖਰੀਦਦਾਰੀ ਰੇੜ੍ਹੀ
containers-icon-circle =
    .label = ਬਿੰਦੀ
containers-icon-vacation =
    .label = ਛੁੱਟੀਆਂ
containers-icon-gift =
    .label = ਸੁਗਾਤ
containers-icon-food =
    .label = ਖਾਣ-ਪੀਣ
containers-icon-fruit =
    .label = ਫ਼ਲ
containers-icon-pet =
    .label = ਪਾਲਤੂ
containers-icon-tree =
    .label = ਦਰੱਖਤ
containers-icon-chill =
    .label = ਠੰਢ
