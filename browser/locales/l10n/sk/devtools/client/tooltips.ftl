# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Ďalšie informácie</span>

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".


## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".
##   $display (string) - A CSS display value e.g. "inline-block".

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> nemá na tento prvok žiadny vplyv, pretože nejde ani o flex kontajner ani o grid kontajner.

inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> nemá na tento prvok žiadny vplyv, pretože nejde ani o flex kontajner, grid kontajner či kontajner s viacerými stĺpcami.

inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> nemá na tento prvok žiadny vplyv, pretože nejde o grid ani flex položku.

inactive-css-not-grid-item = <strong>{ $property }</strong> nemá na tento prvok žiadny vplyv, pretože nejde o grid položku.

inactive-css-not-grid-container = <strong>{ $property }</strong> nemá na tento prvok žiadny vplyv, pretože nejde o grid kontajner.

inactive-css-not-flex-item = <strong>{ $property }</strong> nemá na tento prvok žiadny vplyv, pretože nejde o flex položku.

inactive-css-not-flex-container = <strong>{ $property }</strong> nemá na tento prvok žiadny vplyv, pretože nejde o flex kontajner.

inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong> nemá na tento prvok žiadny vplyv, pretože nejde o vložený prvok ani prvok tabuľky.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Skúste pridať <strong>display:grid</strong> alebo <strong>display:flex</strong>. { learn-more }

inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Skúste pridať <strong>display:grid</strong>, <strong>display:flex</strong> alebo <strong>columns:2</strong>. { learn-more }

inactive-css-not-grid-or-flex-item-fix-2 = Skúste pridať <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong> alebo <strong>display:inline-flex</strong>. { learn-more }

inactive-css-not-grid-item-fix-2 = Skúste pridať <strong>display:grid</strong> alebo <strong>display:inline-grid</strong> do nadradenej položky. { learn-more }

inactive-css-not-grid-container-fix = Skúste pridať <strong>display:grid</strong> alebo <strong>display:inline-grid</strong>. { learn-more }

inactive-css-not-flex-item-fix-2 = Skúste pridať <strong>display:flex</strong> alebo <strong>display:inline-flex</strong> do nadradenej položky. { learn-more }

inactive-css-not-flex-container-fix = Skúste pridať <strong>display:flex</strong> alebo <strong>display:inline-flex</strong>. { learn-more }

inactive-css-not-inline-or-tablecell-fix = Skúste pridať <strong>display:inline</strong> alebo <strong>display:table-cell</strong>. { learn-more }

inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Skúste pridať <strong>display:inline-block</strong> alebo <strong>display:block</strong>. { learn-more }

inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Skúste pridať <strong>display:inline-block</strong>. { learn-more }

inactive-css-not-display-block-on-floated-fix = Skúste odstrániť <strong>float</strong> alebo pridať <strong>display:block</strong>. { learn-more }

inactive-text-overflow-when-no-overflow-fix = Skúste pridať <strong>overflow:hidden</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

