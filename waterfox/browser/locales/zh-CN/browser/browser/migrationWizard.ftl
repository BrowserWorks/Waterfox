# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard-selection-header = 导入浏览器数据
migration-wizard-selection-list = 选择要导入的数据。
# Shown in the new migration wizard's dropdown selector for choosing the browser
# to import from. This variant is shown when the selected browser doesn't support
# user profiles, and so we only show the browser name.
#
# Variables:
#  $sourceBrowser (String): the name of the browser to import from.
migration-wizard-selection-option-without-profile = { $sourceBrowser }
# Shown in the new migration wizard's dropdown selector for choosing the browser
# and user profile to import from. This variant is shown when the selected browser
# supports user profiles.
#
# Variables:
#  $sourceBrowser (String): the name of the browser to import from.
#  $profileName (String): the name of the user profile to import from.
migration-wizard-selection-option-with-profile = { $sourceBrowser } - { $profileName }

# Each migrator is expected to include a display name string, and that display
# name string should have a key with "migration-wizard-migrator-display-name-"
# as a prefix followed by the unique identification key for the migrator.

migration-wizard-migrator-display-name-brave = Brave
migration-wizard-migrator-display-name-canary = Chrome Canary
migration-wizard-migrator-display-name-chrome = Chrome
migration-wizard-migrator-display-name-chrome-beta = Chrome Beta
migration-wizard-migrator-display-name-chrome-dev = Chrome Dev
migration-wizard-migrator-display-name-chromium = Chromium
migration-wizard-migrator-display-name-chromium-360se = 360 安全浏览器
migration-wizard-migrator-display-name-chromium-edge = Microsoft Edge
migration-wizard-migrator-display-name-chromium-edge-beta = Microsoft Edge Beta
migration-wizard-migrator-display-name-edge-legacy = 旧版 Microsoft Edge
migration-wizard-migrator-display-name-firefox = Waterfox
migration-wizard-migrator-display-name-file-password-csv = CSV 文件中的密码
migration-wizard-migrator-display-name-file-bookmarks = 从 HTML 文件导入书签
migration-wizard-migrator-display-name-ie = Microsoft Internet Explorer（IE 浏览器）
migration-wizard-migrator-display-name-opera = Opera
migration-wizard-migrator-display-name-opera-gx = Opera GX
migration-wizard-migrator-display-name-safari = Safari 浏览器
migration-wizard-migrator-display-name-vivaldi = Vivaldi

## These strings will be displayed based on how many resources are selected to import

migration-all-available-data-label = 导入所有可用数据
migration-no-selected-data-label = 未选择要导入的数据
migration-selected-data-label = 导入所选数据

##

migration-select-all-option-label = 全选
migration-bookmarks-option-label = 书签
# Favorites is used for Bookmarks when importing from Internet Explorer or
# Edge, as this is the terminology for bookmarks on those browsers.
migration-favorites-option-label = 收藏夹
migration-logins-and-passwords-option-label = 保存的登录名和密码
migration-history-option-label = 浏览历史
migration-extensions-option-label = 扩展
migration-form-autofill-option-label = 自动填写表单数据
migration-payment-methods-option-label = 付款方式
migration-cookies-option-label = Cookie
migration-session-option-label = 窗口和标签页
migration-otherdata-option-label = 其他数据
migration-passwords-from-file-progress-header = 导入密码文件
migration-passwords-from-file-success-header = 已成功导入密码
migration-passwords-from-file = 正在检查文件中的密码
migration-passwords-new = 新密码
migration-passwords-updated = 现有密码
migration-passwords-from-file-no-valid-data = 此文件不含有效的密码数据，请选择其他文件。
migration-passwords-from-file-picker-title = 导入密码文件
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
migration-passwords-from-file-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV 文档
       *[other] CSV 文件
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
migration-passwords-from-file-tsv-filter-title =
    { PLATFORM() ->
        [macos] TSV 文档
       *[other] TSV 文件
    }
# Shown in the migration wizard after importing passwords from a file
# has completed, if new passwords were added.
#
# Variables:
#  $newEntries (Number): the number of new successfully imported passwords
migration-wizard-progress-success-new-passwords = 已添加 { $newEntries } 个
# Shown in the migration wizard after importing passwords from a file
# has completed, if existing passwords were updated.
#
# Variables:
#  $updatedEntries (Number): the number of updated passwords
migration-wizard-progress-success-updated-passwords = 已更新 { $updatedEntries } 个
migration-bookmarks-from-file-picker-title = 导入书签文件
migration-bookmarks-from-file-progress-header = 导入书签
migration-bookmarks-from-file = 书签
migration-bookmarks-from-file-success-header = 书签导入成功
migration-bookmarks-from-file-no-valid-data = 此文件不含书签数据，请选择其他文件。
# A description for the .html file format that may be shown as the file type
# filter by the operating system.
migration-bookmarks-from-file-html-filter-title =
    { PLATFORM() ->
        [macos] HTML 文稿
       *[other] HTML 文件
    }
