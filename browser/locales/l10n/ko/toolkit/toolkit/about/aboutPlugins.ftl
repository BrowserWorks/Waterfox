# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

title-label = 플러그인에 대하여

installed-plugins-label = 설치한 플러그인
no-plugins-are-installed-label = 설치한 플러그인 없음

deprecation-description = 뭔가 빠졌습니까? 어떤 플러그인은 더 이상 지원되지 않습니다. <a data-l10n-name="deprecation-link">더 알아보기.</a>

## The information of plugins
##
## Variables:
##   $pluginLibraries: the plugin library
##   $pluginFullPath: path of the plugin
##   $version: version of the plugin

file-dd = <span data-l10n-name="file">파일:</span> { $pluginLibraries }
path-dd = <span data-l10n-name="path">경로:</span> { $pluginFullPath }
version-dd = <span data-l10n-name="version">버전:</span> { $version }

## These strings describe the state of plugins
##
## Variables:
##   $blockListState: show some special state of the plugin, such as blocked, outdated

state-dd-enabled = <span data-l10n-name="state">상태:</span> 사용
state-dd-enabled-block-list-state = <span data-l10n-name="state">상태:</span> 사용 ({ $blockListState })
state-dd-Disabled = <span data-l10n-name="state">상태:</span> 사용 안 함
state-dd-Disabled-block-list-state = <span data-l10n-name="state">상태:</span> 사용 안 함 ({ $blockListState })

mime-type-label = MIME 타입
description-label = 설명
suffixes-label = 확장자
