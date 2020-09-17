# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Saznaj više</span>

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

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> ne utječe na ovaj element, budući da nije niti fleks-kontejner niti grid-kontejner.

inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> ne utječe na ovaj element, budući da nije fleks-kontejner, grid-kontejner ili višestupčani kontejner.

inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> ne utječe na ovaj element, budući da nije mrežni ili fleks element.

inactive-css-not-grid-item = <strong>{ $property }</strong> ne utječe na ovaj element, budući da nije mrežni element.

inactive-css-not-grid-container = <strong>{ $property }</strong> ne utječe na ovaj element, budući da nije grid-kontejner.

inactive-css-not-flex-item = <strong>{ $property }</strong> ne utječe na ovaj element, budući da nije fleks element.

inactive-css-not-flex-container = <strong>{ $property }</strong> ne utječe na ovaj element, budući da nije fleks-kontejner.

inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong> ne utječe na ovaj element, budući da nije linijski element ili ćelija tablice.

inactive-css-property-because-of-display = <strong>{ $property }</strong> ne utječe na ovaj element, budući da sadrži prikaz <strong>{ $display }</strong>.

inactive-css-not-display-block-on-floated = Vrijednost za <strong>display</strong> promijenjena je u <strong>block</strong> jer je element postavljen na <strong>float<strong>.

inactive-css-property-is-impossible-to-override-in-visited = Zbog ograničenja <strong>:visited</strong> nije moguće nadjačati <strong>{ $property }</strong>.

inactive-css-position-property-on-unpositioned-box = <strong>{ $property }</strong> ne utječe na ovaj element, budući da nije pozicionirani element.

inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> ne utječe na ovaj element, budući da <strong>overflow:hidden</strong> nije postavljeno.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Pokušaj dodati <strong>display:grid</strong> ili <strong>display:flex</strong>. { learn-more }

inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Pokušaj dodati <strong>display:grid</strong>, <strong>display:flex</strong> ili <strong>columns:2</strong>. { learn-more }

inactive-css-not-grid-or-flex-item-fix-2 = Pokušaj dodati <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong> ili <strong>display:inline-flex</strong>. { learn-more }

inactive-css-not-grid-item-fix-2 = Pokušaj dodati <strong>display:grid</strong> ili <strong>display:inline-grid</strong> nadređenom elementu stavke. { learn-more }

inactive-css-not-grid-container-fix = Pokušaj dodati <strong>display:grid</strong> ili <strong>display:inline-grid</strong>. { learn-more }

inactive-css-not-flex-item-fix-2 = Pokušaj dodati <strong>display:flex</strong> ili <strong>display:inline-flex</strong> nadređenom elementu stavke. { learn-more }

inactive-css-not-flex-container-fix = Pokušaj dodati <strong>display:flex</strong> ili <strong>display:inline-flex</strong>. { learn-more }

inactive-css-not-inline-or-tablecell-fix = Pokušaj dodati <strong>display:inline</strong> ili <strong>display:table-cell</strong>. { learn-more }

inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Pokušaj dodati <strong>display:inline-block</strong> ili <strong>display:block</strong>. { learn-more }

inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Pokušaj dodati <strong>display:inline-block</strong>. { learn-more }

inactive-css-not-display-block-on-floated-fix = Pokušaj ukloniti <strong>float</strong> ili dodati <strong>display:block</strong>. { learn-more }

inactive-css-position-property-on-unpositioned-box-fix = Pokušaj postaviti svojstvo <strong>position</strong> na nešto što nije <strong>static</strong>. { learn-more }

inactive-text-overflow-when-no-overflow-fix = Pokušaj dodati <strong>overflow:hidden</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

