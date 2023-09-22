# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard-selection-header = 匯入瀏覽器資料
migration-wizard-selection-list = 請選擇您要匯入的資料。
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
migration-wizard-selection-option-with-profile = { $sourceBrowser } — { $profileName }

# Each migrator is expected to include a display name string, and that display
# name string should have a key with "migration-wizard-migrator-display-name-"
# as a prefix followed by the unique identification key for the migrator.

migration-wizard-migrator-display-name-brave = Brave
migration-wizard-migrator-display-name-canary = Chrome Canary
migration-wizard-migrator-display-name-chrome = Chrome
migration-wizard-migrator-display-name-chrome-beta = Chrome Beta
migration-wizard-migrator-display-name-chrome-dev = Chrome Dev
migration-wizard-migrator-display-name-chromium = Chromium
migration-wizard-migrator-display-name-chromium-360se = 360 安全瀏覽器
migration-wizard-migrator-display-name-chromium-edge = Microsoft Edge
migration-wizard-migrator-display-name-chromium-edge-beta = Microsoft Edge Beta
migration-wizard-migrator-display-name-edge-legacy = Microsoft Edge 傳統版
migration-wizard-migrator-display-name-firefox = Waterfox
migration-wizard-migrator-display-name-file-password-csv = CSV 檔案中的密碼
migration-wizard-migrator-display-name-file-bookmarks = HTML 檔裡的書籤
migration-wizard-migrator-display-name-ie = Microsoft Internet Explorer
migration-wizard-migrator-display-name-opera = Opera
migration-wizard-migrator-display-name-opera-gx = Opera GX
migration-wizard-migrator-display-name-safari = Safari
migration-wizard-migrator-display-name-vivaldi = Vivaldi

## These strings will be displayed based on how many resources are selected to import

migration-all-available-data-label = 匯入所有可用資料
migration-no-selected-data-label = 未選擇要匯入的資料
migration-selected-data-label = 匯入選擇的資料

##

migration-select-all-option-label = 全選
migration-bookmarks-option-label = 書籤
# Favorites is used for Bookmarks when importing from Internet Explorer or
# Edge, as this is the terminology for bookmarks on those browsers.
migration-favorites-option-label = 我的最愛
migration-logins-and-passwords-option-label = 儲存的登入資訊與密碼
migration-history-option-label = 瀏覽紀錄
migration-extensions-option-label = 擴充套件
migration-form-autofill-option-label = 表單自動填寫資料
migration-payment-methods-option-label = 付款方式
migration-cookies-option-label = Cookie
migration-session-option-label = 視窗與分頁
migration-otherdata-option-label = 其他資料
migration-passwords-from-file-progress-header = 匯入密碼檔
migration-passwords-from-file-success-header = 已成功匯入密碼
migration-passwords-from-file = 正在檢查檔案中的密碼
migration-passwords-new = 新密碼
migration-passwords-updated = 已有的密碼
migration-passwords-from-file-no-valid-data = 此密碼檔不含任何有效密碼資料，請選擇其他檔案。
migration-passwords-from-file-picker-title = 匯入密碼檔
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
migration-passwords-from-file-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV 文件
       *[other] CSV 檔案
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
migration-passwords-from-file-tsv-filter-title =
    { PLATFORM() ->
        [macos] TSV 文件
       *[other] TSV 檔案
    }
# Shown in the migration wizard after importing passwords from a file
# has completed, if new passwords were added.
#
# Variables:
#  $newEntries (Number): the number of new successfully imported passwords
migration-wizard-progress-success-new-passwords = 已新增 { $newEntries } 筆
# Shown in the migration wizard after importing passwords from a file
# has completed, if existing passwords were updated.
#
# Variables:
#  $updatedEntries (Number): the number of updated passwords
migration-wizard-progress-success-updated-passwords = 已更新 { $updatedEntries } 筆
migration-bookmarks-from-file-picker-title = 匯入書籤檔案
migration-bookmarks-from-file-progress-header = 匯入書籤
migration-bookmarks-from-file = 書籤
migration-bookmarks-from-file-success-header = 已成功匯入書籤
migration-bookmarks-from-file-no-valid-data = 此書籤檔不含任何書籤資料，請選擇其他檔案。
# A description for the .html file format that may be shown as the file type
# filter by the operating system.
migration-bookmarks-from-file-html-filter-title =
    { PLATFORM() ->
        [macos] HTML 文件
       *[other] HTML 檔案
    }
# A description for the .json file format that may be shown as the file type
# filter by the operating system.
migration-bookmarks-from-file-json-filter-title = JSON 檔案
# Shown in the migration wizard after importing bookmarks from a file
# has completed.
#
# Variables:
#  $newEntries (Number): the number of imported bookmarks.
migration-wizard-progress-success-new-bookmarks = { $newEntries } 筆書籤
migration-import-button-label = 匯入
migration-choose-to-import-from-file-button-label = 從檔案匯入
migration-import-from-file-button-label = 選擇檔案
migration-cancel-button-label = 取消
migration-done-button-label = 完成
migration-continue-button-label = 繼續
migration-wizard-import-browser-no-browsers = { -brand-short-name } 找不到任何包含書籤、瀏覽紀錄或密碼的程式。
migration-wizard-import-browser-no-resources = 發生錯誤。{ -brand-short-name } 無法從該瀏覽器設定檔找到任何可匯入的資料。

