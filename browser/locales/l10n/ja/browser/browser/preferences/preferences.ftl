# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = ウェブサイトに “Do Not Track” 信号を送り、追跡されたくないことを知らせます。
do-not-track-learn-more = 詳細情報
do-not-track-option-default-content-blocking-known =
    .label = 既知のトラッカーをブロックする設定時のみ
do-not-track-option-always =
    .label = 常に送る

pref-page-title =
    { PLATFORM() ->
        [windows] オプション
       *[other] 設定
    }

# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 15.4em
    .placeholder =
        { PLATFORM() ->
            [windows] オプションを検索
           *[other] 設定を検索
        }

settings-page-title = 設定

# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box2 =
    .style = width: 15.4em
    .placeholder = 設定を検索

managed-notice = ご使用のブラウザーはあなたの所属組織に管理されています。

category-list =
    .aria-label = カテゴリー

pane-general-title = 一般
category-general =
    .tooltiptext = { pane-general-title }

pane-home-title = ホーム
category-home =
    .tooltiptext = { pane-home-title }

pane-search-title = 検索
category-search =
    .tooltiptext = { pane-search-title }

pane-privacy-title = プライバシーとセキュリティ
category-privacy =
    .tooltiptext = { pane-privacy-title }

pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }

pane-sync-title3 = 同期
category-sync3 =
    .tooltiptext = { pane-sync-title3 }

pane-experimental-title = 実験的な機能
category-experimental =
    .tooltiptext = 実験的な機能
pane-experimental-subtitle = 注意して進んでください
pane-experimental-search-results-header = 実験的な機能: 注意して進んでください
pane-experimental-description2 = 高度な設定を変更すると、{ -brand-short-name } の性能と安全性に影響を及ぼす可能性があります。

pane-experimental-reset =
  .label = 既定値に戻す
  .accesskey = R

help-button-label = { -brand-short-name } サポート
addons-button-label = 拡張機能とテーマ

focus-search =
    .key = f

close-button =
    .aria-label = 閉じる

## Browser Restart Dialog

feature-enable-requires-restart = この機能を有効にするには、{ -brand-short-name } の再起動が必要です
feature-disable-requires-restart = この機能を無効にするには、{ -brand-short-name } の再起動が必要です
should-restart-title = { -brand-short-name } を再起動
should-restart-ok = { -brand-short-name } を今すぐ再起動
cancel-no-restart-button = キャンセル
restart-later = 後で再起動

## Extension Control Notifications
##
## These strings are used to inform the user
## about changes made by extensions to browser settings.
##
## <img data-l10n-name="icon"/> is going to be replaced by the extension icon.
##
## Variables:
##   $name (String): name of the extension

# This string is shown to notify the user that their home page
# is being controlled by an extension.
extension-controlled-homepage-override = 拡張機能 <img data-l10n-name="icon"/> { $name } によりホームページ設定が変更されています。

# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = 拡張機能 <img data-l10n-name="icon"/> { $name } により新しいタブページが変更されています。

# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlled-password-saving = 拡張機能 <img data-l10n-name="icon"/> { $name } により、この設定が変更されています。

# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = 拡張機能 <img data-l10n-name="icon"/> { $name } により、この設定が変更されています。

# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = 拡張機能 <img data-l10n-name="icon"/> { $name } により既定の検索エンジンが変更されています。

# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = 拡張機能 <img data-l10n-name="icon"/> { $name } がコンテナータブを必要としています。

# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = 拡張機能 <img data-l10n-name="icon"/> { $name } により、この設定が変更されています。

# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = 拡張機能 <img data-l10n-name="icon"/> { $name } が { -brand-short-name } のインターネット接続方法の設定を変更しています。

# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = 拡張機能を有効にするには、<img data-l10n-name="menu-icon"/> メニューから <img data-l10n-name="addons-icon"/> アドオンを開きます。

## Preferences UI Search Results

search-results-header = 検索結果

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] “<span data-l10n-name="query"></span>” オプションについての検索結果はありません。
       *[other] “<span data-l10n-name="query"></span>” 設定についての検索結果はありません。
    }

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message2 =
        申し訳ありません。“<span data-l10n-name="query"></span>” の設定についての検索結果はありません。

search-results-help-link = ヘルプが必要な方は、<a data-l10n-name="url">{ -brand-short-name } サポート</a> をご利用ください

## General Section

startup-header = 起動

# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = { -brand-short-name } と Firefox の同時起動を許可する
use-firefox-sync = ヒント: これは別のプロファイルを使用します。データを共有するには { -sync-brand-short-name } を使用してください。
get-started-not-logged-in = { -sync-brand-short-name } にログインする...
get-started-configured = { -sync-brand-short-name } 設定を開く

always-check-default =
    .label = { -brand-short-name } が既定のブラウザーか確認する
    .accesskey = y

is-default = { -brand-short-name } は既定のブラウザーに設定されています
is-not-default = { -brand-short-name } は既定のブラウザーに設定されていません

set-as-my-default-browser =
    .label = 既定のブラウザーにする...
    .accesskey = D

startup-restore-previous-session =
    .label = 前回のセッションを復元する
    .accesskey = s

startup-restore-warn-on-quit =
    .label = ブラウザーを終了するときは確認する

disable-extension =
    .label = 拡張機能を無効化

tabs-group-header = タブグループ

