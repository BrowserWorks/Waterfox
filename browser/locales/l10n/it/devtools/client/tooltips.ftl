# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Ulteriori informazioni</span>

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

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> non ha effetto su questo elemento in quanto non è un contenitore flex o griglia.

inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> non ha effetto su questo elemento in quanto non è un contenitore flex, un contenitore griglia o un contenitore multicolonna.

inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> non ha effetto su questo elemento in quanto non è un elemento flex o griglia.

inactive-css-not-grid-item = <strong>{ $property }</strong> non ha effetto su questo elemento in quanto non è un elemento griglia.

inactive-css-not-grid-container = <strong>{ $property }</strong> non ha effetto su questo elemento in quanto non è un contenitore griglia.

inactive-css-not-flex-item = <strong>{ $property }</strong> non ha effetto su questo elemento in quanto non è un elemento flex.

inactive-css-not-flex-container = <strong>{ $property }</strong> non ha effetto su questo elemento in quanto non è un contenitore flex.

inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong> non ha effetto su questo elemento in quanto non è “inline” o “table-cell”.

inactive-css-property-because-of-display = <strong>{ $property }</strong> non ha effetto su questo elemento in quanto il valore di “display” è <strong>{ $display }</strong>.

inactive-css-not-display-block-on-floated = Il valore di <strong>display</strong> è stato modificato in <strong>block</strong> in quanto l’elemento è <strong>floated</strong>.

inactive-css-property-is-impossible-to-override-in-visited = Non è possibile ignorare <strong>{ $property }</strong> per la restrizione causata da <strong>:visited</strong>.

inactive-css-position-property-on-unpositioned-box = <strong>{ $property }</strong> non ha effetto su questo elemento in quanto non è un elemento posizionato.

inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> non ha effetto su questo elemento in quanto <strong>overflow:hidden</strong> non è impostato.

inactive-css-not-for-internal-table-elements = <strong>{ $property }</strong> non ha effetto sugli elementi interni di una tabella.

inactive-css-not-for-internal-table-elements-except-table-cells = <strong>{ $property }</strong> non ha effetto sugli elementi interni di una tabella ad eccezione delle celle.

inactive-css-not-table = <strong>{ $property }</strong> non ha effetto su questo elemento in quanto non è una tabella.

inactive-scroll-padding-when-not-scroll-container = <strong>{ $property }</strong> non ha effetto su questo elemento in quanto non prevede scorrimento (”scroll”).

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Provare ad aggiungere <strong>display:grid</strong> o <strong>display:flex</strong>. { learn-more }

inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Provare ad aggiungere <strong>display:grid</strong>, <strong>display:flex</strong> o <strong>columns:2</strong>. { learn-more }

inactive-css-not-grid-or-flex-item-fix-2 = Provare ad aggiungere <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong> o <strong>display:inline-flex</strong>. { learn-more }

inactive-css-not-grid-or-flex-item-fix-3 = Provare ad aggiungere <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong> o <strong>display:inline-flex</strong> al genitore dell’elemento. { learn-more }

inactive-css-not-grid-item-fix-2 =Provare ad aggiungere <strong>display:grid</strong> o <strong>display:inline-grid</strong> al genitore dell’elemento. { learn-more }

inactive-css-not-grid-container-fix = Provare ad aggiungere <strong>display:grid</strong> o <strong>display:inline-grid</strong>. { learn-more }

inactive-css-not-flex-item-fix-2 = Provare ad aggiungere <strong>display:flex</strong> o <strong>display:inline-flex</strong> al genitore dell’elemento. { learn-more }

inactive-css-not-flex-container-fix = Provare ad aggiungere <strong>display:flex</strong> o <strong>display:inline-flex</strong>. { learn-more }

inactive-css-not-inline-or-tablecell-fix = Provare ad aggiungere <strong>display:inline</strong> o <strong>display:table-cell</strong>. { learn-more }

inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Provare ad aggiungere <strong>display:inline-block</strong> o <strong>display:block</strong>. { learn-more }

inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Provare ad aggiungere <strong>display:inline-block</strong>. { learn-more }

inactive-css-not-display-block-on-floated-fix = Provare a rimuovere <strong>float</strong> o aggiungere <strong>display:block</strong>. { learn-more }

inactive-css-position-property-on-unpositioned-box-fix = Provare a impostare per la proprietà <strong>position</strong> un valore diverso da <strong>static</strong>. { learn-more }

inactive-text-overflow-when-no-overflow-fix = Provare ad aggiungere <strong>overflow:hidden</strong>. { learn-more }

inactive-css-not-for-internal-table-elements-fix = Provare a impostare per la proprietà <strong>display</strong> un valore diverso da <strong>table-cell</strong>, <strong>table-column</strong>, <strong>table-row</strong>, <strong>table-column-group</strong>, <strong>table-row-group</strong> o <strong>table-footer-group</strong>. { learn-more }

inactive-css-not-for-internal-table-elements-except-table-cells-fix = Provare a impostare per la proprietà <strong>display</strong> un valore diverso da <strong>table-column</strong>, <strong>table-row</strong>, <strong>table-column-group</strong>, <strong>table-row-group</strong> o <strong>table-footer-group</strong>. { learn-more }

inactive-css-not-table-fix = Provare ad aggiungere <strong>display:table</strong> o <strong>display:inline-table</strong>. { learn-more }

inactive-scroll-padding-when-not-scroll-container-fix = Provare ad aggiungere <strong>overflow:auto</strong>, <strong>overflow:scroll</strong> o <strong>overflow:hidden</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = <strong>{ $property }</strong> non è supportato nei seguenti browser:

css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong> era una proprietà sperimentale che è attualmente deprecata dagli standard W3C. Non è supportata nei seguenti browser:

css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong> era una proprietà sperimentale che è attualmente deprecata dagli standard W3C.

css-compatibility-deprecated-message = <strong>{ $property }</strong> è deprecato dagli standard W3C. Non è supportato nei seguenti browser:

css-compatibility-deprecated-supported-message = <strong>{ $property }</strong> è deprecato dagli standard W3C.

css-compatibility-experimental-message = <strong>{ $property }</strong> è una proprietà sperimentale. Non è supportata nei seguenti browser:

css-compatibility-experimental-supported-message = <strong>{ $property }</strong> è una proprietà sperimentale.

css-compatibility-learn-more-message = <span data-l10n-name="link">Ulteriori informazioni</span> su <strong>{ $rootProperty }</strong>
