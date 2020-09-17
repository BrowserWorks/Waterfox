# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Află mai multe</span>

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".
##   $display (string) - A CSS display value e.g. "inline-block".

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> nu are niciun efect asupra acestui element pentru că nu este nici container flex, nici container de grilă.
inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> nu are niciun efect asupra acestui element pentru că nu este un container flex, container de grilă sau container multicoloane.
inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> nu are niciun efect asupra acestui element pentru că nu este nici element de grilă, nici element flex.
inactive-css-not-grid-item = <strong>{ $property }</strong> nu are niciun efect asupra acestui element pentru că nu este element flex.
inactive-css-not-grid-container = <strong>{ $property }</strong> nu are niciun efect asupra acestui element pentru că nu este container de grilă.
inactive-css-not-flex-item = <strong>{ $property }</strong> nu are niciun efect asupra acestui element pentru că nu este element flex.
inactive-css-not-flex-container = <strong>{ $property }</strong> nu are niciun efect asupra acestui element pentru că nu este container flex.
inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong> nu are niciun efect asupra acestui element pentru că nu este element inline sau de celulă tabulară.
inactive-css-property-because-of-display = <strong>{ $property }</strong> nu are niciun efect asupra acestui element deoarece valoarea de afișare este <strong>{ $display }</strong>.
inactive-css-not-display-block-on-floated = Valoarea <strong>display</strong> a fost modificată de motor în <strong>block</strong> deoarece elementul este <strong>floated<strong>.
inactive-css-property-is-impossible-to-override-in-visited = Imposibil de redefinit <strong>{ $property }</strong> din cauza restricției <strong>:visited</strong>.
inactive-css-position-property-on-unpositioned-box = <strong>{ $property }</strong>nu are niciun efect asupra acestui element pentru că nu este element poziționat.
inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> nu are niciun efect asupra acestui element pentru că <strong>overflow:hidden</strong> nu este setat.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Încearcă să adaugi <strong>display:grid</strong> sau <strong>display:flex</strong>. { learn-more }
inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Încearcă să adaugi <strong>display:grid</strong>, <strong>display:flex</strong> sau <strong>columns:2</strong>. { learn-more }
inactive-css-not-grid-or-flex-item-fix-2 = Încearcă să adaugi <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong> sau <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-grid-item-fix-2 = Încearcă să adaugi <strong>display:grid</strong> or <strong>display:inline-grid</strong> la părintele elementului. { learn-more }
inactive-css-not-grid-container-fix = Încearcă să adaugi <strong>display:grid</strong> sau <strong>display:inline-grid</strong>. { learn-more }
inactive-css-not-flex-item-fix-2 = Încearcă să adaugi <strong>display:flex</strong> sau <strong>display:inline-flex</strong> la părintele elementului. { learn-more }
inactive-css-not-flex-container-fix = Încearcă să adaugi <strong>display:flex</strong> sau <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-inline-or-tablecell-fix = Încearcă să adaugi <strong>display:inline</strong> sau <strong>display:table-cell</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Încearcă să adaugi <strong>display:inline-block</strong> sau <strong>display:block</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Încearcă să adaugi <strong>display:block</strong>. { learn-more }
inactive-css-not-display-block-on-floated-fix = Încearcă să elimini <strong>float</strong> sau să adaugi <strong>display:block</strong>. { learn-more }
inactive-css-position-property-on-unpositioned-box-fix = Încearcă să îi setezi proprietatea <strong>poziție</strong> pe altceva decât <strong>static</strong>. { learn-more }
inactive-text-overflow-when-no-overflow-fix = Încearcă să adaugi <strong>overflow:hidden</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = <strong>{ $property }</strong> nu are suport pe următoarele browsere:
css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong> a fost o proprietate experimentală și acum este perimată conform standardelor W3C. Nu are suport pe următoarele browsere:
css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong> a fost o proprietate experimentală și acum este perimată conform standardelor W3C.
css-compatibility-deprecated-message = <strong>{ $property }</strong> este perimată conform standardelor W3C. Nu are suport pe următoarele browsere:
css-compatibility-deprecated-supported-message = <strong>{ $property }</strong> este perimată conform standardelor W3C.
css-compatibility-experimental-message = <strong>{ $property }</strong> este o proprietate experimentală. Nu are suport pe următoarele browsere:
css-compatibility-experimental-supported-message = <strong>{ $property }</strong> este o proprietate experimentală.
css-compatibility-learn-more-message = <span data-l10n-name="link">Află mai multe</span> despre <strong>{ $rootProperty }</strong>
