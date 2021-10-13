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
