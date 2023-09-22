# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Læs mere</span>

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".
##   $display (string) - A CSS display value e.g. "inline-block".

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> har ingen effekt på dette element, fordi det ikke er en flex-container eller en grid-container.
inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> har ingen effekt på dette element, fordi det ikke er en flex-container, grid-container eller en container, der strækker sig over flere kolonner.
inactive-css-not-multicol-container = <strong>{ $property }</strong> har ingen effekt på dette element, eftersom det ikke er en container med flere kolonner.
inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> har ingen effekt på dette element, fordi det ikke er et grid-element eller et flex-element.
inactive-css-not-grid-item = <strong>{ $property }</strong> har ingen effekt på dette element, fordi det ikke er et grid-element.
inactive-css-not-grid-container = <strong>{ $property }</strong> har ingen effekt på dette element, fordi det ikke er en grid-container.
inactive-css-not-flex-item = <strong>{ $property }</strong> har ingen effekt på dette element, fordi det ikke er et flex-element.
inactive-css-not-flex-container = <strong>{ $property }</strong> har ingen effekt på dette element, fordi det ikke er en flex-container.
inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong> har ingen effekt på dette element, fordi det ikke er et inline-element eller en celle i en tabel.
inactive-css-first-line-pseudo-element-not-supported = <strong>{ $property }</strong> er ikke understøttet på pseudo-elementer af typen ::first-line
inactive-css-placeholder-pseudo-element-not-supported = <strong>{ $property }</strong> er ikke understøttet på pseudo-elementer af typen ::placeholder.
inactive-css-property-because-of-display = <strong>{ $property }</strong> har ingen effekt på dette element, fordi elementets display er sat til <strong>{ $display }</strong>.
inactive-css-not-display-block-on-floated = Værdien <strong>display</strong> er blevet ændret til <strong>block</strong> fordi elementet er <strong>floated</strong>.
inactive-css-property-is-impossible-to-override-in-visited = Det er umuligt at tilsidesætte <strong>{ $property }</strong> på grund af begrænsning for <strong>:visited</strong>.
inactive-css-position-property-on-unpositioned-box = <strong>{ $property }</strong> har ingen effekt på dette element, fordi det ikke er et placeret element.
inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> har ingen effekt på dette element, fordi <strong>overflow:hidden</strong> ikke er sat.
inactive-css-not-for-internal-table-elements = <strong>{ $property }</strong>  har ingen effekt på interne tabel-elementer.
inactive-css-not-for-internal-table-elements-except-table-cells = <strong>{ $property }</strong> har ingen effekt på interne tabel-elementer, bortset fra tabel-celler.
inactive-css-not-table = <strong>{ $property }</strong> har ingen effekt på dette element, fordi det ikke er en tabel.
inactive-css-not-table-cell = <strong>{ $property }</strong> har ingen effekt på dette element, eftersom det ikke er en tabelcelle.
inactive-scroll-padding-when-not-scroll-container = <strong>{ $property }</strong> har ingen effekt på dette element, fordi det ikke kan scrolles.
inactive-css-border-image = <strong>{ $property }</strong>  har ingen effekt på dette element, eftersom den ikke kan anvendes på interne tabel-elementer, hvor <strong>border-collapse</strong> er sat til <strong>collapse</strong> på det overordnede element.
inactive-css-ruby-element = <strong>{ $property }</strong> har ingen effekt på dette element, da det er et ruby-element. Dets størrelse er afgjort af ruby-elementets skriftstørrelse.
inactive-css-highlight-pseudo-elements-not-supported = <strong>{ $property }</strong> er ikke understøttet på pseudo-elementer brugt til fremhævning (fx ::selection).

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Prøv at tilføje  <strong>display:grid</strong> eller <strong>display:flex</strong>. { learn-more }
inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Prøv at tilføje <strong>display:grid</strong>, <strong>display:flex</strong> eller <strong>columns:2</strong>. { learn-more }
inactive-css-not-multicol-container-fix = Prøv at tilføje enten <strong>column-count</strong> eller <strong>column-width</strong>. { learn-more }
inactive-css-not-grid-or-flex-item-fix-3 = Prøv at tilføje <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong> eller <strong>display:inline-flex</strong> til elementets forælder. { learn-more }
inactive-css-not-grid-item-fix-2 = Prøv at tilføje <strong>display:grid</strong> eller <strong>display:inline-grid</strong> til elementets forælder. { learn-more }
inactive-css-not-grid-container-fix = Prøv at tilføje <strong>display:grid</strong> eller <strong>display:inline-grid</strong>. { learn-more }
inactive-css-not-flex-item-fix-2 = Prøv at tilføje <strong>display:flex</strong> eller <strong>display:inline-flex</strong> til elementets forælder. { learn-more }
inactive-css-not-flex-container-fix = Prøv at tilføje <strong>display:flex</strong> eller <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-inline-or-tablecell-fix = Prøv at tilføje <strong>display:inline</strong> eller <strong>display:table-cell</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Prøv at tilføje <strong>display:inline-block</strong> eller <strong>display:block</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Prøv at tilføje <strong>display:inline-block</strong>. { learn-more }
inactive-css-not-display-block-on-floated-fix = Prøv at fjerne <strong>float</strong> eller tilføje <strong>display:block</strong>. { learn-more }
inactive-css-position-property-on-unpositioned-box-fix = Prøv at sætte elements <strong>position</strong>-egenskab til noget andet end <strong>static</strong>. { learn-more }
inactive-text-overflow-when-no-overflow-fix = Prøv at tilføje <strong>overflow:hidden</strong>. { learn-more }
inactive-css-not-for-internal-table-elements-fix = Prøv at sætte <strong>display</strong>-egenskaben til noget andet end<strong>table-cell</strong>, <strong>table-column</strong>, <strong>table-row</strong>, <strong>table-column-group</strong>, <strong>table-row-group</strong> eller <strong>table-footer-group</strong>. { learn-more }
inactive-css-not-for-internal-table-elements-except-table-cells-fix = Prøv at sætte <strong>display</strong>-egenskaben til noget andet end <strong>table-column</strong>, <strong>table-row</strong>, <strong>table-column-group</strong>, <strong>table-row-group</strong> eller <strong>table-footer-group</strong>. { learn-more }
inactive-css-not-table-fix = Prøv at tilføje <strong>display:table</strong> eller <strong>display:inline-table</strong>. { learn-more }
inactive-css-not-table-cell-fix = Prøv at tilføje <strong>display:table-cell</strong>. { learn-more }
inactive-scroll-padding-when-not-scroll-container-fix = Prøv at tilføje <strong>overflow:auto</strong>, <strong>overflow:scroll</strong> eller <strong>overflow:hidden</strong>. { learn-more }
inactive-css-border-image-fix = Fjern egenskaben<strong>border-collapse</strong> eller vælg anden værdi for den end <strong>collapse</strong> for det overordnede tabel-element. { learn-more }
inactive-css-ruby-element-fix = Prøv at ændre ruby-tekstens <strong>skriftstørrelse</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = <strong>{ $property }</strong> er ikke understøttet i følgende browsere:
css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong> var en eksperimentel egenskab, der nu er forældet af W3 C-standarder. Egenskaben er ikke understøttet i følgende browsere:
css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong> var en eksperimentel egenskab, der nu er forældet af W3 C-standarder.
css-compatibility-deprecated-message = <strong>{ $property }</strong> er forældet af W3 C-standarder. Egenskaben er ikke understøttet i følgende browsere:
css-compatibility-deprecated-supported-message = <strong>{ $property }</strong> er forældet af W3 C-standarder.
css-compatibility-experimental-message = <strong>{ $property }</strong> er en eksperimentel egenskab. Den er ikke understøttet i følgende browsere:
css-compatibility-experimental-supported-message = <strong>{ $property }</strong> er en eksperimentel egenskab.
css-compatibility-learn-more-message = <span data-l10n-name="link">Læs mere</span> om <strong>{ $rootProperty }</strong>
