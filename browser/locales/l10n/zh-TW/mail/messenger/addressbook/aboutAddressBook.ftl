# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

about-addressbook-title = 通訊錄

## Toolbar

about-addressbook-toolbar-new-address-book =
    .label = 新增通訊錄
about-addressbook-toolbar-new-carddav-address-book =
    .label = 新增 CardDAV 通訊錄
about-addressbook-toolbar-new-ldap-address-book =
    .label = 新增 LDAP 通訊錄
about-addressbook-toolbar-add-carddav-address-book =
    .label = 新增 CardDAV 通訊錄
about-addressbook-toolbar-add-ldap-address-book =
    .label = 新增 LDAP 通訊錄
about-addressbook-toolbar-new-contact =
    .label = 新增連絡人
about-addressbook-toolbar-new-list =
    .label = 新增群組名單

## Books

all-address-books = 所有通訊錄
about-addressbook-books-context-properties =
    .label = 屬性
about-addressbook-books-context-synchronize =
    .label = 同步
about-addressbook-books-context-print =
    .label = 列印…
about-addressbook-books-context-delete =
    .label = 刪除
about-addressbook-books-context-remove =
    .label = 移除
about-addressbook-confirm-delete-book-title = 刪除通訊錄
# Variables:
# $name (String) - Name of the address book to be deleted.
about-addressbook-confirm-delete-book = 您確定要刪除 { $name } 及當中的所有聯絡人嗎？
about-addressbook-confirm-remove-remote-book-title = 移除通訊錄
# Variables:
# $name (String) - Name of the remote address book to be removed.
about-addressbook-confirm-remove-remote-book = 您確定要刪除 { $name } 嗎？

## Cards

# Variables:
# $name (String) - Name of the address book that will be searched.
about-addressbook-search =
    .placeholder = 搜尋 { $name }
about-addressbook-search-all =
    .placeholder = 搜尋所有通訊錄
about-addressbook-sort-button =
    .title = 更改清單順序
about-addressbook-name-format-display =
    .label = 顯示名稱
about-addressbook-name-format-firstlast =
    .label = [名] [姓]（英式）
about-addressbook-name-format-lastfirst =
    .label = [姓][名]（中式）
about-addressbook-sort-name-ascending =
    .label = 依照名稱排序（升冪）
about-addressbook-sort-name-descending =
    .label = 依照名稱排序（降冪）
about-addressbook-sort-email-ascending =
    .label = 依照電子郵件地址排序（升冪）
about-addressbook-sort-email-descending =
    .label = 依照電子郵件地址排序（降冪）
about-addressbook-confirm-delete-mixed-title = 刪除通訊錄與群組
# Variables:
# $count (Number) - The number of contacts and lists to be deleted. Always greater than 1.
about-addressbook-confirm-delete-mixed = 您確定要刪除這 { $count } 位聯絡人與群組？
# Variables:
# $count (Number) - The number of lists to be deleted.
about-addressbook-confirm-delete-lists-title =
    { $count ->
       *[other] 刪除群組
    }
# Variables:
# $count (Number) - The number of lists to be deleted.
# $name (String) - The name of the list to be deleted, if $count is 1.
about-addressbook-confirm-delete-lists =
    { $count ->
        [one] 您確定要刪除 { $name } 群組嗎？
       *[other] 您確定要刪除這 { $count } 個群組嗎？
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
about-addressbook-confirm-remove-contacts-title =
    { $count ->
       *[other] 移除聯絡人
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
# $name (String) - The name of the contact to be removed, if $count is 1.
# $list (String) - The name of the list that contacts will be removed from.
about-addressbook-confirm-remove-contacts =
    { $count ->
        [one] 您確定要從 { $list } 刪除聯絡人 { $name } 嗎？
       *[other] 您確定要從 { $list } 清單刪除 { $count } 位聯絡人嗎？
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
about-addressbook-confirm-delete-contacts-title =
    { $count ->
       *[other] 刪除聯絡人
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
# $name (String) - The name of the contact to be deleted, if $count is 1.
about-addressbook-confirm-delete-contacts =
    { $count ->
        [one] 您確定要刪除聯絡人 { $name } 嗎？
       *[other] 您確定要刪除下列 { $count } 位聯絡人嗎？
    }

## Details

about-addressbook-begin-edit-contact-button = 編輯
about-addressbook-cancel-edit-contact-button = 取消
about-addressbook-save-edit-contact-button = 儲存
about-addressbook-details-email-addresses-header = 電子郵件地址
about-addressbook-details-phone-numbers-header = 電話號碼
about-addressbook-details-home-address-header = 住家地址
about-addressbook-details-work-address-header = 商務地址
about-addressbook-details-other-info-header = 其他資訊
