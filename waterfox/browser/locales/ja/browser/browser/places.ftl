# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.

places-open =
    .label = 開く
    .accesskey = O
places-open-in-tab =
    .label = 新しいタブで開く
    .accesskey = w
places-open-in-container-tab =
    .label = 新しいコンテナータブで開く
    .accesskey = i
places-open-all-bookmarks =
    .label = ブックマークをすべて開く
    .accesskey = O
places-open-all-in-tabs =
    .label = タブですべて開く
    .accesskey = O
places-open-in-window =
    .label = 新しいウィンドウで開く
    .accesskey = N
places-open-in-private-window =
    .label = 新しいプライベートウィンドウで開く
    .accesskey = P
places-empty-bookmarks-folder =
    .label = (なし)
places-add-bookmark =
    .label = ブックマークを追加...
    .accesskey = B
places-add-folder-contextmenu =
    .label = フォルダーを追加...
    .accesskey = F
places-add-folder =
    .label = フォルダーを追加...
    .accesskey = o
places-add-separator =
    .label = 区切りを追加
    .accesskey = S
places-view =
    .label = 表示
    .accesskey = w
places-by-date =
    .label = 日付順に並べる
    .accesskey = D
places-by-site =
    .label = サイト名順に並べる
    .accesskey = S
places-by-most-visited =
    .label = 表示回数順に並べる
    .accesskey = V
places-by-last-visited =
    .label = 最後に表示した日時順に並べる
    .accesskey = L
places-by-day-and-site =
    .label = 日付とサイト名順に並べる
    .accesskey = t
places-history-search =
    .placeholder = 履歴を検索
places-history =
    .aria-label = 履歴
places-bookmarks-search =
    .placeholder = ブックマークを検索
places-delete-domain-data =
    .label = このサイトの履歴を消去
    .accesskey = F
places-sortby-name =
    .label = 名前順に並べ替える
    .accesskey = r
# places-edit-bookmark and places-edit-generic will show one or the other and can have the same access key.
places-edit-bookmark =
    .label = ブックマークを編集...
    .accesskey = E
places-edit-generic =
    .label = 編集...
    .accesskey = E
places-edit-folder2 =
    .label = フォルダーを編集...
    .accesskey = E
# Variables
#   $count (number) - Number of folders to delete
places-delete-folder =
    .label = フォルダーを削除
    .accesskey = D
# Variables:
#   $count (number) - The number of pages selected for removal.
places-delete-page =
    .label =
        { $count ->
            [1] ページを削除
           *[other] ページを削除
        }
    .accesskey = D
# Managed bookmarks are created by an administrator and cannot be changed by the user.
managed-bookmarks =
    .label = 管理ブックマーク
# This label is used when a managed bookmarks folder doesn't have a name.
managed-bookmarks-subfolder =
    .label = サブフォルダー
# This label is used for the "Other Bookmarks" folder that appears in the bookmarks toolbar.
other-bookmarks-folder =
    .label = 他のブックマーク
places-show-in-folder =
    .label = フォルダーで表示
    .accesskey = F
# Variables:
# $count (number) - The number of elements being selected for removal.
places-delete-bookmark =
    .label = ブックマークを削除
    .accesskey = D
# Variables:
#   $count (number) - The number of bookmarks being added.
places-create-bookmark =
    .label =
        { $count ->
            [1] ページをブックマークに追加...
           *[other] ページをブックマークに追加...
        }
    .accesskey = B
places-untag-bookmark =
    .label = タグを消去
    .accesskey = R
places-manage-bookmarks =
    .label = ブックマークを管理
    .accesskey = M
places-forget-about-this-site-confirmation-title = このサイトのデータの消去について
# Variables:
# $hostOrBaseDomain (string) - The base domain (or host in case there is no base domain) for which data is being removed
places-forget-about-this-site-confirmation-msg = この操作は { $hostOrBaseDomain } に関連する履歴、Cookie、キャッシュ、コンテンツの設定を含むデータを削除します。関連するブックマークとパスワードは削除されません。本当に削除してもよろしいですか？
places-forget-about-this-site-forget = 消去
places-library3 =
    .title = ブラウジングライブラリー
