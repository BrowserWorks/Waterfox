# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

about-addressbook-title = アドレス帳

## Toolbar

about-addressbook-toolbar-new-address-book =
    .label = 新しいアドレス帳
about-addressbook-toolbar-add-carddav-address-book =
    .label = CardDAV アドレス帳を追加
about-addressbook-toolbar-add-ldap-address-book =
    .label = LDAP アドレス帳を追加
about-addressbook-toolbar-new-contact =
    .label = 新しい連絡先
about-addressbook-toolbar-new-list =
    .label = 新しいアドレスリスト
about-addressbook-toolbar-import =
    .label = インポート

## Books

all-address-books = すべてのアドレス帳
about-addressbook-books-context-properties =
    .label = プロパティ
about-addressbook-books-context-synchronize =
    .label = 同期
about-addressbook-books-context-edit =
    .label = 編集
about-addressbook-books-context-print =
    .label = 印刷...
about-addressbook-books-context-export =
    .label = エクスポート...
about-addressbook-books-context-delete =
    .label = 削除
about-addressbook-books-context-remove =
    .label = 削除
about-addressbook-books-context-startup-default =
    .label = 初期表示ディレクトリー
about-addressbook-confirm-delete-book-title = アドレス帳の削除
# Variables:
# $name (String) - Name of the address book to be deleted.
about-addressbook-confirm-delete-book = { $name } とその内容をすべて削除してもよろしいですか？
about-addressbook-confirm-remove-remote-book-title = アドレス帳の削除
# Variables:
# $name (String) - Name of the remote address book to be removed.
about-addressbook-confirm-remove-remote-book = { $name } を削除してもよろしいですか？

## Cards

# Variables:
# $name (String) - Name of the address book that will be searched.
about-addressbook-search =
    .placeholder = { $name } を検索
about-addressbook-search-all =
    .placeholder = すべてのアドレス帳を検索
about-addressbook-sort-button2 =
    .title = リスト表示のオプションです
about-addressbook-name-format-display =
    .label = 表示名
about-addressbook-name-format-firstlast =
    .label = 名 姓
about-addressbook-name-format-lastfirst =
    .label = 姓 名
about-addressbook-sort-name-ascending =
    .label = 名前で並べ替え (昇順)
about-addressbook-sort-name-descending =
    .label = 名前で並べ替え (降順)
about-addressbook-sort-email-ascending =
    .label = メールアドレスで並べ替え (昇順)
about-addressbook-sort-email-descending =
    .label = メールアドレスで並べ替え (降順)
about-addressbook-horizontal-layout =
    .label = 水平レイアウトに切り替え
about-addressbook-vertical-layout =
    .label = 垂直レイアウトに切り替え

## Card column headers
## Each string is listed here twice, and the values should match.

about-addressbook-column-header-generatedname = 名前
about-addressbook-column-label-generatedname =
    .label = { about-addressbook-column-header-generatedname }
about-addressbook-column-header-emailaddresses = メールアドレス
about-addressbook-column-label-emailaddresses =
    .label = { about-addressbook-column-header-emailaddresses }
about-addressbook-column-header-phonenumbers = 電話番号
about-addressbook-column-label-phonenumbers =
    .label = { about-addressbook-column-header-phonenumbers }
about-addressbook-column-header-addresses = 住所
about-addressbook-column-label-addresses =
    .label = { about-addressbook-column-header-addresses }
about-addressbook-column-header-title = 役職
about-addressbook-column-label-title =
    .label = { about-addressbook-column-header-title }
about-addressbook-column-header-department = 部署
about-addressbook-column-label-department =
    .label = { about-addressbook-column-header-department }
about-addressbook-column-header-organization = 組織
about-addressbook-column-label-organization =
    .label = { about-addressbook-column-header-organization }
about-addressbook-column-header-addrbook = アドレス帳
about-addressbook-column-label-addrbook =
    .label = { about-addressbook-column-header-addrbook }
about-addressbook-cards-context-write =
    .label = 作成
