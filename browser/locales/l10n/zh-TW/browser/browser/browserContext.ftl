# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] 長按以顯示歷史記錄
           *[other] 按滑鼠右鍵或長按以顯示歷史記錄
        }

## Back

main-context-menu-back =
    .tooltiptext = 回到上一頁
    .aria-label = 上一頁
    .accesskey = B

navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }

toolbar-button-back =
    .label = { main-context-menu-back.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = 前進下一頁
    .aria-label = 下一頁
    .accesskey = F

navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }

toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = 重新載入
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = 停止
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Save Page

main-context-menu-page-save =
    .label = 另存新檔…
    .accesskey = P

toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = 將本頁加入書籤
    .accesskey = m
    .tooltiptext = 將本頁加入書籤

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

main-context-menu-bookmark-this-link =
    .label = 將此鏈結加入書籤
    .accesskey = L

main-context-menu-save-link =
    .label = 鏈結另存新檔…
    .accesskey = k

main-context-menu-save-link-to-pocket =
    .label = 將鏈結儲存至 { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = 複製電子郵件地址
    .accesskey = E

main-context-menu-copy-link =
    .label = 複製鏈結網址
    .accesskey = a

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

main-context-menu-media-play-speed =
    .label = 播放速度
    .accesskey = d

main-context-menu-media-play-speed-slow =
    .label = 慢速（0.5×）
    .accesskey = S

main-context-menu-media-play-speed-normal =
    .label = 標準
    .accesskey = N

main-context-menu-media-play-speed-fast =
    .label = 快速（1.25×）
    .accesskey = F

main-context-menu-media-play-speed-faster =
    .label = 更快（1.5×）
    .accesskey = a

# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = 超快（2×）
    .accesskey = L

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
main-context-menu-media-pip =
    .label = 子母畫面
    .accesskey = u

main-context-menu-image-reload =
    .label = 重新載入圖片
    .accesskey = R

main-context-menu-image-view =
    .label = 檢視圖片
    .accesskey = I

main-context-menu-video-view =
    .label = 播放視訊檔案
    .accesskey = I

main-context-menu-image-copy =
    .label = 複製圖片
    .accesskey = y

main-context-menu-image-copy-location =
    .label = 複製圖片網址
    .accesskey = o

main-context-menu-video-copy-location =
    .label = 複製視訊檔案網址
    .accesskey = o

main-context-menu-audio-copy-location =
    .label = 複製音訊檔案網址
    .accesskey = o

main-context-menu-image-save-as =
    .label = 圖片另存新檔…
    .accesskey = v

main-context-menu-image-email =
    .label = 郵寄圖片…
    .accesskey = g

main-context-menu-image-set-as-background =
    .label = 設為桌布…
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

main-context-menu-video-image-save-as =
    .label = 另存快照為…
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

main-context-menu-view-background-image =
    .label = 檢視背景圖片
    .accesskey = w

main-context-menu-generate-new-password =
    .label = 使用產生的密碼…
    .accesskey = G

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

main-context-menu-view-selection-source =
    .label = 檢視選取範圍原始碼
    .accesskey = e

main-context-menu-view-page-source =
    .label = 檢視原始碼
    .accesskey = V

main-context-menu-view-page-info =
    .label = 檢視頁面資訊
    .accesskey = I

main-context-menu-bidi-switch-text =
    .label = 改變文字方向
    .accesskey = w

main-context-menu-bidi-switch-page =
    .label = 切換頁面方向
    .accesskey = D

main-context-menu-inspect-element =
    .label = 檢測元素
    .accesskey = Q

main-context-menu-inspect-a11y-properties =
    .label = 檢測輔助功能環境屬性

main-context-menu-eme-learn-more =
    .label = 了解 DRM 的更多資訊…
    .accesskey = D

