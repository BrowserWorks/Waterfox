# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Más información</span>

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".
##   $display (string) - A CSS display value e.g. "inline-block".

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> no tiene ningún efecto en este elemento ya que no es un contenedor flex ni un contenedor de rejilla.
inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> no tiene ningún efecto en este elemento, ya que no es un contenedor flex, un contenedor grid o un contenedor multicolumna.
inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> no tiene ningún efecto en este elemento ya que no es un un ítem grid ni flex.
inactive-css-not-grid-item = <strong>{ $property }</strong> no tiene ningún efecto en este elemento ya que no es un ítem grid.
inactive-css-not-grid-container = <strong>{ $property }</strong> no tiene ningún efecto en este elemento ya que no es un contenedor grid.
inactive-css-not-flex-item = <strong>{ $property }</strong> no tiene ningún efecto en este elemento ya que no es un ítem flex.
inactive-css-not-flex-container = <strong>{ $property }</strong> no tiene ningún efecto en este elemento ya que no es un contenedor flex.
inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong> no tiene ningún efecto en este elemento ya que no es un elemento en línea o  de celda de tabla.
inactive-css-property-because-of-display = <strong>{ $property }</strong> no tiene ningún efecto en este elemento ya que su valor de "display" es <strong>{ $display }</strong>.
inactive-css-not-display-block-on-floated = El motor cambió el valor de <strong>display</strong> a <strong>block</strong> porque el elemento es <strong>floated</strong>.
inactive-css-property-is-impossible-to-override-in-visited = No es posible anular <strong>{ $property }</strong> debido a la restricción <strong>:visited</strong>.
inactive-css-position-property-on-unpositioned-box = <strong>{ $property }</strong> no tiene efecto en este elemento ya que no es un elemento posicionado.
inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> no tiene ningún efecto en este elemento ya que <strong>overflow:hidden</strong> no está establecido.
inactive-outline-radius-when-outline-style-auto-or-none = <strong>{ $property }</strong> no tiene ningún efecto en este elemento porque su <strong>outline-style</strong> es <strong>auto</strong> o <strong>none</strong>.
inactive-css-not-for-internal-table-elements = <strong>{ $property }</strong> no tiene efecto en elementos internos de la tabla.
inactive-css-not-for-internal-table-elements-except-table-cells = <strong>{ $property }</strong> no tiene efecto en elementos internos de la tabla excepto en celdas de la tabla.
inactive-css-not-table = <strong>{ $property }</strong> no tiene efecto en este elemento ya que no es una tabla.
inactive-scroll-padding-when-not-scroll-container = <strong>{ $property }</strong> no tiene efecto en este elemento ya que no tiene desplazamiento.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Intenta agregar <strong>display:grid</strong> o <strong>display:flex</strong>. { learn-more }
inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Intenta agregar <strong>display:grid</strong>, <strong>display:flex</strong>, o <strong>columns:2</strong>. { learn-more }
inactive-css-not-grid-or-flex-item-fix-2 = Intenta agregar <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong> o <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-grid-item-fix-2 = Intenta agregar <strong>display:grid</strong> o <strong>display:inline-grid</strong> al padre del item. { learn-more }
inactive-css-not-grid-container-fix = Intenta agregar <strong>display:grid</strong> o <strong>display:inline-grid</strong>. { learn-more }
inactive-css-not-flex-item-fix-2 = Intenta agregar <strong>display:flex</strong> o <strong>display:inline-flex</strong> al padre del elemento. { learn-more }
inactive-css-not-flex-container-fix = Intenta agregar <strong>display:flex</strong> o <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-inline-or-tablecell-fix = Intenta agregar <strong>display:inline</strong> o <strong>display:table-cell</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Intenta agregar <strong>display:inline-block</strong> o <strong>display:block</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Intenta agregar <strong>display:inline-block</strong>. { learn-more }
inactive-css-not-display-block-on-floated-fix = Intenta eliminar <strong>float</strong> o agrega <strong>display:block</strong>. { learn-more }
inactive-css-position-property-on-unpositioned-box-fix = Intenta establecer la propiedad <strong>position</strong> en algo diferente a <strong>static</strong>. { learn-more }
inactive-text-overflow-when-no-overflow-fix = Intenta agregar <strong>overflow:hidden</strong>. { learn-more }
inactive-css-not-for-internal-table-elements-fix = Prueba configurar su propiedad <strong>mostrar</strong> a algo distinto de <strong>table-cell</strong>, <strong>tabla-celda</strong>, <strong>tabla-columna</strong>, <strong>tabla-fila>, <strong>table-grupo-tabla-pie de página</strong>. { learn-more }
inactive-css-not-for-internal-table-elements-except-table-cells-fix = Prueba establecer su propiedad <strong>mostrar</strong> a algo diferente de<strong>tabla-columna</strong>, <strong>table-fila</strong>, <strong>table-de gupo de-columnas</strong>, <strong>tabla-de grupo de-filas</strong> o <strong>tabla de grupo de pies de página</strong>. { learn-more }
inactive-outline-radius-when-outline-style-auto-or-none-fix = Prueba a cambiar la propiedad <strong>outline-style</strong> a algo diferente a <strong>auto</strong> o <strong>none</strong>. { learn-more }
inactive-css-not-table-fix = Intenta agregar <strong>display:table</strong> o <strong>display:inline-table</strong>. { learn-more }
inactive-scroll-padding-when-not-scroll-container-fix = Intenta agregar <strong>overflow:auto</strong>,<strong>overflow:scrooll</strong>, o<strong>overflow:hidden</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = <strong>{ $property }</strong> no está soportado en los siguientes navegadores:
css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong> era una propiedad experimental y ahora está obsoleta según el estándar W3C. No es compatible con los siguientes navegadores:
css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong> era una propiedad experimental y ahora está obsoleta según el estándar W3C.
css-compatibility-deprecated-message = <strong>{ $property }</strong> está obsoleta según el estándar W3C. No es compatible con los siguientes navegadores:
css-compatibility-deprecated-supported-message = <strong>{ $property }</strong> está obsoleta según el estándar W3C.
css-compatibility-experimental-message = <strong>{ $property }</strong> era una propiedad experimental. No es compatible con los siguientes navegadores:
css-compatibility-experimental-supported-message = <strong>{ $property }</strong> era una propiedad experimental.
css-compatibility-learn-more-message = <span data-l10n-name="link">Conocer más</span> sobre <strong>{ $rootProperty }</strong>
