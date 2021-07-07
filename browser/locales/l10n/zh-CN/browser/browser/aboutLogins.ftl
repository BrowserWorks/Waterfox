# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = 我的密码

# "Google Play" and "App Store" are both branding and should not be translated

login-filter =
    .placeholder = 搜索登录信息

create-login-button = 新建登录信息

fxaccounts-sign-in-text = 取得您其他设备上的密码
fxaccounts-sign-in-sync-button = 登录同步服务
fxaccounts-avatar-button =
    .title = 管理账户

## The ⋯ menu that is in the top corner of the page

menu =
    .title = 打开菜单
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = 从其他浏览器导入…
about-logins-menu-menuitem-import-from-a-file = 从文件导入…
about-logins-menu-menuitem-export-logins = 导出登录信息…
about-logins-menu-menuitem-remove-all-logins = 移除所有登录信息…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] 选项
       *[other] 偏好设置
    }
about-logins-menu-menuitem-help = 帮助

## Login List

login-list =
    .aria-label = 匹配搜索词的登录信息
login-list-count =
    { $count ->
       *[other] { $count } 条登录信息
    }
login-list-sort-label-text = 顺序：
login-list-name-option = 名称（A-Z）
login-list-name-reverse-option = 名称（Z-A）
login-list-username-option = 用户名（A-Z）
login-list-username-reverse-option = 用户名（Z-A）
about-logins-login-list-alerts-option = 警报
login-list-last-changed-option = 最后修改
login-list-last-used-option = 上次使用
login-list-intro-title = 未找到登录信息
login-list-intro-description = 当您保存密码到 { -brand-product-name } 后，它会出现在这里。
about-logins-login-list-empty-search-title = 未找到登录信息
about-logins-login-list-empty-search-description = 没有符合您搜索条件的结果。
login-list-item-title-new-login = 新建登录信息
login-list-item-subtitle-new-login = 输入您的登录凭据
login-list-item-subtitle-missing-username = （无用户名）
about-logins-list-item-breach-icon =
    .title = 发生数据外泄的网站
about-logins-list-item-vulnerable-password-icon =
    .title = 弱密码

about-logins-list-section-breach = 发生数据外泄的网站
about-logins-list-section-vulnerable = 弱密码
about-logins-list-section-nothing = 暂无警报
about-logins-list-section-today = 今天
about-logins-list-section-yesterday = 昨天
about-logins-list-section-week = 最近 7 天

## Introduction screen

about-logins-login-intro-heading-logged-out2 = 在寻找您保存的登录信息？请开启同步或进行导入。
about-logins-login-intro-heading-logged-in = 未找到同步的登录信息。
login-intro-description = 若您曾在其他设备上将登录信息保存到 { -brand-product-name }，请按以下步骤操作：
login-intro-instructions-fxa = 在您保存登录信息的设备，注册或登录 { -fxaccount-brand-name }
login-intro-instructions-fxa-settings = 前往“设置”>“同步”>“开启同步…”，勾选“登录名和密码”复选框。
login-intro-instructions-fxa-help = 若需帮助，请访问 <a data-l10n-name="help-link">{ -lockwise-brand-short-name } 用户支持</a>。
about-logins-intro-import = 若登录信息保存在其他浏览器，您可以<a data-l10n-name="import-link">导入到 { -lockwise-brand-short-name }</a>
about-logins-intro-import2 = 若您的登录信息并未存储在 { -brand-product-name }，可以<a data-l10n-name="import-browser-link">从另一浏览器</a>或<a data-l10n-name="import-file-link">文件</a>导入

## Login

login-item-new-login-title = 新建登录信息
login-item-edit-button = 编辑
about-logins-login-item-remove-button = 移除
login-item-origin-label = 网址
login-item-tooltip-message = 请确保其与您所登录的网站地址精确匹配。
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = 用户名
about-logins-login-item-username =
    .placeholder = （无用户名）
