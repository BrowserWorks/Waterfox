# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = 跟全新的 { -brand-short-name } 說聲嗨！
upgrade-dialog-new-subtitle = 設計來讓您更快抵達想去的地方
upgrade-dialog-new-item-menu-title = 更精簡的工具列與選單設計
upgrade-dialog-new-item-menu-description = 重要功能優先，讓您更快完成任務。
upgrade-dialog-new-item-tabs-title = 新一代的分頁標籤設計
upgrade-dialog-new-item-tabs-description = 把資訊收好收滿，可聚焦又可靈活移動。
upgrade-dialog-new-item-icons-title = 全新設計的圖示，訊息說明更清楚
upgrade-dialog-new-item-icons-description = 輕輕鬆鬆就能快速上手。
upgrade-dialog-new-primary-default-button = 將 { -brand-short-name } 設為我的預設瀏覽器
upgrade-dialog-new-primary-theme-button = 選擇佈景主題
upgrade-dialog-new-secondary-button = 現在不要
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = 好，知道了！

## Pin Waterfox screen
##
## These title, subtitle and button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-pin-title =
    { PLATFORM() ->
        [macos] 將 { -brand-short-name } 保留在您的 Dock
       *[other] 將 { -brand-short-name } 釘選到您的工作列
    }
# The English macOS string avoids repeating "Keep" a third time, so if your
# translations don't repeat anyway, the same string can be used cross-platform.
upgrade-dialog-pin-subtitle =
    { PLATFORM() ->
        [macos] 輕輕鬆鬆使用最新版的 { -brand-short-name }。
       *[other] 輕輕鬆鬆使用最新版的 { -brand-short-name }。
    }
upgrade-dialog-pin-primary-button =
    { PLATFORM() ->
        [macos] 保留在 Dock
       *[other] 釘選到工作列
    }
upgrade-dialog-pin-secondary-button = 現在不要

## Default browser screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title-2 = 將 { -brand-short-name } 設為您的預設瀏覽器
upgrade-dialog-default-subtitle-2 = 開啟速度、安全性、隱私權的自動保護。
upgrade-dialog-default-primary-button-2 = 設為預設瀏覽器
upgrade-dialog-default-secondary-button = 現在不要

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 = 使用新佈景主題讓我們重新再出發
upgrade-dialog-theme-system = 系統佈景主題
    .title = 依照作業系統設定的佈景主題顯示按鈕、選單、視窗

## Start screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-start-title = 美麗生活
upgrade-dialog-start-subtitle = 活力滿點的新配色，限時提供。
upgrade-dialog-start-primary-button = 探索配色
upgrade-dialog-start-secondary-button = 現在不要

## Colorway screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-colorway-title = 挑選您的色彩配置
upgrade-dialog-colorway-home-checkbox = 切換成使用佈景主題背景的 Waterfox 首頁
upgrade-dialog-colorway-primary-button = 儲存配色
upgrade-dialog-colorway-secondary-button = 繼續使用原先的佈景主題
upgrade-dialog-colorway-theme-tooltip =
    .title = 探索預設佈景主題
# $colorwayName (String) - Name of colorway, e.g., Abstract, Cheers
upgrade-dialog-colorway-colorway-tooltip =
    .title = 探索 { $colorwayName } 的配色
upgrade-dialog-colorway-default-theme = 預設
# "Auto" is short for "Automatic"
upgrade-dialog-colorway-theme-auto = 自動
    .title = 根據作業系統佈景主題設定來顯示按鈕、選單、視窗。
upgrade-dialog-theme-light = 亮色
    .title = 為按鈕、選單、視窗使用亮色佈景主題
upgrade-dialog-theme-dark = 暗色
    .title = 為按鈕、選單、視窗使用暗色佈景主題
upgrade-dialog-theme-alpenglow = Alpenglow
    .title = 為按鈕、選單、視窗使用色彩斑斕的佈景主題
upgrade-dialog-theme-keep = 保留原設定
    .title = 使用您更新 { -brand-short-name } 前安裝使用的佈景主題
upgrade-dialog-theme-primary-button = 儲存佈景主題
upgrade-dialog-theme-secondary-button = 現在不要
upgrade-dialog-colorway-variation-soft = 軟色調
    .title = 使用這種色彩配置
upgrade-dialog-colorway-variation-balanced = 均衡色調
    .title = 使用這種色彩配置
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
upgrade-dialog-colorway-variation-bold = 濃烈色調
    .title = 使用這種色彩配置

## Thank you screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-thankyou-title = 感謝您選用
upgrade-dialog-thankyou-subtitle = { -brand-short-name } 是一套由非營利組織所打造的獨立瀏覽器。由我們一起讓網路環境更安全、更健康、也更有隱私。
upgrade-dialog-thankyou-primary-button = 開始瀏覽
