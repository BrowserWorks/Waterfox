# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">További tudnivalók</span>

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".
##   $display (string) - A CSS display value e.g. "inline-block".

inactive-css-not-grid-or-flex-container = A(z) <strong>{ $property }</strong> nem befolyásolja ezt az elemet, mivel nem flexibilis vagy rácstároló.
inactive-css-not-grid-or-flex-container-or-multicol-container = A(z) <strong>{ $property }</strong> nem befolyásolja ezt az elemet, mivel ez nem flex konténer, rács- vagy többoszlopos tároló.
inactive-css-not-grid-or-flex-item = A(z) <strong>{ $property }</strong> nem befolyásolja ezt az elemet, mivel nem rács vagy flexibilis elem.
inactive-css-not-grid-item = A(z) <strong>{ $property }</strong> nem befolyásolja ezt az elemet, mivel nem egy rácselem.
inactive-css-not-grid-container = A(z) <strong>{ $property }</strong> nem befolyásolja ezt az elemet, mivel nem rácstároló.
inactive-css-not-flex-item = A(z) <strong>{ $property }</strong> nem befolyásolja ezt az elemet, mivel nem flexibilis elem.
inactive-css-not-flex-container = A(z) <strong>{ $property }</strong> nem befolyásolja ezt az elemet, mivel nem flexibilis tároló.
inactive-css-not-inline-or-tablecell = A(z) <strong>{ $property }</strong> nem befolyásolja ezt az elemet, mivel nem „inline” vagy „table-cell” elem.
inactive-css-property-because-of-display = A(z) <strong>{ $property }</strong> nem befolyásolja ezt az elemet, mivel a „display” értéke <strong>{ $display }</strong>.
inactive-css-not-display-block-on-floated = A <strong>display</strong> értéket <strong>blokkolásra</strong> változtatta a motor, mert az elem <strong>lebegő</strong>.
inactive-css-property-is-impossible-to-override-in-visited = A(z) <strong>{ $property }</strong> felülbírálása a <strong>:visited</strong> korlátozás miatt lehetetlen.
inactive-css-position-property-on-unpositioned-box = A(z) <strong>{ $property }</strong> nincs hatással erre az elemre, mivel nem pozicionált elem.
inactive-text-overflow-when-no-overflow = A(z) <strong>{ $property }</strong> nem befolyásolja ezt az elemet, mivel nem megadva az <strong>overflow:hidden</strong>.
inactive-outline-radius-when-outline-style-auto-or-none = A(z) <strong>{ $property }</strong> nem befolyásolja ezt az elemet, mert az <strong>outline-style</strong> értéke <strong>auto</strong> vagy <strong>none</strong>.
inactive-css-not-for-internal-table-elements = A(z) <strong>{ $property }</strong> nincs hatással a belső táblázatelemekre.
inactive-css-not-for-internal-table-elements-except-table-cells = A(z) <strong>{ $property }</strong> nincs hatással a belső táblázatelemekre, kivéve a táblázatcellákat.
inactive-css-not-table = A(z) <strong>{ $property }</strong> nem befolyásolja ezt az elemet, mivel nem táblázat.
inactive-scroll-padding-when-not-scroll-container = A(z) <strong>{ $property }</strong> nem befolyásolja ezt az elemet, mivel nem görgethető.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Próbálja meg ezeket hozzáadni: <strong>display:grid</strong> vagy <strong>display:flex</strong>. { learn-more }
inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Próbálja meg ezeket hozzáadni: <strong>display:grid</strong>, <strong>display:flex</strong> vagy <strong>columns:2</strong>. { learn-more }
inactive-css-not-grid-or-flex-item-fix-2 = Próbálja meg ezeket hozzáadni: <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong> vagy <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-grid-item-fix-2 = Próbálja meg ezeket hozzáadni az elem szülőjéhez: <strong>display:grid</strong> vagy <strong>display:inline-grid</strong>. { learn-more }
inactive-css-not-grid-container-fix = Próbálja meg ezeket hozzáadni: <strong>display:grid</strong> vagy <strong>display:inline-grid</strong>. { learn-more }
inactive-css-not-flex-item-fix-2 = Próbálja meg ezeket hozzáadni az elem szülőjéhez: <strong>display:flex</strong> vagy <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-flex-container-fix = Próbálja meg ezeket hozzáadni: <strong>display:flex</strong> vagy <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-inline-or-tablecell-fix = Próbálja meg ezeket hozzáadni: <strong>display:inline</strong> vagy <strong>display:table-cell</strong>.{ learn-more }
inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Próbálja meg ezeket hozzáadni: <strong>display:inline-block</strong> vagy <strong>display:block</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Próbálja meg ezt hozzáadni: <strong>display:inline-block</strong>. { learn-more }
inactive-css-not-display-block-on-floated-fix = Próbálja meg eltávolítani a <strong>float</strong> tulajdonságot, vagy hozzáadni a <strong>display:block</strong> tulajdonságot. { learn-more }
inactive-css-position-property-on-unpositioned-box-fix = Próbálja meg a <strong>position</strong> tulajdonságot <strong>static</strong> helyett valami másra beállítani. { learn-more }
inactive-text-overflow-when-no-overflow-fix = Próbálja meg ezt hozzáadni: <strong>overflow:hidden</strong>. { learn-more }
inactive-css-not-for-internal-table-elements-fix = Próbálja meg a <strong>display</strong> tulajdonságot másra állítani, mint a <strong>table-cell</strong>, <strong>table-column</strong>, <strong>table-row</strong>, <strong>table-column-group</strong>, <strong>table-row-group</strong> vagy <strong>table-footer-group</strong>. { learn-more }
inactive-css-not-for-internal-table-elements-except-table-cells-fix = Próbálja meg a <strong>display</strong> tulajdonságot másra állítani, mint a <strong>table-column</strong>, <strong>table-row</strong>, <strong>table-column-group</strong>, <strong>table-row-group</strong> vagy <strong>table-footer-group</strong>. { learn-more }
inactive-outline-radius-when-outline-style-auto-or-none-fix = Próbálja meg a <strong>outline-style</strong> tulajdonságot <strong>auto</strong> vagy <strong>none</strong> helyett valami másra beállítani. { learn-more }
inactive-css-not-table-fix = Próbálja meg ezeket hozzáadni: <strong>display:table</strong> vagy <strong>display:inline-table</strong>. { learn-more }
inactive-scroll-padding-when-not-scroll-container-fix = Próbálkozzon az <strong>overflow:auto</strong>, <strong>overflow:scroll</strong> vagy <strong>overflow:hidden</strong> hozzáadásával. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = A(z) <strong>{ $property }</strong> nem támogatott a következő böngészőkben:
css-compatibility-deprecated-experimental-message = A(z) <strong>{ $property }</strong> egy kísérleti tulajdonság volt, amely a W3C szabványoknak megfelelően elavult. A következő böngészőkben nem támogatott:
css-compatibility-deprecated-experimental-supported-message = A(z) <strong>{ $property }</strong> egy kísérleti tulajdonság volt, amely a W3C szabványoknak megfelelően elavult.
css-compatibility-deprecated-message = A(z) <strong>{ $property }</strong> a W3C szabványoknak megfelelően elavult. A következő böngészőkben nem támogatott:
css-compatibility-deprecated-supported-message = A(z) <strong>{ $property }</strong> a W3C szabványoknak megfelelően elavult.
css-compatibility-experimental-message = A(z) <strong>{ $property }</strong> egy kísérleti tulajdonság. A következő böngészőkben nem támogatott:
css-compatibility-experimental-supported-message = A(z) <strong>{ $property }</strong> egy kísérleti tulajdonság.
css-compatibility-learn-more-message = <span data-l10n-name="link">További tudnivalók</span> a(z) <strong>{ $rootProperty }</strong> tulajdonságról
