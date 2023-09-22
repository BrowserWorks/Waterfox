# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear in Origin Controls for Extensions.  Currently,
## they are visible in the context menu for extension toolbar buttons,
## and are used to inform the user how the extension can access their
## data for the current website, and allow them to control it.

origin-controls-no-access =
    .label = 擴充套件不可讀取或變更任何網站資料
origin-controls-quarantined =
    .label = 不允許擴充套件讀取或變更任何網站資料
origin-controls-quarantined-status =
    .label = 不允許於受限制的網站運作的擴充套件
origin-controls-quarantined-allow =
    .label = 允許於受限制的網站運作
origin-controls-options =
    .label = 擴充套件可讀取或變更下列網站資料：
origin-controls-option-all-domains =
    .label = 所有網站
origin-controls-option-when-clicked =
    .label = 只在點擊同意後
# This string denotes an option that grants the extension access to
# the current site whenever they visit it.
# Variables:
#   $domain (String) - The domain for which the access is granted.
origin-controls-option-always-on =
    .label = 針對 { $domain } 總是允許

## These strings are used to map Origin Controls states to user-friendly
## messages. They currently appear in the unified extensions panel.

origin-controls-state-no-access = 無法對此網站讀取或變更資料
origin-controls-state-quarantined = { -vendor-short-name } 不允許於此網站使用
origin-controls-state-always-on = 總是可以對此網站讀取或變更資料
origin-controls-state-when-clicked = 需要點擊授權才可讀取或變更資料
origin-controls-state-hover-run-visit-only = 只對此次造訪執行
origin-controls-state-runnable-hover-open = 開啟擴充套件
origin-controls-state-runnable-hover-run = 執行擴充套件
origin-controls-state-temporary-access = 可在此次造訪讀取或變更資料

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
    .tooltiptext = { $extensionTitle } 需要權限
# Extension's toolbar button when quarantined.
# Note that the new line is intentionally part of the tooltip.
origin-controls-toolbar-button-quarantined =
    .label = { $extensionTitle }
    .tooltiptext =
        { $extensionTitle }
        { -vendor-short-name } 不允許於此網站運作
