# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = 新增容器
    .style = width: 45em

# Variables
#   $name (String) - Name of the container
containers-window-update-settings =
    .title = { $name } 容器設定
    .style = width: 45em

containers-window-close =
    .key = w

# This is a term to store style to be applied
# on the three labels in the containers add/edit dialog:
#   - name
#   - icon
#   - color
#
# Using this term and referencing it in the `.style` attribute
# of the three messages ensures that all three labels
# will be aligned correctly.
-containers-labels-style = min-width: 4rem

containers-name-label = 名稱
    .accesskey = N
    .style = { -containers-labels-style }

containers-name-text =
    .placeholder = 輸入容器名稱

containers-icon-label = 圖示
    .accesskey = I
    .style = { -containers-labels-style }

containers-color-label = 色彩
    .accesskey = o
    .style = { -containers-labels-style }

containers-dialog =
    .buttonlabelaccept = 完成
    .buttonaccesskeyaccept = D

containers-color-blue =
    .label = 藍色
containers-color-turquoise =
    .label = 綠松色
containers-color-green =
    .label = 綠色
containers-color-yellow =
    .label = 黃色
containers-color-orange =
    .label = 橘色
containers-color-red =
    .label = 紅色
containers-color-pink =
    .label = 粉紅色
containers-color-purple =
    .label = 紫色
containers-color-toolbar =
    .label = 與工具列相同

containers-icon-fence =
    .label = 籬笆
containers-icon-fingerprint =
    .label = 指紋
containers-icon-briefcase =
    .label = 公事包
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = 錢號
containers-icon-cart =
    .label = 購物車
containers-icon-circle =
    .label = 圓點
containers-icon-vacation =
    .label = 假期
containers-icon-gift =
    .label = 禮物
containers-icon-food =
    .label = 食物
containers-icon-fruit =
    .label = 水果
containers-icon-pet =
    .label = 寵物
containers-icon-tree =
    .label = 大樹
containers-icon-chill =
    .label = 墨鏡
