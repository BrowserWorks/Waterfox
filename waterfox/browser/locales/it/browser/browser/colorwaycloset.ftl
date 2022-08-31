# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $expiryDate (string) - date on which the colorway collection expires. When formatting this, you may omit the year, only exposing the month and day, as colorway collections will always expire within a year.
colorway-collection-expiry-label = Scade il { DATETIME($expiryDate, month: "long", day: "numeric") }

colorway-intensity-selector-label = Intensità
colorway-intensity-soft = Delicata
colorway-intensity-balanced = Bilanciata
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
colorway-intensity-bold = Forte

# Label for the button to keep using the selected colorway in the browser
colorway-closet-set-colorway-button = Imposta tonalità
colorway-closet-cancel-button = Annulla

colorway-homepage-reset-prompt = Utilizza { -firefox-home-brand-name } per una pagina iniziale multicolore
colorway-homepage-reset-success-message = { -firefox-home-brand-name } è ora impostato come pagina iniziale
colorway-homepage-reset-apply-button = Applica
colorway-homepage-reset-undo-button = Annulla