about-addressbook-confirm-delete-mixed-title = 連絡先とアドレスリストの削除
# Variables:
# $count (Number) - The number of contacts and lists to be deleted. Always greater than 1.
about-addressbook-confirm-delete-mixed = 選択された { $count } 件の連絡先とアドレスリストを削除してもよろしいですか？
# Variables:
# $count (Number) - The number of lists to be deleted.
about-addressbook-confirm-delete-lists-title =
    { $count ->
         [one] アドレスリストの削除
        *[other] アドレスリストの削除
    }
# Variables:
# $count (Number) - The number of lists to be deleted.
# $name (String) - The name of the list to be deleted, if $count is 1.
about-addressbook-confirm-delete-lists =
    { $count ->
         [one] { $name } のアドレスリストを削除してもよろしいですか？
        *[other] 選択された { $count } 件のアドレスリストを削除してもよろしいですか？
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
about-addressbook-confirm-remove-contacts-title =
    { $count ->
         [one] 連絡先の除外
        *[other] 連絡先の除外
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
# $name (String) - The name of the contact to be removed, if $count is 1.
# $list (String) - The name of the list that contacts will be removed from.
about-addressbook-confirm-remove-contacts =
    { $count ->
         [one] { $list } のアドレスリストから { $name } の連絡先を除外してもよろしいですか？
        *[other] { $list } のアドレスリストから選択された { $count } 件の連絡先を除外してもよろしいですか？
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
about-addressbook-confirm-delete-contacts-title =
    { $count ->
         [one] 連絡先の削除
        *[other] 連絡先の削除
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
# $name (String) - The name of the contact to be deleted, if $count is 1.
about-addressbook-confirm-delete-contacts =
    { $count ->
         [one] { $name } の連絡先を削除してもよろしいですか？
        *[other] 選択された { $count } 件の連絡先を削除してもよろしいですか？
    }

## Card list placeholder
## Shown when there are no cards in the list

about-addressbook-placeholder-empty-book = 連絡先がありません
about-addressbook-placeholder-new-contact = 新しい連絡先
about-addressbook-placeholder-search-only = このアドレス帳は検索後にのみ連絡先を表示します
about-addressbook-placeholder-searching = 検索しています...
about-addressbook-placeholder-no-search-results = 連絡先が見つかりませんでした

## Details

about-addressbook-prefer-display-name = メッセージヘッダーでは表示名を優先する
about-addressbook-write-action-button = 作成
about-addressbook-event-action-button = 予定
about-addressbook-search-action-button = 検索
about-addressbook-begin-edit-contact-button = 編集
about-addressbook-delete-edit-contact-button = 削除
about-addressbook-cancel-edit-contact-button = キャンセル
about-addressbook-save-edit-contact-button = 保存
about-addressbook-add-contact-to = 追加先:
about-addressbook-details-email-addresses-header = メールアドレス
about-addressbook-details-phone-numbers-header = 電話番号
about-addressbook-details-addresses-header = アドレス
about-addressbook-details-notes-header = メモ
about-addressbook-details-other-info-header = 他の情報
about-addressbook-entry-type-work = 勤務先
about-addressbook-entry-type-home = 自宅
about-addressbook-entry-type-fax = Fax
about-addressbook-entry-type-cell = 携帯電話
about-addressbook-entry-type-pager = ポケットベル
about-addressbook-entry-name-birthday = 誕生日
about-addressbook-entry-name-anniversary = 記念日
about-addressbook-entry-name-title = 役職
about-addressbook-entry-name-role = 担当
about-addressbook-entry-name-organization = 組織
about-addressbook-entry-name-website = ウェブサイト
about-addressbook-entry-name-time-zone = タイムゾーン
about-addressbook-unsaved-changes-prompt-title = 変更が保存されていません
about-addressbook-unsaved-changes-prompt = 編集ビューを閉じる前に変更を保存しますか？

# Photo dialog

about-addressbook-photo-drop-target = 写真をここにドロップまたは貼り付けるか、クリックしてファイルを選択してください
about-addressbook-photo-drop-loading = 写真を読み込んでいます...
about-addressbook-photo-drop-error = 写真の読み込みに失敗しました。
about-addressbook-photo-filepicker-title = 画像ファイルの選択
about-addressbook-photo-discard = 既存の写真を破棄
about-addressbook-photo-cancel = キャンセル
about-addressbook-photo-save = 保存