ctrl-tab-recently-used-order =
    .label = Ctrl+Tab で最近使用した順にタブを切り替える
    .accesskey = T

open-new-link-as-tabs =
    .label = 新しいウィンドウではなく新しいタブに開く
    .accesskey = w

warn-on-close-multiple-tabs =
    .label = 同時に複数のタブを閉じるときは確認する
    .accesskey = m

warn-on-open-many-tabs =
    .label = 同時に複数のタブを開いて { -brand-short-name } の動作が遅くなるときは確認する
    .accesskey = d

switch-links-to-new-tabs =
    .label = リンクを新しいタブで開いたとき、すぐにそのタブに切り替える
    .accesskey = h

switch-to-new-tabs =
    .label = リンク、画像、メディアを新しいタブで開いたとき、すぐにそのタブに切り替える
    .accesskey = h

show-tabs-in-taskbar =
    .label = タスクバーにタブのプレビューを表示する
    .accesskey = k

browser-containers-enabled =
    .label = コンテナータブを有効にする
    .accesskey = n

browser-containers-learn-more = 詳細情報

browser-containers-settings =
    .label = 設定...
    .accesskey = i

containers-disable-alert-title = すべてのコンテナータブを閉じますか？
containers-disable-alert-desc = コンテナータブを無効にすると、{ $tabCount } 個のコンテナータブが閉じられます。コンテナータブを無効にしますか？

containers-disable-alert-ok-button = { $tabCount } 個のコンテナータブを閉じる
containers-disable-alert-cancel-button = このままにする

containers-remove-alert-title = このコンテナーを削除しますか？

# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg = このコンテナーを削除すると { $count } 個のコンテナータブが閉じられます。このコンテナーを削除してもよろしいですか？

containers-remove-ok-button = このコンテナーを削除する
containers-remove-cancel-button = 削除しない

## General Section - Language & Appearance

language-and-appearance-header = 言語と外観

fonts-and-colors-header = フォントと配色

default-font = 既定のフォント
    .accesskey = D
default-font-size = サイズ
    .accesskey = S

advanced-fonts =
    .label = 詳細設定...
    .accesskey = A

colors-settings =
    .label = 配色設定...
    .accesskey = C

# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = ズーム

preferences-default-zoom = 既定のズーム
    .accesskey = z

preferences-default-zoom-value =
    .label = { $percentage }%

preferences-zoom-text-only =
    .label = 文字サイズのみ変更
    .accesskey = t

language-header = 言語

choose-language-description = ウェブページの表示に使用する言語の優先順位を設定できます。

choose-button =
    .label = 言語設定...
    .accesskey = o

choose-browser-language-description = メニュー、メッセージ、{ -brand-short-name } からの通知に表示される言語を選択します。
manage-browser-languages-button =
    .label = 代替言語を設定...
    .accesskey = l
confirm-browser-language-change-description = 変更を適用するには、{ -brand-short-name } の再起動が必要です
confirm-browser-language-change-button = 適用して再起動

translate-web-pages =
    .label = ウェブページを翻訳
    .accesskey = T

# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = 翻訳:  <img data-l10n-name="logo"/>

translate-exceptions =
    .label = 例外...
    .accesskey = x

# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
   .label = 日付、時刻、数値、寸法の書式に、OS の “{ $localeName }” の設定を使う。

check-user-spelling =
    .label = 自動スペルチェック機能を使用する
    .accesskey = t

## General Section - Files and Applications

files-and-applications-title = ファイルとプログラム

download-header = ダウンロード

download-save-to =
    .label = 次のフォルダーに保存する
    .accesskey = v

download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] 選択...
           *[other] 参照...
        }
    .accesskey =
        { PLATFORM() ->
            [macos] e
           *[other] o
        }

download-always-ask-where =
    .label = ファイルごとに保存先を指定する
    .accesskey = A

applications-header = プログラム

applications-description = ウェブからダウンロードしたファイルを { -brand-short-name } が取り扱う方法とブラウズ中に使用するプログラムを選んでください。

applications-filter =
    .placeholder = ファイルの種類とプログラムを検索

applications-type-column =
    .label = ファイルの種類 (Content Type)
    .accesskey = T

applications-action-column =
    .label = 取り扱い方法
    .accesskey = A

# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = { $extension } ファイル
applications-action-save =
    .label = ファイルを保存

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = { $app-name } を使用

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = { $app-name } を使用 (標準設定)

applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] macOS の既定のプログラムを使用
            [windows] Windows の既定のプログラムを使用
           *[other] システムの既定のプログラムを使用
        }

applications-use-other =
    .label = 他のプログラムを選択...
applications-select-helper = プログラムの選択

applications-manage-app =
    .label = プログラムの管理...
applications-always-ask =
    .label = 毎回確認する
applications-type-pdf = PDF 文書 (PDF)

# Variables:
#   $type (String) - the MIME type (e.g application/binary)
applications-type-pdf-with-type = { applications-type-pdf } ({ $type })

# Variables:
#   $type-description (String) - Description of the type (e.g "Portable Document Format")
#   $type (String) - the MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })

# Variables:
#   $extension (String) - file extension (e.g .TXT)
#   $type (String) - the MIME type (e.g application/binary)
applications-file-ending-with-type = { applications-file-ending } ({ $type })

# Variables:
#   $plugin-name (String) - Name of a plugin (e.g Adobe Flash)
applications-use-plugin-in =
    .label = { $plugin-name } を使用 ({ -brand-short-name } 内で表示)
