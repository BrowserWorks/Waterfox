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

## Gecko Media Plugins (GMPs)

plugins-gmp-license-info = 라이선스 정보
plugins-gmp-privacy-info = 개인정보 보호정보

plugins-openh264-name = Cisco Systems, Inc.가 제공하는 OpenH264 동영상 코덱
plugins-openh264-description = 이 플러그인은 WebRTC 표준을 따르고 H.264 동영상 코덱을 필요로 하는 기기로 부터의 WebRTC 통신을 활성화하기 위해서 Waterfox에 의해서 설치되었습니다. 코덱 소스 코드와 구현에 대한 내용을 확인하기 위해서는 http://www.openh264.org/ 를 방문하세요.

plugins-widevine-name = Google Inc.가 제공하는 Widevine Content Decryption Module
plugins-widevine-description = 이 플러그인은 암호화된 미디어 확장 명세를 준수하는 암호화된 미디어를 실행할 수 있게 합니다. 암호화된 미디어는 보통 사이트에서 프리미엄 미디어 콘텐츠가 복제되는 것을 보호하기 위해 사용됩니다. 암호화된 미디어 확장에 대한 자세한 내용은 https://www.w3.org/TR/encrypted-media/ 페이지를 참조하세요.
