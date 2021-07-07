# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] 長按以顯示歷史記錄
           *[other] 按滑鼠右鍵或長按以顯示歷史記錄
        }

## Back

# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Back command.
main-context-menu-back-2 =
    .tooltiptext = 回到上一頁（{ $shortcut }）
    .aria-label = 返回
    .accesskey = B

# This menuitem is only visible on macOS
main-context-menu-back-mac =
    .label = 返回
    .accesskey = B

navbar-tooltip-back-2 =
    .value = { main-context-menu-back-2.tooltiptext }

toolbar-button-back-2 =
    .label = { main-context-menu-back-2.aria-label }

## Forward

# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Forward command.
main-context-menu-forward-2 =
    .tooltiptext = 前進下一頁（{ $shortcut }）
    .aria-label = 前進
    .accesskey = F

# This menuitem is only visible on macOS
main-context-menu-forward-mac =
    .label = 前進
    .accesskey = F

navbar-tooltip-forward-2 =
    .value = { main-context-menu-forward-2.tooltiptext }

toolbar-button-forward-2 =
    .label = { main-context-menu-forward-2.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = 重新載入
    .accesskey = R

# This menuitem is only visible on macOS
main-context-menu-reload-mac =
    .label = 重新載入
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = 停止
    .accesskey = S

# This menuitem is only visible on macOS
main-context-menu-stop-mac =
    .label = 停止
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Waterfox Account Button

toolbar-button-fxaccount =
    .label = { -fxaccount-brand-name }
    .tooltiptext = { -fxaccount-brand-name }

## Save Page

main-context-menu-page-save =
    .label = 另存新檔…
    .accesskey = P

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = 將本頁加入書籤
    .accesskey = m
    .tooltiptext = 將本頁加入書籤

# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-edit-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-add-mac =
    .label = 將頁面加入書籤
    .accesskey = m

# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-add-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-edit-mac =
    .label = 編輯書籤
    .accesskey = m

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = 將本頁加入書籤
    .accesskey = m
    .tooltiptext = 將本頁加入書籤 ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = 編輯此書籤
    .accesskey = m
    .tooltiptext = 編輯此書籤

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = 編輯此書籤
    .accesskey = m
    .tooltiptext = 編輯此書籤 ({ $shortcut })

main-context-menu-open-link =
    .label = 開啟鏈結
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = 用新分頁開啟鏈結
    .accesskey = T

main-context-menu-open-link-container-tab =
    .label = 用新容器分頁開啟鏈結
    .accesskey = z

main-context-menu-open-link-new-window =
    .label = 用新視窗開啟鏈結
    .accesskey = w

main-context-menu-open-link-new-private-window =
    .label = 用新隱私視窗開啟鏈結
    .accesskey = P

main-context-menu-bookmark-link =
    .label = 將鏈結加入書籤
    .accesskey = B

main-context-menu-save-link =
    .label = 鏈結另存新檔…
    .accesskey = k

main-context-menu-save-link-to-pocket =
    .label = 將鏈結儲存至 { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.


## The access keys for "Copy Link" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = 複製電子郵件地址
    .accesskey = E

main-context-menu-copy-link-simple =
    .label = 複製鏈結
    .accesskey = L

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = 播放
    .accesskey = P

main-context-menu-media-pause =
    .label = 暫停
    .accesskey = P

##

main-context-menu-media-mute =
    .label = 靜音
    .accesskey = M

main-context-menu-media-unmute =
    .label = 取消靜音
    .accesskey = m

main-context-menu-media-play-speed-2 =
    .label = 速度
    .accesskey = d

main-context-menu-media-play-speed-slow-2 =
    .label = 0.5×

main-context-menu-media-play-speed-normal-2 =
    .label = 1.0×

main-context-menu-media-play-speed-fast-2 =
    .label = 1.25×

main-context-menu-media-play-speed-faster-2 =
    .label = 1.5×

main-context-menu-media-play-speed-fastest-2 =
    .label = 2×

main-context-menu-media-loop =
    .label = 循環
    .accesskey = L

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = 顯示控制按鈕
    .accesskey = C

main-context-menu-media-hide-controls =
    .label = 隱藏控制按鈕
    .accesskey = C

##

main-context-menu-media-video-fullscreen =
    .label = 全螢幕
    .accesskey = F

main-context-menu-media-video-leave-fullscreen =
    .label = 離開全螢幕模式
    .accesskey = u

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-watch-pip =
    .label = 使用子畫面觀賞
    .accesskey = u

main-context-menu-image-reload =
    .label = 重新載入圖片
    .accesskey = R

main-context-menu-image-view-new-tab =
    .label = 用新分頁開啟圖片
    .accesskey = I

main-context-menu-video-view-new-tab =
    .label = 用新分頁開啟影片
    .accesskey = i

main-context-menu-image-copy =
    .label = 複製圖片
    .accesskey = y

main-context-menu-image-copy-link =
    .label = 複製圖片鏈結
    .accesskey = o

main-context-menu-video-copy-link =
    .label = 複製影片鏈結
    .accesskey = o

main-context-menu-audio-copy-link =
    .label = 複製音訊鏈結
    .accesskey = o

main-context-menu-image-save-as =
    .label = 圖片另存新檔…
    .accesskey = v

main-context-menu-image-email =
    .label = 郵寄圖片…
    .accesskey = g

main-context-menu-image-set-image-as-background =
    .label = 將圖片設為桌布…
    .accesskey = S

main-context-menu-image-info =
    .label = 檢視圖片資訊
    .accesskey = f

main-context-menu-image-desc =
    .label = 檢視說明
    .accesskey = D

main-context-menu-video-save-as =
    .label = 另存視訊檔案…
    .accesskey = v

main-context-menu-audio-save-as =
    .label = 另存音訊檔案…
    .accesskey = v

main-context-menu-video-take-snapshot =
    .label = 拍攝快照…
    .accesskey = S

main-context-menu-video-email =
    .label = 郵寄視訊…
    .accesskey = a

main-context-menu-audio-email =
    .label = 郵寄音訊…
    .accesskey = a

main-context-menu-plugin-play =
    .label = 啟用此外掛程式
    .accesskey = c

main-context-menu-plugin-hide =
    .label = 隱藏此外掛程式
    .accesskey = H

main-context-menu-save-to-pocket =
    .label = 將頁面儲存至 { -pocket-brand-name }
    .accesskey = k

main-context-menu-send-to-device =
    .label = 將頁面傳送至裝置
    .accesskey = D

## The access keys for "Use Saved Login" and "Use Saved Password"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-use-saved-login =
    .label = 使用已存的登入資訊
    .accesskey = o

main-context-menu-use-saved-password =
    .label = 使用已存的密碼
    .accesskey = o

##

main-context-menu-suggest-strong-password =
    .label = 建議一組安全的密碼…
    .accesskey = S

main-context-menu-manage-logins2 =
    .label = 管理登入資訊
    .accesskey = M

main-context-menu-keyword =
    .label = 設為用關鍵字搜尋…
    .accesskey = K

main-context-menu-link-send-to-device =
    .label = 將鏈結傳送至裝置
    .accesskey = D

main-context-menu-frame =
    .label = 本頁框
    .accesskey = h

main-context-menu-frame-show-this =
    .label = 只顯示本頁框
    .accesskey = S

main-context-menu-frame-open-tab =
    .label = 用新分頁開啟頁框
    .accesskey = T

main-context-menu-frame-open-window =
    .label = 用新視窗開啟頁框
    .accesskey = w

main-context-menu-frame-reload =
    .label = 重新載入頁框
    .accesskey = R

main-context-menu-frame-bookmark =
    .label = 將此頁框加入書籤
    .accesskey = m

main-context-menu-frame-save-as =
    .label = 頁框另存新檔…
    .accesskey = F

main-context-menu-frame-print =
    .label = 列印此頁框…
    .accesskey = P

main-context-menu-frame-view-source =
    .label = 檢視頁框原始碼
    .accesskey = V

main-context-menu-frame-view-info =
    .label = 檢視頁框資訊
    .accesskey = I

main-context-menu-print-selection =
    .label = 僅列印選取區域
    .accesskey = r

main-context-menu-view-selection-source =
    .label = 檢視選取範圍原始碼
    .accesskey = e

main-context-menu-take-screenshot =
    .label = 拍攝畫面擷圖
    .accesskey = T

main-context-menu-take-frame-screenshot =
    .label = 拍攝畫面擷圖
    .accesskey = o

main-context-menu-view-page-source =
    .label = 檢視原始碼
    .accesskey = V

main-context-menu-bidi-switch-text =
    .label = 改變文字方向
    .accesskey = w

main-context-menu-bidi-switch-page =
    .label = 切換頁面方向
    .accesskey = D

main-context-menu-inspect =
    .label = 檢測
    .accesskey = Q

main-context-menu-inspect-a11y-properties =
    .label = 檢測輔助功能環境屬性

main-context-menu-eme-learn-more =
    .label = 了解 DRM 的更多資訊…
    .accesskey = D

# Variables
#   $containerName (String): The name of the current container
main-context-menu-open-link-in-container-tab =
    .label = 用新 { $containerName } 容器分頁開啟鏈結
    .accesskey = T