login-item-copy-username-button-text = 复制
login-item-copied-username-button-text = 已复制！
login-item-password-label = 密码
login-item-password-reveal-checkbox =
    .aria-label = 显示密码
login-item-copy-password-button-text = 复制
login-item-copied-password-button-text = 已复制！
login-item-save-changes-button = 保存更改
login-item-save-new-button = 保存
login-item-cancel-button = 取消
login-item-time-changed = 最后修改：{ DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = 创建时间：{ DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = 上次使用：{ DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Waterfox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = 请输入 Windows 登录凭据，以继续编辑登录信息。这有助于保护您的账户安全。
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = 编辑存放的登录信息

# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = 请输入 Windows 登录凭据，以查看密码。这有助于保护您的账户安全。
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = 显示存放的密码

# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = 请输入 Windows 登录凭据，以复制密码。这有助于保护您的账户安全。
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = 复制存放的密码

## Master Password notification

# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = 请输入 Windows 登录凭据，以继续导出登录信息。这有助于保护您的账户安全。
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = 导出存放的登录名和密码

## Primary Password notification

about-logins-primary-password-notification-message = 请输入主密码以查看保存的账号和密码
master-password-reload-button =
    .label = 登录
    .accesskey = L

## Password Sync notification

## Dialogs

confirmation-dialog-cancel-button = 取消
confirmation-dialog-dismiss-button =
    .title = 取消

about-logins-confirm-remove-dialog-title = 要移除此登录信息吗？
confirm-delete-dialog-message = 此操作不可撤销。
about-logins-confirm-remove-dialog-confirm-button = 移除

about-logins-confirm-remove-all-dialog-confirm-button-label =
    { $count ->
        [1] 移除
       *[other] 全部移除
    }

about-logins-confirm-remove-all-dialog-checkbox-label =
    { $count ->
        [1] 是的，移除此登录信息
       *[other] 是的，移除这些登录信息
    }

about-logins-confirm-remove-all-dialog-title =
    { $count ->
        [one] 要移除 { $count } 条登录信息吗？
       *[other] 要移除全部共 { $count } 条登录信息吗？
    }
about-logins-confirm-remove-all-dialog-message =
    { $count ->
       *[other] 将移除您存放在 { -brand-short-name } 的登录信息，以及在此显示的任何数据外泄警报。此操作不可撤销。
    }

about-logins-confirm-remove-all-sync-dialog-title =
    { $count ->
       *[other] 要从所有设备移除 { $count } 条登录信息吗？
    }
about-logins-confirm-remove-all-sync-dialog-message =
    { $count ->
       *[other] 将在您所有与 { -fxaccount-brand-name }同步的设备上，移除存放在 { -brand-short-name } 的登录信息，以及在此显示的任何数据外泄警报。此操作不可撤销。
    }

about-logins-confirm-export-dialog-title = 导出登录名和密码
about-logins-confirm-export-dialog-message = 您的密码将存为可读文本（如 BadP@ssw0rd），因此任何可以打开导出文件的人都可以进行查看。
about-logins-confirm-export-dialog-confirm-button = 导出…

about-logins-alert-import-title = 导入完成
about-logins-alert-import-message = 更多信息见：导入摘要报告

confirm-discard-changes-dialog-title = 要丢弃未保存的更改吗？
confirm-discard-changes-dialog-message = 将失去所有未保存的更改。
confirm-discard-changes-dialog-confirm-button = 丢弃

## Breach Alert notification

about-logins-breach-alert-title = 网站信息外泄
breach-alert-text = 自您上次更新这份登录信息后，该网站上的密码已遭泄露或窃取。立即更改您的密码以保障账户安全。
about-logins-breach-alert-date = 此外泄事件发生于：{ DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = 前往 { $hostname }
about-logins-breach-alert-learn-more-link = 详细了解

## Vulnerable Password notification

about-logins-vulnerable-alert-title = 弱密码
about-logins-vulnerable-alert-text2 = 此密码已用于另一个可能已遭外泄的账号。重复使用登录信息会使您的所有账号面临风险。请更改此密码。
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = 前往 { $hostname }
about-logins-vulnerable-alert-learn-more-link = 详细了解

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = 已存在具有该用户名的 { $loginTitle } 条目。<a data-l10n-name="duplicate-link">要转至现有条目吗？</a>

# This is a generic error message.
about-logins-error-message-default = 尝试保存该密码时发生错误。

## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = 导出登录信息文件
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = 登录信息.csv
about-logins-export-file-picker-export-button = 导出
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV 文档
       *[other] CSV 文件
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = 导入登录信息文件
about-logins-import-file-picker-import-button = 导入
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV 文档
       *[other] CSV 文件
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
about-logins-import-file-picker-tsv-filter-title =
    { PLATFORM() ->
        [macos] TSV 文件
       *[other] TSV 文件
    }

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-dialog-title = 导入完成
about-logins-import-dialog-items-added =
    { $count ->
       *[other] <span>新增的登录信息：</span> <span data-l10n-name="count">{ $count }</span>
    }

about-logins-import-dialog-items-modified =
    { $count ->
       *[other] <span>更新的现有登录信息：</span> <span data-l10n-name="count">{ $count }</span>
    }

about-logins-import-dialog-items-no-change =
    { $count ->
       *[other] <span>重复的登录信息：</span> <span data-l10n-name="count">{ $count }</span><span data-l10n-name="meta">（未导入）</span>
    }
about-logins-import-dialog-items-error =
    { $count ->
       *[other] <span>错误：</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">（未导入）</span>
    }
about-logins-import-dialog-done = 完成

about-logins-import-dialog-error-title = 导入出错
about-logins-import-dialog-error-conflicting-values-title = 一登录信息中出现多个冲突值
about-logins-import-dialog-error-conflicting-values-description = 例如：一登录信息中出现多个用户名、密码、网址等等。
about-logins-import-dialog-error-file-format-title = 文件格式问题
about-logins-import-dialog-error-file-format-description = 列标题不正确或缺失。请确保文件中包含正确的用户名、密码和网址列。
about-logins-import-dialog-error-file-permission-title = 无法读取文件
about-logins-import-dialog-error-file-permission-description = { -brand-short-name } 无权读取文件。请尝试更改文件权限。
about-logins-import-dialog-error-unable-to-read-title = 无法解析文件
about-logins-import-dialog-error-unable-to-read-description = 请确保已选择 CSV 或 TSV 文件。
about-logins-import-dialog-error-no-logins-imported = 未导入任何登录信息
about-logins-import-dialog-error-learn-more = 详细了解
about-logins-import-dialog-error-try-import-again = 再次尝试导入…
about-logins-import-dialog-error-cancel = 取消

about-logins-import-report-title = 导入摘要
about-logins-import-report-description = 导入到 { -brand-short-name } 的登录名和密码。

#
# Variables:
#  $number (number) - The number of the row
about-logins-import-report-row-index = 第 { $number } 行
about-logins-import-report-row-description-no-change = 重复：与现有登录信息完全一致
about-logins-import-report-row-description-modified = 更新的现有登录信息
about-logins-import-report-row-description-added = 新增的登录信息
about-logins-import-report-row-description-error = 错误：缺少字段

##
## Variables:
##  $field (String) - The name of the field from the CSV file for example url, username or password

about-logins-import-report-row-description-error-multiple-values = 错误：{ $field } 对应多个值
about-logins-import-report-row-description-error-missing-field = 错误：缺少“{ $field }”

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-report-added =
    { $count ->
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">新增的登录信息</div>
    }
about-logins-import-report-modified =
    { $count ->
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">更新的现有登录信息</div>
    }
about-logins-import-report-no-change =
    { $count ->
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">重复的登录信息</div> <div data-l10n-name="not-imported">（未导入）</div>
    }
about-logins-import-report-error =
    { $count ->
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">错误</div> <div data-l10n-name="not-imported">（未导入）</div>
    }

## Logins import report page

about-logins-import-report-page-title = 导入摘要报告
