# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used in DevTools’ performance-new panel, about:profiling, and
### the remote profiling panel. There are additional profiler strings in the appmenu.ftl
### file that are used for the profiler popup.

perftools-intro-title = 分析器设置
perftools-intro-description = 记录过程将在新标签页中打开 profiler.firefox.com。所有数据都存储在本地，您可以手动选择上传以进行共享。

## All of the headings for the various sections.

perftools-heading-settings = 完整设置
perftools-heading-buffer = 缓冲区设置
perftools-heading-features = 功能
perftools-heading-features-default = 功能（默认推荐开启）
perftools-heading-features-disabled = 已禁用的功能
perftools-heading-features-experimental = 实验性
perftools-heading-threads = 线程
perftools-heading-local-build = 本地构建版本

##

perftools-description-intro = 记录过程将在新标签页中打开 <a>profiler.firefox.com</a>。所有数据都存储在本地，您可以手动选择上传以进行共享。
perftools-description-local-build = 若您要对本机自行编译的构建版本进行测量，请将其 objdir 路径添加至下方列表，以便查询调试符号信息。

## The controls for the interval at which the profiler samples the code.

perftools-range-interval-label = 采样间隔：
perftools-range-interval-milliseconds = { NUMBER($interval, maxFractionalUnits: 2) } ms

##

# The size of the memory buffer used to store things in the profiler.
perftools-range-entries-label = 缓冲区大小：
perftools-custom-threads-label = 按名称添加自定义线程：
perftools-devtools-interval-label = 间隔：
perftools-devtools-threads-label = 线程：
perftools-devtools-settings-label = 设置

## Various statuses that affect the current state of profiling, not typically displayed.

perftools-status-private-browsing-notice =
    启用隐私浏览后，将禁用分析器。
    请关闭所有隐私窗口，即可重新启用分析器
perftools-status-recording-stopped-by-another-tool = 已被其他工具停止记录。
perftools-status-restart-required = 必须重启浏览器才能启用此功能。

## These are shown briefly when the user is waiting for the profiler to respond.

perftools-request-to-stop-profiler = 正在停止记录
perftools-request-to-get-profile-and-stop-profiler = 正在捕捉性能

##

perftools-button-start-recording = 开始记录
perftools-button-capture-recording = 正在捕捉记录
perftools-button-cancel-recording = 取消记录
perftools-button-save-settings = 保存设置并返回
perftools-button-restart = 重新启动
perftools-button-add-directory = 添加路径
perftools-button-remove-directory = 移除选中项
perftools-button-edit-settings = 编辑设置…

## These messages are descriptions of the threads that can be enabled for the profiler.

perftools-thread-gecko-main =
    .title = 父进程和内容进程等主进程
perftools-thread-compositor =
    .title = 将页面中各种绘制完成的元素进行合成
perftools-thread-dom-worker =
    .title = 处理 web worker 和 service worker
perftools-thread-renderer =
    .title = 启用 WebRender 时，用于执行 OpenGL 调用的线程
perftools-thread-render-backend =
    .title = WebRender 的 RenderBackend 线程
perftools-thread-paint-worker =
    .title = 启用非主线程绘制时，进行绘制的线程
perftools-thread-style-thread =
    .title = 样式计算会拆分在多个线程中进行
pref-thread-stream-trans =
    .title = 网络数据流传输
perftools-thread-socket-thread =
    .title = 网络相关代码进行任何 socket 阻塞式调用时，将发生在此线程
perftools-thread-img-decoder =
    .title = 图像解码线程
perftools-thread-dns-resolver =
    .title = DNS 解析会发生在此线程
perftools-thread-task-controller =
    .title = TaskController 线程池中的线程

##

perftools-record-all-registered-threads = 忽略上面选择的项目，记录所有注册的线程
perftools-tools-threads-input-label =
    .title = 下方列表是要在分析器中测量性能的线程名称（以逗号分隔）。名称须与要测量的线程的名称部分匹配，且对空格敏感。

## Onboarding UI labels. These labels are displayed in the new performance panel UI, when
## both devtools.performance.new-panel-onboarding & devtools.performance.new-panel-enabled
## preferences are true.

perftools-onboarding-message = <b>新变化</b>：{ -profiler-brand-name }现已集成于开发者工具。<a>详细了解</a>这个功能强大的新工具。
# `options-context-advanced-settings` is defined in toolbox-options.ftl
perftools-onboarding-reenable-old-panel = （在短时间内，您仍可以通过<a>{ options-context-advanced-settings }</a>访问旧的“性能”面板）
perftools-onboarding-close-button =
    .aria-label = 关闭导览消息

## Profiler presets


# Presets and their l10n IDs are defined in the file
# devtools/client/performance-new/popup/background.jsm.js
# The same labels and descriptions are also defined in appmenu.ftl.

perftools-presets-web-developer-label = Web 开发者
perftools-presets-web-developer-description = 推荐在对大部分 Web 应用程序调试时使用，开销较少。
perftools-presets-firefox-platform-label = Waterfox 平台
perftools-presets-firefox-platform-description = 推荐在 Waterfox 内部平台调试时使用。
perftools-presets-firefox-front-end-label = Waterfox 前端
perftools-presets-firefox-front-end-description = 推荐在 Waterfox 内部前端调试时使用。
perftools-presets-firefox-graphics-label = Waterfox 图形
perftools-presets-firefox-graphics-description = 推荐在检查 Waterfox 图形性能问题时使用。
perftools-presets-media-label = 媒体
perftools-presets-media-description = 推荐在诊断 Waterfox 音视频问题时使用。
perftools-presets-custom-label = 自定义

##

