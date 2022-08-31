# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = 关于插件

installed-plugins-label = 已安装的插件
no-plugins-are-installed-label = 找不到已安装的插件

deprecation-description = 少些东西？某些插件已不再支持。 <a data-l10n-name="deprecation-link">详细了解。</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">文件：</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">路径：</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">版本：</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">状态：</span> 启用
state-dd-enabled-block-list-state = <span data-l10n-name="state">状态：</span> 启用 ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">状态：</span> 禁用
state-dd-Disabled-block-list-state = <span data-l10n-name="state">状态：</span> 禁用 ({ $blockListState })

mime-type-label = MIME 类型
description-label = 描述
suffixes-label = 后缀

## Gecko Media Plugins (GMPs)

plugins-gmp-license-info = 许可协议信息
plugins-gmp-privacy-info = 隐私信息

plugins-openh264-name = OpenH264 视频编码器，由思科系统公司提供
plugins-openh264-description = 此插件由 Waterfox 自动安装，以遵从 WebRTC 技术标准，满足设备进行 WebRTC 通话所需要的 H.264 视频编码器。访问 http://www.openh264.org/ 可查看编码器的源代码和详细了解其实现。

plugins-widevine-name = Widevine 内容解密模块，由 Google 公司提供
plugins-widevine-description = 此插件让您可播放符合加密媒体扩展（EME）规范的加密媒体内容。网站通常使用加密媒体内容来防止高质量媒体内容的非法复制。访问 https://www.w3.org/TR/encrypted-media/ 可获取加密媒体扩展（EME）的更多信息。
