# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

### Waterfox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = 新しいタブ
newtab-settings-button =
    .title = 新しいタブページをカスタマイズ
newtab-personalize-icon-label =
    .title = 新しいタブをパーソナライズ
    .aria-label = 新しいタブをパーソナライズ
newtab-personalize-dialog-label =
    .aria-label = パーソナライズ

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = 検索
    .aria-label = 検索

# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-text = { $engine } で検索、または URL を入力します
newtab-search-box-handoff-text-no-engine = 検索語句、または URL を入力します
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-input =
    .placeholder = { $engine } で検索、または URL を入力します
    .title = { $engine } で検索、または URL を入力します
    .aria-label = { $engine } で検索、または URL を入力します
newtab-search-box-handoff-input-no-engine =
    .placeholder = 検索語句、または URL を入力します
    .title = 検索語句、または URL を入力します
    .aria-label = 検索語句、または URL を入力します
newtab-search-box-search-the-web-input =
    .placeholder = ウェブを検索
    .title = ウェブを検索
    .aria-label = ウェブを検索

newtab-search-box-text = ウェブを検索
newtab-search-box-input =
    .placeholder = ウェブを検索
    .aria-label = ウェブを検索

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = 検索エンジンを追加
newtab-topsites-add-topsites-header = 新着トップサイト
newtab-topsites-add-shortcut-header = 新しいショートカット
newtab-topsites-edit-topsites-header = トップサイトを編集
newtab-topsites-edit-shortcut-header = ショートカットを編集
newtab-topsites-title-label = タイトル
newtab-topsites-title-input =
    .placeholder = タイトルを入力
newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = URL を入力するか貼り付け
newtab-topsites-url-validation = 正しい URL を入力してください
newtab-topsites-image-url-label = カスタム画像 URL
newtab-topsites-use-image-link = カスタム画像を使用...
newtab-topsites-image-validation = 画像を読み込めませんでした。別の URL を試してください。

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = キャンセル
newtab-topsites-delete-history-button = 履歴から削除
newtab-topsites-save-button = 保存
newtab-topsites-preview-button = プレビュー
newtab-topsites-add-button = 追加

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = 本当にこのページに関して保存されているあらゆる情報を履歴から削除しますか？
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = この操作は取り消せません。

## Top Sites - Sponsored label

newtab-topsite-sponsored = 広告

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = メニューを開きます
    .aria-label = メニューを開きます
# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = 削除
    .aria-label = 削除
# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = メニューを開きます
    .aria-label = { $title } のコンテキストメニューを開く
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = このサイトを編集
    .aria-label = このサイトを編集

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = 編集
newtab-menu-open-new-window = 新しいウィンドウで開く
newtab-menu-open-new-private-window = 新しいプライベートウィンドウで開く
newtab-menu-dismiss = 閉じる
newtab-menu-pin = ピン留め
newtab-menu-unpin = ピン留めを外す
newtab-menu-delete-history = 履歴から削除
newtab-menu-save-to-pocket = { -pocket-brand-name } に保存
newtab-menu-delete-pocket = { -pocket-brand-name } から削除
newtab-menu-archive-pocket = { -pocket-brand-name } にアーカイブ
newtab-menu-show-privacy-info = 私たちのスポンサーとあなたのプライバシー

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = 完了
newtab-privacy-modal-button-manage = スポンサーコンテンツの設定を管理
newtab-privacy-modal-header = プライバシーは重要です。
newtab-privacy-modal-paragraph-2 =
    盛り上がる魅力あるストーリーに加えて、選ばれたスポンサーからあなたの興味を引きそうな厳選コンテンツを提供します。
    <strong>ブラウジングデータに { -brand-product-name } の個人情報のコピーが残ることはありません。</strong>私たちとスポンサーのどちらもその情報を見ることはありませんので、ご安心ください。
