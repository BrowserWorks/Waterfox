# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Pelajari lebih lanjut</span>

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

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> tidak berdampak pada elemen ini karena bukan kontainer flex atau kontainer grid.

inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> tidak berdampak pada elemen ini karena bukan kontainer flex, atau kontainer grid, atau kontainer muli-kolom.

inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> tidak berdampak pada elemen ini karena bukan grid atau item flex.

inactive-css-not-grid-item = <strong>{ $property }</strong> tidak berdampak pada elemen ini karena bukan item grid.

inactive-css-not-grid-container = <strong>{ $property }</strong> tidak berdampak pada elemen ini karena bukan kontainer grid.

inactive-css-not-flex-item = <strong>{ $property }</strong> tidak berdampak pada elemen ini karena bukan item flex.

inactive-css-not-flex-container = <strong>{ $property }</strong> tidak berdampak pada elemen ini karena bukan kontainer flex.

inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong> tidak berdampak pada elemen ini karena bukan elemen sebarus atau table-cell.

inactive-css-property-because-of-display = <strong>{ $property }</strong> tidak berdampak pada elemen ini karena memiliki nilai display <strong>{ $display }</strong>..

inactive-css-not-display-block-on-floated = Nilai <strong>display</strong> telah diubah oleh mesin menjadi <strong>block</strong> karena elemennya <strong>mengambang<strong>.

inactive-css-property-is-impossible-to-override-in-visited = Tidak mungkin menimpa <strong>{ $property }</strong> karena pembatasan <strong>:visited</strong>.

inactive-css-position-property-on-unpositioned-box = <strong>{ $property }</strong> tidak berdampak pada elemen ini karena bukan elemen dengan posisi.

inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> tidak berdampak pada elemen ini karena <strong>overflow:hidden</strong> tidak diatur.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Coba tambahkan <strong>display:grid</strong> atau <strong>display:flex</strong>. { learn-more }

inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Coba tambahkan baik <strong>display:grid</strong>, <strong>display:flex</strong>, maupun <strong>columns:2</strong>. { learn-more }

inactive-css-not-grid-or-flex-item-fix-2 = Coba tambahkan <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong>, atau <strong>display:inline-flex</strong>. { learn-more }

inactive-css-not-grid-item-fix-2 = Coba tambahkan <strong>display:grid</strong> atau <strong>display:inline-grid</strong> pada induk elemen. { learn-more }

inactive-css-not-grid-container-fix = Coba tambahkan <strong>display:grid</strong> atau <strong>display:inline-grid</strong>. { learn-more }

inactive-css-not-flex-item-fix-2 = Coba tambahkan <strong>display:flex</strong> atau <strong>display:inline-flex</strong> pada induk elemen. { learn-more }

inactive-css-not-flex-container-fix = Coba tambahkan <strong>display:flex</strong> atau <strong>display:inline-flex</strong>. { learn-more }

inactive-css-not-inline-or-tablecell-fix = Coba tambahkan baik <strong>display:inline</strong> maupun <strong>display:table-cell</strong>. { learn-more }

inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Coba tambahkan baik <strong>display:inline-block</strong> maupun <strong>display:block</strong>. { learn-more }

inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Coba tambahkan <strong>display:inline-block</strong>. { learn-more }

inactive-css-not-display-block-on-floated-fix = Coba hapus <strong>float</strong> atau menambahkan <strong>display:block</strong>. { learn-more }

inactive-css-position-property-on-unpositioned-box-fix = Coba atur properti <strong>position</strong> menjadi selain <strong>static</strong>. { learn-more }

inactive-text-overflow-when-no-overflow-fix = Coba tambahkan <strong>overflow:hidden</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

