# This Source Code Form is subject to the terms of the BrowserWorks Public
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
grid-row-column-positions = 列 { $row } / 行 { $column }

# The layout type of an element shown in the infobar when hovering over a DOM element and
# it is a grid container.
gridtype-container = Grid 容器

# The layout type of an element shown in the infobar when hovering over a DOM element and
# it is a grid item.
gridtype-item = Grid 項目

# The layout type of an element shown in the infobar when hovering over a DOM element and
# it is both a grid container and a grid item.
gridtype-dual = Grid 容器 / 項目

# The layout type of an element shown in the infobar when hovering over a DOM element and
# it is a flex container.
flextype-container = Flex 容器

# The layout type of an element shown in the infobar when hovering over a DOM element and
# it is a flex item.
flextype-item = Flex 項目

# The layout type of an element shown in the infobar when hovering over a DOM element and
# it is both a flex container and a flex item.
flextype-dual = Flex 容器 / 項目

# The message displayed in the content page when the user clicks on the
# "Pick an element from the page" in about:devtools-toolbox inspector panel, when
# debugging a remote page.
# Variables
# $action (string) - Will either be remote-node-picker-notice-action-desktop or
#                    remote-node-picker-notice-action-touch
remote-node-picker-notice = 已啟用 DevTools 元素挑選器，{ $action }

# Text displayed in `remote-node-picker-notice`, when the remote page is on desktop
remote-node-picker-notice-action-desktop = 點擊元素即可在檢測器中選擇

# Text displayed in `remote-node-picker-notice`, when the remote page is on Android
remote-node-picker-notice-action-touch = 點擊元素即可在檢測器中選擇

# The text displayed in the button that is in the notice in the content page when the user
# clicks on the "Pick an element from the page" in about:devtools-toolbox inspector panel,
# when debugging a remote page.
remote-node-picker-notice-hide-button = 隱藏

# The text displayed in a toolbox notification message which is only displayed
# if prefers-reduced-motion is enabled (via OS-level settings or by using the
# ui.prefersReducedMotion=1 preference).
simple-highlighters-message = 開啟 prefers-reduced-motion 後，可在設定面板中開啟比較簡單的強調器，來避免色彩閃爍。

# Text displayed in a button inside the "simple-highlighters-message" toolbox
# notification. "Settings" here refers to the DevTools settings panel.
simple-highlighters-settings-button = 開啟選項
