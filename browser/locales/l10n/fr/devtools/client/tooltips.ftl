# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">En savoir plus </ span>

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".
##   $display (string) - A CSS display value e.g. "inline-block".

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> n’a aucun effet sur cet élément, car il ne s’agit ni d’un conteneur flex, ni d’un conteneur de grille.
inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> n’a aucun effet sur cet élément, car ce n’est ni un conteneur flex, ni un conteneur de grille ni un conteneur de plusieurs colonnes.
inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> n’a aucun effet sur cet élément, car il ne s’agit ni d’un élément de grille ni d’un élément flexible.
inactive-css-not-grid-item = <strong>{ $property }</strong> n’a aucun effet sur cet élément, car il ne s’agit pas d’un élément de grille.
inactive-css-not-grid-container = <strong>{ $property }</strong> n’a aucun effet sur cet élément, car il ne s’agit pas d’un conteneur de grille.
inactive-css-not-flex-item = <strong>{ $property }</strong> n’a aucun effet sur cet élément, car il ne s’agit pas d’un élément flexible.
inactive-css-not-flex-container = <strong>{ $property }</strong> n’a aucun effet sur cet élément, car il ne s’agit pas d’un conteneur d’éléments flexibles.
inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong> n’a aucun effet sur cet élément, car il ne s’agit ni d’un élément « inline » ni d’un élément « table-cell ».
inactive-css-property-because-of-display = <strong>{ $property }</strong> n’a aucun effet sur cet élément car la valeur de sa propriété « display » est <strong>{ $display }</strong>.
inactive-css-not-display-block-on-floated = La valeur <strong>display</strong> a été modifiée par le moteur en <strong>block</strong> car l’élément est <strong>flottant</strong>.
inactive-css-property-is-impossible-to-override-in-visited = Il n’est pas possible de redéfinir <strong>{ $property }</strong> en raison de restrictions sur <strong>:visited</strong>.
inactive-css-position-property-on-unpositioned-box = <strong>{ $property }</strong> n’a aucun effet sur cet élément, car il ne s’agit pas d’un élément positionné.
inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> n’a aucun effet sur cet élément, car <strong>overflow:hidden</strong> n’est pas défini.
inactive-outline-radius-when-outline-style-auto-or-none = <strong>{ $property }</strong> n’a aucun effet sur cet élément, car son <strong>outline-style</strong> est <strong>auto</strong> ou <strong>none</strong>.
inactive-css-not-for-internal-table-elements = <strong>{ $property }</strong> n’a aucun effet sur les éléments contenus dans un élément table.
inactive-css-not-for-internal-table-elements-except-table-cells = <strong>{ $property }</strong> n’a aucun effet sur les éléments contenus dans un élément table à l’exception de ses cellules.
inactive-css-not-table = <strong>{ $property }</strong> n’a aucun effet sur cet élément, car il ne s’agit pas d’un tableau.
inactive-scroll-padding-when-not-scroll-container = <strong>{ $property }</strong> n’a aucun effet sur cet élément, car il ne s’agit pas d’un élément défilable.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Essayez d’ajouter <strong>display: grid</strong> ou <strong>display: flex</strong>. { learn-more }
inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Essayez d’ajouter <strong>display:grid</strong>, <strong>display:flex</strong>, ou <strong>columns:2</strong>. { learn-more }
inactive-css-not-grid-or-flex-item-fix-2 = Essayez d’ajouter <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong> ou <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-grid-item-fix-2 = Essayez d’ajouter <strong>display:grid</strong> ou <strong>display:inline-grid</strong> au parent de l’élément. { learn-more }
inactive-css-not-grid-container-fix = Essayez d’ajouter <strong>display: grid</strong> ou <strong>display:inline-grid</strong>. { learn-more }
inactive-css-not-flex-item-fix-2 = Essayez d’ajouter <strong>display:flex</strong> ou <strong>display:inline-flex</strong> au parent de l’élément. { learn-more }
inactive-css-not-flex-container-fix = Essayez d’ajouter <strong>display:flex</strong> ou <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-inline-or-tablecell-fix = Essayez d’ajouter <strong>display:inline</strong> ou <strong>display:table-cell</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Essayez d’ajouter <strong>display:inline-block</strong> ou <strong>display:block</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Essayez d’ajouter <strong>display:inline-block</strong>. { learn-more }
inactive-css-not-display-block-on-floated-fix = Essayez de retirer <strong>float</strong> ou d’ajouter <strong>display:block</strong>. { learn-more }
inactive-css-position-property-on-unpositioned-box-fix = Essayez de définir sa propriété <strong>position</strong> avec une valeur différente de <strong>static</strong>. { learn-more }
inactive-text-overflow-when-no-overflow-fix = Essayez d’ajouter <strong>overflow:hidden</strong>. { learn-more }
inactive-css-not-for-internal-table-elements-fix = Essayez d’affecter à la propriété <strong>display</strong> une valeur autre que <strong>table-cell</strong>, <strong>table-column</strong>, <strong>table-row</strong>, <strong>table-column-group</strong>, <strong>table-row-group</strong> ou <strong>table-footer-group</strong>. { learn-more }
inactive-css-not-for-internal-table-elements-except-table-cells-fix = Essayez d’affecter à la propriété <strong>display</strong> une valeur autre que <strong>table-column</strong>, <strong>table-row</strong>, <strong>table-column-group</strong>, <strong>table-row-group</strong> ou <strong>table-footer-group</strong>. { learn-more }
inactive-outline-radius-when-outline-style-auto-or-none-fix = Essayez de définir sa propriété <strong>outline-style</strong> à une valeur autre qu’<strong>auto</strong> ou <strong>none</strong>. { learn-more }
inactive-css-not-table-fix = Essayez d’ajouter <strong>display:table</strong> ou <strong>display:inline-table</strong>. { learn-more }
inactive-scroll-padding-when-not-scroll-container-fix = Essayez d’ajouter <strong>overflow:auto</strong>, <strong>overflow:scroll</strong> ou <strong>overflow:hidden</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = <strong>{ $property }</strong> n’est pas pris en charge par les navigateurs suivants :
css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong> était une propriété expérimentale qui est désormais obsolète d’après les normes du W3C. Elle n’est plus prise en charge par les navigateurs suivants :
css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong> était une propriété expérimentale qui est désormais obsolète d’après les normes du W3C.
css-compatibility-deprecated-message = <strong>{ $property }</strong> est obsolète d’après les normes du W3C. La propriété n’est plus prise en charge par les navigateurs suivants :
css-compatibility-deprecated-supported-message = <strong>{ $property }</strong> est obsolète d’après les normes du W3C.
css-compatibility-experimental-message = <strong>{ $property }</strong> est une propriété expérimentale. Elle n’est pas prise en charge par les navigateurs suivants :
css-compatibility-experimental-supported-message = <strong>{ $property }</strong> est une propriété expérimentale.
css-compatibility-learn-more-message = <span data-l10n-name="link">En savoir plus</span> à propos de <strong>{ $rootProperty }</strong>
