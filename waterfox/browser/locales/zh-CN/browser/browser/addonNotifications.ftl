# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

xpinstall-prompt = { -brand-short-name } 已阻止此网站在您的计算机上安装软件的请求。

## Variables:
##   $host (String): The hostname of the site the add-on is being installed from.

xpinstall-prompt-header = 允许 { $host } 安装附加组件？
xpinstall-prompt-message = 您正尝试从 { $host } 安装附加组件。继续之前请确保您信任此站点。

##

xpinstall-prompt-header-unknown = 允许未知站点安装附加组件？
xpinstall-prompt-message-unknown = 您正尝试从未知站点安装附加组件。继续之前请确保您信任此站点。
xpinstall-prompt-dont-allow =
    .label = 不允许
    .accesskey = D
xpinstall-prompt-never-allow =
    .label = 永不允许
    .accesskey = N
# Long text in this context make the dropdown menu extend awkwardly to the left,
# avoid a localization that's significantly longer than the English version.
xpinstall-prompt-never-allow-and-report =
    .label = 报告可疑网站
    .accesskey = R
# Accessibility Note:
# Be sure you do not choose an accesskey that is used elsewhere in the active context (e.g. main menu bar, submenu of the warning popup button)
# See https://website-archive.mozilla.org/www.mozilla.org/access/access/keyboard/ for details
xpinstall-prompt-install =
    .label = 继续安装
    .accesskey = C

# These messages are shown when a website invokes navigator.requestMIDIAccess.

site-permission-install-first-prompt-midi-header = 此网站请求访问您的 MIDI（乐器数字接口）设备，安装附加组件后可实现访问。
site-permission-install-first-prompt-midi-message = 此访问不一定安全，请仅在您信任此网站时才继续。

##

xpinstall-disabled-locked = 软件安装已被您的系统管理员禁用。
xpinstall-disabled = 软件安装已被禁用。请单击“启用”并重试。
xpinstall-disabled-button =
    .label = 启用
    .accesskey = n
# This message is shown when the installation of an add-on is blocked by enterprise policy.
# Variables:
#   $addonName (String): the name of the add-on.
#   $addonId (String): the ID of add-on.
addon-install-blocked-by-policy = { $addonName }（{ $addonId }）已被系统管理员禁用。
# This message is shown when the installation of add-ons from a domain is blocked by enterprise policy.
addon-domain-blocked-by-policy = 您的系统管理员已阻止此网站在您的计算机上安装软件的请求。
addon-install-full-screen-blocked = 进入全屏模式前或进入时，不允许安装附加组件。
# Variables:
#   $addonName (String): the localized name of the sideloaded add-on.
webext-perms-sideload-menu-item = “{ $addonName }”已添加到 { -brand-short-name }
# Variables:
#   $addonName (String): the localized name of the extension which has been updated.
webext-perms-update-menu-item = “{ $addonName }”需要新的权限
# This message is shown when one or more extensions have been imported from a
# different browser into Waterfox, and the user needs to complete the import to
# start these extensions. This message is shown in the appmenu.
webext-imported-addons = 正在完成安装已导入 { -brand-short-name } 的扩展

## Add-on removal warning

# Variables:
#  $name (String): The name of the add-on that will be removed.
addon-removal-title = 要移除 { $name } 吗？
# Variables:
#   $name (String): the name of the extension which is about to be removed.
addon-removal-message = 移除 { -brand-shorter-name } 中的 { $name } 吗？
addon-removal-button = 移除
addon-removal-abuse-report-checkbox = 向 { -vendor-short-name } 举报此扩展
# Variables:
#   $addonCount (Number): the number of add-ons being downloaded
addon-downloading-and-verifying = 正在下载并验证 { $addonCount } 个附加组件…
addon-download-verifying = 正在验证
addon-install-cancel-button =
    .label = 取消
    .accesskey = C
addon-install-accept-button =
    .label = 添加
    .accesskey = A

## Variables:
##   $addonCount (Number): the number of add-ons being installed

addon-confirm-install-message = 此网站想安装 { $addonCount } 个附加组件到 { -brand-short-name }：
addon-confirm-install-unsigned-message = 注意：此网站想在 { -brand-short-name } 中安装 { $addonCount } 个未通过验证的附加组件。请谨慎决定。
# Variables:
#   $addonCount (Number): the number of add-ons being installed (at least 2)
addon-confirm-install-some-unsigned-message = 注意：此网站想在 { -brand-short-name } 中安装 { $addonCount } 个附加组件，其中一些未通过验证。请谨慎决定。

## Add-on install errors
## Variables:
##   $addonName (String): the add-on name.

addon-install-error-network-failure = 此附加组件未能下载，因为连接失败。
addon-install-error-incorrect-hash = 所下载的不是本要安装附加组件 { -brand-short-name }，无法安装。
addon-install-error-corrupt-file = 从此网站下载的这个附加组件文件损坏了，无法安装。
addon-install-error-file-access = “{ $addonName }”未能安装，因为 { -brand-short-name } 无法修改所需的文件。
addon-install-error-not-signed = { -brand-short-name } 已阻止此网站安装未通过验证的附加组件。
addon-install-error-invalid-domain = 无法从此位置安装附加组件“{ $addonName }”。
addon-local-install-error-network-failure = 因为文件系统错误，无法安装该附加组件。
addon-local-install-error-incorrect-hash = 所下载的不是本要安装附加组件 { -brand-short-name }，无法安装。
addon-local-install-error-corrupt-file = 该附加组件无法安装，因为它似乎已损坏。
addon-local-install-error-file-access = “{ $addonName }”未能安装，因为 { -brand-short-name } 无法修改所需的文件。
addon-local-install-error-not-signed = 此附加组件无法安装，因为它未通过验证。
# Variables:
#   $appVersion (String): the application version.
addon-install-error-incompatible = “{ $addonName }”未能安装，因为它与 { -brand-short-name } { $appVersion } 不兼容。
addon-install-error-blocklisted = “{ $addonName }”未能安装，因为它很可能引发稳定性或安全性问题。
