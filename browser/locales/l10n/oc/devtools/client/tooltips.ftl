# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Ne saber mai</span>

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

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> a pas cap d’efèit sus aqueste element per çò que es pas un contenidor flex nimai un contenidor grid.

inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> a pas cap d’efèit sus aqueste element per çò que es pas un contenidor flex, ni un contenidor grid o un contenidor multi-colomna.

inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> a pas cap d’efèit sus aqueste element per çò que es pas un element flex nimai grid.

inactive-css-not-grid-item = <strong>{ $property }</strong> a pas cap d’efèit sus aqueste element per çò que es pas un element grid.

inactive-css-not-grid-container = <strong>{ $property }</strong> a pas cap d’efèit sus aqueste element per çò que es pas un contenidor grid.

inactive-css-not-flex-item = <strong>{ $property }</strong> a pas cap d’efèit sus aqueste element per çò que es pas un element flex.

inactive-css-not-flex-container = <strong>{ $property }</strong> a pas cap d’efèit sus aqueste element per çò que es pas un contenidor flex.

inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong> a pas cap d’efèit sus aqueste element per çò que es pas un element « inline » o element « table-cell ».

inactive-css-property-because-of-display = <strong>{ $property }</strong> a pas cap d’efèit sus aqueste element per çò que sa proprietat « display » val <strong>{ $display }</strong>.

inactive-css-not-display-block-on-floated = La valor <strong>display</strong> es estada modificada pel motor en <strong>block</strong> perque l’element es <strong>floated<strong>.

inactive-css-property-is-impossible-to-override-in-visited = Es pas possible de subrecargar <strong>{ $property }</strong> a causa de la restriccion <strong>:visited</strong>.

inactive-css-position-property-on-unpositioned-box = <strong>{ $property }</strong> a pas cap d’efèit sus aqueste element per çò que es pas un element posicionat.

inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> a pas cap d’efèit sus aqueste element per çò que <strong>overflow:hidde</strong> es pas definit.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Ensajatz d’apondre <strong>display:grid</strong> o <strong>display:flex</strong>. { learn-more }

inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Ensajatz d’apondre siá <strong>display:grid</strong>, <strong>display:flex</strong>, o <strong>columns:2</strong>. { learn-more }

inactive-css-not-grid-or-flex-item-fix-2 = Ensajatz d’apondre <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong>, o <strong>display:inline-flex</strong>. { learn-more }

inactive-css-not-grid-item-fix-2 = Ensajatz d’apondre <strong>display:grid</strong> o <strong>display:inline-grid</strong> al parent de l’element. { learn-more }

inactive-css-not-grid-container-fix = Ensajatz d’apondre <strong>display:grid</strong> o <strong>display:inline-grid</strong>. { learn-more }

inactive-css-not-flex-item-fix-2 = Ensajatz d’apondre <strong>display:flex</strong> or <strong>display:inline-flex</strong> al parent de l’element. { learn-more }

inactive-css-not-flex-container-fix = Ensajatz d’apondre <strong>display:flex</strong> o <strong>display:inline-flex</strong>. { learn-more }

inactive-css-not-inline-or-tablecell-fix = Ensajatz d’apondre <strong>display:inline</strong> o <strong>display:table-cell</strong>. { learn-more }

inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Ensajatz d’apondre <strong>display:inline-block</strong> o <strong>display:block</strong>. { learn-more }

inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Ensajatz d’apondre <strong>display:inline-block</strong>. { learn-more }

inactive-css-not-display-block-on-floated-fix = Ensajatz de tirar <strong>float</strong> o d’apondre adding <strong>display:block</strong>. { learn-more }

inactive-css-position-property-on-unpositioned-box-fix = Ensajar de definir sa proprietat <strong>position</strong> amb una valor diferenta de <strong>static</strong>. { learn-more }

inactive-text-overflow-when-no-overflow-fix = Ensajatz d’apondre <strong>overflow:hidden</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = <strong>{ $property }</strong> es pas compatibla amb los navegadors seguents :

css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong> èra una proprietat experimentala qu’es ara obsolèta segon los estandards del W3C. Es pas compatibla amb los navegadors seguent :

css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong> èra una proprietat experimentala qu’es ara obsolèta segon los estandards del W3C.

css-compatibility-deprecated-message = <strong>{ $property }</strong> es obsolèta segon los estandards del W3C. Es pas compatibla amb los navegadors seguent :

css-compatibility-deprecated-supported-message = <strong>{ $property }</strong> es obsolèta segon los estandards W3C.

css-compatibility-experimental-message = <strong>{ $property }</strong> es una proprietat experimentala. Es pas compatibla amb los navegadors seguent :

css-compatibility-experimental-supported-message = <strong>{ $property }</strong> es una proprietat experimentala.

css-compatibility-learn-more-message = <span data-l10n-name="link">Ne saber mai</span> sus <strong>{ $rootProperty }</strong>