applications-open-inapp =
    .label = { -brand-short-name } で開く

## The strings in this group are used to populate
## selected label element based on the string from
## the selected menu item.

applications-use-plugin-in-label =
    .value = { applications-use-plugin-in.label }

applications-action-save-label =
    .value = { applications-action-save.label }

applications-use-app-label =
    .value = { applications-use-app.label }

applications-open-inapp-label =
    .value = { applications-open-inapp.label }

applications-always-ask-label =
    .value = { applications-always-ask.label }

applications-use-app-default-label =
    .value = { applications-use-app-default.label }

applications-use-other-label =
    .value = { applications-use-other.label }

applications-use-os-default-label =
    .value = { applications-use-os-default.label }

##

drm-content-header = デジタル著作権管理 (DRM) コンテンツ

play-drm-content =
    .label = DRM 制御のコンテンツを再生
    .accesskey = P

play-drm-content-learn-more = 詳細情報

update-application-title = { -brand-short-name } の更新

update-application-description = 最高のパフォーマンスと安定性、セキュリティを提供するため { -brand-short-name } を最新の状態に保ちます。

update-application-version = バージョン { $version } <a data-l10n-name="learn-more">更新情報</a>

update-history =
    .label = 更新履歴を表示...
    .accesskey = p

update-application-allow-description = { -brand-short-name } の更新動作

update-application-auto =
    .label = 更新を自動的にインストールする (推奨)
    .accesskey = A

update-application-check-choose =
    .label = 更新の確認は行うが、インストールするかを選択する
    .accesskey = C

update-application-manual =
    .label = 更新の確認は行わない (非推奨)
    .accesskey = N

update-application-background-enabled =
    .label = { -brand-short-name } を実行していない時に更新する
    .accesskey = W

update-application-warning-cross-user-setting = この設定はこの端末のすべての Windows アカウントと、この { -brand-short-name } のインストール先を使用するすべての { -brand-short-name } プロファイルに適用されます。

update-application-use-service =
    .label = 更新のインストールにバックグラウンドサービスを使用する
    .accesskey = b

update-setting-write-failure-title = 変更した設定の保存エラー

# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } がエラーに遭遇したため変更を保存できませんでした。この設定変更を保存するには、以下のファイルの書き込み権限が必要なことに注意してください。あなたかシステム管理者が、このファイルにユーザーグループのフルコントロール権限を与えると、エラーを解決できる可能性があります。
    
    ファイルに書き込みできません: { $path }

update-setting-write-failure-title2 = 設定変更の保存エラー

# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message2 =
    { -brand-short-name } がエラーに遭遇したため変更を保存できませんでした。この設定変更を保存するには、以下のファイルの書き込み権限が必要なことに注意してください。あなたかシステム管理者が、このファイルにユーザーグループのフルコントロール権限を与えると、エラーを解決できる可能性があります。

    ファイルに書き込めません: { $path }

update-in-progress-title = 更新中

update-in-progress-message = この更新を続行しますか？

update-in-progress-ok-button = 破棄(&D)
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = 続行(&C)

## General Section - Performance

performance-title = パフォーマンス

performance-use-recommended-settings-checkbox =
    .label = 推奨のパフォーマンス設定を使用する
    .accesskey = U

performance-use-recommended-settings-desc = これらの設定はコンピューターのハードウェアとオペレーティングシステムに合わせて調整されます。

performance-settings-learn-more = 詳細情報

performance-allow-hw-accel =
    .label = ハードウェアアクセラレーション機能を使用する (可能な場合)
    .accesskey = r

performance-limit-content-process-option = コンテンツプロセス数の制限
    .accesskey = l

performance-limit-content-process-enabled-desc = コンテンツプロセスを増やすと、複数タブの使用時にパフォーマンスが向上しますが、メモリーを多く消費します。
performance-limit-content-process-blocked-desc = コンテンツプロセスの数はマルチプロセスの { -brand-short-name } でしか変更できません。 <a data-l10n-name="learn-more">マルチプロセスが有効になっているか確認してください</a>

# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (既定)

## General Section - Browsing

browsing-title = ブラウズ

browsing-use-autoscroll =
    .label = 自動スクロール機能を使用する
    .accesskey = a

browsing-use-smooth-scrolling =
    .label = スムーズスクロール機能を使用する
    .accesskey = m

browsing-use-onscreen-keyboard =
    .label = 必要であればタッチキーボードを表示する
    .accesskey = c

browsing-use-cursor-navigation =
    .label = ページ中の移動にカーソルを使用する (キャレットブラウズモード)
    .accesskey = k

browsing-search-on-start-typing =
    .label = キー入力時に検索を開始する
    .accesskey = x

browsing-picture-in-picture-toggle-enabled =
    .label = ピクチャーインピクチャーの動画の操作を有効にする
    .accesskey = E

browsing-picture-in-picture-learn-more = 詳細情報

browsing-media-control =
    .label = メディアをキーボード、ヘッドセット、仮想インターフェースで操作する
    .accesskey = v

browsing-media-control-learn-more = 詳細情報

browsing-cfr-recommendations =
    .label = おすすめの拡張機能を紹介する
    .accesskey = R
browsing-cfr-features =
    .label = おすすめの機能を紹介する
    .accesskey = f

browsing-cfr-recommendations-learn-more = 詳細情報

## General Section - Proxy