## These strings will be used to create a dynamic list of items that can be
## imported. The list will be created using Intl.ListFormat(), so it will
## follow each locale's rules, and the first item will be capitalized by code.
## When applicable, the resources should be in their plural form.
## For example, a possible list could be "Bookmarks, passwords and autofill data".

migration-list-bookmark-label = 書籤
# “favorites” refers to bookmarks in Edge and Internet Explorer. Use the same terminology
# if the browser is available in your language.
migration-list-favorites-label = 我的最愛
migration-list-password-label = 密碼
migration-list-history-label = 瀏覽紀錄
migration-list-extensions-label = 擴充套件
migration-list-autofill-label = 自動填寫資料
migration-list-payment-methods-label = 付款方式

##

migration-wizard-progress-header = 正在匯入資料
# This header appears in the final page of the migration wizard only if
# all resources were imported successfully.
migration-wizard-progress-done-header = 已成功匯入資料
# This header appears in the final page of the migration wizard if only
# some of the resources were imported successfully. This is meant to be
# distinct from migration-wizard-progress-done-header, which is only shown
# if all resources were imported successfully.
migration-wizard-progress-done-with-warnings-header = 資料匯入完成
migration-wizard-progress-icon-in-progress =
    .aria-label = 匯入中…
migration-wizard-progress-icon-completed =
    .aria-label = 已完成
migration-safari-password-import-header = 從 Safari 匯入密碼
migration-safari-password-import-steps-header = 若要匯入 Safari 密碼:
migration-safari-password-import-step1 = 在 Safari 點擊「Safari」選單，然後點擊「偏好設定 > 密碼」
migration-safari-password-import-step2 = 選擇 <img data-l10n-name="safari-icon-3dots"/> 按鈕，然後選擇「匯出所有密碼」
migration-safari-password-import-step3 = 儲存密碼檔案
migration-safari-password-import-step4 = 使用下方的「選擇檔案」選擇您儲存的密碼檔案
migration-safari-password-import-skip-button = 略過
migration-safari-password-import-select-button = 選擇檔案
# Shown in the migration wizard after importing bookmarks from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported bookmarks
migration-wizard-progress-success-bookmarks = { $quantity } 筆書籤
# Shown in the migration wizard after importing bookmarks from either
# Internet Explorer or Edge.
#
# Use the same terminology if the browser is available in your language.
#
# Variables:
#  $quantity (Number): the number of successfully imported bookmarks
migration-wizard-progress-success-favorites = { $quantity } 筆最愛

## The import process identifies extensions installed in other supported
## browsers and installs the corresponding (matching) extensions compatible
## with Waterfox, if available.

# Shown in the migration wizard after importing all matched extensions
# from supported browsers.
#
# Variables:
#   $quantity (Number): the number of successfully imported extensions
migration-wizard-progress-success-extensions = { $quantity } 套擴充套件
# Shown in the migration wizard after importing a partial amount of
# matched extensions from supported browsers.
#
# Variables:
#   $matched (Number): the number of matched imported extensions
#   $quantity (Number): the number of total extensions found during import
migration-wizard-progress-partial-success-extensions = 共 { $quantity } 套擴充套件，僅找到 { $matched } 套
migration-wizard-progress-extensions-support-link = 了解 { -brand-product-name } 如何比對擴充套件
# Shown in the migration wizard if there are no matched extensions
# on import from supported browsers.
migration-wizard-progress-no-matched-extensions = 沒有符合的擴充套件資訊
migration-wizard-progress-extensions-addons-link = { -brand-short-name } 的瀏覽器擴充套件

##

# Shown in the migration wizard after importing passwords from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported passwords
migration-wizard-progress-success-passwords = { $quantity } 筆密碼
# Shown in the migration wizard after importing history from another
# browser has completed.
#
# Variables:
#  $maxAgeInDays (Number): the maximum number of days of history that might be imported.
migration-wizard-progress-success-history =
    { $maxAgeInDays ->
        [one] 昨天以來
       *[other] 過去 { $maxAgeInDays } 來
    }
migration-wizard-progress-success-formdata = 表單填寫紀錄
# Shown in the migration wizard after importing payment methods from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported payment methods
migration-wizard-progress-success-payment-methods = { $quantity } 筆付款方式
migration-wizard-safari-permissions-sub-header = 若要匯入 Safari 書籤與上網紀錄:
migration-wizard-safari-instructions-continue = 選擇「繼續」
migration-wizard-safari-instructions-folder = 從清單中選擇 Safari 資料夾，然後選擇「開啟」
