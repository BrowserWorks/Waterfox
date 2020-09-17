# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - "Mozilla Firefox"
# private - "Mozilla Firefox (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } (プライベートブラウジング)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (プライベートブラウジング)
# These are the default window titles on macOS. The first two are for use when
# there is no content title:
#
# "default" - "Mozilla Firefox"
# "private" - "Mozilla Firefox - (Private Browsing)"
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
    .data-title-private = { -brand-full-name } - (プライベートブラウジング)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (プライベートブラウジング)
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

page-action-add-to-urlbar =
    .label = アドレスバーに追加
page-action-manage-extension =
    .label = 拡張機能を管理...
page-action-remove-from-urlbar =
    .label = アドレスバーから削除
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

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = 今回だけ使う検索エンジン:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = 検索設定を変更
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

bookmark-panel-show-editor-checkbox =
    .label = 追加時にエディターを表示する
    .accesskey = S
bookmark-panel-done-button =
    .label = 完了
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = 安全ではない接続
identity-connection-secure = 安全な接続
identity-connection-internal = このページは { -brand-short-name } の安全な内部ページです。
identity-connection-file = これはあなたのコンピューターに保存されているページです。
identity-extension-page = このページは拡張機能から読み込まれています。
identity-active-blocked = このページの一部が安全でないため { -brand-short-name } がブロックしました。
identity-custom-root = Mozilla が承認していない発行者の証明書で検証された接続です。
identity-passive-loaded = このページの一部 (画像など) は安全ではありません。
identity-active-loaded = このページでの保護は無効に設定されています。
identity-weak-encryption = このページは脆弱な暗号を使用しています。
identity-insecure-login-forms = このページのログインフォームは安全ではありません。
identity-permissions =
    .value = このサイトの設定
identity-permissions-reload-hint = 変更内容を適用するには、ページの再読み込みが必要です。
identity-permissions-empty = このサイトに特別な権限は設定されていません。
identity-clear-site-data =
    .label = Cookie とサイトデータを消去...
identity-connection-not-secure-security-view = このサイトとの接続は安全ではありません。
identity-connection-verified = このサイトとの接続は安全です。
identity-ev-owner-label = 証明書の発行先:
identity-description-custom-root = Mozilla はこの証明書の発行者を承認していません。OS またはシステム管理者により追加された可能性があります。 <label data-l10n-name="link">詳細情報</label>
identity-remove-cert-exception =
    .label = 例外から削除
    .accesskey = R
identity-description-insecure = このサイトへの接続は秘密が保たれません。このサイトに送信した情報 (パスワードやメッセージ、クレジットカード情報など) が第三者に盗み見られる可能性があります。
identity-description-insecure-login-forms = このページに入力したログイン情報は安全に送信されません。第三者に盗み見られる可能性があります。
identity-description-weak-cipher-intro = このウェブサイトとの接続には脆弱な暗号が使用されており、秘密が保たれません。
identity-description-weak-cipher-risk = 第三者にあなたの情報を盗み見られたりウェブサイトの動作を不正に改変される可能性があります。
identity-description-active-blocked = { -brand-short-name } がこのページ上の安全でないコンテンツをブロックしました。 <label data-l10n-name="link">詳細情報</label>
identity-description-passive-loaded = この接続は安全ではないため、サイトと共有したあなたの情報が第三者に盗み見られる可能性があります。
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

## WebRTC Pop-up notifications

popup-select-camera =
    .value = 共有するカメラ:
    .accesskey = C
popup-select-microphone =
    .value = 共有するマイク:
    .accesskey = M
popup-all-windows-shared = 画面に表示されているすべてのウィンドウを共有します。
popup-screen-sharing-not-now =
    .label = 後で
    .accesskey = w
popup-screen-sharing-never =
    .label = 以後許可しない
    .accesskey = N
popup-silence-notifications-checkbox = 共有中は { -brand-short-name } からの通知を無効にする。
popup-silence-notifications-checkbox-warning = 共有中は { -brand-short-name } からの通知を表示しないようにします。

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

urlbar-default-placeholder =
    .defaultPlaceholder = URL または検索語句を入力します
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
    .placeholder = Search with { $name } or enter address
urlbar-remote-control-notification-anchor =
    .tooltiptext = ブラウザーがリモート制御下にあります
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
urlbar-pocket-button =
    .tooltiptext = { -pocket-brand-name } に保存

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
