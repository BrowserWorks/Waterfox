# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Докладніше</span>

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

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> не впливає на цей елемент, тому що він не є контейнером flex чи grid.

inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> не впливає на цей елемент, тому що він не є контейнером flex, grid, чи multi-column.

inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> не впливає на цей елемент, тому що він не є елементом grid чи flex.

inactive-css-not-grid-item = <strong>{ $property }</strong> не впливає на цей елемент, тому що він не є елементом grid.

inactive-css-not-grid-container = <strong>{ $property }</strong> не впливає на цей елемент, тому що він не є контейнером grid.

inactive-css-not-flex-item = <strong>{ $property }</strong> не впливає на цей елемент, тому що він не є елементом flex.

inactive-css-not-flex-container = <strong>{ $property }</strong> не впливає на цей елемент, тому що він не є контейнером flex.

inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong> не впливає на цей елемент, тому що він не є inline чи table-cell елементом.

inactive-css-property-because-of-display = <strong>{ $property }</strong> не впливає на цей елемент, тому що він має відображення <strong>{ $display }</strong>.

inactive-css-not-display-block-on-floated = Значення <strong>display</strong> було замінено рушієм на <strong>block</strong>, тому що цей елемент <strong>floated<strong>.

inactive-css-property-is-impossible-to-override-in-visited = Неможливо перевизначити <strong>{ $property }</strong>, у зв'язку з обмеженням <strong>:visited</strong>.

inactive-css-position-property-on-unpositioned-box = <strong>{ $property }</strong> не впливає на цей елемент, тому що це не позиціонований елемент.

inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> не впливає на цей елемент, оскільки не встановлено <strong>overflow:hidden</strong>.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Спробуйте додати <strong>display:grid</strong> або <strong>display:flex</strong>. { learn-more }

inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Спробуйте додати <strong>display:grid</strong>, <strong>display:flex</strong>, або <strong>columns:2</strong>. { learn-more }

inactive-css-not-grid-or-flex-item-fix-2 = Спробуйте додати <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong>, або <strong>display:inline-flex</strong>. { learn-more }

inactive-css-not-grid-item-fix-2 = Спробуйте додати <strong>display:grid</strong> або <strong>display:inline-grid</strong> до елемента вищого рівня. { learn-more }

inactive-css-not-grid-container-fix = Спробуйте додати <strong>display:grid</strong> або <strong>display:inline-grid</strong>. { learn-more }

inactive-css-not-flex-item-fix-2 = Спробуйте додати <strong>display:flex</strong> або <strong>display:inline-flex</strong> до елемента вищого рівня. { learn-more }

inactive-css-not-flex-container-fix = Спробуйте додати <strong>display:flex</strong> або <strong>display:inline-flex</strong>. { learn-more }

inactive-css-not-inline-or-tablecell-fix = Спробуйте додати <strong>display:inline</strong> або <strong>display:table-cell</strong>. { learn-more }

inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Спробуйте додати <strong>display:inline-block</strong> або <strong>display:block</strong>. { learn-more }

inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Спробуйте додати <strong>display:inline-block</strong>. { learn-more }

inactive-css-not-display-block-on-floated-fix = Спробуйте вилучити <strong>float</strong> або додати <strong>display:block</strong>. { learn-more }

inactive-css-position-property-on-unpositioned-box-fix = Спробуйте налаштувати його властивість <strong>позиції</strong> на щось інше, ніж <strong>static</strong>. { learn-more }

inactive-text-overflow-when-no-overflow-fix = Спробуйте додати <strong>overflow:hidden</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = <strong>{ $property }</strong> не підтримується такими браузерами:

css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong> була експериментальною властивістю, яка тепер застаріла за стандартами W3C. Не підтримується такими браузерами:

css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong> була експериментальною властивістю, яка тепер застаріла за стандартами W3C.

css-compatibility-deprecated-message = <strong>{ $property }</strong> застаріла за стандартами W3C. Не підтримується такими браузерами:

css-compatibility-deprecated-supported-message = <strong>{ $property }</strong> застаріла за стандартами W3C.

css-compatibility-experimental-message = <strong>{ $property }</strong> - експериментальна властивість. Не підтримується такими браузерами:

css-compatibility-experimental-supported-message = <strong>{ $property }</strong> - експериментальна властивість.

css-compatibility-learn-more-message = <span data-l10n-name="link">Докладніше</span> про <strong>{ $rootProperty }</strong>
