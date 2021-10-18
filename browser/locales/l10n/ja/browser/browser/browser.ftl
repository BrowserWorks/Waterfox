# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - "Waterfox"
# private - "Waterfox (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } (プライベートブラウジング)
    .data-content-title-default = { $content-title } — { -brand-full-name }
    .data-content-title-private = { $content-title } — { -brand-full-name } (プライベートブラウジング)
# These are the default window titles on macOS. The first two are for use when
# there is no content title:
#
# "default" - "Waterfox"
# "private" - "Waterfox — (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Do not use the brand name in the last two attributes, as we do on non-macOS.
#
# Also note the other subtle difference here: we use a `-` to separate the
# brand name from `(Private Browsing)`, which does not happen on other OSes.
#
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-mac =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } — (プライベートブラウジング)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } — (プライベートブラウジング)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = サイトの情報を表示

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = インストールメッセージパネルを開きます
urlbar-web-notification-anchor =
    .tooltiptext = サイトからの通知の設定を変更します
urlbar-midi-notification-anchor =
    .tooltiptext = MIDI パネルを開きます
urlbar-eme-notification-anchor =
    .tooltiptext = DRM ソフトウェアを管理します
urlbar-web-authn-anchor =
    .tooltiptext = Web Authentication パネルを開きます
urlbar-canvas-notification-anchor =
    .tooltiptext = canvas 要素抽出の許可設定を管理します
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = マイクの共有を管理します
urlbar-default-notification-anchor =
    .tooltiptext = メッセージパネルを開きます
urlbar-geolocation-notification-anchor =
    .tooltiptext = 位置情報の要求パネルを開きます
urlbar-xr-notification-anchor =
    .tooltiptext = VR の許可設定パネルを開きます
urlbar-storage-access-anchor =
    .tooltiptext = 行動追跡の許可設定パネルを開きます
urlbar-translate-notification-anchor =
    .tooltiptext = このページを翻訳します
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = ウィンドウと画面の共有を管理します
urlbar-indexed-db-notification-anchor =
    .tooltiptext = オフラインストレージのメッセージパネルを開きます
urlbar-password-notification-anchor =
    .tooltiptext = パスワードの保存メッセージパネルを開きます
urlbar-translated-notification-anchor =
    .tooltiptext = ページ翻訳を管理します
urlbar-plugins-notification-anchor =
    .tooltiptext = 使用するプラグインを管理します
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = カメラとマイクの共有を管理します
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
urlbar-web-rtc-share-speaker-notification-anchor =
    .tooltiptext = その他のスピーカーの共有を管理します
urlbar-autoplay-notification-anchor =
    .tooltiptext = 自動再生パネルを開きます
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = データを永続ストレージに格納します
urlbar-addons-notification-anchor =
    .tooltiptext = アドオンのインストールのメッセージパネルを開きます
urlbar-tip-help-icon =
    .title = ヘルプを表示
urlbar-search-tips-confirm = 了解しました
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = ヒント:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = 少ない入力でたくさん見つかる: アドレスバーから { $engineName } ですぐ検索します。
urlbar-search-tips-redirect-2 = アドレスバーで検索を始めると、{ $engineName } からの検索候補と閲覧履歴が表示されます。
# Prompts users to use the Urlbar when they are typing in the domain of a
# search engine, e.g. google.com or amazon.com.
urlbar-tabtosearch-onboard = このショートカットを選択すると、より素早く検索できます。

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = ブックマーク
urlbar-search-mode-tabs = タブ
urlbar-search-mode-history = 履歴

##

urlbar-geolocation-blocked =
    .tooltiptext = このウェブサイトでの位置情報の共有をブロックしました。
urlbar-xr-blocked =
    .tooltiptext = このウェブサイトの VR デバイスへのアクセスをブロックしました。
urlbar-web-notifications-blocked =
    .tooltiptext = このウェブサイトからの通知をブロックしました。
urlbar-camera-blocked =
    .tooltiptext = このウェブサイトでのカメラの共有をブロックしました。
urlbar-microphone-blocked =
    .tooltiptext = このウェブサイトでのマイクの共有をブロックしました。
urlbar-screen-blocked =
    .tooltiptext = このウェブサイトでの画面の共有をブロックしました。
urlbar-persistent-storage-blocked =
    .tooltiptext = このウェブサイトの永続ストレージの使用をブロックしました。
