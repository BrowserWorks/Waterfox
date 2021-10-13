# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = 三思而后行
about-config-intro-warning-text = 更改高级配置的首选项可能会影响 { -brand-short-name } 的性能和安全性。
about-config-intro-warning-checkbox = 当我尝试修改底层首选项时警示我
about-config-intro-warning-button = 接受风险并继续



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = 更改这些首选项可能会影响 { -brand-short-name } 的性能和安全性。

about-config-page-title = 高级首选项

about-config-search-input1 =
    .placeholder = 搜索首选项名称
about-config-show-all = 显示全部

about-config-pref-add-button =
    .title = 添加
about-config-pref-toggle-button =
    .title = 切换
about-config-pref-edit-button =
    .title = 编辑
about-config-pref-save-button =
    .title = 保存
about-config-pref-reset-button =
    .title = 重置
about-config-pref-delete-button =
    .title = 删除

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = 布尔
about-config-pref-add-type-number = 数值
about-config-pref-add-type-string = 字符串

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value }（默认）
about-config-pref-accessible-value-custom =
    .aria-label = { $value }（自定义）
