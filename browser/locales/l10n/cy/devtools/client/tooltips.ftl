# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name ="link">Dysgu rhagor</span>

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

inactive-css-not-grid-or-flex-container = Nid yw <strong>{ $property }</strong> yn effeithio ar yr elfen hon gan nad yw'n gynhwysydd flex nac yn gynhwysydd grid.

inactive-css-not-grid-or-flex-container-or-multicol-container = Nid yw <strong>{ $property }</strong> yn effeithio ar yr elfen hon gan nad yw'n gynhwysydd fflecs, yn gynhwysydd grid, neu'n gynhwysydd aml-golofn.

inactive-css-not-grid-or-flex-item = Nid yw <strong>{ $property }</strong> yn effeithio ar yr elfen hon gan nad yw'n grid nac yn eitem flex.

inactive-css-not-grid-item = Nid yw <strong>{ $property }</strong> yn effeithio ar yr elfen hon gan nad yw'n eitem grid.

inactive-css-not-grid-container = Nid yw <strong>{ $property }</strong> yn effeithio ar yr elfen hon gan nad yw'n gynhwysydd grid.

inactive-css-not-flex-item = Nid yw <strong>{ $property }</strong> yn cael unrhyw effaith ar yr elfen hon gan nad yw'n eitem hyblyg.

inactive-css-not-flex-container = Nid yw <strong>{ $property }</strong> yn effeithio ar yr elfen hon gan nad yw'n gynhwysydd flex.

inactive-css-not-inline-or-tablecell = Nid yw <strong> { $property } </strong> yn cael unrhyw effaith ar yr elfen hon gan nad yw'n elfen mewnlin neu gell tabl.

inactive-css-property-because-of-display = Nid oes gan <strong>{ $property }</strong> unrhyw effaith ar yr elfen hon gan ei bod yn dangos  <strong>{ $display }</strong>.

inactive-css-not-display-block-on-floated = Mae'r peiriant wedi newid y gwerth <strong>display</strong> i <strong>block</strong> oherwydd bod yr elfen yn <strong>arnofio<strong>.

inactive-css-property-is-impossible-to-override-in-visited = Mae'n amhosib diystyru <strong>{ $property }</strong> oherwydd cyfyngiadau <strong>:visited</strong>.

inactive-css-position-property-on-unpositioned-box = Nid yw <strong>{ $property }</strong> yn effeithio ar yr elfen hon gan nad yw'n eitem wedi'i lleoli.

inactive-text-overflow-when-no-overflow = Nid yw <strong>{ $property }</strong> yn cael unrhyw effaith ar yr elfen hon gan nad yw <strong>overflow:hidden</strong> wedi'i osod.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Ceisiwch ychwanegu <strong>display:grid</strong> neu <strong>display:flex</strong>. { learn-more }

inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Ceisiwch ychwanegu naill ai <strong>display:grid</strong>, <strong>display:flex</strong>, neu <strong>columns:2</strong>. { learn-more }

inactive-css-not-grid-or-flex-item-fix-2 = Ceisiwch ychwanegu <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong> neu <strong>display:inline-flex</strong>. { learn-more }

inactive-css-not-grid-item-fix-2 = Ceisiwch ychwanegu <strong>display:grid</strong> neu <strong>display:inline-grid</strong> at riant yr elfen. { learn-more }

inactive-css-not-grid-container-fix = Ceisiwch ychwanegu <strong>display:grid</strong> neu <strong>display:inline-grid</strong>. { learn-more }

inactive-css-not-flex-item-fix-2 = Ceisiwch ychwanegu <strong>display:flex</strong> neu <strong>display:inline-flex</strong> i riant yr elfen. { learn-more }

inactive-css-not-flex-container-fix = Ceisiwch ychwanegu <strong>display:flex</strong> neu <strong>display:inline-flex</strong>. { learn-more }

inactive-css-not-inline-or-tablecell-fix = Ceisiwch ychwanegu <strong>display:inline</strong> neu <strong>display:table-cell</strong>. { learn-more }

inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Ceisiwch ychwanegu <strong>display:inline-block</strong> neu <strong>display:block</strong>. { learn-more }

inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Ceisiwch ychwanegu <strong>display:inline-block</strong>. { learn-more }

inactive-css-not-display-block-on-floated-fix = Ceisiwch dynnu <strong>float</strong> neu <strong>display:block</strong>. { learn-more }

inactive-css-position-property-on-unpositioned-box-fix = Ceisiwch osod priodwedd ei <strong>leoliad</strong> i rywbeth arall heblaw <strong>statig</strong>. { learn-more }

inactive-text-overflow-when-no-overflow-fix = Ceisiwch ychwanegu <strong>overflow:hidden</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = Nid yw <strong>{ $property }</strong> yn cael ei gefnogi gan y porwyr canlynol:

css-compatibility-deprecated-experimental-message = Roedd <strong>{ $property }</strong> yn briodoledd arbrofol sydd bellach yn cael ei anghymeradwyo gan safonau'r W3C. Nid yw'n cael ei gefnogi gan y porwyr canlynol:

css-compatibility-deprecated-experimental-supported-message = Roedd <strong>{ $property }</strong> yn briodwedd arbrofol sydd bellach yn cael ei anghymeradwyo gan safonau'r W3C.

css-compatibility-deprecated-message = Mae <strong>{ $property }</strong> yn cael ei anghymeradwyo gan safonau'r W3C. Nid yw'n cael ei gefnogi gan y porwyr canlynol:

css-compatibility-deprecated-supported-message = Mae <strong>{ $property }</strong> yn cael ei anghymeradwyo gan safonau'r W3C.

css-compatibility-experimental-message = Mae <strong>{ $property }</strong> yn briodwedd arbrofol. Nid yw'n cael ei gefnogi gan y porwyr canlynol:

css-compatibility-experimental-supported-message = Mae <strong>{ $property }</strong> yn briodwedd arbrofol.

css-compatibility-learn-more-message = <span data-l10n-name="link">Dysgu rhagor</span> am <strong>{ $rootProperty }</strong>