urlbar-popup-blocked =
    .tooltiptext = このウェブサイトのポップアップをブロックしました。
urlbar-autoplay-media-blocked =
    .tooltiptext = このウェブサイトの音声付きメディアの自動再生をブロックしました。
urlbar-canvas-blocked =
    .tooltiptext = このウェブサイトの Canvas データの抽出をブロックしました。
urlbar-midi-blocked =
    .tooltiptext = このウェブサイトの MIDI へのアクセスをブロックしました。
urlbar-install-blocked =
    .tooltiptext = このウェブサイトのアドオンのインストールをブロックしました。
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = このページのブックマークを編集します ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = このページをブックマークに追加します ({ $shortcut })

## Page Action Context Menu

page-action-manage-extension =
    .label = 拡張機能を管理...
page-action-remove-extension =
    .label = 拡張機能を削除

## Auto-hide Context Menu

full-screen-autohide =
    .label = ツールバーを隠す
    .accesskey = H
full-screen-exit =
    .label = 全画面表示モードを終了
    .accesskey = F

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of search shortcuts in
# the Urlbar and searchbar.
search-one-offs-with-title = 今回だけ使う検索エンジン:
search-one-offs-change-settings-compact-button =
    .tooltiptext = 検索設定を変更します
search-one-offs-context-open-new-tab =
    .label = 新しいタブで検索
    .accesskey = T
search-one-offs-context-set-as-default =
    .label = 既定の検索エンジンに設定
    .accesskey = D
search-one-offs-context-set-as-default-private =
    .label = プライベートウィンドウの既定の検索エンジンに設定
    .accesskey = P
# Search engine one-off buttons with an @alias shortcut/keyword.
# Variables:
#  $engineName (String): The name of the engine.
#  $alias (String): The @alias shortcut/keyword.
search-one-offs-engine-with-alias =
    .tooltiptext = { $engineName } ({ $alias })
# Shown when adding new engines from the address bar shortcut buttons or context
# menu, or from the search bar shortcut buttons.
# Variables:
#  $engineName (String): The name of the engine.
search-one-offs-add-engine =
    .label = “{ $engineName }” を追加
    .tooltiptext = 検索エンジン “{ $engineName }” を追加します
    .aria-label = 検索エンジン “{ $engineName }” を追加
# When more than 5 engines are offered by a web page, they are grouped in a
# submenu using this as its label.
search-one-offs-add-engine-menu =
    .label = 検索エンジンを追加

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).

search-one-offs-bookmarks =
    .tooltiptext = ブックマーク ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = タブ ({ $restrict })
search-one-offs-history =
    .tooltiptext = 履歴 ({ $restrict })

## Bookmark Panel

bookmarks-add-bookmark = ブックマークを追加
bookmarks-edit-bookmark = ブックマークを編集
bookmark-panel-cancel =
    .label = キャンセル
    .accesskey = C
# Variables:
#  $count (number): number of bookmarks that will be removed
bookmark-panel-remove =
    .label = { $count } 個のブックマークを削除
    .accesskey = R
bookmark-panel-show-editor-checkbox =
    .label = 追加時にエディターを表示する
    .accesskey = S
bookmark-panel-save-button =
    .label = 保存
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-site-information = { $host } のサイト情報
# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-header-security-with-host =
    .title = { $host } への接続の安全性
identity-connection-not-secure = 安全でない接続
identity-connection-secure = 安全な接続
identity-connection-failure = 接続失敗
identity-connection-internal = このページは { -brand-short-name } の安全な内部ページです。
identity-connection-file = これはあなたのコンピューターに保存されているページです。
identity-extension-page = このページは拡張機能から読み込まれています。
identity-active-blocked = このページの一部が安全でないため { -brand-short-name } がブロックしました。
identity-custom-root = Waterfox が承認していない発行者の証明書で検証された接続です。
identity-passive-loaded = このページの一部 (画像など) は安全ではありません。
identity-active-loaded = このページでの保護は無効に設定されています。
identity-weak-encryption = このページは脆弱な暗号を使用しています。
identity-insecure-login-forms = このページのログインフォームは安全ではありません。
identity-https-only-connection-upgraded = (HTTPS で接続中)
identity-https-only-label = HTTPS-Only モード
identity-https-only-dropdown-on =
    .label = オン
