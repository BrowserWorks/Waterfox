# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## Window controls

messenger-window-minimize-button =
    .tooltiptext = 最小化
messenger-window-maximize-button =
    .tooltiptext = 最大化
messenger-window-restore-down-button =
    .tooltiptext = 元に戻す
messenger-window-close-button =
    .tooltiptext = 閉じる

# Variables:
# $count (Number) - Number of unread messages.
unread-messages-os-tooltip =
    { $count ->
         [one] 1 通の未読メッセージ
        *[other] { $count } 通の未読メッセージ
    }

about-rights-notification-text = { -brand-short-name } は無料のオープンソースソフトウェアであり、世界中の多数のコミュニティによって開発されています。

## Content tabs

content-tab-page-loading-icon =
    .alt = ページの読み込み中です
content-tab-security-high-icon =
    .alt = 安全な接続です
content-tab-security-broken-icon =
    .alt = 安全な接続ではありません

## Toolbar

addons-and-themes-toolbarbutton =
    .label = アドオンとテーマ
    .tooltiptext = アドオンを管理します
quick-filter-toolbarbutton =
    .label = クイックフィルター
    .tooltiptext = メッセージを絞り込みます
redirect-msg-button =
    .label = リダイレクト
    .tooltiptext = 選択したメッセージをリダイレクトします

## Folder Pane

folder-pane-toolbar =
    .toolbarname = フォルダーペインツールバー
    .accesskey = F
folder-pane-toolbar-options-button =
    .tooltiptext = フォルダーペインのオプション
folder-pane-header-label = フォルダー

## Folder Toolbar Header Popup

folder-toolbar-hide-toolbar-toolbarbutton =
    .label = ツールバーを隠す
    .accesskey = H
show-all-folders-label =
    .label = すべてのフォルダー
    .accesskey = A
show-unread-folders-label =
    .label = 未読フォルダー
    .accesskey = n
show-favorite-folders-label =
    .label = お気に入りフォルダー
    .accesskey = F
show-smart-folders-label =
    .label = 統合フォルダー
    .accesskey = U
show-recent-folders-label =
    .label = 最近使用したフォルダー
    .accesskey = R
folder-toolbar-toggle-folder-compact-view =
    .label = コンパクトビュー
    .accesskey = C

## Menu

redirect-msg-menuitem =
    .label = リダイレクト
    .accesskey = D
menu-file-save-as-file =
    .label = ファイル...
    .accesskey = F

## AppMenu

appmenu-save-as-file =
    .label = ファイル...
appmenu-settings =
    .label = 設定
appmenu-addons-and-themes =
    .label = アドオンとテーマ
appmenu-help-enter-troubleshoot-mode =
    .label = トラブルシューティングモード...
appmenu-help-exit-troubleshoot-mode =
    .label = トラブルシューティングモードをオフにする
appmenu-help-more-troubleshooting-info =
    .label = トラブルシューティング情報
appmenu-redirect-msg =
    .label = リダイレクト

## Context menu

context-menu-redirect-msg =
    .label = リダイレクト
mail-context-delete-messages =
    .label = { $count ->
         [one] メッセージを削除
        *[other] 選択したメッセージを削除
    }
context-menu-decrypt-to-folder =
    .label = 復号したメッセージをコピー
    .accesskey = y

## Message header pane

other-action-redirect-msg =
    .label = リダイレクト
message-header-msg-flagged =
    .title = スター付き
    .aria-label = スター付き
# Variables:
# $address (String) - The email address of the recipient this picture belongs to.
message-header-recipient-avatar =
    .alt = { $address } のプロファイル写真

## Message header cutomize panel

message-header-customize-panel-title = メッセージヘッダー設定
message-header-customize-button-style =
    .value = ボタンのスタイル
    .accesskey = B
message-header-button-style-default =
    .label = アイコンとテキスト
message-header-button-style-text =
    .label = テキストのみ
message-header-button-style-icons =
    .label = アイコンのみ
message-header-show-sender-full-address =
    .label = 常に送信者の完全アドレスを表示する
    .accesskey = f
message-header-show-sender-full-address-description = メールアドレスが表示名の下に表示されます。
message-header-show-recipient-avatar =
    .label = 送信者のプロファイル写真を表示する
    .accesskey = p
message-header-hide-label-column =
    .label = ラベル列を隠す
    .accesskey = l
message-header-large-subject =
    .label = 件名を拡大表示する
    .accesskey = s

## Action Button Context Menu

toolbar-context-menu-manage-extension =
    .label = 拡張機能の管理
    .accesskey = E