# A description for the .json file format that may be shown as the file type
# filter by the operating system.
migration-bookmarks-from-file-json-filter-title = JSON 文件
# Shown in the migration wizard after importing bookmarks from a file
# has completed.
#
# Variables:
#  $newEntries (Number): the number of imported bookmarks.
migration-wizard-progress-success-new-bookmarks = { $newEntries } 个书签
migration-import-button-label = 导入
migration-choose-to-import-from-file-button-label = 从文件导入
migration-import-from-file-button-label = 选择文件
migration-cancel-button-label = 取消
migration-done-button-label = 完成
migration-continue-button-label = 继续
migration-wizard-import-browser-no-browsers = { -brand-short-name } 找不到存有书签、历史记录或密码数据的程序。
migration-wizard-import-browser-no-resources = 出错了。{ -brand-short-name } 在所选的浏览器配置文件中找不到数据。

## These strings will be used to create a dynamic list of items that can be
## imported. The list will be created using Intl.ListFormat(), so it will
## follow each locale's rules, and the first item will be capitalized by code.
## When applicable, the resources should be in their plural form.
## For example, a possible list could be "Bookmarks, passwords and autofill data".

migration-list-bookmark-label = 书签
# “favorites” refers to bookmarks in Edge and Internet Explorer. Use the same terminology
# if the browser is available in your language.
migration-list-favorites-label = 收藏夹
migration-list-password-label = 密码
migration-list-history-label = 历史记录
migration-list-extensions-label = 扩展
migration-list-autofill-label = 自动填写数据
migration-list-payment-methods-label = 付款方式

##

migration-wizard-progress-header = 正在导入数据
# This header appears in the final page of the migration wizard only if
# all resources were imported successfully.
migration-wizard-progress-done-header = 数据导入成功
# This header appears in the final page of the migration wizard if only
# some of the resources were imported successfully. This is meant to be
# distinct from migration-wizard-progress-done-header, which is only shown
# if all resources were imported successfully.
migration-wizard-progress-done-with-warnings-header = 数据导入完成
migration-wizard-progress-icon-in-progress =
    .aria-label = 正在导入…
migration-wizard-progress-icon-completed =
    .aria-label = 已完成
migration-safari-password-import-header = 从 Safari 浏览器导入密码
migration-safari-password-import-steps-header = 如需导入 Safari 浏览器密码：
migration-safari-password-import-step1 = 在 Safari 浏览器中，打开“Safari 浏览器”菜单，前往“偏好设置”>“密码”
migration-safari-password-import-step2 = 点按 <img data-l10n-name="safari-icon-3dots"/> 按钮，然后选取“导出所有密码”
migration-safari-password-import-step3 = 保存密码文件
migration-safari-password-import-step4 = 使用下方的“选择文件”来选取您保存的密码文件
migration-safari-password-import-skip-button = 跳过
migration-safari-password-import-select-button = 选择文件
# Shown in the migration wizard after importing bookmarks from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported bookmarks
migration-wizard-progress-success-bookmarks = { $quantity } 个书签
# Shown in the migration wizard after importing bookmarks from either
# Internet Explorer or Edge.
#
# Use the same terminology if the browser is available in your language.
#
# Variables:
#  $quantity (Number): the number of successfully imported bookmarks
migration-wizard-progress-success-favorites = { $quantity } 个收藏

## The import process identifies extensions installed in other supported
## browsers and installs the corresponding (matching) extensions compatible
## with Waterfox, if available.

# Shown in the migration wizard after importing all matched extensions
# from supported browsers.
#
# Variables:
#   $quantity (Number): the number of successfully imported extensions
migration-wizard-progress-success-extensions = { $quantity } 个扩展
# Shown in the migration wizard after importing a partial amount of
# matched extensions from supported browsers.
#
# Variables:
#   $matched (Number): the number of matched imported extensions
#   $quantity (Number): the number of total extensions found during import
migration-wizard-progress-partial-success-extensions = 检测到 { $quantity } 个扩展，成功匹配 { $matched } 个
migration-wizard-progress-extensions-support-link = 详细了解 { -brand-product-name } 匹配扩展的方式
# Shown in the migration wizard if there are no matched extensions
# on import from supported browsers.
migration-wizard-progress-no-matched-extensions = 没有匹配的扩展
migration-wizard-progress-extensions-addons-link = 浏览 { -brand-short-name } 的扩展

##

# Shown in the migration wizard after importing passwords from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported passwords
migration-wizard-progress-success-passwords = { $quantity } 个密码
# Shown in the migration wizard after importing history from another
# browser has completed.
#
# Variables:
#  $maxAgeInDays (Number): the maximum number of days of history that might be imported.
migration-wizard-progress-success-history =
    { $maxAgeInDays ->
        [one] 昨天以来
       *[other] 过去 { $maxAgeInDays } 天以来
    }
migration-wizard-progress-success-formdata = 表单历史记录
# Shown in the migration wizard after importing payment methods from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported payment methods
migration-wizard-progress-success-payment-methods = { $quantity } 个付款方式
migration-wizard-safari-permissions-sub-header = 如需导入 Safari 浏览器书签和历史记录：
migration-wizard-safari-instructions-continue = 选择“继续”
migration-wizard-safari-instructions-folder = 在列表中选择“Safari”文件夹，然后选取“打开”
