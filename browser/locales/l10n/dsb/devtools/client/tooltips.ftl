# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Dalšne informacije</span>

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

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> njama efekt na toś ten element, dokulaž njejo daniž kontejner flex daniž kontejner grid.

inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> njama wustatkowanje na toś ten element, dokulaž njejo kontejner flex, kśidnowy kontejner abo wěcejsłupikojty kontejner.

inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> njama efekt na toś ten element, dokulaž njejo daniž zapisk grid daniž zapisk flex.

inactive-css-not-grid-item = <strong>{ $property }</strong> njama efekt na toś ten element, dokulaž njejo zapisk grid.

inactive-css-not-grid-container = <strong>{ $property }</strong> njama efekt na toś ten element, dokulaž njejo kontejner grid.

inactive-css-not-flex-item = <strong>{ $property }</strong> njama efekt na toś ten element, dokulaž njejo zapisk flex.

inactive-css-not-flex-container = <strong>{ $property }</strong> njama efekt na toś ten element, dokulaž njejo kontejner flex.

inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong> njama na toś to wustatkowanje, dokulaž element njejo element inline abo element tabeloweje cele.

inactive-css-property-because-of-display = <strong>{ $property }</strong> njama wustatkowanje na toś ten element, dokulaž ma zwobraznjenje <strong>{ $display }</strong>.

inactive-css-not-display-block-on-floated = Gódnota <strong>display</strong> jo se změnił pśez engine do <strong>block</strong>, dokulaž element jo <strong>floated<strong>.

inactive-css-property-is-impossible-to-override-in-visited = Wobgranicowanja <strong>:visited</strong> dla jo njemóžno, <strong>{ $property }</strong> pśepisaś.

inactive-css-position-property-on-unpositioned-box = <strong>{ $property }</strong> njama efekt na toś ten element, dokulaž njejo pozicioněrowany element.

inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> njama efekt na toś ten element, dokulaž gódnota <strong>overflow:hidden</strong> njejo nastajona.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Wppytajśo <strong>display:grid</strong> abo <strong>display:flex</strong> pśidaś. { learn-more }

inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Wopytajśo <strong>display:grid</strong>, <strong>display:flex</strong> abo <strong>columns:2</strong> pśidaś. { learn-more }

inactive-css-not-grid-or-flex-item-fix-2 = Wopytajśo <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong> abo <strong>display:inline-flex</strong> pśidaś. { learn-more }

inactive-css-not-grid-item-fix-2 = Wopytajśo <strong>display:grid</strong> abo <strong>display:inline-grid</strong> nadrědowanemu elementoju pśidaś. { learn-more }

inactive-css-not-grid-container-fix = Wopytajśo <strong>display:grid</strong> abo <strong>display:inline-grid</strong> pśidaś. { learn-more }

inactive-css-not-flex-item-fix-2 = Wopytajśo <strong>display:flex</strong> abo <strong>display:inline-flex</strong> nadrědowanemu elementoju pśidaś. { learn-more }

inactive-css-not-flex-container-fix = Wopytajśo <strong>display:flex</strong> abo <strong>display:inline-flex</strong> pśidaś. { learn-more }

inactive-css-not-inline-or-tablecell-fix = Wopytajśo <strong>display:inline</strong> abo <strong>display:table-cell</strong> pśidaś. { learn-more }

inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Wopytajśo <strong>display:inline-block</strong> abo <strong>display:block</strong> pśidaś. { learn-more }

inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Wopytajśo <strong>display:inline-block</strong> pśidaś. { learn-more }

inactive-css-not-display-block-on-floated-fix = Wopytajśo <strong>float</strong> wotstronić abo <strong>display:block</strong> pśidaś. { learn-more }

inactive-css-position-property-on-unpositioned-box-fix = Wopytajśo jogo kakosć <strong>position</strong> na něco druge ako <strong>static</strong> nastajiś. { learn-more }

inactive-text-overflow-when-no-overflow-fix = Wopytajśo <strong>overflow:hidden</strong> pśidaś. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = <strong>{ $property }</strong> se w slědujucych wobglědowakach njepódpěra:

css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong> jo był eksperimentelna kakosć, kótaraž jo něnto zestarjona pó W3C-standardach. Njepódpěra se w slědujucych wobglědowakach:

css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong> jo był eksperimentelna kakosć, kótaraž jo  něnto zestarjona pó W3C-standardach.

css-compatibility-deprecated-message = <strong>{ $property }</strong> jo zestarjona pó W3C-standardach. Njepódpěra se w slědujucych wobglědowakach:

css-compatibility-deprecated-supported-message = <strong>{ $property }</strong> jo zestarjona pó W3C-standardach.

css-compatibility-experimental-message = <strong>{ $property }</strong> jo eksperimentelna kakosć. Njepódpěra se w slědujucych wobglědowakach:

css-compatibility-experimental-supported-message = <strong>{ $property }</strong> jo eksperimentelna kakosć.

css-compatibility-learn-more-message = <span data-l10n-name="link">Dalšne informacije</span>wó <strong>{ $rootProperty }</strong>
