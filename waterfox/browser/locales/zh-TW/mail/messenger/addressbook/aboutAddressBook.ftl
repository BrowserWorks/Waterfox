# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

about-addressbook-title = 通訊錄

## Toolbar

about-addressbook-toolbar-new-address-book =
    .label = 新增通訊錄
about-addressbook-toolbar-add-carddav-address-book =
    .label = 新增 CardDAV 通訊錄
about-addressbook-toolbar-add-ldap-address-book =
    .label = 新增 LDAP 通訊錄
about-addressbook-toolbar-new-contact =
    .label = 新增連絡人
about-addressbook-toolbar-new-list =
    .label = 新增群組名單
about-addressbook-toolbar-import =
    .label = 匯入

## Books

all-address-books = 所有通訊錄
about-addressbook-books-context-properties =
    .label = 屬性
about-addressbook-books-context-synchronize =
    .label = 同步
about-addressbook-books-context-edit =
    .label = 編輯
about-addressbook-books-context-print =
    .label = 列印…
about-addressbook-books-context-export =
    .label = 匯出…
about-addressbook-books-context-delete =
    .label = 刪除
about-addressbook-books-context-remove =
    .label = 移除
about-addressbook-books-context-startup-default =
    .label = 預設啟動目錄
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
about-addressbook-sort-button2 =
    .title = 清單顯示選項
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
about-addressbook-horizontal-layout =
    .label = 切換為水平版面配置
about-addressbook-vertical-layout =
    .label = 切換為垂直版面配置

## Card column headers
## Each string is listed here twice, and the values should match.

about-addressbook-column-header-generatedname = 姓名
about-addressbook-column-label-generatedname =
    .label = { about-addressbook-column-header-generatedname }
about-addressbook-column-header-emailaddresses = 電子郵件地址
about-addressbook-column-label-emailaddresses =
    .label = { about-addressbook-column-header-emailaddresses }
about-addressbook-column-header-phonenumbers = 電話號碼
about-addressbook-column-label-phonenumbers =
    .label = { about-addressbook-column-header-phonenumbers }
about-addressbook-column-header-addresses = 地址
about-addressbook-column-label-addresses =
    .label = { about-addressbook-column-header-addresses }
about-addressbook-column-header-title = 頭銜
about-addressbook-column-label-title =
    .label = { about-addressbook-column-header-title }
about-addressbook-column-header-department = 部門
about-addressbook-column-label-department =
    .label = { about-addressbook-column-header-department }
about-addressbook-column-header-organization = 公司
about-addressbook-column-label-organization =
    .label = { about-addressbook-column-header-organization }
about-addressbook-column-header-addrbook = 通訊錄
about-addressbook-column-label-addrbook =
    .label = { about-addressbook-column-header-addrbook }
about-addressbook-cards-context-write =
    .label = 寫信
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

## Card list placeholder
## Shown when there are no cards in the list

about-addressbook-placeholder-empty-book = 無聯絡人
about-addressbook-placeholder-new-contact = 新增聯絡人
about-addressbook-placeholder-search-only = 進行搜尋後才會顯示此通訊錄的聯絡人
about-addressbook-placeholder-searching = 搜尋中…
about-addressbook-placeholder-no-search-results = 找不到聯絡人

## Details

about-addressbook-prefer-display-name = 在郵件檔頭上方顯示姓名
about-addressbook-write-action-button = 寫信
about-addressbook-event-action-button = 事件
about-addressbook-search-action-button = 搜尋
about-addressbook-begin-edit-contact-button = 編輯
about-addressbook-delete-edit-contact-button = 刪除
about-addressbook-cancel-edit-contact-button = 取消
about-addressbook-save-edit-contact-button = 儲存
about-addressbook-add-contact-to = 新增到:
about-addressbook-details-email-addresses-header = 電子郵件地址
about-addressbook-details-phone-numbers-header = 電話號碼
about-addressbook-details-addresses-header = 通訊錄
about-addressbook-details-notes-header = 附註
about-addressbook-details-other-info-header = 其他資訊
about-addressbook-entry-type-work = 商務
about-addressbook-entry-type-home = 住家
about-addressbook-entry-type-fax = 傳真
about-addressbook-entry-type-cell = 手機
about-addressbook-entry-type-pager = 呼叫器
about-addressbook-entry-name-birthday = 生日
about-addressbook-entry-name-anniversary = 週年紀念日
about-addressbook-entry-name-title = 頭銜
about-addressbook-entry-name-role = 角色
about-addressbook-entry-name-organization = 公司
about-addressbook-entry-name-website = 網站
about-addressbook-entry-name-time-zone = 時區
about-addressbook-unsaved-changes-prompt-title = 未儲存修改
about-addressbook-unsaved-changes-prompt = 您想要在離開編輯畫面前儲存變更嗎？

# Photo dialog

about-addressbook-photo-drop-target = 將照片放到或貼到此處，或點擊此處選擇檔案。
about-addressbook-photo-drop-loading = 正在載入照片…
about-addressbook-photo-drop-error = 照片載入失敗。
about-addressbook-photo-filepicker-title = 選擇圖檔
about-addressbook-photo-discard = 捨棄現有照片
about-addressbook-photo-cancel = 取消
about-addressbook-photo-save = 儲存