network-settings-title = ネットワーク設定

network-proxy-connection-description = { -brand-short-name } のインターネットへの接続方法を設定します。

network-proxy-connection-learn-more = 詳細情報

network-proxy-connection-settings =
    .label = 接続設定...
    .accesskey = e

## Home Section

home-new-windows-tabs-header = 新しいウィンドウとタブ

home-new-windows-tabs-description2 = ホームページ、新しいウィンドウ、新しいタブを開くときに表示するものを選択してください。

## Home Section - Home Page Customization

home-homepage-mode-label = ホームページと新しいウィンドウ

home-newtabs-mode-label = 新しいタブ

home-restore-defaults =
    .label = 既定値に戻す
    .accesskey = R

# "Waterfox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Waterfox ホーム (既定)

home-mode-choice-custom =
    .label = カスタム URL...

home-mode-choice-blank =
    .label = 空白ページ

home-homepage-custom-url =
    .placeholder = URL を貼り付け...

# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] 現在のページを使用
           *[other] 現在のタブグループを使用
        }
    .accesskey = C

choose-bookmark =
    .label = ブックマークを使う...
    .accesskey = B

## Home Section - Firefox Home Content Customization

home-prefs-content-header = Waterfox Home コンテンツ
home-prefs-content-description = Waterfox Home に表示するコンテンツを選びましょう。

home-prefs-search-header =
    .label = ウェブ検索
home-prefs-topsites-header =
    .label = トップサイト
home-prefs-topsites-description = よく訪れるサイト

home-prefs-topsites-by-option-sponsored =
    .label = 広告トップサイト
home-prefs-shortcuts-header =
    .label = ショートカット
home-prefs-shortcuts-description = 保存または訪問したサイト
home-prefs-shortcuts-by-option-sponsored =
    .label = 広告ショートカット

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = { $provider } のおすすめ
home-prefs-recommended-by-description-update = { $provider } がウェブ全体から厳選した注目のコンテンツ
home-prefs-recommended-by-description-new = { -brand-product-name } ファミリーを構成する { $provider } が厳選した注目のコンテンツ

##

home-prefs-recommended-by-learn-more = 使い方
home-prefs-recommended-by-option-sponsored-stories =
    .label = 広告記事

home-prefs-highlights-header =
    .label = ハイライト
home-prefs-highlights-description = 保存したり訪れたりしたサイトうち主なもの
home-prefs-highlights-option-visited-pages =
    .label = 訪れたページ
home-prefs-highlights-options-bookmarks =
    .label = ブックマーク
home-prefs-highlights-option-most-recent-download =
    .label = 最近のダウンロード
home-prefs-highlights-option-saved-to-pocket =
    .label = { -pocket-brand-name } に保存されたページ

home-prefs-recent-activity-header =
    .label = 最近のアクティビティ
home-prefs-recent-activity-description = 最近のサイトとコンテンツの抜粋

# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = スニペット
home-prefs-snippets-description = { -vendor-short-name } と { -brand-product-name } に関する最新情報

home-prefs-snippets-description-new = { -vendor-short-name } と { -brand-product-name } に関するヒントと最新情報

home-prefs-sections-rows-option =
    .label = { $num } 行

## Search Section

search-bar-header = 検索バー
search-bar-hidden =
    .label = 検索とナビゲーションにアドレスバーを使用する
search-bar-shown =
    .label = 検索バーをツールバーに追加する

search-engine-default-header = 既定の検索エンジン
search-engine-default-desc-2 = アドレスバーと検索バーの既定の検索エンジンです。いつでも切り替えられます。
search-engine-default-private-desc-2 = プライベートウィンドウでの既定の検索エンジンを選択してください
search-separate-default-engine =
    .label = この検索エンジンをプライベートウィンドウで使用する
    .accesskey = U

search-suggestions-header = 検索候補
search-suggestions-desc = 検索エンジンからの検索候補の表示方法を選択してください。

search-suggestions-option =
    .label = 検索候補を使用する
    .accesskey = s

search-show-suggestions-url-bar-option =
    .label = アドレスバーに検索候補を表示する
    .accesskey = l

# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = アドレスバーの入力候補は、検索候補を閲覧履歴より先に表示する

search-show-suggestions-private-windows =
    .label = プライベートウィンドウで検索候補を表示する

suggestions-addressbar-settings-generic = アドレスバーの入力候補のその他の設定を変更

suggestions-addressbar-settings-generic2 = アドレスバーの入力候補のその他の設定を変更

search-suggestions-cant-show = 履歴を保存しない設定となっているため、ロケーションバーに検索候補が表示されません。

search-one-click-header = ワンクリック検索エンジン

search-one-click-header2 = 検索ショートカット

search-one-click-desc = キーワードの入力開始時にアドレスバーや検索バーの下に現れる代替検索エンジンを選んでください。

search-choose-engine-column =
    .label = 検索エンジン
search-choose-keyword-column =
    .label = キーワード

search-restore-default =
    .label = 既定の検索エンジンを復元
    .accesskey = D

search-remove-engine =
    .label = 削除
    .accesskey = R

search-add-engine =
    .label = 追加
    .accesskey = A

search-find-more-link = 他の検索エンジンを追加

# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = キーワードが重複しています
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = "{ $name }" で使用されているキーワードを指定しました。他のものを指定してください。
search-keyword-warning-bookmark = ブックマークで使用されているキーワードを指定しました。他のものを指定してください。

