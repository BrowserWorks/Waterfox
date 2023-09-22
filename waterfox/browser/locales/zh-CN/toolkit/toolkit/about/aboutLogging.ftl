# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This is the title of the page
about-logging-title = 关于日志记录
about-logging-page-title = 日志管理器
about-logging-current-log-file = 当前日志文件：
about-logging-new-log-file = 新日志文件：
about-logging-currently-enabled-log-modules = 当前已启用日志模块：
about-logging-log-tutorial = 参见 <a data-l10n-name="logging">HTTP 日志</a> 了解如何使用此工具。
# This message is used as a button label, "Open" indicates an action.
about-logging-open-log-file-dir = 打开目录
about-logging-set-log-file = 设置日志文件
about-logging-set-log-modules = 设置日志模块
about-logging-start-logging = 开始记录日志
about-logging-stop-logging = 停止记录日志
about-logging-buttons-disabled = 已通过环境变量配置日志记录，动态配置不可用。
about-logging-some-elements-disabled = 已通过 URL 配置日志记录，部分配置选项不可用
about-logging-info = 信息：
about-logging-log-modules-selection = 选择日志模块
about-logging-new-log-modules = 新日志模块：
about-logging-logging-output-selection = 日志输出
about-logging-logging-to-file = 记录到文件
about-logging-logging-to-profiler = 记录到 { -profiler-brand-name }
about-logging-no-log-modules = 无
about-logging-no-log-file = 无
about-logging-logging-preset-selector-text = 日志预设置：
about-logging-with-profiler-stacks-checkbox = 启用日志消息的堆栈跟踪

## Logging presets

about-logging-preset-networking-label = 网络
about-logging-preset-networking-description = 用于诊断网络问题的日志模块
about-logging-preset-networking-cookie-label = Cookie
about-logging-preset-networking-cookie-description = 用于诊断 Cookie 问题的日志模块
about-logging-preset-networking-websocket-label = WebSocket
about-logging-preset-networking-websocket-description = 用于诊断 WebSocket 问题的日志模块
about-logging-preset-networking-http3-label = HTTP/3
about-logging-preset-networking-http3-description = 用于诊断 HTTP/3 和 QUIC 问题的日志模块
about-logging-preset-media-playback-label = 媒体播放
about-logging-preset-media-playback-description = 用于诊断媒体播放（非视频会议）问题的日志模块
about-logging-preset-webrtc-label = WebRTC
about-logging-preset-webrtc-description = 用于诊断 WebRTC 调用的日志模块
about-logging-preset-webgpu-label = WebGPU
about-logging-preset-webgpu-description = 用于诊断 WebGPU 问题的日志模块
about-logging-preset-gfx-label = 图形
about-logging-preset-gfx-description = 用于诊断图形问题的日志模块
about-logging-preset-custom-label = 自定义
about-logging-preset-custom-description = 手动选择的日志模块
# Error handling
about-logging-error = 错误：

## Variables:
##   $k (String) - Variable name
##   $v (String) - Variable value

about-logging-invalid-output = 键“{ $v }”的值“{ $k }”无效
about-logging-unknown-logging-preset = 日志记录预设置“{ $v }”未知
about-logging-unknown-profiler-preset = 性能分析预设置“{ $v }”未知
about-logging-unknown-option = about:logging 选项“{ $k }”未知
about-logging-configuration-url-ignored = 已忽略配置 URL
about-logging-file-and-profiler-override = 无法同时强制输出到文件并覆盖性能分析选项
about-logging-configured-via-url = 通过 URL 配置的选项
