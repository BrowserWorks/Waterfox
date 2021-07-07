# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = 關於設定檔
profiles-subtitle = 此頁面可幫助您管理設定檔。不同的設定檔會有自己的小世界，能夠分隔開不同的瀏覽紀錄、書籤、設定與附加元件。
profiles-create = 建立新設定檔
profiles-restart-title = 重新啟動
profiles-restart-in-safe-mode = 重新啟動但停用附加元件…
profiles-restart-normal = 正常重新啟動…
profiles-conflict = 有另一套 { -brand-product-name } 對設定檔做了異動。您必須重新啟動 { -brand-short-name } 才能再做變動。
profiles-flush-fail-title = 未儲存變更
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = 發生未預期的錯誤，無法儲存變更。
profiles-flush-restart-button = 重新啟動 { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = 設定檔: { $name }
profiles-is-default = 預設設定檔
profiles-rootdir = 根目錄

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = 本機目錄
profiles-current-profile = 這個設定檔正在使用中，無法刪除。
profiles-in-use-profile = 其他應用程式正在使用此設定檔，無法刪除。

profiles-rename = 重新命名
profiles-remove = 移除
profiles-set-as-default = 設為預設設定檔
profiles-launch-profile = 用新瀏覽器啟動此設定檔

profiles-cannot-set-as-default-title = 無法設為預設值
profiles-cannot-set-as-default-message = 無法更改 { -brand-short-name } 的預設設定檔。

profiles-yes = 是
profiles-no = 否

profiles-rename-profile-title = 變更設定檔名稱
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = 重新命名設定檔 { $name }

profiles-invalid-profile-name-title = 設定檔名稱無效
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = 設定檔名稱不能為「{ $name }」。

profiles-delete-profile-title = 刪除設定檔
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    刪除設定檔會移除設定檔列表中的項目，而且無法復原。
    您也可以同時刪除設定檔內含的資料檔，包括您的設定、憑證和其他個人資料等。這個選項會刪除資料夾「{ $dir }」而且無法復原。
    您想刪除設定檔內含的資料檔案嗎？
profiles-delete-files = 刪除檔案
profiles-dont-delete-files = 不要刪除檔案

profiles-delete-profile-failed-title = 錯誤
profiles-delete-profile-failed-message = 嘗試刪除此設定檔時發生錯誤。


profiles-opendir =
    { PLATFORM() ->
        [macos] 顯示於 Finder
        [windows] 開啟資料夾
       *[other] 開啟資料夾
    }