## Containers Section

containers-back-button =
    .aria-label =
      { PLATFORM() ->
          [windows] オプションに戻る
         *[other] 設定に戻る
      }

containers-back-button2 =
    .aria-label = 設定に戻る
containers-header = コンテナータブ
containers-add-button =
    .label = 新しいコンテナーを追加
    .accesskey = A

containers-new-tab-check =
    .label = 新しいタブを開くコンテナーを毎回選択する
    .accesskey = S

containers-preferences-button =
    .label = 設定

containers-settings-button =
    .label = 設定
containers-remove-button =
    .label = 削除

## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = ウェブを持ち歩こう
sync-signedout-description = ブックマークやページの表示履歴、タブ、パスワード、アドオン、設定を、お持ちのすべての端末間で同期できます。

sync-signedout-account-signin2 =
    .label = { -sync-brand-short-name } にログイン...
    .accesskey = i

sync-signedout-description2 = ブックマークやページの表示履歴、タブ、パスワード、アドオン、設定を、お持ちのすべての端末間で同期できます。

sync-signedout-account-signin3 =
    .label = ログインして同期...
    .accesskey = i

# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Waterfox for <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> または <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> をダウンロードしてモバイル端末と同期しましょう。

## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = プロフィール写真を変更します

sync-sign-out =
    .label = ログアウト...
    .accesskey = g

sync-manage-account = アカウントの管理
    .accesskey = o

sync-signedin-unverified = { $email } は認証されていません。
sync-signedin-login-failure = { $email } に再接続するにはログインしてください。

sync-resend-verification =
    .label = 認証メールを再送信
    .accesskey = d

sync-remove-account =
    .label = アカウントを削除
    .accesskey = R

sync-sign-in =
    .label = ログイン
    .accesskey = g

## Sync section - enabling or disabling sync.

prefs-syncing-on = 同期: オン

prefs-syncing-off = 同期: オフ

prefs-sync-setup =
    .label = { -sync-brand-short-name } をセットアップ...
    .accesskey = S

prefs-sync-offer-setup-label = ブックマーク、履歴、タブ、パスワード、アドオン、設定をあなたの端末すべてに同期化します。

prefs-sync-turn-on-syncing =
    .label = 同期をオンにしています...
    .accesskey = s

prefs-sync-offer-setup-label2 = ブックマーク、履歴、タブ、パスワード、アドオン、設定をあなたのすべての端末に対して同期させます。

prefs-sync-now =
    .labelnotsyncing = 今すぐ同期
    .accesskeynotsyncing = N
    .labelsyncing = 同期中...

## The list of things currently syncing.

sync-currently-syncing-heading = これらの項目を同期しています:

sync-currently-syncing-bookmarks = ブックマーク
sync-currently-syncing-history = 履歴
sync-currently-syncing-tabs = 開いたタブ
sync-currently-syncing-logins-passwords = ログイン情報とパスワード
sync-currently-syncing-addresses = 所在地フォーム
sync-currently-syncing-creditcards = クレジットカード
sync-currently-syncing-addons = アドオン
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] オプション
       *[other] 個人設定
    }

sync-currently-syncing-settings = 個人設定

sync-change-options =
    .label = 変更...
    .accesskey = C

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = 同期する項目を選択
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = 変更を保存
    .buttonaccesskeyaccept = S
    .buttonlabelextra2 = 切断...
    .buttonaccesskeyextra2 = D

sync-engine-bookmarks =
    .label = ブックマーク
    .accesskey = m

sync-engine-history =
    .label = 履歴
    .accesskey = r

sync-engine-tabs =
    .label = 開いたタブ
    .tooltiptext = 同期した端末で開いているすべてのタブの一覧です
    .accesskey = t

sync-engine-logins-passwords =
    .label = ログイン情報とパスワード
    .tooltiptext = 保存したユーザー名とパスワードです
    .accesskey = L

sync-engine-addresses =
    .label = 所在地フォーム
    .tooltiptext = 保存した住所です (デスクトップのみ)
    .accesskey = e

sync-engine-creditcards =
    .label = クレジットカード
    .tooltiptext = クレジットカードの名義と番号と有効期限です (デスクトップのみ)
    .accesskey = C

sync-engine-addons =
    .label = アドオン
    .tooltiptext = デスクトップ版 Firefox の拡張機能とテーマです
    .accesskey = A

sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] オプション
           *[other] 個人設定
        }
    .tooltiptext = 変更した一般、プライバシー、セキュリティの設定です
    .accesskey = s

sync-engine-settings =
    .label = 個人設定
    .tooltiptext = 変更した一般設定、プライバシー設定、セキュリティ設定です
    .accesskey = s

## The device name controls.

sync-device-name-header = 端末名

sync-device-name-change =
    .label = 端末名を変更...
    .accesskey = h

sync-device-name-cancel =
    .label = キャンセル
    .accesskey = n

sync-device-name-save =
    .label = 保存
    .accesskey = v

sync-connect-another-device = 別の端末を接続

## Privacy Section

privacy-header = ブラウザープライバシー

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = ログインとパスワード
    .searchkeywords = { -lockwise-brand-short-name }

# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = ウェブサイトのログイン情報とパスワードを保存する
    .accesskey = r
forms-exceptions =
    .label = 例外サイト...
    .accesskey = x
forms-generate-passwords =
    .label = 強固なパスワードを生成、提案する
    .accesskey = u
