# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = 跟全新的 { -brand-short-name } 說聲嗨！
upgrade-dialog-new-subtitle = 設計來讓您更快抵達想去的地方
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline
# style to be automatically added to the text inside it. { -brand-short-name }
# should stay inside the span.
upgrade-dialog-new-alt-subtitle = 滑鼠輕鬆點擊幾下，即可開始使用 <span data-l10n-name="zap">{ -brand-short-name }</span>
upgrade-dialog-new-item-menu-title = 更精簡的工具列與選單設計
upgrade-dialog-new-item-menu-description = 重要功能優先，讓您更快完成任務。
upgrade-dialog-new-item-tabs-title = 新一代的分頁標籤設計
upgrade-dialog-new-item-tabs-description = 把資訊收好收滿，可聚焦又可靈活移動。
upgrade-dialog-new-item-icons-title = 全新設計的圖示，訊息說明更清楚
upgrade-dialog-new-item-icons-description = 輕輕鬆鬆就能快速上手。
upgrade-dialog-new-primary-primary-button = 將 { -brand-short-name } 設為我的主要瀏覽器
    .title = 將 { -brand-short-name } 設為預設瀏覽器，並釘選到工作列
upgrade-dialog-new-primary-default-button = 將 { -brand-short-name } 設為我的預設瀏覽器
upgrade-dialog-new-primary-pin-button = 將 { -brand-short-name } 釘選到我的工作列
upgrade-dialog-new-primary-pin-alt-button = 釘選到工作列
upgrade-dialog-new-primary-theme-button = 選擇佈景主題
upgrade-dialog-new-secondary-button = 現在不要
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = 好，知道了！

## Pin Firefox screen
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
upgrade-dialog-default-title = 要將 { -brand-short-name } 設為您的預設瀏覽器嗎？
upgrade-dialog-default-subtitle = 隨時上網都有最快速度、安全與隱私保護。
upgrade-dialog-default-primary-button = 設為預設瀏覽器
# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title-2 = 將 { -brand-short-name } 設為您的預設瀏覽器
upgrade-dialog-default-subtitle-2 = 開啟速度、安全性、隱私權的自動保護。
upgrade-dialog-default-primary-button-2 = 設為預設瀏覽器
upgrade-dialog-default-secondary-button = 現在不要

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title =
    使用新佈景主題
    讓我們重新再出發
# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 = 使用新佈景主題讓我們重新再出發
upgrade-dialog-theme-system = 系統佈景主題
    .title = 依照作業系統設定的佈景主題顯示按鈕、選單、視窗
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