identity-https-only-dropdown-off =
    .label = オフ
identity-https-only-dropdown-off-temporarily =
    .label = 一時的にオフ
identity-https-only-info-turn-on2 = このサイトで { -brand-short-name } に可能な限り接続をアップグレードさせたい場合は、HTTPS-Only モードをオンにしてください。
identity-https-only-info-turn-off2 = ページが動作しない場合は HTTPS-Only モードをオフにして、安全でない HTTP 接続でこのサイトを再読み込みするとよいでしょう。
identity-https-only-info-no-upgrade = 接続を HTTP からアップグレードできません。
identity-permissions-storage-access-header = クロスサイト Cookie
identity-permissions-storage-access-hint = 以下のサイトが、あなたがこのサイトにいる間、クロスサイト Cookie とサイトデータにアクセスできます。
identity-permissions-storage-access-learn-more = 詳細情報
identity-permissions-reload-hint = 変更内容を適用するには、ページの再読み込みが必要です。
identity-clear-site-data =
    .label = Cookie とサイトデータを消去...
identity-connection-not-secure-security-view = このサイトとの接続は安全ではありません。
identity-connection-verified = このサイトとの接続は安全です。
identity-ev-owner-label = 証明書の発行先:
identity-description-custom-root = Waterfox はこの証明書の発行者を承認していません。OS またはシステム管理者により追加された可能性があります。 <label data-l10n-name="link">詳細情報</label>
identity-remove-cert-exception =
    .label = 例外から削除
    .accesskey = R
identity-description-insecure = このサイトへの接続は秘密が保たれません。このサイトに送信した情報 (パスワードやメッセージ、クレジットカード情報など) が第三者に盗み見られる可能性があります。
identity-description-insecure-login-forms = このページに入力したログイン情報は安全に送信されません。第三者に盗み見られる可能性があります。
identity-description-weak-cipher-intro = このウェブサイトとの接続には脆弱な暗号が使用されており、秘密が保たれません。
identity-description-weak-cipher-risk = 第三者にあなたの情報を盗み見られたりウェブサイトの動作を不正に改変される可能性があります。
identity-description-active-blocked = { -brand-short-name } がこのページ上の安全でないコンテンツをブロックしました。 <label data-l10n-name="link">詳細情報</label>
identity-description-passive-loaded = この接続は安全でないため、サイトと共有したあなたの情報が第三者に盗み見られる可能性があります。
identity-description-passive-loaded-insecure = このウェブサイトには安全でないコンテンツ (画像など) が含まれています。 <label data-l10n-name="link">詳細情報</label>
identity-description-passive-loaded-mixed = { -brand-short-name } が一部のコンテンツをブロックしていますが、ページ上には安全でないコンテンツ (画像など) が含まれています。 <label data-l10n-name="link">詳細情報</label>
identity-description-active-loaded = このウェブサイトには安全でないコンテンツ (スクリプトなど) が含まれており、サイトとの接続は秘密が保たれません。
identity-description-active-loaded-insecure = このサイトと共有したあなたの情報 (パスワードやメッセージ、クレジットカード情報など) が第三者に盗み見られる可能性があります。
identity-learn-more =
    .value = 詳細情報
identity-disable-mixed-content-blocking =
    .label = このセッションのみ保護を無効にする
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = 保護を有効にする
    .accesskey = E
identity-more-info-link-text =
    .label = 詳細を表示

## Window controls

browser-window-minimize-button =
    .tooltiptext = 最小化
browser-window-maximize-button =
    .tooltiptext = 最大化
browser-window-restore-down-button =
    .tooltiptext = 元に戻す
browser-window-close-button =
    .tooltiptext = 閉じる

## Tab actions

# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-playing2 = 再生中
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-muted2 = ミュート中
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-blocked = 自動再生をブロック
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-pip = ピクチャーインピクチャー

## These labels should be written in all capital letters if your locale supports them.
## Variables:
##  $count (number): number of affected tabs

browser-tab-mute =
    { $count ->
        [1] タブをミュート
       *[other] { $count } 個のタブをミュート
    }
browser-tab-unmute =
    { $count ->
        [1] タブのミュートを解除
       *[other] { $count } 個のタブのミュートを解除
    }
browser-tab-unblock =
    { $count ->
        [1] タブのメディアを再生
       *[other] { $count } 個のタブのメディアを再生
    }