forms-breach-alerts =
    .label = 漏洩したウェブサイトのパスワードの警告を表示する
    .accesskey = b
forms-breach-alerts-learn-more-link = 詳細情報

# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = ログイン情報とパスワードを自動入力する
    .accesskey = i
forms-saved-logins =
    .label = 保存されているログイン情報...
    .accesskey = L
forms-master-pw-use =
    .label = マスターパスワードを使用する
    .accesskey = U
forms-primary-pw-use =
    .label = マスターパスワードを使用する
    .accesskey = U
forms-primary-pw-learn-more-link = 詳細情報
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = マスターパスワードを変更...
    .accesskey = M

forms-master-pw-fips-title = 現在 FIPS モードです。FIPS モードではマスターパスワードを空には設定できません。
forms-primary-pw-change =
    .label = マスターパスワードを変更...
    .accesskey = P
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = { "" }

forms-primary-pw-fips-title = 現在 FIPS モードです。FIPS モードではマスターパスワードを空には設定できません。
forms-master-pw-fips-desc = パスワードを変更できませんでした

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = マスターパスワードを作成するには、Windows でのあなたの資格情報を入力してください。これはアカウントのセキュリティ保護に役立ちます。

# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = マスターパスワードを作成

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = マスターパスワードを作成するには、Windows でのあなたの資格情報を入力してください。これはアカウントのセキュリティ保護に役立ちます。

# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = マスターパスワードを作成
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = 履歴

# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Waterfox", moving the verb into each option.
#     This will result in "Waterfox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = { -brand-short-name } に
    .accesskey = w

history-remember-option-all =
    .label = 履歴を記憶させる
history-remember-option-never =
    .label = 履歴を一切記憶させない
history-remember-option-custom =
    .label = 記憶させる履歴を詳細設定する

history-remember-description = { -brand-short-name } は表示したページの履歴、ファイルのダウンロード履歴、検索やフォームの入力履歴を保存します。
history-dontremember-description = { -brand-short-name } はプライベートブラウジング中と同様に、表示したページの履歴などのプライバシーデータを一切保存しません。

history-private-browsing-permanent =
    .label = 常にプライベートブラウジングモード
    .accesskey = p

history-remember-browser-option =
    .label = 表示したページとファイルのダウンロードの履歴を残す
    .accesskey = b

history-remember-search-option =
    .label = 検索やフォームの入力履歴を記憶させる
    .accesskey = f

history-clear-on-close-option =
    .label = { -brand-short-name } の終了時に履歴を消去する
    .accesskey = r

history-clear-on-close-settings =
    .label = 設定...
    .accesskey = t

history-clear-button =
    .label = 履歴を消去...
    .accesskey = s

## Privacy Section - Site Data

sitedata-header = Cookie とサイトデータ

sitedata-total-size-calculating = サイトデータとキャッシュのサイズを計算しています...

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = 保存された Cookie とサイトデータとキャッシュのディスク使用量は現在 { $value } { $unit } です。

sitedata-learn-more = 詳細情報

sitedata-delete-on-close =
    .label = { -brand-short-name } を閉じたときに Cookie とサイトデータを削除する
    .accesskey = c

sitedata-delete-on-close-private-browsing = 永続プライベートブラウジングモードでは、Cookie とサイトデータは { -brand-short-name } の終了時に必ず消去されます。

sitedata-allow-cookies-option =
    .label = Cookie とサイトデータを保存する
    .accesskey = A

sitedata-disallow-cookies-option =
    .label = Cookie とサイトデータをブロック
    .accesskey = B

# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = ブロックの種類
    .accesskey = T

sitedata-option-block-cross-site-trackers =
    .label = クロスサイトトラッカー
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = クロスサイトトラッカーとソーシャルメディアトラッカー
sitedata-option-block-cross-site-tracking-cookies-including-social-media =
    .label = ソーシャルメディア Cookie を含むクロスサイトトラッキング Cookie
sitedata-option-block-cross-site-cookies-including-social-media =
    .label = ソーシャルメディア Cookie を含むクロスサイト Cookie
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = クロスサイトトラッカーとソーシャルメディアトラッカー、および残存 Cookie を隔離
sitedata-option-block-unvisited =
    .label = 未訪問のウェブサイトの Cookie
sitedata-option-block-all-third-party =
    .label = すべてのサードパーティ Cookie (ウェブサイトが動作しない可能性があります)
sitedata-option-block-all =
    .label = すべての Cookie (ウェブサイトが動作しなくなります)

sitedata-clear =
    .label = データを消去...
    .accesskey = l

sitedata-settings =
    .label = データを管理...
    .accesskey = M

sitedata-cookies-permissions =
    .label = サイトの設定を管理...
    .accesskey = P

sitedata-cookies-exceptions =
    .label = 例外を管理...
    .accesskey = x

## Privacy Section - Address Bar

addressbar-header = アドレスバー

addressbar-suggest = アドレスバーの使用時に表示する候補

addressbar-locbar-history-option =
    .label = ブラウジング履歴
    .accesskey = h
addressbar-locbar-bookmarks-option =
    .label = ブックマーク
    .accesskey = k
addressbar-locbar-openpage-option =
    .label = 開いているタブ
    .accesskey = O
# Shortcuts refers to the shortcut tiles on the new tab page, previously known as top sites. Translation should be consistent.
addressbar-locbar-shortcuts-option =
    .label = ショートカット
    .accesskey = S
