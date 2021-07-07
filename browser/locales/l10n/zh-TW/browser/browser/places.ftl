# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.

places-open =
    .label = 開啟
    .accesskey = O
places-open-in-tab =
    .label = 用新分頁開啟
    .accesskey = w
places-open-all-bookmarks =
    .label = 開啟所有書籤
    .accesskey = O
places-open-all-in-tabs =
    .label = 全部用分頁開啟
    .accesskey = O
places-open-in-window =
    .label = 用新視窗開啟
    .accesskey = N
places-open-in-private-window =
    .label = 用新隱私視窗開啟
    .accesskey = P
places-add-bookmark =
    .label = 新增書籤…
    .accesskey = B
places-add-folder-contextmenu =
    .label = 新增資料夾…
    .accesskey = F
places-add-folder =
    .label = 新增資料夾…
    .accesskey = o
places-add-separator =
    .label = 新增分隔線
    .accesskey = S
places-view =
    .label = 檢視
    .accesskey = w
places-by-date =
    .label = 依日期
    .accesskey = D
places-by-site =
    .label = 依網站
    .accesskey = S
places-by-most-visited =
    .label = 依瀏覽次數
    .accesskey = V
places-by-last-visited =
    .label = 依瀏覽順序
    .accesskey = L
places-by-day-and-site =
    .label = 依日期及網站
    .accesskey = t
places-history-search =
    .placeholder = 搜尋紀錄
places-history =
    .aria-label = 歷史
places-bookmarks-search =
    .placeholder = 搜尋書籤
places-delete-domain-data =
    .label = 刪除與此網站有關的記錄
    .accesskey = F
places-sortby-name =
    .label = 依名稱排序
    .accesskey = r
# places-edit-bookmark and places-edit-generic will show one or the other and can have the same access key.
places-edit-bookmark =
    .label = 編輯書籤…
    .accesskey = i
places-edit-generic =
    .label = 編輯…
    .accesskey = i
places-edit-folder =
    .label = 重新命名資料夾…
    .accesskey = e
places-remove-folder =
    .label =
        { $count ->
            [1] 移除資料夾
           *[other] 移除資料夾
        }
    .accesskey = m
places-edit-folder2 =
    .label = 編輯資料夾…
    .accesskey = i
places-delete-folder =
    .label =
        { $count ->
            [1] 刪除資料夾
           *[other] 刪除資料夾
        }
    .accesskey = D
# Managed bookmarks are created by an administrator and cannot be changed by the user.
managed-bookmarks =
    .label = 受管理的書籤
# This label is used when a managed bookmarks folder doesn't have a name.
managed-bookmarks-subfolder =
    .label = 子資料夾
# This label is used for the "Other Bookmarks" folder that appears in the bookmarks toolbar.
other-bookmarks-folder =
    .label = 其他書籤
# Variables:
# $count (number) - The number of elements being selected for removal.
places-remove-bookmark =
    .label =
        { $count ->
            [1] 移除書籤
           *[other] 移除 { $count } 筆書籤
        }
    .accesskey = e
places-show-in-folder =
    .label = 於資料夾顯示
    .accesskey = F
# Variables:
# $count (number) - The number of elements being selected for removal.
places-delete-bookmark =
    .label =
        { $count ->
            [1] 刪除書籤
           *[other] 刪除書籤
        }
    .accesskey = D
places-manage-bookmarks =
    .label = 管理書籤
    .accesskey = M
places-forget-about-this-site-confirmation-title = 刪除與此網站有關的記錄
# Variables:
# $hostOrBaseDomain (string) - The base domain (or host in case there is no base domain) for which data is being removed
places-forget-about-this-site-confirmation-message = 此動作將清除與 { $hostOrBaseDomain } 有關的所有資料，包含瀏覽紀錄、密碼、Cookie、快取資料與內容偏好設定。您確定要繼續嗎？
places-forget-about-this-site-forget = 忘記
places-library =
    .title = 收藏庫
    .style = width:700px; height:500px;
places-organize-button =
    .label = 管理
    .tooltiptext = 管理您的書籤
    .accesskey = O
places-organize-button-mac =
    .label = 管理
    .tooltiptext = 管理您的書籤
places-file-close =
    .label = 關閉
    .accesskey = C
places-cmd-close =
    .key = w
places-view-button =
    .label = 檢視
    .tooltiptext = 變更檢視方式
    .accesskey = V
places-view-button-mac =
    .label = 檢視
    .tooltiptext = 變更檢視方式
places-view-menu-columns =
    .label = 顯示欄位
    .accesskey = C
places-view-menu-sort =
    .label = 排序
    .accesskey = S
places-view-sort-unsorted =
    .label = 不排序
    .accesskey = U
places-view-sort-ascending =
    .label = 遞增排序 (A > Z)
    .accesskey = A
places-view-sort-descending =
    .label = 遞減排序 (Z > A)
    .accesskey = Z
places-maintenance-button =
    .label = 匯入及備份
    .tooltiptext = 匯入與備份您的書籤
    .accesskey = I
places-maintenance-button-mac =
    .label = 匯入及備份
    .tooltiptext = 匯入與備份您的書籤
places-cmd-backup =
    .label = 備份…
    .accesskey = B
places-cmd-restore =
    .label = 回復
    .accesskey = R
places-cmd-restore-from-file =
    .label = 選擇檔案…
    .accesskey = C
places-import-bookmarks-from-html =
    .label = 自 HTML 匯入書籤…
    .accesskey = I
places-export-bookmarks-to-html =
    .label = 匯出書籤成 HTML…
    .accesskey = E
places-import-other-browser =
    .label = 自其他瀏覽器匯入資料…
    .accesskey = a
places-view-sort-col-name =
    .label = 名稱
places-view-sort-col-tags =
    .label = 標籤
places-view-sort-col-url =
    .label = 網址
places-view-sort-col-most-recent-visit =
    .label = 最近瀏覽
places-view-sort-col-visit-count =
    .label = 瀏覽次數
places-view-sort-col-date-added =
    .label = 加入日期
places-view-sort-col-last-modified =
    .label = 上次修改
places-cmd-find-key =
    .key = f
places-back-button =
    .tooltiptext = 回上一頁
places-forward-button =
    .tooltiptext = 到下一頁
places-details-pane-select-an-item-description = 請選擇一個項目以檢視或編輯其屬性
