# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-masonry2 =
    .label = CSS：瀑布流（Masonry）布局
experimental-features-css-masonry-description = 启用对 CSS 瀑布流布局的实验性支持。欲详细了解该功能，请参阅<a data-l10n-name="explainer">说明文档</a>。若要提供反馈，请在 <a data-l10n-name="w3c-issue">GitHub Issue</a> 或此 <a data-l10n-name="bug">Bug</a> 中留言。
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-gpu2 =
    .label = Web API: WebGPU
experimental-features-web-gpu-description2 = 这个新的 API 为利用用户设备或计算机的<a data-l10n-name="wikipedia">图形处理器（GPU）</a>执行计算和图形渲染提供了底层支持。该<a data-l10n-name="spec">规范</a>仍在完善中。欲详细了解，请参阅 <a data-l10n-name="bugzilla">Bug 1602129</a>。
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-avif =
    .label = 媒体：AVIF
experimental-features-media-avif-description = 启用后，{ -brand-short-name } 将支持 AV1 图像文件格式（AVIF）。这是一种静态图像文件格式，它利用 AV1 视频压缩算法的特性来减小图像体积。欲详细了解，请参阅 <a data-l10n-name="bugzilla">Bug 1443863</a>。
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-jxl =
    .label = 媒体：JPEG XL
experimental-features-media-jxl-description = 启用此功能后，{ -brand-short-name } 将支持 JPEG XL（JXL）格式。这是一种增强的图像文件格式，支持从传统 JPEG 文件无损过渡。欲详细了解，请参阅 <a data-l10n-name="bugzilla">Bug 1539075</a>。
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-inputmode =
    .label = Web API: inputmode
# "inputmode" and "contenteditable" are technical terms and shouldn't be translated.
experimental-features-web-api-inputmode-description = 我们已按照 <a data-l10n-name="whatwg">WHATWG</a> 规范，更新了 <a data-l10n-name="mdn-inputmode">inputmode</a> 全局属性的实现。注意，我们仍需进行其他修改，如使其在可编辑内容上可用。欲详细了解，请参阅 <a data-l10n-name="bugzilla">Bug 1205133</a>。
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS：可构造样式表
experimental-features-css-constructable-stylesheets-description = 在 <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a> 接口加入构造函数，以及其他多项相关修改，让您可以直接新建样式表，而无需将其添加到 HTML 中。此特性可让您更容易地创建用于 <a data-l10n-name="mdn-shadowdom">Shadow DOM</a> 的可重用样式表。欲详细了解，请参阅 <a data-l10n-name="bugzilla">Bug 1520690</a>。
experimental-features-devtools-color-scheme-simulation =
    .label = 开发者工具：配色方案模拟
experimental-features-devtools-color-scheme-simulation-description = 添加 <a data-l10n-name="mdn-preferscolorscheme">@prefers color scheme</a> 媒体查询测试选项，模拟不同的配色方案。该特性可让您的样式表根据用户对界面的亮 ∕ 暗偏好作出响应。启用后，无需调整浏览器或操作系统（若浏览器遵循系统级颜色模式）的设置，便可测试代码。欲详细了解，请参阅 <a data-l10n-name="bugzilla1">Bug 1550804</a> 和 <a data-l10n-name="bugzilla2">Bug 1137699</a>。
experimental-features-devtools-execution-context-selector =
    .label = 开发者工具：执行上下文选择器
experimental-features-devtools-execution-context-selector-description = 此特性会在控制台的命令行显示按钮，让您可以切换执行所输入表达式的上下文。欲详细了解，请参阅  <a data-l10n-name="bugzilla1">Bug 1605154</a> 及 <a data-l10n-name="bugzilla2">Bug 1605153</a>。
experimental-features-devtools-compatibility-panel =
    .label = 开发者工具：兼容性面板
