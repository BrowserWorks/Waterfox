# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Window controls

messenger-window-minimize-button =
    .tooltiptext = 最小化
messenger-window-maximize-button =
    .tooltiptext = 最大化
messenger-window-restore-down-button =
    .tooltiptext = 還原大小
messenger-window-close-button =
    .tooltiptext = 關閉
# Variables:
# $count (Number) - Number of unread messages.
unread-messages-os-tooltip =
    { $count ->
       *[other] { $count } 封未讀訊息
    }
about-rights-notification-text = { -brand-short-name } 是一套自由且開放原始碼的軟體，由來自世界各地數千位成員組成的社群所打造。

## Content tabs

content-tab-page-loading-icon =
    .alt = 頁面載入中
content-tab-security-high-icon =
    .alt = 連線是安全的
content-tab-security-broken-icon =
    .alt = 連線不安全

## Toolbar

addons-and-themes-toolbarbutton =
    .label = 附加元件與佈景主題
    .tooltiptext = 管理您的附加元件
quick-filter-toolbarbutton =
    .label = 快速篩選
    .tooltiptext = 篩選訊息
redirect-msg-button =
    .label = 重導
    .tooltiptext = 將選擇的訊息重新導向

## Folder Pane

folder-pane-toolbar =
    .toolbarname = 資料夾窗格工具列
    .accesskey = F
folder-pane-toolbar-options-button =
    .tooltiptext = 資料夾窗格選項
folder-pane-header-label = 資料夾

## Folder Toolbar Header Popup

folder-toolbar-hide-toolbar-toolbarbutton =
    .label = 隱藏工具列
    .accesskey = H
show-all-folders-label =
    .label = 所有資料夾
    .accesskey = A
show-unread-folders-label =
    .label = 未讀資料夾
    .accesskey = n
show-favorite-folders-label =
    .label = 最愛資料夾
    .accesskey = F
show-smart-folders-label =
    .label = 整合資料夾
    .accesskey = U
show-recent-folders-label =
    .label = 最近開啟資料夾
    .accesskey = R
folder-toolbar-toggle-folder-compact-view =
    .label = 精簡檢視
    .accesskey = C

## Menu

redirect-msg-menuitem =
    .label = 重導
    .accesskey = D
menu-file-save-as-file =
    .label = 檔案…
    .accesskey = F

## AppMenu

appmenu-save-as-file =
    .label = 檔案…
appmenu-settings =
    .label = 設定
appmenu-addons-and-themes =
    .label = 附加元件與佈景主題
appmenu-help-enter-troubleshoot-mode =
    .label = 疑難排解模式…
appmenu-help-exit-troubleshoot-mode =
    .label = 關閉疑難排解模式
appmenu-help-more-troubleshooting-info =
    .label = 更多疑難排解資訊
appmenu-redirect-msg =
    .label = 重導

## Context menu

context-menu-redirect-msg =
    .label = 重導
mail-context-delete-messages =
    .label =
        { $count ->
            [one] 刪除訊息
           *[other] 刪除選擇的訊息
        }
context-menu-decrypt-to-folder =
    .label = 將解密格式複製到
    .accesskey = y

## Message header pane

other-action-redirect-msg =
    .label = 重導
message-header-msg-flagged =
    .title = 已標星號
    .aria-label = 已標星號
message-header-msg-not-flagged =
    .title = 未加上星號的郵件
# Variables:
# $address (String) - The email address of the recipient this picture belongs to.
message-header-recipient-avatar =
    .alt = { $address } 的個人資料照片。

## Message header cutomize panel

message-header-customize-panel-title = 訊息標題設定
message-header-customize-button-style =
    .value = 按鈕樣式
    .accesskey = B
message-header-button-style-default =
    .label = 圖示與文字
message-header-button-style-text =
    .label = 文字
message-header-button-style-icons =
    .label = 圖示
message-header-show-sender-full-address =
    .label = 總是顯示寄件者的完整信箱
    .accesskey = f
message-header-show-sender-full-address-description = 將在顯示名稱下方顯示電子郵件信箱。
message-header-show-recipient-avatar =
    .label = 顯示寄件者的個人資料照片
    .accesskey = p
message-header-hide-label-column =
    .label = 隱藏標籤欄
    .accesskey = l
message-header-large-subject =
    .label = 放大主旨
    .accesskey = s

## Action Button Context Menu

toolbar-context-menu-manage-extension =
    .label = 管理擴充套件
    .accesskey = E
