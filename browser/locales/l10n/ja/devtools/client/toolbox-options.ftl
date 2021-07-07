# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = 標準の開発ツール
# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * 現在のツールボックスには対応していません
# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = 開発ツールのアドオン
# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = 利用可能なツールボックスボタン
# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = テーマ

## Inspector section

# The heading
options-context-inspector = 調査
# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = ブラウザー CSS を表示
options-show-user-agent-styles-tooltip =
    .title = このオプションを有効にすると、ブラウザーが読み込んだ既定のスタイルを表示します。
# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = DOM 属性値を省略
options-collapse-attrs-tooltip =
    .title = 値の長い属性を省略します

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = 既定の色単位
options-default-color-unit-authored = 記述通りの単位
options-default-color-unit-hex = 16 進数
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = 色の名前

## Style Editor section

# The heading
options-styleeditor-label = スタイルエディター
# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = CSS 自動補完
options-stylesheet-autocompletion-tooltip =
    .title = スタイルエディターで CSS プロパティ、値、セレクター入力時に自動補完します

## Screenshot section

# The heading
options-screenshot-label = スクリーンショットの動作

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-only-label = スクリーンショットをクリップボードだけにコピー
options-screenshot-clipboard-tooltip2 =
    .title = スクリーンショットをクリップボードに直接保存します

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = カメラのシャッター音を再生
options-screenshot-audio-tooltip =
    .title = スクリーンショット撮影時のカメラ音声を有効にします

## Editor section

# The heading
options-sourceeditor-label = エディター設定
options-sourceeditor-detectindentation-tooltip =
    .title = ソースの内容からインデントを推測します
options-sourceeditor-detectindentation-label = インデントを検知
options-sourceeditor-autoclosebrackets-tooltip =
    .title = 閉じ括弧を自動的に入力します
options-sourceeditor-autoclosebrackets-label = 閉じ括弧自動入力
options-sourceeditor-expandtab-tooltip =
    .title = タブ文字の代わりにスペース文字を使います
options-sourceeditor-expandtab-label = インデントにスペース文字を使う
options-sourceeditor-tabsize-label = タブ幅
options-sourceeditor-keybinding-label = キー割り当て
options-sourceeditor-keybinding-default-label = 既定

## Advanced section

# The heading (this item is also used in perftools.ftl)
options-context-advanced-settings = 詳細設定
# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = HTTP キャッシュを無効化 (ツールボックスを開いているとき)
options-disable-http-cache-tooltip =
    .title = このオプションを有効にすると、ツールボックスを開いているときはすべてのタブの HTTP キャッシュを無効にします。ただし、Service Worker はこのオプションに影響されません
# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = JavaScript を無効化 *
options-disable-javascript-tooltip =
    .title = このオプションを有効にすると、現在のタブの JavaScript を無効にします。タブまたはツールボックスを閉じると、この設定は元に戻されます
# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = ブラウザーとアドオンのデバッガーを有効化
options-enable-chrome-tooltip =
    .title = さまざまな開発ツールがブラウザーコンテキスト (ツール > ウェブ開発 > ブラウザーツールボックス) とアドオンマネージャーからのアドオンデバッグで使えるようになります

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = リモートデバッガーを有効化
options-enable-remote-tooltip2 =
    .title = このオプションを有効にすると、このブラウザーインスタンスをリモートでデバッグできるようになります

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = HTTP による Service Worker を有効化 (ツールボックスを開いたとき)
options-enable-service-workers-http-tooltip =
    .title = このオプションを有効にすると、ツールボックスを開いているすべてのタブで HTTP による Service Worker を有効にします
# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = ソースマップを有効化
options-source-maps-tooltip =
    .title = このオプションを有効にすると、ソースがツールにマッピングされます
# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * 現在のセッションのみ有効。再読み込みで復帰

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Gecko プラットフォームのデータを表示
options-show-platform-data-tooltip =
    .title = このオプションを有効にすると、JavaScript プロファイラの出力に Gecko プラットフォームのシンボルが含まれるようになります