addressbar-locbar-topsites-option =
    .label = トップサイト
    .accesskey = T

addressbar-locbar-engines-option =
    .label = 検索エンジン
    .accesskey = a

addressbar-suggestions-settings = 検索エンジンの検索候補の設定を変更

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = 強化型トラッキング防止機能

content-blocking-section-top-level-description = トラッカーはあなたの習慣や興味に関する情報を収集するために、オンラインであなたを追跡します。{ -brand-short-name } はこれらのトラッカーや悪意のあるスクリプトの多くをブロックします。

content-blocking-learn-more = 詳細情報

content-blocking-fpi-incompatibility-warning = { -brand-short-name } の Cookie の設定の一部を上書きするファーストパーティ分離 (FPI) を使用しています。

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = 標準
    .accesskey = d
enhanced-tracking-protection-setting-strict =
    .label = 厳格
    .accesskey = r
enhanced-tracking-protection-setting-custom =
    .label = カスタム
    .accesskey = C

##

content-blocking-etp-standard-desc = 保護と性能をバランスよく。ページが正しく機能するように読み込みます。
content-blocking-etp-strict-desc = より強固な保護ですが、一部のサイトやコンテンツが機能しなくなる可能性があります。
content-blocking-etp-custom-desc = ブロックするトラッカーとスクリプトを選択します。

content-blocking-etp-blocking-desc = { -brand-short-name } は以下のものをブロックします:

content-blocking-private-windows = プライベートウィンドウのトラッキングコンテンツ
content-blocking-cross-site-cookies-in-all-windows = すべてのウィンドウのクロスサイト Cookie (トラッキング Cookie 含む)
content-blocking-cross-site-tracking-cookies = クロスサイトトラッキング Cookie
content-blocking-all-cross-site-cookies-private-windows = プライベートウィンドウのクロスサイト Cookie
content-blocking-cross-site-tracking-cookies-plus-isolate = クロスサイトトラッキング Cookie と残存 Cookie の隔離
content-blocking-social-media-trackers = ソーシャルメディアトラッカー
content-blocking-all-cookies = すべての Cookie
content-blocking-unvisited-cookies = 未訪問のサイトの Cookie
content-blocking-all-windows-tracking-content = すべてのウィンドウのトラッキングコンテンツ
content-blocking-all-third-party-cookies = サードパーティ Cookie すべて
content-blocking-cryptominers = 暗号通貨マイニング
content-blocking-fingerprinters = フィンガープリント採取

content-blocking-warning-title = 注意！
content-blocking-and-isolating-etp-warning-description = トラッカーをブロックし、残存 Cookie を隔離すると、一部のサイトの機能に影響がある可能性があります。すべてのコンテンツを読み込むには、トラッカーを許容してページを再読み込みします。
content-blocking-and-isolating-etp-warning-description-2 = この設定では、一部のウェブサイトが表示されないか正しく動作しない可能性があります。サイトが動作しない場合は、トラッキング防止機能をオフにして再読み込みするとよいでしょう。
content-blocking-warning-learn-how = 詳細情報

content-blocking-reload-description = これらの変更を適用するには、タブを再読み込みする必要があります。
content-blocking-reload-tabs-button =
    .label = すべてのタブを再読み込み
    .accesskey = R

content-blocking-tracking-content-label =
    .label = トラッキングコンテンツ
    .accesskey = T
content-blocking-tracking-protection-option-all-windows =
    .label = すべてのウィンドウ
    .accesskey = A
content-blocking-option-private =
    .label = プライベートウィンドウのみ
    .accesskey = p
content-blocking-tracking-protection-change-block-list = ブロックリストを変更

content-blocking-cookies-label =
    .label = Cookie
    .accesskey = C

content-blocking-expand-section =
    .tooltiptext = 詳細情報

# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = 暗号通貨マイニング
    .accesskey = y

# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = フィンガープリント採取
    .accesskey = F

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = 例外を管理...
    .accesskey = x

## Privacy Section - Permissions

permissions-header = 許可設定

permissions-location = 位置情報
permissions-location-settings =
    .label = 設定...
    .accesskey = t

permissions-xr = バーチャルリアリティ
permissions-xr-settings =
    .label = 設定...
    .accesskey = t

permissions-camera = カメラ
permissions-camera-settings =
    .label = 設定...
    .accesskey = t

permissions-microphone = マイク
permissions-microphone-settings =
    .label = 設定...
    .accesskey = t

permissions-notification = 通知
permissions-notification-settings =
    .label = 設定...
    .accesskey = t
permissions-notification-link = 詳細情報

permissions-notification-pause =
    .label = { -brand-short-name } を再起動するまで通知を一時停止
    .accesskey = n

permissions-autoplay = 自動再生

permissions-autoplay-settings =
    .label = 設定...
    .accesskey = t

permissions-block-popups =
    .label = ポップアップウィンドウをブロックする
    .accesskey = B

permissions-block-popups-exceptions =
    .label = 許可サイト...
    .accesskey = E

permissions-addon-install-warning =
    .label = アドオンのインストールを求められたときに警告する
    .accesskey = W

permissions-addon-exceptions =
    .label = 許可サイト...
    .accesskey = E

permissions-a11y-privacy-checkbox =
    .label = アクセシビリティサービスによるブラウザーへのアクセスを止める
    .accesskey = a