## Bookmarks toolbar items

browser-import-button2 =
    .label = ブックマークをインポートする...
    .tooltiptext = ブックマークを他のブラウザーから { -brand-short-name } にインポートします。
bookmarks-toolbar-empty-message = ブックマークをこのブックマークツールバーに配置すると、素早くアクセスできます。<a data-l10n-name="manage-bookmarks">ブックマークを管理...</a>

## WebRTC Pop-up notifications

popup-select-camera-device =
    .value = カメラ:
    .accesskey = C
popup-select-camera-icon =
    .tooltiptext = カメラ
popup-select-microphone-device =
    .value = マイク:
    .accesskey = M
popup-select-microphone-icon =
    .tooltiptext = マイク
popup-select-speaker-icon =
    .tooltiptext = スピーカー
popup-all-windows-shared = 画面に表示されているすべてのウィンドウを共有します。
popup-screen-sharing-block =
    .label = ブロック
    .accesskey = B
popup-screen-sharing-always-block =
    .label = 常にブロック
    .accesskey = w
popup-mute-notifications-checkbox = 共有中はウェブサイトからの通知を無効にする

## WebRTC window or screen share tab switch warning

sharing-warning-window = { -brand-short-name } を共有しています。新しいタブ に切り替えると、他の人にも見えます。
sharing-warning-screen = 全画面を共有しています。新しいタブ に切り替えると、他の人にも見えます。
sharing-warning-proceed-to-tab =
    .label = タブに移動
sharing-warning-disable-for-session =
    .label = このセッションでは共有保護を無効にする。

## DevTools F12 popup

enable-devtools-popup-description = F12 ショートカットを使うには、最初にメニューのウェブ開発から開発ツールを開いてください。

## URL Bar

# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = URL または検索語句を入力します
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = ウェブを検索します
    .aria-label = { $name } で検索
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = 検索語句を入力を入力します
    .aria-label = { $name } を検索
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = 検索語句を入力を入力します
    .aria-label = ブックマークを検索
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = 検索語句を入力を入力します
    .aria-label = 履歴を検索
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = 検索語句を入力を入力します
    .aria-label = タブを検索
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = { $name } で検索、または URL を入力します
# Variables
#  $component (String): the name of the component which forces remote control.
#    Example: "DevTools", "Marionette", "RemoteAgent".
urlbar-remote-control-notification-anchor2 =
    .tooltiptext = ブラウザーがリモート制御下にあります (制御元: { $component })
urlbar-permissions-granted =
    .tooltiptext = このウェブサイトで追加の権限を許可しました。
urlbar-switch-to-tab =
    .value = タブを表示:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = 拡張機能:
urlbar-go-button =
    .tooltiptext = アドレスバーに入力された URL へ移動します
urlbar-page-action-button =
    .tooltiptext = ページ操作

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".

# Used when the private browsing engine differs from the default engine.
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-in-private-w-engine = プライベートウィンドウの { $engine } で検索
# Used when the private browsing engine is the same as the default engine.
urlbar-result-action-search-in-private = プライベートウィンドウで検索
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-w-engine = { $engine } で検索
urlbar-result-action-sponsored = 広告
urlbar-result-action-switch-tab = タブを表示
urlbar-result-action-visit = 開く
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-before-tabtosearch-web = Tab キーを押すと { $engine } でウェブを検索します
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-before-tabtosearch-other = Tab キーを押すと { $engine } を検索します
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-tabtosearch-web = アドレスバーから直接 { $engine } で検索
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-tabtosearch-other-engine = アドレスバーから直接 { $engine } を検索
# Action text for copying to clipboard.
urlbar-result-action-copy-to-clipboard = コピー
# Shows the result of a formula expression being calculated, the last = sign will be shown
# as part of the result (e.g. "= 2").
# Variables
#  $result (String): the string representation for a formula result
urlbar-result-action-calculator-result = = { $result }

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".
## In these actions "Search" is a verb, followed by where the search is performed.

urlbar-result-action-search-bookmarks = ブックマークを検索
urlbar-result-action-search-history = 履歴を検索
urlbar-result-action-search-tabs = タブを検索

## Labels shown above groups of urlbar results

