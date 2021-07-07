# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Sužinoti daugiau</span>

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".
##   $display (string) - A CSS display value e.g. "inline-block".

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> nedaro poveikio šiam elementui, kadangi jis nėra nei „flex“ konteineris, nei „grid“ konteineris.
inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> nedaro poveikio šiam elementui, kadangi jis nėra nei „flex“, nei „grid“, nei „multi-column“ konteineris.
inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> nedaro poveikio šiam elementui, kadangi jis nėra nei „grid“, nei „flex“ elementas.
inactive-css-not-grid-item = <strong>{ $property }</strong> nedaro poveikio šiam elementui, kadangi jis nėra „grid“ elementas.
inactive-css-not-grid-container = <strong>{ $property }</strong> nedaro poveikio šiam elementui, kadangi jis nėra „grid“ konteineris.
inactive-css-not-flex-item = <strong>{ $property }</strong> nedaro poveikio šiam elementui, kadangi jis nėra „flex“ elementas.
inactive-css-not-flex-container = <strong>{ $property }</strong> nedaro poveikio šiam elementui, kadangi jis nėra „flex“ konteineris.
inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong> nedaro poveikio šiam elementui, kadangi jis nėra nei „inline“, nei „table-cell“ elementas.
inactive-css-property-because-of-display = <strong>{ $property }</strong> nedaro poveikio šiam elementui, kadangi jis turi „display“ tipą <strong>{ $display }</strong>.
inactive-css-not-display-block-on-floated = Varikliukas pakeitė <strong>display</strong> reikšmę į <strong>block</strong>, nes elementas yra su <strong>float</strong>.
inactive-css-property-is-impossible-to-override-in-visited = Neįmanoma pakeisti <strong>{ $property }</strong> dėl <strong>:visited</strong> apribojimo.
inactive-css-position-property-on-unpositioned-box = <strong>{ $property }</strong> nedaro poveikio šiam elementui, kadangi jis nėra pozicionuotas elementas.
inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> nedaro poveikio šiam elementui, kadangi nėra nustatyta <strong>overflow:hidden</strong> savybė.
inactive-outline-radius-when-outline-style-auto-or-none = <strong>{ $property }</strong> nedaro poveikio šiam elementui, kadangi jo savybė <strong>outline-style</strong> turi reikšmę <strong>auto</strong> arba <strong>none</strong>.
inactive-css-not-for-internal-table-elements = <strong>{ $property }</strong> neturi jokios įtakos vidiniams lentelės elementams.
inactive-css-not-for-internal-table-elements-except-table-cells = <strong>{ $property }</strong> neturi jokios įtakos vidiniams lentelės elementams, išskyrus langelius.
inactive-css-not-table = <strong>{ $property }</strong> nedaro poveikio šiam elementui, kadangi jis nėra „table“ elementas.
inactive-scroll-padding-when-not-scroll-container = <strong>{ $property }</strong> nedaro poveikio šiam elementui, kadangi jis nėra slenkamas.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Pabandykite pridėti <strong>display:grid</strong> arba <strong>display:flex</strong>. { learn-more }
inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Pabandykite pridėti <strong>display:grid</strong>, <strong>display:flex</strong>, arba <strong>columns:2</strong>. { learn-more }
inactive-css-not-grid-or-flex-item-fix-2 = Pabandykite pridėti <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong>, arba <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-grid-item-fix-2 = Pabandykite pridėti <strong>display:grid</strong> arba <strong>display:inline-grid</strong> tėviniam elementui. { learn-more }
inactive-css-not-grid-container-fix = Pabandykite pridėti <strong>display:grid</strong> arba <strong>display:inline-grid</strong>. { learn-more }
inactive-css-not-flex-item-fix-2 = Pabandykite pridėti <strong>display:flex</strong> arba <strong>display:inline-flex</strong> tėviniam elementui. { learn-more }
inactive-css-not-flex-container-fix = Pabandykite pridėti <strong>display:flex</strong> arba <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-inline-or-tablecell-fix = Pabandykite pridėti <strong>display:inline</strong> arba <strong>display:table-cell</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Pabandykite pridėti <strong>display:inline-block</strong> arba <strong>display:block</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Pabandykite pridėti <strong>display:inline-block</strong>. { learn-more }
inactive-css-not-display-block-on-floated-fix = Pabandykite nuimti <strong>float</strong> arba pridėti <strong>display:block</strong>. { learn-more }
inactive-css-position-property-on-unpositioned-box-fix = Pabandykite nustatyti jo <strong>position</strong> savybės reikšmę į kitą negu <strong>static</strong>. { learn-more }
inactive-text-overflow-when-no-overflow-fix = Pabandykite pridėti <strong>overflow:hidden</strong>. { learn-more }
inactive-css-not-for-internal-table-elements-fix = Pabandykite nustatyti jo <strong>display</strong> savybės reikšmę į kitą negu <strong>table-cell</strong>, <strong>table-column</strong>, <strong>table-column</strong>, <strong>table-row</strong>, <strong>table-column-group</strong>, <strong>table-row-group</strong>, arba <strong>table-footer-group</strong>. { learn-more }
inactive-css-not-for-internal-table-elements-except-table-cells-fix = Pabandykite nustatyti jo <strong>display</strong> savybės reikšmę į kitą negu <strong>table-column</strong>, <strong>table-column</strong>, <strong>table-column</strong>, <strong>table-row</strong>, <strong>table-column-group</strong>, <strong>table-row-group</strong>, arba <strong>table-footer-group</strong>. { learn-more }
inactive-outline-radius-when-outline-style-auto-or-none-fix = Pabandykite nustatyti jo <strong>outline-style</strong> savybės reikšmę į kitą negu <strong>auto</strong> ar <strong>none</strong>. { learn-more }
inactive-css-not-table-fix = Pabandykite pridėti <strong>display:table</strong> arba <strong>display:inline-table</strong>. { learn-more }
inactive-scroll-padding-when-not-scroll-container-fix = Pabandykite pridėti <strong>overflow:auto</strong>, <strong>overflow:scroll</strong>, arba <strong>overflow:hidden</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = <strong>{ $property }</strong> nėra palaikoma šiose naršyklėse:
css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong> buvo bandomoji savybė, kuri dabar yra nenaudotina pagal „W3C“ standartus. Ji nėra palaikoma šiose naršyklėse:
css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong> buvo bandomoji savybė, kuri dabar yra nenaudotina pagal „W3C“ standartus.
css-compatibility-deprecated-message = <strong>{ $property }{ $property } yra nenaudotina pagal „W3C“ standartus. Ji nėra palaikoma šiose naršyklėse:
css-compatibility-deprecated-supported-message = <strong>{ $property }</strong> yra nenaudotina pagal „W3C“ standartus.
css-compatibility-experimental-message = <strong>{ $property }</strong> yra bandomoji savybė. Ji nėra palaikoma šiose naršyklėse:
css-compatibility-experimental-supported-message = <strong>{ $property }</strong> yra bandomoji savybė.
css-compatibility-learn-more-message = <span data-l10n-name="link">Sužinokite daugiau</span> apie <strong>{ $rootProperty }</strong>
