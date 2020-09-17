# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Več o tem</span>

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".
##   $display (string) - A CSS display value e.g. "inline-block".

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> ne vpliva na ta element, ker ni niti vsebnik flex niti vsebnik grid.
inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> ne vpliva na ta element, ker ni vsebnik flex, vsebnik grid ali vsebnik z več stolpci.
inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> ne vpliva na ta element, ker ni vsebnik grid ali flex.
inactive-css-not-grid-item = <strong>{ $property }</strong> ne vpliva na ta element, ker ni element grid.
inactive-css-not-grid-container = <strong>{ $property }</strong> ne vpliva na ta element, ker ni vsebnik grid.
inactive-css-not-flex-item = <strong>{ $property }</strong> ne vpliva na ta element, ker ni element flex.
inactive-css-not-flex-container = <strong>{ $property }</strong> ne vpliva na ta element, ker ni vsebnik flex.
inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong> ne vpliva na ta element, ker ni vrstični element ali element celice tabele.
inactive-css-property-because-of-display = <strong>{ $property }</strong> ne vpliva na ta element, ker prikazuje <strong>{ $display }</strong>.
inactive-css-not-display-block-on-floated = Pogon je spremenil vrednost <strong>display</strong> v <strong>block</strong>, ker je element nastavljen na <strong>float<strong>.
inactive-css-property-is-impossible-to-override-in-visited = <strong>{ $property }</strong> ni mogoče preglasiti zaradi omejitve <strong>:visited</strong>.
inactive-css-position-property-on-unpositioned-box = <strong>{ $property }</strong> ne vpliva na ta element, ker element ni postavljen.
inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> ne vpliva na ta element, ker <strong>overflow:hidden</strong> ni nastavljen.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Poskusite dodati <strong>display:grid</strong> ali <strong>display:flex</strong>. { learn-more }
inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Poskusite dodati <strong>display:grid</strong>, <strong>display:flex</strong> ali <strong>columns:2</strong>. { learn-more }
inactive-css-not-grid-or-flex-item-fix-2 = Poskusite dodati <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong> ali <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-grid-item-fix-2 = Nadrejenemu elementu poskusite dodati <strong>display:grid</strong> ali <strong>display:inline-grid</strong>. { learn-more }
inactive-css-not-grid-container-fix = Poskusite dodati <strong>display:grid</strong> ali <strong>display:inline-grid</strong>. { learn-more }
inactive-css-not-flex-item-fix-2 = Nadrejenemu elementu poskusite dodati <strong>display:flex</strong> ali <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-flex-container-fix = Poskusite dodati <strong>display:flex</strong> ali <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-inline-or-tablecell-fix = Poskusite dodati <strong>display:inline</strong> ali <strong>display:table-cell</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Poskusite dodati <strong>display:inline-block</strong> ali <strong>display:block</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Poskusite dodati <strong>display:inline-block</strong>. { learn-more }
inactive-css-not-display-block-on-floated-fix = Poskusite odstraniti<strong>float</strong> ali dodati <strong>display:block</strong>. { learn-more }
inactive-css-position-property-on-unpositioned-box-fix = Poskusite nastaviti lastnost <strong>position</strong> na kaj drugega kot <strong>static</strong>. { learn-more }
inactive-text-overflow-when-no-overflow-fix = Poskusite dodati <strong>overflow:hidden</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = <strong>{ $property }</strong> ni podprt v naslednjih brskalnikih:
css-compatibility-experimental-supported-message = <strong>{ $property }</strong> je poskusna lastnost.
css-compatibility-learn-more-message = <span data-l10n-name="link">Več</span> o <strong>{ $rootProperty }</strong>
