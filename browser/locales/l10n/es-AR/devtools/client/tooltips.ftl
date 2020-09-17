# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link"> Conocer más</span>

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

inactive-css-not-grid-or-flex-container = <strong> { $property }</strong> no tiene ningún efecto en este elemento, ya que no es un contenedor flexible ni un contenedor de grilla.

inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> no tiene ningún efecto en este elemento, ya que no es un contenedor flexible, un contenedor de cuadrícula ni un contenedor multi columnas.

inactive-css-not-grid-or-flex-item = <strong> { $property }</strong> no tiene ningún efecto en este elemento, ya que no es una cuadrícula ni un elemento flexible.

inactive-css-not-grid-item = <strong>{ $property }</strong> no tiene efecto en este elemento ya que no es un elemento de la cuadrícula.

inactive-css-not-grid-container = <strong>{ $property }</strong> no tiene efecto en este elemento ya que no es un contenedor de cuadrícula.

inactive-css-not-flex-item = <strong>{ $property }</strong> no tiene ningún efecto en este elemento, ya que no es un elemento flexible.

inactive-css-not-flex-container = <strong>{ $property }</strong> no tiene ningún efecto en este elemento, ya que no es un contenedor flexible.

inactive-css-not-inline-or-tablecell = <strong> { $property }</strong> no tiene ningún efecto en este elemento, ya que no es un elemento en línea o de celda de tabla.

inactive-css-property-because-of-display = { $property }{ $property }</strong> no tiene efecto en este elemento, ya que tiene una visualización de <strong>{ $display }</strong>.

inactive-css-not-display-block-on-floated = El motor cambió el valor de <strong> visualización </strong> a <strong> bloque </strong> porque el elemento está <strong> flotando <strong>.

inactive-css-property-is-impossible-to-override-in-visited = Es imposible anular <strong>{ $property }</strong> debido a la restricción <strong>:visitada </strong>.

inactive-css-position-property-on-unpositioned-box = <strong> { $property }</strong> no tiene efecto en este elemento ya que no es un elemento posicionado.

inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> no tiene efecto en este elemento porque <strong>overflow:hidden</strong> no está establecido.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Intente agregar <strong>display:grid</strong> o <strong>display:flex</strong>. { learn-more }

inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Intente agregando <strong> display: grid </strong>, <strong> display: flex </strong> o <strong> columnas: 2 </strong>. { learn-more }

inactive-css-not-grid-or-flex-item-fix-2 = Pruebe agregar <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong> o <strong>display:inline-flex</strong>. { learn-more }

inactive-css-not-grid-item-fix-2 = Pruebe agregar <strong>display:grid</strong> o <strong>display:inline-grid</strong> al padre del item. { learn-more }

inactive-css-not-grid-container-fix = Intente agregar <strong>display:grid</strong> o <strong>display:inline-grid</strong>. { learn-more }

inactive-css-not-flex-item-fix-2 = Pruebe agregar <strong>display:flex</strong> o <strong>display:inline-flex</strong> al padre del elemento. { learn-more }

inactive-css-not-flex-container-fix = Intente agregar <strong>display:flex</strong> o <strong>display:inline-flex</strong>. { learn-more }

inactive-css-not-inline-or-tablecell-fix = Intente agregar <strong>display:inline</strong> o <strong>display:table-cell</strong>. { learn-more }

inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Pruebe a añadir <strong>display:inline-block</strong> o <strong>display:block</strong>. { learn-more }

inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Pruebe a añadir <strong>display:inline-block</strong>. { learn-more }

inactive-css-not-display-block-on-floated-fix = Intente eliminar <strong>flotante</strong> o agregue<strong> display:block </strong>. { learn-more }

inactive-css-position-property-on-unpositioned-box-fix = Intente establecer la propiedad de<strong> posición </strong> en algo más que <strong>la estática </strong>. { learn-more }

inactive-text-overflow-when-no-overflow-fix = Intente agregar <strong>overflow:hidden</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = <strong>{ $property }</strong> no está soportado en los siguientes navegadores:

css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong> fue una propiedad experimental que ahora es obsoleta según los estándares de W3C. No está soportada en los siguientes navegadores:

css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong> fue una propiedad experimental que ahora es obsoleta según los estándares de W3C.

css-compatibility-deprecated-message = <strong>{ $property }</strong> es obsoleto según los estándares de W3C. No está soportado en los siguientes navegadores:

css-compatibility-deprecated-supported-message = <strong>{ $property }</strong> es obsoleto según los estándares de W3C.

css-compatibility-experimental-message = <strong>{ $property }</strong> es una propiedad experimental. No está soportada en los siguientes navegadores:

css-compatibility-experimental-supported-message = <strong>{ $property }</strong> es una propiedad experimental.

css-compatibility-learn-more-message = <span data-l10n-name="link">Conocer más</span> sobre <strong>{ $rootProperty }</strong>
