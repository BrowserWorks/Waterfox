# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Tìm hiểu thêm</span>

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".
##   $display (string) - A CSS display value e.g. "inline-block".

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> không có tác dụng đối với phần tử này vì nó không phải là ngăn chứa flex hay ngăn chứa lưới.
inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> không có tác dụng đối với phần tử này vì nó không phải là ngăn chứa flex, ngăn chứa lưới hoặc ngăn chứa nhiều cột.
inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> không có tác dụng đối với phần tử này vì nó không phải là một mục lưới hoặc flex.
inactive-css-not-grid-item = <strong>{ $property }</strong> không có tác dụng đối với thành phần này vì nó không phải là một mục lưới.
inactive-css-not-grid-container = <strong>{ $property }</strong> không có tác dụng đối với phần tử này vì nó không phải là ngăn chứa lưới.
inactive-css-not-flex-item = <strong>{ $property }</strong> không có tác dụng đối với phần tử này vì nó không phải là một mục flex.
inactive-css-not-flex-container = <strong>{ $property }</strong> không có tác dụng đối với phần tử này vì nó không phải là ngăn chứa flex.
inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong> không có tác dụng đối với phần tử này vì nó không phải là phần tử nội tuyến hoặc ô bảng.
inactive-css-property-because-of-display = <strong>{ $property }</strong> không ảnh hưởng đến yếu tố này vì nó có hiển thị của <strong>{ $display }</strong>.
inactive-css-not-display-block-on-floated = Giá trị <strong>display</strong> đã được thay đổi bởi máy thành <strong>block</strong> vì phần tử là <strong>floated</strong>.
inactive-css-property-is-impossible-to-override-in-visited = Nó không thể ghi đè <strong>{ $property }</strong> do hạn chế <strong>:visited</strong>.
inactive-css-position-property-on-unpositioned-box = <strong>{ $property }</strong> không có tác dụng đối với phần tử này vì nó không phải là phần tử được định vị.
inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> không ảnh hưởng đến phần tử này vì <strong>overflow:hidden</strong> không được đặt.
inactive-outline-radius-when-outline-style-auto-or-none = <strong>{ $property }</strong> không ảnh hưởng đến phần tử này vì <strong>outline-style</strong> của nó là <strong>auto</strong> hoặc <strong>none</strong>.
inactive-css-not-for-internal-table-elements = <strong>{ $property }</strong> không ảnh hưởng đến các phần tử nội bộ của bảng.
inactive-css-not-for-internal-table-elements-except-table-cells = <strong>{ $property }</strong> không có ảnh hưởng đến các phần tử bên trong bảng ngoại trừ các ô trong bảng.
inactive-css-not-table = <strong>{ $property }</strong> không ảnh hưởng đến phần tử này vì nó không phải là một bảng.
inactive-scroll-padding-when-not-scroll-container = <strong>{ $property }</strong> không ảnh hưởng đến phần tử này vì nó không cuộn.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Hãy thử thêm <strong>display:grid</strong> hoặc <strong>display:flex</strong>. { learn-more }
inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Hãy thử thêm <strong>display:grid</strong>, <strong>display:flex</strong> hoặc <strong>columns:2</strong>. { learn-more }
inactive-css-not-grid-or-flex-item-fix-2 = Hãy thử thêm <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong>, hoặc <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-grid-item-fix-2 = Hãy thử thêm <strong>display:grid</strong> hoặc <strong>display:inline-grid</strong> vào phần tử mẹ. { learn-more }
inactive-css-not-grid-container-fix = Hãy thử thêm <strong>display:grid</strong> hoặc <strong>display:inline-grid</strong>. { learn-more }
inactive-css-not-flex-item-fix-2 = Hãy thử thêm <strong>display:flex</strong> hoặc <strong>display:inline-flex</strong> vào phần tử mẹ. { learn-more }
inactive-css-not-flex-container-fix = Hãy thử thêm <strong>display:flex</strong> hoặc <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-inline-or-tablecell-fix = Hãy thử thêm <strong>display:inline</strong> hoặc <strong>display:table-cell</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Hãy thử thêm <strong>display:inline-block</strong> hoặc <strong>display:block</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Hãy thử thêm <strong>display:inline-block</strong>. { learn-more }
inactive-css-not-display-block-on-floated-fix = Hãy thử xóa <strong>float</strong> hoặc thêm <strong>display:block</strong>. { learn-more }
inactive-css-position-property-on-unpositioned-box-fix = Hãy thử đặt thuộc tính <strong>position</strong> của nó thành một thứ khác ngoài <strong>static</strong>. { learn-more }
inactive-text-overflow-when-no-overflow-fix = Hãy thử thêm <strong>overflow:hidden</strong>. { learn-more }
inactive-css-not-for-internal-table-elements-fix = Hãy thử đặt thuộc tính <strong>display</strong> của nó thành thứ khác ngoài <strong>table-cell</strong>, <strong>table-column</strong>, <strong>table-row</strong>, <strong>table-column-group</strong>, <strong>table-row-group</strong>, hoặc <strong>table-footer-group</strong>. { learn-more }
inactive-css-not-for-internal-table-elements-except-table-cells-fix = Hãy thử đặt thuộc tính <strong>display</strong> của nó thành thứ khác ngoài <strong>table-column</strong>, <strong>table-row</strong>, <strong>table-column-group</strong>, <strong>table-row-group</strong>, hoặc <strong>table-footer-group</strong>. { learn-more }
inactive-outline-radius-when-outline-style-auto-or-none-fix = Thử thay đổi thuộc tính <strong>outline-style</strong> của nó thành một thứ khác ngoài <strong>auto</strong> hoặc <strong>none</strong>. { learn-more }
inactive-css-not-table-fix = Hãy thử thêm <strong>display:table</strong> hoặc <strong>display:inline-table</strong>. { learn-more }
inactive-scroll-padding-when-not-scroll-container-fix = Hãy thử thêm <strong>overflow:auto</strong>, <strong>overflow:scroll</strong>, hoặc <strong>overflow:hidden</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = <strong>{ $property }</strong> không được hỗ trợ trong các trình duyệt sau:
css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong> là thuộc tính thử nghiệm hiện không được hỗ trợ bởi các tiêu chuẩn W3C. Nó không được hỗ trợ trong các trình duyệt sau:
css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong> là thuộc tính thử nghiệm hiện không được hỗ trợ bởi các tiêu chuẩn W3C.
css-compatibility-deprecated-message = <strong>{ $property }</strong> hiện không được hỗ trợ bởi các tiêu chuẩn W3C. Nó không được hỗ trợ trong các trình duyệt sau:
css-compatibility-deprecated-supported-message = <strong>{ $property }</strong> hiện không được hỗ trợ bởi các tiêu chuẩn W3C.
css-compatibility-experimental-message = <strong>{ $property }</strong> là thuộc tính thử nghiệm. Nó không được hỗ trợ trong các trình duyệt sau:
css-compatibility-experimental-supported-message = <strong>{ $property }</strong> là thuộc tính thử nghiệm.
css-compatibility-learn-more-message = <span data-l10n-name="link">Tìm hiểu thêm</span> về <strong>{ $rootProperty }</strong>
