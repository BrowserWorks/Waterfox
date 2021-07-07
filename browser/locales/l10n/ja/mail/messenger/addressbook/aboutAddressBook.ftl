# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

about-addressbook-title = Address Book

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

about-addressbook-sort-button =
  .title = リストの並び順を変更します
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

## Details

about-addressbook-begin-edit-contact-button = 編集
about-addressbook-cancel-edit-contact-button = キャンセル
about-addressbook-save-edit-contact-button = 保存

about-addressbook-details-email-addresses-header = メールアドレス
about-addressbook-details-phone-numbers-header = 電話番号
about-addressbook-details-home-address-header = 自宅アドレス
about-addressbook-details-work-address-header = 勤務先アドレス
about-addressbook-details-other-info-header = 他の情報
