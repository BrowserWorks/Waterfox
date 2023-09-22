# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear in Origin Controls for Extensions.  Currently,
## they are visible in the context menu for extension toolbar buttons,
## and are used to inform the user how the extension can access their
## data for the current website, and allow them to control it.

origin-controls-no-access =
    .label = 扩展不可读取和更改任何数据
origin-controls-quarantined =
    .label = 不允许扩展读取和更改任何数据
origin-controls-quarantined-status =
    .label = 扩展未被允许在受限网站上运行
origin-controls-quarantined-allow =
    .label = 允许在受限网站上运行
origin-controls-options =
    .label = 扩展可以读取和更改下列数据：
origin-controls-option-all-domains =
    .label = 在所有网站
origin-controls-option-when-clicked =
    .label = 仅在点击允许后
# This string denotes an option that grants the extension access to
# the current site whenever they visit it.
# Variables:
#   $domain (String) - The domain for which the access is granted.
origin-controls-option-always-on =
    .label = 总是允许于 { $domain }

## These strings are used to map Origin Controls states to user-friendly
## messages. They currently appear in the unified extensions panel.

origin-controls-state-no-access = 无法读取和更改此网站的数据
origin-controls-state-quarantined = { -vendor-short-name } 不允许在此网站使用
origin-controls-state-always-on = 总能读取和更改此网站的数据
origin-controls-state-when-clicked = 需点击授权以读取和更改数据
origin-controls-state-hover-run-visit-only = 仅在此次访问运行
origin-controls-state-runnable-hover-open = 打开扩展
origin-controls-state-runnable-hover-run = 运行扩展
origin-controls-state-temporary-access = 能在此次访问读取和更改数据

## Extension's toolbar button.
## Variables:
##   $extensionTitle (String) - Extension name or title message.

origin-controls-toolbar-button =
    .label = { $extensionTitle }
    .tooltiptext = { $extensionTitle }
# Extension's toolbar button when permission is needed.
# Note that the new line is intentionally part of the tooltip.
origin-controls-toolbar-button-permission-needed =
    .label = { $extensionTitle }
    .tooltiptext = { $extensionTitle }
# Extension's toolbar button when quarantined.
# Note that the new line is intentionally part of the tooltip.
origin-controls-toolbar-button-quarantined =
    .label = { $extensionTitle }
    .tooltiptext =
        { $extensionTitle }
        已由 { -vendor-short-name } 在此网站上禁用