experimental-features-devtools-compatibility-panel-description = 在“页面查看器”中加入侧面板，显示应用程序的跨浏览器兼容性状态。欲详细了解，请参阅 <a data-l10n-name="bugzilla">Bug 1584464</a>。
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-lax-by-default2 =
    .label = Cookie: SameSite=Lax［默认］
experimental-features-cookie-samesite-lax-by-default2-description = 若未指定 Cookie 的“SameSite”属性，则将其默认视为“SameSite=Lax”。开发者须明确声明“SameSite=None”，以适应当前滥用的现状。
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-none-requires-secure2 =
    .label = Cookie: SameSite=None［需设置 Secure 属性］
experimental-features-cookie-samesite-none-requires-secure2-description = 属性为“SameSite=None”的 Cookie 需设置 Secure 属性。此特性依赖于“Cookie: SameSite=Lax [默认]”。
# about:home should be kept in English, as it refers to the the URI for
# the internal default home page.
experimental-features-abouthome-startup-cache =
    .label = about:home 启动缓存
experimental-features-abouthome-startup-cache-description = 缓存启动时默认加载的 about:home 初始文件，以提高启动性能。
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-cookie-samesite-schemeful =
    .label = Cookie: SameSite［区分规范］
experimental-features-cookie-samesite-schemeful-description = 将不同规范的的同一域名（如 http://example.com 和 https://example.com）的 Cookie 视为跨站而非同站。此举可提高安全性，但可能会导致某些网站异常。
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support =
    .label = 开发者工具：Service Worker 调试
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support-description = 在“调试器”面板中启用对 Service Worker 的实验性支持。此功能可能会拖慢开发者工具的响应速度，并增加内存消耗。
# WebRTC global mute toggle controls
experimental-features-webrtc-global-mute-toggles =
    .label = WebRTC 全局音视频输入开关
experimental-features-webrtc-global-mute-toggles-description = 添加控件到 WebRTC 全局共享指示器中，让用户可以全局关闭麦克风和摄像头输入。
# Win32k Lockdown
experimental-features-win32k-lockdown =
    .label = Win32k 锁定
experimental-features-win32k-lockdown-description = 在浏览器标签页中禁用 Win32k API。此举可增强安全性，但当前可能不够稳定或易出故障。（仅适用于 Windows）
# JS JIT Warp project
experimental-features-js-warp =
    .label = JavaScript JIT: Warp
experimental-features-js-warp-description = 启用 Warp，此项目旨在改善 JavaScript 性能和内存使用。
# Fission is the name of the feature and should not be translated.
experimental-features-fission =
    .label = Fission（网站隔离）
experimental-features-fission-description = Fission（网站隔离）是 { -brand-short-name } 中的实验特性，可针对安全漏洞提供额外的保护。通过将每个网站隔离到单独的进程中，Fission 能够有效防止恶意网站从您正在访问的其他页面获取信息。这是 { -brand-short-name } 的一项重大架构变更，我们非常欢迎您可以测试并报告任何可能遇到的问题。欲详细了解，请参阅 <a data-l10n-name="wiki">Wiki</a>。
# Support for having multiple Picture-in-Picture windows open simultaneously
experimental-features-multi-pip =
    .label = 画中画支持多开
experimental-features-multi-pip-description = 允许同时打开多个画中画窗口的实验性支持。
experimental-features-http3 =
    .label = HTTP/3 协议
experimental-features-http3-description = 对 HTTP/3 协议的实验性支持。
# Search during IME
experimental-features-ime-search =
    .label = 地址栏：实时显示输入过程中的结果
experimental-features-ime-search-description = 对于东亚及印度语言使用者，要在标准键盘上输入各种文字，输入法是不可或缺的工具。启用此实验后，地址栏面板将在文本输入过程中保持打开状态，并实时显示搜索结果与建议。请注意：某些输入法的面板可能会覆盖地址栏显示的结果，建议在确认所用输入法无上述行为后，开启此首选项。
