# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $expiryDate (string) - date on which the colorway collection expires. When formatting this, you may omit the year, only exposing the month and day, as colorway collections will always expire within a year.
colorway-collection-expiry-label = Wygasa { DATETIME($expiryDate, month: "long", day: "numeric") }
colorway-intensity-selector-label = Intensywność
colorway-intensity-soft = Stonowana
colorway-intensity-balanced = Wyważona
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
colorway-intensity-bold = Odważna
# Label for the button to keep using the selected colorway in the browser
colorway-closet-set-colorway-button = Ustaw kolorystykę
colorway-closet-cancel-button = Anuluj
colorway-homepage-reset-prompt = Ustaw kolorową { -firefox-home-brand-name(case: "acc", capitalization: "lower") }
colorway-homepage-reset-success-message = { -firefox-home-brand-name } jest teraz stroną startową
colorway-homepage-reset-apply-button = Zastosuj
colorway-homepage-reset-undo-button = Cofnij
