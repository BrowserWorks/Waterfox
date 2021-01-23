# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Saiba mais</span>

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

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> has no effect on this element since it’s neither a flex container nor a grid container.

inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> has no effect on this element since it’s not a flex container, a grid container, or a multi-column container.

inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> has no effect on this element since it’s not a grid or flex item.

inactive-css-not-grid-item = <strong>{ $property }</strong> has no effect on this element since it’s not a grid item.

inactive-css-not-grid-container = <strong>{ $property }</strong> has no effect on this element since it’s not a grid container.

inactive-css-not-flex-item = <strong>{ $property }</strong> has no effect on this element since it’s not a flex item.

inactive-css-not-flex-container = <strong>{ $property }</strong> has no effect on this element since it’s not a flex container.

inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong> has no effect on this element since it’s not an inline or table-cell element.

inactive-css-property-because-of-display = <strong>{ $property }</strong> has no effect on this element since it has a display of <strong>{ $display }</strong>.

inactive-css-not-display-block-on-floated = The <strong>display</strong> value has been changed by the engine to <strong>block</strong> because the element is <strong>floated<strong>.

inactive-css-property-is-impossible-to-override-in-visited = It’s impossible to override <strong>{ $property }</strong> due to <strong>:visited</strong> restriction.

inactive-css-position-property-on-unpositioned-box = <strong>{ $property }</strong> has no effect on this element since it’s not a positioned element.

inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> has no effect on this element since <strong>overflow:hidden</strong> is not set.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Experimente adicionar <strong>display:grid</strong> ou <strong>display:flex</strong>. { learn-more }

inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Experimente adicionar <strong>display:grid</strong>, <strong>display:flex</strong> ou <strong>columns:2</strong>. { learn-more }

inactive-css-not-grid-or-flex-item-fix-2 = Experimente adicionar <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong> ou <strong>display:inline-flex</strong>. { learn-more }

inactive-css-not-grid-item-fix-2 = Experimente adicionar <strong>display:grid</strong> ou <strong>display:inline-grid</strong> ao parent do elemento. { learn-more }

inactive-css-not-grid-container-fix = Experimente adicionar <strong>display:grid</strong> ou <strong>display:inline-grid</strong>. { learn-more }

inactive-css-not-flex-item-fix-2 = Experimente adicionar <strong>display:flex</strong> ou <strong>display:inline-flex</strong> ao parent do elemento. { learn-more }

inactive-css-not-flex-container-fix = Experimente adicionar <strong>display:flex</strong> ou <strong>display:inline-flex</strong>. { learn-more }

inactive-css-not-inline-or-tablecell-fix = Experimente adicionar <strong>display:inline</strong> ou <strong>display:table-cell</strong>. { learn-more }

inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Experimente adicionar <strong>display:inline-block</strong> ou <strong>display:block</strong>. { learn-more }

inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Experimente adicionar <strong>display:inline-block</strong>. { learn-more }

inactive-css-not-display-block-on-floated-fix = Experimente remover <strong>float</strong> ou adicionar <strong>display:block</strong>. { learn-more }

inactive-css-position-property-on-unpositioned-box-fix = Experimente definir sua propriedade <strong>position</strong> com algo diferente de <strong>static</strong>. { learn-more }

inactive-text-overflow-when-no-overflow-fix = Experimente adicionar <strong>overflow:hidden</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = <strong>{ $property }</strong> is not supported in the following browsers:

css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong> was an experimental property that is now deprecated by W3C standards. It is not supported in the following browsers:

css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong> era uma propriedade experimental que agora está obsoleta pelas normas W3C.

css-compatibility-deprecated-message = <strong>{ $property }</strong> está obsoleta pelas normas W3C. Não é suportada pelos seguintes navegadores:

css-compatibility-deprecated-supported-message = <strong>{ $property }</strong> está obsoleta pelas normas W3C.

css-compatibility-experimental-message = <strong>{ $property }</strong> é uma propriedade experimental. Não é suportada pelos seguintes navegadores:

css-compatibility-experimental-supported-message = <strong>{ $property }</strong> é uma propriedade experimental.

css-compatibility-learn-more-message = <span data-l10n-name="link">Saiba mais</span> sobre <strong>{ $rootProperty }</strong>