places-organize-button =
    .label = 管理
    .tooltiptext = 履歴とブックマークを管理します
    .accesskey = O
places-organize-button-mac =
    .label = 管理
    .tooltiptext = 履歴とブックマークを管理します
places-file-close =
    .label = 閉じる
    .accesskey = C
places-cmd-close =
    .key = w
places-view-button =
    .label = 表示
    .tooltiptext = 表示する項目を変更します
    .accesskey = V
places-view-button-mac =
    .label = 表示
    .tooltiptext = 表示する項目を変更します
places-view-menu-columns =
    .label = 表示する列
    .accesskey = C
places-view-menu-sort =
    .label = 項目の表示順序
    .accesskey = S
places-view-sort-unsorted =
    .label = 並べ替えない
    .accesskey = U
places-view-sort-ascending =
    .label = 昇順 (A > Z)
    .accesskey = A
places-view-sort-descending =
    .label = 降順 (Z > A)
    .accesskey = Z
places-maintenance-button =
    .label = インポートとバックアップ
    .tooltiptext = ブックマークのインポートとバックアップができます
    .accesskey = I
places-maintenance-button-mac =
    .label = インポートとバックアップ
    .tooltiptext = ブックマークのインポートとバックアップができます
places-cmd-backup =
    .label = バックアップ...
    .accesskey = B
places-cmd-restore =
    .label = 復元
    .accesskey = R
places-cmd-restore-from-file =
    .label = ファイルを選択...
    .accesskey = C
places-import-bookmarks-from-html =
    .label = HTML からインポート...
    .accesskey = I
places-export-bookmarks-to-html =
    .label = HTML としてエクスポート...
    .accesskey = E
places-import-other-browser =
    .label = 他のブラウザーからデータをインポート...
    .accesskey = A
places-view-sort-col-name =
    .label = 名前
places-view-sort-col-tags =
    .label = タグ
places-view-sort-col-url =
    .label = URL
places-view-sort-col-most-recent-visit =
    .label = 最近表示した日時
places-view-sort-col-visit-count =
    .label = 表示回数
places-view-sort-col-date-added =
    .label = 追加日時
places-view-sort-col-last-modified =
    .label = 変更日時
places-view-sortby-name =
    .label = 名前順で表示
    .accesskey = N
places-view-sortby-url =
    .label = URL 順で表示
    .accesskey = L
places-view-sortby-date =
    .label = 最後に表示した日時順で表示
    .accesskey = V
places-view-sortby-visit-count =
    .label = 表示回数順で表示
    .accesskey = C
places-view-sortby-date-added =
    .label = 追加日時順で表示
    .accesskey = e
places-view-sortby-last-modified =
    .label = 変更日時順で表示
    .accesskey = M
places-view-sortby-tags =
    .label = タグ順で表示
    .accesskey = T
places-cmd-find-key =
    .key = f
places-back-button =
    .tooltiptext = フォルダー表示履歴を前に戻ります
places-forward-button =
    .tooltiptext = フォルダー表示履歴を次に進みます
places-details-pane-select-an-item-description = 各項目を選択すると、名前や詳細情報の表示や編集ができます
places-details-pane-no-items =
    .value = 項目がありません
# Variables:
#   $count (Number): number of items
places-details-pane-items-count =
    .value = 項目の数: { $count } 個

## Strings used as a placeholder in the Library search field. For example,
## "Search History" stands for "Search through the browser's history".

places-search-bookmarks =
    .placeholder = ブックマークの検索
places-search-history =
    .placeholder = 履歴の検索
places-search-downloads =
    .placeholder = ダウンロードの検索

##

places-locked-prompt = { -brand-short-name } のファイルを他のアプリケーションが使用しているため、ブックマークと履歴のシステムが無効化されます。この問題はセキュリティソフトが原因で生じることがあります。
