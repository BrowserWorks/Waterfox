# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Saper plus</span>

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

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> non ha effecto sur iste elemento perque non es un contentor flexibile o contentor de grillia.

inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> non ha effecto sur iste elemento perque non es un contentor flexibile, contentor de grillia o contentor multi-columna.

inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> ha nulle effecto sur iste elemento pois que illo non es un elemento de flex ni de grillia.

inactive-css-not-grid-item = <strong>{ $property }</strong> ha nulle effecto sur iste elemento pois que illo non es un elemento de grillia.

inactive-css-not-grid-container = <strong>{ $property }</strong> non ha effecto sur iste elemento perque non es un contentor de grillia.

inactive-css-not-flex-item = <strong>{ $property }</strong> ha nulle effecto sur iste elemento pois que illo non es un elemento de flex.

inactive-css-not-flex-container = <strong>{ $property }</strong> non ha effecto sur iste elemento perque non es un contentor flexibile.

inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong> non ha effecto sur iste elemento perque non es un elemento “inline” o “table-cell”.

inactive-css-property-because-of-display = <strong>{ $property }</strong> ha nulle effecto sur iste elemento perque illo ha un schermo de <strong>{ $display }</strong>.

inactive-css-not-display-block-on-floated = Le motor ha cambiate le valor de <strong>display</strong> a <strong>block</strong> perque le elemento es <strong>floated<strong>.

inactive-css-property-is-impossible-to-override-in-visited = Il es impossibile supplantar <strong>{ $property }</strong> a causa de un restriction sur <strong>:visited</strong>.

inactive-css-position-property-on-unpositioned-box = <strong>{ $property }</strong> non ha effecto sur iste elemento perque non es un elemento positionate.

inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> non ha effecto sur iste elemento perque <strong>overflow:hidden</strong> non es definite.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Prova adder <strong>display:grid</strong> o <strong>display:flex</strong>. { learn-more }

inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Prova adder o <strong>display:grid</strong>, o <strong>display:flex</strong>, o <strong>columns:2</strong>. { learn-more }

inactive-css-not-grid-or-flex-item-fix-2 = Prova adder <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong>, o <strong>display:inline-flex</strong>.{ learn-more }

inactive-css-not-grid-item-fix-2 = Prova adder <strong>display:grid</strong> o <strong>display:inline-grid</strong> al genitor del elemento. { learn-more }

inactive-css-not-grid-container-fix = Prova adder <strong>display:grid</strong> o <strong>display:inline-grid</strong>. { learn-more }

inactive-css-not-flex-item-fix-2 = Prova adder <strong>display:flex</strong> o <strong>display:inline-flex</strong> al genitor del elemento. { learn-more }

inactive-css-not-flex-container-fix = Prova adder <strong>display:flex</strong> o <strong>display:inline-flex</strong>. { learn-more }

inactive-css-not-inline-or-tablecell-fix = Tenta adder <strong>display:inline</strong> o <strong>display:table-cell</strong>. { learn-more }

inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Prova adder <strong>display:inline-block</strong> o <strong>display:block</strong>. { learn-more }

inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Prova adder <strong>display:inline-block</strong>. { learn-more }

inactive-css-not-display-block-on-floated-fix = Prova remover <strong>flottar</strong> o <strong>monstrar:bloco</strong>.{ learn-more }

inactive-css-position-property-on-unpositioned-box-fix = Tenta mitter su proprietate <strong>position</strong> a un valor differente de <strong>static</strong>. { learn-more }

inactive-text-overflow-when-no-overflow-fix = Tenta adder <strong>overflow:hidden</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = <strong>{ $property }</strong> non es supportate in le sequente navigatores:

css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong> esseva un proprietate experimental e ora es rendite obsolete per le standards del W3C. Illo non es supportate in le sequente navigatores:

css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong> esseva un proprietate experimental e ora es rendite obsolete per le standards del W3C.

css-compatibility-deprecated-message = <strong>{ $property }</strong> es rendite obsolete per le standards del W3C. Illo non es supportate in le sequente navigatores:

css-compatibility-deprecated-supported-message = <strong>{ $property }</strong> es rendite obsolete per le standards del W3C.

css-compatibility-experimental-message = <strong>{ $property }</strong> es un proprietate experimental. Illo non es supportate in le sequente navigatores:

css-compatibility-experimental-supported-message = <strong>{ $property }</strong> es un proprietate experimental.

css-compatibility-learn-more-message = <span data-l10n-name="link">Lege plus</span> sur <strong>{ $rootProperty }</strong>
