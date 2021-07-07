# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

page-title = 排障信息
page-subtitle =
    本页面包含的技术信息在您寻求解决方法时或许能帮上忙。
    如果您正在寻找 { -brand-short-name } 常见问题的答案，
    可以查阅我们的<a data-l10n-name="support-link">帮助网站</a>。

crashes-title = 崩溃报告
crashes-id = 报告 ID
crashes-send-date = 提交日期
crashes-all-reports = 全部崩溃报告
crashes-no-config = 此应用程序未被配置为显示崩溃报告。
support-addons-title = 附加组件
support-addons-name = 名称
support-addons-type = 类型
support-addons-enabled = 已启用
support-addons-version = 版本
support-addons-id = ID
security-software-title = 安全软件
security-software-type = 类型
security-software-name = 名称
security-software-antivirus = 防病毒软件
security-software-antispyware = 反间谍软件
security-software-firewall = 防火墙
features-title = { -brand-short-name } 功能
features-name = 名称
features-version = 版本
features-id = ID
processes-title = 远程进程
processes-type = 类型
processes-count = 数量
app-basics-title = 应用程序概要
app-basics-name = 名称
app-basics-version = 版本
app-basics-build-id = 版本 ID
app-basics-distribution-id = 发行 ID
app-basics-update-channel = 更新通道
# This message refers to the folder used to store updates on the device,
# as in "Folder for updates". "Update" is a noun, not a verb.
app-basics-update-dir =
    { PLATFORM() ->
        [linux] 更新目录
       *[other] 更新文件夹
    }
app-basics-update-history = 更新历史
app-basics-show-update-history = 显示更新历史
# Represents the path to the binary used to start the application.
app-basics-binary = 应用程序二进制文件
app-basics-profile-dir =
    { PLATFORM() ->
        [linux] 配置文件夹
       *[other] 配置文件夹
    }
app-basics-enabled-plugins = 已启用的插件
app-basics-build-config = 构建配置
app-basics-user-agent = 用户代理
app-basics-os = 操作系统
app-basics-os-theme = 操作系统主题
# Rosetta is Apple's translation process to run apps containing x86_64
# instructions on Apple Silicon. This should remain in English.
app-basics-rosetta = 由 Rosetta 转译
app-basics-memory-use = 内存使用
app-basics-performance = 性能
app-basics-service-workers = 已注册的 Service Worker
app-basics-third-party = 第三方模块
app-basics-profiles = 配置文件
app-basics-launcher-process-status = 启动器进程
app-basics-multi-process-support = 多进程窗口
app-basics-fission-support = Fission 窗口
app-basics-remote-processes-count = 远程进程
app-basics-enterprise-policies = 企业策略
app-basics-location-service-key-google = Google 位置服务密钥
app-basics-safebrowsing-key-google = Google 安全浏览密钥
app-basics-key-mozilla = Waterfox 位置服务密钥
app-basics-safe-mode = 安全模式
show-dir-label =
    { PLATFORM() ->
        [macos] 在 Finder 中显示
        [windows] 打开文件夹
       *[other] 打开目录
    }
environment-variables-title = 环境变量
environment-variables-name = 名称
environment-variables-value = 值
experimental-features-title = 实验性功能
experimental-features-name = 名称
experimental-features-value = 值
modified-key-prefs-title = 修改过的重要首选项
modified-prefs-name = 名称
modified-prefs-value = 值
user-js-title = user.js 设置
user-js-description = 您的配置文件夹中有一个 <a data-l10n-name="user-js-link">user.js 文件</a>，其中包含了一些并非由 { -brand-short-name } 所创建的首选项（偏好设置）。
locked-key-prefs-title = 已锁定的重要首选项
locked-prefs-name = 名称
locked-prefs-value = 值
graphics-title = 图像
graphics-features-title = 特性
graphics-diagnostics-title = 诊断
graphics-failure-log-title = 失败日志
graphics-gpu1-title = GPU #1
graphics-gpu2-title = GPU #2
graphics-decision-log-title = 决策日志
graphics-crash-guards-title = 被崩溃守卫禁用的功能
graphics-workarounds-title = 变通方法
# Windowing system in use on Linux (e.g. X11, Wayland).
graphics-window-protocol = 窗口协议
# Desktop environment in use on Linux (e.g. GNOME, KDE, XFCE, etc).
graphics-desktop-environment = 桌面环境
place-database-title = Places 数据库
place-database-integrity = 完整性
place-database-verify-integrity = 验证完整性
a11y-title = 无障碍环境
a11y-activated = 已激活
a11y-force-disabled = 强制停用无障碍环境
a11y-handler-used = 采用无障碍处理程序
a11y-instantiator = 无障碍环境实例化器（Accessibility Instantiator）
library-version-title = 库版本
copy-text-to-clipboard-label = 复制文本到剪贴板
copy-raw-data-to-clipboard-label = 复制原始数据到剪贴板
sandbox-title = 沙盒
sandbox-sys-call-log-title = 被拒绝的系统调用
sandbox-sys-call-index = #
sandbox-sys-call-age = 秒前
sandbox-sys-call-pid = PID
sandbox-sys-call-tid = TID
sandbox-sys-call-proc-type = 进程类型
sandbox-sys-call-number = 系统调用
sandbox-sys-call-args = 参数
troubleshoot-mode-title = 诊断问题
restart-in-troubleshoot-mode-label = 排障模式…
clear-startup-cache-title = 尝试清除启动缓存
clear-startup-cache-label = 清除启动缓存...
startup-cache-dialog-title2 = 要重启 { -brand-short-name } 以清除启动缓存吗？
startup-cache-dialog-body2 = 将不会更改您的设置或移除扩展。
restart-button-label = 重启

