# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Zjistit více</span>

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".
##   $display (string) - A CSS display value e.g. "inline-block".

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> nemá na tento prvek žádný vliv, protože není kontejnerem pro zobrazení grid ani flex.

inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> nemá na tento prvek žádný vliv, protože není kontejnerem pro zobrazení grid ani flex, ani není kontejnerem s více sloupci.

inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> nemá na tento prvek žádný vliv, protože není prvkem zobrazení grid ani flex.

inactive-css-not-grid-item = <strong>{ $property }</strong> nemá na tento prvek žádný vliv, protože není prvkem zobrazení grid.

inactive-css-not-grid-container = <strong>{ $property }</strong> nemá na tento prvek žádný vliv, protože není kontejnerem pro zobrazení grid.

inactive-css-not-flex-item = <strong>{ $property }</strong> nemá na tento prvek žádný vliv, protože prvkem zobrazení flex.

inactive-css-not-flex-container = <strong>{ $property }</strong> nemá na tento prvek žádný vliv, protože není kontejnerem pro zobrazení flex.

inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong> nemá na tento prvek žádný vliv, protože není prvkem typu inline ani table-cell.

inactive-css-property-because-of-display = <strong>{ $property }</strong> nemá na tento prvek žádný vliv, protože má nastavenu vlastnost display s hodnotou <strong>{ $display }</strong>.

inactive-css-not-display-block-on-floated = Hodnota vlastnosti <strong>display</strong> byla automaticky nastavena na <strong>block</strong>, protože je nastavena vlastnost <strong>float</strong>.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.


## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

