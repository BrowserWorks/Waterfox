# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = プラグインについて
installed-plugins-label = インストールされたプラグイン
no-plugins-are-installed-label = インストールされたプラグインが見つかりませんでした
deprecation-description = サポートを終了したプラグインは表示されません。 <a data-l10n-name="deprecation-link">詳細</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">ファイル:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">パス:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">バージョン:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">状態:</span> 有効
state-dd-enabled-block-list-state = <span data-l10n-name="state">状態:</span> 有効 ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">状態:</span> 無効
state-dd-Disabled-block-list-state = <span data-l10n-name="state">状態:</span> 無効 ({ $blockListState })
mime-type-label = MIME タイプ
description-label = ファイルの種類
suffixes-label = 拡張子
