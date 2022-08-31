# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains strings used in highlighters.
### Highlighters are visualizations that DevTools draws on top of content to aid
### in understanding content sizing, etc.

# The row and column position of a grid cell shown in the grid cell infobar when hovering
# over the CSS grid outline.
# Variables
# $row (integer) - The row index
# $column (integer) - The column index
grid-row-column-positions = Hàng { $row } / Cột { $column }

# The layout type of an element shown in the infobar when hovering over a DOM element and
# it is a grid container.
gridtype-container = Ngăn chứa lưới

# The layout type of an element shown in the infobar when hovering over a DOM element and
# it is a grid item.
gridtype-item = Mục lưới

# The layout type of an element shown in the infobar when hovering over a DOM element and
# it is both a grid container and a grid item.
gridtype-dual = Ngăn chứa/mục lưới

# The layout type of an element shown in the infobar when hovering over a DOM element and
# it is a flex container.
flextype-container = Ngăn chứa Flex

# The layout type of an element shown in the infobar when hovering over a DOM element and
# it is a flex item.
flextype-item = Mục Flex

# The layout type of an element shown in the infobar when hovering over a DOM element and
# it is both a flex container and a flex item.
flextype-dual = Ngăn chứa/mục Flex

# The message displayed in the content page when the user clicks on the
# "Pick an element from the page" in about:devtools-toolbox inspector panel, when
# debugging a remote page.
# Variables
# $action (string) - Will either be remote-node-picker-notice-action-desktop or
#                    remote-node-picker-notice-action-touch
remote-node-picker-notice = Đã bật trình chọn Node của DevTools. { $action }

# Text displayed in `remote-node-picker-notice`, when the remote page is on desktop
remote-node-picker-notice-action-desktop = Nhấp vào một phần tử để chọn nó trong Trình kiểm tra

# Text displayed in `remote-node-picker-notice`, when the remote page is on Android
remote-node-picker-notice-action-touch = Nhấn vào một phần tử để chọn nó trong Trình kiểm tra

# The text displayed in the button that is in the notice in the content page when the user
# clicks on the "Pick an element from the page" in about:devtools-toolbox inspector panel,
# when debugging a remote page.
remote-node-picker-notice-hide-button = Ẩn
