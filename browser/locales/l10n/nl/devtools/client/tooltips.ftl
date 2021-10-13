# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Meer informatie</span>

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".
##   $display (string) - A CSS display value e.g. "inline-block".

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> heeft geen effect op dit element aangezien het geen flexcontainer of gridcontainer is.

inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> heeft geen effect op dit element, omdat het geen flex-container, grid-container of een container met meerdere kolommen is.

inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> heeft geen effect op dit element aangezien het geen grid- of flexitem is.

inactive-css-not-grid-item = <strong>{ $property }</strong> heeft geen effect op dit element aangezien het geen griditem is.

inactive-css-not-grid-container = <strong>{ $property }</strong> heeft geen effect op dit element aangezien het geen gridcontainer is.

inactive-css-not-flex-item = <strong>{ $property }</strong> heeft geen effect op dit element aangezien het geen flexitem is.

inactive-css-not-flex-container = <strong>{ $property }</strong> heeft geen effect op dit element aangezien het geen flexcontainer is.

inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong> heeft geen effect op dit element, omdat het geen inline of table-cell-element is.

inactive-css-property-because-of-display = <strong>{ $property }</ strong> heeft geen effect op dit element, omdat het een weergave van <strong>{ $display }</ strong> heeft.

inactive-css-not-display-block-on-floated = De waarde <strong>display</strong> is door de engine in <strong>block</strong> gewijzigd omdat het element <strong>floated</strong> is.

inactive-css-property-is-impossible-to-override-in-visited = Het is onmogelijk om <strong>{ $property }</strong> te overschrijven vanwege de beperking <strong>:visited</strong>.

inactive-css-position-property-on-unpositioned-box = <strong>{ $property }</strong> heeft geen effect op dit element aangezien het geen gepositioneerd element is.

inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> heeft geen effect op dit element, aangezien <strong>overflow:hidden</strong> niet is ingesteld.

inactive-css-not-for-internal-table-elements = <strong>{ $property }</strong> heeft geen effect op interne tabelelementen.

inactive-css-not-for-internal-table-elements-except-table-cells = <strong>{ $property }</strong> heeft geen effect op interne tabelelementen, behalve op tabelcellen.

inactive-css-not-table = <strong>{ $property }</strong> heeft geen effect op dit element aangezien het geen tabel is.

inactive-scroll-padding-when-not-scroll-container = <strong>{ $property }</strong> heeft geen effect op dit element aangezien het niet scrollt.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Probeer <strong>display:grid</strong> of <strong>display:flex</strong> toe te voegen. { learn-more }

inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Probeer <strong>display:grid</strong>, <strong>display:flex</strong> of <strong>colums:2</strong> toe te voegen. { learn-more }

inactive-css-not-grid-or-flex-item-fix-2 = Probeer <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong> of <strong>display:inline-flex</strong> toe te voegen. { learn-more }

inactive-css-not-grid-or-flex-item-fix-3 = Probeer <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong> of <strong>display:inline-flex</strong> aan het bovenliggende niveau van het element toe te voegen. { learn-more }

inactive-css-not-grid-item-fix-2 = Probeer <strong>display:grid</strong> of <strong>display:inline-grid</strong> aan het bovenliggende element toe te voegen. { learn-more }

inactive-css-not-grid-container-fix = Probeer <strong>display:grid</strong> of <strong>display:inline-grid</strong> toe te voegen. { learn-more }

inactive-css-not-flex-item-fix-2 = Probeer <strong>display:flex</strong> of <strong>display:inline-flex</strong> aan het bovenliggende element toe te voegen. { learn-more }

inactive-css-not-flex-container-fix = Probeer <strong>display:flex</strong> of <strong>display:inline-flex</strong> toe te voegen. { learn-more }

inactive-css-not-inline-or-tablecell-fix = Probeer <strong>display:inline</strong> of <strong>display:table-cell</strong> toe te voegen. { learn-more }

inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Probeer <strong>display:inline-block</ strong> of <strong>display:block</ strong> toe te voegen. { learn-more }

inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Probeer <strong>display:inline-block</ strong> toe te voegen. { learn-more }

inactive-css-not-display-block-on-floated-fix = Probeer <strong>float</strong> te verwijderen of <strong>display:block</strong> toe te voegen. { learn-more }

inactive-css-position-property-on-unpositioned-box-fix = Probeer de eigenschap <strong>position</strong> op iets anders dan <strong>static</strong> in te stellen. { learn-more }

inactive-text-overflow-when-no-overflow-fix = Probeer <strong>overflow:hidden</strong> toe te voegen. { learn-more }

inactive-css-not-for-internal-table-elements-fix = Probeer de property <strong>display</strong> op iets anders dan <strong>table-cell</strong>, <strong>table-column</strong>, <strong>table-row</strong>, <strong>table-column-group</strong>, <strong>table-row-group</strong> of <strong>table-footer-group</strong> in te stellen. { learn-more }

inactive-css-not-for-internal-table-elements-except-table-cells-fix = Probeer de property <strong>display</strong> op iets anders dan <strong>table-column</strong>, <strong>table-row</strong>, <strong>table-column-group</strong>, <strong>table-row-group</strong> of <strong>table-footer-group</strong> in te stellen. { learn-more }

inactive-css-not-table-fix = Probeer <strong>display:table</strong> of <strong>display:inline-table</strong> toe te voegen. { learn-more }

inactive-scroll-padding-when-not-scroll-container-fix = Probeer <strong>overflow:auto</strong>, <strong>overflow:scroll</strong> of <strong>overflow:hidden</strong> toe te voegen. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = <strong>{ $property }</strong> wordt niet ondersteund in de volgende browsers:

css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong> was een experimentele property die volgens de W3C-standaarden nu is verouderd. Hij wordt niet ondersteund in de volgende browsers:

css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong> was een experimentele property die volgens de W3C-standaarden nu is verouderd.

css-compatibility-deprecated-message = <strong>{ $property }</strong> is verouderd volgens W3C-standaarden. Het wordt niet ondersteund in de volgende browsers:

css-compatibility-deprecated-supported-message = <strong>{ $property }</strong> is verouderd volgens W3C-normen.

css-compatibility-experimental-message = <strong>{ $property }</strong> is een experimentele property. Hij wordt niet ondersteund in de volgende browsers:

css-compatibility-experimental-supported-message = <strong>{ $property }</strong> is een experimentele property.

css-compatibility-learn-more-message = <span data-l10n-name="link">Meer info</span> over <strong>{ $rootProperty }</strong>
