# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The Enterprise Policies feature is aimed at system administrators
## who want to deploy these settings across several Firefox installations
## all at once. This is traditionally done through the Windows Group Policy
## feature, but the system also supports other forms of deployment.
## These are short descriptions for individual policies, to be displayed
## in the documentation section in about:policies.

policy-3rdparty = 设置 WebExtension 可通过 chrome.storage.managed 存取的策略。
policy-AllowedDomainsForApps = 定义允许访问 Google Workspace 的域。
policy-AppAutoUpdate = 启用或禁用应用程序自动更新。
policy-AppUpdateURL = 设置自定义的应用程序更新网址。
policy-Authentication = 为支持的网站配置集成身份验证。
policy-AutoLaunchProtocolsFromOrigins = 定义一组外部协议列表，可不提示用户直接从列出的来源使用。
policy-BackgroundAppUpdate2 = 启用或禁用后台更新程序。
policy-BlockAboutAddons = 阻止访问附加组件管理器（about:addons）。
policy-BlockAboutConfig = 阻止访问 about:config 页面。
policy-BlockAboutProfiles = 阻止访问 about:profiles 页面。
policy-BlockAboutSupport = 阻止访问 about:support 页面。
policy-Bookmarks = 在书签工具栏，书签菜单或特定文件夹中创建书签。
policy-CaptivePortal = 启用或禁用强制门户支持。
policy-CertificatesDescription = 添加证书或使用内置的证书。
policy-Cookies = 允许或拒绝网站设置 Cookie。
policy-DisabledCiphers = 禁用加密算法。
policy-DefaultDownloadDirectory = 设置默认下载目录。
policy-DisableAppUpdate = 阻止浏览器更新。
policy-DisableBuiltinPDFViewer = 禁用 { -brand-short-name } 内置的 PDF 阅读器 PDF.js。
policy-DisableDefaultBrowserAgent = 阻止默认浏览器用户代理执行任何操作。仅适用于 Windows，其他平台没有用户代理可用。
policy-DisableDeveloperTools = 阻止访问开发者工具。
policy-DisableFeedbackCommands = 禁用“帮助”菜单中的“发送反馈”命令（提交反馈和举报诈骗网站）。
policy-DisableFirefoxAccounts = 禁用 { -fxaccount-brand-name }的基础服务，包含同步。
# Firefox Screenshots is the name of the feature, and should not be translated.
policy-DisableFirefoxScreenshots = 禁用 Firefox 的“截图”功能。
policy-DisableFirefoxStudies = 阻止 { -brand-short-name } 运行研究实验。
policy-DisableForgetButton = 阻止使用“忘记”功能。
policy-DisableFormHistory = 不要记住搜索和表单的历史记录。
policy-DisableMasterPasswordCreation = 若为 true，将无法创建主密码。
policy-DisablePrimaryPasswordCreation = 若为 true，将无法创建主密码。
policy-DisablePasswordReveal = 阻止密码在列表中明文显示
policy-DisablePocket = 禁用保存网页到 Pocket 的功能。
policy-DisablePrivateBrowsing = 禁用隐私浏览功能。
policy-DisableProfileImport = 禁用自其他浏览器导入数据的菜单命令。
policy-DisableProfileRefresh = 禁用 about:support 页面中的“翻新 { -brand-short-name }”按钮。
policy-DisableSafeMode = 禁用以安全模式重启浏览器的功能。注意：仅可在 Windows 上使用组策略禁用按住 Shift 键进入安全模式。
policy-DisableSecurityBypass = 阻止用户绕过某些安全性警告。
policy-DisableSetAsDesktopBackground = 禁用将图像“设为桌面背景”的菜单命令。
policy-DisableSystemAddonUpdate = 阻止浏览器安装或更新“系统附加组件”。
policy-DisableTelemetry = 关闭“遥测”组件。
policy-DisplayBookmarksToolbar = 默认显示书签工具栏。
policy-DisplayMenuBar = 默认显示菜单栏。
policy-DNSOverHTTPS = 配置基于 HTTPS 的 DNS。
policy-DontCheckDefaultBrowser = 禁用启动时的默认浏览器检查。
policy-DownloadDirectory = 设置并锁定下载目录。
# “lock” means that the user won’t be able to change this setting
policy-EnableTrackingProtection = 启用或禁用内容拦截，并可选择锁定该功能。
# “lock” means that the user won’t be able to change this setting
policy-EncryptedMediaExtensions = 启用或禁用“加密媒体扩展（EME）”，并可选择锁定该功能。
# A “locked” extension can’t be disabled or removed by the user. This policy
# takes 3 keys (“Install”, ”Uninstall”, ”Locked”), you can either keep them in
# English or translate them as verbs.
policy-Extensions = 安装，移除或锁定扩展。安装选项可将网址或路径作为参数。移除和锁定选项则需要扩展 ID 作为参数。
policy-ExtensionSettings = 管理扩展的各种安装设置。
policy-ExtensionUpdate = 启用或禁用扩展自动更新。
policy-FirefoxHome = 配置 Firefox 主页。
policy-FlashPlugin = 允许或拒绝使用 Flash 插件。
policy-Handlers = 配置默认应用程序处理方式。
policy-HardwareAcceleration = 若为 false，将会关闭硬件加速。
# “lock” means that the user won’t be able to change this setting
policy-Homepage = 设置主页，可选择锁定。
policy-InstallAddonsPermission = 允许特定网站安装附加组件。
policy-LegacyProfiles = 禁用要求每个安装实例有不同用户配置文件的功能

