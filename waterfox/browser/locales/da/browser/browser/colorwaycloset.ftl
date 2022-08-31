# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $expiryDate (string) - date on which the colorway collection expires. When formatting this, you may omit the year, only exposing the month and day, as colorway collections will always expire within a year.
colorway-collection-expiry-label = Udløber { DATETIME($expiryDate, month: "long", day: "numeric") }
colorway-intensity-selector-label = Intensitet
colorway-intensity-soft = Blød
colorway-intensity-balanced = Balanceret
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
colorway-intensity-bold = Dristig
# Label for the button to keep using the selected colorway in the browser
colorway-closet-set-colorway-button = Indstil farvekombination
colorway-closet-cancel-button = Annuller
colorway-homepage-reset-prompt = Gør { -firefox-home-brand-name } til din farverige startside
colorway-homepage-reset-success-message = { -firefox-home-brand-name } er nu din startside
colorway-homepage-reset-apply-button = Anvend
colorway-homepage-reset-undo-button = Fortryd
