# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

config-window =
    .title = about:config

## Strings used to display a warning in about:config

# This text should be attention grabbing and playful
config-about-warning-title =
    .value = 動作保証対象外になります！
config-about-warning-text = プログラムの高度な設定を変更すると、安定性、セキュリティ、パフォーマンスに深刻な問題を引き起こす恐れがあります。設定変更による影響を完全に理解している場合に限ってご利用ください。
config-about-warning-button =
    .label = 危険性を承知の上で使用する
config-about-warning-checkbox =
    .label = 次回もこの警告を表示する

config-search-prefs =
    .value = 検索:
    .accesskey = r

config-focus-search =
    .key = r

config-focus-search-2 =
    .key = f

## These strings are used for column headers
config-pref-column =
    .label = 設定名
config-lock-column =
    .label = 状態
config-type-column =
    .label = 型
config-value-column =
    .label = 値

## These strings are used for tooltips
config-pref-column-header =
    .tooltip = クリックするとソートされます
config-column-chooser =
    .tooltip = クリックすると表示する列を選択できます

## These strings are used for the context menu
config-copy-pref =
    .key = C
    .label = コピー
    .accesskey = C

config-copy-name =
    .label = 名前をコピー
    .accesskey = N

config-copy-value =
    .label = 値をコピー
    .accesskey = V

config-modify =
    .label = 値を変更
    .accesskey = M

config-toggle =
    .label = 切り替え
    .accesskey = T

config-reset =
    .label = リセット
    .accesskey = R

config-new =
    .label = 新規作成
    .accesskey = w

config-string =
    .label = 文字列...
    .accesskey = S

config-integer =
    .label = 整数値...
    .accesskey = I

config-boolean =
    .label = 真偽値...
    .accesskey = B

config-default = 初期設定値
config-modified = 変更されています
config-locked = ロックされています

config-property-string = 文字列
config-property-int = 整数値
config-property-bool = 真偽値

config-new-prompt = 設定名を入力してください

config-nan-title = 不正な値
config-nan-text = 入力されたテキストが数値ではありません。

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-new-title = 新しい{ $type }の設定名

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-modify-title = { $type }を入力してください
