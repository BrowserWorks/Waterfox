# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

about-addressbook-title = 通讯录

## Toolbar

about-addressbook-toolbar-new-address-book =
    .label = 新建通讯录
about-addressbook-toolbar-add-carddav-address-book =
    .label = 添加 CardDAV 通讯录
about-addressbook-toolbar-add-ldap-address-book =
    .label = 添加 LDAP 通讯录
about-addressbook-toolbar-new-contact =
    .label = 新建联系人
about-addressbook-toolbar-new-list =
    .label = 新建列表
about-addressbook-toolbar-import =
    .label = 导入

## Books

all-address-books = 所有通讯录
about-addressbook-books-context-properties =
    .label = 属性
about-addressbook-books-context-synchronize =
    .label = 同步
about-addressbook-books-context-print =
    .label = 打印…
about-addressbook-books-context-export =
    .label = 导出…
about-addressbook-books-context-delete =
    .label = 删除
about-addressbook-books-context-remove =
    .label = 移除
about-addressbook-books-context-startup-default =
    .label = 默认启动目录
about-addressbook-confirm-delete-book-title = 删除通讯录
# Variables:
# $name (String) - Name of the address book to be deleted.
about-addressbook-confirm-delete-book = 您确定要删除 { $name } 及当中的所有联系人吗？
about-addressbook-confirm-remove-remote-book-title = 移除通讯录
# Variables:
# $name (String) - Name of the remote address book to be removed.
about-addressbook-confirm-remove-remote-book = 您确定要删除 { $name } 吗？

## Cards

# Variables:
# $name (String) - Name of the address book that will be searched.
about-addressbook-search =
    .placeholder = 搜索 { $name }
about-addressbook-search-all =
    .placeholder = 搜索所有通讯录
about-addressbook-sort-button =
    .title = 更改列表顺序
about-addressbook-name-format-display =
    .label = 显示名称
about-addressbook-name-format-firstlast =
    .label = 名前姓后
about-addressbook-name-format-lastfirst =
    .label = 姓前名后
about-addressbook-sort-name-ascending =
    .label = 按名称排序（A > Z）
about-addressbook-sort-name-descending =
    .label = 按名称排序（Z > A）
about-addressbook-sort-email-ascending =
    .label = 按电子邮件地址排序（A > Z）
about-addressbook-sort-email-descending =
    .label = 按电子邮件地址排序（Z > A）
about-addressbook-cards-context-write =
    .label = 写邮件
about-addressbook-confirm-delete-mixed-title = 删除联系人和列表
# Variables:
# $count (Number) - The number of contacts and lists to be deleted. Always greater than 1.
about-addressbook-confirm-delete-mixed = 您确定要删除这 { $count } 位联系人和列表？
# Variables:
# $count (Number) - The number of lists to be deleted.
about-addressbook-confirm-delete-lists-title =
    { $count ->
       *[other] 删除列表
    }
# Variables:
# $count (Number) - The number of lists to be deleted.
# $name (String) - The name of the list to be deleted, if $count is 1.
about-addressbook-confirm-delete-lists =
    { $count ->
        [one] 您确定要删除 { $name } 列表吗？
       *[other] 您确定要删除这 { $count } 个列表吗？
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
about-addressbook-confirm-remove-contacts-title =
    { $count ->
       *[other] 移除联系人
    }
# Variables:
# $count (Number) - The number of contacts to be removed.
# $name (String) - The name of the contact to be removed, if $count is 1.
# $list (String) - The name of the list that contacts will be removed from.
about-addressbook-confirm-remove-contacts =
    { $count ->
        [one] 您确定要从 { $list } 删除联系人 { $name } 吗？
       *[other] 您确定要从 { $list } 列表删除 { $count } 位联系人吗？
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
about-addressbook-confirm-delete-contacts-title =
    { $count ->
       *[other] 删除联系人
    }
# Variables:
# $count (Number) - The number of contacts to be deleted.
# $name (String) - The name of the contact to be deleted, if $count is 1.
about-addressbook-confirm-delete-contacts =
    { $count ->
        [one] 您确定要删除联系人 { $name } 吗？
       *[other] 您确定要删除下列 { $count } 位联系人吗？
    }

## Details

about-addressbook-begin-edit-contact-button = 编辑
about-addressbook-cancel-edit-contact-button = 取消
about-addressbook-save-edit-contact-button = 保存
about-addressbook-details-email-addresses-header = 电子邮件地址
about-addressbook-details-phone-numbers-header = 手机号码
about-addressbook-details-home-address-header = 家庭地址
about-addressbook-details-work-address-header = 工作地址
about-addressbook-details-other-info-header = 其他信息
about-addressbook-prompt-to-save-title = 要保存更改吗？
about-addressbook-prompt-to-save = 您要保存更改吗？