toolbar-context-menu-remove-extension =
    .label = 移除擴充套件
    .accesskey = v

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = 要移除 { $name } 嗎？
addon-removal-confirmation-button = 移除
addon-removal-confirmation-message = 要從 { -brand-short-name } 移除 { $name }，以及其設定與儲存的資料嗎？
caret-browsing-prompt-title = 鍵盤瀏覽
caret-browsing-prompt-text = 按下 F7 鍵可切換是否開啟「鍵盤瀏覽」功能。此功能可在某些內容中顯示游標，讓您只用鍵盤就選取文字。您確定要開啟「鍵盤瀏覽」嗎？
caret-browsing-prompt-check-text = 不要再問我。
repair-text-encoding-button =
    .label = 修復文字編碼
    .tooltiptext = 根據訊息內容猜測正確的文字編碼

## no-reply handling

no-reply-title = 不支援回覆
no-reply-message = 信件的回覆地址（{ $email }）看起來不像是有人會收信的地址。發送到此信箱的郵件，很有可能不會被人閱讀。
no-reply-reply-anyway-button = 還是要回覆

## error messages

decrypt-and-copy-failures = 無法解密全部共 { $total } 封訊息當中的 { $failures } 封訊息，並未複製。

## Spaces toolbar

spaces-toolbar-element =
    .toolbarname = 按鈕空間
    .aria-label = 按鈕空間
    .aria-description = 用來切換各種空間的垂直工具列。可使用方向鍵來切換不同按鈕。
spaces-toolbar-button-mail2 =
    .title = 郵件
spaces-toolbar-button-address-book2 =
    .title = 通訊錄
spaces-toolbar-button-calendar2 =
    .title = 行事曆
spaces-toolbar-button-tasks2 =
    .title = 工作
spaces-toolbar-button-chat2 =
    .title = 聊天
spaces-toolbar-button-overflow =
    .title = 更多按鈕…
spaces-toolbar-button-settings2 =
    .title = 設定
spaces-toolbar-button-hide =
    .title = 隱藏按鈕空間
spaces-toolbar-button-show =
    .title = 顯示按鈕空間
spaces-context-new-tab-item =
    .label = 用新分頁開啟
spaces-context-new-window-item =
    .label = 用新視窗開啟
# Variables:
# $tabName (String) - The name of the tab this item will switch to.
spaces-context-switch-tab-item =
    .label = 切換到 { $tabName }
settings-context-open-settings-item2 =
    .label = 設定
settings-context-open-account-settings-item2 =
    .label = 帳號設定
settings-context-open-addons-item2 =
    .label = 附加元件與佈景主題

## Spaces toolbar pinned tab menupopup

spaces-toolbar-pinned-tab-button =
    .tooltiptext = 開啟按鈕空間選單
spaces-pinned-button-menuitem-mail =
    .label = { spaces-toolbar-button-mail.title }
spaces-pinned-button-menuitem-address-book =
    .label = { spaces-toolbar-button-address-book.title }
spaces-pinned-button-menuitem-calendar =
    .label = { spaces-toolbar-button-calendar.title }
spaces-pinned-button-menuitem-tasks =
    .label = { spaces-toolbar-button-tasks.title }
spaces-pinned-button-menuitem-chat =
    .label = { spaces-toolbar-button-chat.title }
spaces-pinned-button-menuitem-settings =
    .label = { spaces-toolbar-button-settings2.title }
spaces-pinned-button-menuitem-mail2 =
    .label = { spaces-toolbar-button-mail2.title }
spaces-pinned-button-menuitem-address-book2 =
    .label = { spaces-toolbar-button-address-book2.title }
spaces-pinned-button-menuitem-calendar2 =
    .label = { spaces-toolbar-button-calendar2.title }
spaces-pinned-button-menuitem-tasks2 =
    .label = { spaces-toolbar-button-tasks2.title }
spaces-pinned-button-menuitem-chat2 =
    .label = { spaces-toolbar-button-chat2.title }
spaces-pinned-button-menuitem-settings2 =
    .label = { spaces-toolbar-button-settings2.title }
spaces-pinned-button-menuitem-show =
    .label = { spaces-toolbar-button-show.title }
# Variables:
# $count (Number) - Number of unread messages.
chat-button-unread-messages = { $count }
    .title =
        { $count ->
           *[other] { $count } 封未讀訊息
        }

## Spaces toolbar customize panel

menuitem-customize-label =
    .label = 自訂…
spaces-customize-panel-title = 按鈕空間設定
spaces-customize-background-color = 背景色
spaces-customize-icon-color = 按鈕色
# The background color used on the buttons of the spaces toolbar when they are
# `current`, meaning the related space/tab is active and visible.
spaces-customize-accent-background-color = 已選擇按鈕的背景色
# The icon color used on the buttons of the spaces toolbar when they are
# `current`, meaning the related space/tab is active and visible.
spaces-customize-accent-text-color = 已選擇按鈕的顏色
spaces-customize-button-restore = 回復為預設值
    .accesskey = R
customize-panel-button-save = 完成
    .accesskey = D
