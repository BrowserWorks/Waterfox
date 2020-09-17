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
experimental-features-web-api-inputmode =
    .label = Web API: inputmode
# "inputmode" and "contenteditable" are technical terms and shouldn't be translated.
experimental-features-web-api-inputmode-description = 我们已按照 <a data-l10n-name="whatwg">WHATWG</a> 规范，更新了 <a data-l10n-name="mdn-inputmode">inputmode</a> 全局属性的实现。注意，我们仍需进行其他修改，如使其在可编辑内容上可用。欲详细了解，请参阅 <a data-l10n-name="bugzilla">Bug 1205133</a>。

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-link-preload =
    .label = Web API: <link rel="preload">
# Do not translate "rel", "preload" or "link" here, as they are all HTML spec
# values that do not get translated.
experimental-features-web-api-link-preload-description = <a data-l10n-name="link">&lt;link&gt;</a> 元素的 <a data-l10n-name="rel">rel</a> 属性值<code>“preload”</code>，使得资源能够在页面生命周期中更早的进行加载并可用，以此提高性能，且更不易阻塞页面的渲染。欲详细了解，请参阅<a data-l10n-name="readmore">“Preloading content with <code>rel="preload"</code>”</a> 或 <a data-l10n-name="bugzilla">Bug 1583604</a>。

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-focus-visible =
    .label = CSS：:focus-visible 伪类
experimental-features-css-focus-visible-description = 仅在使用键盘聚焦于按钮和表单控件等元素（例如：使用 Tab 键切换）时，允许聚焦样式生效。鼠标或其他指针设备则禁止。欲详细了解，请参阅 <a data-l10n-name="bugzilla">Bug 1617600</a>。

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-beforeinput =
    .label = Web API: beforeinput Event
# The terms "beforeinput", "input", "textarea", and "contenteditable" are technical terms
# and shouldn't be translated.
experimental-features-web-api-beforeinput-description = 在 <a data-l10n-name="mdn-input">&lt;input&gt;</a>、<a data-l10n-name="mdn-textarea">&lt;textarea&gt;</a>，以及任何启用 <a data-l10n-name="mdn-contenteditable">contenteditable</a> 属性的元素的值变更前，会触发全局的的 <a data-l10n-name="mdn-beforeinput">beforeinput</a> 事件。此事件可让 Web 应用程序覆盖浏览器的默认用户交互行为（例如：应用程序可阻止用户输入某些特殊字符，或只允许以特定的样式修改粘贴的文本）。

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS：可构造样式表
experimental-features-css-constructable-stylesheets-description = 在 <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a> 接口加入构造函数，以及其他多项相关修改，让您可以直接新建样式表，而无需将其添加到 HTML 中。此特性可让您更容易地创建用于 <a data-l10n-name="mdn-shadowdom">Shadow DOM</a> 的可重用样式表。欲详细了解，请参阅 <a data-l10n-name="bugzilla">Bug 1520690</a>。

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-session-api =
    .label = Web API: Media Session API
experimental-features-media-session-api-description = { -brand-short-name } 对于 Media Session API 的整个实现目前尚处于实验阶段。此 API 用于自定义媒体相关通知的处理方式、管理用于呈现用户播放界面的事件与数据、以及获取媒体文件的元数据。欲详细了解，请参阅 <a data-l10n-name="bugzilla">Bug 1112032</a>。

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

experimental-features-print-preview-tab-modal =
    .label = 打印预览改版
experimental-features-print-preview-tab-modal-description = 引入了重新设计的打印预览功能，并使其在 macOS 上也可用。该实验项可能不够稳定，且尚未包含完整的打印选项。若有后者需求，请点击打印面板中的“使用系统对话框打印...”。

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

# Desktop zooming experiment
experimental-features-graphics-desktop-zooming =
    .label = 图形：平滑手势缩放
experimental-features-graphics-desktop-zooming-description = 启用对触摸屏和精密触控板上平滑手势缩放的支持。