# A label shown above the "Waterfox Suggest" (bookmarks/history) group in the
# urlbar results.
urlbar-group-firefox-suggest =
  .label = { -firefox-suggest-brand-name }

# A label shown above the search suggestions group in the urlbar results. It
# should use title case.
# Variables
#  $engine (String): the name of the search engine providing the suggestions
urlbar-group-search-suggestions =
  .label = { $engine } の検索候補

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> は現在全画面表示モードです。
fullscreen-warning-no-domain = このページは現在全画面表示モードです。
fullscreen-exit-button = 全画面表示モードを終了 (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = 全画面表示モードを終了 (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = マウスポインターは現在、 <span data-l10n-name="domain">{ $domain }</span> が制御しています。制御を取り戻すには、ESC キーを押してください。
pointerlock-warning-no-domain = マウスポインターは現在、このページが制御しています。制御を取り戻すには、ESC キーを押してください。

## Subframe crash notification

crashed-subframe-message = <strong>このページの一部がクラッシュしました。</strong> { -brand-product-name } にこの問題を知らせて素早く修正するために、レポートを送信してください。
# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = このページの一部がクラッシュしました。{ -brand-product-name } にこの問題を知らせて素早く修正するために、レポートを送信してください。
crashed-subframe-learnmore-link =
    .value = 詳細
crashed-subframe-submit =
    .label = レポートを送信
    .accesskey = S

## Bookmarks panels, menus and toolbar

bookmarks-manage-bookmarks =
    .label = ブックマークを管理
bookmarks-recent-bookmarks-panel-subheader = 最近のブックマーク
bookmarks-toolbar-chevron =
    .tooltiptext = 残りのブックマークを表示します
bookmarks-sidebar-content =
    .aria-label = ブックマーク
bookmarks-menu-button =
    .label = ブックマークメニュー
bookmarks-other-bookmarks-menu =
    .label = 他のブックマーク
bookmarks-mobile-bookmarks-menu =
    .label = モバイルのブックマーク
bookmarks-tools-sidebar-visibility =
    .label =
        { $isVisible ->
            [true] ブックマークサイドバーを隠す
           *[other] ブックマークサイドバーを表示
        }
bookmarks-tools-toolbar-visibility-menuitem =
    .label =
        { $isVisible ->
            [true] ブックマークツールバーを隠す
           *[other] ブックマークツールバーを表示
        }
bookmarks-tools-toolbar-visibility-panel =
    .label =
        { $isVisible ->
            [true] ブックマークツールバーを隠す
           *[other] ブックマークツールバーを表示
        }
bookmarks-tools-menu-button-visibility =
    .label =
        { $isVisible ->
            [true] ブックマークメニューをツールバーから削除
           *[other] ブックマークメニューをツールバーに追加
        }
bookmarks-search =
    .label = ブックマークを検索
bookmarks-tools =
    .label = ブックマークツール
bookmarks-bookmark-edit-panel =
    .label = このブックマークを編集
# The aria-label is a spoken label that should not include the word "toolbar" or
# such, because screen readers already know that this container is a toolbar.
# This avoids double-speaking.
bookmarks-toolbar =
    .toolbarname = ブックマークツールバー
    .accesskey = B
    .aria-label = ブックマーク
bookmarks-toolbar-menu =
    .label = ブックマークツールバー
bookmarks-toolbar-placeholder =
    .title = ブックマークツールバーの項目
bookmarks-toolbar-placeholder-button =
    .label = ブックマークツールバーの項目
# "Bookmark" is a verb, as in "Add current tab to bookmarks".
bookmarks-current-tab =
    .label = 現在のタブをブックマークに追加

## Library Panel items

library-bookmarks-menu =
    .label = ブックマーク
library-recent-activity-title =
    .value = 最近のアクティビティ

## Pocket toolbar button

save-to-pocket-button =
    .label = { -pocket-brand-name } に保存
    .tooltiptext = { -pocket-brand-name } に保存します

## Repair text encoding toolbar button

repair-text-encoding-button =
    .label = テキストエンコーディングを修復
    .tooltiptext = ページの内容から正しいテキストエンコーディングを推測します

## Customize Toolbar Buttons

# Variables:
#  $shortcut (String): keyboard shortcut to open the add-ons manager
toolbar-addons-themes-button =
    .label = アドオンとテーマ
    .tooltiptext = アドオンとテーマを管理します ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open settings (only on macOS)
toolbar-settings-button =
    .label = 設定
    .tooltiptext =
        { PLATFORM() ->
            [macos] 設定を開きます ({ $shortcut })
           *[other] 設定を開きます
        }

## More items

more-menu-go-offline =
    .label = オフライン作業
    .accesskey = k
toolbar-overflow-customize-button =
    .label = ツールバーをカスタマイズ...
    .accesskey = C
toolbar-button-email-link =
    .label = ページの URL をメールで送信
    .tooltiptext = このページの URL をメールで送信します
# Variables:
#  $shortcut (String): keyboard shortcut to save a copy of the page
toolbar-button-save-page =
    .label = ページを保存
    .tooltiptext = このページを保存します ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open a local file
toolbar-button-open-file =
    .label = ファイルを開く
    .tooltiptext = ファイルを開きます ({ $shortcut })
toolbar-button-synced-tabs =
    .label = 同期タブ
    .tooltiptext = 他の端末のタブを表示します
# Variables
# $shortcut (string) - Keyboard shortcut to open a new private browsing window
toolbar-button-new-private-window =
    .label = 新しいプライベートウィンドウ
    .tooltiptext = 新しいプライベートブラウジングウィンドウを開きます ({ $shortcut })

## EME notification panel

eme-notifications-drm-content-playing = このサイトの音声や映像には DRM ソフトウェアが使われており、{ -brand-short-name } での視聴が制限される可能性があります。
eme-notifications-drm-content-playing-manage = 設定を管理
eme-notifications-drm-content-playing-manage-accesskey = M
eme-notifications-drm-content-playing-dismiss = 閉じる
eme-notifications-drm-content-playing-dismiss-accesskey = D

## Password save/update panel

panel-save-update-username = ユーザー名
panel-save-update-password = パスワード

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = { $name } を削除しますか？
addon-removal-abuse-report-checkbox = この拡張機能を { -vendor-short-name } に報告する

## Remote / Synced tabs

remote-tabs-manage-account =
    .label = アカウントを管理
remote-tabs-sync-now = 今すぐ同期

##

# "More" item in macOS share menu
menu-share-more =
    .label = その他...
ui-tour-info-panel-close =
    .tooltiptext = 閉じる

## Variables:
##  $uriHost (String): URI host for which the popup was allowed or blocked.

popups-infobar-allow =
    .label = このサイト ({ $uriHost }) によるポップアップを許可する
    .accesskey = p
popups-infobar-block =
    .label = このサイト ({ $uriHost }) によるポップアップを禁止する
    .accesskey = p

##

popups-infobar-dont-show-message =
    .label = ポップアップをブロックするとき、このメッセージを表示しない
    .accesskey = D

edit-popup-settings =
    .label = ポップアップの設定を管理...
    .accesskey = M

picture-in-picture-hide-toggle =
    .label = ピクチャーインピクチャーの切り替えボタンを隠す
    .accesskey = H

# Navigator Toolbox

# This string is a spoken label that should not include
# the word "toolbar" or such, because screen readers already know that
# this container is a toolbar. This avoids double-speaking.
navbar-accessible =
    .aria-label = ナビゲーション
navbar-downloads =
    .label = ダウンロード
navbar-overflow =
    .tooltiptext = その他のツール...
# Variables:
#   $shortcut (String): keyboard shortcut to print the page
navbar-print =
    .label = 印刷
    .tooltiptext = このページを印刷します... ({ $shortcut })
navbar-print-tab-modal-disabled =
    .label = 印刷
    .tooltiptext = このページを印刷します
navbar-home =
    .label = ホーム
    .tooltiptext = { -brand-short-name } のホームページです
navbar-library =
    .label = ブラウジングライブラリー
    .tooltiptext = 履歴や保存したブックマークなどを表示します
navbar-search =
    .title = 検索
navbar-accessibility-indicator =
    .tooltiptext = アクセシビリティ機能が有効です
# Name for the tabs toolbar as spoken by screen readers. The word
# "toolbar" is appended automatically and should not be included in
# in the string
tabs-toolbar =
    .aria-label = ブラウザータブ
tabs-toolbar-new-tab =
    .label = 新しいタブ
tabs-toolbar-list-all-tabs =
    .label = タブを一覧表示する
    .tooltiptext = タブを一覧表示します
