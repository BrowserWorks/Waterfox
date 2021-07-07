# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = 新しい { -brand-short-name } をどうぞよろしく
upgrade-dialog-new-subtitle = より速くあなたの行きたいところへ行けるようデザインされました。
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline
# style to be automatically added to the text inside it. { -brand-short-name }
# should stay inside the span.
upgrade-dialog-new-alt-subtitle = クリックして <span data-l10n-name="zap">{ -brand-short-name }</span> を始めましょう
upgrade-dialog-new-item-menu-title = 一新されたツールバーとメニュー
upgrade-dialog-new-item-menu-description = 重要なものに優先順位をつけて、必要なものがすぐに見つかるようになりました。
upgrade-dialog-new-item-tabs-title = モダンなタブ
upgrade-dialog-new-item-tabs-description = 情報を適切に収めて、柔軟な動作をサポートし、操作に集中できます。
upgrade-dialog-new-item-icons-title = 新しいアイコンと明瞭なメッセージ
upgrade-dialog-new-item-icons-description = 明るいタッチで使いやすくなりました。
upgrade-dialog-new-primary-primary-button = { -brand-short-name } を優先ブラウザーに設定
    .title = { -brand-short-name } を既定のブラウザーに設定して、タスクバーにピン留めしましょう
upgrade-dialog-new-primary-default-button = { -brand-short-name } を既定のブラウザーに設定
upgrade-dialog-new-primary-pin-button = { -brand-short-name } をタスクバーにピン留め
upgrade-dialog-new-primary-pin-alt-button = タスクバーにピン留め
upgrade-dialog-new-primary-theme-button = テーマを選択
upgrade-dialog-new-secondary-button = 後で

# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = OK

## Pin Firefox screen
##
## These title, subtitle and button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-pin-title = { PLATFORM() ->
    [macos] { -brand-short-name } を Dock に追加
   *[other] { -brand-short-name } をタスクバーにピン留め
}
# The English macOS string avoids repeating "Keep" a third time, so if your
# translations don't repeat anyway, the same string can be used cross-platform.
upgrade-dialog-pin-subtitle = { PLATFORM() ->
    [macos] 最新の { -brand-short-name } にすぐアクセスできるようにしましょう。
   *[other] 最新の { -brand-short-name } をすぐ手の届くところにおきましょう。
}
upgrade-dialog-pin-primary-button = { PLATFORM() ->
    [macos] Dock に追加
   *[other] タスクバーにピン留め
}
upgrade-dialog-pin-secondary-button = 後で

## Default browser screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title = { -brand-short-name } を既定のブラウザーに設定しますか？
upgrade-dialog-default-subtitle = いつでも高速、安全、プライベートに。
upgrade-dialog-default-primary-button = 既定のブラウザーに設定する

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title-2 = { -brand-short-name } を既定のブラウザーに設定
upgrade-dialog-default-subtitle-2 = 高速、安全、プライベートなブラウザーにお任せください。
upgrade-dialog-default-primary-button-2 = 既定のブラウザーに設定する
upgrade-dialog-default-secondary-button = 後で

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title =
    テーマを更新して
    新しく始める

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 = できたてのテーマで新しく始める
upgrade-dialog-theme-system = システムテーマ
    .title = OS のボタン、メニュー、ウィンドウの外観です
upgrade-dialog-theme-light = Light
    .title = 明るい外観のボタン、メニュー、ウィンドウを使用します
upgrade-dialog-theme-dark = Dark
    .title = 暗い外観のボタン、メニュー、ウィンドウを使用します
upgrade-dialog-theme-alpenglow = Alpenglow
    .title = ダイナミックでカラフルな外観のボタン、メニュー、ウィンドウを使用します
upgrade-dialog-theme-keep = 以前のテーマ
    .title = { -brand-short-name } を更新する前にインストールしていたテーマを使用します
upgrade-dialog-theme-primary-button = テーマを保存
upgrade-dialog-theme-secondary-button = 後で
