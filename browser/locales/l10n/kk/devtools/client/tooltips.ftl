# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Көбірек білу</span>

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".
##   $display (string) - A CSS display value e.g. "inline-block".

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> бұл элементке әсер етпейді, өйткені ол flex немесе тор контейнері емес.
inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> бұл элементке әсер етпейді, өйткені ол flex, тор немесе көпбағандық контейнері емес.
inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> бұл элементке әсер етпейді, өйткені ол flex немесе тор элементі емес.
inactive-css-not-grid-item = <strong>{ $property }</strong> бұл элементке әсер етпейді, өйткені ол тор элементі емес.
inactive-css-not-grid-container = <strong>{ $property }</strong> бұл элементке әсер етпейді, өйткені ол тор контейнері емес.
inactive-css-not-flex-item = <strong>{ $property }</strong> бұл элементке әсер етпейді, өйткені ол flex элементі емес.
inactive-css-not-flex-container = <strong>{ $property }</strong> бұл элементке әсер етпейді, өйткені ол flex контейнері емес.
inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong> бұл элементке әсер етпейді, өйткені ол inline немесе кесте ұяшығы элементі емес.
inactive-css-property-because-of-display = <strong>{ $property }</strong> бұл элементке әсер етпейді, өйткені оның display қасиеті <strong>{ $display }</strong> етіп берілген.
inactive-css-not-display-block-on-floated = <strong>display</strong> қасиетінің мәні қозғалтқышпен <strong>block</strong> етіп өзгертілді, өйткені элемент <strong>қалқымалы<strong>.
inactive-css-property-is-impossible-to-override-in-visited = <strong>{ $property }</strong> қасиетін <strong>:visited</strong> шектеуі салдарынан үстінен жазу мүмкін емес.
inactive-css-position-property-on-unpositioned-box = <strong>{ $property }</strong> бұл элементке әсер етпейді, өйткені ол орны бекітілген элементі емес.
inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> бұл элементке әсер етпейді, өйткені <strong>overflow:hidden</strong> орнатылмаған.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = <strong>display:grid</strong> немесе <strong>display:flex</strong> қосып көріңіз. { learn-more }
inactive-css-not-grid-or-flex-container-or-multicol-container-fix = <strong>display:grid</strong>, <strong>display:flex</strong>, немесе <strong>columns:2</strong> қосып көріңіз. { learn-more }
inactive-css-not-grid-or-flex-item-fix-2 = <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong> немесе <strong>display:inline-flex</strong> қосып көріңіз. { learn-more }
inactive-css-not-grid-item-fix-2 = Элементтің аталық элементіне <strong>display:grid</strong> немесе <strong>display:inline-grid</strong> қосып көріңіз. { learn-more }
inactive-css-not-grid-container-fix = <strong>display:grid</strong> немесе <strong>display:inline-grid</strong> қосып көріңіз. { learn-more }
inactive-css-not-flex-item-fix-2 = Элементтің аталық элементіне <strong>display:flex</strong> немесе <strong>display:inline-flex</strong> қосып көріңіз. { learn-more }
inactive-css-not-flex-container-fix = <strong>display:flex</strong> немесе <strong>display:inline-flex</strong> қосып көріңіз. { learn-more }
inactive-css-not-inline-or-tablecell-fix = <strong>display:inline</strong> немесе <strong>display:table-cell</strong> қосып көріңіз. { learn-more }
inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = <strong>display:inline-block</strong> немесе <strong>display:block</strong> қосып көріңіз. { learn-more }
inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = <strong>display:inline-block</strong> қосып көріңіз. { learn-more }
inactive-css-not-display-block-on-floated-fix = <strong>float</strong> өшіріп немесе <strong>display:block</strong> қосып көріңіз. { learn-more }
inactive-css-position-property-on-unpositioned-box-fix = Элементтің <strong>position</strong> қасиетін <strong>static</strong> шамасынан басқа мәніне орнатып көріңіз. { learn-more }
inactive-text-overflow-when-no-overflow-fix = <strong>overflow:hidden</strong> қосып көріңіз. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-experimental-supported-message = <strong>{ $property }</strong> - эксперименталдық қасиет.