## Media titles

audio-backend = 音频后端
max-audio-channels = 最大声道
sample-rate = 首选采样率
roundtrip-latency = 往返延迟（标准差）
media-title = 媒体
media-output-devices-title = 输出设备
media-input-devices-title = 输入设备
media-device-name = 名称
media-device-group = 组别
media-device-vendor = 厂商
media-device-state = 状态
media-device-preferred = 首选
media-device-format = 格式
media-device-channels = 声道
media-device-rate = 采样率
media-device-latency = 延迟
media-capabilities-title = 媒体能力
# List all the entries of the database.
media-capabilities-enumerate = 枚举数据库

##

intl-title = 国际化与本地化
intl-app-title = 应用程序设置
intl-locales-requested = 要求的语言环境
intl-locales-available = 可用的语言环境
intl-locales-supported = 应用程序语言环境
intl-locales-default = 默认语言环境
intl-os-title = 操作系统
intl-os-prefs-system-locales = 系统语言环境
intl-regional-prefs = 地区偏好

## Remote Debugging
##
## The Waterfox remote protocol provides low-level debugging interfaces
## used to inspect state and control execution of documents,
## browser instrumentation, user interaction simulation,
## and for subscribing to browser-internal events.
##
## See also https://firefox-source-docs.mozilla.org/remote/

remote-debugging-title = 远程调试（Chromium 协议）
remote-debugging-accepting-connections = 接受连接
remote-debugging-url = URL

##

# Variables
# $days (Integer) - Number of days of crashes to log
report-crash-for-days = 近 { $days } 天的崩溃报告

# Variables
# $minutes (integer) - Number of minutes since crash
crashes-time-minutes = { $minutes } 分钟前

# Variables
# $hours (integer) - Number of hours since crash
crashes-time-hours = { $hours } 小时前

# Variables
# $days (integer) - Number of days since crash
crashes-time-days = { $days } 天前

# Variables
# $reports (integer) - Number of pending reports
pending-reports = 全部崩溃报告（包括 { $reports } 个待上传的指定时间范围内的崩溃）

raw-data-copied = 原始数据已复制到剪贴板
text-copied = 文本已复制到剪贴板

## The verb "blocked" here refers to a graphics feature such as "Direct2D" or "OpenGL layers".

blocked-driver = 因您的显卡驱动版本而无法启用。
blocked-gfx-card = 因您显卡驱动的未解决的问题而无法启用。
blocked-os-version = 因您的操作系统版本而无法启用。
blocked-mismatched-version = 因您的注册表与 DLL 中的显卡驱动程序版本号不相符而无法启用。
# Variables
# $driverVersion - The graphics driver version string
try-newer-driver = 因您的显卡驱动版本而无法启用。请尝试更新您的显卡驱动程序至版本 { $driverVersion } 或更新的版本。

# "ClearType" is a proper noun and should not be translated. Feel free to leave English strings if
# there are no good translations, these are only used in about:support
clear-type-parameters = ClearType 参数

compositing = 合成
hardware-h264 = H264 硬件解码
main-thread-no-omtc = 主线程，无 OMTC
yes = 是
no = 否
unknown = 未知
virtual-monitor-disp = 虚拟显示器

## The following strings indicate if an API key has been found.
## In some development versions, it's expected for some API keys that they are
## not found.

found = 存在
missing = 缺失

gpu-process-pid = GPUProcessPid
gpu-process = GPUProcess
gpu-description = 描述
gpu-vendor-id = 厂商 ID
gpu-device-id = 设备 ID
gpu-subsys-id = 子系统 ID
gpu-drivers = 驱动程序
gpu-ram = 内存
gpu-driver-vendor = 驱动程序供应商
gpu-driver-version = 驱动程序版本
gpu-driver-date = 驱动程序日期
gpu-active = 活动
webgl1-wsiinfo = WebGL 1 驱动程序 WSI 信息
webgl1-renderer = WebGL 1 驱动程序渲染器
webgl1-version = WebGL 1 驱动程序版本
webgl1-driver-extensions = WebGL 1 驱动程序扩展
webgl1-extensions = WebGL 1 扩展
webgl2-wsiinfo = WebGL 2 驱动程序 WSI 信息
webgl2-renderer = WebGL2 渲染器
webgl2-version = WebGL 2 驱动程序版本
webgl2-driver-extensions = WebGL 2 驱动程序扩展
webgl2-extensions = WebGL 2 扩展

