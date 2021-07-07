# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

config-window =
    .title = about:config

## Strings used to display a warning in about:config

# This text should be attention grabbing and playful
config-about-warning-title =
    .value = 这可能使质量保证失效！
config-about-warning-text = 修改这些高级设置可能对本应用程序的稳定性、安全性以及性能造成不良影响。请仅在您十分清楚的情况下继续操作。
config-about-warning-button =
    .label = 我了解此风险！
config-about-warning-checkbox =
    .label = 下次仍显示此警告

config-search-prefs =
    .value = 搜索：
    .accesskey = r

config-focus-search =
    .key = r

config-focus-search-2 =
    .key = f

## These strings are used for column headers

config-pref-column =
    .label = 首选项名称
config-lock-column =
    .label = 状态
config-type-column =
    .label = 类型
config-value-column =
    .label = 值

## These strings are used for tooltips

config-pref-column-header =
    .tooltip = 点击排序
config-column-chooser =
    .tooltip = 单击以选择要显示的列

## These strings are used for the context menu

config-copy-pref =
    .key = C
    .label = 复制
    .accesskey = C

config-copy-name =
    .label = 复制名称
    .accesskey = N

config-copy-value =
    .label = 复制值
    .accesskey = V

config-modify =
    .label = 修改
    .accesskey = M

config-toggle =
    .label = 切换
    .accesskey = T

config-reset =
    .label = 重置
    .accesskey = R

config-new =
    .label = 新建
    .accesskey = w

config-string =
    .label = 字符串
    .accesskey = S

config-integer =
    .label = 整数
    .accesskey = I

config-boolean =
    .label = 布尔
    .accesskey = B

config-default = 默认
config-modified = 已修改
config-locked = 已锁定

config-property-string = 字符串
config-property-int = 整数
config-property-bool = 布尔

config-new-prompt = 输入首选项名称

config-nan-title = 无效的值
config-nan-text = 您输入的文字不是数字。

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-new-title = 新的 { $type } 值

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-modify-title = 输入 { $type } 的值
