# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Headers used in the webextension permissions dialog,
## See https://bug1308309.bmoattachments.org/attachment.cgi?id=8814612
## for an example of the full dialog.
## Note: This string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $extension (String): replaced with the localized name of the extension.

webext-perms-header = 要添加“{ $extension }”吗？
webext-perms-header-with-perms = 要添加“{ $extension }”吗？此扩展将可执行下列操作：
webext-perms-header-unsigned = 要添加“{ $extension }”吗？此扩展未经验证。恶意的扩展可能会窃取您的私密信息或损坏您的计算机。请仅在信任其来源时才安装。
webext-perms-header-unsigned-with-perms = 要添加“{ $extension }”吗？此扩展未经验证。恶意的扩展可能会窃取您的私密信息或损坏您的计算机。请仅在信任其来源时才安装。此扩展将可执行下列操作：
webext-perms-sideload-header = 已添加“{ $extension }”
webext-perms-optional-perms-header = “{ $extension }”需要额外权限。

##

webext-perms-add =
    .label = 添加
    .accesskey = A
webext-perms-cancel =
    .label = 取消
    .accesskey = C
webext-perms-sideload-text = 您的计算机上的某个程序安装了可能会影响您的浏览器的附加组件。请检查此附件组件所要求的权限，然后选择启用或者取消（保持禁用状态）。
webext-perms-sideload-text-no-perms = 您的计算机上的某个程序安装了可能会影响您的浏览器的附加组件。请选择启用或者取消（保持禁用状态）。
webext-perms-sideload-enable =
    .label = 启用
    .accesskey = E
webext-perms-sideload-cancel =
    .label = 取消
    .accesskey = C
# Variables:
#   $extension (String): replaced with the localized name of the extension.
webext-perms-update-text = “{ $extension }”已有更新。您必须接受新版本中的新权限才能安装更新。也可选择“取消”保持目前使用的版本。此扩展将可执行下列操作：
webext-perms-update-accept =
    .label = 更新
    .accesskey = U
webext-perms-optional-perms-list-intro = 它想要：
webext-perms-optional-perms-allow =
    .label = 允许
    .accesskey = A
webext-perms-optional-perms-deny =
    .label = 拒绝
    .accesskey = D
webext-perms-host-description-all-urls = 存取您在所有网站的数据
# Variables:
#   $domain (String): will be replaced by the DNS domain for which a webextension is requesting access (e.g., mozilla.org)
webext-perms-host-description-wildcard = 存取您在 { $domain } 域名的数据
# Variables:
#   $domainCount (Number): Integer indicating the number of additional
#     hosts for which this webextension is requesting permission.
webext-perms-host-description-too-many-wildcards = 存取您用于其他 { $domainCount } 个域名的数据
# Variables:
#   $domain (String): will be replaced by the DNS host name for which a webextension is requesting access (e.g., www.mozilla.org)
webext-perms-host-description-one-site = 存取您在 { $domain } 的数据
# Variables:
#   $domainCount (Number): Integer indicating the number of additional
#     hosts for which this webextension is requesting permission.
webext-perms-host-description-too-many-sites = 存取您用于其他 { $domainCount } 个网站的数据

## Headers used in the webextension permissions dialog for synthetic add-ons.
## The part of the string describing what privileges the extension gives should be consistent
## with the value of webext-site-perms-description-gated-perms-{sitePermission}.
## Note, this string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $hostname (String): the hostname of the site the add-on is being installed from.

webext-site-perms-header-with-gated-perms-midi = 此附加组件会准许 { $hostname } 访问您的 MIDI 设备。
webext-site-perms-header-with-gated-perms-midi-sysex = 此附加组件会准许 { $hostname } 访问您的 MIDI 设备（支持 SysEx）。

##

# This string is used as description in the webextension permissions dialog for synthetic add-ons.
# Note, the empty line is used to create a line break between the two sections.
# Note, this string will be used as raw markup. Avoid characters like <, >, &
webext-site-perms-description-gated-perms-midi =
    这些通常是音频合成器等插拔设备，但也可能内置于您的计算机中。
    
    通常网站不被允许访问 MIDI 设备。使用不当可能会造成损坏或危及信息安全。

## Headers used in the webextension permissions dialog.
## Note: This string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $extension (String): replaced with the localized name of the extension being installed.
##   $hostname (String): will be replaced by the DNS host name for which a webextension enables permissions.

webext-site-perms-header-with-perms = 要安装“{ $extension }”吗？此扩展将授予 { $hostname } 以下功能：
webext-site-perms-header-unsigned-with-perms = 要安装“{ $extension }”吗？此扩展未经验证。恶意的扩展可能会窃取您的私密信息或损坏您的计算机。请仅在信任其来源时才安装。此扩展将授予 { $hostname } 以下功能：

## These should remain in sync with permissions.NAME.label in sitePermissions.properties

webext-site-perms-midi = 访问 MIDI 设备
webext-site-perms-midi-sysex = 访问支持 SysEx 的 MIDI 设备
