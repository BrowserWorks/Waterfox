# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

config-window =
    .title = about:config

## Strings used to display a warning in about:config

# This text should be attention grabbing and playful
config-about-warning-title =
    .value = 隨便亂搞會讓保固失效！
config-about-warning-text = 更改進階設定可能會影響本程式的穩定性、安全性及執行效能。在修改前請確定您知道在做什麼，或者確定參考的文件值得信賴。
config-about-warning-button =
    .label = 我發誓，我一定會小心的！
config-about-warning-checkbox =
    .label = 下次顯示此警告訊息

config-search-prefs =
    .value = 搜尋:
    .accesskey = r

config-focus-search =
    .key = r

config-focus-search-2 =
    .key = f

## These strings are used for column headers

config-pref-column =
    .label = 偏好設定名稱
config-lock-column =
    .label = 狀態
config-type-column =
    .label = 類型
config-value-column =
    .label = 值

## These strings are used for tooltips

config-pref-column-header =
    .tooltip = 按此排序
config-column-chooser =
    .tooltip = 點此選擇要顯示的欄位

## These strings are used for the context menu

config-copy-pref =
    .key = C
    .label = 複製
    .accesskey = C

config-copy-name =
    .label = 複製名稱
    .accesskey = N

config-copy-value =
    .label = 複製值
    .accesskey = V

config-modify =
    .label = 修改
    .accesskey = M

config-toggle =
    .label = 切換
    .accesskey = T

config-reset =
    .label = 重設
    .accesskey = R

config-new =
    .label = 新增
    .accesskey = w

config-string =
    .label = 字串
    .accesskey = S

config-integer =
    .label = 整數
    .accesskey = I

config-boolean =
    .label = 布林（Boolean）值
    .accesskey = B

config-default = 預設值
config-modified = 已修改
config-locked = 已鎖定

config-property-string = 字串
config-property-int = 整數
config-property-bool = 布林（Boolean）值

config-new-prompt = 輸入偏好設定名稱

config-nan-title = 無效值
config-nan-text = 您輸入的內容不是數字。

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-new-title = 新 { $type } 的值

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-modify-title = 輸入 { $type } 的值
