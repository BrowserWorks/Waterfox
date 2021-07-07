# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## App Menu

appmenuitem-update-banner3 =
    .label-update-downloading = { -brand-shorter-name } の更新をダウンロード中
    .label-update-available = 更新可能 — 今すぐダウンロード
    .label-update-manual = 更新可能 — 今すぐダウンロード
    .label-update-unsupported = 更新不可 — システムの互換性なし
    .label-update-restart = 更新可能 — 今すぐ再起動
appmenuitem-protection-dashboard-title = プライバシー保護ダッシュボード
appmenuitem-customize-mode =
    .label = カスタマイズ...

## Zoom Controls

appmenuitem-new-tab =
    .label = 新しいタブ
appmenuitem-new-window =
    .label = 新しいウィンドウ
appmenuitem-new-private-window =
    .label = 新しいプライベートウィンドウ
appmenuitem-passwords =
    .label = パスワード
appmenuitem-addons-and-themes =
    .label = アドオンとテーマ
appmenuitem-find-in-page =
    .label = このページを検索...
appmenuitem-more-tools =
    .label = その他のツール
appmenuitem-exit2 =
    .label = 終了
appmenu-menu-button-closed2 =
    .tooltiptext = アプリケーションメニューを開きます
    .label = { -brand-short-name }
appmenu-menu-button-opened2 =
    .tooltiptext = アプリケーションメニューを閉じます
    .label = { -brand-short-name }
# Settings is now used to access the browser settings across all platforms,
# instead of Options or Preferences.
appmenuitem-settings =
    .label = 設定

## Zoom and Fullscreen Controls

appmenuitem-zoom-enlarge =
    .label = 拡大
appmenuitem-zoom-reduce =
    .label = 縮小
appmenuitem-fullscreen =
    .label = 全画面表示

## Firefox Account toolbar button and Sync panel in App menu.

fxa-toolbar-sync-now =
    .label = 今すぐ同期
appmenu-remote-tabs-sign-into-sync =
    .label = ログインして同期...
appmenu-remote-tabs-turn-on-sync =
    .label = 同期をオンにする...
appmenuitem-fxa-toolbar-sync-now2 = 今すぐ同期
appmenuitem-fxa-manage-account = アカウントを管理
appmenu-fxa-header2 = { -fxaccount-brand-name }
# Variables
# $time (string) - Localized relative time since last sync (e.g. 1 second ago,
# 3 hours ago, etc.)
appmenu-fxa-last-sync = 最終同期: { $time }
    .label = 最終同期: { $time }
appmenu-fxa-sync-and-save-data2 = 同期してデータを保存
appmenu-fxa-signed-in-label = ログイン
appmenu-fxa-setup-sync =
    .label = 同期をオンにする...
appmenu-fxa-show-more-tabs = さらにタブを表示
appmenuitem-save-page =
    .label = 名前を付けてページを保存...

## What's New panel in App menu.

whatsnew-panel-header = 新着情報
# Checkbox displayed at the bottom of the What's New panel, allowing users to
# enable/disable What's New notifications.
whatsnew-panel-footer-checkbox =
    .label = 新機能を通知する
    .accesskey = f

## The Firefox Profiler – The popup is the UI to turn on the profiler, and record
## performance profiles. To enable it go to profiler.firefox.com and click
## "Enable Profiler Menu Button".

profiler-popup-title =
    .value = { -profiler-brand-name }
profiler-popup-reveal-description-button =
    .aria-label = 詳細な情報を表示
profiler-popup-description-title =
    .value = 記録、分析、共有
profiler-popup-description = プロファイルを公開してあなたのチームと共有し、パフォーマンス問題に協力しましょう。
profiler-popup-learn-more = 詳細
profiler-popup-settings =
    .value = 設定
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings = 設定を編集...
profiler-popup-disabled = プライベートウィンドウを開いているため、プロファイラーは現在無効です。
profiler-popup-recording-screen = 記録中...
# The profiler presets list is generated elsewhere, but the custom preset is defined
# here only.
profiler-popup-presets-custom =
    .label = カスタム
profiler-popup-start-recording-button =
    .label = 記録を開始
profiler-popup-discard-button =
    .label = 破棄
profiler-popup-capture-button =
    .label = キャプチャ
profiler-popup-start-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧1
       *[other] Ctrl+Shift+1
    }
profiler-popup-capture-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧2
       *[other] Ctrl+Shift+2
    }

## History panel

appmenu-manage-history =
    .label = 履歴を管理
appmenu-reopen-all-tabs = タブをすべて開きなおす
appmenu-reopen-all-windows = ウィンドウをすべて開きなおす
appmenu-restore-session =
    .label = 以前のセッションを復元
appmenu-clear-history =
    .label = 最近の履歴を消去...
appmenu-recent-history-subheader = 最近の履歴
appmenu-recently-closed-tabs =
    .label = 最近閉じたタブ
appmenu-recently-closed-windows =
    .label = 最近閉じたウィンドウ

## Help panel

appmenu-help-header =
    .title = { -brand-shorter-name } ヘルプ
appmenu-about =
    .label = { -brand-shorter-name } について
    .accesskey = A
appmenu-get-help =
    .label = ヘルプを表示
    .accesskey = h
appmenu-help-more-troubleshooting-info =
    .label = 他のトラブルシューティング情報
    .accesskey = t
appmenu-help-report-site-issue =
    .label = サイトの問題を報告...
appmenu-help-feedback-page =
    .label = フィードバックを送信...
    .accesskey = S

## appmenu-help-enter-troubleshoot-mode and appmenu-help-exit-troubleshoot-mode
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-enter-troubleshoot-mode2 =
    .label = トラブルシューティングモード...
    .accesskey = M
appmenu-help-exit-troubleshoot-mode =
    .label = トラブルシューティングモードをオフにする
    .accesskey = M

## appmenu-help-report-deceptive-site and appmenu-help-not-deceptive
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-report-deceptive-site =
    .label = 詐欺サイトを報告...
    .accesskey = d
appmenu-help-not-deceptive =
    .label = 詐欺サイトの誤報告を指摘...
    .accesskey = d

## More Tools

appmenu-customizetoolbar =
    .label = ツールバーをカスタマイズ...
appmenu-taskmanager =
    .label = タスクマネージャー
appmenu-developer-tools-subheader = ブラウザーツール
appmenu-developer-tools-extensions =
    .label = 開発者用拡張機能
