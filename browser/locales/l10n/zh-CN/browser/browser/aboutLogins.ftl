# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = 我的密码

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = 随身携带密码
login-app-promo-subtitle = 免费下载 { -lockwise-brand-name } 应用
login-app-promo-android =
    .alt = 从 Google Play 获取
login-app-promo-apple =
    .alt = 到 App Store 下载
login-filter =
    .placeholder = 搜索登录信息
create-login-button = 新建登录信息
fxaccounts-sign-in-text = 取得您其他设备上的密码
fxaccounts-sign-in-button = 登录{ -sync-brand-short-name }服务
fxaccounts-avatar-button =
    .title = 管理账户

## The ⋯ menu that is in the top corner of the page

menu =
    .title = 打开菜单
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = 从其他浏览器导入…
about-logins-menu-menuitem-import-from-a-file = 从文件导入…
about-logins-menu-menuitem-export-logins = 导出登录信息…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] 选项
       *[other] 偏好设置
    }
about-logins-menu-menuitem-help = 帮助
menu-menuitem-android-app = { -lockwise-brand-short-name }（Android 版）
menu-menuitem-iphone-app = { -lockwise-brand-short-name }（iPhone / iPad 版）

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

## Introduction screen

login-intro-heading = 在找您保存的登录信息？请设置“{ -sync-brand-short-name }”。
about-logins-login-intro-heading-logged-out = 在找您保存的登录信息？请设置{ -sync-brand-short-name }或导入。
about-logins-login-intro-heading-logged-in = 未找到同步的登录信息。
login-intro-description = 若您曾在其他设备上将登录信息保存到 { -brand-product-name }，请按以下步骤操作：
login-intro-instruction-fxa = 在您保存登录信息的设备，注册或登录 { -fxaccount-brand-name }
login-intro-instruction-fxa-settings = 确定您已在“{ -sync-brand-short-name }”设置中勾选了“登录信息”复选框
about-logins-intro-instruction-help = 若需帮助，请访问 <a data-l10n-name="help-link">{ -lockwise-brand-short-name } 用户支持</a>
about-logins-intro-import = 若登录信息保存在其他浏览器，您可以<a data-l10n-name="import-link">导入到 { -lockwise-brand-short-name }</a>
about-logins-intro-import2 = 若您的登录信息并未存储在 { -brand-product-name }，可以<a data-l10n-name="import-browser-link">从另一款浏览器</a>或<a data-l10n-name="import-file-link">文件</a>导入

## Login

login-item-new-login-title = 新建登录信息
login-item-edit-button = 编辑
about-logins-login-item-remove-button = 移除
login-item-origin-label = 网址
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

## The macOS strings are preceded by the operating system with "Firefox is trying to "
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

master-password-notification-message = 请输入您的主密码，以查看保存的登录信息
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

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] 想将使用 { -brand-product-name } 时填写的登录信息随身携带？打开您的 { -sync-brand-short-name } 选项，选中“登录信息”复选框。
       *[other] 想将使用 { -brand-product-name } 时填写的登录信息随身携带？打开您的 { -sync-brand-short-name } 首选项，选中“登录信息”复选框。
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] 前往{ -sync-brand-short-name }选项
           *[other] 前往{ -sync-brand-short-name }首选项
        }
    .accesskey = V
about-logins-enable-password-sync-dont-ask-again-button =
    .label = 不再询问
    .accesskey = D

## Dialogs

confirmation-dialog-cancel-button = 取消
confirmation-dialog-dismiss-button =
    .title = 取消
about-logins-confirm-remove-dialog-title = 删除此登录信息？
confirm-delete-dialog-message = 此操作不可撤销。
about-logins-confirm-remove-dialog-confirm-button = 移除
about-logins-confirm-export-dialog-title = 导出登录名和密码
about-logins-confirm-export-dialog-message = 您的密码将存为可读文本（如 BadP@ssw0rd），因此任何可以打开导出文件的人都可以进行查看。
about-logins-confirm-export-dialog-confirm-button = 导出…
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
