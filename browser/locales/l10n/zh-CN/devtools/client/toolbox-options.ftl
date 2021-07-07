# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = 默认的开发者工具
# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * 不支持当前的工具箱目标
# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = 附加组件安装的开发者工具
# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = 可用的工具箱按钮
# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = 主题

## Inspector section

# The heading
options-context-inspector = 查看器
# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = 显示浏览器样式
options-show-user-agent-styles-tooltip =
    .title = 启用此选项将显示由浏览器载入的默认样式。
# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = 截短 DOM 属性
options-collapse-attrs-tooltip =
    .title = 截短查看器中的长属性

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = 默认颜色单位
options-default-color-unit-authored = 按原单位
options-default-color-unit-hex = Hex
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = 颜色名

## Style Editor section

# The heading
options-styleeditor-label = 样式编辑器
# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = 自动补全 CSS
options-stylesheet-autocompletion-tooltip =
    .title = 在样式编辑器中自动补全您输入的 CSS 属性、值和选择器

## Screenshot section

# The heading
options-screenshot-label = 截图行为
# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-label = 截图到剪贴板
options-screenshot-clipboard-tooltip =
    .title = 直接将截图保存到剪贴板
# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-only-label = 截图仅保存到剪贴板
options-screenshot-clipboard-tooltip2 =
    .title = 直接将截图保存到剪贴板
# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = 播放相机快门声
options-screenshot-audio-tooltip =
    .title = 截图时播放相机快门声

## Editor section

# The heading
options-sourceeditor-label = 编辑器首选项
options-sourceeditor-detectindentation-tooltip =
    .title = 基于源内容推测缩进
options-sourceeditor-detectindentation-label = 检测缩进
options-sourceeditor-autoclosebrackets-tooltip =
    .title = 自动插入关闭括号
options-sourceeditor-autoclosebrackets-label = 自动关闭括号
options-sourceeditor-expandtab-tooltip =
    .title = 使用空格而非制表符缩进
options-sourceeditor-expandtab-label = 使用空格缩进
options-sourceeditor-tabsize-label = 制表符宽度
options-sourceeditor-keybinding-label = 按键绑定
options-sourceeditor-keybinding-default-label = 默认设置

## Advanced section

# The heading (this item is also used in perftools.ftl)
options-context-advanced-settings = 高级设置
# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = 禁用 HTTP 缓存（工具箱打开时）
options-disable-http-cache-tooltip =
    .title = 开启此选项将对所有已打开工具箱的标签页禁用 HTTP 缓存。Service Worker 不会受此选项影响。
# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = 禁用 JavaScript *
options-disable-javascript-tooltip =
    .title = 启用这个选项将对当前标签页禁用 JavaScript。如果关闭了该标签页或者工具箱，则这个设置就不再有效。
# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = 启用浏览器界面及附加组件的调试工具箱
options-enable-chrome-tooltip =
    .title = 打开此选项将允许您使用在浏览器上下文的开发者工具（通过 工具 > Web 开发者 > 浏览器工具箱）和从“附加组件管理器”调试附加组件
# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = 启用远程调试
options-enable-remote-tooltip2 =
    .title = 启用此选项将允许远程调试此浏览器实例
# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = 启用 Service Workers over HTTP（在工具箱打开时）
options-enable-service-workers-http-tooltip =
    .title = 开启此选项时，将对所有标签页在工具箱打开时启用 Service Workers over HTTP。
# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = 启用源映射
options-source-maps-tooltip =
    .title = 如果您启用此选项，工具中的源代码将被映射。
# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * 仅限当前会话，将重新载入当前页面
# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = 显示 Gecko 平台数据
options-show-platform-data-tooltip =
    .title = 如果开启此选项，JavaScript 分析报告将会包含 Gecko 平台符号表
