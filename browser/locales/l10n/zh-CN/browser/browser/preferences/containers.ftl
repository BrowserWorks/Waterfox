# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

containers-window-new =
    .title = 添加新身份
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update =
    .title = { $name } 身份首选项
    .style = width: 45em
# Variables
#   $name (String) - Name of the container
containers-window-update-settings =
    .title = { $name } 身份设置
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
containers-name-label = 名称
    .accesskey = N
    .style = { -containers-labels-style }
containers-name-text =
    .placeholder = 请输入身份名称
containers-icon-label = 图标
    .accesskey = I
    .style = { -containers-labels-style }
containers-color-label = 颜色
    .accesskey = o
    .style = { -containers-labels-style }
containers-button-done =
    .label = 完成
    .accesskey = D
containers-dialog =
    .buttonlabelaccept = 完成
    .buttonaccesskeyaccept = D
containers-color-blue =
    .label = 蓝色
containers-color-turquoise =
    .label = 青色
containers-color-green =
    .label = 绿色
containers-color-yellow =
    .label = 黄色
containers-color-orange =
    .label = 橙色
containers-color-red =
    .label = 红色
containers-color-pink =
    .label = 粉色
containers-color-purple =
    .label = 紫色
containers-color-toolbar =
    .label = 匹配工具栏
containers-icon-fence =
    .label = 篱笆
containers-icon-fingerprint =
    .label = 指纹
containers-icon-briefcase =
    .label = 公文包
# String represents a money sign but currently uses a dollar sign
# so don't change to local currency. See Bug 1291672.
containers-icon-dollar =
    .label = 美元符号
containers-icon-cart =
    .label = 购物车
containers-icon-circle =
    .label = 圆点
containers-icon-vacation =
    .label = 假期
containers-icon-gift =
    .label = 礼物
containers-icon-food =
    .label = 食品
containers-icon-fruit =
    .label = 水果
containers-icon-pet =
    .label = 宠物
containers-icon-tree =
    .label = 树木
containers-icon-chill =
    .label = 墨镜
