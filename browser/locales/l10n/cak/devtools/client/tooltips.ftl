# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Tetamäx ch'aqa' chik</span>

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".
##   $display (string) - A CSS display value e.g. "inline-block".

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> majun nub'än pa re ch'akulal re', ruma chi majun ta chi jalel k'wayöl ni xa ta jun wokowïk kajtz'ik k'wayöl.
inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> majun nub'än pa re wachinäq re', ruma chi ma jalel ta chi k'wayöl, kajtz'ikinel k'wayöl chuqa' man jun ta k'ïy tem ajk'wayöl.
inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> majun nub'än chi re re ch'akulal re', ruma majun ta wokowïk kajtz'ik chuqa' majun jalel chi ch'akulal.
inactive-css-not-grid-item = <strong>{ $property }</strong> majun nub'än pa re ch'akulal re' ruma chi man ruch'akulal ta ri wokowïk kajtz'ik.
inactive-css-not-grid-container = <strong>{ $property }</strong> majun nub'än pa re ch'akulal re' ruma majun ta ruk'wayöl wokowïk kajtz'ik.
inactive-css-not-flex-item = <strong>{ $property }</strong> majun nub'än pa re ch'akulal re' ruma chi majun ta jalel ch'akulal.
inactive-css-not-flex-container = <strong>{ $property }</strong> majun nub'än chi re re ch'akulal re' ruma chi majun ta jalel k'wayöl.
inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong> majun nub'än pa re wachinäq re', ruma majun ta wachinäq pa k'amab'ey o ruch'utikajtz'ik kajtz'ik.
inactive-css-property-because-of-display = <strong>{ $property }</strong> majun nub'än pa re wachinäq re', ruma k'o rutz'etik richin <strong>{ $display }</strong>.
inactive-css-not-display-block-on-floated = Ri <strong>tz'etoj</strong> xujäl retal pa ri motor richin <strong>blok</strong> ruma chi ri ch'akulal <strong>jun k'o wi<strong>.
inactive-css-property-is-impossible-to-override-in-visited = Tikirel niyuj <strong>{ $property }</strong> ruma ri q'atoj <strong>:xtz'et</strong>.
inactive-css-position-property-on-unpositioned-box = <strong>{ $property }</strong> majun nub'än pa re ch'akulal re' ruma chi majun ta ch'akulal ya'on ruk'ojlem.
inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> majun nub'än pa re ch'akulal re' ruma chi ri <strong>overflow:hidden</strong> man jikib'an ta.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Titojtob'ëx nitz'aqatisäx <strong>display:grid</strong> o <strong>display:flex</strong>. { learn-more }
inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Titojtob'ëx nitz'aqatisäx <strong>display:grid</strong>, <strong>display:flex</strong>, o <strong>columns:2</strong>. { learn-more }
inactive-css-not-grid-or-flex-item-fix-2 = Titojtob'ëx nitz'aqatisäx <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong>, o <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-grid-item-fix-2 = Titojtob'ëx nitz'aqatisäx <strong>display:grid</strong> o <strong>display:inline-grid</strong> chi re ri rach'alal ch'akulal. { learn-more }
inactive-css-not-grid-container-fix = Titojtob'ëx nitz'aqatisäx <strong>display:grid</strong> o <strong>display:inline-grid</strong>. { learn-more }
inactive-css-not-flex-item-fix-2 = Titojtob'ëx nitz'aqatisäx <strong>display:flex</strong> o <strong>display:inline-flex</strong> chi re ri rach'alal ch'akulal. { learn-more }
inactive-css-not-flex-container-fix = Titojtob'ëx nitz'aqatisäx <strong>display:flex</strong> o <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-inline-or-tablecell-fix = Titojtob'ëx nitz'aqatisäx <strong>display:inline</strong> o <strong>display:table-cell</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Titojtob'ëx nitz'aqatisäx <strong>display:inline-block</strong> o <strong>display:block</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Titojtob'ëx nitz'aqatisäx <strong>display:inline-block</strong>. { learn-more }
inactive-css-not-display-block-on-floated-fix = Tatojtob'ej nayüj <strong>jun k'o wi</strong> o tatz'aqatisaj <strong>display:block</strong>. { learn-more }
inactive-css-position-property-on-unpositioned-box-fix = Tatojtob'ej najikib'a' runuk'ulem <strong>k'ojlemal</strong> chuwäch <strong>jun k'o wi</strong>. { learn-more }
inactive-text-overflow-when-no-overflow-fix = Tatojtob'ej natz'aqatisaj <strong>overflow:hidden</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = <strong>{ $property }</strong> man koch'on ta pa re taq okik'amaya'l re':
css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong> xok jun tojtob'enel b'anikil, ri ojer chik chuwäch ri W3C taq b'eyal. Man koch'el ta pa re taq okik'amaya'l re':
css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong> xok jun tojtob'enel b'anikil ri ojer chik chuwäch ri W3C taq b'anikil.
css-compatibility-deprecated-message = <strong>{ $property }</strong> ojer chik chuwäch ri W3C taq b'eyal. Man koch'el ta pa re taq okik'amaya'l re':
css-compatibility-deprecated-supported-message = <strong>{ $property }</strong> ojer chik chuwäch ri W3C taq b'eyal.
css-compatibility-experimental-message = <strong>{ $property }</strong> jun tojtob'enel b'anikil. Man koch'el ta pa re taq okik'amaya'l re':
css-compatibility-experimental-supported-message = <strong>{ $property }</strong> jun tojtob'enel b'anikil.
css-compatibility-learn-more-message = <span data-l10n-name="link">Tetamäx ch'aqa' chik</span> chi rij <strong>{ $rootProperty }</strong>
