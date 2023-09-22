# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Zjistit více</span>

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".
##   $display (string) - A CSS display value e.g. "inline-block".

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> nemá na tento prvek žádný vliv, protože není kontejnerem pro zobrazení grid ani flex.
inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> nemá na tento prvek žádný vliv, protože není kontejnerem pro zobrazení grid ani flex, ani není kontejnerem s více sloupci.
inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> nemá na tento prvek žádný vliv, protože není prvkem zobrazení grid ani flex.
inactive-css-not-grid-item = <strong>{ $property }</strong> nemá na tento prvek žádný vliv, protože není prvkem zobrazení grid.
inactive-css-not-grid-container = <strong>{ $property }</strong> nemá na tento prvek žádný vliv, protože není kontejnerem pro zobrazení grid.
inactive-css-not-flex-item = <strong>{ $property }</strong> nemá na tento prvek žádný vliv, protože prvkem zobrazení flex.
inactive-css-not-flex-container = <strong>{ $property }</strong> nemá na tento prvek žádný vliv, protože není kontejnerem pro zobrazení flex.
inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong> nemá na tento prvek žádný vliv, protože není prvkem typu inline ani table-cell.
inactive-css-first-line-pseudo-element-not-supported = Vlastnost <strong>{ $property }</strong> není podporována na pseudoprvcích ::first-line.
inactive-css-property-because-of-display = <strong>{ $property }</strong> nemá na tento prvek žádný vliv, protože má nastavenu vlastnost display s hodnotou <strong>{ $display }</strong>.
inactive-css-not-display-block-on-floated = Hodnota vlastnosti <strong>display</strong> byla automaticky nastavena na <strong>block</strong>, protože je nastavena vlastnost <strong>float</strong>.
inactive-css-property-is-impossible-to-override-in-visited = Není možné přepsat vlastnost <strong>{ $property }</strong> z důvodu omezení selekorem <strong>:visited</strong>.
inactive-css-position-property-on-unpositioned-box = Vlastnost <strong>{ $property }</strong> nemá na tento prvek žádný vliv, protože nejde o prvek s definovanou pozicí.
inactive-text-overflow-when-no-overflow = Vlastnost <strong>{ $property }</strong> nemá žádný vliv na tento prvek, protože není nastavené <strong>overflow:hidden</strong>.
inactive-css-not-for-internal-table-elements = Vlastnost <strong>{ $property }</strong> nemá žádný vliv na interní prvky tabulky.
inactive-css-not-for-internal-table-elements-except-table-cells = Vlastnost <strong>{ $property }</strong> nemá žádný vliv na interní prvky tabulky kromě jejích buněk.
inactive-css-not-table = Vlatnost <strong>{ $property }</strong> nemá žádný vliv na tento prvek, protože se nejedná o tabulku.
inactive-css-not-table-cell = Vlastnost <strong>{ $property }</strong> nemá žádný efekt na tento prvek, protože se nejedná o buňku tabulky.
inactive-scroll-padding-when-not-scroll-container = Vlastnost <strong>{ $property }</strong> nemá žádný vliv na tento prvek, protože není rolovatelný.
inactive-css-highlight-pseudo-elements-not-supported = Vlastnost <strong>{ $property }</strong> není podporována na zvýrazněných pseudoprvcích.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Zkuste přidat <strong>display:grid</strong> nebo <strong>display:flex</strong>. { learn-more }
inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Zkuste přidat <strong>display:grid</strong>, <strong>display:flex</strong> nebo <strong>columns:2</strong>. { learn-more }
inactive-css-not-multicol-container-fix = Zkuste přidat buď <strong>column-count</strong> nebo <strong>column-width</strong>. { learn-more }
inactive-css-not-grid-or-flex-item-fix-3 = Zkuste přidat <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong> nebo <strong>display:inline-flex</strong> k rodiči tohoto prvku. { learn-more }
inactive-css-not-grid-item-fix-2 = Zkuste přidat <strong>display:grid</strong> nebo <strong>display:inline-grid</strong> k rodiči tohoto prvku. { learn-more }
inactive-css-not-grid-container-fix = Zkuste přidat <strong>display:grid</strong> nebo <strong>display:inline-grid</strong>. { learn-more }
inactive-css-not-flex-item-fix-2 = Zkuste přidat <strong>display:flex</strong> nebo <strong>display:inline-flex</strong> k rodiči tohoto prvku. { learn-more }
inactive-css-not-flex-container-fix = Zkuste přidat <strong>display:flex</strong> nebo <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-inline-or-tablecell-fix = Zkuste přidat <strong>display:inline</strong> nebo <strong>display:table-cell</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Zkuste přidat <strong>display:inline-block</strong> nebo <strong>display:block</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Zkuste přidat <strong>display:inline-block</strong>. { learn-more }
inactive-css-not-display-block-on-floated-fix = Zkuste odstranit <strong>float</strong> nebo přidat <strong>display:block</strong>. { learn-more }
inactive-css-position-property-on-unpositioned-box-fix = Zkuste nastavit vlastnost <strong>position</strong> na jinou hodnotu než <strong>static</strong>. { learn-more }
inactive-text-overflow-when-no-overflow-fix = Zkuste přidat <strong>overflow:hidden</strong>. { learn-more }
inactive-css-not-for-internal-table-elements-fix = Zkuste nastavit vlastnost <strong>display</strong> na jinou hodnotu než <strong>table-cell</strong>, <strong>table-column</strong>, <strong>table-row</strong>, <strong>table-column-group</strong>, <strong>table-row-group</strong> nebo <strong>table-footer-group</strong>. { learn-more }
inactive-css-not-for-internal-table-elements-except-table-cells-fix = Zkuste nastavit vlastnost <strong>display</strong> na jinou hodnotu než <strong>table-column</strong>, <strong>table-row</strong>, <strong>table-column-group</strong>, <strong>table-row-group</strong> nebo <strong>table-footer-group</strong>. { learn-more }
inactive-css-not-table-fix = Zkuste přidat <strong>display:table</strong> nebo <strong>display:inline-table</strong>. { learn-more }
inactive-css-not-table-cell-fix = Zkuste přidat <strong>display:table-cell</strong>. { learn-more }
inactive-scroll-padding-when-not-scroll-container-fix = Zkuste přidat <strong>overflow:auto</strong>, <strong>overflow:scroll</strong> nebo <strong>overflow:hidden</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = Vlastnost <strong>{ $property }</strong> není podporována v následujících prohlížečích:
css-compatibility-deprecated-experimental-message = Vlastnost <strong>{ $property }</strong> byla experimentální vlastností, která je nyní dle W3C standardů zastaralá. Není podporována v následujících prohlížečích:
css-compatibility-deprecated-experimental-supported-message = Vlastnost <strong>{ $property }</strong> byla experimentální vlastností, která je nyní dle standardů W3C zastaralá.
css-compatibility-deprecated-message = Vlastnost <strong>{ $property }</strong> je podle standardů W3C zastaralá. Není podporována v následujících prohlížečích:
css-compatibility-deprecated-supported-message = Vlastnost <strong>{ $property }</strong> je dle standardů W3C zastaralá.
css-compatibility-experimental-message = Vlastnost <strong>{ $property }</strong> je experimentální. Není podporována v následujících prohlížečích:
css-compatibility-experimental-supported-message = Vlastnost <strong>{ $property }</strong> je experimentální.
css-compatibility-learn-more-message = <span data-l10n-name="link">Zjistit více</span> o vlastnosti <strong>{ $rootProperty }</strong>