# Variables
#   $bugNumber (string) - Bug number on Bugzilla
support-blocklisted-bug = 由于已知问题，被列入屏蔽列表：<a data-l10n-name="bug-link">bug { $bugNumber }</a>

# Variables
# $failureCode (string) - String that can be searched in the source tree.
unknown-failure = 已列入黑名单；故障代码 { $failureCode }

d3d11layers-crash-guard = D3D11 合成器
glcontext-crash-guard = OpenGL
wmfvpxvideo-crash-guard = WMF VPX 视频解码器

reset-on-next-restart = 下次开启时重置
gpu-process-kill-button = 终止 GPU 进程
gpu-device-reset = 设备重置
gpu-device-reset-button = 触发设备重置
uses-tiling = 使用 Tiling
content-uses-tiling = 使用 Tiling（内容）
off-main-thread-paint-enabled = 非主线程绘制已启用
off-main-thread-paint-worker-count = 非主线程绘制工作器数量
target-frame-rate = 目标帧率

min-lib-versions = 预期最低版本
loaded-lib-versions = 目前使用版本

has-seccomp-bpf = Seccomp-BPF（系统调用过滤）
has-seccomp-tsync = Seccomp 线程同步
has-user-namespaces = 用户命名空间
has-privileged-user-namespaces = 用于特权进程的用户命名空间
can-sandbox-content = 内容进程沙盒化
can-sandbox-media = 媒体插件沙盒化
content-sandbox-level = 内容进程沙盒级别
effective-content-sandbox-level = 生效的内容进程沙盒级别
content-win32k-lockdown-state = 内容进程的 Win32k 锁定状态
sandbox-proc-type-content = 内容
sandbox-proc-type-file = 文件内容
sandbox-proc-type-media-plugin = 媒体插件
sandbox-proc-type-data-decoder = 数据解码器

startup-cache-title = 启动缓存
startup-cache-disk-cache-path = 磁盘缓存路径
startup-cache-ignore-disk-cache = 忽略磁盘缓存
startup-cache-found-disk-cache-on-init = 在初始化时发现磁盘缓存
startup-cache-wrote-to-disk-cache = 已写入磁盘缓存

launcher-process-status-0 = 启用
launcher-process-status-1 = 因故障而禁用
launcher-process-status-2 = 强制禁用
launcher-process-status-unknown = 未知状态

# Variables
# $remoteWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
multi-process-windows = { $remoteWindows }/{ $totalWindows }
# Variables
# $fissionWindows (integer) - Number of remote windows
# $totalWindows (integer) - Number of total windows
fission-windows = { $fissionWindows }/{ $totalWindows }
fission-status-experiment-control = 通过实验禁用
fission-status-experiment-treatment = 通过实验启用
fission-status-disabled-by-e10s-env = 被环境禁用
fission-status-enabled-by-env = 由环境启用
fission-status-disabled-by-safe-mode = 被安全模式禁用
fission-status-enabled-by-default = 默认启用
fission-status-disabled-by-default = 默认禁用
fission-status-enabled-by-user-pref = 由用户启用
fission-status-disabled-by-user-pref = 被用户禁用
fission-status-disabled-by-e10s-other = 已禁用 E10s
fission-status-enabled-by-rollout = 通过分阶段推出启用

async-pan-zoom = 异步平移/缩放
apz-none = 无
wheel-enabled = 滚轮输入已启用
touch-enabled = 触摸输入已启用
drag-enabled = 滚动条拖动已启用
keyboard-enabled = 键盘已启用
autoscroll-enabled = 自动滚动已启用
zooming-enabled = 已启用平滑手势缩放

## Variables
## $preferenceKey (string) - String ID of preference

wheel-warning = 因为不支持的首选项: { $preferenceKey }，已禁用异步滚轮输入
touch-warning = 因为不支持的首选项: { $preferenceKey }，已禁用异步触摸输入

## Strings representing the status of the Enterprise Policies engine.

policies-inactive = 未激活
policies-active = 已激活
policies-error = 错误

## Printing section

support-printing-title = 打印
support-printing-troubleshoot = 故障排除
support-printing-clear-settings-button = 清除保存的打印设置
support-printing-modified-settings = 修改过的打印设置
support-printing-prefs-name = 名称
support-printing-prefs-value = 值

## Normandy sections

support-remote-experiments-title = 远程实验
support-remote-experiments-name = 名称
support-remote-experiments-branch = 实验分支
support-remote-experiments-see-about-studies = 欲详细了解，请参见 <a data-l10n-name="support-about-studies-link">about:studies</a>，包括如何禁用单个实验或禁止 { -brand-short-name } 以后运行此类实验。

support-remote-features-title = 远程功能
support-remote-features-name = 名称
support-remote-features-status = 状态