newtab-privacy-modal-link = 新しいタブページでのプライバシーの仕組みついて

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = ブックマークを削除
# Bookmark is a verb here.
newtab-menu-bookmark = ブックマーク

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = ダウンロード元の URL をコピー
newtab-menu-go-to-download-page = ダウンロード元のページを開く
newtab-menu-remove-download = 履歴から削除

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Finder に表示
       *[other] 保存フォルダーを開く
    }
newtab-menu-open-file = ファイルを開く

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = 訪問済み
newtab-label-bookmarked = ブックマーク済み
newtab-label-removed-bookmark = 削除済みブックマーク
newtab-label-recommended = 話題の記事
newtab-label-saved = { -pocket-brand-name } に保存しました
newtab-label-download = ダウンロード済み
# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = 提供: { $sponsorOrSource }
# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = 提供: { $sponsor }

# This string is used under the image of story cards to indicate source and time to read
# Variables:
#  $source (String): This is the name of a company or their domain
#  $timeToRead (Number): This is the estimated number of minutes to read this story
newtab-label-source-read-time = { $source } · { $timeToRead } 分

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = セクションを削除
newtab-section-menu-collapse-section = セクションを折りたたむ
newtab-section-menu-expand-section = セクションを広げる
newtab-section-menu-manage-section = セクションを管理
newtab-section-menu-manage-webext = 拡張機能を管理
newtab-section-menu-add-topsite = トップサイトを追加
newtab-section-menu-add-search-engine = 検索エンジンを追加
newtab-section-menu-move-up = 上へ移動
newtab-section-menu-move-down = 下へ移動
newtab-section-menu-privacy-notice = プライバシー通知

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = セクションを折りたたむ
newtab-section-expand-section-label =
    .aria-label = セクションを広げる

## Section Headers.

newtab-section-header-topsites = トップサイト
newtab-section-header-highlights = ハイライト
newtab-section-header-recent-activity = 最近のアクティビティ
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = { $provider } のおすすめ

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = ブラウジング中にあなたが最近訪れたりブックマークしたりした、優れた記事、動画、その他ページの一部をここに表示します。
# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = すべて既読です。また後で戻って { $provider } からのおすすめ記事をチェックしてください。もし待ちきれないなら、人気のトピックを選択すれば、他にもウェブ上の優れた記事を見つけられます。

## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = すべて既読です！
newtab-discovery-empty-section-topstories-content = また後で戻っておすすめ記事をチェックしてください。
newtab-discovery-empty-section-topstories-try-again-button = 再試行
newtab-discovery-empty-section-topstories-loading = 読み込み中...
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = おおっと、このセクションはほぼ読み込みましたが、完全ではありません。

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = 人気のトピック:
newtab-pocket-more-recommendations = 他のおすすめ
newtab-pocket-learn-more = 詳細
newtab-pocket-cta-button = { -pocket-brand-name } を入手
newtab-pocket-cta-text = お気に入りに記事を { -pocket-brand-name } に保存して、魅力的な読み物を思う存分楽しみましょう。

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = このコンテンツの読み込み中に何か問題が発生しました。
newtab-error-fallback-refresh-link = ページを再読み込みしてもう一度試してください。

## Customization Menu

newtab-custom-shortcuts-title = ショートカット
newtab-custom-shortcuts-subtitle = 保存または訪問したサイト
newtab-custom-row-selector = { $num } 行
newtab-custom-sponsored-sites = 広告ショートカット
newtab-custom-pocket-title = { -pocket-brand-name } のおすすめ
newtab-custom-pocket-subtitle = { -brand-product-name } ファミリーを構成する { -pocket-brand-name } が厳選した注目のコンテンツ
newtab-custom-pocket-sponsored = 広告ストーリー
newtab-custom-recent-title = 最近のアクティビティ
newtab-custom-recent-subtitle = 最近のサイトとコンテンツの抜粋
newtab-custom-close-button = 閉じる
newtab-custom-settings = 他の設定を管理
