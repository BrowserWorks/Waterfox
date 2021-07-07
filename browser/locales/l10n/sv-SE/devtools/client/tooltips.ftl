# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Läs mer</span>

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".
##   $display (string) - A CSS display value e.g. "inline-block".

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> har ingen effekt på det här elementet eftersom det varken är en flexbehållare eller en rutnätsbehållare.
inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> har ingen effekt på det här elementet eftersom det inte är en flexbehållare, en rutnätsbehållare eller en behållare med flera kolumner.
inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> har ingen effekt på det här elementet eftersom det inte är ett rutnät eller ett flex-objekt.
inactive-css-not-grid-item = <strong>{ $property }</strong> har ingen effekt på det här elementet eftersom det inte är ett rutnätsobjekt.
inactive-css-not-grid-container = <strong>{ $property }</strong> har ingen effekt på detta element eftersom det inte är en rutnätsbehållare.
inactive-css-not-flex-item = <strong>{ $property }</strong> har ingen effekt på det här elementet eftersom det inte är ett flex-objekt.
inactive-css-not-flex-container = <strong>{ $property }</strong> har ingen effekt på detta element eftersom det inte är en flexbehållare.
inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong> har ingen effekt på detta element eftersom det inte är ett inline- eller table-cellelement.
inactive-css-property-because-of-display = <strong>{ $property }</strong> har ingen effekt på det här elementet eftersom den har en visning av <strong>{ $display }</strong>.
inactive-css-not-display-block-on-floated = Värdet <strong>display</strong> har ändrats av motorn till <strong>block</strong> eftersom elementet är <strong>floated</strong>.
inactive-css-property-is-impossible-to-override-in-visited = Det är omöjligt att skriva över <strong>{ $property }</strong> på grund av begränsningen <strong>:visited</strong>.
inactive-css-position-property-on-unpositioned-box = <strong>{ $property }</strong> har ingen effekt på detta element eftersom det inte är ett positionerat element.
inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> har ingen effekt på detta element eftersom <strong>overflow:hidden</strong> inte är satt.
inactive-outline-radius-when-outline-style-auto-or-none = <strong>{ $property }</strong> påverkar inte detta element eftersom dess <strong>outline-style</strong> är <strong>auto</strong> eller <strong>none</strong>.
inactive-css-not-for-internal-table-elements = <strong>{ $property }</strong> har ingen effekt på interna tabellelement.
inactive-css-not-for-internal-table-elements-except-table-cells = <strong>{ $property }</strong> har ingen effekt på interna tabellelement utom tabellceller.
inactive-css-not-table = <strong>{ $property }</strong> har ingen effekt på detta element eftersom det inte är en tabell.
inactive-scroll-padding-when-not-scroll-container = <strong>{ $property }</strong> har ingen effekt på detta element eftersom det inte rullar.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Försök lägga till <strong>display:grid</strong> eller <strong>display:flex</strong>. { learn-more }
inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Försök lägga till antingen <strong>display:grid</strong>, <strong>display:flex</strong> eller <strong>columns:2</strong>. { learn-more }
inactive-css-not-grid-or-flex-item-fix-2 = Försök att lägga till <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong> eller <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-grid-item-fix-2 = Försök lägga till <strong>display:grid</strong> eller <strong>display:inline-grid</ strong> till elementets förälder. { learn-more }
inactive-css-not-grid-container-fix = Försök lägga till <strong>display:grid</strong> eller <strong>display:inline-grid</strong>. { learn-more }
inactive-css-not-flex-item-fix-2 = Försök lägga till <strong>display:flex</strong> eller <strong>display:inline-flex</strong> till elementets förälder. { learn-more }
inactive-css-not-flex-container-fix = Försök lägga till <strong>display:flex</strong> eller <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-inline-or-tablecell-fix = Försök lägga till <strong>display:inline</strong> eller <strong>display:tabell-cell</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Försök lägga till <strong>display:inline-block</strong> eller <strong>display:block</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Försök lägga till <strong>display:inline-block</strong>. { learn-more }
inactive-css-not-display-block-on-floated-fix = Försök ta bort <strong>float</strong> eller lägga till <strong>display:block</strong>. { learn-more }
inactive-css-position-property-on-unpositioned-box-fix = Försök ställa in egenskapen <strong>position</strong> till något annat än <strong>static</strong>. { learn-more }
inactive-text-overflow-when-no-overflow-fix = Försök att lägga till <strong>overflow:hidden</strong>. { learn-more }
inactive-css-not-for-internal-table-elements-fix = Prova att ställa in egenskapen <strong>display</strong> till något annat än <strong>table-cell</strong>, <strong>table-column</strong>, <strong>table-row</strong>, <strong>table-column-group</strong>, <strong>table-row-group</strong> eller <strong>table-footer-group</strong>. { learn-more }
inactive-css-not-for-internal-table-elements-except-table-cells-fix = Prova att ställa in egenskapen <strong>display</strong> till något annat än <strong>table-column</strong>, <strong>table-row</strong>, <strong>table-column-group</strong>, <strong>table-row-group</strong> eller <strong>table-footer-group</strong>. { learn-more }
inactive-outline-radius-when-outline-style-auto-or-none-fix = Försök att ställa in egenskapen <strong>outline-style</strong> till något annat än <strong>auto</strong> eller <strong>none</strong>. { learn-more }
inactive-css-not-table-fix = Prova att lägga till <strong>display:table</strong> eller <strong>display:inline-table</strong>. { learn-more }
inactive-scroll-padding-when-not-scroll-container-fix = Försök att lägga till <strong>overflow:auto</strong>, <strong>overflow:scroll</strong> eller <strong>overflow:hidden</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = <strong>{ $property }</strong> stöds inte i följande webbläsare:
css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong> var ett experimentellt värde som nu är föråldrat enligt W3C standarder Det stöds inte i följande webbläsare:
css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong> var ett experimentellt värde som nu föråldras med W3C standarder.
css-compatibility-deprecated-message = <strong>{ $property }</strong> är föråldrat enligt W3C-standarder. Det stöds inte i följande webbläsare:
css-compatibility-deprecated-supported-message = <strong>{ $property }</strong> är föråldrat enligt W3C-standarder.
css-compatibility-experimental-message = <strong>{ $property }</strong> är ett experimentellt värde. Det stöds inte i följande webbläsare:
css-compatibility-experimental-supported-message = <strong>{ $property }</strong> är ett experimentellt värde.
css-compatibility-learn-more-message = <span data-l10n-name="link">Läs mer</span> om <strong>{ $rootProperty }</strong>
