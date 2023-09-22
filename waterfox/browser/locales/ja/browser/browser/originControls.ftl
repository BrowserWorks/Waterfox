# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear in Origin Controls for Extensions.  Currently,
## they are visible in the context menu for extension toolbar buttons,
## and are used to inform the user how the extension can access their
## data for the current website, and allow them to control it.

origin-controls-no-access =
    .label = データの取得と変更はできません
origin-controls-quarantined =
    .label = データの取得と変更は許可されていません
origin-controls-quarantined-status =
    .label = 制限されたサイトでの実行が許可されていません
origin-controls-quarantined-allow =
    .label = 制限されたサイトで許可
origin-controls-options =
    .label = データの取得と変更を許可する条件:
origin-controls-option-all-domains =
    .label = すべてのサイト上
origin-controls-option-when-clicked =
    .label = クリック時のみ
# This string denotes an option that grants the extension access to
# the current site whenever they visit it.
# Variables:
#   $domain (String) - The domain for which the access is granted.
origin-controls-option-always-on =
    .label = { $domain } サイト上

## These strings are used to map Origin Controls states to user-friendly
## messages. They currently appear in the unified extensions panel.

origin-controls-state-no-access = このサイトのデータの取得と変更: 不可
origin-controls-state-quarantined = このサイトのデータの取得と変更: { -vendor-short-name } により不許可
origin-controls-state-always-on = このサイトのデータの取得と変更: 常に可能
origin-controls-state-when-clicked = このサイトのデータの取得と変更: 権限が必要
origin-controls-state-hover-run-visit-only = 今回のみ実行
origin-controls-state-runnable-hover-open = 拡張機能を開く
origin-controls-state-runnable-hover-run = 拡張機能を実行
origin-controls-state-temporary-access = このサイトのデータの取得と変更: 今回のみ可能

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
    .tooltiptext =
        { $extensionTitle }
        権限が必要です
# Extension's toolbar button when quarantined.
# Note that the new line is intentionally part of the tooltip.
origin-controls-toolbar-button-quarantined =
    .label = { $extensionTitle }
    .tooltiptext =
        { $extensionTitle }
        このサイトは { -vendor-short-name } により許可されていません
