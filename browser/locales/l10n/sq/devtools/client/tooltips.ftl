# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Mësoni më tepër</span>

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".
##   $display (string) - A CSS display value e.g. "inline-block".

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> s’ka efekt mbi këtë element, ngaqë s’është as kontejner fleks, as kontejner rrjetë.
inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> s’ka efekt mbi këtë element, ngaqë s’është kontejner fleks, kontejner rrjetë apo kontejner shumështyllësh.
inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> s’ka efekt mbi këtë element, ngaqë s’është objekt rrjetë apo fleks.
inactive-css-not-grid-item = <strong>{ $property }</strong> s’ka efekt mbi këtë element, ngaqë s’është objekt rrjetë.
inactive-css-not-grid-container = <strong>{ $property }</strong> s’ka efekt mbi këtë element, ngaqë s’është kontejner rrjetë.
inactive-css-not-flex-item = <strong>{ $property }</strong> s’ka efekt mbi këtë element, ngaqë s’është objekt fleks.
inactive-css-not-flex-container = <strong>{ $property }</strong> s’ka efekt mbi këtë element, ngaqë s’është kontejner fleks.
inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong> s’ka efekt mbi këtë element, ngaqë s’është element i brendshëm ose table-cell.
inactive-css-property-because-of-display = <strong>{ $property }</strong> s’ka efekt mbi këtë element, ngaqë ka shfaqje të <strong>{ $display }</strong>.
inactive-css-not-display-block-on-floated = Vlera <strong>display</strong> është ndryshuar nga motori në <strong>block</strong>, ngaqë elementi është <strong>floated<strong>.
inactive-css-property-is-impossible-to-override-in-visited = Është e pamundur të anashkalohet <strong>{ $property }</strong>, për shkak të kufizimit <strong>:visited</strong>.
inactive-css-position-property-on-unpositioned-box = <strong>{ $property }</strong> s’ka efekt mbi këtë element, ngaqë s’është element i pozicionuar.
inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> s’ka efekt mbi këtë element, ngaqë <strong>overflow:hidden</strong> s’është caktuar.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Provoni të shtoni <strong>display:grid</strong> ose <strong>display:flex</strong>. { learn-more }
inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Provoni të shtoni <strong>display:grid</strong>, <strong>display:flex</strong>, ose <strong>columns:2</strong>. { learn-more }
inactive-css-not-grid-or-flex-item-fix-2 = Provoni të shtoni <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong>, ose <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-grid-item-fix-2 = Provoni të shtoni <strong>display:grid</strong> ose <strong>display:inline-grid</strong> te mëma e elementit. { learn-more }
inactive-css-not-grid-container-fix = Provoni të shtoni <strong>display:grid</strong> ose <strong>display:inline-grid</strong>. { learn-more }
inactive-css-not-flex-item-fix-2 = Provoni të shtoni <strong>display:flex</strong> ose <strong>display:inline-flex</strong> te mëma e elementit. { learn-more }
inactive-css-not-flex-container-fix = Provoni të shtoni <strong>display:flex</strong> ose <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-inline-or-tablecell-fix = Provoni të shtoni <strong>display:inline</strong> ose <strong>display:table-cell</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Provoni të shtoni <strong>display:inline-block</strong> ose <strong>display:block</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Provoni të shtoni <strong>display:inline-block</strong>. { learn-more }
inactive-css-not-display-block-on-floated-fix = Provoni të hiqni <strong>float</strong> ose të shtoni <strong>display:block</strong>. { learn-more }
inactive-css-position-property-on-unpositioned-box-fix = Provoni të ujdisni vetinë e tij <strong>position</strong> si diçka tjetër nga <strong>static</strong>. { learn-more }
inactive-text-overflow-when-no-overflow-fix = Provoni të shtoni <strong>overflow:hidden</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = <strong>{ $property }</strong> nuk mbulohet në shfletuesit vijues:
css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong> qe një veti eksperimentale që tani është nxjerrë nga përdorimi nga standardet W3C. Nuk mbulohet në shfletuesit vijues:
css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong> qe një veti eksperimentale që tanimë është nxjerrë nga përdorimi nga standardet W3C.
css-compatibility-deprecated-message = <strong>{ $property }</strong> është nxjerrë nga përdorimi nga standardet W3C. Nuk mbulohet në shfletuesit vijues:
css-compatibility-deprecated-supported-message = <strong>{ $property }</strong> është nxjerrë nga përdorimi nga standardet W3C.
css-compatibility-experimental-message = <strong>{ $property }</strong> është një veti eksperimentale. Nuk mbulohet në shfletuesit vijues:
css-compatibility-experimental-supported-message = <strong>{ $property }</strong> është një veti eksperimentale.
css-compatibility-learn-more-message = <span data-l10n-name="link">Mësoni më tepër</span> rreth <strong>{ $rootProperty }</strong>
