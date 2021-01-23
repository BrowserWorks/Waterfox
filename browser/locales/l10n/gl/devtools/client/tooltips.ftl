# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name = "link">Máis información</span>

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".
##   $display (string) - A CSS display value e.g. "inline-block".

inactive-css-not-grid-or-flex-container = <strong> { $property } </strong> non ten ningún efecto sobre este elemento, xa que non é un contedor flexible nin un contedor da grade.
inactive-css-not-grid-or-flex-container-or-multicol-container = <strong> { $property } </strong> non ten ningún efecto sobre este elemento, xa que non é un contedor flex, un contedor da grade ou un contedor de varias columnas.
inactive-css-not-grid-or-flex-item = <strong> { $property } </strong> non ten ningún efecto sobre este elemento, xa que non é un elemento da grade ou flexible.
inactive-css-not-grid-item = <strong> { $property } </strong> non ten ningún efecto sobre este elemento xa que non é un elemento da grade.
inactive-css-not-grid-container = <strong> { $property } </strong> non ten ningún efecto sobre este elemento xa que non é un contedor da grade.
inactive-css-not-flex-item = <strong> { $property } </strong> non ten ningún efecto sobre este elemento xa que non é un elemento flexible.
inactive-css-not-flex-container = <strong> { $property } </strong> non ten ningún efecto sobre este elemento xa que non é un contedor flexible.
inactive-css-not-inline-or-tablecell = <strong> { $property } </strong> non ten ningún efecto sobre este elemento, xa que non é un elemento da liña nin de celas de táboa.
inactive-css-property-because-of-display = <strong> { $property } </strong> non ten ningún efecto sobre este elemento xa que ten como display <strong{ $display }</strong>.
inactive-css-not-display-block-on-floated = O valor de <strong>display</strong> foi cambiado polo motor a <strong>block</strong> porque o elemento está <strong>flotado<strong>.
inactive-css-property-is-impossible-to-override-in-visited = É imposible anular <strong>{ $property }</strong> debido á restricción <strong>:visited</strong>.
inactive-css-position-property-on-unpositioned-box = <strong>{ $property }</strong> non ten ningún efecto sobre este elemento xa que non é un elemento posicionado.
inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> non ten ningún efecto sobre este elemento xa que <strongoverflow:hidden</strong> non está definido.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Probe a engadir <strong>display:grid</strong> ou <strong>display:flex</strong>. { learn-more }
inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Probe a engadir <strong>display:grid</strong>, <strong>display:flex</strong> ou <strong>columnsj:2</strong>. { learn-more }
inactive-css-not-grid-or-flex-item-fix-2 = Probe a engadir <strong>display>grid</strong>, <strong>display>flex</strong>, <strong>display:inline-grid</strong>, ou <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-grid-item-fix-2 = Probe a engadir <strong>display:grid</strong> ou <strong>display:inline-grid</strong> ao pai do elemento. { learn-more }
inactive-css-not-grid-container-fix = Probe a engadir <strong>display:grid</strong> ou <strong>display:inline-grid</strong>. { learn-more }
inactive-css-not-flex-item-fix-2 = Probe a engadir <strong>display:flex</strong> ou <strong>display:inline-flex</strong> ao pai do elemento. { learn-more }
inactive-css-not-flex-container-fix = Probe a engadir <strong>display:flex</strong> ou <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-inline-or-tablecell-fix = Probe a engadir <strong>display:inline</strong> ou <strong>display:table-cell</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Probe a engadir <strong>display:inline-block</strong> ou <strong>display:block</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Probe a engadir <strong>display:inline-block</strong>. { learn-more }
inactive-css-not-display-block-on-floated-fix = Probe a eliminar <strong>float</strong> ou engadir <strong>display:block</strong>. { learn-more }
inactive-css-position-property-on-unpositioned-box-fix = Probe a establecer a súa propiedade <strong>position</strong> nalgo diferente a <strong>static</strong>. { learn-more }
inactive-text-overflow-when-no-overflow-fix = Probe a engadir <strong>overflow:hidden</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = <strong>{ $property }</strong> non é admitido polos navegadores seguintes:
css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong> foi unha propiedade experimental que se considera obsoleta segundo os estándares do W3C. Non a admiten os navegadores seguintes:
css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong> foi unha propiedade experimental que agora se considera obsoleta segundo os estándares do W3C.
css-compatibility-deprecated-message = <strong>{ $property }</strong> considérase obsoleta segundo os estándares do W3C. Non a admiten os navegadores seguintes:
css-compatibility-deprecated-supported-message = <strong>{ $property }</strong> considérase obsoleta segundo os estándares do W3C.
css-compatibility-experimental-message = <strong>{ $property }</strong> é unha propiedade experimental. Non a admiten os navegadores seguintes:
css-compatibility-experimental-supported-message = <strong>{ $property }</strong> é unha propiedade experimental.
css-compatibility-learn-more-message = <span data-l10n-name="link">Saiba máis</span> sobre <strong>{ $rootProperty }</strong>
