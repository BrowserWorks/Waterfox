# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = 關於外掛程式

installed-plugins-label = 已安裝的外掛程式
no-plugins-are-installed-label = 找不到已安裝的外掛程式

deprecation-description = 少了點東西嗎？已不再支援某些外掛程式。<a data-l10n-name="deprecation-link">了解更多。</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">檔案:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">路徑:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">版本:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">狀態:</span> 已啟用
state-dd-enabled-block-list-state = <span data-l10n-name="state">狀態:</span> 已啟用 ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">狀態:</span> 已停用
state-dd-Disabled-block-list-state = <span data-l10n-name="state">狀態:</span> 已停用 ({ $blockListState })

mime-type-label = MIME 型態:
description-label = 描述
suffixes-label = 副檔名

## Gecko Media Plugins (GMPs)

plugins-gmp-license-info = 授權資訊
plugins-gmp-privacy-info = 隱私權資訊

plugins-openh264-name = Cisco Systems, Inc. 提供的 OpenH264 視訊解碼器
plugins-openh264-description = 此外掛程式是由 Waterfox 自動安裝，以符合 WebRTC 規範，並讓您能夠與需要使用 H.264 視訊解碼器的裝置溝通。您可至 http://www.openh264.org/ 取得解碼器的原始碼，並了解此實作的相關資訊。

plugins-widevine-name = Google Inc. 提供的 Widevine 內容解碼模組
plugins-widevine-description = 此外掛程式讓您可播放相容於 Encrypted Media Extensions 規格的加密媒體內容。加密媒體內容通常用於防止複製，或是需收費的媒體內容。可到 https://www.w3.org/TR/encrypted-media/ 取得 Encrypted Media Extensions 的更多資訊。