permissions-a11y-privacy-link = 詳細情報

## Privacy Section - Data Collection

collection-header = { -brand-short-name } のデータ収集と利用について

collection-description = 私たちはユーザーに選択肢を提供し、{ -brand-short-name } をすべての人に提供し改善するために必要なものだけを収集するよう努力しています。私たちは、個人情報を受け取る前に、常にユーザーの許可を求めます。
collection-privacy-notice = 個人情報保護方針

collection-health-report-telemetry-disabled = { -vendor-short-name } への技術的な対話データの送信の許可を取り消しました。過去のデータは 30 日以内にすべて削除されます。
collection-health-report-telemetry-disabled-link = 詳細情報

collection-health-report =
    .label = { -brand-short-name } が技術的な対話データを { -vendor-short-name } へ送信することを許可する
    .accesskey = r
collection-health-report-link = 詳細情報

collection-studies =
    .label = { -brand-short-name } に調査のインストールと実行を許可する
collection-studies-link = { -brand-short-name } 調査を確認する

addon-recommendations =
    .label = { -brand-short-name } にパーソナライズされた拡張機能のおすすめを許可する
addon-recommendations-link = 詳細情報

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = このビルド設定ではヘルスレポートが無効化されています

collection-backlogged-crash-reports =
    .label = { -brand-short-name } があなたに代わって未送信のクラッシュレポートを送信することを許可する
    .accesskey = c
collection-backlogged-crash-reports-link = 詳細情報

collection-backlogged-crash-reports-with-link = { -brand-short-name } があなたに代わって未送信のクラッシュレポートを送信することを許可する <a data-l10n-name="crash-reports-link">詳細情報</a>
    .accesskey = c

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = セキュリティ

security-browsing-protection = 詐欺コンテンツと危険なソフトウェアからの防護

security-enable-safe-browsing =
    .label = 危険な詐欺コンテンツをブロックする
    .accesskey = B
security-enable-safe-browsing-link = 詳細情報

security-block-downloads =
    .label = 危険なファイルのダウンロードをブロックする
    .accesskey = d

security-block-uncommon-software =
    .label = 不要な危険ソフトウェアを警告する
    .accesskey = c

## Privacy Section - Certificates

certs-header = 証明書

certs-personal-label = サーバーが個人証明書を要求したとき

certs-select-auto-option =
    .label = 自動的に選択する
    .accesskey = S

certs-select-ask-option =
    .label = 毎回自分で選択する
    .accesskey = A

certs-enable-ocsp =
    .label = OCSP レスポンダーサーバーに問い合わせて証明書の現在の正当性を確認する
    .accesskey = Q

certs-view =
    .label = 証明書を表示...
    .accesskey = C

certs-devices =
    .label = セキュリティデバイス...
    .accesskey = D

space-alert-learn-more-button =
    .label = 詳細情報
    .accesskey = L

space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] オプションを開く
           *[other] 設定を開く
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] O
        }

space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] { -brand-short-name } を実行するためのディスク領域が足りません。ウェブサイトが正しく表示されない可能性があります。[オプション] > [プライバシーとセキュリティ] > [Cookie とサイトデータ] から、保存されたデータを削除してください。
       *[other] { -brand-short-name } を実行するためのディスク領域が足りません。ウェブサイトが正しく表示されない可能性があります。[設定] > [プライバシーとセキュリティ] > [Cookie とサイトデータ] から、保存されたデータを削除してください。
    }

space-alert-under-5gb-ok-button =
    .label = OK
    .accesskey = K

space-alert-under-5gb-message = { -brand-short-name } を実行するためのディスク領域が足りません。ウェブサイトが正しく表示されない可能性があります。快適なブラウジングのために、[詳細情報] のリンク先を読み、ディスク使用量を最適化してください。

space-alert-over-5gb-settings-button =
    .label = 設定を開く
    .accesskey = O

space-alert-over-5gb-message2 = <strong>{ -brand-short-name } を実行するためのディスク領域が足りません。</strong>ウェブサイトが正しく表示されない可能性があります。[設定] > [プライバシーとセキュリティ] > [Cookie とサイトデータ] から、保存されたデータを削除してください。

space-alert-under-5gb-message2 = <strong>{ -brand-short-name } を実行するためのディスク領域が足りません。</strong>ウェブサイトが正しく表示されない可能性があります。快適なブラウジングのために、[詳細情報] のリンク先を読み、ディスク使用量を最適化してください。

## Privacy Section - HTTPS-Only

httpsonly-header = HTTPS-Only モード

httpsonly-description = HTTPS は { -brand-short-name } とあなたが訪れるウェブサイトとの間に、暗号化された安全な接続を提供します。多くのウェブサイトは HTTPS に対応しており、HTTPS-Only モードを有効にすると { -brand-short-name } はすべての接続を HTTPS に切り替えます。

httpsonly-learn-more = 詳細

httpsonly-radio-enabled =
    .label = すべてのウィンドウで HTTPS-Only モードを有効にする

httpsonly-radio-enabled-pbm =
    .label = プライベートウィンドウのみ HTTPS-Only モードを有効にする

httpsonly-radio-disabled =
    .label = HTTPS-Only モードを有効にしない

## The following strings are used in the Download section of settings

desktop-folder-name = デスクトップ
downloads-folder-name = ダウンロード
choose-download-folder-title = ダウンロードフォルダーを選択:

# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = { $service-name } にファイルを保存する