## Do not translate "SameSite", it's the name of a cookie attribute.

policy-LegacySameSiteCookieBehaviorEnabled = 启用默认旧有 SameSite cookie 行为设置。
policy-LegacySameSiteCookieBehaviorEnabledForDomainList = 对指定的网站恢复旧有 SameSite cookie 行为。

##

policy-LocalFileLinks = 允许特定网站链接到本地文件。
policy-ManagedBookmarks = 配置由管理员控制的书签列表，用户无法更改。
policy-MasterPassword = 要求或禁止使用主密码。
policy-ManualAppUpdateOnly = 只允许手动更新，并且不通知用户有可用更新。
policy-PrimaryPassword = 要求或禁止使用主密码。
policy-NetworkPrediction = 启用或禁用网络预测（DNS 预读取）功能。
policy-NewTabPage = 启用或禁用“新标签页”页面。
policy-NoDefaultBookmarks = 禁止创建 { -brand-short-name } 捆绑的默认书签以及智能书签（最常访问、最近使用的标签）。注意：此策略仅在配置文件首次运行时生效。
policy-OfferToSaveLogins = 强制启用或禁用 { -brand-short-name } 的登录账号与密码保存功能。接受 true 或 false。
policy-OfferToSaveLoginsDefault = 允许 { -brand-short-name } 提供登录账号与密码保存功能。接受 true 或 false。
policy-OverrideFirstRunPage = 覆盖首次运行页面。如果您想禁用首次运行页面，将此策略设为空白。
policy-OverridePostUpdatePage = 覆盖更新后的“新版变化”页面。如果您想禁用更新后页面，将此策略设为空白。
policy-PasswordManagerEnabled = 启用密码管理器的密码保存功能。
# PDF.js and PDF should not be translated
policy-PDFjs = 禁用或配置 { -brand-short-name } 内置的 PDF 阅读器 PDF.js。
policy-Permissions2 = 配置摄像头、麦克风、位置、通知和自动播放的权限。
policy-PictureInPicture = 启用或禁用画中画。
policy-PopupBlocking = 默认允许特定网站显示弹出式窗口。
policy-Preferences = 设置并锁定若干首选项的值。
policy-PromptForDownloadLocation = 下载前询问文件保存位置。
policy-Proxy = 配置代理设置
policy-RequestedLocales = 设置应用程序表明语言区域偏好的语言区域请求列表。
policy-SanitizeOnShutdown2 = 关机时，清除上网数据。
policy-SearchBar = 设置搜索栏的默认位置，用户仍可自定义。
policy-SearchEngines = 配置搜索引擎设置。此策略仅适用于延长支持版（ESR）。
policy-SearchSuggestEnabled = 启用或禁用搜索建议。
# For more information, see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/PKCS11/Module_Installation
policy-SecurityDevices = 安装 PKCS #11 模块。
policy-ShowHomeButton = 在工具栏显示“主页”按钮
policy-SSLVersionMax = 设置最高 SSL 版本。
policy-SSLVersionMin = 设置最低 SSL 版本。
policy-SupportMenu = 向帮助菜单自选添加技术支持项目。
policy-UserMessaging = 不向用户显示某些消息。
# “format” refers to the format used for the value of this policy.
policy-WebsiteFilter = 阻止访问某些网站。参阅文档了解该格式的更多详情。
policy-Windows10SSO = 允许 Microsoft、工作和学校账户的 Windows 单点登录。
