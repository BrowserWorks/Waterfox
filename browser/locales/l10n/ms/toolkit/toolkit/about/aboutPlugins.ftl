# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = Perihal Plugin

installed-plugins-label = Plugin dipasang
no-plugins-are-installed-label = Tiada plugin terpasang yang ditemui

deprecation-description = Ada sesuatu yang tidak kena? Ada plugin yang tidak lagi disokong. <a data-l10n-name="deprecation-link">Ketahui Selanjutnya.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">Fail:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">Laluan:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">Versi:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">Keadaan:</span> Didayakan
state-dd-enabled-block-list-state = <span data-l10n-name="state">Keadaan:</span> Didayakan ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">Keadaan:</span> Dinyahdayakan
state-dd-Disabled-block-list-state = <span data-l10n-name="state">Keadaan:</span> Dinyahdayakan ({ $blockListState })

mime-type-label = Jenis MIME
description-label = Keterangan
suffixes-label = Akhiran