toolbar-context-menu-remove-extension =
    .label = 拡張機能を削除
    .accesskey = v

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = { $name } を削除しますか？
addon-removal-confirmation-button = 削除
addon-removal-confirmation-message = { $name } とその設定およびデータを { -brand-short-name } から削除しますか？
caret-browsing-prompt-title = キャレットブラウジング
caret-browsing-prompt-text = F7 キーを押すとキャレットブラウジングのオンとオフを切り替えられます。この機能は、移動可能なカーソルをコンテンツ内に配置して、キーボードでテキストを選択できるようにします。キャレットブラウジングをオンにしますか？
caret-browsing-prompt-check-text = 今後は確認しない
repair-text-encoding-button =
    .label = テキストエンコーディングを修復
    .tooltiptext = メッセージ本文の適切なテキストエンコーディングを推定します

## no-reply handling

no-reply-title = 返信に対応していません
no-reply-message = この返信アドレス ({ $email }) は通信相手が監視していません。このアドレスへのメッセージは誰にも読まれることがないでしょう。
no-reply-reply-anyway-button = 強制返信する

## error messages

decrypt-and-copy-failures = { $failures } / { $total } 通のメッセージが復号できなかったためコピーされませんでした。

## Spaces toolbar

# (^m^) menubar.ftl の menu-spaces-toolbar-button と同じ
spaces-toolbar-element =
    .toolbarname = スペースツールバー
    .aria-label = スペースツールバー
    .aria-description = 異なるスペースに切り替えるための垂直ツールバーです。矢印キーを使って利用可能なボタンへ移動してください。
spaces-toolbar-button-mail2 =
    .title = メール
spaces-toolbar-button-address-book2 =
    .title = アドレス帳
spaces-toolbar-button-calendar2 =
    .title = カレンダー
spaces-toolbar-button-tasks2 =
    .title = ToDo
spaces-toolbar-button-chat2 =
    .title = チャット
spaces-toolbar-button-overflow =
    .title = 他のスペース...
spaces-toolbar-button-settings2 =
    .title = 設定を開きます
spaces-toolbar-button-hide =
    .title = スペースツールバーを隠します
spaces-toolbar-button-show =
    .title = スペースツールバーを表示します
spaces-context-new-tab-item =
    .label = 新しいタブで開く
spaces-context-new-window-item =
    .label = 新しいウィンドウで開く
# Variables:
# $tabName (String) - The name of the tab this item will switch to.
spaces-context-switch-tab-item =
    .label = { $tabName }に切り替える
settings-context-open-settings-item2 =
    .label = 設定
settings-context-open-account-settings-item2 =
    .label = アカウント設定
settings-context-open-addons-item2 =
    .label = アドオンとテーマ

## Spaces toolbar pinned tab menupopup

spaces-toolbar-pinned-tab-button =
    .tooltiptext = スペースメニュー
spaces-pinned-button-menuitem-mail2 =
    .label = { spaces-toolbar-button-mail2.title }
spaces-pinned-button-menuitem-address-book2 =
    .label = { spaces-toolbar-button-address-book2.title }
spaces-pinned-button-menuitem-calendar2 =
    .label = { spaces-toolbar-button-calendar2.title }
spaces-pinned-button-menuitem-tasks2 =
    .label = { spaces-toolbar-button-tasks2.title }
spaces-pinned-button-menuitem-chat2 =
    .label = { spaces-toolbar-button-chat2.title }
spaces-pinned-button-menuitem-settings2 =
    .label = 設定
spaces-pinned-button-menuitem-show =
    .label = スペースツールバーを表示
# Variables:
# $count (Number) - Number of unread messages.
chat-button-unread-messages = { $count }
    .title = { $count ->
        [one] 1 件の未読メッセージ
        *[other] { $count } 件の未読メッセージ
    }
## Spaces toolbar customize panel

menuitem-customize-label =
    .label = カスタマイズ...
spaces-customize-panel-title = スペースツールバー設定
spaces-customize-background-color = 背景の色
spaces-customize-icon-color = ボタンの色
# The background color used on the buttons of the spaces toolbar when they are
# `current`, meaning the related space/tab is active and visible.
spaces-customize-accent-background-color = 選択されたボタンの背景色
# The icon color used on the buttons of the spaces toolbar when they are
# `current`, meaning the related space/tab is active and visible.
spaces-customize-accent-text-color = 選択されたボタンの色
spaces-customize-button-restore = 初期設定に戻す
    .accesskey = R
customize-panel-button-save = 完了
    .accesskey = D
